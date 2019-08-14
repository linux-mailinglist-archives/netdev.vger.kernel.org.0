Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B918DE1E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfHNTya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:54:30 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34018 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbfHNTya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 15:54:30 -0400
Received: by mail-lf1-f65.google.com with SMTP id b29so155838lfq.1
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 12:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6B5UcJxV8QUT2xZ6Wa6Deh/vIXzkPqawf+42QwI2RC0=;
        b=h/LWBAideIyWkQIHvw7Vk8BDQBK/M5Ru0Gm3t/olYp7yNDj2TeNTmGb9zj3tZRkinY
         2TzhRI1wLoyjlhDns56KUyEChBmejXT2sgXyacwfOToRDuuzOGJlrxtekZfNJ6znK984
         in75QtKmUK+5nZAxmKhUY0PNaFLDV2os3JVGjHD1UqLDolbkhDU/I/Wm002eo+aQ8rv+
         IwW/BIj9B4UBo9+9wl9WPgPUBsH7MBzTQNQR5ff94ND2W38pWe+YSq3oVag0+f6Bgo9Y
         uVPI0WepFap79C0GLvO3CC0C/eWw5v1mb/lVPgNhjrv8kWaYg/NwiKMK84Q1f+n9ZQnk
         lyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=6B5UcJxV8QUT2xZ6Wa6Deh/vIXzkPqawf+42QwI2RC0=;
        b=Fuex1DU6lef/K2Zo3RJ0gNvQSlvzyjfgxcRYSDuLEy+FgbNaUqjDYRF3rkTu575rtE
         WEroOyrwr9tGSIl9KNO5dL8qCZwR2TCHyT6R6PdBI3ORsdvFDpw1WJjVwP11FuAmMh07
         +3pMg8N+zRI1nDofqdMAY1gKB6GX3KpBSKd4jst+vtfPdrKDDdO/eX1DaopYVUXPmoWc
         9NmJum7/FR3gs/FsF3DM4sWGRPlL8tpOi94q8F0l53phs4c13BKuVLZr64SXEIPu6HRm
         gVQ4t1wFvyvLCLxc5UdJB2ii2+n/JENZJ0aqeJrlQIZb8sfOQJouE4r/+srAbAtLpEi0
         gjjw==
X-Gm-Message-State: APjAAAXs1rSiW7OaOFDDS2Wt9KB7U0r7mRw/PQnIGkQqh0CMTiBVrTVc
        lHxr3euZ8X+QC3hg4l2ohdfdHQ==
X-Google-Smtp-Source: APXvYqz3BVlBA6rFpKdvAjbcFzp/DKKxSJ2xn1Xflg5G44k0mxsQduF2H0waaUdaf8jvYeDtdwVOdQ==
X-Received: by 2002:a19:2d15:: with SMTP id k21mr551454lfj.188.1565812468085;
        Wed, 14 Aug 2019 12:54:28 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id e11sm103604ljo.19.2019.08.14.12.54.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Aug 2019 12:54:27 -0700 (PDT)
Date:   Wed, 14 Aug 2019 22:54:25 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Message-ID: <20190814195423.GE4142@khorivan>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
 <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
 <20190814092403.GA4142@khorivan>
 <20190814115659.GC4142@khorivan>
 <CAJ+HfNiqu7WEoBFnfK3znU4tVyAmpPVabTjTSKH1ZVo2W1rrXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNiqu7WEoBFnfK3znU4tVyAmpPVabTjTSKH1ZVo2W1rrXg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 03:32:24PM +0200, Björn Töpel wrote:
