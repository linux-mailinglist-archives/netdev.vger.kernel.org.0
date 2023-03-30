Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1633B6D0646
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjC3NQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjC3NQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:16:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36E910DE;
        Thu, 30 Mar 2023 06:16:25 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UBmjho019105;
        Thu, 30 Mar 2023 13:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=f4jDnA55nWNuqiM57jPVHMgN1carbtNjJa10KrGN0cs=;
 b=gqGT7Tkj1x7vCnB6DgknOvk+9BUFKm+bdjDMWDVy2ZHREyNoQpOa8W+u95jyQ7Zd3czo
 iNgqaowmKxZgh2BUj3Wr0UHErpJ2KR7h99bFKg/uddtLJ/b9UNq6ztDh9BRHeCaV1X9+
 FUSFAbVY/7qteohyxGJvAciTG+ZQh3c2G6QurkZKWAJsBArfiCOXRDEN6/XmvJuck7IC
 3V/X7gwq4f1AFlR2pbuLB0P68uTgzzAbx/nEs9WLWyBtgaZzNCWJ0fqIxtWq0pJxK3SE
 Q566K13ZdjzdOoFl72RvRcZSqIAUTF9Td0nKZ85XCWtc5IHcWbdnLx24qREBQoH1shEl uA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq53ak9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 13:16:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32UBRU2Q010730;
        Thu, 30 Mar 2023 13:16:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd9mumh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 13:16:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwJADS3f9kZXIIkYCYccDB98pSMyzDy81jFP9/1/Jv/v/sCRY3Q1UyLxwtdUe2aa+sc+PspUUybRuKwNHZOEYR7hULObmko6/gaQHH5UXnxvqWmEh8WkV99inGo3dUP3yCDvCTMgkkS11hH5TbVtw9a1OxyAqv3elO0T2kCLg/9FG8u4Nt/JYfCQJNEF6qaRnIVq98sx5ysPoXWbLaIFR9SoN/8x3urgX7/HHbpIpP+pQFwcoHxSTb8nRjHMvrNJjcrAZWIlSHnqgNgVNtP40YUyfSnVh7O5IJDyonU73MGkdN6v9u6xHUqHGe+ZBgNfEuCwNAyWa4ZsXlpnM+L1NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4jDnA55nWNuqiM57jPVHMgN1carbtNjJa10KrGN0cs=;
 b=mWiySZAToc1sjHO2RO5Boo3kxQGUdBUkvNehk9dIxjTc/JaQIaBjXxF/9tlh/h6VF/QIu3Q6c0hebnqkBO/I4wBsuqN7VYDqX3cYNIRmK57pmCzfF6bOcvHF7hjfVWd2gVzZw4pU6Pto6s5D9nOT39rdu36rKLWa8C2sgrNpNZCnHZs9UWCJHHoIVFPetPHj5Q4Hp1AnpI+4OwAyKN0M1SMWR7AbWXAtG6Kyu2ZfK6rL3KYwGFHaOwuwIjmzG7hBlYVR7OhLgkX4AMUixCaZRvLIAYGbl8sS5Lv1DsiLj428rxEU2wr1Bxe+bQo579Ak9JuGNN6twEaOeR1gpI6SwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4jDnA55nWNuqiM57jPVHMgN1carbtNjJa10KrGN0cs=;
 b=vrVvu7PC0qLuCZLi33Szbf9UoBPy67IEafFfo85qTulaq6cvgcWZclvKYtd2kCc9YJ1auSQJKIFIPc0+ei/VpYpORjaBYeirfgkaCQjHQo7HixTqsYrhEQ0bOD/m45lZK+Jg4Je0wkNGSE4QsmA7miaB2A2L3Mi3Ddc7fQoi/sk=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 13:16:01 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%6]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 13:16:01 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     David Howells <dhowells@redhat.com>
CC:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Topic: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES)
 rather then sendpage
