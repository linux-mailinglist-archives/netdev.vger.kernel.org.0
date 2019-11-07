Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E33F3536
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbfKGQ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:59:21 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33249 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKGQ7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:59:20 -0500
Received: by mail-yb1-f196.google.com with SMTP id i15so1219693ybq.0
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OY3mL3SJty7WONSqI9Sp3mmm9hhK0YCgUyTwKH16DyM=;
        b=NNUuOmM7CKWjGHRTbNqGdtPWTCVZ0EOBnHBVZa3Du0rkbJ7FuAdoM+5baW/0stuk3E
         gCiivLgsL72BauezxIjWfOW69541tetppjNLpG2D95N8+F/Wn/SGBAKFTqnLiB7KU6Lx
         CX3qq1gGt+ByA9Y561UNZy9VW7qUxNA/RFLeIB6YzUt5jxNcSAniQlhV5waLfLIYwRmI
         CNEAmi7iXeMVT9AdY2V3t1FWvhKfmU8ccDR4oOIJ+vrikdE91d1U2H6AutP4iBv4Leoj
         +HqRPkKjWHec2HWsuDwlAK0V8pdoaeVsGF3xzqc4YUKmwU5Ea5BiwNPzJA4399Kyj9sf
         hYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OY3mL3SJty7WONSqI9Sp3mmm9hhK0YCgUyTwKH16DyM=;
        b=Qt0j+vj6+PgrBQJ7w6tK8lO4J5kSH2BGzQxqiMsudimhLD3vJdz66TXoDZDUPSoz1x
         R+z0kz3UMdONKQF2MAmwyrafxY4QAu0QoHlxsVUXM/p3Fv4bykchykrYkL1ICBM9sxRg
         jVZVzv3tRcjXFZgWcikoaTB1rsSuQ4H8GuyeDfrr3Zd/QEk3DQMdXSltQmHnUAMQnyQr
         xqgPhFnQA1o4j+rFzM9XQJ583f0qtb8puZB9rutNuPnYH0/jMCLWzgGXGJWKD2kzKKVE
         fqaHbKLOZ5Hpxcb8LHnHNCDPhXkwkCg+3PpQegB45+IzmEejdXXEmvyaqNpzSozsarkV
         cznA==
X-Gm-Message-State: APjAAAXBKn3StlOELhtte9EM5BiZYsuQmMla2ohXGAemw4m5h6hYy/U2
        pyV2V8W4yfmNioOcniP3tNrtUzjB
X-Google-Smtp-Source: APXvYqxFut2yxH7PqpA71d3KJAxs5HebTN+eknxgBnVy7jeHXqJzJq8ZmmmZ/+5OtH3D4K3+fdkwIg==
X-Received: by 2002:a25:490:: with SMTP id 138mr4200956ybe.360.1573145959274;
        Thu, 07 Nov 2019 08:59:19 -0800 (PST)
Received: from mail-yw1-f42.google.com (mail-yw1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id f64sm871537ywd.51.2019.11.07.08.59.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 08:59:18 -0800 (PST)
Received: by mail-yw1-f42.google.com with SMTP id d80so419340ywa.6
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:59:17 -0800 (PST)
X-Received: by 2002:a0d:fe06:: with SMTP id o6mr1541900ywf.424.1573145957443;
 Thu, 07 Nov 2019 08:59:17 -0800 (PST)
MIME-Version: 1.0
References: <000000000000f68d660570dcddd8@google.com> <000000000000e51d450596c1d472@google.com>
In-Reply-To: <000000000000e51d450596c1d472@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 Nov 2019 11:58:41 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdz-+Hj2itAiC5uiP0X7aHP4YPG1+1k_bbE+OCBK+P0Rg@mail.gmail.com>
Message-ID: <CA+FuTSdz-+Hj2itAiC5uiP0X7aHP4YPG1+1k_bbE+OCBK+P0Rg@mail.gmail.com>
Subject: Re: kernel BUG at net/ipv4/ip_output.c:LINE!
To:     syzbot <syzbot+90d5ec0c05e708f3b66d@syzkaller.appspotmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>, johannes.berg@intel.com,
        Martin Lau <kafai@fb.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Peter Oskolkov <posk@google.com>, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 8:42 AM syzbot
<syzbot+90d5ec0c05e708f3b66d@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this bug was fixed by commit:
>
> commit e7c87bd6cc4ec7b0ac1ed0a88a58f8206c577488
> Author: Willem de Bruijn <willemb@google.com>
> Date:   Wed Jan 16 01:19:22 2019 +0000
>
>      bpf: in __bpf_redirect_no_mac pull mac only if present
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14175486600000
> start commit:   112cbae2 Merge branch 'linus' of git://git.kernel.org/pub/..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=152cb8ccd35b1f70
> dashboard link: https://syzkaller.appspot.com/bug?extid=90d5ec0c05e708f3b66d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153ed6e2400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1539038c400000
>
> If the result looks correct, please mark the bug fixed by replying with:
>
> #syz fix: bpf: in __bpf_redirect_no_mac pull mac only if present

#syz fix: bpf: in __bpf_redirect_no_mac pull mac only if present
