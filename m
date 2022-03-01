Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF7F4C9778
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbiCAVEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiCAVEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:04:55 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF90370337
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 13:04:12 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id l12so11680999ljh.12
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 13:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WPdaOZxQv/+NPdqn8YJ6TsMnJrXaQm6Rh85/hgPFMHQ=;
        b=ZxPc45uI2AqxuFwew1yLhiTkQfXDv4IJjaiXHnuhsgHkpUJCWFzOJ8JHBEeAgz9wNU
         kC2tdnmBaPZkb0eniZZPMYoq99CXLrZ9ZlaWgKiujHJ+IjFwf+e8hxDHxdYxtOaRNa1l
         v9FugmAlmBbXgR0CTfN4uY29h2MyZl0qSRXGMvUltqwqelnqvK7Z+nbMW8Ff9flZGCWh
         PfqOYljYodBYwVOB8JncXY7AZkKuXTCArNQgQwA4/6aDgvb6xRXSEKzDDZAlZh7TSE7k
         Z46eDqHt9JasRQu9Wi+SlUviqUj2YyGRfrMlLRDMt1PH9VT1YbB1SGgp62o8gF+gjLwu
         pQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WPdaOZxQv/+NPdqn8YJ6TsMnJrXaQm6Rh85/hgPFMHQ=;
        b=T3WnBcu0Oa6q3FVdcJIICVU31qruzQON2+C4Tk/86AVMjVjYrDaQ4notG8GHt00U/I
         RFQhySQxE1l0v9MImxf/gHs/i0TU1aQiUwoKraKss3sjSvzMrqaPWXlFqqiVf8lzqOKp
         aeuaegZp1Egc9SwDAmpjyzgI9dUiIDHM6ZPOkAcQ+l9+yStAfVwWutrdxngDE3zpLXLm
         vgGujiiEU/f17D1oNFNRnSYhl0yjONmNpikOF6OiQA+lrl6XaO65eNT2Lvt99c8WvMvL
         UcS3QCd4AgbPegLqc9uZY06L4GWQIgK8RxGz96hePgdnU/ZEf6Hjuoq0T6rQjuYPj2sd
         3HGg==
X-Gm-Message-State: AOAM533iLMrMJa4MukeBcbZIQZgeFTAz6kEJkyaHIGDrdrF9H8OM5N6S
        89C8dbx1sRAF1eB80JeV9kSW9dH4A/YwBOro
X-Google-Smtp-Source: ABdhPJzaaeog4PPZgDKQuKvfe/WEEiygHdFTaWmJhAcnFvz91X2kwO7JaCrnWaJIHplFIsLSQt9XxA==
X-Received: by 2002:a2e:a593:0:b0:246:7327:cd8e with SMTP id m19-20020a2ea593000000b002467327cd8emr15683674ljp.108.1646168650570;
        Tue, 01 Mar 2022 13:04:10 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id o25-20020ac24959000000b00443fdf504bcsm1668932lfi.161.2022.03.01.13.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 13:04:10 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: Re: [PATCH net-next 0/3] bridge: dsa: switchdev: mv88e6xxx:
 Implement local_receive bridge flag
In-Reply-To: <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
Date:   Tue, 01 Mar 2022 22:04:09 +0100
Message-ID: <87ilsxo052.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 09:14, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 3/1/2022 4:31 AM, Mattias Forsblad wrote:
>> Greetings,
>> 
>> This series implements a new bridge flag 'local_receive' and HW
>> offloading for Marvell mv88e6xxx.
>> 
>> When using a non-VLAN filtering bridge we want to be able to limit
>> traffic to the CPU port to lessen the CPU load. This is specially
>> important when we have disabled learning on user ports.
>> 
>> A sample configuration could be something like this:
>> 
>>         br0
>>        /   \
>>     swp0   swp1
>> 
>> ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
>> ip link set swp0 master br0
>> ip link set swp1 master br0
>> ip link set swp0 type bridge_slave learning off
>> ip link set swp1 type bridge_slave learning off
>> ip link set swp0 up
>> ip link set swp1 up
>> ip link set br0 type bridge local_receive 0
>> ip link set br0 up
>> 
>> The first part of the series implements the flag for the SW bridge
>> and the second part the DSA infrastructure. The last part implements
>> offloading of this flag to HW for mv88e6xxx, which uses the
>> port vlan table to restrict the ingress from user ports
>> to the CPU port when this flag is cleared.
>
> Why not use a bridge with VLAN filtering enabled? I cannot quite find it 
> right now, but Vladimir recently picked up what I had attempted before 
> which was to allow removing the CPU port (via the bridge master device) 
> from a specific group of VLANs to achieve that isolation.
>

Hi Florian,

Yes we are aware of this work, which is awesome by the way! For anyone
else who is interested, I believe you are referring to this series:

https://lore.kernel.org/netdev/20220215170218.2032432-1-vladimir.oltean@nxp.com/

There are cases though, where you want a TPMR-like setup (or "dumb hub"
mode, if you will) and ignore all tag information.

One application could be to use a pair of ports on a switch as an
ethernet extender/repeater for topologies that span large physical
distances. If this repeater is part of a redundant topology, you'd to
well to disable learning, in order to avoid dropping packets when the
surrounding active topology changes. This, in turn, will mean that all
flows will be classified as unknown unicast. For that reason it is very
important that the CPU be shielded.

You might be tempted to solve this using flooding filters of the
switch's CPU port, but these go out the window if you have another
bridge configured, that requires that flooding of unknown traffic is
enabled.

Another application is to create a similar setup, but with three ports,
and have the third one be used as a TAP.

>> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
>
> I don't believe this tag has much value since it was presumably carried 
> over from an internal review. Might be worth adding it publicly now, though.

I think Mattias meant to replicate this tag on each individual
patch. Aside from that though, are you saying that a tag is never valid
unless there is a public message on the list from the signee? Makes
sense I suppose. Anyway, I will send separate tags for this series.
