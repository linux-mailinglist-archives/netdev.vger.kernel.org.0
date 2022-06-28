Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE4C55C28B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241617AbiF1KT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343958AbiF1KT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:19:26 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3172F39A;
        Tue, 28 Jun 2022 03:19:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id cf14so16854494edb.8;
        Tue, 28 Jun 2022 03:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T4BrUsUdQUfI0IrfnrZ7M70Vp/ISL4yw1Ysuq86iaKY=;
        b=YmBTW1323HoH90NQwBLukBkxQlOQqO+46PEQRUvTy8Oe7l2u0y3IEMx6yjEHyOGzxZ
         zKsEb5ewFK89AsupfcN5/qsFNRlNWvOLlgx2zC3ElWtLqf78gtu6AX613QEIVCiI96DY
         L0WpoxYVa/0HVJQpECvqV07fAHmJqlPlEBpe1KPuaGRaPmjp5lj33ICHFcypDxFEbhhk
         VLvFQhL3rXPh84u+7xWxvrVJ6VER7Jgcv8h/Yd4bQ4eVHs+K1Yk0OOTCsSw3vVrdKgBC
         qSVAdyiYbwVzWsQh1ymZ5tCuN+zFfz+592OWGa09yqrHfl3T1xypV1vJ9f1vhCeZb8ct
         30JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T4BrUsUdQUfI0IrfnrZ7M70Vp/ISL4yw1Ysuq86iaKY=;
        b=QUpu9NjDxKRvA68T/NraRKTtQJ1o+sDDRmixmGeLNJj2FYUh3DMrrEZOZm8+SweqQk
         Vu1WVoagTcpjVf5AegPaqPnBzOl5px5neLIrTJTaZaQhJGuNODMfHeuluh0m0ta9YS5C
         UFEAYVxRq3+XIPRvNYiiSONrol/ChKPGlnfVC7aM1ym+6TMN4jcSLxb0S72L3tiu2sZ8
         /u9O6ug6CJ/s8na9+EYACYrEx3CE52yy/3K7rGSSvIZfGg1Lx8vYZLilQWoFe7jAwcWJ
         WAciOH7OQ+GPt2hGlPO05zA5nNm0XzsV55DSbyyZK3hqfF3gFxmGuCGMY4JO4qIxEhlO
         ARwg==
X-Gm-Message-State: AJIora8vcm+6ItgH8tixoYmUjRmzjsbJm974IYtH8bJ6TuW3Va1TfzFX
        QqHbNeW6/SO//L/laNg4Dgw=
X-Google-Smtp-Source: AGRyM1tn3Qma8woAoIzA0KLbUo4XEW6TOG57R6ysb6bO0TxGnQEiRrQDWPYW+2J8KOv46dAwlitlJw==
X-Received: by 2002:a05:6402:528d:b0:435:89c6:e16b with SMTP id en13-20020a056402528d00b0043589c6e16bmr22481154edb.292.1656411548351;
        Tue, 28 Jun 2022 03:19:08 -0700 (PDT)
Received: from skbuf ([188.25.231.135])
        by smtp.gmail.com with ESMTPSA id q14-20020a1709066ace00b00722e603c39asm6308486ejs.31.2022.06.28.03.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 03:19:07 -0700 (PDT)
Date:   Tue, 28 Jun 2022 13:19:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 3/4] net: dsa: microchip: add pause stats
 support
Message-ID: <20220628101906.yvhwlqtugurlenpe@skbuf>
References: <20220628085155.2591201-1-o.rempel@pengutronix.de>
 <20220628085155.2591201-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628085155.2591201-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 10:51:54AM +0200, Oleksij Rempel wrote:
> Add support for pause specific stats.
> 
> Tested on ksz9477.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
