Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65068568325
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 11:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbiGFJOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 05:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbiGFJNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 05:13:48 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3931A3B1;
        Wed,  6 Jul 2022 02:13:20 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id k30so10305959edk.8;
        Wed, 06 Jul 2022 02:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WKlacHhWVR2IblvCAgYMcCw7cvtmo7gBzlhxFpijOWM=;
        b=UyINPEp8aUU7+iO4UvYReAysG8acJi4s0lW7fYS990hIHuI2KgReqshlPjlC0FcdQX
         RWLEJ1iagzj5JHTLAwg1Tfl34CjKErUg06qCwRi5FpbuqXpIfRK0B8kuUc2l5x+40o+8
         2YldATzAdsq2GhIZIL2D0cZi8oKOkVG5Y5xLvvP4kajNiX5yCXAJSyEYBx1RvA9W9SdO
         piij5Lfa0VXVwqnHofYdHxRPOmYTBO/NXTATLm6C9JRKYr2iRvgzlsZTZRGqO8gtc9pI
         zkPBxco6Fa5B8qkZy3WblPhpXY+1PsQ3ol/zLxC+L8wAov5SdI1JA4byrn/VHyXJavbs
         ZPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WKlacHhWVR2IblvCAgYMcCw7cvtmo7gBzlhxFpijOWM=;
        b=QxR5OpPe3NgjVZHkxNID4w7Mgvcw6XaQKzgi6rmn5TdcUkdgaBseRGdfsFVHDfK+LW
         qhe6gUqffxKYBwr8jvHWxccaa/ThR1eRottwfKm2NQmkTLT10ajPqMSVzGrGZZaNbfSG
         ornZME+JmgmlRk5r1vYTpZ8jQF3eEmPw3seTG0dsDKCTXCpG90vpF2NV/bTtBNQ0jo/r
         Cb/OfvKw5bcMuJ+BRqb9+3CIzWMmEcQ/1X77PlHpLxmiK7TnDOOxNF2f5hWrdOj8ijIm
         b0bKL/Ab/riiu2JY5h2t0CwqmoaY6Z57nESze7yZBTjtdV2/PF7odfLK7dF3yv5IRI8Q
         mqsQ==
X-Gm-Message-State: AJIora808hsnV+UdsynlkTYT6KRbYaZklCtQ/r1z67l8sQQwRm1XoMiS
        PqE6mIIEjoGD9C62az3dzFg=
X-Google-Smtp-Source: AGRyM1tgzHocOxIjG9HexS+g9z9ap2nsem/HblqVyMjIbl5ZbLhG8nAvflW5PCvUObUWjIPHfLadCA==
X-Received: by 2002:a05:6402:350a:b0:435:df44:30aa with SMTP id b10-20020a056402350a00b00435df4430aamr51209856edd.403.1657098799156;
        Wed, 06 Jul 2022 02:13:19 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id er13-20020a056402448d00b0043a5bcf80a2sm6350790edb.60.2022.07.06.02.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:13:18 -0700 (PDT)
Date:   Wed, 6 Jul 2022 12:13:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Wolfram Sang <wsa@kernel.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        openipmi-developer@lists.sourceforge.net,
        linux-integrity@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
        dri-devel@lists.freedesktop.org, chrome-platform@lists.linux.dev,
        linux-rpi-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net, linux-pm@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kasan-dev@googlegroups.com,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 6/6] i2c: Make remove callback return void
Message-ID: <20220706091315.p5k2jck3rmyjhvqw@skbuf>
References: <20220628140313.74984-1-u.kleine-koenig@pengutronix.de>
 <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 04:03:12PM +0200, Uwe Kleine-König wrote:
> From: Uwe Kleine-König <uwe@kleine-koenig.org>
> 
> The value returned by an i2c driver's remove function is mostly ignored.
> (Only an error message is printed if the value is non-zero that the
> error is ignored.)
> 
> So change the prototype of the remove function to return no value. This
> way driver authors are not tempted to assume that passing an error to
> the upper layer is a good idea. All drivers are adapted accordingly.
> There is no intended change of behaviour, all callbacks were prepared to
> return 0 before.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---

Assuming you remove the spurious kasan change:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
