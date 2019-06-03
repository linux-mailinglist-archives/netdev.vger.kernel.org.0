Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89B3334BD
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 18:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfFCQSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 12:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfFCQSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 12:18:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 75D1C3086217;
        Mon,  3 Jun 2019 16:18:43 +0000 (UTC)
Received: from ovpn-112-59.rdu2.redhat.com (ovpn-112-59.rdu2.redhat.com [10.10.112.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DF5D5D6A9;
        Mon,  3 Jun 2019 16:18:37 +0000 (UTC)
Message-ID: <0fc29577a5c69530145b6095fa1ac1a51949ba8e.camel@redhat.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Dan Williams <dcbw@redhat.com>
To:     Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
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
Date:   Mon, 03 Jun 2019 11:18:36 -0500
In-Reply-To: <87f98f81-8f77-3bc5-374c-f498e07cb1bd@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
         <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
         <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
         <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
         <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
         <3b1e12b145a273dd3ded2864d976bdc5fa90e68a.camel@redhat.com>
         <87f98f81-8f77-3bc5-374c-f498e07cb1bd@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 03 Jun 2019 16:18:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-03 at 10:52 -0500, Alex Elder wrote:
> On 6/3/19 9:54 AM, Dan Williams wrote:
> > > To be perfectly honest, at first I thought having IPA use rmnet
> > > was a cargo cult thing like Dan suggested, because I didn't see
> > To be clear I only meant cargo-culting the naming, not any
> > functionality. Clearly IPA/rmnet/QMAP are pretty intimately
> > connected
> > at this point. But this goes back to whether IPA needs a netdev
> > itself
> > or whether you need an rmnet device created on top. If the former
> > then
> > I'd say no cargo-culting, if the later then it's a moot point
> > because
> > the device name will be rmnet%d anyway.
> 
> OK I thought you weren't sure why rmnet was a layer at all.  As I
> said, I didn't have a very good understanding of why it was even
> needed when I first started working on this.

No problem.

> I can't (or won't) comment right now on whether IPA needs its own
> netdev for rmnet to use.  The IPA endpoints used for the modem
> network interfaces are enabled when the netdev is opened and
> disabled when closed.  Outside of that, TX and RX are pretty
> much immediately passed through to the layer below or above.
> IPA currently has no other net device operations.

I don't really have issues with the patchset underneath the netdev
layer. I'm interested in how the various bits present themselves to
userspace, which is why I am trying to tie this in with Johannes'
conversation about WWAN devices, netdevs, channels, and how the various
drivers present API for creating data channels that map to different
modem contexts.

So let me rephrase. If the control plane has set up the default context
and sent a QMI Start Network message (or the network attached the
default one) and the resulting IP details are applied to the IPA netdev
can things just start sending data? Or do we need to create an rmnet on
top to get that working?

Dan

