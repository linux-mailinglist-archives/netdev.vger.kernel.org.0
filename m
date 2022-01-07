Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FEE4870D4
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345613AbiAGDCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:02:13 -0500
Received: from mail-eopbgr60093.outbound.protection.outlook.com ([40.107.6.93]:64014
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345500AbiAGDCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 22:02:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUn0ZvWx7HkBxb0yWTUmd2BJlUIgZgJKEuF3hKL6NM5PBpJT7Gsm9WjhE9O4HyNLAjId7Y/p1NysVuSghcMsl6b2xc3OOt7AJy6B4TE+8a5JlTW6t9xTiFNlmsT8Y9WQ5hrSQYlDTVcMu7CYBgN3ZaCACidnBcPdnxmjxz9KcIBd1J1SR9+AtHgwEiE+TRar81fD299MO9Q03oDaxD5P4NKWiTmy/TF/NLQKZqrsd6QHwVAotaPS4vtWCZI+sH/tyYRH6iOtbn7u0TS61cUvGkTIXz6cpUlus5k0OKjuRYobddLHcx/9y8sKc7PkUGVulfLSeuqKr6p1QxC57OqxUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fV9uj3b561oeT8oucz6QXL3SHa3Sd4xsoIIhmXRNFp8=;
 b=Dng4KiAnfcdTFll/D3kgfRHecz1VQO16cm1ovcJofDJLAVbKv65+4k5LXZLslK53fmANMoLHuG5x7xpKUZlaOAu47tt9zQhXp1L64dbmLLgvEg7eb/oNaUpEtVLF4NDsUYB885I/DsOl0WFNQ+K1oh2M0WYAeX1GyFul7705seSE+EjMGOSHol/dku9ZZ12bX6OQBxZghnf0mmrhkisbtVGprZwyVNB8FfW3A8G9QcTGlEA9QdJUzPAYT/dwihbeThpfALXHgccCybOrQpQknDfgMP0LRiRG9PzCKjHunDWMSrfW4jNPMNMH+i+myVbvL4UkRBotfCkvxlXIVes/AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fV9uj3b561oeT8oucz6QXL3SHa3Sd4xsoIIhmXRNFp8=;
 b=XecbirW6C+LuYMWGyU43ihY3J0aGMzguPHKFcBAp2DQgUm4lxe0zarSdsd/xTuoCW4Z6Bj1AmliGMfPfcQVN9J/g6FNTfKjXTOnIrmhVSkYbgHAft6EjqkBUTXGsTSLpwklKY0TZUVRDxXVGsilaPHyByqkVOYII98wfvPNoQ5g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1316.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 03:02:10 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 03:02:10 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/6] prestera: add basic router driver support
