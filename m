Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1862E6D00D7
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjC3KNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjC3KN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:13:26 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8453F83DA;
        Thu, 30 Mar 2023 03:13:19 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32U3lCdO020366;
        Thu, 30 Mar 2023 03:13:13 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pn2ty1pp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 03:13:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtJIFkXj4ntK0EFPjkcAw81WvdUiTA5VwkTVPG4RKWY3WXSV1709IdaQ6/BWpN4B1VQE4XKmIb+ithuxAZSJDzyrw8mWvTVXrz/8Z8wbWVoaXgYcTcILPeGKBEDYw4H3m3nBsJTadAXYQ/fijfKwuyUy6FL22MtJkNmydSl4B254axY6w6y+yMmYU65v/ZrCAt1xb6yBUko0gAn3xs8CQjWC51WnAO2Cr0mK7HSiws9oNTwLjOIgAnDBgdw9uWQkqVbOWSyWIEtzPVk+DL/aR1Ue+Bm8/LgTvsx8Gu0A6aLt57rvB5eG7nd553c4oASr0OZCLbVacvQkx/Dlg7d/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eiCj98tplvwohP+199R41Ufw0szY4dFKLhgX3u1tArc=;
 b=Viat6hj0b3oWe4lXeU3xOUKBISv2B5MBZArKh/VXAvH2uVd8mI73xQUmjY4Yp1+RRHy56G5SbhdfStAl5F7kQ94Q3SVBG6sJVeRDPqX6H05uLK58rKdK2kmzsN9QxFrMJiEdV+xd5FW6DJwrAns+cG4XN7JiixJMGeXthMdj7lpTYzrlK+ro1Hpl+M0pdm3JwTc7DJtZZys29ftH0sbE8IB0icaXDekBDA30c+m1CJZMt/ftomJXee88zmNLgL9WX6i/DPxxcyzkfBgHWFT59sL78KEXHBtPF+rs4TnMoUdtSQ0p76jpIjMycmjw3UeylRU99bMUNc0Fxl75/2bUIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiCj98tplvwohP+199R41Ufw0szY4dFKLhgX3u1tArc=;
 b=kklhn8lOaMrd38pMMJVxQT1nFBLR7aZdfGUbkle+YSBfYN8ImWMWqxioCEkRnbigU5God2upk6la8mXjuK9m91fWEQOA4e8yYBSNae1tKhbCytMFDsksIGQE//SizGkF4ti4sYPTHQlJBH/d/sAjUHk6APeFtOmYJSi42FgGfG8=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by SN7PR18MB3919.namprd18.prod.outlook.com (2603:10b6:806:f5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Thu, 30 Mar
 2023 10:13:10 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251%3]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 10:13:10 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: [net PATCH 3/7] octeontx2-af: Add validation for lmac type
Thread-Topic: [net PATCH 3/7] octeontx2-af: Add validation for lmac type
Thread-Index: AQHZYvA698tMiSoOKkG9zrn76D6ClQ==
Date:   Thu, 30 Mar 2023 10:13:10 +0000
Message-ID: <BY3PR18MB47076BEBC13E5C0A36083C43A08E9@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-4-saikrishnag@marvell.com>
 <20230330061840.GM831478@unreal>
In-Reply-To: <20230330061840.GM831478@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy03NzhjM2EwNi1jZWUzLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcNzc4YzNhMDgtY2VlMy0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIzMzEyIiB0PSIxMzMyNDY0NDc4?=
 =?us-ascii?Q?ODcxNTQ5MTYiIGg9IlhHTXRUcFlEQk5oTjhhNElQalh2b3FvUk5Dcz0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBRGtmdVU1OEdMWkFVSXdMeVVNVXF0UVFqQXZKUXhTcTFBTkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBMUZIM2FBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
 =?us-ascii?Q?UUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4?=
 =?us-ascii?Q?QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VB?=
 =?us-ascii?Q?YmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJq?=
 =?us-ascii?Q?QUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFN?=
 =?us-ascii?Q?QUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdB?=
 =?us-ascii?Q?QUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhB?=
 =?us-ascii?Q?Y2dCa0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2?=
 =?us-ascii?Q?QUcwQVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFj?=
 =?us-ascii?Q?Z0JmQUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFB?=
 =?us-ascii?Q?QUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVB?=
 =?us-ascii?Q?RjhBY3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFu?=
 =?us-ascii?Q?Z0FBQUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFH?=
 =?us-ascii?Q?MEFaUUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3?=
 =?us-ascii?Q?QnpBR3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdj?=
 =?us-ascii?Q?QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0Fj?=
 =?us-ascii?Q?QUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFH?=
 =?us-ascii?Q?WUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpB?=
 =?us-ascii?Q?QmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRHdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFC?=
 =?us-ascii?Q?akFIUUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdF?=
 =?us-ascii?Q?QWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|SN7PR18MB3919:EE_
