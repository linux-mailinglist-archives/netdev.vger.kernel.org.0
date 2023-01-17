Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F53B66E57F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjAQSAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjAQR47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:56:59 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622FD521CF;
        Tue, 17 Jan 2023 09:47:57 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-15eec491b40so11820455fac.12;
        Tue, 17 Jan 2023 09:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ni99ePUt0vzhCDQEc2vcK8aOMav7LfPyZHSW24Ez63s=;
        b=L4CERME+NHxYyqNwqbFe6tRfSn/ojOSZ7sa0VZF0em849hDV4zqBO1vj0a+VOrMuCZ
         G2bRnm1Kgi30nSHZL+LcuoB7/ViLbTxIOKHjKGa1BnbmDRALV2PUgNoXcbRLyfpNzWPW
         tTi99Qe+LTNu/wnnke0MdAcxVhGQ2ZDTtzvUqKXWgV9FhPeif92xnP8OrJffjGaoqwXC
         vli3OvFF79pmqP6eIj/YbHgoWUaNrMI98J6mjidTP/PAkaaJLv39OO7A34z/n8BDFWHf
         eM6NWAJSktQKvV26CbGQkm6H24Dab15Ne7FYG9OQcTnsUFkhWk1klP9KGnSKlGWPbZGh
         rm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ni99ePUt0vzhCDQEc2vcK8aOMav7LfPyZHSW24Ez63s=;
        b=V3/gWJTzGpqADqfPnQSbZGZO8CnUujViyqdpisx97FGjGe+TNJn2DTJPKMo0gyGeFs
         ow/QAxCQ9fQg0tKZs+CXH/KBqdffLsZwapojVTI1m4VJQ6s95MGu/HdNjj//13t+7F/r
         jtHfIwx2U0vGYEO3wIRSeem2sj+QNKyN+ov/htAK98e451gPM1O3oAVdzHUO0A+xA9s8
         BkC2N2XiNvmlomkA2WtRf3AiCJBcb+PxakneEJaiZDHyw8+7yDitTlqI2jcEDNk/5xqw
         dyl7+8GAtpgkDbr7KgvAHVoFUqUD1K8n2aH528O4/OpjR1blmSnF90UwqqCA6Tvss7YE
         6wwQ==
X-Gm-Message-State: AFqh2krpj95c2MryA4q9Wz5ucUInMWC/E+UoCy79CsY4wmO9to99ojfE
        IDxoopGWHgAsayaEv8nmQno=
X-Google-Smtp-Source: AMrXdXszJzyenKu3zOnAH9lqAnrj7r4bO5158pguBWScVUuv89j/yR+4vdbMb1crOtGqUUFNluO8OQ==
X-Received: by 2002:a05:6870:8c2c:b0:15f:385c:a94e with SMTP id ec44-20020a0568708c2c00b0015f385ca94emr1868748oab.43.1673977676529;
        Tue, 17 Jan 2023 09:47:56 -0800 (PST)
Received: from t14s.localdomain ([177.220.174.155])
        by smtp.gmail.com with ESMTPSA id q187-20020a4a4bc4000000b004a3c359fdaesm15282820ooa.30.2023.01.17.09.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 09:47:56 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 2C4734AD246; Tue, 17 Jan 2023 14:47:54 -0300 (-03)
Date:   Tue, 17 Jan 2023 14:47:54 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 4/7] netfilter: flowtable: allow updating
 offloaded rules asynchronously
Message-ID: <Y8bfSksS/29SgkPJ@t14s.localdomain>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-5-vladbu@nvidia.com>
 <Y8a+qBjcr7KuPf+e@t14s.localdomain>
 <875yd5cbcl.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yd5cbcl.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 07:33:31PM +0200, Vlad Buslov wrote:
> 
> On Tue 17 Jan 2023 at 12:28, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > On Fri, Jan 13, 2023 at 05:55:45PM +0100, Vlad Buslov wrote:
> >> Following patches in series need to update flowtable rule several times
> >> during its lifetime in order to synchronize hardware offload with actual ct
> >> status. However, reusing existing 'refresh' logic in act_ct would cause
> >> data path to potentially schedule significant amount of spurious tasks in
> >> 'add' workqueue since it is executed per-packet. Instead, introduce a new
> >> flow 'update' flag and use it to schedule async flow refresh in flowtable
> >> gc which will only be executed once per gc iteration.
> >> 
> >> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> >> ---
> >>  include/net/netfilter/nf_flow_table.h |  3 ++-
> >>  net/netfilter/nf_flow_table_core.c    | 20 +++++++++++++++-----
> >>  net/netfilter/nf_flow_table_offload.c |  5 +++--
> >>  3 files changed, 20 insertions(+), 8 deletions(-)
> >> 
> >> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> >> index 88ab98ab41d9..e396424e2e68 100644
> >> --- a/include/net/netfilter/nf_flow_table.h
> >> +++ b/include/net/netfilter/nf_flow_table.h
> >> @@ -165,6 +165,7 @@ enum nf_flow_flags {
> >>  	NF_FLOW_HW_DEAD,
> >>  	NF_FLOW_HW_PENDING,
> >>  	NF_FLOW_HW_BIDIRECTIONAL,
> >> +	NF_FLOW_HW_UPDATE,
> >>  };
> >>  
> >>  enum flow_offload_type {
> >> @@ -300,7 +301,7 @@ unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
> >>  #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
> >>  	MODULE_ALIAS("nf-flowtable-" __stringify(family))
> >>  
> >> -void nf_flow_offload_add(struct nf_flowtable *flowtable,
> >> +bool nf_flow_offload_add(struct nf_flowtable *flowtable,
> >>  			 struct flow_offload *flow);
> >>  void nf_flow_offload_del(struct nf_flowtable *flowtable,
> >>  			 struct flow_offload *flow);
> >> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> >> index 04bd0ed4d2ae..5b495e768655 100644
> >> --- a/net/netfilter/nf_flow_table_core.c
> >> +++ b/net/netfilter/nf_flow_table_core.c
> >> @@ -316,21 +316,28 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
> >>  }
> >>  EXPORT_SYMBOL_GPL(flow_offload_add);
> >>  
> >> +static bool __flow_offload_refresh(struct nf_flowtable *flow_table,
> >> +				   struct flow_offload *flow)
> >> +{
> >> +	if (likely(!nf_flowtable_hw_offload(flow_table)))
> >> +		return true;
> >> +
> >> +	return nf_flow_offload_add(flow_table, flow);
> >> +}
> >> +
> >>  void flow_offload_refresh(struct nf_flowtable *flow_table,
> >>  			  struct flow_offload *flow)
> >>  {
> >>  	u32 timeout;
> >>  
> >>  	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
> >> -	if (timeout - READ_ONCE(flow->timeout) > HZ)
> >> +	if (timeout - READ_ONCE(flow->timeout) > HZ &&
> >> +	    !test_bit(NF_FLOW_HW_UPDATE, &flow->flags))
> >>  		WRITE_ONCE(flow->timeout, timeout);
> >>  	else
> >>  		return;
> >>  
> >> -	if (likely(!nf_flowtable_hw_offload(flow_table)))
> >> -		return;
> >> -
> >> -	nf_flow_offload_add(flow_table, flow);
> >> +	__flow_offload_refresh(flow_table, flow);
> >>  }
> >>  EXPORT_SYMBOL_GPL(flow_offload_refresh);
> >>  
> >> @@ -435,6 +442,9 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
> >>  		} else {
> >>  			flow_offload_del(flow_table, flow);
> >>  		}
> >> +	} else if (test_and_clear_bit(NF_FLOW_HW_UPDATE, &flow->flags)) {
> >> +		if (!__flow_offload_refresh(flow_table, flow))
> >> +			set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
> >>  	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
> >>  		nf_flow_offload_stats(flow_table, flow);
> >
> > AFAICT even after this patchset it is possible to have both flags set
> > at the same time.
> > With that, this would cause the stats to skip a beat.
> > This would be better:
> >
> > - 	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
> > - 		nf_flow_offload_stats(flow_table, flow);
> > +	} else {
> > +		if (test_and_clear_bit(NF_FLOW_HW_UPDATE, &flow->flags))
> > +			if (!__flow_offload_refresh(flow_table, flow))
> > +				set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
> > +	 	if (test_bit(NF_FLOW_HW, &flow->flags))
> > + 			nf_flow_offload_stats(flow_table, flow);
> >  	}
> >
> > But a flow cannot have 2 pending actions at a time.
> 
> Yes. And timeouts are quite generous so there is IMO no problem in
> skipping one iteration. It is not like this wq is high priority and we
> can guarantee any exact update interval here anyway.

I cannot disagree, lets say :-)

Perhaps I'm just over worried because of recent issues with ovs and
datapath flows, that it was evicting them because it saw no traffic in
5s and so.

For example,
Subject: [ovs-dev] [PATCH v3] ofproto-dpif-upcall: Wait for valid hw flow stats before applying min-revalidate-pps

And we're still chasing a stall in ovs revalidator that leads to
hicups in datapath stats periodicity.

Yet, I'm not aware of such checks on top of CT entries.

> 
> > Then maybe an update to nf_flow_offload_tuple() to make it handle the
> > stats implicitly?
> 
> I considered this, but didn't want to over-complicate this series which
> is tricky enough as it is.

Makes sense.

> 
> >
> >>  	}
> >> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> >> index 8b852f10fab4..103b2ca8d123 100644
> >> --- a/net/netfilter/nf_flow_table_offload.c
> >> +++ b/net/netfilter/nf_flow_table_offload.c
> >> @@ -1036,16 +1036,17 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
> >>  }
> >>  
> >>  
> >> -void nf_flow_offload_add(struct nf_flowtable *flowtable,
> >> +bool nf_flow_offload_add(struct nf_flowtable *flowtable,
> >>  			 struct flow_offload *flow)
> >>  {
> >>  	struct flow_offload_work *offload;
> >>  
> >>  	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
> >>  	if (!offload)
> >> -		return;
> >> +		return false;
> >>  
> >>  	flow_offload_queue_work(offload);
> >> +	return true;
> >>  }
> >>  
> >>  void nf_flow_offload_del(struct nf_flowtable *flowtable,
> >> -- 
> >> 2.38.1
> >> 
> 
