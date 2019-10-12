Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC9AD51A2
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfJLSev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 14:34:51 -0400
Received: from mout.web.de ([212.227.15.4]:45025 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfJLSev (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 14:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1570905280;
        bh=tnUCoeFj2C0v+2VNSy0rywq/m+iexZfrWWmmse2Betw=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=Cy/iYMQrK2HxmrBeEidu+rEMvmriEQZWz45f3swHeDzr8gPjhNfRPrRuMzPGn+3wL
         7k9b2M23LI/RP3atUOUwKGkseeEXv8dmhFrg+HoYm7nIyYLKCmIj4DpUorXVmS0G2F
         7f3HyBsW/++CwtlsBRa9s65aQOAqh0y6wt+hD/NA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.155.250]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lfipe-1hhYcH3MhG-00pK6t; Sat, 12
 Oct 2019 20:34:39 +0200
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: mac80211: Checking a kmemdup() call in ieee80211_send_assoc()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
Message-ID: <1b2c589c-46d4-2bad-ed54-176b7c2f66bf@web.de>
Date:   Sat, 12 Oct 2019 20:34:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Z0eKhyF/1qhVEuJn8+76n7DUgjpIAkCcKI8tnk3AgDF3NnwtXY9
 wN8UhUue8mAU9m2c8hDiLmtDkFp40/Z2DRfQS0/t5QF8qMwmmy+YkXVugr8cCuuJkVEhpYr
 lVSIuQdejpLA4OK3RshTTLe7ziHim7udHZE8PFnn0hUHAdInDAoJv0kFTuSPH9aaJtz6sDs
 ABg9drpClLh0DJac3WM/A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:x/KgguxDvGA=:ESEK/BX8Khoof0DULGuntb
 6dntcI75FerXZa/IqZBeJKpWBPCE0HrwgoJ0wa4pcYfIwf3B9wSP26CEyXukU/c5l66nPoXZ1
 2+JB0cDS6BBNaZfcCGIiTn21WEY3Skv8LD5T6I0KM376ektyZCnUzZyLqZ7l+t85hu+kQjzlc
 xblpksGkhboh8PUrZlU2EACgCcfUs3vcsy8VGftb+jdP/xk/riLwg7Qy7Kcvm8I+zK9eM5kGF
 /OLx5GQEKd8hl7h219CxR5BB8Cz0TubMqaDBxtexESawFUywXKqPVFRj6PrNXOsYq18QQgzCf
 hTupfj3gTIlXj5wONE1rhmBHCjpa8N78d94Ne9GymiJsgzCwsk+RKw6ky+QDbIUPZ7CkBLbXS
 vxRwwPsCRbiuDkuKn7IuUweLmKcwkOJsT6IeDDQCCMzWtxyPaKBkZrUm8NDVyMpatHM+whac5
 yT2UsDeut8eQHveDxU5g527J9WRuXrok8nBwVscr/Suu4avLCITN3RaRlgY79YIHzH5rvRo+o
 HdO8EK9aLYHv7GIlv1XN1gz/kKchdSv9fiJGNbTryDUN7IqJJMb6sbDSjPQijTCU6oZX26+CG
 JMF9dsH4iGZGvldwLuj90mEHhHBiVYmTLQZrrnXP2ulz/9hhY9NPzAw04JqzMdZiPbN4Onz7u
 7/03064dsysUsgGKX99iZkv/vWAZ53kQsZdZVfG6NQ14LWTS85NTNsQqmdjNv56vObLY9y+Hl
 fb3j0VbxvP/FPVP28Z8/suF2aM9ufL+ddOhIRgy8x9u/X+excKk2M0RugYRqQDGSQNgr5oc2n
 nbuIV7XXQWZ+vV5aECA0pQQAPGit/DWgMxfbklDXqJg2NaIF6xOSMyceHHVYG9mnN1voIAu2B
 I4s+8uKh/u5Ou7hQf1FCbVCe81Pre5bOHjCLKDewikNz3DmIwDjIeIAyMLV2vB4VSIDUH4pme
 HoJ8dHbPGtY+neJkJ1d03cfNp5thR1Gndn6xUIL9I6lbSmXP3gYj9L6PXmEOO/W/Ywj+efsZS
 XplNJ57+wJb3s3SG8746A1hw2mDocDEos/r0RDJu4mhTVMroeJoiMfw01uyp0E12FXwybXZS2
 +4nY9qH+VWklCGfvlsKm+YRr0dzkehtMq2MotAaChBPSaH7pmBm/UiyiNkrU5d0koXbfkjl2I
 EOqiRSBGLgX7H53nM+x34opMa99Ux5h2ryocn0X7pL2rPy3TBEwqCCRTQCpVBZCz0rVtc7Bpv
 4Zcx63Qs8L88H1vjJqmoPnwbK9DfaQZNUUF7fwrZTgPlfMsE13oxl1cVEeuI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I tried another script for the semantic patch language out.
This source code analysis approach points out that the implementation
of the function =E2=80=9Cieee80211_send_assoc=E2=80=9D contains still an u=
nchecked call
of the function =E2=80=9Ckmemdup=E2=80=9D.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/ne=
t/mac80211/mlme.c?id=3D1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#n980
https://elixir.bootlin.com/linux/v5.4-rc2/source/net/mac80211/mlme.c#L980

How do you think about to improve it?

Regards,
Markus