Thread-Index: AQHZYkj+dLwZN/D8CEye9eJOITPkS68R4ZoAgAExYICAADv/gA==
Date:   Thu, 30 Mar 2023 13:16:01 +0000
Message-ID: <C8E6146A-0987-402F-BD91-3114E9A18E1D@oracle.com>
References: <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com>
 <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-41-dhowells@redhat.com>
 <778590.1680169277@warthog.procyon.org.uk>
In-Reply-To: <778590.1680169277@warthog.procyon.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CO1PR10MB4627:EE_
x-ms-office365-filtering-correlation-id: 0d6744df-0e32-4cf7-e0b3-08db3120e8b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Czom1A7ISgjCxpVmbbqrdoBwYeZ/+GAnkKCMJTDrl5RMWX7mb6k2NH1cKsxxfEIx/WGy20maLiAgiu+3qNcCRxOXQtXP2txbGne4Gpt0mpJpiAlZvBIBgaga+wem8r0ICxUwOu96FF14bofcU7C1kde6eQtNSEoMm5EmeQS7/oCRolr9CGrbZSgzkgqrGcR/nFtJn81AbOUJ5vsBgV6ujCaH1/NZZbzJ7AmF5twnWaWIvOUBbXqLDib0iQKjUXLrrIiWvb3PFdUfcwY/2bnNgEwxs8sMV8zIK7fD+nciGdbwqVfJL6bGhLTtavmRnrCvkDh7U6WeMMbqqSR2EnfDEN4/AvMQ18P3P+aqWELhh9SBhILApXBhPcAbEgXt9unzqPDSjgBOweBAQkR8ciod1DYhuKfJh6bMuJ9zY6FCg4iSv/vKAkU9KaD1B5W5mqvTePSN77p0llT+mwJm1SBM+gi9cdQKciXg1WBbq+hOT6GzI5dDzICQQrMbZzPSofInvURjBgIbXbIsMHb7VL/F9Nc8xcm7cROBAYruYgSTq1zMyVmeZ7mwXrEVoj4QLjKhUIyEKGJo23BLMXWK+x1KBhGg0S3ZyxhOkiqfICovd7iYBRepDGmKNdYfQ2J5qG22Wq3xsa/S2srrwaTZTcBpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199021)(71200400001)(6486002)(38070700005)(186003)(36756003)(6506007)(33656002)(53546011)(26005)(86362001)(6512007)(4326008)(54906003)(2906002)(8676002)(6916009)(8936002)(316002)(66476007)(41300700001)(122000001)(64756008)(66946007)(66556008)(66446008)(4744005)(76116006)(38100700002)(91956017)(5660300002)(7416002)(478600001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M+MQN59ubkbqsHABGJi52HbhiSg027WBF700oVv+sg1EZpyLQ7eOIlaM4l9a?=
 =?us-ascii?Q?2fNTHuB0hVmS/Gsyeo6qDuolMoMDtIx2oC6VE26wa2DKMZvDY99gEco2Cmfl?=
 =?us-ascii?Q?YL0BbICh8NeYHeICJ84znI7GPRTGY0mfTkO6cLZQOKgsujKJVic73Ljxyndl?=
 =?us-ascii?Q?ShcGbeBC4a+3RUt9RG2QvxZxgviXs1AzjkUdHnCf3ttQ0g4ldHXOJeXWinkD?=
 =?us-ascii?Q?4dKypyaXMzzPtRme0lDf88jMHc0H0aAIxrdncYicmK+mYmNd0czHUDeOdf2M?=
 =?us-ascii?Q?gT6pmtKN5MWb99HVkbMYYpkLKkD5zbpqXP18ZUNJh+SqQyUmVBjqAqEilyRE?=
 =?us-ascii?Q?RbepiWzlRhaHBQmtxwgqabJdydPRf/Ov6PKT2Or8X+3IMXHJFR7MjveKZzlj?=
 =?us-ascii?Q?mQVoxjiXvQ9fcB0+ED4KTCQDDQB172kFG3j1EGo7FfoPnD8rx0fbTEl5rPqc?=
 =?us-ascii?Q?QOwkX3xjDD6+FZf7+EMNgBnBaugnOLMq471jb5TlF+IsfPLbAqcTCsogxmZw?=
 =?us-ascii?Q?k89jgTVYQGZ1uH8aMfWV6/nxs1PVZaI1fO0GP2rJp8D1KvmBmbrj/KxIJmFY?=
 =?us-ascii?Q?86FKxSv4F50GJlXesrvUBEXG08LJq1zmd5UI9fDMz+bQiMiRHAetN1zKf9ko?=
 =?us-ascii?Q?vqyj/ea+ohP7T1p26ifmre0VmQk4P06fzwzoe0Km9AY1Wqw6IoJ73fgWl/Qr?=
 =?us-ascii?Q?pjk+ypOmReEvjU9Ss2yw61KLplY4K8IwwzQETUzctQEMaWsnTXQWNgaQOdUZ?=
 =?us-ascii?Q?BRIkLkKG6wSAF/sfdxdNkgZg0xbfoGijDPHE4jzH3GuJGqnMcCDdS3VzJTBl?=
 =?us-ascii?Q?LOgkAyEfVY/pAAiiw5ymqZtG/OcjzFH12UDUvcWyR88UvbgG5U7tO01Frfwk?=
 =?us-ascii?Q?GbACOp52gSYLDlOiyfDzQzidOKaOiS7hocAfLlxAlcqtRRPIMqoXMURv123b?=
 =?us-ascii?Q?9q5PUXf8LylCTCD5+chcAy9jVo9GibJgIyuDLvG1jUbAl4Y/pxtGRMA3Hh7e?=
 =?us-ascii?Q?vddUCgwKoRSJrHwEsIbWTX8Czvva2pcBEJEOTe+Ij8HGfycHVps4jPw6DUjn?=
 =?us-ascii?Q?tv9vqc54Aq78yvUXTUzE+1nUHNmAiZMHzME+u/Uidsq1N+I9OgKGMojc5AZP?=
 =?us-ascii?Q?bmEKF4ANXxnj4hqc+IgNauRfoR4qqBcM3safRI4RqPAtLI2XwILeG0f16b6x?=
 =?us-ascii?Q?9aC5wB+RvAKBA8Ggdb/jNX0fBfxDzpKFJVxejvnMvqhCQGsTUWMsmLv235z7?=
 =?us-ascii?Q?CehQPoDlTAJ77BrLEUwIy2Dhxxb6BeA8Imz8fE8fOMeWN0ov3rPV7hMiNDlr?=
 =?us-ascii?Q?W1NM1tsErbfdqcFyYSLAEgskTJky5ZDqw8EkZzVSw2l143Q0prafYptBZx07?=
 =?us-ascii?Q?d3NvbiBEy+6xrRt8EgYdO3/ZL3a4qJAdO0O+ekQDfrIMmN7EWpJR9mb6369T?=
 =?us-ascii?Q?rZg5koJ+yrNAWeuTzxvdzh1sdNDS9tzSc4xgJWmFPhCFUPhm8+dO/TG6bzp6?=
 =?us-ascii?Q?qI1FhIc5BmtElnI4mc03X6hIc+p3XIJ/x4swDbRxJg3tH1TTAxv+PhrJsEEc?=
 =?us-ascii?Q?Rvj1MBVzCABMdNk1zbvizyxBFDPlsMSWqqmnyAQgxLp2qVet9YMY2JrnbGUA?=
 =?us-ascii?Q?cQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3BE7A2D545BEC242A8662E782FE7E088@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?m1qmkgJyxujv8/sJi3b+Bae+QzHd3r3+edK9KeR3SyAq5bMvAcLOeXsOy5xM?=
 =?us-ascii?Q?yr1/X2hG2AR0JlfVVBHBurenBGv1/s9jcE7tXMSaXmQKLxvcTxbkOivJ7Rjf?=
 =?us-ascii?Q?Kw/HTSewbeiyOagP2AJiKz5MITOTtCfwIyuArJHVJHcWpvRM11KNQoEgG/D9?=
 =?us-ascii?Q?7X3WwrQ/11zlaL0oLUHN63eWE8Ldx0xss6w7+/BljTnntwmdyZP/3KZxWV8y?=
 =?us-ascii?Q?ETP3nXfji4Qal4jtFJguIFQ2/kVcXaHsPFTW1ctlvwgYCn5p53Wq9X5oofP4?=
 =?us-ascii?Q?pplm4KMk5uewo/WBxl7kcnT8RWax7u/G5CydsWvOnXkHdpMyurBKCHI6X2vj?=
 =?us-ascii?Q?XpA0qLyj013t94IIA/EcMnExnwxU7Kaqu6Op10CuDMfXKd1+52t2WIkBideA?=
 =?us-ascii?Q?lJlQJl/LrHUj69DKLeV/jyN6mrrquu5ScbPC5KqRsQdV0xU9wPE9CdgJQyDl?=
 =?us-ascii?Q?pir6TUExF1o6d5mGFr+UBaSsDgL1JxQEBu+RXIqdsZIVEy/onG7BGffw3ynU?=
 =?us-ascii?Q?9jAr1Imbqe9fEqj5sLhIeCYhdfAf8P7g3bzxKTeyzq143nKuPwZAfpygEJct?=
 =?us-ascii?Q?Nz+pY8QlBuIgBwLhRNmOJRDqLFdlzMRrKk62a3DpGZEksJgoin/OYtE4hLuZ?=
 =?us-ascii?Q?z2hblY+OSxRdVp8bIkRmBIZfRKzFUEKBTRO6dq2QNvs/1jwkiC5euESIofG8?=
 =?us-ascii?Q?YBvAKgib9XvaU3+2p3exVOWqPclwrH8P/Vcfcv4Vd2pMMpvJ0S24tKQN2pze?=
 =?us-ascii?Q?5RxemZCVfoABItbMc6JODln1gocbtuDXiFzD9muq5gS/zH9zFEhZb6eUEhSl?=
 =?us-ascii?Q?4nYdQ1Fib0sDVEhSUAGs/2YzFG9h3F7tD4A5Lc6SQxbVDkcf2iQ+7GdANWVZ?=
 =?us-ascii?Q?n5ozv1NBx80ofFud1EWJQWKrvK9ZAfUnx7mMq40tkS6x5fPDkhKHEjx5gsyS?=
 =?us-ascii?Q?Z1CgWLBVOQv33zVE3B80CZLCUg7Ht2HVh7TPXGh1ztN12shpAShyl9IsInK/?=
 =?us-ascii?Q?iArWachJfy29+od8FMmc6gSz1H2T2WBv6SQ6L5l3xuZ3c+CwO4RgcKMrkpcY?=
 =?us-ascii?Q?votYRPC2Ko2ANXVYdiXThubYpPm8V6IYgGlcZyAVUYOFM2TV+17Tx2NS+es3?=
 =?us-ascii?Q?eXxkp+PdAELF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6744df-0e32-4cf7-e0b3-08db3120e8b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 13:16:01.5344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gA8SQHgpyakpJevAjuhWTdBeMu8q2txrZifoLKUg72Rrj7/edhYm36US1iN6+ilPzu9wMJSOJ7tirCWgsK86bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_08,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=975 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303300105
X-Proofpoint-GUID: A5Oz5xgX977tucOAfR5DTYMcCnKLJKWm
X-Proofpoint-ORIG-GUID: A5Oz5xgX977tucOAfR5DTYMcCnKLJKWm
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2023, at 5:41 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> Chuck Lever III <chuck.lever@oracle.com> wrote:
>=20
>>> +	if (ret > 0)
>>> +		*sentp =3D ret;
>=20
> Should that be:
>=20
> 		*sentp =3D ret - sizeof(marker);
>=20
> David
>=20

That's a bit out of context, but ...

The return value of ->xpo_sendto is effectively ignored. There is
no caller of svc_process that checks its return code.

svc_rdma_sendto(), for example, returns zero or a negative errno.

That should be cleaned up one day.

--
Chuck Lever


