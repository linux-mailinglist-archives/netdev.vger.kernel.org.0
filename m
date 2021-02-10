Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5657F31641D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhBJKog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:44:36 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7120 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229892AbhBJKm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:42:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11AAelQQ021359;
        Wed, 10 Feb 2021 02:42:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=UXRKDWGHd8EvQwBW86jmfLEneSqwGMywEEDRXO5XoWc=;
 b=V6JPS2N3DxkDIeKCOc5q0UUX0LzANPHM2jVneC3s+YcHv61Hk0cNyFTlIerGfwNn7Hyb
 jsrMhiWwiRtI1KGwW6HCJi9kXzk4lnfRz/fBEf/Ht7WHXqE6xZBFyMR4fn3og4pnSA8P
 xZy2S0LPTTYTR9Cbii64bFN2UluVoj68CkpbIQFMK/48vdQbTGSJZoDORnWbAHyMwUis
 K3aEphsypKCb7plJvvC9zsKnvHQYW/fGjPC+tDIQKtR/t/xGVYz7PklpQ7xwfbA6jeBt
 K6o5t7AL4b7jXg35eiOPICKFQvfGjvl3oqeHhmMySS529S2WoaEvRuxrkhIPEBvsALGj 0A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqbbnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 02:42:02 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 02:42:01 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 02:42:00 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 10 Feb 2021 02:42:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfBtNWpOEQ0OTAYJrX5zA82LWe/sI79HK9pnuwSCwXKeU2gp9XtvIye8BVAj8PTe4kNzC4C+GbFEJIRsmK2UvkeHy8U7/F7sdH3SExwpjL4YSMR/kQjsf/JiOgHRI6hJxNwrkUdK8k6X7YzFcSoEA5cB8lFIYoBS2WvkIH8EPdLKzFWRpP/fdZXIxBNmqDPfkctwEuDYH/kFtjdPsU2OFd/iDsH/TpGijo2Ha2OQY1NWyCZxNU91l8sNpVU+0OB0ZX48O+wKPT39dAsfedyV9QuJ5bePCq5o9MVxm669VR/srWwHiIzlAZAIEuo6uNdyVgHaAJ61VquVq7KsCOu6dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXRKDWGHd8EvQwBW86jmfLEneSqwGMywEEDRXO5XoWc=;
 b=TTF5RggjIziqtKbARdkSqRlyuH/KzxXKA9cgB7Wx4o7qBVporFhPIJRui7/18ubZsRZi5LR6W/qE2dNFulydHxgCGwixifUvJsw1ippRZdoIKi+MaC3iiEm90sV+MeQliwEMCAiSsk/hTa4s41bK0wNPEE+XXsn9G+fOOGR/g0tCX0+m/fk20EiKRSP8EJZkEOcS1kV6AMxYc4y4WQodjyWPqJrf+ZeG5oCL7Ccx7zkUJCc5/MoWc+VgpIicPy2b9KYK3HDVnhPBGKHReChJgGNmLyOCHhG6oMgoPeclMBoXkT45sUJFJvZArKGb/b2NiSGQzVbgPlWksP/yo0CvGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXRKDWGHd8EvQwBW86jmfLEneSqwGMywEEDRXO5XoWc=;
 b=lzMzP8MbHsXDAfPzPaNaUEcz5rv1qOCtTyZrzHB3dc9AmPDm3W9yVrz31/LAmCkYxxc+bi/xtUkM96ajx5ACpYWTpGKuowvZZsPFdLCoqDRJeOeUea2RmJo5Z+UJ8bQ+76zPKRrDrmzWjWN9G4V+SxAy102qUK45Fsur0h8rmv8=
Received: from BN6PR18MB1587.namprd18.prod.outlook.com (2603:10b6:404:129::18)
 by BN6PR18MB1265.namprd18.prod.outlook.com (2603:10b6:404:e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 10 Feb
 2021 10:41:58 +0000
Received: from BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::addf:6885:7a52:52b0]) by BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::addf:6885:7a52:52b0%8]) with mapi id 15.20.3825.032; Wed, 10 Feb 2021
 10:41:58 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG
 support