>On Wed, 14 Aug 2019 at 13:57, Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>> On Wed, Aug 14, 2019 at 12:24:05PM +0300, Ivan Khoronzhuk wrote:
>> >On Tue, Aug 13, 2019 at 04:38:13PM -0700, Andrii Nakryiko wrote:
>> >
>> >Hi, Andrii
>> >
>> >>On Tue, Aug 13, 2019 at 3:24 AM Ivan Khoronzhuk
>> >><ivan.khoronzhuk@linaro.org> wrote:
>> >>>
>> >>>That's needed to get __NR_mmap2 when mmap2 syscall is used.
>> >>>
>> >>>Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> >>>---
>> >>> tools/lib/bpf/xsk.c | 1 +
>> >>> 1 file changed, 1 insertion(+)
>> >>>
>> >>>diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> >>>index 5007b5d4fd2c..f2fc40f9804c 100644
>> >>>--- a/tools/lib/bpf/xsk.c
>> >>>+++ b/tools/lib/bpf/xsk.c
>> >>>@@ -12,6 +12,7 @@
>> >>> #include <stdlib.h>
>> >>> #include <string.h>
>> >>> #include <unistd.h>
>> >>>+#include <asm/unistd.h>
>> >>
>> >>asm/unistd.h is not present in Github libbpf projection. Is there any
>> >
>> >Look on includes from
>> >tools/lib/bpf/libpf.c
>> >tools/lib/bpf/bpf.c
>> >
>> >That's how it's done... Copping headers to arch/arm will not
>> >solve this, it includes both of them anyway, and anyway it needs
>> >asm/unistd.h inclusion here, only because xsk.c needs __NR_*
>> >
>> >
>>
>> There is one more radical solution for this I can send, but I'm not sure how it
>> can impact on other syscals/arches...
>>
>> Looks like:
>>
>>
>> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>> index 9312066a1ae3..8b2f8ff7ce44 100644
>> --- a/tools/lib/bpf/Makefile
>> +++ b/tools/lib/bpf/Makefile
>> @@ -113,6 +113,7 @@ override CFLAGS += -Werror -Wall
>>  override CFLAGS += -fPIC
>>  override CFLAGS += $(INCLUDES)
>>  override CFLAGS += -fvisibility=hidden
>> +override CFLAGS += -D_FILE_OFFSET_BITS=64
>>
>
>Hmm, isn't this glibc-ism? Does is it work for, say, musl or bionic?
>
>If this is portable, and works on 32-, and 64-bit archs, I'm happy
>with the patch. :-)

https://users.suse.com/~aj/linux_lfs.html

BIONIС
======
https://android.googlesource.com/platform/bionic
So, LFS is in bionic since Fri Feb 6 22:28:49 2015
68dc20d41193831a94df04b994ff2f601dd38d10
Author: Elliott Hughes <enh@google.com>
Implement _FILE_OFFSET_BITS (mostly)


MUSL
====
I took here: git@github.com:kraj/musl.git
With musl situation is a little different, seems like, it provides
64bit off_t by default


#if defined(_LARGEFILE64_SOURCE) || defined(_GNU_SOURCE)
#define lseek64 lseek
#define pread64 pread
#define pwrite64 pwrite
#define truncate64 truncate
#define ftruncate64 ftruncate
#define lockf64 lockf
#define off64_t off_t
#endif

and

/* If _GNU_SOURCE was defined by the user, turn on all the other features.  */
#ifdef _GNU_SOURCE
# undef  _ISOC95_SOURCE
# define _ISOC95_SOURCE	1
# undef  _ISOC99_SOURCE
# define _ISOC99_SOURCE	1
# undef  _ISOC11_SOURCE
# define _ISOC11_SOURCE	1
# undef  _POSIX_SOURCE
# define _POSIX_SOURCE	1
# undef  _POSIX_C_SOURCE
# define _POSIX_C_SOURCE	200809L
# undef  _XOPEN_SOURCE
# define _XOPEN_SOURCE	700
# undef  _XOPEN_SOURCE_EXTENDED
# define _XOPEN_SOURCE_EXTENDED	1
# undef	 _LARGEFILE64_SOURCE
# define _LARGEFILE64_SOURCE	1
# undef  _DEFAULT_SOURCE
# define _DEFAULT_SOURCE	1
# undef  _ATFILE_SOURCE
# define _ATFILE_SOURCE	1
#endif

So shouldn't be issuse.

64 ARCHES
=========
Should also work, if grep on _FILE_OFFSET_BITS tool:

./lib/api/Makefile:CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
./lib/subcmd/Makefile:CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE

So, it's used already and no problems.
But here one moment, _LARGEFILE64_SOURCE is also defined, probably for MUSL 
(despite it's defined anyway) just to be sure.

So, in Makefile, for sure, will be:

override CFLAGS += -D_FILE_OFFSET_BITS=64
verride CFLAGS += -D_LARGEFILE64_SOURCE

-- 
Regards,
Ivan Khoronzhuk
