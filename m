Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBF41D5AC3
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 22:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgEOUjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 16:39:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28744 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbgEOUjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 16:39:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04FKUSqr019894;
        Fri, 15 May 2020 13:38:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=OKkirUSTD0FpxoPez929X5SWc+0Ds12aspg6pJpCaCA=;
 b=hQeKDexS00IP5AkGz/MWOdT3Y80DU5zXsn/zuvDCayzhsPOMhOE+yUbeSQrmfeITA/eY
 LAMmGFTO/DL6ZdWle55QmtpHhmVx3SnK2xt2MOlXUda4tzV22NdTK/CNR3MM2sem1V7x
 Ab1V9+j/uD85iHO4cI6kMrhJk9m+AGtopgGHfeD5ADE0Txkm03OKjNTCe5V5RfT/1Huw
 TfjgqwU1lEu6iIw0v33NvTd530SQqXzTlqZp8NZ9T5bCoeTQc1AHWygKttgBGMIDsi6D
 Tpu/0lnFyrELaHMNebzKa4Cqc0QQj8Fds6qB0+9cxIIPOuhRUGI1JDp/HXql3U2F8KgF 0Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3100xk9p7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 13:38:06 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 May
 2020 13:37:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 15 May 2020 13:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nR/1VLYSgPAzGNQO/0LVZRxstxAO0Xw77Z8s+TULs6igsXxNP73I2oCEO1tZxYraWlv5xYGs5YrYPKgJd39nkEyl1GeXngxkinlryVMscAB7lEFC+VWEmk2zw6jUkNo/wbvaKFeCE4pXlYiNxiq6R0YRlsx4dEfpmh/5DSS0M+bJV1FPJY887M2ip84pNjSgfJLivLeijGMcwNqU0qOoTlco8YRqWTxID20PJqKsrxFczE6M8/Wrd7LKifs82PFGLg65Ni1a5MrGozUOFxaXRAcMA4Shv1pQmwW6ZekM39cK49r1TP7U9q24j9PkAeu5rTvktsR5CIHTMWfM5Ap6+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKkirUSTD0FpxoPez929X5SWc+0Ds12aspg6pJpCaCA=;
 b=KIPPirhoPPdqoI9SVyw8iOKGhCxXkDH2tlEuTEVQ8YnHb9BbP930M3zuLiN1IZmkwn/C1y4Y0JCsbSQ5cYMeu5UPK9d1Y1OujQZ9KU5yb72bWGJsyBhawVIpyaGcO0sKCz/WlXgptpEylLedkZZZMsT5jW3bITz0DRIA9RwMIvmM97bq5gLDXbQeO++qdpy6TlLmSQXUWM+kK0P9bCQHJ6wUfqD1V8zS/40HZJ9sgFXJS9A9zdnI8A0B2iKDqrvjV2E6ML+EhlkEXPzUz4rc+lzx7r87uhJOqOAQREDL74QbRcA8BNyRrG7IRvFYZwmrjb36dMHe2gp1IYNqasf48Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKkirUSTD0FpxoPez929X5SWc+0Ds12aspg6pJpCaCA=;
 b=Q6ORa8M4q8DNY7RaDz2dJfq9sTYRk8JCuo/YZFBNhuBN8SSSZGVGhlChQ/Ck+v2XImjE/Cf4JICqv8pV3jsCGObpQP2N5Gioj+Kp8ZCjsaA0E6B6+Iahzw7GkLLijL8kVaX63jR1Y8xSTM3sQD5dXnmCS9ih07xjHLHPg6wl/jE=
