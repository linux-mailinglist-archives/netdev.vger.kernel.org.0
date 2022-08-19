Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467FC5996E4
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347514AbiHSIMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347505AbiHSIM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:12:26 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12802E68DD
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:12:23 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-11c9af8dd3eso4086254fac.10
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=cQSR+3OwW66bL/nS6PZ8fmuUzlxpwPzl5GLk12L++BE=;
        b=dhjczcFZD9uMRMSTEAsOQlEi7ANt//Axc+kpli8A1OsayAGab/PMD8zD6L45LQl1EW
         tC8/n18mUVGLER5KifOKhcHwNRiIUjCLVZWyb37iwUHI/Kk4T3dQZbGCtHXR/gRSk9EJ
         A2f9UrKV2DueIzwdw8R3Gacgvp1+X1nu29dNzBTCQ0dmK6VNB9tYfd0/T0kVnNSAXN7q
         cdjaWAtxebk3UMeDCZs9t1ZPKS0Ktee8hCMxhj5afTMoOJys6p5iS9lhqjhvsiiQHHGi
         GYuimydAE6m8pyaL4TBuK/x4b/W5aJjq4s6KXsS9G5bnifNHPVb8qCMtlcX134HWCUcf
         7baw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=cQSR+3OwW66bL/nS6PZ8fmuUzlxpwPzl5GLk12L++BE=;
        b=z+/znI6zgFSQiITXMJbXxamTvqZwU0JPIyVyRXZzIyvivY9favhIcoCIOY4zcLGgZn
         Sk3d+kA4qlOIGe2geLoxyTnC/XSbT9aQSQgb/qJ78AqZy9Qgf0srf//s4opFGAZnsn7X
         LzK69VWliis1KrRvas0G2BP+K5VLsuTiT2FyVZML51cIacGPkdxaNKXjOqFgaWP92diX
         g+OkgPm69FhpJafHDCn+90+bevQXDiUZjYH6X8mWY7z634C/JxnyUBlzR07hBHPGPuls
         bJPTS2elaUERJQyXXzHET2+PlI+3PLVl6HOUdbGBpgz8JLNXuS7eotEPVc7OdtVNaaSw
         b9kA==
X-Gm-Message-State: ACgBeo1uOF0aBIIuuETMRCxKySihFhpI0pjFswtZIZpvX5oDwZeUw0mn
        ycWfL6uuQYfHuwIkugs6AtA8/RvFu8OQc+f0LuM=
X-Google-Smtp-Source: AA6agR7gaRCBuwNkplFXdVpD4hOje2wKLoGgNN6HXIpBCPUJkTNl56uYIUxaw526atiL4ChdFrAQMylzbGmhQn08m7k=
X-Received: by 2002:a05:6870:8984:b0:10d:d981:151f with SMTP id
 f4-20020a056870898400b0010dd981151fmr5917397oaq.212.1660896742443; Fri, 19
 Aug 2022 01:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220818182948.931712-1-saproj@gmail.com> <20220818182948.931712-2-saproj@gmail.com>
 <Yv6SiQgzKSRL1Zy6@lunn.ch>
In-Reply-To: <Yv6SiQgzKSRL1Zy6@lunn.ch>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Fri, 19 Aug 2022 11:12:11 +0300
Message-ID: <CABikg9zym9rzcP+uabijRwuWa9NC5pQPp+bMbPFZFBSsVOX2Lg@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: moxa: prevent double-mapping of DMA areas
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 at 22:27, Andrew Lunn <andrew@lunn.ch> wrote:
> > Unmap RX memory areas in moxart_mac_stop(), so that moxart_mac_open()
> > will map them anew instead of double-mapping. To avoid code duplication,
> > create a new function moxart_mac_unmap_rx(). Nullify unmapped pointers to
> > prevent double-unmapping (ex: moxart_mac_stop(), then moxart_remove()).
>
> This makes the code symmetric, which is good.
>
> However, moxart_mac_free_memory() will also free the descriptors,
> which is not required. moxart_remove() should undo what the probe did,
> nothing more.

Having considered your comments, I now think I should make another
patch, which fixes two problems at once. To unmap DMA areas only in
moxart_mac_stop() and not in moxart_remove(). It will fix error
unwinding during probe and double-mapping on link down, link up. It
will be correct if Linux always calls moxart_mac_stop() before calling
moxart_remove().
