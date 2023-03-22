Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C046C4408
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 08:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjCVH0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 03:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCVH0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 03:26:51 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB8B126DE;
        Wed, 22 Mar 2023 00:26:50 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32M7Eog8007381;
        Wed, 22 Mar 2023 00:26:07 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3pdctpc5py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 00:26:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewbY8nXzRvOiQgjA+fjjxMAwc9S5xBZewGCAij6T4+ok7YPDCo0L3XKrpBShfKKuz8wvM5rBBLfolzq8yNgKi5ujlTwuR/fhWUOQe4GUcZEAISeLAslmpPhg9kKbUw/Q+swPBQLjJ0dD8EbyvAeRrrGvdyUQb/McPjjKilwViFUvF2PIxFIRpavbNUYHZoSG+CMFYxDNf8nriLSJrXtP//aX3a9ogvz25BY7f/20+JBM0+AoMXrPNM0Zb/hLNavP8RhN1UM/N8VyTwQgigPx+xnH+66Xh2CD+FIUlGGFraJWrqnKB+hNqoMOBhKGCUwdZgTSbosnAs5Wv9hWo7CFQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kEOQMjbARsPQx5T1Xlg9SJaW2Hv2W5Y9Cpi+R6FCCvE=;
 b=Bs7MocInB3ASqA+lmoAJZP0c7uvrRxMDG5jHG4jugVNjvl12Ls6toVx0hxQy4jXWwaVx5u9qtQ9yP1i2Tt4gG1Mp4BhFbNduI6c4ts/DTiID6cm8xiJOHXZu8CPHv4ZUYAqZk0t5rENBCf94kcQrLktXCVoVQZhtyxzt0PzGLQYO3qldDcdE6B7PuDJqdsiHW+QQ3/N7F8eJZyZrG43orinixpP+ofQN96Gv+qNCr/gQn0NR2J3KmDKBQWXrdh3iPcDo9T60vm6Po0l836fxZlSxBFbOSJMsF8xLDq3cWhfahxlMqEuEB/04ugowlFXnyfFQNWo60K40XanoWcyLmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEOQMjbARsPQx5T1Xlg9SJaW2Hv2W5Y9Cpi+R6FCCvE=;
 b=KgT+zFg/w+tHLhrzV6EGowaCbKXmW2NYPKBAvd8wQTOwLjIHNGPFuWuUQM0Wt7Wi3DYnKecnh3crDZf96ZGpdbZkOSdFcQK7l2rAJKgkiLkXFn3U/udGS73fH4ukVglpEYO3HPLZEWXGXFd63v0vSwgcSH2AUb7/YZKU9hCj8DE=
