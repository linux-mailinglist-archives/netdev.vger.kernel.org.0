Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A8656E12
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfFZPw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:52:27 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35260 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfFZPw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:52:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id s27so1424039pgl.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=36HsqFqfMN5dc7er2VzR9aQOVFMEyTF/EfglEXhfvh8=;
        b=xrSp2PBdW/GlKn3IK8OWx+YfZcZhDrxBOQrIUmi5pV/lkXu3PMjgpyNK50kSZOCiIT
         ovZzXfweXwUCYyvjmGKUE5AMS492m3A6MZw6682KMYjV8ruW11ffiaZQ37GUKGwegGTc
         VEJtxHIT5zHctG9ynbrsjuGB5ISBNJI1iDdnUHoV6S0m8Luz/NXlQGwiD68k778pdzHt
         wCA3D9/zOQG2J5RhFABdQpKvEda17pduBZj9WyxS2hIC5ip6+weicjHkW1FBgV+64Zt9
         /46/i13vp5sPnvzgmn/2Y7bzVOe0B8KpVoR3GK3FlgqFpJ7JQKny3XmaRoQGhxvEEEwO
         g4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=36HsqFqfMN5dc7er2VzR9aQOVFMEyTF/EfglEXhfvh8=;
        b=AK1wwSFqAE+6ZNp2K1iWKgzTbAja8HfEjjmkM3vknmxkqXH2Y5c2bDjWklCzA/jUqQ
         G+FmB+WEUqv6blaE76PZJFMrza7UW+lfzHgOnAOicjHH5jfQgyyEpKOaZjkL3TGwrFIX
         8XAV3/DjTCxatq4jutCxHXqH3w12s0nlQ1nFtwciOoOnDfpWlnynx4Se/i6H5V9Eibya
         kAUrROcjyQIQAptxCEUAKoDrGE+luM68X/i5K1uaU8dyYi3QE5brCjLPTxFAql7aCAzs
         uqeTGb25BUSyl/olvjcu51Jmgo5k6oVTV7FpzEJYAFGKo6OM2rqMje0Wuxwtfs+36/wT
         xiMw==
X-Gm-Message-State: APjAAAWHmsvfU0NIWUzIieQUU4rGw4FaCFqrTjHGEQZtfp1Vh9OO/Bxc
        hl5Qik9LjpOHqLR9tf/2BARNThVBiBU=
X-Google-Smtp-Source: APXvYqwDZMeFElYVuGkvpB0dj/4IFUnaJ0xDgaw1f/7SX2SoYYb5+bqLmMzuUTZUajn0Ix4eC+aEPQ==
X-Received: by 2002:a17:90a:22aa:: with SMTP id s39mr5546113pjc.39.1561564346251;
        Wed, 26 Jun 2019 08:52:26 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id l1sm17089135pgi.91.2019.06.26.08.52.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 08:52:25 -0700 (PDT)
Subject: Re: [PATCH net-next 10/18] ionic: Add management of rx filters
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-11-snelson@pensando.io>
 <20190625163729.617346e0@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <5ea141a1-37e1-a33f-105f-16f5a976bdb8@pensando.io>
Date:   Wed, 26 Jun 2019 08:52:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625163729.617346e0@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 4:37 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:16 -0700, Shannon Nelson wrote:
>> +int ionic_rx_filter_save(struct lif *lif, u32 flow_id, u16 rxq_index,
>> +			 u32 hash, struct ionic_admin_ctx *ctx)
>> +{
>> +	struct device *dev = lif->ionic->dev;
>> +	struct hlist_head *head;
>> +	struct rx_filter *f;
>> +	unsigned int key;
>> +
>> +	f = devm_kzalloc(dev, sizeof(*f), GFP_KERNEL);
>> +	if (!f)
>> +		return -ENOMEM;
>> +
>> +	f->flow_id = flow_id;
>> +	f->filter_id = le32_to_cpu(ctx->comp.rx_filter_add.filter_id);
>> +	f->rxq_index = rxq_index;
>> +	memcpy(&f->cmd, &ctx->cmd, sizeof(f->cmd));
>> +
>> +	INIT_HLIST_NODE(&f->by_hash);
>> +	INIT_HLIST_NODE(&f->by_id);
>> +
>> +	switch (le16_to_cpu(f->cmd.match)) {
>> +	case RX_FILTER_MATCH_VLAN:
>> +		key = le16_to_cpu(f->cmd.vlan.vlan) & RX_FILTER_HLISTS_MASK;
>> +		break;
>> +	case RX_FILTER_MATCH_MAC:
>> +		key = *(u32 *)f->cmd.mac.addr & RX_FILTER_HLISTS_MASK;
>> +		break;
>> +	case RX_FILTER_MATCH_MAC_VLAN:
>> +		key = le16_to_cpu(f->cmd.mac_vlan.vlan) & RX_FILTER_HLISTS_MASK;
>> +		break;
>> +	default:
> I know you use devm_kzalloc() but can't this potentially keep arbitrary
> amounts of memory held until the device is removed (and it's the entire
> device not just a LIF)?

Yes, but we're freeing this memory when objects are deleted.  We're 
trying to be tidy with our allocations, but used devm_kzalloc to be more 
sure that things went away when the device did.

>
>> +		return -ENOTSUPP;
> EOPNOTSUPP, please do not use ENOTSUPP in the drivers.  It's a high
> error code, unknown to libc.  We should use EOPNOTSUPP or EINVAL.

Sure.

>
>> +	}

