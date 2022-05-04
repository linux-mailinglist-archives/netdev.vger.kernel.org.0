Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D219A51A46A
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352722AbiEDPvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiEDPvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:51:00 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326D51FA4C;
        Wed,  4 May 2022 08:47:24 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id i27so3668475ejd.9;
        Wed, 04 May 2022 08:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TqM11B6n/7I4zpUs+ecH9iPi5qiIZecTmzEvJnM7wU0=;
        b=bSkNvN6Pr0ZvSu4SsAwum52J8rN9eabMzdmB8P0U2GTCvGWXaPNftMyHxDWI3IGj70
         fBTwXRdfHaMCWAr4BbTw9WRr5DDhPiMcLvcQM3v6DsuPIXFLTQ3tE1vN1E0BTQCTfobz
         S/RfYHceQFtTiLLrMqXmZ7IvbrinJ6GAu2zaYMhzgKGQQADxcSvKZxpPhX2mPQKSpsdj
         XcfhBm4uB5VVfkzeVLrYD3azxjvH1JYgCLFWWrxAlhnyUYrD8KgDFtrs5KmIiGpPNkb3
         v6tvtHeOARnIGvXz18jMVC173P1pT6cuLuY+o5ORR7bVmCdAbAlqLN9Y+l4Csmh1AWJp
         kt7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TqM11B6n/7I4zpUs+ecH9iPi5qiIZecTmzEvJnM7wU0=;
        b=u9kGHhs2FR2pApS5WvH7iIMrXI7SyDkTphbhTMwtiJ6Wo8krEcr6gke9WzkPmGLlf/
         yT1pLkMWrk40e8Fx8F8VVaXYcKTd2h6msUea2/q6UYLML8rR+oJ+viy8WhzalEfA6qGd
         nM0oZr7JOACdYfpej9eAk9LDjNJqUgF7PLEDBn3NXBVWVsH/l1HlTFp0fw/CiNwo6nRu
         VIO+PExZmWuMT9C+g+mvaVYKffuH0T2Z5a50IZONSQti4VMrRSoWQqEDFSGQCFOilgAy
         jerkfiSYp7yfA+VNz5JSMWGOXA+9pqMB4p/4YHbbvyYEfOoniv3QwGPCRZ5OBC75+Fqw
         UmIQ==
X-Gm-Message-State: AOAM531+I3nj+tR6rw2soCz/G0s5MghV3d97blLJU+YDb1fXCd9rb8PL
        iai2OaFzCfaSp+U3BmjUHmk=
X-Google-Smtp-Source: ABdhPJyGEcz4aR+WhVvTIsoabj98eWOZrMv6CT4IGXSZM1VRBB9wbW/hJn0VXJoJH/dyxMRBM4lC1Q==
X-Received: by 2002:a17:906:ad9:b0:6f3:da10:1389 with SMTP id z25-20020a1709060ad900b006f3da101389mr20710873ejf.32.1651679242735;
        Wed, 04 May 2022 08:47:22 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7df8d000000b0042617ba638asm9388190edy.20.2022.05.04.08.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:47:22 -0700 (PDT)
Date:   Wed, 4 May 2022 18:47:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v2 4/4] arm64: dts: rockchip: Add mt7531 dsa node to
 BPI-R2-Pro board
Message-ID: <20220504154720.62cwrz7frjkjbb7u@skbuf>
References: <20220430130347.15190-1-linux@fw-web.de>
 <20220430130347.15190-5-linux@fw-web.de>
 <20220504152450.cs2afa4hwkqp5b5m@skbuf>
 <trinity-9f557027-8e00-4a4a-bc19-bc576e163f7b-1651678399970@3c-app-gmx-bs42>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-9f557027-8e00-4a4a-bc19-bc576e163f7b-1651678399970@3c-app-gmx-bs42>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 05:33:20PM +0200, Frank Wunderlich wrote:
> Hi,
> 
> thanks for review
> 
> > Gesendet: Mittwoch, 04. Mai 2022 um 17:24 Uhr
> > Von: "Vladimir Oltean" <olteanv@gmail.com>
> 
> > > +&mdio0 {
> > > +	#address-cells = <1>;
> > > +	#size-cells = <0>;
> > > +
> > > +	switch@0 {
> >
> > I think the preferable names are the newer "ethernet-switch@0",
> > "ethernet-ports", "ethernet-port@0".
> >
> > Otherwise
> >
> > Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> current device-tree nodes using "switch" and "ports"
> 
> see discussioon here about make it fixed to "ports" property instead of PatternProperties including optional "ethernet-"
> 
> https://patchwork.kernel.org/project/linux-mediatek/patch/20220502153238.85090-1-linux@fw-web.de/#24843155

Hmm, I don't get why Krzysztof said to just keep what is used in
existing device trees. The schema validator should describe what is
valid, and since the mt7530 driver does not care one way or another
(some drivers do explicitly parse the "ports"/"ethernet-ports" node),
then whatever is valid for the DSA core is also valid for the mt7530
bindings. And "ethernet-ports" is valid too, so I think it should be
accepted by mediatek.yaml...
