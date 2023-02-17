Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A7169A6C7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 09:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBQIV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 03:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQIVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 03:21:24 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E2F1729;
        Fri, 17 Feb 2023 00:21:23 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31H7oPiB032227;
        Fri, 17 Feb 2023 00:21:16 -0800
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nsg88bqg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 00:21:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXPR0q/di6yMngzYK9ub204LZ+PBHFON/gApvFFhTpkdH1TkJthYj2PS2VzKlqGxeLUqsYGLUZq9kAvGNDZhu359Q1wyTawIAFJ6uSCooyGKDNdDId7mfPynmKXueSstCIWOtK3T6PxU74uuwQ3X0FM5zzVZIxAgJTmMTaOMJO/bt4Q7MTkPepuD0qxGYT8TXM8+88voWJb/V7ndkFG8EbbvwpwoaZqmhBPKKNaZu9/y2aF124EO/sFEOjeZ8GLbz949Mvp3GrNDIN33JzkL4CCZP8WdzFgPqPZZmqshoC5zsSxbEeCjxPaODDsAVFqq2miTzjTN6YssopHqdpXfJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IX1f6JXxL7CQZDL1/JjAS5Wdj4QISE+0qgQtnBo5G/8=;
 b=PEhMlFViW6b3d5+FswBfSaT+NusKa/9bxuXueaDx0tKGwiVgItrmMN2R9/waEtcRl7kpB+d7BTTyx6vkyHPg9Nj06gE/7ICyqNOXYy3ZX6cgF3fTG8X+fjE6sAhh4fMow3/r4TLypgupvh7FHctH9/DmWB04vPRvWhVEwkc5s/b+IOF4CqyHjct+75cxVgIgJ0E4juAvPNxK5eQH8qMrjJHIQDqRlNJdHtCrHzC3BIOs8nFkOOmUBmXF1w7qlYfWCShr5lmyGMLnwNLymxXTXGlGvJvM4cNSdjfqLrCvRD7BFGSQywVOy6/WljairAyu1hoQmjRgMIYX6eQx90QCuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IX1f6JXxL7CQZDL1/JjAS5Wdj4QISE+0qgQtnBo5G/8=;
 b=MvmgrI2eFO4JJGSbYIy9bXNbg9BeKWTqANP1zGW5NhP+cACZVvmlw/Ux3zCpSYeMX4fw5ZFu/OC5cuP29DVI/T0E4p9P+VJ/BVCwsafnSKbKbl33Dva5giXPRGJ3A2tXYyqB1RrpAj+5tgTG5WN6o8k5rWouUzvQSDdBaVPIlFc=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by MW3PR18MB3596.namprd18.prod.outlook.com (2603:10b6:303:5a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 08:21:12 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::c8d1:d5dd:1b5e:eacc]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::c8d1:d5dd:1b5e:eacc%2]) with mapi id 15.20.6043.038; Fri, 17 Feb 2023
 08:21:11 +0000
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
Subject: RE: [EXT] Re: [PATCH net-next v3 1/7] octeon_ep: defer probe if
 firmware not ready
Thread-Topic: [EXT] Re: [PATCH net-next v3 1/7] octeon_ep: defer probe if
 firmware not ready
