Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A022C8EEA
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgK3USq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 15:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbgK3USq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 15:18:46 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB179C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:18:05 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l1so17946561wrb.9
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pPaIndybLktFRyucz7TD3tkaUOea4d6ea7t52sd6HmM=;
        b=TZkoDvuzXHr/grbRlok0aTZKS+jNQwCO64JlYZl9jBXGPU8k8aBTw0oeraZh9JeK0f
         oxOIWG+z/GouE4MXp9uJyQcGL3OhFdceW35w4KtKyJ4VqTQGPWW23RgcpKjLAbEOb66w
         B1kpnUXsrxNS8W2dXWpUA30fJZ8WIH51rOzn+LHS62kSYaMuYTyhzLXvmWQIze5N8KAh
         FGaSmTjoZUB5gaYYM0U2k4DFWMJpkrRjYuk6Et+J2kjzU6h7ApvE2zIfU6IqyI5fATA8
         MzUFffRZeL0iM7pK41V6iPrseD7YsxpGXXusUKHQTWejQKy/yF6Pc0AB6zkX6SHgIR5Y
         gEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pPaIndybLktFRyucz7TD3tkaUOea4d6ea7t52sd6HmM=;
        b=RPs3MiJyvFd5m6PgG6zeol0lWjCvgI/kr//z7s8xZ5o0P6AaulZXGWHTjP+OuCoJph
         tuwR+7h4ZO4EFEC+getXz2Ld0QayPA9Znv55Q2Q7BDvQbY9AMcYUanxsbZaBDLvh8fwb
         T1OWUO6Y44KqoyiLW6CqGSpZJ8DYMf1G8TcJmjTs2nLXm0YagoQ3dVrmYYM8B1gJr/Fv
         Xvq0snQOLXbtEaRKFSGo5XZdi++E2FFVsytv5R7WweGZtl3n4M0f4J7S7GfLlpJ9n18h
         NpWxpmPAuTKeuhjH1UA99eyEWNtnevQMkpIrDcST1H1wWgjRifXhdwezp9hsEJ00euYf
         luPQ==
X-Gm-Message-State: AOAM530Cv+0i2O8X2PQsAnM4udvMZ2yLjDMknRXUsdGkS3wznaImznAa
        lhrh+sQniZDIy/p01Q6DWAk=
X-Google-Smtp-Source: ABdhPJxCao2N2/t6kR5rJC6UOwZl6yFUt249LlDieMC7GfVoHl6VwB11I/pfTml9RQFPqtcUY3TjZw==
X-Received: by 2002:adf:82cc:: with SMTP id 70mr30168295wrc.74.1606767484466;
        Mon, 30 Nov 2020 12:18:04 -0800 (PST)
Received: from [192.168.8.116] ([37.172.189.71])
        by smtp.gmail.com with ESMTPSA id w21sm476658wmi.29.2020.11.30.12.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 12:18:03 -0800 (PST)
Subject: Re: Correct usage of dev_base_lock in 2020
To:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
 <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
 <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf>
 <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130194617.kzfltaqccbbfq6jr@skbuf>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <edd71200-88c0-9de4-1ad2-3a4af3d407df@gmail.com>
Date:   Mon, 30 Nov 2020 21:18:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130194617.kzfltaqccbbfq6jr@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/20 8:46 PM, Vladimir Oltean wrote:
> On Mon, Nov 30, 2020 at 08:22:01PM +0100, Eric Dumazet wrote:
>> And ?
>>
>> A bonding device can absolutely maintain a private list, ready for
>> bonding ndo_get_stats() use, regardless
>> of register/unregister logic.
>>
>> bond_for_each_slave() is simply a macro, you can replace it by something else.
> 
> Also, coming to take the comment at face value.
> Can it really? How? Freeing a net_device at unregister time happens
> after an RCU grace period.

Except that the device would have to be removed from the bonding list
before the RCU grace period starts.

This removal would acquire the bonding ->stats_mutex in order to change the list.

 So whatever the bonding driver does to keep a
> private list of slave devices, those pointers need to be under RCU
> protection.


Not at all, if this new list is _only_ used from process context,
and protected by a per-device mutex.

I am not speaking of existing lists that _possibly_ are
used from IRQ context, thus are using RCU.


 And that doesn't help with the sleepable context that we're
> looking for.
>

Again, RCU would not be used at all, since you want ndo_get_stats64()
being called in process context (sleepable context)

And this should be solved without expanding RTNL usage.
(We do not want to block RTNL for ~10ms just because a device driver has to sleep
while a firmware request is processed)

