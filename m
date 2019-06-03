Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573D7338CF
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfFCTEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:04:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36876 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFCTEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:04:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BFD07607C3; Mon,  3 Jun 2019 19:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559588681;
        bh=2fFF2UZ1IMZoss2BdlfTKftG1dBbtIAex7bZx7hQCNA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e9asATusPcw0LSbghmIwPQkwJg+oAHwQGTHydazcY9tQ/gFD4R4zc69ZFUkWTLl6N
         EHfjekEeWo6jkd01rCHpfPFf36FY5lJUx6ICYxQfcrni/SbnVoNcA+J0/XNEgUpG03
         tI4hqzXe7SRakYnfbSamFoqjH5/ujpYtpSMAF6DI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 639956020A;
        Mon,  3 Jun 2019 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559588677;
        bh=2fFF2UZ1IMZoss2BdlfTKftG1dBbtIAex7bZx7hQCNA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MoQ3CkC5zUj8smO9TgVqkewwzN+bMdSvy1hwgvlG1qi8GDPxO9pSlf2g2VzGuEgZ7
         iW1JFRDNNyJGMxrHj2N2KKQJ1R9sOPUWSN2u7qkqOAa3Cy9TTjpL7rWs/BRNAqeBdM
         IM1gEWYa2IWjjsaxCuJWM6r5brDVUnpN2UWV4XPM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 03 Jun 2019 13:04:37 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Dan Williams <dcbw@redhat.com>
Cc:     Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        evgreen@chromium.org, Ben Chan <benchan@google.com>,
        Eric Caruso <ejcaruso@google.com>, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, abhishek.esse@gmail.com,
        Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
In-Reply-To: <0fc29577a5c69530145b6095fa1ac1a51949ba8e.camel@redhat.com>
References: <20190531035348.7194-1-elder@linaro.org>
 <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
 <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
 <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
 <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
 <3b1e12b145a273dd3ded2864d976bdc5fa90e68a.camel@redhat.com>
 <87f98f81-8f77-3bc5-374c-f498e07cb1bd@linaro.org>
 <0fc29577a5c69530145b6095fa1ac1a51949ba8e.camel@redhat.com>
Message-ID: <c200581b8fc167f3a0c09ef6233b8d81@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> I can't (or won't) comment right now on whether IPA needs its own
>> netdev for rmnet to use.  The IPA endpoints used for the modem
>> network interfaces are enabled when the netdev is opened and
>> disabled when closed.  Outside of that, TX and RX are pretty
>> much immediately passed through to the layer below or above.
>> IPA currently has no other net device operations.
> 
> I don't really have issues with the patchset underneath the netdev
> layer. I'm interested in how the various bits present themselves to
> userspace, which is why I am trying to tie this in with Johannes'
> conversation about WWAN devices, netdevs, channels, and how the various
> drivers present API for creating data channels that map to different
> modem contexts.
> 
> So let me rephrase. If the control plane has set up the default context
> and sent a QMI Start Network message (or the network attached the
> default one) and the resulting IP details are applied to the IPA netdev
> can things just start sending data? Or do we need to create an rmnet on
> top to get that working?
> 
> Dan

Hi Dan

All data from the hardware will have the MAP headers.
We still need to create rmnet devs over the IPA netdev and use it for 
the
data path.
The IPA netdev will pass on the packets which it receives from the 
hardware
and queue it to network stack where it will be intercepted by the
rmnet rx handler.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
