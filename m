Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB40140E6B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 16:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgAQP5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 10:57:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgAQP5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 10:57:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HFnvar061118;
        Fri, 17 Jan 2020 15:56:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=iqvs+sVVKZaa4/znTtL9zy7qo15cyPsjoI0/bG8wINw=;
 b=j7ttOzKCuWAL5yM25G++3DsVbi2/WPCdYxqBdWk7iSuN6SUn5fKlvvx2FbmEBBPZ9cpP
 zeDeQTCal6+IONS3XO/mUR5txmB2Q1jqJe4fmw35jtii8cAcMjniD5ghZAjJTf5vXvGx
 z9nh5CLLiX1HtvDGtIXTn/j5O+B/i7Tw+UT9BaQFECaZHch6A2o75EqZ4kz07VHd7OeP
 fABkSLGhN7Zuyp3L7YglV7hwdpkHlGtTwV6I1SczvGUEdNQpRWZbnRp4TzSqO4Ik0zw6
 ywTbutWQvKYp9ELrPHhj5jS9jFSN7K9TS5jgVlH/geDM81fJ3cP5HAb0Gho2O9YpVxpg pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xf74ssfg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 15:56:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HFnkGq032161;
        Fri, 17 Jan 2020 15:54:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xjxm94p6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 15:54:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00HFspCj012640;
        Fri, 17 Jan 2020 15:54:51 GMT
Received: from [192.168.14.112] (/109.66.225.253)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jan 2020 07:54:50 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] net: AWS ENA: Remove unncessary wmb() to flush bounce
 buffer
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200102180830.66676-2-liran.alon@oracle.com>
Date:   Fri, 17 Jan 2020 17:54:41 +0200
Cc:     "Belgazal, Netanel" <netanel@amazon.com>, davem@davemloft.net,
        netdev@vger.kernel.org, saeedb@amazon.com, zorik@amazon.com,
        sameehj@amazon.com, igorch@amazon.com, akiyano@amazon.com,
        evgenys@amazon.com, gtzalik@amazon.com, ndagan@amazon.com,
        matua@amazon.com, galpress@amazon.com,
        =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9D62CAC6-7AB5-4D98-A39D-1FE87A2EE1F7@oracle.com>
References: <20200102180830.66676-1-liran.alon@oracle.com>
 <20200102180830.66676-2-liran.alon@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping on merging this patch (Patch 2/2 of series should be dropped).

-Liran

> On 2 Jan 2020, at 20:08, Liran Alon <liran.alon@oracle.com> wrote:
>=20
> Current code executes wmb() in order to flush writes to bounce buffer
> before copying it to device-memory (PCI BAR mapped as WC) to ensure
> consistent data is written to device-memory.
>=20
> However, this wmb() is unnecessary. This is because all reads from the
> buffer are guaranteed to be consistent with previous writes to the =
buffer
> done from the same task (Which is the only one that writes to the =
buffer).
>=20
> i.e. If a single CPU runs both the writes to the buffer and the reads
> from the buffer, the reads are guaranteed to read most up-to-date data
> in program order (E.g. Due to store-to-load-forwarding mechanism).
> Otherwise, there is a context-switch, and that should make writes =
before
> context-switch globally visible as-well.
>=20
> Reviewed-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
> drivers/net/ethernet/amazon/ena/ena_eth_com.c | 5 -----
> 1 file changed, 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c =
b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> index 2845ac277724..742578ac1240 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> @@ -93,11 +93,6 @@ static int =
ena_com_write_bounce_buffer_to_dev(struct ena_com_io_sq *io_sq,
> 			 io_sq->qid, io_sq->entries_in_tx_burst_left);
> 	}
>=20
> -	/* Make sure everything was written into the bounce buffer =
before
> -	 * writing the bounce buffer to the device
> -	 */
> -	wmb();
> -
> 	/* The line is completed. Copy it to dev */
> 	__iowrite64_copy(io_sq->desc_addr.pbuf_dev_addr + dst_offset,
> 			 bounce_buffer, (llq_info->desc_list_entry_size) =
/ 8);
> --=20
> 2.20.1
>=20

