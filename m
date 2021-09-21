Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7B4413D7E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbhIUWZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:25:03 -0400
Received: from mx07-001d1705.pphosted.com ([185.132.183.11]:59680 "EHLO
        mx07-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229804AbhIUWYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 18:24:55 -0400
Received: from pps.filterd (m0209324.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LMHdxl019089;
        Tue, 21 Sep 2021 22:23:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=e/wby+Li+iV+++l/dsdaJkgX9Aq1ghHZMVltZ2J72lY=;
 b=mIRem1xbee2bdD/87+YjZU3TwqDNKac9be4obX0tJvuiYAPRNMVjYunsUnkLgOKR/vyh
 l0dOs5A7LBBUzj7QJZHmSIms5m0kvhVLIl7N9pepv86Z2ugr36lWtOSE7FKLbXU/xwpV
 FwF7QbXpP42VFhjGcahyqMAm5pANbaulhHMPSzStHyDeJmdga2aqvf7a2iT8ngiN+sfA
 ONlG3/mh2DaKREaqpql8eBAmbsYDVqq5Bs1P7IPVfJxBvKg/xrqbSkn2vW05/6L6f5yr
 MKZEFFTSF1w2UeH0q370FOcpEY1B+AXmz/vb1GImXLVhS/Cw4VyMmJHScYkfV2HvhswG eQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx08-001d1705.pphosted.com with ESMTP id 3b7q3x010j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 22:23:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgxfvYsruzbWzRsVkTYf+oo9nJl25UQWUFk7aoJ2xPhsrQEuiQksDGkvIw33Yx5Fz+svROe44JnvAXGX2YkS56dRAA9G9yZ0jjRcbvxCthpmXfahwZfU1P8xj4Tbausu2YQUKF1GqxSW+3YC3n4lSenz5ks2aU1xQj8UsmD00h1QU78Y8C8un1Lrkm1Y4NJyu8iiI8ZlC8VSbEsUFAbymPXqo+j0Ayc8DNoosG0WajFpSEbbVZKQoiceQ1jZSXjRj60idu2cULpxhTCu4RshKKxRtD4MR0oL79MZ9FDOoSzyk7RUtNyJqYgQizz6sVON6RTkkZrtlqGUHxffpwPnhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=e/wby+Li+iV+++l/dsdaJkgX9Aq1ghHZMVltZ2J72lY=;
 b=LRikzwUY1AQSSFcPSU2ECViU9XUDnSGqPHsTQ0huNfy/NxjFl5eq6WmiaqPVgaWWa664oWW9S3M1HJcjj/130m2datuwA7Plpgt9G6tG6g4klDelQAsTV6yf9IQ3qMmowSqPhYcR6uirPXwIMHdgJxrLVfW+1B841quMZgIbBtCZzt2B/wxxgjqFC8oFniPPG5xlhghe0607dIr8U5w5XT7vUXE/4tUUZt4jM10zlE2CoyLqLsgBaeFB1pnbDLVBBrDNEOnc9qrZ0je5b2W+8Fwit5Qe80EK36i4mHzNHxuR7LEXum06bNzTCw+zyykHz9V3N/PQeySeHc+SRQjVsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from BY5PR13MB3604.namprd13.prod.outlook.com (2603:10b6:a03:1a6::30)
 by BYAPR13MB2664.namprd13.prod.outlook.com (2603:10b6:a03:fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.9; Tue, 21 Sep
 2021 22:22:57 +0000
Received: from BY5PR13MB3604.namprd13.prod.outlook.com
 ([fe80::44c2:dbfb:2fd6:c0a8]) by BY5PR13MB3604.namprd13.prod.outlook.com
 ([fe80::44c2:dbfb:2fd6:c0a8%3]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 22:22:57 +0000
From:   <Patrick.Mclean@sony.com>
To:     <greg@kroah.com>
CC:     <stable@vger.kernel.org>, <regressions@lists.linux.dev>,
        <ayal@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <leonro@nvidia.com>, <Aaron.U'ren@sony.com>,
        <Russell.Brown@sony.com>, <Victor.Payno@sony.com>
Subject: Re: mlx5_core 5.10 stable series regression starting at 5.10.65
Thread-Topic: mlx5_core 5.10 stable series regression starting at 5.10.65
Thread-Index: AQHXrko8xYvrC7NN7Uiktm3q1KSJXKuuCAQAgAC7r5U=
Date:   Tue, 21 Sep 2021 22:22:57 +0000
Message-ID: <BY5PR13MB3604527F4A98D0F86B02AC98EEA19@BY5PR13MB3604.namprd13.prod.outlook.com>
References: <BY5PR13MB3604D3031E984CA34A57B7C9EEA09@BY5PR13MB3604.namprd13.prod.outlook.com>
 <YUl8PKVz/em51KHR@kroah.com>
In-Reply-To: <YUl8PKVz/em51KHR@kroah.com>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 56f53b8b-a0ec-aefe-18d1-c94b5446f85e
authentication-results: kroah.com; dkim=none (message not signed)
 header.d=none;kroah.com; dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8be9f7f9-bc37-46d8-a540-08d97d4e5d23
x-ms-traffictypediagnostic: BYAPR13MB2664:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR13MB26649CB9C552335C79B6ABA7EEA19@BYAPR13MB2664.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:247;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CxSJDxdJ5+nCzPhPRnVZEDDEaZXlPN9ZcdSXAuU10qFAreRBRA7zTAiRFnHr5waHJIHPtFNnSbag+AqizX7hV93p93F71ZppfvEsH/eeBnoJRV8ducY5nJ351RSwkKoyCq+7WJQrgyBDb+QjpNW0LmHiYASopBBm2Mpx9fUooMwX1jycR3861seXyL/ck2E0MWNQFWyqMvi3QKgJG/VcYsQoD7Gd1QtNFvJaNMsqNHwmhm6WnL+iV42U2fPyiapeF7NIIGkkSuT8674uQ4WiV63VUcXym4sGBQGgFPwKb2kSvOKG1iJ3manJA9TXvdIxtUfXqubQr2DC/Ax6iUv+VEr9Y/ZjksevUNjv4HI94o/2pSxu8cTjl/ppnN47jE8zbwtgigdxkLOcVWcBgb+NA2r3NyjCSIkfJVRHS02DZQ2brkaG2U07c6XcaJiOC6srLbzeFc3ioyd8UaIFSND/Aj5XjhfLjFFhC1+3cftGbFJzrMVkLNUYlX+mWDR4GYeP+gAO82XaJbwhNrufk/FuaYWpN4SRQWPtZa8bk6FXSjnZOBgJPHDWk/SGTpUceRBt+7DmjVxoVlamxNOEbikTG6OWMWOuKmqLIRYJ7KbC/jTCFSxyiAlZFRm+Re4vj0cimlSPapRUKxdqV6x4wLG5lf+fCVjyTjvto4XGSoYM7GkguM/iyGnopzUPcg3VtQWsNgceNYLE9dcQgLquz+zpv2GsIPK9pJ3Il6M+MYYKQKxZO3p9HbdMVBw7JgoK1ffNAOpGXxSwykcafKBRU4cRewMqxtkkN9v7zMVpgPuowiU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR13MB3604.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(86362001)(5660300002)(71200400001)(66446008)(316002)(38100700002)(7696005)(66476007)(8936002)(54906003)(107886003)(66946007)(8676002)(4326008)(122000001)(2906002)(9686003)(83380400001)(38070700005)(6916009)(64756008)(66556008)(76116006)(966005)(186003)(6506007)(55016002)(52536014)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?R+cZrQdoHOXmDQSNTNYUjeoQ73C9WTNRNlPfh4RBez6Ds2pj80tpHMLH2S?=
 =?iso-8859-1?Q?YqR0N+c1G7cMSmGsk+MliFPj2HMNzVb4tGOfsLSmELrQiQOZ0vByOGQBqA?=
 =?iso-8859-1?Q?6EXylWMTHIhwB1e7OYZwQWLXGqclYwE6epZhlL/LjFtgNLcgbuH+py3zZp?=
 =?iso-8859-1?Q?xbtPMDm31CGoby2SKKFiAleEpI5y+fjA/uJrTaw6Ev0dqPdVQJnOz1Yi5S?=
 =?iso-8859-1?Q?FG7qOC3WpAQ91bXNKDyTL/pV04VcgdksCGVvL8EOWzygkFiZQ3kWV80mim?=
 =?iso-8859-1?Q?2L0VjZ2iMW2iSw4pmOOkYm/Rk6pDNj1og7Oz7lp0b/+EJy9wkY4RMK9SK4?=
 =?iso-8859-1?Q?3r7fuHVvW5uocT60EfgdV4NJ+VswaPeKG8gSy5QuBVeOZXnj5GnLS5osy1?=
 =?iso-8859-1?Q?6MvtKHA+0Z82+T1LAm0Bmh3k/u7QsA+JZgEMBcMW7giUwmlUxEpGj+QFQP?=
 =?iso-8859-1?Q?XJHWy3ph1lxDdkzHp6bC6VCOmL7rnwDyVLtnRl8k4eSgrbfaZ5uJwa3DZx?=
 =?iso-8859-1?Q?qUsC8obRWxpiz4rzzWEydZEJHBQrA9iZgPavwY1W/J+0SSe3CKnmCegK54?=
 =?iso-8859-1?Q?/1FhG5RiJNE6v6QsPAdcs8IHT5RlIULgUMd34TXJ2Mde3N/yJP+lVTN9Sk?=
 =?iso-8859-1?Q?qXqA15UMKSGvcPEAUOfDenLuwhKR40rZXOjaCzDb9ScTO11SBC/9/ZvOA9?=
 =?iso-8859-1?Q?zn09hFCpMDZF1TSCDfuUBisd/7oLCbqZupxYSqCE8Of8K+gC7cmORkx+zw?=
 =?iso-8859-1?Q?QiRkqjgTXy/8rCF52pAkEbHDozIEIi1fA+aoXGZtmgPKNrDaV4hBEeLlGw?=
 =?iso-8859-1?Q?NIokF49C2VaVwjGSbc0EBu6ubAFf35o/Oqi/nBidtMMsyvgh+6oKbH6BON?=
 =?iso-8859-1?Q?G5ou67rtMo9LOI+6DiHugXsU+LjUqelLo+zJFJIjNXqWcca5tf8q7jtTRZ?=
 =?iso-8859-1?Q?GUECoz0q7TnUWCbMr9hYnsw0Vo2sO3VF0BNiqWIU7B+u06/oJd/v2l7ODK?=
 =?iso-8859-1?Q?7vnJOMvQSuv5C/ZviCoJ3tQLuQNVFJwPdm8RsyWdmY3LXyUfNe2+c53o05?=
 =?iso-8859-1?Q?Zyo/S7+j5L91LBkNxJeVewBVSteXpqYyoAxR1dtPcYdLci3TAPX8u0vZaN?=
 =?iso-8859-1?Q?/CK1PO6665GiJu1jsGXC9EOXjnHpNpuxDhvYZTem99IS2dzcYHDgEPUq5l?=
 =?iso-8859-1?Q?G1BcoD2sob1a23XOvPODO2+7KL9HPiwePG0I4LLAqheqSzg5aYCR5ePLDg?=
 =?iso-8859-1?Q?uZQYbAYsd+P2FoABJKmWZ13h+CbTC/583lZt3uWZrHA8awJGu6n540S0vH?=
 =?iso-8859-1?Q?WTJBzPsV/loR7AFYTcy6Yt4GbZregG4ANbJuCE5bXRswnrylA14hOrRsKh?=
 =?iso-8859-1?Q?SELwEWCFDkX3Q/CaMndJd+LIfKilnbhatxdsNxc81Ku3GMbYVCpiyJEZ5q?=
 =?iso-8859-1?Q?QATt3SNGK5z9ESx7?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR13MB3604.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be9f7f9-bc37-46d8-a540-08d97d4e5d23
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2021 22:22:57.2304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MHPYvl28d52tfRZZrmTLTVByWzdUusybxUY6on6zI0wBN8gfN7vmWWrt/dWszbXyYb8lXwFoFfxk2medGOaGYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR13MB2664
X-Proofpoint-GUID: 6a26jrnvKPl7ge5Ip08lWieUAUG1g3oi
X-Proofpoint-ORIG-GUID: 6a26jrnvKPl7ge5Ip08lWieUAUG1g3oi
X-Sony-Outbound-GUID: 6a26jrnvKPl7ge5Ip08lWieUAUG1g3oi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109210133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Sep 20, 2021 at 08:22:44PM +0000, Patrick.Mclean@sony.com wrote:=
=0A=
> > In 5.10 stable kernels since 5.10.65 certain mlx5 cards are no longer u=
sable (relevant dmesg logs and lspci output are pasted below).=0A=
> >=0A=
> > Bisecting the problem tracks the problem down to this commit:=0A=
> > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel=
/git/stable/linux.git/commit/?h=3Dlinux-5.10.y&id=3Dfe6322774ca28669868a7e2=
31e173e09f7422118__;!!JmoZiZGBv3RvKRSx!phUrsR595UusBY2Q9eNJQS7-VNtnb72Rcvhe=
-W0QKDPir1WY9mvWOkLLfe63k-6Uvw$=0A=
> >=0A=
> > Here is how lscpi -nn identifies the cards:=0A=
> > 41:00.0 Ethernet controller [0200]: Mellanox Technologies MT27800 Famil=
y [ConnectX-5] [15b3:1017]=0A=
> > 41:00.1 Ethernet controller [0200]: Mellanox Technologies MT27800 Famil=
y [ConnectX-5] [15b3:1017]=0A=
> >=0A=
> > Here are the relevant dmesg logs:=0A=
> > [   13.409473] mlx5_core 0000:41:00.0: firmware version: 16.31.1014=0A=
> > [   13.415944] mlx5_core 0000:41:00.0: 126.016 Gb/s available PCIe band=
width (8.0 GT/s PCIe x16 link)=0A=
> > [   13.707425] mlx5_core 0000:41:00.0: Rate limit: 127 rates are suppor=
ted, range: 0Mbps to 24414Mbps=0A=
> > [   13.718221] mlx5_core 0000:41:00.0: E-Switch: Total vports 2, per vp=
ort: max uc(128) max mc(2048)=0A=
> > [   13.740607] mlx5_core 0000:41:00.0: Port module event: module 0, Cab=
le plugged=0A=
> > [   13.759857] mlx5_core 0000:41:00.0: mlx5_pcie_event:294:(pid 586): P=
CIe slot advertised sufficient power (75W).=0A=
> > [   17.986973] mlx5_core 0000:41:00.0: E-Switch: cleanup=0A=
> > [   18.686204] mlx5_core 0000:41:00.0: init_one:1371:(pid 803): mlx5_lo=
ad_one failed with error code -22=0A=
> > [   18.701352] mlx5_core: probe of 0000:41:00.0 failed with error -22=
=0A=
> > [   18.727364] mlx5_core 0000:41:00.1: firmware version: 16.31.1014=0A=
> > [   18.743853] mlx5_core 0000:41:00.1: 126.016 Gb/s available PCIe band=
width (8.0 GT/s PCIe x16 link)=0A=
> > [   19.015349] mlx5_core 0000:41:00.1: Rate limit: 127 rates are suppor=
ted, range: 0Mbps to 24414Mbps=0A=
> > [   19.025157] mlx5_core 0000:41:00.1: E-Switch: Total vports 2, per vp=
ort: max uc(128) max mc(2048)=0A=
> > [   19.053569] mlx5_core 0000:41:00.1: Port module event: module 1, Cab=
le unplugged=0A=
> > [   19.062093] mlx5_core 0000:41:00.1: mlx5_pcie_event:294:(pid 591): P=
CIe slot advertised sufficient power (75W).=0A=
> > [   22.826932] mlx5_core 0000:41:00.1: E-Switch: cleanup=0A=
> > [   23.544747] mlx5_core 0000:41:00.1: init_one:1371:(pid 803): mlx5_lo=
ad_one failed with error code -22=0A=
> > [   23.555071] mlx5_core: probe of 0000:41:00.1 failed with error -22=
=0A=
> >=0A=
> > Please let me know if I can provide any further information.=0A=
> =0A=
> If you revert that single change, do things work properly?=0A=
=0A=
Yes, things work properly after reverting that single change (tested with 5=
.10.67).=0A=
=0A=
> Does newer kernels (5.14, 5.15-rc2) work properly for you as well?=0A=
=0A=
We tested 5.14.6, and it works as expected.=
