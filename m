Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC9B33B421
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhCON0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:26:16 -0400
Received: from mail-eopbgr700067.outbound.protection.outlook.com ([40.107.70.67]:56801
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229602AbhCONZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 09:25:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fE+5oYpb+tWkYgkvvd89AT04QelJfbBBeRcpjmMcrGmNMaL/EOfoYIy9JxGcf6qX6zc4siVN2xJ92X+aT7AhWJX4/yz+yiPkz9HmyGiXZyHgdddCn4we5XPYUbVs36JY600ZVjSbVURhV8KP/b+bdJ0wAkz3YSSusfb9aQJBgQseLWOA6sZN2tx8BP9KGEMQJl+lcNu6JpN3IJLu8llQD+sSJ879rvvlVttQ69UnyGAvaXucrWlQte89kdEsLm1/f0REfLFk4qrQDNMy7r/bbFcSpmUVHwMSO4qYXw57wa1goBwFcMOAK7tl8h1Zjn25iZqyMC4RmxZ1Naqu92n8fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1LoP48ZGSd2f1U07K/MUUWnOqW+uQqKdD4TF7rzSgI=;
 b=jl8kSiCtvWKVKLwX6hnBFAJuLIVHIuZ9FYREeoa5XJ0HJxizss0qzA7IpiDtxqQFrmcbal2e+6IHVJuMrr32JIZPYE3UxmrxZwSbCY2G1V9mqUSGaYCeSpQdTaQe3Pr2aq0lqa/DoL5BzqlGFGNlkWr/iBAB9X58T03qoLd5i//Pfy/wuygba7U1OJjNWoAuxrzW/0wwAmbMwL8X+0TzO86AN/LCwLFahP4cEu9yyFYFatjrAzQk4BBZ52+J/imfcq478h20Hrkc9Zn7BuxACOr0d9CugkV+KJhQESm1dLkL16dG3vPNA5nMtM8usKzkM/5M7rlwNSWnncVldyWnhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1LoP48ZGSd2f1U07K/MUUWnOqW+uQqKdD4TF7rzSgI=;
 b=e1Jj1SSiIkq6LZ2G4GNUoI1jvhpYdNbQaDWhX+/5g5TrK4feREbHo8fY/FHS5aneCulL9m9GGud72ux4oWmbXNt1HsTse/253Ii4HMZlBtqjtgXdWtRqDVMeXCxjgA5WRyVHxLAhkOtGXKQ6IRpyqjFD2/A3cVM3fEE7Bkk3KDU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 13:25:39 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 13:25:39 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v5 06/24] wfx: add bus.h
Date:   Mon, 15 Mar 2021 14:24:43 +0100
Message-Id: <20210315132501.441681-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: SN4PR0801CA0014.namprd08.prod.outlook.com
 (2603:10b6:803:29::24) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Mon, 15 Mar 2021 13:25:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66f883dc-52e2-48c3-61f6-08d8e7b5d305
