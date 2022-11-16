Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A0562B2D0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiKPFiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiKPFiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:38:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11759326E7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:38:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFC67B81BE0
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36221C433C1;
        Wed, 16 Nov 2022 05:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668577085;
        bh=EpaPIJMoJtvSk8XzLIRT8HOaj/5YQSaRcUBxWiZinxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tUbfxNpodeGaVk4m79xTJaSjwimi9s36Dc6mbYYgkOYl7nuNJnhozGuqMbSfwJm9i
         3swlEqgDrNFsgbGABBLTp3QsB447MXkg6O5Ohq2ecQ2AJYq+qa4miJzb9zTTWsaU6D
         yXrziLceBpMrikuCBCEY52uIEqVH8Vl5Lziu9qn9/pkNhEju+8F2oyZFCuRsLwoauv
         BUN5opqzs84EqizaO3Z9dKLevxDY8lpArkCZURGlFeMNVq9p/ZDkwcHLEX/pLPlMPm
         zLr3LQAtbZ8TNs/G0i7A+eYntRd3SCzK479BM7VS2GT8eqL9UPPHPPjRsCSS+dj6xY
         drDus/eHJVtew==
Date:   Tue, 15 Nov 2022 21:38:04 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next v3 0/2] gve: Handle alternate miss-completions
Message-ID: <Y3R3PAwDe+6fFbBw@x130.lan>
References: <20221114233514.1913116-1-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221114233514.1913116-1-jeroendb@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 15:35, Jeroen de Borst wrote:
>Some versions of the virtual NIC present miss-completions in
>an alternative way. Let the diver handle these alternate completions
>and announce this capability to the device.
>

nit: you missed to document the 1st "new AdminQ command" patch which has
some special logic to validate driver/os version compatibility with the
device and if it's related to this cover-letter title if at all.

>Changed in v3:
>- Rewording cover letter
>- Added 'Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>'
>Changes in v2:
>- Changed the subject to include 'gve:'
>
>
>Jeroen de Borst (2):
>  gve: Adding a new AdminQ command to verify driver
>  gve: Handle alternate miss completions
>
> drivers/net/ethernet/google/gve/gve.h         |  1 +
> drivers/net/ethernet/google/gve/gve_adminq.c  | 19 +++++++
> drivers/net/ethernet/google/gve/gve_adminq.h  | 51 ++++++++++++++++++
> .../net/ethernet/google/gve/gve_desc_dqo.h    |  5 ++
> drivers/net/ethernet/google/gve/gve_main.c    | 52 +++++++++++++++++++
> drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 18 ++++---
> 6 files changed, 140 insertions(+), 6 deletions(-)
>
>-- 
>2.38.1.431.g37b22c650d-goog
>
