Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867F83152B
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfEaTTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:19:36 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35042 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbfEaTTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:19:36 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so2279847qto.2;
        Fri, 31 May 2019 12:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZasN1uMb6LWNr3Bdl17/Az/Guny0XVTL4T4x9/AydIU=;
        b=UM7nM38a4xI4mDFTwnvkJ5uHeKUmW5NKf3JRUxdTvVLKyk3lfgeHGBlEUqaNm+x6op
         udiG16NB4a4/8mD1sYtFKZj/e7GY+WmzrZiVg4lYlWN6zFfd09RrCx+R5Nje6ghN1QRn
         yzoAa+Wq1me6pdGv2h8OPve/9ubJP1LKN1/8Mou1YDKNckcjjPjTsoeez9gkCeLQg5Wu
         IHlT2IDcB04iwimQNvzsqyVAMTK4lyHaW4eeBLEAETEPKj/W/hbbXZWcwrRlmPgg1b0k
         9uYspbGfFV+zqceCU0Yq1ECpOIInlGicyj+yOgHlAgwNQQVz0hsmVsYOjC/Xwp5HwSke
         o2uQ==
X-Gm-Message-State: APjAAAVtt06/JdcWU2abaK4ocDsg948NoQUaRlUX/fjoihElVyrWttft
        UV8Bh8u5tk7Ns+rvlNcoBA579DL7o8wLYjIN204=
X-Google-Smtp-Source: APXvYqwTzyt4WCkVVX3Qulyt1v2QQMhca2JE7R2nPL+bbYIIgogHgkLIhe92uxEulcPWL7paeV3/6XiyNu5oc8Epn44=
X-Received: by 2002:aed:3e7c:: with SMTP id m57mr5706705qtf.204.1559330374999;
 Fri, 31 May 2019 12:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190531035348.7194-1-elder@linaro.org> <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
 <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
In-Reply-To: <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 31 May 2019 21:19:18 +0200
Message-ID: <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Alex Elder <elder@linaro.org>
Cc:     Dan Williams <dcbw@redhat.com>, David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        evgreen@chromium.org, Ben Chan <benchan@google.com>,
        Eric Caruso <ejcaruso@google.com>, cpratapa@codeaurora.org,
        syadagir@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 6:36 PM Alex Elder <elder@linaro.org> wrote:
> On 5/31/19 9:58 AM, Dan Williams wrote:
> > On Thu, 2019-05-30 at 22:53 -0500, Alex Elder wrote:
> >
> > My question from the Nov 2018 IPA rmnet driver still stands; how does
> > this relate to net/ethernet/qualcomm/rmnet/ if at all? And if this is
> > really just a netdev talking to the IPA itself and unrelated to
> > net/ethernet/qualcomm/rmnet, let's call it "ipa%d" and stop cargo-
> > culting rmnet around just because it happens to be a net driver for a
> > QC SoC.
>
> First, the relationship between the IPA driver and the rmnet driver
> is that the IPA driver is assumed to sit between the rmnet driver
> and the hardware.

Does this mean that IPA can only be used to back rmnet, and rmnet
can only be used on top of IPA, or can or both of them be combined
with another driver to talk to instead?

> Currently the modem is assumed to use QMAP protocol.  This means
> each packet is prefixed by a (struct rmnet_map_header) structure
> that allows the IPA connection to be multiplexed for several logical
> connections.  The rmnet driver parses such messages and implements
> the multiplexed network interfaces.
>
> QMAP protocol can also be used for aggregating many small packets
> into a larger message.  The rmnet driver implements de-aggregation
> of such messages (and could probably aggregate them for TX as well).
>
> Finally, the IPA can support checksum offload, and the rmnet
> driver handles providing a prepended header (for TX) and
> interpreting the appended trailer (for RX) if these features
> are enabled.
>
> So basically, the purpose of the rmnet driver is to handle QMAP
> protocol connections, and right now that's what the modem provides.

Do you have any idea why this particular design was picked?

My best guess is that it evolved organically with multiple
generations of hardware and software, rather than being thought
out as a nice abstraction layer. If the two are tightly connected,
this might mean that what we actually want here is to reintegrate
the two components into a single driver with a much simpler
RX and TX path that handles the checksumming and aggregation
of data packets directly as it passes them from the network
stack into the hardware.

Always passing data from one netdev to another both ways
sounds like it introduces both direct CPU overhead, and
problems with flow control when data gets buffered inbetween.
The intermediate buffer here acts like a router that must
pass data along or randomly drop packets when the consumer
can't keep up with the producer.

        Arnd
