Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4724C7CD5
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 23:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiB1WGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 17:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiB1WGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 17:06:11 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F44C4B55;
        Mon, 28 Feb 2022 14:05:31 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qx21so27621667ejb.13;
        Mon, 28 Feb 2022 14:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=rjAgW0TZYa01aB+RWuD5jL6/P65QVmPGzGS1fypwqkM=;
        b=SsE2iptdX/xTNU84zbtZf+FZ8hKTkJX9H9ZM578+fdgJrDU7+0yGKs3Y1+Ec8zM22z
         4L/SCSccM9eH+aBbsU9p5ll5VTrDlXvOt1QFHQZ0QoX++s1RFseEQQ8VJGBWAvwFCFIq
         jeFzH1SGTYgHS7irPmR7cmG6wYjaX3+E6LxhLklpw86+z7E18Zuelcsa1QvD5X9AuKj5
         NYlhLrqxXUYjh+QgOiXwDeMKoQqdSp4BR7hulFUTvSZMfnkNflEuO+lrt30n2JUf7UIn
         5TdA8KwzIEgmQjPXnxPtLxIzLgpwPLiA+LehnjNWRY5HBdt4E59Tm/VNBLrMAmAi/DS2
         EEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=rjAgW0TZYa01aB+RWuD5jL6/P65QVmPGzGS1fypwqkM=;
        b=W/12CwqZ3uzF9/7JkXERS4Y+CdZGwbbbQ0nWvsM7TR1zmYzDQ26zI1lWM+qtzN/t1i
         XtDLx3/As3xn++hIWRYWHc+ZWHdBfXN63sO2xLAW9UlAiLBZuqIm0rP5a1jqCDrwOkjZ
         dQccJ/7ZLiYu7KLCH5U25inYMSnunbQzlWsk8OkOlrGDB05bYe6bdNrvLbywT+HUzs3w
         FrkFGkFM85IXPhqoa3rByMdo/mvXvVUwb1rQiGL9ZO3OvQl8OKMRECNJSvOJLtOSUwhD
         0y/onbfE+nza7Kt2o5oUKpgj64lq1VLWbXAiVXpZz2QzDJWpeNMdnAyN+dmjq73P9SyC
         Gp9w==
X-Gm-Message-State: AOAM5317JvYWqn+H3SXcsseeu1Ak49y9S5UGir6uxGGuNvVTz3RflWEV
        mvwm/Fvfl9DIpNtBFqCK+YE=
X-Google-Smtp-Source: ABdhPJy9dyrpbH/urhqhSpy7WKh/oklsnc56vlW33h3ZTWE1g0yI8U4qpehenqdC8nVSV7dV3sC9Vw==
X-Received: by 2002:a17:906:370f:b0:6ce:6e7:7344 with SMTP id d15-20020a170906370f00b006ce06e77344mr16083589ejc.654.1646085929715;
        Mon, 28 Feb 2022 14:05:29 -0800 (PST)
Received: from smtpclient.apple ([2a02:8109:9d80:3f6c:957a:1d13:c949:d1f3])
        by smtp.gmail.com with ESMTPSA id v2-20020a17090606c200b006a728f4a9bcsm4769566ejb.148.2022.02.28.14.05.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Feb 2022 14:05:29 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <0b65541a-3da7-dc35-690a-0ada75b0adae@amd.com>
Date:   Mon, 28 Feb 2022 23:05:26 +0100
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <192A6D7F-E803-47AE-9C7A-267B4E87C856@gmail.com>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com>
 <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <282f0f8d-f491-26fc-6ae0-604b367a5a1a@amd.com>
 <b2d20961dbb7533f380827a7fcc313ff849875c1.camel@HansenPartnership.com>
 <0b65541a-3da7-dc35-690a-0ada75b0adae@amd.com>
To:     =?utf-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
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



> On 28. Feb 2022, at 21:56, Christian K=C3=B6nig =
<christian.koenig@amd.com> wrote:
>=20
>=20
>=20
> Am 28.02.22 um 21:42 schrieb James Bottomley:
>> On Mon, 2022-02-28 at 21:07 +0100, Christian K=C3=B6nig wrote:
>>> Am 28.02.22 um 20:56 schrieb Linus Torvalds:
>>>> On Mon, Feb 28, 2022 at 4:19 AM Christian K=C3=B6nig
>>>> <christian.koenig@amd.com> wrote:
>>>> [SNIP]
>>>> Anybody have any ideas?
>>> I think we should look at the use cases why code is touching (pos)
>>> after the loop.
>>>=20
>>> Just from skimming over the patches to change this and experience
>>> with the drivers/subsystems I help to maintain I think the primary
>>> pattern looks something like this:
>>>=20
>>> list_for_each_entry(entry, head, member) {
>>>      if (some_condition_checking(entry))
>>>          break;
>>> }
>>> do_something_with(entry);

There are other cases where the list iterator variable is used after the =
loop
Some examples:

- list_for_each_entry_continue() and list_for_each_entry_from().

- (although very rare) the head is actually of the correct struct type.
		(ppc440spe_get_group_entry(): =
drivers/dma/ppc4xx/adma.c:1436)

- to use pos->list for example for list_add_tail():
		(add_static_vm_early(): arch/arm/mm/ioremap.c:107)

If the scope of the list iterator is limited those still need fixing in =
a different way.

>>=20
>> Actually, we usually have a check to see if the loop found anything,
>> but in that case it should something like
>>=20
>> if (list_entry_is_head(entry, head, member)) {
>>     return with error;
>> }
>> do_somethin_with(entry);
>>=20
>> Suffice?  The list_entry_is_head() macro is designed to cope with the
>> bogus entry on head problem.
>=20
> That will work and is also what people already do.
>=20
> The key problem is that we let people do the same thing over and over =
again with slightly different implementations.
>=20
> Out in the wild I've seen at least using a separate variable, using a =
bool to indicate that something was found and just assuming that the =
list has an entry.
>=20
> The last case is bogus and basically what can break badly.
>=20
> If we would have an unified macro which search for an entry combined =
with automated reporting on patches to use that macro I think the =
potential to introduce such issues will already go down massively =
without auditing tons of existing code.

Having a unified way to do the same thing would indeed be great.

>=20
> Regards,
> Christian.
>=20
>>=20
>> James
>>=20
>>=20
>=20

- Jakob

