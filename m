Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471B3528355
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243229AbiEPLeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243176AbiEPLdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:33:55 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E35F38D9A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 04:33:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gh6so28148983ejb.0
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 04:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5RmYQNjMaDXtg0d2ywKtVBJLck9qQ3g81Ehrxp1OiOo=;
        b=EDxSsTPpXZOFKHkEMpLT6zecVMOn9f20Bq9PqsKtfMlf2S6Z8JCJf7HfZ57xfpocCW
         5Spld9fRluI1UaEiDMdAS28c2lL9m/nvxo7UCG/K437i+EF8XULHqqJvwIL0Ojgas0s5
         aOFKF/UVMWgLDdvimP5wr55t7sSVKzZjfDL4pp0DjUd6dINSE6ZlBiDkzTuYuw1rvRZu
         KBauXIyrqZ6tq7ZoMWkMjl8x3j6+/1V6RhDt6VpYBEDWS28VDFraSXv4XyLUhCjFVy2s
         KvxjRARLnIWU90QExd7q7Rc/6z0NBL184X1oRLq4B916ZYh5n77vostZw12N0ilV9lYx
         9f4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5RmYQNjMaDXtg0d2ywKtVBJLck9qQ3g81Ehrxp1OiOo=;
        b=V2k2M8Cx/pXYRWyFLQQeLNANos0V5/XdXRI9scN1050QMnBDt373iTItdxw0YF3WHM
         EYivFeutZovHS9OKH3AWqwvZNEMU81oGcwbK8supwyhrlx8A54J9/OArqVlvzZ0JtyEi
         XK04hZ1IySw9+3iFAgPWFap3/rQ0Rao3Bpl5cM2p9cqgvX/RzpaH72SYZu7+yPExZ4mv
         DzmbQirHLXQHj/A3cYcsZLhpk9Hi6ytJrxCy9p9SpPPUaQ3WiJJ0wMMKFW11NvgbYMVk
         vdgmPpgIS/kQWEHwPdyrmGf5umFWUBrzQRtOGLMPAFmBIIgts2XBcagdPu8wxIxxHFS3
         ngxQ==
X-Gm-Message-State: AOAM533GJrsGuiCoe8K9UmZW9q5RK3bIp9+gJH3WvAw/XRoEsZGi8UC1
        fum9qNDaTKSllnqon4mQaak=
X-Google-Smtp-Source: ABdhPJzqLRLuAmuQx+Z5ywo/PsNQUHYyaxC9dPOrvYIOIe18OzD7NdaQN1F5QVWoxaZ97nszdCawng==
X-Received: by 2002:a17:906:7954:b0:6f4:dfbe:acd3 with SMTP id l20-20020a170906795400b006f4dfbeacd3mr15127331ejo.416.1652700831644;
        Mon, 16 May 2022 04:33:51 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id j5-20020aa7c0c5000000b0042617ba63c7sm5004924edp.81.2022.05.16.04.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:33:50 -0700 (PDT)
Date:   Mon, 16 May 2022 14:33:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v3] net: dsa: realtek: rtl8366rb: Serialize
 indirect PHY register access
Message-ID: <20220516113349.766fky6yyqadv7e5@skbuf>
References: <20220513213618.2742895-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220513213618.2742895-1-linus.walleij@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 11:36:18PM +0200, Linus Walleij wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Lock the regmap during the whole PHY register access routines in
> rtl8366rb.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reported-by: kernel test robot <lkp@intel.com>

I don't think I would have added this tag.

> Tested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Explicitly target net-next
> ChangeLog v1->v2:
> - Make sure to always return a properly assigned error
>   code on the error path in rtl8366rb_phy_read()
>   found by the kernel test robot.
> 
> I have tested that this does not create any regressions,
> it makes more sense to have this applied than not. First
> it is related to the same family as the other ASICs, also
> it makes perfect logical sense to enforce serialization
> of these reads/writes.
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
