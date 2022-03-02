Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46394CA912
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 16:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243478AbiCBPc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 10:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243474AbiCBPcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 10:32:25 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C53E27CDE
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 07:31:42 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E902F5C0070;
        Wed,  2 Mar 2022 10:31:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 02 Mar 2022 10:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=P0UyEhJ4bWlfeh/CE
        NyMsA94qtM/zUSyHBvGgQ8gS70=; b=LBovM/unksIfyIvdREn554y7zbNwoRmrp
        tGWGnSjMewTOLV3CHXWL68VWDXvJHlF40dke9YMmF7I0dIJFg+tXhGYuX0ysOwx2
        /SGMh/SeUXieJi77fNMvZkWepQ+EumqJUNukQSLieZC/HtxWB+pcd3WlFNh9Aer/
        3p+eeABsFLRDsyCgYx4KQtvZgeBaXwhJqJHKNv15syi26Sipm06QBV4D6svBmSNz
        uQ9pVws8PQVYS/fMheFuuepSyY1wPtn8qrARgGLlvNAe8x3tb/T9KjkYhH1nf6fs
        0ZxcJs7G3m7R6F6z8TJSEh546mqcRyXLbygjRjfgQ/oJvX/xZlfDw==
X-ME-Sender: <xms:240fYovaBydhYxXLohlBiY_qTAY9ikGTjK54itAuffIuDAbXDlKbZw>
    <xme:240fYlcLy_Yht2EtQU08qz_Z5BX7dFJhxgIPXljwI_qyNRnmPtLyDXTanN-NDEJnC
    LWxJehfgWWxnx8>
X-ME-Received: <xmr:240fYjxWOF6A9m8yHFUVyFLx28qZ5AZdubrop5nufGKnL07JcTIoLtEzeQnYA4vv4BTSHI6SKe73AYNCMvmQuGioPoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtgedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:240fYrMLqodcMR9CxQdkfweEJnnTcLzG0FZDCqaa4eAtHmtJW1xtaQ>
    <xmx:240fYo-RMclgDRsqTPHFYnJ52OM54yKSEmQuIpg9Yzc_zmf6lLRRaQ>
    <xmx:240fYjUQnOXE6CWCCy3vSH-JR8TkTPW2M4uWOhj6SheHSMQ6KJh4Pg>
    <xmx:240fYnZngK-EIDY_IRqBDmjDenBFj0Ydndim1GDt3eiAD8W0maGjeg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Mar 2022 10:31:39 -0500 (EST)
Date:   Wed, 2 Mar 2022 17:31:36 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH net] net: dcb: flush lingering app table entries for
 unregistered devices
Message-ID: <Yh+N2OCM+Mv3GWoO@shredder>
References: <20220224160154.160783-1-vladimir.oltean@nxp.com>
 <Yh5IdEGC9ggxQ/oy@shredder>
 <20220301163632.pcag3zgluewlwnh3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301163632.pcag3zgluewlwnh3@skbuf>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 04:36:32PM +0000, Vladimir Oltean wrote:
> On Tue, Mar 01, 2022 at 06:23:16PM +0200, Ido Schimmel wrote:
> > On Thu, Feb 24, 2022 at 06:01:54PM +0200, Vladimir Oltean wrote:
> > > +static void dcbnl_flush_dev(struct net_device *dev)
> > > +{
> > > +	struct dcb_app_type *itr, *tmp;
> > > +
> > > +	spin_lock(&dcb_lock);
> > 
> > Should this be spin_lock_bh()? According to commit 52cff74eef5d ("dcbnl
> > : Disable software interrupts before taking dcb_lock") this lock can be
> > acquired from softIRQ.
> 
> Could be. I didn't notice the explanation and I was even wondering in
> which circumstance would it be needed to disable softirqs...
> Now that I see the explanation I think the dcb_rpl -> cxgb4_dcb_handle_fw_update
> -> dcb_ieee_setapp call path is problematic, when a different
> DCB-enabled interface unregisters concurrently with a firmware event.

Yep. Can you please send a fix so that it gets into Jakub's PR tomorrow?
