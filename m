Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC044CDBA0
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241496AbiCDSC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241494AbiCDSC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:02:26 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9811B989D
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 10:01:37 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id p20so12115726ljo.0
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 10:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5IIyu3V6JyZxTM4QW6XDn+zJ4BNFrrgaUMPNXlXD3rc=;
        b=UitQJmKRYIi3XZTJMbylshPqv8vGQ+3FgxsTTHVVz4mqaiJsbjaMBivswMaIsg1X6z
         kG1HT/WWh6TXjxgFCnOG4KlWZQzay/cQAzhpTSUO5NuPs7Dx4pAqSuW/1lcfbwCZBKQ1
         +36ay/fBApVGdwFKWLXyR+GyfWDuKseXonuzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5IIyu3V6JyZxTM4QW6XDn+zJ4BNFrrgaUMPNXlXD3rc=;
        b=W7Jgtg033ZcOR4g5a36Ohbe3lvgUiH0ZYwzyoJ+A/xDW+5V1aJ48kaP1YiW5T7Ay5H
         5cJsY+h2kxQwMikwf4MDnWugN5tCMtSc+ulvHTS0xXJjmA5YcWbB/Q7Yhuf0fee04+4+
         RZ82+KeNNx6UTbGxM8oKXocdfK+AY19aw5bEKNGpSctziWPUrio82gTxf8l3sF+4wy+O
         42a7nrW6FcbpKq7Dl1j8uldQ9+/W7AGPTD+a1tK7WFxuHRnSn1fYyVstS4YO20E6HVIb
         +7BuIIiLy2rNmNlPRx5PserxNkszXewcj9cJDdVbf9ma6fpWH2yDey6JjmzydI4eBG9r
         nshg==
X-Gm-Message-State: AOAM530ePtVSwNG9kJM0m7CgOULs8WqOZr7TZ8CMMK3dQtxdSxBA/fd0
        1hn/66D4eWOjZ9FtrsYcus3holdGsN1KPIkS
X-Google-Smtp-Source: ABdhPJzq756IxYFVSaT+to7qTF4xUZkmvClAytlDe+fAokOImGzPt2dsDwYxDW42h1PTlUSwh2Ubow==
X-Received: by 2002:a2e:9b54:0:b0:246:3b89:83e with SMTP id o20-20020a2e9b54000000b002463b89083emr26303541ljj.489.1646416892049;
        Fri, 04 Mar 2022 10:01:32 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id o1-20020ac25b81000000b00445bc956180sm1171893lfn.283.2022.03.04.10.01.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 10:01:28 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id 29so11991161ljv.10
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 10:01:28 -0800 (PST)
X-Received: by 2002:a05:651c:1505:b0:246:8fe5:5293 with SMTP id
 e5-20020a05651c150500b002468fe55293mr14863391ljf.152.1646416887860; Fri, 04
 Mar 2022 10:01:27 -0800 (PST)
MIME-Version: 1.0
References: <8a99a175d25f4bcce6b78cee8fa536e40b987b0a.1646403182.git.daniel@iogearbox.net>
In-Reply-To: <8a99a175d25f4bcce6b78cee8fa536e40b987b0a.1646403182.git.daniel@iogearbox.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 4 Mar 2022 10:01:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=whDLyNRipPBv5Jebmb6K84Q-eAMi=d0t6-gnC2wyQ2-1g@mail.gmail.com>
Message-ID: <CAHk-=whDLyNRipPBv5Jebmb6K84Q-eAMi=d0t6-gnC2wyQ2-1g@mail.gmail.com>
Subject: Re: [PATCH] mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Willy Tarreau <w@1wt.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 6:27 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
>  [ Hi Linus, just to follow-up on the discussion from here [0], I've cooked
>    up proper and tested patch. Feel free to take it directly to your tree if
>    you prefer, or we could also either route it via bpf or mm, whichever way
>    is best. Thanks!

Applied.

Thanks,
          Linus
