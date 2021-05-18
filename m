Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E23387BDD
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 17:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343837AbhERPEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 11:04:46 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:21432 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbhERPEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 11:04:44 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621350023; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=QUU80e8clEURh4Kp4spwHo3wbcXe0npaQCAc7W1dJ+uu88p1plZxekIw3s9SGlWY5+
    6PKHSZNJ3UGaSz9Ut3MHUHviJAkR5qT8TsTFdab71s1bitvypX9gF6fIWqra6pchLDkS
    JrwG89Q9zdbGg43uYPVXAQM/OOclMfGBdEugOT8I2b+A3xxZPg+2LmIlhBh817+p4O/E
    OBSRkYGaAzvjyJkxVTEVZJAjc89uqeftEkGign0A/y2fwolVTMlxTpISKIJ36BldQnEV
    lXHqdmpmq7GMw1F2FAq4oXSy3dU+ffd4XlHgAFMlBgGXl/fm1aJG2hhNWXSGQ/zTuMFH
    M7wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621350023;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=+JBRI2wnUVvQdzfM9cNkT70UphTkFhDyy9+MMG5Vv7E=;
    b=TmqtFXOoCQKYtPDWk8qRcuOcd9Wb9HPBTy+LmoEE94liBHHGQJ8r3QVKCmSxfsU2Mc
    Pfut2LO4PCSYc6F+euvtdIMsqdzejKVuRfOkqZyPugOk2LNZiMd9/MSpYbS6tD/DQAi5
    4BGCbU7VLzSnucOU5o+cTUbUyxIA0NIOY3q0G+LDMVM3TpLFU9+fBw/8nvaZ/XtzI94H
    i39tOlL8SOrmBdayBDj+HV5Dljap5EgklF9QJzDo/GEkczWkxP7jb/jK0iqY/eJtMv6j
    Nn6aN0hmHzxcqT6rHLvBEJDUp3Jvt1phWatwhPUFVxqTNlFBpHDbddAxGYu8VPBAHgNw
    UkNg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621350023;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=+JBRI2wnUVvQdzfM9cNkT70UphTkFhDyy9+MMG5Vv7E=;
    b=l9NbGhV3fde5WU1fTbtmWR0QYoHrEAFhsG9iSLWZf8bQk1tzqSXr/fXYVdiyJuyPOR
    Hjysk1iZlK1QQIwY1qBZXfrnHUCWSEZqki+pHEh3gnf9lbzvqPs6gnk4M0c5zdI/S75+
    fKR6eMqKt3c3BUFNflItIvtA3C0bYXIJGRrLh/egK2W7LnV1h60DXKbsyKRqkWA4ML6J
    qtF2BuPj03u1oU3d1dHTlC26d/9oWCqQWWmbBmczgJJKHPq75kQMySKZubpr7tC1m71Q
    Alp2md5l4l8k52UWwSnEcbh44HV3AVBn+ghE6NVikoBvRggre+NAEcm5UUS/gXSF3sWY
    J7wA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j7Ic/Da4o="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id z041eax4IF0M06r
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 18 May 2021 17:00:22 +0200 (CEST)
Date:   Tue, 18 May 2021 17:00:17 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: [linux-nfc] [PATCH 2/2] nfc: s3fwrn5: i2c: Enable optional clock
 from device tree
Message-ID: <YKPWgSnz7STV4u+c@gerhold.net>
References: <20210518133935.571298-1-stephan@gerhold.net>
 <20210518133935.571298-2-stephan@gerhold.net>
 <ac04821e-359d-aaaa-7e07-280156f64036@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac04821e-359d-aaaa-7e07-280156f64036@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 18, 2021 at 10:30:43AM -0400, Krzysztof Kozlowski wrote:
