Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043042AA780
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgKGTCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGTCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:02:25 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E38AC0613CF;
        Sat,  7 Nov 2020 11:02:24 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id f11so324430lfs.3;
        Sat, 07 Nov 2020 11:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=soRNlc/K6cVluQ0+VaeOOXxw2r7plkvcC+reHxKQUx4=;
        b=bsKVuUwXgaCLddOnkSoCSlZQdNoGIm5R9XzwGw4xELX/hCS4M3IHaDAXT1Kq5gfTmq
         yI5wo4MevNnQkkFUgvSP57zaP48d6vpbrCpenDjCDuGcNvjbECT7yhwXKJeCzUC+y1rY
         SWHHMolvi1R2mpcQ2vqDR5VaLnpnbkDObMWz59mhHEaw/aoxBC++LT99MNWNgrgKLDbI
         u62GipruMVYvivCT7vMRsTGV7OjcKYlAUM5MRsCaFvXgIevCl1h8rueTe0/fv61rXK1l
         ygXSXvdIvKJdo/WE4kcXbP/XeRTCUFLrmysh3G5endpMgEI9IHIaJ0bPQM4SOFa0nSID
         Aryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=soRNlc/K6cVluQ0+VaeOOXxw2r7plkvcC+reHxKQUx4=;
        b=ffgYBk1ykHnsjXrI/DejixE4Wq7Esdt3qbf0AMRT5XcsqTSaIbvy93dqneARWmEBhN
         W7w440uAzM2VdqtvcQbjAcDlWoKj9sNRib1AnJaLIlgmNQpBesRyBHw5o0ZvRil8vkfw
         0VajG2xO//0GWnDEyJ4bGxE2hJn7JH6ckA7WlrsgD2H0kN92HWOee6lZKviRM5+QbbXl
         oGpDBgjlGSHAYYE8rRWPU8w0mylD5GuyTkuPfwrvJhuFBCsLccj2KJV2EN75fH5+373j
         b8K1U5yWRw7jCCh1fY5tfo2VKY5JgG9/rQ+mXQkJCfvQpXKORheNS0ZK5C5DA8iLs7rK
         ECfw==
X-Gm-Message-State: AOAM5307zwrZysWq4YSu5yzPHGw6HXQrP1/126NMRWP2maaPOgi1zTIC
        XisCKPhfoScGzoglo4V9YHfMO1KPjVSWVMF5+pc=
X-Google-Smtp-Source: ABdhPJxEngv1+mdvrUYfkQFjIIpERTeGA4ZgOah7n1WIRgvZ3iWHY3CR104/Xc6//Qc330otjPMDGbU3nnX5PAlPqSk=
X-Received: by 2002:ac2:48b7:: with SMTP id u23mr3212679lfg.327.1604775742934;
 Sat, 07 Nov 2020 11:02:22 -0800 (PST)
MIME-Version: 1.0
References: <20201105155600.9711-1-anmol.karan123@gmail.com> <20201107185654.4339-1-anmol.karan123@gmail.com>
In-Reply-To: <20201107185654.4339-1-anmol.karan123@gmail.com>
From:   Anmol karn <anmol.karan123@gmail.com>
Date:   Sun, 8 Nov 2020 00:32:11 +0530
Message-ID: <CAC+yH-ZCcL=D-ExzXSedRWL2Jq5DY-1tRqP82MjhnBpuKbtONA@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH v2] net: rose: Fix Null pointer
 dereference in rose_send_frame()
To:     ralf@linux-mips.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+a1c743815982d9496393@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Sorry for this wrong subject(It should be v3 instead of v2),
please ignore this patch.

I will send a new one with the corrected subject.

Thanks,
Anmol

On Sun, Nov 8, 2020 at 12:27 AM Anmol Karn <anmol.karan123@gmail.com> wrote:
>
> rose_send_frame() dereferences `neigh->dev` when called from
> rose_transmit_clear_request(), and the first occurrence of the
> `neigh` is in rose_loopback_timer() as `rose_loopback_neigh`,
> and it is initialized in rose_add_loopback_neigh() as NULL.
> i.e when `rose_loopback_neigh` used in rose_loopback_timer()
> its `->dev` was still NULL and rose_loopback_timer() was calling
> rose_rx_call_request() without checking for NULL.
>
> - net/rose/rose_link.c
> This bug seems to get triggered in this line:
>
> rose_call = (ax25_address *)neigh->dev->dev_addr;
>
> Fix it by adding NULL checking for `rose_loopback_neigh->dev`
> in rose_loopback_timer().
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
> Tested-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3
> Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> ---
> Changes in v3:
>         - Corrected checkpatch warnings and errors (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
>         - Added "Fixes:" tag (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
> Changes in v2:
>         - Added NULL check in rose_loopback_timer() (Suggested-by: Greg KH <gregkh@linuxfoundation.org>)
>
>  net/rose/rose_loopback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
> index 7b094275ea8b..2c51756ed7bf 100644
> --- a/net/rose/rose_loopback.c
> +++ b/net/rose/rose_loopback.c
> @@ -96,7 +96,8 @@ static void rose_loopback_timer(struct timer_list *unused)
>                 }
>
>                 if (frametype == ROSE_CALL_REQUEST) {
> -                       if ((dev = rose_dev_get(dest)) != NULL) {
> +                       dev = rose_dev_get(dest);
> +                       if (rose_loopback_neigh->dev && dev) {
>                                 if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
>                                         kfree_skb(skb);
>                         } else {
> -
> 2.29.2
>
