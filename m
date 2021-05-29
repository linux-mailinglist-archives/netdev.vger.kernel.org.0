Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B51394AC3
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 08:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhE2GeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 02:34:01 -0400
Received: from mail-eopbgr1310115.outbound.protection.outlook.com ([40.107.131.115]:23584
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229547AbhE2Gd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 02:33:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1EgZxFT5g+bV7vAcUnqejC8viMRn+uMPc18MOh/k+XQkUdD1htIQGCMjKxBT5t93JLb3Un84KEzQ9pDucWv4f5/BCXYIdqjQ6l29mGb6axDqRQyf/nXtBTAoET+VgHaQfJceArb0lKCk8NQzUd4Ixw+CVdck79OiLJqPZ/Vyr6Zy4sge0L2Z3Wvsc5OuJFWlTAKQFBE3FHIXeJV28+tyJiVYgOxxc5h6k8+oA5heKNacSKbphPuHUe8kAnnkq6JFVXKErGt8Fp78Wseag2ZJdXlY3RmvB0dXDjECLqvtbQ+JG5Kyo8GmUHGE6CUs/B4uXoqdiL9qTyrO8bGK8i0qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2xkoqCf97dbu0dW9dZmJ5t1pzwpMRxPI003afb4g2M=;
 b=cyIdEt0oeSD4hP/GiX1/gmCyPEDZL8uZiHtVCgUharrftCLCJrxYaPqXZWD9kSY1xvbV3hEGXGydajLbWg6U1gngCdi7+Ar3oE5A2FvUvZWVPir7tQKPmvGjs0xDCRXnMKDGYqLxgBdR8vLdlnWhJbgY9DJzr9cQlVABEY0cQqjj5r9naxNmWJ5C9h3gxvFfSD523hPWZ37OXTj1kuoZaLh2e+SOyBWHB+0bOb70Wd4Eeif0KUEbP4y3lv8nmmXqiVw9FCMwa4tnj07nizrDed8eT0nBEMQMFPm1gnPPrMJEMCMNjI0EQuRDNqcE+GmE2kCogVpz79IRQsLE+Lf+aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zenithal.me; dmarc=pass action=none header.from=zenithal.me;
 dkim=pass header.d=zenithal.me; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenithal.me;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2xkoqCf97dbu0dW9dZmJ5t1pzwpMRxPI003afb4g2M=;
 b=Vn420cnI/8UeYOJQv+sWTL9eil8cVpVIV4lNsFZiJh5iCbe7WVXIpFLWUqdwlMrw951P/qAPS/NdM89LkPBGRNgEihVvJTNsRj9MXAsUsksv7cWivTt5bAQp0LnvwtUfih0vnfPhpg/OkHHjnPbLQ0yJK+0E9owClzJCVBkmTyM=
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=zenithal.me;
Received: from SG2PR03MB3804.apcprd03.prod.outlook.com (2603:1096:4:50::20) by
 SG2PR03MB4733.apcprd03.prod.outlook.com (2603:1096:4:de::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.11; Sat, 29 May 2021 06:32:15 +0000
Received: from SG2PR03MB3804.apcprd03.prod.outlook.com
 ([fe80::b0c0:e261:833:8316]) by SG2PR03MB3804.apcprd03.prod.outlook.com
 ([fe80::b0c0:e261:833:8316%6]) with mapi id 15.20.4195.011; Sat, 29 May 2021
 06:32:15 +0000
Date:   Sat, 29 May 2021 14:31:56 +0800
From:   Hongren Zheng <i@zenithal.me>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC] add extack errors for iptoken
Message-ID: <YLHf3ETTHj6uaY9Y@Sun>
References: <YF80x4bBaXpS4s/W@Sun>
 <20210331204902.78d87b40@hermes.local>
 <YIlbLP5PpaKrE0P2@Sun>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIlbLP5PpaKrE0P2@Sun>
X-Operating-System: Linux Sun 5.10.26-1-lts 
X-Mailer: Mutt 2.0.6 (98f8cb83) (2021-03-06)
X-Originating-IP: [2402:f000:6:6009::11]
X-ClientProxiedBy: BY5PR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:a03:167::48) To SG2PR03MB3804.apcprd03.prod.outlook.com
 (2603:1096:4:50::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2402:f000:6:6009::11) by BY5PR17CA0071.namprd17.prod.outlook.com (2603:10b6:a03:167::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24 via Frontend Transport; Sat, 29 May 2021 06:32:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a085bf6f-c3b1-497c-0fea-08d9226b801d
X-MS-TrafficTypeDiagnostic: SG2PR03MB4733:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR03MB47337883022FE85839858B67BC219@SG2PR03MB4733.apcprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hADU1DXFygMtKBLyyBTympxZmS3ZyZG2yjhn2iP5oyppaVr7Jr2MSQ/ToKFNdQOhxSjMypkHpUWbfWVwlIPtD9hcA9ir63749qQFnbzwVQ46T1mkAuK3iOcSlRmI/wgMdr042xbYytiVe4Pb6unE2ia3Cy2Tk7DvSLbX7r1Nkte7fiLJ+A4VqdRAxFJTtglgGHxkBfbmyItmv/zgcHpIkbtnVwMnoxShfdo6MMnB83O5VMB4+SdapEy7GkUdSc8zhNjP+RY4yl+RA+TwMtRysyfIThtfDV2f9eXFtZNLYhwqFo2SRMF5rfQSwe0zlfeeGCBhrHR+1WBnk2YZq2KcZsd0ejYCT6zrPCBmPIlLn7k/o5AQt4aYFue3t5zFaXRVoWnAb7ypIBokUZw23krJkE1aw4sFkmi6s8BCmL//4V4RfVtT1mRwXkZobAyPngV20peT4MLcrRJejQ84IfiEE3qlY3cJcFEnbvy0RAYnt/9bTSp8bNfB6dpAJyGbPxE/ExkCYNo76+7tXMOMpsgqQipP650tWR1Kv3yEnt4BNY7x3syvu8Hb8xs+JH3f2Y7cyRfjoYrt+SKInOJhqRMY0//+AuiFFB8aCawU68e7iyTGfi/9O7NX2Yps6K1FLLu0W8hx3fJL/bDST5WykCldEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR03MB3804.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(346002)(39830400003)(376002)(396003)(136003)(6916009)(86362001)(9686003)(54906003)(33716001)(8676002)(478600001)(316002)(786003)(6666004)(186003)(83380400001)(4326008)(2906002)(66946007)(66556008)(66476007)(38100700002)(8936002)(4744005)(6496006)(52116002)(16526019)(5660300002)(6486002)(49092004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AlMUf4EwtZNLObLE2DGcuRuTYotVDqWP27W3fFAV+yyphvOQ5ePrZAvxtW+n?=
 =?us-ascii?Q?186Gt7QttCM6J2bg30kqPmTh2vc4wYudarqk04eMqbKVGaQ1Tt+/pc00xtWg?=
 =?us-ascii?Q?yJn0WlXkWca9TQBBddT3KT0nXZMJzmVAAecZPoSZgQGGsjPf8t6uz0OW48W3?=
 =?us-ascii?Q?89sqn9zzmUZ4hlK0ZslBXpxYonIeqXZRbo4tlWFST7UTBD+63/RxSuQ9e7+d?=
 =?us-ascii?Q?gc/qJx2d+UQpcdVJVcunlvIr1NyQ+t0MMa+kf5rJyZ61mzM5Dg8PPhtKL3hb?=
 =?us-ascii?Q?MgPX9X4SYCVx8vMvdd2xGXpr4GuEwSk04gqAARdiCVXBALCksqZ+ttTCHyme?=
 =?us-ascii?Q?akCddJiwbtbBsi98nO2Zg2HHgpodx8R58DYUJfrMd4MUupa+rnfnoR49GoYX?=
 =?us-ascii?Q?4tHvfqe/Kjozq1jglbyRdTb+CgSSAFZtlw0RTmsYlWSg1tlTVED71KO63pEW?=
 =?us-ascii?Q?kAiWoqSkVsfZGrLyRzvnMPs4PXW6vJuL2TUzLMkx1lPMyvOtqw01zOuSqjCB?=
 =?us-ascii?Q?HtyoWpgoVdDDBeS/E37GsrFQegourkyOY9jyB+1mLsBAjayR6nEGOHZ1vHI/?=
 =?us-ascii?Q?gT/NXKccuR4smtH5VYSNXsUJHILOXkOWSyPX3q+1zyzV2820dGWHd10sfpk0?=
 =?us-ascii?Q?GTT+I79xEF/07Q+Nftll9TnhX86tfZihR2Lex6NyMLC64npjeb/lA6qBSZ4C?=
 =?us-ascii?Q?uruR80/Qp5bBpFv/rGQ1XRrDiRvYwrJ6JzrwJepYbpYBUzd40hMe8zCtI1vj?=
 =?us-ascii?Q?i9Jv2KWeRUitsYAvvf6mpyG3lyNUUOvrU3wzg9JaQLAI8oq5f8kQe2X8HHFo?=
 =?us-ascii?Q?4talvC2uXDmli/nJu0Nibtb7YHD4EynTmOVAPmdTQ8VdHdBR9HSMPZyDQqvf?=
 =?us-ascii?Q?+uXiJjw9FfcyVCdHvvYJX8wF7fSmzuqPBOQ/hOYZlxk6uU3FjRIPunP+SBaz?=
 =?us-ascii?Q?jaFdq9BNsWnxqTJKjTcKFzyuRRfSqJbdoJdVA53W44iRZojYWRKAHtI/r7pn?=
 =?us-ascii?Q?1lnSGMAGn9KIlEO2J+7GU/m3SrgSXBtYKiAGNSUlojOOeh2CxVY0eRsHR0WP?=
 =?us-ascii?Q?D2eMlPEtVSB2ouY/71jKqNuIcnYa7n5KQ7tK+9DKXvMQPzJyZMdhDQU6MbqE?=
 =?us-ascii?Q?6IVWksEyRo2jI9oxmaUGULNnJORzvLzwNwPXswzngYJH3SEYZ8PDojHfuudJ?=
 =?us-ascii?Q?cDc60aHHObp7yHCGzg+PHqsuP7EN7gyG2ccAC86eA7UPcmNVQpDfpIkEm/Yw?=
 =?us-ascii?Q?HeEmMX5/pTGUpjsezto8VnsQ8wbic6W66b8lWh71Y37i+ufjF2SEu7wuAC6a?=
 =?us-ascii?Q?4lQKAOT2X4joai5UwUTwr/bHuT2gE7JxcIw8T7ccYPL/sA=3D=3D?=
X-OriginatorOrg: zenithal.me
X-MS-Exchange-CrossTenant-Network-Message-Id: a085bf6f-c3b1-497c-0fea-08d9226b801d
X-MS-Exchange-CrossTenant-AuthSource: SG2PR03MB3804.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2021 06:32:15.8028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 436d481c-43b1-4418-8d7f-84c1e4887cf0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FeZfB6v6+uMF+lEUu8rXGncHEPW62eojByAbY9ySjUKZ4g3xGo2/dSQJIWmyP4od
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB4733
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 08:55:08PM +0800, Hongren Zheng wrote:
> > Perhaps the following (NOT TESTED) kernel patch will show you how such error messages
> > could be added.
> 
> Since this patch has been tested, and we have waited a long time for
> comments and there is no further response, I wonder if it is the time
> to submit this patch to the kernel.

Is there any updates?

I'm not quite familiar with "RFC" procedure. Should I send this patch to
netdev mailing list with title "[PATCH] add extack errors for iptoken" now
(I suppose not), or wait for Stephen Hemminger sending it, or wait for
more comments?

-- 
GPG Fingerprint: 1127F188280AE3123619332987E17EEF9B18B6C9
