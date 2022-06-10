Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005EB546B8D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346194AbiFJRQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbiFJRQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:16:23 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC8B3980A
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:16:18 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id c2so24409412lfk.0
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1f4PdYI0+XFCfgDcQE6pqyWgELABzPTyKvtYjGN3WCs=;
        b=Jfx04haGJd2f1gEw0cWrEMpj4k7OifBXLDunHuOHCFs0EJuXmVN5tFo8lDzDI7INKR
         4/Jz7rX0udk4zTLXSk7s0ng368SLZyW5Pk0E+wsxg3jpVyILQrcVAwnpduAIJD+1fM8Q
         Uopr9NfrByj7lPkVaNK4zV5BiXTdhnGsPEZlY8mjjIjLLvxi+VMk2dBs+OYht6DmTzOx
         9Xy/yP0vmauBpJMbfi788LOxr59LsxmhrB4JpsiWS1ZWv/+DAwD6GT6Ak39vYXnp9GbQ
         dNn7HS8cwkKJ0wSBReIGD6oXtZju3i+oXjIQ8C9yf0xKXdRGyiWHQCVlSesFgFv6yLRG
         /97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1f4PdYI0+XFCfgDcQE6pqyWgELABzPTyKvtYjGN3WCs=;
        b=TxYp2rebW1GDAak2N01tyy1ikwvEmtKkAsUFcWHdn1ptkCFdcQYdyFDL0LzwbRUUZW
         0HPu1Hh4b/oPeS7cgZN1CB8zJAcLedgKGDTmRRjcWZku6cFAofscVTxZ2saYItOytfzo
         qakJ9xPp3tlSk2a6FXNRSy3/2nSexL7M8igVGtRsM3GVxQ+KPZF/JZwpCSy21PFF7zSD
         QBDHFLMCfGfxKs+TT7M9/twjG5MQuLP3BKOAifkS+hxRs8oZOL0lYuZxCFxtuV+aXdoi
         QpsdSbumhUkDuNGTIjnuysiCvGA+shWqj0UiKZpKJNA+cGFQdEaaJ9bfkYc0GJIld2Fl
         qmrQ==
X-Gm-Message-State: AOAM533VFfFmVRlzFZV2RBTS61Lvd/pc9n588SlmQFQBNHe2eZ+0kzeV
        lpBLI8vncSN4ZoHpqxx9gfavPbKL49fCBq8Wq7U=
X-Google-Smtp-Source: ABdhPJzkRC5SLLrAgkNX4bUXXO+fdG0/qLFeeQows2+0y1rLy/wtFSq0i6Js6e4znT6yklzkUh+aGxS0ul76MODUgD4=
X-Received: by 2002:a05:6512:3049:b0:479:1c62:77af with SMTP id
 b9-20020a056512304900b004791c6277afmr22735590lfb.149.1654881376981; Fri, 10
 Jun 2022 10:16:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAMJ=MEcPzkBLynL7tpjdv0TCRA=Cmy13e7wmFXrr-+dOVcshKA@mail.gmail.com>
 <f0f30591-f503-ae7c-9293-35cca4ceec84@gmail.com> <CAMJ=MEdctBNSihixym1ZO9RVaCa_FpTQ8e4xFukz3eN8F1P8bQ@mail.gmail.com>
 <0e02ea2593204cd9805c6ed4b7f46c98@AcuMS.aculab.com>
In-Reply-To: <0e02ea2593204cd9805c6ed4b7f46c98@AcuMS.aculab.com>
From:   Ronny Meeus <ronny.meeus@gmail.com>
Date:   Fri, 10 Jun 2022 19:16:06 +0200
Message-ID: <CAMJ=MEe3r+ZrAONTciQgU4yqtXTJJvXc0OFvJYwYg20kPGQtdA@mail.gmail.com>
Subject: Re: TCP socket send return EAGAIN unexpectedly when sending small fragments
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <erdnetdev@gmail.com>, netdev <netdev@vger.kernel.org>
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

Op vr 10 jun. 2022 om 17:21 schreef David Laight <David.Laight@aculab.com>:
>
> ...
> > If the 5 queued packets on the sending side would cause the EAGAIN
> > issue, the real question maybe is why the receiving side is not
> > sending the ACK within the 10ms while for earlier messages the ACK is
> > sent much sooner.
>
> Have you disabled Nagle (TCP_NODELAY) ?

Yes I enabled TCP_NODELAY so the Nagle algo is disabled.
I did a lot of tests over the last couple of days but if I remember well
enable or disable TCP_NODELAY does not influence the result.

> Nagle only really works for bulk data transfer (large sends)
> and interactive sessions (command - response).
> For nearly everything else it adds unwanted 100ms delays.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
