Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E11F55321F
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 14:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350138AbiFUMf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 08:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240753AbiFUMfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 08:35:15 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20055.outbound.protection.outlook.com [40.107.2.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8CF28E18;
        Tue, 21 Jun 2022 05:34:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMFxmp2daaTb83CjIJk6hq1dIDHk18f0lTu03JE3l3AWsRFDgwyhiqV2fuIpfj+2izpJz9bPtBYVvd5uj30ojuM9CP60GrxETHEQexWinoUUXgLbPy2BztF+1c5ZzoqAYt2Ge3kjla67vBBiZeYHfIDw7M7wVVIDMrziknaA44lFuvBbY+d787KYp+ZAgjbBopEeiVje8ByHs4UxoXn9w0MwCRPGmJ24udgDrsHt3BVUyG/qfgDBOyiVzoKOjW7Db1az4iTbwYnO0qFT92gIPpO8JhBGO90vwj6/oW8ppRa4sI0KY/0q1RZDHa+RkSDGi7hPTSaT7bOtfqrm5Evrsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZkBoMg6HCZSWAOc0bXKfKjbPvtkHo78mid82kyuo1nw=;
 b=lhIAuyeFAFJF8zqYQ1CtqSRZvK9FYuF4J9G+7r49nGhO+ujANgWVEZ3ZFcF2ip+GpEY9virw250aIpIRJnr50YcX1IPJrUio/SuHnyFjUDP21DqgAOjCyO0TenDIQc6bpOLpMZVcjld9X36JqyU1lWH/N2UUF/Yy6vhMxnc58W3itnw4vS1TFxJFF0/Ol3qkMXM/xYvuOwSOwf4z+bbKFJpvfBWyfeOPtcwnEZpZmxk5MiIaT68850jrMVx3T6eF8odVq3mVv7lrQXis6DeFNyNH0Q5f2Vqt75PRfcZiZvLXc6VP+Roas9rOyDGiWgeLtdLRQ8kOGhVYILIRuLTqNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkBoMg6HCZSWAOc0bXKfKjbPvtkHo78mid82kyuo1nw=;
 b=VfjW3KY1oOJWBI5tUpp1STsZtinnOxIbOGoMSMaOX1JEacs/cN8LfCXPdEd0fZZx6kFtk5Y0H6qqFkTDkwjMNFv8PtiM6xryxnkHXoTu5tKV6NNH25kxa6xhuT86nmhi51caF36kH7FPA9AIa0K0FPN7Q0ZJ80p1J5q2wN14hRIV8KfOmwv+RWPzH2vTv9/SkPsPPWL2XSI9H7pc/dMt4UEIXoY7ZfWvhWoPAlVKIaqFog6j8lYSJqSGZpDAH1aWGwcDfyPMy3+Oowoaoc7r03UB2UeV/8l/qzYlrqMlNg5N0aLKZqKCquDXMQ1TRIL1sa6eehBGK+DUtY5pCz2yxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DB7PR04MB4810.eurprd04.prod.outlook.com
 (2603:10a6:10:17::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Tue, 21 Jun
 2022 12:34:00 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5353.022; Tue, 21 Jun
 2022 12:34:00 +0000
Message-ID: <92c163f6-0527-e8dd-8e4a-e721594630a5@suse.com>
Date:   Tue, 21 Jun 2022 14:33:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] net: usb: ax88179_178a: Bind only to vendor-specific
 interface
Content-Language: en-US
To:     Hector Martin <marcan@marcan.st>,
        Jacky Chou <jackychou@asix.com.tw>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220621102150.202475-1-marcan@marcan.st>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220621102150.202475-1-marcan@marcan.st>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR05CA0026.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::31) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a5c61eb-a395-43ba-a05c-08da5382513c
