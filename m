Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3067C5701F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 19:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfFZR7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 13:59:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47020 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfFZR7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 13:59:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hgCCC-00084q-Kz; Wed, 26 Jun 2019 19:59:01 +0200
Message-ID: <24bc6695f664669fc77778b7aba5a0f1c88ac85d.camel@sipsolutions.net>
Subject: Re: WWAN Controller Framework (was IPA [PATCH v2 00/17])
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, arnd@arndb.de,
        bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org,
        Dan Williams <dcbw@redhat.com>
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Date:   Wed, 26 Jun 2019 19:58:56 +0200
In-Reply-To: <25bb0936-686c-101b-c5a4-474ed37536aa@linaro.org> (sfid-20190626_154015_130082_AEA49FB2)
References: <20190531035348.7194-1-elder@linaro.org>
         <23ff4cce-1fee-98ab-3608-1fd09c2d97f1@linaro.org>
         <6dae9d1c-ceae-7e88-fe61-f4cda82820ea@linaro.org>
         <f1243295f088b70d48e4b832a28f79c0cd84ca1c.camel@sipsolutions.net>
         <25bb0936-686c-101b-c5a4-474ed37536aa@linaro.org>
         (sfid-20190626_154015_130082_AEA49FB2)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-26 at 08:40 -0500, Alex Elder wrote:

> > I think here we need to be more careful. I don't know how you want to
> > call it, but we actually have multiple levels of control here.
> 
> I completely agree with you.  From what I understand there exists
> a control channel (or even more than one?) that serves a very
> specific purpose in modem management.  The main reason I mention
> the WWAN control function is that someone (maybe you) indicated
> that a control channel automatically gets created.

It may or may not, right. I just bought a cheap used USB modem, and it
just comes with two USB TTY channels, so I guess for data it does PPP on
top of that. But those channels are created automatically once you
connect the device to the system.

OTOH, for something like the Intel modem, we might well decide not to
create *any* channels on driver load, since you have the option of using
AT commands or MBIM (but I believe both at the same time wouldn't really
make sense, if even allowed).

> > This ... depends a bit on how you exactly define a physical channel
> > here. Is that, to you, the PCIe/USB link? In that case, yes, obviously
> > you have only one physical channel for each WWAN unit.
> 
> I think that was what I was trying to capture.  There exists
> one or more "physical" communication paths between the AP
> and WWAN unit/modem.  And while one path *could* carry just
> one type of traffic, it could also carry multiple logical
> channels of traffic by multiplexing.

Right.

(What I wasn't aware is that QMI is actually a different physical path.
I thought it was just a protocol multiplexed on top of the same IPA
physical path).

> I don't think I have any argument with this.  I'm going to try to
> put together something that goes beyond what I wrote in this message,
> to try to capture what I think we agree on in a sort of loose design
> document.

Awesome, thanks a lot!

johannes

