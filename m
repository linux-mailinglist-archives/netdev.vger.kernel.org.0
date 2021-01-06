Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30C22EB7DB
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 02:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbhAFB4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 20:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbhAFB4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 20:56:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227A9C061382;
        Tue,  5 Jan 2021 17:55:37 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b5so770884pjk.2;
        Tue, 05 Jan 2021 17:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M2SnuavxPcXUJasCexKnjXWwhRBi46twzYFZCFVtxIA=;
        b=jaDmkjxUvv933vnXaE4le+w+4C0Bd4foHxhGcP6dcW/tNQyBdvdC1uMwWxXqUJtanL
         h/JnWWeoprKpQ5HR8NxHvwUySBVL7w0jELn2jUrKjC7FlK89tbyez+y1IiScIIvPhxc8
         AiXvSOYqXH3Np15o8MSmUnThKxABfQxLT4vZq83I3lWVJISw1kh2vfPKoNvJc1xvaOJB
         fEPXTm6XgOztjw7QJS08uxTdw6zqn8T3nnquHMHqFjI5ukqv+HRTwSJmCpQOx1bV3Xkd
         NG2cHtrZOP+7buEgNt6n5rNGFG8hzxitWbJV1V3FRmCJPCs/DS99SJmJmqTU06qHid4e
         DJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M2SnuavxPcXUJasCexKnjXWwhRBi46twzYFZCFVtxIA=;
        b=Gm4NK1HjAkIyZFrndQ4RKI0zXoUbRudM6Lpluk6pub1t8h/Vq6MjsNUKWhXzdb/k4i
         fgUDbhR12HmfZB5qdgRnEIf8lqAV3+m3ywDb1jda2G5wuo2jRUQTG3dgUuhUitJsm2h7
         O2wTqqrcizMbELImebwFqAWTn8qL052zC0zIgnvMpyXc01XRGyTpvbj7Wtzm23AXqVjq
         rBqHMChSQlG4zwzoz/V8QfhwLUN8cz32BmLUOhXFbKcJerrajq8PHPd3qbwHO+P3Fmbj
         gpIAySaZ8EUdr5+qKPYV1vXxSAxuJqE897Rt9papNXkiuWTUCUinzqu8UwH9rSbeFbZl
         j2jQ==
X-Gm-Message-State: AOAM5335hddFYcwt693gwDcgKmDbd9S+lEdw6CiNR0Y3lo5vJe4R8b/+
        Sf/5sOuuL5PjHb5t9X2s9JfibKu+uNA=
X-Google-Smtp-Source: ABdhPJyBKCiWl8KqpA3d/9qhuLzYJM2/8URZ+PH/AyWme2ojcsE4nRsA6SZa1w/6+Y6vqjUiBP87Hg==
X-Received: by 2002:a17:902:6e02:b029:dc:8e14:a928 with SMTP id u2-20020a1709026e02b02900dc8e14a928mr1938073plk.24.1609898136435;
        Tue, 05 Jan 2021 17:55:36 -0800 (PST)
Received: from google.com ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id gm18sm425052pjb.55.2021.01.05.17.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 17:55:35 -0800 (PST)
Date:   Tue, 5 Jan 2021 17:55:31 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Add missing array size constraints
Message-ID: <X/UYk4RESSfjCIPI@google.com>
References: <20210104230253.2805217-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104230253.2805217-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 04:02:53PM -0700, Rob Herring wrote:
>  .../input/touchscreen/elan,elants_i2c.yaml    |  1 +

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

-- 
Dmitry
