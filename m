Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAA0529DC6
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbiEQJUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244830AbiEQJUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:20:12 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2056A3A18A;
        Tue, 17 May 2022 02:20:01 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id r188-20020a1c44c5000000b003946c466c17so992954wma.4;
        Tue, 17 May 2022 02:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5/To3q1iix39r0lCQ+hhuwUqkdpFvOMo3ijNMqcdH64=;
        b=kiu/iECmQxpFDXj3H3uLLN100wIRqg8E8311/LlhcNSFiQmy18ebSvnt9ct+FVv6Zn
         hSt+mkPDxQDPhd/o+oBS7Rw8YazWmLE3uvixG85ukYIZoONIipM3R24UIpQe6FcU4T09
         oUqKxrJRbJ9J3YkxIT2iVYCSSYXqcsU2Z2Fjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5/To3q1iix39r0lCQ+hhuwUqkdpFvOMo3ijNMqcdH64=;
        b=49+y8WVNN63nxUJsGq+heXKJAvYSYG3Yt1dXcXOHRGEAsgbq6TvCoKZ270rGHhImwP
         2ALcbkczo75k0W4Vr7e6OVrEyHa+xplNWzoqdgYuBricjkKcoppGtwaK7p/jjZROaNMv
         jIYVqEHGwydgfVB/T8qZEQrtVMinRcPbuYNkLzXXlICrAuXBHnl/NRdn6PVPQSZaL06l
         EzXf3wgbSQctDtlCyqSMkAS9+TQ9xGSThreRbCAsgoKN+K/SCcrNEtECWiiBg4dDWS4C
         jdIF6QFZvYBMMvV1og7VAK2PKYRXIK8wyR1NgHVhpAyBkQwzwVHZpClOwc4v6hb6Af7N
         Oo3A==
X-Gm-Message-State: AOAM533dqy4ssaJfCzcXRH0cqeWFJ2uYp49kMt3IPkZWBF89G5p5SCev
        crFEapKKtHE+ZbngpwXc5/q9vmzFFjUIESAipRgpQVf35I4=
X-Google-Smtp-Source: ABdhPJy1rSqL48gyvRhmpjpN8GuHXjUytsXO0NGJntsr0tTAcsfAMsqLvBb8AQIyi9ayddqeP56N5IkuzIzJV/x8CEk=
X-Received: by 2002:a7b:cd82:0:b0:389:77ef:66d7 with SMTP id
 y2-20020a7bcd82000000b0038977ef66d7mr19878367wmj.171.1652779199500; Tue, 17
 May 2022 02:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220512231938.228651-1-joel@jms.id.au> <b6da2e5a-eb85-d3cf-d4c3-ca9c0f0c04a4@molgen.mpg.de>
In-Reply-To: <b6da2e5a-eb85-d3cf-d4c3-ca9c0f0c04a4@molgen.mpg.de>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 17 May 2022 09:19:47 +0000
Message-ID: <CACPK8XchZcjXjkhDEa=RnnbD3PycwM7Hu5x2tB3A4g0v4964_w@mail.gmail.com>
Subject: Re: [PATCH net v2] net: ftgmac100: Disable hardware checksum on AST2600
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        David Wilder <dwilder@us.ibm.com>,
        Networking <netdev@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        David Wilder <wilder@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
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

On Fri, 13 May 2022 at 05:11, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Joel,
>
>
> Am 13.05.22 um 01:19 schrieb Joel Stanley:
> > The AST2600 when using the i210 NIC over NC-SI has been observed to
> > produce incorrect checksum results with specific MTU values. This was
> > first observed when sending data across a long distance set of networks.
> >
> > On a local network, the following test was performed using a 1MB file of
> > random data.
> >
> > On the receiver run this script:
> >
> >   #!/bin/bash
> >   while [ 1 ]; do
> >          # Zero the stats
> >          nstat -r  > /dev/null
> >          nc -l 9899 > test-file
> >          # Check for checksum errors
> >          TcpInCsumErrors=$(nstat | grep TcpInCsumErrors)
> >          if [ -z "$TcpInCsumErrors" ]; then
> >                  echo No TcpInCsumErrors
> >          else
> >                  echo TcpInCsumErrors = $TcpInCsumErrors
> >          fi
> >   done
> >
> > On an AST2600 system:
> >
> >   # nc <IP of  receiver host> 9899 < test-file
> >
> > The test was repeated with various MTU values:
> >
> >   # ip link set mtu 1410 dev eth0
> >
> > The observed results:
> >
> >   1500 - good
> >   1434 - bad
> >   1400 - good
> >   1410 - bad
> >   1420 - good
>
> Sort the values? As some MTUs are good, should a allow list for these
> values be added?

No.

>
> > The test was repeated after disabling tx checksumming:
> >
> >   # ethtool -K eth0 tx-checksumming off
> >
> > And all MTU values tested resulted in transfers without error.
> >
> > An issue with the driver cannot be ruled out, however there has been no
> > bug discovered so far.
> >
> > David has done the work to take the original bug report of slow data
> > transfer between long distance connections and triaged it down to this
> > test case.
> >
> > The vendor suspects this this is a hardware issue when using NC-SI. The fixes line refers
> > to the patch that introduced AST2600 support.
>
> Please wrap the line after 75 characters.
>
> Can the problem be reproduced with QEMU?

It can not. If you wanted to try you could modify the model to corrupt
tx checksums, but I would consider this of limited value.

>
> > Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
> > Reported-by: David Wilder <wilder@us.ibm.com>
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
>
> Should the intel-wired-lan folks be put in Cc?

No, as all evidence points towards this being an AST2600 problem.

ASPEED did not report the issue relates to the i210 doing anything
wrong. The issue is not seen from the host PCIe interface, and the
i210 is in widespread use with other BMCs without issue.

>
> > ---
> > v2 updates the commit message with confirmation form the vendor that
>
> from
>
> > this is a hardware issue, and clarifes why the commit used in the fixes
>
> clarifies
>
> > tag was chosen.
> >
> >   drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
> >   1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> > index caf48023f8ea..5231818943c6 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -1928,6 +1928,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
> >       /* AST2400  doesn't have working HW checksum generation */
> >       if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
> >               netdev->hw_features &= ~NETIF_F_HW_CSUM;
> > +
> > +     /* AST2600 tx checksum with NC-SI is broken */
>
> Does ASPEED have an internal bug for this, so should there be new
> revisions of the AST2600, the bug can be fixed?

There are no plans to fix it that I'm aware of.

>
> > +     if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
> > +             netdev->hw_features &= ~NETIF_F_HW_CSUM;
> > +
>
> I would fancy a note or even warning about this hardware issue.

I don't see the need to clutter up the kernel logs.

We've had a similar workaround for the 2400 since support was added
for the aspeed part. It doesn't affect the operation of the system; in
fact it improves it as without this we see degraded throughput due to
retransmissions.

We have git history for detailed notes on why a change was made.

>
> >       if (np && of_get_property(np, "no-hw-checksum", NULL))
> >               netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
> >       netdev->features |= netdev->hw_features;
>
>
> Kind regards,
>
> Paul
