Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57C74CA6D3
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 14:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240421AbiCBOAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 09:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbiCBOAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:00:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F59F4EA11
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 05:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646229565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xe2iwKfGIRkq9VyKQg0gm/3lc8YXGtL4KrUQ6qSmDg0=;
        b=YwW6Ct5ZADx3AeHLI12xXgybpnFETyU4MT00z2h4DWBWJ6C7PuOe0dkKZrUmHO/KpMbtDw
        TIoU7qBcWeYhWkolg6c6GC1ttqMMzXzSNV8wVkaxuQ7T+ciO6F3YmCr9TB4JLUYGwMyv37
        LgoLx2QhSOCEJbvX3TXfo34HWZxHow4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-PFTlOUrdPMC8g8Xhu898Eg-1; Wed, 02 Mar 2022 08:59:24 -0500
X-MC-Unique: PFTlOUrdPMC8g8Xhu898Eg-1
Received: by mail-ed1-f72.google.com with SMTP id da28-20020a056402177c00b00415ce4b20baso110020edb.17
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 05:59:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xe2iwKfGIRkq9VyKQg0gm/3lc8YXGtL4KrUQ6qSmDg0=;
        b=dZ8zGJTGJwBVifP2fUL0iPDlnkpLK4fLBX376Svv8O7R3MLs9ZzT18PrkeXqaAEpr0
         BVMdLNW2wbHgw0RyidOQ0PdKfRQxAgQmKE3MDm03afhAH8yCYfvmyIzZ/FGkOt5gk/Jf
         EFjTQd0TX0QzwhHPm34JNsRgur+R2InphCj9Ep/slXiRSjfbMi4bJNS7xIfoaVfJsCSs
         +9aUObYjeS3RNcdGy45g3OvfkxMyxHtHaYDVigDIFrtIhGgXIq8YwjHjpFoYz0pT6zsz
         b28QJ7zvhmGFVySusoxWWQW0X8U2B7YNG4JJ26vw+dGJwjCcxD7NghMb30lHSjHQceDG
         BEgQ==
X-Gm-Message-State: AOAM532Zhy/zTUBK+Pk0U76X4eXjI89sQEHEZxy+MQ/PRpX0bs1k3hNp
        WNlP6vtNAhZwQUoQ3DNsyIQh5jQd3oewiQkXcVR0BTWpoV9THAkF+8SETrMZIT+105F2QHNP5AG
        3fbR3B1iRHSH2fgul
X-Received: by 2002:a17:906:d935:b0:6cc:fcfc:c286 with SMTP id rn21-20020a170906d93500b006ccfcfcc286mr23114032ejb.423.1646229563128;
        Wed, 02 Mar 2022 05:59:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyNhPgatvjDQdr29sr8p4ut5aR7tTRqN0kQcy5FzWNUczB6jUqUudHhRoIZ2HGAYUznew8Sbw==
X-Received: by 2002:a17:906:d935:b0:6cc:fcfc:c286 with SMTP id rn21-20020a170906d93500b006ccfcfcc286mr23114006ejb.423.1646229562885;
        Wed, 02 Mar 2022 05:59:22 -0800 (PST)
Received: from [10.39.192.144] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id m25-20020a170906161900b006d43be5b95fsm6389055ejd.118.2022.03.02.05.59.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Mar 2022 05:59:22 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Toms Atteka <cpp.code.lv@gmail.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension header support
Date:   Wed, 02 Mar 2022 14:59:21 +0100
X-Mailer: MailMate (1.14r5875)
Message-ID: <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
In-Reply-To: <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
 <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
 <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
 <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2 Mar 2022, at 11:50, Roi Dayan wrote:

> On 2022-03-02 12:03 PM, Roi Dayan wrote:
>>
>>
>> On 2022-02-25 12:40 PM, patchwork-bot+netdevbpf@kernel.org wrote:
>>> Hello:
>>>
>>> This patch was applied to netdev/net-next.git (master)
>>> by David S. Miller <davem@davemloft.net>:
>>>
>>> On Wed, 23 Feb 2022 16:54:09 -0800 you wrote:
>>>> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
>>>> packets can be filtered using ipv6_ext flag.
>>>>
>>>> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
>>>> Acked-by: Pravin B Shelar <pshelar@ovn.org>
>>>> ---
>>>> =C2=A0 include/uapi/linux/openvswitch.h |=C2=A0=C2=A0 6 ++
>>>> =C2=A0 net/openvswitch/flow.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 140 +++++++++++++++++++++++++++++++
>>>> =C2=A0 net/openvswitch/flow.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 14 ++++
>>>> =C2=A0 net/openvswitch/flow_netlink.c=C2=A0=C2=A0 |=C2=A0 26 +++++-
>>>> =C2=A0 4 files changed, 184 insertions(+), 2 deletions(-)
>>>
>>> Here is the summary with links:
>>> =C2=A0=C2=A0 - [net-next,v8] net: openvswitch: IPv6: Add IPv6 extensi=
on header support
>>> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/netdev/net-next/c/28a=
3f0601727
>>>
>>> You are awesome, thank you!
>>
>> Hi,
>>
>> After the merge of this patch I fail to do ipv6 traffic in ovs.
>> Am I missing something?
>>
>> ovs-vswitchd.log has this msg
>>
>> 2022-03-02T09:52:26.604Z|00013|odp_util(handler1)|WARN|attribute packe=
t_type has length 2 but should have length 4
>>
>> Thanks,
>> Roi
>
>
> I think there is a missing userspace fix. didnt verify yet.
> but in ovs userspace odp-netlink.h created from datapath/linux/compat/i=
nclude/linux/openvswitch.h
> and that file is not synced the change here.
> So the new enum OVS_KEY_ATTR_IPV6_EXTHDRS is missing and also struct
> ovs_key_ipv6_exthdrs which is needed in lib/udp-util.c
> in struct ovs_flow_key_attr_lens to add expected len for
> OVS_KEY_ATTR_IPV6_EXTHDR.

I guess if this is creating backward compatibility issues, this patch sho=
uld be reverted/fixed. As a kmod upgrade should not break existing deploy=
ments.

