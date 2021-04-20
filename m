Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC023661B6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 23:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhDTVnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 17:43:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234169AbhDTVnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 17:43:21 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KLYIUk190410;
        Tue, 20 Apr 2021 17:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=zoeQ6vkUw400/4294RH+pt+SzJY+sKC0woi28HS+zsY=;
 b=XuNGN8gTfvauoLudl0JDCJzffdkChgPMpvEHdz7GQ6nzU9+ZTOgvmZ1v4wi0QqdFlKFd
 ARExKQ6gEu3UzULE3ih87NeDK08TG+XClFPyc2a0qvsHuxXOORVmiyOTQdhFUm1UxLmg
 p36Idjrgr5dKlQ8jpOYUG/3iN5CCYE2tuCCPfUMQETsB7RVq9AHRMnszWj5AkQMKodF/
 qnwqpRym1U4pAYb5sOMMx0vWOUFJF1QJjBXUjZYWpFvHsGOb8UJZRYHmuuf1D7Bv90z7
 gM1K9+DDjc2NngWZe694mxroEd1mi0XnZMeCOOIuviejp2u7FinrHK+EVjiEM4DsO8yn ww== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3824atv4qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 17:42:27 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13KLX1Cr002698;
        Tue, 20 Apr 2021 21:42:26 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 37yqa8wbe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 21:42:26 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13KLgPK719202520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 21:42:25 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC09E124058;
        Tue, 20 Apr 2021 21:42:25 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6205C124054;
        Tue, 20 Apr 2021 21:42:25 +0000 (GMT)
Received: from [9.80.196.76] (unknown [9.80.196.76])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Apr 2021 21:42:25 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down
 failed
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <20210420213517.24171-1-drt@linux.ibm.com>
Date:   Tue, 20 Apr 2021 16:42:24 -0500
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org,
        paulus@samba.org, Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <60C99F56-617D-455B-9ACF-8CE1EED64D92@linux.vnet.ibm.com>
References: <20210420213517.24171-1-drt@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qtBITTJRaRjxuCurwKIuGWi6KPggGyxn
X-Proofpoint-ORIG-GUID: qtBITTJRaRjxuCurwKIuGWi6KPggGyxn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_11:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 clxscore=1011 mlxlogscore=999 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200150
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 20, 2021, at 4:35 PM, Dany Madden <drt@linux.ibm.com> wrote:
>=20
> When ibmvnic gets a FATAL error message from the vnicserver, it marks
> the Command Respond Queue (CRQ) inactive and resets the adapter. If =
this
> FATAL reset fails and a transmission timeout reset follows, the CRQ is
> still inactive, ibmvnic's attempt to set link down will also fail. If
> ibmvnic abandons the reset because of this failed set link down and =
this
> is the last reset in the workqueue, then this adapter will be left in =
an
> inoperable state.
>=20
> Instead, make the driver ignore this link down failure and continue to
> free and re-register CRQ so that the adapter has an opportunity to
> recover.

This v2 does not adddress the concerns mentioned in v1.
And I think it is better to exit with error from do_reset, and schedule =
a thorough
do_hard_reset if the the adapter is already in unstable state.

>=20
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
> Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
> Changes in V2:
> - Update description to clarify background for the patch
> - Include Reviewed-by tags
> ---
> drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c =
b/drivers/net/ethernet/ibm/ibmvnic.c
> index ffb2a91750c7..4bd8c5d1a275 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1970,8 +1970,10 @@ static int do_reset(struct ibmvnic_adapter =
*adapter,
> 			rtnl_unlock();
> 			rc =3D set_link_state(adapter, =
IBMVNIC_LOGICAL_LNK_DN);
> 			rtnl_lock();
> -			if (rc)
> -				goto out;
> +			if (rc) {
> +				netdev_dbg(netdev,
> +					   "Setting link down failed =
rc=3D%d. Continue anyway\n", rc);
> +			}
>=20
> 			if (adapter->state =3D=3D VNIC_OPEN) {
> 				/* When we dropped rtnl, ibmvnic_open() =
got
> --=20
> 2.26.2
>=20

