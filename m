Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3FD58693
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfF0QAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:00:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41071 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0QAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:00:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so1445417pff.8
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VgkULGoi1W6FOAp38WloAVy4YIIGLQvkGFlnnxJr3rQ=;
        b=INLWwhK40o+/OlZOO7w7ew6j5WRkYWTD4GE0XGAu6gHDw/IYd02+9O/zA7fBVkNY7T
         polEQE6ghTvV2sh8EVbomu2SauaspVXBRsgxq4UmQg6cruAfOq6nWprBVkoluIdRzyiR
         GPW40D2m/dr1/qdnPyWIYOUHs8N4ygA27L48MhQvV5V0p8lsrdgBE85xVQoM1VtDaj3z
         vdud/F7rIpnXQAoAjV2LgSOAdNTAoCwyccsgGyBozRWolsYtm1ctwzizrGqsyK0VvAeq
         LGzl64kozHdIAEGxDNh0ByWAT1ctZ8j3xZG+MLXrmKsGCa6OCCbDbcbH+witxw9bXKkR
         yvKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VgkULGoi1W6FOAp38WloAVy4YIIGLQvkGFlnnxJr3rQ=;
        b=WuuYfYxVXJ1KiIXfoieaYaI+SrMSeJqo6XH6QKGyqr5wR3daKl8j0NMT9kxP5IRzhD
         K5MIJYM8yGT9mVA09lGMF2Z4Mxd+1OWaK9d0KweiHpgnCp/SfUAdJ2O7zjY7vevzTeQ4
         65XVN/kvEHrDN5wjXXAj2Pi44aKDkcFM3OEIBrgeh5h6zWWjlzyKCWHOzEJnE0wvAsvm
         4n9n9A6WXqq2VeE9knEusky3B+4ydsj8TJBxKYevUZuhvWrT/QhgyM5ZLRA1OBMT7oeZ
         Dmm6uEZTURTKT7Tl7C6qwMpIFyE2SZrobWfK5xjn+FnN/1o2ji1strAj86z/Ra2p+cR0
         vlIQ==
X-Gm-Message-State: APjAAAWVPGziaj6M4AfBakOs+b4cK7uvJ3swPn6vUk3GBcKn2UYWcWOB
        bhtuVUxrzDSEf/iXEYBvQPD4YC3mLGg=
X-Google-Smtp-Source: APXvYqwiPaBwp/SWvaEs9mVLFY+DYdPE9aIuKdsRr0CFMHXuR/4qYEtiEOANGfzELKEH8MrvRIs54A==
X-Received: by 2002:a63:50f:: with SMTP id 15mr4517592pgf.148.1561651201311;
        Thu, 27 Jun 2019 09:00:01 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b19sm2609773pgh.57.2019.06.27.09.00.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 09:00:00 -0700 (PDT)
Subject: Re: [PATCH net-next 10/18] ionic: Add management of rx filters
From:   Shannon Nelson <snelson@pensando.io>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-11-snelson@pensando.io>
 <20190625163729.617346e0@cakuba.netronome.com>
 <5ea141a1-37e1-a33f-105f-16f5a976bdb8@pensando.io>
Message-ID: <99eb3d29-b20f-cde3-c810-bf745133c9b4@pensando.io>
Date:   Thu, 27 Jun 2019 08:59:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5ea141a1-37e1-a33f-105f-16f5a976bdb8@pensando.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/19 8:52 AM, Shannon Nelson wrote:
> On 6/25/19 4:37 PM, Jakub Kicinski wrote:
>> On Thu, 20 Jun 2019 13:24:16 -0700, Shannon Nelson wrote:
>>> +int ionic_rx_filter_save(struct lif *lif, u32 flow_id, u16 rxq_index,
>>> +             u32 hash, struct ionic_admin_ctx *ctx)
>>> +{
>>> +    struct device *dev = lif->ionic->dev;
>>> +    struct hlist_head *head;
>>> +    struct rx_filter *f;
>>> +    unsigned int key;
>>> +
>>> +    f = devm_kzalloc(dev, sizeof(*f), GFP_KERNEL);
>>> +    if (!f)
>>> +        return -ENOMEM;
>>> +
>>> +    f->flow_id = flow_id;
>>> +    f->filter_id = le32_to_cpu(ctx->comp.rx_filter_add.filter_id);
>>> +    f->rxq_index = rxq_index;
>>> +    memcpy(&f->cmd, &ctx->cmd, sizeof(f->cmd));
>>> +
>>> +    INIT_HLIST_NODE(&f->by_hash);
>>> +    INIT_HLIST_NODE(&f->by_id);
>>> +
>>> +    switch (le16_to_cpu(f->cmd.match)) {
>>> +    case RX_FILTER_MATCH_VLAN:
>>> +        key = le16_to_cpu(f->cmd.vlan.vlan) & RX_FILTER_HLISTS_MASK;
>>> +        break;
>>> +    case RX_FILTER_MATCH_MAC:
>>> +        key = *(u32 *)f->cmd.mac.addr & RX_FILTER_HLISTS_MASK;
>>> +        break;
>>> +    case RX_FILTER_MATCH_MAC_VLAN:
>>> +        key = le16_to_cpu(f->cmd.mac_vlan.vlan) & 
>>> RX_FILTER_HLISTS_MASK;
>>> +        break;
>>> +    default:
>> I know you use devm_kzalloc() but can't this potentially keep arbitrary
>> amounts of memory held until the device is removed (and it's the entire
>> device not just a LIF)?
>
> Yes, but we're freeing this memory when objects are deleted. We're 
> trying to be tidy with our allocations, but used devm_kzalloc to be 
> more sure that things went away when the device did.

... except, of course, in this error case.  Yes, I'll add a free here.

sln

