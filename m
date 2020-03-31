Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37A198AFF
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 06:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgCaEMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 00:12:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3964 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725809AbgCaEMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 00:12:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02V4C57L009813;
        Mon, 30 Mar 2020 21:12:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=ItjujfmcJOYtI394FMK1EyUcOLAKQWUY13hrMsm8ezU=;
 b=VyKORPRgEYeY4R5e0ec1rafusishMKrCcIfDN1VwByNnpXjx822QoPjEI4d4lFlx0q8a
 ODpEPSi+WRxfTzqs9AwLprk40n2kpoYvYz+THGiJ/zoCY88HM2ytbJrPir/DWQfwWp4N
 LU/BdnesLZ5vnWPR4Jn7ckp92ejLTqHKB9BallckCFV3FbuKavX2OD3IH5VFQXkPOOKY
 WhJXuPkSs6t5vHTKlFsLI//tfUMAEfZ/8nNMnR5WvSDs4mvudD/lHOsxzxQmIc4Ut9G2
 je8fzWmf81NuWuC6xnxEPJ9+h6RrzMruI6mBM1ZqP4KT7Ixp0396fyg4HvnLW0TWrISU EA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3023xp1cap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 21:12:05 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Mar
 2020 21:12:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 30 Mar 2020 21:12:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4GLE1y7LXagwBKqDDKveiW5eXx0TbzHGp2A1ZyNJh1FaJZcl/kXGOuLm7q+Jst/p1xxG8dC2VOgU8E1aCwMsqGjeXIB0YX9Bq9VvubqGLMH6W+n7ORM+d7zDWUkM7UsOIsI2AnGZ6PzQFxgUdN3IdFXzAm4ehzndrlDqNQBxlaK1Hj/qfv9s7YbdxM+b6eXnzu36ICebunkQfKuRuM+tXbBdhiFGa+2EaVQrOppkGbKG+6r8paGa5+koNeLu3ciMTT45F0BpowEoQJQcjasPFMW86XwrGSBo5EzHWKD0V/dM+4jmAZlhKjvJSaaa2XOzz3x6W3KhSDK2TvSCFriKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItjujfmcJOYtI394FMK1EyUcOLAKQWUY13hrMsm8ezU=;
 b=agJWlMZq+ne12lo9xwV6KHTeoVpISIIye4cI3RmaqKILi+2LeLGe0UHfCSS2QxbqLR4d4ce0XctV+KAMRKtmSfShRscwvSBJJBAKVeXzreF8ZEFYqFf80yrtpl+YcCYHpaFlkhwYhEMknfcS+q2KTzXBCPsIDP1J47aIoRrDLZxXhljs40AxJy9zcmRXbVIPxIZ+Bt6sIgP/LloQ8iweE8vivA70sSKEp8ZToMh3+lZs3+Ngf8WrzMCN+Bsm6AQhSqji1fTFO5pNfaAoRH5+hhi7CEt64h6vEebShzWe13nfqIJsVS3BX+G2OoNqbyuZ8Oi4Xz+Dc6d/UDeD+7VAxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItjujfmcJOYtI394FMK1EyUcOLAKQWUY13hrMsm8ezU=;
 b=KXWnfK1POAbmWn1IRHJLzVm8a8fSTq+miwWfYBnK0rh41ErAsoLajTjYZtUQqCTmbp1pwl8Py09jtgPcnTf6REuNm5ShfjiBE9YhrdCwjvMgSwZCf/xiPMMUQaG+3KCPe7Ls/WgPXsiYkNVS2dYdN9soZAp2KlNeAeMxIyOYmX8=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (2603:10b6:208:103::10)
 by MN2PR18MB3230.namprd18.prod.outlook.com (2603:10b6:208:15a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 04:12:00 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f%5]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 04:12:00 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Javed Hasan <jhasan@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 0/8] qed/qedf: Firmware recovery, bw update
 and misc fixes.
