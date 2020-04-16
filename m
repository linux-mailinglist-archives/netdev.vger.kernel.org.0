Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EACD1AC55C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404052AbgDPORZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436893AbgDPORV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 10:17:21 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575E5C061A0C;
        Thu, 16 Apr 2020 07:17:21 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id l84so2138540ybb.1;
        Thu, 16 Apr 2020 07:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3EGvPiqngo9PD85Viky7JQgBsBWxZ43+ciyx0Y2fiF4=;
        b=Yi/E/mBJzOIl2MV86JyIsd5FTc11nOcA+xz2PWKuAss2G6mpkD8aM4I6/gv4wfzJkq
         X9eINDXL+BA+fBWBfnxIaYkEhnMTtj8NIsMIyp3FKAMcQcOarjU0l48eENxVXBAvn+hx
         LWYjV/wiEOGQ4JsGfRAoL49LSGI60I/46MGMrL2XwNIW/b2OjcQ/TYSAHcfs9SIY3n+J
         PrggIBtNHLe9t6BI8TVRb4AX9NH0+PY/LpLRNDx5bzJVg79tYKzS3srQZjjX5EkTRUMj
         rxR4XSD7v6DM+rhmFf3pFKZ1WafWoeGNFcze0uEzg3TsCdpFvoTU+cLGmNQBTnqgdYna
         lEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3EGvPiqngo9PD85Viky7JQgBsBWxZ43+ciyx0Y2fiF4=;
        b=HsWMmpwEs6dC+pQaIGmF0WYzdtfvUlz3h5cISyxMqTrJntyVJbGW4GIhQKD4RF5Niv
         Fo5DgrXzb+mo7//ljrXk2+Qui3NniHIE8Ak9Kk4oO/4RzfSwEycGq/gESHEIRnogUrNS
         GJuSg0SO6zKN50Z1wkglSdivVqoQR5x6/dsPS22Bn1hYoNiBnuuqFV9C42qTDrOh4ufm
         ZgPgbf2xYFZgD8u5Bgh4roYUPBTayzw4MdNJnHnZ8ijgE7S7SSY+BD9Pu9ib3X94MhSJ
         szxFev5GjnkHjrG2fsX/zcEWibOhsX+nC1HyPVm5t+6NLSGANKD+do59qYaChRTxzusz
         iQ7w==
X-Gm-Message-State: AGi0PuYKaYDxAq+kLrQ93HWSQCBpoY3PaEdIiYsPvAw06bUIO4OYn1Vs
        VaUm5FM7ErBc/vfjWdTHYn/+elX16sj5hOw6WOE=
X-Google-Smtp-Source: APiQypIv2aouGBzXhHMa02iF8q/NHS4DlRDchKvavBw5L5PPpIE1U5JF2agcqKyNDktMWX6ZBajiSyWNM9Jm27Cnqnc=
X-Received: by 2002:a5b:5cf:: with SMTP id w15mr16332366ybp.215.1587046640357;
 Thu, 16 Apr 2020 07:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm> <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com> <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com> <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com> <20200416000009.GL1068@sasha-vm>
 <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com> <20200416140441.GL1068@sasha-vm>
