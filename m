Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FE164A7A0
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiLLSyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiLLSxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:53:50 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510E5A183;
        Mon, 12 Dec 2022 10:53:32 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id i9so1451281edj.4;
        Mon, 12 Dec 2022 10:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p+03j9/sd25fW/ec3sxUeYgGDz5Ls8XeZVp5FCHHr5Q=;
        b=BWcWBOXe1HRCMC3Fw1CdgGd5KDFTli7aBgvPSZ2iL1vdE23e+HBNIEht76Dl3Vu49a
         H1aTVkdOfaGJZbmFCjTCIbJEGN8K5TrikTmcDtzUkrAnOpx+EvDnuuf0atplLZzb/gkJ
         tl/o1rrBvXa3cNZrB3lVrCJLQ9t3uUYDrjvdzzNRrZzGxD71DupYJ2G3uaB+xywi2bMS
         SymVx+rZ2yveg+aWawWEfFbauV/9tMijXetnXadNbdw1+j+JRnx53hQSViQNRF+wPTWH
         sCMb7FnQSqPCFaMsgFazoBQb2lGbXH9Y7GX4hm1l+qrxt8gtMK8obZoqmE5uUMXZy5Pb
         NC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p+03j9/sd25fW/ec3sxUeYgGDz5Ls8XeZVp5FCHHr5Q=;
        b=n1YIHPuUNtwhigOe1tQn+spzSVqQAeE3/TjAIdTgmOSSBN95POzyq+dp4d2n+sUKrQ
         UaJslktuBs+2ZsvxbU/wmuT4Myn5/hhBD47r/wEpxGY+G4rpBQ9oikWTaK+JwiCCc4VV
         XhzkwZhVmEAVnVA6cf6DLupxRID52wxPIsoK75jbZPA9kzQNF9suhgMpPzVqQzVHyFmt
         C4hFd05xRKbqxt7lRCgVKJZyNLKQbt8cnDS25bO65BMj8WBRboCEL85EO8d6AOsZ19sd
         a06GS84SaZozpJXvQfjWwpnzOfM3aPUd/2gKttLBcBDmePEuhbyY6ogCtr+adF/dO8Sb
         YqPQ==
X-Gm-Message-State: ANoB5pkpH7jGgWH3IfMLakA/jBTGQ6VImfoTk9+UXIaazzAQtrQqeJtl
        wHtzyezzrgdR72zlBn/PDd0=
X-Google-Smtp-Source: AA0mqf5FnmsDemXIdm+4STqH3yMbqsw4AXvCXkOqCGK5r0GwQiBqI9JkDVuMyUc3iZDk+BBzsj42fg==
X-Received: by 2002:a05:6402:5483:b0:467:7b2e:8863 with SMTP id fg3-20020a056402548300b004677b2e8863mr14625809edb.12.1670871210764;
        Mon, 12 Dec 2022 10:53:30 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id o11-20020a50fd8b000000b00461aca1c7b6sm4151006edt.6.2022.12.12.10.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:53:30 -0800 (PST)
Date:   Mon, 12 Dec 2022 20:53:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v5 net-next 07/10] dt-bindings: net: dsa:
 mediatek,mt7530: remove unnecessary dsa-port reference
Message-ID: <20221212185327.kbkydi5gcrjgzwas@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-8-colin.foster@in-advantage.com>
 <20221210033033.662553-8-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221210033033.662553-8-colin.foster@in-advantage.com>
 <20221210033033.662553-8-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 07:30:30PM -0800, Colin Foster wrote:
> dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
> the binding isn't necessary. Remove this unnecessary reference.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
