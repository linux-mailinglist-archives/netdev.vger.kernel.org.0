Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CFC67308C
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjASEsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjASErB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:47:01 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED946F8B0;
        Wed, 18 Jan 2023 20:42:43 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id f3so602075pgc.2;
        Wed, 18 Jan 2023 20:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=STVqEc7oOl+QVpUn9b+9qaeBSKQO6FlmyaaPl+RgL4Q=;
        b=Pxxw8kKb5YIXyBuMissBWQUeo7EwpkiHMZHprxSztbbEj8/qlirEjVBm51YNhtlbrB
         5c+6XeKBxQwRrpGjIq/PxzXRl/ELjYPCltODE8ecMYDUtAxMlaYFDITm2DpmS0oXrQHN
         Ue9IXu+pwbcZ3EmMcqSE/FBC2JLOAoAdzZil24dgtyaTMcc6KnAEiPLpGq0B5tsiHVZX
         B+5c5e0jf6BDwu7sANWnF7Bl2YROHWwxfLPF2C3raHSaRBFBnF7OuOvPePrq/wwpHoxs
         zFzO6D0HjNqU8AgK5WR07ipoAHU3zExEW50vfnLk2cjUNajGLGsAgGUwHXSiOmFWqZ8p
         +QGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STVqEc7oOl+QVpUn9b+9qaeBSKQO6FlmyaaPl+RgL4Q=;
        b=wNnj5qMy0l6ROals1vHEWXjH4/E3Pa/TH/PjPexkMP3F4vhGKlrm97dKPunuKGSDie
         n6Ja04BVFKM77zvdPYteSahByG1DjnKoJ968qJz7kKwYj2UFl4gh3LVVELv62lV/CwkQ
         7IPUlQsSwln6ZU57Fu6DeAhO7igR+GJExk0p4AlK1kdWC5X5QbMOyO9K+LF2zpkqVMWr
         2vW43fO8izkp0BiV9V8FKErpKKJ0jP1ar83WsAMmp5a2zEnhKm7Fbsvftdf3GrR3M66m
         qL3GfA4bVmdA9VMXjov3mXwSif+EVgbzaAAXVwccv2UrwiC63eDw6iDdvokmltXHCMxP
         /RMg==
X-Gm-Message-State: AFqh2krobjFhBLaYH8gBAM+PuhOAufNqJPwwWA2M52AUsixOWg41GSY5
        F7FnLO7Yk1ipsk6DOeTppUDRF0dSG5SheQ==
X-Google-Smtp-Source: AMrXdXsbBa0dkoyKmb42VEar7z2m+r0ArpOLThqZi2hj9xqEoxM52duh1OERLdrh4iiRe+hK15ji2Q==
X-Received: by 2002:a05:6830:13d1:b0:686:5862:ff8c with SMTP id e17-20020a05683013d100b006865862ff8cmr2204306otq.1.1674101928623;
        Wed, 18 Jan 2023 20:18:48 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:3243:26ee:68de:6577:af10])
        by smtp.gmail.com with ESMTPSA id bs1-20020a056830398100b00660e833baddsm19409345otb.29.2023.01.18.20.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 20:18:48 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 8626C4ADF5E; Thu, 19 Jan 2023 01:18:46 -0300 (-03)
Date:   Thu, 19 Jan 2023 01:18:46 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 6/7] net/sched: act_ct: offload UDP NEW
 connections
Message-ID: <Y8jEpg+8KSxTLFPF@t14s.localdomain>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-7-vladbu@nvidia.com>
 <Y8bBs4668C9r5oTT@t14s.localdomain>
 <871qntcb14.fsf@nvidia.com>
 <Y8bhMMvqylw+TbZv@t14s.localdomain>
 <87sfg9as10.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfg9as10.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 09:12:26PM +0200, Vlad Buslov wrote:
> On Tue 17 Jan 2023 at 14:56, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > On Tue, Jan 17, 2023 at 07:36:42PM +0200, Vlad Buslov wrote:
> >> 
> >> On Tue 17 Jan 2023 at 12:41, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> >> > On Fri, Jan 13, 2023 at 05:55:47PM +0100, Vlad Buslov wrote:
> >> >> When processing connections allow offloading of UDP connections that don't
> >> >> have IPS_ASSURED_BIT set as unidirectional. When performing table lookup
> >> >
> >> > Hmm. Considering that this is now offloading one direction only
> >> > already, what about skipping this grace period:
> >> >
> >> > In nf_conntrack_udp_packet(), it does:
> >> >
> >> >         /* If we've seen traffic both ways, this is some kind of UDP
> >> >          * stream. Set Assured.
> >> >          */
> >> >         if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
> >> > 		...
> >> >                 /* Still active after two seconds? Extend timeout. */
> >> >                 if (time_after(jiffies, ct->proto.udp.stream_ts)) {
> >> >                         extra = timeouts[UDP_CT_REPLIED];
> >> >                         stream = true;
> >> >                 }
> >> > 		...
> >> >                 /* Also, more likely to be important, and not a probe */
> >> >                 if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
> >> >                         nf_conntrack_event_cache(IPCT_ASSURED, ct);
> >> >
> >> > Maybe the patch should be relying on IPS_SEEN_REPLY_BIT instead of
> >> > ASSURED for UDP? Just a thought here, but I'm not seeing why not.
> >> 
> >> The issue with this is that if we offload both directions early, then
> >> conntrack state machine will not receive any more packets and,
> >> consecutively, will never change the flow state to assured. I guess that
> >
> > I'm missing how it would offload each direction independently.
> > Wouldn't CT state machine see the 1st reply, because it is not
> > offloaded yet, and match it to the original direction?
> 

(ok, better reply this too instead of radio silence)

> What I meant is that if both directions are offloaded as soon as
> IPS_SEEN_REPLY_BIT is set, then nf_conntrack_udp_packet() will not be
> called for that connection anymore and would never be able to transition
> the connection to assured state. But main thing is, as I said in the

Oh, right!

