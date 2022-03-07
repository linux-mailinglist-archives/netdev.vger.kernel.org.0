Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F884D039D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbiCGQCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 11:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiCGQCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:02:38 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1130F8596D
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 08:01:43 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id w127so5243431oig.10
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 08:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0nnDTDhzMGHmwy5E7MgVgyhieP/+IA0Jjk2Cb6zWQVM=;
        b=wRboQgemZE55FYqHQ7fPYxknkPVO2PHGUBXGiDmcLV54wL0mFETe9cyrRY/l7dF4vK
         De3SSHZ0Hw/Mj6LB3m06iFbdq/Bam2WY4+0Lz63QOhSzP0YGwMY4iQ6wXUlXkPry08Vt
         PaRVCN+dZUdyv0Adx6OLyaKYh1i9Z2ZI76LZtxbyW8yv65Uhf5tq7PpyNYsbbaLy+UZG
         5tKgVVRceSqYuaaYcKgKZmko1oyriuTlD8Q/OuUo0FcPoiTP4m/oYRgGBGgrE0wCPktY
         dW8nDvXi1xLpzzihGB9hXxA6Xxvzxdgyi/MwmMxHWvkn+iEClEWNFW7Nd8L3kwHr2c1s
         y0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0nnDTDhzMGHmwy5E7MgVgyhieP/+IA0Jjk2Cb6zWQVM=;
        b=esGmi1UxMF7mXr3DuMrbL3j0dgpZO7fNw9R1M+nBNqAWMdGdGM95Ps8KAnaGG8d2wb
         IeK46enwwyx1sE90exDmC6knf9hNZlxIeMEwvsLBaeG4PcpbFn0sk9dVaJGhE2y1iN4P
         9VRvIQpeU2aE5nkHdvtds5cMPrxo0qAOeezzeggMcXVlQPhBQoH6nsO08zox8uurtXLy
         iQVxNLcfyN3rB1cM6qtIZxm0TRhRsxxVDOpIfmgyajsR3Vm2Jx1YaNxW8IAorQCc3MtL
         u4xL220yI0wH8yrUNdpCoCNKAo7mK5Q8FIopyMSLo5FewmiY22h9lpCwmpxulleKpcGi
         KPBw==
X-Gm-Message-State: AOAM530l9u4+jAYUS5SLi5IWI1R/eKBkIUTtEfx+sXc6JT+J+UU2s33V
        LGIzyoEsp0+tUWFEp/8SoelFMQj34362HbKKIQstlw==
X-Google-Smtp-Source: ABdhPJwpayzYTbVQyEQs9FS5rVuxrMEX8Qw1AvPHgwL2s9X7w4iINoISHUM/CN6jG5eLQz3jZsGWD6pgtgCCFiBtE+I=
X-Received: by 2002:aca:d803:0:b0:2d9:9259:515c with SMTP id
 p3-20020acad803000000b002d99259515cmr12419098oig.23.1646668902387; Mon, 07
 Mar 2022 08:01:42 -0800 (PST)
MIME-Version: 1.0
References: <20220306085658.1943-1-gerhard@engleder-embedded.com> <20220307120751.3484125-1-michael@walle.cc>
In-Reply-To: <20220307120751.3484125-1-michael@walle.cc>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Mon, 7 Mar 2022 17:01:31 +0100
Message-ID: <CANr-f5yFwmOSZVy7kTF=gV09LjreqLjRh-uMe4a+=C=Y3fQxpA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
To:     Michael Walle <michael@walle.cc>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        yangbo.lu@nxp.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From what I understand, you have a second PHC which is just a second
> PHC you cannot control; i.e. it is equivalent to a PHC in free running
> mode. This PHC will take the timestamps for the PTP frames. You can
> create multiple vclocks and you can use ptp4l to synchronize these.
>
> The first (controlable) PHC is used to do the Qbv scheduling, thus
> needs a synchronized time.
>
> How do you synchronize the vclock with this PHC? And how precise
> is it? I know that some cards can do cross timestamping in hardware
> to aid the synchronization (but I think that is not supported right
> now in linux).

There is no need to synchronize the first (controlable) PHC with the vclock.
A ptp4l instance is running and synchronizing the time for Qbv/TAPRIO.
vclocks are used for other time domains, which do not affect Qbv/TAPRIO.

> > You are adding eight bytes per frame for what is arguably an extreme
> > niche case.
>
> I don't think it is a niche case, btw. I was always wondering why
> NXP introduced the vclock thingy. And apparently it is for
> 802.1AS-rev, but one use case for that is 802.1Qbv and there you'll
> need a (synchronized) hardware clock to control the gates. So while
> we can have multiple time domain support with the vclock, we cannot
> use Qbv with them. That was something I have always wondered about.

I agree that most people using Linux have no interest in TSN. For the few
people who are interested in TSN, I assume using two time domains in
combination with Qbv/TAPRIO is a common goal. Is there anyone else who
wants to use two time domains in combination with Qbv/TAPRIO?

Gerhard