X-MS-TrafficTypeDiagnostic: DB7PR04MB4810:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4810814E0B20D9BCD11A4BD7C7B39@DB7PR04MB4810.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i8Z8V9N/qSERxsq4Oqw5TZX0fMZgCi8ayTPmO6IsDCLOYtpnrvmjFhJlRjZpYUltCnJNi7Q77hADq4LMw9RupKXr6Kg6vvlyaLAT7p+B9CDdOpL8u1ud+9eSNB+SWDRYxt3ytT/cxjeNedr61cA2FmFFFtLinnka8Z4UQ91KzE8ihDGdfmr+chbrvuVBzzjUDhmRr1wa7dwqSZJpGA0dQlNRdSTnoDz8o8Ueqen5fq/Ir9FIyTjAsnMJgOA1bSpfr0Tfwe2AnUid2pkuLr6rI7U4rZ2gyBCWJF97igLZi4qGIMlFjMfiDUpIxR9iuVjKeeprRVtQ+cvPXWBK9nkmJpWrzU59nGY2wpzvZlhfqjF0fR/zKfINfDuf0mLXCVVxWj8v8hdzprfecmM17AwOP2y1BlT5qlOR6iZdWmrMh8j41NmJoB1omOK4v0Obdq5ENk3jK4u4N/i0UUNm3IYo8/kCu6lDZ2iFejS0/BBZEeu4V5cXqRH70MwRPjNYSBq/Bhtuu4Zt/Oc+KpC60PMOG77F7oQ6C6SmFYY0gRTujc5FRCYxhy57JDPcYaGaNmIHdPEHeU7FMBvR7OMsN8hYq8awlWOoD0DBM/Ews102hujjhMVGZN0ZT6rAV0LvtMuj/jBcQCQkaR34YqipCYTJGpzoGu/HxA2yWmBpM6g9N9fy9R+eDvx9R0t/OXxcXqFKtjt3vaIhJEDtzqAcCCmnbjZS2xMvpQsx1p66gbkbj5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(478600001)(6512007)(6506007)(53546011)(86362001)(38100700002)(6666004)(186003)(2616005)(41300700001)(36756003)(66476007)(66556008)(66946007)(8676002)(31686004)(4326008)(2906002)(316002)(31696002)(8936002)(4744005)(5660300002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDVibnZKbU5XeGNiL2F6dktKanhhbFFSemd2bzk1cnBjVS81YTNRWlA3MlQ4?=
 =?utf-8?B?VTVITjg4WDFrcWd6MEFvdGw1Rm0rSDdZZHprdGNneFRYRWdoczFMdVN5TEFp?=
 =?utf-8?B?VnNqeVZiQU5BdlVlZS9KYUtvQ2NXUzZkTExRdmR5SGRqYjkrSjBMMlhWdmNk?=
 =?utf-8?B?bGZHZkZHalJtUHhicUpPdmhzLzVsVWp5MU9XelhnU0FDWW1heUFnRUZremVk?=
 =?utf-8?B?MVZ6VFpKVmRBcElpd2hhMnNRUVM4N25uUFl3TUVEdVVNMHdNRE9NeWVJSE9X?=
 =?utf-8?B?UGFIWENQSll4SHRxMHExVWcxQkFyQlFwSlF3M0lILzloTHMyRy83eHlNV0Qz?=
 =?utf-8?B?TmMvZjU4SXJwSS8xeXIwenA0SThQMHdLYUZtUVNTYURmaFdtUVFlckdQd0Nk?=
 =?utf-8?B?TlFqMnlvTlpVVFoyQVJVSlRrQWVpWWwzN083WC81amx0QlFyLzVxSDQ2eEtt?=
 =?utf-8?B?VisrUXI3clk4WmwzeVJSZ3V0MFJmR3FMc2lRUzVoL2dqQlR6bUZTQnFqQ1BT?=
 =?utf-8?B?YkJlRlY2MEhoQ3lDcG9RZXpkbU9WeTZYaWZRcUhKZTBvNjAxODRQQlUxNjRE?=
 =?utf-8?B?clFkVTBuMlhTTTRWdGgzdVpKRVlnNDc5T1RXSGp3T2NiN3YycWRPQlh0MFVN?=
 =?utf-8?B?TmdYVFpvMlJJWERhb1czTGpQOTd1cWFnTVBYS1NsR1Q4Q1Arei9rZlhGM1RY?=
 =?utf-8?B?ZkJ2cS9seHZCZnFwSERSOGtJbHRNM21uZFlkc3pYelIxbGF0MWx4dmxNbEtZ?=
 =?utf-8?B?emo1Y25kS3dwWlFwS1Ntbk5YR1oxNkhaNnZEbW9iTy9kbTdqM21YRmRqZFFo?=
 =?utf-8?B?cXlKUUx6eFZKT3NXWmY4dzNJVU5Say9OU0QydWxzcjNYQjA5QzFveWN6QTN0?=
 =?utf-8?B?THNLS2oybXF3ckNRQ3FxNEZQeElCNTdRRXFONlR3THkrb1NIcGRvaUgwWmFv?=
 =?utf-8?B?VGRXT1NIcWFXaXFkUG85aGpJcDVkRjZNYnUxU3ZzbkxkSG1SZzlHMEROTW1i?=
 =?utf-8?B?TlAvVzhYL1g0Sk0xa0RiRjdNM0wxSUF2TGRZWDhkVVgwanF1MFJGTS9VTGp2?=
 =?utf-8?B?elRIbWF6OElZdGFXbmdYN1RRMU5sK3dRUDlaMWFEaHBrR0hNeU9kQXY5TnZX?=
 =?utf-8?B?UHpIalBIa1FCZ0pxTW5EUVY3WEdkejRDV00ydy9oa3pMd2NYMkV1ekNBQUU1?=
 =?utf-8?B?THVFaytwWnpmZnVVQ1VyR3phNi9wZmw0T3pzM2p6NXZ5RXY3YVFtYlQwUDk3?=
 =?utf-8?B?dnZtcHpYcFY2dWRtN0kzUlY1Y0oyWi9wajg4WG9JV2dnUFU3eU9yTlJtbllL?=
 =?utf-8?B?V1E2cDcwa2RoQTV2b3NvQk13VjJNSVVWdGFGcXU3ZDQwb0lscFpFRU9BYjJC?=
 =?utf-8?B?T0l1V3dCdEZ2a0pJRnBxRisvaXNUdnNDSmZweERQbU5MMGdJN0QyV2o2QUln?=
 =?utf-8?B?NVl6bjZDWVZEVys1NTRlT1B1Rlg2eEYvM2R5bGVnRnE3Wkkrc0JZYlFyNSs2?=
 =?utf-8?B?d3o1RmczM1h4c0xUL3NRcis5NWwvVjYrVmlpdWNUL0ZLM1ZzMm5LU2lWYU9K?=
 =?utf-8?B?V1ZERS9pTWdGV2I0Z2RVdEN6eXhSbkZEL3lyTDJHZDUzOThGZXVzbFlDT2hO?=
 =?utf-8?B?ZW5BWUtDeUlzTVJBSXI5RW1XZGlMMitsRkNaWThIQ01hTlp5bFlXU25ZK21U?=
 =?utf-8?B?MG90UlpHbTBDa051cWV2SXo1ZjhwRXc0UHl5MHBCUkhqeTlDYTdVTkQ1YlNr?=
 =?utf-8?B?UVRBdk5ncEoxMjhFdnVWcmloSkRBMzNsVE1lVVJFelhJQmI2OEdwbVQ2QjBV?=
 =?utf-8?B?SDNVRE1oUG9uTDRERkRoUFFMMGlJUEpIaUR2ZjdkQUlxaUQyZ1VmRTVlQzZz?=
 =?utf-8?B?SEJmR3IxaDVKY1pwSjZrY2JwYUpLRGNiQThsK3pONTRXNDNyYVd6QVhPYmd4?=
 =?utf-8?B?RTdML29yLzJueDgyTURsSHNTUkQ4YTVOQktyTnZ4QkRZYkhkL3BDZHFpamxZ?=
 =?utf-8?B?cmpyR0VPcExJNkpYWWFLVkVWSjJRMStyN3Z2T2RRekE2UkNJemV4L29QQ1I4?=
 =?utf-8?B?TDFZWlUvZTIvQlhscElKczAwaTlNdlZJQy9OclJyaDd6cWlwN0M4aVN5c1lp?=
 =?utf-8?B?UFFKRkUrSDlxUzlvOVF1QVVVdkJnOUI4aCtnZFVwbkRaRGVSeG13alBDbE5j?=
 =?utf-8?B?eDdxSTdFYVJSQ0JXNmliQWIzTmY4UVJNdldQU2Y4SU5ZampKUXVnZ1Jla0tV?=
 =?utf-8?B?aEVYY0Z2dENCK1lJQ3JIZ0M1Q2lTUEFlMW9HN1NUV2JxZmxnMUlDMFFKZWZ2?=
 =?utf-8?B?emEvNGViUy9OSkpxQ1JjNlVpU3RScGhPR1N5RGM1eFhnWHdsMmRBaHdpQWtx?=
 =?utf-8?Q?+UBnPVRzfrCKg+TkCjS3ShnKxS/+L/ixdJgwVLh01eBJd?=
X-MS-Exchange-AntiSpam-MessageData-1: OMn18YEXIIYl/g==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a5c61eb-a395-43ba-a05c-08da5382513c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 12:34:00.1534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2KA6dcFGMYv3248IZRCjc5I0UHGAZtf5/9XvP2HfL/sm7D7yKmsf9kYtwNi4xDcwLl7vKZ9qgUpyZvBn+O9qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4810
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.06.22 12:21, Hector Martin wrote:
> The Anker PowerExpand USB-C to Gigabit Ethernet adapter uses this
> chipset, but exposes CDC Ethernet configurations as well as the
> vendor specific one. This driver ends up binding first to both CDC
> interfaces, tries to instantiate two Ethernet interfaces talking to
> the same device, and the result is a nice fireworks show.

Could you explicitly state here that the root cause is that the
driver for the vendor specific mode binds to the device based only
on vendor:product ID, thus taking interfaces that only the
class driver can handle properly?

This log reads like the basic issue is that it binds to two
interfaces.

The patch itself is fine.

	Regards
		Oliver

