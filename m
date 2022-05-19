Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C32352DC07
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243552AbiESRyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243460AbiESRxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:53:50 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DCDCDA;
        Thu, 19 May 2022 10:53:45 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gi33so2910061ejc.3;
        Thu, 19 May 2022 10:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sgrwK+j2yWEYF7Mxi+16rw3HUhKH66/j3hYzPNTlcSA=;
        b=Xv+IVeuC6ykZjSTEAJ1vQKfNgthe84KfbhJQv2WeHw56k8pzOVi5p4kyDM0dfdnNgi
         JlZ27xvO5us6L161Mz8p7WqSOLcqFe/8FxMJMYY6IuEhHmgLd1VT2fMHvaI1tjP4BoBQ
         9lc07RayOlQ+OXgCbSFc2zzQZsM/YuXKvM0O5ohf7bBJ/3WuAk+YYQRwT2hTr0UcsFWK
         f+AusIB+ahDRCKvWyjzBn3S3CpYPfair2XHqi96KQVhA0VNWhhpefWnE5vEZjgzStpGB
         yCFzQucfP+aLdEjaigqOfwlvxkSNhyYVWuOLXDbUf85FvjH3iLkTbEb55YbE11XL4UM9
         V58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sgrwK+j2yWEYF7Mxi+16rw3HUhKH66/j3hYzPNTlcSA=;
        b=5SPSTtEesYRzp9hWN9m1y1ZaiILYjj7MDk4EnFGttQ1SCYucvZpQJQQDJCCMy8O7cy
         Uzfs/ZLUCpV9Y3tTIGrj/2OvpsB/JAdonOYVVdiG/xZWnTXD4aLQEFgkhyBFO7syOl8M
         OKGwZxQ9+L77ZLSMlAwGg6xtHtE59eolGrO1RC6wKlV9WmwUVmWb6EiD73UzMrDTTt6l
         /LX9w+4WPL82v+k99LBelNMOzHrDJojVM4wpp63rtr7X0qt+p+yupDd69+sK+ak+Ui0D
         RgbMrlGMO1J8XTAuPrIOAb4pUw/pu+AdPVp04rPc+tATR4mUhIDFQTutps3BEa7RaS9A
         5PqA==
X-Gm-Message-State: AOAM530SRlnxL+5VTUGk6qEHqB90pJ3zweoWYbiMVvhySDjZ4x70q6rP
        6bl00+xeh91zs33ZyLb3MYUZMepYX2w=
X-Google-Smtp-Source: ABdhPJwCT7BuWabCj+hO3YTl6oimsYDda1ZBuXZU0EaMF92dBAmBSQiNVA3e5WNe4LllDTMiMsIfWw==
X-Received: by 2002:a17:906:cb97:b0:6f3:c671:a337 with SMTP id mf23-20020a170906cb9700b006f3c671a337mr5288125ejb.93.1652982824048;
        Thu, 19 May 2022 10:53:44 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j4-20020a170906104400b006f52dbc192bsm2383809ejj.37.2022.05.19.10.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 10:53:43 -0700 (PDT)
Date:   Thu, 19 May 2022 20:53:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 01/13] net: dsa: allow port_bridge_join() to
 override extack message
Message-ID: <20220519175341.fheue7mng3os7hkl@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220519153107.696864-2-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 05:30:55PM +0200, Clément Léger wrote:
> Some drivers might report that they are unable to bridge ports by
> returning -EOPNOTSUPP, but still wants to override extack message.
> In order to do so, in dsa_slave_changeupper(), if port_bridge_join()
> returns -EOPNOTSUPP, check if extack message is set and if so, do not
> override it.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
