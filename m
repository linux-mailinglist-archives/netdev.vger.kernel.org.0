Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23732113D8E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 10:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbfLEJH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 04:07:58 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:42185 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfLEJH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 04:07:57 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MDQRy-1iVgMe44Tm-00AZOa; Thu, 05 Dec 2019 10:07:55 +0100
Received: by mail-lf1-f42.google.com with SMTP id n25so1930431lfl.0;
        Thu, 05 Dec 2019 01:07:54 -0800 (PST)
X-Gm-Message-State: APjAAAWaX08cRKCjC9kcRjUAcKbVHB6rq2Rap8epvqa5d/be0qLqWlRj
        NRkNh18YjbBt6U1M1LNYl3e+ju7bTX/N+jI1V/8=
X-Google-Smtp-Source: APXvYqypV1X5EMz2sl1SKkaAbf4BM9c0wEFFQFI//IuQIHowR6BnovlkX8ELT08+5Z0laudy+q0gKPhwMe9Yp9XTz5g=
X-Received: by 2002:a19:22cc:: with SMTP id i195mr4781773lfi.148.1575536874347;
 Thu, 05 Dec 2019 01:07:54 -0800 (PST)
MIME-Version: 1.0
References: <20191205052220.GC1158@sol.localdomain> <20191205055419.13435-1-ebiggers@kernel.org>
In-Reply-To: <20191205055419.13435-1-ebiggers@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 5 Dec 2019 10:07:37 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2Fka2tuCnYAsSM8DHVzV9Zpvj_J7rkGg6zgWLEsU3KAw@mail.gmail.com>
Message-ID: <CAK8P3a2Fka2tuCnYAsSM8DHVzV9Zpvj_J7rkGg6zgWLEsU3KAw@mail.gmail.com>
Subject: Re: [PATCH] ppp: fix out-of-bounds access in bpf_prog_create()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>, bpf@vger.kernel.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-ppp@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+eb853b51b10f1befa0b7@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:XiJIUuR/OeqRdx0q/I6GwluGTGsdAMHUl4MQ9R4EKyAkzHom6AR
 ODog5/k3OD8ftZArXfJ9gzj1bXo0vd6KSsKxMFDh3mq2+UwAwqIozNJjbNFrXoh3ufgFf3E
 OD6F2mOrYl8HpkOW+aw4YeYHuOkyEDjuukaYJ9XE3e7BcYzz0NtpxN9q1SKaXb6SMWmyObG
 hqBWPR75Zc9ym6LDePlNA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BEadTGh7wNM=:DRgQGSU66b4UPkvk7ATasF
 9Ey/O0yUQ/4D8Y3kcFbWOJ22PXJZ+G1+in5J4mGtqCBlhlQOa/30d+J+6hOmwWE85MDzf8GYO
 Ejwb/qGjHW1Tijz1FK7yAw7TcIv5g8BG0I96YWzrwInHuFpxx2jlo/MVlj5bpj2vt56F0/JGL
 iMBTG/+kBKyAQkzHyuv1JSLMn2bm9Ypox57hUDOjQMiBy7gPIuyYtHrjNI7rPXbAyX7TTpX1n
 nQ0TLqGZJeB542oEvsd3KJ8BwvA3lvze5U16/LibU4XGKakmhY2Gvuhs51UrVSXh6ij58XM6K
 2pz/GFcbbMcDKw9lI9KF+OzQkhsPQCHj3ybp9rMEAqW2mnGP0G7IrUwze1kECDwFOh1tijywr
 FgDva/kTC7hqTriwW5ubDBxWmEEnnoAv5YgbhpX/5xmV7PrgZ3yN8nizgPE+rg6QzGetnYUhS
 lYJb4bHNBXRBH27/lIyjINtLv5ifRrUpu17pCxoVIOFouAJaDt7xw/EkBtKrG3Cra4rJ7x/T8
 obrytdlwYs0+o/fDez1/bCGetN8y7zkMsgk8hTxQROqwG4GVT9XbNa0fDhCDxp7+CLPNjLzlA
 DaePrBcufmX8GH9kbTZ5SXuQU8Rnq/BF9gVsdtsuqSV/qfaBcuuAg1AwrVb8qa42iMAi8gjP5
 PczD6sUn6cSNmnFn0yi7ndsP2ebW9iDadXqw1MTPEvsi8Nzo+sKFifRN24NBjq+mJ/JtI2DlH
 S47b0iUG55hZa2aGRPakliTMe1Qwkd6hPhvSrLJt1cFp7W3T/4GRaLvY7LE70SpvAJEaLzPof
 FMvvPfs9M6DUNo6jeDxXP/4fS4u2E5NZyWgfc+o3XWUWo74pIg0OqgNInpVshdq/s+26OZFxZ
 Y7PkkYEzHZzXLMaMSiXA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 6:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> sock_fprog_kern::len is in units of struct sock_filter, not bytes.
>
> Fixes: 3e859adf3643 ("compat_ioctl: unify copy-in of ppp filters")
> Reported-by: syzbot+eb853b51b10f1befa0b7@syzkaller.appspotmail.com
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Thanks for fixing the bug I introduced!
