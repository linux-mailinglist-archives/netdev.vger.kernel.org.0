Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4704E529DDC
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbiEQJVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244871AbiEQJVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:21:03 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04E964C9;
        Tue, 17 May 2022 02:20:56 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k126so10080105wme.2;
        Tue, 17 May 2022 02:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bcX3jvyky5Zk1BA9CMjUs4Jca7mrgBWVxkDo89CEHzg=;
        b=e+oQjDpVJTotBuHUxen0PIl62GNZJClBrr6ySobqIJkbmgE/BQHXpDYKaHDmJ6A2Bh
         CttzTVPFNmITqU31R8RPcoMY7kvQRjXEuAyj0ks2ifwICACW5p2do4LVrx40zoK0+ck6
         obqDGtSPvQmFvO88eBrDlGKe1UVPStbDzJqx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bcX3jvyky5Zk1BA9CMjUs4Jca7mrgBWVxkDo89CEHzg=;
        b=Odt0+xOQWKNOTU8S79jVeSFfTmgqrhDUsyY2EAJHu+ZSwdD964dQX1kmu/FdFfMoJb
         MLqLkKXVbHhrtBWJbNCQPuddrnw8X5wmwZ6OKvl+U2Y/Jf8UiJIh9g3tMpMIb6MJV8Ep
         tLrdvA6CUJDGzuqin7UiA53Dly7uZ1ztMOz1OaHW3Mtc33E/v2FfvCq0RiEzR2TTZgSk
         bu+WB1GCMhaTg02G0dcK2vPS5nZOVQsgxrmrMGSpo1XZ3fRcYGF6a5jujG5i7Aw+MGZK
         sYXJgERck5e5EeuBbORgzzcFZAz76OzWYR7E+WFtGlIKfk1CbY3R4hcD9hAtl2oNEzFG
         tKZA==
X-Gm-Message-State: AOAM531pD/kAE9zFGVCXrMstyXBkaxG+N2P9jdx3IvYAt8l3Xt19yDmo
        ZAwwxw1XoPLhFC4AQ4wDKRZlt5xqzTqb6THftzQ=
X-Google-Smtp-Source: ABdhPJxjyoMaplhahUMc5vmQunZ55IVRht20Aa1fvbTBU8WBhjMtVxgkuh1btiXLCak6T4vSnA5rC7RjSCAsl9k2dGk=
X-Received: by 2002:a05:600c:1c0e:b0:394:66af:ef0f with SMTP id
 j14-20020a05600c1c0e00b0039466afef0fmr30434678wms.48.1652779254607; Tue, 17
 May 2022 02:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220512231938.228651-1-joel@jms.id.au> <HK0PR06MB28341F811AD74F52ACA5D19B9CCA9@HK0PR06MB2834.apcprd06.prod.outlook.com>
In-Reply-To: <HK0PR06MB28341F811AD74F52ACA5D19B9CCA9@HK0PR06MB2834.apcprd06.prod.outlook.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 17 May 2022 09:20:41 +0000
Message-ID: <CACPK8XfS+orcdGxGtDy4_gjT9Za9B4umELVcWVYAJv1MWhV4qQ@mail.gmail.com>
Subject: Re: [PATCH net v2] net: ftgmac100: Disable hardware checksum on AST2600
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Wilder <dwilder@us.ibm.com>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Wilder <wilder@us.ibm.com>
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

On Fri, 13 May 2022 at 01:46, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
>
> > -----Original Message-----
> > From: joel.stan@gmail.com [mailto:joel.stan@gmail.com] On Behalf Of Joel
> > Stanley
> > Sent: Friday, May 13, 2022 7:20 AM
> > To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> > <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Benjamin
> > Herrenschmidt <benh@kernel.crashing.org>; Dylan Hung
> > <dylan_hung@aspeedtech.com>; David Wilder <dwilder@us.ibm.com>
> > Cc: openbmc@lists.ozlabs.org; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; David Wilder <wilder@us.ibm.com>
> > Subject: [PATCH net v2] net: ftgmac100: Disable hardware checksum on
> > AST2600
> >
> > The AST2600 when using the i210 NIC over NC-SI has been observed to
> > produce incorrect checksum results with specific MTU values. This was first
> > observed when sending data across a long distance set of networks.
> >
> > On a local network, the following test was performed using a 1MB file of
> > random data.
> >
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
> > An issue with the driver cannot be ruled out, however there has been no bug
> > discovered so far.
> >
> > David has done the work to take the original bug report of slow data transfer
> > between long distance connections and triaged it down to this test case.
> >
> > The vendor suspects this this is a hardware issue when using NC-SI. The fixes
> > line refers to the patch that introduced AST2600 support.
> >
> > Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle
> > property")
> > Reported-by: David Wilder <wilder@us.ibm.com>
> > Signed-off-by: Joel Stanley <joel@jms.id.au>

> Reviewed-by: Dylan Hung <dylan_hung@aspeedtech.com>

Thank you Dylan. I've added your r-b to v3, as the only changes are to
the wrapping of the commit message.
