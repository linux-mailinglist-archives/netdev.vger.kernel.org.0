Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF454408B97
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbhIMNDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:03:36 -0400
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:14912
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236918AbhIMNDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:03:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hb2LvPD626wNpnO0enrp9Kar1sY9soww8jlEwX2zlztNpl3+Iu3JZR6XSG87mW3E97CS0B6cXnX3HSBbs7A3eF7/TnTtn7FmZwAM+fnr0t7cNvPU/RbaI8/4DAAztbY7aTfbKaSNnQYv56I99bq4Vo0B/o7Wf4l5jmjg3OUhn2yu5eTQRh3Uq1tjaS1xHH6N0d022tJBPtFBrIgajFYt9L1s9uN0BO1uW93VD5nNPnLrkIbxsZbNdIRtgkIjI1s12sF5ExNQoSDJp3EIWLtrseYg2JZCMdXQkutSpd3OkjVudMHELZNwVmSbLl7P4HVGv9VE/ckhVgCQAYW2mORpYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vEasab9Ix4f7UzKncEVfA4qRm1ge3YVHkjWFEieBUvA=;
 b=NyJ25kp6jrBGlZKPQLsN9/o39y445ibO5/OwLaulYrIxc0JBS+m+F843VnDzjYQbL4y0JrlXTxJI4tUwvUj/FoDl4uX3GVeQhEuZNHuccQIVG82hf0ZzU6vFUvR4e2fhjkP44g4vOlS4QMCvJy8VwPJVsr0pAJoqgWdC2PoVe/BuAt9t5YPbSm+nf6vjMAvNkFcpQfsfzy12o/RYihefx4PT8eS0m0p1bdw/mP3k4/0ps1MEDuSfe6+DhUSUH+lTPJSX1qDtl0GzFvt6b8y625uor1DLOhwwS+WNYKmpf9GQyHOpM2Uiof5kvQ7sJwutpdt0+kwpdS7TVooBEiBcDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEasab9Ix4f7UzKncEVfA4qRm1ge3YVHkjWFEieBUvA=;
 b=YR2QHrDBRSAJAQyArWNLKB+btOv2MdXHWSQUSWSlqeCeOo4nR0auWzfyAUlJ1T1DIdKoqKGPOmtJ2yNJCPEwBf1ec2KeRts/wMbdiHDW03AdMvTcX+QFlj+ctGKxM6i91wdNdfXvRK6tjizxXp9DjMJy4iXOeX1WMtF/PQrVFcE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2894.namprd11.prod.outlook.com (2603:10b6:805:d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 13:02:17 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:16 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 00/32] staging/wfx: usual maintenance
