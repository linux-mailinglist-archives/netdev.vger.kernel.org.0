Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BD45835E2
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 02:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiG1ACj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 20:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiG1ACg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 20:02:36 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359DD4C62E
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 17:02:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id b11so354188eju.10
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 17:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UzFmumGlhWBSiubw4vmZ2Q4tOYSiKg3jrj4LIYo7Ij4=;
        b=oNFUEbHrUvfPjVMn2p9N1Ny0CWiN4nC80jPcoOK6To7rs7ELdLbO05kcL0IY14ZJJs
         7QZGs0uKTm48vMxhUZADjFQtFl8sJVIyPekJHg1iN9T82KPY+5uoEWNHPyfP7OHpwUTF
         T/XgZ3XELbA9APAV38XwioXvs8qu9HPAW2aa2DACiMhpArd1/3hOSUhtdFLxtt4PnB/g
         ZHtzc0dS2eI+JV8z/UIOYvoZK8fRtNlsfCagJxZQvqBLC0DkaOtfjp4eS6px7Tnugq2N
         tCSmhJoENhaTJIXLGepjc3iXxUmBIWS0+Miu7H77t0oRqxWbH3Ae98u6/SE4qWFDNEZf
         SO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UzFmumGlhWBSiubw4vmZ2Q4tOYSiKg3jrj4LIYo7Ij4=;
        b=3x/TJnhyfj76aTXLrCPpEG/AH1Y4iDV/YDZamp3BZRDv/l42/EvnKo1YPuQIqt/OJG
         PRwdq131V5SdfoeCWlf9gTzS7yNOoxy+lpGvWAiw7/mIK0FoEa7Pjg4FHh6Vn/Nhurql
         +JP/GEP3DcrelU8C5QxrnPlExjsi2d0D7yyq4y0no6AqGRlD31KLkx+Ol5aWvPGHQNhS
         GhErC63YwoHFL7g2oL+Ry84NzSTJZtoo0ekNiyHvxSJ069SRSMW8B5n+a6JWQpQDdltX
         J+X0MvzH1gcjqV+YTetd5UgutaIKGhrfPOFopPS3e2A6H4MWclQJoSpAR1Y/oAvjAbD8
         3ZvQ==
X-Gm-Message-State: AJIora8R9YxV+NWp8MhHL+G0vucyW9TrTC8dorGBih3B3E5kvK8sl0Na
        EwnL7riFIZ/WKHwk2VlcxJ8=
X-Google-Smtp-Source: AGRyM1v9dR/2VFGv/B8Fn+hgPha1sedP10s7Z+9awW42ns0a5zn+AMVCTDeO/Vlg1ctJFKRVjnyU9w==
X-Received: by 2002:a17:906:9bef:b0:72b:40d1:4276 with SMTP id de47-20020a1709069bef00b0072b40d14276mr18979537ejc.360.1658966553411;
        Wed, 27 Jul 2022 17:02:33 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id eq20-20020a056402299400b0043ce97fe4f7sm200149edb.44.2022.07.27.17.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 17:02:32 -0700 (PDT)
Date:   Thu, 28 Jul 2022 03:02:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
Message-ID: <20220728000230.kfwd5rkn433f2ecf@skbuf>
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <7dba0e0b-b3d8-a40e-23dd-3cc7999b8fc4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dba0e0b-b3d8-a40e-23dd-3cc7999b8fc4@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 02:07:51PM -0700, Florian Fainelli wrote:
> Since I am in the process of re-designing my test rack at home with
> DSA devices, how do you run the selftests out of curiosity? Is there a
> nice diagram that explains how to get a physical connection set-up?
> 
> I used to have between 2 and 4 Ethernet controllers dedicated to each
> port of the switch of the DUT so I could run
> bridge/standalone/bandwidth testing but I feel like this is a tad
> extreme and am cutting down on the number of Ethernet ports so I can
> put NVMe drives in the machine instead.

tools/testing/selftests/net/forwarding/README

                             br0
                              +
               vrf-h1         |           vrf-h2
                 +        +---+----+        +
                 |        |        |        |
    192.0.2.1/24 +        +        +        + 192.0.2.2/24
               swp1     swp2     swp3     swp4
                 +        +        +        +
                 |        |        |        |
                 +--------+        +--------+

Most of the tests assume these 4 ports, otherwise the topology is
mentioned in a drawing for that particular selftest.

The names used by the tests are actually $h1 and $h2 for the host ports
(extreme left and extreme right) - these terminate traffic - and $swp1
and $swp2 (mid left and mid right) - these forward traffic. In the
drawing from the README, I suppose the names "swp1 ... swp4" were used
to illustrate that you can use switch net devices as host ports, and
also as forwarding ports.
