Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49233579F79
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbiGSNUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243587AbiGSNTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:19:17 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594A89C78D;
        Tue, 19 Jul 2022 05:36:20 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ss3so26852962ejc.11;
        Tue, 19 Jul 2022 05:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mxcLD7aZ6jsY7oFsPYUSToT/Y/wpWE8VHgtc4q9/SHs=;
        b=UMCedSn0uqijFaItw1iI5KA3Xqb/2Y9y/GJ3g0UMPpc9/OIzgjdrO9zpEv5C1Wyni2
         hfuN7dkQOlnuQ6TkNUySZ7hNe1naFhbh6QjbLhxeBSTs35AhPIJ3ullF81Wpzthr4flB
         PJH9ptYNnvx/5pkadKqfUK0uKg6dF11aHdDouPN0Y3VpEcfxZ3VBsNw0L4qyJj/Lb8xF
         XUJ709vFQCUb3DTBKJPYN8DkTxooVq/xQrRxFZvRhFlPJVjkRfwEsj5cMHc1FKlFUMFJ
         1Pb7ZlmpY0qK7tmT7hisrI5mJjrdDiDJeQc5/HGLKKvj4CgGUYslIMoBusVjo94y/ELD
         Czlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mxcLD7aZ6jsY7oFsPYUSToT/Y/wpWE8VHgtc4q9/SHs=;
        b=vnR0btXLq6eui3F4V1MIT9UMKN9XtBqIasUhCSCmLMptFrWWkP4iM0W18M+/nK9SpU
         qrAUGOoronr0ZiUHFVy8zRAgU0BeBANSA4S3unwo9Y1GtVGG3C+wn1DFVCb0jgg7mDSD
         k2nTG6cqEobG8q4DZrLeZIHen1NPVPesFKn1pdwny3bN32LYASRUYQVzvPmDHZqcl6ED
         euVaV3oywPWl8jrdDEdJBBSgXuW9UdpL8MaVzyo/JKbxyUis1YJFMMvjk/isMZ9NTw9H
         /+YqGrTjKv8CXmWugiBqdPyESCf3YoFiKBn1yAESu2vQSORVI6KIw6sNwFrYZbNybwSN
         GNjg==
X-Gm-Message-State: AJIora+vV+zxaZjUvoCbCO32P2nDOjz7gdOM2wVFGahxRyStKJemRNrT
        Fx82OosgYTlIp6By7JbJmfI=
X-Google-Smtp-Source: AGRyM1vnqAm8mBYSI0RJubE81r4PBFBeZqZ0fyTuSJUxeoZ58Tg8crAGQYRszmO3VvxW0HJ/rfoYHQ==
X-Received: by 2002:a17:907:3e05:b0:71c:2ba5:1ab with SMTP id hp5-20020a1709073e0500b0071c2ba501abmr29551417ejc.93.1658234178540;
        Tue, 19 Jul 2022 05:36:18 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id mb17-20020a170906eb1100b006fe9ec4ba9esm6629945ejb.52.2022.07.19.05.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:36:17 -0700 (PDT)
Date:   Tue, 19 Jul 2022 15:36:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 02/15] net: dsa: qca8k: move mib struct to
 common code
Message-ID: <20220719123615.yazpogreu5cw7oxg@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-3-ansuelsmth@gmail.com>
 <20220719005726.8739-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-3-ansuelsmth@gmail.com>
 <20220719005726.8739-3-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:12AM +0200, Christian Marangi wrote:
> The same MIB struct is used by drivers based on qca8k family switch. Move
> it to common code to make it accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
