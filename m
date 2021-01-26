Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B83042CC
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 16:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391739AbhAZPmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 10:42:16 -0500
Received: from mail-bn8nam11on2092.outbound.protection.outlook.com ([40.107.236.92]:6624
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391050AbhAZPhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 10:37:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qil8An3OZOyDAechrupEQPhzvOlXeAeKbsmxDkjN1t8CTKh6y2BMrQDmXdST+tuDiEmDjqYtDrpYKkgGgAvJk1ZDcRy263N1261lKvzEfCoBWNm/KLl1IB0cU8WqREhmRD26WmK9mkkxkR320U8sGBQfNJ6W8kjUpWbuglkYqVJPHctmPopM9NmvSsP7UNq/ooE2IiQugbdHU9vhP88IHGpQaKqX1t5QqKMtmwh6wNtiqbOHjE1U4m/yov8QrQe6DyA5TxPlhRsUDQKeKHSQsDX00+YJR+FRirA4FJDcvV/fD9X2bZRH8pK4CwFl+XjC2IeRXMSEGn5WVDiek0ffow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7+g68V1i/FMEpZIbB7Uhynmz8Ilw8zrbARISNRUP5k=;
 b=ASr+EPyAiOg/pVe5dtpzx3tMzIh7suTWBXCJUo9KOLBliNgJ45nF1dlbQAhNaTwmW8BCNIGK4MXHQe8zM1G3P+dRSfui7icZUAO2PHW/1ATC8PL3UK5V16EIUZ3oEEBIF/MSBHgB2pSVdKwkzrvWSmf2HIucPq9c2USkYMvo9d4+FJ5DqW23EZztVWQ2oHrEqQVQC/Q9je15WngxT52+3GGT4kU3+SDSx6Aqx1UZUI4ooXGAelKtKWJrnPGx+uJk7kc2TL3y0qsrXXv7kBzIz57cCzfsmyPpguF65r7Zc2dFMtdw2Q+ovczjf+y4QuKkN56Ec0QqgzZaPERZHJZ9zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7+g68V1i/FMEpZIbB7Uhynmz8Ilw8zrbARISNRUP5k=;
 b=P4bEaPx1zeajaXtBdNPqH42FYL8tlDYclhO3wKHvOMCWBRneu9d8422Hn9//Dk3+9upBgmrQERZByCC3juIwxykHpbIue0LZsHgZxqSaPZMNQPDcQaRpK/CB1mrXs29akt1Igd0vmoXWBCOXZVOx9RIxZ4v+J+hljL8Wxgxw5Ps=
Received: from (2603:10b6:207:30::18) by
 BL0PR2101MB1347.namprd21.prod.outlook.com (2603:10b6:208:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.6; Tue, 26 Jan
 2021 15:36:09 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e427:1f15:a89e:2bc5]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e427:1f15:a89e:2bc5%7]) with mapi id 15.20.3825.005; Tue, 26 Jan 2021
 15:36:09 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 4/4] hv_netvsc: Restrict configurations on isolated
 guests
Thread-Topic: [PATCH v2 4/4] hv_netvsc: Restrict configurations on isolated
 guests
Thread-Index: AQHW89pqGbyqkgkYL0CRHzUXMQ8QQ6o6CfyQ
Date:   Tue, 26 Jan 2021 15:36:09 +0000
Message-ID: <BL0PR2101MB09305A4C70430BF2F1EE1358CABC9@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210126115641.2527-1-parri.andrea@gmail.com>
 <20210126115641.2527-5-parri.andrea@gmail.com>
