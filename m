Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA02739E632
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhFGSJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhFGSJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:09:06 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917A8C061766;
        Mon,  7 Jun 2021 11:06:59 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id j12so14436532pgh.7;
        Mon, 07 Jun 2021 11:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FuFCxxhlqU1gJ6Q4Qz+Q1WuISkrmAV+veNCgzB0JY00=;
        b=kuOL0fuiPa7F7ByFMrWT55XaKJA81MJT49hCSvfUhTetF5lmf6+GyuoT2Mv0i6G5vD
         4XxTxqNFcjaVg63Hjj4Dth2BWqVToV6ELrpbEyBJCDG2b6KeLythaOu+zvqqCTN4kjHg
         d/VO/Po8E86FZYdf9d3y59EBXPC8FoMvPt6aXR5MLi6GdnvP2TjMQPtV60l42LNzdQaw
         uqnEoseVznQ57LqR32Kc5TOJLQefWipxIyQnM+hgmjTHg0AyFkLqRPq34CO4omcgux5S
         ly7+Dt0oUlCRPFngVPuB6gwke7bYV8k37aVv37H/ahnfE5AkwtUtsxVkYxYx1SGtsY9+
         1n8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FuFCxxhlqU1gJ6Q4Qz+Q1WuISkrmAV+veNCgzB0JY00=;
        b=XnnZ23xU2snNnkj+9t01jeBXNK5+DiYoS8Qk/HRkvTT/fVC8/7pDNSZdSaHAveIJYD
         O6oAic+c2Xlh3Ft7lM04daeBilS+OZSoynAykPfX0fzFA8r9/XoXQpAvbmHHdiMUcMRb
         PXU4k/dxN7mDE7YklvdGPUlzMkjZja7opeW9ePrOMNnHNkx6ScJEBZRgnuKLgZcHrMhO
         RGg6BDJhOuVYk8D3+AYRO/zP88Iqoft3H8y/Fi2UF9tm7FxIh4cNXSyYfBQ720ql7wV/
         cg6ad2a01Fqf7idjjU9Uup66lP3qVXNf5Du8jz4qSfiV/a9Ahepk1Ce5ZAIpwh2HSAsz
         ijUg==
X-Gm-Message-State: AOAM532bXb/Y1EixaudbICSyJ3QkTkNIG0VP1JhNivKGMtbyZzghdbNR
        TOSDbKAw5sqQxrlnPK3IxuuKNvFcsKetMdir6fg=
X-Google-Smtp-Source: ABdhPJzeNnoVt3jjJSGHz9gnsdo6w872WBQBE+scFXh06cicWVZKw8r5aJVWDd8xefFUSsKtkHeRRSDajz+L82/QXDE=
X-Received: by 2002:a65:50c5:: with SMTP id s5mr18835460pgp.138.1623089219001;
 Mon, 07 Jun 2021 11:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f8e51405beaebdde@google.com> <00000000000064e7d505c4214310@google.com>
In-Reply-To: <00000000000064e7d505c4214310@google.com>
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Mon, 7 Jun 2021 21:06:32 +0300
Message-ID: <CAKErNvpTgH+=fcoNy=D31Ky2USJSfd5tNXpTGn7wCPYt-5Hfig@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nfc_llcp_sock_unlink
To:     syzbot <syzbot+8b7c5fc0cfb74afee8d1@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        bp@alien8.de, "David S. Miller" <davem@davemloft.net>,
        hpa@zytor.com, Jiri Kosina <jikos@kernel.org>, jkosina@suse.cz,
        jmattson@google.com, joro@8bytes.org, kuba@kernel.org,
        kvm@vger.kernel.org, linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tseewald@gmail.com, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 2:27 AM syzbot
<syzbot+8b7c5fc0cfb74afee8d1@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit f567d6ef8606fb427636e824c867229ecb5aefab
> Author: Maxim Mikityanskiy <maxtram95@gmail.com>
> Date:   Sun Feb 7 14:47:40 2021 +0000
>
>     HID: plantronics: Workaround for double volume key presses

Dear syzbot,

I highly doubt my commit could fix any use-after-free bug in NFC. It's
not related to NFC, and it's not a bugfix. Probably the repro isn't
100% stable, so the bisect results are invalid.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e41588300000
> start commit:   bbd6f0a9 bnxt_en: Fix RX consumer index logic in the error..
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=339c2ecce8fdd1d0
> dashboard link: https://syzkaller.appspot.com/bug?extid=8b7c5fc0cfb74afee8d1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1712a893d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1298b469d00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: HID: plantronics: Workaround for double volume key presses
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
