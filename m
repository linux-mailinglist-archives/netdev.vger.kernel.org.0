Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E00794F63
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfHSU4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:56:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727769AbfHSU4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:56:54 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7JKsfVA030575;
        Mon, 19 Aug 2019 13:56:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=F8PIRJ1Ja1IkIjpngjDG+i01ObQF419fiC/ypd+VnlI=;
 b=cvCO8hYoEkYlIkl89Ojzk4j2sqrFz8O4I89hp3MeONq0N1b3X2QOz+2R6AaQhgL//G22
 gN3bGODyLZGXiNsCbRTVjQVN84VtgknsnaRge8ylkZTp0byGUwWOKO5b3gQ+sCY8XkOx
 4gpjUz8OItfxtfnqJfrQ9EJAjSZKm3hvC5g= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ug1358n6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Aug 2019 13:56:41 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 19 Aug 2019 13:56:40 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 19 Aug 2019 13:56:40 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 19 Aug 2019 13:56:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEkv8/6Ad0ZMqbuUbTHLYeXXVFlAh0afzp2qxTahzLJjj6i9lrgXZwRljtsNPso+DyABk+eZCYs0nS9LLARopZKt7ixuBVPPmVy371+AqyhcsYZ5CPVCZnZ1abX7hDmA2A0vKAoY8ZdhVrhjlk1QWWjGHv92lA5AEZTsgEsUTJCsHfqGfrOjCFgwdZ/hb1CRjjHIFXDn4wjDdn0tE+tB3ORehas9J4NQ9OBln3rI0mInlrWdvwCgVLwRqKeeMu0traY/2EiJacZWZ1efscr0OzxGaCH0aDkgiDhBpFkqIbT91KEQK9rMThtAWe+JMeTgX+3LTIf73DQ+1E2ESVkb9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8PIRJ1Ja1IkIjpngjDG+i01ObQF419fiC/ypd+VnlI=;
 b=Qo4sCvLRn5aYR56tU5ucSkFthdpf+r4tWwAJuBm1Oeu83snnwCMoKT62L5F07Q9GnKxjuxyYzR/oS5SEpzeTty6kltbKnuTuEM2gw71uKwCQSWfLgC22+/Ccr60iV1g3s0LAKv1rz4bHfqveZZJ/zQ1xxTAIvndfCqo+EcvRNy8AVoRGJCGLajx7ejt4evfdEwbKHzVTjls5FkZV6f9gkm437Z31KjWn1rMFFlFdSIQC8TwcFaFSkKtC6rcv7z1fUpvdDuQYxtstlk1rX7GCgotvzZVzmGqIKLBSEGelc7JLvQGfD1v4qrtj+ePhRviFjD7NGI0UTOAifmyHjOjevw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8PIRJ1Ja1IkIjpngjDG+i01ObQF419fiC/ypd+VnlI=;
 b=Cd2yONY6n5i2KOv5e3rN817GGPn1t+2916I0uq8DnSESdrymZEdDkKzB//+fCbnoUYLBp0N8U3NAU12n7IYwswtFZuPjLpE3gbsMTcP00fqFRepZpdxDHlgp+l8yeb/JajdzYDmP5AaMjE3OMzltZZZAwhBLf2T9nAXuFNH6XrI=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 BYASPR01MB0058.namprd15.prod.outlook.com (20.179.90.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 20:56:39 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c%5]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 20:56:39 +0000
From:   Ben Wei <benwei@fb.com>
To:     "Justin.Lee1@Dell.com" <Justin.Lee1@Dell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Deepak Kodihalli <dkodihal@linux.vnet.ibm.com>
Subject: RE: [PATCH] net/ncsi: add control packet payload to NC-SI commands
 from netlink
Thread-Topic: [PATCH] net/ncsi: add control packet payload to NC-SI commands
 from netlink
Thread-Index: AdVWRzWK9Wcjcdd/SW6uTu9wV1cgUQAe69YgAALeARA=
Date:   Mon, 19 Aug 2019 20:56:38 +0000
Message-ID: <CH2PR15MB3686A4CEF8FA3B567078B4A1A3A80@CH2PR15MB3686.namprd15.prod.outlook.com>
References: <CH2PR15MB368691D280F882864A6D356DA3A80@CH2PR15MB3686.namprd15.prod.outlook.com>
 <ec5842fff4de45069a51618eb72df164@AUSX13MPS302.AMER.DELL.COM>
In-Reply-To: <ec5842fff4de45069a51618eb72df164@AUSX13MPS302.AMER.DELL.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Justin_Lee1@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2019-08-19T20:17:25.5740389Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual;
 aiplabel=External Public
