Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D239B40F254
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 08:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhIQG2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 02:28:39 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:31572 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233157AbhIQG2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 02:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1631860035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HWKHW7ZoiNVaIy0mfo3LS1NtMKPljl8Txy7BqM8aytQ=;
        b=IMMEwipMnSpV5qPVcVNpI56p6qKegI16gbBPl5XOBItKJmHNJxKZ+hr4QR9GV9u5BwphqX
        enUCNypDP8eqWDghfdS4cmWDTgmXxlTrswj9sy0lJFa7+Fb1Pwn4BZGOiQvi5JJIbc5Gla
        71wUOzLu30v4wTFPhyD/kBaJ6Cn9H60=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2054.outbound.protection.outlook.com [104.47.0.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-s9X0kTPrPVa5rO-rDPYSaw-1; Fri, 17 Sep 2021 08:27:14 +0200
X-MC-Unique: s9X0kTPrPVa5rO-rDPYSaw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q25i2ebGgB79+F5oGE336FliMymy9jndvpF6sCPFMpktHzv9fCJBD6V6/RDhbTOb/8v+/+UTwoWnDgX2PGmf6EWUU/Vewo44f+sVf0543zaZlqQ7Zy0Iv0S5r10aSgjfyShMbf6JidR3YQOMwF2IR3TVP8XebuZNgXLFMKxBGR5Fv9oHff0rrmu2THRs8k0sTQlbtzhclbn8CBQsEHkGKzLJjTYQQipsJwzYUJ1TMYT0hWkk9LDatGGg8M7tvQ5L0FzlBBjXfSUzWg87jy4fduWxsWH5bPXCfC3QFRHwCToW8MUCPm2X3d3BN3dxi01MwPnbC/0hEElEeQHtcUhxOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HWKHW7ZoiNVaIy0mfo3LS1NtMKPljl8Txy7BqM8aytQ=;
 b=iFP8GZQRiNLvgYFHFfd/cZRlx8c/xh71RocLtmSEFJu2Abx7keyP9LNBpMsYGYff/5D1h35pA01hG8x7RnsBhpCEOhxxFQ68z0RTE4qJfJgCvCJ0HLFQH2UR0JnMmAObOC8q8+1dR0qSzW6ZD6IsxzreDn1OWuSIhxZ+LLvcVCb5B2pgKkWZxMMACkRNvvtoX2bgHV9n/rPPg7PvRtP16pu07bOv6xyq+brhLPgpZG/2HLsKs1MFyJ6/abf289bCZHTUWwBeOijnQ30I/rANzj+x8/fN5U449y2yRGjJyMTeLPP/p4fhnjeMthEK+d98gpfTmn8etW2orxZyrraV4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: lists.xenproject.org; dkim=none (message not signed)
 header.d=none;lists.xenproject.org; dmarc=none action=none
 header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB5904.eurprd04.prod.outlook.com (2603:10a6:803:e6::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 06:27:12 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b%7]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 06:27:12 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Paul Durrant <paul@xen.org>, Wei Liu <wl@xen.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
From:   Jan Beulich <jbeulich@suse.com>
Subject: [PATCH net][RESEND] xen-netback: correct success/error reporting for
 the SKB-with-fraglist case
Message-ID: <ef9e1ab6-17b9-c2d7-ef6c-99ef6726a765@suse.com>
Date:   Fri, 17 Sep 2021 08:27:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0108.eurprd02.prod.outlook.com
 (2603:10a6:208:154::49) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by AM0PR02CA0108.eurprd02.prod.outlook.com (2603:10a6:208:154::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 06:27:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b47cc365-0393-44f9-1ca5-08d979a42f49
X-MS-TrafficTypeDiagnostic: VI1PR04MB5904:
X-Microsoft-Antispam-PRVS: <VI1PR04MB59041FE61A77E0DA91B850D4B3DD9@VI1PR04MB5904.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rZLycOOX7gljECy/boTmyNvbOBUQfqn0Jjmn8YQ50XeNytYYLyVDdJLwkWzdonrZ650Jp+BjDknK/Ui8GZtgIY6xMP5FPMiw/l3iVlq8yh9ZRI4K/6akHdFxrK+4P0WKnienl0MHtuUbXQjpHVf1lUBxOL9DYKUhFN8q+B1kqDKwu3ERrx5KtXzK/dlJCuzFVS/QYglp9TxVvnglX6nAXHHui+rax1LpXhT9hMepTSZgijQa5OpN///GAHZQKiBpjM+af3wbTu4BZYKazBEH2OB3AHE3vwFfsoznuwWJ0HBZarRCRyA/Wm2/Ipozx4IYxUD8zfa6RdKDnatAUoWEfP42C/KTsZ896jM4Jnw+/4xqQNgo9Hc78VU08I8QyFaEJZUGJ8QVUuikYyb8JO13fmIQgF8KvPxKgR658WAW+emP4xiYpfwOcfW91GWlYipLy7IPUXvluVguAM0DArrhx/WeXA9GJebUtWReVWsblQW0B949Vgw/Rs58Tbc/ELo2hYaB4xT2Q0d072ccNlOigrTrUgtqoXZyX+rMuSry9Jn2c7/Ktz7pME80pkTI198jX5NwI7HHayfh5TkpouLbE+A1gFlltkEWdl+o1MF1vR3LhJoeed2dlEYnM68ZiVNpxwysOMcvGT6XfLDNp/2tI6jtk7JeROkshUXJ+/axz91zcf1FqHtUNjY3Cv8C2jnTHdb1sVUhjFoAS2elx/jvVcyQPjpFDBbVpCvLVZsJkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(4326008)(8936002)(66556008)(38100700002)(956004)(4744005)(2616005)(6916009)(66946007)(54906003)(508600001)(186003)(6486002)(16576012)(8676002)(31696002)(31686004)(316002)(36756003)(5660300002)(26005)(86362001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkdhWmVFTTRNUUZZWmxiVUxyazBBMWcyUURsTTBoQ293Nk0xa3lCOEdKeHlH?=
 =?utf-8?B?OThJQm5oc1kvRmVreEZVWC9JNXVvNlUyRVEvd2tER083ZVFrSTZoZzlZeUc2?=
 =?utf-8?B?TjNTc2FYTFlTK3JPR2kzMU9rcjRrdXVsWXFZb1BFUFIzRFRGMldWQXpZclRM?=
 =?utf-8?B?bkIwd3ZNWTF6S0ZOOWQwZ1puMUZYcWJaM1M2bTVLVHBrRXdqcW55Qnd1K2Vv?=
 =?utf-8?B?OGNRaFh6ZUwzMk9POTRXSzhjVnJFU3B5WXU5OGxrdHZCZGFXYlVMa29wc3ZM?=
 =?utf-8?B?Nk1DL0k4WTVWSWRrT0Q0N2pESWNoWXNveWdMUkgvYnNweHNWckNJRFRuMndX?=
 =?utf-8?B?dzM3QlV4aDFqa1BpYkFXeWI0Y3RwaDllWXFiMlU2U0FOK0FETWk2UTdsVGFx?=
 =?utf-8?B?V2VBNUNUaW04dWhqMTZoSmtaaDZ0OWRJaWRnbURzQzhwZTZVR1NyN3YxZktB?=
 =?utf-8?B?UjRXdWpYNDBiRzlyLzBWY1REeit2QzNLVDBpeVJoK0lMZGlmZEtrVE5QYXFR?=
 =?utf-8?B?VDU3bFRDS2o2ZmhjclhoeXhtVUtSSURFT1BYMk54dXRYOE9KdWxnVEdwN1Ni?=
 =?utf-8?B?KzhTR3kyTythVjNqaTlrZ2h0SnJBL2xRVWlJamRLNEJuYkdNc2xPMnhOc3Mr?=
 =?utf-8?B?cVdKZERhM1R5SkYveVZRdnQ0MUd3WDg1cktHTlpqZDdHM0o2b0s3anh4dGtp?=
 =?utf-8?B?aWFIall0TTdZWFZ2SFhIaEIzRUpUZ0dYOTFRbU02bWhLcjc3TUFVRXRHWko0?=
 =?utf-8?B?M2VXVjNZZ0JtU05EYjBWbC9abjhWUWlrbjhJSk16Y05VNEtRUURldm9aenhU?=
 =?utf-8?B?NEpUOEhTeHAzVUx4Qm5OTGhKNktVVUpNMmVpK3pabFV1amk1d2JRS3FPMWds?=
 =?utf-8?B?a3Vza2IyblNZVEFUQkl3ZWxJby92SThQMVQwYW52R0JsWndCWUs2d2RndlF2?=
 =?utf-8?B?TDVIRzVEdnpZL3hkMnNRTjJkUGZ3aEtpRWNZTU9JMnJyQ3BXcVdrOWZBU2Jq?=
 =?utf-8?B?WjRaZUFzaUh5WHFYaUtVMHVERm56bTZsdHBhOEc5eXVEMmR3ckw3bEFuSHZi?=
 =?utf-8?B?SG5kcVZKdGdTTTFobTNadE52Qk1wMUxvdEVyQnBNOTVucTBKUmVETlZoMHFs?=
 =?utf-8?B?MStlajFlc1RiWlRpa1IzVmFmd0d4MlJGQ2kwSk9iWFFBaEc0SzRnbE1IR1RM?=
 =?utf-8?B?ZkdwRmdqaWFTZTRDYjl4bFJyd05pR2g5OUNLMzZIMHRad3JCaUVuQmlva3RF?=
 =?utf-8?B?YWR1cXdQZzErbkkxQmRZQS92Z2haM2tmb2xzK0JrbzJlM3E1Y0d1QU44K012?=
 =?utf-8?B?eVcwejNmcE95a05nWE1hSW5xcHRzS3FkQmhKTFhKYkc2UVVSaUtldFJ1NitQ?=
 =?utf-8?B?bUs4WkhIdFJzY3AwRmxXVWgwNzlXdFJyMTBYeHg1V3Ixd2xwR1hScVp1eVdT?=
 =?utf-8?B?WmhjL0JlRWNMUXp2RnN6MVNiejRMc2pwVnlnWFRsSzhEMEtRcUovM21nVWUz?=
 =?utf-8?B?aFFveWtwT1VDUHFPMEFkSU1lUytuYklPL2t1R1lMbElrMHBkaENFUnk0a3JY?=
 =?utf-8?B?Nk1EY2xadHNObGdvdHVRYjlCK2ZvcEg1TmpwUFNxTWZ3T2FIOUNIb1JpZUlH?=
 =?utf-8?B?WUdCSDBKUTZZK1BVWVB1RUxNeHMrdG95dDBmTTN2SnlodzlEeVgzMmN3WHdH?=
 =?utf-8?B?UnZmSkNlSko1Y095S2RhbkRJSG9EVUIrQ0FuZk9NWHNBWmQzVy9ZYW1HRU0v?=
 =?utf-8?Q?TiFPAtX2OQLpS5QyEpdzeuUWnrWhI+HbqySlpkO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b47cc365-0393-44f9-1ca5-08d979a42f49
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 06:27:12.6642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2TG1/VZESJloobIdrSjVMOIwvM8w5GQv39oMIE/jTFYNbdmyGELDJ1l0J6iPzWm1cnRyOXZUNi/WJ9L8zsfl0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5904
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
special considerations for the head of the SKB no longer apply. Don't
mistakenly report ERROR to the frontend for the first entry in the list,
even if - from all I can tell - this shouldn't matter much as the overall
transmit will need to be considered failed anyway.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -499,7 +499,7 @@ check_frags:
 				 * the header's copy failed, and they are
 				 * sharing a slot, send an error
 				 */
-				if (i == 0 && sharedslot)
+				if (i == 0 && !first_shinfo && sharedslot)
 					xenvif_idx_release(queue, pending_idx,
 							   XEN_NETIF_RSP_ERROR);
 				else

