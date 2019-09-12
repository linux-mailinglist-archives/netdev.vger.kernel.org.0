Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F33B14E0
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 21:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfILTp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 15:45:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55838 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbfILTp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 15:45:59 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CJX5RL006352;
        Thu, 12 Sep 2019 12:45:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+wWN9t8LxNkRxGPFaCx1VNzg9MPHMmwK2Gce75bSU8A=;
 b=CR3MX9x5xeDthMksBZIfiKx1OUhXFdpPFgG8mM+a2RI8E7Kl7uSRplhbYLPh9SbFdFcD
 9WGMScvP+yn9qh01ouju0wtZ9AQFS8MAHdiYSE/Jpn43SoO/qlIVIKgWQ10DOYp0ZCXf
 po6pYp55T4B+6oszuVmxA7oW22X9fLUFlEs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uytcsrpa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Sep 2019 12:45:43 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Sep 2019 12:45:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 12 Sep 2019 12:45:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjPR0cI6smnZVGhApm+nPGkp7LQuxGBHcnlIwyeM34PtfTxZdL0q9tt4oC1p12N+fQFEhIyvchiYBkJBqNCib0iG9A3v1gY8EFTxyBwMy70qfxKdm1ucJnwmpj1t03/DwbewehI1i1BN8CIVTkGHCWNLIBagYnyp7xoM0XEsxy0bUb0RcZ6CZMyUpgQ21eKxsJ/fF5dcs3wVcTuVuFEXv328R8hmqfPjJPRJBiyKm5b7+G3t6fYklIHzhYfWeB1CqWny+KwfZnqklXg6OiJXd2OX71/7s4AfEJ2qQ0NWTMGFxws7XjEZQ8sR/32lBzrBeidefeKhtFjrIJHq9icLEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wWN9t8LxNkRxGPFaCx1VNzg9MPHMmwK2Gce75bSU8A=;
 b=hajF2Nwxmmk1lKc8cUbrEY7tu6bLKJX8prtULAp6exbhTabWEh8KrEcZsp2e3aLFTAYTbj1Z/sFizDtjfvxgr04xEj4D+7VIqfZnXtN9xg/RO1vbsiDw3SGQirPWlxY0jRtoU2sztdUMhbenFP00Ryb/knzEHcdtik9MyheQw5IsnLWlMHkHJ2XOTqBCGvdmB6O+cmdZw32yVwFiiLUvdUHECaZs7jOWitvcWd3DJV/ekt8QwOzCd0tU4jzIKsFTr/lRrf76kBM5F3SeTprjlDNgj6Y3IgCARajaG2OFX2BNk5bJoaLsDsuIKa9o/umpPBdFDOepwFu0LMS+VwiN8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wWN9t8LxNkRxGPFaCx1VNzg9MPHMmwK2Gce75bSU8A=;
 b=YXOIx2yH5eFqn/rg/uD6c3hQ1ozsMyrr0S0aAeoNg8AzqjTqTXc9or0OPPIcRq9Yi2BSob9uMsewfxALgDvl5nJVRgFqFuH9c2A7i710SNKt6OMCzIcbQfk0i5Q2gerTNNzegJPu1zWugSIUoDa5B3OMyo4V7eN90vG0H9j/GcY=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3541.namprd15.prod.outlook.com (10.255.156.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Thu, 12 Sep 2019 19:45:40 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::49a8:bb4e:fcce:aee7]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::49a8:bb4e:fcce:aee7%4]) with mapi id 15.20.2241.018; Thu, 12 Sep 2019
 19:45:40 +0000
From:   Ben Wei <benwei@fb.com>
To:     "Justin.Lee1@Dell.com" <Justin.Lee1@Dell.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Wei <benwei@fb.com>
Subject: RE: [PATCH net-next] net/ncsi: support unaligned payload size in
 NC-SI cmd handler
Thread-Topic: [PATCH net-next] net/ncsi: support unaligned payload size in
 NC-SI cmd handler
Thread-Index: AdVhOKsnD7LLLBrzTcm5Yllqe1NFWAAiF68AAAhz6HAAKnitgAHFTyYw
Date:   Thu, 12 Sep 2019 19:45:40 +0000
Message-ID: <CH2PR15MB36863AED8F20F62F029C0CFAA3B00@CH2PR15MB3686.namprd15.prod.outlook.com>
References: <CH2PR15MB368619179F403EAE47FD61F7A3BE0@CH2PR15MB3686.namprd15.prod.outlook.com>
 <20190902.120300.174900457187536042.davem@davemloft.net>
 <CH2PR15MB36869BE1AA44813CE293891BA3BE0@CH2PR15MB3686.namprd15.prod.outlook.com>
 <5d58b4eefc7c4d22b60dd1f6ef51093f@AUSX13MPS306.AMER.DELL.COM>
In-Reply-To: <5d58b4eefc7c4d22b60dd1f6ef51093f@AUSX13MPS306.AMER.DELL.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Justin_Lee1@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2019-09-03T19:21:05.2123280Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual;
 aiplabel=External Public
