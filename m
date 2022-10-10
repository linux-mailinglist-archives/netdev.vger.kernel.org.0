Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A365F9E0F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiJJLyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiJJLy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:54:27 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8006AE8E;
        Mon, 10 Oct 2022 04:54:20 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id nb11so24360813ejc.5;
        Mon, 10 Oct 2022 04:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U/E3T0wl6Fj2R/y+KYK4EXcAVuig6QXfdci5nsqVyLc=;
        b=Uc+eaL15HfPAYF9dUYGq7BhfX+07P+J3DeG9b8MbPvEsGHRFY13g6KnVxzq23VcPX7
         lmGOR371sevEQuhD5w1zq0f4sJFYw90R9rHO+9X6pAOwZejKmbPcboA9i1FbL6/J4CO7
         vur+XsWGMa4c56DuFZT85dDcva2b2AAkg6I3st1qQd8ZScztcwXmsGaM6Mmx3ES+dmCA
         SjPkbH3UOX7spqe7nvUAH1ZTSREYY18Je762/KDbFm0uma3kQN5BkX6CFHuz+yeKU6Eb
         ydBaiHY/TjII4zN+tGUzCXh7AuSKAC1Zp98SoFMHtjzsUvBGDIx9k8Ck4PqNcqRvtHIM
         r8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U/E3T0wl6Fj2R/y+KYK4EXcAVuig6QXfdci5nsqVyLc=;
        b=uliMIId7bz1pkYanihAytlnQ977mbrsS2U06EPNlGNCgtOO1QThuas/+cB2D6ZZVHi
         ys+UOMYiODoSJFuDiTu1SfWbC+n9BiAnBXLwExrDPjQx/AzhZiMbxtGy4O+z6HOQ/Mi6
         fw7CX7+S/wPxvVJrf6wZPvNYKLVU8jfPAGrB3FR/mNMloB9/rXHX/1w08rNTxQo/1Ved
         tQDVus4d8r46u1xXoQlMCTyfrUmow1oOQqbepF9Y2WrHLbKSy5HUFfy7I6KpdgLMchbi
         x9PkLnnGK5m/uJNlaLRLtUAK4Vqfb2Odp8O/28QUfD9tsMNyiWUhwKZ527gimgXGgAlY
         AVLQ==
X-Gm-Message-State: ACrzQf3p4ASMI9KInKy1wxYg6rknxZuDdxrAtV2ioPpMnSTzoJYtzgoS
        EkW3Szvpe/uHvF7/HgzG6hk=
X-Google-Smtp-Source: AMsMyM4obdvVUsya0ElcJK85kqwZXV/oU7fOwD3hjhtjnE/ZKRKbvo9srbr5lpCbbdd44DxuRuJMmw==
X-Received: by 2002:a17:907:da7:b0:789:efd0:3995 with SMTP id go39-20020a1709070da700b00789efd03995mr14462502ejc.759.1665402858125;
        Mon, 10 Oct 2022 04:54:18 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id p13-20020a50cd8d000000b0045726e8a22bsm7003504edi.46.2022.10.10.04.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 04:54:17 -0700 (PDT)
Date:   Mon, 10 Oct 2022 14:54:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcus Carlberg <marcus.carlberg@axis.com>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 18/77] net: dsa: mv88e6xxx: Allow external
 SMI if serial
Message-ID: <20221010115415.4uxq5f42e7qfnf4p@skbuf>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-18-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009220754.1214186-18-sashal@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:06:55PM -0400, Sasha Levin wrote:
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