x-ms-office365-filtering-correlation-id: 531f764c-2ddd-4828-2a36-08db31075d77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zA4gbCwg8y+EZicXJDeXv19zbh2Guoqd6Kzt6tXLaSfsKVYnSenzzoNTeaTh1pJDguBOO82lY03pPcXn66zVZoDQ1r5UTbIvC0Eiii7NU8cA0RYe3y6kadWuhLNTPX42ZQGcQMeqr7k/j/XELeGTaVLq9wZ7M5N58CQqozQdsHHAk7iVvExPywnPZbU4ajuzNfK7HjhQIDU9E6E6Yv2PxNqitgcn6q7xbbKT3VtLt0QTBpEKFbM34E2AyENIvVN2yCNkCm4F8UJYf6Bx7hsngZxI9DLJhVfzh8yecz0EpPyqOpq5req/GpKVGBxqzLnd66wR4mSjVzJavIe8dIF3ZwWjWKxsD2f4Is10jrWtUpd17cK8bjQDCnQyq6NfnsmHSClqqN4eCZoOuUFqTVlu7NDT010dp6qNNPdZEawI38s4KP3REWcU3rRE7LcvFwrBljOso9UMKKpx6CSTlWw3kXPSB8jbdOL3KBckIvjQ4GfSODsaS/oV77Z1dXg/WzMDe5KHqP1AQSXjWvCZVBjsa6Vz2QGGrNPF0O4kLgZ+zioqJy8KvABXXYOfcBkw6qbXFoRMq4fBz/ofj5orNOnwao9dXXgGbvfNJUxrKCl5DnT9QsGC0ZifO5NKxNXFlCxa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199021)(5660300002)(8936002)(52536014)(41300700001)(2906002)(86362001)(66476007)(76116006)(66556008)(8676002)(66946007)(6916009)(4326008)(66446008)(64756008)(316002)(478600001)(54906003)(45080400002)(71200400001)(7696005)(107886003)(9686003)(6506007)(26005)(186003)(53546011)(122000001)(83380400001)(33656002)(38100700002)(38070700005)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3MA3L1UpOQdUb2tDRekZBKl+ADYGrcI5DXjZvylIeuSc8ogGFgvvmgezqAhz?=
 =?us-ascii?Q?Qtg/HN4zXPUxK8gMxe5sP5Nw/2ghuoIRVAmFXxgxJJ5bU4PdBtLQqcRDlVec?=
 =?us-ascii?Q?VqQfPABnknmm3h1ohLWd32jFWWtmN2MZHXs+0dZL5GyzRwZvSqAYSEpu3rgG?=
 =?us-ascii?Q?9hQ5tZg9yybmko1pSY9Q5AK0DOm0xI5H3jMBVCFTN9pdmj3bMaLMotUwZ8o/?=
 =?us-ascii?Q?A9VYUh6TUwQKsrWpYXOzb48GhekksVLYyQSADVtOVGNboBqpghrn92vrYVad?=
 =?us-ascii?Q?7EgOc8rjy2jEkyQ++ozYiL6esgiD9jFzdkkP0TPQ9QRwRZlawAzusR+KOMCq?=
 =?us-ascii?Q?nbEwqaPuSV1cDr8ojBIoSWxsGWv+6rrnpeJz5dr67jiu/2h6vu+re2LqJhwj?=
 =?us-ascii?Q?vOzXqVi2mTBp4LhUmCuMsXiSAUPdPcT6vijtzuAr1pcjqWhIn+Sl7M/uQ5+E?=
 =?us-ascii?Q?zXjEp0oTUyM2Vv/Uafuon+9TjkEpmmSor0u8vxTwknTq1aH3DmF0pbjCuB7V?=
 =?us-ascii?Q?e3QeHUxBeXTAfNFKV9dTpAv5oyn4P5KiKdRMuh8aHetrr3dz0gIcXweqIYgc?=
 =?us-ascii?Q?aess4L/yRRVFze7JEiKDycxhtgkrtPMc0cvK52mQbj6MPDKBstqprMbjP/yR?=
 =?us-ascii?Q?2TStk0np+xsbbUOc7FRrz6xH2ZXt0daDW0aiavhmcXckbXKjOPze5P2AVum6?=
 =?us-ascii?Q?UuoCpFjyoDyQIIyy1mTCifdDW/vCJFX6nkgePR7pwJFFZAW4+CtQlXMy9M+v?=
 =?us-ascii?Q?9tl0B066pCss2xy8ZcnWSAnzCZXwbYBjj8qK6EyPmo6+d48yr07rtuFqvum2?=
 =?us-ascii?Q?c5gPCSDqWXuYN/lk3Tqfz4dnmdC5CjkcqXTY0zLlUMYe66Gy5IqVCjbeYDfc?=
 =?us-ascii?Q?nBxO7KBET0rSaOJjiPUVRC7+4G60kgYJC2wf5tD7ASmojdZkSomMAquAckDF?=
 =?us-ascii?Q?vkdEBTE21TpcfhwtzXraie59ASLexNqLMMQC9xCygPsC9jAGtot7ECyJQpjY?=
 =?us-ascii?Q?iqaYQ3uMffYlU2fQzf1Ce54OMxSH7zUq6uCJy/Oy4Q4XQSNNEzkOnA7LpknQ?=
 =?us-ascii?Q?0X3thh1OaLWegpKRGrwRsKmft/hWj/8vzBi7IxSFdmjUfFoudCVFCAI/gmZ1?=
 =?us-ascii?Q?NqWnruYsojGtrGQdcLGdUkQVfpV8dAoHDPlmW2ixN76KOzZSrBY2zABAxWCU?=
 =?us-ascii?Q?eWMZij5CKgGXs/VE1Adw6h9MXgHdc9SDfrVYC8R1Avns6AK5kMVIscWNQRAS?=
 =?us-ascii?Q?X+9K87mwnmx2COt3Ta4q0Ndcaf5e2g5AJ1BCeKJqhGQnbv+IY2AAA7gEOu4o?=
 =?us-ascii?Q?74yJXjR5gxMsyJhWV5DaALFSlys79C2BjX3xQqGxb1x9f5p+x1AFOy89NzCV?=
 =?us-ascii?Q?ndZSrbTr94wIFz5e55faRItlvqsGPCk4qnc18/aebLulOgy63wGnP94k3nDM?=
 =?us-ascii?Q?hTE5znifPbNQi8qEMVktZOQVYcr1mRdJVqCRrTujlWP4gcmfbP8ExxBXASjP?=
 =?us-ascii?Q?1CO0P8Gyk6LpcDn1piJPldSLbisoN0LcYh6v1REyg3dweeZRJElQFABpdJ1l?=
 =?us-ascii?Q?3wXqq2v9HapCPwsnKi9L/C1U+AdB9gp96tr1CZNv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 531f764c-2ddd-4828-2a36-08db31075d77
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 10:13:10.5370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0AZ2m5hTpQFeDG/SSaeCf03IQkBeKwQqO0YYhzDOj6EJAKHXXI87GDmUPxfMTE2J9h/H/7CWDSCobL6dl6lhkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB3919
X-Proofpoint-GUID: vvxJghEN0bJPHJpi2OKhBZRMRC5PTKrO
X-Proofpoint-ORIG-GUID: vvxJghEN0bJPHJpi2OKhBZRMRC5PTKrO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_04,2023-03-30_01,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline,

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, March 30, 2023 11:49 AM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> richardcochran@gmail.com; Hariprasad Kelam <hkelam@marvell.com>
> Subject: Re: [net PATCH 3/7] octeontx2-af: Add validation for lmac type
=20
> > From: Hariprasad Kelam <hkelam@marvell.com>
> >
> > Upon physical link change, firmware reports to the kernel about the
> > change along with the details like speed, lmac_type_id, etc.
> > Kernel derives lmac_type based on lmac_type_id received from firmware.
> >
> > In a few scenarios, firmware returns an invalid lmac_type_id, which is
> > resulting in below kernel panic. This patch adds the missing
> > validation of the lmac_type_id field.
> >
> > Internal error: Oops: 96000005 [#1] PREEMPT SMP
> > [   35.321595] Modules linked in:
> > [   35.328982] CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted
> > 5.4.210-g2e3169d8e1bc-dirty #17
> > [   35.337014] Hardware name: Marvell CN103XX board (DT)
> > [   35.344297] Workqueue: events work_for_cpu_fn
> > [   35.352730] pstate: 40400089 (nZcv daIf +PAN -UAO)
> > [   35.360267] pc : strncpy+0x10/0x30
> > [   35.366595] lr : cgx_link_change_handler+0x90/0x180
> >
> > Fixes: 61071a871ea6 ("octeontx2-af: Forward CGX link notifications to
> > PFs")
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > index 724df6398bbe..180aa84cf1c3 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > @@ -1231,6 +1231,13 @@ static inline void link_status_user_format(u64
> lstat,
> >  	linfo->an =3D FIELD_GET(RESP_LINKSTAT_AN, lstat);
> >  	linfo->fec =3D FIELD_GET(RESP_LINKSTAT_FEC, lstat);
> >  	linfo->lmac_type_id =3D FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
> > +
> > +	if (linfo->lmac_type_id >=3D LMAC_MODE_MAX) {
> > +		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d
> reported by firmware on cgx port%d:%d",
> > +			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
> > +		return;
>=20
> You are keeping old lmac_type, which is out-of-sync now.
> Why don't you do something like that?
>=20
> if (linfo->lmac_type_id >=3D LMAC_MODE_MAX) {
>   strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN - 1);
>   return;
> }
>=20
>=20
We will add the proposed change (Unknown). Since we need to know the firmwa=
re reported lmac type ID is proper or not, we will keep dev_err also.

Thanks,
Sai

> > +	}
> > +
> >  	lmac_string =3D cgx_lmactype_string[linfo->lmac_type_id];
> >  	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);  }
> > --
> > 2.25.1
> >
