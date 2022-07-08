Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1460F56B6F7
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 12:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbiGHKI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 06:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237846AbiGHKI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 06:08:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E60C413F92
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 03:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657274932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R31VwcSPJiQ7JIw87RxF+TN0+eL/CdtqRF2EIROnvwo=;
        b=A8RuLRs2WeW+xuloAq0M+wdqbbic0CP1VXOHD06JWcQjkcyq0yABos+S4i/ZJ8nc4nY9rq
        iMrRIonCJBnYJotWSCnWeYsLwmet1nkmltBMoZ4n6C8otkFf2eGpnXu+phyjufGXWsMy0M
        8WHaP+dp2TjS/poZvzY9wcuTv+0rWIE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-HpiOXLEONUSB-jJF8v-jTg-1; Fri, 08 Jul 2022 06:08:50 -0400
X-MC-Unique: HpiOXLEONUSB-jJF8v-jTg-1
Received: by mail-wr1-f71.google.com with SMTP id k26-20020adfb35a000000b0021d6c3b9363so2856171wrd.1
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 03:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R31VwcSPJiQ7JIw87RxF+TN0+eL/CdtqRF2EIROnvwo=;
        b=QL8Y21U7CCL8SJ/JSjczI9ziGNt/KiyUl+LaQ9okkAZDpVheNnG+cP2O/CBZqZjoon
         6bwPk3PY1peO5FkHSsHoNXO9220BFxzLgxUUnD1by1J7oCZCPE4ALjsnXmIcFIqpHfW5
         Lu6dWEtPo+ILfgT6fZWKnGwAvSgetTzVoYOcLXE4Ur6nyMpHhgRanOS1tmh2YdQjR1VR
         KgNZxK1mY0Yk8wYkqNedtTHXalI0lRgzCH3KT5nVozY+qpNvQOt8kkJyfZ1GYElrhxEm
         tjcuiCXzcMi01cI3Wpj+/UtLLy/96avr1MxvJ/N/tPuiqY6yjBkFhfYLHq4VfTwCvAHK
         x1wg==
X-Gm-Message-State: AJIora8PplTtvuV/56x0S/MkFoZA54IvQWN3ixYcN7FuZmtaMUroamJi
        2wBMNiu68c1QWTR3cKEMHTtt45sFaPNROicuOcCl4X0qHDmoZKrTvbq8lEFpPBXyW5LyPUXESNg
        PwyBbCv0fHqoeG5PP
X-Received: by 2002:a05:600c:4e8b:b0:3a0:5826:3321 with SMTP id f11-20020a05600c4e8b00b003a058263321mr2822312wmq.108.1657274929787;
        Fri, 08 Jul 2022 03:08:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1syukJVbZC5Q5vHTRyn7SXZAqXHIKjGpeSBXFwl4fsGgBLNx7VcuUla/SxRd4bJfBA7oD8ULA==
X-Received: by 2002:a05:600c:4e8b:b0:3a0:5826:3321 with SMTP id f11-20020a05600c4e8b00b003a058263321mr2822281wmq.108.1657274929580;
        Fri, 08 Jul 2022 03:08:49 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id z10-20020a1cf40a000000b003a2c7bf0497sm1654705wma.16.2022.07.08.03.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 03:08:49 -0700 (PDT)
Date:   Fri, 8 Jul 2022 12:08:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Tom Parkin <tparkin@katalix.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] l2tp: l2tp_debugfs: fix Clang -Wformat warnings
Message-ID: <20220708100847.GA26192@debian.home>
References: <20220707221456.1782048-1-justinstitt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707221456.1782048-1-justinstitt@google.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 03:14:56PM -0700, Justin Stitt wrote:
> When building with Clang we encounter the following warnings:
> | net/l2tp/l2tp_debugfs.c:187:40: error: format specifies type 'unsigned
> | short' but the argument has type 'u32' (aka 'unsigned int')
> | [-Werror,-Wformat] seq_printf(m, "   nr %hu, ns %hu\n", session->nr,
> | session->ns);
> -
> | net/l2tp/l2tp_debugfs.c:196:32: error: format specifies type 'unsigned
> | short' but the argument has type 'int' [-Werror,-Wformat]
> | session->l2specific_type, l2tp_get_l2specific_len(session));
> -
> | net/l2tp/l2tp_debugfs.c:219:6: error: format specifies type 'unsigned
> | short' but the argument has type 'u32' (aka 'unsigned int')
> | [-Werror,-Wformat] session->nr, session->ns,
> 
> Both session->nr and ->nc are of type `u32`. The currently used format
> specifier is `%hu` which describes a `u16`. My proposed fix is to listen
> to Clang and use the correct format specifier `%u`.
> 
> For the warning at line 196, l2tp_get_l2specific_len() returns an int
> and should therefore be using the `%d` format specifier.

Acked-by: Guillaume Nault <gnault@redhat.com>

