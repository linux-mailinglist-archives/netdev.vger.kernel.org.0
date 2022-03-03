Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52A94CBDFE
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 13:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbiCCMil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 07:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbiCCMig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 07:38:36 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179C340A1E;
        Thu,  3 Mar 2022 04:37:48 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z2so4410135plg.8;
        Thu, 03 Mar 2022 04:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FF/MJjppdIPbLAPuX69GDDcuetlfqDD+38vpsQJKjV4=;
        b=bORDDPjE3HJ8Q+lkuHUI9YXm2z2OfuiHyYo73LjCVUqKH+mzapaLyTx7j6vUSzodyH
         H1fbBW3W0VvnP5bKsE/Cw0qa3UKie6z+yV023jD/NJPLY9kKDIxXXIT7NvpcVUCfUtIs
         KFg6MVSLFINqOtsOfPJChC2DDL1HsjgJIQ8T87wI93Fz/8cIhc43z3LdnIXEJu5YqpzN
         mnmxIpvlp/TKF5EWx4k9hHupAU2T1e2iVIXLRuFiSvdgN4U8XMzx7dalBaWhuU90/nq+
         yD0rNidPjh7VKui8oE8v/Ywp+ZPTs/OvJCCqJBXBdG8sdbvMpiVPMu/2SHGpauCCE/Ok
         XUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FF/MJjppdIPbLAPuX69GDDcuetlfqDD+38vpsQJKjV4=;
        b=5nmLDPdt4158KChLD7ZNId285UqdJIJg11uAueR32aF7hOqlaYWbUvnmXZpM/JktUK
         1qvgKYbYiTRkWHI5gTGarJSXkv/BPsY02qYjIyaKu5D1VoFhfQK3OfOvvBA1mitkp1pl
         PHdB5t5bp1FMJUVOAH0K8EpBEK1rG15MNH4CTtmiib6Vw4Pr7eykcIDH7EDZNF9GTY6z
         II2zykestbe6hJIjCaKLuZLX/2vbbnq4OYS/ayY74gRe/rgTtqZBgMurHZQMjy38p/aF
         qArR0GkBo8iuzNewabyxKOYNjpfwJ8HcLGIyXlRseL3hv363FaX+5Gl48VoKpzYF3kmL
         oM/A==
X-Gm-Message-State: AOAM530wAj2kNlYNbl2xdlwDu3GliNRaOBAj8yqWQoWLLlVxSGhp9Yd4
        BQspS3STPlljfAwrfky5Csc=
X-Google-Smtp-Source: ABdhPJwaQutGx29a4puPWhBgOBT74prgxxfsvHgGuVwO/yqGuQ+dVL8XCd59bWLeDERLYwR3js66yQ==
X-Received: by 2002:a17:903:22d0:b0:151:97f5:db54 with SMTP id y16-20020a17090322d000b0015197f5db54mr7837971plg.58.1646311068298;
        Thu, 03 Mar 2022 04:37:48 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.19])
        by smtp.googlemail.com with ESMTPSA id t7-20020a17090a024700b001bf12386db4sm1483030pje.47.2022.03.03.04.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 04:37:47 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     david.laight@aculab.com
Cc:     akpm@linux-foundation.org, alsa-devel@alsa-project.org,
        amd-gfx@lists.freedesktop.org, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bcm-kernel-feedback-list@broadcom.com,
        bjohannesmeyer@gmail.com, c.giuffrida@vu.nl,
        christian.koenig@amd.com, christophe.jaillet@wanadoo.fr,
        dan.carpenter@oracle.com, dmaengine@vger.kernel.org,
        drbd-dev@lists.linbit.com, dri-devel@lists.freedesktop.org,
        gustavo@embeddedor.com, h.j.bos@vu.nl,
        intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
        jakobkoschel@gmail.com, jgg@ziepe.ca, keescook@chromium.org,
        kgdb-bugreport@lists.sourceforge.net, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-block@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux@rasmusvillemoes.dk,
        linuxppc-dev@lists.ozlabs.org, nathan@kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        rppt@kernel.org, samba-technical@lists.samba.org,
        tglx@linutronix.de, tipc-discussion@lists.sourceforge.net,
        torvalds@linux-foundation.org,
        v9fs-developer@lists.sourceforge.net, xiam0nd.tong@gmail.com
