Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBDE590523
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237195AbiHKQwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbiHKQwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A1632D9B;
        Thu, 11 Aug 2022 09:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46396B82148;
        Thu, 11 Aug 2022 16:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E7AC433D6;
        Thu, 11 Aug 2022 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660235144;
        bh=eNAY7nWNpX+4QCS5pm35Zgw+2wWwXkC4x4JRn6bEsoU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z8GfzVsB4lo2Q7+VvVqkh0hhFVheVGn7fLnj9FluSweoTUA1FuqKNn5B/HWZnZYJf
         Li0A4vMWGQm3Zv0n347RvsFuoNdlj+u8H3/S3ecubgn6Q4vchAQJyTyorm3rrU1u+t
         T904AA78rBrotaqyz3l2CrWUVveh1T+qTbt6dD53oVIOJ7OSkGTXTEZ8SErH3y6LP4
         GD0TsrqJh+GkvSQqisJ3HuOW0catPbhYLu3EwiirjJ7OqMBD6zzmPIXDlnFoLDBgRB
         foyroxiqtWrDVVoZhy67kJZonhKr4EC01yqA50UnqGOmqb83h8P2a/9deJn3I3omfV
         2QtYIS9nAq68A==
Date:   Thu, 11 Aug 2022 09:25:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     <edumazet@google.com>, <mayflowerera@gmail.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net 1/1] net: macsec: Fix XPN properties passing to
 macsec offload
Message-ID: <20220811092543.696a5ef2@kernel.org>
In-Reply-To: <20220809102905.31826-1-ehakim@nvidia.com>
References: <20220809102905.31826-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Aug 2022 13:29:05 +0300 Emeel Hakim wrote:
> Currently macsec invokes HW offload path before reading extended
> packet number (XPN) related user properties i.e. salt and short
> secure channel identifier (ssci), hence preventing macsec XPN HW
> offload.
> 
> Fix by moving macsec XPN properties reading prior to HW offload path.
> 
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Is there a driver in the tree which uses those values today?
I can't grep out any rx_sa->key accesses in the drivers at all :S

If there is none it's not really a fix.
