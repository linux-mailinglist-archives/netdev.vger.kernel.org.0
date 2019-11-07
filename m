Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D04DF31DD
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 15:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388349AbfKGO7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 09:59:36 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37562 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728351AbfKGO7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 09:59:36 -0500
Received: by mail-yb1-f195.google.com with SMTP id e13so1037487ybh.4
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 06:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o+v9ae4WyOkoGg0fa11vDq0Xg6/DkGJA+dIZ2hjJXDk=;
        b=CHlivEuwOpKEuSHcvUr2fEq2ZW6fzeYLjAhYLVIAJ9gx9qhQCVzL9lEtp60VWJ5zui
         OYZI94fIHFHCD+7NETlCsMhgK99mDpEai1R95P99gY2lvi5T3JNliKpv4sd4a3ELZWbf
         TWr3Ahlsu2qJWIBq6n043wem+cmoGEunuJKWN479l/opx6aDe22ZRTwm+bi5gQ8Id5yj
         3SKH6oXjd+0zvvdnkmFdqTJS4wlq2A3D9oEI49H45TgK1q03Df34oTFN9o/jGYXKRJ63
         xmKdlQYRwasFHyUyNUNntxIN62+HSXzgKgcm71OP8CxTeMYWjqkWjSEdobHp8bfws4zT
         4bbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o+v9ae4WyOkoGg0fa11vDq0Xg6/DkGJA+dIZ2hjJXDk=;
        b=P8Sc/bNVydUeJTwdK4nXi3VQEh9jdV8hBFUcl/WM2Dg4fI6/u396yMC8eNQxwe+1nt
         gmUi3X3PpEEnoOg7tX/A6jopfWCoDWG6VxDtTjSygfw/YNCE/KbijmfS87HFn0uPQSe1
         0Im1r2Q1FAw4KpCLt/kokXUw7aCfiukwiUcfn/nuUIzzV79lR//TeVvfpCmfz7L6b0mV
         svQUkzDuVS33fgHpLF9Qs8Za2C1kAknEd99xUXV0jmMb5LdUYxUlMS5gWI08GHgGINv+
         VlT3GyrizzvnpRylOvpV4Qcmygdip9gdetsx4RWK7+mInPQ+zubx5Jn1STPKGabBnvM6
         Mgpw==
X-Gm-Message-State: APjAAAVZgXW0bwL6/Hc0j9pyU8lF9KqY/HQnjapEWq7itLY/zR7/cRop
        OB1uru37XiKGFtUnHXrtsOECAgkC
X-Google-Smtp-Source: APXvYqxeg2kw+YJCuKFNdjCv6MbNCwBJJyPAgJT4uU5Rw1N5CYl5YAqNUuMPPZgPGECsZPR+2jU2eg==
X-Received: by 2002:a5b:889:: with SMTP id e9mr1003216ybq.187.1573138774225;
        Thu, 07 Nov 2019 06:59:34 -0800 (PST)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id z139sm1206254ywz.32.2019.11.07.06.59.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 06:59:33 -0800 (PST)
Received: by mail-yw1-f47.google.com with SMTP id p128so665657ywc.11
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 06:59:32 -0800 (PST)
X-Received: by 2002:a81:53d5:: with SMTP id h204mr1071614ywb.411.1573138772305;
 Thu, 07 Nov 2019 06:59:32 -0800 (PST)
MIME-Version: 1.0
References: <0000000000008c6be40570d8a9d8@google.com> <000000000000f5a6620596c1d43e@google.com>
In-Reply-To: <000000000000f5a6620596c1d43e@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 Nov 2019 09:58:56 -0500
X-Gmail-Original-Message-ID: <CA+FuTScESZAhoyDvD3uNq3SRC1=5dvnkONW53tZ0vj0tLnbF-A@mail.gmail.com>
Message-ID: <CA+FuTScESZAhoyDvD3uNq3SRC1=5dvnkONW53tZ0vj0tLnbF-A@mail.gmail.com>
Subject: Re: general protection fault in propagate_entity_cfs_rq
To:     syzbot <syzbot+2e37f794f31be5667a88@syzkaller.appspotmail.com>
Cc:     allison@lohutok.net, andy.shevchenko@gmail.com,
        David Miller <davem@davemloft.net>, douly.fnst@cn.fujitsu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPA <hpa@zytor.com>, info@metux.net,
        Jiri Benc <jbenc@redhat.com>, jgross@suse.com,
        kstewart@linuxfoundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        Network Development <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        ville.syrjala@linux.intel.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 8:42 AM syzbot
<syzbot+2e37f794f31be5667a88@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this bug was fixed by commit:
>
> commit bab2c80e5a6c855657482eac9e97f5f3eedb509a
> Author: Willem de Bruijn <willemb@google.com>
> Date:   Wed Jul 11 16:00:44 2018 +0000
>
>      nsh: set mac len based on inner packet
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170cc89c600000
> start commit:   6fd06660 Merge branch 'bpf-arm-jit-improvements'
> git tree:       bpf-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a501a01deaf0fe9
> dashboard link: https://syzkaller.appspot.com/bug?extid=2e37f794f31be5667a88
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1014db94400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f81e78400000
>
> If the result looks correct, please mark the bug fixed by replying with:
>
> #syz fix: nsh: set mac len based on inner packet

#syz fix: nsh: set mac len based on inner packet
