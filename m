Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2192D3975AE
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhFAOoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:44:12 -0400
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:4992
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234126AbhFAOoK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 10:44:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uonK+sA1hxPenpa/2KzxhZzMekIAA97T9ks6fxUhq3k=;
 b=bVdKdsvJye9QMzbXgPgx0bOj11penk1wyuw3R9FZdhp3hb5mEIc2dd8Af6hTch3uOBj+pzglDRloHPhPNzcVwGJAiS5xNLOCMfthsNrMEy0iBC9OeBDnXEj/V6/YJR/vSVAtSkTy9EYg3VtOWiw+yU39RIL53wypB5RtOhMnOCc=
Received: from DB6PR1001CA0048.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:4:55::34)
 by AM4PR08MB2627.eurprd08.prod.outlook.com (2603:10a6:205:b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 1 Jun
 2021 14:42:25 +0000
Received: from DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:55:cafe::7d) by DB6PR1001CA0048.outlook.office365.com
 (2603:10a6:4:55::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend
 Transport; Tue, 1 Jun 2021 14:42:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT005.mail.protection.outlook.com (10.152.20.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.30 via Frontend Transport; Tue, 1 Jun 2021 14:42:25 +0000
Received: ("Tessian outbound cce4cc55b7ee:v93"); Tue, 01 Jun 2021 14:42:24 +0000
X-CR-MTA-TID: 64aa7808
Received: from be22757f6fc0.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 8D31B971-B7DF-4258-855B-8F5BE4E47E05.1;
        Tue, 01 Jun 2021 14:42:18 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id be22757f6fc0.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 01 Jun 2021 14:42:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBBxnjV7UAcJtKb4BVLFOJEj9G+ujawIn+0M7wIVvUn7nAjRKgHewcyGGMN7eoQ+87mqXqZllG94TShiB5aQXnZp3PxsMYt9Xj92hghT0UEEsZRnSoISNbKNXYg4CsUZyIpcM6Ojc2ElUKgZJ5sBsg+h/A28vLpYWPhM2SBAiiuomLBXQvlNhaaP5Dmcp8gQ/5Ydrh0wdyZcoMp6QLjVcK9A06jyLN709S7HaK547pzjKEQj8wBgYEIF99PjuOjYiE9IQp2inW9JQVNZlDvxlJeP+wBJB6kvAVOtEnLWQXsY9it5qz7bpcfhU40SjKlwYFmyXzN6XdcDbYwePCzNQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uonK+sA1hxPenpa/2KzxhZzMekIAA97T9ks6fxUhq3k=;
 b=CiAHEv2yrI2d0kcRdeO6E2SkniLzLKjaMIIX4tYEWR1WRD+fjQYFbKTaE6JBpYZwlIH181XrYE5fs3RmXslrpqaBdqdzgS7GB8RRlQhz3iErJ4ZRHOJYZhTNizNisuYKIUAIhsB0gWNrdjJQcELAQYKflhHEIgcLIY6ln5PES9mqlqYj2zdkRBN8teW9bdkyY3oLLEeCrJ7KKyxFdup7uX9xf46ip2yz/ozijcecPkn6jom/RNE0GbG1r/Xcj/qgnl5Ahqllzk3yqODgdyFTN6ElL+TlcXLL4gB5jesBDl4hwtgzjRfJpgSK2OSAQwPeFCRhtKosYs43B4lbRO79Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uonK+sA1hxPenpa/2KzxhZzMekIAA97T9ks6fxUhq3k=;
 b=bVdKdsvJye9QMzbXgPgx0bOj11penk1wyuw3R9FZdhp3hb5mEIc2dd8Af6hTch3uOBj+pzglDRloHPhPNzcVwGJAiS5xNLOCMfthsNrMEy0iBC9OeBDnXEj/V6/YJR/vSVAtSkTy9EYg3VtOWiw+yU39RIL53wypB5RtOhMnOCc=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS8PR08MB6104.eurprd08.prod.outlook.com (2603:10a6:20b:299::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Tue, 1 Jun
 2021 14:42:16 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60%3]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 14:42:15 +0000
From:   Justin He <Justin.He@arm.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Thread-Topic: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Thread-Index: AQHXU7ZL838wopFuOEK5GzAxNom8qqr420gAgAAQ9UCAAA6WAIAAAE0ggAAH7gCABjupYA==
Date:   Tue, 1 Jun 2021 14:42:15 +0000
Message-ID: <AM6PR08MB43764764B52AAC7F05B71056F73E9@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
 <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org>
 <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEKqGkm8bX6LZfP@casper.infradead.org>
In-Reply-To: <YLEKqGkm8bX6LZfP@casper.infradead.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: A45FDA7D321AE9498E0514E7F044EC12.0
x-checkrecipientchecked: true
Authentication-Results-Original: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [223.167.32.35]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 42f5819e-6777-4223-b002-08d9250b78ca
x-ms-traffictypediagnostic: AS8PR08MB6104:|AM4PR08MB2627:
X-Microsoft-Antispam-PRVS: <AM4PR08MB2627AEFE1A56CFA51FAB5B73F73E9@AM4PR08MB2627.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 46+AHIMhPrFI2qrbR+Gh0smbz7DDvK7TDqrQidpMTML2YO5MWFAKZaQEPVY3MTDEUzHisCRMTgspaucdhNZk2g7isT9OdFJU7v5SYzFGYjHprGqFtMNiksecauFGtiBG3Nnz7j2qa69+wU3xGHmer0EFAmpFlDPUc570DIg2klPCs9at2diZkMfehkizwo9bRzm/C+KBkF/gehdNI4m53KvRbcbIaNWAoOuLvBgJOXpPstfGwE+QjCX57dyfrTkizZh9BX8CqVBRR0+mz50uIdwafGjozEuQao/rxDcBotM5reHW058h+KEV3IzWygapZ2we5pYcm+H2fcdpqgMdDtVayyoxgDW2cJ2h/1ON48nvG3rVC6pjXJTRF9aDecjD9LIZfpC8Yq+95CPigZB/v0GnRwvjy1Yt9zG97yaM890A1Ch8EuGYp296EWHGhfPqAyyE6w5EhUR4mLVTWPE+h+qcxrJvBw49wb/I44v32jfbevn7XPQxQ5CViAiQAzVKFpGOg6SBdN53gZqwjkANdXjHfn8AQ2CFt4hHEsaJHYxITTwKmPwRNkaEorP0xGWZWsSHli42PeYqvZo8Kbz/WcxDeaJoLuTNqqbERfjRjj8=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(26005)(66476007)(66446008)(9686003)(83380400001)(5660300002)(8676002)(38100700002)(52536014)(66556008)(64756008)(54906003)(7416002)(4326008)(6916009)(7696005)(71200400001)(33656002)(66946007)(498600001)(8936002)(186003)(76116006)(2906002)(86362001)(6506007)(122000001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZhbO+H5k2Zzh4hN+oYyEEcKhFTorK1Zs3RzlfC4UAKsmlpDrhpaBPf08kJL3?=
 =?us-ascii?Q?hjs/2pmbB5AdR6bd0N61cecz8cjHPOdHlGwMQIJBWHLHkaAXtyaPYQOrw5xK?=
 =?us-ascii?Q?UMwVY+vX2sCLuRSjBwY88A86nbCXSQ+hI7Zq4btU1AEAbn5w9fqZBqYYW9An?=
 =?us-ascii?Q?fSoUBMX706NO0F6x9ARi/bU2WdzXASBIPtUHcX7JpjKh4CJPMJXI1GJ6mypX?=
 =?us-ascii?Q?bjEptVailsnhKOR7n2rUYiJMBkG7Ty1QezHkx3Rg+zyccFA/SrHkKPII96IN?=
 =?us-ascii?Q?tIzCDNQpaGYult4bjHBUYDlYAYG/ljenmzfJP6hpVm46apuGNU+kLthd8HTQ?=
 =?us-ascii?Q?6tweZHWcSVHuJfZvmTtWYTEmCRaCoCOHrFhAVbk/Duvc4w46QJw5gIIzvbUp?=
 =?us-ascii?Q?LUiTcfZn1HnM7BuIaSJiWu7gfyAAs0Ltgd+PGJ3wjzStWXQVeMvTW5scpO+H?=
 =?us-ascii?Q?A9guyun+TxNdvXAwoA67SCf5B74mqIrGJVTUy+NkaaS57cPFDRmVEsclnpZk?=
 =?us-ascii?Q?scgKb99yQXM6GB5u7LpRVN1vDqRGCvwZWlhzColw7urzDl5sz8z/VfiayqLR?=
 =?us-ascii?Q?G2P1fS7ia+c0AdvsFGmiAl2eDeq4BU91Hb3jMGW4G6AzQR4UyKNnDZY3ChM2?=
 =?us-ascii?Q?/2DJW1BKi4yf4memB53ucha44oDDd412TUHko1ZFDnoloRLp2OMlxsYcxxcJ?=
 =?us-ascii?Q?GVJjRmrXLS6NSs932rpTpfRnTu23aF83RpcfHdJGX/vWDGVSUFPPpnMDiWCR?=
 =?us-ascii?Q?puH6g00fHZ5xO2SBkIsZv3p9JfDlqcckDh/28SABN3/bjM9xBSoX778XdwTZ?=
 =?us-ascii?Q?AAT/skcfSEE3IEufqYbt/MI/61oB+BK10Zn+RD8Qdps7hWDlCx9iZtwoA2P0?=
 =?us-ascii?Q?FQ9jSK5H1bgZhtR9ILlp+ZMC+SDbJOgZPcy7rPOMbpOUr4G5kZIi1jMq9l50?=
 =?us-ascii?Q?4bqqleHwfcN0Ecm/S6T8LHMw4LI5Dhoaq01+5G4IuLSTD82bL8KWh1NdSKRG?=
 =?us-ascii?Q?shM05DIg43cb9yvQ4UHmGyr1KLa9yduqXHy59iboEwWhBbR0L0I0Fqk6gcs+?=
 =?us-ascii?Q?kavakFuZ5bnmzX9xeNYsvcMeme0NITfD2D2Z8h9AcFalhdhn+HKW7UV4pUst?=
 =?us-ascii?Q?6xnqk43gu7bysgBoR9qYBjlvtKHdDNNAXEfzx7/hZOad48yb+fiBtK5v9sNb?=
 =?us-ascii?Q?DbgkQy2IRun/PQNJKCxEchaEGtZEUivlG0XNBrUaUAlo9Xqm90wGQc6yIMaN?=
 =?us-ascii?Q?SZNoBwpWpnkiPl0XaVhNzFPIt/DA27mdnGLhogjQF9ovWLH5mqlj7/wfZUOE?=
 =?us-ascii?Q?ndFbYOqz6rXfytJeTn/gZaxl?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6104
Original-Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 77b5ec07-61e9-409b-fdcc-08d9250b7341
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKEGL6Upml6Ggy1r4bCCTukhsbaHcgXWhXTOIx5QwzBGH9Lvh7DWdVqzjB46PkyGnp8mpXzeYE8wd3L9m2tK/PSQWIX+5bPtJay8w+W8c1q5dmgmENGWL3Rxnoq7cGcIbt0MV3pXq3KAV9ZI1JKJDUhRK+uewZMNHzdpLGJhTJ8JYoe5W6WBiVAhTy8M6r+IEq1KpNkYqWIpG6/IKcOksX++aj5cuQRJyWnvq9JOmWjrZ8X9KlrSRn1RzA+BHpiB7lDxKO4AT7DKDHn+nsLXfjEYiFJosEpELkjxtxZ49QCI4KYRmkm26ExpsyAh7hqwWPzMq52MHjeY4XJ4hzmLfQ6Lo34aG2tbA5G4wo2jv8UJvPFRvQcekH5rDCZZGpgIeDL+1Npv7PEBAcwSPyntaGV69BSzWuh/4rixJm+aUvrrDYrx2TslLN5CWNGOZlD1fwune68Yeg6dNPC3dsQooguQhTzyR9VqQpjRt3jbi1tbDewl7GEp0VzJocl/d3VfHwbmrZQKLIq0555O83QcmRW6um1lbNPiZLrMyX2dhblYpJzX08f95b664D278nWtUoFxaPHYls5xWW/GNDNuxrNRhu8OVraCbTAk7MQhYcP4oArk0bo/e0ETYKKn4uMBHMAvldbYsEZkWd8uze3Gvr6rSk4QuUJ8zzxC8Dx9TCM=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(36840700001)(46966006)(7696005)(8676002)(4326008)(70586007)(70206006)(9686003)(54906003)(478600001)(336012)(8936002)(82740400003)(52536014)(6506007)(450100002)(82310400003)(47076005)(83380400001)(36860700001)(186003)(86362001)(6862004)(33656002)(356005)(26005)(5660300002)(316002)(2906002)(53546011)(55016002)(81166007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 14:42:25.0863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f5819e-6777-4223-b002-08d9250b78ca
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR08MB2627
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew

> -----Original Message-----
> From: Matthew Wilcox <willy@infradead.org>
> Sent: Friday, May 28, 2021 11:22 PM
> To: Justin He <Justin.He@arm.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>; Petr Mladek
> <pmladek@suse.com>; Steven Rostedt <rostedt@goodmis.org>; Sergey
> Senozhatsky <senozhatsky@chromium.org>; Andy Shevchenko
> <andriy.shevchenko@linux.intel.com>; Rasmus Villemoes
> <linux@rasmusvillemoes.dk>; Jonathan Corbet <corbet@lwn.net>; Alexander
> Viro <viro@zeniv.linux.org.uk>; Luca Coelho <luciano.coelho@intel.com>;
> Kalle Valo <kvalo@codeaurora.org>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Heiko Carstens <hca@linux.ibm.com>;
> Vasily Gorbik <gor@linux.ibm.com>; Christian Borntraeger
> <borntraeger@de.ibm.com>; Johannes Berg <johannes.berg@intel.com>; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> s390@vger.kernel.org
> Subject: Re: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path
> for file
>
> On Fri, May 28, 2021 at 03:09:28PM +0000, Justin He wrote:
> > > I'm not sure why it's so complicated.  p->len records how many bytes
> > > are needed for the entire path; can't you just return -p->len ?
> >
> > prepend_name() will return at the beginning if p->len is <0 in this cas=
e,
> > we can't even get the correct full path size if keep __prepend_path
> unchanged.
> > We need another new helper __prepend_path_size() to get the full path
> size
> > regardless of the negative value p->len.
>
> It's a little hard to follow, based on just the patches.  Is there a
> git tree somewhere of Al's patches that you're based on?
>
> Seems to me that prepend_name() is just fine because it updates p->len
> before returning false:
>
>  static bool prepend_name(struct prepend_buffer *p, const struct qstr
> *name)
>  {
>       const char *dname =3D smp_load_acquire(&name->name); /* ^^^ */
>       u32 dlen =3D READ_ONCE(name->len);
>       char *s;
>
>       p->len -=3D dlen + 1;
>       if (unlikely(p->len < 0))
>               return false;
>
> I think the only change you'd need to make for vsnprintf() is in
> prepend_path():
>
> -             if (!prepend_name(&b, &dentry->d_name))
> -                     break;
> +             prepend_name(&b, &dentry->d_name);
>
> Would that hurt anything else?
>

It almost works except the snprintf case,
Consider,assuming filp path is 256 bytes, 2 dentries "/root/$long_string":
snprintf(buffer, 128, "%pD", filp);
p->len is positive at first, but negative after prepend_name loop.
So, it will not fill any bytes in _buffer_.
But in theory, it should fill the beginning 127 bytes and '\0'.

What do you think of it?

--
Cheers,
Justin (Jia He)


> > More than that, even the 1st vsnprintf could have _end_ > _buf_ in some
> case:
> > What if printk("%pD", filp) ? The 1st vsnprintf has positive (end-buf).
>
> I don't understand the problem ... if p->len is positive, then you
> succeeded.  if p->len is negative then -p->len is the expected return
> value from vsnprintf().  No?

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
