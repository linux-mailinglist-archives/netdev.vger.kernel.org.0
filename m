Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F095D1E8C94
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgE3Aqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:46:36 -0400
Received: from mail-eopbgr150137.outbound.protection.outlook.com ([40.107.15.137]:8517
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728349AbgE3Aqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 20:46:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kA3+JwB8rstGJ8mdB5NV1TlyhUHzkF6TJFlSGcwv9KTxu3AyEO+LoGyIViJdaqhDzGviKj6TE0mfT1yZH3eRaBabQiYlyNn620Zsvqjt/UE0vxYB0eLnOxKUV6Y/AXpw8hdwsoF7jiOEYxU2rSsJ2k7plkvLER5oTjUQ4FZ+FusT9DFF6eaR5OzbpxVlDxvdEP0HvGpEiTq9AK9uIrR2RoEOlHysiNrjWWDA1/RgdBIpFNOECnmCK2Gfvo+rqgmV/4Eo1MflNr6SuQlwbZrKIk+egm+3FYb9l3o8TTYDCcccrlSRmJeYhaGne5NZ9ZiU/WKQSMG/lCWujrCqaXf2kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okzzPF7FfPLvbBPY9lG35isXGd5k67zIi+EYITBTW2M=;
 b=funGdRcTxo45Hem9VKxOvhWRD36WPi4ZgSujGdf3SkdAmxN5dij56ofTSz1QNZ21bjtFvaWiRlDWcmQmbpptHDh7/at6N+NLfKBModURJVbUR3fsJJywebGRvzmXugg9NHDFglzEi6vwiyN1ORZmiK0YnvWX4ZzxNr8O5y2+RY7itTkulJl01K5PPA5Q+q7EBXr4eH0QgwCeeIzbdzidP8Os8FU1jHwdzqaIyBKgHTYYj9LD5I8y+5Bceee5M4rBD2qhUOSv8s7rrpnMa2NUzO0UA0xuGrzyFV2Kx3CXsUUxcX0Kk+UAWUDenhheH0Brxic/jCYzHEwiONThYz7dgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okzzPF7FfPLvbBPY9lG35isXGd5k67zIi+EYITBTW2M=;
 b=qbiyap3PEKvn0hUMgs45WGXrwecRWp6Gie9EMde4pSBtR6Wy8a3unslsSWwlgWgqTF90i8SNiy1ZJr8V+Qm949WG0RPbLLm2koP7gtRLv0aBXr4yNmw4bj6huC1oaEVH8Y+SvF3AeBPK7vS3FLnSl2ot7AL/WPXbCi+EoQKeAwc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0304.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:38::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Sat, 30 May
 2020 00:46:31 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 00:46:31 +0000
Date:   Sat, 30 May 2020 03:46:22 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        andrew@lunn.ch, oleksandr.mazur@plvision.eu,
        serhiy.boiko@plvision.eu, serhiy.pshyk@plvision.eu,
        volodymyr.mytnyk@plvision.eu, taras.chornyi@plvision.eu,
        andrii.savka@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mickeyr@marvell.com
Subject: Re: [net-next 1/6] net: marvell: prestera: Add driver for Prestera
 family ASIC devices
Message-ID: <20200530004622.GA19411@plvision.eu>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-2-vadym.kochan@plvision.eu>
 <20200529.171839.213046818110655879.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529.171839.213046818110655879.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR0502CA0042.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::19) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR0502CA0042.eurprd05.prod.outlook.com (2603:10a6:20b:56::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Sat, 30 May 2020 00:46:29 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 459fdea9-292d-4307-d577-08d80432e4ca
X-MS-TrafficTypeDiagnostic: VI1P190MB0304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0304F90262230D28118CF5D1958C0@VI1P190MB0304.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WkpZhtK+Gzhveyvw6MoIJHTbz477moxSWQZ+ma6lGyBQSRPhhimUrRGIrGy+0YokCG4xcvAzZ3OKSjlC1xWePHwv1pVfSv59HHmYEXYkfcregtVBS21YCmie/yUxi2rkbVsrE7uy9lOgIo4WoYeUL6zDGWAkiiIBAJQMUYC/Vu9Km6Jm8vwKHHKc7U2Z+rlZcuiq7mnEd2llJIbmBxCdIMjLIIP8SNkZJrjX7CGIq8GY+r6pk551IW30xyed6dhSZNVLYSJGZkrGeieDsHR7C7T2pcFHCq48oEgdKcVHI/5wjpJ9M4yb2W0Iy3tVbwbyR/AY6upi8VVtrC609rui0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(39830400003)(346002)(366004)(396003)(26005)(508600001)(8936002)(5660300002)(6666004)(6916009)(8886007)(83380400001)(7696005)(4326008)(52116002)(86362001)(956004)(316002)(2906002)(44832011)(1076003)(4744005)(36756003)(2616005)(33656002)(55016002)(186003)(16526019)(66556008)(66946007)(66476007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: hNhy3bEmv4C3+uC4pg9pocuVhSozMTufRkFFWiFB3EJ882YUa6iZWd98xOHS2bDm7CZ4whUqSogat1QUAEvLgqXQ8Faj+ugmA+vqYvUqg4hbFgcavKeNSbQWK2S6R7C6ZsJDTMQgyOY47lHGUH2Osc//gClmzhcaTih7q1svCqLGLYTI3pjugIFmeDu9xpTr/ynD6XSQBTEmuyLslKxk8UdvD6JyCgmdkXGNDuDm51pJ0tku1MIIoHIdKzmK8czl64McILQgqBKALijt0kd21YGeOKWkEf/9M2JXLFNKn7IwQ7bzQyu2Y0RbUkVB6Igkz3hPgQDJkdHMXEWZ05CqKGRV5AK5TaM8vRmdcuyig6ErWFZ5n4psgfcjQEyfsQJpRVBpFqs4A4T0f6uKARySeUS/Ssa914a+yYt1njSRPEINQLLSQ6fkoSZD2nRHPQvmVXoPpbo2x3zjYVXi6FonhD8hh2/jyGucWLX9sKgu5lY=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 459fdea9-292d-4307-d577-08d80432e4ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 00:46:30.8318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saSiBd1BSvW2nUdh13TFXVJTRSMJuA1gWCaY0/k+UNaWprNayw/k6CS7y24h+3wY1ZQJ7sJ+PR8awM3ZGEije5zwsX/DHlDgmERpuUGVPFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0304
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, May 29, 2020 at 05:18:39PM -0700, David Miller wrote:
> 
> Please remove all of the __packed attributes.
> 
> I looked at your data structures and all of them use fixed sized types
> and are multiples of 4 so the __packed attribute is completely
> unnecessary.
> 
> The alignment attribute is also unnecessary so please remove that too.

Some of the fields are u8, so I assume there might be holes added by
the compiler ? Also these attributes guarantee some ABI compatibility
with FW side, I will try to remove them and check but it sounds for me a bit
risky.
