Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3A8689E84
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbjBCPul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjBCPuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:50:39 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2070.outbound.protection.outlook.com [40.92.52.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF08699D6F;
        Fri,  3 Feb 2023 07:50:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k492+f5Pb7fGyfOFCAPlHevDX4l97/qBCvfNFD093THGtOuKezqgXaCwrHjFPNhpVcH18i3pRjgiIUExe3udm928+ZBS+f26dktjm5YTV35eWIO6gxG1K+qvZ0BDyAVHUVy+zmBimaumjy6UiZpfqnu0ALMFpHaKNfmVmLMCMAW6n+tgOBfvIaZVpGox0RYHxfmRDnIVwXNKXZo5oS0CIMLLSvZpDyL+Z5R6XhaTdzXhzm675mxIyhyMmZ5/WS/CzsIDBcOkHHHq4nbpGPZgpXQt2y6M4Qj/ESk/OR8rQg1q0ebXEsjJwduxYWP3xmSJGAX+wFDRv+tFSLCDpYJk6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1H9sHtb72Otqt2PXM5e85hbmGjCB16YmoHQTXY+oDbQ=;
 b=bA652JY5gtrPnFUmKiYZk0uHtg8fMa5D5MPSe/5y40kRCg8RGj97QtpxmonWs73DTyh5FXErgsAtovF0VNU4jWg40Jg45v+zUlkZ6sxbB3YkJe5D4qHuZwr6YDlMKi16ysLEqsl5kYK3w84koRKykeSqboMDSswWojuckTwwb7ZCld6+0rqGzaMwpFWZidjLUZv0fOnryj1N0wQIzhyfTD5oDJ8xc7zt+mCe5YBLQ/E0Z2j71LEnzT5SOKGYvQ0q2z6A40xpX1PPeeJM419/jzJVgt+ulK4O1MTOHLcT/AraKY/eNbAZgEOnAzwU5fnrVCY2wW5f+5Kol7aoEct9DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1H9sHtb72Otqt2PXM5e85hbmGjCB16YmoHQTXY+oDbQ=;
 b=GlAmtYDZycRAgjZNFE1hJRLrKxV7RvQJX1AFvWvWbVX7oKZgc/oUDAmTXJjjCDVs26R6tQ9INREbrAXBN3SYHP+TVQ4LyyIw5zq+5ocFy1Ghcejjjh1ojoux9de6Mc6sk919euVVgAoA3ImTL2VZS/EV3zsEWeQ8H/GzN3B5RvPCaDob/0C3IzeTxibHA8Pk2zxEOTDBmesRR+R7sP/qhdXv+ozmqc+6yPimmeZqGzfbPNWVhm9Nhj1v+opXCXBbN1XrjhBJEtyMoIhX+2sBkK0Sd5DE3KfwWFODwQIW2efbvVsA/ZvpHZdKGJ/FLhinNahY75VtLnKmX8cHuU7f+w==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYWP286MB2716.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:24f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 15:50:32 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 15:50:32 +0000
From:   =?gb2312?B?zNUg1LU=?= <taoyuan_eddy@hotmail.com>
To:     Eelco Chaudron <echaudro@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogW1BBVENIIG5ldC1uZXh0IHY3IDEvMV0gbmV0Om9wZW52c3dpdGNo?=
 =?gb2312?B?OnJlZHVjZSBjcHVfdXNlZF9tYXNrIG1lbW9yeQ==?=
Thread-Topic: [PATCH net-next v7 1/1] net:openvswitch:reduce cpu_used_mask
 memory
Thread-Index: AQHZN+c/DKiHb6zeGkipM7oLPYpwgA==
Date:   Fri, 3 Feb 2023 15:50:31 +0000
Message-ID: <OS3P286MB22950F0D26C1496D1773B172F5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
References: <20230203095118.276261-1-taoyuan_eddy@hotmail.com>
 <OS3P286MB2295DC976A51C0087F6FE16BF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <ECDAB6E2-EBFE-435C-B5E5-0E27BABA822F@redhat.com>
In-Reply-To: <ECDAB6E2-EBFE-435C-B5E5-0E27BABA822F@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [7UbzRKunmRX1OVeK1GLlwEgFFgFGHi9r]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3P286MB2295:EE_|TYWP286MB2716:EE_
x-ms-office365-filtering-correlation-id: e6af2b65-aa78-457c-4000-08db05fe6196
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZkDTqmWMmJxJsKMNqxg2+HR9y2t0qh+RYoeoRtoo9wacDaWTSrn9NIhUPgBBVolcsZ5c9cTe/Ixnsd6LruHi09U0XItWalyYxacfTwOZQnaBnwZd89DsyPbcfIGgtCIE88epOVCKiX9AIzdTJx817hMcMLvkZ+ryJT8p2DiP40mq6Y5qTfk3kYOdeXzKxnlSjCH/03al7E7c0RJXUu5D2DO2DrnO2HZ/PHgDbw1FJn57UBlsGUp2/Z9YuBBY2TfKQrVuL4EXiR7TRA2mhZqTkUW1n1olIkFV8f8frgY+KCwN8igDs11ITTzWwCwQ2q+Hvh41jYFI7h+zZVVgLRz/zIcl3dWiSALBHbakxcKceqlP+XRsZWTTPvPgXKiEWg/lf3mo4QwHCUJTkjR3c2jK1a9+1SINWNpuf7TIZeHswSBPu6owupkPxJdj9zzYRJvBgTo9QYfGsq63kherPkDx1eXnlCtCZ+06yaFWC6X8cSbx0ovfVDyeGzqMS8zJ8sfA9yjKfe984wV/KFy/mKvposJ/D7gmYTiFvkePRCwGLoRwsMV6vaE1CjT2WopreTS6hyOGsgWVD7c6Kn113kUu90WYcoTzD0AZ3AB3uzLDI8o=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?NldyT2VNd2dQcExwS0d6RkZaT2dRYWE0cnpGVjFyRTJCTEtzMGFhVW5yVXVF?=
 =?gb2312?B?dmRwc2g0T1lZL0plTURrWXFWNmVkK1JSR2d4REtMRUY2QmNjWTYrNjJHdDZx?=
 =?gb2312?B?Zm9ZSVVVZWZCZmppM0ZiOHBXL3FCOElKZHExTzBLTW51cGF2ZGdXWGRmNEo4?=
 =?gb2312?B?c3RTb01JTHFPR0VJdFdOdEE3YmEvUG1vTXk1bnBCTmZqM1BlNTdKcDg3U2FC?=
 =?gb2312?B?QU1ydlJCSThxQVRFSmZibDVJZ1FzNCtPUXdnOXl6SXdZc2gxVmdCaXd5NmI0?=
 =?gb2312?B?VFdRanM3RTRBSG56VlBsRmp0akNOVFByY1pTY1JXZzNpTnZ4c09nSHcwT0xX?=
 =?gb2312?B?ZmUwUE5FYmg1MUNUOW10NXRqM2kxU3NMdDlld2g5TmdQaEVZV0UvZ3pqbzJU?=
 =?gb2312?B?SHI5SlpIWG4ySHlOOENTUXhPR1NIRldqdjdCcjNPQmtFUHpSK1kvMW1sTzdz?=
 =?gb2312?B?TzRaV1grMlFZTU8xdFJaVHlsUlFzU241cjBFK0E0QUpjVm90RzVlUWw1OTBT?=
 =?gb2312?B?M042OWpCdUFZUDJTdlBlcFJFMjFmSU9VWDQrWWlsdi9sVllmamlHdkF0Mytj?=
 =?gb2312?B?T0tnTDM5dDBIVS9UMmxhMk9YaS9ka1F2dzkvSTA5a3ZuSXNjWlhCZUg1c1M1?=
 =?gb2312?B?NHlEUi96RVRHc0xublQ1anZBMENsWFNCN3VIQmtGa2VoaHpaRTErYld1UGhL?=
 =?gb2312?B?OGJ0eTl1bWVvTXRhckFWWTIvYWFxeEZRZWxuSktvVFFUcFB0L3ZrQ3lBN28w?=
 =?gb2312?B?UTF2ZTRJVVdaREJJOHFkQVRDTkUweUROcTFqR1N4TnBpOUI5MHlrOUlrSGo4?=
 =?gb2312?B?K3JLaDBCRDJXQis0UzdRTVZuMVVWMnIvRmdWVEhSTFA2Y3ZjbENrRUN5TVNJ?=
 =?gb2312?B?M2kzdG9SQ1prbnlQN3lJSDh6dFR4dWlraDEwTjJBcDhySkZZU0lVMzdBQU5F?=
 =?gb2312?B?Ykh4OEpycjZ5c1N5WitpZDU0aEVRZVVWczVHWVNhRFRCNTFMT3BnL01yNTJ2?=
 =?gb2312?B?THBDMG5MaTc1V2RsTVRsQkVpenJ4VHFwYVBFbk5ZVzdreHUzb0lGNWhtTUhO?=
 =?gb2312?B?ZVJ4d0xIeHhTdCtEaGVUc3dPS0hPSkZqRk9tZjIzNC9LSE1lMXFoL0FEVEEw?=
 =?gb2312?B?M3BZNTBDMHdodTZmM2NmaHMvdEt1VUFvT0drV0pHMDJ4TEpraW9zZytoT0gv?=
 =?gb2312?B?TWVsWHpmUlBBTmlvNHZMUFdFY2FhRk9DTmZxQ2JJZnY4MjBQSjQ4Vm9HSWJu?=
 =?gb2312?B?THhKU013OStTTlFQblJkaDJNYkU2VlhaZzBWSDlwYkZDdmJYUVQrdnQxMTIz?=
 =?gb2312?B?eFhOOUtjUkNZZDRLL2pZRDdVR2R1ek92VjFzTDF5eEg4Y0IwSGNUMG5FcFVE?=
 =?gb2312?B?NmF3eVpNaWFUS0EwR09OZ2NGUWg0WjU3R05CUHJEc2x4UGNvWVpFRUthWHVz?=
 =?gb2312?B?cTZ3djlCZXQvZkJ0Q1dNYXFBc0dPb3RPNklVcWVIL1dFNjhsdjB0ejhrWmE3?=
 =?gb2312?B?RGN6YVZtUkZMSG9EaFBrVWFJUXpZcFA3ZDdkRXduUXYvYWFNbTJHalhPZ1JF?=
 =?gb2312?B?N0xvMkhHMDlkVW5JLzNMMWF6aFhDNVhLbERScFViUW1yOG0rRUJVRytHanl1?=
 =?gb2312?B?ZkE5cS95Z3pYN01sOStGVG42VmhqRFpTSzU2Q1A0Q05ZZnBwaFB3RmpnSjR2?=
 =?gb2312?B?ZHZVcVpwVUpZakVHS25Jd3hTUnJZbzlEWk92c2toTGFTTEtzY0hTR0lRPT0=?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e6af2b65-aa78-457c-4000-08db05fe6196
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 15:50:31.9657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWP286MB2716
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q2hhbmdlIGJldHdlZW4gVjcgYW5kIFY2Ogptb3ZlIGluaXRpYWxpemF0aW9uIG9mIGNwdV91c2Vk
X21hc2sgdXAgdG8gZm9sbG93IHN0YXRzX2xhc3Rfd3JpdGVyCgp0aGFua3MKZWRkeQo=
