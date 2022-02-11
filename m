Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AA74B2A41
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 17:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbiBKQ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 11:27:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244685AbiBKQ1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 11:27:30 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA5B3B0;
        Fri, 11 Feb 2022 08:27:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsBd9tEfyQ9RBevuljecYHaL60YkWDGRLS1d+/k5z64GPw8+gGadtmW7VrHboL274S4dFJw2lYOUfr8fzaO0cxI4BY0YPEYGpzc7sLd8MtsPTxgtw/Lvr+O4B8RpWbpyya6BsPPEWSL0ENmr1E8SA3juiUP/lmqfKdzki6jYEJEtFgZQRXl1vh0odl+nYBsgOnOT5Zsi6aB+vYqfRPkAn/rZjY13OJfX6lLezWS8soclA1KV9niP5PMgDpohLUyXqER6wxSdQP/LQNc4+sBEG3VNr/3F+RJFVM8n9gK7RfbV6hcHVt3O3ykB6wHej//reLPWVyTLeHO2YOfe1jbFsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E29EQU/4o7BCp/2H38+YLXVSDBSxcJY/BaocP9NI1vY=;
 b=Co0jUoKtuGKqIFc5zozwbRfmWKsaQxK0r4OS4a74ovzDoO1/bBDkJZrqfzId6YJGtrMTIUcI62dptaudsOlGqkFti/2J/r9vQbTJ1gYB+kZl+reipwO3EDQhWbm09bEFSCBNm4pLyg133ZbIXr/xGzFg2aznMb425x/RpwMzsAFCTPrdMXsG/CyQTtx/jGDjNZ1IHiLlzJ6KM+biKrnU6nweKnXWeNjEaXVwWFN0gTaaQoJRyGCDxpckAhrLOqxN348kQP7ZLvEAfNLurTFYZy3Rmfxc7Nc6jl4cpYMaiCMmGv/G4DfbLKn6ZyDyTRRAh/u449QWeQVDjlegecEQug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E29EQU/4o7BCp/2H38+YLXVSDBSxcJY/BaocP9NI1vY=;
 b=cl/KyfTlKD7lOnCin+E35cR36Mi69gdwWmCpMm5orBXLS85zgM9npqxxwJD+z4qBC23y2t4wZmjFrM1F84JyC5zcu1Zx0GApK4BN9j85lquVkd5IqARe6yfyZUPhrMc9P8cclusQHjSOl/1Wk5dv9AYx8Tff/LVyiL9z4SSJAeA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BN6PR1101MB2196.namprd11.prod.outlook.com (2603:10b6:405:52::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 16:27:27 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 16:27:26 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 1/2] staging: wfx: allow new PDS format
