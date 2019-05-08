Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85781828E
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 01:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfEHXJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 19:09:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42876 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbfEHXJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 19:09:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id 145so141025pgg.9;
        Wed, 08 May 2019 16:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RDwzXQQnVDWTDb2YFzPQmIWZ8cdJid91E6t4A4DL6uw=;
        b=SIKxP3zdIRNGdfA9n9jawuuQwPpjGyglfCv+JB9Z2/RkkFujQtX+3PRetO2n6ykFFb
         f4jqC8qStWdJ7E+EePuRjrkBKWXIx2CnEA6/OV7pLimV+/Gy5rnbI9Twivsed8ihlaCQ
         sc7VE+ZIza7y+4DDXc8a9LUuKra8GAc2EreafpyST1LBFiVAxY0DVfL0LjgRn3L52yNc
         v4Q9b4G5Nqr5QkZZIlCdYjb2i+WXPdsXpeHFVuAPH5sL83rI+VWpic2vSzCpFbpMo4NM
         8PcR+RxMZ+R6aD0vlxBTAL/o9jnoiKj7sxb71oirHuFfHzgKGePl5CGPAi0ooTmoiQXi
         1aWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RDwzXQQnVDWTDb2YFzPQmIWZ8cdJid91E6t4A4DL6uw=;
        b=Gl4IJgsGC46rWY5qfYY1LSolO9Lu9y/W0loLhxSz1/XBj9nKi+KdIk7a2yqIl0hQ4X
         VOGpwaCCcg6Ld4sySkY6wveM4zbAJsST3h2lqPQMBpuGSML5UpPY5wq4mUHlx8a9iYlp
         elPi7XracQPlzrtr2DqQ8uUWgsrZESYK/vSn7sn7C/iCE0SG5ZjNRdumvxVq9x47KtgA
         MpMneYEjaQZa9fdBYXGczZIzk6eRxN8oX+t/Hgp2G882lxbRJGYKb0D/EWos84PmYw3n
         NirQe3eFlWTthIStrShZRL0BKr9lJWrYpIq0S7JlqKhiY4qlyJh+Ruz75JigKu9mQDiv
         7FZA==
X-Gm-Message-State: APjAAAV1jEMud5GAe0WO8+skUXmq0zU3dC4YiJ6V9xqWy4pWBwY2MVRc
        jhqsiJXIBYUoUqWak4+W4DA=
X-Google-Smtp-Source: APXvYqz50hlcDAplG0HxHH8o/bhNnozfCSXXJdwIOyhVKEAIYd4dgLCZb1hisyrGyu8jno3EgrHyOw==
X-Received: by 2002:a63:e52:: with SMTP id 18mr984879pgo.3.1557356985878;
        Wed, 08 May 2019 16:09:45 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::f5a7])
        by smtp.gmail.com with ESMTPSA id h6sm411641pfk.188.2019.05.08.16.09.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 16:09:45 -0700 (PDT)
Date:   Wed, 8 May 2019 16:09:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Subject: Re: Question about seccomp / bpf
Message-ID: <20190508230941.6rqccgijqzkxmz4t@ast-mbp>
References: <CANn89iL_XLb5C-+DY5PRhneZDJv585xfbLtiEVc3-ejzNNXaVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL_XLb5C-+DY5PRhneZDJv585xfbLtiEVc3-ejzNNXaVg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 02:21:52PM -0700, Eric Dumazet wrote:
> Hi Alexei and Daniel
> 
> I have a question about seccomp.
> 
> It seems that after this patch, seccomp no longer needs a helper
> (seccomp_bpf_load())
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bd4cf0ed331a275e9bf5a49e6d0fd55dffc551b8
> 
> Are we detecting that a particular JIT code needs to call at least one
> function from the kernel at all ?

Currently we don't track such things and trying very hard to avoid
any special cases for classic vs extended.

> If the filter contains self-contained code (no call, just inline
> code), then we could use any room in whole vmalloc space,
> not only from the modules (which is something like 2GB total on x86_64)

I believe there was an effort to make bpf progs and other executable things
to be everywhere too, but I lost the track of it.
It's not that hard to tweak x64 jit to emit 64-bit calls to helpers
when delta between call insn and a helper is more than 32-bit that fits
into call insn. iirc there was even such patch floating around.

but what motivated you question? do you see 2GB space being full?!

