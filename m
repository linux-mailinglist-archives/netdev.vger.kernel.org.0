Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EE3687B83
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjBBLHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBBLHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:07:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFD4719A1
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675335949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9M4NDpJqrMaRwiYT/VeraTjAir6oKB3t+zIsWAMAXf8=;
        b=dpR3HoAcTyrYwWJNs4ZoX75HEjQuSbeNJ01qQwHuT/ICJce2VTirDcxAoL0lSbBwj1Cz07
        IRITpoil6RzfcQWPAXSH16yIkinyGuZKDoWEz+GT4VvPHiNA0g+SnqwXkt+U36+q6n9b0b
        y+8edX8TfMxNsHvxxAltwo2h7ni/3wc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-PC2EI7lDMHmzfP5WBvoyEA-1; Thu, 02 Feb 2023 06:05:48 -0500
X-MC-Unique: PC2EI7lDMHmzfP5WBvoyEA-1
Received: by mail-ed1-f70.google.com with SMTP id d21-20020aa7c1d5000000b004a6e1efa7d0so955519edp.19
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 03:05:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9M4NDpJqrMaRwiYT/VeraTjAir6oKB3t+zIsWAMAXf8=;
        b=Wvtlukg0ZaQuG91jeC5o74HWzqMdUMNraiRDBDQOxrUIPzDlbkZti2VqqxM84lUfol
         6Tcf9+CIHeJv/VTgqqyQTvVUZjlF8YLUVK2QqvxsXPXxZE+5qgHwPAR/JqLYxRVhLuDW
         ytLCnBRM972uFdTIKwgZfV4QziYkxclnJlcs2RW7B9JMtJ2FLf/6R3WV+2gEW/HFNzTm
         gSP+V4k4AzhNIXQ44BGMaBlEL8iHepuzyq7d4eh2HYifG+CscT0MNXSejLJULXq/CPnQ
         SL09L3pyAH1F5ahsrqkAumumRJl3xevtdZ4AIadChy3/fsFtRqWEyAuf808amWU7nH84
         KuEA==
X-Gm-Message-State: AO0yUKVxOQUSu1f5tUjAwWV+lTXOLtwogf8i7of4Vg/DQCZqlPxVmoqD
        FjEAwCMlWjxgEG0aTVL8y2biJ3sfNecRQ59cRCOD2L7awpgMIMIaVwJyhGYvKuzitousUh21BOI
        /cPIAEUFFOQMB+U6O
X-Received: by 2002:a17:906:c0c3:b0:883:3c7d:944e with SMTP id bn3-20020a170906c0c300b008833c7d944emr5437052ejb.9.1675335946681;
        Thu, 02 Feb 2023 03:05:46 -0800 (PST)
X-Google-Smtp-Source: AK7set+fc8EWwrGtQ1phRFqugSVTLUZhZ3tA5/uyYMtzGXASHL4KhTuAfYpcQFuLTIxGgBC/ci0TuQ==
X-Received: by 2002:a17:906:c0c3:b0:883:3c7d:944e with SMTP id bn3-20020a170906c0c300b008833c7d944emr5437035ejb.9.1675335946424;
        Thu, 02 Feb 2023 03:05:46 -0800 (PST)
Received: from [10.39.192.164] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id er12-20020a056402448c00b0049668426aa6sm10924515edb.24.2023.02.02.03.05.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Feb 2023 03:05:45 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [PATCH net-next v3 1/1] net:openvswitch:reduce
 cpu_used_mask memory
Date:   Thu, 02 Feb 2023 12:05:44 +0100
X-Mailer: MailMate (1.14r5939)
Message-ID: <561547E5-D4C2-4FD6-9B25-100719D4D379@redhat.com>
In-Reply-To: <OS3P286MB2295FA2701BCE468E367607AF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
References: <OS3P286MB2295FA2701BCE468E367607AF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
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



On 2 Feb 2023, at 11:32, Eddy Tao wrote:

> Use actual CPU number instead of hardcoded value to decide the size
> of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.
>
> 'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
> Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
> 8192 by default, it costs memory and slows down ovs_flow_alloc
> as well as the iteration of bits in cpu_used_mask when handling
> netlink message from ofproto

I=E2=80=99m trying to understand how this will decrease memory usage. The=
 size of the flow_cache stayed the same (actually it=E2=80=99s large due =
to the extra pointer).

Also do not understand why the iteration is less, as the mask is initiali=
zed the same.

Cheers,

Eelco

