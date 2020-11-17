Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DE42B5574
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgKQABL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbgKQABL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 19:01:11 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B97C0613CF;
        Mon, 16 Nov 2020 16:01:11 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id t16so20672570oie.11;
        Mon, 16 Nov 2020 16:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=43DQzCg5Fh/e80j18iTB14KX1KqVOE9LtzMgiPsxv38=;
        b=PsL0sYtFCpYFJEeN/zR/L+McjGTROMEXrUz6g6LwC8cK72WwqZ0oAPQoC0Bfv4gemN
         AeYl+9xSiuhuRzrOnZh1WRvRknXwje9Q6jCojfKS2TeY2ogrxezzYn0OjRp/3fSaBLvC
         +jKawWvRxGE7tHXVt6FiTdu6uEnfvaPpcGoVrLflbwmKJxGM9RiZGnFONpy+mr8w+Shl
         A8ACQ+17PIthCUuOruJc34guw8gZy7m18OWCFugC6ZN0M1Y/hn3Xf0pb/OG4zCYpWlMX
         0iUe7UrWClidkDUqPb6OGHeYkW8V0IvKQmFKe5C81rmXtR38mOAWZMpBjJ1y1TwhC3UT
         JQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=43DQzCg5Fh/e80j18iTB14KX1KqVOE9LtzMgiPsxv38=;
        b=bRHDLMaOz3QxRCOARK590iprwuVmANFpdIesIHgn0MVymrewVNWjlvN1EN9BnDj5bf
         NSQKgVgPOHjVScjZSvYqFJi76e7hin6cS+wdXymF4hmyjM4xj0ASO9g4N9m3Bfi5hnci
         onjKYxcLzGfgC6r/tXGeVhBMLZTejKC9wEmMGcWACrc2BTBGO7Cv64rz/cMKwq46hOD7
         sn101R1sqqUL58JM8IxQfw0JhJlamgtNGmrYj9vlgR4O+v5qTfix4VSexGkY9OMZjmnx
         T69AYgkoAUBbZig8JG1S6SQBiO5caPD0TZzirQ5KM259HTjm8OFjpPk5v9dcQ6a7l6z2
         a1JA==
X-Gm-Message-State: AOAM530vdjkySS+ImENJeIrm2Ui9MP3dfOKr1nNmCiIno3Ko+tWF/SWi
        Z/SlOzPW0oKAUXpK8sIQPKM3CNIhiriNo4NVvfk=
X-Google-Smtp-Source: ABdhPJxmLZRBQLvUFxoYDhs/loQsOlCbnoqq8SXRB09DsBSVyRnMhSwE5Q7YTKnPZJrjX8Te1KqotXQYjuk7jSatQws=
X-Received: by 2002:aca:c70b:: with SMTP id x11mr821929oif.58.1605571270718;
 Mon, 16 Nov 2020 16:01:10 -0800 (PST)
MIME-Version: 1.0
References: <20201116132421.94624-1-weiyongjun1@huawei.com>
In-Reply-To: <20201116132421.94624-1-weiyongjun1@huawei.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 16 Nov 2020 16:00:59 -0800
Message-ID: <CABBYNZLAn2ps7MuqeKPFA6QNnVzjmTCOHxTCcK9KzLD34OOpcg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: sco: Fix crash when using BT_SNDMTU/BT_RCVMTU option
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Nov 16, 2020 at 5:22 AM Wei Yongjun <weiyongjun1@huawei.com> wrote:
>
> This commit add the invalid check for connected socket, without it will
> causes the following crash due to sco_pi(sk)->conn being NULL:
>
> KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
> CPU: 3 PID: 4284 Comm: test_sco Not tainted 5.10.0-rc3+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> RIP: 0010:sco_sock_getsockopt+0x45d/0x8e0
> Code: 48 c1 ea 03 80 3c 02 00 0f 85 ca 03 00 00 49 8b 9d f8 04 00 00 48 b8 00
>       00 00 00 00 fc ff df 48 8d 7b 50 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84
>       c0 74 08 3c 03 0f 8e b5 03 00 00 8b 43 50 48 8b 0c
> RSP: 0018:ffff88801bb17d88 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83a4ecdf
> RDX: 000000000000000a RSI: ffffc90002fce000 RDI: 0000000000000050
> RBP: 1ffff11003762fb4 R08: 0000000000000001 R09: ffff88810e1008c0
> R10: ffffffffbd695dcf R11: fffffbfff7ad2bb9 R12: 0000000000000000
> R13: ffff888018ff1000 R14: dffffc0000000000 R15: 000000000000000d
> FS:  00007fb4f76c1700(0000) GS:ffff88811af80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005555e3b7a938 CR3: 00000001117be001 CR4: 0000000000770ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  ? sco_skb_put_cmsg+0x80/0x80
>  ? sco_skb_put_cmsg+0x80/0x80
>  __sys_getsockopt+0x12a/0x220
>  ? __ia32_sys_setsockopt+0x150/0x150
>  ? syscall_enter_from_user_mode+0x18/0x50
>  ? rcu_read_lock_bh_held+0xb0/0xb0
>  __x64_sys_getsockopt+0xba/0x150
>  ? syscall_enter_from_user_mode+0x1d/0x50
>  do_syscall_64+0x33/0x40
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Fixes: 0fc1a726f897 ("Bluetooth: sco: new getsockopt options BT_SNDMTU/BT_RCVMTU")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Luiz Augusto Von Dentz <luiz.von.dentz@intel.com>

>
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index 79ffcdef0b7a..22a110f37abc 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -1003,6 +1003,11 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
>
>         case BT_SNDMTU:
>         case BT_RCVMTU:
> +               if (sk->sk_state != BT_CONNECTED) {
> +                       err = -ENOTCONN;
> +                       break;
> +               }
> +
>                 if (put_user(sco_pi(sk)->conn->mtu, (u32 __user *)optval))
>                         err = -EFAULT;
>                 break;
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
