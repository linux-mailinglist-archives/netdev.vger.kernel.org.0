Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C94D21EB
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 20:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349897AbiCHTuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 14:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242618AbiCHTuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 14:50:12 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5053A5C6
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 11:49:15 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id b5so12160001ilj.9
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 11:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2O69C/SqsM11PvkClNCprXB3cui8118XEFQs0JHJHdc=;
        b=DDjYcsfg/LDm3UQsLwA5Vg0KLpHBiYdqf1mIV79B2M7bcHjz32ti7vOlIszNomCFv1
         ZMlFTlaKnQRSPauMD+vUdxT2GPthZ+3DX7wXJbLmiWh4sfyLAYOe+2T0GNmT0jf1OLyF
         2DwrlIoORWN8Ub340N4YR/XiNxEwxXxy73XnCY7P7oeY3jwwAOVaxpfEKib5FdloKoFF
         Dg0L8I3KLeQ57eLu/iwIVTBPyZOk0vkyN5pJ5X3/pcpJxaujrnygK8EPseiVrhwFbFpp
         16FoDywN7Pn1w3ZUbcVHfUjWfdNV2CF33jmrWJCq9cgPRPLzWc0/cxeyEujVoMF5U/MU
         di5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2O69C/SqsM11PvkClNCprXB3cui8118XEFQs0JHJHdc=;
        b=sPh5ipGqyc7Za/kW6lU32rIDHLjpzyIgqwG14LsRMn3zsNKY6VjxAzuMwxCiEyQGsn
         IKKLuo4udQb3eNqAzSN86yJGKYXkLSd+BfOEYzBYHT9C29BMczXN6h2+yIFh2KctKqor
         rny9+FgvXFjg6IogeaMyFwYuA3w4SF382XuOpWtzRoMq+txP2ZHtl4kRI7dXTuR26QKV
         GdJVgUC24VzFcxppHnrNZxmAtV60lptxVFXU7TO7durf6vYGzxRUsNfCEqMAka8wgbqy
         S8SA68bQCxnv6zJ3QS2ALKo/Xzvs8BQMj5A+UKbgOJ+TUa++aDAtqsQpquEgQIZIzme+
         GzZg==
X-Gm-Message-State: AOAM531xJX8P6w068NhXgEXbo0qU/jCrDGFeFTt347i6Kj2nXuyEqH1n
        4N9op/1Pcl4Ob/XSYpanNWg78lgy8SmbwpndLjQTWg==
X-Google-Smtp-Source: ABdhPJyKFg3qBP/JW+LHiMNw1eYwvEVOYHJus63z6BBe/c76LEeRXQKLKAmIs9VH6rSAwGkL2XpVXtJNCq3s9IknEDo=
X-Received: by 2002:a92:8e43:0:b0:2ba:cde1:8215 with SMTP id
 k3-20020a928e43000000b002bacde18215mr16672808ilh.78.1646768954863; Tue, 08
 Mar 2022 11:49:14 -0800 (PST)
MIME-Version: 1.0
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306170504.GE6290@hoboy.vegasvil.org> <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
 <20220306215032.GA10311@hoboy.vegasvil.org> <20220307143440.GC29247@hoboy.vegasvil.org>
 <CANr-f5zyLX1YAW+D4AJn2MBQ8g7e8F+KVDc0GuxL7s9K89Qx_A@mail.gmail.com> <20220308005523.GB6994@hoboy.vegasvil.org>
In-Reply-To: <20220308005523.GB6994@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 8 Mar 2022 20:49:03 +0100
Message-ID: <CANr-f5yecFHG9mjRTd4aKBNzKgVV_tbZ4VAKXkMe2qxAMb66Gg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > ktime_to_cycles uses hwtstamp as key for the cache lookup. As long as
> > the PHC is monotonic, the key is unique. If the time of the PHC is set, then
> > the cache would be invalidated. I'm afraid that setting the PHC could lead to
> > wrong or missing timestamps. Setting the PHC in hardware, timestamp
> > generation in hardware, and cache invalidation in software would need to
> > be synchronized somehow.
>
> You can avoid errors even with a time jump:
>
> Make a variant (union) of skb_shared_hwtstamps to allow driver to
> provide an address or cookie instead of ktime_t.  Set a flag in the
> skbuff to signal this.
>
> Let the Rx path check the flag and fetch the time stamp by callback
> with the address/cookie.
>
> > For TX it is known which timestamp is required. So I would have to find a way
> > to detect which timestamp shall be filled into hwtstamp.
>
> How about tx_flags in struct skb_shared_info ?

I will try to make an implementation!

Shall I use tx_flags in struct skb_shared_info for both, TX and RX? Or should
I use flags in struct skb_shared_info for address/cookie signalisation?

3 of 8 flags are unused in tx_flags. It may be possible to use the same flag for
TX and RX. Is it worth it trying to save flags?

For TX it signals "fill cycle based timestamp" and could be called
SKBTX_HW_CSTAMP.

For RX it signals "hwtstamp is an address/cookie" and could be called
SKBFL_TSTAMP_COOKIE.

Thank you!
Gerhard
