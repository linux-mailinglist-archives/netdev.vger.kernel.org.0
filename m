Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357766242CC
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiKJNEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiKJNEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:04:43 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398F44E402;
        Thu, 10 Nov 2022 05:04:42 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id 13so4839596ejn.3;
        Thu, 10 Nov 2022 05:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jKA205SGxX5/gDRPfOwnmhv24HAhHc6QkaYmiQwjCjQ=;
        b=J2pI3ZkbKVyI1lq+Nw09ivUgvX/t/JIB4pJ5cL7+fjuc5Ifeaqh4PL07Tn9VLUKbVn
         mR+O6/wYuzR1NYr58juB255hsfl1U5/RJU/vXSOMhREmYdkPT6bCQiuk/YXitimUqs/M
         OkDzdSj32McCTOfkDbNWGR3Rji4aSwCqRT1nBkzhsxcW852rjaawbyIUB7RS1uej1M2f
         kL7mbRNPmQ+T3j0kxmGLM/1Kic29vHENfFA74jqfaR6pbUW2ayjgXzkSv5GvmqHuCtty
         T/yYjFvbfunbo+/HlcCsRMzYJu7LyDGf/AeiSbRFsWYS/gy/eNDUtY1rcoMbIbtijzlf
         rk0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKA205SGxX5/gDRPfOwnmhv24HAhHc6QkaYmiQwjCjQ=;
        b=ESnxvbNOYkFvukhmP2ctqYrbjpPnwhZj5yKct0NfXk8UzDH6wFGnPJfDFSqO6YfOE5
         TC49x3Q3bV7oLE4j2quNWyXY3Sri6RHj79TYtHuI750QpDvMPuFWYNnH2DcyTTY6YnUa
         yz3scsGm+XUTdVpwWgEpEzFmNII2vsBtVKGM95b6t+DkeFxzOG2sD7ixuo1u0b0Il/Sr
         SGVDVvehO7y0Z9Bpj2xC/6XsQaX5lR0PCb7L+5EdlyNM2m/jUGO0iOt6jZfviTn21F4h
         8VDR3DjpPb4ROq6BTnspAKY5M7QEiDqF+u/o5UxJuACikbd3SZWlLkZLymgag+TGBFCd
         DlcQ==
X-Gm-Message-State: ACrzQf0RmnwS5iR5C56FH4Zc8nEj29fBtSEEKHco0pNpGWtl2PRKeGIv
        oKcS0E6cpLiH59oHuJbodow=
X-Google-Smtp-Source: AMsMyM5vQV9taI8P0FqIAYb+0AhIdeiMZIqcIkvkU03xbDUyJcVPmJAJH7ToUT1XoSt1LD7Cp8LhPA==
X-Received: by 2002:a17:907:1dec:b0:7aa:6262:f23f with SMTP id og44-20020a1709071dec00b007aa6262f23fmr26169792ejc.38.1668085480337;
        Thu, 10 Nov 2022 05:04:40 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id qp18-20020a170907207200b007838e332d78sm7107790ejb.128.2022.11.10.05.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 05:04:39 -0800 (PST)
Date:   Thu, 10 Nov 2022 15:04:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v4 2/4] net: dsa: microchip: do not store max
 MTU for all ports
Message-ID: <20221110130436.y3ybvt3ovgvbf6nw@skbuf>
References: <20221110122225.1283326-1-o.rempel@pengutronix.de>
 <20221110122225.1283326-1-o.rempel@pengutronix.de>
 <20221110122225.1283326-3-o.rempel@pengutronix.de>
 <20221110122225.1283326-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110122225.1283326-3-o.rempel@pengutronix.de>
 <20221110122225.1283326-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 01:22:23PM +0100, Oleksij Rempel wrote:
> If we have global MTU configuration, it is enough to configure it on CPU
> port only.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
