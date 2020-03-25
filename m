Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6312B1931FA
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 21:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCYUfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 16:35:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7664 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727275AbgCYUfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 16:35:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PKTHaJ023308;
        Wed, 25 Mar 2020 13:35:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=ShnDBOKSUDv2O1s/0UaZOde6VrYPAfvXcLTG+uqLWQ4=;
 b=w3y5Pz9ekanS6KI83dhqQEiLYiL/WZLxrM7bYJdPSwmSjoOJYGvkGhL+g/76pRtYFQZR
 mK1+khye1VxPX8S3DhKWh4Gn4Hf4ez/RbQ0Ue4jRauSjWa+vhxBhEOCHbnpwfKToE+Fm
 l4YV1+HEFqSXQNeAdfKgGGHthXL4evQjeYdIauBUKpfqr7e5RwSrWLfwD0TcgJRliK75
 MmQ/0gKZXUrgtbfAIaViTcPljdju09vTfYwDzMQSx8Ys7AAEpbJyQuPb71Xo0Hasj2tY
 G1Zrxm8QnY4ENg2J0ewR0CY8vcEEEyhe46vFv43lz88Qr0y638HDL4tL7xu0c++7l5mm Lw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9ntaac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 13:35:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 13:35:17 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 13:35:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 25 Mar 2020 13:35:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OL5r7Bt69eMSe2l+ipRVxpu+GpC2VmuZgSCGQDBEIfChPItwExFDkXJecj0r91UE7SXncU5kx/ErDJopUzDYFMyazsQ+fHfAlLC4lXPGFU543GZWhsLQe9FTAYffTOYjUZ4wyw9BdRMEGG1qp99OqAKs7DN+e4kwAYJRKNW1sEFXD6m/RRC8PIqDXY1VX3VFbJNUNCFHtF3a8/8rzfsUErHcE8zNrlmxRcu6jRx8vVLyDkWV0E6grsmQTbToa7fAilI+YPxZilYw20hTT5KT/mrQz0FoEj3xbq2ySfn3xJvDojwsvjXkpCi/Zrug6THglINqVLbP0kZOpIRtK38zUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShnDBOKSUDv2O1s/0UaZOde6VrYPAfvXcLTG+uqLWQ4=;
 b=KO3WTE58kpcBero7uU39xf9Ts4kjxwLcUkYNo+TW2GQoIhbRXq4YpyIl/vaia972HuN84Gerj+miJNuEa548slnzLv88DZ4O4vIehG+LcRwGRbTUN7iiSTCfq5BIoaYWJvBoVPp1ylJNbCoDY0zEyMHyuJ6DuaTPjoD4S5T/FAXLSnuIEH9C4lkXIXZxmhVUf7aN1Zns+PbY07VyYoqzZ+kboTAKPPLpi4AAoqJX2vd/zb91ux5xxipFJ9zbiQDe+9caso39wpLCkdmIPLvKukqMQp8r0JMx2lP3YVddKNgaGWPoXnUx8uMr3dH8bRyso4YuyS8qDxIcNDDpYAiRog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShnDBOKSUDv2O1s/0UaZOde6VrYPAfvXcLTG+uqLWQ4=;
 b=sJgUrUfSeTl3LihlXSsWRO79vjO2wWCXvavDchCkABxTVjwQf+3gjWp6zbt6cfeqU29Zs06ATB1Hj8WglkueWY2f1stPKMSmHzi14KNuzJ1FTlKdpmpgGU6ERkWs4F9O5kx6UusBRmU9A5YD+dzG9PwNCcc+AH2fP5pk4RdUkNA=
