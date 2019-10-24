Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C341BE2B41
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 09:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408676AbfJXHkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 03:40:52 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36520 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408661AbfJXHkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 03:40:51 -0400
Received: by mail-lj1-f196.google.com with SMTP id v24so23908144ljj.3
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 00:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JPxiGhM5jRhlwHtnCIN5tDoQSbhFV2F/bKlTq8On7Yc=;
        b=i5fxJt9a5fJOI692aJw6RO8RT1YxLreAKshwhvfWPpsOcbT8uSjszOVeisgIr3beAI
         DFsiED5apInER6smWDbxyzhOy/DlKj8zdp5QvGS4mJC+wu8Rv/1U1pZDcWsT6Hvf2M8+
         w4nM52/7O9ZTWt55RCipUjyyXdlOWUptgTYHs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JPxiGhM5jRhlwHtnCIN5tDoQSbhFV2F/bKlTq8On7Yc=;
        b=G+5yZQRp6tt5TrPYbUHCKnC4WuHixCmExFM1CmnIWm87p4F8IC9jeztMkDH8YomPx5
         zpsf8JX8dtOgBPSnD6ctUWSd7dpovVkDXBz9xXb+8RnHMOx/scUfPK7S2S1BUbEvVekv
         qHSSfA2M2wuOVmJLe9BEYkzhTjXsfoh+1VXplXkw0u8EJ6HppL+faw9P7PYg9Dxm8w9M
         cIRuKfUp7tiiiaagJmBfv2kqU86CBTR+R+5quNwf0P+3X8ER4ryFgU5NHdGZA7ICKN9A
         9k+KfFM7HZ3rKl/SaishEwJNC+2UZ8ph+ELCgP9NcCcCy6QBVGDtJWxkCwr+LUa1ZvDv
         zlJg==
X-Gm-Message-State: APjAAAV55pf2IW9YWv+t11XMacWjfiEcqMvKE9bqlPBIKJUK680go01M
        hB6mRz3MJEsPlXsh54rfD/StAQ==
X-Google-Smtp-Source: APXvYqxX7Ws0oMg6WWgYA8lKqNAh68XyMJ4+E23AKZSb5ZI1mB2xMPsqfoKbR82T9sdrg7zZ36zRSg==
X-Received: by 2002:a2e:b0d8:: with SMTP id g24mr22382743ljl.159.1571902846813;
        Thu, 24 Oct 2019 00:40:46 -0700 (PDT)
Received: from [172.16.11.28] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id m6sm10356184ljj.3.2019.10.24.00.40.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 00:40:46 -0700 (PDT)
Subject: Re: [PATCH v4] string-choice: add yesno(), onoff(),
 enableddisabled(), plural() helpers
To:     Andrew Morton <akpm@linux-foundation.org>,
        Jani Nikula <jani.nikula@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
References: <20191023131308.9420-1-jani.nikula@intel.com>
 <20191023155619.43e0013f0c8c673a5c508c1e@linux-foundation.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <18589470-c428-f4c8-6e3e-c8cfed3ad6e0@rasmusvillemoes.dk>
Date:   Thu, 24 Oct 2019 09:40:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191023155619.43e0013f0c8c673a5c508c1e@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/10/2019 00.56, Andrew Morton wrote:
> On Wed, 23 Oct 2019 16:13:08 +0300 Jani Nikula <jani.nikula@intel.com> wrote:
> 
>> +
>> +static inline const char *yesno(bool v)
>> +{
>> +	return v ? "yes" : "no";
>> +}
>> +
>> +static inline const char *onoff(bool v)
>> +{
>> +	return v ? "on" : "off";
>> +}
>> +
>> +static inline const char *enableddisabled(bool v)
>> +{
>> +	return v ? "enabled" : "disabled";
>> +}
>> +
>> +static inline const char *plural(long v)
>> +{
>> +	return v == 1 ? "" : "s";
>> +}
>> +
>> +#endif /* __STRING_CHOICE_H__ */
> 
> These aren't very good function names.  Better to create a kernel-style
> namespace such as "choice_" and then add the expected underscores:
> 
> choice_yes_no()
> choice_enabled_disabled()
> choice_plural()

I think I prefer the short names (no choice_ prefix), it's rather
obvious what they do. I also asked for underscores, especially for the
enableddisabled case, but Jani didn't want to change existing callers.
But I'll keep out of the naming discussion from now on.
> Also, I worry that making these functions inline means that each .o
> file will contain its own copy of the strings 

They will, in .rodata.str1.1

("yes", "no", "enabled",
> etc) if the .c file calls the relevant helper.  I'm not sure if the
> linker is smart enough (yet) to fix this up. 

AFAIK, that's an optimization the linker has done forever - the whole
reason the SHF_MERGE | SHF_STRINGS (the MS in readelf -S output) flags
exist (and AFAICT they have been part of the ELF spec since forever) is
so the linker can do that trick. So no, do not make them ool.

