Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F4D191728
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgCXRD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:03:27 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:3917 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgCXRD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1585069407; x=1616605407;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=cseszdOsxfD1nX0W8vhYeWuspINh8AbHgWvCC5KwW04=;
  b=oIcTUSazb+ld+l/hlzY9ud/ZsEDG4BXBBt0CxcgtuTvZ7Isfp55Ydskb
   KB9T6x0dptx6/bQq/X0DTqGRIuaD8NoltRX+NdCQJlpwuf8/RtbusDOh1
   2jyiimWUbVUHWRVL4vX44iN+owSNBiqD3E+xCbniQ7ER4zeYGgY/AGh3Y
   Q=;
IronPort-SDR: T3UO1Iam/4UTM6N6mdgpuf0nTABag+H72vKeNHpaFh7I8mJhzeY4jePxbZyAFPJGO6owmOLbZf
 tah7ygCrW1nQ==
X-IronPort-AV: E=Sophos;i="5.72,301,1580774400"; 
   d="scan'208";a="23984780"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 24 Mar 2020 17:02:58 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 689C8A2E9E;
        Tue, 24 Mar 2020 17:02:56 +0000 (UTC)
Received: from EX13D08EUB003.ant.amazon.com (10.43.166.117) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 24 Mar 2020 17:02:55 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 24 Mar 2020 17:02:54 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Tue, 24 Mar 2020 17:02:54 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     David Miller <davem@davemloft.net>,
        "gpiccoli@canonical.com" <gpiccoli@canonical.com>
CC:     "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "gavin.guo@canonical.com" <gavin.guo@canonical.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>,
        "pedro.principeza@canonical.com" <pedro.principeza@canonical.com>
Subject: RE: Re: [PATCH] net: ena: Add PCI shutdown handler to allow safe
 kexec
Thread-Topic: Re: [PATCH] net: ena: Add PCI shutdown handler to allow safe
 kexec
Thread-Index: AdYB/A9gUHrWytm4Shy+qOrUZLrOXw==
Date:   Tue, 24 Mar 2020 17:02:49 +0000
Deferred-Delivery: Tue, 24 Mar 2020 17:01:20 +0000
Message-ID: <13726ba604c5439cb2a88bad83d7dec6@EX13D11EUB003.ant.amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of David Miller <davem@davemloft.net>
> Sent: Tuesday, March 24, 2020 6:05 AM
> To: gpiccoli@canonical.com
> Cc: netanel@amazon.com; akiyano@amazon.com; netdev@vger.kernel.org;
> gtzalik@amazon.com; saeedb@amazon.com; zorik@amazon.com;
> kernel@gpiccoli.net; gshan@redhat.com; gavin.guo@canonical.com;
> jay.vosburgh@canonical.com; pedro.principeza@canonical.com
> Subject: Re: [PATCH] net: ena: Add PCI shutdown handler to allow safe kex=
ec
>=20
> From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
> Date: Fri, 20 Mar 2020 09:55:34 -0300
>=20
> > Currently ENA only provides the PCI remove() handler, used during
> > rmmod for example. This is not called on shutdown/kexec path; we are
> > potentially creating a failure scenario on kexec:
> >
> > (a) Kexec is triggered, no shutdown() / remove() handler is called for
> > ENA; instead pci_device_shutdown() clears the master bit of the PCI
> > device, stopping all DMA transactions;
> >
> > (b) Kexec reboot happens and the device gets enabled again, likely
> > having its FW with that DMA transaction buffered; then it may trigger
> > the (now
> > invalid) memory operation in the new kernel, corrupting kernel memory
> area.
> >
> > This patch aims to prevent this, by implementing a shutdown() handler
> > quite similar to the remove() one - the difference being the handling
> > of the netdev, which is unregistered on remove(), but following the
> > convention observed in other drivers, it's only detached on shutdown().
> >
> > This prevents an odd issue in AWS Nitro instances, in which after the
> > 2nd kexec the next one will fail with an initrd corruption, caused by
> > a wild DMA write to invalid kernel memory. The lspci output for the
> > adapter present in my instance is:
> >
> > 00:05.0 Ethernet controller [0200]: Amazon.com, Inc. Elastic Network
> > Adapter (ENA) [1d0f:ec20]
> >
> > Suggested-by: Gavin Shan <gshan@redhat.com>
> > Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
>=20
> Amazon folks, please review.

The patch is still under review we will reply as soon as we have finished t=
esting it,
Thanks
