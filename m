Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393606D73F
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 01:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfGRX0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 19:26:50 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33704 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfGRX0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 19:26:50 -0400
Received: by mail-qk1-f193.google.com with SMTP id r6so21940988qkc.0
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 16:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TED1YMmih5CMaQpPogtNSe98eoJfXq3PHOIoVZoVmXs=;
        b=eWao9mqtXSE9FIpvXcxEjX2v53F6fcDEZeDqxHDrpIeaRS5OKgD4U/69LRSNZavmD7
         rYeX8gV/Hh3ZXxyRPUBw7KyXz8txocn8hhhDI7pU9igo+83feIiGMF56X7JKVhEj0J9W
         t6SB4Cy35v7f1/5I9equwIeHf+7qmPUlEx+mIYXjOnjMdiGPdMcbqQmoHJtY7GU2SWqB
         g30Rk2Bkpmn/YEbtqxobLlyI8MWPxYvRFQiMSN4rT3cCJgCNwC0oz1fVtmQbSZv5AWvh
         HPMpy7q/q3HRkE2pxwIYMXjUVL8WM+m+UfKTQs0in8APrDxMNsW9pBas0Lwipp4Q1MLk
         PmDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TED1YMmih5CMaQpPogtNSe98eoJfXq3PHOIoVZoVmXs=;
        b=Nl++1apP+Tn9dr9CWMHltodgZNqn2lCDtSepieJR90UkfZUfM0hn9qkfhvTJm4XzCd
         +AQLrChE44+Bh+qMBs/YLHNBnV64AO3NnBS4Gmj2B7jj9Wn1PNk3AfgJDmZGw2kOqZ/S
         C6olC/qYd3+Xj3n+xLC6DZ/oZKF+JdKJIY/ocM6jkXXTvZ8GHDZhYw/gjLDZLgVIEtJv
         TF3vKpY/0lepibrTgAQzFNZSo24MpHKzHKY/tW6MlSATxF8UgHUCEPtTbTf1LwAJ5jR5
         6+fnUXgcX9J25F6LlmJQ2YBNPYQLARkMEsTSgAJLGIIirPEKMdRoS78M2sqgLnrud5xT
         /yyQ==
X-Gm-Message-State: APjAAAV7NSEdwI1pcSRNxJgW72mAW52IsTj0o/Ee5ykdtOxBmXp1farQ
        7qdI4fbpovUz9zelv+SmmNhvhg==
X-Google-Smtp-Source: APXvYqyJVK7Uhlc9y7Ytvg/jKRAuZxqH/0++WZuRk63Rtwo9DtHqJwFSYpumxqGYcgetLL78Fx2oCg==
X-Received: by 2002:a37:aa0d:: with SMTP id t13mr34659564qke.167.1563492409444;
        Thu, 18 Jul 2019 16:26:49 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id i23sm12971496qtm.17.2019.07.18.16.26.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 16:26:48 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <CAGG=3QUvdwJs1wW1w+5Mord-qFLa=_WkjTsiZuwGfcjkoEJGNQ@mail.gmail.com>
Date:   Thu, 18 Jul 2019 19:26:47 -0400
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        James Y Knight <jyknight@google.com>,
        David Miller <davem@davemloft.net>, sathya.perla@broadcom.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, netdev@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <75B428FC-734C-4B15-B1A7-A3FC5F9F2FE5@lca.pw>
References: <1562959401-19815-1-git-send-email-cai@lca.pw>
 <20190712.154606.493382088615011132.davem@davemloft.net>
 <EFD25845-097A-46B1-9C1A-02458883E4DA@lca.pw>
 <20190712.175038.755685144649934618.davem@davemloft.net>
 <D7E57421-A6F4-4453-878A-8F173A856296@lca.pw>
 <CAKwvOdkCfqfpJYYX+iu2nLCUUkeDorDdVP3e7koB9NYsRwgCNw@mail.gmail.com>
 <CAGG=3QUvdwJs1wW1w+5Mord-qFLa=_WkjTsiZuwGfcjkoEJGNQ@mail.gmail.com>
To:     Bill Wendling <morbo@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 18, 2019, at 5:21 PM, Bill Wendling <morbo@google.com> wrote:
>=20
> [My previous response was marked as spam...]
>=20
> Top-of-tree clang says that it's const:
>=20
> $ gcc a.c -O2 && ./a.out
> a is a const.
>=20
> $ clang a.c -O2 && ./a.out
> a is a const.


I used clang-7.0.1. So, this is getting worse where both GCC and clang =
will start to suffer the
same problem.

>=20
>=20
> On Thu, Jul 18, 2019 at 2:10 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
>>=20
>> On Thu, Jul 18, 2019 at 2:01 PM Qian Cai <cai@lca.pw> wrote:
>>>=20
>>>=20
>>>=20
>>>> On Jul 12, 2019, at 8:50 PM, David Miller <davem@davemloft.net> =
wrote:
>>>>=20
>>>> From: Qian Cai <cai@lca.pw>
>>>> Date: Fri, 12 Jul 2019 20:27:09 -0400
>>>>=20
>>>>> Actually, GCC would consider it a const with -O2 optimized level =
because it found that it was never modified and it does not understand =
it is a module parameter. Considering the following code.
>>>>>=20
>>>>> # cat const.c
>>>>> #include <stdio.h>
>>>>>=20
>>>>> static int a =3D 1;
>>>>>=20
>>>>> int main(void)
>>>>> {
>>>>>     if (__builtin_constant_p(a))
>>>>>             printf("a is a const.\n");
>>>>>=20
>>>>>     return 0;
>>>>> }
>>>>>=20
>>>>> # gcc -O2 const.c -o const
>>>>=20
>>>> That's not a complete test case, and with a proper test case that
>>>> shows the externalization of the address of &a done by the module
>>>> parameter macros, gcc should not make this optimization or we =
should
>>>> define the module parameter macros in a way that makes this =
properly
>>>> clear to the compiler.
>>>>=20
>>>> It makes no sense to hack around this locally in drivers and other
>>>> modules.
>>>=20
>>> If you see the warning in the original patch,
>>>=20
>>> =
https://lore.kernel.org/netdev/1562959401-19815-1-git-send-email-cai@lca.p=
w/
>>>=20
>>> GCC definitely optimize rx_frag_size  to be a constant while I just =
confirmed clang
>>> -O2 does not. The problem is that I have no clue about how to let =
GCC not to
>>> optimize a module parameter.
>>>=20
>>> Though, I have added a few people who might know more of compilers =
than myself.
>>=20
>> + Bill and James, who probably knows more than they'd like to about
>> __builtin_constant_p and more than other LLVM folks at this point.
>>=20
>> --
>> Thanks,
>> ~Nick Desaulniers

