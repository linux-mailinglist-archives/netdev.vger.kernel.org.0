Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F89E3F6211
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbhHXPx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:53:58 -0400
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:21794 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238437AbhHXPx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 11:53:58 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id DE80D701C1A;
        Tue, 24 Aug 2021 15:53:11 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-13-125.trex.outbound.svc.cluster.local [100.96.13.125])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 17E087019B3;
        Tue, 24 Aug 2021 15:53:09 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.13.125 (trex/6.3.3);
        Tue, 24 Aug 2021 15:53:11 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Inform-Interest: 5c645723559f1033_1629820391569_639225716
X-MC-Loop-Signature: 1629820391569:518000359
X-MC-Ingress-Time: 1629820391569
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Date:Subject:In-Reply-To:References:Cc:To:From:
        Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=l+XbIoJpmVeAnyL1nxsNAek3LZ8eCgH5+Lwv/8h1w3s=; b=2Apcq4CsDL0bEZqJGFA0OwpZQH
        SMgAbIvkcDrDVw8hpBEAQKNWwSqLudMvfoX6phZB/SMA9VV9AF+f36ZcrmhN0BrRCAZJOyl/LVF/K
        fDm7I15OmGju3hgtTIKjLm98+fFDQgbiWNyf6VALu/7uC3qJlj43RWOIt8MfCtzWV03DOlr360Sq7
        UoGw4flEurGRoMUH4ea3X0d3XQ/fhxVxJq81yaVs6niMZQVl1L9U/Je7JZTzPNgmreY8WxpW2B+Mn
        HayZhUo0zEa9U1qowX4STRd3aK/pbSspDsJErW8uulpDeNQlbv1b9KlHcukLP6q69fQ9+BTZftl8T
        VMDHY7Yg==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:36057 helo=pbcllap7)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIYjd-008tZ7-BS; Tue, 24 Aug 2021 16:53:08 +0100
Reply-To: <john.efstathiades@pebblebay.com>
From:   "John Efstathiades" <john.efstathiades@pebblebay.com>
To:     "'Jakub Kicinski'" <kuba@kernel.org>
Cc:     <linux-usb@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <woojung.huh@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>    <20210823135229.36581-6-john.efstathiades@pebblebay.com>        <20210823154022.490688a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <001b01d798c6$5b4d7b30$11e87190$@pebblebay.com> <20210824065303.17f23421@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <02d701d798f5$04a23df0$0de6b9d0$@pebblebay.com> <20210824081958.407b4009@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210824081958.407b4009@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: RE: [PATCH net-next 05/10] lan78xx: Disable USB3 link power state transitions
Date:   Tue, 24 Aug 2021 16:52:45 +0100
Organization: Pebble Bay Consulting Ltd
Message-ID: <02dc01d79900$20a60580$61f21080$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQHPAB61dMYAY/LsGMENMAjMWftvdQFrXfllAlVKFxsBlFp99AImpXjOAZ+0+pYBLhbmb6tBs5Ow
X-AuthUser: john.efstathiades@pebblebay.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> > I like the sound of the device match list but I don't know what you
> mean.
> > Is there a driver or other reference you could point me at that provides
> > additional info?
> 
> Depends on what the discriminator is. If problems happen with
> a particular ASIC revisions driver needs to read the revision
> out and make a match. If it's product by product you can use
> struct usb_device_id :: driver_info to attach metadata per
> device ID. If it's related to the platform things like DMI
> matching are sometimes used. I have very limited experience
> with Android / embedded ARM so not sure what would work there.

Thanks. Based on that I will remove this change from the patch set and
discuss again with the driver maintainer.

