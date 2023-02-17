Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B565769B1A6
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBQRPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBQRPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:15:53 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF2B6D242;
        Fri, 17 Feb 2023 09:15:52 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31HDQKnZ006208;
        Fri, 17 Feb 2023 09:15:41 -0800
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nsg88d3jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 09:15:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUVoZX/oOs4eKqYHoEm4h+/FJspW32VsAOjX9COuJ9n2oO4kL8bCKxfslMg0biD+LM4v/CSedahfF0zWHr3hBpAs1qPItx+BIkmwSFiHYMTtMm6EY9KOzOhg7/3PFz0svWJTd0r4j1gXMzZXUeEn3HybbfYp4EJlNvbqegK2wTq7vEZAMbNTsZdUSQqgmItGYR5sa+YFKpAW9l7f30Qv1B8wXe04EcK3qRFhinHMwtpc/6yPC7fSe6TpTXZ8lDgwjeE+PdD/iLl3U9Lb50nbQHLYylCFZOA3gYa/tRUXSW0Y8lWlu2IAi48yO2iPlZQlcwCV4ed9CKQqz9iUvRLwUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFCKlosRvXQTJltxsBNeIEYKnt0gnoDBrjvoOlQQWbU=;
 b=AQpDWOBiha52RgdDyn89gnxwgPUM4Bx3CfHAisRfs/citgL8zfzcEZKGRvf3NSEhb/GOdn6OTjBlDvvHRdcxmUFzqUslgi86EUOGXOJUyChlTF13v+zlqcWnNMzs4lIQhxEd1+jJQKkLKwq/i7o3scZQsYV1mgV77ErQIvjoMvhedoUGB4YawEmup3uvx92uc0tC/nKt0fColzHjMoyyTuVZp+sooe7k+45ryvYaV9FtR6pY0kC/P5SBCR0/RxeAEhiC5zM48boJn9Q28fuoNBxQSpMTkCtcrakLtvKNFImE42V5a89YIYL3o2kxEGV6UsGGkK+M2CdKwJL1ePPTeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFCKlosRvXQTJltxsBNeIEYKnt0gnoDBrjvoOlQQWbU=;
 b=btGqDSFfXBvfgTNqH5fT0xFPTw2EZns/ysjCW9XutItCGBXtdlkRrNojUv+eRceSnO3tYpbOHmcLMLBGtp8qSE90Cu6h2n/WaXvLinPOyfzPXMgdg3xdv4Xv+p/KE+nUmVqSgnz2vAyoOPm6Qys7EmK6BkksXH+UhOl93AO7Nfg=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by SJ0PR18MB4900.namprd18.prod.outlook.com (2603:10b6:a03:40b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 17:15:36 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::c8d1:d5dd:1b5e:eacc]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::c8d1:d5dd:1b5e:eacc%2]) with mapi id 15.20.6043.038; Fri, 17 Feb 2023
 17:15:36 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [EXT] Re: [PATCH net-next v3 3/7] octeon_ep: control mailbox for
 multiple PFs
Thread-Topic: [EXT] Re: [PATCH net-next v3 3/7] octeon_ep: control mailbox for
 multiple PFs
Thread-Index: AQHZQDM5TfIpJWwcB02yFpzhLnNpwa7OuNsAgAQZvUA=
Date:   Fri, 17 Feb 2023 17:15:36 +0000
Message-ID: <BYAPR18MB2423FE3DAC634559AC94CE66CCA19@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-4-vburru@marvell.com> <Y+vJkPO1UZPDSFT2@boxer>
In-Reply-To: <Y+vJkPO1UZPDSFT2@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctYWY5ODZlYjgtYWVlNi0xMWVkLTgzNzUtZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XGFmOTg2ZWI5LWFlZTYtMTFlZC04Mzc1LWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMzYwNyIgdD0iMTMzMjExMjc3MzQzNTI2?=
 =?us-ascii?Q?Nzk1IiBoPSJoVXNZcXdlR0h4NkdxaUhaM1lSWjhiVlhSc289IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUNM?=
 =?us-ascii?Q?RHlOeTgwTFpBWUhuczlMRFRLSjBnZWV6MHNOTW9uUU5BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTFGSDNhQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQURnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|SJ0PR18MB4900:EE_
