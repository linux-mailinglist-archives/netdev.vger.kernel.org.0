Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C92391F25
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbhEZSc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:32:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60402 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbhEZSc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 14:32:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14QIDeev049286;
        Wed, 26 May 2021 18:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=XA6fdOjYg15DN5gdSLxbx6Is83fSLIQL0nPQobxX5iE=;
 b=bOzHPelmBxprgLSKHTr/fZoPmqDa0l2QbCCeeZ7uAESE/XKPXR6ULGKln/TnbX53oRMw
 E8yYxthzpTKRLJsPhd2IbMrURDOsKoicSU/8OaXjTxI7uCedJD+nbgfJjqlD0RCUKhkz
 9Rc9RwHoLo2vGEehhMVCQhmRuAWMRVpW6dX/oY1HkAI5Eb9wNmmN2Qz/97ErtcL0ZjrN
 vO7Mvz58afUwQr+6NWC1GSRokkMyCFOPnhMj9tdcNymp0su3mcn9Xh6YAsw5d0DBrql5
 PaxjSqUzxTpJtEXWedn2ny1PSC7RgonYPRpluE1XpCNaGKw78btKetKJGhUfJIjAKEUZ fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q91gqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 18:30:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14QIUITa143253;
        Wed, 26 May 2021 18:30:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 38qbqtjejk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 18:30:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F91Px+Sn+Rx7KkTfcE9QWa+miYmbiFFjZXobe9bdUAap34WHHoxl7lfyXPMzrj69KHC7tfheBoZg9Iz+XXmk9tH3iMaCI4ZLJE59TOS1OWZUnzRpVTwYfldPzyWjb0PoW+o6+71DosH2GEoBGOHRD7o+Nc8chpMlhLTWrijv/VyXcq+Rqr/278b/W8PoDudPMB4MPThKSpkpSmA2WvbhuYA2u4GehI0ktjaq24t5mVMt4bkZLtVQ7ToSMgSUeFCDFU7hxmUXzl6zhXhfgqaAsF76/GpcQd5qxhpZv7ysNl1OVmS6bmKC56V8eMQg0HmD4gr99GXyHDDv1DqqOnaErw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XA6fdOjYg15DN5gdSLxbx6Is83fSLIQL0nPQobxX5iE=;
 b=h5YsDmP2klRF+hgMUfdCThFunR7TzY3S54+PAQFgX57Ueka6LQu/XLZoSuuk7yTVZnkaOqBDatI1JLVG+h2Tvr8eMeY1QBdPoAVJyN2rqNEEGGjmEg0RjkTtVoq+TSJIJ7o1KVVjCZPMFRfDGiNFQnnf07aVs0YaBdx89oGcMJkn8XKoRM8k1ftC+mV9iBAtQC71N4fp3URyoEtHnMhvuXw+f/XcQvuiBU4wwMpuZSqKW5udhmsnMdkcNWm1ea6Y6MvZDF+d2Ht9mAEWQU8cH86+fGtvizaw6nRNjuEZWR8cKWZC01n0EwTjZckNoMcuyMFcn+tqHvthf8cUWSWj/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XA6fdOjYg15DN5gdSLxbx6Is83fSLIQL0nPQobxX5iE=;
 b=VQlG9AbAYZNNRx7UhqL+KnrNWTvIny+sOwNlZ/qJtfMJfBwooEFYZjqRiI2ksfzrG6Ru/vOrX2MXd8zbZ//C9hz9uunyqSmq1I9wox18AbK7KDJIfrwGyB6H3xHcFwV9QqVaoabVRztXdKbVRky3oKTTwa5EJ0xS1vKRamPZemQ=
Authentication-Results: dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com;
 dkim=none (message not signed)
 header.d=none;dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com; dmarc=none
 action=none header.from=oracle.com;
