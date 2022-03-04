Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C784CCE3A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbiCDHBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbiCDHBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:01:12 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AF318E3DF;
        Thu,  3 Mar 2022 23:00:21 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id t187so2483135pgb.1;
        Thu, 03 Mar 2022 23:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0a+oQu3LYTAbOOyoILb+F/zkApGIum0yjd+xPCLEHo4=;
        b=UcHSzcmMAevEFsqxc8gimvoSIew96LrW3UYvjfgkcaeLb/Edql9668oTELTgMdhcyh
         uwTLYgNgPfuwuQfZCbkLtuIX59UkP2xXrD0mK6eOfNdOu/KSihdjQUFHL7gwAFzgpb4Z
         PeSQfhLMwS3uLkuXfSSL1QQyblGTA4kTyWBkcty1viz6EkWmIbbGn99xu95lY6jAsJ0c
         CbisDo/RPFGn8gAJnKluj00ht4OQ80XaXmCEvGalnXTnvAWrV5UWFfWh6kgUBnLZJvSQ
         W0PYU136vUwP4grvjJEIhDxHc0WM1lPQ2cysIXPjh+breTQ07tU9AM0RgZ3Jr4UsSFjT
         NaGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0a+oQu3LYTAbOOyoILb+F/zkApGIum0yjd+xPCLEHo4=;
        b=wb2esMQoam0yRdU1iiWooJMh4JC1GjnRkNWIV6OwsjoezbD+7+ifd1PhuzPjaxCPmO
         u1fcrH6eLHtxqL4KDTLuseNeth97iCChifcBxeofjvT0Byq082mjxQBMfKUbi4/3XunZ
         7O1vtdoC6GJQEe1jCXtEwSzf90DWRIWVtkfFAhBCXU/4JQ9/KiwbJufulDJ2q3IPax49
         jtXkkkenH5kmYciK/w/TThMkCF+OMj+Sm8kubeVraTrTJ9SBcdzW0IJc/7q7VtLNcYPK
         tCqru2KpLGaD7gEtqsW5aTHIjrKYId6o+E8n1FslfMQUFX2avWIb0/I/Jx8Qwp0u0z7d
         d27Q==
X-Gm-Message-State: AOAM532aXFpfPfPgP0BGzvfNmwbT3nDlpYgI2HlLyy0AbUqKoKxKSL90
        x6bmOo7yTyt/Z10hh54ZEPQ=
X-Google-Smtp-Source: ABdhPJxBFOb3A6C/RlDh1uHGrWM51HjSkR68cXfNAhNGErUbSC2hd/FilwMHkJmidt1eEHAWD7GVrA==
X-Received: by 2002:a05:6a00:cc7:b0:4ec:c6f3:ad29 with SMTP id b7-20020a056a000cc700b004ecc6f3ad29mr41958698pfv.66.1646377221067;
        Thu, 03 Mar 2022 23:00:21 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.19])
        by smtp.googlemail.com with ESMTPSA id f6-20020a654006000000b00346193b405fsm3665134pgp.44.2022.03.03.23.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 23:00:20 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     daniel.thompson@linaro.org
Cc:     akpm@linux-foundation.org, alsa-devel@alsa-project.org,
        amd-gfx@lists.freedesktop.org, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bcm-kernel-feedback-list@broadcom.com,
        bjohannesmeyer@gmail.com, c.giuffrida@vu.nl,
        christian.koenig@amd.com, christophe.jaillet@wanadoo.fr,
        dan.carpenter@oracle.com, david.laight@aculab.com,
        dmaengine@vger.kernel.org, drbd-dev@lists.linbit.com,
        dri-devel@lists.freedesktop.org, gustavo@embeddedor.com,
        h.j.bos@vu.nl, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, jakobkoschel@gmail.com,
        jgg@ziepe.ca, keescook@chromium.org,
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
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body as a ptr
Date:   Fri,  4 Mar 2022 14:59:57 +0800
Message-Id: <20220304065957.16799-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220303121824.qdyrognluik74iph@maple.lan>
References: <20220303121824.qdyrognluik74iph@maple.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Mar 2022 12:18:24 +0000, Daniel Thompson wrote:
> On Thu, Mar 03, 2022 at 03:26:57PM +0800, Xiaomeng Tong wrote:
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
> 
> Your formulation of the rule is correct: never run container_of() on HEAD
> pointer.

Actually, it is not my rule. My rule is that never access other members
of the struct except for the list_head member after the loop, because
this is a invalid member after loop exit, but valid for the list_head
member which just is HEAD and the lately caculation (&pos->head) seems
harmless.

I have considered the case that the HEAD's container "pos" is layouted
across the max and the min address boundary, which means the address of
HEAD is likely 0x60, and the address of pos is likely 0xffffffe0.
It seems ok to caculate pos with:
((type *)(__mptr - offsetof(type, member)));
and it seems ok to caculate head outside the loop with:
if (&pos->head == &HEAD)
    return NULL;

The only case I can think of with the rule "never run container_of()
on HEAD" must be followed is when the first argument (which is &HEAD)
passing to container_of() is NULL + some offset, it may lead to the
resulting "pos->member" access being a NULL dereference. But maybe
the caller can take the responsibility to check if it is NULL, not
container_of() itself.

Please remind me if i missed somthing, thanks.

> 
> However the rule that is introduced by list_for_each_entry_inside() is
> *not* this rule. The rule it introduces is: never access the iterator
> variable outside the loop.

Sorry for the confusion, indeed, that is two *different* rule.

> 
> Making the iterator NULL on loop exit does follow the rule you proposed
> but using a different technique: do not allow HEAD to be stored in the
> iterator variable after loop exit. This also makes it impossible to run
> container_of() on the HEAD pointer.
> 

It does not. My rule is: never access the iterator variable outside the loop.
The "Making the iterator NULL on loop exit" way still leak the pos with NULL
outside the loop, may lead to a NULL deference.

> 
> > Everyone makes mistakes, but we can eliminate them all from the beginning
> > with the help of compiler which can catch such use-after-loop things.
> 
> Indeed but if we introduce new interfaces then we don't have to worry
> about existing usages and silent regressions. Code will have been
> written knowing the loop can exit with the iterator set to NULL.

Yes, it is more simple and compatible with existing interfaces. Howerver,
you should make every developers to remember that "pos will be set NULL on
loop exit", which is unreasonable and impossible for *every* single person.
Otherwise the mis-use-after-loop will lead to a NULL dereference.
But we can kill this problem by declaring iterator inside the loop and the
complier will catch it if somebody mis-use-after-loop.

> 
> Sure it is still possible for programmers to make mistakes and
> dereference the NULL pointer but C programmers are well training w.r.t.
> NULL pointer checking so such mistakes are much less likely than with
> the current list_for_each_entry() macro. This risk must be offset
> against the way a NULLify approach can lead to more elegant code when we
> are doing a list search.
> 

Yes, the NULLify approach is better than the current list_for_each_entry()
macro, but i stick with that the list_for_each_entry_inside() way is best
and perfect _technically_.

Thus, my idea is *better a finger off than always aching*, let's settle this
damn problem once and for all, with list_for_each_entry_inside().

--
Xiaomeng Tong
