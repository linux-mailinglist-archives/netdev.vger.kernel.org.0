Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9814CB4F1
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 03:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiCCC2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 21:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiCCC2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 21:28:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B340D10FC6;
        Wed,  2 Mar 2022 18:27:53 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso6464723pjj.2;
        Wed, 02 Mar 2022 18:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C6016/38QKZUQAyk5HMPjenTvm42Pe8sPBzTcqL5vmY=;
        b=qBGtve+IuFrAkJa+gsN1WQjHRs2fvQkSK1D44BenBKAqsyswWIPF49CjeAw6Lc/Xiz
         7VY9uX10GWOeYOq3Roffx9lK59MGCnSnWmLkHD6Zz3XGADMqQbIXFAspvzlfyt7tl87F
         C44YITS/y0gKUKqqxM42VKL4jH/Xx4KasojD++jZOWXtcwkx1m//DlSoFwhQEbp4i/NS
         eGEaCL2abI9d2Qo/vgVE47lljuFHl9RIsYb9haWI9DYl1+oIMHXMK3O9uyeK26H4D1AX
         Jy4saNgfSyFkb5FP8pbKE6ds3BSqIpGBCoZu+qijzq/vfSl1dGYXTnehjmH9/ySByi+z
         BIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C6016/38QKZUQAyk5HMPjenTvm42Pe8sPBzTcqL5vmY=;
        b=CzJtZPcuhcWcftaDgdBMfTH8+c9EoS3XmQ505LWS57kdN7/Y7hxiGiFhGCtkVhWR4n
         9QiYMg9DgjK+2U+OgCUW8Ihc/Zsz1tArsI+VPvsbHeizYXBDN8PT/Evowom4DSVx5ZKW
         SbKPrObrC5eMgExacIP+ZPEND4qx5Us+NJQ0WRDXPRpYk5m/o2sqMuwebEko7dN7/HEk
         eAq5ky/UWz0+SWqk5EOcM1gkci5Yts4Pn4Ct+p/tQQvAT2EONElmTfre57WvwdfOJKPi
         0JSo3Tr1FuDqKJWi6MM1A+v0Yqa4E2WoDAES5x9cgi/rm9pPbPuEvHVBoD12sn5e/d+j
         6agg==
X-Gm-Message-State: AOAM531YwoKciGKl5/xB3iguH9sB6KyY7W/Y8igN4n9GDfpUTuo8ZSvU
        LuwF03lr62QEMLGgZKYD3hLDUsWYyg5BSQ==
X-Google-Smtp-Source: ABdhPJwdGKGtPoJbq9KB0b78P8kOQOqlHazHAUCZQHvA6TzNHcldJErwW75BUHOqmaVxrll88UvLqQ==
X-Received: by 2002:a17:902:ec90:b0:151:a632:7ebb with SMTP id x16-20020a170902ec9000b00151a6327ebbmr1936164plg.154.1646274473191;
        Wed, 02 Mar 2022 18:27:53 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.19])
        by smtp.googlemail.com with ESMTPSA id d15-20020a17090ab30f00b001b8e65326b3sm359822pjr.9.2022.03.02.18.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 18:27:52 -0800 (PST)
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
Date:   Thu,  3 Mar 2022 10:27:29 +0800
Message-Id: <20220303022729.9321-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <1077f17e50d34dc2bbfdf4e52a1cb2fd@AcuMS.aculab.com>
References: <1077f17e50d34dc2bbfdf4e52a1cb2fd@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Mar 2022 14:04:06 +0000, David Laight
<David.Laight@ACULAB.COM> wrote:
> I think that it would be better to make any alternate loop macro
> just set the variable to NULL on the loop exit.
> That is easier to code for and the compiler might be persuaded to
> not redo the test.

No, that would lead to a NULL dereference.

The problem is the mis-use of iterator outside the loop on exit, and
the iterator will be the HEAD's container_of pointer which pointers
to a type-confused struct. Sidenote: The *mis-use* here refers to
mistakely access to other members of the struct, instead of the
list_head member which acutally is the valid HEAD.

IOW, you would dereference a (NULL + offset_of_member) address here.

Please remind me if i missed something, thanks.

> OTOH there may be alternative definitions that can be used to get
> the compiler (or other compiler-like tools) to detect broken code.
> Even if the definition can't possibly generate a working kerrnel.

The "list_for_each_entry_inside(pos, type, head, member)" way makes
the iterator invisiable outside the loop, and would be catched by
compiler if use-after-loop things happened.

Can you share your "alternative definitions" details? thanks!

--
Xiaomeng Tong
