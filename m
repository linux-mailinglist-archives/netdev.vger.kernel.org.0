Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF9551EFB
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfFXXMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:12:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41477 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfFXXMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:12:48 -0400
Received: by mail-qk1-f196.google.com with SMTP id c11so11127373qkk.8;
        Mon, 24 Jun 2019 16:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O2BpkHRLSBohgPGQ4ppf93FA03SUHEa07ouP+tSwO48=;
        b=M7faacAMOdA3UtkbfnR66SqX1uVWBeMdmzEutoPNOGenXO27y5b30qfb0X4JvjLZt4
         poxIQ/ZeazW1K9QpWvLZeK2LtSBZcaya18wMtVq/Sucy3J22CvCWJrey8vWIBp5GK6ua
         KnofJAi4/knG9jTjKy3o3EhwN4xnA/ia11Eps2JuQmntoWMOeFTGmvJRkALBtBK9Vadw
         3nA4Hsk6tMH0MmL23tu8B+yj1Rx9U3Qhccr53UNQU5E4CfhdhE88rEtS5vixhCVHBAWV
         xcqb1HWKjfOX4h7tYx82S8q9sPnGrlHmlJoOC5+xWb1yIPv2LrVwFgUHghhjaMQGVkkB
         6pFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O2BpkHRLSBohgPGQ4ppf93FA03SUHEa07ouP+tSwO48=;
        b=m5EZBcV05KFPcH5Z73GzVuI/dgwOji7Vyy5qBWKHnR41xOf3YfB3LgxqJAEMQGba9q
         PEgmgX8wMKvEnFoCzCu0B//ZsHav29OKljBO52ErdtGqWMEe580VhV7qZ5EmDCT593tS
         JSP0U+s66DTk/4osEXdew0en51HnZ2jNPPIpY6GbX9/Dup3KjcyfhRQrADshBknOGmyW
         KeayVARwofKvgwQo3P6o90R3vpH4FfhZG+grqEEPgpN1nZVJGfmyWifLA4J2g7wVvEN8
         tfysKVFYNw6mMhMhZY2fFlwKpdEgsfB1ZWYOXO2n8uK6HZ28hSHVWPGt8uV9Wa8sFuyC
         yTuA==
X-Gm-Message-State: APjAAAU93r71YaoVqDgiB3K2BgMKC5m7q+9BYPDkDcBoZBL9ILcwFMts
        xUJIxglthPuPbv7LtJiXmno9e+JA8HQd+GaGNuS5+1M6
X-Google-Smtp-Source: APXvYqxlkmDdalJ3IzSQp8dpG58bSBDcWX2cxphQaV+wUwwTnU0D86G9VSSzr6Non/zDXcd1PIeNSmQUK8Ij1nyQUkw=
X-Received: by 2002:a37:5cc3:: with SMTP id q186mr50378841qkb.74.1561417967710;
 Mon, 24 Jun 2019 16:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190624215824.118783-1-allanzhang@google.com> <CAPhsuW40c=CTdTo9YUbyj3AAL+A37TX1-Bty267bCYOaThJJ7w@mail.gmail.com>
In-Reply-To: <CAPhsuW40c=CTdTo9YUbyj3AAL+A37TX1-Bty267bCYOaThJJ7w@mail.gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 24 Jun 2019 16:12:36 -0700
Message-ID: <CAPhsuW7D=bn9R7TnWbEZyj-W-WgdErJVdY-1jQmGP_HtcdkPsw@mail.gmail.com>
Subject: Re: [PATCH] bpf: Allow bpf_skb_event_output for a few prog types
To:     allanzhang <allanzhang@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 4:10 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Jun 24, 2019 at 3:08 PM allanzhang <allanzhang@google.com> wrote:
> >
> > Software event output is only enabled by a few prog types right now (TC,
> > LWT out, XDP, sockops). Many other skb based prog types need
> > bpf_skb_event_output to produce software event.
> >
> > Added socket_filter, cg_skb, sk_skb prog types to generate sw event.
> >
> > Test bpf code is generated from code snippet:
> >
> > struct TMP {
> >     uint64_t tmp;
> > } tt;
> > tt.tmp = 5;
> > bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
> >                       &tt, sizeof(tt));
> > return 1;
> >
> > the bpf assembly from llvm is:
> >        0:       b7 02 00 00 05 00 00 00         r2 = 5
> >        1:       7b 2a f8 ff 00 00 00 00         *(u64 *)(r10 - 8) = r2
> >        2:       bf a4 00 00 00 00 00 00         r4 = r10
> >        3:       07 04 00 00 f8 ff ff ff         r4 += -8
> >        4:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00    r2 = 0ll
> >        6:       b7 03 00 00 00 00 00 00         r3 = 0
> >        7:       b7 05 00 00 08 00 00 00         r5 = 8
> >        8:       85 00 00 00 19 00 00 00         call 25
> >        9:       b7 00 00 00 01 00 00 00         r0 = 1
> >       10:       95 00 00 00 00 00 00 00         exit
> >
> > Patch 1 is enabling code.
> > Patch 2 is fullly covered selftest code.
> >
> > Signed-off-by: allanzhang <allanzhang@google.com>
>
> A few logistics issues:
>
> 1. The patch should be sent as a set, as
>    [PATCH bpf-next 0/2] ...
>    [PATCH bpf-next 1/2] ...
>    [PATCH bpf-next 2/2] ...
>
> 2. You need to specify which tree this is targeting. In this case, bpf-next.
> 3. Please use different commit log for each patch.
> 4. No need for Signed-off-by in the cover letter.
>
> Please resubmit. And generate the patches with git command similar to
> the following:
>
> git format-patch --cover-leter --subject_prefix "PATCH bpf-next v2" HEAD~2
>

And your signed-of-by should probably look like:

Signed-off-by: Allan Zhang <allanzhang@google.com>

Thanks,
Song
