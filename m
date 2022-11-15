Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E61462944E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbiKOJap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKOJao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:30:44 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F37EE21;
        Tue, 15 Nov 2022 01:30:43 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D48F05C01E3;
        Tue, 15 Nov 2022 04:30:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 15 Nov 2022 04:30:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668504641; x=1668591041; bh=Im+9MuBynr968Y1hVco+TCBrVcUw
        lHLS7+P/ryvB9FE=; b=StUMi5TOImsdA1ZBeHGwbKsrxetBFlZbaVMvw+S2vGcp
        JmEgMYqpzLp0eJ0jcU8aTeIB7IX4ghIcst47q2KQVud2hUr1apEeoQn4+Thm6Emr
        95QHenJzcUvr0wi/BCYeqouRo2LO8m2hGWZC3F9M5lbCPrg56asCAkPnsEeJ4yRA
        VYmVhZRtW91ZQ/VbFILKry7c2WSM+AAmsYxGmaG2jmnVbD7VW3BQsR1Zd4rmQehD
        8s01ZHg2vg1Fw4VPhP521018XvNK4+e8uBF67hkFktegbNvMr6deMJtEkASt0N1w
        4ElY1UXd5dgRhM/6ZLa14yyU4K/rpbAIEJws1lRKLg==
X-ME-Sender: <xms:QVxzY2ZbFScMIrXmHEr259lD6sYexEW_jgnbqhsVASqqIR0jAATtRg>
    <xme:QVxzY5aqM9JjJbjSglHUAsX3jAZOLN_TnEkmmTL9ph3CxfRDaiRxnThmcdIc1Ccb9
    icCZHsUqlcRVSg>
X-ME-Received: <xmr:QVxzYw--6jhW0Cy6AyjcfJozql4sF_qqZ86I-YaJFyzrTBMR0d_ejLWkUbEMnb4zTiZQcWIxvHi7F9NXdFpwiW3gYio>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeggddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:QVxzY4rSa5_Xm8rkUgl7dA3k7UuWs3GF1yUHdgQzf3gSiW-AEunifA>
    <xmx:QVxzYxpljL-CMjedLc9RuiSxGZg5nvKpstIv-3wySumGA7T9KlL5UA>
    <xmx:QVxzY2QEe_LuOkkRGwQT8ffTe79bvU_aHyYix604UpALjgpPnNQHCg>
    <xmx:QVxzY1IG1UR_PC23H7_yQFPaVVHkgUWmnbux8D8Yn4fBgTR3XcIIhQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Nov 2022 04:30:40 -0500 (EST)
Date:   Tue, 15 Nov 2022 11:30:33 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <Y3NcOYvCkmcRufIn@shredder>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112203748.68995-1-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 12, 2022 at 09:37:46PM +0100, Hans J. Schultz wrote:
> This patchset adds MAB [1] offload support in mv88e6xxx.
> 
> Patch #1: Fix a problem when reading the FID needed to get the VID.
> 
> Patch #2: The MAB implementation for mv88e6xxx.

Just to be sure, this was tested with bridge_locked_port.sh, right?
