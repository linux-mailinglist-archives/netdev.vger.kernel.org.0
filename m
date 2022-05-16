Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6C8528320
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiEPLY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243148AbiEPLY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:24:26 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE91B387A1;
        Mon, 16 May 2022 04:24:24 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id z2so28005792ejj.3;
        Mon, 16 May 2022 04:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=77gx/XLhnKSDiVibNMBRLIPjcw3E1r3YTb0F7inWImQ=;
        b=iXVszanG6bjkeDIEEDw7fW2lVJpChg3S/DptMsSdJR93CW1yQd6530UO3dwLgnAQvk
         +MpAW4yMSlqLZPsk+iARePydg9/ulzdCjc3sO2CjDy4Z6ooWofrHOBny5r0HHkjdsTh2
         HARdrE0jAkfDHgAFGKJhrM9nqvgDsALmSE+q6XrnsaTmFq6t68wCqAvENjcE8Cjl87Tf
         SQ7B/ICb7rpcro+mAmTzNSKnwbELGtP7UKfBd4cPnkZ/QwI/3OvNFs/hpgHCa6pbf/Q1
         /NSrHLtAfFj5BSX5m1tWzCoKIurq65ViOy2cqVcLQtbff9kkZzkvuUB3Xso3kEkOU/7N
         wzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=77gx/XLhnKSDiVibNMBRLIPjcw3E1r3YTb0F7inWImQ=;
        b=JP3krF9BmYIUwIMsfT5OmDI5f9Ci5638ZKTSOdkZfgr5Rz1YSUwATpVXud5xowpOwA
         hy+ougdPF1ZJcdoWLjv5KSYsD5bTSkx6F8O0h0eAtBxueE50K5Z1bBAN2i+QdTz0TZMW
         1vEBr8M++y8ypZ9fe+V5zrGHJT1i+YSyRgyFtFqmklDzi/Ra+RUoft7HGtza/rEq9A5s
         7MCTjsZ/velu+Fj5LrVh6rPblWvxQ0HxRxofKRexfXK/s0FigxcBCpi3OEF708NE+iNo
         SqxRV8Gd8fiSoBc36xkhigwohlP8bbU2rfuWHmFS1FXODEamOjKoXotY/s6TnXvQP+jJ
         NrqQ==
X-Gm-Message-State: AOAM532vC9SlprvN6PXVddV7rVU5GimmI+NkAIiiKw9QKk3i0AsiPQan
        gMTWHpgtNQQu+f3J0dtEczg=
X-Google-Smtp-Source: ABdhPJxT6XSfbzOLNrpQtOjop8bYz8T8iKdEu7rm4HQvaqRMsW3WRPuPU3WoD3SO2asQfdShRD+JVA==
X-Received: by 2002:a17:907:94c6:b0:6f5:287a:2bf2 with SMTP id dn6-20020a17090794c600b006f5287a2bf2mr15551079ejc.124.1652700263341;
        Mon, 16 May 2022 04:24:23 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id w27-20020a170907271b00b006f3ef214e12sm3563951ejk.120.2022.05.16.04.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:24:22 -0700 (PDT)
Date:   Mon, 16 May 2022 14:24:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC Patch net-next v2 6/9] net: dsa: microchip: move
 get_strings to ksz_common
Message-ID: <20220516112421.ndzmocmw4opdpvbw@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-7-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-7-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:16PM +0530, Arun Ramadoss wrote:
> ksz8795 and ksz9477 uses the same algorithm for copying the ethtool
> strings. Hence moved to ksz_common to remove the redundant code.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
