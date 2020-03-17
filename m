Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63AF18767B
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 01:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732994AbgCQABi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 20:01:38 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43299 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732932AbgCQABh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 20:01:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id c144so10848887pfb.10
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 17:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VdSp5SmhE7XqZw+dnWWnNJFiQVXpqITbQV0ebAQiP7I=;
        b=BoyKGv7Igni30S/FCKVFiurpLK2iu4pmjMNZdA8xDib0LQwhisvj8E2N+zwspH/lll
         fPQgsE2ZY3hxsXQ9LswLTCzrXUGK98rY7/38OdVWgRIiM/7OH/59Z31XuCq8ALRl9hkV
         l0o/SLFIvA32YMjZo26+7eB6RxUjtFSipZI0GRA5/Y9fKFOO7I6SNJwUgnbOn+p2Xw74
         rsmG+NiZS0ZaKaI9xFRxzzXjOYk24/UqbUPb/Rf+dXebS8HzUkwqN8+5cFQ1+Lc4URv5
         Bq+p5bA/ps3IfjtBqFrad7CVQ9NL7UruWI+/DtX9jHsEdbuHR+QajVwaS2RlKO+kUPLh
         aUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VdSp5SmhE7XqZw+dnWWnNJFiQVXpqITbQV0ebAQiP7I=;
        b=WdB4BmoMLSbYsKU1sPg+49M2grwiU3FD6CaZjuPiTd9sip2aODiFmDxPNo1gUeu39h
         drxNIK2uHox/+UkkirQ/p8qTZOgbUWySWf5TykguFTZ48gZcmBtOq65insXT0dZJR0kS
         NG4Es8uIY+Te9848agF2bQwDGQJ1OYV/ksFgVaTu729mWVWTuoPt2V/Y3mJTrfw9esB/
         K24MYyVwVSoYtAUrOJ8gmPnPipDRjACuO2757byfiFC87GZdeEwekHsUflrYW0cu/CUd
         70/Zvs5RNTdMhS/zw3XPJsUPwsCvkLu3Rm8TXdKXtMU1v5cN8/BtifuInW/FWzRNmnDt
         xPpQ==
X-Gm-Message-State: ANhLgQ0tMg0zjJDXUOBpPrhLWXvy/nck0eXqvdDHGXS6tCObYXz/qJ0c
        f+LA2VM2o/CIOVjaEJwFmyF5hA==
X-Google-Smtp-Source: ADFU+vvx2rWuTfSay06flokPDiVFR1lQKgnX07KLrwgMFkYXDfZPdu1+py7ifawFmMPEfx2AY/Erkg==
X-Received: by 2002:aa7:848b:: with SMTP id u11mr2189605pfn.76.1584403296885;
        Mon, 16 Mar 2020 17:01:36 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id e187sm958824pfe.50.2020.03.16.17.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 17:01:36 -0700 (PDT)
Date:   Mon, 16 Mar 2020 17:01:35 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH bpf] bpf: Support llvm-objcopy for vmlinux BTF
Message-ID: <20200317000135.GD2179110@mini-arch.hsd1.ca.comcast.net>
References: <20200316222518.191601-1-sdf@google.com>
 <20200316235725.GA43392@ubuntu-m2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316235725.GA43392@ubuntu-m2-xlarge-x86>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/16, Nathan Chancellor wrote:
> On Mon, Mar 16, 2020 at 03:25:18PM -0700, Stanislav Fomichev wrote:
> > Commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux
> > BTF") switched from --dump-section to
> > --only-section/--change-section-address for BTF export assuming
> > those ("legacy") options should cover all objcopy versions.
> > 
> > Turns out llvm-objcopy doesn't implement --change-section-address [1],
> > but it does support --dump-section. Let's partially roll back and
> > try to use --dump-section first and fall back to
> > --only-section/--change-section-address for the older binutils.
> > 
> > 1. https://bugs.llvm.org/show_bug.cgi?id=45217
> > 
> > Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/871
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  scripts/link-vmlinux.sh | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index dd484e92752e..8ddf57cbc439 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -127,6 +127,16 @@ gen_btf()
> >  		cut -d, -f1 | cut -d' ' -f2)
> >  	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> >  		awk '{print $4}')
> > +
> > +	# Compatibility issues:
> > +	# - pre-2.25 binutils objcopy doesn't support --dump-section
> > +	# - llvm-objcopy doesn't support --change-section-address, but
> > +	#   does support --dump-section
> > +	#
> > +	# Try to use --dump-section which should cover both recent
> > +	# binutils and llvm-objcopy and fall back to --only-section
> > +	# for pre-2.25 binutils.
> > +	${OBJCOPY} --dump-section .BTF=$bin_file ${1} 2>/dev/null || \
> >  	${OBJCOPY} --change-section-address .BTF=0 \
> >  		--set-section-flags .BTF=alloc -O binary \
> >  		--only-section=.BTF ${1} .btf.vmlinux.bin
> > -- 
> > 2.25.1.481.gfbce0eb801-goog
> > 
> 
> Hi Stanislav,
> 
> Thank you for the patch! This is targeting the bpf tree but it uses the
> bin_file variable that comes from commit af73d78bd384 ("kbuild: Remove
> debug info from kallsyms linking") in the bpf-next tree. In this form,
> when applied to mainline, the first command fails because $bin_file
> doesn't exist and falls back to the second command, which results in no
> net change for llvm-objcopy.
> 
> When manually applied to next-20200316 or applied to mainline with
> $bin_file replaced with .btf.vmlinux.bin, x86_64 and aarch64 successfully
>  generate BTF with tip of tree llvm-objcopy.
> 
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Oops, sorry, I did it on top of bpf-next, but then blindly cherry-picked
on top of bpf tree. In this case, should we put in only in bpf-next?
Do we need a stable backport for the older versions?
