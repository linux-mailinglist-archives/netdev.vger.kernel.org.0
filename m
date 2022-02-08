Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E184AE340
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiBHWVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386259AbiBHTzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 14:55:15 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eus2azon11021024.outbound.protection.outlook.com [52.101.57.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFA3C0613CB;
        Tue,  8 Feb 2022 11:55:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVPuDPYTBR/6Osb9n9Zrnq0BLpYauk+nMktBS5/a8/RUmlBDoERwyAe4ZxwPb7p6YWGfp2PXMpz0aWbnXJ9Gocnh/mNKoglxQS0VSgh6Sq0xFfDfYq2t4lzyN2y+OdLzJI/WLwcLgmseoaQeGz8w0vJmtuCKzJXAtJJFDohpIqXE+7XW8tsQEfSbYVw8gOIdyKmLT0lpKKxocBik5ebj95xWyB6y9q3WMvriwvmiJwJArq1eEY1q4IltIKVtVW4Cvzq95w1vRzpTbPyA1HqYxTwYWHxEgg5jnlL+7WlDUm+Wbey9cIBY94FTI73/8fZDXQuhYzG4YzY8R1JsNi67Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVERQtCb7OUiDQx1HpSshWfxOtShhI1dQvVG3akATuo=;
 b=TUlRPsFIRvOF9Gmiz/2QUQ3au85faTdjQ87z5FQKgBt5HYnh4gXRnBNozCNwfGpxRbtfejXpe5AVI5kE7W4TLu5BGeCQ7LE26Bn1IsHbgvV6wbthFJuE2RfxMfGydZUglJ7CO7xNm9PRc+DIfcDZt6sG8T92/UJfqa/HR1BKdPcSFEe/6bgfxID7tMml8kJNmddCndWm+3Q4V3P0uORTmrwATtb/l8cymHdsANAxOtn0Iqz9L2oGu9IWaFudybQZRfAGA2sVOefan8yPSOgs6KhR98kXOYSUOQOm+DC3104dT2RSOP3YETRv8ly5EsltwBg5/9iEV0/QleRhgP2hPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVERQtCb7OUiDQx1HpSshWfxOtShhI1dQvVG3akATuo=;
 b=IesYCas2e0j6b9sQ/KYgbECinKO37+OELkOQaWRgLF1Gcvn8fdQaDHNFxFNFKTC+I/FCRShssfQHM0ZbPBhtJRC0SmEZza4dJcIiY4+irgVnobtfyPJz+y0CapwtknRo0QsR/zo7JcpAcXvZYVm8rCsULwuZ1jP0K+zcgEqSL0s=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (2603:10b6:208:3e::25)
 by MW4PR21MB2042.namprd21.prod.outlook.com (2603:10b6:303:11d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.4; Tue, 8 Feb
 2022 19:55:10 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::e081:f6e4:67eb:4704]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::e081:f6e4:67eb:4704%7]) with mapi id 15.20.4995.004; Tue, 8 Feb 2022
 19:55:10 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 1/2] net: mana: Add handling of CQE_RX_TRUNCATED
Thread-Topic: [PATCH net-next, 1/2] net: mana: Add handling of
 CQE_RX_TRUNCATED
Thread-Index: AQHYGhkbwj/2soN83kmQnCFUF3LCRqyFiqLggALM3QCAAb+p4A==
Date:   Tue, 8 Feb 2022 19:55:10 +0000
Message-ID: <MN2PR21MB12957E665D93B56851DBC85ACA2D9@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
        <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
        <MN2PR21MB12957F8F10E4B152E26421BBCA2A9@MN2PR21MB1295.namprd21.prod.outlook.com>
 <20220207091212.0ccccde7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207091212.0ccccde7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=520918e5-84df-401b-a5b3-bc50e242ad18;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-02-08T19:54:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 060d29c6-ad74-4fdf-efae-08d9eb3ce9df
