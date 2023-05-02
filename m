Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4C56F3C42
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 05:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjEBDLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 23:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjEBDLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 23:11:18 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F40730FB;
        Mon,  1 May 2023 20:11:16 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3422Fob7009574;
        Mon, 1 May 2023 20:10:59 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q92rny43e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 May 2023 20:10:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ia9BNfnWhXmZgLh8IVfP11Q0uu5tXd/DbHnPvq3lARMFseEACE2zeDu1xN5qvO5li4EnKKVqXvp1dU0wf7CsGVCmLpuCbRJV++JHjknGHKj9IFlU4OpnGJkbr7F4r+hik1cQXyMhv7LuropBhpDA6n6SGcTya8s7eg2SHHJNxvUB+ZZ5WCXqeMZOe/C7aGJXQG2A2DQVjE7ohMr9LVtlBc7lPXEToVNASKiiCuQzjLf/GRwANUC1UF6btUilkqrBHmlKmK+0iJ5HBMvvK6L7LwNk+SrQN2TCcQi3exu4FX6o6ZIjbp+eDczGU/szHHgmz8DdxnvZ8xc2EWv63JgxOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnV3hes3KHr/bvDaTPV0NjQql+B1fZHVqgGXPIYfU4U=;
 b=CrtLQlv17F+o1wi/ArCw+SieynD1dmv1VDW6vM810Ykz85YBAV359HxhNWlVo4GVAvYl6Fwmd4OLMsqt7TLiAEKQjeqslwJh3nfVallPlCCUCIM/BSZipe2oQ5p19VB/1SOKNP9PWYpDPDQwg+KWB8JOexp5MHgJTV2O6ASUDam34fMHd6RZammOlr+ODrUQ6kI1BPHb7QAk+XKzE5iOL5HQHNtAWoLgSh4OLwaGlqeH7Dw7hfWrIVgiXxX6mxeA4BGXG1Xo+U8XjR7wrunK1JiLnB0EVIa3ViG56cq8VQXH1mX+Cz5dVz+/gAhsC0m0a9uY+VxhP2kTKwIZeDMHFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnV3hes3KHr/bvDaTPV0NjQql+B1fZHVqgGXPIYfU4U=;
 b=uoWWJ3oSfngc/iLBLZY42W7lbxQrWYnzH18yeChG1eoCbGJ78Fhz2YKhI7olsHtIbn4mRW5ZQMmPVsHTjnrsOGFkwieA9hDjaSQ/t/Jnben9+Ghgog/ymd646JrXapEg1SXGXl6X2j+R7RCf+j2D5EtLtP5ABfG9cHzbeUIY4W4=
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 (2603:10b6:301:68::33) by BY3PR18MB4753.namprd18.prod.outlook.com
 (2603:10b6:a03:3c8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 03:10:55 +0000
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::2f2d:d5a1:9884:5f1c]) by MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::2f2d:d5a1:9884:5f1c%7]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 03:10:54 +0000
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Sai Krishna Gajula <saikrishnag@marvell.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: RE: [EXT] Re: [net PATCH v4 09/10] octeontx2-af: Skip PFs if not
 enabled
Thread-Topic: [EXT] Re: [net PATCH v4 09/10] octeontx2-af: Skip PFs if not
 enabled
Thread-Index: AQHZeBMBs6KW8ovJ5U67xKEVlECPs689W86AgAj5UXA=
Date:   Tue, 2 May 2023 03:10:53 +0000
Message-ID: <MWHPR1801MB1918C1AE94BB287FE29FC76BD36F9@MWHPR1801MB1918.namprd18.prod.outlook.com>
References: <20230426074345.750135-1-saikrishnag@marvell.com>
 <20230426074345.750135-10-saikrishnag@marvell.com>
 <ZEj2UYNavsn0xE/D@corigine.com>
