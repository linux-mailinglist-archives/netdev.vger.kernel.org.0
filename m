Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78A21EC28C
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 21:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgFBTRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 15:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBTRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 15:17:08 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3043C08C5C0;
        Tue,  2 Jun 2020 12:17:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e9so4395969pgo.9;
        Tue, 02 Jun 2020 12:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ERk066J2kbr4z1++RmP1dJLaVwbGWGmMSnbedw3Oxy8=;
        b=GafUOppcftTmTnqBNb0uh3fbk/HTmNrhcKYxKTbaJtJ+UXG++ljmzTovkylp+KfkQt
         JjbGdripYCUbpWhYh+9yFPTc0b0NqwlbeMfSGmBj1Wlxp40BWeDyFTFVkp0kzrMp1g75
         qrd1/F31I6ZXftrylJmdp2tpLllz3ORuR1h1D/Z86ulwvzXL6naLpSJ5fvzBrd024X9h
         w/4hPpPGIBXvv3bPLuFWwDnaNDIijsbU8lJfZbCI2RejPrW25c5LNdVuhEO8tYug04O6
         2PGRheBTiCdSuSCyBuxPa1R2iYLqkdwsUQAZjPEkcdjjGXn1AtWaVjZ4dnW6RY+z+YxL
         NIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ERk066J2kbr4z1++RmP1dJLaVwbGWGmMSnbedw3Oxy8=;
        b=JltdQVircmTYNhDJ32KIS7XiftkWZFLjnAtFTHQWzKhgdBJ5zSYLdFjaS8ub1bZKW0
         qOX/eonHIxEqhBYwnbWUKa7o43uLvBKo5CMqaNthquxMtXNozPpC6ic5iWjalwq2emKx
         WWfpgm0fT8yTt8UuSKdGp3iTH9OhFHfgwlZsG2nYwc4OvPRiC/mjImQHJYInu8bIdt6h
         hB15YhamgI2uRqGWYQWBzkwRo5ukyHVvPJ7Tse+KY48BqeYS7TOvO/vfelPxYCHwEAaB
         NaAYJB3ylWO8CNtqVhm56gWVems/is8rPz6v1/qI2RhlxmLFniHNZEMlYlOXKtvQ3aPn
         O6WA==
X-Gm-Message-State: AOAM532pAuKhVMGao7h045B3ebUkm4E64taJ9q8w7LMAq53CMvCLHHUk
        NQZCXaAQPtb66m54z641v+Ia+Rln
X-Google-Smtp-Source: ABdhPJxrLBTRjhYYQ8aylnRTJsImNG9e2BYc18+Q/s66Jql+u9eFvQlIzqbvwEiZ1NKXEsFgfnkiOA==
X-Received: by 2002:a17:90b:b14:: with SMTP id bf20mr688347pjb.231.1591125427339;
        Tue, 02 Jun 2020 12:17:07 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:514a])
        by smtp.gmail.com with ESMTPSA id n2sm3137456pfd.125.2020.06.02.12.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 12:17:06 -0700 (PDT)
Date:   Tue, 2 Jun 2020 12:17:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Michael Forney <mforney@mforney.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
Message-ID: <20200602191703.xbhgy75l7cb537xe@ast-mbp.dhcp.thefacebook.com>
References: <20200303003233.3496043-1-andriin@fb.com>
 <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net>
 <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
 <87blpc4g14.fsf@toke.dk>
 <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
 <CAGw6cBuCwmbULDq2v76SWqVYL2o8i+pBg7JnDi=F+6Wcq3SDTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGw6cBuCwmbULDq2v76SWqVYL2o8i+pBg7JnDi=F+6Wcq3SDTA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 10:31:34PM -0700, Michael Forney wrote:
> Hi,
> 
> On 2020-03-04, Daniel Borkmann <daniel@iogearbox.net> wrote:
> > I was about to push the series out, but agree that there may be a risk for
> > #ifndefs
> > in the BPF C code. If we want to be on safe side, #define FOO FOO would be
> > needed.
> 
> I did indeed hit some breakage due to this change, but not for the
> anticipated reason.
> 
> The C standard requires that enumeration constants be representable as
> an int, and have type int. While it is a common extension to allow
> constants that exceed the limits of int, and this is required
> elsewhere in Linux UAPI headers, this is the first case I've
> encountered where the constant is not representable as unsigned int
> either:
> 
> 	enum {
> 		BPF_F_CTXLEN_MASK		= (0xfffffULL << 32),
> 	};
> 
> To see why this can be problematic, consider the following program:
> 
> 	#include <stdio.h>
> 	
> 	enum {
> 		A = 1,
> 		B = 0x80000000,
> 		C = 1ULL << 32,
> 	
> 		A1 = sizeof(A),
> 		B1 = sizeof(B),
> 	};
> 	
> 	enum {
> 		A2 = sizeof(A),
> 		B2 = sizeof(B),
> 	};
> 	
> 	int main(void) {
> 		printf("sizeof(A) = %d, %d\n", (int)A1, (int)A2);
> 		printf("sizeof(B) = %d, %d\n", (int)B1, (int)B2);
> 	}
> 
> You might be surprised by the output:
> 
> 	sizeof(A) = 4, 4
> 	sizeof(B) = 4, 8
> 
> This is because the type of B is different inside and outside the
> enum. In my C compiler, I have implemented the extension only for
> constants that fit in unsigned int to avoid these confusing semantics.
> 
> Since BPF_F_CTXLEN_MASK is the only offending constant, is it possible
> to restore its definition as a macro?

It's possible, but I'm not sure what it will fix.
Your example is a bit misleading, since it's talking about B
which doesn't have type specifier, whereas enums in bpf.h have ULL
suffix where necessary.
And the one you pointed out BPF_F_CTXLEN_MASK has sizeof == 8 in all cases.

Also when B is properly annotated like 0x80000000ULL it will have size 8
as well.

#include <stdio.h>

enum {
        A = 1,
        B = 0x80000000,
        C = 1ULL << 32,
        D = 0x80000000ULL,

        A1 = sizeof(A),
        B1 = sizeof(B),
        C1 = sizeof(C),
        D1 = sizeof(D),
};

enum {
        A2 = sizeof(A),
        B2 = sizeof(B),
        C2 = sizeof(C),
        D2 = sizeof(D),
};

int main(void) {
        printf("sizeof(A) = %d, %d\n", (int)A1, (int)A2);
        printf("sizeof(B) = %d, %d\n", (int)B1, (int)B2);
        printf("sizeof(C) = %d, %d\n", (int)C1, (int)C2);
        printf("sizeof(D) = %d, %d\n", (int)D1, (int)D2);
}

sizeof(A) = 4, 4
sizeof(B) = 4, 8
sizeof(C) = 8, 8
sizeof(D) = 8, 8

So the problem is only with non-annotated enums that are mixed
in a enum with some values <32bit and others >32 bit.
bpf.h has only one such enum:
enum {
        BPF_F_INDEX_MASK                = 0xffffffffULL,
        BPF_F_CURRENT_CPU               = BPF_F_INDEX_MASK,
        BPF_F_CTXLEN_MASK               = (0xfffffULL << 32),
};

and all values are annotated with ULL.
So I really don't see a problem.

> Also, I'm not sure if it was considered, but using enums also changes
> the signedness of these constants. Many of the previous macro
> expressions had type unsigned long long, and now they have type int
> (the type of the expression specifying the constant value does not
> matter). I could see this causing problems if these constants are used
> in expressions involving shifts or implicit conversions.

It would have been if the enums were not annotated. But that's not the case. 
