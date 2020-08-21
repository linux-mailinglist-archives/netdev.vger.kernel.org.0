Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8434A24D46D
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 13:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgHULse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 07:48:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17686 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgHULpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 07:45:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LBaPU9032116;
        Fri, 21 Aug 2020 04:45:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=gErZgpB/sXWDGveVOoPFlbG5fbthNA4e+IIfVU8dAkY=;
 b=QXYwH/41X8TPGqgY36/R+UQG3Ub2ed6AO1IKZdhCNVPjDzUlFyXImRTSwcuvds+PFslx
 ol/2X0bBZEbLsjMEKnX0KgbCWhj+oh9e7OqOP/f6/JgzzLTHM6Nmh+fYgQ5k5+L/K7ME
 hW0rcYgqSybR7aa0KCK6jh7WXRck5wf+XO1RQoJAWYn7GZZru+XV8u7/3eUIZ7ihTMF5
 7TLmiwsqCUDzMTGysvouTsXa54xZ3+1Q/sZtcFFMcYyOFTeBwelTWYBDdHze6aBe1oqT
 yUKJdNs8/Q310B9Isti2jwFYlqarizEKs4vBeHNcgZfcahlYrRHSWl63yl/iAC8bY2V1 aA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fj2dgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 04:45:32 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 Aug
 2020 04:45:31 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 Aug
 2020 04:45:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 21 Aug 2020 04:45:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKu7fGYDl0CziB/HlShDq5WbfkvB19irSsvv42zEsrVcs49TAnTWVBlquQI8WxLu0+0oxVEHhyX8WMDPfToY79a+O/ndAtRmmXRi1aIIaApKpKFNa9Cjow32uyEzVmB2kc2XlhCOJuKU1zOV95gizBldEFTzmhQA7CRVTiWexWiyTo2dUiMk1xlQTuKjzpGTbS0S/CBeBQ5NJoFnnzm5xhA5F0SQwv1Q+KZwmcSoEcFTKrZ9lmcdXAaQnNsA76a6So6B+rmW31kWI0O2fL7x9mZpFqPxGd8gZC5wadsrdXFoKlIIJNNg6PKa7Sq4DN+kbUoCDMqXP+HBt4n8hg7hoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gErZgpB/sXWDGveVOoPFlbG5fbthNA4e+IIfVU8dAkY=;
 b=CuTz4mmBwBX+zuTn1qgzZMxKjsrjL16dn1nONs0qJxOkf4zIuS4zqb0hm5asU+nY1Dq/vBB01hLoIFt2IpzOfGr5PZHqcDZ+Mtlr52hHv+OAGsIjDhIdRRedc2ZbsIC5OMbqZ/Z/M3GtwDbcJP/VR73YVviuni3OhXn9n/L6FI0b1KFcBGqnK+/fSa+l+AdKnCH/CW12Eln9zN38fG9BnSSVUkcshcEgilbIfyw6XC4V1VHYpondxjimPh5jFy8A9vWPnOyrcNH+T2DiJSyWxuUsBHt5H0g2rUx/Uu8G4GvKSrclV9CGTiMaoYSy093p+tFiMEBKdIrkDjWgJFkmYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gErZgpB/sXWDGveVOoPFlbG5fbthNA4e+IIfVU8dAkY=;
 b=eXfuykadgxm+wrIwb7wVAgGM8mx671AZjRJD9OBam3oo9dOOttc5E54HG0qrTNsQIeTlXQm0IojdLqVA1GpP9wqSVmTQ9929Qmfo5HGbMeV+mucYSD5e5RZNMb58o5Upq2lIiCu3ayLivPxV2yEXiCSgSg0KBxndLozRy9N1DPA=
