Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175C02303B2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgG1HR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:17:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10166 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727091AbgG1HR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 03:17:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S7CJ3W025081;
        Tue, 28 Jul 2020 00:17:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=1W0EyRJgZeqlH/GHO4NFnwEVBhqRcFhvJs6xOks9zXw=;
 b=yr4UmE9oqBqLMOBn3FD0tTAs4k5DZglVT6MJw/cSavyCI3XW06U0/7CuTj5De1gNwckH
 rWgM6fGarCnqH8AnaIcNKVwb8gwCxYYMJdmsYl4qw/di6z1E3Ylz57QllaPvR68cQSWy
 cwzP4GQdV50W1Dl07Div2QxJWJjW/NmSbHdV7fgeysOmXbH4qPWKa3eZyR6ftpZzcRHo
 prlw0AF56JePT1TPNY33hmhyb3ZqRmodK7wDuVdkGUIawKCFq+8rYHR2Bj5K4hp9/nRo
 XObpJS3OQwwfRKJC742vAKeaxMs4OJritWRdo5VmZPyfToK4mcTG7dgeDkOKOvi1I8JO wQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3qtvs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 00:17:22 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Jul
 2020 00:17:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.58) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 28 Jul 2020 00:17:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pe6DYtTpHvowH9jSJEZQ0DznvYh7fW+SvRNJkyg1nvQmo0cnyRuB4JAlKV8q4NMCG4yuEjhT41bYUlAMmtdveFD/zy5qOLFZDvJjnZ5KS6hWS0wIePEpzX0tSKwenU5/d5yGqww280izZc1Zg2KcaCR4Nr5KHt30e7ARyH7hOpelTHwDbAjjqp7UOCKp4wnr6daF7E86NDcSVfhwXYDmB/59W7YMxxDU+5uO4HxthALCnJGA+YVhAAfZjVp7BQ19dENPw2GMyvxCsZc3EWVSRo2wplJAnMV3DaqZLuz2o6vKOgVH/+BbuQGEiffWGsH3oStklipnes2OZlZ/4Bm7Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W0EyRJgZeqlH/GHO4NFnwEVBhqRcFhvJs6xOks9zXw=;
 b=WOHwFU8PT5qyxw0y5ZfqisM/ycWCyQr84nag5OkNArKxmqxIGGimfoAe+wtyUE34tAndiLS/7Jx1kw+/vtRLk6knlB0tJ0v12OAH40RINgkJC19w6nmENTDgpvzJSoG2PUXLlrKX3dcCgTs/aDnh8qxEALKliHa+GttVVYBEbS8mPdw9UYE8uNAw7JJE/zH3IOKYNB9MQ5c8vwYmJFRns7qfHdPIta3yfVWBlpIZ2prfY0UqanLH9hylnZyNDGHOpDy17T6E0ljVESz5mrkK2A0BfrWDEPRQdDagfgkNjLDG+WpBARSs3VGthgHBnXBGFBRuoirkN/6eL3gcAyfqSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W0EyRJgZeqlH/GHO4NFnwEVBhqRcFhvJs6xOks9zXw=;
 b=OFlLktEOAn+HVqI1ogQsHT6GjTADltPdkTPTDRrvSjy2JjXidxNb7aTR4+O8jE/pV5ButzyymeFHJn3mCVrWmL4K9VRbV9dMnYRSG65SRmOSOy7dD/LGROyouTZsOYMJLM0GLee7x/S0hhqtYi9TIycrYKqtJUwc3HqT0JrBZns=
