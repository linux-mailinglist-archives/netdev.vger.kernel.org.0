Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC8C563436
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiGANQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiGANQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:16:53 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9265723F;
        Fri,  1 Jul 2022 06:16:50 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s206so2395414pgs.3;
        Fri, 01 Jul 2022 06:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zJfX3pSp9eK+4i21OCqEor+kXiHP101ubdkk2RtK/mo=;
        b=GGUgask5amJPB41pdE1pg/srmVShZEqjn8DmMDDpIHYrgzrtdDsJ9rSb+u5EHnGgqy
         VuzwTKjKGvft2Ug1NVmo13MFCKdtsAY2WML71v21NypyUOCOYkwt/NAGjsqkIX5ewR4K
         5k0sGV1LuDcTCeY1JxeiZ2G6RnANyuxxI5UlPWBx6GgKqeerMh1+T39WTJ3sXuWAo3Vw
         y+2Iq0fpM61yJbYlIZLi8Qi3kRhWB8p9rsV21tskCGrXfVLtulBWaj3VDiCdc5JX7tpD
         xMeC2NyuP5nYuhNhvsYCpzMz/p0pduTSs4WaWVN+S2V9ySzZWINuxjgzHpzSBXM6n/Yk
         WVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zJfX3pSp9eK+4i21OCqEor+kXiHP101ubdkk2RtK/mo=;
        b=uu1chhWrZYuHlCM1tCVtPk0vuGL+49zxq4egfv3Bq+FbJAINe2jJJK42hYHBARQ0yH
         lalC4YgUpXXvLOZ7+4VfUx+G9UCZDQZw4qqRC+QdOx6mbdd20STOdVoQ8xX6YxnDh1Q2
         6krQ3TxHXLue69jnYZjjxWuqTAgW5QmrMrBg0C7Hp1CmlSsJ0ug+v5g+MGFHaEjv5nSL
         7wq/5Kymfah000CL5Jpr8t76hF2+DS2WfQH/DvlrAbHU6cczUTUw9yjtafhfttFCP6GU
         7h8NX5/PpWSD/77E3dc6EzwlY71tsmdinVqknG2SlwJwgOdqZo3eKCsyceR18WWa6RUN
         d0qg==
X-Gm-Message-State: AJIora/xBrI3ZthH7nN+j9Dfi8aVLLtLA/tmWNuEFyIbEyjhPlCn+esz
        lJ0xcjfLW1UK8UC7FhVq6F5ctRyF7JtWYqScJqk=
X-Google-Smtp-Source: AGRyM1uLjDkMBnD3Ts1jx3ErbUNqQD9VcFzuBUHAjx3VoJHXei7OjdYID2b6MXTXkr1dVarBmBfgLU+Q3L0UPjII0g4=
X-Received: by 2002:a63:5a49:0:b0:40d:e7a0:3cb with SMTP id
 k9-20020a635a49000000b0040de7a003cbmr12184969pgm.69.1656681410512; Fri, 01
 Jul 2022 06:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220630093717.8664-1-magnus.karlsson@gmail.com>
 <fa929729-6122-195f-aa4b-e5d3fedb1887@redhat.com> <CAJ8uoz2KmpVf7nkJXUsHhmOtS2Td+rMOX8-PRqzz9QxJB-tZ3g@mail.gmail.com>
 <CANzUK58FPeKa_b36=9Wnb2g7fVppmMGBnjORb-dkZUZk3mvp8A@mail.gmail.com>
In-Reply-To: <CANzUK58FPeKa_b36=9Wnb2g7fVppmMGBnjORb-dkZUZk3mvp8A@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 1 Jul 2022 15:16:39 +0200
Message-ID: <CAJ8uoz0AVN2P+=stgHunu9vNMzr=BGv8P=Ohzqb3BqMDhoPWQg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests, bpf: remove AF_XDP samples
To:     Srivats P <pstavirs@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>
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

On Fri, Jul 1, 2022 at 3:04 PM Srivats P <pstavirs@gmail.com> wrote:
>
> > I can push xsk_fwd to BPF-examples. Though I do think that xdpsock has
> > become way too big to serve as a sample. It slowly turned into a catch
> > all demonstrating every single feature of AF_XDP. We need a minimal
> > example and then likely other samples for other features that should
> > be demoed. So I suggest that xdpsock dies here and we start over with
> > something minimal and use xsk_fwd for the forwarding and mempool
> > example.
>
> As an AF_XDP user, I want to say that I often refer to xdpsock to
> understand how to use a feature - it is very useful especially when
> there's a lack of good AF_XDP documentation.

Fully agree with you that we need a sample, but a better location for
it is in libxdp as xdpsock demonstrates how to use libxdp interfaces.
We cannot require that people install libxdp just to be able to
compile samples/bpf/. And the sample should be simpler IMO. So let us
use this as an opportunity to improve things.

> Srivats
