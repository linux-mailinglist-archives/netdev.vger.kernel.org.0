Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE0C73436
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387618AbfGXQty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:49:54 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:38961 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbfGXQty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:49:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A525A1B52;
        Wed, 24 Jul 2019 12:49:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 24 Jul 2019 12:49:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lm1vvK
        I2xwlWJcF+ACb/vTMFmTyExlI1L8HTFaVj3dA=; b=pA034k7UkB1N563DIIwfDV
        EN3njaepdPFyMtI90Shp4J4R4CWkFwShYei8IvubvDqpsLV+pwX8EHRno7NnqC4H
        PCs5stOVN2vSiv3hf1sJZp62aWjUC2UJzCmveu8xeJ/bO+ycItr3CVlzDswjXxP4
        8MlYTvggdP/0WHdIeEV7n8g6inpGl1+EaNon2QuVwe2wKH08jHHE3oXDuu9dpXMi
        Ofc2hlsTgWOoIwAsoI15AkNX1t9EVERGwWgq7qhRS+LTTyDoiXLzKQhSZR4ZbpnR
        w5WqtNSeYWmMive/lv1pB4OAmO/IImIyRMclNsQFmIsj/j4OPPWEW9svCAE2l//Q
        ==
X-ME-Sender: <xms:L4w4XQV_oI_ivRutejmboPr49nMJJ-Kh1MmnojqoFAIrAP7QE-S9TA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:L4w4Xaoiywyq5sy6NKQTLrtW4goMEFG8S0FhH28Ycdcz5A7-M1WZ8g>
    <xmx:L4w4XXrf49TqMiovPxAkiFNvsggKLZCjzEGp-yClIHA0d3u-YEOiwQ>
    <xmx:L4w4XXda7F9goRF546aWo6OMYddHSHyze1EWLeIkGaYEL_lcKJcrjA>
    <xmx:MYw4XdLxhkDPDlHElJ6x9BUFF5AeDGLzzvdLnpz1C7qOA2QRcLDzfw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCD00380083;
        Wed, 24 Jul 2019 12:49:50 -0400 (EDT)
Date:   Wed, 24 Jul 2019 19:49:49 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        toke@redhat.com, andy@greyhouse.net, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 11/12] drop_monitor: Allow truncation of
 dropped packets
Message-ID: <20190724164949.GB20252@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <20190722183134.14516-12-idosch@idosch.org>
 <20190724125537.GC2225@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724125537.GC2225@nanopsycho>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 02:55:37PM +0200, Jiri Pirko wrote:
> Mon, Jul 22, 2019 at 08:31:33PM CEST, idosch@idosch.org wrote:
> >+static int net_dm_trunc_len_set(struct genl_info *info)
> 
> void.

Ack, will change.

> 
> 
> >+{
> >+	if (!info->attrs[NET_DM_ATTR_TRUNC_LEN])
> >+		return 0;
> >+
> >+	net_dm_trunc_len = nla_get_u32(info->attrs[NET_DM_ATTR_TRUNC_LEN]);
> >+
> >+	return 0;
> >+}