Date:   Mon, 13 Sep 2021 15:01:31 +0200
Message-Id: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64f06eda-6147-4190-85be-08d976b6b655
X-MS-TrafficTypeDiagnostic: SN6PR11MB2894:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2894779DF96CA8A85378498293D99@SN6PR11MB2894.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhaQpP2iwXLmp7jS3bIbqehf1F3mXhlQKL7yRNabIgLQGiVVZhurKy58yB4cfaLpMu8DjW69Cl16c9s8Vg/ALhmH8ti1CCJYXZLref0CfQg5wXZdRLm/eCETN6rKe/u83w1psDbH+JP0OlpzxSulrmSmnvv2ifzglDtc005psUBYQIfhwpKb3JDDN2Cw7XDWvjZ8vZY0Rs0+dFEvUTwx1Sebe4LfV2dr55Y+gAYqHVwrnvBS7P/60yDUOmUR3xwxzl2ymB4Mi1KmG4rVcTSNAHGM1oQvaT89sNoPbjUdyqwIv0NVMWa4xNTDjHrjs31bWvdgqB43Cyg/7Cz9Y44/RQoKA9HwfcmubR16uWBYjEB/pvq2bq/TsJdSlcei4MOo8gRNfJdvzYmtI5hyvSoBA11E/APMpvNDgxplQ1x5BRVdESyLsBMru6YvT9ZfD6nexlr7lKJRy3Fnu19W6XxmtX6nwxQL8LrRWdGrMM1DzAXJgdRxnZEXDUsCYqVvD7hX2xR0X5cjhWkHlc6S+UTM7JPdE6Mz+Fpq4hg74h1c8xMKgTW+C5BGV9SFKssV4y9HgkmaD8pm0ryljl2RTLOaG8gxzTZkGH/HzIKfuJXQIcKXXWt2FHp2B0rmAkkZVEHIGY1iDZ6EP25QvR+TFzxED/cLhEi/lDPJXuDvDmB2fqLiF+H35ss9dw4I7Snk5C80E4Kr+mbGmJa+xPo519danBah6kLRsEGfPLBeBh42BpPCMA1j5fyEsHnwlXFQieMSBIUt5j120HThnQgV/0ewTBkYT3zqQjrNDd4Oj8nU22g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39850400004)(346002)(376002)(5660300002)(966005)(26005)(8936002)(6486002)(38350700002)(38100700002)(66946007)(7696005)(186003)(316002)(1076003)(8676002)(956004)(478600001)(2616005)(2906002)(52116002)(4326008)(36756003)(6666004)(54906003)(83380400001)(107886003)(66476007)(66556008)(86362001)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmxyWnlYMGVlTlNOc0E3Z0lOWnRjbGFMckk3NGp0d2lEV1FOamM2eEd1L2xM?=
 =?utf-8?B?N3NOL0pOSDVYTDlLd1VDTmdZL3libVlWVHRVdzBwV2UzeEFoU05jbEIyTFFO?=
 =?utf-8?B?R25DemFlYnFPalFrd3lzaXQycDZZVWNXZTRITnFuZ3QzdkdMZmZBVjE1YmQ0?=
 =?utf-8?B?NnJXVlBVMDlTSUkrNkkzUWpOeTgvWS84aXlyY1kxR1NTNm1kdG5nRy9DMnZT?=
 =?utf-8?B?YzhrNVdDYk84L041L3dHejRuTlBIMExaN2d4cG1sRkd6dXlTNjNacGg1aUxZ?=
 =?utf-8?B?QmhCby8wcW00dGRnT2RYVTNWNStLOTVPaUxEQ3o3SUZES2tkd3AyTWxDTG40?=
 =?utf-8?B?anpGaGFkYmx4MHpXcjYwaUllcFU4TkgxNUNTVnFKa2h5OXpMNFo4dkVnNVRB?=
 =?utf-8?B?Q21pQzB3YmZkUjRURGJiVFBOTVEvdzgvWWM2Tit2VUg3RXBOQWc1MC9ueUFi?=
 =?utf-8?B?cUYrMFFweG9halNSSkFGQ3hIY1lmM1hWZ3o5U0w1R09qc2pBWjI2OUZQZG1h?=
 =?utf-8?B?akpsTkg4MGE0MVpUaGRJNnBxVEtPbTd2VnRZV3FMNGE4UzVLM21GM0VrK3pz?=
 =?utf-8?B?dFhjRHJKUUlHQnBrVlpIakZJeFVKenZnMERiV2xSVE1Vd1BnczZGRFo4b2d6?=
 =?utf-8?B?VmpMd1RqRWRVaUlNd1hFN2hxUytHbGoyUlNFNGprclB6VDdUajd0RXU1MmZO?=
 =?utf-8?B?Z3g3R3RacG1qeWpNMzljMUxwV1VBdEFSN1l0dVg3RkN2TVY1YzR1MXlWYWpQ?=
 =?utf-8?B?M2kwbStHK0lmQWtKMzcyNG5KVmRsdmRESzYxR3ZzL0I3cmhhaUpzb1JsRHRD?=
 =?utf-8?B?Y1Y1OUlKaUZzd0N1ZHJiSStVV2E0K0dQODM1enllMGtmQW12VzUwa3dMNkVz?=
 =?utf-8?B?aDllNTBYTEZZa3ZTMkFlNGlwMlM2bnVmS0wxS2ZQeURsUjU5OFZXTXY3aXdN?=
 =?utf-8?B?YXR5a3FDYlQzWlBsZHdHNWdhUDkreVJRM0pvRzZCTHplSklMQ3B5N3NueDhD?=
 =?utf-8?B?UW5kY2xNNXdyN0J1QVRXNG5ycmQrRCtsVllPVEhmQmd6OURyNG1iYnJ2YjVI?=
 =?utf-8?B?Zkw5c2RwdE1IaEcrVXJtNlNsMVBWazc2L2hJRWpiNEwvVVhuZTZ1N1lIUmVw?=
 =?utf-8?B?TGlXWFV5UmxNbFZXYnpieVdoY1Jsak44Y1hJSWFXRTZqeThIS2dXSGRXMHV1?=
 =?utf-8?B?NVVVR2kxNmNaa3FMUjR1Vzl4c0E5N2hsLzJYaS9HSHFUL1dIRkJJUytJQzBu?=
 =?utf-8?B?Vzl0QXFnZk9UV3BDRFhvcE9Dek96YkVnWVkySEZON0piQytQelREWFVraC9O?=
 =?utf-8?B?S3Q0SFJnUkQ5MFJkc2s5bkI2eVN1TXFxczVEYWQ5U2laWXYwNzBpS2xOY01U?=
 =?utf-8?B?R0IvUWFzeEFLdjlJbTdkSDVJeDJXc2JYNUtWdTNTS2VqNXpTUGpvOGFKM09W?=
 =?utf-8?B?NDdRVTVKQkJCZUhHQUphZi9LY051WlpjTUpZYjA5YjAxd1NUdENBTDJBSTBL?=
 =?utf-8?B?cERXMEtxMFd4b0lFZmFhKzR0bGVGbmlKR1ZKNkF0VHVuNk5WR0NabFdmVHdC?=
 =?utf-8?B?MHg5dkptK0VaK2NlSEdWMmxRcWdSVHRhbHNmWGpsb2U0SmViZ0RzVmhidjhZ?=
 =?utf-8?B?bUphNFlLUkJScU9pbFk5djh2Y1ZNd21maG9DbWtFdUQ2ZHd0cG9zdWlYRWtt?=
 =?utf-8?B?ZHpBZzRadUNIREZjOG13L3BKajBGT2krVk5rTkNEemgwQTF2ZTB5SUZVWHhw?=
 =?utf-8?Q?9QcTzIsmPNHyEsWr1UpRM119wCDtglKa0P+cuSy?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f06eda-6147-4190-85be-08d976b6b655
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:16.7397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rYbpXFCXKdDamnpjmn1DaPuQXoD6oiuv+gB0LIZyLuaTC7+hU4cmB97LjCs3bgh2MtaIBXKXFGt2QoSlPx1+BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGks
CgpUaGUgZm9sbG93aW5nIFBSIGNvbnRhaW5zIG5vdyB1c3VhbCBtYWludGVuYW5jZSBmb3IgdGhl
IHdmeCBkcml2ZXIuIEkgaGF2ZQptb3JlLW9yLWxlc3Mgc29ydGVkIHRoZSBwYXRjaGVzIGJ5IGlt
cG9ydGFuY2U6CiAgICAtIHRoZSBmaXJzdCBvbmVzIGFuZCB0aGUgdHdvIGxhc3Qgb25lcyBhcmUg
Zml4ZXMgZm9yIGEgZmV3IGNvcm5lci1jYXNlcwogICAgICByZXBvcnRlZCBieSB1c2VycwogICAg
LSB0aGUgcGF0Y2hlcyA5IGFuZCAxMCBhZGQgc3VwcG9ydCBmb3IgQ1NBIGFuZCBURExTCiAgICAt
IHRoZW4gdGhlIGVuZCBvZiB0aGUgc2VyaWVzIGlzIG1vc3RseSBjb3NtZXRpY3MgYW5kIG5pdHBp
Y2tpbmcKCkkgaGF2ZSB3YWl0IGxvbmdlciB0aGFuIEkgaW5pdGlhbGx5IHdhbnRlZCBiZWZvcmUg
dG8gc2VuZCB0aGlzIFBSLiBJdCBpcwpiZWNhdXNlIGRpZG4ndCB3YW50IHRvIGNvbmZsaWN0IHdp
dGggdGhlIFBSIGN1cnJlbnRseSBpbiByZXZpZXdbMV0gdG8KcmVsb2NhdGUgdGhpcyBkcml2ZXIg
aW50byB0aGUgbWFpbiB0cmVlLiBIb3dldmVyLCB0aGlzIFBSIHN0YXJ0ZWQgdG8gYmUKdmVyeSBs
YXJnZSBhbmQgbm90aGluZyBzZWVtcyB0byBtb3ZlIG9uIG1haW4tdHJlZSBzaWRlIHNvIEkgZGVj
aWRlZCB0byBub3QKd2FpdCBsb25nZXIuCgpLYWxsZSwgSSBhbSBnb2luZyB0byBzZW5kIGEgbmV3
IHZlcnNpb24gb2YgWzFdIGFzIHNvb24gYXMgdGhpcyBQUiB3aWxsIGJlCmFjY2VwdGVkLiBJIGhv
cGUgeW91IHdpbGwgaGF2ZSB0aW1lIHRvIHJldmlldyBpdCBvbmUgZGF5IDotKS4KClsxXSBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMTAzMTUxMzI1MDEuNDQxNjgxLTEtSmVyb21lLlBv
dWlsbGVyQHNpbGFicy5jb20vCgp2MzoKICAtIEZpeCBwYXRjaCAxMSBhbmQgZHJvcCBwYXRjaCAz
MyAoRGFuKQogIC0gRml4IG9uZSBtaXNzaW5nIEM5OSBjb21tZW50CiAgLSBEcm9wIHVzZWxlc3Mg
V0FSTl9PTigpIChEYW4pCgp2MjoKICAtIEFkZCBwYXRjaGVzIDMyIGFuZCAzMyB0byBzb2x2ZSBh
IHBvc3NpYmxlIHJhY2Ugd2hlbiBkZXZpY2UgaXMKICAgIG1pc2NvbmZpZ3VyZWQKICAtIEZpeCBD
OTkgY29tbWVudHMgKEthcmkpCiAgLSBSZXBsYWNlICJBUEkgMy44IiBieSAiZmlybXdhcmUgQVBJ
IDMuOCIgKEthcmkpCiAgLSBGaXggd29yZGluZyAiYWxpZ25lZCB3aXRoIGZpcnN0IGFyZ3VtZW50
IiBpbnN0ZWFkIG9mICJhbGlnbmVkIHdpdGgKICAgIG9wZW5pbmcgcGFyZW50aGVzaXMiCgpKw6ly
w7RtZSBQb3VpbGxlciAoMzIpOgogIHN0YWdpbmc6IHdmeDogdXNlIGFiYnJldmlhdGVkIG1lc3Nh
Z2UgZm9yICJpbmNvcnJlY3Qgc2VxdWVuY2UiCiAgc3RhZ2luZzogd2Z4OiBkbyBub3Qgc2VuZCBD
QUIgd2hpbGUgc2Nhbm5pbmcKICBzdGFnaW5nOiB3Zng6IGlnbm9yZSBQUyB3aGVuIFNUQS9BUCBz
aGFyZSBzYW1lIGNoYW5uZWwKICBzdGFnaW5nOiB3Zng6IHdhaXQgZm9yIFNDQU5fQ01QTCBhZnRl
ciBhIFNDQU5fU1RPUAogIHN0YWdpbmc6IHdmeDogYXZvaWQgcG9zc2libGUgbG9jay11cCBkdXJp
bmcgc2NhbgogIHN0YWdpbmc6IHdmeDogZHJvcCB1bnVzZWQgYXJndW1lbnQgZnJvbSBoaWZfc2Nh
bigpCiAgc3RhZ2luZzogd2Z4OiBmaXggYXRvbWljIGFjY2Vzc2VzIGluIHdmeF90eF9xdWV1ZV9l
bXB0eSgpCiAgc3RhZ2luZzogd2Z4OiB0YWtlIGFkdmFudGFnZSBvZiB3ZnhfdHhfcXVldWVfZW1w
dHkoKQogIHN0YWdpbmc6IHdmeDogZGVjbGFyZSBzdXBwb3J0IGZvciBURExTCiAgc3RhZ2luZzog
d2Z4OiBmaXggc3VwcG9ydCBmb3IgQ1NBCiAgc3RhZ2luZzogd2Z4OiByZWxheCB0aGUgUERTIGV4
aXN0ZW5jZSBjb25zdHJhaW50CiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBBUEkgY29oZXJlbmN5
IGNoZWNrCiAgc3RhZ2luZzogd2Z4OiB1cGRhdGUgd2l0aCB0aGUgZmlybXdhcmUgQVBJIDMuOAog
IHN0YWdpbmc6IHdmeDogdW5pZm9ybWl6ZSBjb3VudGVyIG5hbWVzCiAgc3RhZ2luZzogd2Z4OiBm
aXggbWlzbGVhZGluZyAncmF0ZV9pZCcgdXNhZ2UKICBzdGFnaW5nOiB3Zng6IGRlY2xhcmUgdmFy
aWFibGVzIGF0IGJlZ2lubmluZyBvZiBmdW5jdGlvbnMKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5
IGhpZl9qb2luKCkKICBzdGFnaW5nOiB3Zng6IHJlb3JkZXIgZnVuY3Rpb24gZm9yIHNsaWdodGx5
IGJldHRlciBleWUgY2FuZHkKICBzdGFnaW5nOiB3Zng6IGZpeCBlcnJvciBuYW1lcwogIHN0YWdp
bmc6IHdmeDogYXBwbHkgbmFtaW5nIHJ1bGVzIGluIGhpZl90eF9taWIuYwogIHN0YWdpbmc6IHdm
eDogcmVtb3ZlIHVudXNlZCBkZWZpbml0aW9uCiAgc3RhZ2luZzogd2Z4OiByZW1vdmUgdXNlbGVz
cyBkZWJ1ZyBzdGF0ZW1lbnQKICBzdGFnaW5nOiB3Zng6IGZpeCBzcGFjZSBhZnRlciBjYXN0IG9w
ZXJhdG9yCiAgc3RhZ2luZzogd2Z4OiByZW1vdmUgcmVmZXJlbmNlcyB0byBXRnh4eCBpbiBjb21t
ZW50cwogIHN0YWdpbmc6IHdmeDogdXBkYXRlIGZpbGVzIGRlc2NyaXB0aW9ucwogIHN0YWdpbmc6
IHdmeDogcmVmb3JtYXQgY29tbWVudAogIHN0YWdpbmc6IHdmeDogYXZvaWQgYzk5IGNvbW1lbnRz
CiAgc3RhZ2luZzogd2Z4OiBmaXggY29tbWVudHMgc3R5bGVzCiAgc3RhZ2luZzogd2Z4OiByZW1v
dmUgdXNlbGVzcyBjb21tZW50cyBhZnRlciAjZW5kaWYKICBzdGFnaW5nOiB3Zng6IGV4cGxhaW4g
dGhlIHB1cnBvc2Ugb2Ygd2Z4X3NlbmRfcGRzKCkKICBzdGFnaW5nOiB3Zng6IGluZGVudCBmdW5j
dGlvbnMgYXJndW1lbnRzCiAgc3RhZ2luZzogd2Z4OiBlbnN1cmUgSVJRIGlzIHJlYWR5IGJlZm9y
ZSBlbmFibGluZyBpdAoKIGRyaXZlcnMvc3RhZ2luZy93ZngvYmguYyAgICAgICAgICAgICAgfCAg
MzcgKysrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5oICAgICAgICAgICAgICB8ICAgNCAr
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5jICAgICAgICB8ICAyOSArKystLS0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jICAgICAgICAgfCAgMjIgKystLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvZGF0YV9yeC5jICAgICAgICAgfCAgIDcgKy0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV9yeC5oICAgICAgICAgfCAgIDQgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90
eC5jICAgICAgICAgfCAgODcgKysrKysrKysrLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
ZGF0YV90eC5oICAgICAgICAgfCAgIDYgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYyAg
ICAgICAgICAgfCAgNTQgKysrKysrLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuaCAg
ICAgICAgICAgfCAgIDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZndpby5jICAgICAgICAgICAg
fCAgMjYgKystLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZndpby5oICAgICAgICAgICAgfCAgIDIg
Ky0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCAgICAgfCAgMTQgKy0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oIHwgIDI1ICsrLS0tCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmggICAgIHwgIDg1ICsrKysrKysrLS0tLS0tLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgICAgICAgICAgfCAgMjMgKystLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3J4LmggICAgICAgICAgfCAgIDMgKy0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4LmMgICAgICAgICAgfCAgNjAgKysrKystLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl90eC5oICAgICAgICAgIHwgICA2ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9t
aWIuYyAgICAgIHwgIDE0ICstLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmggICAg
ICB8ICAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9od2lvLmMgICAgICAgICAgICB8ICAgNiAr
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9od2lvLmggICAgICAgICAgICB8ICAyMCArKy0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2tleS5jICAgICAgICAgICAgIHwgIDMwICsrKy0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9rZXkuaCAgICAgICAgICAgICB8ICAgNCArLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9tYWluLmMgICAgICAgICAgICB8ICAzNyArKysrKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21h
aW4uaCAgICAgICAgICAgIHwgICAzICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgICAg
ICAgICAgIHwgIDQzICsrKystLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmggICAgICAg
ICAgIHwgICA2ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgICAgICAgICAgIHwgIDU1
ICsrKysrKystLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaCAgICAgICAgICAgIHwgICA0
ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICAgICAgIHwgMTM1ICsrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oICAgICAgICAgICAg
IHwgICA4ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNlcy5oICAgICAgICAgIHwgICAyICst
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oICAgICAgICAgICAgIHwgIDE0ICsrLQogMzUgZmls
ZXMgY2hhbmdlZCwgNDcwIGluc2VydGlvbnMoKyksIDQwOSBkZWxldGlvbnMoLSkKCi0tIAoyLjMz
LjAKCg==
