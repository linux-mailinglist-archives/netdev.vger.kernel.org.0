Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA65B2944ED
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410355AbgJTWHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:07:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7752 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393428AbgJTWHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 18:07:44 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09KLXWBQ190388;
        Tue, 20 Oct 2020 18:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=XfW1tn+u/qEjbp5MUESQSydzzcXgxN5CVPqt689qW9s=;
 b=HbJK+3IKb7kAd89QzVCT+BItPu7sIXc/ctHa/OvjVnjiNSaNwrp/KiTDUA0U1lobB6aT
 +ITGG5GAnsRiCwt58uu/cRv/bJIJDoPKgN86X6bIIFAjScPWELEiQ8Mq211G+Olx+Rld
 mNv0cW+U9Z/gG3F3wn83qGRCcVh5RG/3wkT1IoKxQoxvqf7Q/K5Ch6ZPLceORKn1Rl4x
 XwOQQytJsFqlbH986E+0CRfawsPUYFqDKzEoC35AbzlcJNq4xdefS/ngF8P7v7s8mGDa
 I460ltLnXm0esmiJf/5nz+Bb64ltIP+af6uKl5CsVjo3XaPAfqqhR7nKjyA98Srxd25/ Wg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34a3wwfngt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 18:07:41 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09KM23vt018368;
        Tue, 20 Oct 2020 22:07:40 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 347r89a37s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 22:07:40 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09KM7dVO40042840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 22:07:39 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C46DE112064;
        Tue, 20 Oct 2020 22:07:39 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 855D0112063;
        Tue, 20 Oct 2020 22:07:39 +0000 (GMT)
Received: from [9.85.179.149] (unknown [9.85.179.149])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Oct 2020 22:07:39 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH net] ibmvnic: save changed mac address to
 adapter->mac_addr
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <20201020143352.04cee401@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 20 Oct 2020 17:07:38 -0500
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8AEE4003-FA15-4D69-9355-F15E1B737C0F@linux.vnet.ibm.com>
References: <20201016045715.26768-1-ljp@linux.ibm.com>
 <20201019171152.6592e0c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <456A40F4-7C46-4147-A22E-8B09209FD13A@linux.vnet.ibm.com>
 <20201020143352.04cee401@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-20_12:2020-10-20,2020-10-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=714 malwarescore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 20, 2020, at 4:33 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Tue, 20 Oct 2020 16:18:04 -0500 Lijun Pan wrote:
>>> On Oct 19, 2020, at 7:11 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>>>=20
>>> On Thu, 15 Oct 2020 23:57:15 -0500 Lijun Pan wrote: =20
>>>> After mac address change request completes successfully, the new =
mac
>>>> address need to be saved to adapter->mac_addr as well as
>>>> netdev->dev_addr. Otherwise, adapter->mac_addr still holds old
>>>> data. =20
>>>=20
>>> Do you observe this in practice? Can you show us which path in
>>> particular you see this happen on?
>>>=20
>>> AFAICS ibmvnic_set_mac() copies the new MAC addr into =
adapter->mac_addr
>>> before making a request.
>>>=20
>>> If anything is wrong here is that it does so regardless if MAC addr=20=

>>> is valid.
>>=20
>> Yes, I ran some internal test to check the mac address in =
adapter->mac_addr, and
>> it is the old data. If you run ifconfig command to change mac addr, =
the netdev->dev_addr
>> is changed afterwards, and if you run ifocnfig again, it will show =
the new mac addr. However,
>> since we did not check adapter->mac_addr in this use case, this bug =
was not exposed.
>>=20
>> This vnic driver is little bit different than other physical NIC =
driver. All the control paths
>> are negotaited with VIOS server, and data paths are through DMA =
mapping.
>>=20
>> __ibmvnic_set_mac copies the new mac addr to crq by
>> 	ether_addr_copy(&crq.change_mac_addr.mac_addr[0], dev_addr);
>> and then send the change request by
>> 	rc =3D ibmvnic_send_crq(adapter, &crq);
>> Now adapter->mac_addr still has the old data.
>>=20
>> When the request is handled by VIOS server, an interrupt is =
triggered, and=20
>> handle_change_mac_rsp is called.=20
>> Now it is time to copy the new mac to netdev->dev_addr, and =
adatper->mac_addr.
>> 	ether_addr_copy(netdev->dev_addr,
>> 			&crq->change_mac_addr_rsp.mac_addr[0]);
>> It missed the copy for adapter->mac_addr, which is what I add in this =
patch.
>> +	ether_addr_copy(adapter->mac_addr,
>> +			&crq->change_mac_addr_rsp.mac_addr[0]);
>=20
> Please read my reply carefully.
>=20
> What's the call path that leads to the address being wrong? If you set
> the address via ifconfig it will call ibmvnic_set_mac() of the driver.
> ibmvnic_set_mac() does the copy.
>=20
> But it doesn't validate the address, which it should.

Sorry about that. The mac addr validation is performed on vios side when =
it receives the
change request. That=E2=80=99s why there is no mac validation code in =
vnic driver.=20
In handle_change_mac_rsp(), &crq->change_mac_addr_rsp.mac_addr[0]
contains the current valid mac address, which may be different than the =
requested one,=20
that is &crq->change_mac_addr.mac_addr[0].
crq->change_mac_addr.mac_addr is the requested one.
crq->change_mac_addr_rsp.mac_addr is the returned valid one.

Hope the above answers your doubt.

