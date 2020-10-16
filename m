Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468A8290A52
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410822AbgJPRLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:11:34 -0400
Received: from mout.gmx.net ([212.227.17.21]:60943 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408728AbgJPRLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 13:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1602868284;
        bh=JieJcBG0b0Xm0jWtZAIE1MpjF///Ntzyj5Fovqz7sug=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=dXrL3Cl7HLw/a/sslrEMalCMXZ1RivXwGTHZbuE2zjly9LCaD08BfaoD3l0yaEdul
         yBVEziXmo6MBtVAZ96+lCyfnJTlxi6vbV7qz2LSWM/B1YfnRFKegqq+TkFLsR+WrOg
         agl1yV80PJ8ZtPE9OU8+pe43uudnVypuHBOjQBew=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.simpson.net ([188.174.240.147]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MjS54-1k1KZK0wBO-00kzej; Fri, 16
 Oct 2020 19:11:24 +0200
Message-ID: <42ff951039f3c92def8490d3842e3f7eaf6900ff.camel@gmx.de>
Subject: Re: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
From:   Mike Galbraith <efault@gmx.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Date:   Fri, 16 Oct 2020 19:11:22 +0200
In-Reply-To: <20201016142611.zpp63qppmazxl4k7@skbuf>
References: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
         <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
         <20201016142611.zpp63qppmazxl4k7@skbuf>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9fm5eU4B/GF1JUTzWSwVcv7rIbpgijo5D+ju+bfaKSRe5C0L1+Q
 2FRImbRBw9tVOrpFVHrlOwS05ubQ6KKCWt1OfZo4gmFWP4k48+XZ4t65q7qym3aChyDI1IZ
 4FouCMoKN6BPNDNhKky8sm0bBCezwdFef6Jr4bzbpVr2l1GvJm+iOr8V47tUr7rBCzc/oP+
 R3i/HHcqX3P4nqtIw9jSA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zX2/mOzkWLs=:/xI2L0JXKQg/C9IzWuB3gw
 kE8/o6CfR6giCQHJl6h1a9m97U2G9EC5bsLsZQkLFtzbuw0n17RHp/9mjB4LwdF+h09+mA+Ig
 A+SpzRnNgmURMSx9WEtbNIZXpaBwIVwHp0k/cG1rsjK6SqegJaaTXF6OsaKvDQHq3SN4C5Cos
 XqcU1/fyHeTm82xToYin0d7tAzOFis+qI0A7S7OSL0cG0DjEkSh7vy+hmqNlRT4k8Y06sNdBz
 7ic76H3NrsUOFh4GlLUPz2G7gM+PQ0I8jHUEP0Yn+QA0qBNljrDIDTYXcgdLSWLH2WAkVasm/
 sGmLdZ2SeLLMiQ+xvd7/5wySaPmf0Hy0CbPoIX+xMuWtIwzm215/lVPoQp/vVXf9LYu5mD/SG
 BH6j3oIks41KxhCdt80BoJmMC4h6w/9VF3XRJniUtcBnDqKSv2OaCFPAdRv0QClVLf4c1cvGy
 TA+Iplok64PXhJK24a6drZ1IIwpzcLNm8U5JuD7dJF8hgK3MQM1ri1XJ66fagOjFbK6a+AYIe
 YFCixVMopamh22XoOWxFVWIumMDXhwh5IZT8Q3cMGA2bY6ALGa/kcAtyWUNABkdzaWrmrwTKm
 gLoBoa1gdCTNZoK9z86Rm98wYyv8KwSeMQBpFonA/JT1MJ2I3F+TilsD+k+9RZ8Vyh5C1W/Dz
 Qa1fdOsNC4XBW4zrY7LAJjyTbpOqfNDkyxbvCfhQBdnq2UvU5aXZ7qpSuuBLj6hIWiD88wxg+
 Cnw1PklrO4H+SE/iMKNJNAUVDRjjChLdHMVF3LklO4o44AMnjbvxsJrjVsGq8z/vHhCsDk/Yo
 MvKaNwLZdDVyajd1YVf6dAbiBWnfXFPaY6h8Ii7yyiTuAWAbNLxAoJnT0IUq31RNq+h2eRQIw
 JEQDSmA0AFZI8MAEUshw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-16 at 17:26 +0300, Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 01:34:55PM +0200, Heiner Kallweit wrote:
> > I'm aware of the topic, but missing the benefits of the irqoff version
> > unconditionally doesn't seem to be the best option.
>
> What are the benefits of the irqoff version? As far as I see it, the
> only use case for that function is when the caller has _explicitly_
> disabled interrupts.

Yeah, it's a straight up correctness issue as it sits.  There is a
dinky bit of overhead added to the general case when using the correct
function though, at least on x86.  I personally don't see why we should
care deeply enough to want to add more code to avoid it given there are
about a zillions places where we do the same for the same reason, but
that's a maintainer call.

	-Mike

