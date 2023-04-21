Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FCD6EA3A6
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 08:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjDUGRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 02:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjDUGRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 02:17:19 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B967DA2;
        Thu, 20 Apr 2023 23:17:05 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L5x352024388;
        Thu, 20 Apr 2023 23:16:55 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q3f5j9mx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 23:16:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHGuFN80EXVe0tB08u65rZPMBtw8Z3Op35M40oAry5mnFu76P86VvOXeVMUSiqSA+LIY+bpwcxeT5P0GatPUqR2qvxs2M3p0LVcPvEBYSIY5sKJdHLHRY6CzNTJRkuEWKHpqVMJumStej6d6JPQ2Kd6Fq+U9DGzNR5/0epbyxz+V3uWyUSxwiFSb2SF9cdSV6sW5ZzD14mcTRemB59+AqxmOctO9+tHxi4bncwaHAjSmOs7yIaWKGgz4thwigU5/Rn2Bft7SO9hUXdNY0Tcm/2BKeNbWGFdLBBx+9fH1ETx9uCBNfE9FHIQyYw/6iXYzJf9UAPcn2mfkdDfUohubAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RkSco1vrRNjsAj49iEovjokNZnCcyXTUltH6dqE2jWQ=;
 b=bMu7X56ekLosKOoD9cMSioYAmb6eUcIgK/xce0UOJRheRnYVXmjFpO3C8YaimxjycBh9AplBeVM4jZV17gow3tgTwDL69GG3A2Gtd1PKEDvkiG39kXJzfQVxwospP4wSM41BWMzKLSag4In0R6WL2+d/8h2aMsMRLqO73SkDu5j0eaqOqDzqDDV71I3M5+c/XJq+UviA+8MWEFOZXHoLdx/gPjkXhRHSD9Jv2VYs90jAepFhqzYjeZAGTAHjibJpC/vabrUG+CE4zBWcECMUey19FyL9zVuoNGy6j85srrFatcBDV6UEaxJ236qbbLwA7ZFGsWqvfsOTEAzaiQA4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkSco1vrRNjsAj49iEovjokNZnCcyXTUltH6dqE2jWQ=;
 b=fajDox9dxllYTDGiT10511sEawn1xXwV9fKZPJIezTwRWRGun0LCDncUs/0a299tqkonf+8hSBjVw9pzXbydiGuysTTREgYs2R1LZjgRtVDvUMNS9PE4AkImiEqrCs3fml8ZrCGNffS9q4Lf1Zjp1a42FkzpoZ69ceYn5jBprc4=
