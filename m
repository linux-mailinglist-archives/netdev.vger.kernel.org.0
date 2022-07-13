Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D5E573255
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbiGMJUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbiGMJUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:20:00 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60086.outbound.protection.outlook.com [40.107.6.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5410DA5A4
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 02:19:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfqdRDT7Dxfb6znB7xA8Q0dnBLYEs5/Z24Wzr5CH2cpLNzUkPY3kKy+/IH7Qcetr7yq8slPOX10ZSQ962GKcQ7qCqhlyoK3E7NrJBsnM8KR7QjO5ZRm/H4eYDjw53dk2y197Z2bz4OX7uT7heXuqI3Y/+WBpr9uS4Go57Ch5X99wqJ+g23SshoTynoYzD/Zr5bPELvqIeymK507NreiHCzf9W1xsh9dUbGALv42iz7H2YtX6Mf05mNuY9XCKWxGR6EZil72qWk8SOZ7g9DpYrdfJ0ql3GgxNMXc6h+l2L7ws37seAJMD0/7IyymYWcp/xvV7vEMq5hZWKr4tyRN6KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEzlgyoqktpBUwg5qI3Cs3eLw+k3O3PDbgsVFU2rvWw=;
 b=VgveumqRArUODB/DBd1QI/dmJJczlsXRsvuDwkKS+1kFaqHx6uEXeFtsU4cnW50o/oD8mEYExued+AXLlBAtQjP5kq+sQvpQYvrvq4Q/HDBQZiY8hjQ/Y6rIDNVA7IKLEx20vfethYT5n0ttCQZxV8o6/1wTeuIIabSSa+FqT2Ygg9nQMv3WHge+z6TXAthgTDv+T3d4x+NJMgnLpFdlLgdwQjZj3YnCzy/i3u7aeSzOvkcw3tMN38kMB5bbqqMZDqa5Pu1SxU4o2y2Q9u1RQeEjKcu2Ur2kX8IwY3sewRmPdRNFOK7n4OW8E1a+bipNcGFpCInMRxPlqvq9ZD3HwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEzlgyoqktpBUwg5qI3Cs3eLw+k3O3PDbgsVFU2rvWw=;
 b=rsoQ7UM28NSh93C8G5ghGNcO6lpZQDDrvZ3Kmvr3ijZz/cYvQpaj5ch3RlHZxQosRN0d4o8z0tazvNMWaWd7Z75nSRAavJeuoDGI7pT5Uqi4JAxcokDjcH+LlCTDauy0DmkZzwHd7PhlE1/6iywE2lpsz9nsn5jkZAT1vFnuMnacefdPvH21PpMNRyhWCVavCnvRKbZQrZJvO3XVSKTP/46GLMWsZAQL9beGVFCfTU4I5k0XHj1UQsDb7qhaphtPGX6JhetSb0t2CmRP/buG1siv3oPyA7wPAvRs9vhPMuzgRpRLC2tHXD0LqYl+lBr0bdtNXl0pgj1mtwXC1MuwQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM6PR04MB6248.eurprd04.prod.outlook.com (2603:10a6:20b:bf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 09:19:57 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 09:19:57 +0000
Message-ID: <743b3ff3-896c-bfc9-e187-6d50da88f103@suse.com>
Date:   Wed, 13 Jul 2022 11:19:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: [PATCH net-next 2/2] xen-netfront: re-order error checks in
 xennet_get_responses()
Content-Language: en-US
From:   Jan Beulich <jbeulich@suse.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <stefano@stabellini.net>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
References: <7fca0e44-43b5-8448-3653-249d117dc084@suse.com>
In-Reply-To: <7fca0e44-43b5-8448-3653-249d117dc084@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::17) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b73baaa-af5e-4ce8-baae-08da64b0dac2
X-MS-TrafficTypeDiagnostic: AM6PR04MB6248:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fdppvxoy6fB7RzXwbN/jS/vA8fxOlMEaUpyLP9848ljFdMZBByjfXmbaTRY/ukPv/hFbtq4ZfuAEXZDLkiqdsTgiqQ/LgG+9ADZ732NVIhjCdv8NKgXW42bEGi3NikKxfeRMPoNCACLaLMT6cdkDU6FI/vS1xcZcnAPx39UnXY9GUfJQWQ/FFxAXwBYkyZwzk11Hmeesl4jz+R2kB4QDL73Uxywr6/ujdGAOMecToJwdodPyr+Vq1ioSkX8mKrSPkZ32UJm3qETNBPSJx/3Z7gft5RV0c8ZeOAurSSsOoA0ApigL/eTv/B2ty4uwxa9+FnaDibWqn8HrBPsOSiJjQc6ywQCGGTauAe9fDXA03DS6KejCEXQyGQAXjwips4gz3JC5klyPgZegD+9hNMvgTELTWIdXTfSSN07WOIhnuLPk0iDDYQMUG5zOZX5byu1plaIh+4TmoBnFCrUbnFcl+BwhnQb1T/1nXcAR+mTrUMNWhFONdhK3h8OZvJQH/mVUCuYC6X6T/xU3C59Z2hEKIdI3VA8JRCRDQV+hEbTI19F5up/YCjaJa9b4VBygRZ4JLIivnBzE7pjfiNv7S5G8yb5usPxDxzLUibBnld0yHDK6QCuTcEoSndq/F8JPW7dtRvdXQjd4vldOctuXqeBtdHHDwZIDSBse13jM4UW43f26xedFs7zQ0Tv3TuGzvQU5W7fANQb2J09EHQrFYbPSLfmRKSKBrvuIDtysKw5OJ6pkU/uY3UvvkNB6i1PkkedQzpvjXic3hXtoHyMxNsCAKy7nVuFHVQvIAJz5VPaMB77yqGRgD9KdrIvnaoUwjQfbYQs69NPb7xZgPDi1ZgSx8V+LE5TYvNLnEqAOVSmA9IeMm0ziTwieMt2kzThY4akx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(366004)(136003)(39860400002)(2906002)(5660300002)(8936002)(83380400001)(31686004)(2616005)(38100700002)(478600001)(6486002)(86362001)(6506007)(110136005)(8676002)(54906003)(4326008)(31696002)(66476007)(316002)(186003)(66556008)(26005)(6512007)(36756003)(41300700001)(66946007)(169823001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTlFa2c4K2V1TmJxV04zbG84Z050WWtWeE1DdUU5TGY0MlN4VURYUXk0TThq?=
 =?utf-8?B?SlNsL3NUSnMxOTlzMUNldmRpenZjVDY1NDB6U210N210eHBmcXRwYWY2ZFZS?=
 =?utf-8?B?Ry93NFBvNFZWWVdMMmw4ckhzSzZiUU5tRE5sT25pd2JYNXNzY2tCV255VXI3?=
 =?utf-8?B?Y0JIUjZsRmZQZ2g0aXRrWnFtQ1R6a041MVRiRUN6bTlrOFBoaHJJZUYwNVAw?=
 =?utf-8?B?WHZvUngrLzVhNTRJTy9tcW1LSlhSZy9ON1JWaGNiNDdBUDRWaU40eXRLclhC?=
 =?utf-8?B?S211UmRyUDdtYk1jUU5RTnJSOEJBdHgzTmluTVVUMWh3eHdVVGlkOWxwRzNs?=
 =?utf-8?B?dHdxUTRUVkpUdnZ1WVBlbUZickQ0Vnh0N0cxTHhSMk1rWmJiaGJhajNlcEll?=
 =?utf-8?B?WEtEVkpaays5ODE1dk95a211R1NXTGgzeGo2aHlOU0R6d0g3TGwvb2NEVlpr?=
 =?utf-8?B?V3pUU0plOGF0S2JhTDdUZU1QSmxMejBjWjlmSjhFNGZoZlVUMlVpSDVpamJw?=
 =?utf-8?B?TnljRXc5SDBpZHZIYTBYeGlZQkNFRjM2UkE0cW1Yb1VHMTZMampIM0xhd3BY?=
 =?utf-8?B?TnZCSzExUkYzWkZpTXNZdjU5UGhtZjdqSFVJOHFaRlZEenlCekdmQ2RMVmY4?=
 =?utf-8?B?MjZRenozOFQ5d3dqbXBEdnM3SFAxSTdaT0NnM3ZHU1FaR1VSZUJVeFBNOHh6?=
 =?utf-8?B?b3RwOUFPZVRJTTB3QVB4QXRwcklINEt5c21ybVZNRVpRMnFKRVNYNzZPbEM3?=
 =?utf-8?B?L29leWRZblI4RHE3UmFsbW9HalNXQUFJT1NVR2xDcnlGY0JpS2JXL1RkLzVy?=
 =?utf-8?B?aHIyc2UyT2lzQWRGSkM5bXRGTGJhOWtBOHBnTWY3WXUvYXoyOFBwRitvQU95?=
 =?utf-8?B?cjA2WCt3V1pZR0ZPbm9qcU14REIxS3MvOWlXK3JiejFIZDRrcEJnVFREQ3VJ?=
 =?utf-8?B?eG1Ya3o3cEZ2eGFwNVppVzY2a3U3VFM0bHVBSk42NFgwUW1yQnZoZVdUcTlF?=
 =?utf-8?B?MkJlZE44TW1ySjVNQk1FdVRESUorbk5vY3NSRC9panptUVlEeEFPZFdJVmVC?=
 =?utf-8?B?NVNSU1hPMnNPMS90NllwNktheTRQRDVNbHU0TmNoa3B2RnJ0UE1qajRmMXB6?=
 =?utf-8?B?UTFTR3EwbVFYd2RwVHhPeThiQWJrZEQzb3ExRWw4OHhZRG1GYTVrUzhhRzQ3?=
 =?utf-8?B?c0ZxZnNTYmU4ZnlIU2FLKzdwbmlGdTkyL0Z0cklXQXovYzJJdDZ0OVJwb0Q2?=
 =?utf-8?B?emtpeXZuOHRmR1lJMWNPamR3TnZkbFc0WGQ3VUw2YzBFSHFSdHhaVWk0dHd2?=
 =?utf-8?B?U0tFTmJYOHdHalpiNG9wbFpQeWtRU3piZHZxc2dLaE5HSG9tYTRERXZVRVl4?=
 =?utf-8?B?bVkrZDJvZmlPcnNkKzNoVkRpVzMrQUdOMnE5bStodFVySDd0NkpjS0hBREVr?=
 =?utf-8?B?SnY5SW5TZ0hPQndzbDFhQnRLN010elpWK2F3TlhJQUIxOVhLN3VUU2NIR00v?=
 =?utf-8?B?TkorSlhUZ29sblVkb0ZiNExweCtLT1RVTlVXalJJc09jZkNKOW9LWE9tdVdq?=
 =?utf-8?B?eVBQVzFiTXpLTk5HSVlrb0QrQXJrRG1CTlB6T3FuRnVwMk9TY3BYWmhlL3Qz?=
 =?utf-8?B?RFkwREZ4MDRiU2FhUDk2MVRkTFpBanVWRUE0Rm5oeGdSWEswQVRZbjVwOGN2?=
 =?utf-8?B?eHQrdDBGaS9qWDlOWnRaUWxBdjIvNzV5U3NKVDA2cnhrVVlBaDJLVENhRElz?=
 =?utf-8?B?TEtvTHkxTlkveU1ncVRwTVVwaXUwR0IyVXg1SFkrTStvZ2g4RXVkSHlsNnZ0?=
 =?utf-8?B?NUhhUy9EZ2ZpeDhQMVpoRXFRZU9RUHJYZnoyUlI4VWNreUNEYTJFUXdBK0No?=
 =?utf-8?B?eTg4VU5tek9ibmVPMU8yRU9ESlY1ejZ6aEh3eUNKUmZJaHRNWGp5WmV1U2RL?=
 =?utf-8?B?S2ZzSnVuYzVSZFBHTGxoWENzVmVDd1BQdWIrRjAxYUg0dkdWTmVaR1BpSE5p?=
 =?utf-8?B?V2x4OFB4L2llNnJseC9UNmF6US9hSFBvbDhRTDBESnRScDBMUHpSR20yV1dk?=
 =?utf-8?B?dWlDcURLSE81K0FGaUtYbkdUL0FPUWZpME94djVkMVR4RS95eU9sR1JqNVpX?=
 =?utf-8?Q?FWHWGxOrCvE8TYavwwMRjjIK1?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b73baaa-af5e-4ce8-baae-08da64b0dac2
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 09:19:57.4656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZyFvZzwNx4CpfTdtb6VsaBnE4Vk5+fz5JJsjQ5r1T8WKHaubReph7QJsOd2OppTfJP4qYS1ESOcQFTMjBKChAw==
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

Check the retrieved grant reference first; there's no point trying to
have xennet_move_rx_slot() move invalid data (and further defer
recognition of the issue, likely making diagnosis yet more difficult).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
I question the log message claiming a bad ID (which is how I read its
wording): rx->id isn't involved in determining ref. I don't see what
else to usefully log, though, yet making the message just "Bad rx
response" also doesn't look very useful.

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1043,16 +1043,6 @@ static int xennet_get_responses(struct n
 	}
 
 	for (;;) {
-		if (unlikely(rx->status < 0 ||
-			     rx->offset + rx->status > XEN_PAGE_SIZE)) {
-			if (net_ratelimit())
-				dev_warn(dev, "rx->offset: %u, size: %d\n",
-					 rx->offset, rx->status);
-			xennet_move_rx_slot(queue, skb, ref);
-			err = -EINVAL;
-			goto next;
-		}
-
 		/*
 		 * This definitely indicates a bug, either in this driver or in
 		 * the backend driver. In future this should flag the bad
@@ -1065,6 +1055,16 @@ static int xennet_get_responses(struct n
 			err = -EINVAL;
 			goto next;
 		}
+
+		if (unlikely(rx->status < 0 ||
+			     rx->offset + rx->status > XEN_PAGE_SIZE)) {
+			if (net_ratelimit())
+				dev_warn(dev, "rx->offset: %u, size: %d\n",
+					 rx->offset, rx->status);
+			xennet_move_rx_slot(queue, skb, ref);
+			err = -EINVAL;
+			goto next;
+		}
 
 		if (!gnttab_end_foreign_access_ref(ref)) {
 			dev_alert(dev,