In-Reply-To: <20200416140441.GL1068@sasha-vm>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 16 Apr 2020 17:17:09 +0300
Message-ID: <CAJ3xEMjobvx=S4JC4n+TLwN9xnJcwNa-B4O_Evi6PUq30VJchQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for representors
To:     Sasha Levin <sashal@kernel.org>
Cc:     Edward Cree <ecree@solarflare.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 5:04 PM Sasha Levin <sashal@kernel.org> wrote:
> On Thu, Apr 16, 2020 at 04:40:31PM +0300, Or Gerlitz wrote:
> >On Thu, Apr 16, 2020 at 3:00 AM Sasha Levin <sashal@kernel.org> wrote:
> >> I'd maybe point out that the selection process is based on a neural
> >> network which knows about the existence of a Fixes tag in a commit.
> >>
> >> It does exactly what you're describing, but also taking a bunch more
> >> factors into it's desicion process ("panic"? "oops"? "overflow"? etc).
> >
> >As Saeed commented, every extra line in stable / production kernel
> >is wrong. IMHO it doesn't make any sense to take into stable automatically
> >any patch that doesn't have fixes line. Do you have 1/2/3/4/5 concrete
> >examples from your (referring to your Microsoft employee hat comment
> >below) or other's people production environment where patches proved to
> >be necessary but they lacked the fixes tag - would love to see them.
>
> Sure, here are 5 from the past few months:
>
> e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss descriptor")
> 3d94a4a8373b ("mwifiex: fix possible heap overflow in mwifiex_process_country_ie()")
> 39d170b3cb62 ("ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()")
> 8b51dc729147 ("rsi: fix a double free bug in rsi_91x_deinit()")
> 5146f95df782 ("USB: hso: Fix OOB memory access in hso_probe/hso_get_config_data")
>
> 5 Different drivers, neither has a stable tag or a Fixes: tag, all 5
> have a CVE number assigned to them.

CVE number sounds good enough to me to AI around and pull to
stable,  BUT only to where relevant, and nothing beyond (see below).

> >We've been coaching new comers for years during internal and on-list
> >code reviews to put proper fixes tag. This serves (A) for the upstream
> >human review of the patch and (B) reasonable human stable considerations.
>
> Thanks for doing it - we do see more and more fixes tags.
>
> >You are practically saying that for cases we screwed up stage (A) you
> >can somehow still get away with good results on stage (B) - I don't
> >accept it. BTW - during my reviews I tend to ask/require developers to
> >skip the word panic, and instead better explain the nature of the
> >problem / result.
>
> Humans are still humans, and humans make mistakes. Fixes tags get
> forgotten

In the netdev land, the very much usual habit is for -rc patches to have
Fixes tag, so maybe some RCA comment here would be to
enforce that better across the kermel land?

> stable tags get forgotten.

An easy AI would be to deduce the -stable tag from the -fixes tag, just
find out where the offending patch was accepted and never/ever (please!)
push a fix beyond that kernel.

> I very much belive you that the mellanox stuff are in good shape thanks
> to your efforts, but the kernel world is bigger than a few select drivers.

>>>>> This is great, but the kernel is more than just net/. Note that I also
>>>>> do not look at net/ itself, but rather drivers/net/ as those end up with
>>>>> a bunch of missed fixes.

>>>>drivers/net/ goes through the same DaveM net/net-next trees, with the
>>>> same rules.

>>you ignored this comment, any more specific complaints?

> See above (the example commits). The drivers/net/ stuff don't work as
> well as net/ sadly.

Disagree.

If there is a problem it is due to some driver/net/ driver maintainers
not doing their job good enough.

> >> Let me put my Microsoft employee hat on here. We have driver/net/hyperv/
> >> which definitely wasn't getting all the fixes it should have been
> >> getting without AUTOSEL.
> >
> >> While net/ is doing great, drivers/net/ is not. If it's indeed following
> >> the same rules then we need to talk about how we get done right.
> >
> >I never [1] saw -stable push requests being ignored here in netdev.
> >Your drivers have four listed maintainers and it's common habit by
> >commercial companies to have paid && human (non autosel robots)
> >maintainers that take care of their open source drivers. As in commercial
> >SW products, Linux has a current, next and past (stable) releases, so
> >something sounds as missing to me in your care matrix.
>
> How come? DaveM is specifically asking not to add stable tags because he
> will do the selection himself, right? So the hyperv stuff indeed don't
> include a stable tag, but all fixes should have a proper Fixes: tag.

Ask/tell your maintainer to note that in their cover letters, it will be taken.

> So why don't they end up in a stable tree?

> If we need to send a mail saying which commits should go to stable, we
> might as well tag them for stable to begin with, right?

so how about you go and argue with the netdev maintainer and
settle your complaints instead of WA your disagreements using autosel?
