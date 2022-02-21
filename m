Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0FD4BE8E9
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380741AbiBUQiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:38:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbiBUQin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:38:43 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B529A220C6;
        Mon, 21 Feb 2022 08:38:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDW3MQUF/ZKDl4rfw/wpL8ewS6QjWAW32XkVjcWlvqPfOif5EWCd51bEf3dIV5nZ/6NuPxTGqQyTaWBopgZyIuy0F1Orah81xBDBRrm0WdKJzUBuRqVTS1dZkuyxsk/lYUmiNrdBp9i3QuqNq94f/CZ5DaH5QDF3GpgnBBuxm0BY5VkjHw3wD4FBa6E/AOJCyiQ8e7eOnuFJ/bXu8tc4bYjecDNX3ZBi+T5OpZLlv8YXFGTqn7yYI1215kqCDdV/kKfmRI6Gmek4wtEwvlp1C/pU2QTRcr555UibOn2JbMgAw2020bIJzyWB93Pp+LPKRHJZsUY1eZ0tOAbQkA6z3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ntj4miQ+9qW4Cu/YUeS6pRxqSZo1c2CUDzXe3buuxYY=;
 b=R9IMgrYGeyUGycOG1OghqwV0WqvBYD+jwCrWDQCz7C37zJUw+iX2cUVL7hrxUu/C8ESeUBhlmW56uAk3H4SSn7Lq4mAfLqM8mSYzAhLy5hdJb/7r/nmf8UZtFJANLJPma4Rk+uriM0PqbcckCrY+JIIt/ufKC+EsIlwQzMdjy6M2xyrLn3kKpFI4HU1yyKdATsh3wyKjo50j04dODoaRyK5PpirwRlAxXiXe+qDuMPewVCoBaI7lk9QhUp5Kbxxtr05AZxqs9U0dCk60tMZi2sw7T1RO+wbwoAtWPFA4Khmvp7nmJAQNWZHnQHI+dkJmaU6kJOSqV9MdMlgRRfPjyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ntj4miQ+9qW4Cu/YUeS6pRxqSZo1c2CUDzXe3buuxYY=;
 b=lY4XdM7saLNxwcOsgm7swPCwU6aXB8zTOc0btcfcCHcbMlIja4ThR7V0f2jF4+f3fhT4lRmg6YF18hYUu3DOfLGJwatzhS4pVEX+h1Qr/Sl4qy4X81cZHY6BvemOtUwgMHNgNtFFljZ2kZ3TyxyNzLBkCh1+eRRPB6lom9BDCTk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BYAPR11MB2631.namprd11.prod.outlook.com (2603:10b6:a02:be::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 16:38:17 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 16:38:16 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-firmware@kernel.org
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jerome.pouiller@gmail.com,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 0/3] linux-firmware: update wfx
Date:   Mon, 21 Feb 2022 17:37:51 +0100
Message-Id: <20220221163754.150011-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0225.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::21) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f835e83-884b-4367-4e29-08d9f5588f38
X-MS-TrafficTypeDiagnostic: BYAPR11MB2631:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB263128BA6A0ADE57BB53FA3A933A9@BYAPR11MB2631.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +FM/A2l0yFnsISIc22144r/mJ0NKDkQ0thrHGgBSc7C38u4Pihwh2Bgk+1dVAt3OxePkdO8Uxcc9uxXmrGIQiGddbgSXJFEOsbMK3+aaGKIcyoT2Deosio6ekfY8PL+nT5OIWK5WLvF20ns3kRccvNml8BEGWyVpGNQizGWOAyGTcFEi1rbsB0Z5tG1j8Hmeadfh+HrpYd0XQ8UqU2F42oRTjHvbugBBgYNK1cAi9zLSxEzoTRZ5pjhPIpIunW5G1egPnTDHnSQI8sXDM/ZyReMg40YqShD8Tdbv7wZA5Kayc6Lg1pmB+8nLelx3U0hZjAjRX61wkXbReC4pncBLA3/TdesyYrs/M2+vpWO8rlLbksuVYRCXowjCRHnPw58p+iaOVlJ+XNc4+pGEd+owQIJWsHscb74+R0hBa/SAj492wFuapzgX9+6UdN9nhiEpYWKbEApr77vhjSrRJMKzV20f5NDrD9S2xunOFei5/XuxLvtEF/7SShoc0ICjpqgaV2G/7dbdlwz9IfOiG1jNFWUCRIaem74Ja47P/F5W/kqJGot1rUmqJ40XmVLbjTtuA55whmr1Wtl7RGzv3yiO9EiT04QsVrOt4p70hsPYD772F80MOVYYD5BWdC/ZTW7mQ+vINBhL4BGUpAGsT36yyQSfWXAAmiTMCHrjHU3Cseow6mCX+oEDDeEmCdXsqpoB4BdUQkwoa2lS5AUujngnLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(2906002)(54906003)(36756003)(66574015)(15650500001)(6512007)(316002)(52116002)(6666004)(6486002)(38350700002)(186003)(26005)(508600001)(2616005)(8936002)(38100700002)(8676002)(4326008)(107886003)(1076003)(66946007)(66556008)(66476007)(86362001)(4744005)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlVtelptYXppandud1R1K1c2ZG1SUjFEY0pTN3hweStjeEtWbEtRUjFTdER2?=
 =?utf-8?B?MGlZQXZVbk9hSVQ1ZjlHL0xGaTloUmhMaGpuSkIwdzl3TUNzWVlYNnF1aXJL?=
 =?utf-8?B?TkZiRlM0d0dtSnlEa1g4RTRCSEpicHRhNlQ1c0w3WXdPRzUybEFzV2tOVmh5?=
 =?utf-8?B?b2hqM1RZZWVtNEh5cE96VlJKQjRkSzVnRkRvVmpYRmpHc0VlMFRjZ0VCTFgx?=
 =?utf-8?B?Z044d3dyZjJ2YmszZ1JSS0RXcG0wU0JraGhiRGJqYXhnWVhrYTVweDVGOUFH?=
 =?utf-8?B?MnVlemlBWGJCWU12TmRrZ1dnM1U2MHFOdGhWUHdqRmpYSEU2K3JpemF3dHh4?=
 =?utf-8?B?WmcxNlJIaklUN0h6ZVBSU1lKMTFjbFdtVC90Nzl4NFVoVktYdDUxblBlUit0?=
 =?utf-8?B?ODRaK3RaZ0EvZUErTys1Vk85YW9LYXdYRVJGTTU1NTliMUV5U1M3Sm1Gc0dm?=
 =?utf-8?B?bUo1OXA1S3R0QnAyYjJ4VW9pNzYzalE5cVprLzB3Z3UxbEpTM05aQi9sYTVx?=
 =?utf-8?B?UFMrU3V3b05Gc25NbUR6cUhEOEwrS1lnU2ZiQ01teC9GVTQ3UFdzakUzUC9n?=
 =?utf-8?B?R001cHlPVzlreVZEYWp3aG5QWGtXd3I1M2t6U3FZd0NBMWY2SUdaSHR6UVY2?=
 =?utf-8?B?Z1cvTGVuQXdLVXEwZHdqMW04QXl4NDNQdmtPdWZXR3NicXNLRzV4Q2xzTjNH?=
 =?utf-8?B?RjVhNGUzUk1iQnRRejBzRG5BaFdsdkRndlBKUGNwdG45c2pOamFDYm4veGsx?=
 =?utf-8?B?L2liMlREVUdqaUkveE9IbjNadkFTUTYwN1NzWjhhQ2xyOFdOT3hCTk5TdkVy?=
 =?utf-8?B?NVJJV3VlUDd3SUxxWVM0bUJGSWNKRmp4QnRKblROT3p3VEZNa3UwZm0wa01W?=
 =?utf-8?B?ek80YkpVZEo5aDhtNFZLS1U1bERTNnpWenNMRmxBYnNMTktHbmtNN203L3FK?=
 =?utf-8?B?WUNVN0x3TkRsejA3R1VLd2hZOGZYUmhaYXg5cFhPa05MUDJxNWhaR1BXOURt?=
 =?utf-8?B?SDdBR2hNQ3JkWnlVUXliVUpXSU13RGVaWjF5cFljSnNVdTZ3dkRtN2JzSCtF?=
 =?utf-8?B?VVRXdGhaNTQvT2tNUDVESUo3bHJyN2hmbGtlSnkrN0RidW9Jc2s5UjArNVoy?=
 =?utf-8?B?TmVvVy9CQVBJcUJ1M3loSUdIdnpmbEVvSzd0Y1VjOVN2dWhITW94S24vK2FB?=
 =?utf-8?B?bnZUZTJvRlRTZFpkSWtLZFJldHQvZm9STkVvTTVrOWdDWml0eHQ0SDR1ZTRy?=
 =?utf-8?B?cTlJZytlOU9rOG5CUk1mK01PdVo3bS9Vd1RDT3hRT3VqTkpJRWppemlDUGtZ?=
 =?utf-8?B?c0Fxb0Q1NWxabDYrdDNlVkJNVGNPOVJUbTFMNWFlWWRDM1NyNjBtVnNwdjJ1?=
 =?utf-8?B?RjFJcVlIZ3dqTE1tanlqVmRBcDBmSW5mcFk5TnU1U2JZalA4TFQ2VHczL3Ex?=
 =?utf-8?B?OFBRcFRwZ0RLcy91ZHRlK2dsdUZ3YUNzT1pVeUtiSVN6RTJCRUp1TWpIK042?=
 =?utf-8?B?alRKbnM0OWNnSE1xNlpLRDQwQ1JYblV6UGhtUWYvUm5abXVOcTdOYUhWaFpE?=
 =?utf-8?B?VlV6cHl2SEtjM3Q4VUltemVkNnlNUmJ0SHIzQ3VqMzBUclpTTjQ4a29hb05i?=
 =?utf-8?B?eUNjT29waDFWNDd0N0hMQWozdllJSXBmWWU4d0pjM3dJd0tBQjkzSllSTEdj?=
 =?utf-8?B?TGhGWldoL1B6Z0d6cGdCL2VRVjZpWWNQR3FnUnN5bXUrV3d3NENhR3IzQkFJ?=
 =?utf-8?B?VlA1T2Y3VlFuL01IQVJLK3pOU1VIZHhPOUNWMGxoQTlTMHFlT2pxSmFCQXBo?=
 =?utf-8?B?VmtCOTVOSnJURys0amhQSzFocDBTYld4RGdsamhrQ3VzRitJeFRaZFd5R2to?=
 =?utf-8?B?Q0lvZlUxR2lVRWJsTWRtSGFxTkozai9BUlFSZStreXFUNHdGdVQ4L3ZWZjIw?=
 =?utf-8?B?azhGMk9sWkwwQjhkanpVcWdFazdsOUpJZk92VGVpOHVIRElUS1J6YUwzUTNB?=
 =?utf-8?B?bkhqQjJCNU92dkQ2SDB1b2NiQ1BNWFhIeVRXSzNxNkEwdkNTeGQ0eCt0UWpU?=
 =?utf-8?B?dWZnZG14WEdmVUhhck5OOU5iRGMySExTUjdPZVp0R2ZkYmFxZCs2czhwaG9u?=
 =?utf-8?B?bEc5WTlNMUxsY1pSNW5qQmpmT1VXVU5zY0lCWHYwN0ZKRXljRHlBZ2ZBNGRZ?=
 =?utf-8?Q?CIp/IwAECnzatEVIwNcpFZw=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f835e83-884b-4367-4e29-08d9f5588f38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 16:38:16.3850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YDOI/39SlbMv0iCdtJIjjUK9ks4HRu+0FpcBAmJzd1r2ujFRxIoijgynZzniryKJmpFOUddiOx7QpBiFypK7Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2631
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHR3byBmaXJzdCBwYXRjaGVzIHJlZmxlY3QgY2hhbmdlcyBtYWRlIGluIHRoZSBrZXJuZWwuCgpK
w6lyw7RtZSBQb3VpbGxlciAoMyk6CiAgd2Z4OiByZW5hbWUgc2lsYWJzLyBpbnRvIHdmeC8KICB3
Zng6IGFkZCBhbnRlbm5hIGNvbmZpZ3VyYXRpb24gZmlsZXMKICB3Zng6IHVwZGF0ZSB0byBmaXJt
d2FyZSAzLjE0CgogV0hFTkNFICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTggKysrKysrKysr
KysrKystLS0tCiBzaWxhYnMvd2ZtX3dmMjAwX0MwLnNlYyAgICAgICB8IEJpbiAzMDUyMzIgLT4g
MCBieXRlcwoge3NpbGFicyA9PiB3Znh9L0xJQ0VOQ0Uud2YyMDAgfCAgIDAKIHdmeC9icmQ0MDAx
YS5wZHMgICAgICAgICAgICAgIHwgQmluIDAgLT4gNjI1IGJ5dGVzCiB3ZngvYnJkODAyMmEucGRz
ICAgICAgICAgICAgICB8IEJpbiAwIC0+IDU4NCBieXRlcwogd2Z4L2JyZDgwMjNhLnBkcyAgICAg
ICAgICAgICAgfCBCaW4gMCAtPiA2MjUgYnl0ZXMKIHdmeC93Zm1fd2YyMDBfQzAuc2VjICAgICAg
ICAgIHwgQmluIDAgLT4gMzA5MzI4IGJ5dGVzCiA3IGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pCiBkZWxldGUgbW9kZSAxMDA2NDQgc2lsYWJzL3dmbV93ZjIw
MF9DMC5zZWMKIHJlbmFtZSB7c2lsYWJzID0+IHdmeH0vTElDRU5DRS53ZjIwMCAoMTAwJSkKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCB3ZngvYnJkNDAwMWEucGRzCiBjcmVhdGUgbW9kZSAxMDA2NDQgd2Z4
L2JyZDgwMjJhLnBkcwogY3JlYXRlIG1vZGUgMTAwNjQ0IHdmeC9icmQ4MDIzYS5wZHMKIGNyZWF0
ZSBtb2RlIDEwMDY0NCB3Zngvd2ZtX3dmMjAwX0MwLnNlYwoKLS0gCjIuMzQuMQoK
