Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E975A531E91
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiEWW0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiEWW0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:26:10 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C566212E
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 15:26:06 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e28so22631020wra.10
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 15:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ueCq5+dTj6j2yPNYsasO+cBMPLIwNOMj1I6QU8gFRMg=;
        b=Z7yEJy/N2gTlEQbAr5k2NwteV8l9KIjimZtAhoasUEzB9ppgypbhMkY0jGSmdKBT3I
         z2Vlj49NHB7YcTKJmv1M0xCsZoMxHbKqZu4cjWF+24ZoXoRjTb8+j6RiD39XEegUfGA8
         9cY3W9Tdyv3UUwjkXeMpl1eCndMk/AKSldBsE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ueCq5+dTj6j2yPNYsasO+cBMPLIwNOMj1I6QU8gFRMg=;
        b=I5fOH7QBQzGVn4XD19xpbBeusZjTWTyDaR9FUmWh0300AcBvwFzq//kVzxJjRrrGt6
         n95adnJcG4pahcq6i34xFTU4DRBI1lRd3SYVXc/8W2qTkSTOcgPk4M3L4sx6KyDosvyf
         HqYixUfoUamGI7jzJKXjZWsu7a2wF4gQr0PnhultW7GUDtQWSjNEqw9pQMoyphJiudqT
         wpp8h+xYf+414Dj+7lU7vFxdFrvdYAlt28B1D9d7ThMvk8Yn5/12cjequgTXonIStKHM
         o8uSQBEgV1YeMEaja1mUPRI685y/imKeMjo7Nj5FesFAqcVVFC9mCAMQkR6AhVM6Od94
         5oWw==
X-Gm-Message-State: AOAM532qadzPhWyWq56e7YWY/JqUj6jOwX9ARv2pGrApFLukicTNg5N0
        OIWfIo98OKQT6+ZB4qAh1o19KHY5Bu2tg+OkZLN7LZht
X-Google-Smtp-Source: ABdhPJzXPWHSihtrD6rjhJLffk6Kg48cDC7kXb+c+GvCBO+Gaz2Ij5Q+JUiK+Kcp4D36G0x093aCzEiTrPrYohUjiM8=
X-Received: by 2002:adf:e18f:0:b0:20e:6352:211d with SMTP id
 az15-20020adfe18f000000b0020e6352211dmr20641190wrb.606.1653344765206; Mon, 23
 May 2022 15:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220517092217.323060-1-joel@jms.id.au> <5630dd68ca5f31dafce3f92489761294ea589b16.camel@kernel.crashing.org>
In-Reply-To: <5630dd68ca5f31dafce3f92489761294ea589b16.camel@kernel.crashing.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 23 May 2022 22:25:52 +0000
Message-ID: <CACPK8Xd5BLiz1ePwzirtxLvSL8V8EGmJuxB0GmxyyqBRK9mSdQ@mail.gmail.com>
Subject: Re: [PATCH net v3] net: ftgmac100: Disable hardware checksum on AST2600
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Networking <netdev@vger.kernel.org>,
        David Wilder <wilder@us.ibm.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 May 2022 at 02:53, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> On Tue, 2022-05-17 at 18:52 +0930, Joel Stanley wrote:
> > The AST2600 when using the i210 NIC over NC-SI has been observed to
> > produce incorrect checksum results with specific MTU values. This was
> > first observed when sending data across a long distance set of
> > networks.
> >
> > On a local network, the following test was performed using a 1MB file
> > of random data.
>
> Can you double check with Aspeed what's going on there and whether
> there's a way to instead, identify the bad case in the TX path and do
> on-demand SW checksuming only in those cases ?

Keep in mind this is only for the NC-SI case, where the link is
limited to 100Mbit anyway.

I did some tests with the openbmc kernel; a v5.15 tree with whatever
options we have enabled there.

Averaging a few iperf3 runs I see about 92Mbit/s with hardware
checksumming enabled, and 90Mbit/s with it disabled. So we can see the
difference, and it would be good if Aspeed could find the root cause
so this only needs to be disabled when hitting the problematic path as
you say.

> Because disabling HW checksum will kill performances afaik... (doesn't
> it also end up disabling zero-copy and SG ?)

Not sure?

>
> Cheers,
> Ben.
>
> > On the receiver run this script:
> >
> >  #!/bin/bash
> >  while [ 1 ]; do
> >         # Zero the stats
> >         nstat -r  > /dev/null
> >         nc -l 9899 > test-file
> >         # Check for checksum errors
> >         TcpInCsumErrors=$(nstat | grep TcpInCsumErrors)
> >         if [ -z "$TcpInCsumErrors" ]; then
> >                 echo No TcpInCsumErrors
> >         else
> >                 echo TcpInCsumErrors = $TcpInCsumErrors
> >         fi
> >  done
> >
> > On an AST2600 system:
> >
> >  # nc <IP of  receiver host> 9899 < test-file
> >
> > The test was repeated with various MTU values:
> >
> >  # ip link set mtu 1410 dev eth0
> >
> > The observed results:
> >
> >  1500 - good
> >  1434 - bad
> >  1400 - good
> >  1410 - bad
> >  1420 - good
> >
> > The test was repeated after disabling tx checksumming:
> >
> >  # ethtool -K eth0 tx-checksumming off
> >
> > And all MTU values tested resulted in transfers without error.
> >
> > An issue with the driver cannot be ruled out, however there has been
> > no
> > bug discovered so far.
> >
> > David has done the work to take the original bug report of slow data
> > transfer between long distance connections and triaged it down to
> > this
> > test case.
> >
> > The vendor suspects this this is a hardware issue when using NC-SI.
> > The
> > fixes line refers to the patch that introduced AST2600 support.
> >
> > Reported-by: David Wilder <wilder@us.ibm.com>
> > Reviewed-by: Dylan Hung <dylan_hung@aspeedtech.com>
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
> > ---
> > v3 modifies the wrapping of the commit message.
> >
> > v2 updates the commit message with confirmation from the vendor that
> > this is a hardware issue, and clarifies why the commit used in the
> > fixes
> >
> >  drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> > b/drivers/net/ethernet/faraday/ftgmac100.c
> > index caf48023f8ea..5231818943c6 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -1928,6 +1928,11 @@ static int ftgmac100_probe(struct
> > platform_device *pdev)
> >       /* AST2400  doesn't have working HW checksum generation */
> >       if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
> >               netdev->hw_features &= ~NETIF_F_HW_CSUM;
> > +
> > +     /* AST2600 tx checksum with NCSI is broken */
> > +     if (priv->use_ncsi && of_device_is_compatible(np,
> > "aspeed,ast2600-mac"))
> > +             netdev->hw_features &= ~NETIF_F_HW_CSUM;
> > +
> >       if (np && of_get_property(np, "no-hw-checksum", NULL))
> >               netdev->hw_features &= ~(NETIF_F_HW_CSUM |
> > NETIF_F_RXCSUM);
> >       netdev->features |= netdev->hw_features;
>
