Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1D92C0FB4
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389645AbgKWQDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:03:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23638 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732604AbgKWQDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 11:03:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANG0ftj012726;
        Mon, 23 Nov 2020 08:03:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=SPZfzEq3OysljiyV4l1MX7yvCxrwLSoiHmHpsp27T/Q=;
 b=GrQrsgtiJQqb5aVI3u1j5lqyR01gwPwfDZFdYHtRAVhNuxXMpDtimgQZFNQX1atkqo0s
 vQwlq3o6ETp0VbOsMXtDdUzKuqtjKxTNq+YeFxukkYUHmTNdKb8xJTFQsK67qhzz+oxu
 Ty5K+ddI+Zvhq2ZCWlw+NJbrknE5xvyDeQvPUIPmco8ZXv1vEZ82ZOSoObmd1G3gS/gq
 jq3MQAHpzHu+V3M6KSZNRf2XSIPVmVoGwslKczvgYOuqFG80z9yZfYOQwFyRz+2JoV3w
 P3PulbjyGP8d5hFSZfOYJMSHm9kZsS2jxNf6bUUsZbpScJgQt+nLRjRclUQjsILdn1jv vw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r5xer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 08:03:03 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 08:03:02 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 08:03:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2TFpjMS7572FGAFzIjpCHJU9O5SQfxf4FcwwwWFG2VzkgH55w+p/G3vwIEnplMg7/CqIbPJnvW9KPM9TOwjiYuaC+uZff/amuMWDCVrOnEAsrwIRkj0CEUmBHvcjSefwzC5QJNSaqZohfDJbEUuDRoH8tI/8cEtZIQk3wknSZ/VROK5LDAzbimRsf92k95HAl4p92Kxw4//Okvvd3kOfYFoZ6i83+vJlUaa43opfqlbZ6iSEDcatYvW8dpNcQo97boI5xNYZ7Yg8dxrbg5r5pV1QaIG0LWLe5GWxmzzmXfTdusGwwiJJ8eqMJJmuwr8D7bpsHP4N5im2sMxxLd8Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPZfzEq3OysljiyV4l1MX7yvCxrwLSoiHmHpsp27T/Q=;
 b=akppuHO+OPzMsQo8HyfjTYssu4Q/yv1scWHxVuYPwdBEWEp0HTYg6fk7939n9LTQskYL3yX8K1zC5+6tl6+lmldlonLsoYdscANh1s0Rk3DhWpRzpjChBjNwDCCyzcm6klC2pM+TKiaQT+6jLfFX4M2NrxDO0cy70ck6SUMXqLaAoFYbbhajc6lLYbiYkvlTk8lHuHT/UosCrGuEQRSBqh9U74cydTIJ0Dnducuwu2R3C0Jy4jy3R3dJvwc42oHZz8FuwkVmjQFv1PMNUzfuT8wZIyNSAd0g8e0KB3kcfoSjYSrqEwPunv0FNkmGdpuOPLb5acXE5S752CeJvEoCTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPZfzEq3OysljiyV4l1MX7yvCxrwLSoiHmHpsp27T/Q=;
 b=NxmFR32EMOj3GhKCYbg3B789oVC2siVe36OR4URSatyP2L6LRB4hjpY7jOwxZc4pPri9AhpXBg7CUuNNV4+PkdB6FF8bfuAOF/61qnEhHR1bRth1XBKRSAJDZOZkagNMyCuiPQtI2nmcYdYrRD8OXfVfiQyv9L6eCeKBOSZcIa4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW2PR18MB2122.namprd18.prod.outlook.com (2603:10b6:907:9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Mon, 23 Nov
 2020 16:03:00 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%6]) with mapi id 15.20.3589.022; Mon, 23 Nov 2020
 16:03:00 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active ports
 only
Thread-Topic: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active
 ports only
Thread-Index: AQHWwahlp9Sv9guVI0awfVNHHhZxM6nV0laAgAAAoWCAAAW3AIAAALaggAAEZQCAAAETwA==
Date:   Mon, 23 Nov 2020 16:03:00 +0000
Message-ID: <CO6PR18MB3873FC445787E395CCB710E4B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1606143160-25589-1-git-send-email-stefanc@marvell.com>
 <20201123151049.GV1551@shell.armlinux.org.uk>
 <CO6PR18MB3873522226E3F9A608371289B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20201123153332.GW1551@shell.armlinux.org.uk>
 <CO6PR18MB3873B4205ECAF2383F9539CCB0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20201123155148.GX1551@shell.armlinux.org.uk>
