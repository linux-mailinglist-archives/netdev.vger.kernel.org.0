Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03164D9646
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 09:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345998AbiCOIcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 04:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345969AbiCOIcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 04:32:19 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2CD4C787
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 01:31:02 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 73572320157F;
        Tue, 15 Mar 2022 04:31:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 15 Mar 2022 04:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=a09louK9PNjhrPgEA
        TZn3aIMtSVDu31QXYfPMVgzL9M=; b=DFYSaDs+9YjmYiHBvA0b8R1zmJbVtOqiv
        K1ezOTQFornDqRFexmfIg7MB90mDzNJt5bLzqlZCwC5FboKlPRyhTtO1+A3Nu8Z9
        uyY3S9/AqMZUmd/Mh5ZV4ykONjrX07xs88H4bYLF2f/UpGBbC2JhyIN8as+rhJEt
        hBGsw5DbTIKOesjSxbNZ+iZ+pGYhl4J7sEU4YJO+57vTnDO/NiK2PUy1wpxSmmwE
        nLGJDEVEpYtm9W2LDbCl5bzWWfXbNxB+xweRw/JqsA3LrgxiyqhBJHiFRMw3b8so
        cJDMKtfskIYxXdItsxhTmivv/VJS1LxGAldevZupJJLo1Z74VNzzw==
X-ME-Sender: <xms:xE4wYhl4r7IJr29wlh6xjs1Y0Y4LL4R4fwkAtd0clNd9DUrXUbDj6Q>
    <xme:xE4wYs20nmf7e1Kpj_HhCe0d22VBWbHIH5TSt7lDfHaqtk0p5H3cpjaeOmmjza0Y8
    -g8dmEd8Fqw9Hk>
X-ME-Received: <xmr:xE4wYnqBXx9q3n0AEpbc_7mdiWVU4ebRIrWdLyvauCt2D5ZJX1DjFJHvfTj9whcG7me1Qne54Iw2Sz429nDsGrWV4cU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvledguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xE4wYhkpWZdcZdLUR9jX2wYJxr7OYqqPnpbNwgygzOKfNitas_ECUA>
    <xmx:xE4wYv25MlktlZmHgDGYJKB43cRhvy4u2_Tx02LGpEi0oW5rsMXHmQ>
    <xmx:xE4wYgsb1elOIOXEND6w9x9VssTm5Y1UGTqN-MJUPe8UNEliZ-cr3g>
    <xmx:xU4wYpoVPzT1okUh93EOiC180yYnqv_h1cQ2-QIqsFUgxl3SLKOnCA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 04:31:00 -0400 (EDT)
Date:   Tue, 15 Mar 2022 10:30:57 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org
Subject: Re: [PATCH net-next 5/6] devlink: hold the instance lock in
 port_split / port_unsplit callbacks
Message-ID: <YjBOwbarsUY1lxUV@shredder>
References: <20220315060009.1028519-1-kuba@kernel.org>
 <20220315060009.1028519-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315060009.1028519-6-kuba@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:00:08PM -0700, Jakub Kicinski wrote:
> Let the core take the devlink instance lock around port splitting
> and remove the now redundant locking in the drivers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
