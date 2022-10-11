Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EB45FAE96
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 10:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiJKIl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 04:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiJKIl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 04:41:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75533DF05
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26790B810C6
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 08:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032E8C433C1;
        Tue, 11 Oct 2022 08:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665477711;
        bh=F3x9BRvQLtbn0jv9lxrUh46msfMS5ROoHZIIqP2Qsu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rYbUcFsP2hi0uh57AWDURdYsAnYMg1VW/UNxkjObwaqgOYy5w6KoefYOrjOACX6ml
         GKD9Z9Ymfv1gphx5EVnUK0Xqtem1mYD3dYvaisxy0+C9brfOy9DNm+bsuQ0XkeHKBD
         kdZ/c9GevznWjeoM9cQyItDAHzh4arw94HN6Y4le6e9S0LDHV3b06XUfIio+25Oq9o
         zXwpo+GtYeFaLXMs9kXztovOWYFam6G3+hvKkwlW8Wpbi7uKbK+QY7KElk8Yitb/Bq
         skluySGyrRQ3esYkXLQJStgDK7TaEVieZJul9JSR7N3akjb6DCrBgMVC7cdL6u+grP
         DpMZFkDHvWkFg==
Date:   Tue, 11 Oct 2022 11:41:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Cc: chengtian.liu@corigine.com, ;
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
        Cc:     ;Simon Horman <simon.horman@corigine.com>
                        ^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH net-next v2 2/3] nfp: add framework to support ipsec
 offloading
Message-ID: <Y0UsS9oxEuac8fmj@unreal>
References: <20220927102707.479199-1-simon.horman@corigine.com>
 <20220927102707.479199-3-simon.horman@corigine.com>
 <YzVS5IVrynGFYXwi@unreal>
 <20221010070512.GA21559@nj-rack01-04.nji.corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010070512.GA21559@nj-rack01-04.nji.corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 03:05:12PM +0800, Yinjun Zhang wrote:
> Thanks for your comments and sorry for the late reply.
> 
> On Thu, Sep 29, 2022 at 11:10:12AM +0300, Leon Romanovsky wrote:
> > On Tue, Sep 27, 2022 at 12:27:06PM +0200, Simon Horman wrote:
> > > +struct nfp_net_ipsec_data {
> > > +	struct nfp_net_ipsec_sa_data sa_entries[NFP_NET_IPSEC_MAX_SA_CNT];
> > > +	unsigned int sa_free_stack[NFP_NET_IPSEC_MAX_SA_CNT];
> > > +	unsigned int sa_free_cnt;
> > 
> > I don't see in this patch what are you doing with this free_stack array,
> > but whole nfp_net_ipsec_data is more than 32Kb of arrays.
> >
> 
> `sa_free_stack` is used to maintain the used/available sa entries, which
> is initialized in `nfp_net_ipsec_init`.
> Yes, it's indeed a big array, and we're going to use pointer instead of array
> here.

Why do you want to use array and not Xarray?

> 
> > > +bool nfp_net_ipsec_tx_prep(struct nfp_net_dp *dp, struct sk_buff *skb,
> > > +			   struct nfp_ipsec_offload *offload_info)
> > > +{
> > > +	struct xfrm_offload *xo = xfrm_offload(skb);
> > > +	struct xfrm_state *x;
> > > +
> > > +	if (!xo)
> > > +		return false;
> > 
> > How is it possible in offload path?
> > Why do all drivers check sec_path length and not xo?
> > 
> 
> `tx_prep` is called in the tx datapath, we use `xo` to check if the
> packet needs offload-encrypto or not.

You didn't answer on any of my questions above.

How is it possible in offload path?
Why do all drivers check sec_path length and not xo?

> 
> > > +int nfp_net_ipsec_rx(struct nfp_meta_parsed *meta, struct sk_buff *skb)
> > > +{
> > > +	struct nfp_net_ipsec_sa_data *sa_data;
> > > +	struct net_device *netdev = skb->dev;
> > > +	struct nfp_net_ipsec_data *ipd;
> > > +	struct xfrm_offload *xo;
> > > +	struct nfp_net_dp *dp;
> > > +	struct xfrm_state *x;
> > > +	struct sec_path *sp;
> > > +	struct nfp_net *nn;
> > > +	int saidx;
> > > +
> > > +	nn = netdev_priv(netdev);
> > > +	ipd = nn->ipsec_data;
> > > +	dp = &nn->dp;
> > > +
> > > +	if (meta->ipsec_saidx == 0)
> > > +		return 0; /* No offload took place */
> > > +
> > > +	saidx = meta->ipsec_saidx - 1;
> > > +	if (saidx > NFP_NET_IPSEC_MAX_SA_CNT || saidx < 0) {
> > > +		nn_dp_warn(dp, "Invalid SAIDX from NIC %d\n", saidx);
> > 
> > No prints in data path that can be triggered from the network, please.
> > 
> 
> It's a ratelimit print, and it means severe error happens, probably
> unrecoverable, when running into this path.

The main part of the sentence is "... can be triggered from the network ..."

Thanks
