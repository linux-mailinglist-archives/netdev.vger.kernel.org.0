Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94104C7B85
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 22:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiB1VN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 16:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiB1VN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 16:13:57 -0500
X-Greylist: delayed 1816 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Feb 2022 13:13:16 PST
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F10ECB3E
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 13:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1646082795;
        bh=b0jOc0WDOwLaR9eob939Fu/T9iRVE4QNy1gcUuEgORI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=fTQp+HhEyDWfdTRw9MD74D4dNoy4lJbDD6ufhn8pOCgDG9LKN5I5E2XfQsXuEnTyE
         o41BjR/wB9Zx796mcVO5HItpPdbUBqFA5gZFvpxw0W0+8SaIBYecaW0t63X4w0ysYd
         Uxmzs2O4chqjQ5mD0m0R9/q9wYnJ2eru8WGs04Zw=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id E895B1281036;
        Mon, 28 Feb 2022 16:13:15 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MBrDmvPYDAaO; Mon, 28 Feb 2022 16:13:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1646082795;
        bh=b0jOc0WDOwLaR9eob939Fu/T9iRVE4QNy1gcUuEgORI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=fTQp+HhEyDWfdTRw9MD74D4dNoy4lJbDD6ufhn8pOCgDG9LKN5I5E2XfQsXuEnTyE
         o41BjR/wB9Zx796mcVO5HItpPdbUBqFA5gZFvpxw0W0+8SaIBYecaW0t63X4w0ysYd
         Uxmzs2O4chqjQ5mD0m0R9/q9wYnJ2eru8WGs04Zw=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 980CE1280320;
        Mon, 28 Feb 2022 16:13:11 -0500 (EST)
Message-ID: <ade13f419519350e460e7ef1e64477ec72e828ed.camel@HansenPartnership.com>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop
 body as a ptr
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakob Koschel <jakobkoschel@gmail.com>,
        alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>
Date:   Mon, 28 Feb 2022 16:13:09 -0500
In-Reply-To: <0b65541a-3da7-dc35-690a-0ada75b0adae@amd.com>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
         <20220228110822.491923-3-jakobkoschel@gmail.com>
         <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
         <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
         <282f0f8d-f491-26fc-6ae0-604b367a5a1a@amd.com>
         <b2d20961dbb7533f380827a7fcc313ff849875c1.camel@HansenPartnership.com>
         <0b65541a-3da7-dc35-690a-0ada75b0adae@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-02-28 at 21:56 +0100, Christian König wrote:
> 
> Am 28.02.22 um 21:42 schrieb James Bottomley:
> > On Mon, 2022-02-28 at 21:07 +0100, Christian König wrote:
> > > Am 28.02.22 um 20:56 schrieb Linus Torvalds:
> > > > On Mon, Feb 28, 2022 at 4:19 AM Christian König
> > > > <christian.koenig@amd.com> wrote:
> > > > [SNIP]
> > > > Anybody have any ideas?
> > > I think we should look at the use cases why code is touching
> > > (pos)
> > > after the loop.
> > > 
> > > Just from skimming over the patches to change this and experience
> > > with the drivers/subsystems I help to maintain I think the
> > > primary pattern looks something like this:
> > > 
> > > list_for_each_entry(entry, head, member) {
> > >       if (some_condition_checking(entry))
> > >           break;
> > > }
> > > do_something_with(entry);
> > 
> > Actually, we usually have a check to see if the loop found
> > anything, but in that case it should something like
> > 
> > if (list_entry_is_head(entry, head, member)) {
> >      return with error;
> > }
> > do_somethin_with(entry);
> > 
> > Suffice?  The list_entry_is_head() macro is designed to cope with
> > the bogus entry on head problem.
> 
> That will work and is also what people already do.
> 
> The key problem is that we let people do the same thing over and
> over again with slightly different implementations.
> 
> Out in the wild I've seen at least using a separate variable, using
> a bool to indicate that something was found and just assuming that
> the list has an entry.
> 
> The last case is bogus and basically what can break badly.

Yes, I understand that.  I'm saying we should replace that bogus checks
of entry->something against some_value loop termination condition with
the list_entry_is_head() macro.  That should be a one line and fairly
mechanical change rather than the explosion of code changes we seem to
have in the patch series.

James


