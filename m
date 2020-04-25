Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787EB1B865A
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 13:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgDYLxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 07:53:11 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:55286 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgDYLxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 07:53:11 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id 23BB420028;
        Sat, 25 Apr 2020 13:53:05 +0200 (CEST)
Date:   Sat, 25 Apr 2020 13:53:03 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Christian Brauner <christian@brauner.io>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Song Liu <songliubraving@fb.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Yonghong Song <yhs@fb.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/16] kbuild: support 'userprogs' syntax
Message-ID: <20200425115303.GA10048@ravnborg.org>
References: <20200423073929.127521-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423073929.127521-1-masahiroy@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=ULXz4hXy c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=kj9zAlcOel0A:10 a=D19gQVrFAAAA:8 a=7gkXJVJtAAAA:8
        a=-Cqz4C0WQvTMSLUl_DAA:9 a=CjuIK1q_8ugA:10 a=W4TVW4IDbPiebHqcZpNg:22
        a=E9Po1WZjFZOl8hwRPBS3:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Masahiro

On Thu, Apr 23, 2020 at 04:39:13PM +0900, Masahiro Yamada wrote:
> 
> Several Makefiles use 'hostprogs' for building the code for
> the host architecture is not appropriate.
> 
> This is just because Kbuild does not provide the syntax to do it.
> 
> This series introduce 'userprogs' syntax and use it from
> sample and bpf Makefiles.
> 
> Sam worked on this in 2014.
> https://lkml.org/lkml/2014/7/13/154

I wonder how you managed to dig that up, but thanks for the reference.

Back then we would fail buiulding without any libc - you have solved
this nicely in this patch-set.

> 
> He used 'uapiprogs-y' but I just thought the meaning of
> "UAPI programs" is unclear.
> 
> Naming is one the most difficult parts of this.
> 
> I chose 'userprogs'.
> Anothor choice I had in my mind was 'targetprogs'.
> 
> If you can test this series quickly by
> 'make allmodconfig samples/'
> 
> When building objects for userspace, [U] is displayed.
> 
> masahiro@oscar:~/workspace/linux$ make allmodconfig samples/
>   [snip]
>   AR      samples/vfio-mdev/built-in.a
>   CC [M]  samples/vfio-mdev/mtty.o
...

> 
> 
> Masahiro Yamada (15):
>   Documentation: kbuild: fix the section title format
>   Revert "objtool: Skip samples subdirectory"
>   kbuild: add infrastructure to build userspace programs
>   net: bpfilter: use 'userprogs' syntax to build bpfilter_umh
>   samples: seccomp: build sample programs for target architecture
>   kbuild: doc: document the new syntax 'userprogs'
>   samples: uhid: build sample program for target architecture
>   samples: hidraw: build sample program for target architecture
>   samples: connector: build sample program for target architecture
>   samples: vfs: build sample programs for target architecture
>   samples: pidfd: build sample program for target architecture
>   samples: mei: build sample program for target architecture
>   samples: auxdisplay: use 'userprogs' syntax
>   samples: timers: use 'userprogs' syntax
>   samples: watchdog: use 'userprogs' syntax
Nice work!
All patches are:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> 
> Sam Ravnborg (1):
>   samples: uhid: fix warnings in uhid-example
> 
>  Documentation/kbuild/makefiles.rst | 185 +++++++++++++++++++++--------
>  Makefile                           |  11 +-
>  net/bpfilter/Makefile              |  11 +-
>  samples/Kconfig                    |  26 +++-
>  samples/Makefile                   |   5 +-
>  samples/auxdisplay/Makefile        |  11 +-
>  samples/connector/Makefile         |  12 +-
>  samples/hidraw/Makefile            |   9 +-
>  samples/mei/Makefile               |   9 +-
>  samples/pidfd/Makefile             |   8 +-
>  samples/seccomp/Makefile           |  42 +------
>  samples/timers/Makefile            |  17 +--
>  samples/uhid/.gitignore            |   2 +
>  samples/uhid/Makefile              |   9 +-
>  samples/uhid/uhid-example.c        |   4 +-
>  samples/vfs/Makefile               |  11 +-
>  samples/watchdog/Makefile          |  10 +-
>  scripts/Makefile.build             |   5 +
>  scripts/Makefile.clean             |   2 +-
>  scripts/Makefile.userprogs         |  44 +++++++
>  20 files changed, 258 insertions(+), 175 deletions(-)
>  create mode 100644 samples/uhid/.gitignore
>  create mode 100644 scripts/Makefile.userprogs
> 
> -- 
> 2.25.1
