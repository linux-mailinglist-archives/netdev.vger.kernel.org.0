Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC505E57EC
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiIVBRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiIVBRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:17:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FCDDE7;
        Wed, 21 Sep 2022 18:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12509B81A97;
        Thu, 22 Sep 2022 01:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E6DC433D6;
        Thu, 22 Sep 2022 01:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663809453;
        bh=JMPgI51DpBrQcNwGIdUMSMjRvDmbd5dzyNZBmm4sXEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U5ADaUtCk2qo3xg97uXRVTz1gypm1L6pl7NsDJ5nxRYSCpC6oR/JfRkbpTSRlAFKV
         qfPCR+aM2kq6CpymkAITFGkVRaZXjj2Am9Z3GUjy9dIxXTzsItm8NJygSJi2SOnAGF
         GCZMaM4YoTCC7kQ9UTdH/fdvPgMaXWyK+gQ+kYHgFPg3U1KsAqKf5BnhlBUChiGYrs
         dVx01AMhnCPoT80xikdeh375ZQBzNjohLvChUiMbGPG4YcSyPA3GwHbewlXl3Zx6UH
         WWE0o+JdI5y/8KHj1wFqOm+oSDoX82ijtSVgQ3IHV7p1Rzw/7EYBRq0AAb/IHa2AoN
         64V9w+VzUxOfw==
Date:   Wed, 21 Sep 2022 18:17:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next V1 2/2] net: lan743x: Add support to SGMII
 register dump for PCI11010/PCI11414 chips
Message-ID: <20220921181731.7d107d64@kernel.org>
In-Reply-To: <20220916115758.73560-3-Raju.Lakkaraju@microchip.com>
References: <20220916115758.73560-1-Raju.Lakkaraju@microchip.com>
        <20220916115758.73560-3-Raju.Lakkaraju@microchip.com>
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

On Fri, 16 Sep 2022 17:27:58 +0530 Raju Lakkaraju wrote:
> Add support to SGMII register dump

Switching between dumps based on a private flag is not gonna cut it.
Please use ethtool -w / ethtool -W or devlink regions.
