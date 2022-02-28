Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287EE4C6BCB
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 13:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbiB1MHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 07:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiB1MHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 07:07:41 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0329366634;
        Mon, 28 Feb 2022 04:07:02 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vz16so24389202ejb.0;
        Mon, 28 Feb 2022 04:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=mpq6EOSgaJN9TDHyutZ1vk7Ts/tQX7VWZG2tuQLEVnE=;
        b=P6Qm9QV+tKwfj02RvG70Y6RM578oBE7xk1h9xLRDl0Phoeno/cOg2X5jGG320h7a80
         51RqQzzCwbkind1CCh/PsD+YJ2xLuw3nTu9DY+Zris5SVOV1FI+8DsU52Jy5KlVydcNu
         G0XxThLJxiMxymk0pHTiYIUYA6Uj3RhvFK2FvOkFF3qdetV9R5zYggWzNl+ojj1OXKZf
         MkNjwD1Q29EHNb+3aSEEQSq9r3HlkkV49QyRIpbAEX1BAYg/I0l3VyVoctyp9PVfLMdm
         3mwm8jDaSc7WWe042oo4mIB/QOs4nHzHS6+i8MWcrLd/SBvvylJKxoeMQwrp3MTt3slq
         2wxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=mpq6EOSgaJN9TDHyutZ1vk7Ts/tQX7VWZG2tuQLEVnE=;
        b=24WWfqqnsD/NG+QE4WdFpI8Hjrqa5CE2WU/U8ebn0q1mJAegySmQ/ZWnYEZZ8D71w2
         k+tVwfwWIjHS1b9ZBn5zNVXe8ukYyQM7UpogSuFXiMXdthhAiWrzTvuFgTpZNIrr7nbu
         TLeFEtLJa7QjePoVd8+i5agQ3eyZt/cGtxKSY896LNVu+n7mo0pMFf6sIJuLBg5ZadY7
         leHLoMK/fqR74aYKgCQ/sHc7aGch5nlaYvLouPr+fo8llkAc72YG/FjB0e2Ab3ccX5XE
         MVAstfebV4dpbQkfVCAy2rT319DRYfRzM25fn+f+0rD7b68x5KvyloysC6ogE54LTVo6
         XFDw==
X-Gm-Message-State: AOAM532LmVJI0aV4Gyf3rxAPyMs86oCeWnUhGH+HHNnO7IG4of6kuNTI
        Sm4XOqSCnAQ6qQN519a5CTg=
X-Google-Smtp-Source: ABdhPJw3Wj1NaKaNlFGnSPXqnbDgppea1F4wGZoXZbWDfwDJgXssQhrPLcI1GM9ROPIg4DuPtt07Tg==
X-Received: by 2002:a17:907:248a:b0:6ce:e03c:e1df with SMTP id zg10-20020a170907248a00b006cee03ce1dfmr14689906ejb.258.1646050020495;
        Mon, 28 Feb 2022 04:07:00 -0800 (PST)
Received: from smtpclient.apple ([2a02:8109:9d80:3f6c:957a:1d13:c949:d1f3])
        by smtp.gmail.com with ESMTPSA id d23-20020a1709067a1700b006d0ebe4af89sm4282959ejo.20.2022.02.28.04.06.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Feb 2022 04:07:00 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <Yhyv42ONIxTj04mg@kroah.com>
Date:   Mon, 28 Feb 2022 13:06:57 +0100
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-sgx@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        bcm-kernel-feedback-list@broadcom.com, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kvm@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        v9fs-developer@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Content-Transfer-Encoding: 7bit
Message-Id: <79FCD5F4-0EBA-4E3F-8B3F-D450BBA10367@gmail.com>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com> <Yhyv42ONIxTj04mg@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
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



> On 28. Feb 2022, at 12:20, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> On Mon, Feb 28, 2022 at 12:08:18PM +0100, Jakob Koschel wrote:
>> If the list does not contain the expected element, the value of
>> list_for_each_entry() iterator will not point to a valid structure.
>> To avoid type confusion in such case, the list iterator
>> scope will be limited to list_for_each_entry() loop.
>> 
>> In preparation to limiting scope of a list iterator to the list traversal
>> loop, use a dedicated pointer to point to the found element.
>> Determining if an element was found is then simply checking if
>> the pointer is != NULL.
>> 
>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>> ---
>> arch/x86/kernel/cpu/sgx/encl.c       |  6 +++--
>> drivers/scsi/scsi_transport_sas.c    | 17 ++++++++-----
>> drivers/thermal/thermal_core.c       | 38 ++++++++++++++++++----------
>> drivers/usb/gadget/configfs.c        | 22 ++++++++++------
>> drivers/usb/gadget/udc/max3420_udc.c | 11 +++++---
>> drivers/usb/gadget/udc/tegra-xudc.c  | 11 +++++---
>> drivers/usb/mtu3/mtu3_gadget.c       | 11 +++++---
>> drivers/usb/musb/musb_gadget.c       | 11 +++++---
>> drivers/vfio/mdev/mdev_core.c        | 11 +++++---
>> 9 files changed, 88 insertions(+), 50 deletions(-)
> 
> The drivers/usb/ portion of this patch should be in patch 1/X, right?

I kept them separate since it's a slightly different case.
Using 'ptr' instead of '&ptr->other_member'. Regardless, I'll split
this commit up as you mentioned.

> 
> Also, you will have to split these up per-subsystem so that the
> different subsystem maintainers can take these in their trees.

Thanks for the feedback.
To clarify I understand you correctly:
I should do one patch set per-subsystem with every instance/(file?)
fixed as a separate commit?

If I understand correctly, I'll repost accordingly.

> 
> thanks,
> 
> greg k-h

thanks,
Jakob Koschel

