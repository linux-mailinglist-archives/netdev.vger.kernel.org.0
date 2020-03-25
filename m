Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C81923B8
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgCYJJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:09:09 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:55013 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgCYJJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1585127348; x=1616663348;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=h3D0NCVSbEC3BsIeS2nf3ue/BJtek3dB0ea1f8pAayI=;
  b=VYsofkI5GQk9Hq4eCvRacF9/ziTxkiBz2yLmvyr6Hv+1gclVLSuKoSbY
   zBGwufUDNDeBgfYH1yfjJg+wGj0DURMoQlxSHc6RRrjqHYVfXrpzT4Bw1
   fNqAOFQUaoS/9BsJHaVwbNbgWtt/IW3NJQCO510nOfIcfPo+JzlvpItPT
   Q=;
IronPort-SDR: 5fyaJRUXo27gQ7xOwJCXveJgASjUAN+PksXFB988cxcd+iyUVHFXb1/s0YYVHVoErwL0mtTPx6
 od46ziJImSsw==
X-IronPort-AV: E=Sophos;i="5.72,303,1580774400"; 
   d="scan'208";a="22806701"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 25 Mar 2020 09:08:54 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 1F989A28A1;
        Wed, 25 Mar 2020 09:08:54 +0000 (UTC)
Received: from EX13D08EUB003.ant.amazon.com (10.43.166.117) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Wed, 25 Mar 2020 09:08:53 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Mar 2020 09:08:53 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Wed, 25 Mar 2020 09:08:53 +0000
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
Thread-Index: AdYB/A9gUHrWytm4Shy+qOrUZLrOXwAiGDTQ
Date:   Wed, 25 Mar 2020 09:08:41 +0000
Deferred-Delivery: Wed, 25 Mar 2020 09:07:03 +0000
Message-ID: <27592a4ede644fcc8e80725cc5302729@EX13D11EUB003.ant.amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.80]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jubran, Samih
> Sent: Tuesday, March 24, 2020 7:03 PM
> To: 'David Miller' <davem@davemloft.net>; 'gpiccoli@canonical.com'
> <gpiccoli@canonical.com>
> Cc: Belgazal, Netanel <netanel@amazon.com>; Kiyanovski, Arthur
> <akiyano@amazon.com>; 'netdev@vger.kernel.org'
> <netdev@vger.kernel.org>; Tzalik, Guy <gtzalik@amazon.com>; Bshara,
> Saeed <saeedb@amazon.com>; Machulsky, Zorik <zorik@amazon.com>;
> 'kernel@gpiccoli.net' <kernel@gpiccoli.net>; 'gshan@redhat.com'
> <gshan@redhat.com>; 'gavin.guo@canonical.com'
> <gavin.guo@canonical.com>; 'jay.vosburgh@canonical.com'
> <jay.vosburgh@canonical.com>; 'pedro.principeza@canonical.com'
> <pedro.principeza@canonical.com>
> Subject: RE: Re: [PATCH] net: ena: Add PCI shutdown handler to allow safe
> kexec
>=20
>=20
>=20
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On
> > Behalf Of David Miller <davem@davemloft.net>
> > Sent: Tuesday, March 24, 2020 6:05 AM
> > To: gpiccoli@canonical.com
> > Cc: netanel@amazon.com; akiyano@amazon.com;
> netdev@vger.kernel.org;
> > gtzalik@amazon.com; saeedb@amazon.com; zorik@amazon.com;
> > kernel@gpiccoli.net; gshan@redhat.com; gavin.guo@canonical.com;
> > jay.vosburgh@canonical.com; pedro.principeza@canonical.com
> > Subject: Re: [PATCH] net: ena: Add PCI shutdown handler to allow safe
> > kexec
> >
> > From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
> > Date: Fri, 20 Mar 2020 09:55:34 -0300
> >
> > > Currently ENA only provides the PCI remove() handler, used during
> > > rmmod for example. This is not called on shutdown/kexec path; we are
> > > potentially creating a failure scenario on kexec:
> > >
> > > (a) Kexec is triggered, no shutdown() / remove() handler is called
> > > for ENA; instead pci_device_shutdown() clears the master bit of the
> > > PCI device, stopping all DMA transactions;
> > >
> > > (b) Kexec reboot happens and the device gets enabled again, likely
> > > having its FW with that DMA transaction buffered; then it may
> > > trigger the (now
> > > invalid) memory operation in the new kernel, corrupting kernel
> > > memory
> > area.
> > >
> > > This patch aims to prevent this, by implementing a shutdown()
> > > handler quite similar to the remove() one - the difference being the
> > > handling of the netdev, which is unregistered on remove(), but
> > > following the convention observed in other drivers, it's only detache=
d on
> shutdown().
> > >
> > > This prevents an odd issue in AWS Nitro instances, in which after
> > > the 2nd kexec the next one will fail with an initrd corruption,
> > > caused by a wild DMA write to invalid kernel memory. The lspci
> > > output for the adapter present in my instance is:
> > >
> > > 00:05.0 Ethernet controller [0200]: Amazon.com, Inc. Elastic Network
> > > Adapter (ENA) [1d0f:ec20]
> > >
> > > Suggested-by: Gavin Shan <gshan@redhat.com>
> > > Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> >
> > Amazon folks, please review.
>=20
> The patch is still under review we will reply as soon as we have finished
> testing it, Thanks

Acked-by: Sameeh Jubran <sameehj@amazon.com>