> previous reply, that we don't need to offload such connection ATM. It
> could be done in a follow-up if there is a use-case for it, maybe even
> made somehow configurable (with BPF! :)), so it could be dynamically
> controlled.
> 
> >
> >> could be mitigated somehow by periodically checking the hw stats and
> >> transitioning the flow to assured based on them, but as I said in
> >> previous email we don't want to over-complicate this series even more.
> >> Also, offloading to hardware isn't free and costs both memory and CPU,
> >> so it is not like offloading as early as possible is strictly beneficial
> >> for all cases...
> >
> > Yup.
> >
> >> 
> >> >
> >> >> for reply packets check the current connection status: If UDP
> >> >> unidirectional connection became assured also promote the corresponding
> >> >> flow table entry to bidirectional and set the 'update' bit, else just set
> >> >> the 'update' bit since reply directional traffic will most likely cause
> >> >> connection status to become 'established' which requires updating the
> >> >> offload state.
> >> >> 
> >> >> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> >> >> ---
> >> >>  net/sched/act_ct.c | 48 ++++++++++++++++++++++++++++++++++------------
> >> >>  1 file changed, 36 insertions(+), 12 deletions(-)
> >> >> 
> >> >> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> >> >> index bfddb462d2bc..563cbdd8341c 100644
> >> >> --- a/net/sched/act_ct.c
> >> >> +++ b/net/sched/act_ct.c
> >> >> @@ -369,7 +369,7 @@ static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
> >> >>  
> >> >>  static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
> >> >>  				  struct nf_conn *ct,
> >> >> -				  bool tcp)
> >> >> +				  bool tcp, bool bidirectional)
> >> >>  {
> >> >>  	struct nf_conn_act_ct_ext *act_ct_ext;
> >> >>  	struct flow_offload *entry;
> >> >> @@ -388,6 +388,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
> >> >>  		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
> >> >>  		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
> >> >>  	}
> >> >> +	if (bidirectional)
> >> >> +		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &entry->flags);
> >> >>  
> >> >>  	act_ct_ext = nf_conn_act_ct_ext_find(ct);
> >> >>  	if (act_ct_ext) {
> >> >> @@ -411,26 +413,34 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
> >> >>  					   struct nf_conn *ct,
> >> >>  					   enum ip_conntrack_info ctinfo)
> >> >>  {
> >> >> -	bool tcp = false;
> >> >> -
> >> >> -	if ((ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY) ||
> >> >> -	    !test_bit(IPS_ASSURED_BIT, &ct->status))
> >> >> -		return;
> >> >> +	bool tcp = false, bidirectional = true;
> >> >>  
> >> >>  	switch (nf_ct_protonum(ct)) {
> >> >>  	case IPPROTO_TCP:
> >> >> -		tcp = true;
> >> >> -		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
> >> >> +		if ((ctinfo != IP_CT_ESTABLISHED &&
> >> >> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
> >> >> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
> >> >> +		    ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
> >> >>  			return;
> >> >> +
> >> >> +		tcp = true;
> >> >>  		break;
> >> >>  	case IPPROTO_UDP:
> >> >> +		if (!nf_ct_is_confirmed(ct))
> >> >> +			return;
> >> >> +		if (!test_bit(IPS_ASSURED_BIT, &ct->status))
> >> >> +			bidirectional = false;
> >> >>  		break;
> >> >>  #ifdef CONFIG_NF_CT_PROTO_GRE
> >> >>  	case IPPROTO_GRE: {
> >> >>  		struct nf_conntrack_tuple *tuple;
> >> >>  
> >> >> -		if (ct->status & IPS_NAT_MASK)
> >> >> +		if ((ctinfo != IP_CT_ESTABLISHED &&
> >> >> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
> >> >> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
> >> >> +		    ct->status & IPS_NAT_MASK)
> >> >>  			return;
> >> >> +
> >> >>  		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
> >> >>  		/* No support for GRE v1 */
> >> >>  		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
> >> >> @@ -446,7 +456,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
> >> >>  	    ct->status & IPS_SEQ_ADJUST)
> >> >>  		return;
> >> >>  
> >> >> -	tcf_ct_flow_table_add(ct_ft, ct, tcp);
> >> >> +	tcf_ct_flow_table_add(ct_ft, ct, tcp, bidirectional);
> >> >>  }
> >> >>  
> >> >>  static bool
> >> >> @@ -625,13 +635,27 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
> >> >>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> >> >>  	ct = flow->ct;
> >> >>  
> >> >> +	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
> >> >> +	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
> >> >> +		/* Only offload reply direction after connection became
> >> >> +		 * assured.
> >> >> +		 */
> >> >> +		if (test_bit(IPS_ASSURED_BIT, &ct->status))
> >> >> +			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
> >> >> +		set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
> >> >> +		return false;
> >> >> +	}
> >> >> +
> >> >>  	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
> >> >>  		flow_offload_teardown(flow);
> >> >>  		return false;
> >> >>  	}
> >> >>  
> >> >> -	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
> >> >> -						    IP_CT_ESTABLISHED_REPLY;
> >> >> +	if (dir == FLOW_OFFLOAD_DIR_ORIGINAL)
> >> >> +		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
> >> >> +			IP_CT_ESTABLISHED : IP_CT_NEW;
> >> >> +	else
> >> >> +		ctinfo = IP_CT_ESTABLISHED_REPLY;
> >> >>  
> >> >>  	flow_offload_refresh(nf_ft, flow);
> >> >>  	nf_conntrack_get(&ct->ct_general);
> >> >> -- 
> >> >> 2.38.1
> >> >> 
> >> 
> 
