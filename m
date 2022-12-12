Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C9064A7A1
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiLLSx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbiLLSxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:53:30 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3BAD2F3;
        Mon, 12 Dec 2022 10:52:54 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id d14so14285905edj.11;
        Mon, 12 Dec 2022 10:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iPCgrlviixbG7fOLs6i0IAsETKWkHMzoOpHKYUaDEYk=;
        b=HwSSl+40WQy8PHXeSUcOdLyUorLDaMS9Lijwmo7u6Y+dzpqsh+SP0WO6UyzGtFdqoX
         Maa/0TAiTFq3MWXfnWSAhucyCjsoPCE4k/StCZ7oIoZ6TvUkBhpMW+UeyPWAeiQXgQ3R
         erwhUHNP1/sK/TPm/ESiPtRNnIibQYZkG95HDbjcos9zVOxktnuLVB8Y6/Roe/DREbEN
         b2QpUi0ua26HCbkEypvbqc1rccBuUgswFgGtEHS5sfBI7XzItWHJaxFMBDTCwI0tFlrJ
         CZOAyTZnek9HJoGV3MGs2S1KSVFWfbO63zJ0hwmo2wyeujO80G+AOwdGBg1YpeY1M+Qa
         s2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPCgrlviixbG7fOLs6i0IAsETKWkHMzoOpHKYUaDEYk=;
        b=x/W/crxxhUS/w9hqatvgo7sy4Tc9NMfPkwx5SkdtffsMwP0DP52dkF8Pr+5Eec3Py4
         9Shu6NEygvA9+GBV9EWm84GOXmOCoKgV+VGMrz+GW5WPuXXUicZeiOZfLG3E8zGF398N
         NxcAR5Lz0bzs9hRey8LRYwGFJHUe+qmdEVH2Ql88vPy1LNnLp9nZ+JWH1SJya7SaSmdB
         rgQpoIJYytnLmGnpP5zJNn8DMlL7gQ39xjlqljUvuMn9NYxal+MRqH9sNEz2gMzkGU8Y
         pNjlcPqxFrtIvKs7OL5e378tdiBi6zGWnYNsUhUsKfOOKedcqJDsirZ3e56LdgQXWGNr
         ma+w==
X-Gm-Message-State: ANoB5pkXugMPXY1kQit7vjPysjcwfNWl0UeXbcT+2ELCzi0yMeokYkAr
        U+K0ZDCVPpY7x/AMTqUeHi4=
X-Google-Smtp-Source: AA0mqf5CAnzhtACya+XFABsMs7TzlVqewVFKf9KdarDIN+sQM2F4ORjjVz4XBP4GoTYV9kdty2IBpw==
X-Received: by 2002:aa7:de0f:0:b0:46c:43ff:6953 with SMTP id h15-20020aa7de0f000000b0046c43ff6953mr18540244edv.13.1670871172735;
        Mon, 12 Dec 2022 10:52:52 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id q26-20020aa7da9a000000b0046b25b93451sm4104460eds.85.2022.12.12.10.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:52:52 -0800 (PST)
Date:   Mon, 12 Dec 2022 20:52:49 +0200
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
Subject: Re: [PATCH v5 net-next 06/10] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Message-ID: <20221212185249.do7un6kajlzgnd63@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-7-colin.foster@in-advantage.com>
 <20221210033033.662553-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210033033.662553-7-colin.foster@in-advantage.com>
 <20221210033033.662553-7-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 07:30:29PM -0800, Colin Foster wrote:
> The dsa.yaml binding contains duplicated bindings for address and size
> cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> this information, remove the reference to dsa-port.yaml and include the
> full reference to dsa.yaml.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
