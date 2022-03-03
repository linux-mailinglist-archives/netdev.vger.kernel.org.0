Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FED4CB7E6
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 08:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiCCHd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 02:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiCCHdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 02:33:23 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E039A21E01;
        Wed,  2 Mar 2022 23:32:35 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id kt27so8803750ejb.0;
        Wed, 02 Mar 2022 23:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Gor8M86/GsIuBlid/S84lkBznvRDaKBCWzgLUKh5JV4=;
        b=k+fk9urovAn8Fq6hF831psJF6X0Hx41hiPVDAocMfW4Gi2tjP5gBRRyYi9UY1gS3y9
         T1f7NxhpZChRCZGs3wiKfQBYFQeu68Ugjwk2rWVNy++UqI5E9Ffm7Qe5sREsy932o9zn
         yoQiy9LiamLlfFC8y8nGBw2mIwTduboT8pHpf33UZ2RGjV2D/meZqmuHsAbl7tfxfJuC
         e8redX9TOEvOJZ9E1AYG0yGidZEg6kfprz6yLCxUQC7gampXaGyLYaXWTA6umkTeR66S
         hL8UX9htvKnv+kjTxwKZtpIsvgv4G4bDiBBsZxSW5S7a6ZZ6AFWNSxZHN5mDaVwEmoV0
         Hg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Gor8M86/GsIuBlid/S84lkBznvRDaKBCWzgLUKh5JV4=;
        b=id0kl/q90ncvhsMeCrR4RKoyZDDANC/HB9N31+GJ3KaCgiAjFV4cIJRbdUQB6Vfzq+
         z6Wgpo3P9AILdpw3qiK35g30pVmVnTBacdxGNBSWHTxSKuVQObpL1BrSTICx2DyuFbSQ
         y07UToAz/LPW32TyLjnnkTUkU+W2XFc9f4hKZsBdjU2h92YeL0jZ14GPPWCTI4QkoprA
         dGoJoPMZtN+QYmJ2ss0VfueKrjfHYv53b28HdoXTFPWB7gp9jpULrd2BZ+pxJGeTH/2s
         9HUU5AMdtUKRnq9mny0Q+glbNiV9UfYjWEIrOmzSmIVPfh+kMJnkeLVv8SkXeCl7gnLK
         XQpg==
X-Gm-Message-State: AOAM530e8Jv/uqzTzSYpQEM5Nb28hM+7fB3J76qfgQWmnwitXHBDKD71
        J0ASu2+7nPZqagQhYrXzLBg=
X-Google-Smtp-Source: ABdhPJzeteUoFgq8PxHWf79kt1+XNtdp+qSeHQzci99kHRtMUTD40dS4a5KNav7C0/39ueCDeIyc3w==
X-Received: by 2002:a17:906:7c93:b0:6cd:341a:a1d5 with SMTP id w19-20020a1709067c9300b006cd341aa1d5mr25639417ejo.698.1646292754302;
        Wed, 02 Mar 2022 23:32:34 -0800 (PST)
Received: from smtpclient.apple ([2a02:8109:9d80:3f6c:896:faf2:6663:1f74])
        by smtp.gmail.com with ESMTPSA id gj18-20020a170907741200b006da82539c83sm410819ejc.73.2022.03.02.23.32.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Mar 2022 23:32:33 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <39404befad5b44b385698ff65465abe5@AcuMS.aculab.com>
Date:   Thu, 3 Mar 2022 08:32:31 +0100
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "bjohannesmeyer@gmail.com" <bjohannesmeyer@gmail.com>,
        "c.giuffrida@vu.nl" <c.giuffrida@vu.nl>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "h.j.bos@vu.nl" <h.j.bos@vu.nl>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A568BD90-FE81-4740-B1D3-C795EB636A5A@gmail.com>
