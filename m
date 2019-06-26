Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E02856FE1
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 19:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfFZRsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 13:48:53 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46802 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFZRsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 13:48:53 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hgC2C-0007vw-Ho; Wed, 26 Jun 2019 19:48:40 +0200
Message-ID: <9e46f95b8727c8b95aedb144970986a21266983c.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>, Alex Elder <elder@linaro.org>
Cc:     Dan Williams <dcbw@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Date:   Wed, 26 Jun 2019 19:48:38 +0200
In-Reply-To: <CAK8P3a3wHe_6ay8P+F9Vo=k19P5fifs6RWozxFF5nGYYjO_=Xw@mail.gmail.com> (sfid-20190626_155908_107021_A3066824)
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
         <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
         <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
         <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
         <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
         <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
         <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
         <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
         <d533b708-c97a-710d-1138-3ae79107f209@linaro.org>
         <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
         <db34aa39-6cf1-4844-1bfe-528e391c3729@linaro.org>
         <CAK8P3a1ixL9ZjYz=pWTxvMfeD89S6QxSeHt9ZCL9dkCNV5pMHQ@mail.gmail.com>
         <efbcb3b84ff0a7d7eab875c37f3a5fa77e21d324.camel@sipsolutions.net>
         <edea19ef-f225-bdcd-f394-77e326d1d3ad@linaro.org>
         <CAK8P3a3wHe_6ay8P+F9Vo=k19P5fifs6RWozxFF5nGYYjO_=Xw@mail.gmail.com>
         (sfid-20190626_155908_107021_A3066824)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-26 at 15:58 +0200, Arnd Bergmann wrote:
> 
> > The IPA hardware is actually something that sits *between* the
> > AP and the modem.  It implements one form of communication
> > pathway (IP data), but there are others (including QMI, which
> > presents a network-like interface but it's actually implemented
> > via clever use of shared memory and interrupts).
> 
> Can you clarify how QMI fits in here? Do you mean one has to
> talk to both IPA and QMI to use the modem, or are these two
> alternative implementations for the same basic purpose?

I'm not going to comment on QMI specifically, because my understanding
might well be wrong, and any response to your question will likely
correct my understanding :-)

(Thus, you should probably also ignore everything I ever said about QMI)

> My previous understanding was that from the hardware perspective
> there is only one control interface, which is for IPA. Part of this
> is abstracted to user space with ioctl commands to the IPA driver,
> and then one must set up rmnet to match these by configuring
> an rmnet device over netlink messages from user space, but
> rmnet does not have a control protocol with the hardware.

Right so this is why I say it's confusing when we just talk about
"control interface" or "path".

I see multiple layers of control

 * hardware control, which you mention here. This might be things like
   "enable/disable aggregation on an rmnet channel" etc. I guess this
   type of thing would have been implemented with ioctls? Not the
   aggregation specifically, but things that affect how you set up the
   hardware.

 * modem control, which we conflate, but can be like AT commands or
   MBIM. From the kernel driver POV, this is actually just another
   channel it provides for userspace to talk to the modem.

johannes

