Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A105B6EEFFB
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239788AbjDZILe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240118AbjDZIL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:11:26 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260851BD6
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 01:11:16 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q6rHrC001804;
        Wed, 26 Apr 2023 01:11:11 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pdpus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 01:11:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0rMtFLtbFsSvpRZT/X0RHYciz4PSgrUrpRRcI+iZfVGmwykplpuyRHSa0e9qBC9HacAvv8njbcOhrsWMqymC5T/84JjDArs2EhNnDQU5KjzY9Z7zm5SjhemydxShFzTPks/x5Yk/9kk2rmGs42/ycWRck0e1LEo7YKucw3GnS8w+eS8fe/smZCRl9d5pin61X4KIsLfIe5SczT5QeuXKL41mAYnSg8xtxpTFAWDqSe+CiAdDWQabrgOJ/xCMupnkXo90ufWBzIShnE6HvFScyS2t5TnaJzGY5Cfq9ro8j9++O3Uoae3jFC7pPtWk0+ZlBCwc4kkW72PIlYlUNlWPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rfpTlZQU62zJ65zO7n18bh8Vanixdu/x0eem9QDNwg=;
 b=WOI5i2v08h4ZsFHQG9rFbeE/Q8djKWQasTwFIGLJjJqzXf/+JuIAJJQ1aFaAyiGUfBrJVg4LeMhsoL2a9Ha2zvbTQZV3xgM0ILUOPZG6mKY2o3/2hYGaDQQZUNLJ7mAYRUDcVGWD1NfWtwMVI81PUARLKvQM72QQr2alnYHhYxwnVLA9hY+3lnfx0Ro6koUDPUmcGCZH9/Bm+Pm+5+9mKAEj1G8afkPlq5h/84+tymaTQiXy/+zX22hVmK9OEsSvteiuihBgjoc00oKRmSak/3AVhK29OnVTvkxGISk+b9aSREsi2dyTsmGhn4ZOgMt9QShK9lQQOetHDpesYC0Jiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rfpTlZQU62zJ65zO7n18bh8Vanixdu/x0eem9QDNwg=;
 b=sPOf9Of5ELU1C1n+04YsBmQQ4yN8Z/GJ/MaVrx2v50G3sPuujLPz/m+boG7BPtMK7b1h2ZmX9oJheBbdw9o+KI1W1wPTFf+EpTR0xVNdrgw10cHodX8VQyVA854CgcSOeu7wyKmO2qk39WTtvm6/b/WL0XIwDH5N8/f0ssn/ZI4=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by DM8PR18MB4438.namprd18.prod.outlook.com (2603:10b6:8:3d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Wed, 26 Apr
 2023 08:11:05 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::edc4:5d0d:f48b:a60a]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::edc4:5d0d:f48b:a60a%7]) with mapi id 15.20.6340.020; Wed, 26 Apr 2023
 08:11:04 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [EXT] Re: [PATCH net] qed/qede: Fix scheduling while atomic
Thread-Topic: [EXT] Re: [PATCH net] qed/qede: Fix scheduling while atomic
Thread-Index: AQHZd3EjecDQgOhMBkirIhB5Sve2kq89I+CAgAANxBA=
Date:   Wed, 26 Apr 2023 08:11:04 +0000
Message-ID: <BY3PR18MB46127EC56DF88024DEC65488AB659@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20230425122548.32691-1-manishc@marvell.com>
 <20230426063607.GD27649@unreal>
