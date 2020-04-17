Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495D01AD9CD
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgDQJZg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Apr 2020 05:25:36 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40641 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730211AbgDQJZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:25:36 -0400
Received: by mail-oi1-f193.google.com with SMTP id t199so1532330oif.7;
        Fri, 17 Apr 2020 02:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BWSTE4N/Wm9rwAUVp1UnC1E/i0r+ahDeY0nVMk2tI18=;
        b=RSnd0XS0+dJ4dX7E+0NjRc5voZrcEAU8JK0DvLYK3rSpnJzRBWxflBEbQJqkHmyyOR
         Pg1waFJBuwin507eQYcDZpag2Looce1JaJ9yJsk5DtFGU3NoJl0eie2gjOEO2P3VRvRn
         HpkvLN27MTk9KKdIv99EQOdezL2WY5pXzPvpN5C44jVCHloufhqqHLogdj9EUwnpRskB
         O+/pkGv3kyHOx9AwNWQatMPqfR3+zcUzQVRcoVxZiLQ+s9F+rHz27Y0GziQONctk5DGx
         H7Ckbhadc09VOHUHsV9RM9FFZM9dT7fezoIXMtYnTXRdCeyzpn7I8SfVWp4IHmrV3PC9
         5NwA==
X-Gm-Message-State: AGi0PuYvSJDNrtOkoB/mcaTaZN10IOeoDsrH+2syikF18FqkvGGl6rGf
        45bcqI2rp8jhvkx3muxgd9T+kg3fzWlvUgDbphDYZMnd
X-Google-Smtp-Source: APiQypKOQv5qC1afvAW43RZ+soR2wpbEzQicoJCcDz/ilWYKQxCgXhQrGiZnQcdr5oL9NLxkkPtHOBZ4kMwMNNnvFv8=
X-Received: by 2002:aca:cdd1:: with SMTP id d200mr1412099oig.153.1587115535289;
 Fri, 17 Apr 2020 02:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200415024356.23751-1-jasowang@redhat.com> <20200416185426-mutt-send-email-mst@kernel.org>
 <b7e2deb7-cb64-b625-aeb4-760c7b28c0c8@redhat.com> <20200417022929-mutt-send-email-mst@kernel.org>
 <4274625d-6feb-81b6-5b0a-695229e7c33d@redhat.com> <20200417042912-mutt-send-email-mst@kernel.org>
 <fdb555a6-4b8d-15b6-0849-3fe0e0786038@redhat.com> <20200417044230-mutt-send-email-mst@kernel.org>
 <73843240-3040-655d-baa9-683341ed4786@redhat.com> <20200417045454-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200417045454-mutt-send-email-mst@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 17 Apr 2020 11:25:23 +0200
