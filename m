Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04ECD55C175
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344732AbiF1KLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343551AbiF1KLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:11:40 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD342FE45;
        Tue, 28 Jun 2022 03:11:39 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id e40so16865108eda.2;
        Tue, 28 Jun 2022 03:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pbt4Qf81oMk2R1epA5k8cX/w9gLKTqsUsrSKOnxNwoc=;
        b=i5Rtg7TJktu/2++nlbQkEV0IGG7QKd4ZytwnUAaDeFqwtZekkC9mH/uu1d/zNW2Dsg
         89GJI7ik3O++gxUKbK7PHDveaagiNOd003dZtrM5+3LDyUcVLxj4bwchbemzhvi1KiXh
         LchTNCztEwEPn6dmS7dBNlE7C3Di9o8eghYhJ6s5eHPmPuK/psFp9zmu20zaVAlL3uSZ
         4Kn9ep7X7ACYaBxY4jYacnVd5TXMtwxSWASp70LSUxFNfy7mmMPYRlgragm6bPbR/29E
         9raFnqW5gelA204vUtLPC7kdBZnTp9cy45XKnEO6PzvOqPt8lmr6SQrqslM2pGmmAAuy
         PCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pbt4Qf81oMk2R1epA5k8cX/w9gLKTqsUsrSKOnxNwoc=;
        b=wgh9Soey0OR9x+QCzZ0oPABF3Zmqw+Oo9IjCDx5MuErBdkIduhUJM3dVdAOxoVo3cm
         Xly/dOThHK2JGckSKI46MUl538LBnDNdVRH0KkCR/srw7tMr99kdVHLg5b5p+uGWgQT3
         B6XSDR0XqqB4PEWOgvPcD/uleM3Liptxcg1aA0KYOCp+0Q5ARugx7E7s5oGAezBJwYyH
         rj1fbdf5O4eqGJtoh+8qw1ZbFD0anKAIPO/C04y1p6hh1pWcja4bqJFSe9dHVh0XITFy
         l4rM7JgC0bE46IaLFAVXbU1xtg2ti350w2zSdKBtxHizhMj/1njuKoCY2h6eOcByGKka
         NHVQ==
X-Gm-Message-State: AJIora9v3XSX3XW/40wUo7smfl1E9+tl14N5FZCqGoK/IqQX19HYw98o
        KVUh8GtbcwU+R3zrc+ppSF0=
X-Google-Smtp-Source: AGRyM1uhu+dIwDjFl1zyx0UnzJ2W0SVL6rC2GFjQIXz3LejV5w1t4Sib81Yw4NmtbO73eJBfCRB7gQ==
X-Received: by 2002:aa7:c952:0:b0:434:edcc:f247 with SMTP id h18-20020aa7c952000000b00434edccf247mr22051774edt.412.1656411098343;
        Tue, 28 Jun 2022 03:11:38 -0700 (PDT)
Received: from skbuf ([188.25.231.135])
        by smtp.gmail.com with ESMTPSA id op23-20020a170906bcf700b0070aaad0a173sm6206628ejb.192.2022.06.28.03.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 03:11:37 -0700 (PDT)
Date:   Tue, 28 Jun 2022 13:11:35 +0300
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
Subject: Re: [PATCH net-next v2 2/4] net: dsa: ar9331: add support for pause
 stats
Message-ID: <20220628101135.fysq7hn64unbwdxp@skbuf>
References: <20220628085155.2591201-1-o.rempel@pengutronix.de>
 <20220628085155.2591201-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628085155.2591201-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 10:51:53AM +0200, Oleksij Rempel wrote:
> Add support for pause stats.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