In-Reply-To: <20230426063607.GD27649@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWFuaXNoY1xh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWUwZTg3MzA2LWU0MDktMTFlZC1iNmQ1LWQ4Zjg4?=
 =?us-ascii?Q?MzVmNjc2YVxhbWUtdGVzdFxlMGU4NzMwNy1lNDA5LTExZWQtYjZkNS1kOGY4?=
 =?us-ascii?Q?ODM1ZjY3NmFib2R5LnR4dCIgc3o9IjE1NjQzIiB0PSIxMzMyNjk3MDI2MTc1?=
 =?us-ascii?Q?Mzk1NjYiIGg9IlNPWS9nYmlyN2g4ZVlqR3NCejJiTTBSSjVwbz0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUJRSkFB?=
 =?us-ascii?Q?RHVJOWVqRm5qWkFXaCt5SHRmV0Y4T2FIN0llMTlZWHc0T0FBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUNrQ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBYWk1eElBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNB?=
 =?us-ascii?Q?QmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQWdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdC?=
 =?us-ascii?Q?MUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhV?=
 =?us-ascii?Q?QWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFNQUF5?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?TUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhBY2dC?=
 =?us-ascii?Q?a0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcw?=
 =?us-ascii?Q?QVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFjZ0Jm?=
 =?us-ascii?Q?QUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFB?=
 =?us-ascii?Q?QUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhB?=
 =?us-ascii?Q?Y3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FB?=
 =?us-ascii?Q?QUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFHMEFa?=
 =?us-ascii?Q?UUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3QnpB?=
 =?us-ascii?Q?R3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdjQVpR?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJm?=
 =?us-ascii?Q?QUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFh?=
 =?us-ascii?Q?UUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtB?=
 =?us-ascii?Q?SElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBRFFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFCakFI?=
 =?us-ascii?Q?UUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNn?=
 =?us-ascii?Q?QjJBR1VBYkFCc0FGOEFjQUJ5QUc4QWFnQmxBR01BZEFCZkFHTUFid0JrQUdV?=
 =?us-ascii?Q?QWN3QmZBR1FBYVFCakFIUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHMEFZUUJ5QUhZQVpRQnNBR3dBWHdC?=
 =?us-ascii?Q?MEFHVUFjZ0J0QUdrQWJnQjFBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQT0iLz48L21ldGE+?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4612:EE_|DM8PR18MB4438:EE_