Message-ID: <CAMuHMdXbzd9puG6gGri4jUtUT8rFrqnWwZ1NwP=47WQJ_eBC5g@mail.gmail.com>
Subject: Re: [PATCH V2] vhost: do not enable VHOST_MENU by default
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Fri, Apr 17, 2020 at 10:57 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> On Fri, Apr 17, 2020 at 04:51:19PM +0800, Jason Wang wrote:
> > On 2020/4/17 下午4:46, Michael S. Tsirkin wrote:
> > > On Fri, Apr 17, 2020 at 04:39:49PM +0800, Jason Wang wrote:
> > > > On 2020/4/17 下午4:29, Michael S. Tsirkin wrote:
> > > > > On Fri, Apr 17, 2020 at 03:36:52PM +0800, Jason Wang wrote:
> > > > > > On 2020/4/17 下午2:33, Michael S. Tsirkin wrote:
> > > > > > > On Fri, Apr 17, 2020 at 11:12:14AM +0800, Jason Wang wrote:
> > > > > > > > On 2020/4/17 上午6:55, Michael S. Tsirkin wrote:
> > > > > > > > > On Wed, Apr 15, 2020 at 10:43:56AM +0800, Jason Wang wrote:
> > > > > > > > > > We try to keep the defconfig untouched after decoupling CONFIG_VHOST
> > > > > > > > > > out of CONFIG_VIRTUALIZATION in commit 20c384f1ea1a
> > > > > > > > > > ("vhost: refine vhost and vringh kconfig") by enabling VHOST_MENU by
> > > > > > > > > > default. Then the defconfigs can keep enabling CONFIG_VHOST_NET
> > > > > > > > > > without the caring of CONFIG_VHOST.
> > > > > > > > > >
> > > > > > > > > > But this will leave a "CONFIG_VHOST_MENU=y" in all defconfigs and even
> > > > > > > > > > for the ones that doesn't want vhost. So it actually shifts the
> > > > > > > > > > burdens to the maintainers of all other to add "CONFIG_VHOST_MENU is
> > > > > > > > > > not set". So this patch tries to enable CONFIG_VHOST explicitly in
> > > > > > > > > > defconfigs that enables CONFIG_VHOST_NET and CONFIG_VHOST_VSOCK.
> > > > > > > > > >
> > > > > > > > > > Acked-by: Christian Borntraeger<borntraeger@de.ibm.com>   (s390)
> > > > > > > > > > Acked-by: Michael Ellerman<mpe@ellerman.id.au>   (powerpc)
> > > > > > > > > > Cc: Thomas Bogendoerfer<tsbogend@alpha.franken.de>
> > > > > > > > > > Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
> > > > > > > > > > Cc: Paul Mackerras<paulus@samba.org>
> > > > > > > > > > Cc: Michael Ellerman<mpe@ellerman.id.au>
> > > > > > > > > > Cc: Heiko Carstens<heiko.carstens@de.ibm.com>
> > > > > > > > > > Cc: Vasily Gorbik<gor@linux.ibm.com>
> > > > > > > > > > Cc: Christian Borntraeger<borntraeger@de.ibm.com>
> > > > > > > > > > Reported-by: Geert Uytterhoeven<geert@linux-m68k.org>
> > > > > > > > > > Signed-off-by: Jason Wang<jasowang@redhat.com>
> > > > > > > > > I rebased this on top of OABI fix since that
> > > > > > > > > seems more orgent to fix.
> > > > > > > > > Pushed to my vhost branch pls take a look and
> > > > > > > > > if possible test.
> > > > > > > > > Thanks!
> > > > > > > > I test this patch by generating the defconfigs that wants vhost_net or
> > > > > > > > vhost_vsock. All looks fine.
> > > > > > > >
> > > > > > > > But having CONFIG_VHOST_DPN=y may end up with the similar situation that
> > > > > > > > this patch want to address.
> > > > > > > > Maybe we can let CONFIG_VHOST depends on !ARM || AEABI then add another
> > > > > > > > menuconfig for VHOST_RING and do something similar?
> > > > > > > >
> > > > > > > > Thanks
> > > > > > > Sorry I don't understand. After this patch CONFIG_VHOST_DPN is just
> > > > > > > an internal variable for the OABI fix. I kept it separate
> > > > > > > so it's easy to revert for 5.8. Yes we could squash it into
> > > > > > > VHOST directly but I don't see how that changes logic at all.
> > > > > > Sorry for being unclear.
> > > > > >
> > > > > > I meant since it was enabled by default, "CONFIG_VHOST_DPN=y" will be left
> > > > > > in the defconfigs.
> > > > > But who cares?
> > > > FYI, please seehttps://www.spinics.net/lists/kvm/msg212685.html
> > > The complaint was not about the symbol IIUC.  It was that we caused
> > > everyone to build vhost unless they manually disabled it.
> >
> > There could be some misunderstanding here. I thought it's somehow similar: a
> > CONFIG_VHOST_MENU=y will be left in the defconfigs even if CONFIG_VHOST is
> > not set.
> >
> > Thanks
>
> Hmm. So looking at Documentation/kbuild/kconfig-language.rst :
>
>         Things that merit "default y/m" include:
>
>         a) A new Kconfig option for something that used to always be built
>            should be "default y".
>
>         b) A new gatekeeping Kconfig option that hides/shows other Kconfig
>            options (but does not generate any code of its own), should be
>            "default y" so people will see those other options.
>
>         c) Sub-driver behavior or similar options for a driver that is
>            "default n". This allows you to provide sane defaults.
>
>
> So it looks like VHOST_MENU is actually matching rule b).
> So what's the problem we are trying to solve with this patch, exactly?
>
> Geert could you clarify pls?

I can confirm VHOST_MENU is matching rule b), so it is safe to always
enable it.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
