Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC33649D22
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbiLLLIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiLLLHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:07:21 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99E511C06;
        Mon, 12 Dec 2022 02:55:43 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id fc4so26855613ejc.12;
        Mon, 12 Dec 2022 02:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ueHMi2mIOmzpz327lFnzb2ZBYr+ALhB5gftG35Fae8=;
        b=a0j4vd2PYcbV5vGVf5kujUaxiBQ0GBPWAizLVh3tEou21Qq8DVGG1dvLL6RoMI4io8
         N5GS1jAeVsS6EXOVKRRMUT6eIyehLYnH77sN9PDfB6dPjswcIM2k0eai/zlvXFyztve3
         wJ0yAfUe0DhSkBSTlCPba8CCLgaw0M8e4NhBXC9OxHWCWi4GE4Yi6vwkB9jBu+Lh+Uwk
         dRVhtIBp/1N8UdfX7L8w5XgLdJjX65MWejcnf0YXuo803ATTuhibwgcjEpNtjWOLfqDA
         FfE4aX21QmTqW8awDBY60YryZa6/kyI3RphpZSV6CcRCkfTM3df8YjnH/CA0RAR9FM/H
         bQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ueHMi2mIOmzpz327lFnzb2ZBYr+ALhB5gftG35Fae8=;
        b=UzXuw2dmYw73AbXVFBKrXjky5MKGhpp2izNEgUmvOa5/6l1obyIzipIAACg+v3u2pd
         Pu5kyxlbvOUc4GdiNurWfJA0lOVkWsSpmr1Gy3ZGnwb5spHPHrm6tEPaPhOH0iR8LvNe
         GNC92fRO3lp4o14I/zcqvk+ajt725TwwFe2hLRNtp+arlZ5NmgSijQVa7sw/FofmZX4B
         A2mDkdf+iSKSlLuzdwkx4Z8agl9KNt3SMH3xxeAfpsmRYAahle80qEAxh4SYAzJX/rsl
         tbO8uJgyp1m/YFbQ2djFgh3R+9QtFOa6cMvNyfJ59jeIUGYruH+iGrsVzqICH5JQUsED
         vbrA==
X-Gm-Message-State: ANoB5pm6qVEKYXcHoC8IGtUtc1H2tLfNBE5LMImEIPnTM9xopbvY3rKI
        fcCpvHHgL7rKr6pSiwk1IFY=
X-Google-Smtp-Source: AA0mqf4xwN0tcH6tlYgdq8vREyR2Z4T8Do7BCzqe/UwSecrAbQSclnTtoDopcOUTqjX6offYOSW+Xg==
X-Received: by 2002:a17:906:2a85:b0:7b2:7181:2489 with SMTP id l5-20020a1709062a8500b007b271812489mr16709516eje.13.1670842542364;
        Mon, 12 Dec 2022 02:55:42 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id u17-20020a170906409100b007c0b6e1c7fdsm3114024ejj.104.2022.12.12.02.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 02:55:41 -0800 (PST)
Date:   Mon, 12 Dec 2022 12:55:38 +0200
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
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v5 net-next 01/10] dt-bindings: dsa: sync with maintainers
Message-ID: <20221212105538.ijybw4v26tozjspr@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210033033.662553-2-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 07:30:24PM -0800, Colin Foster wrote:
> The MAINTAINERS file has Andrew Lunn, Florian Fainelli, and Vladimir Oltean
> listed as the maintainers for generic dsa bindings. Update dsa.yaml and
> dsa-port.yaml accordingly.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> 
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
