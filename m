Return-Path: <netdev+bounces-7295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C648F71F895
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5782C1C21163
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C1E15BE;
	Fri,  2 Jun 2023 02:46:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6002F15B2
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:46:23 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2068.outbound.protection.outlook.com [40.107.113.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB46192;
	Thu,  1 Jun 2023 19:46:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lo46ncPDlbpm65Gncjyouey/zOb2k3BWkZDKUuu/rr0fawEv6xdfLudkE4PkYWrPL33U3A3g8MqK+msrwX44V30bDMQEI4SD8nEt48Rjf3/63OUrbE5Bt/keSYiCLOpCDJs7DXhxY+Kba1o0j3ItC80GTHMRy1wQ/kkZpt5tYK53EGhVqHWBlJPfmlpTfRp2g0DEGKP7jdfXBTtGNYOG1tqjY8rWwvoqZ7Cnq2WiEOht4KQxVnmm+NQ9esXdNRS1erAs419VKalIfZYR1hmBd557C38Q2m1EdIzIuX+fw3XLDN6cJs8kh/EqpSKk4VOKh8FxxMml9VqYy505r9iLzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uo0US8DizagmgAvqABaTq572G3i1nQdwoji3HCyiIfc=;
 b=dR6uNGX2aLV/wbFLOdtLhCfBGTScDKYoMOzxFEHtntwflb86RVrn4o5uHqwu4HB+TWrstZUOZjZXJ6IpSeEuyR3RI8TxSxhRAvVCPdI4EqNRwJJchiEFI9sIrCztdvOfWPyIAlP/lvXMIyvYF/Zh31jHqygYIuit4djPUaCj5iAxL656pZANnwShv93RPuR+ZijjEEtcje7bSjUL3eCaW1iBhspFQus1gFRlPmFlsU8Ag0V3qSQkfIJWtH4V77R7JguCIFGGPITnMbAkD9Of8q7bd8zePuFQVfEDGp23AapdBczs5+nd6E7OdWG3GQKmTMtDzN9Qq9jyyE2PDonVdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uo0US8DizagmgAvqABaTq572G3i1nQdwoji3HCyiIfc=;
 b=pssO9brSBS7qfGWWmZhkHfoO8UuuCUSsJvPgkR2jX1lBmmuxzeg6tpTKYacD5wipPEofD3gAGyDX+HD5a++ta+jXiOqPdohG/kdt8IpbZKxVBZmADntxio6RegBIlX7/DgkJUmoMNNAv2YjqS19QSj3G6RbZgYWkUWnx4/IQA8s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by OS0PR01MB5377.jpnprd01.prod.outlook.com (2603:1096:604:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 02:46:17 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 02:46:17 +0000
Message-ID: <82884b6a-33a1-dd8f-a537-771d99c513ee@sord.co.jp>
Date: Fri, 2 Jun 2023 11:46:16 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 Michael Hennerich <michael.hennerich@analog.com>,
 Alexandru Tachici <alexandru.tachici@analog.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Horatiu Vultur <horatiu.vultur@microchip.com>
References: <e7a699fb-f7aa-3a3e-625f-7a2c512da5f9@sord.co.jp>
 <7d2c7842-2295-4f42-a18a-12f641042972@lunn.ch>
 <6e0c87e0-224f-c68b-9ce5-446e1b7334c1@sord.co.jp>
 <8cc9699c-92e3-4736-86b4-fe59049b3b18@lunn.ch>
 <50ae1bda-3acf-8bce-c86c-036bc953c730@sord.co.jp>
 <cc5cae94-effa-4246-85b8-8d3ec8fada66@lunn.ch>
 <919bdf79-1b53-9578-b428-a8ad969ef0d6@sord.co.jp>
 <feae1f84-36fd-437e-8b2f-9c058ba1e989@lunn.ch>
Content-Language: en-US
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: adin: document a phy
 link status inversion property
In-Reply-To: <feae1f84-36fd-437e-8b2f-9c058ba1e989@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0161.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:383::6) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|OS0PR01MB5377:EE_
X-MS-Office365-Filtering-Correlation-Id: d086e37b-fed3-4263-7bb3-08db63138a0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BjU319yoS0AiRL7gQPPY/oYIGVJ4rlpjmps0b1qSggmFw6f2uSnJiAo0vb8HKkfSuvRzIJ30o1beEIVNAYUoFI6pFOgVv6bNGQpJvhCwvdiXykVmp9K0UAKZVPIC96m4JPElTkRztRn3NzT5CcKo6ESlmTWk5iHrgui9iwaEVtvWDFpKrxnd45WMw3MuFbcGNadqtJgUkaP1S4o5sEwnvk53NVsaCf/HZEXizhIpPX2gFmkTjH1It5lfZZkrpykg8c1hYv+TULkl4VdQUVKGF86bmBmnGHTC04iZgCJc3cQw2fOBkHsgIMzDJUVOq48XLEC9SilptvOSRAvCaaoCgXBgYvYaQQ4+PdLqt0r6G1yhEavtVd3ScRo9FDxqOjImDGHWHpJKShzKa1MU32Cp4z+ht3bIUZxs63zowDENX/jv+rXIGhzrXubhBlDD/XUOmIuI9VuMY9gOIyvcTJp9QmwhdO+8y4H+gxD3M4Sh0Rj+aOyQUoTrWE26gVXpBIl5rdakhtLskTtHcGVixdGOcjBz6it9uNeX/QsnPasNxPvku0WW9MMWNFhbqtXc/crdnD/XxdBlu2V6F9UdEDL8M8aVV0l1gHzdUHZFfkCSqSmgJzf9jLl+uQSkBquoPj9XL4pgfUZIkh8ohc4aOqWOmA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39850400004)(346002)(376002)(396003)(451199021)(478600001)(54906003)(31686004)(26005)(6506007)(6512007)(53546011)(83380400001)(2616005)(186003)(2906002)(44832011)(8936002)(6486002)(8676002)(38100700002)(86362001)(316002)(36756003)(966005)(41300700001)(31696002)(66946007)(7416002)(66556008)(6916009)(4326008)(66476007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3l4M1J6OEkyY05vVElsYmZvbHgxNDhyaHhvbTBYVHZpd3NJT3JBM2dMUHVp?=
 =?utf-8?B?Z3AydXpCL0MxUDZwQnhOMUNQMGxQTVhLaVZjVzVnak9pNzI5YUFBditnSkdw?=
 =?utf-8?B?dy9SKzVwRGh2NHJjdjd1aUdvWktkN1MxL2pndXJDR0d0cW9HS3haN2p4N09u?=
 =?utf-8?B?ZHd2em53WmFiNGRNRElKcXZhazEydU9FeEc3WlFiMjlERDlPbGNwOHRvcHVh?=
 =?utf-8?B?Rk1LMVcxc2IxZFRPRFdLT2NlRWx6dWRHb2Jka3lmWDZwbmg1WnE3NG9paTZW?=
 =?utf-8?B?OTRFc1hId1dnTUI2S2lmeTZWWUMydzhMWWdES0QrVDJIZmFyNjhmQVh2NGRq?=
 =?utf-8?B?bXBCY29ibTU5dzlCSWFXSmEzSkowbEdDcWNxVldQRmVlMVBSeUpBb1VXMitE?=
 =?utf-8?B?WjlFTVFWZnM0QnliU291NHorSElvRVo5QjNIZWF0OXIyMmE5c0dSQTRQN3ZZ?=
 =?utf-8?B?YjZQdEczUDVzMmVmOVF2YXlERTdkSkR2Tms0UGNpWmdsVWFDNEY5U0ZOSVN2?=
 =?utf-8?B?ZmltS1JxZFhvcXExejg4SCtRbmZYVGJkcStxczl4SXNNUis1OXJnVVhKSlpJ?=
 =?utf-8?B?cXpSWmRmU1NIaDB0Q2ZzYitZVm1Hd2ZsaDJuLzRMa3lEdHJVOUkwTWdHaFVL?=
 =?utf-8?B?WXdpSnJPSGRMcUgwUExUc0cwUklYTGIrclJYTXFlUU80M2lNcFhYaE52eVBF?=
 =?utf-8?B?NkdWZ2x3cG9ybWFvRjBDOGRjVGpFcFhPZXgwcTFhc3hHcFBJQzZHWFZBQXpK?=
 =?utf-8?B?Rk1Ea3VNSE5CMWJKTlJHZWJ2NCtwdHNCOHQxR2hkY2o5bWNoT1dweW1uSUNn?=
 =?utf-8?B?d1Y4b3dZcE5SUmU2RjI3TGY2MVY3dEZlZG5QOGdwUXdyVkpobEZ6YkVlWFBB?=
 =?utf-8?B?aldzM3Y2Sms5dDRwYnk5WnJKbnJZUlFiWUwyeHBRRFdJMjQycEE4Mjk2N2t4?=
 =?utf-8?B?dXFPeHNVZzIzNGh2TllxWGcyUjFGUWw1MkRNTlpzSW9QUHU4NTFBMFJyRUh2?=
 =?utf-8?B?THFXaHpjQi9zc0RsLzhCVTlyU2ZJem5iSlhPQVBRbk9jV0F5a2FNekVaN2FV?=
 =?utf-8?B?OWpFdGl0cjYzWDBqaTNZWXdDTWJtSUVjbE9jTXJoYXlCdXJKVVlGYlpvYnVD?=
 =?utf-8?B?SmZsaVhZbXcrTXBxVkVaTG5oeE1YM2hiVXNwbkdoWlVPeThSWFlTcmIrSnl2?=
 =?utf-8?B?RVVoZUhaM05MVndEWTllN0RZajhIVWo5RnB2T29qM1ZvRVVWYk0vczZkelFH?=
 =?utf-8?B?cDI5TVdFc2pscGZVZWZtaEpDeS81cWdnZG14eE11SDRQRXJ1L1NaU0x0UVlT?=
 =?utf-8?B?bC9DRDM4Q1lKTEovYTBDOXpaRjk2V1JtNllHYWhGa2tkdjFvRzZMODRrdFg4?=
 =?utf-8?B?RFhlL1VOdm8yUzdBdHpRWiswYnpXSnlvT3VTYTRFNHJOR20xQnR4Y2UzeXZM?=
 =?utf-8?B?TG1YWk1Ddy9JTlFLd1ozRkt0YlFaQWEvcytYNmIyS1VMWW5xZGdxY3R4S2xa?=
 =?utf-8?B?MHdsZmFaUnRhNVJHRlQ2Y3hQUmVyc0ZXdmVzUkxBVGV4OGQ0MVhVY1p3OUVR?=
 =?utf-8?B?Tm5iS05adGxrUlNiUDY3QjhKK2FFR1F3YytYQzByKzJrRUhCeWsranRpaXVv?=
 =?utf-8?B?K3Q3Y05oOFNMR2NOcmZiTlFMa3RuZlhxMllXZzZFUVVpQW1CZjhSem5BYVYw?=
 =?utf-8?B?dlQ2VjhKaGJxUWlxaWxUbGhxclVQaWFYT1gvU3lzcm92MlVacE5HQmtreEhQ?=
 =?utf-8?B?VGhXcVRFKzBCb2NSdzIwQWp1QWc0QTlCbVdvd0tnS3lGTWZ6ZXBtYngzcDZt?=
 =?utf-8?B?TzV5MnpjeUMzc2pZd0FReW5TSkQ5dEp5Y3JjcXJKZzV2SlM5Z2NWVW1hRmdD?=
 =?utf-8?B?NURQblB0Y3FNYjU3K0tITVFma2FpWmJmcHV3NFBjTzczNVNZcktVNThGekJV?=
 =?utf-8?B?SmhBR0VJNStxNVFWdTVBN1dFdUcvYUYzSjMxZkhRQVY2c3Y5NG9RNi9RRU5r?=
 =?utf-8?B?b1JUZXo3UDMyY0VMazIxSHFiTDh5T2pEa3hnbW14WHk0YzBPTGg1a3JtVHQ5?=
 =?utf-8?B?RHVlNFQ5djJVQ1R1RktjbGxwYlVhNjhZa3NkcUh3cjdFSHRCRHRMMFFiTnZn?=
 =?utf-8?B?eDlBckJocGw2UGZPY2tvd2htckk3RVlERStXbmFYTmNmaThha1ZxVzg0VzRo?=
 =?utf-8?B?RGc9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: d086e37b-fed3-4263-7bb3-08db63138a0a
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 02:46:17.6549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B3wwj9FZ9a5txsdGLMu0t1G+PIPISav11pcD40XGQO9+KsdADmoKAkW7ODOTpWubboZjpN19eTOKO0VYh6t7z2spd/s2FM0NFQo78shJN7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5377
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/06/01 23:45, Andrew Lunn wrote:
> We are now getting close to having all the pieces of the puzzle to
> decide if this is the right or wrong way to do this.
> 
> This appears to be the 'Vendor Crap' driver. You are patching mainline
> here, so it is the mainline PRU driver we care about:
> 
> https://lore.kernel.org/netdev/20230424053233.2338782-1-danishanwar@ti.com/T/
> 
> Looking at the device tree binding, it uses the standard phy-handle,
> phy-mode properties. There is also emac_adjust_link() which is used by
> phylib to tell the MAC driver the link is down.
> 
> So you now need to convince me this change is actually needed in
> mainline.

Looking for purpose of MII_RXLINK signal, it seems like just for
EtherCAT's "enhanced link detection" feature.
refer: https://software-dl.ti.com/processor-industrial-sw/esd/docs/indsw/EtherCAT_Slave/PRU_ICSS_EtherCAT_firmware_API_guide.html#pru-icss-mdio-host-side-apis

So maybe standard linux driver can ignore this.

Then, what really needed is controlling just an LED, i.e. could be
done using the LED subsystem as your advice.

I will try it if I use this combination of devices in the future.

Please drop this patch series for now.

---
Atsushi Nemoto


