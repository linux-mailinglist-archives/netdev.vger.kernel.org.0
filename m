Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7737545B9D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346018AbiFJFUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346132AbiFJFUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:20:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A643B3C2;
        Thu,  9 Jun 2022 22:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43230B830F6;
        Fri, 10 Jun 2022 05:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6278AC34114;
        Fri, 10 Jun 2022 05:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654838433;
        bh=obJOg0nC5+NFcMbSl//FLvr+ceUwgMoc50Ko3u2Lf80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k/PjXRW3Ejm3OWA0ILi7O80zfEKst1OpP7BC0SxRltN5BaZsp6jjKtr3wXBUDO5zB
         e4Raz/E5WEJs1UM/fE5IzTFZTwR5xBef7mdwfpGnTFs6jcYygdrsalBjswLqjAwcn8
         xxzJxOn25O10o5RwvKHTCaY9QGZ0KZC/wv3VRoMA=
Date:   Fri, 10 Jun 2022 07:20:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bill Wendling <morbo@google.com>
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
Subject: Re: [PATCH 00/12] Clang -Wformat warning fixes
Message-ID: <YqLUn3RdZ9HAKZKu@kroah.com>
References: <20220609221702.347522-1-morbo@google.com>
 <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
 <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com>
 <nssn2ps-6n86-nqq6-9039-72847760nnq@vanv.qr>
 <CAGG=3QU0XJhQKJXLMayOkQSiF2yjBi2p2TEZ9KNTzU5mmye-gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QU0XJhQKJXLMayOkQSiF2yjBi2p2TEZ9KNTzU5mmye-gg@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 04:16:16PM -0700, Bill Wendling wrote:
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

You would need to do that for all of the dev_printk() variants, so I
doubt that would ever be all that useful as almost no one should be
using a "raw" printk() these days.

thanks,

greg k-h
