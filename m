Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41298583759
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbiG1DKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237792AbiG1DKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:10:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B70C0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 20:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF31061997
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7D7C433D7;
        Thu, 28 Jul 2022 03:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658977836;
        bh=xsc4101MITosDPG+XsJiTmB7aDnKm+1lJbgwFybCko8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ruxSif9ofIgFbfuKDFdZuH6pxZ0A2WZ3L7FHE1tpJ7mcvJKW07oAcIwUg3G3I35Mg
         vRyMtKmCSKxgP8sZRpRrE1oISVn0B9fesSB1kgcYuhCIIlBYdxVJu9Y0A/YPy/9g4I
         /53uihHt5qh6C3pkMRD5CPtnkWXf8wboP7P1AQvSWy5DsAzQVguTL/320tqvYA1ARJ
         QP0iOFLDV+D3w7o5P0MkXtml83eSO38W+sKI8XKS3xWmz8iGlNzRZFYrzkCWL4gsmu
         BPj7sr/EHp45HkQePkOB0Mp/tSPxDvcb3FEzwiQmHWWrWKB1cPDtJJeioqg9cO/0ti
         mPZZBrmVEl0Hg==
Date:   Wed, 27 Jul 2022 20:10:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <ecree@xilinx.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>, <netdev@vger.kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
Message-ID: <20220727201034.3a9d7c64@kernel.org>
In-Reply-To: <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
        <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 18:46:02 +0100 ecree@xilinx.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> When setting the VF rep's MAC address, set the provisioned MAC address
>  for the VF through MC_CMD_SET_CLIENT_MAC_ADDRESSES.

Wait.. hm? The VF rep is not the VF. It's the other side of the wire.
Are you passing the VF rep's MAC on the VF? Ethernet packets between
the hypervisor and the VF would have the same SA and DA.
