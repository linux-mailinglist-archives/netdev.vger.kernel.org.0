Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF056D87E7
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjDEUMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbjDEUMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:12:17 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D847D93;
        Wed,  5 Apr 2023 13:11:51 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t10so143864711edd.12;
        Wed, 05 Apr 2023 13:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680725474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RolzALN/i4hTsXdHwsUEcc9nlet40/ppXVO8mjfW8J0=;
        b=Paa3T8LoEcSkq3oxN5BIUzryrUFeI7Pxhh6k62iQP/whVlGwX8syueCUwZbPHN06wF
         dczcatlFLUyS88+5By2Gk9ghchQrWUFf7/O3ej/vLwCHcPfUf7napfFHtmw1XQ8lwtn0
         a9zu2qSn8WqFY+2dr/BlnQ5Z2ZQxpA4zEyd1bnQyjfx9d7FdH94nK9kHMqj00pwcRvQy
         8V43JXL2sSZaGiITcoWVV5Ff9lFvBK6xrJOzxzkDvtMn3/vfAGNn0muWxTZLS557XKrB
         mtLsMxX1ShOjgnePktwxe1zxVUOc8XEVO5O7tLMXU8GfAUrBRJdmsdv6F1oXGADtD3Sh
         mmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RolzALN/i4hTsXdHwsUEcc9nlet40/ppXVO8mjfW8J0=;
        b=QeUIg5YDn/NGjiduLaxAYKaX2dJpPe4VaVCATWxV3kboln4LlKahuAg8D9mTPHVw1E
         B1SdV7Vd6qWYdETtmS2xy1v3WHkgvVk/W6c6XWRDeqqTy/FbMht/lVIpjr8I3EHrGxGb
         KD7sMb79OjxRlAvJ2RuReTL2htrfW7m+v271DY4M+HLnptRJ9qeQiA8jECtBZ/0sX9m0
         Q+iBVimsDRbhrn1gGe62FjR9W3SD/Gw+xKvQ97eZj5wFXXpNYFGX8sxWOXgHMetlZbPm
         DhpHq/Ar1jBZMuWbZ4hggs/GcCvXT1ajnO2JvctAXwpl+/SWG8oW5S9k+TL7dK6GFanV
         MvNQ==
X-Gm-Message-State: AAQBX9fkzu7Cxa3jxM1E28cJ1EbC/ZdSjE2YVX8UFCqEEoUNK6V2EhSw
        1pjn1G+E8Yy0Lw1emZtLvbjPxXeIbnvTGp9DqCg=
X-Google-Smtp-Source: AKy350aILvRCcVMZX5nsxabLI+H0XyanrsJx7nh9j3yk2Mi2N30LGL70g3zVuxdmzLWFvhyK8H01d+gu0RZkuV8oulI=
X-Received: by 2002:a17:906:9488:b0:931:ce20:db96 with SMTP id
 t8-20020a170906948800b00931ce20db96mr2226783ejx.5.1680725474171; Wed, 05 Apr
 2023 13:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404145131.GB3896@maniforge> <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
 <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
 <20230404185147.17bf217a@kernel.org> <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
 <20230405111926.7930dbcc@kernel.org>
In-Reply-To: <20230405111926.7930dbcc@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Apr 2023 13:11:02 -0700
Message-ID: <CAEf4Bza6BgD2Dr=8M2daiPKBkytsOXHG7XbN=8jv68Tu3Bq1Fg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the verifier.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 11:19=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 5 Apr 2023 10:22:16 -0700 Andrii Nakryiko wrote:
> > So I'm exclusively using `pw-apply -c <patchworks-url>` to apply
> > everything locally.
>
> I think you can throw -M after -c $url? It can only help... :)
>
> > I'd expect that at this time the script would
> > detect any Acked-by replies on *cover letter patch*, and apply them
> > across all patches in the series. Such that we (humans) can look at
> > them, fix them, add them, etc. Doing something like this in git hook
> > seems unnecessary?
>
> Maybe mb2q can do it, IDK. I don't use the mb2q thing.
> I don't think git has a way of doing git am and insert these tags if
> they don't exist, in a single command.
>
> > So I think the only thing that's missing is the code that would fetch
> > all replies on the cover letter "patch" (e.g., like on [0]) and just
> > apply it across everything. We must be doing something like this for
> > acks on individual patches, so I imagine we are not far off to make
> > this work, but I haven't looked at pw-apply carefully enough to know
> > for sure.
>
> The individual patches are handled by patchwork.
>

Ah, I see, so yeah, it would be harder to do in pw-apply then.

> Don't get me wrong, I'm not disagreeing with you. Just trying to help
> and point out existing workarounds..

Oh, absolutely, I think we are all on the same page here. Daniel
mentioned -a in another reply, I didn't know about that and will use
that for the time being, still will save a bunch of time next time.

When I feel inspired to deal with a bit of bash, curl, and stuff, I'll
see if we can extend `pw-apply -c` to do this automatically. Thanks
for the discussion!
