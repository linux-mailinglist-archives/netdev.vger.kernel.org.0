Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7176D4C4382
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240181AbiBYLZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbiBYLZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:25:50 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6941DBABF;
        Fri, 25 Feb 2022 03:25:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRTnrrcSeNt5FM6FFBn4Lg82qHMGgi6QliKgMEItQm9uUkW7eTyJ7lvsx252k6sqP9ssl8ARODbJCfgJN4sYz2yjbneRDoShoDSuZAx1NahI0RT9yB0JpNIAn5VggAzkbmX0IHpwuIf75r7bdp1bVyfiebqG+Fgq3q72ExBXUz+35dA7KxG57f1rql8d8R5ycTECrkqlnq0nB5k2PSBCugk3f8G00cKQHLnC6FMVEkOSwAnKFrfiLVvwDQguiyunuWlneC39Dls5BlFIA1iBEEQRluGIN316TuUyQr69ksxk8Qfd5cAJNCkJx/8SHHy4RroCLx83Ftj8PhchkJN8Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpPXMkuokgI2KorYtPu/iTSAZ4jYtlCWIdBT4Wkdngg=;
 b=haXmBqont2YqY+cdJnzJO1cOUtJe6ktuvuhN7E+0wyEqMrpQiVus7XqT+jG4hdfSgrub//JPWxBt4ZVcSAY+4HT/NLge/VG+q5u5btXN+9Zgrn2C6iLRWkn7JKVKeBSgjcbS2V/zw8kfJwmWss8AZi/p1Uc7iXpL43mMzq0KcHkAQX6rWVDFHM1w4Y2jiwyWN9TIDtJpP0zRf/2fn/4T7czI5LEJBUj/YWI7cRwRzBfYiGBBJQ8fasNAsB2SKqWAMZ7OTxYZPWKf7FlLBCIz93q5PoyE+O5EsOE0zmEL0US4x5iEcDHbv4m03mObDXNqn3rZMafyf4ZcctSKmcdVQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpPXMkuokgI2KorYtPu/iTSAZ4jYtlCWIdBT4Wkdngg=;
 b=Ax4PwFrBBx0PZmqPEVl6s0JDluD/aA0yXkyxJBrCnaXibF3j+V5G4JKEDeZcStim6jBvYBDQIM2tCq77tmZb0BCD+UuYGen1P1NOdosx2yW9PjQhsvySK4BE6tS6jJLGDrnQp6LieHXv2oqorbXpmvUqyVZStonSlrPg1OXNYb8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by DM6PR11MB4362.namprd11.prod.outlook.com (2603:10b6:5:1dd::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 11:24:44 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66%5]) with mapi id 15.20.5017.023; Fri, 25 Feb 2022
 11:24:44 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 05/10] staging: wfx: remove useless variable
