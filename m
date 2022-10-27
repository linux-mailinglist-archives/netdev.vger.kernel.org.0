Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40B260FDD1
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbiJ0Q70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbiJ0Q7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:59:25 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3E417F661
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:59:24 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i21so3833139edj.10
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SpeSASwy72MMgNgv5Lt2r9weSl95Mg/ZyoZWdp2bqkQ=;
        b=S5uBDi7lmdbA5qf28pQuOVN2WU/DlHyEUlfLEWMEvVenbGy5tyu9rCvIBlRDdwQBOv
         G5Lg5jRqrNhGVTJmS3opS10+x8SETPA9QwKAt6J2MFOQb5v04O4VQGPRc3tpT+pS55U/
         XipZV1Oc9s5jip3WnrZjm8sfaZcS3LGm1RZHLzkX1x3FRkjtsmV63qWOnq6Bph7K+3iQ
         ScLjgPjJIe+eZ1dMHOBKOo4Kqg7mrIMGx2OY7C2XZzxpWWvBgO9gcToeMAhr8ls1V8FC
         SXrSO0gYvGWL4IcgV6lM7k2Eem//ydikxQevTXAvJ/cYok3tPU+fbTafO5JA5JnBJTJG
         Jm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SpeSASwy72MMgNgv5Lt2r9weSl95Mg/ZyoZWdp2bqkQ=;
        b=e/Cg8MpdezdFQHSBEUO/nQ1Alfc08jKG6sLlfs5V1+n47cy5H+X4L1Jlatz0ZAOqkm
         HXSsuFMTTSRHyQDfTCVcFxmymKsyCg5v146AZVy8G4O7fMdz91Ev8Eck1SEa+uFPskql
         /aJk3w3b392y7oWeIdB+DSP4jbRLR4QhPmbbTUsXgsqY5ChOhSfj5PbGRW1xm65blrwJ
         m9Zc5ufd7V8Rv4F/0yN35pYcZyHgvGoLrQ2dYNY5DarUjavwl0ENXeaIvuUlFNg2qf8u
         1VZTRKEwSoGlZkIhbQLPrYB+Ht+SSh+Njbx/c+HPR50CwcsFT5rdBzcR1DhAU+99wcAp
         ODcQ==
X-Gm-Message-State: ACrzQf3RJVwIDYYHPOgj+Rd/mf/K5O9kEitlO7X8G57C6Qa9zURXI5kb
        EGqISM8FKPxLYd7QXuQsiIi00piKqZdh/dUoX+s=
X-Google-Smtp-Source: AMsMyM7btYoxf4PaclbH0b9+MSh53cRURY8sHdYJICXOLJ+ewuhcZES3yVLQG03KpEi1mwpcHLt5qzlcai/nE6K0ey8=
X-Received: by 2002:a05:6402:847:b0:453:944a:ba8e with SMTP id
 b7-20020a056402084700b00453944aba8emr45851006edz.326.1666889963111; Thu, 27
 Oct 2022 09:59:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221024175823.145894-1-saproj@gmail.com> <20221027113513.rqraayuo64zxugbs@skbuf>
In-Reply-To: <20221027113513.rqraayuo64zxugbs@skbuf>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Thu, 27 Oct 2022 19:59:11 +0300
Message-ID: <CABikg9z5uuo9qdcuR4p29Y6W=rGBQedUV4GWB2C+6=6APAtTNQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next] net: ftmac100: support mtu > 1500
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 at 14:35, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Sergei,
>
> On Mon, Oct 24, 2022 at 08:58:23PM +0300, Sergei Antonov wrote:
> > The ftmac100 controller considers packets >1518 (1500 + Ethernet + FCS)
> > FTL (frame too long) and drops them. That is fine with mtu 1500 or less
> > and it saves CPU time. When DSA is present, mtu is bigger (for VLAN
> > tagging) and the controller's built-in behavior is not desired then. We
> > can make the controller deliver FTL packets to the driver by setting
> > FTMAC100_MACCR_RX_FTL. Then we have to check ftmac100_rxdes_frame_length()
> > (packet length sans FCS) on packets marked with FTMAC100_RXDES0_FTL flag.
> >
> > Check for mtu > 1500 in .ndo_open() and set FTMAC100_MACCR_RX_FTL to let
> > the driver FTL packets. Implement .ndo_change_mtu() and check for
> > mtu > 1500 to set/clear FTMAC100_MACCR_RX_FTL dynamically.
> >
> > Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
> > Signed-off-by: Sergei Antonov <saproj@gmail.com>
> > ---
>
> I think it's clear there are problems in communication between us, so
> let me try differently.
>
> Does the attached series of 3 patches work for you? I only compile
> tested them.

I have tested your patches. They fix the problem I have. If they can
make it into mainline Linux - great. Thanks for your help!

A remark on 0002-net-ftmac100-report-the-correct-maximum-MTU-of-1500.patch:
I can not make a case for VLAN_ETH_HLEN because it includes 4 bytes
from a switch and ftmac100 is not always used with a switch.
