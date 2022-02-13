Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4814B3C39
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 17:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbiBMQLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 11:11:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbiBMQLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 11:11:47 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C031D5A0A8
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 08:11:37 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id t19so6445494vkl.0
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 08:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YaE9KVeLJ/5Adtm57P8/bYr9adrmqYlWKVBtPptHpg0=;
        b=BnUBgIsoNfCmefER+CDDQ+vZ2J3wvvyWrZv1yznju+NVG/qmRNFDD4GebCaI/W3+Zp
         KM9WlXsP6nQa283ux0ORpu3SpzU2/P7aLPV3CgeNrfdxhCOuzaJQlKB9HuUPMuMhbIrd
         mP/rBiyXep0S8rwnLuJQcV7EuzcKHh6zlDRqXomf+48G05U+vx0y9UDxDljIgTg+on9z
         9RZkCBnwy+LQY9yTN1zvHxsTVbqEHiPZM+SAw7AmzHXLy18/RPj4eiKdFo0O+hvGYn7y
         VNO2g39uZS5vbI0g1MMlOIFBYxxqrW1O4OAzs2tJNExNbhVQh6ES1Lc/cYgSnjaWsCRz
         t8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YaE9KVeLJ/5Adtm57P8/bYr9adrmqYlWKVBtPptHpg0=;
        b=P4jBQOgVLd9zcCne/FNhv/warYPQGQ5WRF1GVeTmmckVqUaoeONCEaKigmO8w46EDW
         kKNnIVncJmUftHNH83UHIuraC7dBvba7lscRSamLoHm3gt4uSpHeGAKEltcUIEG5KMFE
         d7sXTJ+lPSumhPXrYWcx4pD6PcINFzo0Jf51IWusP+LWD1JTlvMW5Vr8tZWh1R9yXwzV
         y02+EnGx+omAaFWBGIv7zPeZ+DBBVxAvAt+yj++5ipCLlfT1IOFpxRPkk79Uh2fkkrE+
         XEyoD8VLPbX7YgCYNXdxkJ2pvbmkkZJovmNwcBhjxdmaBnX/TY2WYvPFr2tc7akiVteY
         ugVA==
X-Gm-Message-State: AOAM531N/W6nDbK+yQycPHwk8yaws+W9v+RiBHMwwD0wcgjuB3pbEysX
        SCM5iZMGA1GpydmxdiiduXs4n1kDCMA=
X-Google-Smtp-Source: ABdhPJzVxpcjemkCwVxLX8LZNWGpwzxPu0kBEQb/LmsxRQJOLgLfDIvkZ9efH+N6JwHSC0v5VTuVBw==
X-Received: by 2002:a05:6122:1352:: with SMTP id f18mr539033vkp.27.1644768696558;
        Sun, 13 Feb 2022 08:11:36 -0800 (PST)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id w3sm5205466vkd.5.2022.02.13.08.11.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 08:11:36 -0800 (PST)
Received: by mail-vs1-f43.google.com with SMTP id t22so16165438vsa.4
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 08:11:35 -0800 (PST)
X-Received: by 2002:a67:cc14:: with SMTP id q20mr221043vsl.74.1644768695555;
 Sun, 13 Feb 2022 08:11:35 -0800 (PST)
MIME-Version: 1.0
References: <MWHPR2201MB1072BCCCFCE779E4094837ACD0329@MWHPR2201MB1072.namprd22.prod.outlook.com>
In-Reply-To: <MWHPR2201MB1072BCCCFCE779E4094837ACD0329@MWHPR2201MB1072.namprd22.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Feb 2022 11:10:58 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeY-GNfBCppjRwhWrOnUg9JDOaesjby2+QbuvPOO5g-=Q@mail.gmail.com>
Message-ID: <CA+FuTSeY-GNfBCppjRwhWrOnUg9JDOaesjby2+QbuvPOO5g-=Q@mail.gmail.com>
Subject: Re: BUG: potential net namespace bug in IPv6 flow label management
To:     "Liu, Congyu" <liu3101@purdue.edu>
Cc:     "security@kernel.org" <security@kernel.org>,
        "oss-security@lists.openwall.com" <oss-security@lists.openwall.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
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

On Sun, Feb 13, 2022 at 5:31 AM Liu, Congyu <liu3101@purdue.edu> wrote:
>
>
> Hi,
>
> In the test conducted on namespace, I found that one unsuccessful IPv6 flow label
> management from one net ns could stop other net ns's data transmission that requests
> flow label for a short time. Specifically, in our test case, one unsuccessful
> `setsockopt` to get flow label will affect other net ns's `sendmsg` with flow label
> set in cmsg. Simple PoC is included for verification. The behavior descirbed above
> can be reproduced in latest kernel.
>
> I managed to figure out the data flow behind this: when asking to get a flow label,
> some `setsockopt` parameters can trigger function `ipv6_flowlabel_get` to call `fl_create`
> to allocate an exclusive flow label, then call `fl_release` to release it before returning
> -ENOENT. Global variable `ipv6_flowlabel_exclusive`, a rate limit jump label that keeps
> track of number of alive exclusive flow labels, will get increased instantly after calling
> `fl_create`. Due to its rate limit design, `ipv6_flowlabel_exclusive` can only decrease
> sometime later after calling `fl_decrease`. During this period, if data transmission function
> in other net ns (e.g. `udpv6_sendmsg`) calls `fl_lookup`, the false `ipv6_flowlabel_exclusive`
> will invoke the `__fl_lookup`. In the test case observed, this function returns error and
> eventually stops the data transmission.
>
> I further noticed that this bug could somehow be vulnerable: if `setsockopt` is called
> continuously, then `sendmmsg` call from other net ns will be blocked forever. Using the PoC
> provided, if attack and victim programs are running simutaneously, victim program cannot transmit
> data; when running without attack program, the victim program can transmit data normally.

Thanks for the clear explanation.

Being able to use flowlabels without explicitly registering them
through a setsockopt is a fast path optimization introduced in commit
59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases
exist").

Before this, any use of flowlabels required registering them, whether
the use was exclusive or not. As autoflowlabels already skipped this
stateful action, the commit extended this fast path to all non-exclusive
use. But if any exclusive flowlabel is active, to protect it, all
other flowlabel use has to be registered too.

The commit message does state

    This is an optimization. Robust applications still have to revert to
    requesting leases if the fast path fails due to an exclusive lease.

Though I can see how the changed behavior has changed the perception of the API.

That this extends up to a second after release of the last exclusive
flowlabel due to deferred release is only tangential to the issue?

Flowlabels are stored globally, but associated with a netns
(fl->fl_net). Perhaps we can add a per-netns check to the
static_branch and maintain stateless behavior in other netns, even if
some netns maintain exclusive leases.
