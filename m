Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF49F21005E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgF3XV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgF3XV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:21:26 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2D4C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 16:21:26 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id v19so17019687qtq.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 16:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=seqE63Mn86KaKbfXTDzKGyPN8IJ3z3qicvlML3lwbaA=;
        b=p3NnmqZ/v947mNgLd49wLAnc7GWaxKO66MpVdKbt9FK49Z91wcfxXV+0phSu5mTzFX
         ePQu9XcI/XmieQp8pi9F6eSejjAP8hJEOyRy+rqoHdsA6iafO1/9cHz2R7Zk1MpNsbxE
         KCxJ26sPgvzciYZ3K5jauhUe4AFuVZWbVlUEt9UYSrWZriPJCqr/uegbA7607N56eo02
         Yz1XPB//ponD8RBcJZBMbmEKipkxCVCsUccnWOesaY/JQiDLLs2iRUdn7H0nA25bC6JI
         P72w786OqN/JvuHjLYMt4h21wHTW5fK6jtVtmcBNDPT59JciTcx3h1Dh6nE539uudvWl
         rWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=seqE63Mn86KaKbfXTDzKGyPN8IJ3z3qicvlML3lwbaA=;
        b=iFWSzgrc4h36rCZRjlg6pm3pnfh+5rxZ/pPkzlveLfJ7C63YIdUllGmOZUv+wDMqGL
         /D68gSsUtly/kwUxWcn1k6rFnK0bbBPgDt2kNzYyi36fsrCzgMF33uJyXqRtVYRpkWOh
         AesYYpL2I0+vlSWOrJIt23UNwag8lc4wlTvtcdTrKMpHLM6Ye2lRvtnrmfWl59djG5xm
         +zvafbh02KjmxFwj2Ajn+0cl4HC1k7op6VIK7msoq3U03VbeBhLBLSzsMf4Q8IA6gH1+
         UuoNl/KyG7coxaom3s+rA1lSEgEXcn4SiTTiqji0eLg99VYWF+4FILXZ4aTYIjmnq0Th
         7x8A==
X-Gm-Message-State: AOAM531DprhqVOFuJV+09swfw/HNLLfB2beRGQT33NRAYsIbMmsRJRZC
        QDm9zPh1nkLfWjmNgWuLgYX+qWAx
X-Google-Smtp-Source: ABdhPJwpYcbATB/eetey71erKJ4rsPdeFSxQp16kZ1JkrXXaC/zo58b9bd8/+icDvOlkK1bVlCPggQ==
X-Received: by 2002:ac8:7343:: with SMTP id q3mr24655093qtp.165.1593559285106;
        Tue, 30 Jun 2020 16:21:25 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id j4sm4039610qtv.68.2020.06.30.16.21.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 16:21:24 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id e197so6952433yba.5
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 16:21:23 -0700 (PDT)
X-Received: by 2002:a25:df81:: with SMTP id w123mr35628905ybg.428.1593559283353;
 Tue, 30 Jun 2020 16:21:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200630221833.740761-1-kafai@fb.com>
In-Reply-To: <20200630221833.740761-1-kafai@fb.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jun 2020 19:20:46 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdbdmvsAZKwUW7AKwfGWDcs5Wff5GoksErzMcmC_2EwRA@mail.gmail.com>
Message-ID: <CA+FuTSdbdmvsAZKwUW7AKwfGWDcs5Wff5GoksErzMcmC_2EwRA@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: tcp: Fix SO_MARK in RST and ACK packet
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 6:18 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> When testing a recent kernel (5.6 in our case), the skb->mark of the
> IPv4 TCP RST pkt does not carry the mark from sk->sk_mark.  It is
> discovered by the bpf@tc that depends on skb->mark to work properly.
> The same bpf prog has been working in the earlier kernel version.
> After reverting commit c6af0c227a22 ("ip: support SO_MARK cmsg"),
> the skb->mark is set and seen by bpf@tc properly.
>
> We have noticed that in IPv4 TCP RST but it should also
> happen to the ACK based on tcp_v4_send_ack() is also depending
> on ip_send_unicast_reply().
>
> This patch tries to fix it by initializing the ipc.sockc.mark to
> fl4.flowi4_mark.
>
> Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/ipv4/ip_output.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 090d3097ee15..033512f719ec 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1703,6 +1703,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
>         sk->sk_bound_dev_if = arg->bound_dev_if;
>         sk->sk_sndbuf = sysctl_wmem_default;
>         sk->sk_mark = fl4.flowi4_mark;
> +       ipc.sockc.mark = fl4.flowi4_mark;
>         err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
>                              len, 0, &ipc, &rt, MSG_DONTWAIT);
>         if (unlikely(err)) {

Yes, this total sense. I missed these cases.

Slight modification, the line above then no longer needs to be set.
That line was added in commit bf99b4ded5f8 ("tcp: fix mark propagation
with fwmark_reflect enabled"). Basically, it pretends that the socket
has a mark associated, but sk here is always the (netns) global
control sock. So your BPF program was depending on fwmark_reflect?

ipv6 seems to work differently enough not to have this problem,
tcp_v6_send_response passing fl6.flowi6_mark directly to ip6_xmit.
This was added in commit commit 92e55f412cff ("tcp: don't annotate
mark on control socket from tcp_v6_send_response()").

But I do see the same pattern where a socket mark is set from a
reflected value in icmp_reply and __icmp_send. Those almost certainly
need updating too. I can do that separately if you prefer. I even
placed ipcm_init right below this sk_mark initialization without
considering ipcm_init_sk. D'oh.

        sk->sk_mark = mark;
        ipcm_init(&ipc);
