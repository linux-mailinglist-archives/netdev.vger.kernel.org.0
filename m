Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C062130707
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 11:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgAEKWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 05:22:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42084 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgAEKWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 05:22:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 005AJkeo071450;
        Sun, 5 Jan 2020 10:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=boqeggnN34NzY+TDSFYsAAYk1fgBAug0s9rLEITDC0E=;
 b=caUSsLiQ4GoxwVjhpLbRlgIjMqPlb5WqmhVdy2yWRlc8llTW/M7KB51rlku/q9GCD2P5
 HWEvkfpw8KP7BCTwqrRPmJp7mI2uF1jvLoErKnx3pITBYa0Hrws9ezBE49MtSk56hDjd
 wSXKn0vyn7iiE5fklGOeaSUdl3e7qxLWqPmDDXQN2eIzST3rZr169MRy/X4w62G/x1NF
 9Z3k1ciqh5phMIKA5jp/AXWArruXA+A0gJ1deHciNBf2qe79RWIv3qvbSkywxPT0z+Qu
 osYpiUJ5IvPrus90HpMp7or07APgN2Oo6BtXz+evqWLF8JO/dSV5cN9KHhunFiaAKosu cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xakbqarag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jan 2020 10:22:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 005AI6Qg086661;
        Sun, 5 Jan 2020 10:22:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xb475nsw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jan 2020 10:22:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 005AMZc0031464;
        Sun, 5 Jan 2020 10:22:35 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jan 2020 02:22:34 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new SQ tail
 to doorbell
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1578218014463.62861@amazon.com>
Date:   Sun, 5 Jan 2020 12:22:29 +0200
Cc:     "Machulsky, Zorik" <zorik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Chauskin, Igor" <igorch@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Schmeilin, Evgeny" <evgenys@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Pressman, Gal" <galpress@amazon.com>,
        =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2CB0420-79C8-4282-AE14-F575407B7C22@oracle.com>
References: <20200102180830.66676-1-liran.alon@oracle.com>
 <20200102180830.66676-3-liran.alon@oracle.com>
 <37DACE68-F4B4-4297-9FE0-F12461D1FDC6@oracle.com>
 <2BB3E76D-CAF7-4539-A8E3-540CDB253742@amazon.com>
 <1578218014463.62861@amazon.com>
To:     "Bshara, Saeed" <saeedb@amazon.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9490 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001050098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9490 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001050098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

If I understand correctly, the device is only aware of new descriptors =
once the tail is updated by ena_com_write_sq_doorbell() using writel().
If that=E2=80=99s the case, then writel() guarantees all previous writes =
to WB/UC memory is visible to device before the write done by writel().

If device is allowed to fetch packet payload at the moment the transmit =
descriptor is written into device-memory using LLQ,
then ena_com_write_bounce_buffer_to_dev() should dma_wmb() before =
__iowrite64_copy(). Instead of wmb(). And comment
is wrong and should be updated accordingly.
For example, this will optimise x86 to only have a compiler-barrier =
instead of executing a SFENCE.

Can you clarify what is device behaviour on when it is allowed to read =
the packet payload?
i.e. Is it only after writing to doorbell or is it from the moment the =
transmit descriptor is written to LLQ?

-Liran

