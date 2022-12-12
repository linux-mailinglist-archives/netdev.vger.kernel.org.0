Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAAE64A795
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiLLSwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiLLSwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:52:07 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3128DDFDE;
        Mon, 12 Dec 2022 10:51:37 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id gh17so30524789ejb.6;
        Mon, 12 Dec 2022 10:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L8BagAOtehslyk1SZT2MB25JYzaE7cVai22deGdaHF0=;
        b=GOChkXOnyFhD54OkbbiPmVfsrGGTrwxBa30qOt4scbic06PNfTs2rPI9l7AxYx+FNA
         MHPirb+WhMYo3KM6AMha5dTRt9s69IsLa5ctttyfJMf2k5KDREqemXUXOIO1wU1QHaVa
         jm2oMoj/horG7kCKolRD8PiH2d1iSFzWWic2/O86kQ3CwnmJ/917At8wus3qgu+LOBfi
         1G1oiF2k1h7eILfunxvRJ/9htrgnjelaxqs5piFdMrYz4l3Ns4Lf1Pp7KhRBQ7RUT+ph
         LSBGg1lSzcTmYSdceb6fDYj7ar8dENcuIAonXamK4c0hvJ6f8FX4lr3Lmh6ZL3cAbPZg
         07/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8BagAOtehslyk1SZT2MB25JYzaE7cVai22deGdaHF0=;
        b=c2trKdwfFMzkJG+0EsOc+8khrlHs5gGT/HtKt8/+x0M+DfNFkFKKimQsb7szQTH+mf
         m6kiYa3QHlRnmr7iHem+MkNGBUTbqm5ArBEnog3sF+DdSpGpOS2uW3CMNQNYr7mrU1Cj
         TmaEWMgV869bivB1cHhrJ5GJKLi2T7T1Or6zaHKcq+Pa3etKOrQJPREUWOqIym9rbqrf
         lE0SSUAdDtcTZUY6RDOwPc/i5uiU/q8Qebh0/yG71EKeMHGzyitH8sFB0HoqcnJzaxZ5
         wmCZxxkxgXWMVxmx9GDGC9JRWIkEFCbjH1o8f1FcwGunkhvsUARLUmUELUUxO2HIVCzp
         QrTQ==
X-Gm-Message-State: ANoB5plPNdx2qirJI39EdrSUDDVmHZ5VUIuzY2bAPp99n6INFhU6xePA
        ulZYxLDNd2y22onfK4bERnQ=
X-Google-Smtp-Source: AA0mqf4s/TSH0fOWRZ57YqqsDWVMKuesXl9ixlSkK+CFmTWZDK1Joj3SxRP/xOG6m80UAKzULAS4uA==
X-Received: by 2002:a17:906:d8a5:b0:7c1:6f86:eeb with SMTP id qc5-20020a170906d8a500b007c16f860eebmr5271393ejb.7.1670871095795;
        Mon, 12 Dec 2022 10:51:35 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id 23-20020a170906329700b00770812e2394sm3569189ejw.160.2022.12.12.10.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:51:35 -0800 (PST)
Date:   Mon, 12 Dec 2022 20:51:32 +0200
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
Subject: Re: [PATCH v5 net-next 05/10] dt-bindings: net: dsa: allow
 additional ethernet-port properties
Message-ID: <20221212185132.x3ydeehlbqnu4hwe@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-6-colin.foster@in-advantage.com>
 <20221210033033.662553-6-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210033033.662553-6-colin.foster@in-advantage.com>
 <20221210033033.662553-6-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 07:30:28PM -0800, Colin Foster wrote:
> Explicitly allow additional properties for both the ethernet-port and
> ethernet-ports properties. This specifically will allow the qca8k.yaml
> binding to use shared properties.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
