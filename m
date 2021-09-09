Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673D9405B01
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 18:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbhIIQjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 12:39:25 -0400
Received: from mout.gmx.net ([212.227.17.20]:40991 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232192AbhIIQjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 12:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631205478;
        bh=AcoWfISMmSRxRwrW9cBuZAkdzhm3K1/Gv0P6x1L+XXU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=jCP1dWITibONQMgaY41e8PfDw8mzAH7IBZlHdMQrWL6ohKWFY396nfFREtuPh94pX
         TAr2SHVQ7lZ+ffxRl5x6pNrUVkwqUBULGpSc5We3BOKIdqZHfFSYpYykPTbXL4EBTe
         UNT5Ks0z5jDT+Bqy2KqabmTxSo62fYZaBmukI3TQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MUowb-1mXTqZ2Rrl-00QiOL; Thu, 09
 Sep 2021 18:37:58 +0200
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
Date:   Thu, 9 Sep 2021 18:37:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210909154734.ujfnzu6omcjuch2a@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1Ru23UaOAWy66EVAPf/EG78zT/yDgW/qqZe+D04/NG5EjM+hhfb
 8Uf8mADoUCPevy2o3gRRQragmd7OLCUME2bdom78LbVsTYHuISVO7Zfb2lF6ZzbOheQ+yXB
 Rdpexglw/TpaXRBn5nS5voda6FOa7ZdOAJOlURynxql2SYPajZ0ql5Pd3t0nHLxGfG31TxN
 sQ9YZbqP7xSmE5NWN4v7w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Rveiws+0Ppo=:4e808q+04uSjabpxw7g9ob
 Lmwke7B7eahHpLF8qQbdlrwdD70kiDI/RwfkqMJqybYL0YRwMAPRVXkPO4o8vHEBKddQ7QxBI
 m1SHcBWVaQgAN33dDFDpo9afUuyj9oPuzhK+dvrWViYXiKAbe5TOh/0B2K34YDe5cN6JN+ouN
 1sIPr0o7MKO1w9aZYsK3bOuKaAjX+C7OFq/hy6h5tAO5YydnrIau5E8dpu0PAwkEQCgWUV1Ly
 MnXtLJ/ebuF0Fy8npIgrcv6ane53ZFYcM0n8jW7FM50g+6wMvYt9D/RlNTY7X0u+7UnJT6M8n
 RNoHAWwLhpL2qo2lt0tyz+4B7SVWBGNg8M3OGKCa66OlCQNDhPEHAVmUIiMWJgPo2aZmt3Cp/
 jT1wUqYHw13HBJeh9cBQM8sR2J6QfYI6FRZt3BhSO2tvYaFNQPuT3nhMyDXta3KW/1Gtbbs9h
 gtBh1sdZ7jZG1Gqeqnkh94qhuIdpiZF0LJkzaf2G+u5XPJ1TkbyqVsZFJjjBTWp5FTblkaokk
 2lTe+QRg18a852sShXmlFmVX3C9/SJQVnV+EGfoVTMDsyCrRz56gCxt1TzQoKJpCLKuYB8YeV
 MOQOF1bpmD9uhLMKwBdFTBzzzBKwD31R0abIfYX43yE41ke/rrAgZiotBitJrFvgAu7ZdCG0V
 ErVU5SG3gYEazE0PZ6wVqBrVSThCv62/PkR3+FjU6rJZaArBIpEJBFiXiNcN2tSO15ldH0iEg
 voL68huEY601OPjdoYQax4EA/rNKoUk4vegiz3O7kG2t0rpXDP32pecQi1Bv38uNKIEAvFFWw
 DOxMs8xosW4hEPfu6kat6FSPoFzR3klZRy9vJ31pqWgVregqDxxDh5gAzuxCt572nng0eLx2b
 +AzhAo3+RrLLR8S/LwslkpB+j8rWtyaumhrq62U/tIQOgFKG1EciDwkzMwNxu9bpRRfowmQCO
 qCapUbu6q81pH4IFnqFTMmTUawU33BPtVWxCcRgvgK30ub2BO4jat3i9A1gIA8lw/El66GJ8c
 1L+ToMLj1BOTqChzK68LVOH4DgWLCf5xuGRFrb9yI0Yu+mvme8urQ5/tmReLJojbnoR0QcB+q
 zpdanEXOKqUasg=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.09.21 at 17:47, Vladimir Oltean wrote:
> On Thu, Sep 09, 2021 at 03:19:52PM +0200, Lino Sanfilippo wrote:
>>> Do you see similar things on your 5.10 kernel?
>>
>> For the master device is see
>>
>> lrwxrwxrwx 1 root root 0 Sep  9 14:10 /sys/class/net/eth0/device/consum=
er:spi:spi3.0 -> ../../../virtual/devlink/platform:fd580000.ethernet--spi:=
spi3.0
>
> So this is the worst of the worst, we have a device link but it doesn't =
help.
>
> Where the device link helps is here:
>
> __device_release_driver
> 	while (device_links_busy(dev))
> 		device_links_unbind_consumers(dev);
>
> but during dev_shutdown, device_links_unbind_consumers does not get call=
ed
> (actually I am not even sure whether it should).
>
> I've reproduced your issue by making this very simple change:
>
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/n=
et/ethernet/freescale/enetc/enetc_pf.c
> index 60d94e0a07d6..ec00f34cac47 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -1372,6 +1372,7 @@ static struct pci_driver enetc_pf_driver =3D {
>  	.id_table =3D enetc_pf_id_table,
>  	.probe =3D enetc_pf_probe,
>  	.remove =3D enetc_pf_remove,
> +	.shutdown =3D enetc_pf_remove,
>  #ifdef CONFIG_PCI_IOV
>  	.sriov_configure =3D enetc_sriov_configure,
>  #endif
>
> on my DSA master driver. This is what the genet driver has "special".
>

Ah, that is interesting.

> I was led into grave error by Documentation/driver-api/device_link.rst,
> which I've based my patch on, where it clearly says that device links
> are supposed to help with shutdown ordering (how?!).
>
> So the question is, why did my DSA trees get torn down on shutdown?
> Basically the short answer is that my SPI controller driver does
> implement .shutdown, and calls the same code path as the .remove code,
> which calls spi_unregister_controller which removes all SPI children..
>
> When I added this device link, one of the main objectives was to not
> modify all DSA drivers. I was certain based on the documentation that
> device links would help, now I'm not so sure anymore.
>
> So what happens is that the DSA master attempts to unregister its net
> device on .shutdown, but DSA does not implement .shutdown, so it just
> sits there holding a reference (supposedly via dev_hold, but where from?=
!)
> to the master, which makes netdev_wait_allrefs to wait and wait.
>

Right, that was also my conclusion.

> I need more time for the denial phase to pass, and to understand what
> can actually be done. I will also be away from the keyboard for the next
> few days, so it might take a while. Your patches obviously offer a
> solution only for KSZ switches, we need something more general. If I
> understand your solution, it works not by virtue of there being any
> shutdown ordering guarantee at all, but simply due to the fact that
> DSA's .shutdown hook gets called eventually, and the reference to the
> master gets freed eventually, which unblocks the unregister_netdevice
> call from the master.

Well actually the SPI shutdown hook gets called which then calls ksz9477_s=
hutdown
(formerly ksz9477_reset_switch) which then shuts down the switch by
stopping the worker thread and tearing down the DSA tree (via dsa_tree_shu=
tdown()).

While it is right that the patch series only fixes the KSZ case for now, t=
he idea was that
other drivers could use a similar approach in by calling the new function =
dsa_tree_shutdown()
in their shutdown handler to make sure that all refs to the master device =
are released.


Regards,
Lino
