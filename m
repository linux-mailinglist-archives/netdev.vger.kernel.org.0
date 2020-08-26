Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453C62524F7
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHZBOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:14:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64102 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726593AbgHZBOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 21:14:39 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07Q11UV0128735;
        Tue, 25 Aug 2020 21:14:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=1fGRm0vddynnh19Keh/4dSR9SyJQ4VP5EgRJs9e4U2I=;
 b=mY7NySnB7xlcOh8MGAhoMKxl3zOwWP3unLRXhZdcoZjk8YWehuqJ4D86W206h9FFMHot
 nQGaPl82np1s9BPJQgNxnEmHkwjbEilIxtNkbLTCGVaWYn9lo5UkK37n0c/fHkV/bMcS
 piAFE3D6c6atL5TTzczzyWuAGz1exQM+myneXap0oKqsPn2EQwtk1uA5LxXYPZUo/fQr
 fjvVnx31/O1/Kv2c0Ys7NoM35xuIBoTVFyh5iHKKuPTvWsZ17U7Rp9moeyWGeII2F7X6
 LhGFValAjVPWWdKwIfYtlGbXYUA95SO+prBI6oGf0aoacU/q4SsHgaENHlu5Vf/Aq2kO PQ== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 335bthtrty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 21:14:30 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07Q1Cso3027618;
        Wed, 26 Aug 2020 01:14:29 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 332ujenv0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Aug 2020 01:14:29 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07Q1ETu652166954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 01:14:29 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F40AABE054;
        Wed, 26 Aug 2020 01:14:28 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48F40BE053;
        Wed, 26 Aug 2020 01:14:28 +0000 (GMT)
Received: from [9.85.168.187] (unknown [9.85.168.187])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed, 26 Aug 2020 01:14:28 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.14\))
Subject: Re: [PATCH net v3] ibmvnic fix NULL tx_pools and rx_tools issue at
 do_reset
From:   Mingming Cao <mmc@linux.vnet.ibm.com>
In-Reply-To: <20200825.173104.1541443546408114168.davem@davemloft.net>
Date:   Tue, 25 Aug 2020 18:14:25 -0700
Cc:     drt@linux.ibm.com, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B1BB4B7E-9B18-40E7-A051-BF8AEB84A500@linux.vnet.ibm.com>
References: <20200825172641.806912-1-drt@linux.ibm.com>
 <20200825.173104.1541443546408114168.davem@davemloft.net>
To:     David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.3445.104.14)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_10:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 25, 2020, at 5:31 PM, David Miller <davem@davemloft.net> wrote:
>=20
> From: Dany Madden <drt@linux.ibm.com>
> Date: Tue, 25 Aug 2020 13:26:41 -0400
>=20
>> From: Mingming Cao <mmc@linux.vnet.ibm.com>
>>=20
>> At the time of do_rest, ibmvnic tries to re-initalize the tx_pools
>> and rx_pools to avoid re-allocating the long term buffer. However
>> there is a window inside do_reset that the tx_pools and
>> rx_pools were freed before re-initialized making it possible to =
deference
>> null pointers.
>>=20
>> This patch fix this issue by always check the tx_pool
>> and rx_pool are not NULL after ibmvnic_login. If so, re-allocating
>> the pools. This will avoid getting into calling reset_tx/rx_pools =
with
>> NULL adapter tx_pools/rx_pools pointer. Also add null pointer check =
in
>> reset_tx_pools and reset_rx_pools to safe handle NULL pointer case.
>>=20
>> Signed-off-by: Mingming Cao <mmc@linux.vnet.ibm.com>
>> Signed-off-by: Dany Madden <drt@linux.ibm.com>
>=20
> Applied, but:
>=20
>> +	if (!adapter->rx_pool)
>> +		return -1;
>> +
>=20
> This driver has poor error code usage, it's a random mix of hypervisor
> error codes, normal error codes like -EINVAL, and internal error =
codes.
> Sometimes used all in the same function.
>=20

Agree need to improve. For this patch/fix,  -1 is  chosen to follow =
other part of the driver that check NULL pointer and return -1 . We =
should  go through all of -1 cases and replace with normal proper error =
code. That should be a seperate patch.=20

> For example:
>=20
> static int ibmvnic_send_crq(struct ibmvnic_adapter *adapter,
> 			    union ibmvnic_crq *crq)
> ...
> 	if (!adapter->crq.active &&
> 	    crq->generic.first !=3D IBMVNIC_CRQ_INIT_CMD) {
> 		dev_warn(dev, "Invalid request detected while CRQ is =
inactive, possible device state change during reset\n");
> 		return -EINVAL;
> 	}
> ...
> 	rc =3D plpar_hcall_norets(H_SEND_CRQ, ua,
> 				cpu_to_be64(u64_crq[0]),
> 				cpu_to_be64(u64_crq[1]));
>=20
> 	if (rc) {
> 		if (rc =3D=3D H_CLOSED) {
> ...
> 	return rc;
>=20
> So obviously this function returns a mix of negative erro codes
> and Hypervisor codes such as H_CLOSED.
>=20
> And stuff like:
>=20
> 	rc =3D __ibmvnic_open(netdev);
> 	if (rc)
> 		return IBMVNIC_OPEN_FAILED;

Agree.=20

Mingming=
