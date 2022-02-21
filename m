Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E183A4BE70F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380747AbiBUQir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:38:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380740AbiBUQip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:38:45 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175F1220C6;
        Mon, 21 Feb 2022 08:38:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBGQ+tiflCy5H8QfuyyXtXVNNjs6F2c3nnsO58KBS6ymDghkIlk4u1oW2XMdZudqmzR9GZiIULl13YJnyIZ7gRG40M9I0WbBqY6afW+LoUNUTu/u3hzAG5GWn+cQO97vv0yiLdXRsHFYMgpLy6IU8t4cv+gSP1ZwbnGO6G0jQxj1Z9qj/Da8BUP/WDVbm1ojZKxs83cHwbVLUqPI4IUP9sZw84KYA83douU3r8mhApo4gUNlYvBwVqlfwzVTyvGj6dencustdYCxNt+wGUlNvWzIwKAggbJN0+BIZo9yoWSx4iy+Xyy1NJIKjKqcq2PqocNrR14e4lLH/DLMO/D64w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBmPpY9IxKHu0PFiIkYEMoCE4bwkaYh/IhwlQpYTBkA=;
 b=VtOXBx9egyQNQ1+FpMjfD4GzHcfyBtalnHNh2R8vwu6uuTO8WJRw3gPxBFGqy67AepobC/7MXyIuvqUaVkfV4dRZVzMQIZDqC/c3Ja7j+4X+rUUH2Sip0j97hbPvawfS+HMfGen1UQ8+h/wao1a2IQq/NQo1W61E3mTjR0HIbeyb8p+AwMehGfVOLa+mqCxyvx8j04Ow4JsykF0NYCFlyq0erVXZJXPyVtE+gjX7AwW3fo5GcEF73tX5k7mBvBypVGo1MOknoUj8qFbOuxgBwEUoQdp96zT3PzvJRbNFQ+6Gct1zUM7Gf20YjxDkRKuTeokY6/566ea1uVJcnaH5FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBmPpY9IxKHu0PFiIkYEMoCE4bwkaYh/IhwlQpYTBkA=;
 b=T7XAUgki+AEMbBFxr97gtYL70Qm7e3NCdZb+L74tPbuKP1LmFm1KlUCcAnO271U7BCFNuLj8wrv9vPCPUhipUU8FjvmSSR+CKvE/Pujv2H3WdrxK7tZQyW4zhqDl+fk++ddbiaHIlEJWrXWLuVuBmdGXqnTK/SHEzSWRgA44qQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 16:38:20 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 16:38:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-firmware@kernel.org
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jerome.pouiller@gmail.com,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 2/3] wfx: add antenna configuration files
Date:   Mon, 21 Feb 2022 17:37:53 +0100
Message-Id: <20220221163754.150011-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220221163754.150011-1-Jerome.Pouiller@silabs.com>
References: <20220221163754.150011-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0225.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::21) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4acaca6c-03e7-4209-c21d-08d9f558920a
X-MS-TrafficTypeDiagnostic: PH0PR11MB4790:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB4790BD659F3593339487D472933A9@PH0PR11MB4790.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /fK7rhtHAIzKTh4DVop4YhwDc7dSt1IVSz6EPevxUbudQMfEtlK7kEJkR5mvvcDvlYaoSYXQzKVKMTx8j3uppQeJtmNpC3Ju6SbPe/EZMzMvt3dTu5ftolx4arp24EVn3qU/BlLbXNylX+fWFbPL4wxgbmVeSkUhWjVx63MxAbYEHXkhIyiWqk6yNCuVH6AY65NaZGTHATS2QjR0En3PUM6Oz4TG5uu2liEci4lNdW0/zO7BBU0bzdOkyeK7+y6mNHMaK5C0RJrSFuXeqgLgnGZuPIsmPeiqgLG6B2DaIYdsVZCLAoxI/P2li+Z3A9VkJeguRXDh+YW/wuu9CkeU+sdKBp38ugcPAPKPH4EOpM3rR3JHC31GkIz5QLJK5WoiQvAoqwpkKQYiqFaC+YbKD8qa/ZENlWoTdyUdMmwH1pQouGDIVi36E837BYL4CCdbuMisMEVpZ7DYa4MdUSi5akq1ud397A+xxRKC69X/clvYAa4gperVWsuOiaXIuy5IM05gpzoMr5oETyJZHnX8VYRcXhaMSZSCshuuzBi5+ZjQCPWUBLDNjK3TiGwv59nJ4I7OYPhGP9r+65utKCUAOiY3XvkmIXkFAijbWCWTruwrbOzUjh+daWJcOBMnJ4kEI6/j4pFA+1GhZAlLGesOw/IcIrMw12HtDh6WulxPsV1rTugPsYahH0mD6/dqMihdVzdfwAZSa/eCo7GyafsiFRDgc3eOKQRl7O8s90+vueEeSf2WbPYzP5HU1sQg5L3KohQqTPiN5nkJKGsmVL5e/DRCTs6FXmgkcEYzDpCOoXSqjnaGg1bUwk2+hFPTfzfC/UyVw5zq3d812xpijRq5gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(83380400001)(38100700002)(38350700002)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(2906002)(6506007)(52116002)(966005)(66574015)(508600001)(5660300002)(6486002)(26005)(316002)(1076003)(107886003)(186003)(54906003)(2616005)(6512007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnpManMvaW5waitjL0V5azc5bkFvUVo2THpaaGFsNGRxc1JrVTFXU25JNXg1?=
 =?utf-8?B?SE1rY2tRNG93QUtFaVMyNU1qMnhWc3A0Mi9rQzEyQU82UHVKN0ZiQVNONU9k?=
 =?utf-8?B?K0g4WnNDYUhWZ1c3UkVOUzdlRi9sbVh6NTI5UmF1NWl3elhvOWsyMktNRGhP?=
 =?utf-8?B?U1NtazdUMStUSUVzYnd3MEpmaFcrdWw1SFlQK2RuZFZOdnQwak9PalJySkMy?=
 =?utf-8?B?WXl5VFB4c3BBci9YNVRNdmtubEQ5QUZQZXNqQmVUUGVlbkFxRzVsc2lpUmhx?=
 =?utf-8?B?QWlyeFlzR3lTbStIM25xZUpIM2R2d2dMTWdXZVdZaW1vd0M0YmtpUHVUWUI2?=
 =?utf-8?B?Y1l6WURlVkJUYXVTWTUyb0JDdTg1MElXbnFaVHV6WGZuUEpuQmdpVkdNOGR5?=
 =?utf-8?B?SVJtRWw0L29WYmMzeVVmYWN2eTBtTG41OW1ObTV5eDZYMkE2cmI4UUEzaTVm?=
 =?utf-8?B?ZjZTQy82UnNhQjh6bGVOeVFMMjFDZXp2ekdlYUxkRFZoRzc4a0xIUnNWd0dB?=
 =?utf-8?B?SXF5em1oYndjZHE4NWVjUVNGcW92V29RN21XcTBnQUFVSWgvVXgzYXA2Q1JO?=
 =?utf-8?B?RUdCckp1SnRscVkzUzlTU1ovTnJkLzIyTmY0eTNvZmZjdSs4VmxXVW43OCty?=
 =?utf-8?B?RDQ0N3VNZU96MDhVbENKSWR3bnUrTGFZQnlhNVArMG9RaHFSMG9QTEtOeXdK?=
 =?utf-8?B?NDFJRVEyRkd4S0JrbHZIYUJXWEZaOGV6S3pGdmhHRXF5c2UzOWlwckVQR05z?=
 =?utf-8?B?N0ZDTndCK09MYzc5blppeXNpUElTMGwweHd3THBIY0VmOHExU285SWZnYVpr?=
 =?utf-8?B?QXJSWTN3VjhWalkrK3ZVM0Nkam1HcHVMVmo0VHYyOUhlMnJsd28rOWtGeVU1?=
 =?utf-8?B?LzN1S1ZBOUR2MTdmUE5WdFBCNXZtcEd5ZmVWSEZxZzBsVVZDcUhYaFZobEJH?=
 =?utf-8?B?Qk5XM245N2ZCQndQQ3NZdCs4YmpCQVJHVGpUcUtkNlRmL2Q2VEEzODVIeCto?=
 =?utf-8?B?enFLTUNqRC9LQTAyOGNHWlpuaU9ha0VqYVI4dEo1NnhqUGVDTGpUWStvNHpv?=
 =?utf-8?B?akY1anBBODNEZGhqYlVjeGx0OGkvOGRFTXFaMGs3dVNXT3BIMUkxc3lvYmVN?=
 =?utf-8?B?d2liaTVPU01KdTBiWUZTblB6d1ZVak1MK0wyc0lzTWxUcXpaWXltSTFUNXFI?=
 =?utf-8?B?Q25ScUtPZzQ0bU9wQ2xxUk9xbU1VQnlWam5mUkN3QUp2WUJzeFQxY2M5Y3pU?=
 =?utf-8?B?emxwb1Z3b2EwTzd4dnFmMkFCTmdUWWZ4bDVMZDIvZWZKK2lQN0ZDUnFSTkIy?=
 =?utf-8?B?aTc4L244a1RzbE9zSGp6VUJ4Y1FNS2U1YVViQ25KZ2xtcWdCQ1NxalZ1dmRY?=
 =?utf-8?B?Q2EzbGNyRWFKZTF1UE95alNZVlFBNVdudkMwR1d4QmtsUUYwQjZHS3BHanBQ?=
 =?utf-8?B?NGJJU3EweEd5ZTBjVnVZTWV0N2RHcmlUTWhaZnJ5V1d2dVNKSFBoZml5WGk3?=
 =?utf-8?B?cmFXVXVEV08xeDd0NjdUNklLZWh5U1pMRU5mTmFFTGtLQUJsVWY4bzVPdGNp?=
 =?utf-8?B?aVRSam4vdUdLY1ZKbEI4VTNnU1gvZmtrVEp4ajBhdFBQWXJKVmZSMGVSR05k?=
 =?utf-8?B?bE4wWEd6cnVSM0hzWGtEekI0cnZ4YkFCRmJhZXZKcjdSamtzOVpFd1grMHVG?=
 =?utf-8?B?Zm5Fb05SZVJDbWxWUHdtcXM0YWhqQUZ0STdvVWQ0MHBzbHhYblRaVnFNV2Z3?=
 =?utf-8?B?V0JBb3VrNGNReEk2QWRUaFM3YXZ0S3RRRVNRNnlISyt2VTdxZUl0V1VVNmxG?=
 =?utf-8?B?bUNwL0U5ZWMyZjZoUG9iUzRLRjI1NlpoQzB0YnBrNVBXb0hXY1hFRkhDQTRr?=
 =?utf-8?B?UzZiOUZyS2pPbkpBU29FcTZuekJaZnBwMlNGWUN4YjZJSWpjZTUvSWpzY1Ra?=
 =?utf-8?B?K1hpbGF3K2U4emMzSWs5UTlaN2ZRcG91K3lqU0NkZmNsMGRmaDNsaERTUWQ3?=
 =?utf-8?B?VDhDV00vaGxmcnVkY3pxZVpjMlhraE5JdXMrZDZobVFIYmFCMmR2SzFXbnlO?=
 =?utf-8?B?Zk1SVWFyYnRUUjM2RDZTbGVFMDgrSlJZSFZBVU9zSEpHOEdPZU5MMVA5NGpY?=
 =?utf-8?B?ZU1zZXhUeC96MlpOM3FXUVRZbnFDTGpXTXF5OWZwZ09qemtNaDIwQnkvTW1S?=
 =?utf-8?Q?aazBC2rtYSon4sENo4kUAYg=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4acaca6c-03e7-4209-c21d-08d9f558920a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 16:38:20.6991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuLUEr+0JCiia7Wajsqfm2Yg6F8Z1B7jSYNWCGy/R8PPKVRyr855zOoN1xcBSHAIFe4WT01R3mpLE4rLlflF0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHdmeCBkcml2ZXIgaXMgbm93IGFibGUgbG9hZCB0aGUgYW50ZW5uYSBwYXJhbWV0ZXJzIChha2Eg
UERTIGZpbGUpCmNvcnJlc3BvbmRpbmcgdG8gdGhlIGJvYXJkIGRlY2xhcmVkIGluIHRoZSBkZXZp
Y2UgdHJlZS4KClNvLCBhZGQgdGhlc2UgZmlsZXMgdG8gbGludXgtZmlybXdhcmUuCgpTaWduZWQt
b2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0t
LQogV0hFTkNFICAgICAgICAgICB8ICAxMiArKysrKysrKysrKy0KIHdmeC9icmQ0MDAxYS5wZHMg
fCBCaW4gMCAtPiA2MjUgYnl0ZXMKIHdmeC9icmQ4MDIyYS5wZHMgfCBCaW4gMCAtPiA1ODQgYnl0
ZXMKIHdmeC9icmQ4MDIzYS5wZHMgfCBCaW4gMCAtPiA2MjUgYnl0ZXMKIDQgZmlsZXMgY2hhbmdl
ZCwgMTEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IHdm
eC9icmQ0MDAxYS5wZHMKIGNyZWF0ZSBtb2RlIDEwMDY0NCB3ZngvYnJkODAyMmEucGRzCiBjcmVh
dGUgbW9kZSAxMDA2NDQgd2Z4L2JyZDgwMjNhLnBkcwoKZGlmZiAtLWdpdCBhL1dIRU5DRSBiL1dI
RU5DRQppbmRleCAwYTZjYjE1Li45NmY2N2Y3IDEwMDY0NAotLS0gYS9XSEVOQ0UKKysrIGIvV0hF
TkNFCkBAIC01ODQ1LDggKzU4NDUsMTggQEAgRHJpdmVyOiB3ZnggLSBTaWxpY29uIExhYnMgV2kt
RmkgVHJhbnNjZWl2ZXIKIEZpbGU6IHdmeC93Zm1fd2YyMDBfQzAuc2VjCiBWZXJzaW9uOiAzLjEy
LjEKIAorRmlsZTogd2Z4L2JyZDQwMDFhLnBkcyBub3QgbGlzdGVkIGluIFdIRU5DRQorRmlsZTog
d2Z4L2JyZDgwMjJhLnBkcyBub3QgbGlzdGVkIGluIFdIRU5DRQorRmlsZTogd2Z4L2JyZDgwMjNh
LnBkcyBub3QgbGlzdGVkIGluIFdIRU5DRQorCiBMaWNlbmNlOiBSZWRpc3RyaWJ1dGFibGUuIFNl
ZSB3ZngvTElDRU5DRS53ZjIwMCBmb3IgZGV0YWlscy4KLU9yaWdpbmF0ZXMgZnJvbSBodHRwczov
L2dpdGh1Yi5jb20vU2lsaWNvbkxhYnMvd2Z4LWZpcm13YXJlCisKK1RoZSBmaXJtd2FyZSBpdHNl
bGYgb3JpZ2luYXRlcyBmcm9tIGh0dHBzOi8vZ2l0aHViLmNvbS9TaWxpY29uTGFicy93ZngtZmly
bXdhcmUKKworVGhlICoucGRzIGZpbGVzIGNvbWUgZnJvbSBodHRwczovL2dpdGh1Yi5jb20vU2ls
aWNvbkxhYnMvd2Z4LXBkcworCitUaGV5IGhhdmUgYmVlbiBwcm9jZXNzZWQgd2l0aCB0aGUgdG9v
bCAicGRzX2NvbXByZXNzIiBhdmFpbGFibGUgb24KK2h0dHBzOi8vZ2l0aHViLmNvbS9TaWxpY29u
TGFicy93ZngtbGludXgtdG9vbHMKIAogLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIApkaWZmIC0tZ2l0IGEv
d2Z4L2JyZDQwMDFhLnBkcyBiL3dmeC9icmQ0MDAxYS5wZHMKbmV3IGZpbGUgbW9kZSAxMDA2NDQK
aW5kZXggMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMC4uOTc2NWQxMzJj
MjhiZGQxYzNjNzhjZGQ2YTg3NmEwNDgxOGEzZTI1ZgpHSVQgYmluYXJ5IHBhdGNoCmxpdGVyYWwg
NjI1CnpjbVp3RU5lK1RRNUN1Pj9nNz5IZUlGUShoM25waDFfSmpvPiZZcG4keUxtSyFIXmhaamZE
aihsbTlGMTtJYCtFQwp6QFNhSSswdzdQTFFDQ3xTJSRMVWFhXmxtUDJyTj1PMjgkRj16PWV2WlVe
QiV0JFhXOWg8ZjhjK2FAQmtUeG9OKEkKeislP31wOS04a1YmdERJP14ja09rYDRLazJyUHNNTT8w
YGRIO1NmLTAheUgxUHhlKWt2THgqbExrQXFxPj94c0pFCnp4N1RzVG1RYjB3Jjswd3RYaVVOVzBs
eTFoekU9c01QRTsrWHZNQUwqaypjdyhNSXghKkNIdCF7WjVrWk5XJHZ+UApGZDt0MFV0ajdRVgoK
bGl0ZXJhbCAwCkhjbVY/ZDAwMDAxCgpkaWZmIC0tZ2l0IGEvd2Z4L2JyZDgwMjJhLnBkcyBiL3dm
eC9icmQ4MDIyYS5wZHMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwMDAw
MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMC4uNzM3Mjg2ZjMyMzYxNWMxZDA3ZWMxYTk3MmZjOTc5
MDhhMjFmYjZiZgpHSVQgYmluYXJ5IHBhdGNoCmxpdGVyYWwgNTg0CnpjbVp2WklTI0B3NUpnUmtN
OE8kb3J3OVpoVlRsNWd1cF8wOVFuMnFRdT5SZFI4czg/T2ZLamEyY3s1fHB5Y0FpPgp6eFVKPnQx
NFkoc3hTZSUtemFseDxVTWZlTWYrd0ZLSkhrJk9CRzE1PSFnSSg7PDVTMzQ8MUAlYjw4I1BXO3xz
YDUKejw0ZWUwPDE1SkhtdmBDdjh1SFptMkh3UVRjbiE0flBSP1RqUFZhWHdwX1cxeEJ5Yk55QyF4
NHdUJWImalMpMWduCnpOYSY+Jj08azBTJEVsQXJ5MHdFU0w9SGkzJClZYTUlU2dVWTF0SU9KdzJX
bX5zZ2JjdENuX3lkJEBFK0R6eD5NZwpNLSE/QSVoMHI/aTIxdnhBe3J+Xn4KCmxpdGVyYWwgMApI
Y21WP2QwMDAwMQoKZGlmZiAtLWdpdCBhL3dmeC9icmQ4MDIzYS5wZHMgYi93ZngvYnJkODAyM2Eu
cGRzCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAw
MDAwMDAwMDAwMDAwMDAuLjk3NjVkMTMyYzI4YmRkMWMzYzc4Y2RkNmE4NzZhMDQ4MThhM2UyNWYK
R0lUIGJpbmFyeSBwYXRjaApsaXRlcmFsIDYyNQp6Y21ad0VOZStUUTVDdT4/Zzc+SGVJRlEoaDNu
cGgxX0pqbz4mWXBuJHlMbUshSF5oWmpmRGoobG05RjE7SWArRUMKekBTYUkrMHc3UExRQ0N8UyUk
TFVhYV5sbVAyck49TzI4JEY9ej1ldlpVXkIldCRYVzloPGY4YythQEJrVHhvTihJCnorJT99cDkt
OGtWJnREST9eI2tPa2A0S2syclBzTU0/MGBkSDtTZi0wIXlIMVB4ZSlrdkx4KmxMa0FxcT4/eHNK
RQp6eDdUc1RtUWIwdyY7MHd0WGlVTlcwbHkxaHpFPXNNUEU7K1h2TUFMKmsqY3coTUl4ISpDSHQh
e1o1a1pOVyR2flAKRmQ7dDBVdGo3UVYKCmxpdGVyYWwgMApIY21WP2QwMDAwMQoKLS0gCjIuMzQu
MQoK
