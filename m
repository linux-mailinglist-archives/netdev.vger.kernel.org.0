Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC614C98EC
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238588AbiCAXMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238502AbiCAXMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:12:31 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5972C79397
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 15:11:46 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w3so23991981edu.8
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 15:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ojIOUCrgcIak8ZCc1skMdXRKcTVmt9Elm/o+1+I6jGA=;
        b=fmg4LXx5HRB2mrrWsHndl76rC2chdk1sBRQyNWtz+o2V+K2vg9psF6vr/ppax24roG
         0IEY6nkgVM6qwn95jhK4YeupoNeTj8/flkbxBQUDmf863ReCVguQlY3gsMWixLyIz8Mx
         ewpCP9yjbapnom8xtoCAmNy70uRnweYHKzlsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ojIOUCrgcIak8ZCc1skMdXRKcTVmt9Elm/o+1+I6jGA=;
        b=kkz6lzGM+7QlVI3Ijk2/V6zMp8Xl7nBDUBIlwvL+aCZw9j3KiT19U8vVR2H8whqQtm
         u0iy0ez7WMGPeHUIxlQ0uSS+yg5ysmW8oGhTX13Zx0hDkBGtNotNXKUx0IeK4fkUBfH8
         dww5zBkUuS+wC9/OFRUVmN7iMS2LvI0vawlsRfbpecfqkPtx/etNEvQAdw2oO8a4esEN
         sFGpN6glDJcgyj/Ue4vIlD+ETIA0UdJh4Zn5XHqqzd0jW1W1tx+KZF38rWuMXNrvzFBu
         NFcNYjxBJBnUPTUm7vOjGc2jXTmLjCOfdOAEveK63UfG8Va2jMM236Hl/0Qui4tZRxSp
         fgQA==
X-Gm-Message-State: AOAM532Q8cylefoJGaYXsyptV7nz2ULlAqPC2rVGJ1x763348qrAXUMI
        yp9flQYpaWzOVCElH3MpBA+x0XWwbTgF58CvA1Q=
X-Google-Smtp-Source: ABdhPJxafPGlM1BpaZIGSajUXTJzN8ETyuMbKexudk3aV8VNPJn+C+YsptUgpFVrhIyX0H0j4DEGlA==
X-Received: by 2002:a05:6402:4491:b0:413:162a:fc85 with SMTP id er17-20020a056402449100b00413162afc85mr26834389edb.115.1646176304739;
        Tue, 01 Mar 2022 15:11:44 -0800 (PST)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b006d2a835ac33sm5744963ejc.197.2022.03.01.15.11.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 15:11:44 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id gb39so98841ejc.1
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 15:11:44 -0800 (PST)
X-Received: by 2002:a2e:924d:0:b0:246:370c:5618 with SMTP id
 v13-20020a2e924d000000b00246370c5618mr18436468ljg.358.1646175815802; Tue, 01
 Mar 2022 15:03:35 -0800 (PST)
MIME-Version: 1.0
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com> <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <282f0f8d-f491-26fc-6ae0-604b367a5a1a@amd.com> <b2d20961dbb7533f380827a7fcc313ff849875c1.camel@HansenPartnership.com>
 <7D0C2A5D-500E-4F38-AD0C-A76E132A390E@kernel.org> <73fa82a20910c06784be2352a655acc59e9942ea.camel@HansenPartnership.com>
 <CAHk-=wiT5HX6Kp0Qv4ZYK_rkq9t5fZ5zZ7vzvi6pub9kgp=72g@mail.gmail.com> <7dc860874d434d2288f36730d8ea3312@AcuMS.aculab.com>
In-Reply-To: <7dc860874d434d2288f36730d8ea3312@AcuMS.aculab.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 1 Mar 2022 15:03:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whKqg89zu4T95+ctY-hocR6kDArpo2qO14-kV40Ga7ufw@mail.gmail.com>
Message-ID: <CAHk-=whKqg89zu4T95+ctY-hocR6kDArpo2qO14-kV40Ga7ufw@mail.gmail.com>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
To:     David Laight <David.Laight@aculab.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        KVM list <kvm@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 2:58 PM David Laight <David.Laight@aculab.com> wrote:
>
> Can it be resolved by making:
> #define list_entry_is_head(pos, head, member) ((pos) == NULL)
> and double-checking that it isn't used anywhere else (except in
> the list macros themselves).

Well, yes, except for the fact that then the name is entirely misleading...

And somebody possibly uses it together with list_first_entry() etc, so
it really is completely broken to mix that change with the list
traversal change.

             Linus

               Linus