Received: from BYAPR18MB2821.namprd18.prod.outlook.com (2603:10b6:a03:109::21)
 by BYAPR18MB2822.namprd18.prod.outlook.com (2603:10b6:a03:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Tue, 28 Jul
 2020 07:17:18 +0000
Received: from BYAPR18MB2821.namprd18.prod.outlook.com
 ([fe80::2589:74b3:1752:477e]) by BYAPR18MB2821.namprd18.prod.outlook.com
 ([fe80::2589:74b3:1752:477e%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 07:17:18 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Suheil Chandran" <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: RE: [PATCH 2/4] drivers: crypto: add support for OCTEONTX2 CPT engine
Thread-Topic: [PATCH 2/4] drivers: crypto: add support for OCTEONTX2 CPT
 engine
Thread-Index: AQHWYbuTdqiJnfrk4kOmSd/Bv99WcakXoBSAgAOqvHCAAI9pgIAAvsbQ
Date:   Tue, 28 Jul 2020 07:17:18 +0000
Message-ID: <BYAPR18MB28218AC0D1BBE01C50BA4E4EA0730@BYAPR18MB2821.namprd18.prod.outlook.com>
References: <1595596084-29809-3-git-send-email-schalla@marvell.com>
        <20200724.201457.2120372254880301593.davem@davemloft.net>
        <BYAPR18MB2821DDBE4F651E423791C422A0720@BYAPR18MB2821.namprd18.prod.outlook.com>
 <20200727.124805.2057195688758273552.davem@davemloft.net>
In-Reply-To: <20200727.124805.2057195688758273552.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.57.134.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 432947eb-ba07-489c-be5f-08d832c6434a
x-ms-traffictypediagnostic: BYAPR18MB2822:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2822EE053362ACDBA722E5B8A0730@BYAPR18MB2822.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fyftDAWDZ8EbisZmFBHN7oWFUHXQrH/EKtOBpeER3SZUY3omEI5HcDZx9tQslVIcvOIkTxOofpWg+1h+rytT4AFB9xexDh24yN8pMvMkkrgoD34hMEe/CSvJIhBMBg/xur7jhjvvvKnNKP/sUlz7/aieR/U1RS3XYqeK8Xe/NhNgYBJZZef79ETuqGY5N0F/NtIjl0QepGjmUPpVIDSMcFMvm6FQ7VXtM1nl+7Vz49LRNV9EpaT4Gwf716QSnBpaUdHK8jOanw5jTAgh4LGIJ4GvAvSzD54Jfu7S4QfJSMnnvQJUEmdf5kgTZ8aJFg6n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2821.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(478600001)(9686003)(316002)(5660300002)(7696005)(4326008)(52536014)(71200400001)(6916009)(76116006)(6506007)(4744005)(8936002)(66476007)(64756008)(66446008)(66556008)(186003)(66946007)(54906003)(8676002)(86362001)(2906002)(26005)(33656002)(107886003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: VGaNmR/d2vFM7FOMyg0VQFj8JHQhlPzLK7p/xWF9aQtnDQ5P0Ilv3h3u5k4bEHCp8/PQcnhnnIrXWb84RQzqybRwhQHZNCiaQG17w6Hat1NyzqbiCHgGNFlhZl7+CC9wmQiQcB9VmnA+teHuUz3Smi8ujOcbHpYU1hqCIOhdzjAM6v6NOTunT5pqG3pRLApwuoBAs7FyA6gqLZze4PEoUvJMF3pzU4MgP36N6ja+UnajwPmd7ufOhpe9g2SHD0OdxirvrY0pJ7CYrf/Emfp9DyetFJlaojsWV1s6r2REMc6TK2yxpWUtS6mGYfZLpYGmWog9/Rq4XTJgCYXMIbbrEaXnbbj2Br813eW9fpGWruNj7YNGsMtkhVYWIvta2Fghqwt5aRG8Vtb/6Tmh+P+u9E3sNbmdTyerp1KXJ83mspcIc7mCl2JIi3G0bDeaoosPlQ97N2QlHxQAB68IrVLPG6Q8Bz5WJ3OeS1m+kwXrc6c=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2821.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 432947eb-ba07-489c-be5f-08d832c6434a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 07:17:18.5071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Rs0Pg8yD6gkRJ24qbN54vzTOvrnif/clXfChFRu9fExZLvTxz0dQ5LW+RUTywnCGrQicnU6qyWzGH2gBIaNjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2822
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_01:2020-07-27,2020-07-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Srujana Challa <schalla@marvell.com>
> Date: Mon, 27 Jul 2020 14:12:46 +0000
>=20
> > On our test setup, the build is always successful, as we are adding
> > "af/" subdirectory in ccflags list ([PATCH 4/4] crypto: marvell:
> > enable OcteonTX2 cpt options for build).
>=20
> A patch series must be fully bisectable, the tree must build properly
> at every step of the way.

Yes the patches are bisectable. There are no build issues as driver is not =
enabled for compilation until the final patch is applied. If this breakup o=
f patches is not acceptable, I will  redo the patches to move the Makefile =
changes into this patch.
