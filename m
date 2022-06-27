Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E0555CC92
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbiF0OFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 10:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236653AbiF0OFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 10:05:36 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2067.outbound.protection.outlook.com [40.107.22.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48903120B4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 07:05:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1o5TInqio7ZSHhO/tjebiqWQTXl/sxtjO0cs/Yi6YrjdctQ7rPL6kbFHTDdEMfv5poVwMBqKQuIvphn8NG1ZuEtp7rn3CoPpe7pGH4yau3bdpsFcOG21LPMU/UpWIgVB7M7Q6uaIxGUuTFihJgq8S8i5D/5c+rvFQbkb3HKmEI94X508UpUMFobWfR6dgYyOYwa5se2eSKvpNA+xjM0CNuumpM3BsIQ83fr8hi+97ps2QjnSYeqCzRRQuYD5clWdNZZe0F0qhhm5bT39+HiXSwkT67RqUmoyis/oxqrr54GLYhbrcraGN5rfEh0Pos5jeEZRLU8zNhkaeg0+4ysfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ood1FBUVkQpCy+rzeSWEHZT4Hubj3preSnjzT3Uy4yY=;
 b=Vlk+0rYc82DxZuSWZ/2Sc0yVEicKTdP2JHkbC7v9yKuILpUyfMG678QuXj2DlUVkURiK1Wbdf81rMw+7+pxHCvmmlzgwEfqYAiys5vwJf2XyswWmAi+VrZ90TjljCn73uM9bt7t1cyyDCk9A0Cwmb62Fdy9wN53SoULJ22QRynHQWIRQDkqo0GI3DZqOZvrfcLvQTS5non+TBm2zjTXnXVHMWTS3NO46njQj7Z15FCX1ukMrBa57lDVa01UT2hwN2cwQsb2EERha5zb3PgmZdHeGag5t/5pgdNAcpgQwQMWkjlVcKKK/6jRihXh3HWc6ZWXw9RYt081437ktW2d2eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ood1FBUVkQpCy+rzeSWEHZT4Hubj3preSnjzT3Uy4yY=;
 b=kwkWjINf6cNEwbR/GWue1CMA4HGNmAS7B99MfMhJsVv8d2eyHPmwqIHFupPnSpUVgzZo460BkD+mTe0KFHI7sdrPVariaJLv5k1NZ0SjeTPTLLmsFyVMIurrO5FjrNNzWSr+enTUY2AVbji3X3u9m2bvgpYUa7i8aAmBa9QsKHeAHpqgC30WGq3SyiPjgJJZlazZUD+9NXTCJgDYkSkoNaHPW8pZ80JDjHuSra1fV4HXytN6QN5Y+MM4AfJN4Hj+wqQPWb4Qli3eN1pk1F/7IhZhY8fvLdyQEZWL+HjV8bROtqTB+ulp6gE6oUf8a8hxz6cVg1W/oSnNSPrwTtOnYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DB8PR04MB5835.eurprd04.prod.outlook.com
 (2603:10a6:10:a6::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 14:05:29 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5373.018; Mon, 27 Jun
 2022 14:05:29 +0000
Content-Type: multipart/mixed; boundary="------------0FFoJw0FEiF6vUoJK38012RO"
Message-ID: <24312261-6c84-cd2a-9ab4-c92eb700507f@suse.com>
Date:   Mon, 27 Jun 2022 16:05:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To:     Lukas Wunner <lukas@wunner.de>
Content-Language: en-US
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Subject: How to safely disconnect an usbnet device
X-ClientProxiedBy: AM5PR0502CA0013.eurprd05.prod.outlook.com
 (2603:10a6:203:91::23) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95dad8a2-ae65-41cf-1c01-08da584617b2
X-MS-TrafficTypeDiagnostic: DB8PR04MB5835:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vQm7JpVFl9QQrjZ05FN/m7zSb57XSuzbt+snwPcbUD3Mtz6NQKkOO0a3y7sc1F5ryJzCiKYWc7oILIDrfxYi5DpahEhQllp1cS8lgZtbMH2wT2W04iWGSRxj0Xb8grh1jeY1EpyLGoOlt1C39JK/d3cCzev/dHz95SaTpV63f2piklLtjHJVpjAJjIVZ0j3mCiLWmpjgUiG8ozc4okYqTe844NC3ZEx1j0lsoyuFBxru4Up0O90d+UfnPvXBWOajfjXMm4KOmPUHJAZGG8dK/w3vnGWr/tGbB7OokEjqTF74cvChsqWZAi4X2dvIFLy325SQ/KuxAaOUjIwAHm4mXOwU+aMofrcgv8qD4cXgXkU3ib/pR/jnb+F+YYqQOgoZujVLSzoOFDGVc2opjWwpHVAlwSft3ah2KD2o1jlAiRE3X3/QoGKV3Q8E9NXVSnb5bBj0rhC9QzeCLGRRp2E32S8XILh9kE71d+wQ5mgtHE1GAnMsXLY7uVzyDkQg+6hQMqywXtOXnGxp0pjy486QTWdNd2Z6cHg4dLoPmtJmE8pHydtgXmeEMEEAs+ZKYp+BqwgHCnC/hkbuB8R775keo1qdVfcqbpYJ4Dd+hfI4icnTiBP7ClGqWzAx2nL2jtfJl/E/gZYYToi6hCSxbyrYszxlUnBeJVRLTxOfvKRYpuHghmebf3KduhG9OXJWJ0VYkYxERX/Ei2wyNW0DFg4zAmTHK9PoJupy3EZmyscxNmZEHv5dQQDieagHJcNrM1jwerBMVXfyg88GlvRhfPBLb4Wrdi2+2PotvPNopMdhd98EczL/Kn4WXSfwnAWSp8AV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(346002)(396003)(136003)(376002)(38100700002)(8676002)(2906002)(186003)(6486002)(66946007)(86362001)(8936002)(36756003)(31686004)(31696002)(316002)(235185007)(33964004)(6916009)(5660300002)(2616005)(478600001)(4326008)(66556008)(41300700001)(6506007)(66476007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0FrK0k3ODhFOXJ3TndLS2lPd1pCellXRnF3Q3BkYzMrVFB4c2JVL1lPcTJM?=
 =?utf-8?B?bU1YVUNnNXc1VjhVSnQyaG1TVXRBWk1LUFRoWjl0dzIzcGVrK3YrM3NOeTRj?=
 =?utf-8?B?dGxNMC9uZlhjb0RmNks5QjJ0ZVpEWUpaRCtncXYzR0p2YWlPYzJvZ25CVEV0?=
 =?utf-8?B?RDRyMmc1amtyZVB1VzRVTEZIZzFTK25TZVZnSlpOTVphK3VOb1dMbkxGUTha?=
 =?utf-8?B?TmsxY1Iyd3Y3TGFOWGJlUS8yN0EvbjdWMlRObEtFYWZhcHljR0h2Q0V1OSs4?=
 =?utf-8?B?L1hMTDhVZ0FWTkRsU0pOWVV4anVQYlNZMldBN1NEalFnSlU4K2doNkVNUnp5?=
 =?utf-8?B?ZmJHM2tvcit5WFpJU2FQR2RlNVpPVUVhaVFjei9JQ2lIcXg4enpEdHJCdXli?=
 =?utf-8?B?K01PVU5IeHBEMGtDMWpjYjRLQTRZOWlRZ0I3ZmEyZUEySnhidGRKUSsrQjBX?=
 =?utf-8?B?Tkl0TFBRTUs5ZXkrMGhQVWxBUHNNaHVTdGtDOVFLeEYvVVRvV2dNNW5qZmx0?=
 =?utf-8?B?L3VlY09BVldCSnZTNUJuemhhNjFLenE4TDVMZHY4dVVxNmpwaW5VeDFpd0ZD?=
 =?utf-8?B?V2ZreDMxOHNaZmtMZlBOek9aZW9FNTNCSUtzcTlIL1JkU0dnamVZc2lYSVhn?=
 =?utf-8?B?K0l0a2FPNGk0UTJNYTZ2eWI1ajhpRU93MjNGOUFDYStQSm1JZkljd0lTM2VV?=
 =?utf-8?B?bDdrR2orS043b3RZNkFGdGx3THNRZUZWbzUrMXNXeEJvS3YrQ1V0S2M3dmhl?=
 =?utf-8?B?UGN1aTJhdXpsNk1XVmV2Ti9FakxHQ3ZKUHJGK016aUFhY1pEeGRKaDZMRUdZ?=
 =?utf-8?B?RkRHMS9uSG0vV2lzY3hETmt3bTdQczk0WGVYbDBwOXd3QldreHVUSFBDeUFP?=
 =?utf-8?B?MUhuQVduMWdxamZxWUtjQTZxbEhrOGVFYkFlVmY5a0M2MG9vbDNZNnZTaDdx?=
 =?utf-8?B?MHQxemliYko1bCswMk4vTnpJOE8xcmUyaVE5UWdvWlNvM1JSMkg2RFNxTlFP?=
 =?utf-8?B?emEra3RRcC9tbmx1d1AzeXVPekZTYlJDVVFnNkNHOWVxUGhtRHpmS0RXNmtX?=
 =?utf-8?B?ZmdManZXQlhML3lFMVVhc0hKWWlLM3doVWpmMDArM1VXNTJrK1ZlZ3FYbE1l?=
 =?utf-8?B?NEEwazNhZGZqQnBKUzZRRTBiU3FjbkxEQjU1aEhjRmFDcXMvTFVvNjlzZEJk?=
 =?utf-8?B?R2ZBS3cwLzhSRlk3YTN4OGZKQ3hXV2ZnaFRxdndIUk0rb1NBOFVNYjJtN3Fm?=
 =?utf-8?B?NE9lVnAwVUwvSGxJSFlocUFEeWlScjdnbGNQa1JRckJmQlFMZUZWTTE0U1l6?=
 =?utf-8?B?aWNvQU96a28yaWVGakJjZkNwanNjakFneXEvMVhGdGV5M0ZoK0lOcEU1Z2pa?=
 =?utf-8?B?Y1dqSEdoL2VuSHVRVzg2djFuTUJCeUpjS3hmYzdQWVVxazN0NFhRVkJvSVFh?=
 =?utf-8?B?enEwMDBESlQxNE9wQ0M4MHlzaEdBUFdyMkNxem9wVXcramhmdEVjK2FLNFFv?=
 =?utf-8?B?dGNGSmM1c09aRzBEb0cvUElZKzN5QmM3YkJnQlMzWFdTWXVMc1FVZEx4WFVt?=
 =?utf-8?B?bWF2Mm1RalFydUV5cFdQMG9vUXFCSFExcEQ2Wm5PMER6RDNTZ3I0SzZYYkhX?=
 =?utf-8?B?SFV0SU8rVUdOZ3lBQWl3d2JBQ0NDdi9YWkRxSVAwNGRtaURRK2pVdlBIdUg2?=
 =?utf-8?B?NGJhQWJtditJVVpKdXV5eUVTdmdwTmtQNlpHaVkyZ0RySndHa2VhK0xnQTJv?=
 =?utf-8?B?ZjNnSTM5OEZIdFhzMnFEYVNVSE9sR3pmUlNSak1oaHRmSkNVUHlEZHpISG9E?=
 =?utf-8?B?L2FFUFNpemFpek96UjJPMFNRSExQYVprL2V6R2xQNFlKTXFjUExhTWVucFdY?=
 =?utf-8?B?OHJmY3Rqbkpmdjl0VW8xMGlKOUpDNVd1dEVsV2lRcE1lb3JHSWYvTnhqcXNx?=
 =?utf-8?B?Y0UzZ0NKK1FLTU00VnRxZS8rZzE5TWMvNWFISHdITjRqUmFKMVI5c0xHR28x?=
 =?utf-8?B?czFZanZnbldsT1AzNUJhM0pDMTVZUjJHSzRlZ0oxUTN6YkpLbGZlVDMwNXVw?=
 =?utf-8?B?OCtDc0lXRFhadFB2M3dLUXo0U01PbWoxcG9MUHMzOEE0bXJJL2hXS0hMZG1V?=
 =?utf-8?B?NXdiNTdFMEdnclVRb21sTUJuVEFZNUU5WGNkR1ZlclpkQkNIUzRjaER6WTR3?=
 =?utf-8?Q?PQgIsIxwE6aq865EGe1PolH8C2PTp+yflPdtVjwwKc+I?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95dad8a2-ae65-41cf-1c01-08da584617b2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 14:05:29.6724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zazpKq6dbQP/Kx4h/U4tRNZi5Wqkn3T+LhPjRG+zT1YxkyZpSMyxWhr9AD9g1U/17zSewgkzFKrexim3bvS1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5835
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------0FFoJw0FEiF6vUoJK38012RO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

looking at the race conditions with respect to works, timers and bottom
halves it looks to me like me it needs the following algorithm (in
pseudocode):

1. Set a flag
2. Cancel everything
3. Recancel everything

while checking for the flag while every time a work is scheduled,
a timer armed or something similar.
By that logic anything that escapes the first round will be caught
in the second round. What do you think of his patch?

	Regards
		Oliver

--------------0FFoJw0FEiF6vUoJK38012RO
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-usbnet-fix-cyclical-race-on-disconnect.patch"
Content-Disposition: attachment;
 filename="0001-usbnet-fix-cyclical-race-on-disconnect.patch"
Content-Transfer-Encoding: base64

RnJvbSAxNWM1MzdkZTVlNmU5NDk5Yjk2NGY4MzM3YjIyYWUxODM3NDJjYmI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgpEYXRl
OiBNb24sIDI3IEp1biAyMDIyIDE2OjAzOjM3ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gdXNibmV0
OiBmaXggY3ljbGljYWwgcmFjZSBvbiBkaXNjb25uZWN0CgpUaGVyZSBpcyBhIGN5Y2xpY2FsIGRl
cGVuZGVuY3kgdGhhdCBtdXN0IGJlIGJyb2tlbi4KClNpZ25lZC1vZmYtYnk6IE9saXZlciBOZXVr
dW0gPG9uZXVrdW1Ac3VzZS5jb20+Ci0tLQogZHJpdmVycy9uZXQvdXNiL3VzYm5ldC5jICAgfCAy
OCArKysrKysrKysrKysrKysrKysrKysrKy0tLS0tCiBpbmNsdWRlL2xpbnV4L3VzYi91c2JuZXQu
aCB8IDE4ICsrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCA0MSBpbnNlcnRpb25z
KCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi91c2JuZXQu
YyBiL2RyaXZlcnMvbmV0L3VzYi91c2JuZXQuYwppbmRleCA3ODM1ODkwZGY2ZDMuLmZjZjFhM2I5
ZGIxMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvdXNiL3VzYm5ldC5jCisrKyBiL2RyaXZlcnMv
bmV0L3VzYi91c2JuZXQuYwpAQCAtNTAxLDcgKzUwMSw4IEBAIHN0YXRpYyBpbnQgcnhfc3VibWl0
IChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVjdCB1cmIgKnVyYiwgZ2ZwX3QgZmxhZ3MpCiAJCXNr
YiA9IF9fbmV0ZGV2X2FsbG9jX3NrYl9pcF9hbGlnbihkZXYtPm5ldCwgc2l6ZSwgZmxhZ3MpOwog
CWlmICghc2tiKSB7CiAJCW5ldGlmX2RiZyhkZXYsIHJ4X2VyciwgZGV2LT5uZXQsICJubyByeCBz
a2JcbiIpOwotCQl1c2JuZXRfZGVmZXJfa2V2ZW50IChkZXYsIEVWRU5UX1JYX01FTU9SWSk7CisJ
CWlmICghdXNibmV0X2dvaW5nX2F3YXkoZGV2KSkKKwkJCXVzYm5ldF9kZWZlcl9rZXZlbnQgKGRl
diwgRVZFTlRfUlhfTUVNT1JZKTsKIAkJdXNiX2ZyZWVfdXJiICh1cmIpOwogCQlyZXR1cm4gLUVO
T01FTTsKIAl9CkBAIC01MTgsNiArNTE5LDcgQEAgc3RhdGljIGludCByeF9zdWJtaXQgKHN0cnVj
dCB1c2JuZXQgKmRldiwgc3RydWN0IHVyYiAqdXJiLCBnZnBfdCBmbGFncykKIAogCWlmIChuZXRp
Zl9ydW5uaW5nIChkZXYtPm5ldCkgJiYKIAkgICAgbmV0aWZfZGV2aWNlX3ByZXNlbnQgKGRldi0+
bmV0KSAmJgorCSAgICAhdXNibmV0X2dvaW5nX2F3YXkoZGV2KSAmJgogCSAgICB0ZXN0X2JpdChF
VkVOVF9ERVZfT1BFTiwgJmRldi0+ZmxhZ3MpICYmCiAJICAgICF0ZXN0X2JpdCAoRVZFTlRfUlhf
SEFMVCwgJmRldi0+ZmxhZ3MpICYmCiAJICAgICF0ZXN0X2JpdCAoRVZFTlRfREVWX0FTTEVFUCwg
JmRldi0+ZmxhZ3MpKSB7CkBAIC04NTQsNiArODU2LDE2IEBAIGludCB1c2JuZXRfc3RvcCAoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5ldCkKIAlkZWxfdGltZXJfc3luYyAoJmRldi0+ZGVsYXkpOwogCXRh
c2tsZXRfa2lsbCAoJmRldi0+YmgpOwogCWNhbmNlbF93b3JrX3N5bmMoJmRldi0+a2V2ZW50KTsK
KworCS8qCisJICogd2UgaGF2ZSBjeWNsaWMgZGVwZW5kZW5jaWVzLiBUaG9zZSBjYWxscyBhcmUg
bmVlZGVkCisJICogdG8gYnJlYWsgYSBjeWNsZS4gV2UgY2Fubm90IGZhbGwgaW50byB0aGUgZ2Fw
cyBiZWNhdXNlCisJICogd2UgaGF2ZSBhIGZsYWcKKwkgKi8KKwl0YXNrbGV0X2tpbGwgKCZkZXYt
PmJoKTsKKwlkZWxfdGltZXJfc3luYyAoJmRldi0+ZGVsYXkpOworCWNhbmNlbF93b3JrX3N5bmMo
JmRldi0+a2V2ZW50KTsKKwogCWlmICghcG0pCiAJCXVzYl9hdXRvcG1fcHV0X2ludGVyZmFjZShk
ZXYtPmludGYpOwogCkBAIC0xMTc5LDcgKzExOTEsOCBAQCB1c2JuZXRfZGVmZXJyZWRfa2V2ZW50
IChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCQkJCSAgIHN0YXR1cyk7CiAJCX0gZWxzZSB7
CiAJCQljbGVhcl9iaXQgKEVWRU5UX1JYX0hBTFQsICZkZXYtPmZsYWdzKTsKLQkJCXRhc2tsZXRf
c2NoZWR1bGUgKCZkZXYtPmJoKTsKKwkJCWlmICghdXNibmV0X2dvaW5nX2F3YXkoZGV2KSkKKwkJ
CQl0YXNrbGV0X3NjaGVkdWxlICgmZGV2LT5iaCk7CiAJCX0KIAl9CiAKQEAgLTEyMDEsMTAgKzEy
MTQsMTMgQEAgdXNibmV0X2RlZmVycmVkX2tldmVudCAoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQogCQkJfQogCQkJaWYgKHJ4X3N1Ym1pdCAoZGV2LCB1cmIsIEdGUF9LRVJORUwpID09IC1FTk9M
SU5LKQogCQkJCXJlc2NoZWQgPSAwOwotCQkJdXNiX2F1dG9wbV9wdXRfaW50ZXJmYWNlKGRldi0+
aW50Zik7CiBmYWlsX2xvd21lbToKLQkJCWlmIChyZXNjaGVkKQorCQkJdXNiX2F1dG9wbV9wdXRf
aW50ZXJmYWNlKGRldi0+aW50Zik7CisJCQlpZiAocmVzY2hlZCAmJiAhdXNibmV0X2dvaW5nX2F3
YXkoZGV2KSkgeworCQkJCXNldF9iaXQgKEVWRU5UX1JYX01FTU9SWSwgJmRldi0+ZmxhZ3MpOwor
CiAJCQkJdGFza2xldF9zY2hlZHVsZSAoJmRldi0+YmgpOworCQkJfQogCQl9CiAJfQogCkBAIC0x
MjE3LDEzICsxMjMzLDEzIEBAIHVzYm5ldF9kZWZlcnJlZF9rZXZlbnQgKHN0cnVjdCB3b3JrX3N0
cnVjdCAqd29yaykKIAkJaWYgKHN0YXR1cyA8IDApCiAJCQlnb3RvIHNraXBfcmVzZXQ7CiAJCWlm
KGluZm8tPmxpbmtfcmVzZXQgJiYgKHJldHZhbCA9IGluZm8tPmxpbmtfcmVzZXQoZGV2KSkgPCAw
KSB7Ci0JCQl1c2JfYXV0b3BtX3B1dF9pbnRlcmZhY2UoZGV2LT5pbnRmKTsKIHNraXBfcmVzZXQ6
CiAJCQluZXRkZXZfaW5mbyhkZXYtPm5ldCwgImxpbmsgcmVzZXQgZmFpbGVkICglZCkgdXNibmV0
IHVzYi0lcy0lcywgJXNcbiIsCiAJCQkJICAgIHJldHZhbCwKIAkJCQkgICAgZGV2LT51ZGV2LT5i
dXMtPmJ1c19uYW1lLAogCQkJCSAgICBkZXYtPnVkZXYtPmRldnBhdGgsCiAJCQkJICAgIGluZm8t
PmRlc2NyaXB0aW9uKTsKKwkJCXVzYl9hdXRvcG1fcHV0X2ludGVyZmFjZShkZXYtPmludGYpOwog
CQl9IGVsc2UgewogCQkJdXNiX2F1dG9wbV9wdXRfaW50ZXJmYWNlKGRldi0+aW50Zik7CiAJCX0K
QEAgLTE1NjAsNiArMTU3Niw3IEBAIHN0YXRpYyB2b2lkIHVzYm5ldF9iaCAoc3RydWN0IHRpbWVy
X2xpc3QgKnQpCiAJfSBlbHNlIGlmIChuZXRpZl9ydW5uaW5nIChkZXYtPm5ldCkgJiYKIAkJICAg
bmV0aWZfZGV2aWNlX3ByZXNlbnQgKGRldi0+bmV0KSAmJgogCQkgICBuZXRpZl9jYXJyaWVyX29r
KGRldi0+bmV0KSAmJgorCQkgICAhdXNibmV0X2dvaW5nX2F3YXkoZGV2KSAmJgogCQkgICAhdGlt
ZXJfcGVuZGluZygmZGV2LT5kZWxheSkgJiYKIAkJICAgIXRlc3RfYml0KEVWRU5UX1JYX1BBVVNF
RCwgJmRldi0+ZmxhZ3MpICYmCiAJCSAgICF0ZXN0X2JpdChFVkVOVF9SWF9IQUxULCAmZGV2LT5m
bGFncykpIHsKQEAgLTE2MDYsNiArMTYyMyw3IEBAIHZvaWQgdXNibmV0X2Rpc2Nvbm5lY3QgKHN0
cnVjdCB1c2JfaW50ZXJmYWNlICppbnRmKQogCXVzYl9zZXRfaW50ZmRhdGEoaW50ZiwgTlVMTCk7
CiAJaWYgKCFkZXYpCiAJCXJldHVybjsKKwl1c2JuZXRfbWFya19nb2luZ19hd2F5KGRldik7CiAK
IAl4ZGV2ID0gaW50ZXJmYWNlX3RvX3VzYmRldiAoaW50Zik7CiAKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvdXNiL3VzYm5ldC5oIGIvaW5jbHVkZS9saW51eC91c2IvdXNibmV0LmgKaW5kZXgg
MWI0ZDcyZDVlODkxLi44YjU2OGFlNjUzNjYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvdXNi
L3VzYm5ldC5oCisrKyBiL2luY2x1ZGUvbGludXgvdXNiL3VzYm5ldC5oCkBAIC04NCw4ICs4NCwy
NiBAQCBzdHJ1Y3QgdXNibmV0IHsKICMJCWRlZmluZSBFVkVOVF9MSU5LX0NIQU5HRQkxMQogIwkJ
ZGVmaW5lIEVWRU5UX1NFVF9SWF9NT0RFCTEyCiAjCQlkZWZpbmUgRVZFTlRfTk9fSVBfQUxJR04J
MTMKKy8qCisgKiB0aGlzIG9uZSBpcyBzcGVjaWFsLCBhcyBpdCBpbmRpY2F0ZXMgdGhhdCB0aGUg
ZGV2aWNlIGlzIGdvaW5nIGF3YXkKKyAqIHRoZXJlIGFyZSBjeWNsaWMgZGVwZW5kZW5jaWVzIGJl
dHdlZW4gdGFza2xldCwgdGltZXIgYW5kIGJoCisgKiB0aGF0IG11c3QgYmUgYnJva2VuCisgKi8K
KyMJCWRlZmluZSBFVkVOVF9VTlBMVUcJCTMxCiB9OwogCitzdGF0aWMgaW5saW5lIGJvb2wgdXNi
bmV0X2dvaW5nX2F3YXkoc3RydWN0IHVzYm5ldCAqdWJuKQoreworCXNtcF9tYl9fYmVmb3JlX2F0
b21pYygpOworCXJldHVybiB0ZXN0X2JpdChFVkVOVF9VTlBMVUcsICZ1Ym4tPmZsYWdzKTsKK30K
Kworc3RhdGljIGlubGluZSB2b2lkIHVzYm5ldF9tYXJrX2dvaW5nX2F3YXkoc3RydWN0IHVzYm5l
dCAqdWJuKQoreworCXNldF9iaXQoRVZFTlRfVU5QTFVHLCAmdWJuLT5mbGFncyk7CisJc21wX21i
X19hZnRlcl9hdG9taWMoKTsKK30KKwogc3RhdGljIGlubGluZSBzdHJ1Y3QgdXNiX2RyaXZlciAq
ZHJpdmVyX29mKHN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRmKQogewogCXJldHVybiB0b191c2Jf
ZHJpdmVyKGludGYtPmRldi5kcml2ZXIpOwotLSAKMi4zNS4zCgo=

--------------0FFoJw0FEiF6vUoJK38012RO--
