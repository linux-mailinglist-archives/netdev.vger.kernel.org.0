Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53416C998D
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 04:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjC0C0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 22:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjC0C0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 22:26:10 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B44D49CB;
        Sun, 26 Mar 2023 19:26:09 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eg48so29710633edb.13;
        Sun, 26 Mar 2023 19:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679883968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEKMQ//sgZgh2Mb71h08sVFHOl6IgD+xXmIsoUisjIE=;
        b=U50NhQlrcsiBrL+ES0XyqT67HLtli94VrhiODol4xuPdZB6LHOV/GbbPKTsFEE+LRd
         EOroH+0Jh03k2DGByBnhiFvUCImUz7ZqIuFCizBOmFREae5AM6fvyod+Cq0cxReveEsu
         TguP202q2dVbPlaiy1MYlt59WNcVtCbbV5E7dzxlIlkcy79qF8puFfqAcQ+eM2xBZDoR
         n2fIhZa9VLaqziKejQxR+WiD3fYmALN8vzm+qad4pexEm0Y51rTP1ZDYbdfC16ZBXWpZ
         FoDOLCo+cr8hjBGLVeFePsiXmahPVYdhhdKDdz6Y7529Xf3nn5RuKl2cnccnHjP4K0c/
         7PIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679883968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEKMQ//sgZgh2Mb71h08sVFHOl6IgD+xXmIsoUisjIE=;
        b=7HpgledsbxkEYZtusXcY0bu5KE/Uz1LGGabqCh4BxSpBsAwnhvxnVBYDH4cSqwB0t6
         il29/8gb6kly1YFE6tv3aIMm3SlA3yT2S+83jKRf/hjxjoAIP0qtgkAiN6JIhipAalHS
         +VjM84D8FlsuIpmMhp1UVL+wJ9Jj316cYMUzskf2SQVSd+Sy5JZGVIwPJ29PvZZ5oU3H
         0Eq+aM+osWFr9AItPjuM4v0mGWeLOm409eO1znQwcle3Du45fgev9GTtWSnZi3+Y2M0A
         j610gRQNFDUQc+z4c+uBQu1ueR6ZLXoF/pmh5AfmDhdyevx/sBgNoacNzxmILx0hrFaT
         +Q6g==
X-Gm-Message-State: AAQBX9c6JIGF4BlJ5TvNK4WgLj1A9EQdKkJ0WBMLzfTKzU5rT8x5xRWS
        E/85kJK6GLRWAeMnVyKUbpRiYP3HrXOs0C1oEiA=
X-Google-Smtp-Source: AKy350Y5/Ok4YStrnh36ripiu493+BNv+naZFMAGv66y317rz4bigTGy+L9I4nGRvyG44tOX9jsIu4h1kFlDrS3XpiE=
X-Received: by 2002:a17:906:891:b0:8b1:7569:b526 with SMTP id
 n17-20020a170906089100b008b17569b526mr4314015eje.11.1679883967999; Sun, 26
 Mar 2023 19:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230325152417.5403-1-kerneljasonxing@gmail.com>
 <CANn89iJaVrObJNDC9TrnSUC3XQeo-zfmUXLVrNVcsbRDPuSNtA@mail.gmail.com>
 <CAL+tcoDVCywXXt0Whnx+o0PcULmdms0osJf0qUb0HKvVwuE6oQ@mail.gmail.com>
 <CAL+tcoCeyqMif1SDUq4MwfV0bBasgQ4LeYuQjPJYDKYLyof=Rw@mail.gmail.com>
 <CAL+tcoCFPKpDF+JBN1f74BxDJj9q=9ppoPntnCoT0gT6C0r=PA@mail.gmail.com> <CANn89iJLdce57j6fPbLpexp=tzTtw9yDwV7wjT5FbNF6fPkk+g@mail.gmail.com>
In-Reply-To: <CANn89iJLdce57j6fPbLpexp=tzTtw9yDwV7wjT5FbNF6fPkk+g@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 27 Mar 2023 10:25:31 +0800
Message-ID: <CAL+tcoB+xAQWCjznDTmNRfzebJcKa_mTx7-drLWBk_wWbd=G6A@mail.gmail.com>
Subject: Re: [PATCH net] net: fix raising a softirq on the current cpu with
 rps enabled
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
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

On Mon, Mar 27, 2023 at 1:35=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> >
> > Forgive me. Really I need some coffee. I made a mistake. This line
> > above should be:
> >
> > +               if (!test_bit(NAPI_STATE_SCHED, &mysd->backlog.state))
> >
> > But the whole thing doesn't feel right. I need a few days to dig into
> > this part until Eric can help me with more of it.
> >
>
> I am still traveling, and this is weekend time :/

Thanks for your time, Eric, really appreciate it.

>
> It should not be too hard to read net/core/dev.c and remember that not
> _all_ drivers (or some core networking functions) use the NAPI model.
>
> eg look at netif_rx() and ask yourself why your patch is buggy.

Yes, it is. In my last email I sent yesterday I encountered one issue
which exactly happened when I started hundreds of iperf processes
transmitting data to loopback.
It got stuck :( So I realized it is the non-napi case that triggers
such a problem.

>
> Just look at callers of enqueue_to_backlog() and ask yourself if all
> of them are called from net_rx_action()
>
> [The answer is no, just in case you wonder]
>
> In order to add your optimization, more work is needed, like adding
> new parameters so that we do not miss critical
> __raise_softirq_irqoff(NET_RX_SOFTIRQ) when _needed_.

Thanks, I need to do more work/study on it.

>
> We keep going circles around softirq deficiencies, I feel you are
> trying to fix a second-order 'issue'.

Right, going circles gives me a headache.

>
> Real cause is elsewhere, look at recent patches from Jakub.

After you pointed out, I searched and found there is indeed one patchset in=
 2022

The tile like this:

[PATCH 0/3] softirq: uncontroversial change

Thanks,
Jason


>
> Thanks.
