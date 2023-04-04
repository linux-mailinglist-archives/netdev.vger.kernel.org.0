Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB11D6D5EF9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbjDDL26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbjDDL24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:28:56 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DC32117;
        Tue,  4 Apr 2023 04:28:54 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t10so129028659edd.12;
        Tue, 04 Apr 2023 04:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680607733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mKcFP7PU6E3MHzGfY9S4ZrIp2Pkqm6lpQOjzruEh614=;
        b=fRxpJsVeXRBegrrpPlb6iirOC7oKxvho5rlJh1REGpAr3/qOKkqlxiGTw9aPw97wlG
         fW7p+15yucumMFUsB6+4ZUMntUk1XOFgzowGC2W1JlTlwe5OG2i05emMvbuIgqOEk/cc
         96c80C74ag3uhlZBIkY/4es/JJ5F+O7MRIPhW/I3Cq7z49I0apXmuhKyv8EXRe0MaZNp
         a/x6Hh126aaPiJQuG9wfhj59UHU3Ni+AZZjQhPZ0OTDvuAJx40DQYse/Omi51cCVEbdR
         kzXQSAmob+fCOx3Ny3ORPRf0C8X9aj4/tWPclxNQsX/9rnahiUhbouQmtXV8cGaDii6D
         JjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680607733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mKcFP7PU6E3MHzGfY9S4ZrIp2Pkqm6lpQOjzruEh614=;
        b=ZWkASYvz41rmoySb7tox3f8m/SrxA2XJS2krObG6AWXfnRvEkB8EjeEvB3vrXJGnUB
         VI1VCp29wx4m+pHmiqfdoGexYFXoBnXsWDGZkPP8mlH9NrPEYMUGZfIuMfAL6uTGjTZ/
         YSceOhQTmJtM+Bytt/+j0sg4hyZZpEl2Xj4YWPDeEX53WTwT6C5cYts7joDGs8zq3K6+
         Q4nnPG2fkg0yTjReLWenNTOVDxPAi+h8D6fhLjJ57NhtChXuQTzQ57o7554uc8EQ69z8
         QIXmyX3rZRah5VnDwpxn79erF/gQCenkagGw7kxvwHX2ZvDayUsi2JBAtnK/pvKQgQFi
         XTdg==
X-Gm-Message-State: AAQBX9dY25HFyBctBiOAg3Sz8V1P+IrfWsT1uOx2DChZgJud3IYUjh7O
        8maJ+EYkjtxfgBCHthxOmo+q1dLS2UohIg==
X-Google-Smtp-Source: AKy350YVohIFn9mM28k1f0aEluCrJ1LyWG/0nB2Ng7An9gu4YbtFY3a4EJCON6ks9KZN7FgpWgPe6Q==
X-Received: by 2002:a17:906:69d6:b0:947:ebd5:c798 with SMTP id g22-20020a17090669d600b00947ebd5c798mr1937589ejs.54.1680607732655;
        Tue, 04 Apr 2023 04:28:52 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id i1-20020a170906444100b0091ec885e016sm5803140ejp.54.2023.04.04.04.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 04:28:52 -0700 (PDT)
Date:   Tue, 4 Apr 2023 14:28:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 1/7] net: dsa: microchip: ksz8: Separate
 static MAC table operations for code reuse
Message-ID: <20230404112850.xjsxiku5w23fcsof@skbuf>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-2-o.rempel@pengutronix.de>
 <20230404101842.1382986-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404101842.1382986-2-o.rempel@pengutronix.de>
 <20230404101842.1382986-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:18:36PM +0200, Oleksij Rempel wrote:
> Move static MAC table operations to separate functions in order to reuse
> the code for add/del_fdb. This is needed to address kernel warnings
> caused by the lack of fdb add function support in the current driver.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
