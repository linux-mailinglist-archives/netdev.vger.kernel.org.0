Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A446318F168
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 10:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgCWJGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 05:06:05 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:29478 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbgCWJGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 05:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584954363; x=1616490363;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=eTRwEewhiVGCSfPF/aa4t8zypabQkvkyXc1TZjKXH6A=;
  b=JTwwMAnMd5S06e8UtObhpdbH4ywDHlVlKiXvMWXkGWO0dFNA3uwGIZ9h
   ee4BK+BhsAbNJZDsr8uoTd/7Oy3kMCw80lbVaJeWqukF+HHHJg8Z/JtKY
   6pU/iSoRACycxYVpo0ViQlEhg8bUUYbtS0TFEzxNbIxBM6ldIyTLLmSXJ
   c=;
IronPort-SDR: ealZ3JvDS8GWSlcnrHuVqy+hJmt1W/63+vs0R2vAOpy3gy9C+/Sfr+grI0ksIIH+eLeiWV5cKL
 sVZfaDftZz9Q==
X-IronPort-AV: E=Sophos;i="5.72,295,1580774400"; 
   d="scan'208";a="24498837"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 23 Mar 2020 09:06:01 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 0BC1DA2241;
        Mon, 23 Mar 2020 09:05:58 +0000 (UTC)
Received: from EX13D08EUB003.ant.amazon.com (10.43.166.117) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Mon, 23 Mar 2020 09:05:58 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 23 Mar 2020 09:05:57 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Mon, 23 Mar 2020 09:05:57 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "gavin.guo@canonical.com" <gavin.guo@canonical.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>,
        "pedro.principeza@canonical.com" <pedro.principeza@canonical.com>
Subject: RE: [PATCH] net: ena: Add PCI shutdown handler to allow safe kexec
Thread-Topic: [PATCH] net: ena: Add PCI shutdown handler to allow safe kexec
Thread-Index: AdYA8dKoipYPYd26QRuHLaWYX/mvCA==
Date:   Mon, 23 Mar 2020 09:05:34 +0000
Deferred-Delivery: Mon, 23 Mar 2020 09:04:27 +0000
Message-ID: <f350a2ee513f4e3fb2a2cfa633dc0806@EX13D11EUB003.ant.amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Guilherme G. Piccoli <gpiccoli@canonical.com>
> Sent: Friday, March 20, 2020 2:56 PM
> To: netanel@amazon.com; akiyano@amazon.com; netdev@vger.kernel.org
> Cc: gtzalik@amazon.com; saeedb@amazon.com; zorik@amazon.com;
> gpiccoli@canonical.com; kernel@gpiccoli.net; gshan@redhat.com;
> gavin.guo@canonical.com; jay.vosburgh@canonical.com;
> pedro.principeza@canonical.com
> Subject: [PATCH] net: ena: Add PCI shutdown handler to allow safe kexec
>=20
> Currently ENA only provides the PCI remove() handler, used during rmmod
> for example. This is not called on shutdown/kexec path; we are potentiall=
y
> creating a failure scenario on kexec:
>=20
> (a) Kexec is triggered, no shutdown() / remove() handler is called for EN=
A;
> instead pci_device_shutdown() clears the master bit of the PCI device,
> stopping all DMA transactions;
>=20
> (b) Kexec reboot happens and the device gets enabled again, likely having=
 its