> On 5 Jan 2020, at 11:53, Bshara, Saeed <saeedb@amazon.com> wrote:
>=20
>=20
> Thanks Liran,
>=20
> I think we missed the payload visibility; The LLQ descriptor contains =
the header part of the packet, in theory we will need also to make sure =
that all cpu writes to the packet payload are visible to the device, I =
bet that in practice those stores will be visible without explicit =
barrier, but we better stick to the rules.
> so we still need dma_wmb(), also, that means the first patch can't =
simply remove the wmb() as it actually may be taking care for the =
payload visibility.
>=20
> saeed
>=20
> From: Machulsky, Zorik
> Sent: Saturday, January 4, 2020 6:55 AM
> To: Liran Alon
> Cc: Belgazal, Netanel; davem@davemloft.net; netdev@vger.kernel.org; =
Bshara, Saeed; Jubran, Samih; Chauskin, Igor; Kiyanovski, Arthur; =
Schmeilin, Evgeny; Tzalik, Guy; Dagan, Noam; Matushevsky, Alexander; =
Pressman, Gal; H=C3=A5kon Bugge
> Subject: Re: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new =
SQ tail to doorbell
>    =20
>=20
>=20
> =EF=BB=BFOn 1/3/20, 1:47 PM, "Liran Alon" <liran.alon@oracle.com> =
wrote:
>=20
>    =20
>    =20
>     > On 2 Jan 2020, at 20:08, Liran Alon <liran.alon@oracle.com> =
wrote:
>     >=20
>     > AWS ENA NIC supports Tx SQ in Low Latency Queue (LLQ) mode (Also
>     > referred to as "push-mode"). In this mode, the driver pushes the
>     > transmit descriptors and the first 128 bytes of the packet =
directly
>     > to the ENA device memory space, while the rest of the packet =
payload
>     > is fetched by the device from host memory. For this operation =
mode,
>     > the driver uses a dedicated PCI BAR which is mapped as WC =
memory.
>     >=20
>     > The function ena_com_write_bounce_buffer_to_dev() is responsible
>     > to write to the above mentioned PCI BAR.
>     >=20
>     > When the write of new SQ tail to doorbell is visible to device, =
device
>     > expects to be able to read relevant transmit descriptors and =
packets
>     > headers from device memory. Therefore, driver should ensure
>     > write-combined buffers (WCBs) are flushed before the write to =
doorbell
>     > is visible to the device.
>     >=20
>     > For some CPUs, this will be taken care of by writel(). For =
example,
>     > x86 Intel CPUs flushes write-combined buffers when a read or =
write
>     > is done to UC memory (In our case, the doorbell). See Intel SDM =
section
>     > 11.3 METHODS OF CACHING AVAILABLE:
>     > "If the WC buffer is partially filled, the writes may be delayed =
until
>     > the next occurrence of a serializing event; such as, an SFENCE =
or MFENCE
>     > instruction, CPUID execution, a read or write to uncached =
memory, an
>     > interrupt occurrence, or a LOCK instruction execution.=E2=80=9D
>     >=20
>     > However, other CPUs do not provide this guarantee. For example, =
x86
>     > AMD CPUs flush write-combined buffers only on a read from UC =
memory.
>     > Not a write to UC memory. See AMD Software Optimisation Guide =
for AMD
>     > Family 17h Processors section 2.13.3 Write-Combining Operations.
>    =20
>     Actually... After re-reading AMD Optimization Guide SDM, I see it =
is guaranteed that:
>     =E2=80=9CWrite-combining is closed if all 64 bytes of the write =
buffer are valid=E2=80=9D.
>     And this is indeed always the case for AWS ENA LLQ. Because as can =
be seen at
>     ena_com_config_llq_info(), desc_list_entry_size is either 128, 192 =
or 256. i.e. Always
>     a multiple of 64 bytes.
>    =20
>     So this patch in theory could maybe be dropped as for x86 Intel & =
AMD and ARM64 with
>     current desc_list_entry_size, it isn=E2=80=99t strictly necessary =
to guarantee that WC buffers are flushed.
>    =20
>     I will let AWS folks to decide if they prefer to apply this patch =
anyway to make WC flush explicit
>     and to avoid hard-to-debug issues in case of new non-64-multiply =
size appear in the future. Or
>     to drop this patch and instead add a WARN_ON() to =
ena_com_config_llq_info() in case desc_list_entry_size
>     is not a multiple of 64 bytes. To avoid taking perf hit for no =
real value.
>  =20
> Liran, thanks for this important info. If this is the case, I believe =
we should drop this patch as it introduces unnecessary branch
> in data path. Agree with your WARN_ON() suggestion.=20
>  =20
>     -Liran
>    =20
>    =20
>=20