X-MS-TrafficTypeDiagnostic: SA2PR11MB5099:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB5099896D6BF9F3E619AE187E936C9@SA2PR11MB5099.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHPfcwLN4JzhKqGyNM82hwpHgzI7z6gka2tqrOoUgIGNqaO7VZY2VziWU9VKbaxTgCP/QeU13VGZ8SLe+anCGSMeTcAlnbPsIYoo6qp6bp0dO3SSNlr91VChFpJWJuShZmkNl5woLLCgL58KkK7tLgkQ583ql9TjJ/PYTfnaTzaH5Q3GogWKjdXxbnfHWBj+UOPYFGTU/eWdHMvWGvP9BKAU/aYxOSbhgc5fU8iury/AwPRKSRkjSf44OjWUQ9D458pNLZIoNTgrgoNi5DTpzqarQK6wv9uwF05jJKojG6bLYW5mEE5F5AlKvu0otg38vs6BtFBA7E2d/8KTv0nwahf9Fq1NsmgZrBlDSBy65aS4JvzLlLhHb5EfWJLJkNTUoMtkeQgPfi6JDXPJP0xmJ7wsAvIKy1Jl51eUU5hLD/5MrpFlOi7G7bEkOACjK01xd/omZtcGZ3t66vVd0zvAe4GgYM+EQnJc08QMHJYL3fhUUI98867HWztnodIP/x9Dku5k6tN/YLm7/TfFdLJRxvl1c4ffpomJtT2cPGzSjbeESDmoe8zpDHXqhpfq8wEE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39850400004)(376002)(366004)(186003)(7416002)(2616005)(107886003)(4326008)(478600001)(83380400001)(16526019)(66476007)(86362001)(66946007)(54906003)(66556008)(8936002)(316002)(5660300002)(66574015)(8676002)(1076003)(52116002)(7696005)(6666004)(36756003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dE9Nc3NwaEJGVTY2NFpCUk9pcXYrNElKcHBHTmhJdk1lSkVORUNLbkI3bUgy?=
 =?utf-8?B?WDdmSFMzR1V2bUh3WGJlL0N2NlpPRWtwa2pUSmV4NmdLNFBsTWRBZnJoaUw0?=
 =?utf-8?B?dXRCOUlzMjNGdExFTHZTUEJxNnR0bG9TeEtlOGFFanJ2MU15WmJkNDdBazQ1?=
 =?utf-8?B?c3RSWUs2eDVMeXJ5ZkNDcDF1N1BOS3JkZTlMMVdnQS9sMzdLbWF6MGgybFc3?=
 =?utf-8?B?bnJzdzNyb09UaGZ6OENscDZDd1NCSG5qWTUvKzJoakRZaDdvZFpGVWlUWVhD?=
 =?utf-8?B?eXdrdktDYjQzdnY0eW1mTkhHdXh6N0orVEtXM2pVdWEzMHo1YUJycUplZDVH?=
 =?utf-8?B?cmdBUjVmWHF3TmtzamZIWDRHR2JyREFmVnBOTmNkajBVZmpyNGRvMmVDT2wr?=
 =?utf-8?B?cDVtamE2UTFnRGdNM3BYT25OT3p4ZkoyTGRMV3ZjN2dIVFNlRG9JRVZ4Y3ZV?=
 =?utf-8?B?LzBLTnIwWTduMG4zRm4zVnZYcGFCWHY5Q0k5ZGxZZDhCNkVuVEt5SDNOTE41?=
 =?utf-8?B?VkNmZTNrWWZZN3hGbWlaclp6SVhldCtyZ2VDazlJaTBrb1lZdE5DRzI5aERj?=
 =?utf-8?B?cVhQU1Rud1VoRFJxMUlZWThiakcwUnluQVlTZ0dpTHRYWFVLRjJhVjR1L0VZ?=
 =?utf-8?B?MjVBRXd4c2FRYnlualUzUkdNQ3gzTmwrQlpRaElOanNzamMrdmRtZFdOS2c1?=
 =?utf-8?B?TWRxRlVXaUQ5SitmUnRRU3ZINE9Tc2UwRmlTTTNpWXRQVHpiSlZaT0V5VHVH?=
 =?utf-8?B?WGdobmpHTkFwT2ZCOVMxeWtNQTBjc1VrN214cjJnQk5lUVJCWC9uU3p4a3hw?=
 =?utf-8?B?WnNhemJVNVNXTHRtM3hXa0g3blZZdmpVNzlSTThpUTlFSkhVdTZURXlsWXpI?=
 =?utf-8?B?Rkc3eS96OEtSZGc0aEhDYUhGQmJ4aDlETy9LZG5MRStpcVFCRmpxV3dsSGJM?=
 =?utf-8?B?WUFKc2oxNUhrZ0RCWUROVEpsVXdWVG4yQkRqR0tKRUFzUUwyOXYyNEc3Nzda?=
 =?utf-8?B?N0tteFJUS2ZGSGE5Y1F0VVJOcFA1MWlVcS9OTGRIdnlXd0FZUE42T1l6MXZa?=
 =?utf-8?B?RWdhNFdMc0ttR3NRSDJ1TEllYzB6ZXY1STl4Ym1hcEtHM2UrTmVNMHo0NmVU?=
 =?utf-8?B?ejVaYXM3TEd1SVRYbzJHd2s1bnpFaEcxMk5ZN21qTVlKT0NPaDBzVUFiWWtJ?=
 =?utf-8?B?VlliZEdhanUwU1N5TjBvdWVyWVhvenZ5bjF1eVZXWGpuMFU3NHNuR0FmREVr?=
 =?utf-8?B?akJKSnh1dWtzMVpOWUl2U2dCNDlFZFJaaWQvUm5lWFBmRUF2ODlaMzZMOUhS?=
 =?utf-8?B?ME55MW1XUG53YVErTS9qVXRBNjJHVDBIM285dHFjWU9KOWtzeUxYNFY5NW1F?=
 =?utf-8?B?WDBtWWdOTnc4cVRZdHlUa3NRWVY4RHd1dXQ2a01nYkhHd1lEZytZWVlSczBQ?=
 =?utf-8?B?NWFJaGo1eUNtczU3d05Vc3hLN3dMUlZkM1dFNE1QOXhHN2RoZkh0YjhxSVhn?=
 =?utf-8?B?WEZvZFhPN2xWcmFtdTdFelhHeGtrNFU2aHBXZEg2TjdiR3NsckhEcnp5TXQ4?=
 =?utf-8?B?RGxOZ21DWjZQVGp2Uko3TzBXYWZkTlBuZ0ZoZEZYVi9oR2NLVGdvVVZLcnBN?=
 =?utf-8?B?aExUQzFVZTV0VS9yNzc4YmdHTDh0RFFBT3MyQVgxMHlYUkdMODRMakVjZWMr?=
 =?utf-8?B?MzFWTloyL2xNWGhlSEZsdDg5N29VUDVURWdVQ0FDNlpwY3dlYzZYeDZXSmtE?=
 =?utf-8?B?M29DVDQ5VFJ4R3F0QlJReC9IOUZoUzZsN1ZURTJLeVN1c2dHa1ZKRmNQaDB4?=
 =?utf-8?B?anpPU3JiQUs1VU5TaUUrb1ltdk1kdkJYUUdrSjM0d0NZMjYrdUFDb1ByQjVX?=
 =?utf-8?Q?yw7BBvB5Bhaef?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f883dc-52e2-48c3-61f6-08d8e7b5d305
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 13:25:39.0855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iAbc8acNpYzeiye5uNBTvIsvSqp/A+6PtsMKZAqe0bSR1YwJirWubRUdUsxRvytXQ4ZY88V5h+X2R9QZgDgKxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggfCAzOCArKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaAoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2J1cy5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0Cmlu
ZGV4IDAwMDAwMDAwMDAwMC4uY2EwNGIzZGE2MjA0Ci0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaApAQCAtMCwwICsxLDM4IEBACisvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogQ29tbW9uIGJ1cyBh
YnN0cmFjdGlvbiBsYXllci4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTctMjAyMCwgU2lsaWNv
biBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwgU1QtRXJpY3Nzb24K
KyAqLworI2lmbmRlZiBXRlhfQlVTX0gKKyNkZWZpbmUgV0ZYX0JVU19ICisKKyNpbmNsdWRlIDxs
aW51eC9tbWMvc2Rpb19mdW5jLmg+CisjaW5jbHVkZSA8bGludXgvc3BpL3NwaS5oPgorCisjZGVm
aW5lIFdGWF9SRUdfQ09ORklHICAgICAgICAweDAKKyNkZWZpbmUgV0ZYX1JFR19DT05UUk9MICAg
ICAgIDB4MQorI2RlZmluZSBXRlhfUkVHX0lOX09VVF9RVUVVRSAgMHgyCisjZGVmaW5lIFdGWF9S
RUdfQUhCX0RQT1JUICAgICAweDMKKyNkZWZpbmUgV0ZYX1JFR19CQVNFX0FERFIgICAgIDB4NAor
I2RlZmluZSBXRlhfUkVHX1NSQU1fRFBPUlQgICAgMHg1CisjZGVmaW5lIFdGWF9SRUdfU0VUX0dF
Tl9SX1cgICAweDYKKyNkZWZpbmUgV0ZYX1JFR19GUkFNRV9PVVQgICAgIDB4NworCitzdHJ1Y3Qg
aHdidXNfb3BzIHsKKwlpbnQgKCpjb3B5X2Zyb21faW8pKHZvaWQgKmJ1c19wcml2LCB1bnNpZ25l
ZCBpbnQgYWRkciwKKwkJCSAgICB2b2lkICpkc3QsIHNpemVfdCBjb3VudCk7CisJaW50ICgqY29w
eV90b19pbykodm9pZCAqYnVzX3ByaXYsIHVuc2lnbmVkIGludCBhZGRyLAorCQkJICBjb25zdCB2
b2lkICpzcmMsIHNpemVfdCBjb3VudCk7CisJaW50ICgqaXJxX3N1YnNjcmliZSkodm9pZCAqYnVz
X3ByaXYpOworCWludCAoKmlycV91bnN1YnNjcmliZSkodm9pZCAqYnVzX3ByaXYpOworCXZvaWQg
KCpsb2NrKSh2b2lkICpidXNfcHJpdik7CisJdm9pZCAoKnVubG9jaykodm9pZCAqYnVzX3ByaXYp
OworCXNpemVfdCAoKmFsaWduX3NpemUpKHZvaWQgKmJ1c19wcml2LCBzaXplX3Qgc2l6ZSk7Cit9
OworCitleHRlcm4gc3RydWN0IHNkaW9fZHJpdmVyIHdmeF9zZGlvX2RyaXZlcjsKK2V4dGVybiBz
dHJ1Y3Qgc3BpX2RyaXZlciB3Znhfc3BpX2RyaXZlcjsKKworI2VuZGlmCi0tIAoyLjMwLjIKCg==
