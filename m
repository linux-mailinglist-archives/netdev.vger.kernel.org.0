Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11C7F32AB
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfKGPRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:17:24 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40840 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729934AbfKGPRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 10:17:24 -0500
Received: by mail-yw1-f65.google.com with SMTP id n82so699120ywc.7
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 07:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eINQGFNoBj0XJl5Ezms4ve/c5goqCblPH3ci+ZKJmhE=;
        b=RDlXJhZvPW8W/m0PvOyo+HegHt81FppGi/9odDfIbOt99D3t3D4eBgmNzb9U0Lnopr
         IDcoeIZiuOXDt2a3YVDQJqatmyEl+n4h0ZatJvh1hZ/Tn6QOpnxSUcJtxQ8sas60UaEN
         V0EKVdOR/9did3BNQYhsz8QK6bGLs/GErM9X1cXXT0uLoynPqy1pBzBTlqgtR2ydbLpQ
         6Gg/ke5vnWXu6uE2MrSXpyfkUsrp19YZSK4gJR3STrLVBIIpOdBxj5E2AgOajB/xoNx5
         SraCklBeb1zdOhD9hW+go/Qz2rV5QLWFk8fI9lbbIuhZtZ8OgDEuaM7iPaQUsuI7VDXu
         F6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eINQGFNoBj0XJl5Ezms4ve/c5goqCblPH3ci+ZKJmhE=;
        b=rycv0+94PqPiArD2rK2TL3oMd6N5kKvNPQW/Ayz9XwjPYBuy7Xh524cHmgTDCZe8g5
         3Fw7mwdOsV0auV2AZkqZXoWO6N1gXxA9E4CMTrq4Vh0IhqQ6ewaGW2qiRFbc+viKobOv
         TbcWKEd1rUaJyNhTwAX0qyRyzmuUW//16CNHuqjmnuP3v989jEOmzG2zOsv9zK1efVZ0
         EIlLz1j5qB2a4saN1AD0QozzfVP2o7WbWAou2j1mB2qqF7OElSKV/veHIP7/NHRJHQaj
         bUOsYPb/pK2KWoXUNqIm29wbWuQKd/g8x4oJcmcQ7huEfC55l9oTtUXSrhWN2hjr0hrv
         MONQ==
X-Gm-Message-State: APjAAAXwZPh9JNRLL+OCzsOOO9ec3P2FPHoCbxmyDikHmny+L4v2Yyd8
        jnHOT9jX8KlUJc5TzOvCu+LfEw1A
X-Google-Smtp-Source: APXvYqwCwKJq6FrRlxshg+6m2XI5pNQS6cskXK9HeM5rf68H54GmaE/ZBw8JXRrZ00nwTMCYDzpxYQ==
X-Received: by 2002:a81:3d4d:: with SMTP id k74mr2704753ywa.235.1573139842280;
        Thu, 07 Nov 2019 07:17:22 -0800 (PST)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id i125sm892881ywa.68.2019.11.07.07.17.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 07:17:21 -0800 (PST)
Received: by mail-yb1-f179.google.com with SMTP id g38so1043098ybe.11
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 07:17:20 -0800 (PST)
X-Received: by 2002:a25:583:: with SMTP id 125mr3500165ybf.89.1573139840266;
 Thu, 07 Nov 2019 07:17:20 -0800 (PST)
MIME-Version: 1.0
References: <0000000000008c6be40570d8a9d8@google.com> <000000000000f5a6620596c1d43e@google.com>
 <CA+FuTScESZAhoyDvD3uNq3SRC1=5dvnkONW53tZ0vj0tLnbF-A@mail.gmail.com>
In-Reply-To: <CA+FuTScESZAhoyDvD3uNq3SRC1=5dvnkONW53tZ0vj0tLnbF-A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 Nov 2019 10:16:44 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeRdb1xZx8HJJWtUxjsyoMPZRvUKbm+2+r_TwM5SmAXJQ@mail.gmail.com>
Message-ID: <CA+FuTSeRdb1xZx8HJJWtUxjsyoMPZRvUKbm+2+r_TwM5SmAXJQ@mail.gmail.com>
Subject: Re: general protection fault in propagate_entity_cfs_rq
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     syzbot <syzbot+2e37f794f31be5667a88@syzkaller.appspotmail.com>,
        allison@lohutok.net, andy.shevchenko@gmail.com,
        David Miller <davem@davemloft.net>, douly.fnst@cn.fujitsu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPA <hpa@zytor.com>, info@metux.net,
        Jiri Benc <jbenc@redhat.com>, jgross@suse.com,
        Kate Stewart <kstewart@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        Network Development <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        ville.syrjala@linux.intel.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 9:58 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Nov 7, 2019 at 8:42 AM syzbot
> <syzbot+2e37f794f31be5667a88@syzkaller.appspotmail.com> wrote:
> >
> > syzbot suspects this bug was fixed by commit:
> >
> > commit bab2c80e5a6c855657482eac9e97f5f3eedb509a
> > Author: Willem de Bruijn <willemb@google.com>
> > Date:   Wed Jul 11 16:00:44 2018 +0000
> >
> >      nsh: set mac len based on inner packet
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170cc89c600000
> > start commit:   6fd06660 Merge branch 'bpf-arm-jit-improvements'
> > git tree:       bpf-next
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a501a01deaf0fe9
> > dashboard link: https://syzkaller.appspot.com/bug?extid=2e37f794f31be5667a88
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1014db94400000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f81e78400000
> >
> > If the result looks correct, please mark the bug fixed by replying with:
> >
> > #syz fix: nsh: set mac len based on inner packet
>
> #syz fix: nsh: set mac len based on inner packet

The stack traces in both the bisection log and my manual run, when
running the linked reproducer, differ from the one in the dashboard.
Those more obviously include nsh functions. The trace in the dashboard
does not and sees a GPF in propagate_entity_cfs_rq, which does not
immediately appear related. That said, it is reported only once over a
year ago, so probably still preferable to close. A new report will be
opened if incorrect.
