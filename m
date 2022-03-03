Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FC34CB8DF
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 09:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiCCIbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 03:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiCCIbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 03:31:20 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA8F171850;
        Thu,  3 Mar 2022 00:30:35 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id z4so3886069pgh.12;
        Thu, 03 Mar 2022 00:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uLpTC29O7sSEzWIyhD1PQNyRAs1/upRhzEEBO0P7TrY=;
        b=R05ZV01Yp+GvJafCjJwp2DdNQL1X7N4+v2qDpWCUjxekJqjhV8nKttt+lgDdDv8VHZ
         pTpad4a62LLA8SjB/yHHEpNTxY0U28zfBa611uCN9ihzVETreTphlyPy+ETyTE4AgOSy
         RSp6pqcLA1mQfW+JjTEEtr3nMT+EN3gAPPB7pPpCIhAgeloFO+Vkph8Zctn11Qajj/U0
         QUVjSv6dTXzOO7akWefQCdrhFJznQKo01Wl+2crhxprXX9zSh/gHLWP/Xe3lMKAcW1nu
         BI3FrzUOW0QskfQ+hVH91vnr00ExY+gCD8VtMWG6RhFXS05x/6dGZMaR1NPNguf29zlo
         qAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uLpTC29O7sSEzWIyhD1PQNyRAs1/upRhzEEBO0P7TrY=;
        b=tX4Lvnprkbl55JgpIMGPwUYB3zl4weKQtUQYSCGebicA19Oo2euseaSt/seHhHgl0U
         WGEXF4Yq70OpGaJzdrRUdewFnJPKwyRe2hcmhELKOAaCQScpZMjVomIJ7EFgGxvhYEp3
         9HxQe4UlZmMPk4ZhvlJqwjvYVIunkaPltt23SQUu1FRGohEGvel7sT8VStEWsaxjfs5X
         viiLJUsV/Poav7kbPBu/1Hl2pXtDu+ktsOyqWkyiZbpO4/DOhJ/qeHIG5UgkeNYfEpB/
         i4SSxCqaL5X+skhojHCTmrD6wVTzE//JfLQc8R7q5KqW7Pfmirm/ksaw2x6Yi8IQw3cR
         RW+Q==
X-Gm-Message-State: AOAM533yIcrXrWD0e+qg8tCGwICNQuG2ezuK76KXrTeyZwEDIAawJ7rL
        tJd6y95jIfu3iOx5y5a6kN0=
X-Google-Smtp-Source: ABdhPJxl3tqNmXwEb6Rf4RyrJiQAiYb1f64m7AmzgvvLqhkGp3dQvJbj8a24YWybBg5gGNAc3KtcpA==
X-Received: by 2002:a63:8bca:0:b0:370:2717:3756 with SMTP id j193-20020a638bca000000b0037027173756mr29011952pge.604.1646296234811;
        Thu, 03 Mar 2022 00:30:34 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.19])
        by smtp.googlemail.com with ESMTPSA id d5-20020a17090acd0500b001b9c05b075dsm7342532pju.44.2022.03.03.00.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 00:30:34 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jakobkoschel@gmail.com
Cc:     David.Laight@ACULAB.COM, akpm@linux-foundation.org,
        alsa-devel@alsa-project.org, amd-gfx@lists.freedesktop.org,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de,
        bcm-kernel-feedback-list@broadcom.com, bjohannesmeyer@gmail.com,
        c.giuffrida@vu.nl, christian.koenig@amd.com,
        christophe.jaillet@wanadoo.fr, dan.carpenter@oracle.com,
        dmaengine@vger.kernel.org, drbd-dev@lists.linbit.com,
        dri-devel@lists.freedesktop.org, gustavo@embeddedor.com,
        h.j.bos@vu.nl, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, jgg@ziepe.ca,
        keescook@chromium.org, kgdb-bugreport@lists.sourceforge.net,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
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
Date:   Thu,  3 Mar 2022 16:30:07 +0800
Message-Id: <20220303083007.11640-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <A568BD90-FE81-4740-B1D3-C795EB636A5A@gmail.com>
References: <A568BD90-FE81-4740-B1D3-C795EB636A5A@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think this would make sense, it would mean you only assign the containing
> element on valid elements.
>
> I was thinking something along the lines of:
>
> #define list_for_each_entry(pos, head, member)					\
>	for (struct list_head *list = head->next, typeof(pos) pos;	\
>	     list == head ? 0 : (( pos = list_entry(pos, list, member), 1));	\
>	     list = list->next)
>
> Although the initialization block of the for loop is not valid C, I'm
> not sure there is any way to declare two variables of a different type
> in the initialization part of the loop.

It can be done using a *nested loop*, like this:

#define list_for_each_entry(pos, head, member)					\
	for (struct list_head *list = head->next, cond = (struct list_head *)-1; cond == (struct list_head *)-1; cond = NULL) \
	  for (typeof(pos) pos;	\
	     list == head ? 0 : (( pos = list_entry(pos, list, member), 1));	\
	     list = list->next)

>
> I believe all this does is get rid of the &pos->member == (head) check
> to terminate the list.

Indeed, although the original way is harmless.

> It alone will not fix any of the other issues that using the iterator
> variable after the loop currently has.

Yes, but I stick with the list_for_each_entry_inside(pos, type, head, member)
way to make the iterator invisiable outside the loop (before and after the loop).
It is maintainable longer-term than "type(pos) pos" one and perfect.
see my explain:
https://lore.kernel.org/lkml/20220302093106.8402-1-xiam0nd.tong@gmail.com/
and list_for_each_entry_inside(pos, type, head, member) patch here:
https://lore.kernel.org/lkml/20220301075839.4156-3-xiam0nd.tong@gmail.com/

--
Xiaomeng Tong
