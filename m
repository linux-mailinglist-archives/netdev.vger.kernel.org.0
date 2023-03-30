Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1C06CF973
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjC3DMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC3DM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:12:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8086B5240
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A85761EC3
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18176C433EF;
        Thu, 30 Mar 2023 03:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680145947;
        bh=9ImQM+9Nw1AHv8P7rZk8DMfKmjgxfKCiRrTBz4kf4GQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fAr5LGmQv9RiG4Xpu3NJsFyweu5eOfHSX2nx8O1802o3HSV5bqZkPIimyIKnTpZGs
         z/fHcTgtz98CNEM2ZY1VT/R+zD67WTobhQYw2ohQZpr7HrDF/mnUpsYXKc0BiaZPSY
         fk8H9zd4BITRauFKJNBYm+tuuYi0Tfv+j6wv+QGG6My1ST2p3OnboBBEscnUhy5zko
         9qQGxLdNVreXe5BnXOuCADTORB1LnPEDz0H62aaCTNlFd70gPje0BkwsIYf95sfr/6
         LVGcDKEfNt5Z/F0TMvzp0HBaBQXvXq5nG28pkKScznDrAL29w+NCEzAQZGZyK5FpGl
         qUDWtGew5CuDQ==
Date:   Wed, 29 Mar 2023 20:12:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Message-ID: <20230329201225.421e2a84@kernel.org>
In-Reply-To: <DM6PR13MB3705B02A219219A4897A66C5FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-3-louis.peens@corigine.com>
        <20230329122422.52f305f5@kernel.org>
        <DM6PR13MB37057AA65195F85CC16E34BCFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329194126.268ffd61@kernel.org>
        <DM6PR13MB3705B02A219219A4897A66C5FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 02:57:34 +0000 Yinjun Zhang wrote:
> > What is "upper", in this context? grep the networking code for upper,
> > is that what you mean?  
> 
> Sorry, it's not that meaning. I'll remove this "upper", use netdev state
> instead.

Alright, so legacy SR-IOV, no representors, and you just want to let
the VFs talk to the world even when the PF netdev is ifdown'ed ?

Why?
