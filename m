Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EA2688B7A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 01:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbjBCAKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 19:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjBCAKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 19:10:30 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA61751A1
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 16:10:30 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so2812331pjp.0
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 16:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aqReDpiBBbc+Aj6xunkXh0rIFe9l7OobdgB+XKwyf/o=;
        b=KIWdjT0i6GCW7wy/ytlalUUqlle07AWSUlG2+apOFScccgs4vHcmGAoQn2hSQ6xZxS
         pmsU8XCC3Zj9j17Yz3QZX1kL+Ax6kLLHBm6WWrw4q0u6Dk9IXTcQ0pSWpZwzbzm0OpqP
         lVQalTyugttVjpt5gh8QmsXwgPT+kTAPRi6eRAtKrCYrcSa0wsQtq08UMcLyfZEAJfxi
         jc+G8d9BJcSJqGld2VKq+YKaxq8pw9KuE0BN9o0B1CqKNkQv1eJkIODGUt7KsuvI0iMU
         jvblGlID1bSJ+Huyd9tVY1pCnhEAPTQ3VQwjB1vT6/+wLBfiJWG7OJhsyF9rorzGN70u
         NFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aqReDpiBBbc+Aj6xunkXh0rIFe9l7OobdgB+XKwyf/o=;
        b=HjIm4QyNo0IqgZyRr5Kq46jTESHu3bLynNzy31OdOddDQ6ojTJM7BQwpKQ0wyzoyVg
         xh/NxWeqcb+T8Kyyzi0goHx0RwqH78SFkj07uqTUJ0I3jBMLXvH4M2gkQHwMTG2fF9TF
         F0aMGUSfO6UebV7zCx4ta3eXo0Z1ujOBGPkcdhH8eJqm1Ff8+SnvvJAsocvwsWoUCuFY
         HsGLTo8qf6qIQzRsj5q0s2pgfl7X/dSOcsprwGl+P0sfVKNO0ShoxOIncm9HlLSczh7/
         jXXT6SFkOw9qSVQejaBeoMbQqPTGtjl8bkl+6e/zh/hDf3CoHIAlV2gmHiUVo80oiznM
         c4LA==
X-Gm-Message-State: AO0yUKXxtPM0G/IxAF0MtwZVz8FgWo6wAN11WBI35J+5L4H27PRDBDO/
        SyIVj5dBzk7rlLT1KEBy3dE=
X-Google-Smtp-Source: AK7set/5VnhFuOsrkkW+fL46Pa07+Nr7lKh1lPzthse2M9TnzKND8Fma9oYazQfqzxgB2a0o4a7dLg==
X-Received: by 2002:a17:903:1111:b0:196:ea4:c261 with SMTP id n17-20020a170903111100b001960ea4c261mr9428823plh.1.1675383029497;
        Thu, 02 Feb 2023 16:10:29 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w12-20020a63b74c000000b004f1e73b073bsm348450pgt.26.2023.02.02.16.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 16:10:28 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:10:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        netdev@vger.kernel.org, yangbo.lu@nxp.com,
        gerhard@engleder-embedded.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alex.maftei@amd.com,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: PTP vclock: BUG: scheduling while atomic
Message-ID: <Y9xQ8ikvkWjjuw2p@hoboy.vegasvil.org>
References: <69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com>
 <Y9vly2QNCxl3d2QL@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y9vly2QNCxl3d2QL@localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 05:33:15PM +0100, Miroslav Lichvar wrote:
> On Thu, Feb 02, 2023 at 05:02:07PM +0100, Íñigo Huguet wrote:
> > Our QA team was testing PTP vclocks, and they've found this error with sfc NIC/driver:
> >   BUG: scheduling while atomic: ptp5/25223/0x00000002
> > 
> > The reason seems to be that vclocks disable interrupts with `spin_lock_irqsave` in
> > `ptp_vclock_gettime`, and then read the timecounter, which in turns ends calling to
> > the driver's `gettime64` callback.
> 
> The same issue was observed with the ice driver:
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20221107/030633.html
> 
> I tried to fix it generally in the vclock support, but was not
> successful. There was a hint it would be fixed in the driver. I'm not
> sure what is the best approach here.

Can ptp_vclock_gettime use a mutex instead?

Thanks,
Richard