Date:   Fri, 11 Feb 2022 17:26:58 +0100
Message-Id: <20220211162659.528333-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211162659.528333-1-Jerome.Pouiller@silabs.com>
References: <20220211162659.528333-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1P264CA0011.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19e::16) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2740a1e2-0bde-400b-4f1a-08d9ed7b63ef
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2196:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2196D86AEC40329C76E5AE6C93309@BN6PR1101MB2196.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GT11tUA8llhitGfbWKgzWYOzQYrkWh3bvrjGTVHFoRdw2sIUq5f8Eo19N+I3X+je6NCEVoRf/8BybZlVcxTR+aN+UghvpTOCg+Mi07UrCjyFt/ZCYhp3bPam5r7tCNpqERZt3GvqWKl/qo2K1OMIiw/+Ok6euLrujg10qwJ9jdpOAHmUZ3Ffpx1NB17LvenkRz2kbt1iM6BWdhZ82Rbi/xhzWwsijdFAy7ZWaX6PRScOJd8mIVFpbgqTfbjMk4eHgfNM6urnXZoPJL5lckppUrxa45ZzHEb3Mw44KmaaYcW+/8SbZ/KPYYKCexGi4yqYEOd6OtdCvjGo01ihdTWjvEN7wAyXCeDRQ/PRb5/tW6JwKFh0tEKCIlzByWoB3CGQGIAaE4gJncRTVqAvPUMK0rSZUtHvkj+MdstwIx9FR56Io4sh93VLmBAre2k6owNIlhPKWkmrC391cUhW065zUf+Bd5IXZEq3c+ZrAtg/yb/B6WEoNt9OaTrG7MzucWYAAKVtfTqOXkpe2+spGxRXx6+r7PzVUQGK17TSOYkVjR8Jn0/OTtEjHhF9yGmrlXHKrpl2BuzYEi4D0E6dBMSCGlDckKeT00riQ7uaSzys9vluLIUqwdbcj7tl4h6PShy52+6N29Df1sH7VASFPXO9zbTN88Pfvy0YoGPxCo3RWc8Q65YilMu0Au/t3W6yUfwGUPgy/m58X24Ge2rlokf+7U8p9pGif/Oe9Hwy/HChug/gKUQITYRhWjwdqmU352+UCJ9BdELRw6RB8bRXu8oErdkO2V1bOIDus3ECskf1dDU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(86362001)(4326008)(36756003)(84970400001)(66476007)(83380400001)(508600001)(8936002)(66946007)(8676002)(66556008)(1076003)(2616005)(38100700002)(54906003)(38350700002)(966005)(6512007)(316002)(5660300002)(66574015)(52116002)(2906002)(6666004)(6506007)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K21kYWlUdGhjd0kvRFdWUWhMRXNLTjNrV3RFNjZwem1kT3lUVlMyV3VvaUpG?=
 =?utf-8?B?a25IaWpyazdSVDAwaWJKdWszRURDeVl3c2R5MGxNNC83ZHNidThZcWZmbCtm?=
 =?utf-8?B?QTNHQlZvazgrS3p6V21hMnBZVElPampCQzFFWEE2NTVpWEUwRWE1RldXQS9i?=
 =?utf-8?B?aWg4eTJVaHFaRHJ2QXdua1BxcUFlamN2M0VZK3RZVWhKNFJWRTQ2QlhHNE9C?=
 =?utf-8?B?TThiMUd3Z2JIQng4bk9jSWFaNEk3SFRZYXRTMDN3RWlFbXJjdFVhSnhBYlMv?=
 =?utf-8?B?NnQ4UW1hQ0luZ0Jlc1kxWUIwSG1YaER3dHc0OVRvVzA4dFZ4b0huTkFheDAz?=
 =?utf-8?B?Vm9ObUxScXFSK1lQYkxoWS9ieHlFelFVeGhNRUhMdG9RTTgwbWVNYjFSRGtS?=
 =?utf-8?B?NEFzbFl2S1hhRFpML3MzeHI0c2F0aDEzTmVHYS9jdUZ0VVI5MUF3WEM4VDE3?=
 =?utf-8?B?NnNkYXNyaXlhY1pKWDNlNlloZ3Z0SzBHbmVDWWdmV1hFL2VZb2h2eHFadTd6?=
 =?utf-8?B?V0ZyTzIyd2NXVUZHdmY2Y2NlZmV3RU1BUmtWSVA0dXlWdWNPdG5iMHV1QXpT?=
 =?utf-8?B?TTU1YkhMV21BRjZiN3p1ZDZrM2NVWDhlVU5sZ2x5djV1bUZaYTRIVnhBcGlE?=
 =?utf-8?B?Qkh4SWl2UXNLWTE2bGNiUDFZWFJDVUd5S0RrZmxiTVdiRVViSmVXN0t2bUtm?=
 =?utf-8?B?ZEJXc2czWGxOQm82aE1GTXNpbVpVQThTL3l1NVBXSUdLbU5DOU1NL045Qnc5?=
 =?utf-8?B?MUZ4L1lCaFZ4aXNLRXFONmI1SHhHSWpqL0tNWVQ4ejNNZmF2dTVVaEM5bDBX?=
 =?utf-8?B?a0pzSXNsbmRENTZzTGVoa3BCcHJQUEhWWWpIcDdaWXk0Ymp3cjdEY3FKc3RV?=
 =?utf-8?B?UzdBWWw4TVd0WnljWEFqQTE3S0YyN21zSkc5c1FnYWxjemdKdWxWTXBDYldy?=
 =?utf-8?B?RXJhUFpiR1d3RzlPMzBrcWt6MDZ4dzh5am5yTG1DZTJCcWhRWWVmTG5ZT0pl?=
 =?utf-8?B?RUNFUmE2Y29WUC9jQUthYjdKZjNobFg0cHNudVJWTkVXWEJzcmVheEhHVU5N?=
 =?utf-8?B?VTZPY3djci81ckw2ZTFFYlg3b0pTREJleGpZV3hzOFNCdVg5SldvV1NWOEIr?=
 =?utf-8?B?cHNrcnlpL0o5Q0FRcVR3c0kyb2pDcWJtbjRvU0pzS1FaTDl0NjFEQW9hbHVZ?=
 =?utf-8?B?VmlPSjFoaFRYWTJhbWhsKy9NMXp2Mjg4TFFuUlJRQVpyb1BMUnFkdUJyZTR5?=
 =?utf-8?B?a1ZXY0dWRWpsL25hUFJmU2ptWGk3Z2NDNU93a25kUUxReDNXRERqUGJmLzlN?=
 =?utf-8?B?TmZLRSt3QlBUblhPbDB3dEtsS3IwSHNQeVVVb3NxV2paRGFTUGtNb3JkTzlh?=
 =?utf-8?B?bTZSODRORWhLY3FjMkNocmpCZUhKWFZTSDNIaVBGZkJ1YnpyZWM2ZkJEZ2lP?=
 =?utf-8?B?aFlBd2NHU093OEJ1STI0TVhYYXNvOGozSi9ZVEJreFZaMzVkYmxpZjk1L0tT?=
 =?utf-8?B?ODBmN0FxNUdNMW5Nc2ZYdDVudWFtRUc4QVdNc1YyL0ZvdCsrOEVsS2lPUk54?=
 =?utf-8?B?akF5ZnlVaU0vZjU0Y3NZcEN6R0RHQ2ZDQ1E4bEZNc3l3R2c4anp3ejdqNW5Z?=
 =?utf-8?B?cFFOL05pcDg1R1RBa3F0aUF0OEVySHdrZ25YNVdYZ3AzNExkZW53cGd0QldY?=
 =?utf-8?B?QVg2WC8waXozdnNVVmJ4S2hKS2U4aWFCZVoveEU3TTBiQjFZNDNLQ01hcGJM?=
 =?utf-8?B?aXVJeGdHc2VHZkZWdUJrRHEyL3RQa1BGNjl4YUhyMkd5WEpmS0RzNStCbFJi?=
 =?utf-8?B?MHMwWGh0d1dEdFlibVBJeTlVaU9aMVFvUGdDTVo4ZzJ4NFI0VzBSSE1EZmox?=
 =?utf-8?B?UzFicmF4c3pYRjZESTN2Z2dKR1J0bHptVy96RDF5b3loK1JIMnhDdThKQjM3?=
 =?utf-8?B?TnNheXIyMWI2K1g5WU5VdWJ3eDlITEI2RzRzNjhBQmVnRXdWM2hFaVJncVlw?=
 =?utf-8?B?MnpYNnQwajkyNVQ2YmQ4NENoVkhQVmdRTXlFeWNVK01NdWgwZ09KdnkvYXY4?=
 =?utf-8?B?ZHhUUzlrRC9ZUVJSUnlqbWxBSkhiOWZyUDNURzhXZjNUMmwrcVdZUlRMWFgz?=
 =?utf-8?B?MnRhMWNqVkZIUzBEZHRtWEVxSHByeUV0by9XU2FWYUdYTEN1aWt1UGFDYUFv?=
 =?utf-8?Q?lYo5ktYIuOf7lsY0jjne6bk=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2740a1e2-0bde-400b-4f1a-08d9ed7b63ef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 16:27:26.5054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2MAxIBJXBtIefiyQ+DFxoyjDtuc6aUr36eqH9WOGmqtV68m6kIHLU7AmVzB3hJ/znt7armGUZ7KAerL9GKZaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2196
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBuZWVkcyBkYXRhIGFib3V0IHRoZSBhbnRlbm5hIGNvbmZpZ3VyYXRpb24uIFRoaXMg
aW5mb3JtYXRpb24KaW4gcHJvdmlkZWQgYnkgUERTIChQbGF0Zm9ybSBEYXRhIFNldCwgdGhpcyBp
cyB0aGUgd29yZGluZyB1c2VkIGluIFdGMjAwCmRvY3VtZW50YXRpb24pIGZpbGVzLgoKVW50aWwg
bm93LCB0aGUgZHJpdmVyIGhhZCB0byBwYXJzZSB0aGUgUERTIGZpbGUgYmVmb3JlIHRvIHNlbmQg
aXQuIFRoaXMKc29sdXRpb24gd2FzIG5vdCBhY2NlcHRhYmxlIGZvciB0aGUgdmFuaWxsYSBrZXJu
ZWwuIFdlIGhhdmUgc2xpZ2h0bHkKY2hhbmdlZCB0aGUgUERTIGZvcm1hdCBzbyBpdCBpcyBub3cg
YW4gYXJyYXkgb2YgVHlwZS1MZW5ndGgtVmFsdWUuCgpUaGlzIHBhdGNoIGFsbG93cyB0byBzdXBw
b3J0IG5ldyBmb3JtYXQgYW5kIGtlZXAgY29tcGF0aWJpbGl0eSB3aXRoCmxlZ2FjeSBmb3JtYXQu
Cgpwcm9iZTogYWxsb3cgbmV3IFBEUyBmb3JtYXQKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91
aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvbWFpbi5jIHwgNzQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCA1NyBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFp
bi5jCmluZGV4IDhiZTkxMDA4NDdhNy4uYTBmNWUwOWMzYzNmIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L21haW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwpAQCAt
MzMsNyArMzMsOCBAQAogI2luY2x1ZGUgImhpZl90eF9taWIuaCIKICNpbmNsdWRlICJoaWZfYXBp
X2NtZC5oIgogCi0jZGVmaW5lIFdGWF9QRFNfTUFYX1NJWkUgMTUwMAorI2RlZmluZSBXRlhfUERT
X1RMVl9UWVBFIDB4NDQ1MCAvLyAiUEQiIChQbGF0Zm9ybSBEYXRhKSBpbiBhc2NpaSBsaXR0bGUt
ZW5kaWFuCisjZGVmaW5lIFdGWF9QRFNfTUFYX0NIVU5LX1NJWkUgMTUwMAogCiBNT0RVTEVfREVT
Q1JJUFRJT04oIlNpbGljb24gTGFicyA4MDIuMTEgV2lyZWxlc3MgTEFOIGRyaXZlciBmb3IgV0Yy
MDAiKTsKIE1PRFVMRV9BVVRIT1IoIkrDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4iKTsKQEAgLTE2MiwyOSArMTYzLDE4IEBAIGJvb2wgd2Z4X2FwaV9vbGRlcl90
aGFuKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQgbWFqb3IsIGludCBtaW5vcikKIAlyZXR1cm4g
ZmFsc2U7CiB9CiAKLS8qIFRoZSBkZXZpY2UgbmVlZHMgZGF0YSBhYm91dCB0aGUgYW50ZW5uYSBj
b25maWd1cmF0aW9uLiBUaGlzIGluZm9ybWF0aW9uIGluIHByb3ZpZGVkIGJ5IFBEUwotICogKFBs
YXRmb3JtIERhdGEgU2V0LCB0aGlzIGlzIHRoZSB3b3JkaW5nIHVzZWQgaW4gV0YyMDAgZG9jdW1l
bnRhdGlvbikgZmlsZXMuIEZvciBoYXJkd2FyZQotICogaW50ZWdyYXRvcnMsIHRoZSBmdWxsIHBy
b2Nlc3MgdG8gY3JlYXRlIFBEUyBmaWxlcyBpcyBkZXNjcmliZWQgaGVyZToKLSAqICAgaHR0cHM6
Z2l0aHViLmNvbS9TaWxpY29uTGFicy93ZngtZmlybXdhcmUvYmxvYi9tYXN0ZXIvUERTL1JFQURN
RS5tZAotICoKLSAqIFNvIHRoaXMgZnVuY3Rpb24gYWltcyB0byBzZW5kIFBEUyB0byB0aGUgZGV2
aWNlLiBIb3dldmVyLCB0aGUgUERTIGZpbGUgaXMgb2Z0ZW4gYmlnZ2VyIHRoYW4gUngKLSAqIGJ1
ZmZlcnMgb2YgdGhlIGNoaXAsIHNvIGl0IGhhcyB0byBiZSBzZW50IGluIG11bHRpcGxlIHBhcnRz
LgorLyogSW4gbGVnYWN5IGZvcm1hdCwgdGhlIFBEUyBmaWxlIGlzIG9mdGVuIGJpZ2dlciB0aGFu
IFJ4IGJ1ZmZlcnMgb2YgdGhlIGNoaXAsIHNvIGl0IGhhcyB0byBiZSBzZW50CisgKiBpbiBtdWx0
aXBsZSBwYXJ0cy4KICAqCiAgKiBJbiBhZGQsIHRoZSBQRFMgZGF0YSBjYW5ub3QgYmUgc3BsaXQg
YW55d2hlcmUuIFRoZSBQRFMgZmlsZXMgY29udGFpbnMgdHJlZSBzdHJ1Y3R1cmVzLiBCcmFjZXMg
YXJlCiAgKiB1c2VkIHRvIGVudGVyL2xlYXZlIGEgbGV2ZWwgb2YgdGhlIHRyZWUgKGluIGEgSlNP
TiBmYXNoaW9uKS4gUERTIGZpbGVzIGNhbiBvbmx5IGJlZW4gc3BsaXQKICAqIGJldHdlZW4gcm9v
dCBub2Rlcy4KICAqLwotaW50IHdmeF9zZW5kX3BkcyhzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgdTgg
KmJ1Ziwgc2l6ZV90IGxlbikKK2ludCB3Znhfc2VuZF9wZHNfbGVnYWN5KHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2LCB1OCAqYnVmLCBzaXplX3QgbGVuKQogewogCWludCByZXQ7Ci0JaW50IHN0YXJ0LCBi
cmFjZV9sZXZlbCwgaTsKKwlpbnQgc3RhcnQgPSAwLCBicmFjZV9sZXZlbCA9IDAsIGk7CiAKLQlz
dGFydCA9IDA7Ci0JYnJhY2VfbGV2ZWwgPSAwOwotCWlmIChidWZbMF0gIT0gJ3snKSB7Ci0JCWRl
dl9lcnIod2Rldi0+ZGV2LCAidmFsaWQgUERTIHN0YXJ0IHdpdGggJ3snLiBEaWQgeW91IGZvcmdl
dCB0byBjb21wcmVzcyBpdD9cbiIpOwotCQlyZXR1cm4gLUVJTlZBTDsKLQl9CiAJZm9yIChpID0g
MTsgaSA8IGxlbiAtIDE7IGkrKykgewogCQlpZiAoYnVmW2ldID09ICd7JykKIAkJCWJyYWNlX2xl
dmVsKys7CkBAIC0xOTIsNyArMTgyLDcgQEAgaW50IHdmeF9zZW5kX3BkcyhzdHJ1Y3Qgd2Z4X2Rl
diAqd2RldiwgdTggKmJ1Ziwgc2l6ZV90IGxlbikKIAkJCWJyYWNlX2xldmVsLS07CiAJCWlmIChi
dWZbaV0gPT0gJ30nICYmICFicmFjZV9sZXZlbCkgewogCQkJaSsrOwotCQkJaWYgKGkgLSBzdGFy
dCArIDEgPiBXRlhfUERTX01BWF9TSVpFKQorCQkJaWYgKGkgLSBzdGFydCArIDEgPiBXRlhfUERT
X01BWF9DSFVOS19TSVpFKQogCQkJCXJldHVybiAtRUZCSUc7CiAJCQlidWZbc3RhcnRdID0gJ3sn
OwogCQkJYnVmW2ldID0gMDsKQEAgLTIyMiw2ICsyMTIsNTYgQEAgaW50IHdmeF9zZW5kX3Bkcyhz
dHJ1Y3Qgd2Z4X2RldiAqd2RldiwgdTggKmJ1Ziwgc2l6ZV90IGxlbikKIAlyZXR1cm4gMDsKIH0K
IAorLyogVGhlIGRldmljZSBuZWVkcyBkYXRhIGFib3V0IHRoZSBhbnRlbm5hIGNvbmZpZ3VyYXRp
b24uIFRoaXMgaW5mb3JtYXRpb24gaW4gcHJvdmlkZWQgYnkgUERTCisgKiAoUGxhdGZvcm0gRGF0
YSBTZXQsIHRoaXMgaXMgdGhlIHdvcmRpbmcgdXNlZCBpbiBXRjIwMCBkb2N1bWVudGF0aW9uKSBm
aWxlcy4gRm9yIGhhcmR3YXJlCisgKiBpbnRlZ3JhdG9ycywgdGhlIGZ1bGwgcHJvY2VzcyB0byBj
cmVhdGUgUERTIGZpbGVzIGlzIGRlc2NyaWJlZCBoZXJlOgorICogICBodHRwczovL2dpdGh1Yi5j
b20vU2lsaWNvbkxhYnMvd2Z4LWZpcm13YXJlL2Jsb2IvbWFzdGVyL1BEUy9SRUFETUUubWQKKyAq
CisgKiBUaGUgUERTIGZpbGUgaXMgYW4gYXJyYXkgb2YgVGltZS1MZW5ndGgtVmFsdWUgc3RydWN0
cy4KKyAqLworIGludCB3Znhfc2VuZF9wZHMoc3RydWN0IHdmeF9kZXYgKndkZXYsIHU4ICpidWYs
IHNpemVfdCBsZW4pCit7CisJaW50IHJldCwgY2h1bmtfdHlwZSwgY2h1bmtfbGVuLCBjaHVua19u
dW0gPSAwOworCisJaWYgKCpidWYgPT0gJ3snKQorCQlyZXR1cm4gd2Z4X3NlbmRfcGRzX2xlZ2Fj
eSh3ZGV2LCBidWYsIGxlbik7CisJd2hpbGUgKGxlbiA+IDApIHsKKwkJY2h1bmtfdHlwZSA9IGdl
dF91bmFsaWduZWRfbGUxNihidWYgKyAwKTsKKwkJY2h1bmtfbGVuID0gZ2V0X3VuYWxpZ25lZF9s
ZTE2KGJ1ZiArIDIpOworCQlpZiAoY2h1bmtfbGVuID4gbGVuKSB7CisJCQlkZXZfZXJyKHdkZXYt
PmRldiwgIlBEUzolZDogY29ycnVwdGVkIGZpbGVcbiIsIGNodW5rX251bSk7CisJCQlyZXR1cm4g
LUVJTlZBTDsKKwkJfQorCQlpZiAoY2h1bmtfdHlwZSAhPSBXRlhfUERTX1RMVl9UWVBFKSB7CisJ
CQlkZXZfaW5mbyh3ZGV2LT5kZXYsICJQRFM6JWQ6IHNraXAgdW5rbm93biBkYXRhXG4iLCBjaHVu
a19udW0pOworCQkJZ290byBuZXh0OworCQl9CisJCWlmIChjaHVua19sZW4gPiBXRlhfUERTX01B
WF9DSFVOS19TSVpFKQorCQkJZGV2X3dhcm4od2Rldi0+ZGV2LCAiUERTOiVkOiB1bmV4cGVjdGx5
IGxhcmdlIGNodW5rXG4iLCBjaHVua19udW0pOworCQlpZiAoYnVmWzRdICE9ICd7JyB8fCBidWZb
Y2h1bmtfbGVuIC0gMV0gIT0gJ30nKQorCQkJZGV2X3dhcm4od2Rldi0+ZGV2LCAiUERTOiVkOiB1
bmV4cGVjdGVkIGNvbnRlbnRcbiIsIGNodW5rX251bSk7CisKKwkJcmV0ID0gd2Z4X2hpZl9jb25m
aWd1cmF0aW9uKHdkZXYsIGJ1ZiArIDQsIGNodW5rX2xlbiAtIDQpOworCQlpZiAocmV0ID4gMCkg
eworCQkJZGV2X2Vycih3ZGV2LT5kZXYsICJQRFM6JWQ6IGludmFsaWQgZGF0YSAodW5zdXBwb3J0
ZWQgb3B0aW9ucz8pXG4iLCBjaHVua19udW0pOworCQkJcmV0dXJuIC1FSU5WQUw7CisJCX0KKwkJ
aWYgKHJldCA9PSAtRVRJTUVET1VUKSB7CisJCQlkZXZfZXJyKHdkZXYtPmRldiwgIlBEUzolZDog
Y2hpcCBkaWRuJ3QgcmVwbHkgKGNvcnJ1cHRlZCBmaWxlPylcbiIsIGNodW5rX251bSk7CisJCQly
ZXR1cm4gcmV0OworCQl9CisJCWlmIChyZXQpIHsKKwkJCWRldl9lcnIod2Rldi0+ZGV2LCAiUERT
OiVkOiBjaGlwIHJldHVybmVkIGFuIHVua25vd24gZXJyb3JcbiIsIGNodW5rX251bSk7CisJCQly
ZXR1cm4gLUVJTzsKKwkJfQorbmV4dDoKKwkJY2h1bmtfbnVtKys7CisJCWxlbiAtPSBjaHVua19s
ZW47CisJCWJ1ZiArPSBjaHVua19sZW47CisJfQorCXJldHVybiAwOworfQorCiBzdGF0aWMgaW50
IHdmeF9zZW5kX3BkYXRhX3BkcyhzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIHsKIAlpbnQgcmV0ID0g
MDsKLS0gCjIuMzQuMQoK
