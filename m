Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD34198A0D
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 04:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgCaCil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 22:38:41 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:44419 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbgCaCil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 22:38:41 -0400
Received: by mail-ua1-f67.google.com with SMTP id r47so7119120uad.11;
        Mon, 30 Mar 2020 19:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lQkNuHfdbFfCrISunCbd5HE6GiAQV73qbHuCCjJGU+Q=;
        b=P9OR+DCNnGZCC8QKXk7qtERH2e/a6DlXVss0LKQpzu5ViaB4T2UH5YEYbWe/NYoxSN
         hlda1Zp9XlzNN87pVQ4X2emIKM0oz7W08fvm2bq+ZUGHAKJMvj8eRi8VrPte+RPsMjbF
         bFyyz0K+EWz/QEnKEtzV9BcC+Mjgz/Lpem5Hk7zQbN60seN5Jf2GlkCU5VaDpbpg6Tgu
         0juzcZOgGj522fd+AyTyADUd97z69OpMjkrU0fJRwrCQHK0YczS+hOJFCIx9G4uCEyBg
         VchFPczefuqsD7aUAt8FWGTEAhZJuA0SFj1GsEoOzNafbCAB8p5uk7J7qUIjf17stdtc
         B6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lQkNuHfdbFfCrISunCbd5HE6GiAQV73qbHuCCjJGU+Q=;
        b=GVph2CJl5gVUbRyUmEjjusqVPvMAWJgelAG8SYLScEqMVlHRLss9fvYZ+cZGjc8dTu
         XMyhlK7pEdO8yB2WLZ2+J8YIiyilnkQ8sT1XbZyc1ODPXKII7cFVKaxdAHyqlonuxQGm
         wjNgq+plFTH+uVarLEnD8V0Cb5V5hdAYRj+hLaipgRFvOHTDf01h6LoTmLW9qm3HTmpn
         nL6NUeO4vueexNYOyyyGfsv+DBuXspLzorXwXVNrMq/ZcS+2a8Q+HYEp1w0PTjuMobNq
         +taXXuy1l4fIXWCdGBPaTVV/BowQBQjd8jYx/u5F3ShnAi+CIItPzwcMPN3nWratHqJO
         7FJQ==
X-Gm-Message-State: AGi0PubeCEHDFaDrYq/fggRP0BAOrIwoB639Qqe5XIjmtkpK9GcBsbuu
        +3I+gZhXeclolyeQNUBvx7DsNByDZ9z11jT1HPU=
X-Google-Smtp-Source: APiQypIydMRa8jN5Ea+TWdh9b6HfG5Jo/9+sicel9yiAw+Dkxl7k6OiISRTly3cd4Euc+eYwWxkH0C6wvmibFm7TuUM=
X-Received: by 2002:ab0:7406:: with SMTP id r6mr1669634uap.22.1585622319702;
 Mon, 30 Mar 2020 19:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000003d7c1505a2168418@google.com>
In-Reply-To: <0000000000003d7c1505a2168418@google.com>
From:   Qiujun Huang <anenbupt@gmail.com>
Date:   Tue, 31 Mar 2020 10:38:28 +0800
Message-ID: <CADG63jD_VnBJ-fHfStVq5=4ceAT=nwqkXdWzJPcfu1U=fF657A@mail.gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
To:     syzbot <syzbot+d403396d4df67ad0bd5f@syzkaller.appspotmail.com>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        kvalo@codeaurora.org, LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: multipart/mixed; boundary="0000000000001d68c405a21d7706"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001d68c405a21d7706
Content-Type: text/plain; charset="UTF-8"

#syz test: https://github.com/google/kasan.git usb-fuzzer

On Tue, Mar 31, 2020 at 2:21 AM syzbot
<syzbot+d403396d4df67ad0bd5f@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=159a0583e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a782c087b1f425c6
> dashboard link: https://syzkaller.appspot.com/bug?extid=d403396d4df67ad0bd5f
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177a266de00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1579f947e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+d403396d4df67ad0bd5f@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:626 [inline]
> BUG: KASAN: stack-out-of-bounds in ath9k_hif_usb_rx_cb+0xdf6/0xf70 drivers/net/wireless/ath/ath9k/hif_usb.c:666
> Write of size 8 at addr ffff8881db309a28 by task swapper/1/0
>
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xef/0x16e lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
>  __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
>  kasan_report+0xe/0x20 mm/kasan/common.c:641
>  ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:626 [inline]
>  ath9k_hif_usb_rx_cb+0xdf6/0xf70 drivers/net/wireless/ath/ath9k/hif_usb.c:666
>  __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
>  usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
>  dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
>  call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
>  expire_timers kernel/time/timer.c:1449 [inline]
>  __run_timers kernel/time/timer.c:1773 [inline]
>  __run_timers kernel/time/timer.c:1740 [inline]
>  run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

--0000000000001d68c405a21d7706
Content-Type: application/octet-stream; name="hif_usb.patch"
Content-Disposition: attachment; filename="hif_usb.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k8faiqee0>
X-Attachment-Id: f_k8faiqee0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9oaWZfdXNiLmMgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaGlmX3VzYi5jCmluZGV4IGRkMGMzMjMuLjky
Yzk0ZmMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9oaWZfdXNi
LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2hpZl91c2IuYwpAQCAtNjEy
LDYgKzYxMiwxMCBAQCBzdGF0aWMgdm9pZCBhdGg5a19oaWZfdXNiX3J4X3N0cmVhbShzdHJ1Y3Qg
aGlmX2RldmljZV91c2IgKmhpZl9kZXYsCiAJCQloaWZfZGV2LT5yZW1haW5fc2tiID0gbnNrYjsK
IAkJCXNwaW5fdW5sb2NrKCZoaWZfZGV2LT5yeF9sb2NrKTsKIAkJfSBlbHNlIHsKKwkJCWlmIChw
b29sX2luZGV4ID09IE1BWF9QS1RfTlVNX0lOX1RSQU5TRkVSKSB7CisJCQkJZGV2X2VycigiYXRo
OWtfaHRjOiBvdmVyIFJYIE1BWF9QS1RfTlVNXG4iKTsKKwkJCQlnb3RvIGVycjsKKwkJCX0KIAkJ
CW5za2IgPSBfX2Rldl9hbGxvY19za2IocGt0X2xlbiArIDMyLCBHRlBfQVRPTUlDKTsKIAkJCWlm
ICghbnNrYikgewogCQkJCWRldl9lcnIoJmhpZl9kZXYtPnVkZXYtPmRldiwK
--0000000000001d68c405a21d7706--
