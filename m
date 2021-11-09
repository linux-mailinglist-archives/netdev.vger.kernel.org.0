Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2FF44ACF7
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhKIL51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbhKIL5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 06:57:24 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2364BC061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 03:54:38 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id j21so75388873edt.11
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 03:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=HgQRj8CWzhXY68/Mx1NlPnBDr2bx8E+/AmbTxwzHNHY=;
        b=hwaV/em2Ky7JlUS0MuDvnWnrlKrAivcMzU+FK+v8StnhsWyAExBU5waFc0Jp4olNuY
         280Kx79wGG4BTR5Degc3oAGOr3wHr7i/2spWXwxDQUc5cUpYiJspY9QGmxaofmNAK8oc
         qYE0XqOuuvUpI2tzrUO9MIFS+0olsYF+0humH8Z+jMe2aTM4M8Ef+JJSp4xyWhxv5Zvt
         BnM6EgdfbtblLj+wx1a0axar3hexpGk2xNb/LmZqsboPJqCQfpwfqIrdWfLAjnyCHbV5
         ujFsGfEzjeWOA5irjFnoi94D2FD9dKLuSC3AC8kv0+J6pMj5P4bHoXOozku5UwwFSsKk
         oY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HgQRj8CWzhXY68/Mx1NlPnBDr2bx8E+/AmbTxwzHNHY=;
        b=gQLxFlgpZxvNz0OmidEeK4tzC6FUyeAZFmibRlp9+QXe1pzJcQQrPeS7QgyEDE7pX8
         evcvTKm+8Q74AJITsRjs2Uwn71WrV5v0UzzRrE1cOSyPTI1/23JKWIkkRn0OS98reUNp
         pmuE7K2DW5ThW5OEQUjN49gAfIc5QTHBk1Sani2cLQ4pv1Qs3rzZ1JPfTDR+kaO7Rbyl
         83gbMy/p9dbL2uOCJCYP08y4KOOhqXRvdzupymloEaogvQejaGD1bMUO5UJL36vCFegW
         fiGuQFsMthU5t270mC2rAToeLW1Z5357bsBOtLRwLhIoNznHncfnmyYWNLCUpgGqkVYe
         jI8A==
X-Gm-Message-State: AOAM533C5OciP3LCv4gkZV3iYEbKO180Zit1osILrkciySnWy722iq0x
        QDIBI0KwnxdSGY5YLKVW2w4=
X-Google-Smtp-Source: ABdhPJzVYBndtUopMRLymr6GfHxFvBmKzfwXD3kmwEtLYM/UGbvNE2g5KrdqTRlogeg4orn1LjZEyQ==
X-Received: by 2002:a17:906:b201:: with SMTP id p1mr9036729ejz.571.1636458876653;
        Tue, 09 Nov 2021 03:54:36 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id p23sm11382253edw.94.2021.11.09.03.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 03:54:36 -0800 (PST)
Date:   Tue, 9 Nov 2021 13:54:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH net-next] net: dsa: Some cleanups in remove code
Message-ID: <20211109115434.oejplrd7rzmvad34@skbuf>
References: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Your commit prefix does not reflect the fact that you are touching the
vsc73xx driver. Try "net: dsa: vsc73xx: ".

On Tue, Nov 09, 2021 at 12:39:21PM +0100, Uwe Kleine-König wrote:
> vsc73xx_remove() returns zero unconditionally and no caller checks the
> returned value. So convert the function to return no value.

This I agree with.

> For both the platform and the spi variant ..._get_drvdata() will never
> return NULL in .remove() because the remove callback is only called after
> the probe callback returned successfully and in this case driver data was
> set to a non-NULL value.

Have you read the commit message of 0650bf52b31f ("net: dsa: be
compatible with masters which unregister on shutdown")?

To remove the check for dev_get_drvdata == NULL in ->remove, you need to
prove that ->remove will never be called after ->shutdown. For platform
devices this is pretty easy to prove, for SPI devices not so much.
I intentionally kept the code structure the same because code gets
copied around a lot, it is easy to copy from the wrong place.

> Also setting driver data to NULL is not necessary, this is already done
> in the driver core in __device_release_driver(), so drop this from the
> remove callback, too.

And this was also intentional, for visibility more or less. I would like
you to ack that you understand the problems surrounding ->remove/->shutdown
ordering for devices on buses, prior to making seemingly trivial cleanups.

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
