Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F64A5170EF
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 15:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385502AbiEBNyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 09:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385510AbiEBNyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 09:54:17 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5482D13D1E
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 06:50:48 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id o11so11063034qtp.13
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 06:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FKyVeyLgHkEQUP5zKlRmzxCXPCayNY6mEIuID1O2OeY=;
        b=ZtYyJFTxfZTbWCuzpnyJatB6UqsJZvi64t4cxcJLZqoL4fBS5kXKKYlGEejyt7Mo2L
         /Z6G7ua4xKcw4Orm99abuybDa4z/figAUfsZMbFap+Csopj6pvJAnr2YjvoOu0C6DlQr
         ITGQrqu/7Lv0PcRIhc49/mXF0TKpsNyBEYsmFu7OxbRTcG1YS0WFRbHryo9A7ImzDf+h
         EirFCLptPptmCat+/fqRrAN+q7kEtrePQH3zUJ3CPmfBjxYIkwQk7/b6A7xq40ISW7or
         6rx8G+1pouBzn9OmZzGIY18XseLQzGNpzfmZWZUGfFW8/AHtH6H25hhE61qQLcUMDZPN
         aePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FKyVeyLgHkEQUP5zKlRmzxCXPCayNY6mEIuID1O2OeY=;
        b=17xx6Aro6JtRSt+Z6C8J9dbQ2gi3ZIK8yeVk0lTpqlPdwRnNSYpWqLVdmAAAi0zuJa
         tl3pdYcP4rk7tGA33G0IpasKBrAe+pXxtMfGFb3bMuNfDkBiDeI76UPsQQyKQEjo2xth
         kfk8U+QVYySU/h8V6gCsbNhbazxXkNFzbCjdWxdZXR5d7h8cZfpVAQu8f3ubhfJuqqzN
         Mek4knoUrr5nFKZMBRjYW7HwL7WOzl3dEOHUaO7oTEj1juLPoLCAEe1cApr7dZI5fJEH
         dGjtoAja1KbvqeG9m0TlCqwd4jznaXXc2+IlHJJfQWMromGbzYZfKfDA+btkZmnVmLIy
         gTlg==
X-Gm-Message-State: AOAM532k6ojvRwU/NQDMMb5egKHSli4hUuHdEgJdg0kSbH/LDByJ9ePo
        gSz0oH0atXtZjz2KIGdhuLQPsSeFahc=
X-Google-Smtp-Source: ABdhPJzAPEOEFwXOsvuc55lHuu9s7QlOIC4BACY+vrohdYQG4BWsSCVkZyifE0sxFNMJP1YCYyNjLw==
X-Received: by 2002:a05:622a:587:b0:2f3:a51d:9215 with SMTP id c7-20020a05622a058700b002f3a51d9215mr4494502qtb.345.1651499447424;
        Mon, 02 May 2022 06:50:47 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id b19-20020a05620a089300b0069fc13ce22dsm4143438qka.94.2022.05.02.06.50.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 06:50:47 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-2ec42eae76bso148133707b3.10
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 06:50:46 -0700 (PDT)
X-Received: by 2002:a81:3d4d:0:b0:2f9:1974:6582 with SMTP id
 k74-20020a813d4d000000b002f919746582mr3124605ywa.339.1651499446455; Mon, 02
 May 2022 06:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220502094638.1921702-1-mkl@pengutronix.de> <20220502094638.1921702-2-mkl@pengutronix.de>
In-Reply-To: <20220502094638.1921702-2-mkl@pengutronix.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 2 May 2022 09:50:09 -0400
X-Gmail-Original-Message-ID: <CA+FuTSesQwCwko9xuNyOz7XU1erpFhHtXDttV88TAGjVr4e1tQ@mail.gmail.com>
Message-ID: <CA+FuTSesQwCwko9xuNyOz7XU1erpFhHtXDttV88TAGjVr4e1tQ@mail.gmail.com>
Subject: Re: [PATCH net 1/2] selftests/net: so_txtime: fix parsing of start
 time stamp on 32 bit systems
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 2, 2022 at 5:46 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> This patch fixes the parsing of the cmd line supplied start time on 32
> bit systems. A "long" on 32 bit systems is only 32 bit wide and cannot
> hold a timestamp in nano second resolution.
>
> Fixes: 040806343bb4 ("selftests/net: so_txtime multi-host support")
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Acked-by: Willem de Bruijn <willemb@google.com>
