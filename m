Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C60651C885
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351958AbiEETAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 15:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343580AbiEETAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 15:00:42 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580E7377D7
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 11:57:00 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245I4bZM000990;
        Thu, 5 May 2022 14:56:43 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2050.outbound.protection.outlook.com [104.47.60.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fv458gp3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 14:56:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clFUJwUdWMJvZudLuNUrFUSJXGMCShAX2AznaIzD78/HVwfPYNHA4c4FO2sKCf76IvVypp10GlBE6krdIOhqdo/V7QvPPIuiyeJzLX4/TDmDuIoCYPVsZPWwCGWQKTc8rOUsYug54MsVPyY739Ge59U3flfA0JKzoIeWrpW6+Lrau2kF0wP3QYP9IMnUyZQ19U8LXGbpPmkzP8NPNqXN0zYnoAoZBtaJJf9CaNTfbzD81ocWf/e3YxHPN1miPbXxa+oToSGS+gT1x4YgZPHGWqO2KLuHuoBFoaPVApnVzHxolNLQX7o/HXcAWCnXm9ExEQhc2rcsfJ4Sz/AKzF7L/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLRKNikFcJLFa44xjgWQS0h9ISc9LBZ3etCNVh90vLY=;
 b=G2vQoimrZ3aELlmNTlnh1YoKL8B1LefqAfQ9Jwsh4Ng1L/93hCSltKPWFW3jpPOCeNxZGv8VmtyoqVUq2jnPXrQuupoNXrx1/B1DM6F4to1hoeCKGDMNwbXgDqxfwsIxeQSkGB+pP6rBoGoikG5wzDCLvdbMEv8A27W0yjrq2p4+ncHE0yUUmscF3PQ+Sf4zyzIqznsjuUjKKzDznTyl98HbeYQJZNDJfUAcWJif3iWzfAc7bkal6Q4TPAvJd0IKdzuuCDngSLCz4CIieJWHr+xELFZ09Pme9OHY4TuVn2iHcjMPBPQziOFuj3L/9e84BtiCoK3I0is3SOwTVOEbUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLRKNikFcJLFa44xjgWQS0h9ISc9LBZ3etCNVh90vLY=;
 b=gV3gctcQGRV8VE0ukXIH1fEU2jAIuphB7RSoddV218XrH7TY9kQuWUNXVL6bLVJEqfdFmTeKcqGpPfXMYs2TBFSVr6UePbmACGN/Ebvi4E74pqPMomczH2aXW0qypVNJMjVwfuNa+d6B+n2gA357RIpEoHFNB0O54smyPSw92hM=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT2PR01MB4960.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:47::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 18:56:41 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 18:56:41 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "harinik@xilinx.com" <harinik@xilinx.com>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radheys@xilinx.com" <radheys@xilinx.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Thread-Topic: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Thread-Index: AQHYXBiAdPySYflEJ0exYZgZgYcAxK0PlYFNgAD+0ACAAAmugIAADYUA
Date:   Thu, 5 May 2022 18:56:41 +0000
Message-ID: <c714f499a07bc764c8f34c85cac596c3494b53e7.camel@calian.com>
References: <20220429222835.3641895-1-robert.hancock@calian.com>
         <SA1PR02MB856018755A47967B5842A4C4C7C19@SA1PR02MB8560.namprd02.prod.outlook.com>
         <20220504192028.2f7d10fb@kernel.org>
         <5376cbf00c18487b7b96d72396807ab195f53ddc.camel@calian.com>
         <20220505110817.74938ad8@kernel.org>
In-Reply-To: <20220505110817.74938ad8@kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdedfe85-b990-486d-a80c-08da2ec8fdba
x-ms-traffictypediagnostic: YT2PR01MB4960:EE_
x-microsoft-antispam-prvs: <YT2PR01MB49609197737034A177E1F009ECC29@YT2PR01MB4960.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F1tZd03YqmqmxA9/ndf2Az+Y23mWlHfZLhUztqmTikG1K088+Zg0kRC7kWeBSqaomjGV+TGSjaOSDUSMMjAUj286rUZQNYUmkMicWYAwZ0L/R4dG4EgKsXsyyzPSEtvTatpGlbSlOEiL7LBQTVbkVtgBSFC69k7/8DrjfG6Gr+AKDiYBJWdyPehHVMuRqccXdcOiGmg1Ox/mcUGWs1SBajUCxstBwgTDvWX2SUlR1P3EtQNfDujZD0hTSsZQj9NiHegIFc9/bKTWtyOrF8YYa4hOyg3IeLsMpdDPqtYEBgl59Or/J9VkOPdklm6098aYdJbtT5N/Q1zc/Wc41YXkoWzieScbtZux5x3c1tTUE+4xmhKRqJWBkjTxASJvVBUmLbC0yEoE9Cw32DBs05sbHnmVyaSb346VR5sZT36SthA9SRMi0+4bAN5lskqPXTsRWbd4FjaBKnoNZn0+DS3qpuoE0GkqmEOduaIoiNatvsMyu/QgrkHKWYHa1M3eaw6+iaFnkvWBlpZvKBYEFoA52brTIb3bqhgHHBb5hNDyWCK71qY8cVKUVDCyf6xfFZqTD3AUPTMshjq+6CjwqVdglo2ekdmHDIkVfLuVqThSUVmdwIhJEklQ89bFEU1/dPq6j5xkhNPxeE2RR6Fxne71YYfbcdeWd/iutGL7UL9S6wDIzyJI+2FlCKLC2EBXatbbzIdVSXB3EFS0X6IA+EEomUOjVZ0RJlKaU+B22tHPR3ffdTT4aCYim+BDeekuwx0c1fAtyOqokq9qQDsLBYn507qB70KpsOj9UCWVLw43OvIvN1buqRun6HeWbcMWfCivWW0ap+/MgQtE8XST+PTlx+3k87h2wf/oGExAmhTY8/c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(54906003)(38070700005)(38100700002)(4326008)(64756008)(8676002)(66556008)(66446008)(66946007)(66476007)(122000001)(316002)(6916009)(6486002)(71200400001)(76116006)(508600001)(2906002)(2616005)(186003)(8936002)(5660300002)(86362001)(15974865002)(6506007)(26005)(83380400001)(6512007)(44832011)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHZvTEZZVCtLZjJqa05rQ0c5OTdvQXg1YzlIUFdwek5FZ1R4Q09xKzZOMTJY?=
 =?utf-8?B?YW9FSTRwUVVRaUVFMWhRRi90aHBMQW5CQnZqNmNCNkZJMytMWFArZDhUZ3No?=
 =?utf-8?B?SXN5bVlvOWdkQkxUNTlnSjd2alE2UU9Pem5uVzV0bWpnaHFFbTJWRlB2Q01Z?=
 =?utf-8?B?eWpFNVByMHFFSFlYRzh1ZzlYN0YvUzV0TlI1RGcvNWVCK2RtRktWY3htbjdr?=
 =?utf-8?B?R1JnR2w2L2NWdWl3bUVZSjVhaFVrcFdHNTlmKzRoaDlVYXBrVlBpTU4zNC9l?=
 =?utf-8?B?Yko3UmlMcVJJZmN6eXpGdkZUSmhYb081TjY1TWRWS0dmTjArd0ZuYjc3L2pj?=
 =?utf-8?B?blZGeGwrNjVYYUdJUS9zaFJFM0NpZmxFUHVJeXUrZFZtQjZFU3BzRGRaZjNj?=
 =?utf-8?B?SVBDaFpiWE9zWFh6MEEwR25TSFQ3bUtIOUFxMmZPbGJLMnhqTWxPaVFuN3Ra?=
 =?utf-8?B?d1MwaXMxbmFmTVY5ZzVGL1lIZlh4Z1IrZm1scXlONTgwOHJXajAxWVU3a0Mr?=
 =?utf-8?B?bDF2ekdnMmRQRGQ4alVUL2UrMjBSSXVKc3h3UmcxOGYrV1FRUU1hTEZWaUlP?=
 =?utf-8?B?K0FWQkQ5Yzd6YnRKNHB0b3pvY1FKQ2lHdFN6N3FscElDSkdGUUtKMXVvTEh0?=
 =?utf-8?B?OFpzZEV6ZllWS1JjZHNIcU1QMDRpUE9LNkdScXYwYS9tYnNhNXk4dzc4Qmlx?=
 =?utf-8?B?ZUtvc1A3UGtiQkozS0JmY0tmb2dzbFZ0ZGhzV1FvdzMzdjF0SlRIY1EraS9B?=
 =?utf-8?B?cDhXejgvY3pRTy94UDY5Y01XZzAwODB4OGgrUndzQVNMbjhsVy9aT0hXTE8y?=
 =?utf-8?B?NFZUb2ZaS3FValJCWkl5eHYxVmRwcVc5czVNSEdwVHVaaE9Ua1I0andKelVV?=
 =?utf-8?B?SVZlNG1OSlJqdHY5azNHdENiQXZ0RzJrQU1nbEhmWHFxbThKZkNUWjJrODkv?=
 =?utf-8?B?MWVtTi9YUXRXRlJkSWlsNjFNK21VdDV6N3lFUnhvU3FPb3pna1ZjcHlpVjh2?=
 =?utf-8?B?dHp3MDV6L0VhbDJHTUdkWGF4NWR1OU1RYU9DT1hUVEV0aTRrUDNxWmpOc2tt?=
 =?utf-8?B?YldtTkFrbmtmQlhPcGFVT0RsM0daK3FLbE1wTmR5V3ZsUWE5RnNBOEdsbmtt?=
 =?utf-8?B?UExMRWtmTVlOZnBmbGdVOUJMYmFvSjJUOXlqaVZJYmlndE00UTJZdS8rcDhl?=
 =?utf-8?B?L1RaTmhNOU43N2FEelFuaHM3NHZPa2taZ1RkVkdTajRqZFBiQ1Q0clBMQTUy?=
 =?utf-8?B?NjUzbDRpS2V0VkJKaStWSGkzOXh1Z2x0cC9WbWtTL0U3Y0tVU3Fud2txaU1T?=
 =?utf-8?B?UjlYbUo0bXNBUFE1d0ZHT2hYUExlQWRGRmlhZVRrZU4wcytFS0RSZnJXMi9C?=
 =?utf-8?B?WHVsckJmZlJnVSs0WjlZUjFtZ3pPU0FkdmhjWkJZYUpOSllvUmFJY01QVGU0?=
 =?utf-8?B?RzJTNzcwdFZzNHd2SCt0bHhJT1NPOHNldHJaZVJaTXhqcHd1SE5XOWdKcThQ?=
 =?utf-8?B?OEg5cCtjVkU1cHpyUktTRUVRdlNPRS8xL2xCQXVMYXdTU2FyRVRMVktqWTNv?=
 =?utf-8?B?U04vZUEzUXZuZDBPaXVvMUt6SEF3TFNrSXVlbTZvbXZ2K2pROXFXcHpmd09m?=
 =?utf-8?B?emJXQXdXU1VqSlZLTW8rMzhZc0lEOFFmRFdYaE1pWDNKS0NWeFVzTms5MGln?=
 =?utf-8?B?STJTNUVUSGN1bzZNaW1TNW5IV2hkengweXh3Ny8xQng4RlB4dHFQRGplUHY1?=
 =?utf-8?B?WGZiT0grcUtoV2hiYndZWG15aSt0Q2kyZVQ0eWFxUEE0SzV4Qy9XeGNyMTBR?=
 =?utf-8?B?RjJuVS9VQXVBZEM1NUlXdm9DSHZ5WVVORzFVN2N0Mnh1R3crNFdqSzZZQTdr?=
 =?utf-8?B?em1RQWpBVlRuWnl2VmxsMzNuNFpGeGNNU21PSElFTGZyVmtZUENYcGlTM0NH?=
 =?utf-8?B?NFBUaUNZbzJxUzRLRDhiSnFPQ042ZDIzeC95eE5BbVczRlEzME1rTzUzNlRl?=
 =?utf-8?B?c3lILzl1eHF5Y21QcXVoRlY1a0htWnJtcG4yOFZSOFI0bnlYTGhsc3Brd2ht?=
 =?utf-8?B?VVhiOW9XZkl2L0srU045cE9yRlhTa0ZhMDdNWWxDTThCTkZkSnNiZFdHWGJi?=
 =?utf-8?B?WGFDcjBhQnVzVEtKL2VSRHArVnBuT0k3a2xlYW45OEZ2a0VBZTloV0xUcmFt?=
 =?utf-8?B?SmxGdlhuWXhVSytNOG9xUWNoN3VPdU1yUmNLLzIrcWdzZ05Ha215QWcxdkxi?=
 =?utf-8?B?QWk4dVpac21LUEJyd2JrdUUxVTRFbnlZNDQ3ZjJ6cWtQbC9ON0EwODFZVXlX?=
 =?utf-8?B?dzdLUFJwVStWWHdRSDlXS2kyV3VLTkFkTm1JeG9nZE1MbkhkMVgxZktMa09o?=
 =?utf-8?Q?OkQP0qoFmB1ozrWsqqMjtV3cqHkRngIDDzLOM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD4F2769F1B1C749B1EC7BE1DCCEBAFB@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fdedfe85-b990-486d-a80c-08da2ec8fdba
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 18:56:41.1395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vMJwqN62EiBP8raNPR7LB7DjsifqbhBAHQ8IfO3ZgOWr+7Dlr1i/kd3RnOGyGLAp6/EWnsGI6PQF2f8TN+Wbir5WDa4/Ee3ZrhtI7fo77+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4960
X-Proofpoint-GUID: L4dEBW_dUxU8TZipgsbqTouJ8MmNG-Ka
X-Proofpoint-ORIG-GUID: L4dEBW_dUxU8TZipgsbqTouJ8MmNG-Ka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_06,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxlogscore=534 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050125
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA1LTA1IGF0IDExOjA4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA1IE1heSAyMDIyIDE3OjMzOjM5ICswMDAwIFJvYmVydCBIYW5jb2NrIHdyb3Rl
Og0KPiA+IE9uIFdlZCwgMjAyMi0wNS0wNCBhdCAxOToyMCAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+ID4gPiBPbiBNb24sIDIgTWF5IDIwMjIgMTk6MzA6NTEgKzAwMDAgUmFkaGV5IFNo
eWFtIFBhbmRleSB3cm90ZTogIA0KPiA+ID4gPiBUaGFua3MgZm9yIHRoZSBwYXRjaC4gSSBhc3N1
bWUgZm9yIHNpbXVsYXRpbmcgaGVhdnkgbmV0d29yayBsb2FkIHdlDQo+ID4gPiA+IGFyZSB1c2lu
ZyBuZXRwZXJmL2lwZXJmLiBEbyB3ZSBoYXZlIHNvbWUgZGV0YWlscyBvbiB0aGUgYmVuY2htYXJr
DQo+ID4gPiA+IGJlZm9yZSBhbmQgYWZ0ZXIgYWRkaW5nIFRYIE5BUEk/IEkgd2FudCB0byBzZWUg
dGhlIGltcGFjdCBvbg0KPiA+ID4gPiB0aHJvdWdocHV0LiAgDQo+ID4gPiANCj4gPiA+IFNlZW1z
IGxpa2UgYSByZWFzb25hYmxlIGFzaywgbGV0J3MgZ2V0IHRoZSBwYXRjaCByZXBvc3RlZCANCj4g
PiA+IHdpdGggdGhlIG51bWJlcnMgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLiAgDQo+ID4gDQo+ID4g
RGlkbid0IG1lYW4gdG8gaWdub3JlIHRoYXQgcmVxdWVzdCwgbG9va3MgbGlrZSBJIGRpZG4ndCBn
ZXQgUmFkaGV5J3MgZW1haWwNCj4gPiBkaXJlY3RseSwgb2RkLg0KPiA+IA0KPiA+IEkgZGlkIGEg
dGVzdCB3aXRoIGlwZXJmMyBmcm9tIHRoZSBib2FyZCAoWGlsaW54IE1QU29DIFpVOUVHIHBsYXRm
b3JtKQ0KPiA+IGNvbm5lY3RlZA0KPiA+IHRvIGEgTGludXggUEMgdmlhIGEgc3dpdGNoIGF0IDFH
IGxpbmsgc3BlZWQuIFdpdGggVFggTkFQSSBpbiBwbGFjZSBJIHNhdw0KPiA+IGFib3V0DQo+ID4g
OTQyIE1icHMgZm9yIFRYIHJhdGUsIHdpdGggdGhlIHByZXZpb3VzIGNvZGUgSSBzYXcgOTQxIE1i
cHMuIFJYIHNwZWVkIHdhcw0KPiA+IGFsc28NCj4gPiB1bmNoYW5nZWQgYXQgOTQxIE1icHMuIFNv
IG5vIHJlYWwgc2lnbmlmaWNhbnQgY2hhbmdlIGVpdGhlciB3YXkuIEkgY2FuIHNwaW4NCj4gPiBh
bm90aGVyIHZlcnNpb24gb2YgdGhlIHBhdGNoIHRoYXQgaW5jbHVkZXMgdGhlc2UgbnVtYmVycy4N
Cj4gDQo+IFNvdW5kcyBsaWtlIGxpbmUgcmF0ZSwgaXMgdGhlcmUgYSBkaWZmZXJlbmNlIGluIENQ
VSB1dGlsaXphdGlvbj8NCg0KU29tZSBtZWFzdXJlbWVudHMgb24gdGhhdCBmcm9tIHRoZSBUWCBs
b2FkIGNhc2UgLSBpbiBib3RoIGNhc2VzIHRoZSBSWCBhbmQgVFgNCklSUXMgZW5kZWQgdXAgYmVp
bmcgc3BsaXQgYWNyb3NzIENQVTAgYW5kIENQVTMgZHVlIHRvIGlycWJhbGFuY2U6DQoNCkJlZm9y
ZToNCg0KQ1BVMCAoUlgpOiAxJSBoYXJkIElSUSwgMTMlIHNvZnQgSVJRDQpDUFUzIChUWCk6IDEy
JSBoYXJkIElSUSwgMzAlIHNvZnQgSVJRDQoNCkFmdGVyOg0KDQpDUFUwIChSWCk6IDwxJSBoYXJk
IElSUSwgMjklIHNvZnQgSVJRDQpDUFUzIChUWCk6IDwxJSBoYXJkIElSUSwgMjElIHNvZnQgSVJR
DQoNClRoZSBoYXJkIElSUSB0aW1lIGlzIGRlZmluaXRlbHkgbG93ZXIsIGFuZCB0aGUgdG90YWwg
Q1BVIHVzYWdlIGlzIGxvd2VyIGFzIHdlbGwNCig1NiUgZG93biB0byA1MCUpLiBJdCdzIGludGVy
ZXN0aW5nIHRoYXQgc28gbXVjaCBvZiB0aGUgQ1BVIGxvYWQgZW5kZWQgdXAgb24NCnRoZSBDUFUg
d2l0aCB0aGUgUlggSVJRIHRob3VnaCwgcHJlc3VtYWJseSBiZWNhdXNlIHRoZSBSWCBhbmQgVFgg
SVJRcyBhcmUNCnRyaWdnZXJpbmcgdGhlIHNhbWUgTkFQSSBwb2xsIG9wZXJhdGlvbi4gU2luY2Ug
dGhleSdyZSBzZXBhcmF0ZSBJUlFzIHRoYXQgY2FuDQpiZSBvbiBzZXBhcmF0ZSBDUFVzLCBpdCBt
aWdodCBiZSBhIHdpbiB0byB1c2Ugc2VwYXJhdGUgTkFQSSBwb2xsIHN0cnVjdHVyZXMNCmZvciBS
WCBhbmQgVFggc28gdGhhdCBib3RoIENQVXMgYXJlbid0IHRyeWluZyB0byBoaXQgdGhlIHNhbWUg
cmluZ3MgKFRYIGFuZA0KUlgpPw0KDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdh
cmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4uY29t
DQo=