> FW with that DMA transaction buffered; then it may trigger the (now
> invalid) memory operation in the new kernel, corrupting kernel memory
> area.
>=20
> This patch aims to prevent this, by implementing a shutdown() handler qui=
te
> similar to the remove() one - the difference being the handling of the
> netdev, which is unregistered on remove(), but following the convention
> observed in other drivers, it's only detached on shutdown().
>=20
> This prevents an odd issue in AWS Nitro instances, in which after the 2nd
> kexec the next one will fail with an initrd corruption, caused by a wild =
DMA
> write to invalid kernel memory. The lspci output for the adapter present =
in
> my instance is:
>=20
> 00:05.0 Ethernet controller [0200]: Amazon.com, Inc. Elastic Network Adap=
ter
> (ENA) [1d0f:ec20]
>=20
> Suggested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
>=20
>=20
> The idea for this patch came from an informal conversation with my friend
> Gavin Shan, based on his past experience with similar issues.
> I'd like to thank him for the great suggestion!
>=20
> As a test metric, I've performed 1000 kexecs with this patch, whereas
> without this one, the 3rd kexec failed with initrd corruption. Also, one =
test
> that I've done before writing the patch was just to rmmod the driver befo=
re
> the kexecs, and it worked fine too.
>=20
> I suggest we add this patch in stable releases as well.
> Thanks in advance for reviews,
>=20
> Guilherme
>=20
>=20
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 51 ++++++++++++++++-
> ---
>  1 file changed, 41 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 0b2fd96b93d7..7a5c01ff2ee8 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -4325,13 +4325,15 @@ static int ena_probe(struct pci_dev *pdev, const
> struct pci_device_id *ent)
>=20
>=20
> /**********************************************************
> *******************/
>=20
> -/* ena_remove - Device Removal Routine
> +/* __ena_shutoff - Helper used in both PCI remove/shutdown routines
>   * @pdev: PCI device information struct
> + * @shutdown: Is it a shutdown operation? If false, means it is a
> + removal
>   *
> - * ena_remove is called by the PCI subsystem to alert the driver
> - * that it should release a PCI device.
> + * __ena_shutoff is a helper routine that does the real work on
> + shutdown and
> + * removal paths; the difference between those paths is with regards to
> + whether
> + * dettach or unregister the netdevice.
>   */
> -static void ena_remove(struct pci_dev *pdev)
> +static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
>  {
>  	struct ena_adapter *adapter =3D pci_get_drvdata(pdev);
>  	struct ena_com_dev *ena_dev;
> @@ -4350,13 +4352,17 @@ static void ena_remove(struct pci_dev *pdev)
>=20
>  	cancel_work_sync(&adapter->reset_task);
>=20
> -	rtnl_lock();
> +	rtnl_lock(); /* lock released inside the below if-else block */
>  	ena_destroy_device(adapter, true);
> -	rtnl_unlock();
> -
> -	unregister_netdev(netdev);
> -
> -	free_netdev(netdev);
> +	if (shutdown) {
> +		netif_device_detach(netdev);
> +		dev_close(netdev);
> +		rtnl_unlock();
> +	} else {
> +		rtnl_unlock();
> +		unregister_netdev(netdev);
> +		free_netdev(netdev);
> +	}
>=20
>  	ena_com_rss_destroy(ena_dev);
>=20
> @@ -4371,6 +4377,30 @@ static void ena_remove(struct pci_dev *pdev)
>  	vfree(ena_dev);
>  }
>=20
> +/* ena_remove - Device Removal Routine
> + * @pdev: PCI device information struct
> + *
> + * ena_remove is called by the PCI subsystem to alert the driver
> + * that it should release a PCI device.
> + */
> +
> +static void ena_remove(struct pci_dev *pdev) {
> +	__ena_shutoff(pdev, false);
> +}
> +
> +/* ena_shutdown - Device Shutdown Routine
> + * @pdev: PCI device information struct
> + *
> + * ena_shutdown is called by the PCI subsystem to alert the driver that
> + * a shutdown/reboot (or kexec) is happening and device must be disabled=
.
> + */
> +
> +static void ena_shutdown(struct pci_dev *pdev) {
> +	__ena_shutoff(pdev, true);
> +}
> +
>  #ifdef CONFIG_PM
>  /* ena_suspend - PM suspend callback
>   * @pdev: PCI device information struct @@ -4420,6 +4450,7 @@ static
> struct pci_driver ena_pci_driver =3D {
>  	.id_table	=3D ena_pci_tbl,
>  	.probe		=3D ena_probe,
>  	.remove		=3D ena_remove,
> +	.shutdown	=3D ena_shutdown,
>  #ifdef CONFIG_PM
>  	.suspend    =3D ena_suspend,
>  	.resume     =3D ena_resume,
> --
> 2.25.1
>=20


Hi=20
Guilherme,

Thank you for the patch, we are currently looking into your patch and testi=
ng it.

Thanks,
Sameeh

