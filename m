Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC0B669EE3
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjAMQ6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjAMQ6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:58:03 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6F56158
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 08:58:01 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q10so2319755wrs.2
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 08:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2za1A8nEEuXINFLtQr3tDlzj07s9HFmHzlMPC09jSd0=;
        b=OK7Wwp5zU0zZXuRQVDH/O6Wrvo4Pw5eo1kTFc7Sf48Mezyt3uOnZYh/d+XTw9KXSFV
         aZCAB+d1bzv7NekUH8Hzse7dK0fj0cAizMAz3PS3B7VQOYRbt8jiXJ47qGBBH0xZvXh3
         EOTniB1wPK/9yVWp4pvGF6DgoRYB/NjBfvr+gkzLog91nXaUoUdUty2RPioJxTIssTb2
         rCh1WRYZxLSxlAHhbLgeZLIOYrb+MDlAH+X/iL/YJO23rYRIsCi8RNSy6Y5znlP/5rgh
         RPTM5wLSZsp0oDowRPr807q/WQNCz8p0q+fQG5EtHxNX9ofyJWptS0wNjmX0yYyq5dC+
         g4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2za1A8nEEuXINFLtQr3tDlzj07s9HFmHzlMPC09jSd0=;
        b=xh8YzBGPzRBOrtADfnP+KWL1en5Q+E+RkYTmIJwn5FLlOTiji/4MABMQ+LETgAaMaX
         /soo5dsVSpvXBlcrscEHRH8Bu9pib0JN3G6h+Twp82TQU8jjZYtL/HeU9+3bbECEeaXW
         hQGrL15GYGl/BrQjvWqpZKQ8nkATGtF3rAeO2YsvSbOzb3zN5ULVIaKiWJm/VtjOX5Ys
         bBzlZzh2zmWhf2wCXcSzyGWerPrdqfjNSNznqv39ZlgtEViUxf2KHVN8EJ/E/qyCazNs
         biLVLjCVlEIHoryLBITJ+fYmcAPuTwAnu0KFh4gKRJ1MkjryUxqsv5Bkrfc/4ODrN5Kl
         G3uw==
X-Gm-Message-State: AFqh2kpyXCLDsUIbiMb/s17hW3miw2Qeg79gYYUvzVSeFI17cT6GfyQ0
        d0QN0ocB/tXamKYPP54yAmNBwk7d0YgWcKafq9k=
X-Google-Smtp-Source: AMrXdXubsg436oD9uFeC3J1e2iqQtJC2kt8nActN1+81qvrNW3PGRtrX8wqYKkQvKRhjtX2P0skin1dfKliXsuE6Lyw=
X-Received: by 2002:a5d:604d:0:b0:2bb:ea44:2b5a with SMTP id
 j13-20020a5d604d000000b002bbea442b5amr476212wrt.430.1673629079631; Fri, 13
 Jan 2023 08:57:59 -0800 (PST)
MIME-Version: 1.0
References: <20230111130520.483222-1-dnlplm@gmail.com> <b8f798f7b29a257741ba172d43456c3a79454e9c.camel@gmail.com>
 <CAGRyCJGFhNfbHs=qhdOg9DYOq_tLOska2r2B08WTBbnFyXXjhw@mail.gmail.com> <CAKgT0Ueb7AA3NrwxFX7VjS_h1j-kOdXUGYchTjwCh9ah1kpbZA@mail.gmail.com>
In-Reply-To: <CAKgT0Ueb7AA3NrwxFX7VjS_h1j-kOdXUGYchTjwCh9ah1kpbZA@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 13 Jan 2023 08:57:48 -0800
Message-ID: <CAA93jw78pvJENnj5ob7WX8GV676CZprYADWeQjaciasopNTv5A@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/3] add tx packets aggregation to ethtool and rmnet
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Alexander:

Thank you for taking a look at this thread. In earlier tests, the
aggregation was indeed an improvement over the default behavior,
but the amount of data that ended up living in the device was best
case, 150ms, and worst case, 25 seconds, in the flent tcp_nup case. A
better test would be the staggered start tcp_4up_squarewave test which
would show only one tcp out of the 4, able to start with the current
overall structure of this portion of the stack, once that buffer gets
filled.

