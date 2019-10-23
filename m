Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C19E202E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407047AbfJWQIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:08:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42859 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407029AbfJWQIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:08:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so12949009wrs.9
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xEaDXgOE6sYFAsB9XwC/0WxNTPAbA1fNs/xQf1xTUx8=;
        b=SWxuqDAoMvYaV3vjkNJnG4s45Q4y/N248IjvUkQr9aKFTw8vhVem9KrCir41KtcCqq
         YG335orsAFCEcfRtjm1Kuk6VAf+rlO0hP5S5aE5TGwOFL/1YqkCYOwIrWvxTnnsQNLBn
         MIB0U80JOqUBdEc1HcF0xSzVMaDJD+3y7ZKycu+p8imlFUYlR+VuV1b0b8Gd2hUiLJAp
         XzezpL7MXNlLtlwYnJxOHzxtq9kCH4X5l1q5vzz7y42/nrLKCl4CKJkDqkbz3qI0zalT
         ScStAYaXu53ksy+Il6rW9LiLMVi40+ZjMabN6CCH+FtmG3q+bIkSM+kgm9nQViR4p5Fz
         PQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xEaDXgOE6sYFAsB9XwC/0WxNTPAbA1fNs/xQf1xTUx8=;
        b=t1tr5PqXewz90nIpJCcuHbVAAqQxa8vmZXgHhRI03ARTJ2gV27e49BgktJN4sZ4kyp
         VI4H56qkDdh3bes0PtL02c+WoZkbgALRy8uEt61kFQoiXb8Hc8m3kpn5cZ/CvBkb/rkB
         eHkPmtqsA+t09rhKEEdCPJjfRTOehiOBkcfOhk9Jnel24O53R/LedGB95kFzzNOCDpb1
         ePfKO/mzeG2DspN00UC8/ew+ZHGON+ftfLH3gEiDV0D5bQmhoHOP8kGw6lDtzhi61csW
         iMRzmD5DNp7fO2yoqprrkcyowxp/OUcbgd8ZR43uHZv+3Z4hrtrPp6WIu88L7zequ629
         66jg==
X-Gm-Message-State: APjAAAUZ9D1by3ERGMFc4BwA21zglw5hi20tNSbuuD0MTcUV23MlUNc0
        QRYPk/ENr4Ynz3Vf0/ZSpQRf4Q==
X-Google-Smtp-Source: APXvYqx4Ws7YNXWsU2o/Q2QBtpEvxT1V76cKuM6JC5+TVkH8GqRJMB+PVQB1k12z+hRf/cg5IAeLuA==
X-Received: by 2002:a5d:4d85:: with SMTP id b5mr1002251wru.248.1571846917859;
        Wed, 23 Oct 2019 09:08:37 -0700 (PDT)
Received: from localhost (podhomap5b.chobex.cz. [85.163.40.99])
        by smtp.gmail.com with ESMTPSA id a2sm9212357wrv.39.2019.10.23.09.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 09:08:37 -0700 (PDT)
Date:   Wed, 23 Oct 2019 18:08:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v4 1/3] lib/ll_map: cache alternative names
Message-ID: <20191023160833.GA2606@nanopsycho>
References: <20191019173749.19068-1-jiri@resnulli.us>
 <20191019173749.19068-2-jiri@resnulli.us>
 <0aa53f9c-b038-ff66-6e0e-65fe3bd3ee64@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0aa53f9c-b038-ff66-6e0e-65fe3bd3ee64@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 23, 2019 at 05:11:38PM CEST, dsahern@gmail.com wrote:
>On 10/19/19 11:37 AM, Jiri Pirko wrote:
>> +static void ll_altname_entries_destroy(struct ll_cache *parent_im)
>> +{
>> +	struct ll_cache *im;
>> +
>> +	list_for_each_entry(im, &parent_im->altnames_list, altnames_list)
>> +		ll_entry_destroy(im, false);
>
>you are walking a list and removing elements from it, so that should be
>list_for_each_entry_safe, no?
>

You are correct. Will fix and send v5.
