Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008D71B0684
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDTKZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTKZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 06:25:54 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0238DC061A0C;
        Mon, 20 Apr 2020 03:25:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p8so4830736pgi.5;
        Mon, 20 Apr 2020 03:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yypQDahjbXqJhDbVQSiASHihfGpSC0JMzsgU8Cz/AiY=;
        b=HdCWUfWuE1u+XaXD9Ms85gt4izU8DyOrmmvb1s/Jb/Vh5rKqf9BQq9h5pCmTjXXb8E
         i1UeedwF++2a3WAWjZe5irqGqtuCmn1sqTn985LVCgLRPFMufdeksavjuiSojGUipIdZ
         KuEf+TG/qxTGRCRUtJ2GKY3NIj3P93vGRM0HLck6KdcKx4DGwm+0M9vy2nIlfVF7NNsx
         sye5nxxQEOtR0dyZ/uTdz2bHo6IPo03UlAOiO7CTUc83i4baqLwa3JKWU4scp5Bb9LZB
         pg1dl1F8j76CX5u1r2aZ9/L9ZVP5bNKuWBRNtyK6n4Bidq3Wq9nle2G3W7KDxUqkhV/I
         iVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yypQDahjbXqJhDbVQSiASHihfGpSC0JMzsgU8Cz/AiY=;
        b=J/a94mo1ZdoSSAE6gC0TkDuX8Lc1jt9IUMOaIuVwAsPZXZuqGu7FVYDPDS8ZBBxkwZ
         F6zOV1wP0UbxHHP2mJ+OngHu5ojTwVz6C8au44jeYuKNppv/MuhT98lGkeCN5GgAkXal
         yjdPoYW8TC0hSKe5Y24RdL0ll68NuA+iEy/r+COiZs3SgZ3H1b1u+Dxxwd18oHpPJ4QM
         AdkZz5msh3/QbVLYHiBynaU/apzmxvV2tNXbgrbfaSmCpH71xA/q1uW2pepHcotwWDBZ
         7tSANFv7cuesU2EUWRpW5qIojQVjIeNgxqqrc7UYvvgLl7GTVQeYHXKrLcuZmqybYCNk
         uC/Q==
X-Gm-Message-State: AGi0PuZ7fNOJM0hFzBy4LKDO+qBUH2uxXXWbsuWLzsoAAF4IZxbeyHnT
        aKu7kLtCltjPkDyX7J/3kM0=
X-Google-Smtp-Source: APiQypLziiZ4XFGGVOnDb/VHoxNBse93+oqNzvsu4l35WhyBRM2f0vKvSNofiSie8P1sNgYipNPpAg==
X-Received: by 2002:a62:2a8c:: with SMTP id q134mr16642242pfq.35.1587378352530;
        Mon, 20 Apr 2020 03:25:52 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h14sm651899pjc.46.2020.04.20.03.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 03:25:51 -0700 (PDT)
Subject: Re: [PATCH 1/4] fs: Implement close-on-fork
To:     Nate Karstens <nate.karstens@garmin.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Changli Gao <xiaosuo@gmail.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <36dce9b4-a0bf-0015-f6bc-1006938545b1@gmail.com>
Date:   Mon, 20 Apr 2020 03:25:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200420071548.62112-2-nate.karstens@garmin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/20 12:15 AM, Nate Karstens wrote:
> The close-on-fork flag causes the file descriptor to be closed
> atomically in the child process before the child process returns
> from fork(). Implement this feature and provide a method to
> get/set the close-on-fork flag using fcntl(2).
> 
> This functionality was approved by the Austin Common Standards
> Revision Group for inclusion in the next revision of the POSIX
> standard (see issue 1318 in the Austin Group Defect Tracker).

Oh well... yet another feature slowing down a critical path.

> 
> Co-developed-by: Changli Gao <xiaosuo@gmail.com>
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> Signed-off-by: Nate Karstens <nate.karstens@garmin.com>
> ---
>  fs/fcntl.c                             |  2 ++
>  fs/file.c                              | 50 +++++++++++++++++++++++++-
>  include/linux/fdtable.h                |  7 ++++
>  include/linux/file.h                   |  2 ++
>  include/uapi/asm-generic/fcntl.h       |  5 +--
>  tools/include/uapi/asm-generic/fcntl.h |  5 +--
>  6 files changed, 66 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 2e4c0fa2074b..23964abf4a1a 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -335,10 +335,12 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
>  		break;
>  	case F_GETFD:
>  		err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;
> +		err |= get_close_on_fork(fd) ? FD_CLOFORK : 0;
>  		break;
>  	case F_SETFD:
>  		err = 0;
>  		set_close_on_exec(fd, arg & FD_CLOEXEC);
> +		set_close_on_fork(fd, arg & FD_CLOFORK);
>  		break;
>  	case F_GETFL:
>  		err = filp->f_flags;
> diff --git a/fs/file.c b/fs/file.c
> index c8a4e4c86e55..de7260ba718d 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -57,6 +57,8 @@ static void copy_fd_bitmaps(struct fdtable *nfdt, struct fdtable *ofdt,
>  	memset((char *)nfdt->open_fds + cpy, 0, set);
>  	memcpy(nfdt->close_on_exec, ofdt->close_on_exec, cpy);
>  	memset((char *)nfdt->close_on_exec + cpy, 0, set);
> +	memcpy(nfdt->close_on_fork, ofdt->close_on_fork, cpy);
> +	memset((char *)nfdt->close_on_fork + cpy, 0, set);
>  

I suggest we group the two bits of a file (close_on_exec, close_on_fork) together,
so that we do not have to dirty two separate cache lines.

Otherwise we will add yet another cache line miss at every file opening/closing for processes
with big file tables.

Ie having a _single_ bitmap array, even bit for close_on_exec, odd bit for close_on_fork

static inline void __set_close_on_exec(unsigned int fd, struct fdtable *fdt)
{
	__set_bit(fd * 2, fdt->close_on_fork_exec);
}

static inline void __set_close_on_fork(unsigned int fd, struct fdtable *fdt)
{
	__set_bit(fd * 2 + 1, fdt->close_on_fork_exec);
}

Also the F_GETFD/F_SETFD implementation must use a single function call,
to not acquire the spinlock twice.