x-ms-office365-filtering-correlation-id: bb663f32-a8a6-49fb-a65d-08db110a9607
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DGnFZqhPmbvM6MCUD11voW6ovaJP9sUgpjn6Gfdm7iHpw3XaxLKApd5Dp5ftzwsi/p58uk30rf+Xr3gkrNpWTrDDGKc2HCaWhxNXVyRWb/JIpbrQ8MGy9nLilhoDFGG7LktPbXrLe9anwzbMh3p1bFNGvvTmANz27j7vYX10Tdna8OKO26vYotiD9fYXvnI4dRrpu+DyyETc0eoNRvenTvOa5dzVnbkqsL681PyLfK7lKQtu1sKEbrr9YBMqQ9eI7IL9cDbF8HJ2mbXj3prPbu07cbI8nlQbQIft9FJBVhsJw5ThFDElHrJAl84o1ZBA0JVM0X6ugCkLF5X/hCPaNfNGBGP8XdFvydgj+k1NqZgFDSVXFpdJ5XOq7TITS2hxpGgq2CpydfHno1bE3scAhJQjStK8BdqPZbvF9jx/ZEK2biCJ2URmh9wf7HhE11ch5AvBnx1SOl0e1k3TUsmxXX2XE+Aw09kfY/adYWBwlAOoqSUclFARvGPiXtbjqWSZTgUBzX3dirUpee/omJ0HpIVWJEOXU+QN3u89Rl3mkKrFuOOCu55iXUR9Ag0NoLy8cwls5UF2Ssr9NKf5TOhsFwLu9rhZfNgfjGmnSHEVTbyfDNI59A4RXTyHFWZNI1Q4nTcSLKIMNAydOUNw6UXPqxbK+jKlY3Vyn/QMsI2ie5n0TO9hI7SaE5JZCHOil8zNNav40uLkh+qy1krv53F2TA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199018)(38070700005)(38100700002)(86362001)(122000001)(66446008)(33656002)(4326008)(5660300002)(64756008)(8676002)(66946007)(2906002)(55016003)(66476007)(6916009)(8936002)(76116006)(15650500001)(52536014)(66556008)(41300700001)(186003)(53546011)(83380400001)(9686003)(71200400001)(54906003)(316002)(6506007)(7696005)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J+Tqm8eEqR3iDihOA1Qv0efOb6cqJaa1TPW+D7B2wYOhNziLqcPp2HZzQ8Zz?=
 =?us-ascii?Q?bJ1Y2X07FUnU+wSihmtW/wCaBLEsNBodLxPD6ppoI2jL2UWEwjDj1nZyM4Cw?=
 =?us-ascii?Q?/l1qyVvZ/L+JAJ4JV0/QjgYZMPnflB10J3LKZZBCy2cwBB3pvgaDr25mPa6J?=
 =?us-ascii?Q?peZkGm4M9wpR3Vremf7PQ2GLOmymOMzP5bQNMaQ6Qx9Oi9ncYcug8VeZDJSP?=
 =?us-ascii?Q?9i7vw9J/A2ekNG3aXjzQIlhqetf4QfzJtszjSZnA6MIbHiwvMGe35EAvzFXT?=
 =?us-ascii?Q?4sNeLFrEqjJLteoYvpZsDd/ZFsO3cNqoIH5iH5zvndVKeAKaBr4MuzV0vAyM?=
 =?us-ascii?Q?Wx4cIFDVz1MfT3f2PensFcl0DtUyfagFdflRVQ4eHmBs22qQbxkvbUlToFAZ?=
 =?us-ascii?Q?iSXSk9uXaNgfZK8/AUkKosnJAttjPjfUDmknoYPT4NR9zN2nsVlo3QDsBDLc?=
 =?us-ascii?Q?ZqSGUWFdZ8+fzXBTLZM6iPPnhgBLtj8EAYXWxUjBfQsNjDk9T0KdsdRG1i+m?=
 =?us-ascii?Q?tMefUZGF23HqrUWJPFajtPkfljOcDhQzv0XH534+swehkMCB0pnCMB5uFMJA?=
 =?us-ascii?Q?jsN9ubmat02n5gA6r4XS7wf4+RNHi0+iRUYhNrrYOwCrwc5JVY1papU2SY4q?=
 =?us-ascii?Q?9JD61WnZnXhDUwYWLkLTugYgnxtSJskczVyLkQHMC669/Ax9L7C/W0E9q3Tz?=
 =?us-ascii?Q?rlpTpy8P7sndK3bfa3RZg/s/tjCDnUpkMQyCSJ+aMqoYJ7lAwmHaTV2AR3Od?=
 =?us-ascii?Q?ANI2AEu9xlNU+M8Qzq87KPONl4ANiSabRP4yeoHcgq4to+IRoYYTzer9Y4Ss?=
 =?us-ascii?Q?zPHQtQnBkEcF5ymVUkOkLQinLs0+36UsLoVEP48sbFvmfw5ds/QJDx5midKK?=
 =?us-ascii?Q?Xdw3nLwvT6NgT4mjCf90E4STvQ52LVU7UPoCSi+8ebFZ+GUq4GctDb3GUGMq?=
 =?us-ascii?Q?bznYL1TVABf0dI6slCHjR9SA/AM8WUhGNX3IN8lRADtaPUdu0UneEkyejkWi?=
 =?us-ascii?Q?UIz/WrXnLB3ANw3RaDgFm2+PsjBz9+gV8YY6BF4CzxUK8YwVT/vpsFBzb/T0?=
 =?us-ascii?Q?0BjdtA8GEjh0uRYpG67JU6Om6Y88eyKwdS3p87YS/bVPIQWaNh4UgXcWSIrG?=
 =?us-ascii?Q?at+rzg3Tu9WgXCk9GavLFwSjNqyNascTpg7xjjtPL3SugEOG6lUFkOysr8ry?=
 =?us-ascii?Q?zUXdzNM1crmM0ao0J8ei2M3xqs8mmtISn64Za4E1psldFUiESfgfj49jYw+a?=
 =?us-ascii?Q?H7+BOm4CHO9vdQD6iDoYPix7F86+0ybpDM1tyqwHKwnf+vXHbvvgSyuv86yO?=
 =?us-ascii?Q?aTXTDIFU5oQ/H3tiH1Nh6T1n5AHAMurUkkap9uT4CApMf+xM8cLc9irYDgRc?=
 =?us-ascii?Q?pXcjLobr1kxBnfj7yLc9MHaFx8GDohm1m0ffICWjPCJWh7ipFMFjLB4cRyrX?=
 =?us-ascii?Q?N47+8U7sbTVHhAIHEX7ulH41MdeKLeaVhFAPIKW65mauPtODKCeDCA5dDLsG?=
 =?us-ascii?Q?/hkVwL1Lz8bO/bSLlJL+kcL/qKjTC9G3rZcU2paBAz4IZPI+QcgYpjQYzt+/?=
 =?us-ascii?Q?bp/hHzFKBXYT8gN9ONR9LLFpgnyKjRk6/4Y3UA5yS9sgkTlSSGLPSkADHa8o?=
 =?us-ascii?Q?/1pcV/TUF/qIuz0cfsBWTbceYEBDgyAEYOsPT8JWAEV6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb663f32-a8a6-49fb-a65d-08db110a9607
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 17:15:36.7173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S2LosgD21Lzvzc3Y5WP7RDyboXjzGtE+kEPuMwMd8OyHW8q52BPKwJalzwdVIWV5ZQAYzLsIt6TJu60OAzLPjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4900
X-Proofpoint-ORIG-GUID: EE4O8sev3baex1D1DptlNmefT0q2j76x
X-Proofpoint-GUID: EE4O8sev3baex1D1DptlNmefT0q2j76x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_12,2023-02-17_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Tuesday, February 14, 2023 9:49 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Abhijit Ayareka=
r
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next v3 3/7] octeon_ep: control mailbox for
> multiple PFs
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, Feb 13, 2023 at 09:14:18PM -0800, Veerasenareddy Burru wrote:
> > Add control mailbox support for multiple PFs.
> > Update control mbox base address calculation based on PF function link.
> >
> > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > ---
> > v2 -> v3:
> >  * no change
> >
> > v1 -> v2:
> >  * no change
> >
> >  .../ethernet/marvell/octeon_ep/octep_cn9k_pf.c   | 16
> +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > index f40ebac15a79..c82a1347eed8 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > @@ -13,6 +13,9 @@
> >  #include "octep_main.h"
> >  #include "octep_regs_cn9k_pf.h"
> >
> > +#define CTRL_MBOX_MAX_PF	128
> > +#define CTRL_MBOX_SZ		((size_t)(0x400000 /
> CTRL_MBOX_MAX_PF))
> > +
> >  /* Names of Hardware non-queue generic interrupts */  static char
> > *cn93_non_ioq_msix_names[] =3D {
> >  	"epf_ire_rint",
> > @@ -199,6 +202,8 @@ static void octep_init_config_cn93_pf(struct
> octep_device *oct)
> >  	struct octep_config *conf =3D oct->conf;
> >  	struct pci_dev *pdev =3D oct->pdev;
> >  	u64 val;
> > +	int pos;
> > +	u8 link =3D 0;
>=20
> RCT again
>=20

Very sorry for missing these before submitting; Will take care next time.

> >
> >  	/* Read ring configuration:
> >  	 * PF ring count, number of VFs and rings per VF supported @@ -
> 234,7
> > +239,16 @@ static void octep_init_config_cn93_pf(struct octep_device
> *oct)
> >  	conf->msix_cfg.ioq_msix =3D conf->pf_ring_cfg.active_io_rings;
> >  	conf->msix_cfg.non_ioq_msix_names =3D
> cn93_non_ioq_msix_names;
> >
> > -	conf->ctrl_mbox_cfg.barmem_addr =3D (void __iomem *)oct-
> >mmio[2].hw_addr + (0x400000ull * 7);
> > +	pos =3D pci_find_ext_capability(oct->pdev, PCI_EXT_CAP_ID_SRIOV);
> > +	if (pos) {
> > +		pci_read_config_byte(oct->pdev,
> > +				     pos + PCI_SRIOV_FUNC_LINK,
> > +				     &link);
> > +		link =3D PCI_DEVFN(PCI_SLOT(oct->pdev->devfn), link);
> > +	}
> > +	conf->ctrl_mbox_cfg.barmem_addr =3D (void __iomem *)oct-
> >mmio[2].hw_addr +
> > +					   (0x400000ull * 8) +
>=20
> can you explain why s/7/8 and was it broken previously?
>=20

Thank you for the feedback.
Not broken; It works with 7.
It was an experimental change only; should not have been included in the up=
stream patch.
Will revert this change in next revision.

> > +					   (link * CTRL_MBOX_SZ);
> >  }
> >
> >  /* Setup registers for a hardware Tx Queue  */
> > --
> > 2.36.0
> >