In-Reply-To: <20201123155148.GX1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.66.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1dfb34f-2293-46f0-0f43-08d88fc94081
x-ms-traffictypediagnostic: MW2PR18MB2122:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB2122328B7992BF5E0978C6B3B0FC0@MW2PR18MB2122.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: afoZ1pjpnWTf6dxTfLVg2D/+yyZD7eaxT+Epu0nkwvlvi4ksr1VrQ6F5aId2k+Jne/qFKa8XYA1pWkwX6LK1Kwa7F2z94NQw/Jq+EJBwh6gzx01+KZaccZmy0N+ppCUR1Z8r41q7lvZ+hxIQqug20wXQPggpwj9yEsAL3DhexeBtpszh0VDUiRZgi32cJKvQYWibT6GTTmIX0em7K9W3JG7eShsjDLsmws9dq1Nng5vPG3dGMNUbh/rIeh59GA+0fBZma7OJ3hxweU/VvsG48IUNZi66S6HZbFzx1XH5RHv/LL8Mt+EI/NwTpFfWj0xefgFNsvW+9GH68u47E3ei/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(186003)(2906002)(53546011)(33656002)(66946007)(6916009)(8676002)(6506007)(55016002)(76116006)(9686003)(66446008)(71200400001)(5660300002)(8936002)(4326008)(66476007)(478600001)(83380400001)(52536014)(86362001)(64756008)(54906003)(7696005)(66556008)(316002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vOq2eFBc6DqQ2QafeGSOn+lSIjCFVjMRhTCOhOXiofZsXQBILKII4fzP8+h7?=
 =?us-ascii?Q?ZLnkNI9xx7UxhPOO+nbtU+7+pQNq/V4Qd+1JHW0WcB3P+6wdX/CFl7B7YdMm?=
 =?us-ascii?Q?XZOzLRgc01AK2rh9MXzqwUinvXZemMhu1Rnq0KKgkx0n7i9Hn0DPzKH3eq2X?=
 =?us-ascii?Q?vDdp9+H10nuqPOJRKNbQNWnHyyYiNrl4ZkUcu/4d8V+ZtmPDVs0kOgQ7H97e?=
 =?us-ascii?Q?btJDocw8DS2R8Hcbvkb9graHs6EvS9PZcNbjShcwA2RGv6K9CB0I2OeJzWOX?=
 =?us-ascii?Q?3j6ZDLR4/Xv2BIALjhOU6Q3dAcdE/MnsNmasH5uldbixvu6qg2HYpliVn9nr?=
 =?us-ascii?Q?ou0sMC1D2UvOOGPbrJZDf8iNK9sF2te50Jhfz7I5t4p4wa+UlErV5RgMgcg8?=
 =?us-ascii?Q?3u9zca/+3mCUQa4jdmRJPE6hOBxiPaFkbQ9QMRbHMeCxn4OyVRoDmPndGH38?=
 =?us-ascii?Q?I08DzsWuHaY4pQ7Dzfo7lGFxG9RSdLxPKYlqkEZ2pV31GtwQVPuAEKpLWTeW?=
 =?us-ascii?Q?62612Cj7ZOD4v0fUIrdllL2htFliwPuMZf5JA6pfLk4VlvWls9k0ft+TTKw8?=
 =?us-ascii?Q?E9a2QvRVoFKx7i1D4AXOQFORKrgqrYfb6dFK/+MGwLsSPGmNjlLT92cm892E?=
 =?us-ascii?Q?mvNDPCcbb/ClxLhxxuHsejz54N4HVcGunAKpMqAb7faWOnkPLWEDZzQ9l2wQ?=
 =?us-ascii?Q?4zpQHXTdAg695iCT11Ypb0LwgLj9N1AvKVF9C8KVZzd6LCQyA+VN2gGXRkEb?=
 =?us-ascii?Q?uyEiTLQ8SPRvMRsclrmdOLdaF0QVFAoF4AxcK54G8nO73C/PJi9dlMpcXFBp?=
 =?us-ascii?Q?vk1WPZco4dx+c9eIdCD5ta5KA+YZb+HnMtNh+ndlu/3/0SmKRvUd9b8DzhTe?=
 =?us-ascii?Q?9RMlQJ25UaPsptVmgeYXYc8+ZGI8DvhAReZybxL2J+T3LzRk1ug7CdPyuwbp?=
 =?us-ascii?Q?XHXizLovpeYoQ5mnTawEsINKkx28ETdJ2WrptzPydqY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1dfb34f-2293-46f0-0f43-08d88fc94081
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 16:03:00.5327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: myWpnYXm+1d4p7Ly56XkAqDiHXgcMkFhRc9fEQEvalX7mvS0ULvyOmWXOsQJRPKcrJtdEYbxx6gFNCtQkplFXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2122
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_14:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Monday, November 23, 2020 5:52 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan Markman
> <ymarkman@marvell.com>; linux-kernel@vger.kernel.org; kuba@kernel.org;
> mw@semihalf.com; andrew@lunn.ch
> Subject: Re: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active =
ports
> only
>=20
> On Mon, Nov 23, 2020 at 03:44:05PM +0000, Stefan Chulski wrote:
> > Yes, but this allocation exists also in current code.
> > From HW point of view(MAC and PPv2) maximum supported speed in CP110:
> > port 0 - 10G, port 1 - 2.5G, port 2 - 2.5G.
> > in CP115: port 0 - 10G, port 1 - 5G, port 2 - 2.5G.
> >
> > So this allocation looks correct at least for CP115.
> > Problem that we cannot reallocate FIFO during runtime, after specific s=
peed
> negotiation.
>=20
> We could do much better. DT has a "max-speed" property for ethernet
> controllers. If we have that property, then I think we should use that to
> determine the initialisation time FIFO allocation.
>=20
> As I say, on Macchiatobin, the allocations we end up with are just crazy =
when
> you consider the port speeds that the hardware supports.
> Maybe that should be done as a follow-on patch - but I think it needs to =
be
> done.

I agree with you. We can use "max-speed" for better FIFO allocations.
I plan to upstream more fixes from the "Marvell" devel branch then I can pr=
epare this patch.
So you OK with this patch and then follow-on improvement?

Regards.




