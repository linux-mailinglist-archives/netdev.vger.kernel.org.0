Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663F54CB7B9
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 08:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiCCH2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 02:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiCCH2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 02:28:08 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A109C16DAE4;
        Wed,  2 Mar 2022 23:27:22 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so2947354pju.2;
        Wed, 02 Mar 2022 23:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sgLnwuYIGskFjie2H2jjPO7yZK5PfHYTTkrYtctc5ws=;
        b=FXSRJXcZ2cyaSSh+RFzgN891/0EsPjQQYnYlHyt7Q6au+u55Yhw9CQjtuc/Xh+IxeA
         jmfOE8xDuyw6aNjCCweSWK23ooxkZ+FDp1vmELSXGe87/BlE9lQAJ5VCHRxCoJXheQ6e
         z0ZjBk6ntNVuChDJjKVkipnrg4PFzEOabNhKEpFBHr+LTEWxBydNvmRMp4x1CJuZdUwr
         yIPtetuwCR4pZCzLE6nNdjkyjeKTi+kDUarqoW7jVGs3qBeY6IJUgMC1jfObzr57dlqg
         9D3LdaczFYPoymDULVGPmDhvRiVgHdjXQ/LS1xahv5fAEYKipZZ05ntIAVBo2UMKI5ki
         Sw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sgLnwuYIGskFjie2H2jjPO7yZK5PfHYTTkrYtctc5ws=;
        b=xfCfx0luRxF8Bwa80CSNnpCbKiODpZI2Sa+Cl8h5y0cldPiwa/Eh5RS/paMRgGuSOb
         N8zgVlDngJOZxefa38Qnyq2+CoqSjIA+wm0YERAvVhwVj0DW19VALk4XkCknGQRIHnjb
         uXTUo0oKlDPCz589lQWCuBYMtu04UMvalo5pGvyI9GcWg/+r2r3ddBXtWiOGhB34aaSi
         sg6gpJpBk9oKwhQ141ewJoUyzaczBR/5PAs28gQ2SMgdhDxCRQg9skbsTZstNY4xW/Ul
         oTllXgcLLHqfQOmvwF4GjWcmUjwoRJGfR0m6iOCQTRxrUP/tVOKQetGTcy/F2kU0QKGP
         HlsA==
X-Gm-Message-State: AOAM533ngPpNPjEMDo+OdX7PXb4FAjkVbynWfciAFRwlrJbdUIewMqjM
        /igPBGeaVoTOB0ygoO/aqHo=
X-Google-Smtp-Source: ABdhPJxXZq8uo59Ohm7FMpyCTbKfTT1earKguyYxXh9VkI02LjxK1/LHoatHqlibGa3Ordge+YwobQ==
X-Received: by 2002:a17:902:9687:b0:151:7b31:9a57 with SMTP id n7-20020a170902968700b001517b319a57mr13723244plp.146.1646292442145;
        Wed, 02 Mar 2022 23:27:22 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.19])
        by smtp.googlemail.com with ESMTPSA id nu18-20020a17090b1b1200b001bbef4d9049sm1302089pjb.23.2022.03.02.23.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 23:27:21 -0800 (PST)
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
Date:   Thu,  3 Mar 2022 15:26:57 +0800
Message-Id: <20220303072657.11124-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <39404befad5b44b385698ff65465abe5@AcuMS.aculab.com>
References: <39404befad5b44b385698ff65465abe5@AcuMS.aculab.com>
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

On Thu, 3 Mar 2022 04:58:23 +0000, David Laight wrote:
> on 3 Mar 2022 10:27:29 +0800, Xiaomeng Tong wrote:
> > The problem is the mis-use of iterator outside the loop on exit, and
> > the iterator will be the HEAD's container_of pointer which pointers
> > to a type-confused struct. Sidenote: The *mis-use* here refers to
> > mistakely access to other members of the struct, instead of the
> > list_head member which acutally is the valid HEAD.
>
> The problem is that the HEAD's container_of pointer should never
> be calculated at all.
> This is what is fundamentally broken about the current definition.

Yes, the rule is "the HEAD's container_of pointer should never be
calculated at all outside the loop", but how do you make sure everyone
follows this rule?
Everyone makes mistakes, but we can eliminate them all from the beginning
with the help of compiler which can catch such use-after-loop things.

> > IOW, you would dereference a (NULL + offset_of_member) address here.
>
>Where?

In the case where a developer do not follows the above rule, and mistakely
access a non-list-head member of the HEAD's container_of pointer outside
the loop. For example:
    struct req{
      int a;
      struct list_head h;
    }
    struct req *r;
    list_for_each_entry(r, HEAD, h) {
      if (r->a == 0x10)
        break;
    }
    // the developer made a mistake: he didn't take this situation into
    // account where all entries in the list are *r->a != 0x10*, and now
    // the r is the HEAD's container_of pointer. 
    r->a = 0x20;
Thus the "r->a = 0x20" would dereference a (NULL + offset_of_member)
address here.

> > Please remind me if i missed something, thanks.
> >
> > Can you share your "alternative definitions" details? thanks!
>
> The loop should probably use as extra variable that points
> to the 'list node' in the next structure.
> Something like:
> 	for (xxx *iter = head->next;
> 		iter == &head ? ((item = NULL),0) : ((item = list_item(iter),1));
> 		iter = item->member->next) {
> 	   ...
> With a bit of casting you can use 'item' to hold 'iter'.

you still can not make sure everyone follows this rule: 
"do not use iterator outside the loop" without the help of compiler,
because item is declared outside the loop.

BTW, to avoid ambiguity，the "alternative definitions" here i asked is
something from you in this context:
"OTOH there may be alternative definitions that can be used to get
the compiler (or other compiler-like tools) to detect broken code.
Even if the definition can't possibly generate a working kerrnel."

> > 
> > > OTOH there may be alternative definitions that can be used to get
> > > the compiler (or other compiler-like tools) to detect broken code.
> > > Even if the definition can't possibly generate a working kerrnel.
> > 
> > The "list_for_each_entry_inside(pos, type, head, member)" way makes
> > the iterator invisiable outside the loop, and would be catched by
> > compiler if use-after-loop things happened.

> It is also a compete PITA for anything doing a search.

You mean it would be a burden on search? can you show me some examples?

Or you mean it is too long the list_for_each_entry_inside* string to live
in one single line, and should spilt into two line? If it is the case, there
are 2 way to mitigate it.
1. pass a shorter t as struct type to the macro
2. after all list_for_each_entry macros be replaced with
list_for_each_entry_inside, remove the list_for_each_entry implementations
and rename all list_for_each_entry_inside use back to the origin
list_for_each_entry in a single patch.

For me, it is acceptable and not a such big problem.

--
Xiaomeng Tong