Thread-Topic: [EXT] Re: [PATCH v2 0/8] qed/qedf: Firmware recovery, bw update
 and misc fixes.
Thread-Index: AQHWBly7iBKGh4xMPEqEG3AaTWjYKqhhX+4AgAC3sYA=
Date:   Tue, 31 Mar 2020 04:12:00 +0000
Message-ID: <MN2PR18MB25272DAB6C57C9AA9A6AB856D2C80@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20200330063034.27309-1-skashyap@marvell.com>
 <20200330.101202.660829992934953878.davem@davemloft.net>
In-Reply-To: <20200330.101202.660829992934953878.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0f068b6-dead-46dd-d013-08d7d529a902
x-ms-traffictypediagnostic: MN2PR18MB3230:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB32302B826AF40D7CCF7C9E64D2C80@MN2PR18MB3230.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0359162B6D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2527.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(81166006)(81156014)(8676002)(76116006)(66946007)(2906002)(15650500001)(316002)(4326008)(52536014)(33656002)(6916009)(8936002)(478600001)(186003)(54906003)(9686003)(71200400001)(66446008)(86362001)(6506007)(7696005)(55016002)(66476007)(64756008)(66556008)(5660300002)(26005)(53546011);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xliOC4KynZBpZe/X7aDmn9oRWV+v5aNaumvJ/KbaDc6ixJf9QUpyZ6hVJSmV3V/ybUkDpI2f4iHWRj6m0aDaAENnppyBIfA1DodPFAW+KveCyFTms/HJdd2/CjQFCJvmuqc/MOtFO65kYY+A1A+0C7c4BIwp1Ud+XpP2D3q60SDbTDxUukOcMUFnofjN5qN0TE5dR095yg1R0wSOtKZYk6BX4R5GJ5p6wB0A+oqpbiU5Ngtnf2DiRsylZkRYFkqcBfYsTUZ9jgts6FCqL3lv3b8LVWYtX63WpAxTFGph3XivhU3VqwEJ9lKQGB1zpkiD7c/iZk6O2XB/QwpazQYCRJRRS6/BOBT8M1sw2VmJrY/lzJotClzfCMZih4OC4VoVZY7UB0i536mpe/5KET6yeiwAlixYd0QoDC58DvQR9+JahJ6CkRAzMqqLggtNHfux
x-ms-exchange-antispam-messagedata: pezXp1VdbuHoZE5WMPwroWI+poZixgih13HUEBtVRlS4sP5grZ7z66LSyCZ0kLIHwP73cXSiRnCW935l+PBTmBE1CKw8e7oOrW/PwhEiPr+qG0+eOV8+2z3WN+ZYs8p9F/PrjS9vftpocah1F/t3ew==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f068b6-dead-46dd-d013-08d7d529a902
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2020 04:12:00.0774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: daiKub53B1k2GD5KUVoXAlEGgn/GRZE+P84gSoQdCCvgD1t2r3+5Kqkg7SH1WXwmC/CGkntxU35N+KdNE2wciQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3230
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_01:2020-03-30,2020-03-31 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Monday, March 30, 2020 10:42 PM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: martin.petersen@oracle.com; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org; Javed Hasan
> <jhasan@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] Re: [PATCH v2 0/8] qed/qedf: Firmware recovery, bw update
> and misc fixes.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> You add the new qed_bw_update() function but nothing invokes it.
>=20
> Remove this from the patch series until you are submitting changes
> that actually use the function.

qedf driver does use this call, I have submitted following patches. The pat=
ch "Implement callback for bw_update" uses functionality
exposed by qed. Its patch number 4 in the series.

Saurav Kashyap (4):
  qedf: Keep track of num of pending flogi.
  qedf: Implement callback for bw_update.
  qedf: Get dev info after updating the params.
  qedf: Update the driver version to 8.42.3.5.

Sudarsana Reddy Kalluru (1):
  qed: Send BW update notifications to the protocol drivers.

Thanks,
~Saurav
