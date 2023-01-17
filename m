Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714DD66E5DF
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjAQSUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbjAQSQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:16:36 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C88013D7B;
        Tue, 17 Jan 2023 09:56:03 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-15ed38a9b04so14139503fac.8;
        Tue, 17 Jan 2023 09:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9IlUKtg67WFHhkdxrMspMIs9DEEubADNV/QnJwEw5iM=;
        b=BH1H8e0iFd3U3lGNKZ65Wthjuj/KzQEC78iWPew2JknalpEOniWZPecgkSmTctf+0U
         YFUKzdiycyrUYcVvJFg1l/jXwTPcanaXxiIgQPovXBGgJXV6w9FhTRFgb4ajeNHT3PaC
         dhzIBeLXCxt8idgPtSv93pF6qRfduYGGyRLWpgsPLdjJn/Egl7zOQJXjKXEXhtze9zl8
         S+tEuTFgtNOdoOGf0CHKFXXKqTqPzLcAImYjgfY4KAyXoRs+9GfYiIblmxRDhrIvVJm+
         3QSn8Ff3fRwob+/IMc8TPIqIwEGBafGVt+uYeycWDF2dQKVPSfrLoH4j0aL359fliTBu
         au+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9IlUKtg67WFHhkdxrMspMIs9DEEubADNV/QnJwEw5iM=;
        b=2SJX2HuEVLJWU7vjCWP/MwZ/gdtJMJF0phVW5uGX+QxEwaMYRch9Hd54ySIv1nnSOc
         SZuTPjKEFxJdMzTt1ckSGxmzn670chxr96sx+Jcn0w1P2aGmQr8jZWTY7fn4ccpfx6OI
         C1GOAcpuMiywk6+8u3V9nJbyzbtMfsv9QAXi4M8SHp3ic8KxUVjrbM/BQbeWT9nSfCJH
         FbpBtnKzPiPKDMNAzJf12RZEddg0L9iAWAFf0cv/gIdthIZ0ohN+iCD1cSvV3Tw7hxvT
         M6rhIhj3jo1RGrfcO6G1MpXVy6B7TCw8zim47nMeCqBJ5BtR0Z82yVdwVmZ5NbV/y/eS
         O4dQ==
X-Gm-Message-State: AFqh2kp9SVSGOJoT0RY7efoh8HxUkYPZOQKkQC4zuel7WPC5FkrFwBsN
        xx7AujD9iDVJQWwnQFY6I7M=
X-Google-Smtp-Source: AMrXdXshPEuudK8JIYcvtVdyDSVORV3+AIYWbvq0bK5Na6Isk7jUsaLdczkrngYtOtKrlfLsDUb9EA==
X-Received: by 2002:a05:6870:970f:b0:150:c89a:cc23 with SMTP id n15-20020a056870970f00b00150c89acc23mr14579259oaq.59.1673978162505;
        Tue, 17 Jan 2023 09:56:02 -0800 (PST)
Received: from t14s.localdomain ([177.220.174.155])
        by smtp.gmail.com with ESMTPSA id fp18-20020a056870659200b0010d7242b623sm13114771oab.21.2023.01.17.09.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 09:56:02 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 610C44AD24E; Tue, 17 Jan 2023 14:56:00 -0300 (-03)
Date:   Tue, 17 Jan 2023 14:56:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 6/7] net/sched: act_ct: offload UDP NEW
 connections
Message-ID: <Y8bhMMvqylw+TbZv@t14s.localdomain>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-7-vladbu@nvidia.com>
 <Y8bBs4668C9r5oTT@t14s.localdomain>
 <871qntcb14.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qntcb14.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 07:36:42PM +0200, Vlad Buslov wrote:
> 
> On Tue 17 Jan 2023 at 12:41, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > On Fri, Jan 13, 2023 at 05:55:47PM +0100, Vlad Buslov wrote:
> >> When processing connections allow offloading of UDP connections that don't
> >> have IPS_ASSURED_BIT set as unidirectional. When performing table lookup
> >
> > Hmm. Considering that this is now offloading one direction only
> > already, what about skipping this grace period:
> >
> > In nf_conntrack_udp_packet(), it does:
> >
> >         /* If we've seen traffic both ways, this is some kind of UDP
> >          * stream. Set Assured.
> >          */
> >         if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
> > 		...
> >                 /* Still active after two seconds? Extend timeout. */
> >                 if (time_after(jiffies, ct->proto.udp.stream_ts)) {
> >                         extra = timeouts[UDP_CT_REPLIED];
> >                         stream = true;
> >                 }
> > 		...
> >                 /* Also, more likely to be important, and not a probe */
> >                 if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
> >                         nf_conntrack_event_cache(IPCT_ASSURED, ct);
> >
> > Maybe the patch should be relying on IPS_SEEN_REPLY_BIT instead of
> > ASSURED for UDP? Just a thought here, but I'm not seeing why not.
> 
> The issue with this is that if we offload both directions early, then
> conntrack state machine will not receive any more packets and,
> consecutively, will never change the flow state to assured. I guess that

