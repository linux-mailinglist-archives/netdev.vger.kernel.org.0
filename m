Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE8D687C8C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjBBLpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjBBLpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:45:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C976B342
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675338291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k4XB4wBym7vHdMSVJtfOvWMT1fLmtVxmxmLszCplgCM=;
        b=axsMNr9zwufSN1wuhR8pSbHTtvtF7TJ7pG3HfCzjUPRW1eQtOOrU7Gcbr6MR0+fbsKliGP
        7u+czSQZlzymnChwcI3lpnq4FoufTtgs8ud67q/Ui9ngNn0l3pm8DO2uPOEAx7PmtMZjuv
        bBYqk5zT805s0TuX/sDFQNAgLk5GMA4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-315-2tHKI16HMgSm_T79RZXbIw-1; Thu, 02 Feb 2023 06:44:50 -0500
X-MC-Unique: 2tHKI16HMgSm_T79RZXbIw-1
Received: by mail-ed1-f69.google.com with SMTP id a29-20020a50c31d000000b004a248bc5b6dso1274686edb.5
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 03:44:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k4XB4wBym7vHdMSVJtfOvWMT1fLmtVxmxmLszCplgCM=;
        b=H4PWxFJ67dB2lSWAYyNChcPow55+PmQqTTc33rYTwzwP2rL5Y+N/UXneE/r+ftwSpS
         QsqPEnp9H9Xz53ReubjLzL0Es4Vih45kLb3/uHiFrJQ/DHYBFa1mE8MJzux4CHefnTAC
         QsyH71yKwYnt3kk99ka7bNUPoIQ87/FmNqal6tp7njrs6zc/DPDulnhyXKOcSn1ppE++
         GEBP8qz8ohAHnf+wzHHVXvLuTsYVoApcvp8f2yHQJAc/2z3YWzffSRtzYFWPG9jfrXGq
         jRxyFJtT8Rswo/JlrJF3VIJ6dUd9z9M/ONfXYTZ7zqvsd+YLPQnywH+Cytli4s9sbNlT
         Hhsw==
X-Gm-Message-State: AO0yUKUH+aGajNujKwxBI/+OzeUmm6hNAQ0WG/RfKVybp1+mcYXpcFdf
        qximApvnas24MmzG0Gn7NRplB2PSuMirNEbUZh+bWi9Zoc5yGaNCrf2SLSBOFquLjLTYtCKtQR5
        CnCtp6AOfxWaiOV9l
X-Received: by 2002:a05:6402:254c:b0:46d:53d7:d21e with SMTP id l12-20020a056402254c00b0046d53d7d21emr7253845edb.27.1675338289114;
        Thu, 02 Feb 2023 03:44:49 -0800 (PST)
X-Google-Smtp-Source: AK7set+nKMVYhqWVstg0aIMPDMDUpNic8CGMBzZ6874SzcavrRE+8h5k09/QAnQT1AbH/FhSbfs59g==
X-Received: by 2002:a05:6402:254c:b0:46d:53d7:d21e with SMTP id l12-20020a056402254c00b0046d53d7d21emr7253825edb.27.1675338288865;
        Thu, 02 Feb 2023 03:44:48 -0800 (PST)
Received: from [10.39.192.164] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id cf8-20020a0564020b8800b004a18f2ffb86sm10239858edb.79.2023.02.02.03.44.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Feb 2023 03:44:48 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     =?utf-8?b?6Zm2IOe8mA==?= <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [PATCH net-next v3 1/1] net:openvswitch:reduce
 cpu_used_mask memory
Date:   Thu, 02 Feb 2023 12:44:47 +0100
X-Mailer: MailMate (1.14r5939)
Message-ID: <B3DA2461-65EC-4EDB-8775-C8051CDD5043@redhat.com>
In-Reply-To: <OS3P286MB22951B162C8A486E39F250BFF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
References: <OS3P286MB2295FA2701BCE468E367607AF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <561547E5-D4C2-4FD6-9B25-100719D4D379@redhat.com>
 <OS3P286MB22951B162C8A486E39F250BFF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2 Feb 2023, at 12:26, =E9=99=B6 =E7=BC=98 wrote:

> Hi, Eelco:
>
>       Thanks for your time going through the detail.
> The thing is: sizeof(struct cpumask), with default CONFIG_NR_CPUS 8192,=
 has a size of 1024 bytes even on a system with only 4 cpus.
> While in practice the cpumask APIs like cpumask_next and cpumask_set_cp=
u never access more than cpumask_size() of bytes in the bitmap
> My change used cpumask_size() (in above example, consume 8 bytes after =
alignement for the cpumask, it saved 1016 bytes for every flow.

I looked at the wrong nr_cpumask_bits definition, so thanks for this educ=
ation :)

> Your question reminded me to revisit the description "as well as the it=
eration of bits in cpu_used_mask", after a second think, this statement i=
s not valid and should be removed.
> since the iteration API will not access the number of bytes decided by =
nr_cpu_ids(running CPUs)
>
> I will remove this statement after solving a final style issue in the n=
ext submission.

Thanks!


> Thanks
> eddy
> ________________________________
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Eelco Chaudron <echaudro@redhat.com>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2023=E5=B9=B42=E6=9C=882=E6=97=A5=
 11:05
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Eddy Tao <taoyuan_eddy@hotmail.com>
> =E6=8A=84=E9=80=81: netdev@vger.kernel.org <netdev@vger.kernel.org>; de=
v@openvswitch.org <dev@openvswitch.org>; linux-kernel@vger.kernel.org <li=
nux-kernel@vger.kernel.org>; Eric Dumazet <edumazet@google.com>; Jakub Ki=
cinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Mille=
r <davem@davemloft.net>
> =E4=B8=BB=E9=A2=98: Re: [ovs-dev] [PATCH net-next v3 1/1] net:openvswit=
ch:reduce cpu_used_mask memory
>
>
>
> On 2 Feb 2023, at 11:32, Eddy Tao wrote:
>
>> Use actual CPU number instead of hardcoded value to decide the size
>> of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.
>>
>> 'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
>> Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
>> 8192 by default, it costs memory and slows down ovs_flow_alloc
>> as well as the iteration of bits in cpu_used_mask when handling
>> netlink message from ofproto
>
> I=E2=80=99m trying to understand how this will decrease memory usage. T=
he size of the flow_cache stayed the same (actually it=E2=80=99s large du=
e to the extra pointer).
>
> Also do not understand why the iteration is less, as the mask is initia=
lized the same.
>
> Cheers,
>
> Eelco
>
>> To address this, redefine cpu_used_mask to pointer
>> append cpumask_size() bytes after 'stat' to hold cpumask
>>
>> cpumask APIs like cpumask_next and cpumask_set_cpu never access
>> bits beyond cpu count, cpumask_size() bytes of memory is enough
>>
>> Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
>> ---
>>  net/openvswitch/flow.c       | 8 +++++---
>>  net/openvswitch/flow.h       | 2 +-
>>  net/openvswitch/flow_table.c | 8 +++++---
>>  3 files changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
>> index e20d1a973417..0109a5f86f6a 100644
>> --- a/net/openvswitch/flow.c
>> +++ b/net/openvswitch/flow.c
>> @@ -107,7 +107,7 @@ void ovs_flow_stats_update(struct sw_flow *flow, _=
_be16 tcp_flags,
>>
>>                                        rcu_assign_pointer(flow->stats[=
cpu],
>>                                                           new_stats);
>> -                                     cpumask_set_cpu(cpu, &flow->cpu_=
used_mask);
>> +                                     cpumask_set_cpu(cpu, flow->cpu_u=
sed_mask);
>>                                        goto unlock;
>>                                }
>>                        }
>> @@ -135,7 +135,8 @@ void ovs_flow_stats_get(const struct sw_flow *flow=
,
>>        memset(ovs_stats, 0, sizeof(*ovs_stats));
>>
>>        /* We open code this to make sure cpu 0 is always considered */=

>> -     for (cpu =3D 0; cpu < nr_cpu_ids; cpu =3D cpumask_next(cpu, &flo=
w->cpu_used_mask)) {
>> +     for (cpu =3D 0; cpu < nr_cpu_ids;
>> +          cpu =3D cpumask_next(cpu, flow->cpu_used_mask)) {
>>                struct sw_flow_stats *stats =3D rcu_dereference_ovsl(fl=
ow->stats[cpu]);
>>
>>                if (stats) {
>> @@ -159,7 +160,8 @@ void ovs_flow_stats_clear(struct sw_flow *flow)
>>        int cpu;
>>
>>        /* We open code this to make sure cpu 0 is always considered */=

>> -     for (cpu =3D 0; cpu < nr_cpu_ids; cpu =3D cpumask_next(cpu, &flo=
w->cpu_used_mask)) {
>> +     for (cpu =3D 0; cpu < nr_cpu_ids;
>> +          cpu =3D cpumask_next(cpu, flow->cpu_used_mask)) {
>>                struct sw_flow_stats *stats =3D ovsl_dereference(flow->=
stats[cpu]);
>>
>>                if (stats) {
>> diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
>> index 073ab73ffeaa..b5711aff6e76 100644
>> --- a/net/openvswitch/flow.h
>> +++ b/net/openvswitch/flow.h
>> @@ -229,7 +229,7 @@ struct sw_flow {
>>                                         */
>>        struct sw_flow_key key;
>>        struct sw_flow_id id;
>> -     struct cpumask cpu_used_mask;
>> +     struct cpumask *cpu_used_mask;
>>        struct sw_flow_mask *mask;
>>        struct sw_flow_actions __rcu *sf_acts;
>>        struct sw_flow_stats __rcu *stats[]; /* One for each CPU.  Firs=
t one
>> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table=
=2Ec
>> index 0a0e4c283f02..dc6a174c3194 100644
>> --- a/net/openvswitch/flow_table.c
>> +++ b/net/openvswitch/flow_table.c
>> @@ -87,11 +87,12 @@ struct sw_flow *ovs_flow_alloc(void)
>>        if (!stats)
>>                goto err;
>>
>> +     flow->cpu_used_mask =3D (struct cpumask *)&flow->stats[nr_cpu_id=
s];
>>        spin_lock_init(&stats->lock);
>>
>>        RCU_INIT_POINTER(flow->stats[0], stats);
>>
>> -     cpumask_set_cpu(0, &flow->cpu_used_mask);
>> +     cpumask_set_cpu(0, flow->cpu_used_mask);
>>
>>        return flow;
>>  err:
>> @@ -115,7 +116,7 @@ static void flow_free(struct sw_flow *flow)
>>                                          flow->sf_acts);
>>        /* We open code this to make sure cpu 0 is always considered */=

>>        for (cpu =3D 0; cpu < nr_cpu_ids;
>> -          cpu =3D cpumask_next(cpu, &flow->cpu_used_mask)) {
>> +          cpu =3D cpumask_next(cpu, flow->cpu_used_mask)) {
>>                if (flow->stats[cpu])
>>                        kmem_cache_free(flow_stats_cache,
>>                                        (struct sw_flow_stats __force *=
)flow->stats[cpu]);
>> @@ -1196,7 +1197,8 @@ int ovs_flow_init(void)
>>
>>        flow_cache =3D kmem_cache_create("sw_flow", sizeof(struct sw_fl=
ow)
>>                                       + (nr_cpu_ids
>> -                                       * sizeof(struct sw_flow_stats =
*)),
>> +                                       * sizeof(struct sw_flow_stats =
*))
>> +                                    + cpumask_size(),
>>                                       0, 0, NULL);
>>        if (flow_cache =3D=3D NULL)
>>                return -ENOMEM;
>> --
>> 2.27.0
>>
>> _______________________________________________
>> dev mailing list
>> dev@openvswitch.org
>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