Received: from MN2PR18MB3150.namprd18.prod.outlook.com (2603:10b6:208:161::31)
 by MN2PR18MB3575.namprd18.prod.outlook.com (2603:10b6:208:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18; Wed, 25 Mar
 2020 20:35:15 +0000
Received: from MN2PR18MB3150.namprd18.prod.outlook.com
 ([fe80::f9c8:87ef:981f:879a]) by MN2PR18MB3150.namprd18.prod.outlook.com
 ([fe80::f9c8:87ef:981f:879a%4]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 20:35:15 +0000
From:   Yuval Basson <ybason@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Denis Bolotin <dbolotin@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next 1/3] qed: Replace wq_active Boolean
 with an atomic QED_SLOWPATH_ACTIVE flag
Thread-Topic: [EXT] Re: [PATCH net-next 1/3] qed: Replace wq_active Boolean
 with an atomic QED_SLOWPATH_ACTIVE flag
Thread-Index: AQHWAedBLs0U9Kld0EyeWoVOD/97cKhYZiqAgAFM5nA=
Date:   Wed, 25 Mar 2020 20:35:15 +0000
Message-ID: <MN2PR18MB3150183ACB5D37C3D8537212D0CE0@MN2PR18MB3150.namprd18.prod.outlook.com>
References: <20200324141348.7897-1-ybason@marvell.com>
        <20200324141348.7897-2-ybason@marvell.com>
 <20200324.163605.1988277256387167758.davem@davemloft.net>
In-Reply-To: <20200324.163605.1988277256387167758.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [5.102.239.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cac4c929-67fc-4f7c-861a-08d7d0fc069f
x-ms-traffictypediagnostic: MN2PR18MB3575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3575DAD7D531E626F03BCE72D0CE0@MN2PR18MB3575.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(7696005)(26005)(6506007)(66946007)(2906002)(53546011)(5660300002)(66476007)(52536014)(64756008)(66556008)(76116006)(66446008)(54906003)(86362001)(4744005)(9686003)(6916009)(186003)(81156014)(81166006)(8676002)(316002)(8936002)(33656002)(71200400001)(107886003)(4326008)(55016002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3575;H:MN2PR18MB3150.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r/rXj1qkKntW6kGWKnexzY2BbnulnVQDo+S/jku+cNKfrTr2go9f/7dyFn6KfG/xlaiOTspT3qJoLmxiljVxmaPVNh8tcQ0hXHeEh066bnPSHCPYnqAQ4zN53SVB2QxgnL0p9Dqwf89YSOtJ5tGfGUKjJ5wqktoWQtC+Clq1VbuqoB8HJvrJ9WhRf6H/juVGCoJuE8z7u7YTqR7d/tDEKauFPyg6iYpq3SugHnUxPCFuwNGoMHcB3z83KFvlnVAZ7m/PvgK/CPHCjJp7Y7lFrtXQhg5rGVglkXSBjDbYBoE5c/OeVC3gr354G1+aDmlhUlUDnfKE1S2FGiiDrutNbcgCVSE67abN+dYfg5JYf9QRQ4PZTigQPfq7XRiIkv1UOe7B8XtvhbpFiXJv9Med7Bxu8OG+pf3wR2s4cgKALMPAPjqzeNlm70U8k9RSDtCR
x-ms-exchange-antispam-messagedata: Nc8/qtAWVfwiI0j9+x/ds5COgAZlLTeYdcIjJK794fHeCX7b/1IjWqnDGAnQga5ZMKbjXcINcF63V9+BPtu7WFXBhJN/+Otyo2KZ2W4ZMCSQ6/WPTi+u4ZGQwjaI0ecaUztF9ilWuD5RnuXteBkVTw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cac4c929-67fc-4f7c-861a-08d7d0fc069f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 20:35:15.6349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qHRdGRKdwX+STsP/x0bjow371Yx1Py8StJpAKDhkPBjMYXiopuHC3gJmMQwq5ZfTTK2KN8ciTBQmA20LtW+2TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3575
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_11:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, March 25, 2020 1:36 AM
> To: Yuval Basson <ybason@marvell.com>
> Cc: netdev@vger.kernel.org; Denis Bolotin <dbolotin@marvell.com>
> Subject: [EXT] Re: [PATCH net-next 1/3] qed: Replace wq_active Boolean
> with an atomic QED_SLOWPATH_ACTIVE flag
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> From: Yuval Basson <ybason@marvell.com>
> Date: Tue, 24 Mar 2020 16:13:46 +0200
>=20
> > The atomic opertaion might prevent a potential race condition.
> >
> > Signed-off-by: Yuval Basson <ybason@marvell.com>
> > Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
>=20
> There is no basis in fact behind this change.
> > thanks for the comment, indeed it seems the only patch required to solv=
e the race is the third one
>> Sending a v2 with just the third patch.
> Either explain clearly and precisely what race is fixed by this change or
> remove this change.
>=20
> Thank you.