Received: from BYASPR01MB0053.namprd18.prod.outlook.com (2603:10b6:a03:b2::12)
 by PH0PR18MB4441.namprd18.prod.outlook.com (2603:10b6:510:e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 07:26:05 +0000
Received: from BYASPR01MB0053.namprd18.prod.outlook.com
 ([fe80::c472:7b3:b39a:50e2]) by BYASPR01MB0053.namprd18.prod.outlook.com
 ([fe80::c472:7b3:b39a:50e2%5]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 07:26:05 +0000
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
Subject: RE: [EXT] Re: [PATCH net-next v3 5/7] octeon_ep: support asynchronous
 notifications
Thread-Topic: [EXT] Re: [PATCH net-next v3 5/7] octeon_ep: support
 asynchronous notifications
Thread-Index: AQHZQDM6GPKcjWDLWUe8vgr/YQ1bB67QNs6AgDZndGA=
Date:   Wed, 22 Mar 2023 07:26:05 +0000
Message-ID: <BYASPR01MB0053FFDDDF3ED9122B0D917DCC869@BYASPR01MB0053.namprd18.prod.outlook.com>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-6-vburru@marvell.com> <Y+0J94sowllCe5Gs@boxer>
In-Reply-To: <Y+0J94sowllCe5Gs@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctY2NjMjhmNzItYzg4Mi0xMWVkLTgzNzctZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XGNjYzI4Zjc0LWM4ODItMTFlZC04Mzc3LWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMzM0NCIgdD0iMTMzMjM5NDM1NjM1MDE4?=
 =?us-ascii?Q?OTQwIiBoPSJyQU8zYThGbkRFQXYzMlFHV1JxVmNNallJS289IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUM4?=
 =?us-ascii?Q?VEJtUGoxelpBZmFUbkNMUVNvcHQ5cE9jSXRCS2ltME5BQUFBQUFBQUFBQUFB?=
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
x-ms-traffictypediagnostic: BYASPR01MB0053:EE_|PH0PR18MB4441:EE_
x-ms-office365-filtering-correlation-id: 82a68f0b-687b-47ed-f85d-08db2aa6b296
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +arD6xJzCbZr5mctcAqBFADiV1axn3SVh1KGYy6i3sGqzgA7i6/orIl0zQtJoL5sHY2Lu2FoPLGI83tC9YJ/23lxPgQ49mRzsqfY4/dgI81C8K49ZEMXEXNJG2b5smgKjJIuspLgf5OHPAOAjWm5iP3mO5TXDpp2f2tQLDQ3TcQya7NIpbs25VyX50b3VCRUlPuXJZL82fUT9zp2aSqy3PmGOk34eNAIP2SMncEhP6079moVr154Z86X9IqClzbJsnqrq0rzs+bUo5qmIhfuh/ki43a0HHQ8+Hq95dTppYvjN3OGuAL+n+m+AElMtfUsVUiUAyl76T6YTc75AdY5UpLf84BcMMMnmC3n+9dKa3qwMPJorAGBC7zCYrkG6NV1CSBOHuZyjtuMotsasFeC7XpehYYq0rUV5bH8idGaxRpz+Zs2og/Z8cd95MOnWY2jUQEnsfeFcbCC/tP40T2XuPnS9z4hBLSnAUv3wuBKM/g1hiqscYB7aITSdFYjADIBaMinAjivNvHfdfYMqgXwOLnVSpqrr1FK5MN1KsPhZ6xdDVTqK1z6l6hcMso3qErt7LcXF1dB++AqC04VQRNepesMVhMmE8wbn8HoU6nzUYjUBh9phBoTYr02LSc2G7or3fpcOi/MaqN8Y3XxmOtKWj4FWSQeiyCsSiobtO2MgCbgtZfTDIUbIDlPZP2fE5xgN0BQyywZrRvhAczz0GoAgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYASPR01MB0053.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199018)(7696005)(41300700001)(71200400001)(186003)(4326008)(83380400001)(478600001)(316002)(8676002)(64756008)(66556008)(76116006)(66446008)(66946007)(66476007)(6916009)(53546011)(9686003)(26005)(6506007)(54906003)(52536014)(8936002)(5660300002)(38100700002)(122000001)(2906002)(15650500001)(55016003)(38070700005)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dvJttHcqEaaduqzkSk9gTtZocgRBtesoPvQAmudIbNl/fwCXRH1M5LHrWRIq?=
 =?us-ascii?Q?4/ExtGv3iG1F/hMv+YIvTdRuGi8d9zCvuaMPeepLmPpfKZ/5gKtM/duPg9+V?=
 =?us-ascii?Q?AckkKHVW5QGVP5nfIa6Sr6NkD95wqWXNkWL/XOpvYnM9W9lzH+hEaxi6W08z?=
 =?us-ascii?Q?uvqgHtR4XNksiKbjNO3IaL5nP672l3J0+V0kM5W/4s+DPTOuufinZdE/dSx5?=
 =?us-ascii?Q?tjBfCOAKyl4EtjrV+cDBQD4LrsXuKAE7/GnO+xOWJUFUDkB2JK0sgWGeQGte?=
 =?us-ascii?Q?OkmXhV+OwVsV7jIjWtAbfqYQk0xzkBIqJEdKqNAKeFC0QNLa4Rnfc1CIvDG+?=
 =?us-ascii?Q?V9ngCry4JpYsBDPy6jtLedL3ANotjcYWhZRd0O1KjUjPiSkeqZhqChJ0fdbl?=
 =?us-ascii?Q?bQQSgBCrnUJ64vjMN+y6ha2MdylKg9ZyiTUlRocJyyfgOyCXTjZJ4TywZ1Ln?=
 =?us-ascii?Q?8Rri04Gt/8fkQdW+u9QvllVWuilBj6ljkkBpFkAwybO7eCPhBHuzKGKkC6V4?=
 =?us-ascii?Q?oSRjmWYuMY2Ps/DCHkrfBpE7/KpzvT2TCsfUqaHUHsF7/+tikvjQmNy0xGMq?=
 =?us-ascii?Q?f4O1REgVK0btYjlpCKEmHCYya3E+XzUTuSs9d3DeoOtHzkOCZBeTeSILS4yT?=
 =?us-ascii?Q?dWbunjc0gElY0xGJXPRZWNrAb2ppthkwzhcuVIn35aJtFyIZbz0fG/Keeb8J?=
 =?us-ascii?Q?1Xq0HbkrMEj+O0HVTS8uwMPKslAzp0Ms/aLek/ktJ6QKGiJ3r376cLP94Onz?=
 =?us-ascii?Q?9kiLJF3XZtqA8cFEpvSowPg0RZhW7J99M/4kUNYI5xqL59ojAuF8rXu8Js1d?=
 =?us-ascii?Q?zY1QJINBpVVurNFJgHwEagSi9Rw1zpTKLW/zd1cQK7KiaDm5pGbhI6NCUYjR?=
 =?us-ascii?Q?jEfGH017Ve9tHr0uio4EENqtF6IP+P3DeY6zvwsG+yGnkUpFH6+cQKG7iVit?=
 =?us-ascii?Q?/dnvqccgf/YbfafNoqOCSBU3ZgDn5ITZCosCjXVQfclEkjmVh9TeAvV5DPZY?=
 =?us-ascii?Q?ZyxAy6pFGWuZd49pQCY7hc9J98iLWAuY+wX3x1fGetYQq4lYY8Radi1GBvl4?=
 =?us-ascii?Q?R9BVULEFJPBqcfaz3ExBSz3Wz9FL/UaBimKLF3S/UGU2LAGtrLTaeWjRbOyT?=
 =?us-ascii?Q?fA0r+S2uixWnmBGNPRjNGIfVDxQt2nqYnmOYF63aXbzAjcqUzId1IGvuz0Xu?=
 =?us-ascii?Q?BZ5RateB+eJn+kkmRWRI7NOvv5p+LvoM1ab93IU1RXDl+guOePWvv59R3LPw?=
 =?us-ascii?Q?JhqRDcku64JBFkdvvAzJyBq6NDX8FK8lwFm/RfmRc/02tYzlpvW8I/Ws1nKa?=
 =?us-ascii?Q?oxKoDOD8+Slwn4gJnVUQE1SkYD/UpMGtsQT1Hyrwc8R2l9TPNBQVNj6ncPGI?=
 =?us-ascii?Q?S8YqTHeC3r4OA3qNL24nqHybaNVvio6W+TuU/mgVS/ZeK0jTZhLBdOoMVBhT?=
 =?us-ascii?Q?D+JShhopK3inEh3GZI1UZpxf5fhAjyZRiIZQlrVyERzcEJxEinWuubQBd8rx?=
 =?us-ascii?Q?UxCqtdokWqfnjMQxMA0NRN0G7egjeF/0KZ0SLCrwLhTR3k62GHy+AxPEPBqV?=
 =?us-ascii?Q?o4q/eeHscjyquZf0KbadVZEffMeZ1q+nPeo4gwle?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYASPR01MB0053.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a68f0b-687b-47ed-f85d-08db2aa6b296
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 07:26:05.1920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LBiZBjkm7rjTlW7szeYt4jYj/PVCDEwZaa1qHYwPqXOvv9J1k7EMvp3wz6f+5sLJ0AlyDBml33xhO75atxm0TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4441
X-Proofpoint-ORIG-GUID: -KL6TtOditB3mO_MhpVH91SgKnXPtNxY
X-Proofpoint-GUID: -KL6TtOditB3mO_MhpVH91SgKnXPtNxY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Wednesday, February 15, 2023 8:36 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Abhijit Ayareka=
r
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next v3 5/7] octeon_ep: support
> asynchronous notifications
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, Feb 13, 2023 at 09:14:20PM -0800, Veerasenareddy Burru wrote:
> > Add asynchronous notification support to the control mailbox.
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
> >  .../marvell/octeon_ep/octep_ctrl_net.c        | 29 +++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > index 715af1891d0d..80bcd6cd4732 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > @@ -279,6 +279,33 @@ static int process_mbox_resp(struct octep_device
> *oct,
> >  	return 0;
> >  }
> >
> > +static int process_mbox_notify(struct octep_device *oct,
>=20
> void
>=20

Will change in next revision.

> > +			       struct octep_ctrl_mbox_msg *msg) {
> > +	struct octep_ctrl_net_f2h_req *req;
> > +	struct net_device *netdev =3D oct->netdev;
>=20
> RCT
>=20

Will fix in next revision. I missed some RCT violations in this patchset. W=
ill take care for future submissions.
Thank you for kind review.

> > +
> > +	req =3D (struct octep_ctrl_net_f2h_req *)msg->sg_list[0].msg;
> > +	switch (req->hdr.s.cmd) {
> > +	case OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS:
> > +		if (netif_running(netdev)) {
> > +			if (req->link.state) {
> > +				dev_info(&oct->pdev->dev,
> "netif_carrier_on\n");
> > +				netif_carrier_on(netdev);
> > +			} else {
> > +				dev_info(&oct->pdev->dev,
> "netif_carrier_off\n");
> > +				netif_carrier_off(netdev);
> > +			}
> > +		}
> > +		break;
> > +	default:
> > +		pr_info("Unknown mbox req : %u\n", req->hdr.s.cmd);
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  int octep_ctrl_net_recv_fw_messages(struct octep_device *oct)  {
> >  	static u16 msg_sz =3D sizeof(union octep_ctrl_net_max_data); @@ -
> 303,6
> > +330,8 @@ int octep_ctrl_net_recv_fw_messages(struct octep_device
> *oct)
> >  			process_mbox_req(oct, &msg);
> >  		else if (msg.hdr.s.flags &
> OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
> >  			process_mbox_resp(oct, &msg);
> > +		else if (msg.hdr.s.flags &
> OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY)
> > +			process_mbox_notify(oct, &msg);
> >  	}
> >
> >  	return 0;
> > --
> > 2.36.0
> >