In-Reply-To: <20210126115641.2527-5-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3194bee2-b24e-488e-a4be-f01525946f57;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-26T15:35:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3212b898-6a55-4f4e-59eb-08d8c2101ab6
x-ms-traffictypediagnostic: BL0PR2101MB1347:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB13470A17B344B54CAB471166CABC9@BL0PR2101MB1347.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Gqh0lMA2B75ZPAoo8Jck4EHaas4AXBtaenhs0AcHIJj1dkq0XLFZALwU/F8qZuyGlrxRE+NrSsuJ7XTyRsVFg9x2HYUXcXBME2YEaR7MMUnbwVD8QolEr+eOqI7TayorSDJDUgTyJgKDrPl4Qanbz1IGz88tjJ888L8CTBicNq7IqBa1hPfng3JogxgvinZgY+bSTzCzBRZ3ZTFSynwAL2hat0YPIhUKnkG4Q5CQ+Kx3rouf2NSp48eHsR/QnTdxRe/+q96rK+GFo4xdzbLwt4M/SkF+9DGAG6rd/15LwZlfpnyItF7yNj2HJsAeEB0CtzZCdCe0pTcy9LPQboZT6SqOQRBM0WocsTX5ibkn8kPdsxRV7aDlNKI4L0Olq41vP4Uz/4J2kvMQcsOGcpZQmeRqQPHg43sAHuIj9nmAN2sY47C3e26nmXFuU2PBxj+1T8wB3eItnco1Xi/efxRxZPh4BgYWztXoxwI+2w1Zu0say3sGz1rGPMW4/9+e9KcjEA4LR3PgJqTav0cUyo4OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(54906003)(82950400001)(110136005)(71200400001)(82960400001)(55016002)(8676002)(316002)(9686003)(33656002)(2906002)(10290500003)(66446008)(64756008)(66946007)(8936002)(7696005)(186003)(4326008)(478600001)(6506007)(66476007)(8990500004)(86362001)(52536014)(26005)(53546011)(76116006)(5660300002)(66556008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?B1REwOB0lz6SS750sENafFZSiF262kwS0dcA0QU56QXz4CZn1DxMFn0XXaKe?=
 =?us-ascii?Q?c9uD+9u5dVkp5vltz/bHDAb3hwCpNvAMrcUQPz0bFGIcldElfWRzEQ1dtEyq?=
 =?us-ascii?Q?HAahvtN9sbNfeJUtUb9su6Ey02IV4G+El1nfbMsCkTzZPtV5UUrcW73GD297?=
 =?us-ascii?Q?0ogIdcXl7wnMD5IBRV5q+ZMsuyjFSL7weJj8toiSNPh6r5hA3R+76Vrh0x3y?=
 =?us-ascii?Q?iRr3PB1Pjq1XolBy5vB0e11lrtBsi3dJuYqGPtZ4lnlCStrzIovTRlpSNkTz?=
 =?us-ascii?Q?tUEglrw9NOxJseYmpwUEug5VgrjDmXm5J0wUiGlmBMIrl+xx1ep6uTUKuM/G?=
 =?us-ascii?Q?dqfMkpD1IdrxrxhEtmz12+h/zt+BB5pLtTc25QiQAEsJkZOSV2saWZo4IuVO?=
 =?us-ascii?Q?mt7sVfBo77tTwJk608P95ngvoPYRRKkA8I2VjEsPwc48VGXLSCW+mYaz1mKS?=
 =?us-ascii?Q?lFqEkYgiv9beso1fMVDw99pG4gOBWq8X4pHAlDoTNgHUlvjVU65Ai72oYLmk?=
 =?us-ascii?Q?Mhsn6Glu9O1OMu02zxkxdi6IewqHFr6Tj6ocB4R5so6eufU0UH7OcpEKueQ6?=
 =?us-ascii?Q?sn30hzIndum6kdSCQvUyf+3BhjWkJ+M+bTfpEYxocaBTOCPaFs0OOgemZror?=
 =?us-ascii?Q?IpgsN6uI4vE5eCZWX2Z3FINFCzKYiIP61VObd/SFWwvUm+fmk22K+Bb5eZ0n?=
 =?us-ascii?Q?zFb8Q88feWQ12oMlwbLoixzfOiH+v8k0hNr00eL2/HmDEBGbZQemV+/FVrq2?=
 =?us-ascii?Q?sIFM6sAJ+DHBsafOV7/ptJo/HmeZ51is6m39RpkG71Eylbf/YY4wMZwLEabw?=
 =?us-ascii?Q?HZ3WjBQhztfT2ThEpV2xrSjJPxH+kwII5cAM/CvZV7x5c83TGfd0yIgEKF9S?=
 =?us-ascii?Q?S+Vk3MTJM0inS0an7OGwg+/WRVOv71+FdAKoBr0aD1YEsKbxc/jQsAVIZxv0?=
 =?us-ascii?Q?1B1h3uHMxQZllcKz7C3gTtdXaRMDTDk3VgyWPlNx+90robe+Q5gRfih0CDKm?=
 =?us-ascii?Q?WQiGBNLzSOSCut+0TgH36mS96lZ2xHYu+BHV2+giGhzw1LmXa4NjKD3Xkp1g?=
 =?us-ascii?Q?uZUIdy5k?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3212b898-6a55-4f4e-59eb-08d8c2101ab6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 15:36:09.4259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K6TVIHVuOqdW+o7QVkN8rJIDKT5UtlolyO/h8FB6UR3JGuiPHQJ4D8KtGldISw1MVvWYwtfmc53MaaX1kh95sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1347
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Sent: Tuesday, January 26, 2021 6:57 AM
> To: linux-kernel@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Michael Kelley
> <mikelley@microsoft.com>; linux-hyperv@vger.kernel.org; Tianyu Lan
> <Tianyu.Lan@microsoft.com>; Saruhan Karademir
> <skarade@microsoft.com>; Juan Vazquez <juvazq@microsoft.com>; Andrea
> Parri (Microsoft) <parri.andrea@gmail.com>; Jakub Kicinski
> <kuba@kernel.org>; David S. Miller <davem@davemloft.net>;
> netdev@vger.kernel.org
> Subject: [PATCH v2 4/4] hv_netvsc: Restrict configurations on isolated gu=
ests
>=20
> Restrict the NVSP protocol version(s) that will be negotiated with the ho=
st to
> be NVSP_PROTOCOL_VERSION_61 or greater if the guest is running isolated.
> Moreover, do not advertise the SR-IOV capability and ignore
> NVSP_MSG_4_TYPE_SEND_VF_ASSOCIATION messages in isolated guests,
> which are not supposed to support SR-IOV.  This reduces the footprint of =
the
> code that will be exercised by Confidential VMs and hence the exposure to
> bugs and vulnerabilities.
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Thanks.
