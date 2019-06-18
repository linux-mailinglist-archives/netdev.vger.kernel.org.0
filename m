Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F414AB48
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbfFRT7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 15:59:38 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43118 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730242AbfFRT7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 15:59:38 -0400
Received: by mail-qk1-f193.google.com with SMTP id m14so9402256qka.10;
        Tue, 18 Jun 2019 12:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i7s7c5OcKeclqiywXdqj12aC74/yCawdjmwihldgF1s=;
        b=DHYGvxMY6OdMmnVu97ZGrFSVib8SRuY7TON32T/WhGsFNnFlkQ1f1kv9vMlV/haBZt
         /6aF86FrHiAnjzCuqggjGVz6aoe4JBMOvO2d1ytDTwhFGAT9RyNFwdQnQlyKa9VtlNNF
         lhzjnlNHnlItH3fkA2C9tHFHdM/5e2ABgVH2w6sWulkzNXLo+fey7K1AGDsprucjVqOn
         pZq/Ow89YzMHzuMecmbQRxEYu/lzcoey7jCaLgrI8bE+F35p/ivIRazoGkoaONlvSz20
         08hll5eQhwYvmJS/QKLby6Sl4eCk6Co4hQ+Ai62L/AoodhhJkzRM5zDSW/9ncU/J1Hs0
         dO5w==
X-Gm-Message-State: APjAAAWaAF1SUlyLJ36PbDZXBfnjGusFdQyksjFkp4KCHkTcBceXmbFW
        2AGep7KUTG6v0S54p7YZirWRPJUNVyDgmvn8Yd8=
X-Google-Smtp-Source: APXvYqy6dw17Y5hPbpJB1iwj6Y5EiqPTo9iLm7ZATxD+K27A0WaDVgnTPbaE839sYu0LKjhIqohaX9442ZVn9lHIr6Q=
X-Received: by 2002:a37:a4d3:: with SMTP id n202mr8102665qke.84.1560887976962;
 Tue, 18 Jun 2019 12:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net>
 <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org> <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
In-Reply-To: <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jun 2019 21:59:19 +0200
Message-ID: <CAK8P3a1FeUQR3pgoQxHoRK05JGORyR+TFATVQiijLWtFKTv6OQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        syadagir@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 9:14 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2019-06-18 at 08:16 -0500, Alex Elder wrote:
> > On 6/17/19 6:28 AM, Johannes Berg wrote:
> > So getting back to your question, the IPA in its current form only
> > has a single "multiplexed" channel carried over the connection
> > between the AP and modem.  Previously (and in the future) there
> > was a way to add or remove channels.
>
> What would those channels do?
>
> I've not really been very clear with the differentiation between a
> channel and what's multiplexed inside of the channel.
>
> Using the terminology you defined in your other mail, are you saying
> that IPA (originally) allowed multiple *connections* to the device, or
> is there basically just one connection, with multiple (QMAP-muxed)
> *channels* on top of it?
>
> If the latter, why did IPA need ioctls, rather than rmnet?

From my understanding, the ioctl interface would create the lower
netdev after talking to the firmware, and then user space would use
the rmnet interface to create a matching upper-level device for that.
This is an artifact of the strong separation of ipa and rmnet in the
code.

> > > The software bridging is very questionable to start with, I'd advocate
> > > not supporting that at all but adding tracepoints or similar if needed
> > > for debugging instead.
> >
> > To be honest I don't understand the connection between software
> > bridging and debugging, but that's OK.
>
> It's a mess. Basically, AFAICT, the only use for the rmnet bridging is
> in fact debugging. What it does, again AFAICT, is mirror out all the
> rmnet packets to the bridge if you attach it to a bridge, so that then
> you can attach another netdev to the bridge and forward all the rmnet
> packets to another system for debugging.
>
> It's a very weird way of doing this, IMHO.

My understanding for this was that the idea is to use it for
connecting bridging between distinct hardware devices behind
ipa: if IPA drives both a USB-ether gadget and the 5G modem,
you can use to talk to Linux running rmnet, but you can also
use rmnet to provide fast usb tethering to 5g and bypass the
rest of the network stack. That again may have been a wrong
guess on my part.

> > I believe the only QMAP commands are for doing essentially
> > XON/XOFF flow control on a single channel.  In the course of
> > the e-mail discussion in the past few weeks I've come to see
> > why that would be necessary.
>
> It does make sense, because you only have a single hardware (DMA)
> channel in these cases, so you implement flow control in software on
> top.
>
> (As I said before, the Intel modem uses different hardware channels for
> different sessions, so doesn't need something like this - the hardware
> ring just fills up and there's your flow control)

ipa definitely has multiple hardware queues, and the Alex'
driver does implement  the data path on those, just not the
configuration to enable them.

Guessing once more, I suspect the the XON/XOFF flow control
was a workaround for the fact that rmnet and ipa have separate
queues. The hardware channel on IPA may fill up, but user space
talks to rmnet and still add more frames to it because it doesn't
know IPA is busy.

Another possible explanation would be that this is actually
forwarding state from the base station to tell the driver to
stop sending data over the air.

       Arnd
