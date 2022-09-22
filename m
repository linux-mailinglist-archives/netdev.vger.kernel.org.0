Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18ED5E6422
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiIVNt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiIVNtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:49:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C721BACA35
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:49:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63FB662D8E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BC5C433C1;
        Thu, 22 Sep 2022 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663854554;
        bh=UnaYckpSEPjRFxU9NMGISQ9wpLxXVEosc+LgabOv1QY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MyQ0CVdN1xOaouBuC0OXDEehK9Y7b+eFANyy/QedhpIorOAXDe+CkzU0rmJtHAtLM
         K2Sx2LTfmLqwkeg3kqXNJHE6WdbKTb6uK6yhGU32JgGM03E2CiC3qNyCXJgywk7CKm
         TSHS9KH/cUl+ImfEcboqBbrdIv2KIzrKIzFgl4xNZJNTTuCDiKSMQhiq6e10vzc0md
         2AHwfwIhpusz1CsWXRaeTOTOLFb2vQnZAibbZ9+dYKl3sZjYqhchSoS62Rqqr9JN73
         1LiQhUYw4i4acDl67U5UITmvKG2RmiPIuon/o9iWTcJAE7s+r3XtLD1D6LB3bWqwOe
         iBMQn7JIZds1g==
Date:   Thu, 22 Sep 2022 06:49:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: driver uABI review list? (was: Re: [PATCH/RFC net-next 0/3]
 nfp: support VF multi-queues configuration)
Message-ID: <20220922064913.3348896d@kernel.org>
In-Reply-To: <2270b3d5-a298-58e2-8d9a-96e6cac7f8d6@nvidia.com>
References: <20220920151419.76050-1-simon.horman@corigine.com>
        <20220921063448.5b0dd32b@kernel.org>
        <YysUJLKZukN8Kirt@corigine.com>
        <2270b3d5-a298-58e2-8d9a-96e6cac7f8d6@nvidia.com>
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

On Thu, 22 Sep 2022 16:37:21 +0300 Gal Pressman wrote:
> >> The cost is obviously yet another process thing to remember, and 
> >> while this is nothing that lore+lei can't already do based on file 
> >> path filters - I doubt y'all care enough to set that up for
> >> yourselves... :)  
> 
> It's not that simple though, this series for example doesn't touch any
> uapi files directly.

Right, the joys of devlink params. I'd suspect a good filter would need
to match on both uapi and Documentation paths.
