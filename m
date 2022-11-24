Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4144637B28
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiKXOPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiKXOPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:15:03 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E52B51316;
        Thu, 24 Nov 2022 06:15:02 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ha10so4486018ejb.3;
        Thu, 24 Nov 2022 06:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VmbvuSM4gaHt0wF6CYlwWdmkwgoCO7ZVvFZi9V+mMbg=;
        b=H/YpQNPvu/OHLUtSHqZu+AwPJYJZDYZRsxEP23Poh30rrIWfrxZyx+O3KyyZzS5GUP
         6vEzKrmgshBQhDlS9lqr1Ybyb7hRaLrCYrRaUW17RqxOyydjn+uB98AZfZ0NGvUg/llH
         VCgL4mj4SUZDIz90dSpGfJ7Q7VvOrcmkIX7sG5vN6y1edoaDwQOJR7QRHQAa1PGacRY8
         ySBHdQ2vDxzf/A6LLt958z5XUbQ+Oq1fmaeCNH/jNc/C2r+UZSxEFedmLe/okA5bTmXE
         wmHdBKW+ElYVeR5Si81wx15M1iafH89gy8qh1vy1+akc0WgnkCwmvTOYoDxPraywpAwU
         cIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VmbvuSM4gaHt0wF6CYlwWdmkwgoCO7ZVvFZi9V+mMbg=;
        b=yo9BVMzcBOY2m+b2Fw62LV+nbPWHa7Jg3G4eO6cMZc6sj7XAirabfcrUUqa1r1yJpf
         Ib4aOIDcVAb4P23wtuquDSV2/pBBWGD6gfSSCQuQFvHMhYhA8VX6IBtWKEEKU53V53e7
         YTj6MaHHL5J8gTFOdysFPqEVwusPPQ8/IxKrISFSLlNAdgoi+lzmkH+tDKAhBXbPd1hB
         iZNluk4hRRl6evN9SM0McvGX07bSkLZg4GsExSx7qHmkESSrF1XyaTiJzXMK421gTq6G
         Tdn9ZEegFufZzkCOUeN9Mn5jH3J56OBGpSO+PGEsa2pzi+3xpGRSg9rho2Ek3VNpL3gr
         9XeQ==
X-Gm-Message-State: ANoB5pkIQ8Q0oClkVyO0+LKaeWsX1czoFbMSs0g1+T5ekucj0mKFLKA9
        v++rWaUseUXAv+tw4V4dsXg=
X-Google-Smtp-Source: AA0mqf6Ym+4p5FdBNDsq2wBOpMUC0QXWcEBXdkmZrV6feoPX5KMNkrZXoTRiehTR0JcYgbnWwQpowg==
X-Received: by 2002:a17:906:fcac:b0:7ba:a9cb:8643 with SMTP id qw12-20020a170906fcac00b007baa9cb8643mr4410054ejb.298.1669299300445;
        Thu, 24 Nov 2022 06:15:00 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id d5-20020a056402516500b00457b5ba968csm555383ede.27.2022.11.24.06.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 06:14:59 -0800 (PST)
Date:   Thu, 24 Nov 2022 16:14:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net
Subject: Re: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial
 hardware time stamping support
Message-ID: <20221124141456.ruxxiu7bfmsihz35@skbuf>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-4-arun.ramadoss@microchip.com>
 <20221121231314.kabhej6ae6bl3qtj@skbuf>
 <298f4117872301da3e4fe4fed221f51e9faab5d0.camel@microchip.com>
 <20221124102221.2xldwevfmjbekx43@skbuf>
 <0d7df00d4c3a5228571fd408ea7ca3d71885bf6f.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d7df00d4c3a5228571fd408ea7ca3d71885bf6f.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 10:52:46AM +0000, Arun.Ramadoss@microchip.com wrote:
> Mistake here. It is carried forwarded from Christian Eggers patch.

Still taken from sja1105_hwtstamp_set(). Anyway, doesn't matter where
it's taken from, as long as it has a justification for being there.

> > Why do you need to call hwtstamp_set_state anyway?
> 
> In tag_ksz.c, xmit function query this state, to determine whether to
> allocate the 4 PTP timestamp bytes in the skb_buffer or not. Using this
> tagger_data set state, ptp enable and disable is communicated between
> ksz_ptp.c and tag_ksz.c

Why do you need to query this state in particular, considering that the
skb goes first through the port_txtstamp() dsa_switch_ops function?
Can't you just check there if TX timestamping is enabled, and leave a
mark in KSZ_SKB_CB()?