Thread-Index: AQHZQDM4vC2nRdjWY0CmFFUwRXoMBq7OtByAgAQcW6A=
Date:   Fri, 17 Feb 2023 08:21:11 +0000
Message-ID: <BYAPR18MB24237CF1F92E27DB6C127BF0CCA19@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-2-vburru@marvell.com> <Y+vFlfakHj33DEkt@boxer>
In-Reply-To: <Y+vFlfakHj33DEkt@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMDc5ZjMxNjMtYWU5Yy0xMWVkLTgzNzUtZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XDA3OWYzMTY1LWFlOWMtMTFlZC04Mzc1LWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMzg5OSIgdD0iMTMzMjEwOTU2Njk0NTY1?=
 =?us-ascii?Q?MzM3IiBoPSJ5Y1BSalYrNlFtQ2NoZnkxSUgrK1BkUTJpNlE9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQURa?=
 =?us-ascii?Q?TWZqSnFFTFpBZWFpWWthS2UvUFE1cUppUm9wNzg5QU5BQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUR3QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
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
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|MW3PR18MB3596:EE_
x-ms-office365-filtering-correlation-id: 3c4e2b06-28a6-4edc-e528-08db10bfedd2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uVIU/DPp7E8EvuDdB1SKbg8ERL9BnkeIwIfVPmqh7IqXtYEY5mLMb8VKwOkNsEi1CgELXHPxocH3Jup8NAjJ4Vmh7MKD98siM7jvDNSGOLgXcnJEkwkvO41ouZ9xuwVMHkjA4OxjvnUBSwa6lrh9KGjmMZREQ+ay4nmyG7uB+ghlhzmcDzSh1OHgzCrY4jry8az6PdCugxnOwdtZyYlt22ibHfv/+AvUMK7xEtptZNsC7bCTZLAa8n+/3p9SJTJ8Is1n3z/2aGS01sGAsZI/Hu7+CPkdaPK437UceQgwLDvHyqJm6Q1qPCplY21Wqm/q2F9+xhzH0J6+wsiNFWWbQ2nM51J4DwhrzNWP6tN8onHRYYhPIjIKTgKFRJXk3jcwx6TvgPHmJUQ/rPGp6CVKJK5eU3o9VAV5nkiwcSOsdA8cRXdHs8FfKW0/3G0Uthcp4nkNR329U/ou7Gwi2kpjf0042ypODiiPj04l7deRyRCRiv//XnNc5soF148oGYTB3mV/NFVIt3olRS0/ffl4d/IQep1UlGTBpHUYhaJPnTRas20mgQVoN6v8XViaUbXGADjyHEhuWCRgRnMpvDPVBlzvebeBrlQpdjpyPARlwnvPhJbAT671oNdn9lBb7QfLEKa7WCntnQjnb1WF1CZbg4QHpIxDCYreAEvvPJb0qG1YirjRLA6vxVH9kSvQEpPpgj6xpd1MS+3MotwdizBgPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199018)(55016003)(8936002)(2906002)(6506007)(53546011)(26005)(186003)(9686003)(38100700002)(122000001)(71200400001)(38070700005)(54906003)(33656002)(316002)(478600001)(19627235002)(41300700001)(5660300002)(83380400001)(52536014)(4326008)(6916009)(86362001)(64756008)(66446008)(66946007)(66476007)(8676002)(76116006)(66556008)(7696005)(966005)(309714004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NhsT2tx9nhUb4C8OR5sujmrldkprqEQxmIzDjiU9KCfbFRlzSPRr66EAM1Ts?=
 =?us-ascii?Q?shGeBDetiemm2oYJAo/w3nvGQKzAgQnjEtAbcAI+85rkyvBab9jC1QvAh9De?=
 =?us-ascii?Q?ADlRJrBaNzJ0R3bmPWx0xJM+awHYHHU4ELVQ3XmbAhiuQEq/WFcFip3+pnwj?=
 =?us-ascii?Q?alFKvozpsffo7jiZfdlwsYmecIQVGshbHMWEF5fbJuFRkVCWGZO40wH0ujzR?=
 =?us-ascii?Q?LKLNYIDkfpknZMNboRbzhkSzYAV5wyhRYHIgo3CgFrbegubvJA9+1xU6UGsz?=
 =?us-ascii?Q?vFI7cojjgSO4/JTkHAIHcI7DU3oA9+Xr853J7O/UCQRGQdO1/gYmGlzBA/9C?=
 =?us-ascii?Q?Zx2UEKRBMUS0+8WvCwsrJmuVty8dKtEEkiEq/JntSeHl2pwtVGOYwd70zmP6?=
 =?us-ascii?Q?iI52z4q5KoZiBRx1ZyqWrpq9tbJLZ9GnhkrewrpE7JMGwifLByFTmdQuKRhi?=
 =?us-ascii?Q?aLH7uukOaR5zlq/r4V/s2Whm39cebYe6YPvOwHiehiWs9fhjjPEu3RHVod74?=
 =?us-ascii?Q?2ClXzqI+FXzopHAM2Dt11YOE4VAEE7tUfQ3C0FnsD/F+J3pSTyFexHt/X045?=
 =?us-ascii?Q?goL6xe4ulFVyJUrPYyy9PsSnaltyKQkiYvf7QiGSf35ZSE0I0is/h4W/71Le?=
 =?us-ascii?Q?sGCe5xj1F8BRGjoF0JFcOSLT9n2O2CsSIdOYcKIC9ZNPkYRyadBcUungc7JQ?=
 =?us-ascii?Q?QwvCGxgqVSRLxYIeBt1FzF6v9zSkAcJJLLbB8JcWm3MWEoCHlBU9mGQ4o+ZO?=
 =?us-ascii?Q?36HrjopLYYpixZNwz89MLOP0qyFvA5gaPqyVDC9OoEDZo6ge0sjVWZ3Q+40p?=
 =?us-ascii?Q?hv5nhr4YZ0g7A+tM8aykbvS6eGGieqRaUVduYpEkGMN8+3OueVzOfnQKYbW5?=
 =?us-ascii?Q?GJ5+qAO0Nb21M3VGArDKooUtWg8hTz7iU+IWzWyqyRSTGh+GLha9iw76Bm0R?=
 =?us-ascii?Q?MpIrDEkjA/pBDYxeongO01LJqtLbZg+Gp2/NN9PXaA9l6w3wMKgPk67LTNoK?=
 =?us-ascii?Q?aVfr5vTB6TdmOorw3Zq6qqLefvkt/I0M30KjWu5o5cPvAnjLeXu3vZni1j6R?=
 =?us-ascii?Q?zIHrJA6/yBR5OKDo6m4RS8aSB9Jg/BLS1Jri1Ke4hHBbr6nCfRGuJeZbp1Eh?=
 =?us-ascii?Q?F/fKu5pFRfbmFtReETv9rfv9S5iX6stqrdnHvKJ3YST/6hgvs6WXPORxq7Ub?=
 =?us-ascii?Q?eSRx1znduHqg+OCjvH02PNmB6OCR9Pp5IIHBrDsVoWXl99zj61NM0MyxFB6D?=
 =?us-ascii?Q?olabvcjdLmbc94bwGdlq3rlOCULkEOVyKyc+d8Sn5DIv1YDTcXkcb9jN4gjK?=
 =?us-ascii?Q?q/z7/Csi5W0REpQiEiy0GvcIlvZQQ/sQRAtfdr3ylAb4MfsbkgrGkh8r55Z0?=
 =?us-ascii?Q?uSttofKPh5q/+EegmWVNXavieQ6z8i5wWQIHeVgYXF07BN/9cQ6VSnvI/H2u?=
 =?us-ascii?Q?L4pWQtIOhdYGcSkYzcMgRNVyHKp4aOEuZEyzedWg0EGGed7TaPlaECuE/XXA?=
 =?us-ascii?Q?wxa5NCcGqzhrsM00WkP6gQ5ew0pbXJwR1JyZqLs+ayD0hDIr10E1UIMHTt2Q?=
 =?us-ascii?Q?gsINn4M55ZDOGu7DoTo+9kDyy/V/pGekYBCCn3kP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4e2b06-28a6-4edc-e528-08db10bfedd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 08:21:11.7407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bN3kGQEP27pYI07o7R/KNstN9Uf5QhiNooD0U+2VKsa++wk9weGR4Okp+EEw7clnh1tZZvOxVEd4uIONYSTp7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3596
