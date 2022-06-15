Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DE954CD31
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243363AbiFOPkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236389AbiFOPkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:40:01 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A5813DC6
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:40:00 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id d14so16711472eda.12
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=r8ZZlR71S22xAPSG/Tdt3h+VTXyn3BEcJUXzT3hoACY=;
        b=H32ve6xdIByhIeHHhcUG6fPM1qPH7t3NDL6dISDMEtK+L3YWYoLu2N8mlyGS8xRgJk
         Di9qOlH0703He8NG5Z7Uk1tNIrqkKBtLvnQvdBHyPDbh6lYbPHdrwWN7vOYmC+PC8LVv
         Yvr88YsHYN6Ixqrzdc89Ci3TJuoumssuEG5rp6MkSWGyZqgqhHvLY2gR85Nz7xA8jpU8
         O+d63kMwhU9MAMqMNjE/TH0g+R39eYfNSxcgATIECI7q2KPnXtr3PcGkM2PJr5cc9C9T
         snTY9jOjBvF8iHPianCMLxV5Zd4joAsj7kRTzwllrRk7/pver8mHdE2tQNtEjhjvYSJi
         /OUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=r8ZZlR71S22xAPSG/Tdt3h+VTXyn3BEcJUXzT3hoACY=;
        b=Q5RuLjwDhhazPTKQF4yENmVJGyWzcEemfKhjjHKyTlbgUevN/fmmslowd8sVaHUY3u
         Vigo6NI3n0MNQ4wWjSHxzZkrWnp8GL5p44Zx3YHnOEjImt+UdObbBvPuKXFDbOa1atfM
         M9A5ljU3fHampxb5J9b+mMr6l8K/ORYQ2IiUGE7azIUUIA6eIOLBIf23O/XJYkIpL0sh
         GHs1NZ8LV5mv21ZdrU2RyzZg9CyewjtMeH5I+bS5saeN3yejHysjuDmpDJdKnE+mXfmU
         WocvxV1x5ls03kYnFBbBT8J0NDItUTRTfAPThWuNd/LR47/E06sXTKakJX6RlampJZbK
         tMDw==
X-Gm-Message-State: AJIora83e6EH7XrWRT91HywrBvCjaPLzttzSThFiy9mhBJ+pezlnuMtB
        gKD16rEVnWU/Bs9mWNtEp2xOUA==
X-Google-Smtp-Source: AGRyM1u0nIUcgFQw11EycHqn6oM159UocXhB+a0aTREjTrnMCKIrTym1g9rt58cmtPjLBMZdvUI2OQ==
X-Received: by 2002:aa7:cb13:0:b0:433:4985:1b54 with SMTP id s19-20020aa7cb13000000b0043349851b54mr428233edt.182.1655307598401;
        Wed, 15 Jun 2022 08:39:58 -0700 (PDT)
Received: from [127.0.0.1] ([93.123.70.11])
        by smtp.gmail.com with ESMTPSA id l21-20020a056402125500b0042dddaa8af3sm9586514edw.37.2022.06.15.08.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 08:39:58 -0700 (PDT)
Date:   Wed, 15 Jun 2022 18:39:53 +0300
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Yuwei Wang <wangyuweihx@gmail.com>
CC:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>, roopa@nvidia.com,
        dsahern@kernel.org, =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org, wangyuweihx <wangyuweihx@gmail.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next_v3_2/2=5D_net=2C_neigh=3A_intr?= =?US-ASCII?Q?oduce_interval=5Fprobe=5Ftime_for_periodic_probe?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CANmJ_FNXSxPtBbESV4Y4Zme6vabgTJFSw0hjZNndfstSvxAeLw@mail.gmail.com>
