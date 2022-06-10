Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF835545983
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 03:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240165AbiFJBTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 21:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiFJBTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 21:19:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7C536E2B;
        Thu,  9 Jun 2022 18:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1544616C9;
        Fri, 10 Jun 2022 01:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107EEC34114;
        Fri, 10 Jun 2022 01:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654823959;
        bh=NUfNzI+Lzqk+ZMoLBcXdIunumPdQxiKPTgtDE7N0Sgk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k2K3VAI6SDQeixfuxmPLxZgpiSqDGd0SM+Ll9mgkEIzO4uveLGhDNJt0+TSFK+7Dy
         zU2YexZB9zyyJafX9UAhTSLsmxBgnx4E4qwGlBqJCxclBsikRqriCf9H277tXNvHi5
         35QHlBHe+SBvbWDdRMsPbHvFhnkfmzsajDvPN4sk=
Date:   Thu, 9 Jun 2022 18:19:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Bill Wendling <morbo@google.com>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Bill Wendling <isanbard@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-mm@kvack.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH 00/12] Clang -Wformat warning fixes
Message-Id: <20220609181917.32e0169b3d33e42b8eb8dcac@linux-foundation.org>
In-Reply-To: <CAGG=3QU0XJhQKJXLMayOkQSiF2yjBi2p2TEZ9KNTzU5mmye-gg@mail.gmail.com>
References: <20220609221702.347522-1-morbo@google.com>
        <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
        <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com>
        <nssn2ps-6n86-nqq6-9039-72847760nnq@vanv.qr>
        <CAGG=3QU0XJhQKJXLMayOkQSiF2yjBi2p2TEZ9KNTzU5mmye-gg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jun 2022 16:16:16 -0700 Bill Wendling <morbo@google.com> wrote:

> On Thu, Jun 9, 2022 at 4:03 PM Jan Engelhardt <jengelh@inai.de> wrote:
> > On Friday 2022-06-10 00:49, Bill Wendling wrote:
> > >On Thu, Jun 9, 2022 at 3:25 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >> On Thu,  9 Jun 2022 22:16:19 +0000 Bill Wendling <morbo@google.com> wrote:
> > >>
> > >> > This patch set fixes some clang warnings when -Wformat is enabled.
> > >>
> > >> tldr:
> > >>
> > >> -       printk(msg);
> > >> +       printk("%s", msg);
> > >>
> > >> Otherwise these changes are a
> > >> useless consumer of runtime resources.
> > >
> > >Calling a "printf" style function is already insanely expensive.
> > >[...]
> > >The "printk" and similar functions all have the "__printf" attribute.
> > >I don't know of a modification to that attribute which can turn off
> > >this type of check.
> >
> > Perhaps you can split vprintk_store in the middle (after the call to
> > vsnprintf), and offer the second half as a function of its own (e.g.
> > "puts"). Then the tldr could be
> >
> > - printk(msg);
> > + puts(msg);
> 
> That might be a nice compromise. Andrew, what do you think?
> 

Sure.  It's surprising that we don't already have a puts().
