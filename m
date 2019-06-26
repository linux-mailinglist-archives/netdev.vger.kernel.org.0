Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A5A56DE6
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfFZPlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:41:22 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36158 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfFZPlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:41:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so1569866pfl.3
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=s6H+VZIH/8+SpPDS4HKLkLbhIbCgFU2Lx0ZhiuvLd+4=;
        b=oC1zhlpqGlEqeHayr8LquWx2FE2w+bw3+jEPmcq8U1AGO1m99K/8S5ZQ24b+gOy1ov
         1Pja1omxE8YCR/AeqUOJJrjq7usDaRrI9mxPgUN3eXq2e+LvvmhfkLdkRQAcBnyXdpIj
         8Ny4iSwKWVtdurBzuFvVGhPP3jBvs/b0M8/NFbCnlqCb3aihO6u469b/+XX1Mel7Ovd7
         dlRQLR6iHa/yytjTMByzXNL/dCZLsqFf/yZEyzYMEmVGMKDvEOk83jo+di6qJ8RG3pBE
         fZpp92D+l+UvfDyOjQf3CTvqTF4iZKL41QXBK5jEvAuI16th+cMR7044AGKgUaXFL4Hk
         Y4oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=s6H+VZIH/8+SpPDS4HKLkLbhIbCgFU2Lx0ZhiuvLd+4=;
        b=J8nhdhYdwSFfVqHBtM539Fx8prmv2NdXfnhXVcC3CSlYjrAwotwixLp4hcOs6Tf4gu
         AORr+l1wLjbD8ilqTH010YZc/0C1jisitpg4D+g8tp5xaM4ZTnfNZSCbUY/6UCQAGcwf
         oBgsIybuYoYiImmnUorE3VqLC6uc16jabYezJh0HBOXwZzQ0xjvY2kSWNzZAoJ3X13Fl
         T+z5nxe8PmFBmN6J6VC3qoMb+PcWoHtAvAhEQaUBl7+0d2BqeYImCyB3+8iH1FgR15wE
         EcK2aPTwClMukxxB+9aVda5cAXNSF6jXosBbafzEh9xLI37l4yHXEZvpB3jlcauTk1NF
         Njrw==
X-Gm-Message-State: APjAAAWA3htZ6fD78oJ7qqw7qkyYH/cLZdXCwixSu2rTlAm/K9pZ4Uzg
        F8xgqI2N2DycwVnwdnsq3y37HeO5CRI=
X-Google-Smtp-Source: APXvYqwDXZVaOlJA3M2MmqLB1YVoRxES+hEi0kWMDjh+TZapEVqaJuIqrYHiALDW5kKfpy/6EeMXuA==
X-Received: by 2002:a17:90a:de02:: with SMTP id m2mr5525727pjv.18.1561563680790;
        Wed, 26 Jun 2019 08:41:20 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id a3sm21728489pfo.49.2019.06.26.08.41.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 08:41:20 -0700 (PDT)
Subject: Re: [PATCH net-next 09/18] ionic: Add the basic NDO callbacks for
 netdev support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-10-snelson@pensando.io>
 <20190625162738.15049dc7@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <b402326b-d2e7-fc4e-9fdc-b6adcd8dd54c@pensando.io>
Date:   Wed, 26 Jun 2019 08:41:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625162738.15049dc7@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 4:27 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:15 -0700, Shannon Nelson wrote:
>> +static int ionic_set_features(struct net_device *netdev,
>> +			      netdev_features_t features)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	int err;
>> +
>> +	netdev_dbg(netdev, "%s: lif->features=0x%08llx new_features=0x%08llx\n",
>> +		   __func__, (u64)lif->netdev->features, (u64)features);
>> +
>> +	err = ionic_set_nic_features(lif, features);
> Presumably something gets added here in later patch?

This is a pass-through to the lif-specific function which does most of 
the work.

>
>> +	return err;
>> +}
>> +
>> +static int ionic_set_mac_address(struct net_device *netdev, void *sa)
>> +{
>> +	netdev_info(netdev, "%s: stubbed\n", __func__);
>> +	return 0;
>> +}
>> +
>> +static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic_admin_ctx ctx = {
>> +		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
>> +		.cmd.lif_setattr = {
>> +			.opcode = CMD_OPCODE_LIF_SETATTR,
>> +			.index = cpu_to_le16(lif->index),
>> +			.attr = IONIC_LIF_ATTR_MTU,
>> +			.mtu = cpu_to_le32(new_mtu),
>> +		},
>> +	};
>> +	int err;
>> +
>> +	if (new_mtu < IONIC_MIN_MTU || new_mtu > IONIC_MAX_MTU) {
>> +		netdev_err(netdev, "Invalid MTU %d\n", new_mtu);
>> +		return -EINVAL;
>> +	}
> We do the min/max checks in the core now (netdev->min_mtu,
> netdev->max_mtu).  You'll have to keep this if out of tree,
> unfortunately.

Got it.

>
>> +	err = ionic_adminq_post_wait(lif, &ctx);
>> +	if (err)
>> +		return err;
>> +
>> +	netdev->mtu = new_mtu;
>> +	err = ionic_reset_queues(lif);
>> +
>> +	return err;
>> +}