Thread-Topic: [EXT] Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG
 support
Thread-Index: AQHW+34dqeNi3qeAj0SumJjdXBCv2KpOsW+AgAAT+ICAARriAIAAPIIAgAAh5tCAACDpgIAApH9A
Date:   Wed, 10 Feb 2021 10:41:58 +0000
Message-ID: <BN6PR18MB15879B93E3B3BC4F1E92103BBA8D9@BN6PR18MB1587.namprd18.prod.outlook.com>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-6-vadym.kochan@plvision.eu>
 <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87v9b249oq.fsf@waldekranz.com>
 <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YCKVAtu2Y8DAInI+@lunn.ch>
 <20210209093500.53b55ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN6PR18MB158781B17E633670912AEED6BA8E9@BN6PR18MB1587.namprd18.prod.outlook.com>
 <87h7ml3oz4.fsf@waldekranz.com>
In-Reply-To: <87h7ml3oz4.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [109.186.191.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf709a9e-f55a-4c45-a670-08d8cdb07df3
x-ms-traffictypediagnostic: BN6PR18MB1265:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BN6PR18MB1265DC28400255049DDE44D2BA8D9@BN6PR18MB1265.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1i4qJx7oTxiMSFZjR8Yc+BtxIck3XF/B6AhuN+2vHrBnSmv0kUYrvEzOh4pyAvMtUwKgO27eeE74mAd6vAWb/934PJ9x68SAMSGsVZhQWJ7n6hSx+euwgPlK+8FeGLxHQ4xRIVe4g/7sh2SWkXTXQQdR6akrjaiJoTeCrRRGd5xXcHNi/o+Uy9UHQM22oLW9+rZs4+Fg1kNjXEO6TpKaQ5miaJANVp40p6DtGeSueJEwgV4M4fFKxlwqGCeR8VXrqUtuG2xKCYXIvAj0aaAqGKdmiabFW8JSU3BdEa6OlXCnoaIK5jlyz02oUNSGyQfJJMRdQ1FP02NLm8GldBF0hBWamz+r9eDc+Na/+J9eMyi6+xcz9ku542G+fa4iHcm7sz7J4C+0GaUtlsHJU5Q/mi1BWYwNxKeX9CyvlY1nT3Pjhw6zB8pN5H1JYERBpu9X4nFIOi5nPqTL0SRiDRRpOsD81MOTeeO641W3BLP6j6rqsaolS4wf7q+pWf+Wm4mA5C01LCU63N+7IAJVsmldKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR18MB1587.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(376002)(366004)(346002)(396003)(54906003)(478600001)(7696005)(4326008)(55016002)(8676002)(316002)(110136005)(9686003)(5660300002)(8936002)(71200400001)(26005)(52536014)(33656002)(86362001)(4744005)(186003)(76116006)(66556008)(64756008)(66446008)(66946007)(66476007)(6506007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eRMTbWnRX1isoMz+DtWHCdmUIVcKVWwhSGFPBlx6XMoXAFiXbcS9+FTKrLog?=
 =?us-ascii?Q?yUNXyCPyMpd04GYfPhoIzC4ohGINhsvI4rnYWgu7atWlNbyu6XkTmEd9jgUJ?=
 =?us-ascii?Q?IQoT6fRwXY8SsBDuKGLOHUhsmw7z7pCDhq11Cd3Rc0zasrK8am+HdWqryuH8?=
 =?us-ascii?Q?l41nipeNKXb9XAOWw1hOwkLwNlWZ1tIA9HNbJ4KJ8sXWPDfUX/a7cYqrCQur?=
 =?us-ascii?Q?bjypjdEid0bvoexrQjovd5GoldJ/L/vzyDyLGNV0C4isZJlOJJpsTlXsvPVQ?=
 =?us-ascii?Q?R7tZ3xOCvapf7uoMmXCVUcnXxkA0oK0lLAi11kuMjAQcHFRMR/i934XQYw60?=
 =?us-ascii?Q?EHLe/KsKMBOTnngreTYsHssHJ4ARxRheaplXmURkEVRiJ4KwuoaYl7TRwHK2?=
 =?us-ascii?Q?y+T0ACi9GhMkFCSXXWRnvIJPOYvGtBGCYr1rTpdJNxHzjgvZ/c6fabrDf/oZ?=
 =?us-ascii?Q?kmcMgQhNzRug/LPSpEdopM0LfBua3u2ZUfbmieOOe6cqpSXIIcjVjHmu1/zk?=
 =?us-ascii?Q?iG3rzuOJDc8dfOAbDsgziOY6VVYWrK/xxmFLUlN5T2qPnulrsk6bYETPOBc8?=
 =?us-ascii?Q?X20uAH6QoFg+aLQprsYmiWhCKRW8MWsaKkIwDSyJvIfFhkSHRM0K+vVJu6Ci?=
 =?us-ascii?Q?R5XgfDmNWBBVgnn9aPA7gq2YK/C1GOSJvpeUjvBE9I8yYA1iRLxGZ1URWiev?=
 =?us-ascii?Q?7d4exJwmLglS5EGxKpjAgvVmI6tnNaxABx1qsMvaMoEm3K9f0VCwFmSHa6TO?=
 =?us-ascii?Q?29M14517sqgVVkd6O+QK/3lM4eunKal30vuSGBXPDGVn0zdlJ4dBEbsgxkL0?=
 =?us-ascii?Q?NtuPzbKOvyS49qsnzpHDYVEPQVATipV+wORgXdOr9FBBfgDNHoUDC0eFnS/f?=
 =?us-ascii?Q?Hpo+JpNzAyaMQVTBYI4Lp8J+jM4v86MoFk/gcg4k8WICPxzqKuzTcx01Ng+z?=
 =?us-ascii?Q?JN3LiFvhX7krjPoeNxcTuuN/6oHtIpSU49bw+9IUTrWeYBy+f8MXoiDGQAm9?=
 =?us-ascii?Q?uaHsiqGfd1yL1fwCLpXxYu05u9g9zu+b+QgmxL39QJswDbE9Cnnln2z+1652?=
 =?us-ascii?Q?3c/NSQFtH06bDo1W3itxqpQVXljruFdhGCsmaDWFS061Eqo47LBUhdPRoyYC?=
 =?us-ascii?Q?gdL/yxN7YQcp2ZVrf2cC3DcY9I3UiYln2HpM1VlbXEdXXOBCWnf1B2DypziG?=
 =?us-ascii?Q?QuUkhU06qQFG14Ij+MGyWyREdl2CpQXfaqwa72tLoSKxLOooR6pu4WxnRLuq?=
 =?us-ascii?Q?jylN1OYE4AdAD8FnkLGu91i6i1hs9BaYc9jRXuFO9dCa2Qy/zGNb2CI6Ufvd?=
 =?us-ascii?Q?/kBlIDRzUyEyOZ34hmQiMFOJ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR18MB1587.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf709a9e-f55a-4c45-a670-08d8cdb07df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 10:41:58.3273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x2++e7Se/AFYlFCYcJ+ToHULpMa6waenMo71yofPJzRSV+sftjTQnWvvJkQ7c9ezN7E8y0OeLaTI+oO24TwsIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1265
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_03:2021-02-10,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Until that day arrives, are there any chances of Marvell opening up CPSS =
in the same way DSDT was re-licensed some years back?
The CPSS code is available to everyone on Marvell Extranet (Requires simple=
 registration process)
Anyway, as the transition process will progress - it will be less required.

> Being able to clone github.com/Marvell-switching/prestera-firmware (or
> whatever) and build the firmware from source would go a long way to allev=
iate my fears at least.
I understand your concerns but at this stage - we also concerned about othe=
rs that might build not reliable FW images.
I also agree that at some point we should ensure most of the concerns are b=
eing addressed.

Mickey.

