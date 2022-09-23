Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C80B5E7BAD
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiIWNVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiIWNVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:21:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563C91401BF
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 06:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0B5061E84
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6241C43470;
        Fri, 23 Sep 2022 13:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663939276;
        bh=4sfyE5Vk0TOOCcUYTlzx9WGgQ+XlwP322Ur2anhEIjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pxMW05O5MAep1KgiujktY9zdpe/troaS4zD608J1iKD4qmkZmeUTZPWEr6ex35VyM
         4FxqdHsUZmHorBXrVBxtqWr/kijNBrpoRmris1ptdpVtGAWX/VIvXzzEB6hNhIkjV4
         eyGRKh/YPzW8HrrpK17xOFbuwmwJv4JUYr7LQYheJlZ4taXvnzXc+5p552H2gpUgY2
         /FMEfJzCxPb7dafxQQYQVxCHemkYt3WksKUH+3AGZFx0giyGGo3kYVNGnrr4Gq8r1X
         5Fig+c5Jna8vOhXvIjgvLcXAWr9PXQKh/mbt4jrUuOhLJMp9o5iuTwBPqTkMTC1sJS
         WbBx/PgdJ/gdA==
Date:   Fri, 23 Sep 2022 06:21:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Message-ID: <20220923062114.7db02bce@kernel.org>
In-Reply-To: <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
        <20220921121235.169761-3-simon.horman@corigine.com>
        <20220922180040.50dd1af0@kernel.org>
        <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Sep 2022 04:37:58 +0000 Yinjun Zhang wrote:
> > I can't parse what this is saying but doesn't look good  
> 
> I think this comment is clear enough. In previous `
> nfp_net_pf_cfg_nsp`, hwinfo "sp_indiff" is configured into Management
> firmware(NSP), and it decides if autoneg is supported or not and
> updates eth table accordingly. And only `CHANGED` flag is set here so
> that with some delay driver can get the updated eth table instead of
> stale info.

Why is the sp_indif thing configured at the nfp_main layer, before 
the eth table is read? Doing this inside nfp_net_main seems like 
the wrong layering to me.