Date:   Fri,  7 Jan 2022 05:01:30 +0200
Message-Id: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5746fb80-7607-489e-d972-08d9d18a1892
X-MS-TrafficTypeDiagnostic: AM9P190MB1316:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1316084C4870511DFCD17B2F934D9@AM9P190MB1316.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XmXmxlWNXbawvTsDvqsINUIrhK6xW8rpZtptx7LgavWqopC5gZg9VmUxTvpFrSV1ghu8e+YOJ0Oa/wqP9c0kSankYsx9dcJ3X5grAxBh9Bqh0yg1ijOT7x0ZRDtx/XpIULvEQQtLDgZ7w/XbH7P7DLmAS7EwNW5P4Q8fYA5snJy1w4Yu3M5owVevHOqjLHj+/vxXnnQ6eU1jSnu/rRZT3WwrnfUegelQuiuDDVuFtkIYQj9FszhABfaDvkcRR4c+Y+xnRsvmTJDgoyFJa5DqHQ4XkfokLwGsPvXZDw9DCQa7NkHg1SQ6EVeArOGGigjxT05FKTBworqcYZOm5xw91+h21H6h+fgvN6g77ugqtr7pwXX15Fk7BzLB/IBTsyRRPDJ5hq2h+hRkrXLS7aamD8ipMP+8aLtLuZolh1gJTmxrK4x+yr4Jtws8h3oCJTl3AQiDcHuMOzk6+GWybAUegb0mRVhAzVCpARLFW1zMqwIQ+/5uan7BoKMmy+7eKQvSkkJfkP6uXSPKSBfdY+qFH029qnEhbJwrlX50nXj2XQ310xpZTJJcgCS9l4ZnnRR7i1LriOAURv9v/Pvm6g+QhcEb948+W1TY/s2veCn0UtVRFVItIG+bWZhU1rNnJ0hNe3kV8fsBZV1ykYZwFaovg5L4ZhWF1PTyAh3zW7qHgF1YyxosYChghK3mcLze685vQd6OnEqYZ2IxnvAQWkT9gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39830400003)(38350700002)(38100700002)(52116002)(508600001)(316002)(66946007)(66476007)(66556008)(2616005)(6512007)(186003)(6506007)(26005)(4326008)(44832011)(2906002)(5660300002)(6486002)(6666004)(8676002)(36756003)(8936002)(54906003)(86362001)(66574015)(83380400001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hbn6FA10IPUxWRu4oanPPGheiGcfPlaBWVa5GGyVSZ86iwplGgjwJ+PXSRZS?=
 =?us-ascii?Q?SzTAVNAgqqqa/rHHVDo+yV8u3gVbcEWCKwYKk2zczWniU4zhel62P6mEZPZ+?=
 =?us-ascii?Q?nkK9NztAIBjdrTL/i+drqU5Qed7Q4ll7aRXNGQRjmVghLB9CzHhFBs9xCct4?=
 =?us-ascii?Q?q+scofo6od+LK/asoc+XhNnuQMaIzZz+GOCu2FjFOXi2eSulpsx7ROe19IwH?=
 =?us-ascii?Q?lNaqLA9CDvagErpsT7lQR3C6pGqds4qyofceeHubiIWNUAEEE7Na7DzIfIdX?=
 =?us-ascii?Q?HOJznvd4sVU2Uaz3mxiq+pPjiCxUGTkpnzhWRDilRHR8Q9I0FUSNU0P1U4sN?=
 =?us-ascii?Q?IS3ZK/3s7EZu0vZwNsAIW6BibQnQdkvbo6O7hiVGitTHWHsK7CAmDA4doZji?=
 =?us-ascii?Q?L0BNmS8QuyOORlIixWLsYZ7R0ovZMSus1afRyCxhOsm3VriUnnQmwjM9qiwl?=
 =?us-ascii?Q?ESdILGz9K5JY/Bv7svO0nBb4hfw/d2EoH882oaayVnkBdZRR8YMDdGPxaf6Q?=
 =?us-ascii?Q?vT2rKey+qU516340dyujHSd+a+x+0Xu0sjQwHOlNDQIj76xGxlXtJAjtL5oH?=
 =?us-ascii?Q?NOaKK6iLxGVgHPu53+CwtkowM43wlhShYL5eiHbCLCagXHPAsyYcfu8vVO9H?=
 =?us-ascii?Q?3dXi1mAgQS80iK/MzA4Jw2WD7PH+lwt178WxyZqzRHRMMTqaslbB8uffZ2IN?=
 =?us-ascii?Q?Q9bI5KJ2nTLSQfGXjxtICJ09LmstaFSKqcyiz+h/53i6Li1lALbWe/WdWemN?=
 =?us-ascii?Q?xfWs8jzHHkhROJU6+eH9LX2RbE7he4Ior5bb1qu1iG+fTl/zkjLeaiXWl6Vd?=
 =?us-ascii?Q?A7LepuZsPPzUE2NoYZ0DZq6UAPb5BPARHfEH2uT34CmOnj5wTFjamQ4hTtKW?=
 =?us-ascii?Q?Yz2b2boDsLFzAJa1byI9yoWH6/2NdFOaU6C6KN9iUKpZB9e31CUMWw3fsB4l?=
 =?us-ascii?Q?QB2wkE5xSb20HmbXdYf4mON+jIpCc9D3v4SAN9lgYWZi6XrZ0PjthNlfBQZS?=
 =?us-ascii?Q?EiZYM6ieenFHr2vjTNBfjqdBITnpGAoWZBragmc6pgScW54w8tFIsDASohv1?=
 =?us-ascii?Q?5M1eM4Ds49PXTpY4iqk1ce732P4ukp7muDCYJfOpvUDjNJrHXYUq60yOs7wI?=
 =?us-ascii?Q?gsWd0VWo2JED1GD+OIWwquCEnp6zh+/cSzI474CCOjIMzM7wt3WQxw/By1mf?=
 =?us-ascii?Q?AsOImkH172NmcmyIYu95MoaHzMyLmCaulmSxKZGYkESBWUE3ezOjdnMVEfW/?=
 =?us-ascii?Q?t9y1zn/BxM2XD55DYk43IY2crny5PmtpINSxF5DDyNXKXEjes4BsS1kgFXsG?=
 =?us-ascii?Q?gXxyIyrfzwzIw9YLkaVd+EWJNpzWDgZ6X1SN+MGmokf3GLP398PCQOd4SQy6?=
 =?us-ascii?Q?y/74gVVSymp7TO7eIUpMcxMuL5VR7w1OFtYQDetPHBNqw6eRHv6lH8agWKnt?=
 =?us-ascii?Q?wqs0gdKg8srJnCMWiZxLyNtNxoze2BbcN9cs6lOfgszcxi3kJp5KozvuTcGP?=
 =?us-ascii?Q?yPFtWqBVjpzDtuMfizyPUm6h1DdfYd38J7l5B+TgRZwYYeizO6tJaBoQZYNp?=
 =?us-ascii?Q?knvBzX4XHyM/PgeylQFv43CBke6FixQsHUOelPdB4Y7SRpYXEKJGH7Hs502O?=
 =?us-ascii?Q?/i5/+Sg3ZGViLu0lULKH5bQzCBdqZuc/QsSTys17ElsowSi7F0trJWk5JACt?=
 =?us-ascii?Q?mZiw+w=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 5746fb80-7607-489e-d972-08d9d18a1892
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 03:02:09.9647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GPXlZba5tQwmHgHY9GmFS3Lw0dKy/yu4wcMmuVEQ/aCaOcJmtxyqLHF5zuN+ao7nnY2WsFyYjrMFLuGq2lL03uUl4SYqAPriB6TxDcQIKJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1316
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add initial router support for Marvell Prestera driver.
Subscribe on inetaddr notifications. TRAP packets, that has to be routed
(if packet has router's destination MAC address).

Add features:
 - Support ip address adding on port.
   e.g.: "ip address add PORT 1.1.1.1/24"

Limitations:
 - Only regular port supported. Vlan will be added soon.
 - It is routing through CPU. Offloading will be added in
   next patches.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Changes for v2:
* Remove useless assignment

Changes for v3:
* Reverse xmas tree variables refactor
* Make friendly NL_SET_ERR_MSG_MOD messages
* Refactor __prestera_inetaddr_event to use early return
* Add prestera_router_hw_fini, which verify lists are empty
* Fix error path in __prestera_vr_create. Remove unnecessary kfree.
* Make __prestera_vr_destroy symmetric to "create"
* prestera_vr_put/get now using refcount_t
* Add WARN for sanity check path in __prestera_rif_entry_key_copy
* Make prestera_rif_entry_create followed by prestera_rif_entry_destroy
* Add missed call prestera_router_fini in prestera_switch_fini

Yevhen Orlov (6):
  net: marvell: prestera: add virtual router ABI
  net: marvell: prestera: Add router interface ABI
  net: marvell: prestera: Add prestera router infra
  net: marvell: prestera: add hardware router objects accounting
  net: marvell: prestera: Register inetaddr stub notifiers
  net: marvell: prestera: Implement initial inetaddr notifiers

 .../net/ethernet/marvell/prestera/Makefile    |   3 +-
 .../net/ethernet/marvell/prestera/prestera.h  |  37 +++
 .../ethernet/marvell/prestera/prestera_hw.c   | 139 ++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  11 +
 .../ethernet/marvell/prestera/prestera_main.c |   9 +-
 .../marvell/prestera/prestera_router.c        | 185 +++++++++++++++
 .../marvell/prestera/prestera_router_hw.c     | 214 ++++++++++++++++++
 .../marvell/prestera/prestera_router_hw.h     |  37 +++
 8 files changed, 633 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h

-- 
2.17.1

