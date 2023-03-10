Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807816B374B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCJH1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCJH1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:27:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFF3107D65;
        Thu,  9 Mar 2023 23:27:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1487CE26C7;
        Fri, 10 Mar 2023 07:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DA8C433EF;
        Fri, 10 Mar 2023 07:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678433226;
        bh=EObO0GfPUqc7ltHIHmh0Y8AYbHGRqd53SM8I+etahGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QxBJZgOR8AgQHVEpqjww/B1p0OEp9XJ4oxivJuy2Q8khNR7rg9Sy23IUYzUf1idd0
         IAxRsYiaIHCl+qK+NISI1Pja2JbhZRIV1/Vx8PrGrsVo6dQJRdFazcYA8HohU/dOin
         zS7H5A5vAOyy2Vhzwn8S1m8c4/G1ilAfWWVByqkyC6QSzJbb7DtANEE4e92Eds5cIm
         ihdyI3X5GI4JtqRYYJlZoA2mp//SRt65DGpZt0OkgjWEr7OFn7+g1yjBRO7No2QcOs
         uY7Yg5aODv2W5iI5xLQ2RWcPq6QoP7jen0UEx0k/wmNDWFHSclWpOF52fvInV1/kO3
         xeFMU/SdG6TVw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1paXAT-0007rL-HG; Fri, 10 Mar 2023 08:27:57 +0100
Date:   Fri, 10 Mar 2023 08:27:57 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: Re: [PATCH v5 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Message-ID: <ZArb/ZQEmfGDjYyc@hovoldconsulting.com>
References: <20230209020916.6475-1-steev@kali.org>
 <20230209020916.6475-3-steev@kali.org>
 <ZAoS1T9m1lI21Cvn@hovoldconsulting.com>
 <CAKXuJqhEKB7cuVhEzObbFyYHyKj87M8iWVaoz7gkhS2OQ9tTBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKXuJqhEKB7cuVhEzObbFyYHyKj87M8iWVaoz7gkhS2OQ9tTBA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 02:24:57PM -0600, Steev Klimaszewski wrote:
> On Thu, Mar 9, 2023 at 11:08 AM Johan Hovold <johan@kernel.org> wrote:
> > On Wed, Feb 08, 2023 at 08:09:14PM -0600, Steev Klimaszewski wrote:

> > > @@ -672,6 +678,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
> > >       case QCA_WCN3991:
> > >       case QCA_WCN3998:
> > >       case QCA_WCN6750:
> > > +     case QCA_WCN6855:
> >
> > Did you actually verify the microsoft extensions need this, or you are
> > assuming it works as 6750?
> >
> It was 100% an assumption that since the 6750 does it, the 6855 does
> too.  I should know better than to assume since I used to work at a
> device manufacturer but high hopes things have changed a bit in the
> past 12 years ;)

Heh. Thanks for confirming. :)

> > >               hci_set_msft_opcode(hdev, 0xFD70);
> > >               break;
> > >       default:

> > > diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
> > > index 3df8c3606e93..efc1c0306b4e 100644
> > > --- a/drivers/bluetooth/hci_qca.c
> > > +++ b/drivers/bluetooth/hci_qca.c
> > > @@ -605,8 +605,7 @@ static int qca_open(struct hci_uart *hu)
> > >       if (hu->serdev) {
> > >               qcadev = serdev_device_get_drvdata(hu->serdev);
> > >
> > > -             if (qca_is_wcn399x(qcadev->btsoc_type) ||
> > > -                 qca_is_wcn6750(qcadev->btsoc_type))
> > > +             if (!(qcadev->init_speed))
> > >                       hu->init_speed = qcadev->init_speed;
> >
> > This change makes no sense.
> >
> > In fact, it seems the driver never sets init_speed anywhere.
> >
> > Either way, it should not be needed for wcn6855.
> 
> So, that was a request from an earlier review, but if it's not needed
> for 6855, I'll just drop it, and then I don't need to do any of those
> changes :D

Note that with the above, init_speed is only is set if qcadev->init_speed
is *not* set, so if this was needed the test would need to be negated.

But as I mentioned above, this also looks broken as qcadev->init_speed
is never set anywhere.

You could investigate and clean up this code before or after adding
support for wcn6855, but the above really doesn't look right and would
at least need to go in a separate patch with a proper explanation.

> > >
> > >               if (qcadev->oper_speed)

> > > @@ -1723,7 +1725,8 @@ static int qca_setup(struct hci_uart *hu)
> > >
> > >       bt_dev_info(hdev, "setting up %s",
> > >               qca_is_wcn399x(soc_type) ? "wcn399x" :
> > > -             (soc_type == QCA_WCN6750) ? "wcn6750" : "ROME/QCA6390");
> > > +             (soc_type == QCA_WCN6750) ? "wcn6750" :
> > > +             (soc_type == QCA_WCN6855) ? "wcn6855" : "ROME/QCA6390");
> >
> > This is hideous, but not your fault...
> >
> It is, and, I'm not entirely sure we need it? I mean, it's nice to
> show that it's now starting to set up, but it isn't particularly
> helpful for end users or making sure things are working?

