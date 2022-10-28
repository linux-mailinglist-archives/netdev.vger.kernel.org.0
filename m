Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0115610F5A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiJ1LG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJ1LG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:06:56 -0400
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970721D0D7C;
        Fri, 28 Oct 2022 04:06:55 -0700 (PDT)
Received: by mail-qt1-f181.google.com with SMTP id cr19so3249604qtb.0;
        Fri, 28 Oct 2022 04:06:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BjzbETfFX+gqI4cCnhy09ae2F5HDKhvax3GK6w9Wn+Y=;
        b=QfH77EWyshcjJm6XiNDsaw0/CX7elopk9ce/PqEPGtIa37huR8NhqtLinBB54IwE/d
         JB/v8cDO30dvuIiB90nlmeKnN+/5knGytomm5C46JB9MsPCmYKVLLxdEf02zfAcr3boN
         GNdcOSMY9DsSCfrObkAmgNaLKY+tm9Q7fc9hS2C2u5bL7FqFE4H8XFIlRi36adq2765D
         jv2nOc6zS4KEQk7S920QPgFSjLM19huP+s0E7f0dY0+/xwnoAtzUZv/X61xypHKkhm81
         EEmz45TKjeQKOZre0PxnLXIA8Ck3ApO6s9Jc/k+q1izAQYHqNedOwo/xKE3SQyzothEc
         Yo5w==
X-Gm-Message-State: ACrzQf3mkIRd/AiWGTZrtQLVBU95BA7+pSLDsU79mOi6RXKiMQwvF5b8
        9mQfncimKLDfdUJJZP4gHTMHKN0swArBsA==
X-Google-Smtp-Source: AMsMyM4/w6nHdqaVjEjLeUxaDQQTJEtnXQcZ/NS0NVYFRmShLH+90T6CAkwSDTTvf/qvppxfTPCzBw==
X-Received: by 2002:ac8:5a50:0:b0:3a5:ce3:a657 with SMTP id o16-20020ac85a50000000b003a50ce3a657mr613317qta.277.1666955214558;
        Fri, 28 Oct 2022 04:06:54 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id d9-20020a05620a240900b006b8e8c657ccsm2768807qkn.117.2022.10.28.04.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 04:06:54 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id o70so5728824yba.7;
        Fri, 28 Oct 2022 04:06:54 -0700 (PDT)
X-Received: by 2002:a25:687:0:b0:6c2:2b0c:26e with SMTP id 129-20020a250687000000b006c22b0c026emr49498878ybg.202.1666955213909;
 Fri, 28 Oct 2022 04:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be>
 <20221028102932.lfwrm3ahhhgtndsu@pengutronix.de>
In-Reply-To: <20221028102932.lfwrm3ahhhgtndsu@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 28 Oct 2022 13:06:42 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVnBiXuSgDtZwkj_uf9U+M5-8oaG_Shr_zAyVb2hJCngg@mail.gmail.com>
Message-ID: <CAMuHMdVnBiXuSgDtZwkj_uf9U+M5-8oaG_Shr_zAyVb2hJCngg@mail.gmail.com>
Subject: Re: [PATCH] can: rcar_canfd: Add missing ECC error checks for
 channels 2-7
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Fri, Oct 28, 2022 at 12:29 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 28.10.2022 12:06:45, Geert Uytterhoeven wrote:
> > When introducing support for R-Car V3U, which has 8 instead of 2
> > channels, the ECC error bitmask was extended to take into account the
> > extra channels, but rcar_canfd_global_error() was not updated to act
> > upon the extra bits.
> >
> > Replace the RCANFD_GERFL_EEF[01] macros by a new macro that takes the
> > channel number, fixing R-Car V3U while simplifying the code.
> >
> > Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Is this stable material?

Upstream DTS[1] has only the first two channels enabled, so it's not
critical. But it never hurts to end up in stable, helping e.g. CiP.

[1] arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
