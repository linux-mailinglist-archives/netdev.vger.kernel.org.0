Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C5768B51C
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 06:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjBFFMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 00:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBFFMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 00:12:50 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE21A1BE4
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 21:12:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdAn7CcgYGt+++YOw1QXFr5PNYvJWB4OfwjMj1pOWD2c4Bu3Fy7XQ+fkfWtJJwuNkf2HpFMhnrR0/e/1vpEkgJZffCAwKMef8INgrJWnBHQl13rNW/oxiLGwkID/1QbmV4UladcvnGe35qsBGSwkMubRzDuujdEBdv0iPUG3kYpGla9tPpymix3oeIEcksuFKDXRExF/MVzlMmKRY2gWUzoP/MKO+YoMbMegAd4HjkWQHW2u0K9kO0V83gDbBwVCWRbOjFCn6RV4uUBrhBXpQHLX9jI6+rMr29UlX5UVYLLc9U85C7xfkkgeNEkjbdlwbRwP3CNb9KX1JgtLHiO2aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SOwlAstGtjMiENbSNtT5+AazTwY/Uhf/oE4+f7QLvI=;
 b=kyrz+mXMdyzdKek/gi6oWkcrzMp+Afsha+24V+9LvVlwvJw8TCaORr9ShlniSWr0nPUasXw5YbpijUUcPZTfepARzrQULQNabr0YJH15pmVMD+WzwHYiJJeMJquwhYpX9i2oAOp+HPaxK4mNuNc5UYwWwjcFpRQdDh88P20HOzb/EdfZRHqyKekrISZ9RcilOKOw2EWv3rBxF9Woz217uUOUKXiS0ikWD73HeEjdO+ECWBvBL+H/vrCYYjAhcyPr5yLrddZ1Yu2JWIDtCtbx0pG7buWwQ7u4xz+rmEqv1/vjZjtzyxMcMohd2DiOmFFERaZsq1ocTHP1Hf6h3i/B0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SOwlAstGtjMiENbSNtT5+AazTwY/Uhf/oE4+f7QLvI=;
 b=HtN+mfheYxeHy8tAvaS465Bx+V0F0Zi00VwpD1EuWX9zwXdD0DM/+JsIHyTOT78Ppdw8cKHnN5OPoOGqXZgNkBzYelT7lbe8hrI2MK95bOfwB1+Mj5ftb1fpeAnB5EJ8pw20/5f6tPVG2N2tBfAXazpMEZ86lhFonEIKTi04iwx9V3FeRBT+jv+jlgCqE5vIgWLLhjG5h6xqkY1BmkzDr29AMra3VM+whiJuE8aOlWwaFaDnfglj7MIB6n/4kkorLJX0JWIY2y5EsG/60hy6/3VbAq0Ha0KJukPHLTPH67/MwCt8FBy0xKFKPlfAKHlVvaRVPN3PBKDKB14cRSefFw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SJ2PR12MB7847.namprd12.prod.outlook.com (2603:10b6:a03:4d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Mon, 6 Feb
 2023 05:12:44 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 05:12:44 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     "sagi@grimberg.me" <sagi@grimberg.me>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Aurelien Aptel <aaptel@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        Shai Malin <smalin@nvidia.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH v10 00/25] nvme-tcp receive offloads
Thread-Topic: [PATCH v10 00/25] nvme-tcp receive offloads
Thread-Index: AQHZMaJKgDbK8tiYn0yiMjWAx450Qq62iZaAgArmbYA=
Date:   Mon, 6 Feb 2023 05:12:43 +0000
Message-ID: <e4e8e322-4a08-8993-0ffd-d9c58833923f@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
 <20230130064523.GA31758@lst.de>
