Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5028E4D42EA
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbiCJI6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 03:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiCJI6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 03:58:23 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B247137584
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:57:19 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id D1F845C0231;
        Thu, 10 Mar 2022 03:57:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 10 Mar 2022 03:57:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ka/E0eAdPC7UgSU8h
        qJrl5IOAEJ3kI6QMbxuYq3n7oY=; b=fkGHUSBW+1BKExsLniVgi2ulmFHeCzJMR
        VAz8ztNhh8AWvxfNoCkA0sEL41wi18MySLEU7LQxNrHbMbcLH5e5ZaOvE6hkEvAM
        cVtcLLNSOP2VrkXoTUiFrDYd1JXAFkjEZQ+sgqxHkvwkikwgAuzif9tqNseyvRVI
        x8TdmVPAJlGHzf9jAdob+9RDIesMGKXR1ihrqjnniljjws4eb4FWxRwFn+Kubgy9
        vZMNwGj8XFSfCpGXJ423Ag5v5yFsyscK+8Ij270EzSRebaPY1Jfy5HScROIKch7c
        GArdVag3yqxlco71vSJz/lfk8V7TD/01ckPDjl2vmUG38+rmO1e5A==
X-ME-Sender: <xms:bL0pYshN1_q6bnTlii2jgDT2xzUWaqzreLITBh56wC84WPDLdoqByg>
    <xme:bL0pYlDq46niY5aF1MiwtKSKveCOa2mIn3Lfuz-tHx9svqpME8Xz8M_ohg6lSvIw0
    0yb9vgfCJ_FsKQ>
X-ME-Received: <xmr:bL0pYkH8rnMPJKflIPx07V8ckpwOvZ_V_u29N8EBKshFfsgzOpgQbaZvaGt8zVADBEBsMZxq6B-EX9-Abcu8qIoLyIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudduledguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:bL0pYtQ586bfCCKKqC-RxE4NENtfPAB_7CxWSsKZDypO5-9ZoEfurQ>
    <xmx:bL0pYpzbN_-msYSfUpBnwu9UWfBTIiuA4trf4psQqUWayiXEY-qhBQ>
    <xmx:bL0pYr5FzRa87-G2CkZpdndXUKUgkP7umnfAGY2fP5o63InTTgCd8g>
    <xmx:bL0pYruHrY-VZ_W6a3SVlprc_DqzoHnBDqLACYL5OWNipjGXxn37vg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Mar 2022 03:57:15 -0500 (EST)
Date:   Thu, 10 Mar 2022 10:57:12 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and simplify
 port splitting
Message-ID: <Yim9aIeF8oHG59tG@shredder>
References: <20220310001632.470337-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310001632.470337-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 04:16:26PM -0800, Jakub Kicinski wrote:
> This series puts the devlink ports fully under the devlink instance
> lock's protection. As discussed in the past it implements my preferred
> solution of exposing the instance lock to the drivers. This way drivers
> which want to support port splitting can lock the devlink instance
> themselves on the probe path, and we can take that lock in the core
> on the split/unsplit paths.
> 
> nfp and mlxsw are converted, with slightly deeper changes done in
> nfp since I'm more familiar with that driver.
> 
> Now that the devlink port is protected we can pass a pointer to
> the drivers, instead of passing a port index and forcing the drivers
> to do their own lookups. Both nfp and mlxsw can container_of() to
> their own structures.
> 
> I'd appreciate some testing, I don't have access to this HW.

Thanks for working on this. I ran a few tests that exercise these code
paths with a debug config and did not see any immediate problems. I will
go over the patches later today
