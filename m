Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D330E525976
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357500AbiEMBiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiEMBiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:38:12 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752696B7C1;
        Thu, 12 May 2022 18:38:11 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2ef5380669cso75666257b3.9;
        Thu, 12 May 2022 18:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CL1Of/HmkjJyCcKptsJlpH4syhIJ9Nzwuv+dfbFpKSM=;
        b=FqG/3JJm0DvA+76k6SwpM656G9p1m9Rh7Zcolw4aQWHAOq2qoIBFSuX/b80wmZyL8r
         u4e1qNPZLAW8kfP/5rH4HVssWm0au7d5EsxeUTJoLPIGJnqnoRsQAl8xa4L/TgRUOkhP
         +sDbg6SMbI1lnQLxgu+eVj9HTirED5GjnkcH7ufwskTtrLXKsYhm4NG93u+6qsMAnVYG
         v0gU/qg/AHuCDq7pdUQHjJ87LF3cgmd1cWUJvkvqzRDRTS/aq4j+urB2bpZuJlLfQOvF
         i5VxYp/5FqjSh14f/o93lpBfwI5hqYI72ggv//q6AcmykFOcC5erKJnMqA3sbJUN+FT+
         +h5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CL1Of/HmkjJyCcKptsJlpH4syhIJ9Nzwuv+dfbFpKSM=;
        b=dazqrC+UOYfes8LRDftPxcH16X8q88DPFnmBHwi7V+T6KuQcgOUuqQgRmCjoAjZnLG
         voiuljxiGX2CZCgqxQ0v1WF3auXg6hMxFie479JrDirD2cfBhDmPRPsFBCJ7pZRdU8DO
         CLJFM8Z9/+OS02bxqbV/SDj3vKAauFIoA4C/HYKEHnJzeIj3ajTOiLYEvZjiNALFa1sH
         Yu23TUpZjOvfZwrQnrJoJtxdF7FWW89RfvoO9OPNAAWeOdi25P+kJGMy7Mk+Yrk5nZ45
         1ThAd60yVR8Sri87N2aPt1DvbKTclunb/rA20+Lf0NsTclPYZcykBbDxsk7ff6SQuy77
         X98w==
X-Gm-Message-State: AOAM530QcVNh20P8oMyo5K1Gt20g16sSV8yBbyeh05FSb4kUfOzjOdBo
        jjGoea9QTopBSZN7meIVacs7/t4Bm0Adb93hJxI=
X-Google-Smtp-Source: ABdhPJxMk2IF7qvEu0lg8/O1ZUUq8N8/6u/jFYBC0V+YTXtOhTg6BMbHiMAjmwxXR4LCJh28cgcGYJgZ7iXnMvyK7TE=
X-Received: by 2002:a81:2dc5:0:b0:2f5:c6c8:9ee5 with SMTP id
 t188-20020a812dc5000000b002f5c6c89ee5mr3185698ywt.518.1652405890688; Thu, 12
 May 2022 18:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220512135901.1377087-1-srinivas.neeli@xilinx.com> <CAMZ6Rq+z69CTY6Ec0n9d0-ri6pcyHtKH917M1eTD6hgkmyvGDQ@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+z69CTY6Ec0n9d0-ri6pcyHtKH917M1eTD6hgkmyvGDQ@mail.gmail.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Fri, 13 May 2022 10:37:59 +0900
Message-ID: <CAMZ6RqLfDRearE9+UuH+bPC0EX5-ZKVmw3i9Tz3Q3rHMzQDHJw@mail.gmail.com>
Subject: Re: [PATCH] can: xilinx_can: Add Transmitter delay compensation (TDC)
 feature support
To:     Srinivas Neeli <srinivas.neeli@xilinx.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, appana.durga.rao@xilinx.com, sgoud@xilinx.com,
        michal.simek@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
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

On Fri. 13 May 2022 at 10:24, Vincent Mailhol <vincent.mailhol@gmail.com> wrote:
> On Fri. 13 May 2022 at 07:30, Srinivas Neeli <srinivas.neeli@xilinx.com> wrote:
[...]
>                        btr0 = btr0 |
>                        priv->can.tdc.tdco << XCAN_BRPR_TDCO_SHIFT |
>                       XCAN_BRPR_TDC_ENABLE

Actually, you can use |= operator:

                        btr0 |= priv->can.tdc.tdco << XCAN_BRPR_TDCO_SHIFT |
                       XCAN_BRPR_TDC_ENABLE