In-Reply-To: <ZEj2UYNavsn0xE/D@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccmthbm5vdGhc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy1lZmU3YzNlYi1lODk2LTExZWQtYjZlYy04MDM4?=
 =?us-ascii?Q?ZmJmMmM2MjJcYW1lLXRlc3RcZWZlN2MzZWMtZTg5Ni0xMWVkLWI2ZWMtODAz?=
 =?us-ascii?Q?OGZiZjJjNjIyYm9keS50eHQiIHN6PSI5MjEzIiB0PSIxMzMyNzQ3MDY0OTk0?=
 =?us-ascii?Q?MjQxMzYiIGg9ImNEaEY2bDNGblkzbGJrNWM1OHVhRzY3UWJMMD0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUJRSkFB?=
 =?us-ascii?Q?Q0lUM0d5bzN6WkFReE1RUGN4TXU1TERFeEE5ekV5N2tzT0FBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBRkFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
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
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR1801MB1918:EE_|BY3PR18MB4753:EE_
x-ms-office365-filtering-correlation-id: dab9da86-954f-4d36-a8cb-08db4abad732
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EbqYYIrW1z3EjU0NKGzsT9MKBMduIZleJegcxErihRDYhiPY9yqXjgDBx+FlnBPvCl3t2wJ2j7ZeTv1wP/rDna7r1nhg6zc8OHq5c0Q9gu+jAo2m2xWRQ3yCAlo5cYbmFlbNERdzH29x2gZCZXXrMjjB2SIvPp7P1ciMklofz7Liu6nyiN4H5HO6q6kx4049821jfKSfCCbF6d5z7A6Y6qlx5SAmO4P8LtMSG9mcilQ/ahkBI2upDSngFp2J1pch9eH7S7gEOHCWDQkfpjxaw7k9+VTEm6/HYvh6bLtsT8gnGddEkAiH01+x6Lv89f5YK6bTlmWEGk8gAT+CMyC4nt9695rhHjJYAlNou9croFbn48aGRIrz3CDHWCDaHN9fTZTscIkF2pSx5Kd/Xds2SdSi9+yXgZWzmuyZGAnH1tO7JQJTnys1ifuwFDkynZxbF6PxjKE/XpEIB2V9KR31kNKU/VHwhExQ8ZJnm6PSdPFlzlqLm4kzjbYCq637K0HZyp82fBbEL311smW0x8xXINDqHF3Vv8jmSBJ/L9hEaWbT8FsSLtfwqsYFVVRZr1+5C91XOfHEsLk9qzjkV1Zwmi7q6KgMZQNGaKQx5bjjJCkMFnTzr5mlQ5EEdWlzhZlZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1801MB1918.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199021)(41300700001)(122000001)(5660300002)(52536014)(38100700002)(8936002)(8676002)(66946007)(76116006)(66556008)(66446008)(64756008)(66476007)(4326008)(6636002)(316002)(2906002)(55016003)(38070700005)(86362001)(186003)(107886003)(55236004)(53546011)(9686003)(6506007)(26005)(7696005)(71200400001)(83380400001)(33656002)(478600001)(54906003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wdx92uklv1SVJkyywAIC3EbDihYOH55LTv+y8J54dF+TY3WTSIvh1y/+xdLw?=
 =?us-ascii?Q?9NBPFPUX4y6FxD58JDPaDe2dxmFU2G+lvzx53aslqKwzfXXBQmsRL0YZBdRC?=
 =?us-ascii?Q?ln6/89t2gpucsExP8e77prtT7P0T9a4L4ghSoLPXsnUhg5yp4LiVnSN0tGsg?=
 =?us-ascii?Q?SGh9H5wxYWTkkPiN9HoPZVOhy8MIklH5a3sgWZbZhrRRumv/M/O8N4aF0Q7z?=
 =?us-ascii?Q?IbitBgzCoMH3fYrDhLBVeY/fIyOdO4GS+yZ7Oiw7PUDlbjY+InR32Xp6DJt8?=
 =?us-ascii?Q?ua7qd1VjJT17VdZwqYJ9b7GvL2yvmWBCRppLmTHgA3RDO7uIN7OI85A9A6RF?=
 =?us-ascii?Q?Uf1TIyfEHIWSqzOc+w4e9qNqypH23uwxxqefo61sm84/WwF+aypPJ+FowQlH?=
 =?us-ascii?Q?pWiRj8jdDqH+Uc2WQqNscef/SUFoUyfiTDUmP2eV6FUOIEOs05q099AIXNfJ?=
 =?us-ascii?Q?E8n7J/mfj0wFMEWKN8BpJJNmTVW6gLB/LDCH4lkQWuUVFvx+sgFsUqKUhp2h?=
 =?us-ascii?Q?8gTibH6oSzG1Ty3ZKhFl70KLr8seRqDwxmya0RDJDFs4dZYhm8B3F/nH6jiR?=
 =?us-ascii?Q?y94qpOa93gJYsrNYgD5N8JsxZ0KMVSDdNw3EmQu5g/t4qm46Mpz/ak1jVAvq?=
 =?us-ascii?Q?6bbQ2uTCMQIUpb3yUb+VHyknmzrJyzzOofhixjBFGGVoeqC1e/buRHVmjz54?=
 =?us-ascii?Q?wvgGxXbIIpxN2PtU9RQ+IitHXoSQFPrCc7AzmTmy2sOfGubUUQEs/9E+5qTm?=
 =?us-ascii?Q?Gerdb7Dl9BrTQulk719a/S7E2ldexP4u+XkDtfExcPk9K1zquSr5/SjyTaQa?=
 =?us-ascii?Q?GZCNmxijYozaFZ2FOnv5wljr7nwqE16hu9Li8yuxCTCtw32TqH3TcFKydp1Q?=
 =?us-ascii?Q?g6c/mEnd5JdB2qwj4zXTc5KZfBh3BHiISPW37+xf2LTED51p7NMMghkM5f4n?=
 =?us-ascii?Q?LT4UacZrp3Igy9cAQOPZDNmnha43/mcCFgXFca5Sx5NjyOCvV1Df/Tacev5l?=
 =?us-ascii?Q?cdtqs9DLSiBCVDONcD2hy9A1cv1Rv2njf7q2qy7F/Ry9kUOep3CVw3+XJLZV?=
 =?us-ascii?Q?0LuPJucuxju5O/G1lmYZjlqIqYKIlypq0ZgGAiSALT4aNcTsFESEG29DBM7J?=
 =?us-ascii?Q?v1SbibFVslm81ZXCwI+1GAHl0q7qvxjs09CbgxBhGnRHgmAJDB17RyS9naow?=
 =?us-ascii?Q?rqUK1x2Q+d+b0sf+J2Kk59ARtsEXebMuHw9xZ70S3iUynBkd4z4BWjprU8aE?=
 =?us-ascii?Q?xpslFXdOujNA4tW13rXGUfS0wjT/UqTQZfHo8EHAhmValJ4ywblyM5H7h9RZ?=
 =?us-ascii?Q?d16dzrwhGkD/ysuwEt+OkEKpREH4FRUdRhmRPP0+2O/2GiZNYbuCEeeWL6Eg?=
 =?us-ascii?Q?osoLmhpWq6XeDnADk3Umxt2H7bPkwcpaIXEOed3acPHe6Qnyr+SmY4UBkxkB?=
 =?us-ascii?Q?z/MA2fWe3DvA29XaZILQLrQ7zawYSffcuCjgpznLiVp2ZqoIuaRCcXbwpNkG?=
 =?us-ascii?Q?T7fPznkZz33XIBdyl0OEYK5tudXVY2bf3enStrfJ2zIzXYCw5UwMi4lR35Um?=
 =?us-ascii?Q?3P6iSZ5ITzxsIFzYmpOkQ5Fubk18AK+ARCDRaCms?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1801MB1918.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab9da86-954f-4d36-a8cb-08db4abad732
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2023 03:10:53.7539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mSlSAB2am3s9Nu3YAPUpImHu9FgtGBUNfI7V3CM7XJbfn0PDLHdrG0zasP0B5siCf2hxuIMoshtXMJpPwdMQlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR18MB4753
X-Proofpoint-ORIG-GUID: YqAConR0ThZJuAEfvPT7cqp-aII0qxKT
X-Proofpoint-GUID: YqAConR0ThZJuAEfvPT7cqp-aII0qxKT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-01_16,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

Thanks for your review. Please find replies inline.=20

-Ratheesh

> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Wednesday, April 26, 2023 3:31 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; leon@kernel.org; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Ratheesh Kannoth
> <rkannoth@marvell.com>
> Subject: [EXT] Re: [net PATCH v4 09/10] octeontx2-af: Skip PFs if not ena=
bled
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Wed, Apr 26, 2023 at 01:13:44PM +0530, Sai Krishna wrote:
> > From: Ratheesh Kannoth <rkannoth@marvell.com>
> >
> > Fiwmware enables set of PFs and allocate mbox resources based on the
> > number of enabled PFs. Current driver tries to initialize the mbox
> > resources even for disabled PFs, which may waste the resources.
> > This patch fixes the issue by skipping the mbox initialization of
> > disabled PFs.
>=20
> FWIIW, this feels more like an enhancement than a fix to me.
[Ratheesh Kannoth] I agree, commit message convey this change as enhancemen=
t. But this=20
Code change fixes a crash in driver.  We will modify the commit message as =
below in next=20
Patchset version.=20
" Firmware enables PFs and allocate mbox resources for each of the PFs.
Currently PF driver configures mbox resources without checking whether
PF is enabled or not. This results in crash. This patch fixes this issue
by skipping disabled PF's mbox initialization. "
>=20
> > Fixes: 9bdc47a6e328 ("octeontx2-af: Mbox communication support btw AF
> > and it's VFs")
> > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > ---
> >  .../net/ethernet/marvell/octeontx2/af/mbox.c  |  5 ++-
> > .../net/ethernet/marvell/octeontx2/af/mbox.h  |  3 +-
> >  .../net/ethernet/marvell/octeontx2/af/rvu.c   | 44 ++++++++++++++++---
> >  3 files changed, 44 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
> > index 2898931d5260..9690ac01f02c 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
> > @@ -157,7 +157,7 @@ EXPORT_SYMBOL(otx2_mbox_init);
> >   */
> >  int otx2_mbox_regions_init(struct otx2_mbox *mbox, void **hwbase,
> >  			   struct pci_dev *pdev, void *reg_base,
> > -			   int direction, int ndevs)
> > +			   int direction, int ndevs, unsigned long *pf_bmap)
> >  {
> >  	struct otx2_mbox_dev *mdev;
> >  	int devid, err;
> > @@ -169,6 +169,9 @@ int otx2_mbox_regions_init(struct otx2_mbox
> *mbox, void **hwbase,
> >  	mbox->hwbase =3D hwbase[0];
> >
> >  	for (devid =3D 0; devid < ndevs; devid++) {
> > +		if (!test_bit(devid, pf_bmap))
> > +			continue;
> > +
> >  		mdev =3D &mbox->dev[devid];
> >  		mdev->mbase =3D hwbase[devid];
> >  		mdev->hwbase =3D hwbase[devid];
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > index 0ce533848536..26636a4d7dcc 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > @@ -96,9 +96,10 @@ void otx2_mbox_destroy(struct otx2_mbox *mbox);
> > int otx2_mbox_init(struct otx2_mbox *mbox, void __force *hwbase,
> >  		   struct pci_dev *pdev, void __force *reg_base,
> >  		   int direction, int ndevs);
> > +
> >  int otx2_mbox_regions_init(struct otx2_mbox *mbox, void __force
> **hwbase,
> >  			   struct pci_dev *pdev, void __force *reg_base,
> > -			   int direction, int ndevs);
> > +			   int direction, int ndevs, unsigned long *bmap);
> >  void otx2_mbox_msg_send(struct otx2_mbox *mbox, int devid);  int
> > otx2_mbox_wait_for_rsp(struct otx2_mbox *mbox, int devid);  int
> > otx2_mbox_busy_poll_for_rsp(struct otx2_mbox *mbox, int devid); diff
> > --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> > index 8683ce57ed3f..242089b6f199 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> > @@ -2282,7 +2282,7 @@ static inline void
> > rvu_afvf_mbox_up_handler(struct work_struct *work)  }
> >
> >  static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
> > -				int num, int type)
> > +				int num, int type, unsigned long *pf_bmap)
> >  {
> >  	struct rvu_hwinfo *hw =3D rvu->hw;
> >  	int region;
> > @@ -2294,6 +2294,9 @@ static int rvu_get_mbox_regions(struct rvu *rvu,
> void **mbox_addr,
> >  	 */
> >  	if (type =3D=3D TYPE_AFVF) {
> >  		for (region =3D 0; region < num; region++) {
> > +			if (!test_bit(region, pf_bmap))
> > +				continue;
> > +
> >  			if (hw->cap.per_pf_mbox_regs) {
> >  				bar4 =3D rvu_read64(rvu, BLKADDR_RVUM,
> >
> RVU_AF_PFX_BAR4_ADDR(0)) +
> > @@ -2315,6 +2318,9 @@ static int rvu_get_mbox_regions(struct rvu *rvu,
> void **mbox_addr,
> >  	 * RVU_AF_PF_BAR4_ADDR register.
> >  	 */
> >  	for (region =3D 0; region < num; region++) {
> > +		if (!test_bit(region, pf_bmap))
> > +			continue;
> > +
> >  		if (hw->cap.per_pf_mbox_regs) {
> >  			bar4 =3D rvu_read64(rvu, BLKADDR_RVUM,
> >  					  RVU_AF_PFX_BAR4_ADDR(region));
> @@ -2343,12 +2349,33 @@ static
> > int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
> >  	int err =3D -EINVAL, i, dir, dir_up;
> >  	void __iomem *reg_base;
> >  	struct rvu_work *mwork;
> > +	unsigned long *pf_bmap;
> >  	void **mbox_regions;
> >  	const char *name;
> > +	u64 cfg;
> > +
> > +	pf_bmap =3D bitmap_zalloc(num, GFP_KERNEL);
> > +	if (!pf_bmap)
> > +		return -ENOMEM;
> > +
> > +	/* RVU VFs */
> > +	if (type =3D=3D TYPE_AFVF)
> > +		bitmap_set(pf_bmap, 0, num);
> > +
> > +	if (type =3D=3D TYPE_AFPF) {
> > +		/* Mark enabled PFs in bitmap */
> > +		for (i =3D 0; i < num; i++) {
> > +			cfg =3D rvu_read64(rvu, BLKADDR_RVUM,
> RVU_PRIV_PFX_CFG(i));
> > +			if (cfg & BIT_ULL(20))
> > +				set_bit(i, pf_bmap);
> > +		}
> > +	}
> >
> >  	mbox_regions =3D kcalloc(num, sizeof(void *), GFP_KERNEL);
> > -	if (!mbox_regions)
> > +	if (!mbox_regions) {
> > +		bitmap_free(pf_bmap);
> >  		return -ENOMEM;
>=20
> Maybe it is more idiomatic to use
>=20
> 	goto free_bitmap;
>=20
[Ratheesh Kannoth] Agree. Will update the code.=20
> > +	}
> >
> >  	switch (type) {
> >  	case TYPE_AFPF:
> > @@ -2356,7 +2383,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct
> mbox_wq_info *mw,
> >  		dir =3D MBOX_DIR_AFPF;
> >  		dir_up =3D MBOX_DIR_AFPF_UP;
> >  		reg_base =3D rvu->afreg_base;
> > -		err =3D rvu_get_mbox_regions(rvu, mbox_regions, num,
> TYPE_AFPF);
> > +		err =3D rvu_get_mbox_regions(rvu, mbox_regions, num,
> TYPE_AFPF,
> > +pf_bmap);
> >  		if (err)
> >  			goto free_regions;
> >  		break;
> > @@ -2365,7 +2392,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct
> mbox_wq_info *mw,
> >  		dir =3D MBOX_DIR_PFVF;
> >  		dir_up =3D MBOX_DIR_PFVF_UP;
> >  		reg_base =3D rvu->pfreg_base;
> > -		err =3D rvu_get_mbox_regions(rvu, mbox_regions, num,
> TYPE_AFVF);
> > +		err =3D rvu_get_mbox_regions(rvu, mbox_regions, num,
> TYPE_AFVF,
> > +pf_bmap);
> >  		if (err)
> >  			goto free_regions;
> >  		break;
> > @@ -2396,16 +2423,19 @@ static int rvu_mbox_init(struct rvu *rvu, struc=
t
> mbox_wq_info *mw,
> >  	}
> >
> >  	err =3D otx2_mbox_regions_init(&mw->mbox, mbox_regions, rvu-
> >pdev,
> > -				     reg_base, dir, num);
> > +				     reg_base, dir, num, pf_bmap);
> >  	if (err)
> >  		goto exit;
> >
> >  	err =3D otx2_mbox_regions_init(&mw->mbox_up, mbox_regions, rvu-
> >pdev,
> > -				     reg_base, dir_up, num);
> > +				     reg_base, dir_up, num, pf_bmap);
> >  	if (err)
> >  		goto exit;
> >
> >  	for (i =3D 0; i < num; i++) {
> > +		if (!test_bit(i, pf_bmap))
> > +			continue;
> > +
> >  		mwork =3D &mw->mbox_wrk[i];
> >  		mwork->rvu =3D rvu;
> >  		INIT_WORK(&mwork->work, mbox_handler); @@ -2415,6
> +2445,7 @@ static
> > int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
> >  		INIT_WORK(&mwork->work, mbox_up_handler);
> >  	}
> >  	kfree(mbox_regions);
> > +	bitmap_free(pf_bmap);
> >  	return 0;
>=20
> Also, this could avoid duplication using:
>=20
> 	goto free_regions;
>=20
> >  exit:
> > @@ -2424,6 +2455,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct
> mbox_wq_info *mw,
> >  		iounmap((void __iomem *)mbox_regions[num]);
> >  free_regions:
> >  	kfree(mbox_regions);
>=20
> free_bitmap:
>=20
> > +	bitmap_free(pf_bmap);
> >  	return err;
> >  }
> >
> > --
> > 2.25.1
> >