Received: from BY3PR18MB4737.namprd18.prod.outlook.com (2603:10b6:a03:3c8::7)
 by MN2PR18MB3040.namprd18.prod.outlook.com (2603:10b6:208:108::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 21 Apr
 2023 06:16:49 +0000
Received: from BY3PR18MB4737.namprd18.prod.outlook.com
 ([fe80::aeac:c6a9:1987:57ea]) by BY3PR18MB4737.namprd18.prod.outlook.com
 ([fe80::aeac:c6a9:1987:57ea%3]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 06:16:49 +0000
From:   Sunil Kovvuri Goutham <sgoutham@marvell.com>
To:     Tejun Heo <tj@kernel.org>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@meta.com" <kernel-team@meta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>,
        Srujana Challa <schalla@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH 07/22] net: octeontx2: Use alloc_ordered_workqueue()
 to create ordered workqueues
Thread-Topic: [EXT] [PATCH 07/22] net: octeontx2: Use
 alloc_ordered_workqueue() to create ordered workqueues
Thread-Index: AQHZc/wf5qoHZ0YhDkWGPdjOIGr5XK81RkWg
Date:   Fri, 21 Apr 2023 06:16:49 +0000
Message-ID: <BY3PR18MB47375D5899FC67F00AB11F88C6609@BY3PR18MB4737.namprd18.prod.outlook.com>
References: <20230421025046.4008499-1-tj@kernel.org>
 <20230421025046.4008499-8-tj@kernel.org>
In-Reply-To: <20230421025046.4008499-8-tj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2dvdXRoYW1c?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy0xNzMyYmI4My1lMDBjLTExZWQtYmVlZC1jYzE1?=
 =?us-ascii?Q?MzExYThlYjBcYW1lLXRlc3RcMTczMmJiODUtZTAwYy0xMWVkLWJlZWQtY2Mx?=
 =?us-ascii?Q?NTMxMWE4ZWIwYm9keS50eHQiIHN6PSI0MDk2IiB0PSIxMzMyNjUzMTQwNjIw?=
 =?us-ascii?Q?MjkwOTgiIGg9IlZKc1Q2dm1YV2JjRVoxVlM1c3BpbDc4bGV3QT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZSUFB?=
 =?us-ascii?Q?QXFVWXpaR0hUWkFhd0NZREsvbFhHeHJBSmdNcitWY2JFTkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBbzlpamZRQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBR1FBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFCakFI?=
 =?us-ascii?Q?UUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNn?=
 =?us-ascii?Q?QjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4737:EE_|MN2PR18MB3040:EE_
x-ms-office365-filtering-correlation-id: 0e54549c-db0f-42b8-f0f5-08db422ffdd9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a5Y6KVCpVG476+jZXe3mL1HN5ABE3WlHvA3+ADDsBdNEuBh6ekMdevwnv0aJQq5F2RwEWcb3y6u+nXH3Y6pYdvw0cuHMgch4erUWzKr63sRrjUiCoLyQkh0tkw+Mt6cSKP4gM3VFe8C5ai7VTG7e2hDTAlPAkxpxe5MmAK7UFygeoiP5gjPwXI/yFz0AN86M0PtxPBb6jP4lKNohVSi8kkrWKaG49mX1ePKp+O5JKSTg9oIzThr+EkNscZqrs4LXP8apoLBH0nNpDuW0hXQpIWVNS9oKzS6FIGYnb52qpwgb+QwgkmrSpo7YBNvsatG7LRNS5I4kyXnGvipkPKheN3Un/UG0cVDcLBIRTx8WeL8xtGtAHOGY1HrHnGDdtqOITBGVWigYGJ7CV05iqpPnJLjsosk6E3BA5PteVto02CGTfPhK9bMgHgrZv9owEs47BKQyegNZosYb7uSlM412vb/dg/9pG6ZsHGq//zC1JvqXbPuEM6CYnmwh5ycXkmzlHsJDcUId6jyH+/R7CSnqibRPmRRCUjgpdHpQ5Xw8FME98/k3SEmquQ9hlpHUn+/eJ6eBCpZyyBxKXoW1V8MPFEv2Ul8yPkkXvck6SClQignjwS0vitkHGnJ8WyEo4zrM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4737.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199021)(5660300002)(71200400001)(7696005)(66556008)(66476007)(64756008)(2906002)(66946007)(4326008)(76116006)(66446008)(33656002)(8936002)(38070700005)(41300700001)(122000001)(38100700002)(316002)(52536014)(8676002)(86362001)(478600001)(55016003)(54906003)(9686003)(110136005)(6506007)(26005)(53546011)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gcZ9hKZf6hDCVEFLuLCYqTQna+hRN65iWZ3ON5fmKMzcuecW02ZWoZffO7+z?=
 =?us-ascii?Q?Ak764t9W4HIBeDnUFSWkgRBPJZ7EvyZ7rfcW5nD1Ca1QQlOOjSy7lCNvEQWr?=
 =?us-ascii?Q?IS9dMx05XrC8t+uYU1762xcBz+s1avbCS0S5dzQGhvAHF93RWuerehznWNms?=
 =?us-ascii?Q?sRkzdDUh6hAFTOYaQbZyg8m1YBzGWRgDjlO6CWVSxmsmlT/paBBMcv5j9zaD?=
 =?us-ascii?Q?Nt1pRoiTuioxMmxxxwOXNz/6XbEr5zWGz4J74IntSrbZMLM6q1M81TOFjbwt?=
 =?us-ascii?Q?CkSvrxhBj9iwsI0V17sBMlpK6Qo92phElayCUo0UKUuNmgfMusE8N0QBlf3h?=
 =?us-ascii?Q?S7tAvimeQj27HyO6pfdR+M1S8Orjr0josYT4zUvGwIVt38c83kXobs6rabke?=
 =?us-ascii?Q?UF6YGqYKW8fF/PCo6/K75eijA0wjp63+Nq6OS1KxCBvtdrbmUr1ZA1wg42CX?=
 =?us-ascii?Q?OU+BYjN1rjxJFLdJlaRg0o3j29uIXW8+n1fkU8x3YAM5frNayhYd3Md4BJ7z?=
 =?us-ascii?Q?7wmrmEicOGsmeDHpYvqLM13Z9qUBJEImCswTJto+ktWDqCz9fftbjT1M3ieV?=
 =?us-ascii?Q?IogI8QL+90b6Vxg77+F+YRQMUvCCgW1LOuIPAtebWA3znXQaNNs1ndFah5AO?=
 =?us-ascii?Q?0VbhtEtaIstObQlKhIX7lwrFsHFSAsHEzFuhONMF+HfYnvYOSuSda9fX+UQO?=
 =?us-ascii?Q?N5phFG9XIE6STLKEg7e1a5X31tAsA0298KdKPenLef8cMjZKSRRdrEtMD5kN?=
 =?us-ascii?Q?Cu0dOiDZssKoAZKtFk7LwUCHF6SsFh7kNkeRuH65rT6tJSO7VRXuIziKHZH6?=
 =?us-ascii?Q?bSp6ahxVokqvImCvZ943HySN+rxMD6Z7cmIL220qKM3G6TaxWNM+5fOslv+b?=
 =?us-ascii?Q?PZV215ZLV5FGb0sU1HUPxzg//ACvZjcU409ZMDCJaq9dA2Wlmk3q35yzObsh?=
 =?us-ascii?Q?9KqXY2NxEqfEOObU7U81b/ZRY55zOaoplLF+G5yCWwBJxHgDwzhc5uqEfI9U?=
 =?us-ascii?Q?dArUnyOFNjUGtz/UMaasjbB0M8ePq4gJZfp/6LJk70gwZM1BuQx4yS5zuTv3?=
 =?us-ascii?Q?GcnUlU1EBwBH/mjnj+Bk6NSRsAz1YniImPVYdMmIoY6r7u8N+TvsKpjy4flR?=
 =?us-ascii?Q?nlJDGrlsNIygpzm6n76bVsMxvwtTw5AbN9B55nQm4HUHWnWqfqTTrVR4Wjtc?=
 =?us-ascii?Q?/6atlNkZGc7K6yv3uUxbOPZZNs4HTrXJSpyV+wWJGwOp6nw05hV43FIlti7b?=
 =?us-ascii?Q?9ffYrdeNDJvHH8J8IYGi1r04AFx1gZ060TN0i8wTx5xxXtdecypU2yducTNf?=
 =?us-ascii?Q?0uYeWQKjQpeP4lbmTThIb7gNLsWjnFhfk55M2ZDEED7pPUTWIEGOmARvPbRe?=
 =?us-ascii?Q?0CgNjEz6dvdi51oa1gxMgFLJRZVjlrr6/FExNAw73Wn1ZMsG2aBzV7E1EkEc?=
 =?us-ascii?Q?H5Mox19CAJjyWCbCK/hezxiqX1h0NlkCWXA11x80vhSR14NHA3Aul2cTn8gW?=
 =?us-ascii?Q?UoexB1aJau+FOIhdU+UPoc8sYbNttj8Rd5zPH5CoeN1PNpl3ttuVRaYLPy6o?=
 =?us-ascii?Q?nBFzod/0EwjsoFTrCuD64zHfT25WG5n3UyG9NZKj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4737.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e54549c-db0f-42b8-f0f5-08db422ffdd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 06:16:49.2555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yd1/jI2Mx7RNItfEXQFXC/GQ7Rb/3gohBLK1CBQsmFsgR7JNRUlTgtsFaVChduFiUoY3/TBp5H0BqXZRGebBpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3040
X-Proofpoint-GUID: H_ZeoBqiPJby0fcP74m-69esvinUYca1
X-Proofpoint-ORIG-GUID: H_ZeoBqiPJby0fcP74m-69esvinUYca1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_17,2023-04-20_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Tejun Heo <htejun@gmail.com> On Behalf Of Tejun Heo
> Sent: Friday, April 21, 2023 8:21 AM
> To: jiangshanlai@gmail.com
> Cc: linux-kernel@vger.kernel.org; kernel-team@meta.com; Tejun Heo
> <tj@kernel.org>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Ratheesh Kannoth <rkannoth@marvell.com>; Srujana Challa
> <schalla@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> netdev@vger.kernel.org
> Subject: [EXT] [PATCH 07/22] net: octeontx2: Use alloc_ordered_workqueue(=
)
> to create ordered workqueues
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> BACKGROUND
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> When multiple work items are queued to a workqueue, their execution order
> doesn't match the queueing order. They may get executed in any order and
> simultaneously. When fully serialized execution - one by one in the queue=
ing
> order - is needed, an ordered workqueue should be used which can be creat=
ed
> with alloc_ordered_workqueue().
>=20
> However, alloc_ordered_workqueue() was a later addition. Before it, an or=
dered
> workqueue could be obtained by creating an UNBOUND workqueue with
> @max_active=3D=3D1. This originally was an implementation side-effect whi=
ch was
> broken by 4c16bd327c74 ("workqueue: restore WQ_UNBOUND/max_active=3D=3D1
> to be ordered"). Because there were users that depended on the ordered
> execution,
> 5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active=3D=3D1 to be
> ordered") made workqueue allocation path to implicitly promote UNBOUND
> workqueues w/
> @max_active=3D=3D1 to ordered workqueues.
>=20
> While this has worked okay, overloading the UNBOUND allocation interface =
this
> way creates other issues. It's difficult to tell whether a given workqueu=
e actually
> needs to be ordered and users that legitimately want a min concurrency le=
vel wq
> unexpectedly gets an ordered one instead. With planned UNBOUND workqueue
> updates to improve execution locality and more prevalence of chiplet desi=
gns
> which can benefit from such improvements, this isn't a state we wanna be =
in
> forever.
>=20
> This patch series audits all callsites that create an UNBOUND workqueue w=
/
> @max_active=3D=3D1 and converts them to alloc_ordered_workqueue() as
> necessary.
>=20
> WHAT TO LOOK FOR
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The conversions are from
>=20
>   alloc_workqueue(WQ_UNBOUND | flags, 1, args..)
>=20
> to
>=20
>   alloc_ordered_workqueue(flags, args...)
>=20
> which don't cause any functional changes. If you know that fully ordered
> execution is not ncessary, please let me know. I'll drop the conversion a=
nd
> instead add a comment noting the fact to reduce confusion while conversio=
n is
> in progress.
>=20
> If you aren't fully sure, it's completely fine to let the conversion thro=
ugh. The
> behavior will stay exactly the same and we can always reconsider later.
>=20
> As there are follow-up workqueue core changes, I'd really appreciate if t=
he
> patch can be routed through the workqueue tree w/ your acks. Thanks.
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Sunil Goutham <sgoutham@marvell.com>
> Cc: Ratheesh Kannoth <rkannoth@marvell.com>
> Cc: Srujana Challa <schalla@marvell.com>
> Cc: Geetha sowjanya <gakula@marvell.com>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c     |  5 ++---
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c    | 13 +++++--------
>  .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c    |  5 ++---
>  3 files changed, 9 insertions(+), 14 deletions(-)
>=20
Reviewed-by: Sunil Goutham <sgoutham@marvell.com>=20
