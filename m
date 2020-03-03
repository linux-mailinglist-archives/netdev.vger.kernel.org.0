Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6C2177C63
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbgCCQvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:51:18 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46706 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730115AbgCCQvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:51:17 -0500
Received: by mail-qt1-f194.google.com with SMTP id i14so3276220qtv.13
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 08:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YGueDV89b9DMztNI+tfef8S1yIsFn2K1W92G0MhgAqE=;
        b=f/SzZkh4iTKJuGfJyzibnoghGzgP6jKMrMLzpZPGnaysdvEi8YJ8op2Blh2kASBcaQ
         7xH/gR2TkSkgU7JvnkW/AdI2r8YgWn/mNl1YZt98y/hClXgu3PaQXyBn5AYPkKI5n/59
         IRUgD9ujh69nanSUmyj6BzyGyjsTyLuRzEuy0hWAZJa1/CB90hR30hESIuH2LIXdiN0C
         SxIhvd8QcwBXFQDD1IxwyhZKtXmEXReOFyOVQ6ArX9eKxdosayC+6r4b0lSXJDAvRgaQ
         If1hQhhArQtfqDQPnIv4GH4raNZ50Tvr1G70Ns1H4nycDVFwM+gbQsqq6QYq0Bdy74vT
         dTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YGueDV89b9DMztNI+tfef8S1yIsFn2K1W92G0MhgAqE=;
        b=MN8LLqNT2CZZB7fQRuIq2CiN2/ri60vNRt76PsY72ELSw7wQJFe9eXOEloGvoy00/P
         M80T+v6EXE2V5yIvteJqIu3YY8tZuBQcHXxrJ4JT6/xTPadEHlcVm3vRAwzgNZz4weFM
         iKURK0TvL0B3wsSwULsxCNmccvLUua8yAWQhl2/JgTbPzNE9BxeJRmO9PvASvRNefLlt
         1tfCp4ZNKoYc2oY1vRv0/1CQ00G2/FwKF802waJ0eCla7dgvjjWBIE4amLXwuk1SGG+G
         GZ+CiGOKsHJT82lxjkH+wAtDnn8vKOkHRuSd11TLU5H7Td9hfEISfsIJTm6qxDcE+kaP
         /wXA==
X-Gm-Message-State: ANhLgQ2gSNG561y6IP4zNzeVZ2LM3GZ1huu53K66R0VshZa9PV+Zxa3Y
        hggyiI4FAV+rmKu/Mdz6N1Y=
X-Google-Smtp-Source: ADFU+vudkOJHYrknhLajwIFf56XW11Fy/kaO5T6IOpMlbBKGM+utEZJtC8ORa1ImopTHj+v7gfAjGw==
X-Received: by 2002:ac8:4581:: with SMTP id l1mr5193609qtn.59.1583254276754;
        Tue, 03 Mar 2020 08:51:16 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:fb09:9cfd:7305:ba61:3cf5])
        by smtp.gmail.com with ESMTPSA id r198sm12549477qke.98.2020.03.03.08.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:51:16 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D4FE6C5B52; Tue,  3 Mar 2020 13:51:13 -0300 (-03)
Date:   Tue, 3 Mar 2020 13:51:13 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next v6 2/3] net/sched: act_ct: Offload established
 connections to flow table
Message-ID: <20200303165113.GD2546@localhost.localdomain>
References: <1583251072-10396-1-git-send-email-paulb@mellanox.com>
 <1583251072-10396-3-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583251072-10396-3-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 05:57:51PM +0200, Paul Blakey wrote:
> Add a ft entry when connections enter an established state and delete
> the connections when they leave the established state.
> 
> The flow table assumes ownership of the connection. In the following
> patch act_ct will lookup the ct state from the FT. In future patches,
> drivers will register for callbacks for ft add/del events and will be
> able to use the information to offload the connections.
> 
> Note that connection aging is managed by the FT.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sched/act_ct.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 3321087..2ab38431 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -125,6 +125,67 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
>  	spin_unlock_bh(&zones_lock);
>  }
>  
> +static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
> +				  struct nf_conn *ct,
> +				  bool tcp)
> +{
> +	struct flow_offload *entry;
> +	int err;
> +
> +	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
> +		return;
> +
> +	entry = flow_offload_alloc(ct);
> +	if (!entry) {
> +		WARN_ON_ONCE(1);
> +		goto err_alloc;
> +	}
> +
> +	if (tcp) {
> +		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
> +		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
> +	}
> +
> +	err = flow_offload_add(&ct_ft->nf_ft, entry);
> +	if (err)
> +		goto err_add;
> +
> +	return;
> +
> +err_add:
> +	flow_offload_free(entry);
> +err_alloc:
> +	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
> +}
> +
> +static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
> +					   struct nf_conn *ct,
> +					   enum ip_conntrack_info ctinfo)
> +{
> +	bool tcp = false;
> +
> +	if (ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY)
> +		return;
> +
> +	switch (nf_ct_protonum(ct)) {
> +	case IPPROTO_TCP:
> +		tcp = true;
> +		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
> +			return;
> +		break;
> +	case IPPROTO_UDP:
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	if (nf_ct_ext_exist(ct, NF_CT_EXT_HELPER) ||
> +	    ct->status & IPS_SEQ_ADJUST)
> +		return;
> +
> +	tcf_ct_flow_table_add(ct_ft, ct, tcp);
> +}
> +
>  static int tcf_ct_flow_tables_init(void)
>  {
>  	return rhashtable_init(&zones_ht, &zones_params);
> @@ -578,6 +639,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  		nf_conntrack_confirm(skb);
>  	}
>  
> +	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
> +
>  out_push:
>  	skb_push_rcsum(skb, nh_ofs);
>  
> -- 
> 1.8.3.1
> 