> To address this, redefine cpu_used_mask to pointer
> append cpumask_size() bytes after 'stat' to hold cpumask
>
> cpumask APIs like cpumask_next and cpumask_set_cpu never access
> bits beyond cpu count, cpumask_size() bytes of memory is enough
>
> Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
> ---
>  net/openvswitch/flow.c       | 8 +++++---
>  net/openvswitch/flow.h       | 2 +-
>  net/openvswitch/flow_table.c | 8 +++++---
>  3 files changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> index e20d1a973417..0109a5f86f6a 100644
> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -107,7 +107,7 @@ void ovs_flow_stats_update(struct sw_flow *flow, __=
be16 tcp_flags,
>
>  					rcu_assign_pointer(flow->stats[cpu],
>  							   new_stats);
> -					cpumask_set_cpu(cpu, &flow->cpu_used_mask);
> +					cpumask_set_cpu(cpu, flow->cpu_used_mask);
>  					goto unlock;
>  				}
>  			}
> @@ -135,7 +135,8 @@ void ovs_flow_stats_get(const struct sw_flow *flow,=

>  	memset(ovs_stats, 0, sizeof(*ovs_stats));
>
>  	/* We open code this to make sure cpu 0 is always considered */
> -	for (cpu =3D 0; cpu < nr_cpu_ids; cpu =3D cpumask_next(cpu, &flow->cp=
u_used_mask)) {
> +	for (cpu =3D 0; cpu < nr_cpu_ids;
> +	     cpu =3D cpumask_next(cpu, flow->cpu_used_mask)) {
>  		struct sw_flow_stats *stats =3D rcu_dereference_ovsl(flow->stats[cpu=
]);
>
>  		if (stats) {
> @@ -159,7 +160,8 @@ void ovs_flow_stats_clear(struct sw_flow *flow)
>  	int cpu;
>
>  	/* We open code this to make sure cpu 0 is always considered */
> -	for (cpu =3D 0; cpu < nr_cpu_ids; cpu =3D cpumask_next(cpu, &flow->cp=
u_used_mask)) {
> +	for (cpu =3D 0; cpu < nr_cpu_ids;
> +	     cpu =3D cpumask_next(cpu, flow->cpu_used_mask)) {
>  		struct sw_flow_stats *stats =3D ovsl_dereference(flow->stats[cpu]);
>
>  		if (stats) {
> diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
> index 073ab73ffeaa..b5711aff6e76 100644
> --- a/net/openvswitch/flow.h
> +++ b/net/openvswitch/flow.h
> @@ -229,7 +229,7 @@ struct sw_flow {
>  					 */
>  	struct sw_flow_key key;
>  	struct sw_flow_id id;
> -	struct cpumask cpu_used_mask;
> +	struct cpumask *cpu_used_mask;
>  	struct sw_flow_mask *mask;
>  	struct sw_flow_actions __rcu *sf_acts;
>  	struct sw_flow_stats __rcu *stats[]; /* One for each CPU.  First one
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.=
c
> index 0a0e4c283f02..dc6a174c3194 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -87,11 +87,12 @@ struct sw_flow *ovs_flow_alloc(void)
>  	if (!stats)
>  		goto err;
>
> +	flow->cpu_used_mask =3D (struct cpumask *)&flow->stats[nr_cpu_ids];
>  	spin_lock_init(&stats->lock);
>
>  	RCU_INIT_POINTER(flow->stats[0], stats);
>
> -	cpumask_set_cpu(0, &flow->cpu_used_mask);
> +	cpumask_set_cpu(0, flow->cpu_used_mask);
>
>  	return flow;
>  err:
> @@ -115,7 +116,7 @@ static void flow_free(struct sw_flow *flow)
>  					  flow->sf_acts);
>  	/* We open code this to make sure cpu 0 is always considered */
>  	for (cpu =3D 0; cpu < nr_cpu_ids;
> -	     cpu =3D cpumask_next(cpu, &flow->cpu_used_mask)) {
> +	     cpu =3D cpumask_next(cpu, flow->cpu_used_mask)) {
>  		if (flow->stats[cpu])
>  			kmem_cache_free(flow_stats_cache,
>  					(struct sw_flow_stats __force *)flow->stats[cpu]);
> @@ -1196,7 +1197,8 @@ int ovs_flow_init(void)
>
>  	flow_cache =3D kmem_cache_create("sw_flow", sizeof(struct sw_flow)
>  				       + (nr_cpu_ids
> -					  * sizeof(struct sw_flow_stats *)),
> +					  * sizeof(struct sw_flow_stats *))
> +				       + cpumask_size(),
>  				       0, 0, NULL);
>  	if (flow_cache =3D=3D NULL)
>  		return -ENOMEM;
> -- =

> 2.27.0
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