> On 18/05/2021 09:39, Stephan Gerhold wrote:
> > s3fwrn5 has a NFC_CLK_REQ output GPIO, which is asserted whenever
> > the clock is needed for the current operation. This GPIO can be either
> > connected directly to the clock provider, or must be monitored by
> > this driver.
> > 
> > As an example for the first case, on many Qualcomm devices the
> > NFC clock is provided by the main PMIC. The clock can be either
> > permanently enabled (clocks = <&rpmcc RPM_SMD_BB_CLK2>) or enabled
> > only when requested through a special input pin on the PMIC
> > (clocks = <&rpmcc RPM_SMD_BB_CLK2_PIN>).
> > 
> > On the Samsung Galaxy A3/A5 (2015, Qualcomm MSM8916) this mechanism
> > is used with S3FWRN5's NFC_CLK_REQ output GPIO to enable the clock
> > only when necessary. However, to make that work the s3fwrn5 driver
> > must keep the RPM_SMD_BB_CLK2_PIN clock enabled.
> 
> This contradicts the code. You wrote that pin should be kept enabled
> (somehow... by driver? by it's firmware?) but your code requests the
> clock from provider.
> 

Yeah, I see how that's a bit confusing. Let me try to explain it a bit
better. So the Samsung Galaxy A5 (2015) has a "S3FWRN5XS1-YF30", some
variant of S3FWRN5 I guess. That S3FWRN5 has a "XI" and "XO" pin in the
schematics. "XO" seems to be floating, but "XI" goes to "BB_CLK2"
on PM8916 (the main PMIC).

Then, there is "GPIO2/NFC_CLK_REQ" on the S3FWRN5. This goes to
GPIO_2_NFC_CLK_REQ on PM8916. (Note: I'm talking about two different
GPIO2 here, one on S3FWRN5 and one on PM8916, they just happen to have
the same number...)

So in other words, S3FWRN5 gets some clock from BB_CLK2 on PM8916,
and can tell PM8916 that it needs the clock via GPIO2/NFC_CLK_REQ.

Now the confusing part is that the rpmcc/clk-smd-rpm driver has two
clocks that represent BB_CLK2 (see include/dt-bindings/clock/qcom,rpmcc.h):

  - RPM_SMD_BB_CLK2
  - RPM_SMD_BB_CLK2_PIN

(There are also *_CLK2_A variants but they are even more confusing
 and not needed here...)

Those end up in different register settings in PM8916. There is one bit
to permanently enable BB_CLK2 (= RPM_SMD_BB_CLK2), and one bit to enable
BB_CLK2 based on the status of GPIO_2_NFC_CLK_REQ on PM8916
(= RPM_SMD_BB_CLK2_PIN).

So there is indeed some kind of "AND" inside PM8916 (the register bit
and "NFC_CLK_REQ" input pin). To make that "AND" work I need to make
some driver (here: the s3fwrn5 driver) enable the clock so the register
bit in PM8916 gets set.

> > 
> > This commit adds support for this by requesting an optional clock
> 
> Don't write "This commit".
> https://elixir.bootlin.com/linux/latest/source/Documentation/process/submitting-patches.rst#L89
> 

OK, will fix this in v2 (I guess there will be a v2 to clarify things
at least...)

> > and keeping it permanently enabled. Note that the actual (physical)
> > clock won't be permanently enabled since this will depend on the
> > output of NFC_CLK_REQ from S3FWRN5.
> 
> What pin is that "NFC_CLK_REQ"? I cannot find such name. Is it GPIO2?
> What clock are you talking here? The one going to the modem part?
> 

It's indeed GPIO2 on S3FWRN5, but that's pretty much all I can say since
I can't seem to find any datasheet for S3FWRN5. :( I don't know what it
is used for. As I mentioned above, BB_CLK2 goes to "XI" on S3FWRN5.

> I also don't see here how this clock is going to be automatically
> on-off... driver does not perform such. Unless you speak about your
> particular HW configuration where the GPIO is somehow connected with AND
> (but then it is not relevant to the code).
> 

I hope I covered this above already and it's a bit clearer now.
Sorry for the confusion!

Thanks!
Stephan
