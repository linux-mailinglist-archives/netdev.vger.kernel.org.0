Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AD526FFB7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgIROVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 10:21:09 -0400
Received: from mail-eopbgr60126.outbound.protection.outlook.com ([40.107.6.126]:2082
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbgIROVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 10:21:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5g84cckGrvp06PMfqrbw679wlr+ABiqO8LhkDxQGXp7+LlUqDfbnQl3e7OFjSpLEXpyxf49xRCg1EF1vzIfbuBwenEpLHnnVhU9C77/pYKC2YnNQTUoSJ3yiJVqSXE1rRJ95DPEF6GUriLp+v5+Ix8G2SO89RRqYgiG+BXVlCuUmG3zdUbQvaFs70+t1DkWS17xRrTHMkk9yYtQ5j9b59371cqkyTCHzHbs04celGtmMudAYZhx1elZoPvKeaYxAAiQNFJ3cCrwOXT+BqAb8FCtwNvFfYTVDCZ811Rm/vwQJtIEpAM1he3DxdOHwRwpFUbeyt3RL2mvzA9ZklFJCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtzCZNRgGC7Kud14PyWQvzgsejSzmJVOajvxS9+U3lo=;
 b=MlJjzr/YzXewUKjbM4yHJ5s5UV8tDbagBFo66VHRu/4oxnwv5lYbiTurIYy/fHqJdsFQDOrQ/PfdG3zmKp4DxLWmpIaNzRhOVJqsgFE7cv+lNzKG/0cbZEmPjYoW26hUV8Y0elkDzOrcZSeSyTVxbdZpNt9/MMsgrX0m5LgIHpGcCicYxHX0QhGdLixCU8kTgqumkSHcrP5tpzDFou+s5C8TeLKttGag/ScOjEA6zZlv/xBBANNuQpjulb1RH26MOq03cm2DMk5RUzE8YfeK/edo8RciKoAwBsfEwXCblpErJ9qzdAadti6WcLFtK5bp0X3IG9Zx3+wbM+KWhrjgFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtzCZNRgGC7Kud14PyWQvzgsejSzmJVOajvxS9+U3lo=;
 b=q3dMDduEgptrG8QyOqEoyvZ+nbeoP/LLiDxa/BV/01O4cSKWxEyIauwUmLqSKXAZyD/AOhVOHm3CvnVYvi8nyn6a8mR6G/Yd1fv8Gdx88a39kTXk9NUS0Ft1bCuzv9X65OQ5/HvOFdZfZ2GCXY6kLo9JB1SG2fyT6YICi4O3m+A=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0364.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.13; Fri, 18 Sep 2020 14:21:05 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 14:21:05 +0000
Date:   Fri, 18 Sep 2020 17:20:58 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     linux-firmware@kernel.org, Mickey Rachamim <mickeyr@marvell.com>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] linux-firmware: Update Marvell Prestera Switchdev
 firmware ABI changes
Message-ID: <20200918142058.GA15376@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BE0P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::19) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by BE0P281CA0032.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:14::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.10 via Frontend Transport; Fri, 18 Sep 2020 14:21:04 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81ad8d6d-b003-4750-8eda-08d85bde1430
X-MS-TrafficTypeDiagnostic: HE1P190MB0364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0364532F82C44E34CFBC1600953F0@HE1P190MB0364.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ff4NTGtsau4R9CpcS0PbZM6dVPaKAt1sqfFNcYptk0t5ktjvl0zvcphctHAqNb1FF0Zx/0+TkwEGyP0rxPIbvF3wKWCjNMitwPJceNwclTJ4wHxUj1fnlOcKoFJ3PsJhLeVsA3HFJGuH1E8d9ol3ASiNQqMlbg6S8LL2KsOMy+L4AC6wBnscNuIROTI+4A6Are8TfhHCraNzNp3Nh1yDUsLl9QaQHyqgG+bjqk2dD7/+Eh+wupfy5WPUdp1gYM442g3nnzc3DfR3hNsS1h0jn/aM3otSXQYMUxIgoWMUYaRTBMpYWtK6VhnX1bvH9GiUfEX1Olprpux7ilUR9pWT4udFyjVyMP8+7ZSskPqkpxKY9lOT4ZASLZU6bQcmPuX01UyE8LUigyNWzzOujzKhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(39830400003)(396003)(136003)(6666004)(8676002)(66556008)(1076003)(86362001)(8886007)(966005)(4744005)(5660300002)(66476007)(66946007)(110136005)(7696005)(52116002)(55016002)(33656002)(316002)(2906002)(8936002)(36756003)(15650500001)(6636002)(44832011)(2616005)(83380400001)(4326008)(956004)(478600001)(16526019)(26005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: EjcvBdfpaueVhLb5zY3qPJE72q8khIJhZjA1YRmvuye65dpEMc8MlBS6vtNkI5Wfay6QHkRI7YEx1KtKgo9lV/o5IF25eZJpdZgdqtwGh0KagjXoRSTLCDmQojR9i1YHrwOj+hL83me/OYiiDFBeUGiAYbb3BscGO/+tGZRQG+Clrg6/HCEzlaqXFXfI6lXLTmdsawXvJ/DgBQ2S0gc+d1Y4em4y/zXZU4rodUof2BwbqIJXZ4SoWvDXo0l0VIAPkc/BHiOBWvTL2LuLcSUDi5RxfsOK3eU7hDJ0ddb0+Du9pmjKXtKbvd8Z/Guh4bkVT1rZJ3cvRTZwQAWyzkurC2jrBD5qHw7NQd13KzlIvbT6sCncG1D+TTfSuY/3RcPdrjvAmPkPK90vGQ16EqxXUarw3NXt9raKXKaZCFj/BSUlkt7AUTjh3xjpP8TpxiSae1xj2d4U/A7rPrnT+foeKu0qlHZ1VfoXjyfVzF58OqbpuNOoM8lebe5AXQ1z9lxr3jZZ83SrbF5yyCIt17VHPMWK3DFlb/jxFGFtKgh3OIqplQfXHs5fSQzK7IO1p9O/B5j+MgY7aKxvMrjhVDGso38S/1tSBsMPfbcLb/lKAYqQ2DbbUZHcsKCJZRGZYHu1kPdEYnh9FMGjHg8rIneYsw==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ad8d6d-b003-4750-8eda-08d85bde1430
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 14:21:05.4877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FqkPyWuEHhXKakeRPPdIoQ8J7oIHewS2cXR/QSSaJ5H9LPxWfIsyF+n6bu4+RdRMhHMfVUBJ2ubNPD8pLNleBTPUN6ussTv2JiwQVRa400E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 00a84c516078defb76fbd57543b8d5c674a9a2be:

  linux-firmware: Update AMD SEV firmware (2020-09-16 08:01:44 -0400)

are available in the Git repository at:

  https://github.com/PLVision/linux-firmware.git mrvl-prestera

for you to fetch changes up to 7a0221265cda381b5231355965a403ca264392a5:

  linux-firmware: Update Marvell Switchdev firmware with ABI changes (2020-09-18 16:54:29 +0300)

----------------------------------------------------------------
Vadym Kochan (1):
      linux-firmware: Update Marvell Switchdev firmware with ABI changes

 mrvl/prestera/mvsw_prestera_fw-v2.0.img | Bin 13687252 -> 13686596 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
