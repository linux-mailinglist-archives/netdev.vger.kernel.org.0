Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2388F6C80BA
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjCXPIg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Mar 2023 11:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjCXPIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:08:35 -0400
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A09B476;
        Fri, 24 Mar 2023 08:08:34 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-5447d217bc6so38039267b3.7;
        Fri, 24 Mar 2023 08:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679670513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N4EG/12YjsKFSRgzSyso0lyZedauN20vonDHCdasilo=;
        b=1HrzGMkEnFA9RKcqc6bEGvo56iKoW9oCYubI/Kl1b5sOs93UZ96m+z8lUFwyrbVyON
         19xIEunKBwS8wY0i/4QjuDo70EdRC+QmlsQhX7Jp9fLx03I/2KOco7kbu23djZeb5w8D
         PI5vKc+s9+wPyIz9DBW7XhKnNMLgSyoSPTcqYWCU9P6CoNQ0E/oiW2QFd1iuGmMAo73w
         OlPdWDZKzdub3LlZ2LaqRwU7YuvrNXtnyz6vqJRDV4C+2HzunrQSJcRn6detalHbP2zx
         HPFpLtuXmf9VCvMxHMTSmF/4tCv8ehGPgZSeA49RX5exPv1EQxVfVCXl/BkAIpg0qBob
         757g==
X-Gm-Message-State: AAQBX9cdHdZUzuwJoyOFVME6yTjuYmsOli/t3EjruhQ+GjtmplFQyc8N
        xV3dQrl8C8xzg5+hZMGLx/lT4xcNjJQrNg==
X-Google-Smtp-Source: AKy350ZYNsegg7M94tPNoNkUYzDlgjUqZPB6t+F8mqMLG9wKCgM2Sbq5CSXQbHinsvrLtO4u8D1d4A==
X-Received: by 2002:a0d:e648:0:b0:545:637c:3ed7 with SMTP id p69-20020a0de648000000b00545637c3ed7mr2481749ywe.1.1679670513263;
        Fri, 24 Mar 2023 08:08:33 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id q10-20020a81e30a000000b00545a08184adsm443636ywl.61.2023.03.24.08.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 08:08:33 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id p204so2494002ybc.12;
        Fri, 24 Mar 2023 08:08:32 -0700 (PDT)
X-Received: by 2002:a25:6b0e:0:b0:a27:3ecc:ffe7 with SMTP id
 g14-20020a256b0e000000b00a273eccffe7mr3801009ybc.3.1679670512617; Fri, 24 Mar
 2023 08:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1679414936.git.geert+renesas@glider.be> <20230324145742.j4ec237uxcehivsx@pengutronix.de>
In-Reply-To: <20230324145742.j4ec237uxcehivsx@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 24 Mar 2023 16:08:20 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUKgCZ94evcKL6o4R55CW-pVWM51zCD=vx6f0eTo8KbFg@mail.gmail.com>
Message-ID: <CAMuHMdUKgCZ94evcKL6o4R55CW-pVWM51zCD=vx6f0eTo8KbFg@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] can: rcar_canfd: Add transceiver support
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Fri, Mar 24, 2023 at 4:00 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 21.03.2023 17:14:59, Geert Uytterhoeven wrote:
> > This patch series adds transceiver support to the Renesas R-Car CAN-FD
> > driver, and improves the printing of error messages, as requested by
> > Vincent.
> >
> > Originally, both patches were submitted separately, but as the latter
> > depends on the former, I absorbed it within this series for the resend.
>
> Thanks. Applied to can-next, I've replaced the colons by comma, as
> Vincent suggested.

Thanks a lot!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
