Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD52E57324F
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiGMJSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiGMJSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:18:13 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60080.outbound.protection.outlook.com [40.107.6.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07367EF9F5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 02:18:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d38zqlEnIKpT5DpMO5VlrQsrBj86w8s8H2woRj4je3eLU2oHTIyQu0Aqhqm3YwluBKlMzLpxwNZKKvqf3UbMQukljic+NpLTTYRt6lyiDnqPbi9IniUYcYdH4jVdZyxDhFoGv/r2Jg6rHPF+fJpUuhsFOivxKeHrIohE/JWK93dlY9PFcIJ8HAYSIiDnulVBpXNdK9u/ilhIUnV2pWmZp9esBDdEhG95RxI+EI0GXiVXpZJ+S4QmxV4vN7BatZw1lDUcWYSdq520/HnWlDBX953g0uQlJizw6ndR0xXW4LzxtxiycOu/T8wblCmd9wcVeRqey4Ym+ndHof6OmbQDEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0wiJR8y9d9p8OP3226b9Uqy3841O2K+rwB3kugZg0Xw=;
 b=nIpF8MH3UF2WuKpdqlB585whcaLYkEQjKepQKS/B27+rVrxRfwGr7OUBJsawPRmpWogQ8YvorMfqcBh5AOtg2/CG6F6MeSYUT/DqGHxzLYL3esTo5nPTCaq+lvymFZ2ULg6jUGHD1Qz75mQ3Yi4SYrrQSdVKTQwJiGfPomvd3ng3T7KbTxnXV2ojKr7pEF0Q4WETqgF414n9yMvgyzdN9ouG0T5bvFy+41SDYaxJzYKr9bHTC29FlNAAEdKTEwrplL5zAVY1RyaeOqlTjo4VOQhRuy0ustl4P4elRCikVtMH7pA6Iw4sDmcfhaYuU5LqgsyMpfRImZsUK8+zdlzpDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wiJR8y9d9p8OP3226b9Uqy3841O2K+rwB3kugZg0Xw=;
 b=Qu8NhaXnapa1TaUiDrz7HGWQBZHt6EXMl8LNPad127rcTD+hIvIm2r6EzjBlxjXkCrNPYt5ndFiChJpiyntq0N57tg/h5XRpJEWhnWl4YoCd+KPP6WRMcf2zjrclWdzDWOtpPK+CvPuRv5es1CWLv5rNslzemTK2gIZ1u5HxEHDBYhexsLXSadB0791SLrfpK33VvvkY/vS6KlCo5N/2C34YOJJvSlqPlRRXimO1nTgR3eeabP5XlWGTqqm0+Hd8DOSoMKSJg030aEmdfvXM63LCD0MtQL1+QmnitUPvtnpM4hZjQDbIRh6Gw54Nt9IWRHMqs2/DZJgDe3nWQD92Kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM6PR04MB6248.eurprd04.prod.outlook.com (2603:10a6:20b:bf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 09:18:05 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 09:18:05 +0000
Message-ID: <7fca0e44-43b5-8448-3653-249d117dc084@suse.com>
Date:   Wed, 13 Jul 2022 11:18:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <stefano@stabellini.net>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
From:   Jan Beulich <jbeulich@suse.com>
Subject: [PATCH net-next 0/2] xen-netfront: XSA-403 follow-on
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P189CA0040.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:458::7) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef0a73c6-822d-464b-200a-08da64b09809
X-MS-TrafficTypeDiagnostic: AM6PR04MB6248:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xUjMnvxJN13hfPUKFQA5OWNXojBbsQ5iukpZDFdYTODBDGS/gAS84XgTmhDGEAWCJm+sjoauBZ6XwF9KmmFRu7RlDHbplquZUoYW/bMR1XR9Jf8FVDaW9HE73m4NYTr+hwkIiqyahNyX5v7f4eVda6cxPgG8UrqfZdkrcLfkattqIclzWH72ELOPWXC8M54Af3ZVarSyjP59Tbb7g8+WfbLCouzW3SOmiuBuMqiVnV4qcmrk8FiEONo/ldFTezQyM3kpgktPjwmoSzgaG3bPLKjazLyOwVCJERWd//UBtZ3Y36Vm6LwX1FkU36oh5swkruua8IwPxpMcZpqnhvHnXEhX7LFdbtiGuVTp0iMLw+3wz3mbKCf+SgEs1TEflSdtALxo1jDiWulYEZcY3c4lsE70/5bC1t9mbX9sWoIkcd9sihuDG/UR8KI5PdiOn7BBeTlLIh4Grj1RXveXnWEf/sjknosVa6C6PqwTYMm2JVRtQpSJZ07J1EP1dLmWBr/dTu6DxYenKe5pHVceRvOWuPbXoj1MKr9rLac73YkHqC9xXDzM+KM1JCGsc+p/cBIBZamy4GjaLle5AVa8enxnJk8k2vzAZl2FZFYg7nbd2/QHyq7moMY/mM8wtAKCXLgQVuWdqOykvMJMYxxbDMzrBs55xB15hFF9TsY+e+N2QutU2WWl1jcEcYnbm0XLecECX7EJCN5U2U5P6BbKsusnxjZtoIEW/tI5xdkrgD6VQBIvSBHw5BMJe1jsNCqegXuRo4swR3V9M0HTs5PFt2a/K/Gjk4nkCTPNPSIyWLr4VEsU6Suk211+RFvvFivSA8bMX1PmQ7UCTNBbNIvF0jtlWDVbfEmFwe+plnnx7hMxN3A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(366004)(136003)(39860400002)(2906002)(5660300002)(8936002)(83380400001)(31686004)(2616005)(38100700002)(558084003)(478600001)(6486002)(86362001)(6506007)(110136005)(8676002)(54906003)(4326008)(31696002)(66476007)(316002)(186003)(66556008)(26005)(6512007)(36756003)(41300700001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bm5NbjBVOEF2R0lPTmpuVUhHRmphbUFsQU9aT2gvM2JQREtZYXpVc2ZDd0ht?=
 =?utf-8?B?MitSY041NnJXTk1hYlJiOUdmRnhuUGc4eUhmWUZBODhvcGoxWmtCWXYzMzRU?=
 =?utf-8?B?c1p1MUY4Nlp6WGlsTFpJa2gwaWpQcUxjNkQ3NzhWVDUxNnp2UTVXS0FSVzVR?=
 =?utf-8?B?RTk3ZHA3dkkyYkJaMTVBaW45NWhMZXRTdjNuemZMZlg4WWhCQ2kyUk1ZMUlE?=
 =?utf-8?B?eFhyVXRIVlBYOXR1aHlZNWgyZWIxdjRVeDQ3NEVxWjJlVXRnVjlMMDdQZ0dw?=
 =?utf-8?B?dDJhZmRqUGp5cit1MFdIQmRRektQUGNpL1ZuZlBoWjdGQS9JQU5GOXFIYmZO?=
 =?utf-8?B?cDcxQk1OMVlPWGlGZkRVcHhNQ050eDd0TkpZWkJZTVFuT0JPM08vS3NsaFhW?=
 =?utf-8?B?TGpxSG42S3R2Z1ZSalpNRDBKL3F4bEw0SytCelpDNU8zZTVSUUg0aGsyeE12?=
 =?utf-8?B?NUw3eHRQR0hvTnA1NVlYWFpjRGdFY1JyUVo0ZThNY2dOVFRCVWM1T09HdjMx?=
 =?utf-8?B?MFBibzgwa3VROXRiejdxcUNXR1JRNVhsZEhxbGlhd05WWDdkZ0pQOUdRejZp?=
 =?utf-8?B?Y0UydkliOUJrd3g1ejR2Mm5pYk5rSk5XTDRHeGdIV29rMnREVWo3eHNtUWZF?=
 =?utf-8?B?OThVSExLQ0l1dGxJMlNWRDBFU0h2ZEhCK081WTExUDRXYy9paG9TdHJkU2g3?=
 =?utf-8?B?OC94dFBmVzZlVmRvaHJqOG5XblRjMWJ4NVFlUU5kcUo0OHlkbHZKYUNxN2Zv?=
 =?utf-8?B?Qm5yaTRiY3dEdDRYZHhLQzJDSkk2b3UrNE1TbTBNQmpiVEM5UlN0alZPRHVu?=
 =?utf-8?B?UncvejBEVFBKRmxYSkkzU1BRYVRySjZXMks5SW5QMXZYRklXcDhCanMyZTVF?=
 =?utf-8?B?K1JYYWFCekZLNUN3dVhsNE1ON2ZtRnNKTlFYQ3daOUZxdXd1TjRTK2o1eTBa?=
 =?utf-8?B?d2EzYlNvYmI0MTg3SitTbzBaNlVsVWNkTitLZG90QkFIeDdXdS9OcHBDQmNt?=
 =?utf-8?B?OTdhazRWalRSVXR5RGhUTEdOa3hVbXVxSkptT04ydEt3Y3dFRUZqc3JzaGVW?=
 =?utf-8?B?RGQ3S1czZStEMUZXRkdxTE9lSXVQSkVPUGswU1FHZXlZUXN5RFlKK0R1ZWVa?=
 =?utf-8?B?YjVYZ3pKMWNmeFlTdjB1Rnh3NWplTjVFOXJyOW5PVnJSSmR5enZURUs0SUE4?=
 =?utf-8?B?RGZjRnZZUlM3YWlmR1gvVnYzWWZFZTQ3UzRzd0NwSmFIdWNLTGIxbWVldjNr?=
 =?utf-8?B?QmVLRUpjaFF4WXBLTmE4aGt3Vjk3ajh5dFY1a0RYTE82OTl4b1dGV0FHMGJa?=
 =?utf-8?B?ZDJveWwrNTZ4OTE1blk1c0dMYmo1ZURkR1NvcjR4MUZ3Y3RzMEltb1dCL3I3?=
 =?utf-8?B?MDJ3VFNSZVgzOVZ6ZXA5UzJaVS9MNFY2Mi9zajZLNjdsLzFGd20vMXZLV3F0?=
 =?utf-8?B?d1JubENsZnIrQkQ5SlhTTzliM3N4WDE0M1N2RmlBeHl0WTYrN3IvT2ZpTmNU?=
 =?utf-8?B?SkV4U29OSi9aT0lKQkdXL01FNmZQNUZsQVhlRWJyakxVWi9SbE1wK09KTW9G?=
 =?utf-8?B?QUJjYmV3MTcwWDdLTkNhektKOWdCcFBwYWZMa0VVU2owaVBKeUxDazU4Skt6?=
 =?utf-8?B?alV0R01UT2thRkt1R3BJYTFoZ29GNkMvcUQyNkJtdElVTk1LRE1CRHFsZ3N5?=
 =?utf-8?B?cXNNOWZhQTBYeVQwYWlUOHE5WmFWV3lBREhHanJrTVdUdmJid2lJWk9LYWZN?=
 =?utf-8?B?QnFYL3RQWTVUUE9EMmJSb3l1WmJCbVFtZ3pmZCtQS3BXNEdqRlprTDlrRXJh?=
 =?utf-8?B?THpBd1F0RFRZL0hoWktRcmdYYmVHRXdVbjI2ZmFEUFhwaFcvQjdpMlJzbno2?=
 =?utf-8?B?NkcrMmJGMTlTcUU1SDNKYmpPcHlaN1laZWpEVldPS0ZPUGt4em0vTVlabG1s?=
 =?utf-8?B?c05RUDhMc05vc1dQMGtYZEt1ZWlTdmpRc1BWN0p6ZmUrNTRhVXBvK3paVldI?=
 =?utf-8?B?aVBkUVFKcTBpVnBJUVoyVU9ROHlWTEZWdnRqVnZlUmlOWk5YMTFTNG9CYUEr?=
 =?utf-8?B?L2xDMHJRNE1mT3pjNzQwaDN5RUJDSU1FUXRwV0RqK0VSVFZkMG14SFVaNXMr?=
 =?utf-8?Q?+Rh2OXcHSyG1IwI0nwmIyFdB7?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef0a73c6-822d-464b-200a-08da64b09809
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 09:18:05.6602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGoBv65J5fF3uHNEJYWuVsevgYOGCBD7L+klwYprUDiF2dCMBGdlpxBfqkOt/t5tywXpnT9ZmRxXWxKkyRP2gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6248
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While investigating the XSA, I did notice a few more things. The two
patches aren't really dependent on one another.

1: remove leftover call to xennet_tx_buf_gc()
2: re-order error checks in xennet_get_responses()

Jan
