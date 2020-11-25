Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF72C4A18
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732469AbgKYVdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:33:36 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:38476 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730364AbgKYVdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 16:33:32 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 9789F29FB0;
        Wed, 25 Nov 2020 16:33:24 -0500 (EST)
Date:   Thu, 26 Nov 2020 08:33:24 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Nick Desaulniers <ndesaulniers@google.com>
cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Joe Perches <joe@perches.com>,
        Jakub Kicinski <kuba@kernel.org>, alsa-devel@alsa-project.org,
        linux-atm-general@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-fbdev@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-ide@vger.kernel.org, dm-devel@redhat.com,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
        samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        usb-storage@lists.one-eyed-alien.net, drbd-dev@lists.linbit.com,
        devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org,
        linux-rdma@vger.kernel.org, oss-drivers@netronome.com,
        bridge@lists.linux-foundation.org,
        linux-security-module@vger.kernel.org,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        linux-stm32@st-md-mailman.stormreply.com, cluster-devel@redhat.com,
        linux-acpi@vger.kernel.org, coreteam@netfilter.org,
        intel-wired-lan@lists.osuosl.org, linux-input@vger.kernel.org,
        Miguel Ojeda <ojeda@kernel.org>,
        tipc-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-media@vger.kernel.org, linux-watchdog@vger.kernel.org,
        selinux@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, linux-geode@lists.infradead.org,
        linux-can@vger.kernel.org, linux-block@vger.kernel.org,
        linux-gpio@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        linux-mediatek@lists.infradead.org, xen-devel@lists.xenproject.org,
        nouveau@lists.freedesktop.org, linux-hams@vger.kernel.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-hwmon@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
        Linux Memory Management List <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net, linux-mmc@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-sctp@vger.kernel.org, linux-usb@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, patches@opensource.cirrus.com,
        linux-integrity@vger.kernel.org, target-devel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [Intel-wired-lan] [PATCH 000/141] Fix fall-through warnings for
 Clang
In-Reply-To: <CAKwvOdkGBn7nuWTAqrORMeN1G+w3YwBfCqqaRD2nwvoAXKi=Aw@mail.gmail.com>
Message-ID: <alpine.LNX.2.23.453.2011260750300.6@nippy.intranet>
References: <202011201129.B13FDB3C@keescook> <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <202011220816.8B6591A@keescook> <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com> <ca071decb87cc7e905411423c05a48f9fd2f58d7.camel@perches.com>
 <0147972a72bc13f3629de8a32dee6f1f308994b5.camel@HansenPartnership.com> <d8d1e9add08cdd4158405e77762d4946037208f8.camel@perches.com> <dbd2cb703ed9eefa7dde9281ea26ab0f7acc8afe.camel@HansenPartnership.com> <20201123130348.GA3119@embeddedor>
 <8f5611bb015e044fa1c0a48147293923c2d904e4.camel@HansenPartnership.com> <202011241327.BB28F12F6@keescook> <a841536fe65bb33f1c72ce2455a6eb47a0107565.camel@HansenPartnership.com> <CAKwvOdkGBn7nuWTAqrORMeN1G+w3YwBfCqqaRD2nwvoAXKi=Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020, Nick Desaulniers wrote:

> So developers and distributions using Clang can't have 
> -Wimplicit-fallthrough enabled because GCC is less strict (which has 
> been shown in this thread to lead to bugs)?  We'd like to have nice 
> things too, you know.
> 

Apparently the GCC developers don't want you to have "nice things" either. 
Do you think that the kernel should drop gcc in favour of clang?
Or do you think that a codebase can somehow satisfy multiple checkers and 
their divergent interpretations of the language spec?

> This is not a shiny new warning; it's already on for GCC and has existed 
> in both compilers for multiple releases.
> 

Perhaps you're referring to the compiler feature that lead to the 
ill-fated, tree-wide /* fallthrough */ patch series.

When the ink dries on the C23 language spec and the implementations figure 
out how to interpret it then sure, enforce the warning for new code -- the 
cost/benefit analysis is straight forward. However, the case for patching 
existing mature code is another story.
