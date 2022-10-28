Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232BC6115C0
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 17:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJ1PWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 11:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJ1PWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:22:00 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7C860502
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 08:21:59 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id y14so13687907ejd.9
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 08:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+w2aEDOSR+JOX+EJZawq8U1HPGPeLB3ffjYIDo7sCWw=;
        b=E5ScmcB3Bxr2iIoAlxNT4k0bIEPTnIgAYh0BJ2wGLFxhSd2LB0qMeTYisPZlxTFyhu
         z70r5l8RD5PYMhq9FSkb8dNdVlFC+dUz1EZjE6S5RIgpxA+mk4A79gq8grQLyvPH7EXD
         aPdVp9Ec7WfaaLzfZgA0UoeQ7akE0GMcoHfXyocGCNN7AlyCup59ZEZsPQVJhohIU6w3
         6hwgXlm/dNJ1feULILXRtiSrUsSA96LaT9tU8eBrfTzlsehWFEws/JAzax6hFYYT4TVr
         bgtwGWiWik2tGQKtlO3LnyPHmwJ4dEmNYvP5DrPsxS1mxir2/e2RbsLhk1dwDcgW9M1J
         TOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+w2aEDOSR+JOX+EJZawq8U1HPGPeLB3ffjYIDo7sCWw=;
        b=Bo/m0ccxrpN398B31xCBIvxxsP7WVO7QfmAyWk/LynbSTqVGzhvMIrXF02wQDhK7vp
         fNhDATxNHk+CgalVzIq2AvJJk3WBrpOTbqP5qOL9xZZd7cPX7+pUh1iAlU9N4iEUahPH
         v/ke/o9tXpM6aqRAioDCqSJHaM88HC1eiYtLZr1ghaw/14bdOKOwlIuK9ThvRRBwlNvu
         nXpKdzJ34HRGeZSrM2E7mgOD8UKXjy27uygIVPo6JHybbXvqdQibcaLyOMI3eVZRFSUf
         XXRwB0sfJsWlBzuqu9Q2hqWT9oQDX40s72QosrsmF7n/o5RpA1QCPz8ecvj920NbZ1AT
         KuTQ==
X-Gm-Message-State: ACrzQf0hwVIdIpHMPFS6GlR0rqHGGz36Ccpx4AMkHSDQTq012UsNZr4r
        yPqjBShifuzpxKf/REbesn8VmyHQ/DLWoZHlCRw=
X-Google-Smtp-Source: AMsMyM5Blcn7NWBL5wZVbLjKPsScctEJZnOuWCouC0Uenm1R1KpYQsAL2/kySRSLpS/jMUqa3T2j77bQbGI75mwB+AA=
X-Received: by 2002:a17:906:da86:b0:740:7120:c6e6 with SMTP id
 xh6-20020a170906da8600b007407120c6e6mr47141232ejb.44.1666970518011; Fri, 28
 Oct 2022 08:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <20221024175823.145894-1-saproj@gmail.com> <20221027113513.rqraayuo64zxugbs@skbuf>
 <CABikg9z5uuo9qdcuR4p29Y6W=rGBQedUV4GWB2C+6=6APAtTNQ@mail.gmail.com> <20221027185447.kd6sqvf4xrdxis56@skbuf>
In-Reply-To: <20221027185447.kd6sqvf4xrdxis56@skbuf>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Fri, 28 Oct 2022 18:21:46 +0300
Message-ID: <CABikg9yjX1Zypr4pwp8jgZZsUiNxW1m271RonGK2ojuYjYHJ2A@mail.gmail.com>
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

On Thu, 27 Oct 2022 at 21:54, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Oct 27, 2022 at 07:59:11PM +0300, Sergei Antonov wrote:
> > On Thu, 27 Oct 2022 at 14:35, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > Does the attached series of 3 patches work for you? I only compile
> > > tested them.
> >
> > I have tested your patches. They fix the problem I have. If they can
> > make it into mainline Linux - great. Thanks for your help!
>
> Do you mind submitting these patches yourself, to get a better
> understanding of the process? You only need to make sure that you
> preserve the "From:" field (the authorship), and that below the existing
> Signed-off-by line, you also add yours (to make it clear that the
> patches authored by me were not submitted by me). Like this:
>
> | From: Vladimir Oltean <vladimir.oltean@nxp.com>
> |
> | bla bla
> |
> | Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com> <- same as author
> | Signed-off-by: Sergei Antonov <saproj@gmail.com> <- patch carried by X
> | ...etc
> | when patch is merged, the netdev maintainer adds his own sign off at
> | the end to indicate that the patch went through his own hands
>
> I would do the same if I was the one submitting the series; I would add
> my sign-off to patch 3/3, which has your authorship.

OK. I will do it.

> > A remark on 0002-net-ftmac100-report-the-correct-maximum-MTU-of-1500.patch:
> > I can not make a case for VLAN_ETH_HLEN because it includes 4 bytes
> > from a switch and ftmac100 is not always used with a switch.
>
> Why do you think that? What VLAN are you talking about? 802.1Q or
> 802.1ad? What VLAN ID? Where does it come from, where do you see it?

Patch 2 contains this change:
-       netdev->max_mtu = MAX_PKT_SIZE;
+       netdev->max_mtu = MAX_PKT_SIZE - VLAN_ETH_HLEN;

VLAN_ETH_HLEN is equal to 18 which is 6+6+4+2
It includes 4 bytes of 802.1Q.

> VLAN_ETH_HLEN in patch 2 has nothing to do with a switch.

OK then.
