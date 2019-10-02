Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEF2C482D
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 09:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfJBHQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 03:16:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfJBHQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 03:16:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x927EM3S130443;
        Wed, 2 Oct 2019 07:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=OZrFHrOUiGyrpMWS0F9eo4Dxsbk6eglEeDnTWqXsu7o=;
 b=sjntqAhvVxxP63qK3FKSjhPSAQZRG4I6+Nprc12nsS2wZfcDAdjQboqIg8WcvtCteBw7
 MqB1ji4u/ggZDxu0leBBdD7pyd540ydubPqI+wCLsxZGXLWRLqhSWlSQ9tBdLoFpxWJU
 BkVRZpr4grfYymO1KLpdDQ3ScpC646oL13Liz/h8R35f1h23xg+ci/AYXOCBElQ98F0q
 7S3dGyn/y6UL0IRJuxHICHj5oJifevQg0DWBVuPtOs/pIrlimNtZm9PuSnchDJzCaCkS
 3cB7jdwO2ZATE84s7ZlwMV74693N8HerRtf7HtIHdhI0Cc3Kwe2AgQ6Ve/6X3na3Xx1L Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05ru4ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 07:16:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x927DmZ7161624;
        Wed, 2 Oct 2019 07:16:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2vbsm3d0pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Oct 2019 07:16:38 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x927GcDM169015;
        Wed, 2 Oct 2019 07:16:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vbsm3d0p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 07:16:38 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x927Ganm028751;
        Wed, 2 Oct 2019 07:16:36 GMT
Received: from dhcp-10-172-157-155.no.oracle.com (/10.172.157.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Oct 2019 00:16:36 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net-next] net/rds: Use DMA memory pool allocation for
 rds_header
From:   =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
In-Reply-To: <7a388623-b2c5-2ade-69af-2e295784afca@oracle.com>
Date:   Wed, 2 Oct 2019 09:16:33 +0200
Cc:     netdev@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        rds-devel@oss.oracle.com,
        Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E5FBBC01-7395-4580-A504-E882E39EA1E6@oracle.com>
References: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
 <20191001.101615.1260420946739435364.davem@davemloft.net>
 <7a388623-b2c5-2ade-69af-2e295784afca@oracle.com>
To:     David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910020067
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 2 Oct 2019, at 07:20, Ka-Cheong Poon <ka-cheong.poon@oracle.com> =
wrote:
>=20
> On 10/2/19 1:16 AM, David Miller wrote:
>> From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
>> Date: Mon, 30 Sep 2019 02:08:00 -0700
>>> Currently, RDS calls ib_dma_alloc_coherent() to allocate a large =
piece
>>> of contiguous DMA coherent memory to store struct rds_header for
>>> sending/receiving packets.  The memory allocated is then partitioned
>>> into struct rds_header.  This is not necessary and can be costly at
>>> times when memory is fragmented.  Instead, RDS should use the DMA
>>> memory pool interface to handle this.
>>>=20
>>> Suggested-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>>> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
>> This is trading a one-time overhead for extra levels of dereferencing
>> on every single descriptor access in the fast paths.
>> I do not agree with this tradeoff, please implement this more
>> reasonably.
>=20
>=20
> The problem with the existing way of pre-allocation is
> that when there are a lot of RDS connections, the call to
> ib_dma_alloc_coherent() can fail because there are not
> enough contiguous memory pages available.  It is causing
> problems in production systems.
>=20
> And the i_{recv|send|_hdrs_dma array dereferencing is done
> at send/receive ring initialization and refill.  It is not
> done at every access of the header.

The commit removes costly order:4 allocations (with the default 1024 =
#entries in the recv work-queue). These allocations may need reclaims =
and/or compaction. At worst, they may fail.

Consider a switch failure, thousands of RDS IB connections, and their =
corresponding QPs, need to be resurrected. Each QP needs this order:4 =
allocation, and they are all created in close proximity in time, leading =
to an immense memory hog.


Thxs, H=C3=A5kon




> Thanks.
>=20
>=20
> --=20
> K. Poon
> ka-cheong.poon@oracle.com
>=20
>=20
>=20

