Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFF83420D5
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCSPWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:22:50 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:11552 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhCSPWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:22:24 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1616167159; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=aYCO4DQQhlORuE+cq+TGogVzWTWWzsvrR0cRRzU0/hZDSkLmb/obl44X2VdXFgap0a
    oodLDXffioFYOGG9pvY55bRkWkU8cxTwmFtK16FGLqpD/JEKl0ijbDv/LSCisvott9kk
    UOzYI5gNxhpFmlqPF2eqkBcAAoks7euVaJZ1tOaeoC7brJfwM+vtp8HmC8qee5LLQvKh
    46ZU7ND3rGRX86CyKhFNh3IHzUqpEPquNhImTysGW0FXI7q1G/OqWRFmHgotRLECGWRx
    2z1LXiqABuRlsLcrSRf8gvagx5T3sYfd1MuCyshm4gVfMSjKXIUxhVESrrXbNrBskth1
    7ZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1616167159;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=AKOqFWwkTKX0gmc5FtpmyCaMS1mYuj+WZ1NRA7Dh9/Y=;
    b=lJU5RPf+vAsBvwqW0yVHEriRcwbNBH7qvjuhe/YUMYpzBAhsI7AiU5vW2KRLH5teLN
    nSEL1UUhCQIcHdiONwnDbqW5qNH0eIN8VQPM+5et6jGP54p2I/GnytJ5HVUn0HKvdCkK
    r0awGN2dOePl/CCaUnSZTvbOKF5KBQZmKiiYAoyzTE17oP7u4bNPvyPp8CRxcmnlU1Qg
    VR9P7q7H6IOoCPMIyB7Dth6ziLRhlDhf49GYckcN7zV6gPjtIvOTbAeh/7hF28IA+Vi5
    ClIJsDONjeAuSG7fsEpZyR5znBsHfI8ynPm9mnJKwZQaUJN2Y4OYgzfESkmEGDALC2Yg
    53zQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1616167159;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=AKOqFWwkTKX0gmc5FtpmyCaMS1mYuj+WZ1NRA7Dh9/Y=;
    b=aMWgft27kqzbjQK+j8v+Pk6yeXXJavo9ChQKOcbFWf+MYBGhr4OhHmlh7nbhAKrYHg
    kpcqKiIkrzX+DxqGXtCwkM+WRZBVQ2ArntyACV5rvIHBs3+1vIXlWSFOx5/lCImcaPvp
    LY9FGkyj/U/2ihbWaVrqwZaCUza/vSjPG4cZ/OyZtTPRPZqhGUjx0RyzfbgjoMHxW7AY
    h22+z9Y8q+VHxCFMxiSPG6fEGp81ERxbygmkagZ7Qt2lTVsl/xahYcyegOap5e25jpfz
    o6kd4RAix7gRDYQr3XzdBBEX9TS3+xw9YxwyP7tqteZwshVbNj9uTvuCAkPQ1yWaHLiw
    seSA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j7Icip"
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.21.0 DYNA|AUTH)
    with ESMTPSA id Q03f86x2JFJIGSS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 19 Mar 2021 16:19:18 +0100 (CET)
Date:   Fri, 19 Mar 2021 16:19:14 +0100
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Andy Gross <agross@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] arm64: dts: qcom: msm8916: Enable modem and WiFi
Message-ID: <YFTA8gEPp1x6o/9f@gerhold.net>
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
 <20210312003318.3273536-6-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312003318.3273536-6-bjorn.andersson@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

On Thu, Mar 11, 2021 at 04:33:18PM -0800, Bjorn Andersson wrote:
> Enable the modem and WiFi subsystems and specify msm8916 specific
> firmware path for these and the WCNSS control service.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

The changes itself look good to me, but the commit message is really
misleading. It does not mention anywhere that the change actually just
enables "modem" on apq8016-sbc instead of "msm8916". :)

Also, WCNSS was actually enabled before already (with the default
firmware path). In my opinion, it would be clearer to change the
firmware-name for it in an extra patch.

> ---
>  arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi | 12 ++++++++++++
>  arch/arm64/boot/dts/qcom/msm8916.dtsi     |  2 +-
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
> index 6aef0c2e4f0a..448e3561ef63 100644
> --- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
> +++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
> @@ -305,6 +305,12 @@ &mdss {
>  	status = "okay";
>  };
>  
> +&mpss {
> +	status = "okay";
> +
> +	firmware-name = "qcom/msm8916/mba.mbn", "qcom/msm8916/modem.mbn";
> +};
> +
>  &pm8916_resin {
>  	status = "okay";
>  	linux,code = <KEY_VOLUMEDOWN>;
> @@ -312,6 +318,8 @@ &pm8916_resin {
>  
>  &pronto {
>  	status = "okay";
> +
> +	firmware-name = "qcom/msm8916/wcnss.mbn";
>  };
>  

How do I get a .mbn from the wcnss.{mdt,.b??} files provided in the
DB410c firmware package? I guess I should just run them through
https://github.com/andersson/pil-squasher?

Also, is the single file format (mbn) preferred now? Not sure if there
is any significant difference except having less files laying around.

Thanks,
Stephan
