Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145D32EC273
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbhAFRhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:37:42 -0500
Received: from mail-co1nam11on2094.outbound.protection.outlook.com ([40.107.220.94]:43760
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727169AbhAFRhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 12:37:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJnqgu35npin1sA0lbQZk5I941D4uVJddUW731TCJojg8bVV3Cha8n0FArzfUVhJhEK7y2IxUKYCon/Jtttamtem2TjW52kSTY83mUeZOj5dzYmVVKeC4s+mO7qJ9jgetCJfeVDEBaF73r8wVF4K5TCSjnfKqtPSHN4T3obA6EfmXrUPRLJXgei+Hk3vCbp/p83Xgb0bzFAgYl6fk50P42uPXjyLnOkw20yFRAT1tYFZef0rWX3HX0jgTM9ValQwzkZhzN0g6LqerBuHfF0ah6+EHRXymXKVT2PIH8yR4b4O4pP4KnqT25A2ZCx4PbEJjPJiRP8oGK++krZhPhR+lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90WV2HlV2x9nAiFAGu/vWdcLUjaCBMI6HpMA5ouCjxI=;
 b=Pv14dCFV9JrBktAcA8IFlHwAP34iO/lkoSNoIv/3GkX5UTvIDAzyS5nFUL7R9CPsCnDxKlOHIIb22AI4cPwyE6lqY6Z0kSxQ6Zsy9PfmaNAE0/FFoNsHGEo9JfEDwbPFyZCg7BytKn1kI4nofw+im9Oe5CDs5oFMUwX77e4gyMkNO3aze8+stSPqE4U64J0GmW6KbVczS/QOxNYhNDofP+TcERdl2U3anDXOiDRoG9CY/uou4mO9znFHbtSKMoV8m1xUY7uo9/6hNy0YFiD/xoir15KCSAmREVQekLgcYHS7/JSEyD1aSiVWOXs7T/f0bWg6crNqTpPssjHK0dOROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90WV2HlV2x9nAiFAGu/vWdcLUjaCBMI6HpMA5ouCjxI=;
 b=Nk6c128TJCOEBdfnVNqWGeKrWRPo6AiHeM2P807LPh5vrkLwjHlkOn0D6YOWrdg7JixJLe3ggiZhvaKZRqjx6cesJA/2BwhIigyA1CXFn4oQrUn31OQe1NjWT4aAJCvrcTdLeTnvmbzP4GzCDqahu8Ur2s+qozuSTab72GQ09Bk=
Received: from (2603:10b6:207:30::18) by
 BL0PR2101MB1811.namprd21.prod.outlook.com (2603:10b6:207:1e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.0; Wed, 6 Jan
 2021 17:36:53 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::246e:cb1c:4d14:d0eb]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::246e:cb1c:4d14:d0eb%7]) with mapi id 15.20.3763.002; Wed, 6 Jan 2021
 17:36:53 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@linuxonhyperv.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Long Li <longli@microsoft.com>
Subject: RE: [PATCH 3/3] hv_netvsc: Process NETDEV_GOING_DOWN on VF hot remove
Thread-Topic: [PATCH 3/3] hv_netvsc: Process NETDEV_GOING_DOWN on VF hot
 remove
Thread-Index: AQHW48mU2cZbldNEpEaHaEukasQbvaoa3Wcg
Date:   Wed, 6 Jan 2021 17:36:52 +0000
Message-ID: <BL0PR2101MB093087AD4A200EEAC63A716FCAD09@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <1609895753-30445-1-git-send-email-longli@linuxonhyperv.com>
 <1609895753-30445-3-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1609895753-30445-3-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8da6d1cd-e458-481e-88f7-a8f5036f1d75;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-06T17:36:39Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linuxonhyperv.com; dkim=none (message not signed)
 header.d=none;linuxonhyperv.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 632c9ebf-345a-46b4-a589-08d8b269a7e9
