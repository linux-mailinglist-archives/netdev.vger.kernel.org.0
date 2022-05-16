Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6975528327
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243131AbiEPLZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236967AbiEPLZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:25:08 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77D738BC6;
        Mon, 16 May 2022 04:25:06 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id j6so27953570ejc.13;
        Mon, 16 May 2022 04:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FAyKn2oVoJTgO/RP68nqhP+j2lXd/q2JVNgbNaZ+dpc=;
        b=JYn69KIG4UBolrDrCsRYtWe1ZXP4+cTogUmMtyLOMHzjVZXkAYQsZLNnGCG718PyIu
         SM03ntAF7aSP5+b2dqJlkJRWY5Vr4U9J2ArrCjFo77l45+pJBUuGNWTvZJejgCY+5b4r
         f/vqFWpnWSCR0FKYVRe9mXmjv9oscxNT24yknFrAAoE7lXjHvnywhF+iBbDajCMsk4ac
         2onuT4A5Q+agCgbs1FA4RrdPUIODHG1FQQVETZJFYhELQCe5igr56PpXZXT80dZs7Sul
         f8jDuGhauApX+jYCoxXkNQqF+dozRB5j2RojAxH0d+bpiMnDuZsGB5+6LC9d6ivttY+N
         rzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FAyKn2oVoJTgO/RP68nqhP+j2lXd/q2JVNgbNaZ+dpc=;
        b=LhhnH/dj1+tlJx6JvLXuP21EQ9zzBOBcK5OtDAfnVKr79TRWsWfGFaLZVGH02tFwmY
         LMBuRLtk2ImB2zCQFx1xFe8aZnGt14k7yuTJCRyQR8e1rJwZO0jnVzSHIzjcjlQRUb5N
         z9dldFk+EMayy3ZsWexLuBBVkB7mLW7wPGLojLceIdxXze8PX/YhYFEC032kaFbSXrxn
         Gm0HJN1xVEfTfjK0fL+/YDpQJDn/Q2nS71FqTEr2DPgv7LETVoRdRtw4YMWsA3u5qa4+
         jbdcCSiEijHgNrtuEcTgD+JAxoD7zhKFshaoPc2gVg1tf3XyTLXgXyyMO3pXmTk1ovVE
         p8WQ==
X-Gm-Message-State: AOAM533H1PD10Dy+e/TJT35x4RL7R+GyxLCKUgGii06VHHe72ejEtrqn
        6+tu+8pOGWHCzikYcc/j8PA=
X-Google-Smtp-Source: ABdhPJzlqcQD9tVQXFcak4oBjynwnouaMxLBhkGJLa87ayVKXzRNu8yC3sGNb0lHRBr+WziUNpuwLg==
X-Received: by 2002:a17:906:4884:b0:6f3:a042:c1c6 with SMTP id v4-20020a170906488400b006f3a042c1c6mr14631567ejq.363.1652700305430;
        Mon, 16 May 2022 04:25:05 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id i24-20020aa7c9d8000000b0042aa40e76cbsm2863634edt.80.2022.05.16.04.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:25:04 -0700 (PDT)
Date:   Mon, 16 May 2022 14:25:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC Patch net-next v2 7/9] net: dsa: move mib->cnt_ptr reset
 code to ksz_common.c
Message-ID: <20220516112502.xsv6uyg6vtc7hfbo@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-8-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-8-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:17PM +0530, Arun Ramadoss wrote:
> From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> 
> mib->cnt_ptr resetting is handled in multiple places as part of
> port_init_cnt(). Hence moved mib->cnt_ptr code to ksz common layer
> and removed from individual product files.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
