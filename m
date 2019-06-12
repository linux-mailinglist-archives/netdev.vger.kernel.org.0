Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45780448AD
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393465AbfFMRKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:10:31 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:40276 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbfFLWqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 18:46:42 -0400
Received: by mail-qt1-f174.google.com with SMTP id a15so20371713qtn.7
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 15:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AvEz80RndZML7i5e7xLWFJaU/oBcGksUZL3ZVAZz/vc=;
        b=yeN126dH080F5WJlpPkx/gVbgWfPMDnzZs19djMIpFWkQAaC6GGGjs3s9hsd6JKraY
         +QJ4pGRl91F1byjRjEOILr+u2loTuriMZty4iV0M0L7Q7Xav0PB3xkp+8EpcypvWWcMP
         zzJUwEPKDtJgWrWxR/R1ZDG5tzqLYY/cPoOn6XlPU1ROe48CiMkre6f09aEIh3/jOW44
         yPgRQnWmNglH8zGM58ZL7Fq3YKJmE48oQCimuABrRuIIyufEav+Bjt8k+p7wzQrZBEVk
         cYzjSSpm3gM5RpipcK0Wzggy58E2yU21E4WcKWjdmDAg1R4VtJEEe6cyPxp6rxNWy4Sn
         IDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AvEz80RndZML7i5e7xLWFJaU/oBcGksUZL3ZVAZz/vc=;
        b=Kt22MtqFRJsRxpUxnqQFCKxo86AsxWhyO/nXyvVFE1Y3bHOKB6JbZWxb9+ajrBCsBd
         2C0uHRa0KP+imNslxTB5MI79QvT/u4LbssTwt35dZX0t269j0LzE7CG1p6ud4hcCmBqL
         JpWufenRZXlwagXk2WgV5raYcP0k2g5j0uCxVbbui8o+2tZnUkOxtc3FzetNIJfeWEwO
         0MZikDD/8+8DJd48rOVaUJkf/ITncqQ7Jgqudv3YWMGaisq5SOAi9NQYyxRo7dvZpySw
         7jHIch1RTc5AMKyu+wPS776jC3tnVCsWdBYbuIeZH7Pcyd000B5DLZZqTPwqhUbW/44b
         KhFg==
X-Gm-Message-State: APjAAAUxmMYtFkezOTYhnjUMQzbFLu2MxltlLewQiQr+nILqq8qhPIXd
        aDopNweJa1c41lAmIIGq3FsjxA==
X-Google-Smtp-Source: APXvYqw2t3mcxgOlSDwDLTX5e/42JMuOR5iBZr++4VWJwoI79YpIf7fWltBgwDZgdOieGa/+ml1jQA==
X-Received: by 2002:a0c:8927:: with SMTP id 36mr823821qvp.131.1560379601808;
        Wed, 12 Jun 2019 15:46:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 34sm691604qtq.59.2019.06.12.15.46.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 15:46:41 -0700 (PDT)
Date:   Wed, 12 Jun 2019 15:46:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xue Chaojing <xuechaojing@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoshaokai@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: Re: [PATCH net-next v2 1/2] hinic: add rss support
Message-ID: <20190612154637.2ad4d882@cakuba.netronome.com>
In-Reply-To: <20190611181234.4843-2-xuechaojing@huawei.com>
References: <20190611181234.4843-1-xuechaojing@huawei.com>
        <20190611181234.4843-2-xuechaojing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 18:12:33 +0000, Xue Chaojing wrote:
> +	for (i = 0; i < HINIC_RSS_INDIR_SIZE; i++)
> +		indir_tbl[i] = (i / HINIC_RSS_INDIR_SIZE) * nic_dev->num_rss +
> +				i % nic_dev->num_rss;

This looks suspicious:

	i is in range [0, HINIC_RSS_INDIR_SIZE)
	so i / HINIC_RSS_INDIR_SIZE is always 0

For the rest please use ethtool_rxfh_indir_default()
