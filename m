Return-Path: <netdev+bounces-3866-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 859817094AB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DAAE1C21253
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1636FD8;
	Fri, 19 May 2023 10:22:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D136FD7
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:22:12 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014A2E5D;
	Fri, 19 May 2023 03:22:07 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34J6BfiG019732;
	Fri, 19 May 2023 03:21:49 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qp3mkrr7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 May 2023 03:21:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BajJB8rwQHQrA/Bw5FwLmA5no2eCCH4xyDr09EEFnrOlNeWNZVAou9ty2/kfC08o5V9qxM0a85bitsktrurL53kYsqDGyRn19up3l3FdakhDcrbe85uZQCoIaj2MXzeNolyh1ZOgE/asIzoOt3DH3ZM0e0i3sZc3CflFG47YgEwO2ntuzgjLu//bGXzfg0qioUdR9gdlxleuIUP1BkQFEG2I6+Jbg05yj/99KqxQZ++5Hxpb1bhwEg2fDU4vAX3BqqUymokoDwr3WIS2qCVxMHWOicb5CkxB1pEsgfsRn3TLv8v2S2tTFFZfq6cmmOke+MfFBNQ5vAspf814ei8hOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oirORqPhval4i0A+JHDJ6wG3pXY8jf20oEqK/5sy9F4=;
 b=FlyIsoKZfP+raFHT7HBEOoZYlD8Y4ByB0Oh/IUga4xTwY+RtkNL15DAZrmaYJo0iaZQZDoH6R1meL26LIRE+u8TR30IxLWqwSNUyho06/Hogic2okL1UEUzLP4+6afPffg385K+5S+HLJfWbpgse5JwJ4EfUP10bUFeHOVPbtSHPPW/AzqUB/9mRFymTAZVYUcmFcsZb2o18MJ02RGYAczxF3W4FEUNRhsCxFSMRgDmswrJyuNbda5/ZzP9uRjkdiL0T1R4V5ikB9jNe50VEoKr2zek/8vyzOpBRSUbzymgBo8Dr5vBZfwisqXfkXb5jUSK0lWliy+W7sgp+PyYCUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oirORqPhval4i0A+JHDJ6wG3pXY8jf20oEqK/5sy9F4=;
 b=YTKtolNSppPAjf2AvUHKiKMWUwSb/valZVJ0Rtm46zW/fxlFrZGJq5VkRo+LfYT9W658eVTHr0cIm4aELtMjc1N+0mI+1vt1tRiY92aq8D7boRtFZfbbVEcEecfzZYnvxSy4ZRSXfImon1XzDvYnPLvlJ2m64bR6sbp8BK8G6f4=
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 (2603:10b6:301:68::33) by BN8PR18MB2531.namprd18.prod.outlook.com
 (2603:10b6:408:9f::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Fri, 19 May
 2023 10:21:45 +0000
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::652:d887:6cce:6a3]) by MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::652:d887:6cce:6a3%6]) with mapi id 15.20.6387.028; Fri, 19 May 2023
 10:21:45 +0000
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri
 Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org"
	<kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Subbaraya Sundeep Bhatta
	<sbhatta@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Srujana
 Challa <schalla@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: RE:  Re: [PATCH net-next v3] octeontx2-pf: Add support for page pool
Thread-Topic: Re: [PATCH net-next v3] octeontx2-pf: Add support for page pool
Thread-Index: AQHZiju2BsJ1e3XsIEK9sHIHdk/FbA==
Date: Fri, 19 May 2023 10:21:44 +0000
Message-ID: 
 <MWHPR1801MB1918D77C6C6A87F09BC5EDA1D37C9@MWHPR1801MB1918.namprd18.prod.outlook.com>
References: <20230519071352.3967986-1-rkannoth@marvell.com>
 <ZGdJRMfuXHnvVQy9@corigine.com>
