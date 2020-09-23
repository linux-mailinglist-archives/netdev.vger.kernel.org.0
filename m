Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C27276058
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIWSqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:46:15 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:35555 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgIWSqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:46:14 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M89P1-1kOi931zbn-005Hlb; Wed, 23 Sep 2020 20:46:10 +0200
Received: by mail-qt1-f182.google.com with SMTP id a4so831862qth.0;
        Wed, 23 Sep 2020 11:46:09 -0700 (PDT)
X-Gm-Message-State: AOAM531B6RKNkGQC/NDN1KVy6L7ZJDh/eTh8x/vyn/fCGays+viehdTH
        kYMDsdGq5j5wMlrpbikXGrM/muVRkR5VaFZOmUo=
X-Google-Smtp-Source: ABdhPJwsvaOBWtaZA0D/OVEHB/gCWu247kr3QZZFrdP10NBc4wqx9Hcp+T5ZYDolhQMYUd20W7JjEkRUKsdbgp0ivyQ=
X-Received: by 2002:ac8:64a:: with SMTP id e10mr1527617qth.142.1600886767946;
 Wed, 23 Sep 2020 11:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200923060547.16903-1-hch@lst.de> <20200923060547.16903-6-hch@lst.de>
 <20200923142549.GK3421308@ZenIV.linux.org.uk> <20200923143251.GA14062@lst.de>
 <20200923145901.GN3421308@ZenIV.linux.org.uk> <20200923163831.GO3421308@ZenIV.linux.org.uk>
In-Reply-To: <20200923163831.GO3421308@ZenIV.linux.org.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 23 Sep 2020 20:45:51 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3nkLUOkR+jwz2_2LcYTUTqdVf8JOtZqKWbtEDotNhFZA@mail.gmail.com>
Message-ID: <CAK8P3a3nkLUOkR+jwz2_2LcYTUTqdVf8JOtZqKWbtEDotNhFZA@mail.gmail.com>
Subject: Re: [PATCH 5/9] fs: remove various compat readv/writev helpers
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Networking <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:mMkQRAJUWfdk4a4PEkmTkMjSEPbcbr4OqrN3fUr4LQ2AQqlPl0n
 bOWryggRLru9T6JJoTMuOGI9kvl/I6BtMLB/VbJVDYLH2lraHpn3UOgXAQiZMVZJ9Wt6/3q
 dgtI834LPxJGojFQwlbq6VqcE61sUtAzG9Asu4SnN3A1f/GYReptJqFvli47ZUGxJu1McD6
 wXqFv/2sZdtXtrzvqb6Gw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ARXrn3BJvHg=:OaZDrHRji4s3F+Z4R525Bn
 agD8Hjw3INq7irUQDHIrs31n4HiItPG1qRH9sCOQsBDzKfQ2GBPxOe8cQiCUK6etjcRZgS5uz
 ltu+yxAg8SdJB7S6UrMx8x4gZIRJZNx/h1Pd359G8hRQEWUkB77c3Uu7iX6+oWPogrXiRLcyE
 Ay+LH2roCsVe74rsugu9p8r/jxgEYoo6ke7HkJiyLsrJx77n+/GWpX9PQTbGXJGYCmPKo03Dx
 7rZxQHvz4lzlsQGvZ22Lw1H85lBROKXGp/T1YCWt7CkiGs0Y/R3V3UonSnBX41Bf98v3feicD
 RYBnkyjEcAUUQRR5u9cw067xVVV2JdvUKInxkNdutFVn0CM66u/fDJxueg1uLRW9RPYp7DjVs
 Mx/HRUmO0wQonj6taqWhVCgSUthPIg1jpw3qykbSoDJ96MDdaz8DcUt+7qpkA5t/+tGOD+rWW
 Bn0ajxwLkORS0R61/JXIJExhw4SvyLBTVKDr7LI7QuYFV9tfgKH3fZzLZmBkdPEqiGd2kyAMe
 0agELAyDb5Rehyc/3jcYzTGZyQ9nlXuD/YYv4vEmC1CRzjxWF4KIZFY6D3HWoeuUMlzvMCijI
 ue6FAYnnAerqxzrTow74a1x9I80VfvnWRTz0xYpnoiGRegiq0P5uWv1YSyriRyFortckburp8
 xW1/xnziTC/+/JUjrApbsItKfFZpj/Vffo23zPwOLXvOArj8zkutkvZ9h8hGYgo934l9OKJGu
 P5NJw1LlqSAdgmNcPhTbFVxjnCSs1G9+5tq34fiY8XA66+2tLlwvaAnYp+zv5HOWn5OOwlMar
 YndfSM38x1BkZ1kFiYikEr51lnNKUep3VIupblSMr1ljcWZWbNW0XzKu+xNzfuUJBnp9WMfFy
 7T3ELZ0Iq8IWSMYb0u7TCVmN4B9t5+iKBzUQ+0CqaqKkDuOmWY7NnBHAU/IZ6fceZMEkzvN4O
 Id5+SP2sVY8Io6R5XqdC6M9inrRybKQ1OIWUL/7Bpv8x4eU8nqVGM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 6:38 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I wonder if we should do something like
>
> SYSCALL_DECLARE3(readv, unsigned long, fd, const struct iovec __user *, vec,
>                  unsigned long, vlen);
> in syscalls.h instead, and not under that ifdef.
>
> Let it expand to declaration of sys_...() in generic case and, on x86, into
> __do_sys_...() and __ia32_sys_...()/__x64_sys_...(), with types matching
> what SYSCALL_DEFINE ends up using.
>
> Similar macro would cover compat_sys_...() declarations.  That would
> restore mismatch checking for x86 and friends.  AFAICS, the cost wouldn't
> be terribly high - cpp would have more to chew through in syscalls.h,
> but it shouldn't be all that costly.  Famous last words, of course...
>
> Does anybody see fundamental problems with that?

I've had some ideas along those lines in the past and I think it should work.

As a variation of this, the SYSCALL_DEFINEx() macros could go away
entirely, leaving only the macro instantiations from the header to
require that syntax. It would require first changing the remaining
architectures to build the syscall table from C code instead of
assembler though.

Regardless of that, another advantage of having the SYSCALL_DECLAREx()
would be the ability to include that header file from elsewhere with a different
macro definition to create a machine-readable version of the interface when
combined with the syscall.tbl files. This could be used to create a user
space stub for calling into the low-level syscall regardless of the
libc interfaces,
or for synchronizing the interfaces with strace, qemu-user, or anything that
needs to deal with the low-level interface.

      Arnd
