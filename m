Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB5057768B
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 16:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiGQODd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 10:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiGQODc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 10:03:32 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2B912D36;
        Sun, 17 Jul 2022 07:03:30 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id k30so12083613edk.8;
        Sun, 17 Jul 2022 07:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jMRTq+amxNbsBbaOEm6j4FB9NZ1ewtvtmU0mvf4Nm0M=;
        b=IOfVoC11XaS/bWBvLr7Vh11vHQNhwzU0vVkGdNo3Legzm2DOd3dsW/pf8Rh9UjPWvX
         JuW4lEESZ/2apkqE1vo/b/0jvOg/Jf4+7VMt8UaL99wPJ+sn56IuX483kWkcZN3oyoVm
         XToQ4LXI+rik0Y+WztVuU70lo5i92MQulNSXG7vji4vHLtK/VwnrCQx63blturHmJvML
         cdzmEn1GlbHtzRPNw4I/rTk14965Bq/tNQPmfHAUuE5JyL3ItbnQrRJuMi9apyDejczM
         I9t/HENKdlD8vqV7gjUbiCQrU9DiPG1mqk0a1iu25lYshFwxl9SoPiX/JQwBuvT5557j
         EhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jMRTq+amxNbsBbaOEm6j4FB9NZ1ewtvtmU0mvf4Nm0M=;
        b=uS0C73axe89jQHTLqaaXeK14o9vscVluAk0N1Gy8zfgOb9k+g1Phsimld93pBV9Z22
         PVtsnLGRe/K9g61JE2nZZJs6lndRsPAbpPIs9XjPKpDOharYS979TC4WiDWgen3IEW2k
         3FPhQtQf3R6INMtFaepoicJ+bBij+/DTuYlS9EsAy9NzhThAHzgQ14orZoRf5t9N7R0j
         k9/yvzI6//rzUGi15HOuw8EHFjtsAlssIWlSIJ2q5QiUV2dutlnovTx4ziP8qINhiRe0
         uIxiwZ4FGmFwDoNl/kUKqY7RlR99sY5qYq/vGd8WLnIAbFCk9zdId8Y9CkZ5DS4guprP
         tW+g==
X-Gm-Message-State: AJIora8Sw4X6uRu109OBQvc59OfAd1cLHR4xMyj35/WY3xFfPDALM9TH
        gmGAGULWa59roUnOmLGwT0s=
X-Google-Smtp-Source: AGRyM1skUAsFAa+uXtacl2f+72Kz0xptC5vppBw7fL50BB6Blny25XGRyWrXql3Nv8Qfibszf1akNA==
X-Received: by 2002:a05:6402:d0a:b0:437:66ca:c211 with SMTP id eb10-20020a0564020d0a00b0043766cac211mr31694104edb.29.1658066609442;
        Sun, 17 Jul 2022 07:03:29 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id 2-20020a170906218200b0072a815f3344sm4348879eju.137.2022.07.17.07.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 07:03:28 -0700 (PDT)
Date:   Sun, 17 Jul 2022 17:03:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans S <schultz.hans@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
Message-ID: <20220717140325.p5ox5mhqedbyyiz4@skbuf>
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
 <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <20220717134610.k3nw6mam256yxj37@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220717134610.k3nw6mam256yxj37@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 04:46:10PM +0300, Vladimir Oltean wrote:
> Here, what happens is that a locked port learns the MAC SA from the
> traffic it didn't drop, i.e. link-local. In other words, the bridge
> behaves as expected and instructed: +locked +learning will cause just
> that. It's the administrator's fault for not disabling learning.
> It's also the mv88e6xxx driver's fault for not validating the "locked" +
> "learning" brport flag *combination* until it properly supports "+locked
> +learning" (the feature you are currently working on).
> 
> I'm still confused why we don't just say that "+locked -learning" means
> plain 802.1X, "+locked +learning" means MAB where we learn locked FDB entries.

Or is it the problem that a "+locked +learning" bridge port will learn
MAC SA from link-local traffic, but it will create FDB entries without
the locked flag while doing so? The mv88e6xxx driver should react to the
'locked' flag from both directions (ADD_TO_DEVICE too, not just ADD_TO_BRIDGE).
