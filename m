Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3400587B9C
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbiHBL3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiHBL3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:29:11 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33648313AD;
        Tue,  2 Aug 2022 04:29:11 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i14so6648487ejg.6;
        Tue, 02 Aug 2022 04:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P+fnogDd7o4OY7BAR4CYY7dnrQWbdlhGqxBKs5TNoyM=;
        b=p1ONeknWmH33zcO71kmb9HqzoGkHWpDgEE8atOi7MdkP7ta85QD8a1BB7FsjU9tY7M
         znSi989DBBdAxA7cAxJ+rUrJjaz91Facm53mzh3heHvBh6kfgdV5ROMfJnBJqJOS7PBj
         Il4YgkKrl0dXfrPICezRm+x14Mr0BcQcXrcuDFkpignNqz6BwFCSSVPTAcCsqyrlmgK6
         S1NUPF7YA2R9B2JeHQGwy1qkftWo040uCqIzGvAgtsnVdIsZ0HBfiC01QE2+ndxR/xsa
         xnskZt9bQ/32Fz+V0twj0V9C4yrmoZ6V3S+QcVZI2BBUyJBu45L5Pi640AKM+JIX/qbN
         jvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P+fnogDd7o4OY7BAR4CYY7dnrQWbdlhGqxBKs5TNoyM=;
        b=BQhfq6BhblC1r+U0xS+zDOL0DpRuOXrfU092dv3/rBhc9DIpnCp8186/mykU/Cvv11
         aSAWswK4KjobDsFqcrTqG52zqOEYXldsCsU2FC+6iMRb+9RULThzxACHKIyi9/8GiA7o
         U9Aql+Bs3hP8j7CU+0i3O0Z3oaOqUk9I/+zvpHUS3NxkGX0GTdmmBQ4cD8cRViLg3R1F
         WNVppS8eM9D5XRE2xjQcH9kqfuJ3VVvH5d9RoFdXZNZx6RYoa6Ju0Sk18LHV0XVv8wtI
         KUHUfpR6Fd8yiZKmSHwWps2t70LTNRNlmmLnNLZSSrPku+/XItATFHhu9tVVVImoG++b
         +65w==
X-Gm-Message-State: AJIora+amyrZ3frTvuhPkbNXJzRjTCgzj7qujY5vzvAC1L3XYDs5Gl2x
        Qfon406OyeKEOESlSXiSJYs=
X-Google-Smtp-Source: AGRyM1sdiaGLJPythTDLa/EJL1jnyVY4BuMWtsDpcOqMpoYTh0p4hnVKlYviDnr3SABe/PzHYyLSZg==
X-Received: by 2002:a17:906:8cb0:b0:72f:367e:9986 with SMTP id qr48-20020a1709068cb000b0072f367e9986mr15375087ejc.80.1659439749769;
        Tue, 02 Aug 2022 04:29:09 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id s21-20020aa7cb15000000b0043cfda1368fsm7945225edt.82.2022.08.02.04.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 04:29:09 -0700 (PDT)
Date:   Tue, 2 Aug 2022 14:29:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 05/10] net: dsa: microchip: ksz8795: add
 error handling to ksz8_r/w_phy
Message-ID: <20220802112907.ktcokf4giwgunekb@skbuf>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-6-o.rempel@pengutronix.de>
 <20220729130346.2961889-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729130346.2961889-6-o.rempel@pengutronix.de>
 <20220729130346.2961889-6-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:03:41PM +0200, Oleksij Rempel wrote:
> Now ksz_pread/ksz_pwrite can return error value. So, make use of it.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