References: <1077f17e50d34dc2bbfdf4e52a1cb2fd@AcuMS.aculab.com>
 <20220303022729.9321-1-xiam0nd.tong@gmail.com>
 <39404befad5b44b385698ff65465abe5@AcuMS.aculab.com>
To:     David Laight <David.Laight@ACULAB.COM>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 3. Mar 2022, at 05:58, David Laight <David.Laight@ACULAB.COM> =
wrote:
>=20
> From: Xiaomeng Tong
>> Sent: 03 March 2022 02:27
>>=20
>> On Wed, 2 Mar 2022 14:04:06 +0000, David Laight
>> <David.Laight@ACULAB.COM> wrote:
>>> I think that it would be better to make any alternate loop macro
>>> just set the variable to NULL on the loop exit.
>>> That is easier to code for and the compiler might be persuaded to
>>> not redo the test.
>>=20
>> No, that would lead to a NULL dereference.
>=20
> Why, it would make it b ethe same as the 'easy to use':
> 	for (item =3D head; item; item =3D item->next) {
> 		...
> 		if (...)
> 			break;
> 		...
> 	}
> 	if (!item)
> 		return;
>=20
>> The problem is the mis-use of iterator outside the loop on exit, and
>> the iterator will be the HEAD's container_of pointer which pointers
>> to a type-confused struct. Sidenote: The *mis-use* here refers to
>> mistakely access to other members of the struct, instead of the
>> list_head member which acutally is the valid HEAD.
>=20
> The problem is that the HEAD's container_of pointer should never
> be calculated at all.
> This is what is fundamentally broken about the current definition.
>=20
>> IOW, you would dereference a (NULL + offset_of_member) address here.
>=20
> Where?
>=20
>> Please remind me if i missed something, thanks.
>>=20
>> Can you share your "alternative definitions" details? thanks!
>=20
> The loop should probably use as extra variable that points
> to the 'list node' in the next structure.
> Something like:
> 	for (xxx *iter =3D head->next;
> 		iter =3D=3D &head ? ((item =3D NULL),0) : ((item =3D =
list_item(iter),1));
> 		iter =3D item->member->next) {
> 	   ...
> With a bit of casting you can use 'item' to hold 'iter'.

I think this would make sense, it would mean you only assign the =
containing
element on valid elements.

I was thinking something along the lines of:

#define list_for_each_entry(pos, head, member)					=
\
	for (struct list_head *list =3D head->next, typeof(pos) pos;	=
\
	     list =3D=3D head ? 0 : (( pos =3D list_entry(pos, list, =
member), 1));	\
	     list =3D list->next)

Although the initialization block of the for loop is not valid C, I'm
not sure there is any way to declare two variables of a different type
in the initialization part of the loop.

I believe all this does is get rid of the &pos->member =3D=3D (head) =
check
to terminate the list.
It alone will not fix any of the other issues that using the iterator
variable after the loop currently has.


AFAIK Adri=C3=A1n Moreno is working on doing something along those lines
for the list iterator in openvswitch (that was similar to the kernel
one before) [1].

I *think* they don't declare 'pos' within the loop which we *do want*
to avoid any uses of it after the loop.
(If pos is not declared in the initialization block, shadowing the
*outer* pos, it would just point to the last element of the list or stay
uninitialized if the list is empty).


[1] https://www.mail-archive.com/ovs-dev@openvswitch.org/msg63497.html


>=20
>>=20
>>> OTOH there may be alternative definitions that can be used to get
>>> the compiler (or other compiler-like tools) to detect broken code.
>>> Even if the definition can't possibly generate a working kerrnel.
>>=20
>> The "list_for_each_entry_inside(pos, type, head, member)" way makes
>> the iterator invisiable outside the loop, and would be catched by
>> compiler if use-after-loop things happened.
>=20
> It is also a compete PITA for anything doing a search.
>=20
> 	David
>=20
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, =
MK1 1PT, UK
> Registration No: 1397386 (Wales)
>=20

- Jakob=
