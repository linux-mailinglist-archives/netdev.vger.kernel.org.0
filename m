Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28402EC799
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbhAGBMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAGBMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 20:12:53 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CED6C0612EF
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 17:12:13 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r5so6086688eda.12
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 17:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4qZRa6vTQ/ibyR+kN56/QIb8lbRVyte/SLIYH3vkfN4=;
        b=IhnuY2K3J/k451EufL1ohbfykeSkE/N5J0xYpEQvRqy+jmymijQ2naFiC9h9ABKezO
         HKcSoE3Ei+HCR/qCzXNxEk32HdQzmK2+R9ckv2I2DkiBWh6naal+zzQLQK2dUSsEiY4M
         JEw6mDHpCOHT6ARq9dyFBSiJd5wxV/tDAbRWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4qZRa6vTQ/ibyR+kN56/QIb8lbRVyte/SLIYH3vkfN4=;
        b=aiLoQPyF5dWPj7yKOXQOECUVNsEsCm5nYHTDqEAO2jLCYM32JmjSC1ODRD6vl5n5W7
         fcxE1k9hAcazj8NhVu1Piupvav2N7vo9je+3qRk5v4I4E61uTOD3BFmgqsJTKYWtXWBs
         +DD/VnVIVf8QoYxz58/nxu9HU7y1kJwS+wR33wWkDcFy7m/t26kkNsWCAih4cn3ACutN
         DgR4Vf/j9iX7vzlzdHRB6+9ZrXzSAgVhVTPcPufwiVnqKsFAeaylE3SnQSQ6KSydeNVW
         9YFQcEWiTLCUI7pXG5ElYXUsPHJnJp37YB6T2KoQDYWqahhwfHkjX5Au6wNrSLyQIHtb
         Stlg==
X-Gm-Message-State: AOAM530sjVd5V3HPzyJZMAI39cYsoYWUUPotmxP5LHZiAWq3KNYWu0At
        JC+CMthobSmHiaVJkCRoyaCGq13qky7klQ==
X-Google-Smtp-Source: ABdhPJz371hS8ufGdvtQ+Z/r6xV4MCj2LRuE65WdZSQv28rUNoLliZ8t9fJEfGJcRqhFL5bYTxcGwA==
X-Received: by 2002:aa7:d6d8:: with SMTP id x24mr5925741edr.105.1609981931766;
        Wed, 06 Jan 2021 17:12:11 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id v18sm1864455ejw.18.2021.01.06.17.12.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 17:12:11 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id cm17so6171905edb.4
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 17:12:11 -0800 (PST)
X-Received: by 2002:a05:6512:789:: with SMTP id x9mr2704633lfr.487.1609981444808;
 Wed, 06 Jan 2021 17:04:04 -0800 (PST)
MIME-Version: 1.0
References: <20201118194838.753436396@linutronix.de> <20201118204007.169209557@linutronix.de>
 <20210106180132.41dc249d@gandalf.local.home>
