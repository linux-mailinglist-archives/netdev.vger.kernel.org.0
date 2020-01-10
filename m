Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355B413749A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgAJRTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:19:41 -0500
Received: from mout.gmx.net ([212.227.15.19]:52795 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbgAJRTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 12:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578676777;
        bh=Z9j0JlsYSZzWv7dKStdW/uMUsqSHDhxqWRN7DaEcF1s=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=UwlPdTWvaBfJp0iulhJ5/rOW4MAP/ZE/e0WEdnuPpPZ5gmGOXzGhSUqVc6dxIMPV3
         47XdDOMp4egHE+l4MzZRqjA8fBNIXIMJIpK+hvfvnPLPnUGtoxLmUxZ34YmXGh4pMx
         mBGsk65xnpXvVgkPTMS1+YfSjlholWFLTknkpKIg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([31.29.34.215]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M7sDg-1im64A3x10-004yg1; Fri, 10
 Jan 2020 18:19:37 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
 <20200110114433.GZ25745@shell.armlinux.org.uk>
 <7b6f143a-7bdb-90be-00f6-9e81e21bde4e@gmx.net>
 <20200110125305.GB25745@shell.armlinux.org.uk>
 <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
 <20200110150955.GE25745@shell.armlinux.org.uk>
 <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
 <20200110163235.GG25745@shell.armlinux.org.uk>
 <717229a4-f7f6-837d-3d58-756b516a8605@gmx.net>
 <20200110170836.GI25745@shell.armlinux.org.uk>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <12956566-4aa3-2c5d-be1a-8612edab3b3d@gmx.net>
Date:   Fri, 10 Jan 2020 17:19:35 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200110170836.GI25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:O3N6VECuYyQ3oiGt719Qm73BjCGY1xcHLUHTEyX22C2iQ1m006q
 7WW0p+G/0W1q/Uuim0x+9OTYTCa8yMuwcstrwPoICSJfmMTrJ7b2X7oCz4xajL3raWTau1L
 LjS9L5zIRlPPtU7TFyU1vqR3BIkscLCsdKecQFKY3bUE1HHi6LSU+T3q/ykZpQb8LOrTLqk
 FtyMGdRMhhfxG1/pClSmA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oYopUlHbytw=:HBSxEmn1xlwamzSbY8Ygnb
 jUWJSGzSSGWUEFTuzKLv0lO7cAo7ga6c2i9qmNfyY45D0335+zd5RGxMDvaYki22Fbjs7a1YH
 NGxYXHXbRLvmYAeBpligr0smEGOAMg9E77Xj3TXySIECjIKg/djJ1Dgs5Kmm+T4EQn++s7rsW
 zQWNEgNXzN8xMkk+LUCi5g+xq2OVkRUEqVUrCl/dZB4smKstbWwlwCknRYLVnvDyKuYEOo5S9
 eCt3MRpu9QCiRLRUIRWfMzY1xDeGxCOH41aUcdzP6jiPYzuLQr6LWM8JnlYMp483RoLpwq7Tc
 9UtY330Oi/qwZiaWaLyuJwtoMCBOSvkQMbHoC7TmHWGl4XZtGllfwgqP6YS2o04R2H3C/Alvr
 VOKZygr9SrMOAWy4miapmOYfz0Y2NPfQTS/WM4AwprQowJTqMnfjtkmCkCd1OduVD1z47nJkw
 nAzSomVjuG185DxSSar0STQzsDsY6C37gySFSxMyRZDHJUIvMZ513fLtbhxRBk0c8On0fRDDq
 rpooA1faxiPcoWILZbWrJLnQLnrHVOWGan7bhw646g06q+hFwQjFhaUaH5+SNo7KwuXoapNiP
 c/z86ckpEuNYqU62VFI2iYEvuFlRYp18id7DozU3Pf1SPI8Z4vryXeciUrUKMqnblSOWZIJtX
 etYYK9jMRzlklcMFumQWIPWPXgUxK1x0rZwqzFV6yQkEnpAdHouF2e0M0sU7EH2v1+19BHoX0
 in/t0kwDy3jZuhn3wMr6AO3Z+84uL6XgPiclZf62bpPCSifAO75aq5N4vPV3YIPeklXuvAxPr
 DNbMmn7eoWJ0lqWm7Tk4AB2fTn9IATLveo2jeczFoKPyq+wtpWIZodkClhdVeLy8rlT8iv7An
 UMt+6RaPJVqQFmycC17RlaFzytn6ll/qMYI4zddUaJbyPaShb0syjsBnvTgwkq9DO3hkXZRfR
 bcA7HUZEYF5xPkdoaZRkrAP/ML1LOjVX+zIDv60Fh31UURGsKGDhX4GWXpFRtSxiQWHre+h5D
 wRJImlcu30HCP2GT4omI2XR+hhZOysadkC243BZ3rDd2m1GRrdurxcrbTbUjun5QADwXx0FCf
 nvFTH4GvvkuvDTERSTPjwipqtmczix9ai7PLmuFkFay7z2QvACs8EHDrS1o1t10oVrHs7BaLo
 0lMtwIY5wKEZc231YZIk19rO7zYZPnB+/c3ZxgBHHNuK2fVFMATFSIEz7S0NoB5z/tpYFueSY
 ETBq35AMA3NsUZVjxX4nXY/hFH1bXZHjiUIan/A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/01/2020 17:08, Russell King - ARM Linux admin wrote:
> On Fri, Jan 10, 2020 at 04:53:06PM +0000, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=
=E2=84=A0 wrote:
>> Seems that the debug avenue has been exhausted, short of running SFP.C=
 in
>> debug mode.
> You're saying you never see TX_FAULT asserted other than when the
> interface is down?

Yes, it never exhibits once the iif is up - it is rock-stable in that=20
state, only ever when being transitioned from down state to up state.
Pardon, if that has not been made explicitly clear previously.

