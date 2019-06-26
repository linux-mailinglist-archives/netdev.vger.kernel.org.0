Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED656F44
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 19:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfFZREq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 13:04:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38413 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfFZREq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 13:04:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id z75so1500802pgz.5
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 10:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PyE9v8MWJu0XM6vOTo0/JX2feaxhQn1rXusmhBKwqtI=;
        b=nNEYNauebtfxT/mYzBaAe1xgS1Rtr+h04eowFpX8YulqprrH+HxAhtUfDaVhSYboU6
         mPMr4KOjo3A/FiTomQbHr4ILbn3u6+NIxrGJFA70ZFXhA8Ehc5VC3MAEaQlWV4aq0vYJ
         DulRWkoOR0VNDbgGnMP+gQkySA/jx/q0QVNHSQ8/soTIZW9Iszm1PSgH2FLetW4zfGns
         ccLNXQv9n0OGpXTROKD8dxhwkl2sE6KdatXOqoXa/1gljOiKiyg3IEKDkC8tBUfIi7z0
         juXtbVQidRJm/rHCOrFZrBlE0n50U8CkYsBsadzYPVeea8QC0PjERah18G8faZpv/hFh
         ygDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PyE9v8MWJu0XM6vOTo0/JX2feaxhQn1rXusmhBKwqtI=;
        b=au0BEZzp3AqeMIiEJmubg3tJs91WfYAvk+so4dfDIoesQoeivATxE7HC+9Ha6KI3mw
         VrlTjVi5WQ8IpvvEwpyiidB7P4iElMBgmm6XkY+WNuCoKvAvhA/4NOI3i9/jJwy2K4zx
         EEwrFuEMELammDMD+6rHBwGS643VqEa+ct1xqPAtMbg9BvNU7KTVQu23JF2uW2twZbix
         BwLkW8wuoZf3eFaerhCizV1Cl9BHqrMt4ZEskkprGyIHHlaZS190uC2u0A2uhFboME2+
         9ooPj/IO9f/2vyBDell8vt8LRU6hLPiVQRRfKd9uvWNzccu1Xf+K0x7M430oLbiQEwiJ
         X6Nw==
X-Gm-Message-State: APjAAAXPgdKJRGxsZFV+QwDgtP4JP4qeagNkmkCMr/4LgaK10apYNK2V
        8ferrSi8E75AviGg1HJkdvQn6E4mc7g=
X-Google-Smtp-Source: APXvYqwOgpUZr8IfN10h5uvqBPE5knwZNi20+ko4x0IWTAeZAxoXiS50xAetl++HqUhZPi6T6sRC0w==
X-Received: by 2002:a63:3d8d:: with SMTP id k135mr4043059pga.23.1561568685187;
        Wed, 26 Jun 2019 10:04:45 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 1sm19301831pfe.102.2019.06.26.10.04.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 10:04:44 -0700 (PDT)
Subject: Re: [PATCH net-next 17/18] ionic: Add RSS support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-18-snelson@pensando.io>
 <20190625172054.6a9d22dc@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <27de51bd-67e5-f3f3-ea42-eac54262ee5f@pensando.io>
Date:   Wed, 26 Jun 2019 10:04:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625172054.6a9d22dc@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 5:20 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:23 -0700, Shannon Nelson wrote:
>> +static int ionic_lif_rss_init(struct lif *lif)
>> +{
>> +	static const u8 toeplitz_symmetric_key[] = {
>> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
>> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
>> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
>> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
>> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
>> +	};
> netdev_rss_key_fill()

Sure.

>
>> +	unsigned int i, tbl_sz;
>> +
>> +	lif->rss_types = IONIC_RSS_TYPE_IPV4     |
>> +			 IONIC_RSS_TYPE_IPV4_TCP |
>> +			 IONIC_RSS_TYPE_IPV4_UDP |
>> +			 IONIC_RSS_TYPE_IPV6     |
>> +			 IONIC_RSS_TYPE_IPV6_TCP |
>> +			 IONIC_RSS_TYPE_IPV6_UDP;
>> +
>> +	/* Fill indirection table with 'default' values */
>> +	tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
>> +	for (i = 0; i < tbl_sz; i++)
>> +		lif->rss_ind_tbl[i] = i % lif->nxqs;
> ethtool_rxfh_indir_default()

Sure

>
>> +	return ionic_lif_rss_config(lif, lif->rss_types,
>> +				    toeplitz_symmetric_key, NULL);
>> +}

Thanks for your time, I appreciate the review.

sln