> And doing this will cause additional savings: calling a single-arg
> out-of-line function generates less .text than calling yesno().  When I
> did this: 
> 
> --- a/include/linux/string-choice.h~string-choice-add-yesno-onoff-enableddisabled-plural-helpers-fix
> +++ a/include/linux/string-choice.h
> @@ -8,10 +8,7 @@
>  
>  #include <linux/types.h>
>  
> -static inline const char *yesno(bool v)
> -{
> -	return v ? "yes" : "no";
> -}
> +const char *yesno(bool v);
>  
>  static inline const char *onoff(bool v)
>  {
> 
> The text segment of drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.o
> (78 callsites) shrunk by 118 bytes.
> 

Interesting, and not at all what I see. Mind dumping rss_config_show
before/after? Even better, cxgb4_debugfs.s before/after. Here's what I get:

static inline yesno:

     cbb:       49 c7 c4 00 00 00 00    mov    $0x0,%r12        cbe:
R_X86_64_32S       .rodata.str1.1+0x197
     cc2:       44 89 ea                mov    %r13d,%edx
     cc5:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi        cc8:
R_X86_64_32S       .rodata.str1.1+0x1b7
     ccc:       48 c7 c5 00 00 00 00    mov    $0x0,%rbp        ccf:
R_X86_64_32S       .rodata.str1.1+0x19b

Load "yes" into %12 and "no" into %rbp (or vice versa).

     cd3:       4d 89 e7                mov    %r12,%r15
     cd6:       e8 00 00 00 00          callq  cdb
<rss_config_show+0x3b>       cd7: R_X86_64_PC32      seq_printf-0x4
     cdb:       45 85 ed                test   %r13d,%r13d
     cde:       4c 89 e2                mov    %r12,%rdx
     ce1:       48 89 df                mov    %rbx,%rdi
     ce4:       48 0f 49 d5             cmovns %rbp,%rdx
     ce8:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi        ceb:
R_X86_64_32S       .rodata.str1.1+0x1cb
     cef:       e8 00 00 00 00          callq  cf4
<rss_config_show+0x54>       cf0: R_X86_64_PC32      seq_printf-0x4
     cf4:       41 f7 c5 00 00 00 40    test   $0x40000000,%r13d
     cfb:       4c 89 e2                mov    %r12,%rdx
     cfe:       48 89 df                mov    %rbx,%rdi
     d01:       48 0f 44 d5             cmove  %rbp,%rdx
     d05:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi        d08:
R_X86_64_32S       .rodata.str1.1+0x1e1
     d0c:       e8 00 00 00 00          callq  d11
<rss_config_show+0x71>       d0d: R_X86_64_PC32      seq_printf-0x4

Test a bit, move "yes" into %rdx, conditionally move "no" into %rdx
instead, call seq_printf.

     d11:       41 f7 c5 00 00 00 20    test   $0x20000000,%r13d
     d18:       4c 89 e2                mov    %r12,%rdx
     d1b:       48 89 df                mov    %rbx,%rdi
     d1e:       48 0f 44 d5             cmove  %rbp,%rdx
     d22:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi        d25:
R_X86_64_32S       .rodata.str1.1+0x1f7
     d29:       e8 00 00 00 00          callq  d2e
<rss_config_show+0x8e>       d2a: R_X86_64_PC32      seq_printf-0x4

etc. That's a marginal (i.e., after the preamble storing "yes" and "no"
in callee-saved registers) cost of six instructions/29 bytes per
seq_printf, three of which are to implement the yesno() call.

extern const char *yesno():

   64e7:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi        64ea:
R_X86_64_32S      .rodata.str1.1+0x8e4
    64ee:       89 ea                   mov    %ebp,%edx
    64f0:       41 89 ed                mov    %ebp,%r13d
    64f3:       e8 00 00 00 00          callq  64f8
<rss_config_show+0x28>      64f4: R_X86_64_PC32     seq_printf-0x4
    64f8:       89 ef                   mov    %ebp,%edi
    64fa:       c1 ef 1f                shr    $0x1f,%edi
    64fd:       e8 00 00 00 00          callq  6502
<rss_config_show+0x32>      64fe: R_X86_64_PC32     yesno-0x4

Three instructions to prepare the argument to yesno and call it.

    6502:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi        6505:
R_X86_64_32S      .rodata.str1.1+0x8f8
    6509:       48 89 c2                mov    %rax,%rdx

One more to put the return from yesno in the right register.

    650c:       48 89 df                mov    %rbx,%rdi
    650f:       e8 00 00 00 00          callq  6514
<rss_config_show+0x44>      6510: R_X86_64_PC32     seq_printf-0x4

So not a lot, but still one more instruction, for a total of 31 bytes.
bloat-o-meter says

$ scripts/bloat-o-meter
drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.o.{1,2}
add/remove: 0/0 grow/shrink: 3/0 up/down: 301/0 (301)
Function                                     old     new   delta
rss_config_show                             2343    2482    +139
rss_vf_config_show                           263     363    +100
rss_pf_config_show                           342     404     +62

which is more then 2*78, but I haven't looked at the code patterns in
the other functions.

Did you use size(1) to compare when you say "text segment"? That would
include .rodata (and, more importantly, .rodata.strX.Y) in its text
column. Maybe your compiler doesn't do string literal merging (since the
linker does it anyway), so your .rodata.str1.1 might contain several
copies of "yes" and "no", but they shouldn't really be counted.

Rasmus
