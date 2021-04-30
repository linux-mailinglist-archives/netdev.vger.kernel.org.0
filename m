Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7121B36F3BD
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 03:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhD3BhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 21:37:00 -0400
Received: from mail-eopbgr40053.outbound.protection.outlook.com ([40.107.4.53]:31617
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229519AbhD3Bg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 21:36:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zyn6OEEbet91qGh+Q2Tqk9la3ms3IoPAKAzeRwFbAKU=;
 b=SNJglyS5K8mqn3eqlPTVlfrZlW/VEN507JXqmFM1EjSS879wgWmnKBPpsuToRERW3YmZfAy5yho3CRdgAo28mCTQYREK41DXswQJOjaOjPdfxlBuqwyLh+uups/k1fRBxheKwL49hbDq924B2iL4vVMpbIzgmW85ASlHEwIYoAU=
Received: from AS8PR04CA0033.eurprd04.prod.outlook.com (2603:10a6:20b:312::8)
 by VI1PR0801MB2031.eurprd08.prod.outlook.com (2603:10a6:800:8b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 01:36:09 +0000
Received: from VE1EUR03FT019.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:312:cafe::cb) by AS8PR04CA0033.outlook.office365.com
 (2603:10a6:20b:312::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend
 Transport; Fri, 30 Apr 2021 01:36:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT019.mail.protection.outlook.com (10.152.18.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 01:36:08 +0000
Received: ("Tessian outbound 13cdc29c30b8:v91"); Fri, 30 Apr 2021 01:36:07 +0000
X-CR-MTA-TID: 64aa7808
Received: from 29b35f613ced.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 03A3BCB1-A916-41D8-85F7-2E0AB6803F29.1;
        Fri, 30 Apr 2021 01:36:01 +0000
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 29b35f613ced.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 30 Apr 2021 01:36:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iT+ozNgH4gGnFIR5MGEEIm7A3YxYDqX6waxa/b6dsux4Rfk5/pNF5OPLBDU/0Q/uPgCBnBoRCtI1RwA8dTXjN605+ztDCJU593PPofgbFaEbAN0m9x4gI9XH+2hocx7nUYpOX3gIHNgTP1GD9jI/BiOKmQ54GyKzzQXTP+hXT2SDiGvcgINgayNPdTyWqxUlvvHbkXrp/BhS7PhZ9Ppz+Zc4HbEVgzD61tSmYxSp8EVDUtKj5d/Kf+Pv6ToAQ46tjUcNs8ar0WALIGe1dhXAellOjm8fLuICD/8oxJsnlaM+x4Kh2qMSLbzwd0QvNy0RSqXGlQRAAwikEJNCgiixtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zyn6OEEbet91qGh+Q2Tqk9la3ms3IoPAKAzeRwFbAKU=;
 b=nrhI48eNBhjDVozk3hc/QhoBCBUZ415zEDOryxTI++FOWvGCkw6jNKj2+qxWS4GRXzAQt0ir+WL+4NK1kpxDZn93WVBZgQCDxKW5xF8c00gxJyLqyqt8MITQJND3L/18si86BTv+ygezzGI/+/SVZ6vE84Eh9bPs1hIETFq9d2k3GTT0tqDPb9O2vcaFBiGWIvQhkjtEuGZcDfQ/rNxcnJkMQHC9GzqlGafP6+KhoMAnR5GDGOyfcXGFWsGXzb7YqigY+htv2pi5SVhkHt7i68nCCYwWQcZwzcqzvkN8inGAb+O5KFncL171QwxHMGFaNE4JPkGVqNKDOu9afZnMDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zyn6OEEbet91qGh+Q2Tqk9la3ms3IoPAKAzeRwFbAKU=;
 b=SNJglyS5K8mqn3eqlPTVlfrZlW/VEN507JXqmFM1EjSS879wgWmnKBPpsuToRERW3YmZfAy5yho3CRdgAo28mCTQYREK41DXswQJOjaOjPdfxlBuqwyLh+uups/k1fRBxheKwL49hbDq924B2iL4vVMpbIzgmW85ASlHEwIYoAU=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM5PR0802MB2484.eurprd08.prod.outlook.com (2603:10a6:203:a1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Fri, 30 Apr
 2021 01:35:58 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60%3]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 01:35:58 +0000
From:   Justin He <Justin.He@arm.com>
To:     Petr Mladek <pmladek@suse.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH 2/4] lib/vsprintf.c: Make %p{D,d} mean as much components
 as possible
Thread-Topic: [PATCH 2/4] lib/vsprintf.c: Make %p{D,d} mean as much components
 as possible
Thread-Index: AQHXPDbX6dZc1hpzh0aeFLXkWEMr5KrLL94AgAABxICAAAjlgIABDncg
Date:   Fri, 30 Apr 2021 01:35:58 +0000
Message-ID: <AM6PR08MB43764532743E2DC2BA778C7EF75E9@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210428135929.27011-1-justin.he@arm.com>
 <20210428135929.27011-2-justin.he@arm.com> <YIpyZmi1Reh7iXeI@alley>
 <CAHp75Vfa3ATc+-Luka9vJTwoCLAPVm38cciYyBYnWxzNQ1DPrg@mail.gmail.com>
 <YIp7VxzE5MspQ0UX@alley>
In-Reply-To: <YIp7VxzE5MspQ0UX@alley>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: BF9EFF931D940B4A8979C232639C240C.0
x-checkrecipientchecked: true
Authentication-Results-Original: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 397217d0-9bd0-4f2a-7e2b-08d90b785446
x-ms-traffictypediagnostic: AM5PR0802MB2484:|VI1PR0801MB2031:
X-Microsoft-Antispam-PRVS: <VI1PR0801MB20310C0D4B6A4EFF8AAB028DF75E9@VI1PR0801MB2031.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 33vkEBGjhMeb1HcZ95wJwcBM/mqGjZ/09f6zw1MSoVO58JO5Rfkz0Z4P7Uf32j7YRqiKRAX47H+NzAyvquO9t5ojmanj9ogJ3fKBsBbbfEwtCJT/X2jOlQUX2EsOUrUpD3EiJTWkCw5lIZuy8/eBVX7cbgzEZJjCss2N/C6OJnzcGQHONJNHxeePk8k5Dd0xxg6NTVVoaum052VO73aX+okFR+YPRRdyc+NShmXtNi1A3RNqJC9JLvHPRzdi0Nt8N5PyBLs+wRfXktyIteGPNYXH7aqPGLIceXPf2VhDWYTCeP4ypy0eaDvna2/geVXGPBzqVuRZ3ZbE3RdGxFXjA+ERuQf6NZqkuBS492k6gSnDWsxqnUvKgv11/NQf+UxeMr5RFJeVP+79JSZhRSVEzapQk6MSHCgAaw8Un3imcpu+VzQK6f2ikmyIjOLVdzwSwu1Py2qUNdgUv8nZq922dPGPdK+I3jYUs5nFM5d6o7XDDgCj59kSMzCiqKLopWBYYj6B56BX3FWJIP9MR4M6Y2fnwDhGVY8Bvm4EVjmNqAhEwyeP+RbFQcptRLcefkV8gKMBYjVy+gT/FimwILKRth0ojqvQdtmk1jSH2PGe37rQibyeKjZ53fXbcwNp+4h84/HMROleh0OLfSEo77xyUgRAfK8MPNJ6z757PPC/pWbpFVPnI4/z2beTh3VpwZp7
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(66476007)(478600001)(66446008)(6506007)(7696005)(53546011)(7416002)(33656002)(66556008)(64756008)(110136005)(71200400001)(2906002)(316002)(26005)(66946007)(76116006)(966005)(54906003)(8936002)(9686003)(52536014)(8676002)(83380400001)(55016002)(86362001)(122000001)(38100700002)(5660300002)(4326008)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1TdrHWFLXd7pyaTXTZbk+ZDgONlADoQB5wnXfbwnqSrG2MnapfVCFk0nZchQ?=
 =?us-ascii?Q?Gva/e5vAGXdoBXx4ESZbYcyq8Kk4qFuxQzHRtGf+/jc1am5W5jrB2IIs1WxC?=
 =?us-ascii?Q?v+tyRaU4dMiegzwfi60I2I2rT/8BgJgxyu1y1hl5I9QPCe1/CbsYuJzOEx/m?=
 =?us-ascii?Q?CkIMZ4LOJio6LTy2QZ3bk56keC18j0/RMSua62lm4TUTq09o828gYOqmHX4E?=
 =?us-ascii?Q?4ikRHv8ag++jo56Jg05gXXlxJwdsrBjUoaPX08J8TsGrnRUPrHRSMSPDVUJI?=
 =?us-ascii?Q?k3O7J3Hk9x1PeTRVgw73wvVE+kr+FTlW6+kxls246WTbVHRPbUNztJYSunte?=
 =?us-ascii?Q?+BvVlwR4TmLXxLmIvePSDE9rMJ3n1lvL4Oy9XcqlCF6QIEdtBXrkcn3Gd1Wh?=
 =?us-ascii?Q?WIhOeaoTpQ7DK4bBxftDFSm2q+XyGaZURKzUAwZ0Me0l0QgXDX+PaqBQq+ia?=
 =?us-ascii?Q?1azArH3ulrO08rRXBTxUAsl+InjiNjuyOWQNVHqXUZV3ofYJYE9MYEBiBhYx?=
 =?us-ascii?Q?V0sjCnZPK4Ca4yjv+oIPadqQSzuyS3s5GJ2bjOn6Itk2E5A8wo33TS8DQVnF?=
 =?us-ascii?Q?EU4u1qFlH4xRm+19WPDKluVJl0C1XUEhXb9l2ccmtJauWty+GIYCaBlc0qMh?=
 =?us-ascii?Q?1g/z1pF7rviIhpv35ucC0nBkL/6AfCDkOsMdamtmrHU0UEvGt7uXO1Mlfyk8?=
 =?us-ascii?Q?Y2il6bUapJ1JgJSsfE7rVAx1J9pnA1cLtcy43aOk76Y8Ix02q6QAU3gaCYUT?=
 =?us-ascii?Q?XyaIkRgFlya8m7hZKXjAGnzBVR8322BoG26b35JMf+CgCSp9zUf9RAdulSEE?=
 =?us-ascii?Q?FaOVr9geAQa1+DiCDcN7WcZZXnALXCjUAswc7Xif3J+U4SM8w7+xPNOPDDwu?=
 =?us-ascii?Q?rV5asLo63R+lWBNQS8HO5eQxqiINHYm5rt7NbeG9tVj4W+UdIu+yQewBMjCw?=
 =?us-ascii?Q?2LFQVl+qrIh6fi4P2dSIW6Ja6vQ9GLppP3uOMXQdAQTPblQLMOcxgfktC2bs?=
 =?us-ascii?Q?9G596BVlXbF2xAxqqs1cDLwJ4JtMyFNDldS+8lwQr1kxclNXfl2lSFj76G8d?=
 =?us-ascii?Q?PZX/OQxh2WpWXA4jEo8WLQKoAzq19YjLkIxWoOtJEmNYjdE6O23qA5YnMM4g?=
 =?us-ascii?Q?Kt3YKT4Wu57b/lQYaFsAKhSeuRTOOsrJ9iCM3CCQAytEfMk7y9GN8PWcHODY?=
 =?us-ascii?Q?XVzSk1vC2ohbq413Qr1slBrVWvAuxL3ZBB0sc9y9XiiQa0FCRDGaOMF0E6/T?=
 =?us-ascii?Q?ituomotD4nTaL4lOTWXhOJilysJW17u7yQYnl2b51zcnl21j2kZ8vk4x9XDd?=
 =?us-ascii?Q?bYUaqdJwBzdix/8561cxH8EL?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0802MB2484
Original-Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT019.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: a13381f8-7bba-4f2f-f77c-08d90b784e2d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYP2UuJSZiX/axZnuNElrrrD5jb5EJvxZtanxz4czKU0TFoAl4WxekNGsfVZ2f7T3CFc+R11a58Sf6LHrj+qi1suka/Rwws2rO6imRmMyY7VBAmeCvigMwKc/4QrSaaE+WLvxfa+kLA5NrR834prVwxgdDDtbLz5TYe7Liq93LKOXPIfTXPRF52OXCm4ykBbJCkX9UNZV2IrMQqcklnxbyhLRB4R+dA+U+6D9KHjNsNSS6POF0NUOcelThNtVdo8c1v9dOzT393KxhB4z9JgV7vishv0msmmW4LLqdM6nzQ3+KQY2enAl4xmzDLY4/0YG4C5HxjLujflk7Nc3ivPt+q/a7wSej3hoRt0feufV2Xma/BzWUq5JjELTBwwc0Vhk1yC9ZR6jwVNQJwOTIF2GB3AMuUsOYN3O4BZq4UAnMg2HfNgiX0g6VJVD5axbZIj3iYVLnqThp2xg4gCK2UjIPVIKSvf7r70iciqUIwccGpUCDu4LwUUvoT+tUYfoITl2ikzT0DKJeUXluPALN9tiamKkBjAV46BrbrldAAsjzd2ju1BMPpJc042BeOTZCd/SOgX8Bzp/r6J4HNoCBGBoAhZKG5Wb+MmAzf6jEjKK8NqsqQseyNFmTkZXPDYMv4vWPPll+JogWZZFWcaUD6UFyZVMOk5dc7Zk0dwzFwJgc9a9DmSmt9Pwkn1UHrwl5prH+VG7Am7oCkCHd01XGBNolQD9fC1oBhHkR8lHxICruniJkAaHjtZBNHWfvfEPTwbmwv1+n1zZQgxoDdYxQ0gng==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(36840700001)(46966006)(6506007)(53546011)(110136005)(55016002)(54906003)(83380400001)(316002)(34020700004)(36860700001)(47076005)(7696005)(82310400003)(86362001)(478600001)(82740400003)(70206006)(186003)(5660300002)(81166007)(356005)(2906002)(8936002)(4326008)(8676002)(26005)(70586007)(966005)(9686003)(336012)(33656002)(52536014)(450100002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 01:36:08.4544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 397217d0-9bd0-4f2a-7e2b-08d90b785446
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT019.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB2031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> -----Original Message-----
> From: Petr Mladek <pmladek@suse.com>
> Sent: Thursday, April 29, 2021 5:25 PM
> To: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Justin He <Justin.He@arm.com>; Linus Torvalds <torvalds@linux-
> foundation.org>; Steven Rostedt <rostedt@goodmis.org>; Sergey Senozhatsky
> <senozhatsky@chromium.org>; Andy Shevchenko
> <andriy.shevchenko@linux.intel.com>; Rasmus Villemoes
> <linux@rasmusvillemoes.dk>; Jonathan Corbet <corbet@lwn.net>; Luca Coelho
> <luciano.coelho@intel.com>; Kalle Valo <kvalo@codeaurora.org>; David S.
> Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Heiko
> Carstens <hca@linux.ibm.com>; Vasily Gorbik <gor@linux.ibm.com>; Christia=
n
> Borntraeger <borntraeger@de.ibm.com>; Johannes Berg
> <johannes.berg@intel.com>; Linux Documentation List <linux-
> doc@vger.kernel.org>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>; open list:TI WILINK WIRELES... <linux-
> wireless@vger.kernel.org>; netdev <netdev@vger.kernel.org>; linux-
> s390@vger.kernel.org
> Subject: Re: [PATCH 2/4] lib/vsprintf.c: Make %p{D,d} mean as much
> components as possible
>
> On Thu 2021-04-29 11:52:49, Andy Shevchenko wrote:
> > On Thu, Apr 29, 2021 at 11:47 AM Petr Mladek <pmladek@suse.com> wrote:
> > >
> > > On Wed 2021-04-28 21:59:27, Jia He wrote:
> > > > From: Linus Torvalds <torvalds@linux-foundation.org>
> > > >
> > > > We have '%pD'(no digit following) for printing a filename. It may n=
ot
> be
> > > > perfect (by default it only prints one component.
> > > >
> > > > %pD4 should be more than good enough, but we should make plain "%pD=
"
> mean
> > > > "as much of the path that is reasonable" rather than "as few
> components as
> > > > possible" (ie 1).
> > >
> > > Could you please provide link to the discussion where this idea was
> > > came from?
> >
> > https://lore.kernel.org/lkml/20210427025805.GD3122264@magnolia/
>
> Thanks for the link. I see that it was not clear whether the patch
> was good for %pd behavior.
>
> Linus actually suggests to keep %pd behavior as it was before, see
> https://lore.kernel.org/lkml/CAHk-=3DwimsMqGdzik187YWLb-
> ru+iktb4MYbMQG1rnZ81dXYFVg@mail.gmail.com/

Okay, let me keep the default %pd behavior as before('%pd' is '%pd1') and
change the behavior of %pD ('%pD' is '%pD4')

--
Cheers,
Justin (Jia He)
>
> Well, I think that this is up to the file system developers to decide.
> I am not sure if the path would do more harm than good,
> or vice versa, for dentry names.
>
> Best Regards,
> Petr
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
