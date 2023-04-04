Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E566D5F01
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbjDDLbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbjDDLba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:31:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137D81FF6;
        Tue,  4 Apr 2023 04:31:28 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y4so129280205edo.2;
        Tue, 04 Apr 2023 04:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680607886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jFHuFKKi4rQm4ZP3Fz/VY2+l1+/JoDUMQKuP+SQAqWw=;
        b=SswoNsbzl+ZMEoytaP5tXiVnz5N9Tp/81XwHikDZs7p//GPRd56wdPVS2OAcisqjxF
         GNLxQK55Y5rRT/Ls7T2szKhhCNW49WVs7ZI3ubiWmdjKVbjmcEN2FKElPbkiU9EQe+jr
         ZgklwE/NiQhP+Fhr1Pdk2HPzr/oSJWyZnVxiItnUKizY7+x4aqe1slaud4LPXqBgtDAf
         T8pL5Q2P2ZF7jpwoPBswjLdLUa2eC06LzMgxI/mXgZE0ksKTXNT07m4Y8PE5odwb+CmO
         OynexCtcxHRLhR+TQgEn5xaw3g0IPrxpMccKhrE9Wp9rRUoDxFVmUFPM5srN/YQO0RBI
         9OhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680607886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFHuFKKi4rQm4ZP3Fz/VY2+l1+/JoDUMQKuP+SQAqWw=;
        b=5I1rv+bHIwLZQFXuZXXdx++9OCDz7LyGtXQvu9g/f0hqPtL9UFPWWZxXjM1sK2Wlu8
         0tMef7gMlv7Maf7MZzn1Alp9Ck0bdFksa7vb/GuCZiVURo/O7JfwnIMTIJYrByKMFa0j
         SqFozEbOIJag3G4HKvikn7ZcmNAaz3OJGBqBjls5ZWs4Semi06L7nPmipE9F1Z3g1ugu
         5mlwrmy0KUcu/gFkKCA+C3uHv+PnmVijgX4f2E+ljjuutCCb++AgqG0P1ik6ux7KeoO3
         bwpNC/lZ0+7/+VQDxHrCZpOUrZPvBetYwqLqJ4MKrEN7tgowSpkprKsoTu9/kGc8b+DE
         TzsQ==
X-Gm-Message-State: AAQBX9fp7i45N5+quJRPuulP/qs3Umz0kNKXq6aw4NHLkGVwLhkt6SSm
        O4rih2pvCYKyueYhoeDUKQY=
X-Google-Smtp-Source: AKy350aNyUVVypN7M+rHGx/v6Dzdaq0Xbvb39McCi8gg9iQti2CJerQI5A96aKDWVXPExHAnI7YvXA==
X-Received: by 2002:a17:906:b110:b0:927:dfc6:51e6 with SMTP id u16-20020a170906b11000b00927dfc651e6mr2470896ejy.6.1680607886410;
        Tue, 04 Apr 2023 04:31:26 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id gy15-20020a170906f24f00b0092fdb0b2e5dsm5881906ejb.93.2023.04.04.04.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 04:31:26 -0700 (PDT)
Date:   Tue, 4 Apr 2023 14:31:24 +0300
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
Subject: Re: [PATCH net-next v1 2/7] net: dsa: microchip: ksz8: Implement
 add/del_fdb and use static MAC table operations
Message-ID: <20230404113124.nokweynmxtj3yqgt@skbuf>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-3-o.rempel@pengutronix.de>
 <20230404101842.1382986-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404101842.1382986-3-o.rempel@pengutronix.de>
 <20230404101842.1382986-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:18:37PM +0200, Oleksij Rempel wrote:
> Add support for add/del_fdb operations and utilize the refactored static
> MAC table code. This resolves kernel warnings caused by the lack of fdb
> add function support in the current driver.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Side note, I wonder if it's so simple, why this was not done in
e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")?