The shiny new rust based Crusader test (
https://github.com/Zoxc/crusader ) has also now got a nice staggered
start test that shows this problem in more detail.

I was so peeved about 4g/5g behaviors like this in general that I was
going to dedicate a blog entry to it; this recent rant only touches
upon the real problem with engineering to the test, here:

https://blog.cerowrt.org/post/speedtests/

Unfortunately your post is more about leveraging xmit_more - which is
good, but the BQL structure for ethernet, itself leverages the concept
of a completion interrupt (when the packets actually hit the air or
wire), which I dearly wish was some previously unknown, single line
hack to the driver or message in the usb API for 4g/5g etc.

On Fri, Jan 13, 2023 at 8:17 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Jan 13, 2023 at 7:50 AM Daniele Palmas <dnlplm@gmail.com> wrote:
> >
> > Hello Alexander,
> >
> > Il giorno ven 13 gen 2023 alle ore 00:00 Alexander H Duyck
> > <alexander.duyck@gmail.com> ha scritto:
> > >
> > > On Wed, 2023-01-11 at 14:05 +0100, Daniele Palmas wrote:
> > > > Hello maintainers and all,
> > > >
> > > > this patchset implements tx qmap packets aggregation in rmnet and g=
eneric
> > > > ethtool support for that.
> > > >
> > > > Some low-cat Thread-x based modems are not capable of properly reac=
hing the maximum
> > > > allowed throughput both in tx and rx during a bidirectional test if=
 tx packets
> > > > aggregation is not enabled.
> > >
> > > One question I would have about this is if you are making use of Byte
> > > Queue Limits and netdev_xmit_more at all? I know for high speed devic=
es
> > > most of us added support for xmit_more because PCIe bandwidth was
> > > limiting when we were writing the Tx ring indexes/doorbells with ever=
y
> > > packet. To overcome that we added netdev_xmit_more which told us when
> > > the Qdisc had more packets to give us. This allowed us to better
> > > utilize the PCIe bus by bursting packets through without adding
> > > additional latency.
> > >
> >
> > no, I was not aware of BQL: this development has been basically
> > modelled on what other mobile broadband drivers do (e.g.
> > cdc_mbim/cdc_ncm, Qualcomm downstream rmnet implementation), that are
> > not using BQL.
> >
> > If I understand properly documentation
> >
> > rmnet0/queues/tx-0/byte_queue_limits/limit_max
> >
> > would be the candidate for replacing ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYT=
ES.
>
> Yes the general idea is that you end up targeting the upper limit for
> how many frames can be sent in a single burst.
>
> > But I can't find anything for ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES
> > and ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS, something that should work
> > in combination with the bytes limit: at least the first one is
> > mandatory, since the modem can't receive more than a certain number
> > (this is a variable value depending on the modem model and is
> > collected through userspace tools).
>
> In terms of MAX_FRAMES there isn't necessarily anything like that, but
> at the same time it isn't something that is already controlled by the
> netdev itself by using the netif_stop_queue or netif_stop_subqueue
> when there isn't space to store another frame. As such most devices
> control this by just manipulating their descriptor ring size via
> "ethtool -G <dev> tx <N>"
>
> As far as the TIME_USECS that is something I tried to propose a decade
> ago and was essentially given a hard "NAK" before xmit_more was
> introduced. We shouldn't be adding latency when we don't need to.
> Between GSO and xmit_more you should find that the network stack
> itself will naturally want to give you larger bursts of frames with
> xmit_more set. In addition, adding latency can mess with certain TCP
> algorithms and cause problematic behaviors.
>
> > ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES works also as a way to determine
> > that tx aggregation has been enabled by the userspace tool managing
> > the qmi requests, otherwise no aggregation should be performed.
>
> Is there a specific reason why you wouldn't want to take advantage of
> aggregation that is already provided by the stack in the form of
> things such as GSO and the qdisc layer? I know most of the high speed
> NICs are always making use of xmit_more since things like GSO can take
> advantage of it to increase the throughput. Enabling BQL is a way of
> taking that one step further and enabling the non-GSO cases.
>
> > > > I verified this problem with rmnet + qmi_wwan by using a MDM9207 Ca=
t. 4 based modem
> > > > (50Mbps/150Mbps max throughput). What is actually happening is pict=
ured at
> > > > https://drive.google.com/file/d/1gSbozrtd9h0X63i6vdkNpN68d-9sg8f9/v=
iew
> > > >
> > > > Testing with iperf TCP, when rx and tx flows are tested singularly =
there's no issue
> > > > in tx and minor issues in rx (not able to reach max throughput). Wh=
en there are concurrent
> > > > tx and rx flows, tx throughput has an huge drop. rx a minor one, bu=
t still present.
> > > >
> > > > The same scenario with tx aggregation enabled is pictured at
> > > > https://drive.google.com/file/d/1jcVIKNZD7K3lHtwKE5W02mpaloudYYih/v=
iew
> > > > showing a regular graph.
> > > >
> > > > This issue does not happen with high-cat modems (e.g. SDX20), or at=
 least it
> > > > does not happen at the throughputs I'm able to test currently: mayb=
e the same
> > > > could happen when moving close to the maximum rates supported by th=
ose modems.
> > > > Anyway, having the tx aggregation enabled should not hurt.
> > > >
> > > > The first attempt to solve this issue was in qmi_wwan qmap implemen=
tation,
> > > > see the discussion at https://lore.kernel.org/netdev/20221019132503=
.6783-1-dnlplm@gmail.com/
> > > >
> > > > However, it turned out that rmnet was a better candidate for the im=
plementation.
> > > >
> > > > Moreover, Greg and Jakub suggested also to use ethtool for the conf=
iguration:
> > > > not sure if I got their advice right, but this patchset add also ge=
neric ethtool
> > > > support for tx aggregation.
> > >
> > > I have concerns about this essentially moving queueing disciplines do=
wn
> > > into the device. The idea of doing Tx aggregation seems like somethin=
g
> > > that should be done with the qdisc rather than the device driver.
> > > Otherwise we are looking at having multiple implementations of this
> > > aggregation floating around. It seems like it would make more sense t=
o
> > > have this batching happen at the qdisc layer, and then the qdisc laye=
r
> > > would pass down a batch of frames w/ xmit_more set to indicate it is
> > > flushing the batch.
> >
> > Honestly, I'm not expert enough to give a reliable opinion about this.
> >
> > I feel like these settings are more related to the hardware, requiring
> > also a configuration on the hardware itself done by the user, so
> > ethtool would seem to me a good choice, but I may be biased since I
> > did this development :-)
>
> Yeah, I get that. I went through something similar when I had
> submitted a patch to defer Tx tail writes in order to try and improve
> the PCIe throughput. I would be open to revisiting this if we gave
> xmit_more and BQL a try and it doesn't take care of this, but from my
> past experience odds are the combination will likely resolve most of
> what you are seeing without adding additional latency. At a minimum
> the xmit_more should show a significant improvement in Tx throughput
> just from the benefits of GSO sending bursts of frames through that
> can easily be batched.



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
