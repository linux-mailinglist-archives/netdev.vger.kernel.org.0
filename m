Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A85F4645CE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241792AbhLAEWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLAEWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:22:53 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DADC061574;
        Tue, 30 Nov 2021 20:19:32 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id v203so59415681ybe.6;
        Tue, 30 Nov 2021 20:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X/3fFovD46a9y4YQmrvpTwUaa4qtKNVsMZP/WV66wQQ=;
        b=gJVyl5VcXzBOaT8p4+fIiKm7kUeZyTvhub7zGiBv7W8CZ0YfMUuq0wWVeFWBcgU1e/
         veSemlGDydp7UXpBP9KLlZY5oEGQmzIBw042B61iU76IE/W251WD9SaB0v5XlLkJNQAA
         H37/XZ38Oq2rKdOq6Ep5PVEsJf+pry9PfRrrQwi7d8V0nReW8Z1A8Bte5kZE6xpLWhYG
         iFPYbfo3ck8zEtUAjzw7LQiDcWs56wBC8SwGCQIHvwvpNrcmRnXfr9nj2B5rsc22Ym7v
         0gkDCMBwiBTIE4kbf3T4yYPUQf983BolrgTPL//Gt5OMiu4mwgHwDo7wmxRJfy9obhaa
         SJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X/3fFovD46a9y4YQmrvpTwUaa4qtKNVsMZP/WV66wQQ=;
        b=pf67PCfIdbeSfmD01dmCBAmHmZikjenogU0ET69y9iWyh41yBeGIIyuYPl9wq9RCpx
         6sTUOJTbnOv0ApX8stXz5vLrFmbPmajetJbWhwz9Sgwp3OLgEMf8r4k7KxfRNNDv5dIf
         XEbGkiQvzBWRUWK2cxvcDlKxCnVM6kXzVoKvb0t2QXrXiOQfrhHgzbEZw8R8EY0Tk/fW
         Wlosv2ibuPPpQwhVenpkKC03qJ001F57Pdix1/R5vAUSgfu44AvtFeyASsxlhD6hdm7Q
         old/rNofqzSJgCMeUmpI4oLUMuQere5eq9Es40iIUeqxoRaHxARy+TQog44LlkCuXLEN
         80vA==
X-Gm-Message-State: AOAM530jP3Tyg76LDKeEOZEPvuAm0mZt2MYt+DkZX3goUF5Cp5VadPk/
        t5pcIT3RwR89yfY8Owza6E4e0D9HMwdtt7I3o2U=
X-Google-Smtp-Source: ABdhPJwFdB20jvrdKNn0k66aTCNzR+3nfVEVKM2MCD3ZeJsSKCwGu3X9XbUhsZNcCl2P/KuK5OaaGhTNhDPEtspJ4q8=
X-Received: by 2002:a25:13c6:: with SMTP id 189mr4368242ybt.113.1638332371727;
 Tue, 30 Nov 2021 20:19:31 -0800 (PST)
MIME-Version: 1.0
References: <20211126204108.11530-1-xiyou.wangcong@gmail.com>
 <CAPhsuW4zR5Yuwuywd71fdfP1YXX5cw6uNmhqULHy8BhfcbEAAQ@mail.gmail.com>
 <YaU9Mdv+7kEa4JOJ@unknown> <CAPhsuW4M5Zf9ryWihNSc6DPnXAq0PDJReD2-exxNZp4PDvsSXQ@mail.gmail.com>
In-Reply-To: <CAPhsuW4M5Zf9ryWihNSc6DPnXAq0PDJReD2-exxNZp4PDvsSXQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Nov 2021 20:19:20 -0800
Message-ID: <CAM_iQpVrv8C9opCCMb9ZYtemp32vdv8No2XDwYmDAaCgPtq+RA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing section "sk_skb/skb_verdict"
To:     Song Liu <song@kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 3:33 PM Song Liu <song@kernel.org> wrote:
>
> On Mon, Nov 29, 2021 at 12:51 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Fri, Nov 26, 2021 at 04:20:34PM -0800, Song Liu wrote:
> > > On Fri, Nov 26, 2021 at 12:45 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > When BPF_SK_SKB_VERDICT was introduced, I forgot to add
> > > > a section mapping for it in libbpf.
> > > >
> > > > Fixes: a7ba4558e69a ("sock_map: Introduce BPF_SK_SKB_VERDICT")
> > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > >
> > > The patch looks good to me. But seems the selftests are OK without this. So,
> > > do we really need this?
> > >
> >
> > Not sure if I understand this question.
> >
> > At least BPF_SK_SKB_STREAM_PARSER and BPF_SK_SKB_STREAM_VERDICT are already
> > there, so either we should remove all of them or add BPF_SK_SKB_VERDICT for
> > completeness.
> >
> > Or are you suggesting we should change it back in selftests too? Note, it was
> > changed by Andrii in commit 15669e1dcd75fe6d51e495f8479222b5884665b6:
> >
> > -SEC("sk_skb/skb_verdict")
> > +SEC("sk_skb")
>
> Yes, I noticed that Andrii made the change, and it seems to work
> as-is. Therefore,
> I had the question "do we really need it".

Same question from me: why still keep sk_skb/stream_parser and
sk_skb/stream_verdict? ;) I don't see any reason these two are more
special than sk_skb/skb_verdict, therefore we should either keep all
of them or remove all of them.

>
> If we do need to differentiate skb_verdict from just sk_skb, could you

Are you sure sk_skb is a real attach type?? To me, it is an umbrella to
catch all of them:

SEC_DEF("sk_skb",               SK_SKB, 0, SEC_NONE | SEC_SLOPPY_PFX),

whose expected_attach_type is 0. The reason why it works is
probably because we don't check BPF_PROG_TYPE_SK_SKB in
bpf_prog_load_check_attach().

> please add a
> case selftest for skb_verdict?

Ah, sure, I didn't know we have sec_name_test.

>
> Also, maybe we can name it as "sk_skb/verdict" to avoid duplication?

At least we used to call it sk_skb/skb_verdict before commit 15669e1dcd.

Thanks.
