Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D460810C552
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 09:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfK1Ikp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 03:40:45 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46451 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfK1Ikp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 03:40:45 -0500
Received: by mail-qk1-f194.google.com with SMTP id f5so3682921qkm.13
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 00:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5C8NbXcmc1aQS22jTcSPXOSGUlWN7oELXfg5QtAuVzM=;
        b=UYXh/YN6exLANTxIPrG3gGtiatnbu0bh/kGC1PW6FqlM6fscc0zR8db0UZrtuQ59y6
         DMUVc+CWnbnzVDLFDnZN91A0af6QT5QoRflpFOUUPCtPlgIUnHYGYjN8eKvR4nu70I6+
         webO28+9bkOTJCKZP7zzfMu5CiR07YLI41peftG9RdPLOhEMjZzvzioWtO6Kj0Mz3fWD
         aPXCADHuisIvqjqY2nPI46PRUn8Vfk8AFMHAc8VKRVD8AkqqYRl8syJMApsBIwn0HViO
         irlmr7a1C8+9Sw04lbstTjm9zbtYBtejzY2mgPGy2dIgE3wBlJDIX5JNH1dTovt8Ld75
         sM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5C8NbXcmc1aQS22jTcSPXOSGUlWN7oELXfg5QtAuVzM=;
        b=U9w9WewgGsPdutn5r4w58VeTGce76F5EkE5xPuMiGhqnhFPrid2Y9XgslS2FICkAvH
         GiY9uXAISex58WuLMQxXrLCe/zyy8bkGETuc8YYVk7zcACqVRgAKCgsqAx7rWeNA6Imx
         kjR0/fas5PZZi6W9kt/pCdKm7bEwFkZTj5Xmd92jJIe45rJZOhjSSgcHPHprEdGnok+/
         o0cqBz/DPTpUHjOUp6wucCAXZbtwn1GF3HdOsY20Y1ESq9SyxXeE4eRneo8pY4n3/a6u
         YzRWAaCowjloCpp4Qk2+MPGiObXXy4U+ZwBF+jS3B3oyJx+ca5RwG/k14DR3Tm1mKyTm
         Qvwg==
X-Gm-Message-State: APjAAAWEedIEnCxOlZzhTCAvdbGZ4YrrBgHDomjJOIfOX8Z3ikbkgfaA
        xfUHtrUi6eDo8L0Nn9KTMP2DD0P26VZ8NtOosd4H5g==
X-Google-Smtp-Source: APXvYqwSOrs2sa+E7QbDi8H+rGvNlfN5l/NCXi93Y1fBJESRHAf13gMFAaGH1xt3XOfSvi2wrGNiBNIemXtPPjgIyrQ=
X-Received: by 2002:a37:e312:: with SMTP id y18mr5426499qki.250.1574930443688;
 Thu, 28 Nov 2019 00:40:43 -0800 (PST)
MIME-Version: 1.0
References: <0000000000009aa32205985e78b6@google.com> <2825703.dkhYCMB3mh@sven-edge>
In-Reply-To: <2825703.dkhYCMB3mh@sven-edge>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 28 Nov 2019 09:40:32 +0100
Message-ID: <CACT4Y+YwNGWCXBazm+7GHpSw-gXsxmA8NA-o7O7Mpj3d-dhGYA@mail.gmail.com>
Subject: Re: WARNING in mark_lock (3)
To:     Sven Eckelmann <sven@narfation.org>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     syzbot <syzbot+a229d8d995b74f8c4b6c@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        netdev <netdev@vger.kernel.org>, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        vinicius.gomes@intel.com, wang.yi59@zte.com.cn,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 8:25 AM Sven Eckelmann <sven@narfation.org> wrote:
>
> On Thursday, 28 November 2019 03:00:01 CET syzbot wrote:
> [...]
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=132ee536e00000
> > start commit:   89d57ddd Merge tag 'media/v5.5-1' of git://git.kernel.org/..
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=10aee536e00000
>
> Can the syzbot infrastructure be told to ignore this crash in the bisect run?
> Because this should be an unrelated crash which is (hopefully) fixed in
> 40e220b4218b ("batman-adv: Avoid free/alloc race when handling OGM buffer").

+syzkaller mailing list for syzbot discussion

Hi Sven,

There is no such functionality at the moment.
What exactly do you mean? Somehow telling it interactively? Or
hardcode some set of crashes for linux? I don't see how any of these
options can really work...
