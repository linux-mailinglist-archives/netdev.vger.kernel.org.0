Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665655466C5
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 14:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiFJMoj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jun 2022 08:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiFJMoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 08:44:38 -0400
Received: from relay5.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E5D18E;
        Fri, 10 Jun 2022 05:44:35 -0700 (PDT)
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay12.hostedemail.com (Postfix) with ESMTP id 06E07121083;
        Fri, 10 Jun 2022 12:44:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id 08E1F2002A;
        Fri, 10 Jun 2022 12:44:18 +0000 (UTC)
Message-ID: <cd59f3eab3d2b4f069f4ebf169b33307eaa9e50d.camel@perches.com>
Subject: Re: [PATCH 00/12] Clang -Wformat warning fixes
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Wendling <morbo@google.com>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Date:   Fri, 10 Jun 2022 05:44:18 -0700
In-Reply-To: <YqLUn3RdZ9HAKZKu@kroah.com>
References: <20220609221702.347522-1-morbo@google.com>
         <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
         <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com>
         <nssn2ps-6n86-nqq6-9039-72847760nnq@vanv.qr>
         <CAGG=3QU0XJhQKJXLMayOkQSiF2yjBi2p2TEZ9KNTzU5mmye-gg@mail.gmail.com>
         <YqLUn3RdZ9HAKZKu@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 08E1F2002A
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: r8ecgxf89uwg9qffzdumnqfsj56kpo1p
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19T013fSZHIO4BR28mlFWzRzi2PPI2hbJs=
X-HE-Tag: 1654865058-93434
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-06-10 at 07:20 +0200, Greg Kroah-Hartman wrote:
> On Thu, Jun 09, 2022 at 04:16:16PM -0700, Bill Wendling wrote:
> > On Thu, Jun 9, 2022 at 4:03 PM Jan Engelhardt <jengelh@inai.de> wrote:
> > > On Friday 2022-06-10 00:49, Bill Wendling wrote:
> > > > On Thu, Jun 9, 2022 at 3:25 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > On Thu,  9 Jun 2022 22:16:19 +0000 Bill Wendling <morbo@google.com> wrote:
> > > > > 
> > > > > > This patch set fixes some clang warnings when -Wformat is enabled.
> > > > > 
> > > > > tldr:
> > > > > 
> > > > > -       printk(msg);
> > > > > +       printk("%s", msg);
> > > > > 
> > > > > Otherwise these changes are a
> > > > > useless consumer of runtime resources.

> > > > Calling a "printf" style function is already insanely expensive.

I expect the printk code itself dominates, not the % scan cost.

> > > Perhaps you can split vprintk_store in the middle (after the call to
> > > vsnprintf), and offer the second half as a function of its own (e.g.
> > > "puts"). Then the tldr could be
> > > 
> > > - printk(msg);
> > > + puts(msg);
> > 
> > That might be a nice compromise. Andrew, what do you think?
> 
> You would need to do that for all of the dev_printk() variants, so I
> doubt that would ever be all that useful as almost no one should be
> using a "raw" printk() these days.

True.  The kernel has ~20K variants like that.

$ git grep -P '\b(?:(?:\w+_){1,3}(?:alert|emerg|crit|err|warn|notice|info|cont|debug|dbg)|printk)\s*\(".*"\s*\)\s*;' | wc -l
21160

That doesn't include the ~3K uses like

#define foo "bar"
	printk(foo);

$ git grep -P '\b(?:(?:\w+_){1,3}(?:alert|emerg|crit|err|warn|info|notice|debug|dbg|cont)|printk)\s*\((?:\s*\w+){1,3}\s*\)\s*;'|wc -l
2922

There are apparently only a few hundred uses of variants like:

	printk("%s", foo)

$ git grep -P '\b(?:(?:\w+_){1,3}(?:alert|emerg|crit|err|warn|info|notice|debug|dbg|cont)|printk)\s*\(\s*"%s(?:\\n)?"\s*,\s*(?:".*"|\w+)\s*\)\s*;' | wc -l
305

unless I screwed up my greps (which of course is quite possible)