X-Proofpoint-ORIG-GUID: ymgRQRV7VyzQiF9Rx64JjPUN9XNkrU_R
X-Proofpoint-GUID: ymgRQRV7VyzQiF9Rx64JjPUN9XNkrU_R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_04,2023-02-16_01,2023-02-09_01
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
> Sent: Tuesday, February 14, 2023 9:32 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Abhijit Ayareka=
r
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next v3 1/7] octeon_ep: defer probe if
> firmware not ready
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, Feb 13, 2023 at 09:14:16PM -0800, Veerasenareddy Burru wrote:
> > Defer probe if firmware is not ready for device usage.
> >
> > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > Signed-off-by: Satananda Burla <sburla@marvell.com>
> > ---
> > v2 -> v3:
> >  * fix review comments
> >    https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_all_Y4chWyR6qTlptkTE-
> 40unreal_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DXkP_75lnbPIeeucsP
> X36ZgjiMqEKttwZfwNyWMCLjT0&m=3D4b7d0RrdHBeSeuVxcgazZ-
> kuSb9u5rGArB5Mio0glbruzVrVD25vZP2M2f1jPteh&s=3DJhMZ44LA1ICu-
> gf3_8cI2F_pN7OFsWMNHp2Od7u26Gk&e=3D
> >    - change get_fw_ready_status() to return bool
> >    - fix the success oriented flow while looking for
> >      PCI extended capability
> >
> > v1 -> v2:
> >  * was scheduling workqueue task to wait for firmware ready,
> >    to probe/initialize the device.
> >  * now, removed the workqueue task; the probe returns EPROBE_DEFER,
> >    if firmware is not ready.
> >  * removed device status oct->status, as it is not required with the
> >    modified implementation.
> >
> >  .../ethernet/marvell/octeon_ep/octep_main.c   | 26
> +++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > index 5a898fb88e37..5620df4c6d55 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > @@ -1017,6 +1017,26 @@ static void octep_device_cleanup(struct
> octep_device *oct)
> >  	oct->conf =3D NULL;
> >  }
> >
> > +static bool get_fw_ready_status(struct pci_dev *pdev) {
> > +	u32 pos =3D 0;
> > +	u16 vsec_id;
> > +	u8 status;
> > +
> > +	while ((pos =3D pci_find_next_ext_capability(pdev, pos,
> > +						   PCI_EXT_CAP_ID_VNDR))) {
> > +		pci_read_config_word(pdev, pos + 4, &vsec_id); #define
> > +FW_STATUS_VSEC_ID  0xA3
> > +		if (vsec_id !=3D FW_STATUS_VSEC_ID)
> > +			continue;
> > +
> > +		pci_read_config_byte(pdev, (pos + 8), &status);
> > +		dev_info(&pdev->dev, "Firmware ready status =3D %u\n",
> status);
> > +		return status ? true : false;
>=20
> nit:
>=20
> return !!status;
>=20
> ?
>=20

Thank you for the feedback. Will update in next revision.

> > +	}
> > +	return false;
> > +}
> > +
> >  /**
> >   * octep_probe() - Octeon PCI device probe handler.
> >   *
> > @@ -1053,6 +1073,12 @@ static int octep_probe(struct pci_dev *pdev,
> const struct pci_device_id *ent)
> >  	pci_enable_pcie_error_reporting(pdev);
> >  	pci_set_master(pdev);
> >
> > +	if (!get_fw_ready_status(pdev)) {
> > +		dev_notice(&pdev->dev, "Firmware not ready; defer
> probe.\n");
> > +		err =3D -EPROBE_DEFER;
> > +		goto err_alloc_netdev;
> > +	}
> > +
> >  	netdev =3D alloc_etherdev_mq(sizeof(struct octep_device),
> >  				   OCTEP_MAX_QUEUES);
> >  	if (!netdev) {
> > --
> > 2.36.0
> >