Received: from CH0PR10MB5020.namprd10.prod.outlook.com (2603:10b6:610:c0::22)
 by CH2PR10MB4198.namprd10.prod.outlook.com (2603:10b6:610:ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 18:29:59 +0000
Received: from CH0PR10MB5020.namprd10.prod.outlook.com
 ([fe80::6cb6:faf9:b596:3b9a]) by CH0PR10MB5020.namprd10.prod.outlook.com
 ([fe80::6cb6:faf9:b596:3b9a%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 18:29:59 +0000
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend
 mode
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com,
        David <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Shah@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com,
        Amit <aams@amazon.de>,
        Agarwal@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
References: <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
 <20200922231736.GA24215@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200925190423.GA31885@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <274ddc57-5c98-5003-c850-411eed1aea4c@oracle.com>
 <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <cc738014-6a79-a5ae-cb2a-a02ff15b4582@oracle.com>
 <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
 <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0b1f0772-d1b1-0e59-8e99-368e54d40fbf@oracle.com>
 <20210526044038.GA16226@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <33380567-f86c-5d85-a79e-c1cd889f8ec2@oracle.com>
Date:   Wed, 26 May 2021 14:29:53 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <20210526044038.GA16226@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [160.34.88.235]
X-ClientProxiedBy: SA0PR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:806:d3::13) To CH0PR10MB5020.namprd10.prod.outlook.com
 (2603:10b6:610:c0::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.102.235] (160.34.88.235) by SA0PR11CA0008.namprd11.prod.outlook.com (2603:10b6:806:d3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Wed, 26 May 2021 18:29:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8547f8d-1d7b-45d9-e57c-08d9207444e5
X-MS-TrafficTypeDiagnostic: CH2PR10MB4198:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR10MB4198D636FB4AA9B68EF4FE298A249@CH2PR10MB4198.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+rKNv3KV0qLprLhDQ1P4GdxtE4P4X3RiHIY13RDzTceAXwaPZPTWjXI0YF/Gcyjavo0DuDJGarW/yLiEiOmkPzkDwLI33Heq6OdsU3CqfRwwZO+oLmayWGYoXdN5Kf8/2xbLe9m5SyopcC6Z9ljemgjfsXSB/OCVXTycvs8g1YnTEzPmAgzo4OGiLOQHuxH4gXy44JSelLJWZIG0ZHanJENH4zKWcOFAsWImu/HYVQGt1O1S5GxMmxCAnfGdbe8sC3hhVXWxnoIsQo565tY95SBN1QetLE7D4eUUxEgOrOrTlDZ8RpTTt6hh8yf8L+mI/paOnKI1EC0dXkraVvtKuGN4fkFAOvKUJhRtELmUi1fsEc+IsO25dGnd4TypkQSwCd6g5pCxj1bpvsKdCX/JwUoLyvLJgGLXEXYcPi/sBSdLUhRSA3swNA1XoSGKoPbQ0d5za5j0kYDuuSstqdcbvXaHPnYhEsBNXibKq8XuUkipk5ttJGEZsj6QJj5+PMfDL7+rtdvBNlxrGRf3qyRRzR6RruQRqIHmJklP99PDVTdgz+7FowoudHZMogHTvwnr0+iuN4pKyAFAFI1UxwT6xYauZXltMVR2YkfWpxscIJzmin9iWf+RhYvclcRJUItwL65zkjww7Ouh7ZgMSlWcZVnX2iKavTySIOOGn5rj2FaSLNwImY5OHrF4NRy/46N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5020.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(346002)(396003)(136003)(2616005)(7416002)(16576012)(16526019)(186003)(4326008)(53546011)(36756003)(26005)(5660300002)(2906002)(6486002)(31686004)(316002)(83380400001)(6916009)(86362001)(8936002)(54906003)(44832011)(66556008)(956004)(8676002)(66476007)(66946007)(31696002)(478600001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U2FSdlY3azdkbjhFVDMxSy9IZmdiMnhPUGJpMlFEUU9sTHNqL3JxL2hvOUdI?=
 =?utf-8?B?djVoT3JPOEZMdDE2U3lkdjIwMzNOWSs4eEhVL29jcEJlZzlpNDFNZ3FVKzhO?=
 =?utf-8?B?ZGMvWHA0K0E0MXNIQ0FCdU0yRjZLTnRNeXAzbVNQMDQzZk1SNGNoR1BqR1ZH?=
 =?utf-8?B?TDhaSFpyOTlWR1ZQVk5OamdkV0RldGttZGFKT0RiNnlXU2x3VC85Z21xMnFu?=
 =?utf-8?B?ekViS09Ua2dkcVhlOVdXNUNGMmpxT2pBVXRWdFIxRTNPcnVRbmZ0aTlvbUow?=
 =?utf-8?B?YjVreXg2d3lGMHM5ZzFyVjZGQkxhNk5LZWxENCt2M2ZQV3hIenpFa3RyeEhj?=
 =?utf-8?B?R3VSTTlyd094N2loRGNwZUpaVVpTS0J0blJkUXZmdTlMbW1CcjZKZ2pLR21I?=
 =?utf-8?B?c3o4aHVqVnh5VHFOQVBGbTM3UTBoQnBIMEFnc2JkU0l0Yk1QdDlZNXQrejlZ?=
 =?utf-8?B?eUxlUmkyN0Y1KzUwVEtYZ01VelRxZ2F0WFh2MHI5blZhVW9XaytPRVdWaUZW?=
 =?utf-8?B?amkzWUVqOVAwVklCdnJieXN6UnZhZDZ6ZWVqWkRDaGdwOFVXRUVIendzbENE?=
 =?utf-8?B?UkxsNXAwZzIyK0tSZmk2R2tKbDIrSVFkZlJMaHpIalF5MndpeTQ2NXJnTzNx?=
 =?utf-8?B?alFscENNcDhzWXlGVXBjVjRGdG1hNXloSEp0V1VkMCtLU1o2QVppRjJWcmNU?=
 =?utf-8?B?c2YzSWh3bnpRUUJsejlrMGZIZ3NNMGRTRHJXSXJienh5c3NlODBqMnI0L2dX?=
 =?utf-8?B?aWw3V3RSSGNpVkkyS0J1cVE4cWh2c3hZWU1sbFhBa0JTR0xNR1NSV09TcTJZ?=
 =?utf-8?B?bnNaUy9CTkNnS3FmWk5acVFpcVVITFBnYzhBQkYrZllVL21TaStGRVZDN0J5?=
 =?utf-8?B?SXU3QVdzTjNzTStxNVRFdHpIN0VoTTN1clpCZVJhblNXdkQwL2ZUZEJHZkZr?=
 =?utf-8?B?SWZEKzBVYzhlem10WVlCVHJ0V0ZKK0F3QVZwa1RHOVVmdEpFTDNjb1lpb05N?=
 =?utf-8?B?Vi85QmR1VllCUkttY1ZpN2o4WWRNY25UVXV0ejBQVFMxcVN4bjIvVGptdTMw?=
 =?utf-8?B?Q1g3dDNDb0Evbk1ZRHkzZVliRUgySzU1SzBIcHhhNnpmR0Z6aUJMckZOcWIz?=
 =?utf-8?B?RnR1MG1xdm5ER3doTEo4SFlKZ3BWbWtEV3Q1RTJyYlNVdEx6QTZSWnJ2cHUx?=
 =?utf-8?B?ejByT3BHQy9VS1NsVnhCUmlNbVVVL2ZRalVhZjhMakRvMDZjM1lBZEFuYWEr?=
 =?utf-8?B?cEtUOW5JTml4WitocmhMcUROZmF1R0o1bFByZmtrYVRJQkFoSzhrV2h6VFdu?=
 =?utf-8?B?cEl3VDI0WDVuckxYSnR4aWg5STk5VVUveWpTczVqRnE4VzFPYmQ0ZUFmSFlH?=
 =?utf-8?B?K2NLQ1NMVXltWitYcFRsNC96MWRhckF4aW1nTmZoVHR0MzJxQXhpbXZOYWFJ?=
 =?utf-8?B?RnFZSUthM1NqSnZHZkp0RmtReHhhMXZKdWJKOEhZaS9BemdLcTBzSUY2SlJR?=
 =?utf-8?B?dVJUU2tDeGNxTmNiMlBITWVFZmxIQmVxY1RzNjR2eVNIb0xTbVBURW4zYWZs?=
 =?utf-8?B?a203WjJNdy9WY3ZPTXVPdFd5aTV3T3VxUXZzQ2ErSmMrK21hRy8zQU9ydlQ3?=
 =?utf-8?B?MDNFQmJpTDBBUVFtdVVJRk5OZDEwcTE1Q3NUQjdpK2hNMGJwSmNtd3hRYVo0?=
 =?utf-8?B?SVlOT01ob2NGeUh5THJtZ0VNZTVlM0NaaWdZRkMvTmh4YWVvUXBRV01uaTJI?=
 =?utf-8?Q?hAqQRhGEnhs/qSDPgqvWOgufmJ5WVRTOf0yDEIv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8547f8d-1d7b-45d9-e57c-08d9207444e5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5020.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 18:29:59.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Kvz4DQEvSLVF5/Qt8cLlGV3BqyKl7jb7RtaRicSCZ8xr84irSI0Ul34j++9eHoFDVRugiYISj4OW5C0DmALYIfdTAX95lxkxwYOwpIs2Sc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4198
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260125
X-Proofpoint-GUID: RpVKjGUs8Bdpy3b6pvQ1sYv1dVa-Z3UO
X-Proofpoint-ORIG-GUID: RpVKjGUs8Bdpy3b6pvQ1sYv1dVa-Z3UO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/26/21 12:40 AM, Anchal Agarwal wrote:
> On Tue, May 25, 2021 at 06:23:35PM -0400, Boris Ostrovsky wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> On 5/21/21 1:26 AM, Anchal Agarwal wrote:
>>>>> What I meant there wrt VCPU info was that VCPU info is not unregistered during hibernation,
>>>>> so Xen still remembers the old physical addresses for the VCPU information, created by the
>>>>> booting kernel. But since the hibernation kernel may have different physical
>>>>> addresses for VCPU info and if mismatch happens, it may cause issues with resume.
>>>>> During hibernation, the VCPU info register hypercall is not invoked again.
>>>> I still don't think that's the cause but it's certainly worth having a look.
>>>>
>>> Hi Boris,
>>> Apologies for picking this up after last year.
>>> I did some dive deep on the above statement and that is indeed the case that's happening.
>>> I did some debugging around KASLR and hibernation using reboot mode.
>>> I observed in my debug prints that whenever vcpu_info* address for secondary vcpu assigned
>>> in xen_vcpu_setup at boot is different than what is in the image, resume gets stuck for that vcpu
>>> in bringup_cpu(). That means we have different addresses for &per_cpu(xen_vcpu_info, cpu) at boot and after
>>> control jumps into the image.
>>>
>>> I failed to get any prints after it got stuck in bringup_cpu() and
>>> I do not have an option to send a sysrq signal to the guest or rather get a kdump.
>>
>> xenctx and xen-hvmctx might be helpful.
>>
>>
>>> This change is not observed in every hibernate-resume cycle. I am not sure if this is a bug or an
>>> expected behavior.
>>> Also, I am contemplating the idea that it may be a bug in xen code getting triggered only when
>>> KASLR is enabled but I do not have substantial data to prove that.
>>> Is this a coincidence that this always happens for 1st vcpu?
>>> Moreover, since hypervisor is not aware that guest is hibernated and it looks like a regular shutdown to dom0 during reboot mode,
>>> will re-registering vcpu_info for secondary vcpu's even plausible?
>>
>> I think I am missing how this is supposed to work (maybe we've talked about this but it's been many months since then). You hibernate the guest and it writes the state to swap. The guest is then shut down? And what's next? How do you wake it up?
>>
>>
>> -boris
>>
> To resume a guest, guest boots up as the fresh guest and then software_resume()
> is called which if finds a stored hibernation image, quiesces the devices and loads 
> the memory contents from the image. The control then transfers to the targeted kernel.
> This further disables non boot cpus,sycore_suspend/resume callbacks are invoked which sets up
> the shared_info, pvclock, grant tables etc. Since the vcpu_info pointer for each
> non-boot cpu is already registered, the hypercall does not happen again when
> bringing up the non boot cpus. This leads to inconsistencies as pointed
> out earlier when KASLR is enabled.


I'd think the 'if' condition in the code fragment below should always fail since hypervisor is creating new guest, resulting in the hypercall. Just like in the case of save/restore.


Do you call xen_vcpu_info_reset() on resume? That will re-initialize per_cpu(xen_vcpu). Maybe you need to add this to xen_syscore_resume().


-boris


>
> Thanks,
> Anchal
>>
>>>  I could definitely use some advice to debug this further.
>>>
>>>
>>> Some printk's from my debugging:
>>>
>>> At Boot:
>>>
>>> xen_vcpu_setup: xen_have_vcpu_info_placement=1 cpu=1, vcpup=0xffff9e548fa560e0, info.mfn=3996246 info.offset=224,
>>>
>>> Image Loads:
>>> It ends up in the condition:
>>>  xen_vcpu_setup()
>>>  {
>>>  ...
>>>  if (xen_hvm_domain()) {
>>>         if (per_cpu(xen_vcpu, cpu) == &per_cpu(xen_vcpu_info, cpu))
>>>                 return 0;
>>>  }
>>>  ...
>>>  }
>>>
>>> xen_vcpu_setup: checking mfn on resume cpu=1, info.mfn=3934806 info.offset=224, &per_cpu(xen_vcpu_info, cpu)=0xffff9d7240a560e0
>>>
>>> This is tested on c4.2xlarge [8vcpu 15GB mem] instance with 5.10 kernel running
>>> in the guest.
>>>
>>> Thanks,
>>> Anchal.
>>>> -boris
>>>>
>>>>
