Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962FB96C2C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbfHTW0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:26:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61172 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728283AbfHTW0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:26:48 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7KMOBTG023757;
        Tue, 20 Aug 2019 15:26:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PmzdpRrdT8p9nqpFjaHqG0PJu7TS8TDeErXzEhSNiVE=;
 b=SfuD21BbkI0VrFYRiixwTlojnVjgIZR0BO91YQDDScs2Pc3itODS8qijKghqQgZSyU7X
 wDJKohVXGjKzVaFj+MTToj4E0XsnECncejtNFMnsVux847AvCxkVKVoDTeouq2zbeZQO
 8ftYs+iidm3xztWpktMhveBUyXqZCK1keQs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2ugmrphea0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Aug 2019 15:26:30 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 15:26:29 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 15:26:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbPiYNEpFmvh1iCeuxUqKWTldiTlvVwp5Ueu7Drmnek4bXKikqHpUs6tbHfGVjyEPKED4D7sSCPnQ2a6tCQkIyD4oq/qyiqMfFkcOuIUPhhxud1oCq78ga0wzoy4xKzRtVrfLoGFXNt2azjVofdRWdZjX4IS+0zVCsZNJxfRWimvTyjW5B5mhyIhUPQy4J7yV2DGJhl9xz2goQCW26nrki12Hn7KKZL4skzcosxbeDoLrVY8kvzHvA2UedzXLgw+59A0HWigrs0BSjX4k2LRfUWXOr4BhAnBqP9SQwy2WnlMbcTcU6j2KuA7QqbzQwGI0xwUIs+QxFOCVuFaKlRXgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmzdpRrdT8p9nqpFjaHqG0PJu7TS8TDeErXzEhSNiVE=;
 b=ANlca3iFlpPTYXAT0DYE2AIT0yNUlzCO6yYlgc8MXHE6NJ3HdTCzbXNIqUemTTomZZlO2j9MzezMEUd4cy0hG98zVPC1H3BefUxf+SIH88WFBqLEtBiIDM5GFsWzVY8r8DIaRODY95ACcEEbc/1FDO/+6OexJB5tVEr9UfOGt7onAvOMjxe1sw2/QU6x+WmaXk8sjTdTarjrJyTKDH5Xuh1IXaQJfmlbjE+7hLx3mO7voyjK2Q9iXUDLb+LWL3QjV7Qi81+NoS00hzAg/ZpIb5uginBSd1F523vy8koL5y+xZ1UVqNF7DUnYvrfit2pZEOdmpIOQ9vu6k7dsedyqnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmzdpRrdT8p9nqpFjaHqG0PJu7TS8TDeErXzEhSNiVE=;
 b=Qq2xirOzLhwMsDJNLrDPZ7TpdFQ+nlF3xeIiygVmpnBad9R0YZla91pXitF5gSFQ3+sOoZpuOQrrk1EMTfEL542HriYqLOV0m0wS1N7zLbZFp754w6avmxV/aBSeJ9VZO0bAYmJ149M3x7Vyk+tZgnx/MJT33iwcc2GPCCHrzho=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3607.namprd15.prod.outlook.com (52.132.228.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 22:26:27 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 22:26:27 +0000
From:   Ben Wei <benwei@fb.com>
To:     "Justin.Lee1@Dell.com" <Justin.Lee1@Dell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dkodihal@linux.vnet.ibm.com" <dkodihal@linux.vnet.ibm.com>
Subject: RE: [PATCH] net/ncsi: add control packet payload to NC-SI commands
 from netlink
Thread-Topic: [PATCH] net/ncsi: add control packet payload to NC-SI commands
 from netlink
Thread-Index: AdVWRzWK9Wcjcdd/SW6uTu9wV1cgUQAe69YgAALeARAAKCEBYAANyNsw
Date:   Tue, 20 Aug 2019 22:26:26 +0000
Message-ID: <CH2PR15MB36868FA738FB7D9382AB536CA3AB0@CH2PR15MB3686.namprd15.prod.outlook.com>
References: <CH2PR15MB368691D280F882864A6D356DA3A80@CH2PR15MB3686.namprd15.prod.outlook.com>
 <ec5842fff4de45069a51618eb72df164@AUSX13MPS302.AMER.DELL.COM>
 <CH2PR15MB3686A4CEF8FA3B567078B4A1A3A80@CH2PR15MB3686.namprd15.prod.outlook.com>
 <b862e3168f5b4a6eaf005d6b24950795@AUSX13MPS302.AMER.DELL.COM>
In-Reply-To: <b862e3168f5b4a6eaf005d6b24950795@AUSX13MPS302.AMER.DELL.COM>
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
x-originating-ip: [2620:10d:c090:200::3:7b56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76684a57-1422-449e-1202-08d725bd7103
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3607;
x-ms-traffictypediagnostic: CH2PR15MB3607:
x-microsoft-antispam-prvs: <CH2PR15MB360709C990AF5946DC93921EA3AB0@CH2PR15MB3607.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(136003)(366004)(346002)(189003)(199004)(66556008)(66946007)(76116006)(54906003)(66446008)(64756008)(9686003)(6246003)(66476007)(4326008)(55016002)(229853002)(6916009)(52536014)(316002)(486006)(5640700003)(476003)(6116002)(478600001)(33656002)(99286004)(7696005)(7736002)(76176011)(2351001)(6436002)(5660300002)(305945005)(53936002)(46003)(6506007)(2906002)(71190400001)(256004)(74316002)(14444005)(71200400001)(102836004)(81156014)(446003)(8936002)(2501003)(8676002)(86362001)(186003)(81166006)(11346002)(14454004)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3607;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ovi7iTkhkv2UdUc0UZ+f2QoPi47zv9CLQp5u2PI7euBR+OlSdfM/C32Ov+T92BDN3zOX0nO2EOCg7pWbuweSQXcjisFJVkOrDiIlVglXFG03LoYo6AcYbMpQN6HOVerzv9QPkHFkwP4lTf7LiKqHY0aCD5yyYkIDaubMv5LiJygR7BlYUZ/k1T56Tgaujq1LlEXnxPHWnOmTNeebkCsZvSip6R1DlPExvegRA/DFLLy4AxX5ZZf40sJEICb/iSwlfuXJdNO4hjvpvnp2PvpV6mLth1Dx3DjdNBVsnfMJmDVWGyXwVxklxZuJ9ht0DkcJi0VD8IIdMnlpSCR8YomZ60Mwrga02+4b6qNu1wnch7Mpzmgv19fcu6ikb/37AR2t7+lVbf/wV4o1UJ5eM8yTf53pi2sP3vRhC2M4AsrPCGw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 76684a57-1422-449e-1202-08d725bd7103
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 22:26:26.9738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vc+m+cX8kU9f/QorjSno7M0C0bNU8AJNJniN6ngZPg8g3/hC5nsPLaQITb1TVts2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3607
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Ben,=20
>
> > Hi Justin,=20
> >=20
> > > Hi Ben,
> > >
> > > I have similar fix locally with different approach as the command han=
dler may have some expectation for those byes.
> > > We can use NCSI_PKT_CMD_OEM handler as it only copies data based on t=
he payload length.
> >=20
> > Great! Yes I was thinking the same, we just need some way to take data =
payload sent from netlink message and sent it over NC-SI.
> >=20
> > >
> > > diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c index 5c3fad8.=
.3b01f65 100644
> > > --- a/net/ncsi/ncsi-cmd.c
> > > +++ b/net/ncsi/ncsi-cmd.c
> > > @@ -309,14 +309,19 @@ static struct ncsi_request *ncsi_alloc_command(=
struct ncsi_cmd_arg *nca)
> > > =20
> > >  int ncsi_xmit_cmd(struct ncsi_cmd_arg *nca)  {
> > > + struct ncsi_cmd_handler *nch =3D NULL;
> > >         struct ncsi_request *nr;
> > > + unsigned char type;
> > >         struct ethhdr *eh;
> > > -   struct ncsi_cmd_handler *nch =3D NULL;
> > >         int i, ret;
> > > =20
> > > + if (nca->req_flags =3D=3D NCSI_REQ_FLAG_NETLINK_DRIVEN)
> > > +         type =3D NCSI_PKT_CMD_OEM;
> > > + else
> > > +         type =3D nca->type;
> > >         /* Search for the handler */
> > >         for (i =3D 0; i < ARRAY_SIZE(ncsi_cmd_handlers); i++) {
> > > -           if (ncsi_cmd_handlers[i].type =3D=3D nca->type) {
> > > +         if (ncsi_cmd_handlers[i].type =3D=3D type) {
> > >                         if (ncsi_cmd_handlers[i].handler)
> > >                                 nch =3D &ncsi_cmd_handlers[i];
> > >                         else
> > >
> >=20
> > So in this case NCSI_PKT_CMD_OEM would be the default handler for all N=
C-SI command over netlink  (standard and OEM), correct?
> Yes, that is correct. The handler for NCSI_PKT_CMD_OEM command is generic=
.
>
> > Should we rename this to something like NCSI_PKT_CMD_GENERIC for clarit=
y perhaps?  Do you plan to upstream this patch? =20
> NCSI_PKT_CMD_OEM is a real command type and it is defined by the NC-SI sp=
ecific.=20
> We can add comments to indicate that we use the generic command handler f=
rom NCSI_PKT_CMD_OEM command.
>
> Does the change work for you? If so, I will prepare the patch.

Thanks Justin. I verified this change and it works, thanks!

-Ben
