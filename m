Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388D3589A5B
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 12:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiHDKTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 06:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236633AbiHDKTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 06:19:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DC313AB31
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 03:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659608372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5Nv1h1SyP2iBl2S152j/TDD0jGgpMU8IZekv0TFglm0=;
        b=M0DEH5y7mKLPiKtqqGdIsDuvNjtI6Jiayq7++R+RII1iOv9eSy1JKK8J2zXCwZDHeBZnKT
        fR0oRITEl1kQOeghji1qRjOaZl+TdJN5tcSg0P+ZI9m9qLGDGIOHgMwzMC742iXseXARo4
        fuOFoy+PdC6wcnx0CIzF8QEee27n2No=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-sUBN6nsUMaexmIcxgiUb8Q-1; Thu, 04 Aug 2022 06:19:30 -0400
X-MC-Unique: sUBN6nsUMaexmIcxgiUb8Q-1
Received: by mail-wm1-f71.google.com with SMTP id v130-20020a1cac88000000b003a4f057ed9fso2629494wme.7
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 03:19:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:organization:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc;
        bh=5Nv1h1SyP2iBl2S152j/TDD0jGgpMU8IZekv0TFglm0=;
        b=60FPXmz07Nb08XNl859aP6+DudxtjLYlOoXyhl6sCaI9Ke2g6josChK7R3yuGyCIWF
         ZXGcZwq9voLmewtPUddFesZlBEbyHBFvoDHD+qc7bMtQIYny2UK/+k1Idwi/c0ahOCFG
         SYDNB7R12tX9cfpmmB0YNTGxD71+LyQnhiS71gXZRq1I6TXe0YR2XjooFyYOAndwyFJz
         t7gSYtLEqtuZYLCscf78ARQvl4rlU4e8TgVmbKe7tLKFJ7qDC0fEgtp4h4hxSw2O/DBX
         ON0T1J8R9RF3E+X8kWYFMkoQvCd7HKf1JYjoQDEC/7HXWHazYhntFC4lOF1ksup6Ew/l
         oBmg==
X-Gm-Message-State: ACgBeo1J/73BebKH2uU5L2jIOgJ86A0T4HSAKDRjTwutYFMQYO6hTkJK
        UjxzQkSMXMDJn9O/eLY1eMLL+0TfcKclIjt/F74RQ/gAKOlzHeZoihP2lN+fqpwwc0XasCGtB60
        jrOeb5EOPv3HLRN84
X-Received: by 2002:a05:6000:60a:b0:220:62ec:4f2b with SMTP id bn10-20020a056000060a00b0022062ec4f2bmr901955wrb.313.1659608369453;
        Thu, 04 Aug 2022 03:19:29 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4oeFugAFjjlS9dJqxPj0JJbpVxEJWtLgnAOoVji/wu5ahsrvDUV3ndZBMS0++Kbkhc8Jhlnw==
X-Received: by 2002:a05:6000:60a:b0:220:62ec:4f2b with SMTP id bn10-20020a056000060a00b0022062ec4f2bmr901949wrb.313.1659608369196;
        Thu, 04 Aug 2022 03:19:29 -0700 (PDT)
Received: from 0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa (0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:ffda:0:2059:8730:b2:c370])
        by smtp.gmail.com with ESMTPSA id n19-20020a05600c3b9300b003a38606385esm13533649wms.3.2022.08.04.03.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 03:19:28 -0700 (PDT)
Message-ID: <9351fc12c5acc7985fc2ab780fe857a47b7d9610.camel@redhat.com>
Subject: DECnet - end of a era!
From:   Steven Whitehouse <swhiteho@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Christine caulfield <ccaulfie@redhat.com>
Date:   Thu, 04 Aug 2022 11:19:27 +0100
Organization: Red Hat UK Ltd
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've just spotted the thread about dropping DECnet support from the
kernel - apologies for being a bit slow here as somehow the initial
announcement missed me.

I think it is definitely time for this to happen. It has been broken
now for several kernel versions, and as mentioned on another thread,
there is no iproute2 support any more, so there is no way to configure
it in user space anyway.

Do people still use DECnet? Definitely! I had a request only a few
weeks ago from someone asking advice on which vintage of the code to
use. On the other hand the number of users must be very very small, and
they must all be using older kernel/distro versions since the more
recent versions are non-functional. All the users I've been aware of
were actively looking to move away from it as soon as they reasonably
could.

Nobody has stepped up to maintain the code over a long period now, so I
think it has reached the point where removal is the only sensible
option. Still, it would be shame to let that happen without mentioning
some of the applications to which we have, over the time it was
functional, that people have used it for...

 - Satellite comms (when the other end of the link is in orbit, it is
expensive to replace it!)
 - Railways (I don't know for exactly what purpose!)
 - Industrial Control
 - Remote Sensing (again the remote end of the link was very expensive
to replace/update!)
 - X-Windows
 - DECnet to IP gateways

I originally looked into starting a Linux DECnet project because my
then employer used a lot of DEC VAX machines and I thought it might
help the popularity of Linux if people had an easy migration path! I
has started working from the available docs, but there were a few gaps.
Luckily Eduardo Marcelo Serrat had also begun some work at around the
same time and was able to supply the missing pieces of that puzzle, as
we combined our efforts.

Chrissie Caulfield put in a heroic effort on the userland side
(although we all contributed bits to both kernel & userland) and we had
a working stack! I don't remember any of the timings, so I've no idea
of the three of us who started first, but we all somehow found each
other and were able to collaborate together on the project.

Of course many others have contributed over the years, and we had a lot
of support from the Linux network developers too. Many thanks to all
who've helped along the way, we very much appreciate all the assistance
that we've had. Alan Cox provided initial encouragement, with Davem and
Alexey Kuznetsov later on, and with contributions from many quarters
which were very gratefully received.

Farewell to the Linux DECnet stack :-)

Steve.


