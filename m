Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7D26B9B68
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjCNQ11 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Mar 2023 12:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjCNQ1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:27:16 -0400
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A9662854;
        Tue, 14 Mar 2023 09:27:14 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id d36so20749791lfv.8;
        Tue, 14 Mar 2023 09:27:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678811232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9oIpm0eT0DP/I6oQIoYbqYKkBRemzVBGZPTe1HlXAS4=;
        b=vWov7LW7KgPn2R8DxyIV+0573LzVeMo0Lqzp6e99A2rjNHWiheoyy3LokGhxxVloSJ
         INo1Si3JDIcUIDjJzi82J9+kU2Zp8ATX3fRfYbdgna4VywB7f3IiKlJT1pWCJGsslp+q
         wOtzPnkCUoDmeincvp8Os9kZ9GERSTudraN1TVzKb8KULI7toaqns6uAGJuNv4B4yRd2
         fV+Zqx/bcfY/Swc3dm9HrH8ZYn0xA1nSs64UrhUDup3SPKU8Usni7CrF8HIfc2nBK6ue
         TnlnOXg37/7uzyR3LENO0J5mZA2f7nS8h9Scsvk9YYQN7SYbk+/5OAKTd8X25SFDf+3a
         GHvw==
X-Gm-Message-State: AO0yUKWlOscmTsNCwmbhGNu5jUuwfJ/x0HNcl83iD5H8X40Apb4nLh+K
        J7qnassaAyhmLFdlLnBKLGgZH93uKQCfKoqz
X-Google-Smtp-Source: AK7set8mY/HIHWGv+SEa3H2+w0rFrXSWZauuvBzL6v9Bx1LtUnW9FL92X3YNbfmnxNjlGouejUDIRg==
X-Received: by 2002:ac2:5d6a:0:b0:4db:d97:224d with SMTP id h10-20020ac25d6a000000b004db0d97224dmr1047750lft.19.1678811232267;
        Tue, 14 Mar 2023 09:27:12 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id c17-20020a197611000000b004b57bbaef87sm456239lff.224.2023.03.14.09.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 09:27:12 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id x17so4633916lfu.5;
        Tue, 14 Mar 2023 09:27:10 -0700 (PDT)
X-Received: by 2002:ac2:55a6:0:b0:4dd:9eb6:444e with SMTP id
 y6-20020ac255a6000000b004dd9eb6444emr942775lfg.5.1678811230105; Tue, 14 Mar
 2023 09:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <e67f2f58d00faeba74558ae2696aa22cd0897740.1678784404.git.geert+renesas@glider.be>
 <ZBCYCrrYSdXpvGbJ@corigine.com>
In-Reply-To: <ZBCYCrrYSdXpvGbJ@corigine.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Mar 2023 17:26:55 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVAH9U196oCcxPsUT-z0qk4ZBkx8+nGqrJN14q8uGsQFQ@mail.gmail.com>
Message-ID: <CAMuHMdVAH9U196oCcxPsUT-z0qk4ZBkx8+nGqrJN14q8uGsQFQ@mail.gmail.com>
Subject: Re: [PATCH v2] can: rcar_canfd: Improve error messages
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

On Tue, Mar 14, 2023 at 4:51 PM Simon Horman <simon.horman@corigine.com> wrote:
> On Tue, Mar 14, 2023 at 10:00:26AM +0100, Geert Uytterhoeven wrote:
> > Improve printed error messages:
> >   - Replace numerical error codes by mnemotechnic error codes, to
> >     improve the user experience in case of errors,
> >   - Drop parentheses around printed numbers, cfr.
> >     Documentation/process/coding-style.rst,
> >   - Drop printing of an error message in case of out-of-memory, as the
> >     core memory allocation code already takes care of this.
> >
> > Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> you forgot to sign-off.

Thanks!

Checkpatch told me, I amended the commit, but forgot to re-run
git format-patch :-( Sorry for that, and stay tuned...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
