Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE971EB54D
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgFBFbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBFbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 01:31:37 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB47C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 22:31:37 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h4so6249300iob.10
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 22:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mforney-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=T4o7JQzfrNq8g506DM2CjZrMkPTAiudDI9kXxj57o5w=;
        b=sewehkqVaaIYvJ1hCHPYZDK6w1u746F+mhXstgHVIdw70deqJa8YLG3Waq/RlEOYCQ
         1PVfrXl0Tn+SagdDEoQBukL4GwD7j9X8UJi6lbxvYhjMwYrQhVwlD2sBuzH4jyPxvHba
         Kx1Zg/hHUTbAk7OOjrLoBb3k8/vYBTc1gMdEK7xWroccD0PUsC+RSv6a5kpTxAUyFa6L
         5TPCCCGm7iRHRcvpNbaTqGxLxpQ+kBkQjRM7AHpSL40Z1XDyi/nVSgOB0VIIgxfvwyEX
         L3W4o+EbQWRprg70WbYz63CjJz382hox1L1Ngaf018NeuFdHVRXAbeuIi9pCVp6vMXJZ
         cMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=T4o7JQzfrNq8g506DM2CjZrMkPTAiudDI9kXxj57o5w=;
        b=TQqBV5ZIgTtl5CA9gg5FX9q7CW1G/o0owT9IVlwrnqGRG/zM3ROfMuNBqaIT0AQHUH
         v1BvTnR4FbfRB9FXYPOAUckWmPzrjfMXCDZWzjqzwe777FUDc7PPl7Sgr38cDgshUhWd
         wY6+EhLaVpjqgnw9rSa/LzmWp5M40wRLczickAF8LraXmfgEEMP45dBOup6UJGKF5zD6
         vpo7OxRXvi2A/2SkcCfnz7SF1TJIKyg3IOdw3OL8Ed62OEvGGMeQ1iszJJZOLkQ+50/n
         OgUsZZpxHsj9WL9eeZSmrSmLxHLUYTXTol7zQKuCkXt68LOsoIWnqxxS7UZrFjRo6U9K
         Cbug==
X-Gm-Message-State: AOAM531+N1EzxaSuT44F9FoDJDr0X5Qk+HsTTrKx4Yzd/QwGsmQU95fN
        cp1JMoXScss2NVHNE1u1VopVq5AdsYJtu84jXXS16SI4iFc=
X-Google-Smtp-Source: ABdhPJzFqvhcbxOA8g1039MDFa3LEyPLLRJNx+K5nL09YinYKNk+7s5y9w+eSsFhq60i6aaqzu4BC25Oh6FGdpvB8Pg=
X-Received: by 2002:a02:6c8f:: with SMTP id w137mr24710725jab.38.1591075895419;
 Mon, 01 Jun 2020 22:31:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6638:150:0:0:0:0 with HTTP; Mon, 1 Jun 2020 22:31:34
 -0700 (PDT)
X-Originating-IP: [73.70.188.119]
In-Reply-To: <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
References: <20200303003233.3496043-1-andriin@fb.com> <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net> <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
 <87blpc4g14.fsf@toke.dk> <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
From:   Michael Forney <mforney@mforney.org>
Date:   Mon, 1 Jun 2020 22:31:34 -0700
Message-ID: <CAGw6cBuCwmbULDq2v76SWqVYL2o8i+pBg7JnDi=F+6Wcq3SDTA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2020-03-04, Daniel Borkmann <daniel@iogearbox.net> wrote:
> I was about to push the series out, but agree that there may be a risk for
> #ifndefs
> in the BPF C code. If we want to be on safe side, #define FOO FOO would be
> needed.

I did indeed hit some breakage due to this change, but not for the
anticipated reason.

The C standard requires that enumeration constants be representable as
an int, and have type int. While it is a common extension to allow
constants that exceed the limits of int, and this is required
elsewhere in Linux UAPI headers, this is the first case I've
encountered where the constant is not representable as unsigned int
either:

	enum {
		BPF_F_CTXLEN_MASK		= (0xfffffULL << 32),
	};

To see why this can be problematic, consider the following program:

	#include <stdio.h>
	
	enum {
		A = 1,
		B = 0x80000000,
		C = 1ULL << 32,
	
		A1 = sizeof(A),
		B1 = sizeof(B),
	};
	
	enum {
		A2 = sizeof(A),
		B2 = sizeof(B),
	};
	
	int main(void) {
		printf("sizeof(A) = %d, %d\n", (int)A1, (int)A2);
		printf("sizeof(B) = %d, %d\n", (int)B1, (int)B2);
	}

You might be surprised by the output:

	sizeof(A) = 4, 4
	sizeof(B) = 4, 8

This is because the type of B is different inside and outside the
enum. In my C compiler, I have implemented the extension only for
constants that fit in unsigned int to avoid these confusing semantics.

Since BPF_F_CTXLEN_MASK is the only offending constant, is it possible
to restore its definition as a macro?

Also, I'm not sure if it was considered, but using enums also changes
the signedness of these constants. Many of the previous macro
expressions had type unsigned long long, and now they have type int
(the type of the expression specifying the constant value does not
matter). I could see this causing problems if these constants are used
in expressions involving shifts or implicit conversions.

Thanks for your time,

-Michael
