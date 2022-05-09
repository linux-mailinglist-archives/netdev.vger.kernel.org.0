Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5811351F6E7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbiEIINK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238078AbiEIIDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:03:30 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812851CE61B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:59:35 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-deb9295679so13839584fac.6
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73dKpew/ODbtnvYGSJpvXbSYCQqMiE36DamWX/iniPk=;
        b=kJ8Pk2LcOxrOUHKOA6Ec2ywAbj4HcRarUVVMdlzEG7rUaCnz3/gTuBeZpMS4vjow3I
         p2Cg/TPcjVNt1CfmmXu5OFQJ3dYnOa+EU/khZ9sw8urLWyzl9QFhlnHqEZvUqYrAVOpQ
         eRWNkC5oI0v/cwog+/y1VPB1ePFdNMAQMi8JuQ2/Eo8/2lBh3R6WlP0c1++Vri6bTpd2
         Zg7rQbmT92A7RL3Ku2QkENgVydoYvMQhaNfWhBSvmVQcDMpFos8csqrFjPqssJwr3jeC
         VRHFkQc7glpWifLf0vu4m8cjKycLEJ1uuc4gOQrsu2eCv3fAlB1h9lwszpc3koJaknpG
         b4PA==
X-Gm-Message-State: AOAM530x9rxnDvcAUgDs14xBwHQAJbkMY/1rGxewZcPpYpCWPVMgp8zi
        gaoQiYyExRF1drk2KjFk9NHBkZjBW4hM/Q==
X-Google-Smtp-Source: ABdhPJwgqCSZ0yCKMY7Xbn8f90B0uiW3FwLwinXf8hXRk8N5AQVXIvJNNRD1FXhUueN3wn8BkMF01A==
X-Received: by 2002:a05:6870:f224:b0:e5:c30a:fa4f with SMTP id t36-20020a056870f22400b000e5c30afa4fmr6396715oao.252.1652083097633;
        Mon, 09 May 2022 00:58:17 -0700 (PDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id g4-20020a9d6184000000b0060603221250sm4393747otk.32.2022.05.09.00.58.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 00:58:17 -0700 (PDT)
Received: by mail-ot1-f50.google.com with SMTP id g11-20020a9d648b000000b00605e4278793so9570035otl.7
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:58:17 -0700 (PDT)
X-Received: by 2002:a81:6588:0:b0:2f8:b75e:1e1a with SMTP id
 z130-20020a816588000000b002f8b75e1e1amr13330284ywb.358.1652082761496; Mon, 09
 May 2022 00:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220508153049.427227-1-andrew@lunn.ch> <20220508153049.427227-6-andrew@lunn.ch>
In-Reply-To: <20220508153049.427227-6-andrew@lunn.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 9 May 2022 09:52:29 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXY_eC5Tb55t4-1Ug3eAUMVBg0tJAwme2+AMD=1ooYuaw@mail.gmail.com>
Message-ID: <CAMuHMdXY_eC5Tb55t4-1Ug3eAUMVBg0tJAwme2+AMD=1ooYuaw@mail.gmail.com>
Subject: Re: [PATCH net-next 05/10] net: mdio: mdio-bitbang: Separate C22 and
 C45 transactions
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 8, 2022 at 5:31 PM Andrew Lunn <andrew@lunn.ch> wrote:
> The bitbbanging bus driver can perform both C22 and C45 transfers.
> Create separate functions for each and register the C45 versions using
> the new driver API calls.
>
> The SH Ethernet driver places wrappers around these functions. In
> order to not break boards which might be using C45, add similar
> wrappers for C45 operations.
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/renesas/sh_eth.c | 37 ++++++++++---

This part LGTM, so
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