In-Reply-To: <ZGdJRMfuXHnvVQy9@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccmthbm5vdGhc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy1mMjM5NDMxOC1mNjJlLTExZWQtYjZmMC04MDM4?=
 =?us-ascii?Q?ZmJmMmM2MjJcYW1lLXRlc3RcZjIzOTQzMWEtZjYyZS0xMWVkLWI2ZjAtODAz?=
 =?us-ascii?Q?OGZiZjJjNjIyYm9keS50eHQiIHN6PSIzMjQwIiB0PSIxMzMyODk2NTMwMjEy?=
 =?us-ascii?Q?NTAxNDIiIGg9IkxpOXR0NEl1UlA4bVhhZ3B1c1F2ajBlcUVwND0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQU1nTUFB?=
 =?us-ascii?Q?QmVFcEcwTzRyWkFieHkyQ2pJMk5hMXZITFlLTWpZMXJVVUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUJZREFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRRUJBQUFBNCtVdERBQ0FBUUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNB?=
 =?us-ascii?Q?QmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdC?=
 =?us-ascii?Q?MUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhV?=
 =?us-ascii?Q?QWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFNQUF5?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
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
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJm?=
 =?us-ascii?Q?QUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFh?=
 =?us-ascii?Q?UUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtB?=
 =?us-ascii?Q?SElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBRHdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQWJRQmhBSElBZGdCbEFHd0FYd0J3QUhJQWJ3QnFBR1VBWXdCMEFG?=
 =?us-ascii?Q?OEFiZ0JoQUcwQVpRQnpBRjhBY2dCbEFITUFkQUJ5QUdrQVl3QjBBR1VBWkFC?=
 =?us-ascii?Q?ZkFHRUFiQUJ2QUc0QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNn?=
 =?us-ascii?Q?QjJBR1VBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdCdUFHRUFiUUJsQUhN?=
 =?us-ascii?Q?QVh3QnlBR1VBY3dCMEFISUFhUUJqQUhRQVpRQmtBRjhBYUFCbEFIZ0FZd0J2?=
 =?us-ascii?Q?QUdRQVpRQnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHMEFZUUJ5QUhZQVpRQnNBR3dBWHdC?=
 =?us-ascii?Q?aEFISUFiUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJq?=
 =?us-ascii?Q?QUhRQVh3QmpBRzhBWkFCbEFITUFBQUFBQUFB?=
x-dg-refthree: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFB?=
 =?us-ascii?Q?SUFBQUFBQUo0QUFBQnRBR0VBY2dCMkFHVUFiQUJzQUY4QWNBQnlBRzhBYWdC?=
 =?us-ascii?Q?bEFHTUFkQUJmQUdNQWJ3QmtBR1VBY3dCZkFHUUFhUUJqQUhRQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUcw?=
 =?us-ascii?Q?QVlRQnlBSFlBWlFCc0FHd0FYd0J3QUhJQWJ3QnFBR1VBWXdCMEFGOEFiZ0Jo?=
 =?us-ascii?Q?QUcwQVpRQnpBRjhBY2dCbEFITUFkQUJ5QUdrQVl3QjBBR1VBWkFCZkFHMEFZ?=
 =?us-ascii?Q?UUJ5QUhZQVpRQnNBR3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dB?=
 =?us-ascii?Q?YkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdCdUFHRUFiUUJsQUhNQVh3QnlB?=
 =?us-ascii?Q?R1VBY3dCMEFISUFhUUJqQUhRQVpRQmtBRjhBYlFCaEFISUFkZ0JsQUd3QWJB?=
 =?us-ascii?Q?QmZBRzhBY2dCZkFHRUFjZ0J0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBZEFCbEFISUFi?=
 =?us-ascii?Q?UUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?RzBBWVFCeUFIWUFaUUJzQUd3QVh3QjNBRzhBY2dCa0FBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUE9Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR1801MB1918:EE_|BN8PR18MB2531:EE_