x-ms-office365-filtering-correlation-id: 519e21e2-bd82-4892-67c7-08db462dc805
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S0mxLDQkCKDzk1v6PQiNKPkkSvtZi4PeraqxhljxOwZCm1RuAUixl8EJz3ZVSKPdzc2ZnAMsdwDyth0i7DBdxwLhD8MSzxWJfOH1/L0xDZb4LWacjOSx7EG7RofY0rxA7uIwJy+kt2NROsMeWE5Ytzq0gltglYaYRvb/vla2+AWfpgl9x5+fuMGFijRu27Gu7uG2GGeLIRdKDl78s8ADv/mYrhBb3QM1ST1xutcl6jTmY+PK5OfJFyos6bqV/MJUavU076GTt2gdNIG1hWgJZPl2Cmnf3WiMO783TYwEGpiN/GQDPtkuTMPPOa6wEFmEQzpZErpt83FXQrrd2r+NGnZ0VvFplZheBSFUY9DLY/bTxb7TA9xzqciF1NsBxQAU2CqW+P9Uva/scD/0W5SuQGexkTqx650v/YuoC6E3vMhMMRWMXbsxaWQOewfO9hUoXEo0m8LA/VLtnGLpXMNRAxKmOP6VGHv8XJUzzpceoetauH6/CsMCV4idlQun5FwkCZcp8hBfJvdBPeMCWAo3EQVj80nriGjMPTcpyYDcmDm44tEE5KDaViyY18sTISlSxrt3aMMQ6qbzGtqisRqvB4dE6oRGrM15zt+EkHjgxL//J/NyAji/PKOxFGT3pYaN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(316002)(64756008)(66446008)(4326008)(6916009)(38100700002)(41300700001)(122000001)(5660300002)(52536014)(8936002)(8676002)(33656002)(86362001)(38070700005)(2906002)(30864003)(66476007)(55016003)(66556008)(71200400001)(7696005)(9686003)(53546011)(6506007)(478600001)(83380400001)(186003)(54906003)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EYjPLB9E5igNDUeBETGksDz/DNanrZKjV1xmtd15MT8GXHsLyUiO4K/dbpOm?=
 =?us-ascii?Q?1Ve+gwlliadk7S3jS2GgSLMOj7kjSWIE3d2o57PpGLzGBYvGd71Mc2CDRthc?=
 =?us-ascii?Q?XP/xBZ108h7eweZKt7K17eGx5q7VEtr9dDKzeZgPEipTIWIEXT4jmQtPO8Q/?=
 =?us-ascii?Q?v3cNqDNyxxJexm+/9g1YnbEWAMcmGguzsycyh8h7K5TwWICbsyk+XbALrTRL?=
 =?us-ascii?Q?skj6/6Npq+0BVPk8Y7kzHpPvO31diM20U8NEQRICadQ+dQoV8JL6/Nk04Fuq?=
 =?us-ascii?Q?pDcn9Uf8GZa5IoAp5+aFiN3CYRlh742XHPU/XWycXEUDwtQhD233qx1EQQQ1?=
 =?us-ascii?Q?jnQ5wFVF55/2H3gKYQhaOKWXg+FIFigiSXKgj6yyVi7XMF+nwBTeemQu6L3x?=
 =?us-ascii?Q?oKah5WNK8VC2a15E0A23Z/lB8g+cwbZlrgGn3kmVpOR9qOsTyztn3vbva3Ix?=
 =?us-ascii?Q?NSb6gcqe9YsPNxo4rTKFaWegdJ70Ls1FX39+zaXkwSe1LerHHIIZdvqzVY2f?=
 =?us-ascii?Q?SHvXEScmfH/pmtA1n1yBqoInaPZ09n5PQwbvJudKwV2caIa3vpSZyXW8/KSr?=
 =?us-ascii?Q?3Pr3pqyGEzvD5JNeBLKK3/w1ubtgu9hHDCutAMhnuicJcUB9xYPtNXuPchPT?=
 =?us-ascii?Q?RpOZO+K15OJDJ7hx9TFcB7XHXZUyBb1GLtCRjsFOvYxatYVh6GXxEym30thw?=
 =?us-ascii?Q?98DFLy+pb3gIw5dFyWcikAlyypmRIy/xA/3lkzSPf/zHAyF2RBZXIjc3nrpF?=
 =?us-ascii?Q?SxAYFji3o7XOpqV1xRdoZZtsruzkeQWSbZzjuU2fmp0P9k4YSLL3JYpLelX7?=
 =?us-ascii?Q?dx6+p7GyJrgRosMXRnHdcmAFMOWztiRHRdEYlXikYKzs4a2ng5bqGK20Kdsw?=
 =?us-ascii?Q?QyQC1gEwLiXkz9hZARsJEpkMNiSVpWbKlzW6VdfNOi0wY31kfBPZ1hmipJvB?=
 =?us-ascii?Q?pmnDfogPY27EL0q4E7zEB8gwYZ66hsF+dC1h82SIX00KAWLtW88ZgF6FZbJ6?=
 =?us-ascii?Q?yE2Gfao4Mm7IpifXnDkio0nvEmvfJDrBEbaUmtd9muU4RbkM7RyohXF7IIQG?=
 =?us-ascii?Q?7pFLOREvhjqJ7/qOqkD2658WX+Ey08Rdk90eLprhu5VJeH41wmDw4LinqE83?=
 =?us-ascii?Q?URWsl4RZ0hj/oBuFRQl9F9TzAz8Bhtty7uiTF4nHDGmDpu2dm+eBlhvX2jLO?=
 =?us-ascii?Q?wCgyor3NFek8T3RrJDFcm7AlE6jnh44rYvlDNyblqtnx2X39QDzH+AdQZVTZ?=
 =?us-ascii?Q?KBbvNcweG9eNf49RKV/zoGWJkkTNeMF4+7UGllrkXQYpre8iOQ51++NLBtY+?=
 =?us-ascii?Q?GbahlNykDG8N4oUnCfdRqIi2MGGx4pRnXMnOvm6b4cFRepw4us8Dxj9mmHdQ?=
 =?us-ascii?Q?ZBuoN4y6B8xXS2ofDW+otCQWC9uvjhTHAX7s10uCmCJ2uN/r74mxtlxai8G0?=
 =?us-ascii?Q?yYWXJkPPxvoYtaVD0b9HpAZOE/XvQllTSJ/gpgUUFnfEA7/6Dn3qDUBnMoAI?=
 =?us-ascii?Q?LniJCW9vJmlCecoc9deKa/m+1LPRfg16EPLlM9c5QiMoWVwNFwrhM3f9KcrU?=
 =?us-ascii?Q?O0mZA1DJXtOw2/vI9DEhw52k4PR3bJJ8hoMwy1RhaUBExSBzuM2Pl4T99B+U?=
 =?us-ascii?Q?rlpM6NOeiMHR6OIpZeWuiRnpFIkDPSQo3Z4xPVLNMHOo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 519e21e2-bd82-4892-67c7-08db462dc805
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 08:11:04.5845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xz6aT+wH3G7tzzrGMHpFN7CAws41JLG7d3S5i13FNNOj4xPYcnsiKGikEbUeXg+rs29PUEQEJgty4QLylSBNmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR18MB4438
X-Proofpoint-ORIG-GUID: k9K6nkWzLQowHCVMfSlayDskLYcD2-qi
X-Proofpoint-GUID: k9K6nkWzLQowHCVMfSlayDskLYcD2-qi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-26_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, April 26, 2023 12:06 PM
> To: Manish Chopra <manishc@marvell.com>
> Cc: kuba@kernel.org; netdev@vger.kernel.org; Ariel Elior
> <aelior@marvell.com>; Alok Prasad <palok@marvell.com>; Sudarsana Reddy
> Kalluru <skalluru@marvell.com>; David S . Miller <davem@davemloft.net>
> Subject: [EXT] Re: [PATCH net] qed/qede: Fix scheduling while atomic
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, Apr 25, 2023 at 05:25:48AM -0700, Manish Chopra wrote:
> > Bonding module collects the statistics while holding the spinlock,
> > beneath that qede->qed driver statistics flow gets scheduled out due
> > to usleep_range() used in PTT acquire logic which results into below
> > bug and traces -
> >
> > [ 3673.988874] Hardware name: HPE ProLiant DL365 Gen10 Plus/ProLiant
> > DL365 Gen10 Plus, BIOS A42 10/29/2021 [ 3673.988878] Call Trace:
> > [ 3673.988891]  dump_stack_lvl+0x34/0x44 [ 3673.988908]
> > __schedule_bug.cold+0x47/0x53 [ 3673.988918]  __schedule+0x3fb/0x560 [
> > 3673.988929]  schedule+0x43/0xb0 [ 3673.988932]
> > schedule_hrtimeout_range_clock+0xbf/0x1b0
> > [ 3673.988937]  ? __hrtimer_init+0xc0/0xc0 [ 3673.988950]
> > usleep_range+0x5e/0x80 [ 3673.988955]  qed_ptt_acquire+0x2b/0xd0 [qed]
> > [ 3673.988981]  _qed_get_vport_stats+0x141/0x240 [qed] [ 3673.989001]
> > qed_get_vport_stats+0x18/0x80 [qed] [ 3673.989016]
> > qede_fill_by_demand_stats+0x37/0x400 [qede] [ 3673.989028]
> > qede_get_stats64+0x19/0xe0 [qede] [ 3673.989034]
> > dev_get_stats+0x5c/0xc0 [ 3673.989045]
> > netstat_show.constprop.0+0x52/0xb0
> > [ 3673.989055]  dev_attr_show+0x19/0x40 [ 3673.989065]
> > sysfs_kf_seq_show+0x9b/0xf0 [ 3673.989076]  seq_read_iter+0x120/0x4b0
> > [ 3673.989087]  new_sync_read+0x118/0x1a0 [ 3673.989095]
> > vfs_read+0xf3/0x180 [ 3673.989099]  ksys_read+0x5f/0xe0 [ 3673.989102]
> > do_syscall_64+0x3b/0x90 [ 3673.989109]
> > entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [ 3673.989115] RIP: 0033:0x7f8467d0b082 [ 3673.989119] Code: c0 e9 b2
> > fe ff ff 50 48 8d 3d ca 05 08 00 e8 35 e7 01 00 0f 1f 44 00 00 f3 0f
> > 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77
> > 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24 [ 3673.989121] RSP:
> > 002b:00007ffffb21fd08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000 [
> > 3673.989127] RAX: ffffffffffffffda RBX: 000000000100eca0 RCX:
> > 00007f8467d0b082 [ 3673.989128] RDX: 00000000000003ff RSI:
> > 00007ffffb21fdc0 RDI: 0000000000000003 [ 3673.989130] RBP:
> 00007f8467b96028 R08: 0000000000000010 R09: 00007ffffb21ec00 [
> 3673.989132] R10: 00007ffffb27b170 R11: 0000000000000246 R12:
> 00000000000000f0 [ 3673.989134] R13: 0000000000000003 R14:
> 00007f8467b92000 R15: 0000000000045a05
> > [ 3673.989139] CPU: 30 PID: 285188 Comm: read_all Kdump: loaded
> Tainted: G        W  OE
> >
> > Fix this by having caller (QEDE driver flows) to provide the context
> > whether it could be in atomic context flow or not when getting the
> > vport stats from QED driver. QED driver based on the context provided
> > decide to schedule out or not when acquiring the PTT BAR window.
>=20
> And why don't you implement qed_ptt_acquire() to be atomic only?
>=20
> It will be much easier to do so instead of adding is_atomic in all the pl=
aces.

