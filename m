Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4121C7567
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgEFPxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:53:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35179 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729724AbgEFPxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588780433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IIPWhemhWOivhkyMoHAaTDjhY+Cd4+/PKB7r/lBHTsk=;
        b=U/6zCOMfNOeW4VavTUCyedfZ641XjR9HC1ya7kyJLUzYkEpqI/5aBC3rnK5Aufh36JoAuk
        c8xhVe32an5F5VTMbNKa9SchMBqtdiC0s5BAATs2KbBxid60r2xxI5guL4DTVrgWLauYqy
        qev3312VHSLGRQuNEJ93bK89mi4W2l4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-lZeX6d8kP4GU7xA9uNEoKg-1; Wed, 06 May 2020 11:53:49 -0400
X-MC-Unique: lZeX6d8kP4GU7xA9uNEoKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42FE145F;
        Wed,  6 May 2020 15:53:47 +0000 (UTC)
Received: from treble (ovpn-115-96.rdu2.redhat.com [10.10.115.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1D605D9C5;
        Wed,  6 May 2020 15:53:45 +0000 (UTC)
Date:   Wed, 6 May 2020 10:53:43 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200506155343.7x3slq3uasponb6w@treble>
References: <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
 <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble>
 <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <20200505181108.hwcqanvw3qf5qyxk@treble>
 <20200505195320.lyphpnprn3sjijf6@ast-mbp.dhcp.thefacebook.com>
 <20200505202823.zkmq6t55fxspqazk@treble>
 <20200505235939.utnmzqsn22cec643@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200505235939.utnmzqsn22cec643@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 04:59:39PM -0700, Alexei Starovoitov wrote:
> As far as workaround I prefer the following:
> From 94bbc27c5a70d78846a5cb675df4cf8732883564 Mon Sep 17 00:00:00 2001
> From: Alexei Starovoitov <ast@kernel.org>
> Date: Tue, 5 May 2020 16:52:41 -0700
> Subject: [PATCH] bpf,objtool: tweak interpreter compilation flags to help objtool
> 
> tbd
> 
> Fixes: 3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/compiler-gcc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index d7ee4c6bad48..05104c3cc033 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -171,4 +171,4 @@
>  #define __diag_GCC_8(s)
>  #endif
> 
> -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> +#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> --
> 2.23.0
> 
> I've tested it with gcc 8,9,10 and clang 11 with FP=y and with ORC=y.
> All works.
> I think it's safer to go with frame pointers even for ORC=y considering
> all the pain this issue had caused. Even if objtool gets confused again
> in the future __bpf_prog_run() will have frame pointers and kernel stack
> unwinding can fall back from ORC to FP for that frame.
> wdyt?

It seems dangerous to me.  The GCC manual recommends against it.

And how do we know what other flags are getting removed for various
arches (now or in the future)?

-- 
Josh

