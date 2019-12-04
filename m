Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097AE1135D9
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 20:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfLDTkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 14:40:00 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38053 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbfLDTkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 14:40:00 -0500
Received: by mail-qk1-f195.google.com with SMTP id k6so1120495qki.5
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 11:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GboJ6V04qDZWl8k87kSdRH1DQWAO/tS9mhCnR5F3HlQ=;
        b=evP2SthnQmeHmWWlk2fH+TIGNwFVdqbL8d0jZtix9fITPoS8u6JLNCqyZJP3cKqM0n
         jKq4hLkMh5yXQnIdLVowSuAJGnnfeOTvHEjBe7HgK94Pea/rn3kEXrCkJ6hrQUkUXUcl
         tQRX2G17vULrr63GQk83vfa/XcYRMOVwIztoczuD0WFQkNgPBRBZHpBjiGnIyDUcG49N
         ZUgfY5bWRf+6IYhKcHKEcUlhOvhEOfRdxog2ZegaMs2pNi+BWhNSHTMEsvSZtiJ63UPM
         XkaBMfUOXyirlw8Aem+J00x44EkJc2zTMY7P0ONZn7FpI52IuPw/2rV/q0NgPlvFBWZA
         J6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GboJ6V04qDZWl8k87kSdRH1DQWAO/tS9mhCnR5F3HlQ=;
        b=LNZwc4GjBKAD8CK6fwx1vdsu8EAiGr1zUunHMOBMCPn8uRdXUcpVMZsWHiAMen9kr7
         wSWP0MrRJWisFg7vRXlsSFAg9B+lVDjWe3ZNPV+QqT1sJZrASQExCxAgnKaBYBYWROoH
         v5+RxgAyreDHH4Pof7rfUBUjL/hFZX5LJXrNM744H8mDe0Oz9aGmz+Mv6CwRAa8Hbjix
         m4fm0QotvKu/bbB4NPYdZcyAjEnhqUAinI/n9wqBq5cwBdJ7sPlHADDCu2x6Dfo1B9Wp
         WA2i7Yd5H434uwHMy/KawTGW/yq41HDFN7IWNAAeE13zaUj/eXKacxgLSOQbXevfx7EA
         hyCA==
X-Gm-Message-State: APjAAAWBHRgCneTv+EYk4cjV5utgIpr9S4GO9l+jZVqbWYXqcxiMUbRr
        DWRRfJeMO4MSI2a1SXdW+YsZkoZx9n+FiVancKEf1A==
X-Google-Smtp-Source: APXvYqw7M3loYlMcwlYA6SCfua/A7vi1tp9Sdow3Kw8cYwHASbub8MC0jUpalf3cPcZbGCway02HmuxBK4/9SSB8PnU=
X-Received: by 2002:a37:a3c1:: with SMTP id m184mr4759645qke.49.1575488398459;
 Wed, 04 Dec 2019 11:39:58 -0800 (PST)
MIME-Version: 1.0
References: <20191127052118.163594-1-brianvv@google.com> <20191204111107.4a8d7115@hermes.lan>
In-Reply-To: <20191204111107.4a8d7115@hermes.lan>
From:   Brian Vazquez <brianvv@google.com>
Date:   Wed, 4 Dec 2019 11:39:47 -0800
Message-ID: <CAMzD94RmG0VE5tcfzASZEC60cFPgcDrbtEXAKsESX3aHTt_qcw@mail.gmail.com>
Subject: Re: [PATCH iproute2] ss: fix end-of-line printing in misc/ss.c
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reviewing it!

On Wed, Dec 4, 2019 at 11:11 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 26 Nov 2019 21:21:18 -0800
> Brian Vazquez <brianvv@google.com> wrote:
>
> > Before commit 5883c6eba517, function field_is_last() was incorrectly
> > reporting which column was the last because it was missing COL_PROC
> > and by purely coincidence it was correctly printing the end-of-line and
> > moving to the first column since the very last field was empty, and
> > end-of-line was added for the last non-empty token since it was seen as
> > the last field.
> >
> > This commits correcrly prints the end-of-line for the last entrien in
> > the ss command.
> >
> > Tested:
> > diff <(./ss.old -nltp) <(misc/ss -nltp)
> > 38c38
> > < LISTEN    0   128     [::1]:35417   [::]:*   users:(("foo",pid=65254,fd=116))
> > \ No newline at end of file
> > ---
> > > LISTEN    0   128     [::1]:35417   [::]:*   users:(("foo",pid=65254,fd=116))
> >
> > Cc: Hritik Vijay <hritikxx8@gmail.com>
> > Fixes: 5883c6eba517 ("ss: show header for --processes/-p")
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
>
> This commit message is really hard to understand and causes warnings
> in checkpatch. Also, blaming old code for doing the right thing
> is not necessary. The changelog doesn't need to explain why.
> The offending commit is already referenced by the fixes line.
>
> Instead, I propose:
>
>
> The previous change to ss to show header broke the printing of end-of-line
> for the last entry.

This makes sense, I'll fix it in next version. Thanks!

>
> Fixes: 5883c6eba517 ("ss: show header for --processes/-p")
> Signed-off-by: Brian Vazquez <brianvv@google.com>
