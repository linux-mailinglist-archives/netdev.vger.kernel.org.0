Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C5C6DDEB7
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjDKPBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjDKPBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:01:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D20A5254;
        Tue, 11 Apr 2023 08:01:01 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id q23so11691258ejz.3;
        Tue, 11 Apr 2023 08:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681225259;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LldlB1xQuvcrgZ19lm5xn8CkgAXkGiff2Tg7FMmL/4k=;
        b=Yoo0aRfvEQK9F6//XhMwcVV+RaJVf4NkmUC2vXRokx0C5iOJW4xt9cfcuL0yvImJnh
         Vm4MfwyxKHUN0qdmy6YxROhbtNEwIRsgDd51T3NttEh3lo2kuE9Qej1vPaOgBO4ZtX8Z
         CF5IoI9CPjmU3s/wbSvAvjXy/1hKd0sUhuKxU/E41fDSZZCYl9p4BRyboPObBsHOMdR4
         WdzXlyWyERiho1Lrg/ur1aQEziorEXmLHb1qSXe/5nkVPCfYGvJ2Rgix0QNNgvljaB96
         LpW7VF49HtDfnDByk5NPFX6YBsIXLP1g0JiywB7PoQmiLoTQn5JzUVDH1G5YwsEUV2Pb
         LM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681225259;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LldlB1xQuvcrgZ19lm5xn8CkgAXkGiff2Tg7FMmL/4k=;
        b=tXaYe0KPDF32cy7YWWlKIKRsCIK5BXtuu1bVXEKIlbxd9S2r+htg5vDkxeSVZQtfu3
         fIhbE1honY1JWAJs+EVLAm79MuHyl5NXaHdH3r2X5HZbeco2S2fb0EjoMw/HaekK1Y67
         qgze0igFkHCtbSsk6PuS7birLnrRsV8x9hS3+b8V9e0sreH3S8y1WNHtT/WdB3lP1MqS
         J01J1Rj9QIrL8RhHqYxL3Z3MPhYn1meJYkj3qulJ5C12m9QKCEQjLHKqIHk0vHOGwial
         7eaehDW8AmzKYJVXxyRChEloUq0emfZng/7anFT19HONbTMfiCMmpyMrp8rw4glMcwvO
         9i9Q==
X-Gm-Message-State: AAQBX9c0i+rA/R5P2FoB9iREqdQ6cp9nTcAbjZ0EzjikuXyQcmtkipRn
        bIV+1B8d8wyqG8fdaCCT3Wc=
X-Google-Smtp-Source: AKy350Zl/Ty0ZK+idvPOrU2kPQiMgREOiHAPnRD5rc3YIr69o7pJd6Fu4c/i+CEstt/RDWUoUHh4iA==
X-Received: by 2002:a17:906:3710:b0:94a:62e7:70e1 with SMTP id d16-20020a170906371000b0094a62e770e1mr7257462ejc.68.1681225259410;
        Tue, 11 Apr 2023 08:00:59 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id la26-20020a170907781a00b0094a8e06eaa8sm2124389ejc.185.2023.04.11.08.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 08:00:59 -0700 (PDT)
Date:   Tue, 11 Apr 2023 18:00:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH v2 net-next 02/14] net: dsa: mt7530: fix phylink for
 port 5 and fix port 5 modes
Message-ID: <20230411150056.2uhtoy6iqnt2qopr@skbuf>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
 <20230407134626.47928-3-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230407134626.47928-3-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:46:14PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There're two code paths for setting up port 5:
> 
> mt7530_setup()
> -> mt7530_setup_port5()
> 
> mt753x_phylink_mac_config()
> -> mt753x_mac_config()
>    -> mt7530_mac_config()
>       -> mt7530_setup_port5()
> 
> The first code path is supposed to run when PHY muxing is being used. In
> this case, port 5 is somewhat of a hidden port. It won't be defined on the
> devicetree so phylink can't be used to manage the port.
> 
> The second code path used to call mt7530_setup_port5() directly under case
> 5 on mt7530_phylink_mac_config() before it was moved to mt7530_mac_config()
> with 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a
> new hardware"). mt7530_setup_port5() will never run through this code path
> because the current code on mt7530_setup() bypasses phylink for all cases
> of port 5.
> 
> Fix this by leaving it to phylink if port 5 is used as a CPU, DSA, or user
> port. For the cases of PHY muxing or the port being disabled, call
> mt7530_setup_port5() directly from mt7530_setup() without involving
> phylink.
> 
> Move setting the interface and P5_DISABLED mode to a more specific
> location. They're supposed to be overwritten if PHY muxing is detected.
> 
> Add comments which explain the process.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

We have a natural language processing engine (AUTOSEL) which
automatically picks up as candidates for "stable" those patches which
weren't explicitly submitted through the proper process for that (and
they contain words like "fix", "bug", "crash", "leak" etc).

Your chosen wording, both in the commit title and message, would most
likely trigger that bot, and then you'd have to explain why you chose
this language and not something else more descriptive of your change.
It would be nice if you could rewrite the commit messages for your
entire series to be a bit more succint as to what is the purpose of the
change you are making, and don't use the word "fix" when there is no
problem to be observed.
