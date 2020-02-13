Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2860D15CD61
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgBMViA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:38:00 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42042 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgBMViA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:38:00 -0500
Received: by mail-lj1-f193.google.com with SMTP id d10so8337977ljl.9
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jtS4rjKch/eIxYuRE1rBd1Np3fh95EMJHZPtozx1IdU=;
        b=cFIjwFlka8Q6k5k0uwiVOYQh3KBGZAx1jTW+glsWmbGPwW49m06Ggcglnis/tiHHay
         ZSE+vfV0yXAAXW0sTdr2mfTP0lHIqZJAWrU2TNWwpoj1rKjxwn/vmL5G7GDwWRxe9gI5
         OFGRlR97WSSIJ71X/s74bTCKEX95FOy4zawho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jtS4rjKch/eIxYuRE1rBd1Np3fh95EMJHZPtozx1IdU=;
        b=lHWR4zt1YTErOj4+70Vc5HqDDOjcqDfCBhixihoPV5cHQKkrYGAs2bRb8wPHS5nStI
         eCBZLPxY91kKnl5SKMfP9djBNfL2BCHYPpQ0+v7BmrBFPTNWg8H1YkYJC/7U1iacayr9
         8bniDKoRhzb7LMT/PR/qmURnTf8WAq5Nftx6feNQId4kIGimejonBRHZBJvaMuTxt1vz
         MFUcWsqlrGOXaDlkRuaUlVUlbL+UylaOwxTaUreeCXRqmjCQUofJPlKyBbO+1LweT2EI
         j0eAaMVtbR3J4zsatrhaCw45jUwWDyDvCU1mv8WGTIH1lJ5vXKPxCZveLiRLtWCeh9o7
         AApQ==
X-Gm-Message-State: APjAAAXVflPigUBJJoeSfa1k7wRQ1ps5V/PpEdPEXIGhWoF7HFbWukku
        XvbAp8PRrXJDSqNTm2jiXBw23aLlXy0=
X-Google-Smtp-Source: APXvYqxcHErnDgEJ5ArINcx2+PMBl0nhkUtM2ohxf7eU7mukkWDaFvtKWfvmvtU3MrAZ9AshIKTg8A==
X-Received: by 2002:a2e:9b90:: with SMTP id z16mr12781831lji.254.1581629878031;
        Thu, 13 Feb 2020 13:37:58 -0800 (PST)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id t10sm2247779lji.61.2020.02.13.13.37.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 13:37:56 -0800 (PST)
Received: by mail-lj1-f178.google.com with SMTP id q8so8353506ljb.2
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:37:56 -0800 (PST)
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr12479474ljk.201.1581629876398;
 Thu, 13 Feb 2020 13:37:56 -0800 (PST)
MIME-Version: 1.0
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
 <20200128025958.43490-2-arjunroy.kdev@gmail.com> <20200212184101.b8551710bd19c8216d62290d@linux-foundation.org>
In-Reply-To: <20200212184101.b8551710bd19c8216d62290d@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 13 Feb 2020 13:37:40 -0800
X-Gmail-Original-Message-ID: <CAHk-=whXrLfFrgJKrLUCXB0_ncXAetOqp7Crv4pqmKfiEjh4=w@mail.gmail.com>
Message-ID: <CAHk-=whXrLfFrgJKrLUCXB0_ncXAetOqp7Crv4pqmKfiEjh4=w@mail.gmail.com>
Subject: Re: [PATCH resend mm,net-next 2/3] mm: Add vm_insert_pages().
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        arjunroy@google.com, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 6:41 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Also, vm_insert_page() does
>
>         if (!page_count(page))
>                 return -EINVAL;
>
> and this was not carried over into vm_insert_pages().  How come?

Sounds like that was just a mistake.

> I don't know what that test does - it was added by Linus in the
> original commit a145dd411eb28c83.  It's only been 15 years so I'm sure
> he remembers ;)

Oh, sure.

No, I have absolutely no memory of the details, but I think the commit
message is actually the big hint: the difference between
vm_insert_page() and some of the more random "insert any pdf" cases we
have is exactly that:

    The page you insert needs to be a nice clean kernel allocation, so you
    can't insert arbitrary page mappings with this, but that's not what
    people want.

thing. The comment above it also kind of hints at it.

We *historically* had interfaces to insert random reserved pages (for
IO mappings, but also the zero page etc), but the whole point of that
vm_insert_page() is that it's now an interface for drivers to insert
the pages they maintain into the page tables.

But that also means that we very much didn't allow just random pages
accessed by doing pfn lookups (that might not be in use at all).

Is "page_count()" a great test? No. But it's at least _a_ test of
that. No reserved pages or other magic need apply.

         Linus