Received: from DM6PR18MB3066.namprd18.prod.outlook.com (2603:10b6:5:166::32)
 by DM6PR18MB3473.namprd18.prod.outlook.com (2603:10b6:5:2a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Fri, 21 Aug
 2020 11:45:28 +0000
Received: from DM6PR18MB3066.namprd18.prod.outlook.com
 ([fe80::a939:e4c1:c01a:1542]) by DM6PR18MB3066.namprd18.prod.outlook.com
 ([fe80::a939:e4c1:c01a:1542%4]) with mapi id 15.20.3305.025; Fri, 21 Aug 2020
 11:45:28 +0000
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net 0/3] net: qed disable aRFS in NPAR and 100G
Thread-Topic: [PATCH net 0/3] net: qed disable aRFS in NPAR and 100G
Thread-Index: AQHWdmd1mvjfoTfGxEWuPNNxj3/7LKlCc/ZQ
Date:   Fri, 21 Aug 2020 11:45:28 +0000
Message-ID: <DM6PR18MB30663EABE317AA519AD7D454A45B0@DM6PR18MB3066.namprd18.prod.outlook.com>
References: <cover.1597833340.git.dbogdanov@marvell.com>
In-Reply-To: <cover.1597833340.git.dbogdanov@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [85.209.1.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d74a0292-82a0-4fe9-b9ee-08d845c7b39a
x-ms-traffictypediagnostic: DM6PR18MB3473:
x-microsoft-antispam-prvs: <DM6PR18MB34739B9D5B1262C7996D8805A45B0@DM6PR18MB3473.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PS3DrWvkSYHEoxgdrdoVGS+rJ11TRpb/wBOsbt1PQNGv8CTFAFxXAXJ+SoJ8w16T3BDYO4+R4fowUgt2noRV9R/PZAPskTogI0MLwilSSuuPOIbycXEpd1SaP27MYLXdXdUpXGobJWaLLcIhUWHqu0OC3W+ROeBh7NMVh9C9qYgViJsaTuXKdQnU0mlS3eq/S8VBG1awK/R+U75TfylsbWhkNepekNIIhpu1KzR3semr7YXJg//ZzX78qYLDDBSpNHzBuyNEDT7WmDAnnQ9vEIAEu8bXzIlXqHp1tyT8w8QOlv1U8Qb2SV3CzbRYDYXU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3066.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(76116006)(110136005)(9686003)(53546011)(6506007)(66556008)(8676002)(64756008)(66446008)(66476007)(316002)(55016002)(66946007)(5660300002)(478600001)(71200400001)(2906002)(8936002)(52536014)(4744005)(7696005)(83380400001)(186003)(86362001)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YlouS3HA0rAtN8myl6tnBSBSaykDTPb+8//94eX/nNMxE6Nls4qhKuO6LrRNvmDFG/8soaB/kK/Pt95ACMs9Igjr9nAYHZaXult/+hu2tXavjBBwvdFjl3qgVoFx7YkQmQA3aTJzB0gXcJV4QnrBEgtcaBhZIZTl2PLFs+xCo2z8kHRzQYzJT+Jnbf5GvrZQ122mokqtbBxfaLTRdd/l8TZep3OlzUG3iBgv7H275PsRGBxpcMknQzWgxpSRO7ZOAVtCzyUFyzaicfuaSIOH41G6f8OL5aJMA5neFAl0Kg2DRXnchjPHDTQhJXIY+mAELOlHT+aWwVpjgvjzXwWgxo8pWyjRzFSnnzKG5pITYp9xRyWaOhLkV/+TLNsmfcANC/ts0VMrwe1H+zqibgTJ3tT7NMIL7/2wWADQdc1byb1FtCyeFQTztUrY/L5DI6d+6HVdjDS8t/BDLDXJCGlnhNdVakWmJV20ZsaSPEAuruSuxzzRDzbyfDsPfWrFe3l+fzpj4Kh21458XYff1L0d4KuKT3VIfgQITw9rbCmxCA3jE9vsMKUZNXjPmCwIwT7xV4c5x3RB2qBnL0Ys3mGpdH0JlUmlq1Rx2DwA8GuUc2UR/RG1Fdwb9lutETmoDpJPVLRDaT9IrM7OnQkqxDRIqw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3066.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d74a0292-82a0-4fe9-b9ee-08d845c7b39a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2020 11:45:28.4426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r6rKK5rJ2Y7zkcFoQldmeDdd/KOYdY1fN/YAwhN+O7AcTfvdz0cHCnUJT+8kOymqXcCCdFvauxOZts6adJm9GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3473
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_06:2020-08-21,2020-08-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forgot to indicate "v2" in the subject, please ignore it then.
Will resend with v2 in the subject.

-----Original Message-----
From: Dmitry Bogdanov <dbogdanov@marvell.com>=20
Sent: Thursday, August 20, 2020 2:08 PM
To: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>
Cc: Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH net 0/3] net: qed disable aRFS in NPAR and 100G

This patchset fixes some recent issues found by customers.

v2:
  correct hash in Fixes tag

Dmitry Bogdanov (3):
  net: qed: Disable aRFS for NPAR and 100G
  net: qede: Disable aRFS for NPAR and 100G
  qed: RDMA personality shouldn't fail VF load

 drivers/net/ethernet/qlogic/qed/qed_dev.c      | 11 ++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_l2.c       |  3 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c     |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_sriov.c    |  1 +
 drivers/net/ethernet/qlogic/qede/qede_filter.c |  3 +++
 drivers/net/ethernet/qlogic/qede/qede_main.c   | 11 +++++------
 include/linux/qed/qed_if.h                     |  1 +
 7 files changed, 25 insertions(+), 7 deletions(-)

--=20
2.17.1

