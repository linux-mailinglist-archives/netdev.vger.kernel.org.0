Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4D365DB1D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239722AbjADRSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239761AbjADRSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:18:03 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D1E186E2;
        Wed,  4 Jan 2023 09:18:01 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z11so33672340ede.1;
        Wed, 04 Jan 2023 09:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YqJCrFKJuvTL4FCowkMWwLaEVKycE71RXNEurs/DUyA=;
        b=KIJK6N+wh4FeiFBZL/t/TvwZbDfvFv7pSngmv9F1VjlRV3UBRM8Exmd/CwQJzyBrMq
         YDaOxTSwZdx9OL0CcQmCyOOidP7fM8Dquc/E+kCrxaRgJetYUWoLeqppsXPNpTBIYQ6o
         T46x0JxVCf3gUB6T0AM35b78vu6sWAZzLKLTEHpQO07UfA1P8U3U4AnLFCj3lP8h7iI7
         TKyq+nBSsPuUHNAG2Y8+hiy/UBLPO44KpKoXEuwb+gbbB7JdTyCJchKibYHcMqiYAm1B
         RITpYmKuhD5YwAvkrN2N3Qb2eeUW38nkbtvr43MVexgF8Ze9jmNWcuebRs0KxkJGifE5
         5Qng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YqJCrFKJuvTL4FCowkMWwLaEVKycE71RXNEurs/DUyA=;
        b=u855aYLW+aseJ8i/xi2Dijyt4lYSqygkT2nJCW/6kU2YlxPuLM3XuNOTFyE4RRNFHo
         sko5AEmHrOXB8sNQRPrMapim/Fav1oItwXfXntW4tioqvbh8fd8w2WBpRQRqbbWSgyTa
         +8DObAxdMJWGHqgiwTLAzbuAxGGPj5zEPLP86eg/T+2gMGVtxB/L3R5vgA44syACLv9N
         a0BIpOmU9rVwXv7i6Ai1nqBI0kgMxSP8Q7JsghXUkhQaKEDla7vJ9m26i99EzNgNpvcI
         1apWfzLhxjvwSqJdoChyxrWu2ILtcT8ZGscRPmfCqjqiODO2r9D9Xe+Hlk19qyjmURQK
         QmUw==
X-Gm-Message-State: AFqh2kpAtmPtCTpn1lx77lkTd/zGuFpTfig+rL1L+1JwHVI1CKBP1AJR
        RoEJGHW8B16WcwPYpjW12dg=
X-Google-Smtp-Source: AMrXdXv0M6Jnr6NKagOqeH5m/coY6G3M6PBcYS/au7F9jvY0xIjLaBJWYCmfN6nm2c3vYKsbMXULHA==
X-Received: by 2002:a05:6402:380b:b0:480:f01b:a385 with SMTP id es11-20020a056402380b00b00480f01ba385mr41762257edb.4.1672852679531;
        Wed, 04 Jan 2023 09:17:59 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id i6-20020a056402054600b0045ce419ecffsm15056246edx.58.2023.01.04.09.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:17:59 -0800 (PST)
Date:   Wed, 4 Jan 2023 19:17:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 1/3] net: dsa: mv88e6xxx: change default
 return of mv88e6xxx_port_bridge_flags
Message-ID: <20230104171757.2k4hwdpxqe5x5pi4@skbuf>
References: <20230104130603.1624945-1-netdev@kapio-technology.com>
 <20230104130603.1624945-2-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104130603.1624945-2-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 02:06:01PM +0100, Hans J. Schultz wrote:
> The default return value -EOPNOTSUPP of mv88e6xxx_port_bridge_flags()
> came from the return value of the DSA method port_egress_floods() in
> commit 4f85901f0063 ("net: dsa: mv88e6xxx: add support for bridge flags"),
> but the DSA API was changed in commit a8b659e7ff75 ("net: dsa: act as
> passthrough for bridge port flags"), resulting in the return value
> -EOPNOTSUPP not being valid anymore, and sections for new flags will not
> need to set the return value to zero on success, as with the new mab flag
> added in a following patch.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