I'm missing how it would offload each direction independently.
Wouldn't CT state machine see the 1st reply, because it is not
offloaded yet, and match it to the original direction?

> could be mitigated somehow by periodically checking the hw stats and
> transitioning the flow to assured based on them, but as I said in
> previous email we don't want to over-complicate this series even more.
> Also, offloading to hardware isn't free and costs both memory and CPU,
> so it is not like offloading as early as possible is strictly beneficial
> for all cases...

Yup.

> 
> >
> >> for reply packets check the current connection status: If UDP
> >> unidirectional connection became assured also promote the corresponding
> >> flow table entry to bidirectional and set the 'update' bit, else just set
> >> the 'update' bit since reply directional traffic will most likely cause
> >> connection status to become 'established' which requires updating the
> >> offload state.
> >> 
> >> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> >> ---
> >>  net/sched/act_ct.c | 48 ++++++++++++++++++++++++++++++++++------------
> >>  1 file changed, 36 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> >> index bfddb462d2bc..563cbdd8341c 100644
> >> --- a/net/sched/act_ct.c
> >> +++ b/net/sched/act_ct.c
> >> @@ -369,7 +369,7 @@ static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
> >>  
> >>  static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
> >>  				  struct nf_conn *ct,
> >> -				  bool tcp)
> >> +				  bool tcp, bool bidirectional)
> >>  {
> >>  	struct nf_conn_act_ct_ext *act_ct_ext;
> >>  	struct flow_offload *entry;
> >> @@ -388,6 +388,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
> >>  		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
> >>  		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
> >>  	}
> >> +	if (bidirectional)
> >> +		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &entry->flags);
> >>  
> >>  	act_ct_ext = nf_conn_act_ct_ext_find(ct);
> >>  	if (act_ct_ext) {
> >> @@ -411,26 +413,34 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
> >>  					   struct nf_conn *ct,
> >>  					   enum ip_conntrack_info ctinfo)
> >>  {
> >> -	bool tcp = false;
> >> -
> >> -	if ((ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY) ||
> >> -	    !test_bit(IPS_ASSURED_BIT, &ct->status))
> >> -		return;
> >> +	bool tcp = false, bidirectional = true;
> >>  
> >>  	switch (nf_ct_protonum(ct)) {
> >>  	case IPPROTO_TCP:
> >> -		tcp = true;
> >> -		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
> >> +		if ((ctinfo != IP_CT_ESTABLISHED &&
> >> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
> >> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
> >> +		    ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
> >>  			return;
> >> +
> >> +		tcp = true;
> >>  		break;
> >>  	case IPPROTO_UDP:
> >> +		if (!nf_ct_is_confirmed(ct))
> >> +			return;
> >> +		if (!test_bit(IPS_ASSURED_BIT, &ct->status))
> >> +			bidirectional = false;
> >>  		break;
> >>  #ifdef CONFIG_NF_CT_PROTO_GRE
> >>  	case IPPROTO_GRE: {
> >>  		struct nf_conntrack_tuple *tuple;
> >>  
> >> -		if (ct->status & IPS_NAT_MASK)
> >> +		if ((ctinfo != IP_CT_ESTABLISHED &&
> >> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
> >> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
> >> +		    ct->status & IPS_NAT_MASK)
> >>  			return;
> >> +
> >>  		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
> >>  		/* No support for GRE v1 */
> >>  		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
> >> @@ -446,7 +456,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
> >>  	    ct->status & IPS_SEQ_ADJUST)
> >>  		return;
> >>  
> >> -	tcf_ct_flow_table_add(ct_ft, ct, tcp);
> >> +	tcf_ct_flow_table_add(ct_ft, ct, tcp, bidirectional);
> >>  }
> >>  
> >>  static bool
> >> @@ -625,13 +635,27 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
> >>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> >>  	ct = flow->ct;
> >>  
> >> +	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
> >> +	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
> >> +		/* Only offload reply direction after connection became
> >> +		 * assured.
> >> +		 */
> >> +		if (test_bit(IPS_ASSURED_BIT, &ct->status))
> >> +			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
> >> +		set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
> >> +		return false;
> >> +	}
> >> +
> >>  	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
> >>  		flow_offload_teardown(flow);
> >>  		return false;
> >>  	}
> >>  
> >> -	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
> >> -						    IP_CT_ESTABLISHED_REPLY;
> >> +	if (dir == FLOW_OFFLOAD_DIR_ORIGINAL)
> >> +		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
> >> +			IP_CT_ESTABLISHED : IP_CT_NEW;
> >> +	else
> >> +		ctinfo = IP_CT_ESTABLISHED_REPLY;
> >>  
> >>  	flow_offload_refresh(nf_ft, flow);
> >>  	nf_conntrack_get(&ct->ct_general);
> >> -- 
> >> 2.38.1
> >> 
> 
