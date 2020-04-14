Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A36B1A727B
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 06:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405324AbgDNEVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 00:21:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44100 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405226AbgDNEVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 00:21:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03E4LThG013466;
        Mon, 13 Apr 2020 21:21:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=pbKc8xSrj2NuUbkcO7U3N2zLMArz0itE1EnMKLuyxFo=;
 b=yLxmbdQ486c1nVekuVYymMR2PMrtNWa+DQ+OAuERFp1eGQbirUq33HSkLLCHRAykmzcm
 bg6XYc/NDA5zyst9L73YvdoK0TRcnNEhAdqD2jCe0Sw25Du2Yq+JnToZY7t23GTP2hzB
 mNr3M6jfAM920saLlM+BzYlqHiaJIUEwTH8/neMxho/HK4araAYBVKA30S0c3SOfuYCU
 mj/5yu1/K9QzvMgJ/r5Uf3b5hInRFbNuYdNTvkrrEiqXkEiLcPoi3z3jIs0/QfQlVakW
 BBPNEzjSBhnRN9LZwZw274gZo30GqqoMo/vSs3jDjsq4Ksk39DyZXC9XDQandPYlrTvm HQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30bddkrucy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 21:21:30 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Apr
 2020 21:21:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 13 Apr 2020 21:21:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiKh/h5FyVPe8M04ZCEwhd8K51bhY00yHWd0e+hp3c+N63f73yKe7HAb2Wn+jNbeJ6ZjWmWZVGb0GVhlMFdTWTsXZg8S2m3kaD4yR5+/MNUYp7ZXqtW5LsrkW+9HIIoKNYoqg12D4o0Ms7GRsW7uMYpY7jIZYCqZ6PMnQMpPSu87bO92Vb4k07UpD2vK08HQ9VFtTC2QJ0gWtFY3QHLSLAaCMyll2HmUnvTAXUyRRPzl4hoxLqdUtsNa6s8w3XhDHEeeWpaZKF7pKh1FVZIwnqzEum5wV0485j8hOm2cqXnWJQB6O9KVy8rEbasA0px3eBzJL7wgvgn55pk1Amstiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbKc8xSrj2NuUbkcO7U3N2zLMArz0itE1EnMKLuyxFo=;
 b=n5kdacRw59LngfGM8vycLNJ37ow1Z56XdF4X/ted2vKbhech9HhiV3XRWYgDv4agzWmFLrlEi80tlHyAqQlQSftpJv3E9HLcYD+TyuYOVt91wil6/C4eDdF2EG7Q/GaLX+AKbuc224TDzKz3dFJAiAd3v68wLRdBCF24oHcXdmeh0XCjjX1/l3ao7xZWhuIZeEfIDUNEKy5LCy8xGm/CJpe/bGTPJIKlWs7DauB/bmtEyjOREJ2uTy4VxwP3DD6/ltZ6Jc7nfmjsVGQEJYDbjfAUKyBLldnZ2JrkQ9M5QWXNj7H8lBSgeLjx8/hxgchEDGyWuhJszkHdb8F9vIPb+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbKc8xSrj2NuUbkcO7U3N2zLMArz0itE1EnMKLuyxFo=;
 b=M/Che6j5cmUASHjqjpMb0E/jNvQhqqPL5bpNCeZmnd/aTmBbfKPb8tHL5j/NGJkhSL1z7dcsX/Re2GL4T32co58/7WPOSJMuk7Xg6ERW/zYk2IF9su/E06VCUvsYEyKoJk/2MkD9fQsZ9Ycknab3F1hKHDdGoUIOeg3CMfF0b/c=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (2603:10b6:208:103::10)
 by MN2PR18MB3151.namprd18.prod.outlook.com (2603:10b6:208:16b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.23; Tue, 14 Apr
 2020 04:21:22 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f%5]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 04:21:22 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Javed Hasan <jhasan@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v3 7/7] qedf: Get dev info after updating the
 params.
Thread-Topic: [EXT] Re: [PATCH v3 7/7] qedf: Get dev info after updating the
 params.
Thread-Index: AQHWCbDkZgYCMCx6LUOeJCxcAMl9sKh35Ea7gAAwgHA=
Date:   Tue, 14 Apr 2020 04:21:22 +0000
Message-ID: <MN2PR18MB25273CA10FBD701395C905C6D2DA0@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20200403120957.2431-1-skashyap@marvell.com>
        <20200403120957.2431-8-skashyap@marvell.com> <yq1mu7euaae.fsf@oracle.com>
In-Reply-To: <yq1mu7euaae.fsf@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [45.127.44.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82fb6b04-803d-4426-0ff7-08d7e02b4a37
x-ms-traffictypediagnostic: MN2PR18MB3151:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB31514BFA82BABDF4B211F44FD2DA0@MN2PR18MB3151.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2527.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(33656002)(186003)(76116006)(66476007)(4326008)(9686003)(55016002)(54906003)(478600001)(316002)(81156014)(8676002)(7696005)(2906002)(66556008)(64756008)(5660300002)(66946007)(8936002)(6506007)(66446008)(26005)(52536014)(71200400001)(86362001)(53546011)(4744005)(6916009);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PgNjKjH91XBuAGBEAs7/FwohrpLQhs8FL2zqGU0eF6BhzpRVoP3cjZyWZcXUkQqHkChHFDze+dadAy7WFQ7q7+9UBOWPWvGaq9x6k/UbSv1q24jgALUQ3QPWSlDORAJKNPjwJhS7jnhgkljualtztVK1pfwIrjOkr43qsXiecqSWwu3IvGVHKu5JU8F5oru5RrI5ZS5aCpctTABxxV8Saphfvohhzf/Lras2U95qDngdWEs9tdE9M1A9XxaPLfE59kvd0NDIWtz6AgAjje8WkOFyuJFT5mC5UmUH2Tz7uBTcpI2HE+YfAp78Bpr+G2l6p3rpCh81NrP792uQ7qQ+vCMbr9E1t8rd79ET/jL6gO2kXkVBx4nABDIGzC7XBG8o8+4TcRdGE+wNzlbSh4IWhzHh5vJMTodCNgfOnlmtA/hrq/CaZl84qKJp+9NsPhbm
x-ms-exchange-antispam-messagedata: Vy1CKfQQJhnCUA0mzYCaQuvUZG0AqcGINODASpbGaCwd9Wo5/zXVvpTGeZP1TNsb0dJFWgJmnkZbckiq200t425FN+bKUfWz0uIpIdO9kqexNN2EApXjT8QVAf1l/aeS/WCsrNiSLpeypF1MIK9org==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 82fb6b04-803d-4426-0ff7-08d7e02b4a37
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 04:21:22.8193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NMYpzWjRspkJfVBySJdam3DVH/y81rbueGtSDlK4bHDyOEFZ4oiOoRXFG97PsGd3RT6iZc8fzGML+/C4BK1zOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3151
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-13_11:2020-04-13,2020-04-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,


> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Tuesday, April 14, 2020 6:57 AM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: martin.petersen@oracle.com; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org; Javed Hasan
> <jhasan@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] Re: [PATCH v3 7/7] qedf: Get dev info after updating the
> params.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> Saurav,
>=20
> > - Get the dev info after updating the params.
>=20
> This could also benefit from being elaborated a bit.

<SK> Thanks for the feedback. I will submit the updated patch set.

Thanks,
~Saurav
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
