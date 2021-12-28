Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF8C480CAC
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 19:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbhL1S4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 13:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbhL1S4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 13:56:10 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4CFC06173E
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 10:56:09 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id h15so18674221ljh.12
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 10:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxdfxLuiSeWnXlU6gfhg71wxiE+vMrvatpHVdz5QN7g=;
        b=Ras2/40KS2Q64dMJMWOqT02xLehnyD9+zE9s4u71NAFP7NawCp4DUYULihV9fus3RP
         ALyQKuaOOAH0lWSb453txIGSfhV+pIOaoLS9cxI/lfw3q59NXIp5yCSK+NIhCS9HsqNy
         FzweukWxgmcCnSqkf28bmkySDucRpjSaGZubd87qkka5xdiBdZ4YaSX6NpRFasCAt3pc
         DLcfmQIxWW3ff+h1y5KQhbPc6dI1454ukl6B5pQVXRxp8Eq6jqGzUZdJP42V6+ujDHFH
         KXznw2J0FudkddglGUcHE0hoXGEmbM82vK1bp5a8ekWIc5bdUiaBFhoHOgwfQaFRG0pr
         ApBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OxdfxLuiSeWnXlU6gfhg71wxiE+vMrvatpHVdz5QN7g=;
        b=4ryYpXuKUs2/c1iVNN7jRYzo7rphz0h8ZR1TvoergCpu0PEoxaC3qkukCQvpT2l4d8
         p+X7J7xDljucFp1uR/9pdn31rckpp3Ret2Ma+Vwu1rmgAv4z27ylV68EcKfNMoUhfddo
         V4oEohDSyJGGjAp+0dyegJeLQUnglYxPq/1ZXn0a50x4NESxxAwzW8/VaTHP9VPz+KJb
         gkriXuhai5avRdAYMiAKyOhADKqREOHJgPG16UTSZ6k1W3/obMBbLN1rNd2nkeh2wzNp
         dbc+B2h3PyWHOJBvaYkihP+LACYOyfzdC1zmGwOzdrhlgdQ4seonAMCE+m8bJLFV15wi
         yvMQ==
X-Gm-Message-State: AOAM531lqYsXHvwNCidIu7zF6CBCN+9JxiYO3QMOpLeSkRLxzYrMAzoD
        Rye0FnhjCEw4P/vASOIoE09hBa7KP4TC9wUUh247vQ==
X-Google-Smtp-Source: ABdhPJxSHEH7S9BL9eRVIvEVwtJoh0q7t8Ea+aoQCnO5P1krfwZ0pAqTW/eFTemIqU9uH8bmc+kunDU8qLoyC8UA3jk=
X-Received: by 2002:a2e:141c:: with SMTP id u28mr19256751ljd.338.1640717767195;
 Tue, 28 Dec 2021 10:56:07 -0800 (PST)
MIME-Version: 1.0
References: <20211223162848.3243702-1-trix@redhat.com> <CAKwvOd=dLjMAim_FRNyWegzEjy0_1vF2xVW1hNPQ55=32qO4Wg@mail.gmail.com>
 <b3ef8d23-7c77-7c83-0bc8-2054b7ac1d8b@redhat.com>
In-Reply-To: <b3ef8d23-7c77-7c83-0bc8-2054b7ac1d8b@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 28 Dec 2021 10:55:55 -0800
Message-ID: <CAKwvOdkUQARWd7qG_hkUJYuVcvObMYTif_HDSEmJ5mSXP6y1=A@mail.gmail.com>
Subject: Re: [PATCH] mac80211: initialize variable have_higher_than_11mbit
To:     Tom Rix <trix@redhat.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 24, 2021 at 6:01 AM Tom Rix <trix@redhat.com> wrote:
>
>
> On 12/23/21 12:30 PM, Nick Desaulniers wrote:
> > On Thu, Dec 23, 2021 at 8:29 AM <trix@redhat.com> wrote:
> >> From: Tom Rix <trix@redhat.com>
> >>
> >> Clang static analysis reports this warnings
> >>
> >> mlme.c:5332:7: warning: Branch condition evaluates to a
> >>    garbage value
> >>      have_higher_than_11mbit)
> >>      ^~~~~~~~~~~~~~~~~~~~~~~
> >>
> >> have_higher_than_11mbit is only set to true some of the time in
> >> ieee80211_get_rates() but is checked all of the time.  So
> >> have_higher_than_11mbit needs to be initialized to false.
> > LGTM. There's only one caller of ieee80211_get_rates() today; if there
> > were others, they could make a similar mistake in the future. An
> > alternate approach: ieee80211_get_rates() could unconditionally write
> > false before the loop that could later write true. Then call sites
> > don't need to worry about this conditional assignment. Perhaps that
> > would be preferable? If not:
>
> The have_higher_than_11mbit variable had previously be initialized to false.
>
> The commit 5d6a1b069b7f moved the variable without initializing.

I'm not disagreeing with that.

My point is that these sometimes uninitialized warnings you're
finding+fixing with clang static analyzer are demonstrating a
recurring pattern with code.

When _not_ using the static analyzer, -Wuninitialized and
-Wsometimes-uninitialized work in Clang by building a control flow
graph, but they only analyze a function locally.

For example, consider the following code:
```
_Bool is_thursday(void);
void hello(int);

void init (int* x) {
  if (is_thursday())
    *x = 1;
}

void foo (void) {
  int x;
  init(&x);
  hello(x);
}
```
(Clang+GCC today will warn on the above; x is considered to "escape"
the scope of foo as init could write the address of x to a global.
Instead clang's static analyzer will take the additional time to
analyze the callee.  But here's a spooky question: what happens when
init is in another translation unit? IIRC, the static analyzer doesn't
do cross TU analysis; I could be wrong though, I haven't run it in a
while.)

My point is that you're sending patches initializing x, when I think
it might be nicer to instead have functions like init always write a
value (unconditionally, rather than conditionally).  That way other
callers of init don't have to worry about sometimes initialized
variables.

>
> Tom
>
> >
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> >
> >> Fixes: 5d6a1b069b7f ("mac80211: set basic rates earlier")
> >> Signed-off-by: Tom Rix <trix@redhat.com>
> >> ---
> >>   net/mac80211/mlme.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> >> index 51f55c4ee3c6e..766cbbc9c3a72 100644
> >> --- a/net/mac80211/mlme.c
> >> +++ b/net/mac80211/mlme.c
> >> @@ -5279,7 +5279,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
> >>           */
> >>          if (new_sta) {
> >>                  u32 rates = 0, basic_rates = 0;
> >> -               bool have_higher_than_11mbit;
> >> +               bool have_higher_than_11mbit = false;
> >>                  int min_rate = INT_MAX, min_rate_index = -1;
> >>                  const struct cfg80211_bss_ies *ies;
> >>                  int shift = ieee80211_vif_get_shift(&sdata->vif);
> >> --
> >> 2.26.3
> >>
> >
>


-- 
Thanks,
~Nick Desaulniers
