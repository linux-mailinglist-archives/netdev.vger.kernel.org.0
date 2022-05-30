Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1AD537501
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiE3G2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 02:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiE3G2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 02:28:07 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0353F25C5E
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 23:28:07 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 137so9307117pgb.5
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 23:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lCzAr8nL1qXffTgU3cFq2CijWkgjVBAIoLhycWg5B0k=;
        b=de5ZVG2JK/tey+aN1/jchboHd1yljLQI/HHap/Uzr1LUTzOEpLLSs/mjK45hJPTnSG
         21H82TGLYNCu9SL18AEDAB/tKIK4P22Ga6N3It59wejiDAFs7mzB731/09DuhcCM4yKQ
         4swTfgXSW9jd8fBmn0Rkg3NVlCSalzKPAg51mbDHoHdP2s4nGMuiL3nB68TuNlthFzTb
         dNcpm25GGOjSFmjtoxcfQTqxpJygKFlBQ6OnCEyJUrJMC7+2A9/rQBPJO0+OzM4JNhjj
         JVWD1hzEUC0oxuPo0CDdp9uVB0cdczM3RQr5tCEgEcwS2iOc/R3H/3xmSosLt3TQU295
         uuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lCzAr8nL1qXffTgU3cFq2CijWkgjVBAIoLhycWg5B0k=;
        b=Cc+5somSQLvv8aiNXnIo66o56OGdrhv9NTwdvRo0Yh0tfDXi0fcTvjcl/MhxOjfLNn
         PIhuQDwGYd6+Gi4HoPr2NbccCmLz+voY3mwV2dG3D3CaK0rmFuSSATD6V07BGvI5Oq4S
         /vFUSoMOaHXQq77YjZIUwFCbAkfMP0U7rNHiehJUgIgyegm3uBXGpHYj3hy93nhEQp+M
         k3UUJYxkV5S3qf46LaEAvwZrIYThZ20nqPWym3GVvB/1q1FkxFu7mfGXpqkhchzAqjuV
         pGiDu+u9vHkAO9D6ZHqqGWw3KtOMwBnvb6jdl9b4SAoRWbACIakFaZIs3Mgwwai8wAK0
         p2QQ==
X-Gm-Message-State: AOAM533SWce8hHhNkBlGBwbcd3wJHF8srjLZ5ZuSGthv05mxX9gOKhoZ
        lMFqyGDG+H4gCFKsRDKx64r8X17XoX9rfw==
X-Google-Smtp-Source: ABdhPJyuCCVEjMWQXPsdW8FcG3wkDrAfmgekpmxoTU1sBwJ/vDLb5Av4pRqKiWiuU4gyOD/i4nB4Bg==
X-Received: by 2002:a63:115b:0:b0:3c1:eb46:6f5 with SMTP id 27-20020a63115b000000b003c1eb4606f5mr47758451pgr.277.1653892086321;
        Sun, 29 May 2022 23:28:06 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b80-20020a621b53000000b005082a7fd144sm7991822pfb.3.2022.05.29.23.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 23:28:05 -0700 (PDT)
Date:   Mon, 30 May 2022 14:28:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>
Subject: Re: [PATCHv2 net] bonding: show NS IPv6 targets in proc master info
Message-ID: <YpRj8DBe0EnQ284j@Laptop-X1>
References: <20220530030319.16696-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530030319.16696-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 11:03:19AM +0800, Hangbin Liu wrote:
> When adding bond new parameter ns_targets. I forgot to print this
> in bond master proc info. After updating, the bond master info will looks
> like:

Forgot to fix the typo, I will post a new version.

Hangbin