This is driver is already spamming the logs, while generally we should
only be logging when things go wrong. Those info messages can probably
be changed to dev_dbg(), but that's a separate issue and not something
that's needed to add support for wcn6855.

And same here, you can keep the above as is, but it seems like someone
will soon need to clean up the type handling as all these conditionals
are getting a bit unwieldy.

> > > @@ -1883,6 +1888,20 @@ static const struct qca_device_data qca_soc_data_wcn6750 = {
> > >       .capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
> > >  };
> > >
> > > +static const struct qca_device_data qca_soc_data_wcn6855 = {
> > > +     .soc_type = QCA_WCN6855,
> > > +     .vregs = (struct qca_vreg []) {
> > > +             { "vddio", 5000 },
> > > +             { "vddbtcxmx", 126000 },
> > > +             { "vddrfacmn", 12500 },
> > > +             { "vddrfa0p8", 102000 },
> > > +             { "vddrfa1p7", 302000 },
> > > +             { "vddrfa1p2", 257000 },
> >
> > Hmm. More random regulator load values. I really think we should get rid
> > of this but that's a separate discussion.
> >
> Bjorn specifically requested that he wanted me to leave them in.  I'm
> not married to them, and don't care one way or the other, I just
> wanted working bluetooth since audio wasn't quite ready yet :)

You can them in for now, but we had a discussion last fall about whether
these made up numbers really belong in the kernel.

> > > +     },
> > > +     .num_vregs = 6,
> > > +     .capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
> > > +};
> > > +
> > >  static void qca_power_shutdown(struct hci_uart *hu)
> > >  {
> > >       struct qca_serdev *qcadev;
> >
> > As I mentioned elsewhere, you need to update also this function so that
> > wcn6855 can be powered down.
> 
> Sorry, I do have that locally, I just haven't pushed a v6 as I was
> looking at Tim's v2 of the qca2066 and was wondering if I should or
> shouldn't continue working on my version of the driver?

I only skimmed that patch a while ago, but that ones not strictly needed
for wcn6855, right? Things seems to work well here with just this series
applied.

> > With power-off handling fixed, this seems to work as quite well on my
> > X13s with 6.3-rc1. Nice job!
> >
> > Btw, apart from the frame reassembly error, I'm also seeing:
> >
> >         Bluetooth: Received HCI_IBS_WAKE_ACK in tx state 0
> >
> > during probe.
> >
> I'm still not sure where the frame reassembly error comes from, and I
> don't know how to get more info to figure it out either, if anyone
> happens to have any guidance for that, I would love some.
> Additionally, it doesn't always happen.  It seems to happen on the
> first load of the module, however, running modprobe -r && modprobe in
> a loop (with the powerdown properly modified so the log isn't full of
> splats),  it doesn't seem to occur every time. Likewise for the
> WAKE_ACK.

Ok. Looks like the Chromium team tried to suppress these errors when
switching line speed by toggling rts, but the frame-assembly error I get
appears to happen before that.

Johan
