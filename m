Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533AF10476C
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 01:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUASU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 19:18:20 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:43184 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfKUASU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 19:18:20 -0500
Received: by mail-pj1-f67.google.com with SMTP id a10so582160pju.10;
        Wed, 20 Nov 2019 16:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q65laBuYdJWvTVk53HpqiScmboCGkwX/f4b20vWYhQE=;
        b=kBI9PxBEvKtv6pVRxz8DkT5sSjqXsz8tQmmGEf9CFdr027PtuTrxD7WhT9LTu5t0Ja
         72W+6wWAktMxi2VHcywB3IRQprKqPB9loFcoMjw0rwL96X7aMDHJMq0QHdbEGouvC4w/
         DK6mavi78MYLrYVwY2iSbbFlXBdy8kWs6vHjj1EKJJ6SX6UPsYsN4NtYMIiFffMIuHpA
         E5h7euz1wpaRv6JZEgNLXfZsjV8RywfO2XcsDrSpY6oWPkNd8wj7knlvFERqTYiImobo
         leqHPnZQZwor1G5QD8QetZliXkqUqjefVKoMu4yos6aK7AfZXXsHdMgbHg+LAWnrrtWG
         9iQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q65laBuYdJWvTVk53HpqiScmboCGkwX/f4b20vWYhQE=;
        b=cBaGAW6xaE5Kf8if/7KTX8Bo+6cJRmi9ZIPbeGHCKoatvl9gwGkqzNiKB9iPdPpB9e
         EfYX9LLPgezPYUoYNMKhAGFU27hzIcyae+ohZzw1W0mly0KsrZFPNHvBMPDcqFmKGsoF
         xyf70IhsIx9aOu0R+hAS5MxPCmCuUJdEGesBS0KFH5n0TGzlWCbyvB+ipwlaETiYhO82
         nEzen3G1892xs4gV3l8ds0UnJXfXEk2Z7z5u5ax020qo+VzIDoL7+jU12LA8efhE7N36
         RYQ1tvPBsOcStZrg6FNIbDgmKUWlDFyH7CPlVu8YIhO/qKQ8wI/fa9w9VerfdBxM9+jF
         73+A==
X-Gm-Message-State: APjAAAV+nESq4gQLbg3oIL78Ao/AMteokfwv8cA+ijvSKVFHezVymwwQ
        HuMWwGzU4OrwEe+sc9NW6bQ=
X-Google-Smtp-Source: APXvYqwX7aTnAehgqZCSk/f4+z9Kck2FOBVp4uerkHFeeXzEobo9uJjcIZ+SDqioicaEA8DAM0oENw==
X-Received: by 2002:a17:90a:ead5:: with SMTP id ev21mr7528948pjb.76.1574295498387;
        Wed, 20 Nov 2019 16:18:18 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::d7b8])
        by smtp.gmail.com with ESMTPSA id t1sm549540pfq.156.2019.11.20.16.18.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 16:18:17 -0800 (PST)
Date:   Wed, 20 Nov 2019 16:18:13 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern
 variables
Message-ID: <20191121001811.eyksi2acyhvy4skr@ast-mbp.dhcp.thefacebook.com>
References: <20191117070807.251360-1-andriin@fb.com>
 <20191117070807.251360-6-andriin@fb.com>
 <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaNEU_vpa98QF1Ko_AFVX=3ncykEtWy0kiTNW9agsO+xg@mail.gmail.com>
 <CAEf4Bza1T6h+MWadVjuCrPCY7pkyK9kw-fPdaRx2v3yzSsmcbg@mail.gmail.com>
 <7012feeb-c1e8-1228-c8ce-464ea252799c@fb.com>
 <CAEf4BzaW4-XTxZTt2ZLvzuc2UsmmPa3Bkoej7B0pUJWcM--eVQ@mail.gmail.com>
 <11d4fde2-6cf5-72eb-9c04-b424f7314672@fb.com>
 <CAEf4BzakAJ5dEF35+g7RBgieXfVzjKQHm_Dej-9f_K_qXNuG2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzakAJ5dEF35+g7RBgieXfVzjKQHm_Dej-9f_K_qXNuG2Q@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 02:47:58PM -0800, Andrii Nakryiko wrote:
> 
> Given all this, I think realistically we can pick few combinations:
> 
> 1. Only support int/hex as uint64_t. Anything y/n/m or a string will
> fail in runtime.
> Pros:
>   - we get at least something to use in practice (LINUX_KERNEL_VERSION
> and int CONFIG_XXXs).
> Cons:
>   - undefined weak extern will have to be assumed either uint64_t 0
> (and succeed) or undefined string (and fail). No clearly best behavior
> here.

what that uint64 going to be when config_ is defined?
If your answer is 1 than it's not extensible.

>   - no ability to do "feature detection" logic in BPF program.
> 2. Stick to uint64_t for bool/tristate/int/hex. Don't support strings
> yet. Improve in backwards compatible way once we get BTF type info for
> externs (adding strings at that time).
> Pros:
>   - well-defined and logical behavior
>   - easily extensible once we get BTF for externs. No new flags, no
> changes in behavior.

extensible with new flag == not extensible.
The choices for bpf program that we pick for extern must keep working
when llvm starts generating BTF for externs.

> My preferences would be 2, if not, then 1.

I'm proposing something else.
I see libbpf as a tool to pass /boot/config.gz into bpf program. From program
pov CONFIG_FOO is a label. It's not a variable of type u8 or type u64.
Example:
CONFIG_A=100
CONFIG_B=y
CONFIG_C="abcd"
will be a map of one element with value:
char ar[]= { 0x64, 0, 0, 0, 'y', 'a', 'b', 'c', 'd', 0};

CONFIG_A = &ar[0];
CONFIG_B = &ar[4];
CONFIG_C = &ar[5];

libbpf parses config.gz and converts all int/hex into 4 byte or 8 byte
integers depending on number of text digits it sees in config.gz
with alignment. All other strings and characters are passed as-is.
If program says
extern u8 CONFIG_A, CONFIG_B, CONFIG_C;
It will read 1st byte from these three labels.
Later when llvm emits BTF those u8 swill stay as-is and will read the same
things. With BTF if program says 'extern _Bool CONFIG_B;' then it will be an
explicit direction for libbpf to convert that CONFIG_B value into _Bool at
program load time and represent it as sizeof(_Bool) in map element. If program
says 'extern uint32_t CONFIG_C;' the libbpf will keep first 4 bytes of that
string in there. If program says 'extern uint64_t CONFIG_C;' the libbpf will
keep first 4 character plus one byte for zero plus 3 bytes of padding in map
element.
'extern char CONFIG_C[5];' is also ok. Either with or without BTF.
In both cases it will be 5 bytes in map element.
Without BTF doing 'extern char *CONFIG_C;' will read garbage 8 bytes from that
label. With BTF 'extern char *CONFIG_C;' will be converted to pointer to inner
bytes of map element.
In other words BTF types will be directives of how libbpf should convert
strings in text file to be consumed by bpf program. Since we don't have types
now int/hex are the only ones that libbpf will convert unconditionally. The
logic of parsing config.gz is generic. It can parse any file with 'var=value'
lines this way. All names will be preserved.
In that sense LINUX_KERNEL_VERSION is a text file that has one line:
LINUX_KERNEL_VESRION=1234
If digits fit into u32 it should be u32.
This way users can feed any configuration.txt file into libbpf and into their
programs. Without BTF the map element is a collection of raw bytes and the
program needs to be smart about reading them with correct sizes. With BTF
libbpf will be converting .txt into requested types and failing to load
if libbpf cannot convert string from text into requested type.
