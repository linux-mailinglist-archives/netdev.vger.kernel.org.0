Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A5F2752B3
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgIWIAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:00:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10230 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWIAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:00:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N7iHu6078309
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 04:00:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=LyF0ZqyLyitaQh/xZwNVJuRpGtXyVwKtvIk5NG8XHpg=;
 b=ciMJ/PufEBa3gkZ5mzvt0As6eJRVfST7CoO8sqvAc5rNoxN2uMY7iJOGN2zB6a1GsXW+
 4ndIPN/ejpTo0PgW1yDKn7YgRBZ67nA6KrPEjZEojNf+2NfSNN6YeIPj5KpK/6wYI16i
 awJY8Y2Or94V9hOOWP3dGSa6dsORzS4VQ9zdiRxGjKccoA09wUt41jang356ouCrjC5u
 00qf3p5gSZOrdSNHLh4D0h8Nam4FgoCaQJMFbmD0rrQd4VDv7PHlthKQUGr4yiASdLUi
 GBAlpjllBonxiJkqOVXL7h21CKrbgWTPFTqYmPG21I8UOPUXkgSplf1OpzeJdqrsR6f+ uQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r27u0ds1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 04:00:36 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N7w1q5026240
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 08:00:35 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 33n9m959y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 08:00:35 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N80Y6m51511718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:00:34 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A06ACBE058;
        Wed, 23 Sep 2020 08:00:34 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C0A8BE051;
        Wed, 23 Sep 2020 08:00:32 +0000 (GMT)
Received: from [9.85.207.48] (unknown [9.85.207.48])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed, 23 Sep 2020 08:00:32 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <20200923045332.GA269687@us.ibm.com>
Date:   Wed, 23 Sep 2020 03:00:31 -0500
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, ljp@linux.ibm.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <066E780A-93EB-498E-A6EC-9DDDFF1B461A@linux.vnet.ibm.com>
References: <20200923045332.GA269687@us.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 22, 2020, at 11:53 PM, Sukadev Bhattiprolu =
<sukadev@linux.ibm.com> wrote:
>=20
>=20
> =46rom 547fa5627b63102f3ef80edffff3a032d62c88c5 Mon Sep 17 00:00:00 =
2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Thu, 10 Sep 2020 11:18:41 -0700
> Subject: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window
>=20
> Commit 5a18e1e0c193b introduced the 'failover_pending' state to track
> the "failover pending window" - where we wait for the partner to =
become
> ready (after a transport event) before actually attempting to =
failover.
> i.e window is between following two events:
>=20
>        a. we get a transport event due to a FAILOVER
>=20
>        b. later, we get CRQ_INITIALIZED indicating the partner is
>           ready  at which point we schedule a FAILOVER reset.
>=20
> and ->failover_pending is true during this window.
>=20
> If during this window, we attempt to open (or close) a device, we =
pretend
> that the operation succeded and let the FAILOVER reset path complete =
the
> operation.
>=20
> This is fine, except if the transport event ("a" above) occurs during =
the
> open and after open has already checked whether a failover is pending. =
If
> that happens, we fail the open, which can cause the boot scripts to =
leave
> the interface down requiring administrator to manually bring up the =
device.
>=20
> This fix "extends" the failover pending window till we are _actually_
> ready to perform the failover reset (i.e until after we get the RTNL
> lock). Since open() holds the RTNL lock, we can be sure that we either
> finish the open or if the open() fails due to the failover pending =
window,
> we can again pretend that open is done and let the failover complete =
it.
>=20
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
> drivers/net/ethernet/ibm/ibmvnic.c | 33 +++++++++++++++++++++++++-----
> 1 file changed, 28 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c =
b/drivers/net/ethernet/ibm/ibmvnic.c
> index 1b702a43a5d0..cf75a649ed8b 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1197,18 +1197,29 @@ static int ibmvnic_open(struct net_device =
*netdev)
> 	if (adapter->state !=3D VNIC_CLOSED) {
> 		rc =3D ibmvnic_login(netdev);
> 		if (rc)
> -			return rc;
> +			goto out;
>=20
> 		rc =3D init_resources(adapter);
> 		if (rc) {
> -			netdev_err(netdev, "failed to initialize =
resources\n");
> +			netdev_err(netdev,
> +				"failed to initialize resources, =
failover %d\n",
> +				adapter->failover_pending);

Would =E2=80=9C..., failover_pending=3D%d\n=E2=80=9D be more explicit =
than "failover %d=E2=80=9D?

> 			release_resources(adapter);
> -			return rc;
> +			goto out;
> 		}
> 	}
>=20
> 	rc =3D __ibmvnic_open(netdev);
>=20
> +out:
> +	/*
> +	 * If open fails due to a pending failover, set device state and
> +	 * return. Device operation will be handled by reset routine.
> +	 */
> +	if (rc && adapter->failover_pending) {
> +		adapter->state =3D VNIC_OPEN;
> +		rc =3D 0;
> +	}
> 	return rc;
> }
>=20
> @@ -1931,6 +1942,13 @@ static int do_reset(struct ibmvnic_adapter =
*adapter,
> 		   rwi->reset_reason);
>=20
> 	rtnl_lock();
> +	/*
> +	 * Now that we have the rtnl lock, clear any pending failover.
> +	 * This will ensure ibmvnic_open() has either completed or will
> +	 * block until failover is complete.
> +	 */
> +	if (rwi->reset_reason =3D=3D VNIC_RESET_FAILOVER)
> +		adapter->failover_pending =3D false;

The window extends till here.
And sometimes VNIC_RESET_FAILOVER case will call do_hard_reset
instead of do_reset, depending on adapter->force_reset_recovery is true =
or false.

>=20
> 	netif_carrier_off(netdev);
> 	adapter->reset_reason =3D rwi->reset_reason;
> @@ -2275,9 +2293,15 @@ static int ibmvnic_reset(struct ibmvnic_adapter =
*adapter,
> 	unsigned long flags;
> 	int ret;
>=20
> +	/*
> +	 * If failover is pending don't schedule any other reset.
> +	 * Instead let the failover complete. If there is already a
> +	 * a failover reset scheduled, we will detect and drop the
> +	 * duplicate reset when walking the ->rwi_list below.
> +	 */
> 	if (adapter->state =3D=3D VNIC_REMOVING ||
> 	    adapter->state =3D=3D VNIC_REMOVED ||
> -	    adapter->failover_pending) {
> +	    (adapter->failover_pending && reason !=3D =
VNIC_RESET_FAILOVER)) {

I don=E2=80=99t quite get =E2=80=9Creason !=3DVNIC_RESET_FAILOVER=E2=80=9D=
.
Isn=E2=80=99t failover_pending to describe VNIC_RESET_FAILOVER only?=20
Please list an example that failover_pending is true and reason is not =
VNIC_RESET_FAILOVER.

Lijun

> 		ret =3D EBUSY;
> 		netdev_dbg(netdev, "Adapter removing or pending =
failover, skipping reset\n");
> 		goto err;
> @@ -4653,7 +4677,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq =
*crq,
> 		case IBMVNIC_CRQ_INIT:
> 			dev_info(dev, "Partner initialized\n");
> 			adapter->from_passive_init =3D true;
> -			adapter->failover_pending =3D false;
> 			if (!completion_done(&adapter->init_done)) {
> 				complete(&adapter->init_done);
> 				adapter->init_done_rc =3D -EIO;
> --=20
> 2.26.2
>=20