x-ms-traffictypediagnostic: MW4PR21MB2042:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <MW4PR21MB20423A952897783BE3897CCFCA2D9@MW4PR21MB2042.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NcuPTydZOWyiwnNFn5OzbHMbuIdMH7ITFkHbfgMmn8yPWl+y92UcXBhyun/suTGcGaBweCLtbmWfCHedV8UwUc9KAyfqMVOeAeoSEQCVq96RAhSPZJv5mvULtbS/auqRo6pAdcycxqyX6E0TjHsdmyf0d0yN2szNgOFh/PJqQ7eddGVfgIjRoJeR2So8S0GUjKLe0WsDtCl1wuj/8mR+YwuO7sH0MGLO6JN/4JI3dAH3vX1Qnm+iCbs0sji9Fa9DIQdZ9yn/SsPdxR3KejjXxfwoHcbQo6w/wmX4EtfiERY49d/j9uWnrLcf3NY1nTcbnW4o+hoINp6zR1h4xKXsZfPdThDO/SLfVTWhNTz4B/6i2DD88AuDZfdXdEaLcXiB0hckvtHU5h9RRJgVooeq46cWcGzBaFJSgNSEwrE64X/32TWsKbhWGzSNqnMTdtTEvtV8vBJPBhXHOdxxpfrvvrgH5wqZHghqeIjjN/76S6SJdBPeu7ybRXDllK9nvVs7hcFtdU1NdgXz7o5rU2qlA16qZ7f0iRJo6M502SznDg+4JodoB/EyimSGitg/TNtzuy2OQUpas9+gD1jUsvcNTHZv87Iy7gnqh9eAscG6fwZtHQU1dHmc0P82yIsca1MxJf54NyesNNy3jYGU1kVH1PvQx74f1S361ejYeGrznHsp7DhXRJtuQXmukEo28Eynn/5AzKvQPYPkYVIfTI44GWf81hdk0gsr8aKf0fe91fmT4ZYtTRIpmmSJTZj0sAu1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(64756008)(66446008)(71200400001)(26005)(186003)(8676002)(9686003)(6506007)(7696005)(53546011)(508600001)(10290500003)(66476007)(76116006)(83380400001)(4326008)(6916009)(8936002)(66946007)(4744005)(38100700002)(86362001)(316002)(122000001)(38070700005)(54906003)(8990500004)(2906002)(82960400001)(33656002)(82950400001)(5660300002)(52536014)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n7R2dmue9wGMc73JfAFiLrbaCdZszzQphU+/gR0XvCBHtK9ICv6BqxzboRCb?=
 =?us-ascii?Q?wmNIHo9H1t17Jt1pD6Yv6BVSUX2+Q9RcxL+N7lnpLOW2qJYtVhQDdZ6eFHyr?=
 =?us-ascii?Q?iZfgVVFpMrMBVQRmSnCMx5Q63XiXeZ48KP6FAkHkU41WP4x8Bwzgv2Z8VP9c?=
 =?us-ascii?Q?BwoEQeDG2mQog/ZlU7XietL3zuqOJAiKk1IIX0HFg/5OGs8TVKt0fxpLXM52?=
 =?us-ascii?Q?AVXEdbPfnjIa0ETChIG/A5nt4049ZrloQP9p2GdlGTOd4cGOhf8RZvTmH4RL?=
 =?us-ascii?Q?JoTtymd/b/QI9d9p3TnAu6k8jfzRONr6IW2VWlVUZ/DHFUVJz2jTZuCXNzPL?=
 =?us-ascii?Q?1JxVemKOHMixZZCD7KOclkHQ1T/9zt0VGcWTRZG9p99hHwS1fFAb/SsYD5E8?=
 =?us-ascii?Q?++XRhW66G+9t3KK7xAV20DSkFFjiJMXiBKG/TVj9ECitWb+21r390npRW70a?=
 =?us-ascii?Q?RuyBdT57WwCenuRehKtzp9hejTWutDJlrC/6l91T5GDkmekXQPGnat3YhH9L?=
 =?us-ascii?Q?Rf5bE2OYMH0y3DamIeSH3e8LuqS/DSjqGuYXxeYIEZqR70faxDoD4uKYa/Nw?=
 =?us-ascii?Q?BBGbOlsvRCyjDnQJH4BRzxKsGH8KhnvLf95AhBFqElE8VjjDwy1YfOEiqX4p?=
 =?us-ascii?Q?5+7DuCSdJsjJbKUeFwT1rVTA5wHj6wcIpe+M5r7sLDUcmP3SlbwBnxK6kp9g?=
 =?us-ascii?Q?Yv9jLFAyFPoH8J7f56G3SAyOheASOR5vWdNVnomrvsw+9kaN17aWIgQGXydG?=
 =?us-ascii?Q?O8hF9HJ8x0MfjpzsZNMhoX4gG8bVcqIsnP27Y1TKZQzS2EzYFaAvqkhwmfdb?=
 =?us-ascii?Q?g38ESqA/3/lisPWy5L8RDErr2WpAzQQytnU0SIdh05OMYwd3g9WC2b6WqCDw?=
 =?us-ascii?Q?AVO7BjqHwEgdgfuJAw9/UFjM6vk3XqetJiI9JYfvZHApcaAzwybAt8o8rkI8?=
 =?us-ascii?Q?hk1BJizPEN3+iEiU4RdpVfvsO4gaI+HIyJ6NODBYl40xjDnfsFNbFWkKyerS?=
 =?us-ascii?Q?mH7NRZZ3QX8hF85GidjlUV8aoRiN1A7RD08QdDGigINQQO1oI41UucbrGofe?=
 =?us-ascii?Q?RhXhAF8fGwAdvtSEjoCwdGS3b9AU8qh4Xr/KTAzaegjZK4osG24AbiXOMCtP?=
 =?us-ascii?Q?g79qYDA2k6ymyvo9nnCr87k0SGQxEulAytHiY+SyCMiXU+yWHrR0GRc3ei2e?=
 =?us-ascii?Q?a0+7wag8nkUabXMldUdam8DVDf0Kd5/X4GgGYxqR71mCWhFCm5ZvqvWU1wM1?=
 =?us-ascii?Q?95SYgTK8ZdulKUnN5Vm6R2FCUDWBeSh7GstoYzvo+rDfSAXLGL5vU0HZrbnc?=
 =?us-ascii?Q?ty+xYuuSePqfcb7eHBd6efqe81wY3l2h8mhauwWh86HyyZi9fZSSJ4cA8O9M?=
 =?us-ascii?Q?E8uTRu2R1bYvLSUKO2wyUzVMj5RA+UvhKmNSgSRvdKmMdOAYIN/Iv4L6RpeK?=
 =?us-ascii?Q?4zJMwh+wTegG3RHgJgDzpOyZ7sfOrtUT0ThfsyeyM09e+/2yiEgFFoBTXHBk?=
 =?us-ascii?Q?wsc7VHpyILrgA6+BUZLnezBjkxcHhYa88v+OhRTP1tU2WGuBKbLCI7p6zqaP?=
 =?us-ascii?Q?/fuQVeRV4DDP0FrPBu2mlizOkvDZN5OVn3/xI3se5CX41kxGqc4YvsQwlSQh?=
 =?us-ascii?Q?9w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060d29c6-ad74-4fdf-efae-08d9eb3ce9df
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:55:10.3218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uO4JoJHew4SlCXFv5OC0+Z+Pewv1NFTTstwiXl8DDFh2t9Mkq7OQMxq5+Cvgyk7f5tryP8/f1j7SyVby6zZ2Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2042
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, February 7, 2022 12:12 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui <dec=
ui@microsoft.com>;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.=
com>; Paul
> Rosswurm <paulros@microsoft.com>; Shachar Raindel <shacharr@microsoft.com=
>; olaf@aepfle.de;
> vkuznets <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.ke=
rnel.org
> Subject: Re: [PATCH net-next, 1/2] net: mana: Add handling of CQE_RX_TRUN=
CATED
>=20
> On Sat, 5 Feb 2022 22:32:41 +0000 Haiyang Zhang wrote:
> > Since the proper handling of CQE_RX_TRUNCATED type is important, could =
any
> > of you backport this patch to the stable branches: 5.16 & 5.15?
>=20
> Only patches which are in Linus's tree can be backported to stable.
> You sent this change for -next so no, it can't be backported now.
> You need to wait until 5.17 final is released and then ask Greg KH
> to backport it.

Will do.

Thanks!