x-ms-traffictypediagnostic: BL0PR2101MB1811:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB181137B308467A1EC5A74D11CAD09@BL0PR2101MB1811.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vGt0hub874tydExBZeI5Lhxosw2o9NhqDx5fzN9fINnXJX10rVRNxfL2zTtvo5H76KWQ2eWq99ZtSZKtxYMkoW0SFUIpyEchSu15M/s2CVAOlxpwDQV/2eBVP/+msx6SEbVeJlTZgt5uNxt8swe08s6d7SyZ/v5rHLoyx3K72L5IBYIcrlTp67miynLBhUV7oLZC72I/I9KJHLFf4sxv7SB83omNeY65PO/jYrXsej38/FKVmH0ulTZweiQ2JesfmY8ctCSRlEdHqQwu7DzCstnNMNtYs+EQ4n4mRk2d8b1Traq8y8EjFytA1F1BYaWk0qUIUZlD3n50VkGebopeO4nVo8mF/Nu1EzJmIr5gI1DkA6V5pouvp5jaClVT2Hse
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(33656002)(26005)(9686003)(83380400001)(8936002)(86362001)(8676002)(2906002)(107886003)(66556008)(5660300002)(8990500004)(55016002)(66476007)(76116006)(110136005)(64756008)(53546011)(4326008)(7696005)(4744005)(186003)(52536014)(82950400001)(6506007)(82960400001)(10290500003)(66946007)(66446008)(71200400001)(316002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gQupwgoyooiBA7DpUQuFe+VOQnt2G2o0a+w5XwZakIm991C6DWEIKm2VVCz+?=
 =?us-ascii?Q?to9uBPH19YFAlf856ALM3Lasfvi/Z27tlq1wYCfhMNvxobEuk91rldqlLY60?=
 =?us-ascii?Q?ZBW3azk7xaiNCjs6qJyUbGlbgKFp7fwrWhvhMUMsIe5PLdJobUA8FicQT+VF?=
 =?us-ascii?Q?GW1LSfPTuvOkrWNEx0WMSoxTCRzOyhXT0mbblhqEWMaluaSiVM8NEgr9te4l?=
 =?us-ascii?Q?/PvXpkLyDqt4CvKowtsMjrgg9MIeOxSEmPKLFGGlm/XHzuISwdUFhg6Bv9vp?=
 =?us-ascii?Q?acJJaGMHVRfyr4NAJoI4b01XKsJRZY7HoGsEq83hvTPS2TmCx52HG0n/3NSL?=
 =?us-ascii?Q?EciXe9RCzTXUM8iPP1NVnHbTKZoPP3W1CcLIE0twYX3IlTYzq9v694xJOweE?=
 =?us-ascii?Q?fvaUJxYR3ecq20kLVRBrhowKHSvGDHBr4Q8GmgSXlqMN9ZN1XloCF2w4qhma?=
 =?us-ascii?Q?y1G8+h1Xxe+4U7HMuHHymfjw0v/iLHSE3LiiWCirCUZxGZM1li2tTouxI9cy?=
 =?us-ascii?Q?Z/jHqCHopOmb51YFvkPwadul+Ttqugo+2jAZjinmUdJzyeAhHIf79ZD9F4We?=
 =?us-ascii?Q?p8G4AQpGk1Zy9TaNSmZN59sx0GKZm8WtN8ni+K55JqCaGao2yx9OLGslE/yO?=
 =?us-ascii?Q?Q0k5ar02EBT643cj8yhSp4YldccE1/JkomTeiHU/yF9qzoX1mVTkvDQjOzxz?=
 =?us-ascii?Q?xSiDEKt8OaIXAumAhWQsEAko6f/ZIumBrjSCuVlK9CbNR/L+2FWDz2uoHjBO?=
 =?us-ascii?Q?/oizHfL/U8IwKYCRwQj1vTpP2S+QlAcQRVuwfBYGBWTMxd6Q+n4GDuskGL20?=
 =?us-ascii?Q?k+VX2AL6GyNNwvBCnTotMiYhUFdSnK7eQvrEqLHoNib74DlKV3Up5OHSa6Fl?=
 =?us-ascii?Q?+lagOleJQKi2lvkr85b6ndt24FNyxribQ5H6LXXlOP09iv9MYzuHWUQi/+ef?=
 =?us-ascii?Q?WZNN8ii0GoUs8m2Ibj7GJqRb1sogs1dcHb96vUPn4N0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 632c9ebf-345a-46b4-a589-08d8b269a7e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2021 17:36:52.9993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q2JjWFSDaKOoGk8qH3LSQqemtmmJ5Hv/5C2ceMNDob6cFGyibxfbxVr2H70Yc6YN7pQYl8tur72H1c9Ot7skRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1811
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Long Li <longli@linuxonhyperv.com>
> Sent: Tuesday, January 5, 2021 8:16 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [PATCH 3/3] hv_netvsc: Process NETDEV_GOING_DOWN on VF hot
> remove
>=20
> From: Long Li <longli@microsoft.com>
>=20
> On VF hot remove, NETDEV_GOING_DOWN is sent to notify the VF is about
> to go down. At this time, the VF is still sending/receiving traffic and w=
e
> request the VSP to switch datapath.
>=20
> On completion, the datapath is switched to synthetic and we can proceed
> with VF hot remove.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
