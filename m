Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF0C5F9E01
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiJJLxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbiJJLxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:53:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC8E696CE;
        Mon, 10 Oct 2022 04:53:40 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id o21so24271706ejm.11;
        Mon, 10 Oct 2022 04:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+kWrxkps9B1r/XcbDCedzmZ8kw3EWdGClT/ETHdPLsc=;
        b=CDQmS9pao6pGb3OiG/CbbyjZsDu9VQepW4QO/tfUO6hLIHc7mF5+OW7ZbADA2ckjRB
         16jhuL8K9PEc65ADOOv/D+FdzZ/QcbS+PXFKAdek+J1aQh04P9PubVJyySamrOd4v6ql
         cekl/zL/vdFDegcqMRAyp24WzSUd6ozcHuJLGDXoHVH+ClmkIRZRpuYPwy+cKuBDSoTc
         GivWfDLW6aZzwy1JKWi1hOgm1woPf/FLwwrvhlNnZSaoaevMZXEVX/Ta49Tjtz448Zwc
         Jw2PpXqgbd8WDrS7UoynOyqFWr9wpozW9cEW8Y8t7zErbSZat2TmRfirE917WN91qwke
         0haA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kWrxkps9B1r/XcbDCedzmZ8kw3EWdGClT/ETHdPLsc=;
        b=V5rdcbB2ub+Cqkvf3h6CM3H7eiV//RBQQ4OuefjDV5IyMlrojBQMrK7nTL5Obudlub
         K8ZMvuORiXRQnIqtxUVBWYbFvlcej7EXbeZZUWuodbqbRof1Bm5RduKOms29Dat0ddfu
         muLxcsNIGGbMbWS0btSwc+EXowTmV6yG5taaztfBev13eZOcEypsvCV25nF5fqXW9IXG
         c9JfOcc10psEFvN1RVys86KZqFff9B7ZJwaEMBAZXFGzBdujGMi+Lzd03QXF6cGw8Mo0
         OPygW6mB1BUJm74Z7Dr6Ju0Q2mYX0HjD2CFYANPLEu3oyeDnqZI7EroTwSNflHphtnas
         BCgg==
X-Gm-Message-State: ACrzQf0n6I8ZKCAd7Laph7RHVvAW2H1GW4DlhsFmCRdbCIn6Lf96eD4U
        krPCsXFpTAGIKH62ey5LWD0=
X-Google-Smtp-Source: AMsMyM46ZJx7yl8ObIeDqSqu6ChdWomxR5YvfNZvborP4VE3vnEiLspCZs0MO3uXLT7Fw6LEEFUO7A==
X-Received: by 2002:a17:907:6d8c:b0:78d:b65a:ab12 with SMTP id sb12-20020a1709076d8c00b0078db65aab12mr4022713ejc.573.1665402818752;
        Mon, 10 Oct 2022 04:53:38 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id k8-20020a17090632c800b007030c97ae62sm5238097ejk.191.2022.10.10.04.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 04:53:37 -0700 (PDT)
Date:   Mon, 10 Oct 2022 14:53:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcus Carlberg <marcus.carlberg@axis.com>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 15/73] net: dsa: mv88e6xxx: Allow external
 SMI if serial
Message-ID: <20221010115335.wt2dpm4dnrxn25ln@skbuf>
References: <20221009221453.1216158-1-sashal@kernel.org>
 <20221009221453.1216158-15-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009221453.1216158-15-sashal@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:13:53PM -0400, Sasha Levin wrote:
> From: Marcus Carlberg <marcus.carlberg@axis.com>
> 
> [ Upstream commit 8532c60efcc5b7b382006129b77aee2c19c43f15 ]
> 
> p0_mode set to one of the supported serial mode should not prevent
> configuring the external SMI interface in
> mv88e6xxx_g2_scratch_gpio_set_smi. The current masking of the p0_mode
> only checks the first 2 bits. This results in switches supporting
> serial mode cannot setup external SMI on certain serial modes
> (Ex: 1000BASE-X and SGMII).
> 
> Extend the mask of the p0_mode to include the reduced modes and
> serial modes as allowed modes for the external SMI interface.
> 
> Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>
> Link: https://lore.kernel.org/r/20220824093706.19049-1-marcus.carlberg@axis.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.
