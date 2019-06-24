Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898FA51EF7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfFXXLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:11:12 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46526 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfFXXLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:11:12 -0400
Received: by mail-qk1-f194.google.com with SMTP id x18so11088006qkn.13;
        Mon, 24 Jun 2019 16:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t2olUjb+16IZtzOoq18SXHccFR02UrcSs/pzhBjuQYc=;
        b=LG3m/z6w5YI3QAgJOK9/qBg7kB2GAceSIahI/bjERhRHBVEfR5MQGznAQe1+7xq0W7
         Nh0kyVIB8NVB93sxhlJuhzQ5KUAE6Qz1BPikOMudcogD6owbYr5r9ue9QiILYf+whf7A
         TDBgkGjdyQjN/fySmtXhQuzZac6v/iAXmRJhodBn5T+PxBJ3A7aD51Yj0Ug/eOpeEJKg
         XhjlBXwR/abMS5uN+rGN63FKkl/j8HS1VGkT4JTi8lBuJmgrZjKKVrSXy89DpS0CczO9
         o0M37DcXlqkKaHwA6TT/zUte8ZjvUJNlBk58xAlt0Bkd1aPQThNI/uXa+0EnmTeH3VY3
         bTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t2olUjb+16IZtzOoq18SXHccFR02UrcSs/pzhBjuQYc=;
        b=CQty6x/DHAFKS0Y+bZDqPOVVagCtvTbJDnVa3anOp5gvy7AKybnmZ+gt6O6q7gIYJx
         XilyFkrXxwtk2swxKF5DWCv8hdnvCVubIIoGKGj9iTQq3yNpLtVsQQy9FRAlkKv6UGAe
         mwsLpKGDzpJmNp2NhNiVNaPmeTlTSg6UKH6Ly0EHbwtt9aTRntaMO6XyoVrtCLFhWDRR
         69rIljsk8TSlp9TBo/KgXvTwLaH4cm3HyUzC2foFMXv+uGt/arMUsCiEVbi8avnJjKxd
         /YilC8NsoSfqbn+JlKtbtRIlkd3MKmj0oHahD4nBLiFheh5BGAY1JbLcO8QqZ2c/IU+m
         AMJQ==
X-Gm-Message-State: APjAAAXlSwXalMl8uGIucrAZbsWMWQDrUlLpEF+0xzcyJWojo0cU5sgZ
        TYlgsIb/3EF9HCUDgRUxn2QSKcGUKHx5xtDxi0M=
X-Google-Smtp-Source: APXvYqzSDSbXNFncqjERfHaY7Nx3NAuwCBGrqaFXc/ZkV5HX1DrlOzILnN1JAHAVDdvZ2qJw7c40CA4+lbRHfClvVYk=
X-Received: by 2002:ae9:e40f:: with SMTP id q15mr54612321qkc.241.1561417870754;
 Mon, 24 Jun 2019 16:11:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190624215824.118783-1-allanzhang@google.com>
In-Reply-To: <20190624215824.118783-1-allanzhang@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 24 Jun 2019 16:10:59 -0700
Message-ID: <CAPhsuW40c=CTdTo9YUbyj3AAL+A37TX1-Bty267bCYOaThJJ7w@mail.gmail.com>
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

On Mon, Jun 24, 2019 at 3:08 PM allanzhang <allanzhang@google.com> wrote:
>
> Software event output is only enabled by a few prog types right now (TC,
> LWT out, XDP, sockops). Many other skb based prog types need
> bpf_skb_event_output to produce software event.
>
> Added socket_filter, cg_skb, sk_skb prog types to generate sw event.
>
> Test bpf code is generated from code snippet:
>
> struct TMP {
>     uint64_t tmp;
> } tt;
> tt.tmp = 5;
> bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
>                       &tt, sizeof(tt));
> return 1;
>
> the bpf assembly from llvm is:
>        0:       b7 02 00 00 05 00 00 00         r2 = 5
>        1:       7b 2a f8 ff 00 00 00 00         *(u64 *)(r10 - 8) = r2
>        2:       bf a4 00 00 00 00 00 00         r4 = r10
>        3:       07 04 00 00 f8 ff ff ff         r4 += -8
>        4:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00    r2 = 0ll
>        6:       b7 03 00 00 00 00 00 00         r3 = 0
>        7:       b7 05 00 00 08 00 00 00         r5 = 8
>        8:       85 00 00 00 19 00 00 00         call 25
>        9:       b7 00 00 00 01 00 00 00         r0 = 1
>       10:       95 00 00 00 00 00 00 00         exit
>
> Patch 1 is enabling code.
> Patch 2 is fullly covered selftest code.
>
> Signed-off-by: allanzhang <allanzhang@google.com>

A few logistics issues:

1. The patch should be sent as a set, as
   [PATCH bpf-next 0/2] ...
   [PATCH bpf-next 1/2] ...
   [PATCH bpf-next 2/2] ...

2. You need to specify which tree this is targeting. In this case, bpf-next.
3. Please use different commit log for each patch.
4. No need for Signed-off-by in the cover letter.

Please resubmit. And generate the patches with git command similar to
the following:

git format-patch --cover-leter --subject_prefix "PATCH bpf-next v2" HEAD~2

Thanks,
Song
