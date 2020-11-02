Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1EA2A259B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgKBHwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:52:46 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726819AbgKBHwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 02:52:45 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A27p3af012915;
        Sun, 1 Nov 2020 23:52:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=VbNa5ACqx592PQrfEJXJri6YkJg0ny6DF6Zp6nUDHuk=;
 b=L2lXSBp1OdMFeqUw+1l1SJq43dtQbh4Otb2odD3rq13kmP+LJmByWS4J4kgMCV3Blfi+
 +n2iOVkvwk+7eu0NbwWVg/PK56jwkFCTa7gAf3Lwy/EuZi8+XM4Ycjms8D8ybxxjUSyQ
 aedFyQ5b2VLRkhNq+fLLMZ+uQ5LOrjqdEmqwyPImZqSLfgP959hUmWNnGpwf6m/bik58
 g961eX5nt5uoWvZPggzldr9UPXNbUdVsDyinj8QXI/UYLbNWxXM7nkbShfrVHxbmIJaE
 M/OJM3NJbcdYLSMnMG8ueRXoO3oKmE5+zWlHzWiN5gZ1HrzgFAgwd4IeQ2ZUX+HSjui6 0Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34h59mpw1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Nov 2020 23:52:37 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 23:52:36 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 1 Nov 2020 23:52:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsblBDFntSZnhmH1o4Oev7DzKaCOkA8nRBOeMzj6fQbk3DxCkIZwSd6b9U9OOd36VLE3T1HB3dPd3J9m/6nj6M4T1Q9MQZaYa4vEaRtiTdi67TKSXu7Y++erpyqN1mBOD2ErVdbtC4hOd3EjFWGhTZpHO/kCQGowag4Foar95zThrM4gOASlOrfzj7aNhyLFcbcTsQwOPwMYS+3/Oxfdjb03RKcCIC7jAWZD4K+O7qzCTtZGDD1Dg2WvAa+9SH3IySWfRseYpKfpfv763mc42bPh7Vpmcha+89yX5cgz52N/gSN+Kb6LRRiB1FM0SOT03JjGeAYdfpefzxxfUaD/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbNa5ACqx592PQrfEJXJri6YkJg0ny6DF6Zp6nUDHuk=;
 b=UVdbaPJsQrKLbu6Royx0TFiMV91/wSxhRQXqftcuZGZ0MF2/h6y2w9be/6V8x9SgY0amxZGNGdLc6rd7Yf1Q2unq4VW3y6oZmohrVeDgrJSHlDXQBfZtZHgw4YAwuqQatx92xu+a2O1ljNr7LRICsaz5nTl4jEgdjNeT+OD83tcGuV5hExSHz16eXVxS/Tx0HLAzG7TQz+kJfGFFNOkWZA2IYcJ22I0w5E/FuTHGKl9B1iIE8sWkuXW++0TKulKq3WPky4BGowhT260FaCAW6PDXcNEVXksh6yYsobSDzHIBGnl6wzhBME4wnvXoeFZgEmHWET48rthQBlYK2dhkCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbNa5ACqx592PQrfEJXJri6YkJg0ny6DF6Zp6nUDHuk=;
 b=J/WoIWTxBD/mvWSCNObXOQzWXE5zSnbo3M6dkYAUKiMFCuFGCUUfHwnBFqa6y1aRegkMpXeEDCPp6EjaYB+UZobbYeiZ1HwoB7nn3RPO1NkJwlAfp/ynb6MbDx9bTuDLhWHYN6VK68y183Sc0FBbA2IGOrp7Jr+nSdbF2G2JxS4=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by SJ0PR18MB3865.namprd18.prod.outlook.com (2603:10b6:a03:2ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Mon, 2 Nov
 2020 07:52:35 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2%5]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 07:52:35 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Sunil Kovvuri Goutham" <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>