x-originating-ip: [2620:10d:c090:200::2:3f12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4b7712e-f557-42ec-43e9-08d737b9caf0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3541;
x-ms-traffictypediagnostic: CH2PR15MB3541:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR15MB3541FD9EE402DD4C55582097A3B00@CH2PR15MB3541.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(136003)(39860400002)(396003)(189003)(199004)(186003)(14454004)(110136005)(7736002)(305945005)(66946007)(316002)(64756008)(6246003)(66556008)(66476007)(486006)(66446008)(52536014)(54906003)(81166006)(81156014)(14444005)(74316002)(102836004)(76116006)(476003)(256004)(5660300002)(8936002)(11346002)(86362001)(446003)(229853002)(53936002)(71200400001)(71190400001)(2501003)(6506007)(6436002)(8676002)(7696005)(2906002)(46003)(33656002)(9686003)(478600001)(4326008)(76176011)(55016002)(25786009)(99286004)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3541;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Il5wHrkibb3XL7Lfnp3PHzV1IY2diHMGPT1hfuEh8laUQOkMpAhCgWebNHY4EpBAPCzDG5ymTVk1+TixZ+MNRfJ7POW3tEpUZ44Hi+dyHwkf/SBdbIAbirtmXR7RKVKIT/LN54uPwFqQ3Kd0PgFneL8sMXEo9qZCUCrRJwgcVn5obSWXydgKMR+1aJ4cT0vMJpRN3efdaqKn5bOWFaoR+TXOit+1hqaouxSD2xACT1LvOU5Jgs0A8bahBA+Zvj7hH92muZnfs9+B4oTY6FRyadqDei9OUumEC3F4mhITMo3H0HlYx3goBp4e4Y/2Sj1cI+6pqgDUl2UzhOHAGLgQj95weDVoVQpBhbUS0+L4dJ2pCkDwn+8UD3N2NFBi2VgyroYQaigGUMObkj42r0cK2tf/fHX9Y1F6FMEdCMITyGk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c4b7712e-f557-42ec-43e9-08d737b9caf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 19:45:40.8246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: luu4yKKf+DR7G4Q0ZZwAKQHMbL0KAxXaoaDy8cOzWVao1hv2nrI8h9ylsuTDf5OW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3541
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_10:2019-09-11,2019-09-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909120203
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> That is right. It is necessary to adjust the len for padding on both plac=
es.
>
> Thanks,
> Justin
>
>
> > > > Update NC-SI command handler (both standard and OEM) to take into=20
> > > > account of payload paddings in allocating skb (in case of payload=20
> > > > size is not 32-bit aligned).
> > > >=20
> > > > The checksum field follows payload field, without taking payload=20
> > > > padding into account can cause checksum being truncated, leading to=
=20
> > > > dropped packets.
> > > >=20
> > > > Signed-off-by: Ben Wei <benwei@fb.com>
> > >
> > > If you have to align and add padding, I do not see where you are=20
> > > clearing out that padding memory to make sure it is initialized.
> > >
> > > You do comparisons with 'payload' but make adjustments to 'len'.
> > >
> > > The logic is very confusing.
> >=20
> > Yes let me clarify a bit.=20
> >=20
> > In the code 'payload' is the exact NC-SI payload length, which goes int=
o NC-SI packet header and needs to be actual unpadded payload length.
> >=20
> > 'len' is used to allocate total NC-SI packet buffer (include padding).=
=20
> >=20
> > The original calculation of 'len' was done by summing up NCSI header + =
payload + checksum, without taking into account of possible padding, e.g.
> >=20
> >         len +=3D sizeof(struct ncsi_cmd_pkt_hdr) + 4;  /* 4 is the chec=
ksum size */
> >        if (nca->payload < 26)
> >                 len +=3D 26;
> >         else
> >                len +=3D nca->payload;
> >         /* Allocate skb */
> >         skb =3D alloc_skb(len, GFP_ATOMIC);
> >=20
> > This works today for all standard NC-SI commands (in spec v1.1) because=
 all standard commands have payload size < 26, and packet size is then set =
to minimum of 46 (16 hdr + 26 payload + 4 cksum) bytes.
> >=20
> > And mem clearing is done in each of the standard cmd handlers, e.g.=20
> > ncsi_cmd_handler_sp, ncsi_cmd_handler_ae.
> >=20
> >=20
> >=20
> > The problem occurs if payload >=3D 26 and is unaligned.  This could hap=
pen on some OEM commands, and I see this happening when we carry PLDM traff=
ic over NC-SI packet.=20
> > (PLDM header being 3 bytes and payload size can be large)=20
> >=20
> > The skb allocated would be too small, and later when checksum is calcul=
ated and written:
> >=20
> > 	pchecksum =3D (__be32 *)((void *)h + sizeof(struct ncsi_pkt_hdr) +
> > 		    ALIGN(nca->payload, 4));
> > 	*pchecksum =3D htonl(checksum);
> >=20
> > Part of the checksum would fall outside of our allocated buffer.
> >=20
> > PLDM over NC-SI and OEM NC-SI commands are currently handled in
> >=20
> > @@ -213,17 +213,22 @@ static int ncsi_cmd_handler_oem(struct sk_buff *s=
kb,
> >=20
> > So here I ensure the skb allocation takes padding into account, and do =
the initial mem clearing to set the padding bytes
> >=20
> > +       unsigned short payload =3D ALIGN(nca->payload, 4);
> >=20
> >         len =3D sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> > -       if (nca->payload < 26)
> > +       if (payload < 26)
> >                 len +=3D 26;
> >         else
> > -               len +=3D nca->payload;
> > +               len +=3D payload;
> >=20
> >         cmd =3D skb_put_zero(skb, len);
> >         memcpy(&cmd->mfr_id, nca->data, nca->payload);
> >=20
> > So in this patch I updated both standard command handler (in case futur=
e spec updates adds commands with payload >=3D 26) and OEM/generic command =
handler to support unaligned payload size. =20
> >=20


Is this notes sufficient or should I add more comments to the patch?
Basically the issue you raised ('len' vs 'payload') is due to 'len' being u=
sed for buffer allocation, which needs padding based on 'payload' (which is=
 exact payload length).

Thanks
-Ben

