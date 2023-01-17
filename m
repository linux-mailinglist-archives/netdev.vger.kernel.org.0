Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0466E290
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjAQPol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjAQPoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:44:10 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF5249039;
        Tue, 17 Jan 2023 07:41:42 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id i26-20020a9d68da000000b00672301a1664so18053267oto.6;
        Tue, 17 Jan 2023 07:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zvL7hIBxgVvR/E5BtO5sPB4duDHNw1BnGZMphT+CLnA=;
        b=LcPGYq/bOZUcBCAf3MQq1WQAuiBJwvVIKSWaZ4aQdtBqhNLL8QF49fVFNLbL205K2z
         nXOalfH6ymRG0jOZCm8pBYEvFCnJc5iD1IekBxuEC7jn++8WAlm6/+9TSxnqiOCM7Zru
         THj9jRj2RzcC4Ql2SQuwxTXF7zBEgNpWqadgqxzl110kUbarXOb0SHxlDCz9pknCk4dy
         9ldUYWKRhRAAVd/HeykQ91P1ndWZ9qNmF4gHEIrEbXd6UZgcdd9FVSIUhm1WPH7NX7wk
         CiX7NmCAcrIYm7n9tLeQ0Z07ni+o35dGjHFOmIb0xDKR12R8chcRpB1psOnaRI4n5q6i
         Ckmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvL7hIBxgVvR/E5BtO5sPB4duDHNw1BnGZMphT+CLnA=;
        b=SY7egv+xe7B5A/tC/PoFR0UamopQobPPi6SnxHMdUxOn40M7+G2T81zYoxZBHckNNo
         JDQQGtj3SnhgbqH+AWXAT3YxprE3HArQaYyaXU4EApH0qAf9ksVs9mCMvxXwROLn0HS5
         tCsfqtN9K7CEEBaC7S22qg8nP+N+0WAFFGoTx4QcIE6gqS+Dl6JDO2Iao/mbDv5XrEM0
         SrzIzHDTr+XW2vsejd5Y86nj+2siq1+FAlwbVLneP6BIhw9LDvnfQryNDy9TVNoipkRg
         t8N7+EW6T4neXeMoax6Eq9euqFLg0oXpkDTIblfG+6LcLkDa8eqPUKDMSkEEnITADSpg
         sN8g==
X-Gm-Message-State: AFqh2kppInYU4nHpjjm+UBLAgf49FQegltN+QTY1Qq33yaUJ/1e78OJw
        p+7UtBX1cXW+C0py80ScjAE=
X-Google-Smtp-Source: AMrXdXuOKFRuxoUhczkyMsmYrWFPzH7udu2WUiq8h1zxgrdsS65iefWr9uC9l1JsR1P4YV/8eBO2ZQ==
X-Received: by 2002:a9d:4b18:0:b0:66e:c096:126c with SMTP id q24-20020a9d4b18000000b0066ec096126cmr1415556otf.29.1673970101435;
        Tue, 17 Jan 2023 07:41:41 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:7189:754f:dfa5:a770:f05f])
        by smtp.gmail.com with ESMTPSA id i9-20020a9d6109000000b0066c3bbe927esm16697157otj.21.2023.01.17.07.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 07:41:41 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 749984AD211; Tue, 17 Jan 2023 12:41:39 -0300 (-03)
Date:   Tue, 17 Jan 2023 12:41:39 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 6/7] net/sched: act_ct: offload UDP NEW
 connections
Message-ID: <Y8bBs4668C9r5oTT@t14s.localdomain>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-7-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113165548.2692720-7-vladbu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 05:55:47PM +0100, Vlad Buslov wrote:
> When processing connections allow offloading of UDP connections that don't
> have IPS_ASSURED_BIT set as unidirectional. When performing table lookup

Hmm. Considering that this is now offloading one direction only
already, what about skipping this grace period:

In nf_conntrack_udp_packet(), it does:

        /* If we've seen traffic both ways, this is some kind of UDP
         * stream. Set Assured.
         */
        if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
		...
                /* Still active after two seconds? Extend timeout. */
                if (time_after(jiffies, ct->proto.udp.stream_ts)) {
                        extra = timeouts[UDP_CT_REPLIED];
                        stream = true;
                }
		...
                /* Also, more likely to be important, and not a probe */
                if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
                        nf_conntrack_event_cache(IPCT_ASSURED, ct);

Maybe the patch should be relying on IPS_SEEN_REPLY_BIT instead of
ASSURED for UDP? Just a thought here, but I'm not seeing why not.

> for reply packets check the current connection status: If UDP
> unidirectional connection became assured also promote the corresponding
> flow table entry to bidirectional and set the 'update' bit, else just set
> the 'update' bit since reply directional traffic will most likely cause
> connection status to become 'established' which requires updating the
> offload state.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> ---
>  net/sched/act_ct.c | 48 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index bfddb462d2bc..563cbdd8341c 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -369,7 +369,7 @@ static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
>  
>  static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>  				  struct nf_conn *ct,
> -				  bool tcp)
> +				  bool tcp, bool bidirectional)
>  {
>  	struct nf_conn_act_ct_ext *act_ct_ext;
>  	struct flow_offload *entry;
> @@ -388,6 +388,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>  		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
>  		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
>  	}
> +	if (bidirectional)
> +		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &entry->flags);
>  
>  	act_ct_ext = nf_conn_act_ct_ext_find(ct);
>  	if (act_ct_ext) {
> @@ -411,26 +413,34 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>  					   struct nf_conn *ct,
>  					   enum ip_conntrack_info ctinfo)
>  {
> -	bool tcp = false;
> -
> -	if ((ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY) ||
> -	    !test_bit(IPS_ASSURED_BIT, &ct->status))
> -		return;
> +	bool tcp = false, bidirectional = true;
>  
>  	switch (nf_ct_protonum(ct)) {
>  	case IPPROTO_TCP:
> -		tcp = true;
> -		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
> +		if ((ctinfo != IP_CT_ESTABLISHED &&
> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
> +		    ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
>  			return;
> +
> +		tcp = true;
>  		break;
>  	case IPPROTO_UDP:
> +		if (!nf_ct_is_confirmed(ct))
> +			return;
> +		if (!test_bit(IPS_ASSURED_BIT, &ct->status))
> +			bidirectional = false;
>  		break;
>  #ifdef CONFIG_NF_CT_PROTO_GRE
>  	case IPPROTO_GRE: {
>  		struct nf_conntrack_tuple *tuple;
>  
> -		if (ct->status & IPS_NAT_MASK)
> +		if ((ctinfo != IP_CT_ESTABLISHED &&
> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
> +		    ct->status & IPS_NAT_MASK)
>  			return;
> +
>  		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
>  		/* No support for GRE v1 */
>  		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
> @@ -446,7 +456,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>  	    ct->status & IPS_SEQ_ADJUST)
>  		return;
>  
> -	tcf_ct_flow_table_add(ct_ft, ct, tcp);
> +	tcf_ct_flow_table_add(ct_ft, ct, tcp, bidirectional);
>  }
>  
>  static bool
> @@ -625,13 +635,27 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>  	ct = flow->ct;
>  
> +	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
> +	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
> +		/* Only offload reply direction after connection became
> +		 * assured.
> +		 */
> +		if (test_bit(IPS_ASSURED_BIT, &ct->status))
> +			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
> +		set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
> +		return false;
> +	}
> +
>  	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
>  		flow_offload_teardown(flow);
>  		return false;
>  	}
>  
> -	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
> -						    IP_CT_ESTABLISHED_REPLY;
> +	if (dir == FLOW_OFFLOAD_DIR_ORIGINAL)
> +		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
> +			IP_CT_ESTABLISHED : IP_CT_NEW;
> +	else
> +		ctinfo = IP_CT_ESTABLISHED_REPLY;
>  
>  	flow_offload_refresh(nf_ft, flow);
>  	nf_conntrack_get(&ct->ct_general);
> -- 
> 2.38.1
> 