Received: from DM5PR18MB1418.namprd18.prod.outlook.com (2603:10b6:3:bc::7) by
 DM5PR18MB1673.namprd18.prod.outlook.com (2603:10b6:3:14d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.20; Fri, 15 May 2020 20:37:41 +0000
Received: from DM5PR18MB1418.namprd18.prod.outlook.com
 ([fe80::9db5:78f9:4531:c552]) by DM5PR18MB1418.namprd18.prod.outlook.com
 ([fe80::9db5:78f9:4531:c552%8]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 20:37:41 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     "jeyu@kernel.org" <jeyu@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "aquini@redhat.com" <aquini@redhat.com>, "cai@lca.pw" <cai@lca.pw>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gpiccoli@canonical.com" <gpiccoli@canonical.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "schlad@suse.de" <schlad@suse.de>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "will@kernel.org" <will@kernel.org>,
        "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
Subject: RE: [EXT] [PATCH 09/15] qed: use new module_firmware_crashed()
Thread-Topic: [EXT] [PATCH 09/15] qed: use new module_firmware_crashed()
Thread-Index: AQHWKvf0C1jPlx80W0yb7wc+a8cK76ipm0LA
Date:   Fri, 15 May 2020 20:37:41 +0000
Message-ID: <DM5PR18MB141839419062FE0AAB39B6EAB7BD0@DM5PR18MB1418.namprd18.prod.outlook.com>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <20200509043552.8745-10-mcgrof@kernel.org>
 <2aaddb69-2292-ff3f-94c7-0ab9dbc8e53c@marvell.com>
 <20200509164229.GJ11244@42.do-not-panic.com>
 <e10b611e-f925-f12d-bcd2-ba60d86dd8d0@marvell.com>
 <20200512173431.GD11244@42.do-not-panic.com>
 <9badaaa7-ca79-9b6d-aa83-b1c28310ec4d@marvell.com>
 <20200515203230.GA11244@42.do-not-panic.com>
In-Reply-To: <20200515203230.GA11244@42.do-not-panic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [82.208.124.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d2ba71c-2e4b-4ac7-1981-08d7f90fd0a9
x-ms-traffictypediagnostic: DM5PR18MB1673:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1673D57E38C580DED7382293B7BD0@DM5PR18MB1673.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lYj9x1gb0d7IamaaEU/tBWLEvKsAMmdIGjKdwjC6m9769419ysqycne0HTJvmwHV2a3GWfuXuTgiCHLtlYQf3kkpjjs0qrrAVCjzFmFai3COhzBfDg/lKB2oBgNanNCBYsIWjdR0kt3+V/BGg0bQoq0KWsH1WeVZ8UT7AxUEoELfikiVAfmNaFAAsLuFuLHrXyv3D+XmCGWno9Qzf47DeyPoGjGod5fmemLywh+TR02eGtZRwnGT8pqGo/F/FIfpPcjTfkQS/txt8YUR65E0k56tvmRckQxdczWlo5NqkslRf9cCDi7uiKMjMIPzZOx+dv2stPQ+HhB+9QnQBPjeukkYOAm0Kpl3zT7eWDCp6yFo8C6TtHUZi0nEg/gKKwrPnoBeAIChSpUjNuHRU4EKcB0QJ8RMc2xVpzI9CGXEsxnA4NFaw65+n2grEkgPGX6R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB1418.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(478600001)(316002)(66446008)(2906002)(8936002)(4326008)(66476007)(6506007)(64756008)(33656002)(66946007)(76116006)(66556008)(558084003)(7416002)(107886003)(186003)(8676002)(5660300002)(6916009)(9686003)(26005)(52536014)(86362001)(54906003)(7696005)(71200400001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: H0c1nfPkn800SWqY0y3miHzNjriPaQ8ySxSrnAtYnMZ51mlG/rnhXtbmrPd2VQlVQeM5yix7sarb/nQrwZvUFXX9zcMf2fJyHAabqD4SE9DjoWQIir7oUGyA5zXTFB4dTQlpIYpia4UgiKSf4JASnc3RkIHaC5W1Rnc3oVe6Dn/YV/Idwu412FH6wSG23gqvSczrzm+FO9bK7kk8tZVNtgR27qQSqc10z3Pi6g84fMjX/gD2mDmNVDXgbdAA7OmOI28pLBl3JqT/e/SzKCcfwj7xcLJb5v6gUZ3oYnYA1r96REk1okUpjeqcQrkMKB0u4qaL6PAiChEhpa6eYmhbU8+SXjJ9FWvJ29iYGUuQFFMTF6/hO0Oev7qufbUAr5Hr/sbjcUITObNZhVTOIwIjWH2WjNxZ0ilwlWiK1mnRizOZppDJlNU/zwHk++GUbbc8O0/6Op9Afts1+u28OzZvlStoyx5E3+2LfUN1iCzC8H679bYJpzZUIwwt2Kazj/UM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d2ba71c-2e4b-4ac7-1981-08d7f90fd0a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 20:37:41.3934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQ8hiSv01bNoshSX5BSv+KtScQmiMtj872UcYo+PAFadO6NdRnfRj6swXcWbX39mwjMQQE4/GkjUrXL96NsfDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1673
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> >
> > This one is perfect, thanks!
>=20
> Can I add your Reviewed-by provided I remove the hunk above?
>=20
>   Luis

Sure, I'm OK.

Regards,
  Igor
=20
