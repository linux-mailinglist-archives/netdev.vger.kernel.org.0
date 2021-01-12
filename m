Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796C82F3D6E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407081AbhALVio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:44 -0500
Received: from mail-co1nam11on2122.outbound.protection.outlook.com ([40.107.220.122]:10465
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437163AbhALVcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 16:32:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hS6mX+hs4kmO7jD+xxg8ZcAmpkjOY2ko2FtNAYN8nh/zvsC1bCERld83E1QWOW0zk29U2UMjmX6C+c/V/GPbwFjjYqj2EtkJweVK68bd0tOLZlFZdIuB9cesRtcnz9mQoWGUTPgrwyxSzkVE8uyxL5VfB2286rSMpd+GQDMnPWEHKKPLIjIH4u0Ss3zl+ox60G1UCQ1p3+AMQr96Bxi1r15R9l5z38UufPLCj41iWmVTc43GbatLZEeiFyUw1ggebpOQY4WzeX1KUWLrbsEJS+mNoMTQEI20sn8OJfawvSenFXVk34JM/15X3BWeGBywXgmmVoSSE76b0mcRhG87uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgiLmQNubKy3UGAMcpiKWYR3bFNX6vLv6gh16piSk5M=;
 b=iKMHTrchhVaY3+kKZlqC71+yRG8UTm25JTnvrVOWZ8vdHLJLyV6MoZIZfizLpev9Q7cyzRWpnI2HdYJfc4dFYX7TEJhYkYDWaMDpsFEojYHep3dvw3IkG4bK3HEOy0ewTDWETPobyJ1/mEFc+Xw5qXfOrT/P9qM3C9qYJeiw+JBXi5tL+zhuwNZ7uaN61aoCh0lGakHTCr3Zny/Ybl9DWRP0Il+Z4TDIMhNUHEQW+LRJBMWtZJROEz65LJtu/WrmHpzjuFNFYDlwJvWz0vR1ptictQHqao0ZOAEpbUT+UQAQebHa50REutta3ZXby/Tqp8KnAq1ARZhDUqof8/tkPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgiLmQNubKy3UGAMcpiKWYR3bFNX6vLv6gh16piSk5M=;
 b=bn41mXrqsbBN3asz+p+utk1pZ9EHH3qnHVw8QFtGxjbykDDCkSKhjXRsJ6G5Z51qi2BKVpEEBuK4sF0Cd6ihsKWkDyBMGEzW+z3n3kSUv/4sMwu2F6tpvPx8sWMTSs+FE5EKslDfi6o4K3XSR/zZSrI1Dvs/KyJ8FOvqG8JfigY=
Received: from (2603:10b6:208:fe::31) by
 BL0PR2101MB1794.namprd21.prod.outlook.com (2603:10b6:207:1a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.4; Tue, 12 Jan
 2021 21:31:24 +0000
Received: from MN2PR21MB1166.namprd21.prod.outlook.com
 ([fe80::64ae:b13b:a0a3:5bd1]) by MN2PR21MB1166.namprd21.prod.outlook.com
 ([fe80::64ae:b13b:a0a3:5bd1%3]) with mapi id 15.20.3784.004; Tue, 12 Jan 2021
 21:31:24 +0000
From:   Long Li <longli@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Long Li <longli@linuxonhyperv.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/3] hv_netvsc: Prevent packet loss during VF
 add/remove
Thread-Topic: [PATCH v2 0/3] hv_netvsc: Prevent packet loss during VF
 add/remove
Thread-Index: AQHW5iHnNrYxEgDKNki14pVRntGh26ojQwmAgAFElHA=
Date:   Tue, 12 Jan 2021 21:31:23 +0000
Message-ID: <MN2PR21MB11666A2B3D026DA710E470ADCEAA9@MN2PR21MB1166.namprd21.prod.outlook.com>
References: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
 <20210111180717.19126810@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111180717.19126810@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=02531aca-3510-445d-bf07-b389d7e1a10d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-12T21:28:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [67.168.111.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 51462a90-1b3b-4c49-e863-08d8b7416970
x-ms-traffictypediagnostic: BL0PR2101MB1794:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB1794F539C3044F869C53CB2CCEAA9@BL0PR2101MB1794.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GTWj3K9wgrvrw9DaoGGcT9mWVhFDq7MLB44ghWakC92Gy3Din154+u5VbXGSN9hVE39FfDnce3Y8OawdnIFZmb3ZcFvW115y2awQzVu+eDb/uPnkQoLmHyU2nMUx3QM2Csmz37yqjOCxzZWlzTnDeSJaDZPAXl6EtWmnEKxZxPKCjmkvysCeFo21SA16MJvEmr17Rbhtg+td5gTfA7Rn76puj5g0k7Zateb+Fpjh45xpd0MNW6sIqsdsRK+YWc5Gz0CXP7mDyPDhRpYO8i8fKqic35NoEwfiB92XFjX8mL14N62iwoAzUuBPBVxsatqaQ294f5MCwRDXYobJOmZKFI6Gm6+cKxfMeO7hJT3KEnkQpoCmvewiqNtJYXumGmxaDGCN1mNHsFFiNQQ55MfnWxHWmJ8qfpLJZrkbdpNaH98t1R0esG5yAAVQtFMflYGYyx72YcOZLFFNPVUMaW2e201qmWvedwY5W5TbyLxPsSypnTA9In+QFoywz1W8fM6ZajVjF8PJpHnD4uFRxceCYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1166.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(4744005)(5660300002)(54906003)(6506007)(2906002)(8676002)(9686003)(8936002)(86362001)(4326008)(316002)(33656002)(26005)(110136005)(64756008)(66556008)(66946007)(7696005)(66446008)(66476007)(76116006)(55016002)(478600001)(52536014)(186003)(10290500003)(71200400001)(82960400001)(8990500004)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gIoJ1Q7+Ihrf8NeWvE4KxBSv6WUU1vS+yqpjYQVMterdfj4eoEkl6BieIC+M?=
 =?us-ascii?Q?CDe9sp7XKAE4jsa4e6ANKpBriSjCKlnHwvGxQifLcF1ABWyQ7q1hxuEIkWhd?=
 =?us-ascii?Q?P2JabY9ZggH/dihylLwUeUPPqxd4z9mbnb1P9bP/gyA9R/AlZysx1nwwxkjb?=
 =?us-ascii?Q?kltFywqwEntaoDBPMugZ4wChO+5DIkjEdGkiVrVsnnY2WObdBXZQLmIC31MH?=
 =?us-ascii?Q?fn26+YAArndmlgAq2OKkLWJ0iNqg+0jQkBViv1llvR2TYiR8mgEx+dDOTbb+?=
 =?us-ascii?Q?5YJ7ZtFr5OmI2tvEtB3i/N4aYvu7C/XWaQzLjW+e8FKiK1Y/LXG9wgytJ5+P?=
 =?us-ascii?Q?T0UzeR1Zdkz74z57Hw/HSF54G0rUMRxPJf6i+B+oxiR7goHnsk8CX9dDq0g3?=
 =?us-ascii?Q?Y3PpL4w3ECtLbPe6x3zs0evQdp1RkTRNt9ur0LUHQdKXDzWpoOvPrQGDEiRu?=
 =?us-ascii?Q?yGI8Dzx+Zcx/dtsXMjP/KgjUQjpT3zrqq5M56XNdeqISNqgi0lKXP7rWV7SO?=
 =?us-ascii?Q?nvQAq5m6jpTIFfakPwM7Q9G1lJmx8fXrnmrNMBauOHojPrXTs0DpwAWOCx2z?=
 =?us-ascii?Q?QE6qoyAwFBqTznbg4yGofhbf7vT0umG9UG4tFBqZmluLklB8VXwKbLf2JI0U?=
 =?us-ascii?Q?K9jLcqGLKkItNx3seeMH4VGnxIEDaGuD4GmIJAq6mx/SUsdJAuN7pUV7m7e+?=
 =?us-ascii?Q?Vt44LtrwBlYs6BDoYBD6fwbk6KRFEF4EfBNgEm8We+hPPhpANMMnJWHH8Z8r?=
 =?us-ascii?Q?E0t/8VvDRsnW7QGWnrg+CgiPmgiQxc++JMYTRoQMo+5JTtrHO/lFP6ynaKZ3?=
 =?us-ascii?Q?D7HKUQ9vjMNB+XPv5QqC4unkBbWH4//6FewzrTa9zcOUd0XygOC70i5tawB8?=
 =?us-ascii?Q?u75TmMhlxIvbeHe//obqXTmF6guNz1tRpjMouew8r2BIJw9axuDJHrewktXz?=
 =?us-ascii?Q?0n56byokrAfEwe5snlJ7+5F0s9Np4h0B3OMZvR5Mr00=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1166.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51462a90-1b3b-4c49-e863-08d8b7416970
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 21:31:24.1410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n6QuFLLqNv7MXxLLoIL3PJRAXc+LlZUF4ZQ5ulyAKow2sFKsX9R6RVwyqJYL9e/vpFrwewjFUdeeS+YgNjhq7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1794
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v2 0/3] hv_netvsc: Prevent packet loss during VF
> add/remove
>=20
> On Fri,  8 Jan 2021 16:53:40 -0800 Long Li wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > This patch set fixes issues with packet loss on VF add/remove.
>=20
> These patches are for net-next? They just optimize the amount of packet
> loss on switch, not fix bugs, right?

Yes, those patches are for net-next.

They eliminate the packet loss introduced from Linux side during VF changes=
. They can be seen as optimizations.