x-originating-ip: [2620:10d:c090:200::3:2581]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02b484cb-c7b2-4123-c83b-08d724e7bb17
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYASPR01MB0058;
x-ms-traffictypediagnostic: BYASPR01MB0058:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYASPR01MB005820B3D84CA103914AFF2BA3A80@BYASPR01MB0058.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(136003)(396003)(39860400002)(199004)(189003)(478600001)(305945005)(66556008)(46003)(66446008)(7736002)(486006)(446003)(476003)(74316002)(6116002)(14454004)(71200400001)(71190400001)(11346002)(256004)(54906003)(14444005)(2351001)(316002)(2906002)(86362001)(99286004)(33656002)(561944003)(52536014)(2501003)(9686003)(6306002)(55016002)(5640700003)(76176011)(7696005)(8936002)(186003)(102836004)(8676002)(6916009)(81166006)(6506007)(81156014)(6246003)(5660300002)(53936002)(66476007)(64756008)(25786009)(4326008)(66946007)(229853002)(76116006)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYASPR01MB0058;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XnpLHJA/MEJZzizIwdDQOd3sCb4CZams9qjbl9+/BtaclYd4YyQmm39S1rS/UjNX1ZYM4p16FMKXBmLF/WK0RjY+Lf1D5HS8a89B6ztafyqpRU/c3pQFo0dT7PDWyF4cf0m05aNdhAoSyaR93HipOsNSxQEHsuqwsPZf/lJxG9N+vuMNHd/jE637No8ObYqFxjkEL7NlgudPXPI1IyQh3vE/Il/HWXqMQhBWBY0tDnOGz0HQxctacnqPWHQsFddMV8gKQNktIgJKzjW2PrefF+il8Qzsn0vv5I2PJsvqggMsIhYD42TPco5URT3XwaSKMBVXuHPhEtE1wC2Ox8rhLA8Q+TwRIi/Ussx6TYhoEAn8XUr26W87uPzer5cm9OFKC1UqJx8KnL1Am7lNAoAN89ffZfwefgxoJyw2haJG7D4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b484cb-c7b2-4123-c83b-08d724e7bb17
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 20:56:38.9418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xbqXG5gSWQP4ojgRVM6Ea96CrAX9EhwbJ7orlNE72BzlxVGe4ItbzX+/iM7L4gtH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYASPR01MB0058
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908190211
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Justin,=20

> Hi Ben,
>
> I have similar fix locally with different approach as the command handler=
 may have some expectation for those byes.
> We can use NCSI_PKT_CMD_OEM handler as it only copies data based on the p=
ayload length.

Great! Yes I was thinking the same, we just need some way to take data payl=
oad sent from netlink message and sent it over NC-SI.

>
> diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c index 5c3fad8..3b0=
1f65 100644
> --- a/net/ncsi/ncsi-cmd.c
> +++ b/net/ncsi/ncsi-cmd.c
> @@ -309,14 +309,19 @@ static struct ncsi_request *ncsi_alloc_command(stru=
ct ncsi_cmd_arg *nca)
> =20
>  int ncsi_xmit_cmd(struct ncsi_cmd_arg *nca)  {
> + struct ncsi_cmd_handler *nch =3D NULL;
>         struct ncsi_request *nr;
> + unsigned char type;
>         struct ethhdr *eh;
> -   struct ncsi_cmd_handler *nch =3D NULL;
>         int i, ret;
> =20
> + if (nca->req_flags =3D=3D NCSI_REQ_FLAG_NETLINK_DRIVEN)
> +         type =3D NCSI_PKT_CMD_OEM;
> + else
> +         type =3D nca->type;
>         /* Search for the handler */
>         for (i =3D 0; i < ARRAY_SIZE(ncsi_cmd_handlers); i++) {
> -           if (ncsi_cmd_handlers[i].type =3D=3D nca->type) {
> +         if (ncsi_cmd_handlers[i].type =3D=3D type) {
>                         if (ncsi_cmd_handlers[i].handler)
>                                 nch =3D &ncsi_cmd_handlers[i];
>                         else
>

So in this case NCSI_PKT_CMD_OEM would be the default handler for all NC-SI=
 command over netlink  (standard and OEM), correct?
Should we rename this to something like NCSI_PKT_CMD_GENERIC for clarity pe=
rhaps?  Do you plan to upstream this patch? =20


Also do you have local patch to support NCSI_PKT_CMD_PLDM and the PLDM over=
 NC-SI commands defined here (https://www.dmtf.org/sites/default/files/NC-S=
I_1.2_PLDM_Support_over_RBT_Commands_Proposal.pdf)?
If not I can send my local changes - but I think we can use the same NCSI_P=
KT_CMD_OEM handler to transport PLDM payload over NC-SI.
What do you think?

(CC Deepak as I think once this is in place we can use pldmtool to send bas=
ic PLDM payloads over NC-SI)

Regards,
-Ben


