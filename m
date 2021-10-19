Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E8433328
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbhJSKGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:06:54 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:40635 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235213AbhJSKGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634637876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ve/tEHDNo145pzRhnqD6cBW+aaJS+HmpK2oie8LTOQ0=;
        b=aSi3CWHWXJf1o2ZU2HMWctoLRhKw9VyOoCi+EBpOBk3dm2sZRKY+jAhqjJakMh5SAFUIrk
        pgTsp2zLzeNJej2ZAkmPmYEhnpjpK8PRJjWhNnUHLANZOe06fUMkILR5uheXo7bwqGiK/E
        JNmFsxTS+ACVEpfB2mmTL90MabCSl5U=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2051.outbound.protection.outlook.com [104.47.9.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-dc8CjytDMR2eJvmYQ0SFzw-1; Tue, 19 Oct 2021 12:04:35 +0200
X-MC-Unique: dc8CjytDMR2eJvmYQ0SFzw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EK/oZrG6vDAdGYRVw0uGzo341Ofb36paAVOJfj9qfeBmLPPULR8oK9gttr4URAAj94h+1hjWfaddtFMZ1i6kfXwhoK812EmD71W7HaIFqS7x8+812xjP9K9dNyGKxDZ4LSASY0nP/ZlxkEvKG2H5LpqghhP4EDCgW8Oowq2KHMK/pR+K/edrcuA9UacsksQSXX3JhkzKNd/7kanjZ5YYVzjGcju5RYUP6thTnnTIxYe9w4ImObRnBuFznEYSN0y2dYtVvOzvej2R59vfjBvgvJpbic3KdWlN6Jn3DaA2h0uaWWFocgKCfL9/gGjbwAqBBnSeLaEjriWx/E28Y2vpaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGrT0+EIh6Aw5qan1fD2kVZyUPG7Ggex4XAkz+odZWc=;
 b=X1aO4FyAfltvlP4fEXGa5fSxrHjaKFidq47LrbeSa0zW6KdMpbnfmOZQtGbu6pxtRK+Ilhfys+YZD7VDbpzccK1hx4lPUjoiUo+AS3xT5SK0iqN/ViufOKs8ThtLLbZiMgT2gF6w/8cra3xgviMCcLj6Ym2i5AoU31tzzPRBZdo08s1xI0w3393Rqpvni5pqXXObFuwMUKhlJR/SVUlprim/gFcO+9H42D+0kD0JhkdZG/RtrNDh91Atly9wxe90Uw7u1+IoWZEcDBi6NpT89hnW/IHen/2cyiMuHGgqC8DUuK0gqklWRI0WaGnZmvqnn3X+mb9MGgIDpMcyOC6Ufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB5049.eurprd04.prod.outlook.com (2603:10a6:10:17::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 10:04:33 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 10:04:33 +0000
Subject: Re: [syzbot] divide error in usbnet_start_xmit
To:     Johan Hovold <johan@kernel.org>, Oliver Neukum <oneukum@suse.com>
CC:     syzbot <syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000046acd05ceac1a72@google.com>
 <c5a75b9b-bc2b-2bd8-f57c-833e6ca4c192@suse.com>
 <YW6On2cAm1qLoidn@hovoldconsulting.com>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <db0817c7-a918-dbb6-d6ca-e69d14d0d134@suse.com>
Date:   Tue, 19 Oct 2021 12:04:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <YW6On2cAm1qLoidn@hovoldconsulting.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: AM5PR1001CA0052.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::29) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM5PR1001CA0052.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:04:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d256a4c4-9e2e-4b44-dcdc-08d992e7d974
X-MS-TrafficTypeDiagnostic: DB7PR04MB5049:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB50496EA3080A90DF12307524C7BD9@DB7PR04MB5049.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:407;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /nlc+aGz+PjPYyO9Qr67RdxHrisnC5qh+3ghU2OwNhFpUc1Ko/2Hazgl9JQoXaTG0C9whVqTTaF5XIIa5UWQdRlZ0UzaoJvl49n+S4arpyQW8SHnscBkCEx04Z0WXnjsPFMG7Q94ijciJLRXljsbTZA2dJFkzKJDmgShHZ4VKeCAOopBBch1KRUC+JGRP1cz5DBpPKTXmwaNpq5S8+SdRiLpRh6sdZTnHfbokemO48r1m1Y9CCv8AVDYdnyIqoyVL7uACYk9eArQihIK9fXBiRM+71XwKzIjt8a6UlFV1nV+rKwdMKllFzYPxxt4FXgJvVVQFCAwu4a3zVHSRF9uyrk7d2T3GzWd7x1dfXUcXIItipEV+xaG+no0tVxo2q4H+dLaxQZtzEGtxrPG2I5/BeLZlbsJhcyctxKgF+hfhfHJQoNgVIt8u7FvaAhhYCYUO5ArHDhsL50+Feemvzdxn45JPi4ZI+9KXBvXqvHBlYxDSTqrfOhAQ8p1O43OqX9IcXNBmYZ9nXxn/2ERA7Uovb9vxhLE2DB95BrIDhcRvnK32kdqMTA4X7TCsSAn1uTL0pc5fHw0J7UMlLWtjuaMX12Pha9EW99MqzBtBilGA8ALOelMPvxcCyV1iwDDbO9QrcV32dqeOjVrBJAg98MSPa8PoxuUkvR1djc/EGCxJbE4UJZpAFOAzOWLtUzz7ecMTgGDQjP8u92iWr3iNG8haXHAPX3261NMy7B+5eqAYg0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(2616005)(38100700002)(316002)(558084003)(86362001)(36756003)(8936002)(8676002)(66556008)(66476007)(66946007)(6486002)(4326008)(2906002)(5660300002)(186003)(31696002)(31686004)(6506007)(53546011)(508600001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b8J6yyRTjsQ1w654ySTY0TI1PIOXQctV0TBRJDoOUhttXSFXQqBVhJHQznZ0?=
 =?us-ascii?Q?CLBc6z2CzRx5m6rEtA7jaGK3Tp+U4AQVmDM5W8IBG9ZB7h8Kc0TveC2FXH52?=
 =?us-ascii?Q?lUlVhms9Kxgp39hgKrhPsGefrnj5F7UKmZjjuV4jZdbRjapl9GbqzYjYefYW?=
 =?us-ascii?Q?b+AkoofJIs6/3SOdErYpDHbb+pUWFrZiTBXiKAZTCJgPg1XhgXoGdk4scQWP?=
 =?us-ascii?Q?MCLXI9GSw2JVV1rgTZiVbui8o7mO9cl0Kz4R4PfDHXLpElExK4RoO5/Ymjv0?=
 =?us-ascii?Q?NUMgVcmh4im38Q2P85MuBunUF+yzVM0xkmhYsCtisYIDuB7QtbYeulV13IKk?=
 =?us-ascii?Q?9P1rJiAAJEfqJAEEJidICd4sxPntCUdF4vi3UnyFAlT6482gGwjznJiHRkHW?=
 =?us-ascii?Q?f0COKZVh14IyB8fKbvU32Y8eRh1TCJFxdQszJDPW3LWTzTa/MG8wQROhClRP?=
 =?us-ascii?Q?50CrVylzwVjQgo+thnxqwLHQrCmLgINnrMHwecRbhQ7Tkg2s9m12rxgIYV2I?=
 =?us-ascii?Q?vxTzdxFYZkZq5h9TPxPvriKjd/lu/hhmO2BHhbP4qY+zQzVjNfVrxQCceonB?=
 =?us-ascii?Q?d1ukZ5xxtEPMfiMhfRMvjKqLxpVMuHsv4Sl/LQcD499oiYMH5NJNKOveNo9M?=
 =?us-ascii?Q?to+LTjYRJGyYmI1QulpqnYyDQ2dhYt4tUEDMIHeNujNmlsfKDectY9QgoZ8G?=
 =?us-ascii?Q?0ALDcmFPWFtU5NyEnGUquHznDmjcNMUnCejb9lutormpg7+kuRYD+is5QnMy?=
 =?us-ascii?Q?MUIgX/VxV29qxcTOyep5i7lF//+iMm+8DYvQXtpoT2JcEZLb/SKV6uE/iWMT?=
 =?us-ascii?Q?BFYzrktRGdM36uTTUbdT7tp55GqRHU1b9LNO3tdjE2dYyAwNO1jx0ITnY50l?=
 =?us-ascii?Q?OAKMLMHCrsuFBAYPK2EraRVXJRGN8/5tZIsjeqsIZPk0PpFDnTtA1Sy/78kP?=
 =?us-ascii?Q?AaSeUzf5ze4i9uDgoxaxkWDH+/0cGnccOBN7AHXXTKog8kAzWqPkUMWDcXdG?=
 =?us-ascii?Q?MBScdcbRzh0APQsJqzulKA0QJBWyWu2VYSqwoTr0ovF7Y7btiYaFdIp4nAY/?=
 =?us-ascii?Q?MwX0kDTKLptyMp7ihcgRbghKKCZ6GZswKkGM418Ugv21CtntCT3II3Pmp97/?=
 =?us-ascii?Q?tSWoATVK2llkvaLrhftQRB/pMyTPPOHVLLcBW+KwN1owZ/Sqc/7qdNxRT+ku?=
 =?us-ascii?Q?wWNFCAinFuFKsjE9Yyh/WSOQG2QhoUuhoUY0GUZogds29CJgaHKr+7RbI7V0?=
 =?us-ascii?Q?UYxDBmvq3QGO8NJD5Ag6AlKAXA/4Vf8V+A+nF7iIEUMTpiVUvA5Y1K8sKISn?=
 =?us-ascii?Q?O+d2beQB8XpalzeAJnwL0bxhNFTFaeM/X+mI+DkM8HwddcdntNv80SfNVT20?=
 =?us-ascii?Q?kQNIolcTdH5+txqGas15/jaLBy/h?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d256a4c4-9e2e-4b44-dcdc-08d992e7d974
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:04:33.4320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C9vZu2skG1rQ7dOjK05dwFWaZiZbX1CNIkxEez7BlfOATgYMqvrsQC8d0/7F3FT9LKOXZa3tO6ESAm8xl7Lf5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5049
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.10.21 11:23, Johan Hovold wrote:

> Just bail out; what can you do with a 1-byte packet size? Also compare
> usbnet_get_endpoints() where such endpoints are ignored.

OK. We'd accept a 1 now, though. Can you think of a sensible lower bound?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