qed_ptt_acquire() is quite crucial and delicate for HW access, throughout t=
he driver it is used at many places and
from various different flows. Changing/Making it atomic completely for all =
the flows (even for the flows which are
non-atomic which is mostly 99.9% of all the flows except the .ndo_get_stats=
64() flow which could be atomic in bonding
configuration) sounds aggressive and I am afraid if it could introduce any =
sort of regressions in the driver as the impact
would be throughout all the driver flows. Currently there is only single fu=
nctional flow (getting vport stats) which seems
to be demanding for qed_ptt_acquire() to be atomic so that's why it is done=
 exclusively and keeping all other flows intact
in the driver from functional regression POV.

Thanks.

>=20
> Thanks
>=20
> >
> > Fixes: 133fac0eedc3 ("qede: Add basic ethtool support")
> > Cc: Sudarsana Kalluru <skalluru@marvell.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Manish Chopra <manishc@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Alok Prasad <palok@marvell.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_dev_api.h | 12 +++++++-
> >  drivers/net/ethernet/qlogic/qed/qed_hw.c      | 28 +++++++++++++++----
> >  drivers/net/ethernet/qlogic/qed/qed_l2.c      | 11 ++++----
> >  drivers/net/ethernet/qlogic/qed/qed_l2.h      |  3 +-
> >  drivers/net/ethernet/qlogic/qed/qed_main.c    |  4 +--
> >  drivers/net/ethernet/qlogic/qede/qede.h       |  2 +-
> >  .../net/ethernet/qlogic/qede/qede_ethtool.c   |  2 +-
> >  drivers/net/ethernet/qlogic/qede/qede_main.c  |  6 ++--
> >  include/linux/qed/qed_eth_if.h                |  2 +-
> >  9 files changed, 50 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
> > b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
> > index f8682356d0cf..5e15a6a506c8 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
> > @@ -182,7 +182,7 @@ int qed_hw_prepare(struct qed_dev *cdev,  void
> > qed_hw_remove(struct qed_dev *cdev);
> >
> >  /**
> > - * qed_ptt_acquire(): Allocate a PTT window.
> > + * qed_ptt_acquire(): Allocate a PTT window in sleepable context.
> >   *
> >   * @p_hwfn: HW device data.
> >   *
> > @@ -193,6 +193,16 @@ void qed_hw_remove(struct qed_dev *cdev);
> >   */
> >  struct qed_ptt *qed_ptt_acquire(struct qed_hwfn *p_hwfn);
> >
> > +/**
> > + *  @brief _qed_ptt_acquire - Allocate a PTT window based on the
> > +context
> > + *
> > + *  @param p_hwfn
> > + *  @param is_atomic - acquire ptt based on this context (sleepable
> > +or unsleepable)
> > + *
> > + *  @return struct qed_ptt
> > + */
> > +struct qed_ptt *_qed_ptt_acquire(struct qed_hwfn *p_hwfn, bool
> > +is_atomic);
> > +
> >  /**
> >   * qed_ptt_release(): Release PTT Window.
> >   *
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.c
> > b/drivers/net/ethernet/qlogic/qed/qed_hw.c
> > index 554f30b0cfd5..4e8bfa0194e7 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_hw.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_hw.c
> > @@ -23,7 +23,10 @@
> >  #include "qed_reg_addr.h"
> >  #include "qed_sriov.h"
> >
> > -#define QED_BAR_ACQUIRE_TIMEOUT 1000
> > +#define QED_BAR_ACQUIRE_TIMEOUT_USLEEP_CNT	1000
> > +#define QED_BAR_ACQUIRE_TIMEOUT_USLEEP		1000
> > +#define QED_BAR_ACQUIRE_TIMEOUT_UDELAY_CNT	100000
> > +#define QED_BAR_ACQUIRE_TIMEOUT_UDELAY		10
> >
> >  /* Invalid values */
> >  #define QED_BAR_INVALID_OFFSET          (cpu_to_le32(-1))
> > @@ -83,13 +86,18 @@ void qed_ptt_pool_free(struct qed_hwfn *p_hwfn)
> >  	p_hwfn->p_ptt_pool =3D NULL;
> >  }
> >
> > -struct qed_ptt *qed_ptt_acquire(struct qed_hwfn *p_hwfn)
> > +struct qed_ptt *_qed_ptt_acquire(struct qed_hwfn *p_hwfn, bool
> > +is_atomic)
> >  {
> >  	struct qed_ptt *p_ptt;
> > -	unsigned int i;
> > +	unsigned int i, count;
> > +
> > +	if (is_atomic)
> > +		count =3D QED_BAR_ACQUIRE_TIMEOUT_UDELAY_CNT;
> > +	else
> > +		count =3D QED_BAR_ACQUIRE_TIMEOUT_USLEEP_CNT;
> >
> >  	/* Take the free PTT from the list */
> > -	for (i =3D 0; i < QED_BAR_ACQUIRE_TIMEOUT; i++) {
> > +	for (i =3D 0; i < count; i++) {
> >  		spin_lock_bh(&p_hwfn->p_ptt_pool->lock);
> >
> >  		if (!list_empty(&p_hwfn->p_ptt_pool->free_list)) { @@ -
> 105,13
> > +113,23 @@ struct qed_ptt *qed_ptt_acquire(struct qed_hwfn *p_hwfn)
> >  		}
> >
> >  		spin_unlock_bh(&p_hwfn->p_ptt_pool->lock);
> > -		usleep_range(1000, 2000);
> > +
> > +		if (is_atomic)
> > +			udelay(QED_BAR_ACQUIRE_TIMEOUT_UDELAY);
> > +		else
> > +			usleep_range(QED_BAR_ACQUIRE_TIMEOUT_USLEEP,
> > +				     QED_BAR_ACQUIRE_TIMEOUT_USLEEP *
> 2);
> >  	}
> >
> >  	DP_NOTICE(p_hwfn, "PTT acquire timeout - failed to allocate PTT\n");
> >  	return NULL;
> >  }
> >
> > +struct qed_ptt *qed_ptt_acquire(struct qed_hwfn *p_hwfn) {
> > +	return _qed_ptt_acquire(p_hwfn, false); }
> > +
> >  void qed_ptt_release(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
> > {
> >  	spin_lock_bh(&p_hwfn->p_ptt_pool->lock);
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c
> > b/drivers/net/ethernet/qlogic/qed/qed_l2.c
> > index 2edd6bf64a3c..46d8d35dc7ac 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
> > @@ -1863,7 +1863,7 @@ static void __qed_get_vport_stats(struct
> > qed_hwfn *p_hwfn,  }
> >
> >  static void _qed_get_vport_stats(struct qed_dev *cdev,
> > -				 struct qed_eth_stats *stats)
> > +				 struct qed_eth_stats *stats, bool is_atomic)
> >  {
> >  	u8 fw_vport =3D 0;
> >  	int i;
> > @@ -1872,7 +1872,7 @@ static void _qed_get_vport_stats(struct qed_dev
> > *cdev,
> >
> >  	for_each_hwfn(cdev, i) {
> >  		struct qed_hwfn *p_hwfn =3D &cdev->hwfns[i];
> > -		struct qed_ptt *p_ptt =3D IS_PF(cdev) ?
> qed_ptt_acquire(p_hwfn)
> > +		struct qed_ptt *p_ptt =3D IS_PF(cdev) ?
> _qed_ptt_acquire(p_hwfn,
> > +is_atomic)
> >  						    :  NULL;
> >  		bool b_get_port_stats;
> >
> > @@ -1899,7 +1899,8 @@ static void _qed_get_vport_stats(struct qed_dev
> *cdev,
> >  	}
> >  }
> >
> > -void qed_get_vport_stats(struct qed_dev *cdev, struct qed_eth_stats
> > *stats)
> > +void qed_get_vport_stats(struct qed_dev *cdev, struct qed_eth_stats
> *stats,
> > +			 bool is_atomic)
> >  {
> >  	u32 i;
> >
> > @@ -1908,7 +1909,7 @@ void qed_get_vport_stats(struct qed_dev *cdev,
> struct qed_eth_stats *stats)
> >  		return;
> >  	}
> >
> > -	_qed_get_vport_stats(cdev, stats);
> > +	_qed_get_vport_stats(cdev, stats, is_atomic);
> >
> >  	if (!cdev->reset_stats)
> >  		return;
> > @@ -1960,7 +1961,7 @@ void qed_reset_vport_stats(struct qed_dev
> *cdev)
> >  	if (!cdev->reset_stats) {
> >  		DP_INFO(cdev, "Reset stats not allocated\n");
> >  	} else {
> > -		_qed_get_vport_stats(cdev, cdev->reset_stats);
> > +		_qed_get_vport_stats(cdev, cdev->reset_stats, false);
> >  		cdev->reset_stats->common.link_change_count =3D 0;
> >  	}
> >  }
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.h
> > b/drivers/net/ethernet/qlogic/qed/qed_l2.h
> > index a538cf478c14..2bb93c50a2e4 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_l2.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_l2.h
> > @@ -249,7 +249,8 @@ qed_sp_eth_rx_queues_update(struct qed_hwfn
> *p_hwfn,
> >  			    enum spq_mode comp_mode,
> >  			    struct qed_spq_comp_cb *p_comp_data);
> >
> > -void qed_get_vport_stats(struct qed_dev *cdev, struct qed_eth_stats
> > *stats);
> > +void qed_get_vport_stats(struct qed_dev *cdev,
> > +			 struct qed_eth_stats *stats, bool is_atomic);
> >
> >  void qed_reset_vport_stats(struct qed_dev *cdev);
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c
> > b/drivers/net/ethernet/qlogic/qed/qed_main.c
> > index c91898be7c03..307856c4ed22 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_main.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
> > @@ -3101,7 +3101,7 @@ void qed_get_protocol_stats(struct qed_dev
> > *cdev,
> >
> >  	switch (type) {
> >  	case QED_MCP_LAN_STATS:
> > -		qed_get_vport_stats(cdev, &eth_stats);
> > +		qed_get_vport_stats(cdev, &eth_stats, false);
> >  		stats->lan_stats.ucast_rx_pkts =3D
> >  					eth_stats.common.rx_ucast_pkts;
> >  		stats->lan_stats.ucast_tx_pkts =3D
> > @@ -3161,7 +3161,7 @@ qed_fill_generic_tlv_data(struct qed_dev *cdev,
> struct qed_mfw_tlv_generic *tlv)
> >  		}
> >  	}
> >
> > -	qed_get_vport_stats(cdev, &stats);
> > +	qed_get_vport_stats(cdev, &stats, false);
> >  	p_common =3D &stats.common;
> >  	tlv->rx_frames =3D p_common->rx_ucast_pkts + p_common-
> >rx_mcast_pkts +
> >  			 p_common->rx_bcast_pkts;
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede.h
> > b/drivers/net/ethernet/qlogic/qede/qede.h
> > index f90dcfe9ee68..312b1c2484fe 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede.h
> > +++ b/drivers/net/ethernet/qlogic/qede/qede.h
> > @@ -569,7 +569,7 @@ void qede_set_udp_tunnels(struct qede_dev *edev);
> > void qede_reload(struct qede_dev *edev,
> >  		 struct qede_reload_args *args, bool is_locked);  int
> > qede_change_mtu(struct net_device *dev, int new_mtu); -void
> > qede_fill_by_demand_stats(struct qede_dev *edev);
> > +void qede_fill_by_demand_stats(struct qede_dev *edev, bool
> > +is_atomic);
> >  void __qede_lock(struct qede_dev *edev);  void __qede_unlock(struct
> > qede_dev *edev);  bool qede_has_rx_work(struct qede_rx_queue *rxq);
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> > b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> > index 8034d812d5a0..7e40e35d990c 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> > @@ -408,7 +408,7 @@ static void qede_get_ethtool_stats(struct
> net_device *dev,
> >  	struct qede_fastpath *fp;
> >  	int i;
> >
> > -	qede_fill_by_demand_stats(edev);
> > +	qede_fill_by_demand_stats(edev, false);
> >
> >  	/* Need to protect the access to the fastpath array */
> >  	__qede_lock(edev);
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c
> > b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > index 953f304b8588..6c4187e5faa5 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > @@ -301,12 +301,12 @@ module_exit(qede_cleanup);  static int
> > qede_open(struct net_device *ndev);  static int qede_close(struct
> > net_device *ndev);
> >
> > -void qede_fill_by_demand_stats(struct qede_dev *edev)
> > +void qede_fill_by_demand_stats(struct qede_dev *edev, bool is_atomic)
> >  {
> >  	struct qede_stats_common *p_common =3D &edev->stats.common;
> >  	struct qed_eth_stats stats;
> >
> > -	edev->ops->get_vport_stats(edev->cdev, &stats);
> > +	edev->ops->get_vport_stats(edev->cdev, &stats, is_atomic);
> >
> >  	p_common->no_buff_discards =3D stats.common.no_buff_discards;
> >  	p_common->packet_too_big_discard =3D
> > stats.common.packet_too_big_discard;
> > @@ -413,7 +413,7 @@ static void qede_get_stats64(struct net_device
> *dev,
> >  	struct qede_dev *edev =3D netdev_priv(dev);
> >  	struct qede_stats_common *p_common;
> >
> > -	qede_fill_by_demand_stats(edev);
> > +	qede_fill_by_demand_stats(edev, true);
> >  	p_common =3D &edev->stats.common;
> >
> >  	stats->rx_packets =3D p_common->rx_ucast_pkts +
> > p_common->rx_mcast_pkts + diff --git a/include/linux/qed/qed_eth_if.h
> > b/include/linux/qed/qed_eth_if.h index e1bf3219b4e6..f2893b6b4cb3
> > 100644
> > --- a/include/linux/qed/qed_eth_if.h
> > +++ b/include/linux/qed/qed_eth_if.h
> > @@ -319,7 +319,7 @@ struct qed_eth_ops {
> >  				  struct eth_slow_path_rx_cqe *cqe);
> >
> >  	void (*get_vport_stats)(struct qed_dev *cdev,
> > -				struct qed_eth_stats *stats);
> > +				struct qed_eth_stats *stats, bool is_atomic);
> >
> >  	int (*tunn_config)(struct qed_dev *cdev,
> >  			   struct qed_tunn_params *params);
> > --
> > 2.27.0
> >