x-ms-office365-filtering-correlation-id: 627519ed-4fef-413e-7d78-08db5852d891
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 MLjmrxOMBikB29LXxLnz/iO56zeQQiDUSzgdJF8k0URzNgxiaWB8CqJvtiwQhKjN/nOHvK/jRxye7bjKq0rr4eQfQR1lREEfyIhcok1cc/C5/2zSkPRXOVEs3aa0PriAsCLL5B6VBIHcQF9lv95XcEls8bOvB18hrOkOuKIzEsQlr1kCMeyoEx/Yc3wZuZPiKVfUqPXc19mSp8frqIfFwYTT4T9x9RLcyL7S2Iv/p/RK7FheNBJrC5Vr1tpsJWOo4YPi4q6a/HrRiHZPiquvXZsYjyAPIeyF5vn0v7V0hI6FilQigz0xkX1+vA3os8iLDvYv86TKzuuf2eywJ9rKc+qzNy5AR98y2yNx4cRX1BuR5qQt5+O+8xB02MEYHtgJY6hAkWM6m7XBQNWdkCHZIt53/hQPt47RxcuupU+6S9xoP8dsqf8O77YUi4aEgDfJxLJ5BBggL3stgBkO7yYKH4mZfH3RBMgjJndQDbxctrEFKRUokA0qwj6OgG6V3xRMPF45+l4lSAuwfIh+h+CFuzzqZdJLcSyDZ2B4JjcgWnrmXUwn3If3vtT1wTajocBVHzuNFPrXHJoeXoDdddAPxPCdlFBeHKUZ+sysONZ7y3s=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1801MB1918.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(4326008)(966005)(6916009)(76116006)(66946007)(64756008)(478600001)(66556008)(7696005)(66476007)(66446008)(19627235002)(86362001)(54906003)(316002)(71200400001)(9686003)(53546011)(186003)(107886003)(83380400001)(6506007)(55016003)(52536014)(8936002)(41300700001)(38070700005)(38100700002)(2906002)(8676002)(33656002)(5660300002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?XveloOmZpUzmLqlRe5xFXYEhxqdAfX2ACxL7hR1B1sHjqLbQghbttwcs6p4z?=
 =?us-ascii?Q?K595CTbaBfha14bMSBzd2lEDq7PTyEfshgnDdLD3YyYjBDVD759TdoiQSeEg?=
 =?us-ascii?Q?NTWSu6/zNx6DdhUNaK8EQnF4JW83Nku5IuJN9fBsq+ENOkqnTQIc12wglnxG?=
 =?us-ascii?Q?klZhJJYlzqOOk9zyvdkViPa+Ij52APDaxlIvLjnTmJ9mGpQFuivVChpcRBCG?=
 =?us-ascii?Q?5USKX639zztDkLxqS4R7atTzKie6NfssnN+VS5r0nEOLlfLWPUBmwCqyPoWH?=
 =?us-ascii?Q?c2LhTYkHWl7+zmV0vur57x/9Lo++NoSKhNWQB84eKfEkkRvM1BTq6a6QAz++?=
 =?us-ascii?Q?KwGEFbTYhhFebCKJDbA7sE7kIr/ux+EUJohLlS7sCVypl7F4Wa1LIl2XJCyF?=
 =?us-ascii?Q?R31uIoLmMy/L62syZniOqxQ+ZnJjs6fFZZmiYvCZQp0RAUP1biptBI5Jsjqt?=
 =?us-ascii?Q?l6QISs6cvdjNMGWaZuvt4yj4J0MbMBbG+iIcUdESsd06m0EcQnt0U2rIiprd?=
 =?us-ascii?Q?237KOoi8+m4zkaSinSIffDvKaiHTWsJYELuawblGfSt4ktf8W22GInYv8PjF?=
 =?us-ascii?Q?k1eabQIIP4ji5LFJWCaArZCw05tRdzBNrtosklSSu+K70Vp5gtmRy4nfEzof?=
 =?us-ascii?Q?QqlYEeiZToFLCqvxbPtJSCFSmLGAuxiYmtXpop4YHhLm4imi6BsTrRdSl5vE?=
 =?us-ascii?Q?V1w1bQOCeIlkN1E4j4K05E5Cc/81L2xEAe8TYDT+0dZpgTAuj1aTdLVkkIqE?=
 =?us-ascii?Q?wYBfilUm8RsHAEMwJIAOUndPGXXlJd/SBV8tJarDeyomE/dC24EPo2G/loXZ?=
 =?us-ascii?Q?oOS9kvcWeWfuwtr18ui7O/8qaRGliaHMIX9L5/PZAIv/iwP4Auh6Fx99uWN8?=
 =?us-ascii?Q?G/KlwO7ma5NdM3NYdccXa5js/5AykX0KaL/TpIosYBzgj85+ts5xVS8D7Is1?=
 =?us-ascii?Q?fomHEoD4lbzptfxwecPMrVRJv0ODGb0nSYd/ckaZNhkvVCOsHGkWyJ2uiFbu?=
 =?us-ascii?Q?21oG03i0kDdj4VnNkcCoFlpHUAop1ZKEgdCB3VC5W90wQB0Pi3CODf7BTC58?=
 =?us-ascii?Q?C/ukA82G6gIxRU1xPn4B7bjW+EjCgWnEj6zIq0s1Xpw00m6SXairnanm22Jw?=
 =?us-ascii?Q?Mhfl6wYS1QM7HEwRhyPu0as3OriEj0ueB7VrzhTx4SuVbZgGw+lm7KTx2M9t?=
 =?us-ascii?Q?xSQmtKZCg6+pVHk/g5yFZCMieVAddVuVWXFSQGn6xymJGY4HJ97w2TPDjXAo?=
 =?us-ascii?Q?hLUAYS3ZueSZ2vfqsWHAvO0vrBYmq0e8/VUVT/XXceZt0mCMK3O2khHQXRB2?=
 =?us-ascii?Q?tRwOFkcn9rhOYjFu/2uo6WanaCXiydu6NZ/Im5iziRbnnPS1wjQE+PbBTy9x?=
 =?us-ascii?Q?CytJotnUMKYCncHtO/Ke+ffCEE81AdIE4MaZ3Fa7uK24B2rr1sQHM3V6iq3e?=
 =?us-ascii?Q?CZXVdTXlGjCHbg1eSZKw+MPwETZS5cTc7kk9X5IyWYxNyqf8KPrzFBU86l/i?=
 =?us-ascii?Q?rSUL31bvncCjmzMSl659nSV/z+kwyXz1/uyFdp3jcUJoAc/OP4Xk/hi3lhdu?=
 =?us-ascii?Q?fHdfqCTJCIZuv+Xa49qrzl2tRVRVAdC3XRo5cCUsi9/sVSGo0B3Dkme97X07?=
 =?us-ascii?Q?9VlmRw1sv1ki9s64FAmVVnHTUwZiQKkkJQtzgn+u8yhL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1801MB1918.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 627519ed-4fef-413e-7d78-08db5852d891
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 10:21:44.6739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+qOIr0uOuhhHDJUxHTh2eQn+FKsu5i3bw1+mGgYqDNNAF1PN4TtrngnLsO3UAbZT+AAzee6E+ieyI8U89aZXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB2531
X-Proofpoint-GUID: nBPPGkiTA7Hq433WACFg3SVPCXBIvXUz
X-Proofpoint-ORIG-GUID: nBPPGkiTA7Hq433WACFg3SVPCXBIvXUz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_06,2023-05-17_02,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Friday, May 19, 2023 3:33 PM
> To: Ratheesh Kannoth <rkannoth@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri
> Goutham <sgoutham@marvell.com>; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linyunsheng@huawei.com; Subbaraya Sundeep Bhatta
> <sbhatta@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> Srujana Challa <schalla@marvell.com>; Hariprasad Kelam
> <hkelam@marvell.com>
> Subject: [EXT] Re: [PATCH net-next v3] octeontx2-pf: Add support for page
> pool
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Fri, May 19, 2023 at 12:43:52PM +0530, Ratheesh Kannoth wrote:
> > Page pool for each rx queue enhance rx side performance by reclaiming
> > buffers back to each queue specific pool. DMA mapping is done only for
> > first allocation of buffers.
> > As subsequent buffers allocation avoid DMA mapping, it results in
> > performance improvement.
> >
> > Image        |  Performance
> > ------------ | ------------
> > Vannila      |   3Mpps
> >              |
> > with this    |   42Mpps
> > change	     |
> > ---------------------------
> >
> > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
>=20
> ...
>=20
> > @@ -1205,10 +1226,28 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
> >  	}
> >  }
> >
> > +void otx2_free_bufs(struct otx2_nic *pfvf, struct otx2_pool *pool,
> > +		    u64 iova, int size)
> > +{
> > +	u64 pa =3D otx2_iova_to_phys(pfvf->iommu_domain, iova);
> > +	struct page *page =3D virt_to_head_page(phys_to_virt(pa));
>=20
> nit: please arrange local variables in networking code in reverse xmas tr=
ee
>      order - longest line to shortest.
Variable "pa" is used in second line.  Are you suggesting to defer assignme=
nt later; and only declare variables here in reverse xmas tree style ?=20

=20
>=20
> 	u64 pa =3D otx2_iova_to_phys(pfvf->iommu_domain, iova);
> 	struct page *page;
>=20
> 	page =3D virt_to_head_page(phys_to_virt(pa));
>=20
>      The following tool can check this:
>=20
>         https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__github.com_ecree-
> 2Dsolarflare_xmastree&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3Daekcsy
> BCH00_LewrEDcQBzsRw8KCpUR0vZb_auTHk4M&m=3DEAM7f8UtMNRC57jfDp
> gqNsIClttVw6HHyCL7XecFBync-LgDwxIm9_45n-w-
> WvjY&s=3Dx_0EQ5wG1cZv01ySk_vzRX3kc8Bd2OALcpI8NgxYXTI&e=3D
>=20
> ...
>=20
> > @@ -1186,11 +1185,13 @@ bool otx2_sq_append_skb(struct net_device
> > *netdev, struct otx2_snd_queue *sq,  }
> > EXPORT_SYMBOL(otx2_sq_append_skb);
> >
> > -void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue
> > *cq)
> > +void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue
> > +*cq, int qidx)
> >  {
> >  	struct nix_cqe_rx_s *cqe;
> >  	int processed_cqe =3D 0;
> > -	u64 iova, pa;
> > +	struct otx2_pool *pool;
> > +	u16 pool_id;
> > +	u64 iova;
>=20
> Likewise here.
Okay
>=20
> >
> >  	if (pfvf->xdp_prog)
> >  		xdp_rxq_info_unreg(&cq->xdp_rxq);
>=20

-Ratheesh

