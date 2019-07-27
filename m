Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 323087761C
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 04:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfG0C4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 22:56:23 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37076 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbfG0C4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 22:56:22 -0400
Received: by mail-qk1-f194.google.com with SMTP id d15so40492666qkl.4
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 19:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=b/g/UkQMvOsg1N0rbY/yySPTGMQNY5F8dTERfSADiKQ=;
        b=eMQaGK35dCJBd/0p+TnvHHYFPeX+5bAbP3P+lOGrohXSgf0UD+zb4GX1wjJUaUalFw
         xP/ktfqhdDXRXBgu3kHNwSdBC4wcnJU2HQqO3AwoaqQZcb+YCTcIGTbVrXlmfPaGDDw1
         u1zoRgwf+jJFVZEl8UGmZ4M6zJKyoszU3Lc9r2VNvtweL81sT87uWShaE+0L75AgWtQa
         gEodjoNCreMgSA0Iy2EK7ssDqIfHRju6uVuvzrEyVPLw2prglB9XzVvgqgHmWf5lGxAf
         yikXff4rCyszF7fcS6j0xm54AVhH135ZqwXOoOsfREkcQyRwtpehRvKSniGmoe3GUGIE
         omWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=b/g/UkQMvOsg1N0rbY/yySPTGMQNY5F8dTERfSADiKQ=;
        b=jyCF0tbZ5NSEKHsL8DdTvyoy8Wqvvq15bO1HKdI0/EhpNrl+i/ZEJmBgORjD5kMEFf
         GyXEQ6v6vGcnu4d/M+bgM86Aluo/RQaqSBLRtbZwgYaXDIvKNncrPD3U5cp9sX5uvs4q
         bwdXwCVA7sBjLWcM796yqr0ixO2K9iLwU1yswwwEh0q9ZVuEQmorxBQRQJw4umrtHkm6
         WpuYilRskfWTgrC+RlaPBKC5bEIYRqNa9yjNan/Pss9f1KTJRpbvwW56FBLns7nGaPJU
         UOYWQWxmzSMAUSeAbaKg1swbiRkXTYbK97sqMJx4/n32Eg/3OVOqbt2e3gI48kkO8eCz
         05rw==
X-Gm-Message-State: APjAAAUVFdBB3/fRTfttM9WUCFntTqX1uN3PWxCf12M9j6HHYAspFnTK
        bx9ZjfGMBbTCS2KG/T1wTIz8bw==
X-Google-Smtp-Source: APXvYqynQocQE4l7hBi/wmTypC83TazHSdyWCMed6qXNA6h59EAC1XNMJmP9bCMa5a4vj95oaIQkNg==
X-Received: by 2002:a05:620a:137c:: with SMTP id d28mr1857550qkl.351.1564196181742;
        Fri, 26 Jul 2019 19:56:21 -0700 (PDT)
Received: from qians-mbp.fios-router.home (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id v84sm24822683qkb.0.2019.07.26.19.56.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 19:56:21 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: memory leak in kobject_set_name_vargs (2)
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <CAHk-=why-PdP_HNbskRADMp1bnj+FwUDYpUZSYoNLNHMRPtoVA@mail.gmail.com>
Date:   Fri, 26 Jul 2019 22:56:19 -0400
Cc:     syzbot <syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kuznet@ms2.inr.ac.ru,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, luciano.coelho@intel.com,
        Netdev <netdev@vger.kernel.org>, steffen.klassert@secunet.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        yoshfuji@linux-ipv6.org, Wang Hai <wanghai26@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E20E1982-1F60-4F01-AE3C-0CF397A596C4@lca.pw>
References: <000000000000edcb3c058e6143d5@google.com>
 <00000000000083ffc4058e9dddf0@google.com>
 <CAHk-=why-PdP_HNbskRADMp1bnj+FwUDYpUZSYoNLNHMRPtoVA@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 26, 2019, at 10:29 PM, Linus Torvalds =
<torvalds@linux-foundation.org> wrote:
>=20
> On Fri, Jul 26, 2019 at 4:26 PM syzbot
> <syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com> wrote:
>>=20
>> syzbot has bisected this bug to:
>>=20
>> commit 0e034f5c4bc408c943f9c4a06244415d75d7108c
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Wed May 18 18:51:25 2016 +0000
>>=20
>>     iwlwifi: fix mis-merge that breaks the driver
>=20
> While this bisection looks more likely than the other syzbot entry
> that bisected to a version change, I don't think it is correct eitger.
>=20
> The bisection ended up doing a lot of "git bisect skip" because of the
>=20
>    undefined reference to `nf_nat_icmp_reply_translation'
>=20
> issue. Also, the memory leak doesn't seem to be entirely reliable:
> when the bisect does 10 runs to verify that some test kernel is bad,
> there are a couple of cases where only one or two of the ten run
> failed.
>=20
> Which makes me wonder if one or two of the "everything OK" runs were
> actually buggy, but just happened to have all ten pass=E2=80=A6

Real bisection should point to,

8ed633b9baf9e (=E2=80=9CRevert "net-sysfs: Fix memory leak in =
netdev_register_kobject=E2=80=9D")

I did encounter those memory leak and comes up with a similar fix in,

6b70fc94afd1 ("net-sysfs: Fix memory leak in netdev_register_kobject=E2=80=
=9D)

but those error handling paths are tricky that seems nobody did much =
testing there, so it will
keep hitting other bugs in upper functions.=