Subject: RE: [PATCH 2/6] treewide: remove using list iterator after loop body as a ptr
Date:   Thu,  3 Mar 2022 20:37:18 +0800
Message-Id: <20220303123718.12426-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <2d208771c50b4c6db4f43039e9d62851@AcuMS.aculab.com>
References: <2d208771c50b4c6db4f43039e9d62851@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Xiaomeng Tong
> > Sent: 03 March 2022 07:27
> > 
> > On Thu, 3 Mar 2022 04:58:23 +0000, David Laight wrote:
> > > on 3 Mar 2022 10:27:29 +0800, Xiaomeng Tong wrote:
> > > > The problem is the mis-use of iterator outside the loop on exit, and
> > > > the iterator will be the HEAD's container_of pointer which pointers
> > > > to a type-confused struct. Sidenote: The *mis-use* here refers to
> > > > mistakely access to other members of the struct, instead of the
> > > > list_head member which acutally is the valid HEAD.
> > >
> > > The problem is that the HEAD's container_of pointer should never
> > > be calculated at all.
> > > This is what is fundamentally broken about the current definition.
> > 
> > Yes, the rule is "the HEAD's container_of pointer should never be
> > calculated at all outside the loop", but how do you make sure everyone
> > follows this rule?
> > Everyone makes mistakes, but we can eliminate them all from the beginning
> > with the help of compiler which can catch such use-after-loop things.
> > 
> > > > IOW, you would dereference a (NULL + offset_of_member) address here.
> > >
> > >Where?
> > 
> > In the case where a developer do not follows the above rule, and mistakely
> > access a non-list-head member of the HEAD's container_of pointer outside
> > the loop. For example:
> >     struct req{
> >       int a;
> >       struct list_head h;
> >     }
> >     struct req *r;
> >     list_for_each_entry(r, HEAD, h) {
> >       if (r->a == 0x10)
> >         break;
> >     }
> >     // the developer made a mistake: he didn't take this situation into
> >     // account where all entries in the list are *r->a != 0x10*, and now
> >     // the r is the HEAD's container_of pointer.
> >     r->a = 0x20;
> > Thus the "r->a = 0x20" would dereference a (NULL + offset_of_member)
> > address here.
> 
> That is just a bug.
> No different to failing to check anything else might 'return'
> a NULL pointer.

Yes, but it‘s a mistake everyone has made and will make, we should avoid
this at the beginning with the help of compiler.

> Because it is a NULL dereference you find out pretty quickly.

AFAIK，NULL dereference is a undefined bahavior, can compiler quickly
catch it? Or it can only be applied to some simple/restricted cases.

> The existing loop leaves you with a valid pointer to something
> that isn't a list item.
> 
> > > > Please remind me if i missed something, thanks.
> > > >
> > > > Can you share your "alternative definitions" details? thanks!
> > >
> > > The loop should probably use as extra variable that points
> > > to the 'list node' in the next structure.
> > > Something like:
> > > 	for (xxx *iter = head->next;
> > > 		iter == &head ? ((item = NULL),0) : ((item = list_item(iter),1));
> > > 		iter = item->member->next) {
> > > 	   ...
> > > With a bit of casting you can use 'item' to hold 'iter'.
> > 
> > you still can not make sure everyone follows this rule:
> > "do not use iterator outside the loop" without the help of compiler,
> > because item is declared outside the loop.
> 
> That one has 'iter' defined in the loop.

Oh, sorry, I misunderstood. Then this is the same way with my way of
list_for_each_entry_inside(pos, type, head, member), which declare
the iterator inside the loop.
You go further and make things like "&pos->member == (head)" goes away
to avoid calculate the HEAD's container_of pointer, although the
calculation is harmless.

> 
> > BTW, to avoid ambiguity，the "alternative definitions" here i asked is
> > something from you in this context:
> > "OTOH there may be alternative definitions that can be used to get
> > the compiler (or other compiler-like tools) to detect broken code.
> > Even if the definition can't possibly generate a working kerrnel."
> 
> I was thinking of something like:
> 	if ((pos = list_first)), 1) pos = NULL else
> so that unchecked dereferences after the loop will be detectable
> as NULL pointer offsets - but that in itself isn't enough to avoid
> other warnings.
> 

Do you mean put this right after the loop (I changed somthing that i
do not understand, please correct me if i am worng, thanks):
       if (pos == list_first) pos = NULL; else
and compiler can detect the following NULL derefernce?
But if the NULL derefernce is just right after the loop originally,
it will be masked by the *else* keyword。

> > > > The "list_for_each_entry_inside(pos, type, head, member)" way makes
> > > > the iterator invisiable outside the loop, and would be catched by
> > > > compiler if use-after-loop things happened.
> > 
> > > It is also a compete PITA for anything doing a search.
> > 
> > You mean it would be a burden on search? can you show me some examples?
> 
> The whole business of having to save the pointer to the located item
> before breaking the loop, remembering to have set it to NULL earlier etc.

Ok, i see. And then you need pass a "item" to the list_for_each_entry macro
as a new argument.

> 
> It is so much better if you can just do:
> 		if (found)
> 			break;
> 
> 	David

this confused me. this way is better or the "save the pointer to the located item
before breaking the loop" one?

--
Xiaomeng Tong