In-Reply-To: <20210106180132.41dc249d@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 6 Jan 2021 17:03:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
Message-ID: <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
Subject: Re: [BUG] from x86: Support kmap_local() forced debugging
To:     Steven Rostedt <rostedt@goodmis.org>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001d1c6605b8450450"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001d1c6605b8450450
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 6, 2021 at 3:01 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I triggered the following crash on x86_32 by simply doing a:
>
> (ssh'ing into the box)
>
>   # head -100 /tmp/output-file
>
> Where the /tmp/output-file was the output of a trace-cmd report.
> Even after rebooting and not running the tracing code, simply doing the
> head command still crashed.

The code decodes to

   0:   3b 5d e8                cmp    -0x18(%ebp),%ebx
   3:   0f 47 5d e8             cmova  -0x18(%ebp),%ebx
   7:   c7 45 e0 00 00 00 00    movl   $0x0,-0x20(%ebp)
   e:   8b 7d e0                mov    -0x20(%ebp),%edi
  11:   39 7d e8                cmp    %edi,-0x18(%ebp)
  14:   76 3a                   jbe    0x50
  16:   8b 45 d4                mov    -0x2c(%ebp),%eax
  19:   e8 a4 e4 ff ff          call   0xffffe4c2
  1e:   8b 55 e4                mov    -0x1c(%ebp),%edx
  21:   03 55 e0                add    -0x20(%ebp),%edx
  24:   89 d9                   mov    %ebx,%ecx
  26:   01 c6                   add    %eax,%esi
  28:   89 d7                   mov    %edx,%edi
  2a:*  f3 a4                   rep movsb %ds:(%esi),%es:(%edi)
 <-- trapping instruction
  2c:   e8 c9 e4 ff ff          call   0xffffe4fa
  31:   01 5d e0                add    %ebx,-0x20(%ebp)
  34:   8b 5d e8                mov    -0x18(%ebp),%ebx
  37:   b8 00 10 00 00          mov    $0x1000,%eax
  3c:   2b 5d e0                sub    -0x20(%ebp),%ebx

and while it would be good to see the output of
scripts/decode_stacktrace.sh, I strongly suspect that the above is

                                vaddr = kmap_atomic(p);
                                memcpy(to + copied, vaddr + p_off, p_len);
                                kunmap_atomic(vaddr);

(although I wonder how/why the heck you've enabled
CC_OPTIMIZE_FOR_SIZE=y, which is what causes "memcpy()" to be done as
that "rep movsb". I thought we disabled it because it's so bad on most
cpus).

So that first "call" instruction is the kmap_atomic(), the "rep movs"
is the memcpy(), and the "call" instruction immediately after is the
kunmap_atomic().

Anyway, you can see vaddr in register state:

        EAX: fff57000

so we've kmapped that one page at fff57000, but we're accessing past
it into the next page:

> BUG: unable to handle page fault for address: fff58000

with the current source address being (ESI: fff58000) and we still
have 248 bytes to go (ECX: 000000f8) even though we've already
overflowed into the next page.

You can see the original count still (EBX: 000005a8), so it really
looks like that skb_frag_foreach_page() logic

                        skb_frag_foreach_page(f,
                                              skb_frag_off(f) + offset - start,
                                              copy, p, p_off, p_len, copied) {
                                vaddr = kmap_atomic(p);
                                memcpy(to + copied, vaddr + p_off, p_len);
                                kunmap_atomic(vaddr);
                        }

must be wrong, and doesn't handle the "each page" part properly. It
must have started in the middle of the page, and p_len (that 0x5a8)
was wrong.

IOW, it really looks like p_off + p_len had the value 0x10f8, which is
larger than one page. And looking at the code, in
skb_frag_foreach_page(), I see:

             p_off = (f_off) & (PAGE_SIZE - 1),                         \
             p_len = skb_frag_must_loop(p) ?                            \
             min_t(u32, f_len, PAGE_SIZE - p_off) : f_len,              \

where that "min_t(u32, f_len, PAGE_SIZE - p_off)" looks correct, but
then presumably skb_frag_must_loop() must be wrong.

Oh, and when I look at that, I see

    static inline bool skb_frag_must_loop(struct page *p)
    {
    #if defined(CONFIG_HIGHMEM)
            if (PageHighMem(p))
                    return true;
    #endif
            return false;
    }

and that is no longer true. With the kmap debugging, even non-highmem
pages need that "do one page at a time" code, because even non-highmem
pages get remapped by kmap().

IOW, I think the patch to fix this might be something like the attached.

I wonder whether there is other code that "knows" about kmap() only
affecting PageHighmem() pages thing that is no longer true.

Looking at some other code, skb_gro_reset_offset() looks suspiciously
like it also thinks highmem pages are special.

Adding the networking people involved in this area to the cc too.

               Linus

--0000000000001d1c6605b8450450
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
Content-ID: <f_kjm5bgcv0>
X-Attachment-Id: f_kjm5bgcv0

IGluY2x1ZGUvbGludXgvc2tidWZmLmggfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3NrYnVmZi5o
IGIvaW5jbHVkZS9saW51eC9za2J1ZmYuaAppbmRleCAzMzNiY2RjMzk2MzUuLmM4NThhZGZiNWE4
MiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9za2J1ZmYuaAorKysgYi9pbmNsdWRlL2xpbnV4
L3NrYnVmZi5oCkBAIC0zNjYsNyArMzY2LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHNrYl9mcmFn
X3NpemVfc3ViKHNrYl9mcmFnX3QgKmZyYWcsIGludCBkZWx0YSkKIHN0YXRpYyBpbmxpbmUgYm9v
bCBza2JfZnJhZ19tdXN0X2xvb3Aoc3RydWN0IHBhZ2UgKnApCiB7CiAjaWYgZGVmaW5lZChDT05G
SUdfSElHSE1FTSkKLQlpZiAoUGFnZUhpZ2hNZW0ocCkpCisJaWYgKElTX0VOQUJMRUQoQ09ORklH
X0RFQlVHX0tNQVBfTE9DQUxfRk9SQ0VfTUFQKSB8fCBQYWdlSGlnaE1lbShwKSkKIAkJcmV0dXJu
IHRydWU7CiAjZW5kaWYKIAlyZXR1cm4gZmFsc2U7Cg==
--0000000000001d1c6605b8450450--
