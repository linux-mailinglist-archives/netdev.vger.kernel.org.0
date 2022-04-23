Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B36A50C82F
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 10:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiDWIJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 04:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiDWIJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 04:09:01 -0400
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100ED18B27;
        Sat, 23 Apr 2022 01:06:05 -0700 (PDT)
Received: by mail-qt1-f170.google.com with SMTP id x12so7035393qtp.9;
        Sat, 23 Apr 2022 01:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MnsKeIXdOWL+qzKGmeKdJ+/k4zo4q4coagprsKaIqao=;
        b=50LLgeICQMYEHCGzTMVsYBaia6P4/Sj/MQsSMwn5Y/MO5sbWpwTyKvBUp1KbCAToVB
         fMtvKAAMDEDMWKLk7B8a3z2GGj5FEqI9c++BKfrB0ejY2MbCXI7hNM46eNCkkYUUaa5j
         RCB/NlK2TzZnGJdSDhPn7HDF1tO7vJ+INFnWU7UtqCwEagGr6PidZ61tu0MPX6uabGE5
         hkJSJg3Au+OH7QpbrZgFRTNmhEcudFtLgI++9OOHR0wPJIHFhFFxcPSql4AJh3M3HhPe
         TvSQ5aTO9XHQm742Na255pDV0d5FHlAu/MTOPNFoOcBNfDaLx+uELtnwiR3rJeLBCmHI
         iwzA==
X-Gm-Message-State: AOAM533lbLR9y/e1tWMQn28vvvykjAu+o94PKrRCFFyAW1O5hlIU7Q/z
        ebLOhiFHS+j2HnD8HJ/DAJnyk6VQsnrzyg==
X-Google-Smtp-Source: ABdhPJyzFyUzhtRKooaZxY5e32ekOZF9n9jze/MIsSQAmgUqA5O1HKJgnjDOXK743w4sWH6UKQfIsw==
X-Received: by 2002:a05:622a:105:b0:2e1:d653:c325 with SMTP id u5-20020a05622a010500b002e1d653c325mr5794028qtw.75.1650701164124;
        Sat, 23 Apr 2022 01:06:04 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id z15-20020a05622a060f00b002e2070bf899sm2527344qta.90.2022.04.23.01.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 01:06:03 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id b95so18391783ybi.1;
        Sat, 23 Apr 2022 01:06:03 -0700 (PDT)
X-Received: by 2002:a5b:984:0:b0:63f:8c38:676c with SMTP id
 c4-20020a5b0984000000b0063f8c38676cmr8029426ybq.393.1650701163360; Sat, 23
 Apr 2022 01:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220421070440.1282704-1-hch@lst.de>
In-Reply-To: <20220421070440.1282704-1-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 23 Apr 2022 10:05:51 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUw6c-dEOJUyZaQqOj=udmk9X8pxyd-nyph4K4at7iaDQ@mail.gmail.com>
Message-ID: <CAMuHMdUw6c-dEOJUyZaQqOj=udmk9X8pxyd-nyph4K4at7iaDQ@mail.gmail.com>
Subject: Re: [PATCH] net: unexport csum_and_copy_{from,to}_user
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 11:14 PM Christoph Hellwig <hch@lst.de> wrote:
> csum_and_copy_from_user and csum_and_copy_to_user are exported by
> a few architectures, but not actually used in modular code.  Drop
> the exports.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

>  arch/m68k/lib/checksum.c             | 2 --

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