In-Reply-To: <20230130064523.GA31758@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SJ2PR12MB7847:EE_
x-ms-office365-filtering-correlation-id: 60f96e40-1173-43f2-c17b-08db0800c74d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8OlJua8Ft3XQ9WNeeRVsVzft2OQcR6jUui4Dv8mTZhFja0+hwvCEQ/002cL8Zou9RgDWwioZvEpyboE7P6zoU3vS26yrGU/ZzvICVPe0+K4HZlfvt/xauNjGv2GJhgLRTVdK86xubMSSTpXRS6dUZa8h6gJxDQDBxmSzfrXVW8lBzbtTOHWO7vCQ/NYNZygjU8X1bsr0Ld2eaF8bCZcYq2+JMNsjn442vYCbaM1ulJ4o+olM7Z/Li5Ya70zPQcLs0FuT1su1uy8DgXR2ofze51jQuDqdl4p0Q5QqKPB90ZYWLgKo2tqLxO6nrqpdoxoa8Pf5FFHDbDTuD4/x27zWGwMqfy7ig2YbzG+r77CnyS32LI2PGtFpRhaYkpIzJW70XcnXe5vgCH8lRhwCPqysjGjsuJWPlH37E0YvCTz0Q57X3pMQ4/nQgBBlY9BfpkUN65wlWMFyyB1DU6VfZuFJ1WCA/aToi1NbWFClWQRVDRpRafqh1UubrX/TAGaSN3tE2CJrinufUVCkNSvioCG17IXdSp5nXt8J3i5bYN4Mw3hJ6Aa8EbYvUYL+Zr5X/bOkEjZa1tyx2GlqBp4waADNHM/N3+fS2wlTu3qk0o82v9oOTKKDiQH8KQndUQTG3/MN4qjOP40dk8jcCXf+7gJt9SYB8pfScc8N9vqrRwt+KNeFo91RABvh1dySeR1k0ZrwsNMlJ+aIAQ86djzxftM9gK+C4QcnNTimH0M4+NZNqVnwfKZ+YcBZL5rn0OmWY05BKs/7j9wbXkWY//pn+QXxCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(8936002)(31686004)(53546011)(2906002)(6506007)(7416002)(5660300002)(6916009)(41300700001)(66476007)(66556008)(64756008)(558084003)(66446008)(4326008)(76116006)(36756003)(54906003)(91956017)(66946007)(2616005)(8676002)(6512007)(316002)(31696002)(38100700002)(71200400001)(186003)(38070700005)(122000001)(26005)(86362001)(107886003)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0hIeTA2Yk1oT3RyUjc0dVZWeHVtUWtseExsT2d6VVJQMnQ3S1NNUjJRcC90?=
 =?utf-8?B?N2RKQ2NYc013UGRTanY4TExFS1dFTmFnOVBpWHVodHJiR053MzBKMUthRDlM?=
 =?utf-8?B?VjNhSmt0Z1d3VngydjRIVXlqdWtnMkZTMDdCbEFYcjF4MDVObWs2U0pIM3ZH?=
 =?utf-8?B?eEFoNHpiRUJYY3NvWUI1T1FRSVdWR1BpUVk5T094RGU3SGdRNUtYMkhiaWl3?=
 =?utf-8?B?NjFvWmRQQndiZXZ0T2Q3NjAzZkc1MDNEQUxBRk9QSitZRkl2MDFhUjhITmdP?=
 =?utf-8?B?d0pmMHp1cEJJZHlybTFHZEJBL0NNV0dXU0J1cUwyWjdhbUhzZVRGTjcwWFhF?=
 =?utf-8?B?MExtVFNNeERQaW9mNGczR1I3THVDNTRHbmNFcmxPVmNpM0xaQmM1U2pnSFJB?=
 =?utf-8?B?RmFOamR0V2p4QmV2MThJR25KcHlOd2xXYUxwVGRPUWpxc2RmNU1vUDJDSE55?=
 =?utf-8?B?YThFUmJyZ0Q1WHlPVWtMUzZHbStDRjNsM29CQndLalYrT1JhMmR5MWN2akJu?=
 =?utf-8?B?bi8yNXVlKzg2aWpGZ3FJS2p6WFpMVzRjd24wN0NIR0RHeG56QVExNHZEUXJN?=
 =?utf-8?B?c0UyZCsrczBIVFl1WnlTbWNtVWxpY3VyZGFlMC8vU2R2SnBuY3Fvd2hZZFU0?=
 =?utf-8?B?N2N2ZnFKQlFlOVlLY1lsQXZGMDJSVUVKRklUQkEwcWozeDJUTlFLWjRGS0pJ?=
 =?utf-8?B?WGtRd1NyMGJDUVVWVFNuOEhtSU5kZXBZQ1ptRlBLTG44S0twTGp4MUx0ZnpX?=
 =?utf-8?B?OE0yWmlrWFlQaEx4Q21rbWpFVUl4SnIxZXR4M205T0lONkd5NE1aYjV5b2tW?=
 =?utf-8?B?QkpCUXkxbUtBcHVMTHFreEpKcnNlY3ZpY0ppYlpmYUkxZSt3YjJxUk9hTTd0?=
 =?utf-8?B?elp5UlRRWXc2eEtTZ3pnRU14VFN4SXY0QnIwUmt5SkxYeE9ONW11a2FraVBJ?=
 =?utf-8?B?UzVuQmJ5dHg4WHJZcGZ4ZTU4aTNZSERMSHVBWTVsMlNUdTJYZzZJcUEyM3h2?=
 =?utf-8?B?eGZRa09xODRQeE5MR0FVY3FrUFAycVFURWtHOEV4bXFPV3FOM1ExU0gxTVo2?=
 =?utf-8?B?WUM5UHJoRkpieVNRRFk5TkJZdzRqRzlEa3pPQlZTQnl0SE1sd3JFaDh0ZW5M?=
 =?utf-8?B?cmp4MHdnaUIybFFWQWJVblUvTE0rd0dMTmpWWHBDTXdHT2xsNHhtb3pOWXo0?=
 =?utf-8?B?a0wwbWppZm9FQVhxdWZsK2JDRHE1aVZsdklZK3VveWF0aUNla3ZucmdqZFNR?=
 =?utf-8?B?czFMOVJrK0lUbFNtb25hUmluN2lvbGFqSVZFazdXdHdLOTY1REpLNHdhU0Fp?=
 =?utf-8?B?TU95Q3dDSENaemxVWEFwYW80UUlvSWtEcU5hOGJFdGphRmVnSVRrZnEvK1lX?=
 =?utf-8?B?QTI5emgzVzhSTW5xcERmU2orYlU4ZjdMN0txdkxNZXNGVkpRRXI2eW9IM3dG?=
 =?utf-8?B?RzdobzZRZUE5QU9WL2tsKzlUVXhtVHhrbURpVFFjRDN2ZXkyR0FJK1hXSm5x?=
 =?utf-8?B?aHgwcGlXQmRpU2JEaTcwcStkOVNrd1FYb3RvM0VyMkhtWm5XNGhPRVNEdEtm?=
 =?utf-8?B?MU5YSDh0OTk5ZnRnb1dPVnlMSTFlRlJWMFhqQUxOY0NWUU9pbTRPQytTQXFM?=
 =?utf-8?B?dzhyUHRJUlBnK1NnUCthYkg5UjFLTHgwaDlNTE56bm9teVBMMTl0anFEY0du?=
 =?utf-8?B?VHNPWm04Tm5lbDRocW1kOTBoSzh1YS92dEQrZzJQSVJ0alNTWndNdTFBdTlS?=
 =?utf-8?B?THFuTHZ3Q3pLakxlZTM0S2ZUaTJWdE53dnFOejRPZ3ROanRldXJDcjh1cHNX?=
 =?utf-8?B?ZEU3TGhBSlVja1YySGhMeUhHcFlreDJHT2JsR2xKQ1pIQ01jU2Z6aWRGT3cw?=
 =?utf-8?B?VnpqRGp0WnB1VXcxbFVBL0QzVHArM3p0enpHaFd5Vmo4bE40c1RSL05GZUVk?=
 =?utf-8?B?VG9RRERlTGg1S3lUZ1U3OUNrMTd5OEx6UmV4ZWEvWk85TWRuRzZRYWtsc0Jh?=
 =?utf-8?B?UnJ3ZjhVem9HcHhhSDJPcEhxaGZzWWZ3V3p2eFJOeEM3V1pOVjBlZHBRZ043?=
 =?utf-8?B?UFVIR0FOWk5haE1USlQvdmZBZldjd1NSakhTUGRkMjNtOUo1MENhWFd0RkRx?=
 =?utf-8?Q?R8r8Ov0n3tAeUYOoQHH8gUyQ2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9997F1A658A6345BF98C12DAB533659@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f96e40-1173-43f2-c17b-08db0800c74d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 05:12:43.9684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Quu8OBH9hmP7ZQh0r2eeRJiox80gSNhqSsTH31hPkwU8WMYQgFwrSrfgVZ0/5dFj968zqlOB5DNSZNl7/3ocqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7847
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2FnaSwNCg0KT24gMS8yOS8yMyAyMjo0NSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEZZ
SSwgYmVmb3JlIHNvbWVvbmUganVtcHMgdG8gZmFyIGFoZWFkLCB0aGUgbnZtZSBzaWRlIG5lZWRz
IGEgc3Ryb25nDQo+IEFDSyBmcm9tIFNhZ2kgYXMgb3VyIHByaW1hcnkgbnZtZS10Y3AgbWFpbnRh
aW5lci4NCg0KSXQgd2lsbCBiZSBuaWNlIHRvIGdldCBzb21lIGZlZWRiYWNrIGZyb20gU2FnaSBv
biBWMTEgYW5kIHNlZSB3ZSBjYW4NCmNvbnNpZGVyIHRoaXMgd29yayBmb3IgbWVyZ2UuDQoNCi1j
aw0KDQo=
