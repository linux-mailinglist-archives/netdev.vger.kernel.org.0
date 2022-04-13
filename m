Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C134FF6E5
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 14:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbiDMMhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 08:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiDMMh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 08:37:28 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1847218E35
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 05:35:08 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7CAF25C0364;
        Wed, 13 Apr 2022 08:35:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 13 Apr 2022 08:35:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1649853307; x=
        1649939707; bh=XMgjqSu330j537uTdk8vlBBLcfWargGjanG7gxBvZyg=; b=z
        QW+9E/xJjz5557ZQvJmGoLEHCR3PqDZ2OV/fW+wKGV6shPhL4bVwe1NBK+Jat8ma
        pQvzsOsB1KmRlIWTz3jcroigAiEuugm4PYzgEleksi1wxXqn1Fu9yE+xMSeQIuS0
        XYV4uIrGhKHdZeWAfEnUsZMfJepRIDUBQAVq9rNRjTZlmKxtN11gnr7upi6ZnLIE
        7TKPk4+SCnoO3if3V37TCxXGeIdFn/H34kGCWoq6XTvk9S76Q1pjXBdRtMs59azj
        pFf+M16rLDQSaplMhimuWD82QnPtrowWq3U9KXY24OHZq9ZMApinbxH3iLUwzMe3
        UyxL7qSAru56LPfXn9XHw==
X-ME-Sender: <xms:e8NWYlit5EEn34rxWyiyWJRL5ERRuWilRL2Pk8DkX7eMsO45hiYw8g>
    <xme:e8NWYqD6MOcdyZNUzRtHdIZkbER3ThT5WB2cgVaeKGsE3rT2ub44F6xOvPTUW_J8h
    tRRBM5UA9Ly7ds>
X-ME-Received: <xmr:e8NWYlHO5jMJqQKQlJySY8cEQ8tIWrswiGRI6HMMrsym-hFfYHGaVsIWl2-VpumanNOaP7QtF2oRSI3TAZkaVNnp3gFCMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeluddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:e8NWYqQKMixU83rHXURlJF2ihVFAAWLBHFWykr5CD0EbKem5LRhmlw>
    <xmx:e8NWYiykUQp4_IfKGSCqHV3sMWsM0lfSHPMzgXDsVj57UVDiyeU1Ew>
    <xmx:e8NWYg4Lub-JniHJgQv37rLWx2iL_EtJ7j7zD_lVh95n3C92ISpt0A>
    <xmx:e8NWYsu8iSi7U3rqdHBpFIVNlPSnJ6zi0aUXwteD_aeyBcpKrygT8Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Apr 2022 08:35:06 -0400 (EDT)
Date:   Wed, 13 Apr 2022 15:35:04 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, roopa@nvidia.com,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v4 07/12] net: rtnetlink: add NLM_F_BULK support
 to rtnl_fdb_del
Message-ID: <YlbDeNh7D+BHRscg@shredder>
References: <20220413105202.2616106-1-razor@blackwall.org>
 <20220413105202.2616106-8-razor@blackwall.org>
 <YlbABWs3ICeeiKsq@shredder>
 <e22bd42c-f257-82d6-f550-6e174c74b500@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e22bd42c-f257-82d6-f550-6e174c74b500@blackwall.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 03:21:54PM +0300, Nikolay Aleksandrov wrote:
> On 13/04/2022 15:20, Ido Schimmel wrote:
> > On Wed, Apr 13, 2022 at 01:51:57PM +0300, Nikolay Aleksandrov wrote:
> >> When NLM_F_BULK is specified in a fdb del message we need to handle it
> >> differently. First since this is a new call we can strictly validate the
> >> passed attributes, at first only ifindex and vlan are allowed as these
> >> will be the initially supported filter attributes, any other attribute
> >> is rejected. The mac address is no longer mandatory, but we use it
> >> to error out in older kernels because it cannot be specified with bulk
> >> request (the attribute is not allowed) and then we have to dispatch
> >> the call to ndo_fdb_del_bulk if the device supports it. The del bulk
> >> callback can do further validation of the attributes if necessary.
> >>
> >> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> >> ---
> >> v4: mark PF_BRIDGE/RTM_DELNEIGH with RTNL_FLAG_BULK_DEL_SUPPORTED
> >>
> >>  net/core/rtnetlink.c | 67 +++++++++++++++++++++++++++++++-------------
> >>  1 file changed, 48 insertions(+), 19 deletions(-)
> >>
> >> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> >> index 63c7df52a667..520d50fcaaea 100644
> >> --- a/net/core/rtnetlink.c
> >> +++ b/net/core/rtnetlink.c
> >> @@ -4169,22 +4169,34 @@ int ndo_dflt_fdb_del(struct ndmsg *ndm,
> >>  }
> >>  EXPORT_SYMBOL(ndo_dflt_fdb_del);
> >>  
> >> +static const struct nla_policy fdb_del_bulk_policy[NDA_MAX + 1] = {
> >> +	[NDA_VLAN]	= { .type = NLA_U16 },
> > 
> > In earlier versions br_vlan_valid_id() was used to validate the VLAN,
> > but I don't see it anymore. Maybe use 
> > 
> > NLA_POLICY_RANGE(1, VLAN_N_VID - 2)
> > 
> > ?
> > 
> > I realize that invalid values won't do anything, but I think it's better
> > to only allow valid ranges.
> > 
> 
> It's already validated below, see fdb_vid_parse().

Sorry, missed it :)
