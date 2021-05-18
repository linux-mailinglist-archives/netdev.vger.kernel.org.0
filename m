Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2626B3880A9
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 21:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351916AbhERTod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 15:44:33 -0400
Received: from msg-2.mailo.com ([213.182.54.12]:39160 "EHLO msg-2.mailo.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239361AbhERToc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 15:44:32 -0400
X-Greylist: delayed 1440 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2021 15:44:32 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailoo.org; s=mailo;
        t=1621365538; bh=SOKZhfbRC9Pxh+E+B9Jim/4njEcIPdr7MCczTSyxEvg=;
        h=X-EA-Auth:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
         References:Content-Type:MIME-Version:Content-Transfer-Encoding;
        b=by1P4bDlrjWbhW8Zu6f1zmqEEAW2AIsAtju8cFtQ0yMmfz4lqcYzKDIRq/UB19TtQ
         ObpsViLzdB+yijna/wSaTMMxHdYevLbCHIJ/DdxJ/PfjKnIRFj3Ndzl/wUBenkRvgu
         vj6bnnq7/MtDFaJMfIDu7eZy41GF8rCStSAZN20Y=
Received: by 192.168.90.13 [192.168.90.13] with ESMTP
        via proxy.mailoo.org [213.182.55.207]
        Tue, 18 May 2021 21:18:58 +0200 (CEST)
X-EA-Auth: azT5fbq4qyjbROh0nktYyillwM9rizpi0s6FGCPrEKSu3cj8CFFiRFl1g9iZf8wMgQSQZ+25ygsivZKugyUJYcgam4kawsWHA62WxPNCb8M=
Message-ID: <f4ad7e8ebf520e0057ce912ea37b7d0a63112253.camel@mailoo.org>
Subject: Re: Testing wanted for Linux NFC subsystem
From:   Vincent Knecht <vincent.knecht@mailoo.org>
To:     Mark Greer <mgreer@animalcreek.com>,
        Stephan Gerhold <stephan@gerhold.net>
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Alex Blasche <alexander.blasche@qt.io>,
        phone-devel@vger.kernel.org
Date:   Tue, 18 May 2021 21:18:56 +0200
In-Reply-To: <20210514152350.GA301895@animalcreek.com>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
         <14e78a9a-ed1a-9d7d-b854-db6d811f4622@kontron.de>
         <20210512170135.GB222094@animalcreek.com> <YJ0SYWJjq3ZmXMy3@gerhold.net>
         <20210513144855.GA266838@animalcreek.com> <YJ1Hr/hov9I42GK1@gerhold.net>
         <20210514152350.GA301895@animalcreek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le vendredi 14 mai 2021 =C3=A0 08:23 -0700, Mark Greer a =C3=A9crit=C2=A0:
> On Thu, May 13, 2021 at 05:37:19PM +0200, Stephan Gerhold wrote:
> > On Thu, May 13, 2021 at 07:48:55AM -0700, Mark Greer wrote:
> > > On Thu, May 13, 2021 at 01:49:53PM +0200, Stephan Gerhold wrote:
> > > > I have a couple of "recycled" smartphones running mainline Linux
> > > > and some of them do have NFC chips. I have two with NXP PN547
> > > > (supported by nxp,nxp-nci-i2c), one with Samsung S3FWRN5
> > > > (samsung,s3fwrn5-i2c) and even one with Broadcom BCM2079x I think
> > > > (this one does not have a driver for the Linux NFC subsystem sadly)=
.
> > > >=20
> > > > +Cc phone-devel@vger.kernel.org, in case other people there are
> > > > interested in NFC :)
> > > >=20
> > > > The NXP/Samsung ones seems to work just fine. However, since there =
are
> > > > barely any userspace tools making use of Linux NFC all my testing s=
o far
> > > > was limited to polling for devices with "nfctool" and being happy e=
nough
> > > > when it realizes that I hold some NFC tag close to the device. :S
> > >=20
> > > There is a user-level daemon that is the counterpart for the in-kerne=
l
> > > NFC subsystem.=C2=A0 It is called neard and is available here:
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/=
pub/scm/network/nfc/neard.git
> > >=20
> > > There are a few test script in it that will let you read and write NF=
C
> > > tags, and do some other things.=C2=A0 We can add some more tests to t=
hat set
> > > as we go.
> > >=20
> >=20
> > Yeah, I packaged that for Alpine Linux / postmarketOS.
> > "nfctool" also comes from "neard" as far as I can tell :)
> >=20
> > I think I also played with the Neard test scripts a bit at some point,
> > and managed to read some NFC tag thing inside an old Yubikey NEO
> > that I found, but didn't really know what else to do.
>=20
> Yeah, there isn't a whole lot you can do but beyond reading/writing
> tags and peer-to-peer, there are things like Bluetooth and Wifi
> handover, Android Application Record support, and at least some
> support for Secure Engine.

Could sniffing and injection work, like for wifi ?
Guess that depends on specific chip drivers, and libpcap support for sniffi=
ng ?

https://wiki.wireshark.org/SampleCaptures#Radio_Frequency_Identification_.2=
8RFID.29.2C_and_Near-Field_Communication_.28NFC.29

https://code.google.com/archive/p/wireshark-nfc/




