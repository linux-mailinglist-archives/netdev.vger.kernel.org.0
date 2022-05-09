Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D137E51FE4E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiEINbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiEINb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:31:28 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E181C7428
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 06:27:34 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k2so19443990wrd.5
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 06:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QFVN/hz05R4qwSXg2D2znBc/cojLhJAL9Em25eSEyUs=;
        b=6xRVzIssKst/rqxxPREtWICDSxF4w5ikEyLXgYtiyHfwoFR62qzHqhy8MmdXwbFsiH
         EN1s7NRkVK630kW4S0DZ8IJ4ek3A4DIcX+O5sQVk13Q5lSzHcx+ZBJ6N+nE+qVOEutxO
         YhmV0NqHQZ6GKsIJ5dcqIY3iRnJ92q4763GClOxJYQgCR2IVAZSWhvlNBcYgqyEf2mdg
         sL+s9a0M0uDwEKlJN/ZRwI8qqGgM6Pnv9w9kBxO7UHjmLq2VG1/cwAQFjwhwWOk6DmS3
         WXcsuMHOTqvaPxA2qMLhJfzMUCLGkMXpGJWTgG01bCjZr8SOd9rBJH3+ZJfZg+FsqZvJ
         mKpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QFVN/hz05R4qwSXg2D2znBc/cojLhJAL9Em25eSEyUs=;
        b=8CYCnQYYmYBLdpLHW7oAzWJYkhY/PA2ogtjICNoGb1UCuyBILbK0+sFHgag8N+AIOk
         s8vmcmHEfXA75NnYBLfAvFoe/svGP9uG0uRqES/ujpdmDY+dME+pXjEyEfONtuzUik4L
         2CPyiacMUxj8RZ0e5RgHKNLJq+x+RPhkvVEo+2WpFVaoGjQWC5C4/v/AvjC2afUqrOw9
         XTai1UuyA5vIzAkL3uKw0PKO1nHUCE/NEXbzubKTroypfPmQaL/f/G+QSl80f5OQAQpF
         3zv9sERZdREgczmeZlnwaW1zzY9Tg/4P99xtoAZ0Jwks3XEunFl71IDBaPbmQdoHnwj6
         yGLg==
X-Gm-Message-State: AOAM532BcHNhRIwKcprLtnGxA76M6vkEuohapRjviI6KgBX/OX4M1sCe
        26WgRgPObdQX9E5dD0Cnj2qiTA==
X-Google-Smtp-Source: ABdhPJy2ss8Dz2yhDwsiVDbK2gmSF+OzAXLxhmvGcDLqB4SyyXjhEvJqTERDh5KjiXjGgI2r7WmGYw==
X-Received: by 2002:a05:6000:1f03:b0:20c:4d9e:7400 with SMTP id bv3-20020a0560001f0300b0020c4d9e7400mr13919108wrb.257.1652102853452;
        Mon, 09 May 2022 06:27:33 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id n7-20020a05600c500700b003942a244ee1sm12434830wmr.38.2022.05.09.06.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 06:27:33 -0700 (PDT)
Date:   Mon, 9 May 2022 15:27:30 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     alexandre.torgue@foss.st.com, broonie@kernel.org,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 0/6] arm64: add ethernet to orange pi 3
Message-ID: <YnkWwrKk4zjPnZLg@Red>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <YnkG9yV+Fbf7WtCh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YnkG9yV+Fbf7WtCh@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, May 09, 2022 at 02:20:07PM +0200, Andrew Lunn a écrit :
> On Mon, May 09, 2022 at 07:48:51AM +0000, Corentin Labbe wrote:
> > Hello
> > 
> > 2 sunxi board still does not have ethernet working, orangepi 1+ and
> > orangepi 3.
> > This is due to the fact thoses boards have a PHY which need 2 regulators.
> 
> Why PHY make/module is it which is causing problems?
> 

The problem was stmmac support only one regulator for PHY.