Subject: RE: [PATCH v8,net-next,00/12] Add Support for Marvell OcteonTX2
Thread-Topic: [PATCH v8,net-next,00/12] Add Support for Marvell OcteonTX2
Thread-Index: AQHWr8jltnVbe7+b+0eB/r/GIqpT3am0d3BQ
Date:   Mon, 2 Nov 2020 07:52:35 +0000
Message-ID: <BYAPR18MB2791EDEF594694285FA8E457A0100@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20201028145015.19212-1-schalla@marvell.com>
        <CA+FuTSc9KJg+MSWvXDCMaNSMkXxxKEW6JkDa9wNvQ9xg_7RS5Q@mail.gmail.com>
 <20201031140034.4af041ee@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031140034.4af041ee@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [157.48.169.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc2babc6-2449-4e8c-80e7-08d87f04430c
x-ms-traffictypediagnostic: SJ0PR18MB3865:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB38657B25523BF5C744B5BF55A0100@SJ0PR18MB3865.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9TKrenJ7x8nvypFjr/tKdKjg4EdMXeic9PFAujOedUOZukQzRTeica6lQykk10fx5rLOAGvZjrw1knpDLTk0Ir+Vu6Ck8VSO0MU4NK5cPnw+5IOy8zLIPRkBhjooH6srxCfaJhiprwDIweTgR2wf7H43SpiCGeiLQuvcuCZV5lgp7pp0gpW8w5OgrgzrIWqISm5DNz1gTf2eXc0PCvhBGfhSkT81z6FMC7sYu+kEAGiuRsd7c4+WqEm78/+IJyIv8oSyonGggROyq2AEWgsUVMzrJj2w73nWqefxH+QqXR0A1lxJkmX6iHAm40X34WtoJ5gtXAfcIc0b0Rar1AZAPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39850400004)(366004)(76116006)(71200400001)(26005)(107886003)(4326008)(66476007)(6506007)(186003)(33656002)(66946007)(64756008)(66446008)(66556008)(478600001)(55016002)(7696005)(52536014)(8676002)(110136005)(54906003)(4744005)(8936002)(5660300002)(316002)(86362001)(2906002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IVL6jv0P22sv3Orv+pC5cly8LHE0LGi4+ipJykFkymGKro8t4PTreXJ7ImBEDmml+oHFYLztfZf8X+5gfSauWHU64iaAHo9bdf6LG7aH9D2qIGvdfeNgELcfyxbjSWb9K2wCf1DQyhdvt0EiWLlFyTaG+AyPzomOSBohs6vzZHNTjqSCM7fGl4ojoSitIF3k8uSyozF4hLpdKL4MyB2nh4qKaXLm0cVkrUUE92GNiFIMcIzbS0T7OdY0r0OXe3rgFO+/6cvHsTrThJ8jC+PdZ6Q0OYztd0+vR1f9zZBNm/RNrzWc/BGnrhV+ufmjMPDzWljoUqAmvzsTSjEUHxtzbtE60Y9xojLyje7T9Upfj1sydnjGuUqh9HvBo9558E9Ttad+x4YXRaOpEIatcDAl14hgarlJDxc2SyvvETwEBn7I6YMq8L19fhnIIxtBAQqTA7sV6ii0m15ljQ+GMieuob13jA9OT8Jaq1DEbN+hiF6iB8jXiY10DFf6hN9Ldp+k43xuUjdSI0Q6YwHt+7Fe7hEkB7VyHviZBIewmbdi0G4eRtZfxVb4Ul7eZPNnCKz1HCH1I5ffUVc6oebGJuLVqPPKLcD11HGT5THRYXR0FNyY06hoMEfSstjVYdbH9lHD6SjgcDXVmrHxCdlqtHAC5w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2babc6-2449-4e8c-80e7-08d87f04430c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 07:52:35.2755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HlffELYaKpSWH9TjAwvpsPtjsKYpEHF5unEawnZpEzL4ECUne8CaOvV6QUd5B+geMT8jx0T8g0Ie5ecnH9T+1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3865
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_03:2020-10-30,2020-11-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v8,net-next,00/12] Add Support for Marvell OcteonTX2
>=20
> On Sat, 31 Oct 2020 15:28:59 -0400 Willem de Bruijn wrote:
> > The point about parsing tar files remains open. In general error-prone
> > parsing is better left to userspace.
>=20
> The tar files have to go. Srujana said they have 3 files to load,
> just load them individually.

Okay, I will do the changes and submit next version.
