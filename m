Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018F4388904
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 10:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbhESIJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 04:09:39 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:11986 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236275AbhESIJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 04:09:36 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621411685; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Dkz4dcBavii0N+K8S/+n2p40HfLhkH9ObdcLqf06ZKw7gJw1eLvmjotmbsUT7Y+7K/
    Jk/0Axxhq9Q0nMRWhWWa2p/rrhvJhAl7pfHBP7jqzinTTai1UQ0ZWw1KnQqtEjehf5sE
    hFd4ol61UqAI4K2yRlghMRznbVZ05LczP4N0Ue4tn03UGG8om4fD8YueEKKPuAijUSYe
    IqRzkuNFZ+w79Q5Ly2L+BYsEsFPw65HnEvgJqM98rxrfsEwjehhrOBQ9X5zDmlzh1QDY
    9W/oXP3fXZlEdrtGRx3I7+BhneKJ93ngLNl9wl4f/KeWuQPvQ+wV6Up7GJJMONskWLp6
    pDjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621411685;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=GUrXeKAgdA1NNFxGRQfEzTx+UhwutW+q736CLOlMIyA=;
    b=Z23Qn+KaTgzQx3EmrSiz0/PL+6Q/5TR2VjEeZ6y0JorPYtMK2B6pyWtY/iJmR+/L9o
    7WT+Z9r9m+p2rnqCgj/EaWrx0C+8QLPWD6cag/f8YxTeb3AytySxE60USd0fJl322EgW
    eJN2LH92yGItd7w1rQ9tCh5DyxSjyPeK3tZ3ih0WjnYJnWxan4jY93VvwKBmmGytOyg9
    PCRzSolQPSVLnq7f82djVxIoZ9+WiZFzLbIjezQU6ly/U/FZFz4IkbfT5xORjJEa5gNM
    NVFydZvXcw1S/1Zr22Iw9SALd4ToMyMp1wk8cJ5dlmUtJ3yaSnbsrb29qrQdmI2u6zyd
    oJHQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621411685;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=GUrXeKAgdA1NNFxGRQfEzTx+UhwutW+q736CLOlMIyA=;
    b=p95blirop3V1/WSZyq4GC/zMG+JX4WTSGzT5Gk8d8kFAUX941PIaGbDLhc/WRI0EMB
    rqkPsjpSffXAJMSnTF0/P2IC+IQJA53gGtSE4Y0PwIALK6V3LcVVmZuXiKi176cSACxZ
    HikKsdNsjlI0WHlnbgY5he1DfPQKAnF+3F7svZhwbeQJg5EiUBldhuNTxlsSeHv3Jby7
    5tff2iuoOo6XJfyUIQ6YKLDgBXYOxSg2Z/Md+pKaZYjw7hxK72ksL1ukNdwwPW9NEoV4
    R31YHjrL6vRZarrD1rvfukZKYnLrbCV8QqUKc/iEITlHRyJp+r+vbdl6tsyXsXNYGiQ9
    tGyQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j6Ic/GaYo="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id z041eax4J88353z
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 19 May 2021 10:08:03 +0200 (CEST)
Date:   Wed, 19 May 2021 10:07:59 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: [linux-nfc] Re: [PATCH 2/2] nfc: s3fwrn5: i2c: Enable optional
 clock from device tree
Message-ID: <YKTHXzUhcYa5YJIs@gerhold.net>
References: <20210518133935.571298-1-stephan@gerhold.net>
 <20210518133935.571298-2-stephan@gerhold.net>
 <ac04821e-359d-aaaa-7e07-280156f64036@canonical.com>
 <YKPWgSnz7STV4u+c@gerhold.net>
 <8b14159f-dca9-a213-031f-83ab2b3840a4@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b14159f-dca9-a213-031f-83ab2b3840a4@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 11:25:55AM -0400, Krzysztof Kozlowski wrote:
> On 18/05/2021 11:00, Stephan Gerhold wrote:
> > On Tue, May 18, 2021 at 10:30:43AM -0400, Krzysztof Kozlowski wrote:
> >> On 18/05/2021 09:39, Stephan Gerhold wrote:
> >>> s3fwrn5 has a NFC_CLK_REQ output GPIO, which is asserted whenever
> >>> the clock is needed for the current operation. This GPIO can be either
> >>> connected directly to the clock provider, or must be monitored by
> >>> this driver.
> >>>
> >>> As an example for the first case, on many Qualcomm devices the
> >>> NFC clock is provided by the main PMIC. The clock can be either
> >>> permanently enabled (clocks = <&rpmcc RPM_SMD_BB_CLK2>) or enabled
> >>> only when requested through a special input pin on the PMIC
> >>> (clocks = <&rpmcc RPM_SMD_BB_CLK2_PIN>).
> >>>
> >>> On the Samsung Galaxy A3/A5 (2015, Qualcomm MSM8916) this mechanism
> >>> is used with S3FWRN5's NFC_CLK_REQ output GPIO to enable the clock
> >>> only when necessary. However, to make that work the s3fwrn5 driver
> >>> must keep the RPM_SMD_BB_CLK2_PIN clock enabled.
> >>
> >> This contradicts the code. You wrote that pin should be kept enabled
> >> (somehow... by driver? by it's firmware?) but your code requests the
> >> clock from provider.
> >>
> > 
> > Yeah, I see how that's a bit confusing. Let me try to explain it a bit
> > better. So the Samsung Galaxy A5 (2015) has a "S3FWRN5XS1-YF30", some
> > variant of S3FWRN5 I guess. That S3FWRN5 has a "XI" and "XO" pin in the
> > schematics. "XO" seems to be floating, but "XI" goes to "BB_CLK2"
> > on PM8916 (the main PMIC).
> > 
> > Then, there is "GPIO2/NFC_CLK_REQ" on the S3FWRN5. This goes to
> > GPIO_2_NFC_CLK_REQ on PM8916. (Note: I'm talking about two different
> > GPIO2 here, one on S3FWRN5 and one on PM8916, they just happen to have
> > the same number...)
> > 
> > So in other words, S3FWRN5 gets some clock from BB_CLK2 on PM8916,
> > and can tell PM8916 that it needs the clock via GPIO2/NFC_CLK_REQ.
> > 
> > Now the confusing part is that the rpmcc/clk-smd-rpm driver has two
> > clocks that represent BB_CLK2 (see include/dt-bindings/clock/qcom,rpmcc.h):
> > 
> >   - RPM_SMD_BB_CLK2
> >   - RPM_SMD_BB_CLK2_PIN
> > 
> > (There are also *_CLK2_A variants but they are even more confusing
> >  and not needed here...)
> > 
> > Those end up in different register settings in PM8916. There is one bit
> > to permanently enable BB_CLK2 (= RPM_SMD_BB_CLK2), and one bit to enable
> > BB_CLK2 based on the status of GPIO_2_NFC_CLK_REQ on PM8916
> > (= RPM_SMD_BB_CLK2_PIN).
> > 
> > So there is indeed some kind of "AND" inside PM8916 (the register bit
> > and "NFC_CLK_REQ" input pin). To make that "AND" work I need to make
> > some driver (here: the s3fwrn5 driver) enable the clock so the register
> > bit in PM8916 gets set.
> 
> Thanks for the explanation, it sounds good. The GPIO2 (or how you call
> it NFC_CLK_REQ) on S3FWRN5 looks like non-configurable from Linux point
> of view. Probably the device firmware plays with it always or at least
> handles it in an unknown way for us.
> 

FWIW, I was looking at some more s3fwrn5 code yesterday and came
across this (in s3fwrn5_nci_rf_configure()):

	/* Set default clock configuration for external crystal */
	fw_cfg.clk_type = 0x01;
	fw_cfg.clk_speed = 0xff;
	fw_cfg.clk_req = 0xff;
	ret = nci_prop_cmd(info->ndev, NCI_PROP_FW_CFG,
		sizeof(fw_cfg), (__u8 *)&fw_cfg);
	if (ret < 0)
		goto out;

It does look quite suspiciously like that configures how s3fwrn5 expects
the clock and possibly (fw_cfg.clk_req?) how GPIO2 behaves. But it's not
particularly useful without some documentation for the magic numbers.

Personally, I just skip all firmware/RF configuration (which works thanks
to commit 4fb7b98c7be3 ("nfc: s3fwrn5: skip the NFC bootloader mode")).
That way, S3FWRN5 just continues using the proper configuration
that was loaded by the vendor drivers at some point. :)

Stephan