Date:   Fri, 25 Feb 2022 12:24:00 +0100
Message-Id: <20220225112405.355599-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
References: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0052.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::27) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd10e88c-e59a-412c-96de-08d9f8516c2b
X-MS-TrafficTypeDiagnostic: DM6PR11MB4362:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4362B1F7B1E6868BC1D0CBF8933E9@DM6PR11MB4362.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uhJCkmG2WAZXip4qdoljjfXR9oQUc+LXApBWG2yhDS5XFNuIiaclsTmEf3L+zvH7UzCgsSdEDExyrFB4Dz1upXgrlJfzLsvgOcskjB6uqw0mqaFCp07w5YOEgCVpjzKsSEGYgWhmxl9jNxSW/l7R5Aos7F6B7arql60ohIGmBSwpu8m67wwyo+7+x8XKg4f5gQbWExIIWdoFHOZbHSLdTfc8TJYcSApmblI1cGGQRqVybNFtvahVPaJQ+umFR7T3KdQ7qXsm9MgZWFOzIKSNK/JvaxREYMZrflT8riJQA6e0vabWSKdlEsD2/DULqvxNjXXxSI9ESzKugGLWODvMtjy7sTBs1A6NWp5OOuOnZ6HbNOC8WLGa4co729BCi7nYUMFsl5WdOx8LKyRc38VCwtvK/vFnlDKnqd4R7SAFkCgVJJODLkSRPNRiwvpmrGsj48vxg/KoOuXuYw+QY6qF6UHEMfEombaCk1Qu7Stehg3xlj+Q3KF8DeoEZmEnouebn4lNBbGNK0VJJfxykD2kGj20X+elm5awRGcutw2M2RzWpzKVhd0og1k+sJrjFme/jpFsgIjGkiNB2RQHgP7fwCM69RaH9dMSZ4aBHILSuVPz3HJKpC5B80LLTw52f3FUAdFqXtPbU/ZARKa60HViTjNjZ//pMH/JMOO0b+k6zCZ77b+g7jRJRbJlfeYDiXEwookQb5JPgJfHvfA1beTyMZUrg0dw1vw369DRBQUREwZt1EqMMYgy/VjGF1XEML7M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6506007)(1076003)(66946007)(52116002)(8676002)(2616005)(26005)(66476007)(5660300002)(66556008)(508600001)(2906002)(83380400001)(54906003)(38100700002)(4326008)(86362001)(6486002)(8936002)(4744005)(186003)(6666004)(107886003)(36756003)(316002)(38350700002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wm1DS3lNSDdMN3dmVWNJZTZrampVamhjcGl6VEE0cVJhZ3FoV29LQ1UvTFdY?=
 =?utf-8?B?YjVTMTE5emFyZFJqcFM5LzJHcnU4b3hwMXR5Rjd5SUxha2VsRjZ3YWM3RTJl?=
 =?utf-8?B?TkYvWGUreE1xT1phL2Q5S1NzSlBhSTNrS1E0UENGY1N2ZW1vL0tNNC9HSTFF?=
 =?utf-8?B?UmY3Y0xsbnA1d0YrbjVocUJxeUZVbzNUKzhkVVJuTUNRZGxrWWJTdjVHVFBj?=
 =?utf-8?B?WU5FbEFINTg2V0ZWQS81R1VPQ0VWQVJEaGVQNjVMcEFGR3Jlcml3T2VVVVpm?=
 =?utf-8?B?djNqWjFWV2E0OTJ6R2JTN0NlNEtWTEIwMlpkc1diZVZpTzdlZ3dNNnN3Z0Zr?=
 =?utf-8?B?QXYyNk02aGI4K0R0R0ZoMjY0WDBoaVJ0ZFBVbldwMWV0bVVRR2dTYk9aZFYy?=
 =?utf-8?B?aEpwYUhIRVJhdHY0V1FNcnA2aVpJWHllTVJuVFFBbkdEZ3VJRFlFWXNXUmpB?=
 =?utf-8?B?NHhCbFN4U25iQ0hhczdVMkhTMXlYaDBOaVB5aHpHbHY2OVZNN3hXLzZMZkNr?=
 =?utf-8?B?S2E1bCtYWXJJdGZEYjZGOFArRCswZDBIcno3RXIzQWpuUSs0TUdpWVprbG9F?=
 =?utf-8?B?ZHJHSjVNUTd3QlY1TGNKRzRBQVZSQVlSWHgvUmhxUHNmM2pBNlVML0tmVlpr?=
 =?utf-8?B?dk0zdXE0TEJRREo4K2Mrb1dLTzNoRVBYZFM1aUhDb2ZudXJwbXlJR2NxNVZi?=
 =?utf-8?B?MHl0NlJ0bGFKbHM5bXlGT3c4ZStiY01iaHl0S3JOVnVqN21MbUY4RUxrRit5?=
 =?utf-8?B?ck40eWlKRGg1RU5RNFNtR09FeE9HRm8xSGtZWE5ha3l6aUo2YlZndGFMM0F4?=
 =?utf-8?B?ZDVXT1RFaEwwZTBRQW5OeS9ta3lUNWFiTTQvQWFmVmJCOU13ZXp5UzdwajBs?=
 =?utf-8?B?WW9nYndMZHh1cUJzYy9YK05IVXByNVBPSjRCZGxXb0JkcTIzVjZhcEZNNE1J?=
 =?utf-8?B?S2ZtajYwTE05YzJUZk9SclllQ0lPNW81ZjluVDJIa1dVdXdXQzRLZUdVLzFs?=
 =?utf-8?B?OW4yNHJHZE10Y3VKWmxVc3FvaFh0VDVKMy9GSll2dDNCZzltM1FHMy9BVmNs?=
 =?utf-8?B?Z1VyZW56TmUyb3VVWHI3MVVRYW9PNG1lekZhZmh3Z1k2R2I0NndpSFNiS3V4?=
 =?utf-8?B?ODlPa1ZZNlFVMkN2TXBtUHNQd1EvL2lFdis2WnZNTGs1ek5jN2tDUC9yclBH?=
 =?utf-8?B?RGozRnRadUM4aXhpUXArMTFsQno4TzdveGtSU1Zkd05sTHFsZ3RvdXJ0Ullq?=
 =?utf-8?B?SmVRRFp1UElrUHR3TkM0RlF1YVhhdndKYkJNZWxadUJxRHFqWnVTTUY4QUZm?=
 =?utf-8?B?b2E2ejk4bEVWQnpaTDA5dlI1b1kxMWlPSEZQQkl1cFNZZmdGRmJ0L3h1aXRx?=
 =?utf-8?B?Z25nZ21QU09Ib1hiVm5KNVhsbFFvVkVGWUEzdVh0VlYvTkppbFhDMTRuUG1w?=
 =?utf-8?B?Q1owNUV6Z0RoVXpmY2R3c0ovOEtMOE1KVEJWSmljL3ZEaC9CMWRUUnArS0JQ?=
 =?utf-8?B?UHUrNDdYS3ltSlVZcnJoRWNxZ0tVd0REWFVXWlN2enp5eExCbHZzWHE5UmhI?=
 =?utf-8?B?dGs5R1hvVGd0NHpRNk1XWHkyYjc4VWlhbkpzZU9mQmpiOVBHUzJkVEhHQkdt?=
 =?utf-8?B?RGozUHpYTXpYaXlUb3pNd1p4Nk1sWjlTbk1lTDFMVDFMYVdMOWpvM1lQd25o?=
 =?utf-8?B?UXdSZnpNME1zS2Y4aHNZcUwzSS8xZkVaY1lzOHJ0VVBINWpnUDdtR2lxb25J?=
 =?utf-8?B?azdHcGFYaEtvdExDd1lFc3NST1Iyd0lBZTdjbDlqdGxDbENQZFd5Q1VjRjJG?=
 =?utf-8?B?Rm5JSEdxK254T3VvQVlLVndyNWROUmJydTZIS3U4dVhUZFhjRlNKTzFHM3JG?=
 =?utf-8?B?M3IySU8yR2s1SWlxVTVTUFpkcVo5bGlQTnR4dzFoVmlDQ0hTMkVlcWEwZ0N6?=
 =?utf-8?B?RlloREFOUlpzY215QjdQVkpsRGNOblBXQUl0alZlT2Z0TE5ZMEhLdmE1Rmk3?=
 =?utf-8?B?OEh1S1dtRUd5WnJJMC9Tc0dmZUlkMXZ2TG5Zd216MTh2NnJHVVlldDZrQ1RO?=
 =?utf-8?B?bS9MeThmVHI4ZUMxN3orUHpKajZJTEQzaGMreTlnc0pZWWlPZnE1dGliMFFl?=
 =?utf-8?B?d2hFR3czMDdhZk1nbXdJdGlCYmljZkI3YTcrYUJpY3k4b002S0hwVzgvNmdp?=
 =?utf-8?Q?ONYAVIFxoKGrIe5KOQcWZqc=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd10e88c-e59a-412c-96de-08d9f8516c2b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 11:24:44.3127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QgvTpa1v4KQ55c390GPES//S+5Jhn8kT3wuEaH8ppEUfa8PMbYzlFmoALFKtK3yB1sZ4fWy7FNFVF+oFwCeN8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4362
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKT2J2
aW91c2x5LCB0aGUgdmFyaWFibGUgInJldCIgd2FzIHVzZWxlc3MuCgpTaWduZWQtb2ZmLWJ5OiBK
w6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCAyODQ3NDYxNGE4ZTUuLmIxZTlm
YjE0ZDJiNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC02ODcsNyArNjg3LDcgQEAgaW50IHdmeF9jb25maWco
c3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiBjaGFuZ2VkKQogCiBpbnQgd2Z4X2FkZF9pbnRl
cmZhY2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYp
CiB7Ci0JaW50IGksIHJldCA9IDA7CisJaW50IGk7CiAJc3RydWN0IHdmeF9kZXYgKndkZXYgPSBo
dy0+cHJpdjsKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+
ZHJ2X3ByaXY7CiAKQEAgLTc0Nyw3ICs3NDcsNyBAQCBpbnQgd2Z4X2FkZF9pbnRlcmZhY2Uoc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCiAJCWVsc2UK
IAkJCXdmeF9oaWZfc2V0X2Jsb2NrX2Fja19wb2xpY3kod3ZpZiwgMHgwMCwgMHgwMCk7CiAJfQot
CXJldHVybiByZXQ7CisJcmV0dXJuIDA7CiB9CiAKIHZvaWQgd2Z4X3JlbW92ZV9pbnRlcmZhY2Uo
c3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCi0tIAoy
LjM0LjEKCg==
