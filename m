Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9B17F58
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 19:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfEHRvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 13:51:17 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44161 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfEHRvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 13:51:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id g9so733457pfo.11;
        Wed, 08 May 2019 10:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mU0jCr2GPi1b5hbzLUx4Twx7GHJo/Q+lsHVdxoN16WQ=;
        b=DSVxsfCoTYlsJiHyH+9Kv4UMbRKGb59U4V+42afB2Ua1B2m1PccT8qdY6QSNXFTH+D
         ms6d5fJqJTSYDrKENn41Uaq3E1SHvNQSzmWMbRc+++i8waeoUkSIg8X0jUY6Vtoe23WX
         HhejBRgikCGmXv49MNTI1zHcJb87AxpsdpwRxQEsF9eTug1eUYRkxlbJde++glevtiM4
         8EtDeuQRUAWlNp9PGNA9vywSWF3Bq1UavwrrIPnL1H/o+CIc9YMGgJ0kuWOJ3lzzWFeR
         QMqMc5UA6P5qcBE3pbNH/DsKgsveesTaZaLMGk173OabSSRUS84l9i2mTt1jTE7u0cp1
         GpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mU0jCr2GPi1b5hbzLUx4Twx7GHJo/Q+lsHVdxoN16WQ=;
        b=RE3gQ5S0E/I02m9Fa8IfhmEll/gc5n7LGokyFXsDS98cogbtOreRlgyhOd8rd4mpYS
         /tkNWoXLfXaXs9a716aO9vJggR684+OwEeUpVFcj4bGzmnj9sMvKiJJm2Fwa/3cP8fy8
         hHGd2skyGTmTj7z5AFb1OlqfkHPr/K6sNLz2pdK+HWexUxkZdTM5geb3kmuob7Kzib7B
         hMqREeAqU4bSUvKfpXlo27BWsvd0fCxG+w4lrofvUo98GfaA1orp/lOsGXJRLMUljdVF
         ASTWr0c/e7ZB8HuKB0c8NJHPS8Bg0Mxyzq+a2C727L92BBLyFFrRgZJT03PoYmcavBzX
         5pgA==
X-Gm-Message-State: APjAAAWsN7Q2kZmZ5ejdshYB+2XfMwX21YUNIjyGaXJMzVGAJB+GcZlY
        4jKpYLHdLgGXEJ+BmcNy9E4=
X-Google-Smtp-Source: APXvYqywnMrTGy+V5HxpsShneQGGiggrBPbQibmHxh5kYafR4eYcMMhoReTslDBhJWDH6xWD9RZIJQ==
X-Received: by 2002:a63:6ac3:: with SMTP id f186mr48202908pgc.326.1557337876471;
        Wed, 08 May 2019 10:51:16 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::cecc])
        by smtp.gmail.com with ESMTPSA id j184sm710557pge.83.2019.05.08.10.51.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 10:51:15 -0700 (PDT)
Date:   Wed, 8 May 2019 10:51:13 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate
 helper function arg and return type
Message-ID: <20190508175111.hcbufw22mbksbpca@ast-mbp>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
 <1556880164-10689-2-git-send-email-jiong.wang@netronome.com>
 <20190506155041.ofxsvozqza6xrjep@ast-mbp>
 <87mujx6m4n.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mujx6m4n.fsf@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 03:45:12PM +0100, Jiong Wang wrote:
> 
> I might be misunderstanding your points, please just shout if I am wrong.
> 
> Suppose the following BPF code:
> 
>   unsigned helper(unsigned long long, unsigned long long);
>   unsigned long long test(unsigned *a, unsigned int c)
>   {
>     unsigned int b = *a;
>     c += 10;
>     return helper(b, c);
>   }
> 
> We get the following instruction sequence by latest llvm
> (-O2 -mattr=+alu32 -mcpu=v3)
> 
>   test:
>     1: w1 = *(u32 *)(r1 + 0)
>     2: w2 += 10
>     3: call helper
>     4: exit
> 
> Argument Types
> ===
> Now instruction 1 and 2 are sub-register defines, and instruction 3, the
> call, use them implicitly.
> 
> Without the introduction of the new ARG_CONST_SIZE32 and
> ARG_CONST_SIZE32_OR_ZERO, we don't know what should be done with w1 and
> w2, zero-extend them should be fine for all cases, but could resulting in a
> few unnecessary zero-extension inserted.

I don't think we're on the same page.
The argument type is _const_.
In the example above they are not _const_.

> 
> And that why I introduce these new argument types, without them, there
> could be more than 10% extra zext inserted on benchmarks like bpf_lxc.

10% extra ? so be it.
We're talking past each other here.
I agree with your optimization goal, but I think you're missing
the safety concerns I'm trying to explain.

> 
> But for helper functions, they are done by native code which may not follow
> this convention. For example, on arm32, calling helper functions are just
> jump to and execute native code. And if the helper returns u32, it just set
> r0, no clearing of r1 which is the high 32-bit in the register pair
> modeling eBPF R0.

it's arm32 bug then. All helpers _must_ return 64-bit back to bpf prog
and _must_ accept 64-bit from bpf prog.