References: <20220609105725.2367426-1-wangyuweihx@gmail.com> <20220609105725.2367426-3-wangyuweihx@gmail.com> <101855d8-878b-2334-fd5a-85684fd78e12@blackwall.org> <CANmJ_FNXSxPtBbESV4Y4Zme6vabgTJFSw0hjZNndfstSvxAeLw@mail.gmail.com>
Message-ID: <57228F24-81CD-49E9-BE4D-73FC6697872B@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 June 2022 18:28:27 EEST, Yuwei Wang <wangyuweihx@gmail=2Ecom> wrote:
>On Tue, 14 Jun 2022 at 17:10, Nikolay Aleksandrov <razor@blackwall=2Eorg>=
 wrote:
>> > @@ -2255,6 +2257,7 @@ static const struct nla_policy nl_ntbl_parm_pol=
icy[NDTPA_MAX+1] =3D {
>> >       [NDTPA_ANYCAST_DELAY]           =3D { =2Etype =3D NLA_U64 },
>> >       [NDTPA_PROXY_DELAY]             =3D { =2Etype =3D NLA_U64 },
>> >       [NDTPA_LOCKTIME]                =3D { =2Etype =3D NLA_U64 },
>> > +     [NDTPA_INTERVAL_PROBE_TIME]     =3D { =2Etype =3D NLA_U64, =2Em=
in =3D 1 },
>>
>> shouldn't the min be MSEC_PER_SEC (1 sec minimum) ?
>
>thanks, I will make it match the option ;)
>
>> >
>> > +static int neigh_proc_dointvec_jiffies_positive(struct ctl_table *ct=
l, int write,
>> > +                                             void *buffer, size_t *l=
enp,
>> > +                                             loff_t *ppos)
>>
>> Do we need the proc entry to be in jiffies when the netlink option is i=
n ms?
>> Why not make it directly in ms (with _ms similar to other neigh _ms tim=
e options) ?
>>
>> IMO, it would be better to be consistent with the netlink option which =
sets it in ms=2E
>>
>> It seems the _ms options were added later and usually people want a mor=
e understandable
>> value, I haven't seen anyone wanting a jiffies version of a ms interval=
 variable=2E :)
>>
>
>It was in jiffies because this entry was separated from `DELAY_PROBE_TIME=
`,
>it keeps nearly all the things the same as `DELAY_PROBE_TIME`,
>they are both configured by seconds and read to jiffies, was `ms` in
>netlink attribute,
>I think it's ok to keep this consistency, and is there a demand
>required to configure it by ms?
>If there is that demand, we can make it configured as ms=2E
>

no, no demand, just out of user-friendliness :) but=20
I get it keeping it as jiffies is also fine=20

>> > +{
>> > +     struct ctl_table tmp =3D *ctl;
>> > +     int ret;
>> > +
>> > +     int min =3D HZ;
>> > +     int max =3D INT_MAX;
>> > +
>> > +     tmp=2Eextra1 =3D &min;
>> > +     tmp=2Eextra2 =3D &max;
>>
>> hmm, I don't think these min/max match the netlink attribute's min/max=
=2E
>
>thanks, I will make it match the attribute ;)
>
>>
>> > +
>> > +     ret =3D proc_dointvec_jiffies_minmax(&tmp, write, buffer, lenp,=
 ppos);
>> > +     neigh_proc_update(ctl, write);
>> > +     return ret;
>> > +}
>> > +
>> >  int neigh_proc_dointvec(struct ctl_table *ctl, int write, void *buff=
er,
>> >                       size_t *lenp, loff_t *ppos)
>> >  {
>> > @@ -3658,6 +3683,9 @@ static int neigh_proc_base_reachable_time(struc=
t ctl_table *ctl, int write,
>> >  #define NEIGH_SYSCTL_USERHZ_JIFFIES_ENTRY(attr, name) \
>> >       NEIGH_SYSCTL_ENTRY(attr, attr, name, 0644, neigh_proc_dointvec_=
userhz_jiffies)
>> >
>> [snip]
>> Cheers,
>>  Nik
>
>Thanks,
>Yuwei Wang

