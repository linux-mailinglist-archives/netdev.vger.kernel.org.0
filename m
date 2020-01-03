Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC6512FCB8
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 19:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgACSq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 13:46:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbgACSq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 13:46:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003IiKlm188014;
        Fri, 3 Jan 2020 18:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=+p6GASsLtvgDJNtw2FCnQRt9Gfu6PIz2T5JlZEwkuic=;
 b=bv992UtYqW7LHhjdywl/743RmDRktFPiqULpMBbRd8rTIiWvsdEvms4SMiB4C6/gRrk3
 eJLQ8LTaF2CB7tWYz8mqLQjaBU8vGajgbr1bpyzVn99lxdxV+QJg98ZYALXafn+3/AL4
 T48tRDte1TnFMh9pWrnUDG0OE8Li6LuQ0ezi9IB2uTx6qrPrkvib3+uhCYA9A98acUnZ
 hGg5bXFvu86pxUUqULx0auLrAjoViQnYqhhjnVfXC8y6a41cZHi23BIOp2jTeS3IRl27
 jYSl6p7Q7k6BDtig6FtC4VsVmJ9X5cCpoHX+WbPIcpv8H7aZ1aqrrlgt6Vwy0iCrgBSj Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqwqnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 18:46:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003Id6fv146127;
        Fri, 3 Jan 2020 18:46:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xa7tytrca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 18:46:46 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 003IkiVF020689;
        Fri, 3 Jan 2020 18:46:44 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 10:46:43 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new SQ tail
 to doorbell
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200102180830.66676-3-liran.alon@oracle.com>
Date:   Fri, 3 Jan 2020 20:46:38 +0200
Cc:     "Belgazal, Netanel" <netanel@amazon.com>, davem@davemloft.net,
        netdev@vger.kernel.org, saeedb@amazon.com, zorik@amazon.com,
        sameehj@amazon.com, igorch@amazon.com, akiyano@amazon.com,
        evgenys@amazon.com, gtzalik@amazon.com, ndagan@amazon.com,
        matua@amazon.com, galpress@amazon.com,
        =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <37DACE68-F4B4-4297-9FE0-F12461D1FDC6@oracle.com>
References: <20200102180830.66676-1-liran.alon@oracle.com>
 <20200102180830.66676-3-liran.alon@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=934
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=996 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030170
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 2 Jan 2020, at 20:08, Liran Alon <liran.alon@oracle.com> wrote:
>=20
> AWS ENA NIC supports Tx SQ in Low Latency Queue (LLQ) mode (Also
> referred to as "push-mode"). In this mode, the driver pushes the
> transmit descriptors and the first 128 bytes of the packet directly
> to the ENA device memory space, while the rest of the packet payload
> is fetched by the device from host memory. For this operation mode,
> the driver uses a dedicated PCI BAR which is mapped as WC memory.
>=20
> The function ena_com_write_bounce_buffer_to_dev() is responsible
> to write to the above mentioned PCI BAR.
>=20
> When the write of new SQ tail to doorbell is visible to device, device
> expects to be able to read relevant transmit descriptors and packets
> headers from device memory. Therefore, driver should ensure
> write-combined buffers (WCBs) are flushed before the write to doorbell
> is visible to the device.
>=20
> For some CPUs, this will be taken care of by writel(). For example,
> x86 Intel CPUs flushes write-combined buffers when a read or write
> is done to UC memory (In our case, the doorbell). See Intel SDM =
section
> 11.3 METHODS OF CACHING AVAILABLE:
> "If the WC buffer is partially filled, the writes may be delayed until
> the next occurrence of a serializing event; such as, an SFENCE or =
MFENCE
> instruction, CPUID execution, a read or write to uncached memory, an
> interrupt occurrence, or a LOCK instruction execution.=E2=80=9D
>=20
> However, other CPUs do not provide this guarantee. For example, x86
> AMD CPUs flush write-combined buffers only on a read from UC memory.
> Not a write to UC memory. See AMD Software Optimisation Guide for AMD
> Family 17h Processors section 2.13.3 Write-Combining Operations.

Actually... After re-reading AMD Optimization Guide SDM, I see it is =
guaranteed that:
=E2=80=9CWrite-combining is closed if all 64 bytes of the write buffer =
are valid=E2=80=9D.
And this is indeed always the case for AWS ENA LLQ. Because as can be =
seen at
ena_com_config_llq_info(), desc_list_entry_size is either 128, 192 or =
256. i.e. Always
a multiple of 64 bytes.

So this patch in theory could maybe be dropped as for x86 Intel & AMD =
and ARM64 with
current desc_list_entry_size, it isn=E2=80=99t strictly necessary to =
guarantee that WC buffers are flushed.

I will let AWS folks to decide if they prefer to apply this patch anyway =
to make WC flush explicit
and to avoid hard-to-debug issues in case of new non-64-multiply size =
appear in the future. Or
to drop this patch and instead add a WARN_ON() to =
ena_com_config_llq_info() in case desc_list_entry_size
is not a multiple of 64 bytes. To avoid taking perf hit for no real =
value.

-Liran

