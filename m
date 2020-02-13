Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93A315CDD0
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 23:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBMWHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 17:07:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54195 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbgBMWHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 17:07:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id s10so7959940wmh.3
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 14:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xDjQGbNYIrgDUILgWgtabhg5xTMNM/MqQjIcUQH38tk=;
        b=ZjFS4r7b+2HbjflGUPMaa2nJC/vZOO2WMF8QBRln/sJls2qItOz71S5ZbjAzXwzYbR
         bJ5zugBmGM8MnnRecxz6T1ku9ef+I19FOSl+PY+5A2grT/5cgFerzznBJXWN9d959Yw6
         bybdD+smWXo72hUxIOfZcJyxsh4dtkMZajvWZgfBsP4W9FPa94mA4hCQan0W8++2i0Tp
         0VskwUWm9YXU1LefkcABcjvfEvph2gIjjFfXtx34l9+ZspaWMHToT0GqvP3VgXIpkP43
         mJhc0u2wisZr55uU8Xq9vWDfOaAG0QyUfvWN1tD4xA0tjtqsxekRVhrfjlEFHupEHKz2
         3AXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xDjQGbNYIrgDUILgWgtabhg5xTMNM/MqQjIcUQH38tk=;
        b=MYpiUSRJlonYLfrb8SeXI4E6f3cxACxSxMKssknyAYmx8t1kTwHhiCzzASYh1Wnc1+
         EA6l+5wJ8rjQ3Z1rkpk+urCs3d+8FV0aW8gn8Idv3UZBrPgCWvhKL4vBsqbbZ77x+H8U
         iXiOSdzwwsWf3tmUOJskCQqu4edpUkT/BTJVU/ICnF68bqkk/jcgfFP1v6M62ewtqxHv
         OHGDqG4VzJdAxxKm2DOrt0IaT4d1pet+X0LLACiTQQzw6jCxmColcqLSU2loXMUdN8Gr
         IdM18JfEKmN+y71NMbKY1d2e7pXL9uLsT/nv/ps4eAGrINdma2tGRMnTrlbEvEqw6zEb
         qDWg==
X-Gm-Message-State: APjAAAXZR+hip4MQHd1+Ajs+cdy87543g8K46bGtuXdG4eheIXQVVSnw
        VZhBUbzt1+Zs3kPNfXbiBybKCh2Uqv+8LpFyZJyBGQ==
X-Google-Smtp-Source: APXvYqweAGOTxJ3tHjE53HI+a2dp1jKgjevEVhFy62A84q7gs10oq5FPkRiM3QMNPr9PqgFSSORAHyTsb1wliVbSN0U=
X-Received: by 2002:a1c:4857:: with SMTP id v84mr199500wma.8.1581631625882;
 Thu, 13 Feb 2020 14:07:05 -0800 (PST)
MIME-Version: 1.0
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
 <20200128025958.43490-2-arjunroy.kdev@gmail.com> <20200213215407.GT7778@bombadil.infradead.org>
In-Reply-To: <20200213215407.GT7778@bombadil.infradead.org>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 13 Feb 2020 14:06:53 -0800
Message-ID: <CAOFY-A2Nd7PNpeirGJsA5NWkLbT=yh9Gt-FYLuuNPX8ufLmEtQ@mail.gmail.com>
Subject: Re: [PATCH resend mm,net-next 2/3] mm: Add vm_insert_pages().
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 1:54 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Jan 27, 2020 at 06:59:57PM -0800, Arjun Roy wrote:
> >  int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
> > +int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
> > +                     struct page **pages, unsigned long *num);
> >  int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
> >                       unsigned long pfn);
>
> Sorry I didn't notice these patches earlier.  I'm not thrilled about
> the addition of a new vm_insert_* operation; we're moving towards a
> vmf_insert_* API.  There are almost no users left of vm_insert_page
> (10, at a quick count).  Once they're all gone, we can switch the
> underlying primitives over to a vm_fault_t return type and get rid of the
> errno-to-vm-fault translation step that currently goes on.
>
> So ... is this called in the fault path?  Do you have a struct vm_fault
> around?  Can you handle a vm_fault_t return value instead of an errno?

This is not a page fault, really. This customer of vm_insert_page() is
the TCP receive zerocopy code, which is remapping pages from the NIC
into the userspace process (in lieu of sys_recvmsg()'s copy). See:
tcp_zerocopy_receive() in net/ipv4/tcp.c .

I took a peek at vmf_insert_page(). I think that hides the presence of
EBUSY, which would be a necessary signal for us. If that was exposed I
think vm_fault_t could be fine, *but* I shall defer to Eric for
actually deciding on it.

-Arjun
