Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7B4D277B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiCICSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 21:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbiCICSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 21:18:02 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0C5E0A;
        Tue,  8 Mar 2022 18:16:34 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22921lIL028672;
        Wed, 9 Mar 2022 02:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=OMhzTUZ/+4D5ueVu6u1BQ/6EUH8eCWzGnrq8uV07umc=;
 b=Er/n0zygKztXRrcEhmwCBWzwwTboFrL209Jlp6cE6qtvmMHPa4qdjioiyF+1gvi7Fjmz
 EDHu9YYbG2FaQhQqrs1seObVH+97i27IIi+rmY/jKXNoCBxnoYdVKrN7VEEaQva7b1IE
 N127B1qUBuijnezrXLw1pSDC56K9EUhfd+LRdwk1hczKA2MKvNuK+Qf9W/fK/oAmPnZ2
 OovVLVOEP37hy11MfZCIwi/fD7N9lm3FYFc7H0YikHDq7uKlmoXjiergRhjZtWni/zNN
 9OhP4j30jL/ZMlW7EQZLpUg90jffQWYzDGpvjeZ6dgT1C0tLyRWMzqO9caS/nb9R+U13 1A== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ekxu8311n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 02:16:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXBXBsjchLw1dqvkxQ67aqxHrLzQQAvstdPmHDRTtla3z0NICiUEIHMmDFZ2D6pNOVmgAHpxNF4EILCahrKoqSsEHswsr15GgnO+aJxyRypAuzbRywkS5IPmywcWjslLa+sccYLLoZVhzs1NKhP6O7SuMRKPJL8CWgiJF6yLvXKSSaGLutEJislHn6aYYEYca3drWbT8CbGOQrrp5LoQgG7fE8c/vWu4UWeXII5mh5ogPukpmF9w//O5Bg2lFzcsBB25qKoAMNZmeHGTSLCvrlMR881r8zIP4TSS5+H/6NYQwr89Q2vLpcwGYG7E/oFqG8tQ28YjsHlCVgfvGNQt+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMhzTUZ/+4D5ueVu6u1BQ/6EUH8eCWzGnrq8uV07umc=;
 b=O8L9tsojktcv39xfYwWAmmLUDz0tY5ggF0eoiWeQk9icvJ8lb4H/EcOY2muVZfimGx0ZmIwR9xG08SjVI1BVIm9FoQzubqVEvJWRunLEUVAcHygHiO+NynkK6YcTx+Rv+K9xmxlBMI+NImuYfM2KzTjanlnUH8L0j7m+8OAr1FZlqlaqgyeBUo/iXnIA+mjQLWN9heQjH4N4hd/cKnltQ2X6q2coQ3Q9tqshJUJpPMyvmy2jrobbc/Upxi1UFhUQ9rXI39TBh0M1wrxuLVynSIDUOiy3I7vYnODekWl29RyLnrCpZLqbWKopQkVaG6YBL6OVb6d48e9knjogOZvL4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB5120.namprd11.prod.outlook.com (2603:10b6:a03:2d1::13)
 by BYAPR11MB3111.namprd11.prod.outlook.com (2603:10b6:a03:90::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Wed, 9 Mar
 2022 02:16:12 +0000
Received: from SJ0PR11MB5120.namprd11.prod.outlook.com
 ([fe80::8017:c38b:eb2b:28f4]) by SJ0PR11MB5120.namprd11.prod.outlook.com
 ([fe80::8017:c38b:eb2b:28f4%4]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 02:16:12 +0000
From:   "Xiao, Jiguang" <Jiguang.Xiao@windriver.com>
To:     David Ahern <dsahern@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Pudak, Filip" <Filip.Pudak@windriver.com>
Subject: RE: This counter "ip6InNoRoutes" does not follow the RFC4293
 specification implementation
Thread-Topic: This counter "ip6InNoRoutes" does not follow the RFC4293
 specification implementation
Thread-Index: AdgjHkb8kp0sEn6JQ1icxeGMRY2HXQAAIjdwAABijTAAACgXIAAiXNUAAWtW3lACgJFT0A==
Date:   Wed, 9 Mar 2022 02:16:12 +0000
Message-ID: <SJ0PR11MB51209DA3F7CAAB45A609633A930A9@SJ0PR11MB5120.namprd11.prod.outlook.com>
References: <SJ0PR11MB51207CBDB5145A89B8A0A15393359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51202FA2365341740048A64593359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209200786235187572EE0D93359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB5120426D474963E08936DD2493359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <bcc98227-b99f-5b2f-1745-922c13fe6089@kernel.org>
 <SJ0PR11MB5120EBCF140B940C8FF712B9933D9@SJ0PR11MB5120.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5120EBCF140B940C8FF712B9933D9@SJ0PR11MB5120.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0901c2d-1029-4ba5-a153-08da0172c81a
x-ms-traffictypediagnostic: BYAPR11MB3111:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3111A34945D4B39C7F041FA3930A9@BYAPR11MB3111.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zr4MgQoCbaRj13nwYs+wMLC/lLIf4kjgbhI+VJ/p5XOQlOC4lZzI1WzlnTYqtNR6hME5yRnYSORllo16dNXxthsqHMDYj4KU5qr7QIFsyMESv6NytSykrVtVnjqkTY7xVNnr1+1+10vHaFJQv64sRO/QQqOx/qcYMJKtQRDuKx/9eT4m22D+u9rNBKvyGShJs+hZqDJgFPwz8dHb+z/g7tYEGRmSqPzd8YK7cDlTjhQJaUDve68z9T/wjsmbAA68Ll6WbM0g3MCbRPzt3bBPAiWetfDZEZXZfmPgJ7X8Fu41Za5bVD8SVdYOlRpWBUQjKCt/tEtvNf3OdIxgYk2hAMsTbQwW+SbH6SKKuvt6BBEUqcmkh6cfWon4DGGyPZitcvx9+cZFbl3VNq5bWEZBcuAC39oCZKvYNnHxq1FITmlODZBYorwsinMalW1Zz0n8oGL8me1nikcRA2OX0EdNzso5JRri3lvUaqRrdzHOM14tmsq+VbX1An5X6Dd6UIbSBzbg7ahaZD0ICCFL4QRfFpiMEh97dWixGZxubaaU6RIupS9uDTWj806VxFIeVFDRfjC5s9b85S5SWpYzaDzZiJgWZslrujg3dwW2+vZFfdnwdCHQjE53nBoY0/ftnyiFwMWzU/mkp8jztKZvi1T3iH9OQXbdZdC37lu+ekQBcuVXM3LNr/HiNkJsXcS8FVbzamFximszHBmuO7WqXGd0BA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(366004)(38100700002)(33656002)(38070700005)(71200400001)(26005)(2906002)(110136005)(107886003)(186003)(316002)(6506007)(53546011)(86362001)(9686003)(122000001)(55016003)(83380400001)(7696005)(8676002)(66946007)(66556008)(66476007)(66446008)(64756008)(5660300002)(76116006)(4326008)(8936002)(52536014)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDlhNml0TU5xenJQQXgvdHM1UDBmQW9Eb3pXS09KWlQwamxybUN2RzRFQ2tm?=
 =?utf-8?B?ck1ja0VsN05IUm1oYVlnb0NBenpFTFcwZjhXeTVpd3hXY3ZtVGhPWXRHRU1L?=
 =?utf-8?B?SUhWK1huM3VtaHJFM0g4bnVOa01WTWVCRHRUckJ5UHQyNW55OTBIYmlUZDM0?=
 =?utf-8?B?WC9KbHBBWW9aY0pYeXdVc3VUdXRVU3hBVUMxdmlhdE4vcC9RRjduQzJoZGNT?=
 =?utf-8?B?bjVqeHV0VjJoclJhUTVJVFFrRGl5TXdxdFdNSWlTd3orMnVML2J3amN4ZFkw?=
 =?utf-8?B?MUo2Mm80UnpLMXhLeCtRdDBwTi9MSk13Q2JPdzBmOHc3NmtYUGc1N0wwdmxT?=
 =?utf-8?B?Z2x1RXpPZ0FDWUhjbEdvek5QbWZMQm5tNTVmTDFWT1JXZEpHeE1PMUJQRUUw?=
 =?utf-8?B?bmxkU1BDcnhYM2hKN3FBMHlURHppdFpxazlzK3BOd2wyMFBIVjcrMjdKRk01?=
 =?utf-8?B?SlUrUGt3TnlNUlBQUE1mUmlNYUlWVkxRK0lTWWdxUmVPUm5QMjFTRU9lY3NV?=
 =?utf-8?B?OFNBMUgvV1BMM0Jnd040VWRNZ3dxUGJzUFVHSkc3bUpWVmJFOXk1ZS9wVnZS?=
 =?utf-8?B?QVFkbWtFczliVExFbG9WTkNLRFZjTkZoQ0lwc0pYN3MydlUrK1RDVUtsQzM3?=
 =?utf-8?B?cVNNK2VzMm1UaWRYN3FqZlo1UUJZNVZ5dEpZYUN4c2RoRE5WL051K0d1RnVp?=
 =?utf-8?B?b3N3amVxd3pZMnhOdXJ3RkVrRGZEd1VCa2pKaENzbEUzS1NJMTNrbmVzTllY?=
 =?utf-8?B?d3Q1U2x3MUJyZ01wdmR2dWdJN2FVR1EwZysrWFEyYWlCV3NzTUFiQjZTTXhG?=
 =?utf-8?B?THppOFVseGZwUHJaUG0vMVhKZXRXR1ZuMlRrUEdTbG5MWndiWnBHYWZIV09v?=
 =?utf-8?B?bGRYb2p6Q1NoR3NWamNESnd2RlZjMjVmQmFVd3NUeVJ2QTNYSFNjWHE1eVc2?=
 =?utf-8?B?ajgxV2VpZW45MzRxKzJidkFyd2VkT0YrYWU1K1dhYTNzSktVcDZ2NHlZRE5U?=
 =?utf-8?B?M0dzZlhKbHBhaHhQYmFpVG1XZU5lMWVydU5acEVBMXZTNXNnS0RSVTBFUkJM?=
 =?utf-8?B?MFQ1NDcxb2J6TVc2ZGJoZ1d0b2lMbkFPMmFIS1hrVUM5ZjdadWZ1Q3h5Tlds?=
 =?utf-8?B?NHF6M0YyM0ZNdEg5RUVUeEpmN2V0UjljYnc1bXpkRWFtcENZWWZjek9QQ1Vx?=
 =?utf-8?B?a2xGWEFjNFFzQnRQYm1uOWR1WVlmY3ZZUkdxTktIamJ6VTVoa2Q1TGsxcUZV?=
 =?utf-8?B?OGxyN05GYlNhVGd4Wlg0YlBSSlh1SXJOTWZzelJIZUovb0N2UnBnaVYwY01h?=
 =?utf-8?B?MUlUTnFncENKRHFySGw1K1A3OWkweWI2VDRXdnM2TzRHNzd0dll0R05GMjRs?=
 =?utf-8?B?MmxNbFJYajRaSzVnN0YrNVR4RHg4OG1DcXFGUGpvRXdteTVxWWxMTG1nV2Yv?=
 =?utf-8?B?R1BkM2ZNV1RFOEVEb3U3clVLb25SYnZteWZJWm1KSWV5OFVadDRWTklyc0tR?=
 =?utf-8?B?SHJDUWtGZ2VCYnRnOGdhZnNuVkZwRDF6aWhyd2NyZE5KSWlqU1g5cHlOeVJh?=
 =?utf-8?B?TnB2cnFEckdRSHVHdE5DaHR2K2psN2VTQVhlaTZxcjQxblY4K09DMXE4RDF6?=
 =?utf-8?B?Q20rdTk2VGtySi9DWTN5NlhRZS9CMTJjVVZtZHpnWWpDNC90SlZqZ0lWand0?=
 =?utf-8?B?WHFDMzZ6ZEJWN0U0eGFsWmEvODJDb2dZNDR3YVhnNU5VNElxMDBQV1doNDJ2?=
 =?utf-8?B?R2tCMUFOalVRcnVBNkFoRWxRY0RmRnNyZ3laMFZzdER6S3hzdngzcXRJUTBo?=
 =?utf-8?B?c2RlNzVSbFcxK0RlRnc2cVpoYjdaaXV5ZVluVHlmb0VGM0ltMHpYa3M0dWw0?=
 =?utf-8?B?R09ucHZ2bnBxK2pGU3VhUnJVcUQxeWtvaEg0RytSelpud0JNMTlXbUFEekJl?=
 =?utf-8?B?Y0ROTGZoR2luWFNuZ0NrdWFUU0NvNitMTVNlRFluMjBGMk5zVTZVRTd0ZUFN?=
 =?utf-8?B?MHBWWFVHWTQyOGNCQjQraEozMU1BaHJ5T3BIamtSWWJPUlVUcStwbGNTcWdh?=
 =?utf-8?B?SC9IODFCOHFDRUxENmtZMjVnb0FmQ0NJbThjU1ZHUnF1VjNKWlp2MVNEdmtp?=
 =?utf-8?B?b254Vkh6eEowUmZrSWhrNlNUbnZKZCtMaDc2aUN1QThkaDdDencxNzYrRTc0?=
 =?utf-8?B?S1ZYbTRxV1NDeWo5VnU1d0JRQUR1dUhXTjZnNi82bXU1U2xGdkpjZnJsVHdz?=
 =?utf-8?B?RDZWVUtXRm5vQnY3TlZ4NUt0SEN3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0901c2d-1029-4ba5-a153-08da0172c81a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 02:16:12.0340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: inZWM/JqBJOPmQoTy1GxVHCxQClwAFl1i6DJjrF3akY4mau1M+ZN5csIyUrbC19FfQ+MX86CShystwV91OnDr+G9H9zGl1DR/KMEgznGZWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3111
X-Proofpoint-ORIG-GUID: 3HCgzhoEBo0yLmc5voUM6xar7Pr5t50j
X-Proofpoint-GUID: 3HCgzhoEBo0yLmc5voUM6xar7Pr5t50j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 clxscore=1011
 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090010
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQNCg0KVG8gY29uZmlybSB3aGV0aGVyIG15IHRlc3QgbWV0aG9kIGlzIGNvcnJlY3Qs
IGNvdWxkIHlvdSBwbGVhc2UgYnJpZWZseSBkZXNjcmliZSB5b3VyIHRlc3QgcHJvY2VkdXJlPyAN
Cg0KDQoNCkJlc3QgUmVnYXJkcw0KWGlhbyBKaWd1YW5nDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQpGcm9tOiBYaWFvLCBKaWd1YW5nIA0KU2VudDogMjAyMuW5tDLmnIgyNOaXpSAxNzow
NA0KVG86IERhdmlkIEFoZXJuIDxkc2FoZXJuQGtlcm5lbC5vcmc+OyBkYXZlbUBkYXZlbWxvZnQu
bmV0OyB5b3NoZnVqaUBsaW51eC1pcHY2Lm9yZzsga3ViYUBrZXJuZWwub3JnOyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpDYzogUHVkYWssIEZp
bGlwIDxGaWxpcC5QdWRha0B3aW5kcml2ZXIuY29tPg0KU3ViamVjdDogUkU6IFRoaXMgY291bnRl
ciAiaXA2SW5Ob1JvdXRlcyIgZG9lcyBub3QgZm9sbG93IHRoZSBSRkM0MjkzIHNwZWNpZmljYXRp
b24gaW1wbGVtZW50YXRpb24NCg0KSGkgRGF2aWQNCg0KVGhhbmtzIGZvciBndWlkaW5nIG1lIGhv
dyB0byBwcm9jZWVkLiBJIGhhdmUgY2FwdHVyZWQgdGhlIG91dHB1dCByZXN1bHQgb2YgcGVyZiAo
cGVyZl9vdXRwdXRfNS4xMC40OSkuIA0KDQpUbyBjb25maXJtIHRoZSBwcm9ibGVtLCBJIHRlc3Rl
ZCBpdCBhZ2FpbiBvbiBVYnVudHUgKGtlcm5lbCB2ZXJzaW9uIGlzIDUuNC4wLTc5KSB1c2luZyBE
b2NrZXIgYW5kIHRoZSByZXN1bHRzIHdlcmUgdGhlIHNhbWUsIHRoZSBvbmx5IGRpZmZlcmVuY2Ug
aXMgdGhlIGtlcm5lbCB2ZXJzaW9uLiBJIGFsc28gY29sbGVjdGVkIHRoZSBwZXJmIHJlc3VsdHMg
YW5kIGFkZGVkIHRoZW0gdG8gdGhlIGF0dGFjaG1lbnQgKHBlcmZfb3V0cHV0XzUuNC4wKS4NCg0K
DQoNCkJlc3QgUmVnYXJkcw0KWGlhbyBKaWd1YW5nDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBrZXJuZWwub3JnPg0KU2VudDogMjAyMuW5
tDLmnIgxN+aXpSAxMTowMA0KVG86IFhpYW8sIEppZ3VhbmcgPEppZ3VhbmcuWGlhb0B3aW5kcml2
ZXIuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgeW9zaGZ1amlAbGludXgtaXB2Ni5vcmc7IGt1
YmFAa2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFRoaXMgY291bnRlciAiaXA2SW5Ob1JvdXRlcyIgZG9l
cyBub3QgZm9sbG93IHRoZSBSRkM0MjkzIHNwZWNpZmljYXRpb24gaW1wbGVtZW50YXRpb24NCg0K
W1BsZWFzZSBub3RlOiBUaGlzIGUtbWFpbCBpcyBmcm9tIGFuIEVYVEVSTkFMIGUtbWFpbCBhZGRy
ZXNzXQ0KDQpPbiAyLzE2LzIyIDM6MzYgQU0sIFhpYW8sIEppZ3Vhbmcgd3JvdGU6DQo+IEhlbGxv
LA0KPg0KPiBJIGZvdW5kIGEgY291bnRlciBpbiB0aGUga2VybmVsKDUuMTAuNDkpIHRoYXQgZGlk
IG5vdCBmb2xsb3cgdGhlDQo+IFJGQzQyOTMgc3BlY2lmaWNhdGlvbi4gVGhlIHRlc3Qgc3RlcHMg
YXJlIGFzIGZvbGxvd3M6DQo+DQo+DQo+DQo+IFRvcG9sb2d5Og0KPg0KPiAgIHxWTSAxfCAtLS0t
LS0gfGxpbnV4fCAtLS0tLS0gfFZNIDJ8DQo+DQo+DQo+DQo+IFN0ZXBzOg0KPg0KPiAxLiBWZXJp
ZnkgdGhhdCDigJxWTTHigJ0gaXMgcmVhY2hhYmxlIGZyb20g4oCcVk0gMuKAnSBhbmQgdmljZSB2
ZXJzYSB1c2luZw0KPiBwaW5nNiBjb21tYW5kLg0KPg0KPiAyLiBPbiDigJxsaW51eOKAnSBub2Rl
LCBpbiBwcm9wZXIgZmliLCByZW1vdmUgZGVmYXVsdCByb3V0ZSB0byBOVyBhZGRyZXNzIA0KPiB3
aGljaCDigJxWTSAy4oCdIHJlc2lkZXMgaW4uIFRoaXMgd2F5LCB0aGUgcGFja2V0IHdvbuKAmXQg
YmUgZm9yd2FyZGVkIGJ5IA0KPiDigJxsaW51eOKAnSBkdWUgdG8gbm8gcm91dGUgcG9pbnRpbmcg
dG8gZGVzdGluYXRpb24gYWRkcmVzcyBvZiDigJxWTSAy4oCdLg0KPg0KPiAzLiBDb2xsZWN0IHRo
ZSBjb3JyZXNwb25kaW5nIFNOTVAgY291bnRlcnMgZnJvbSDigJxsaW51eOKAnSBub2RlLg0KPg0K
PiA0LiBWZXJpZnkgdGhhdCB0aGVyZSBpcyBubyBjb25uZWN0aXZpdHkgZnJvbSDigJxWTSAx4oCd
IHRvIOKAnFZNIDLigJ0gdXNpbmcNCj4gcGluZzYgY29tbWFuZC4NCj4NCj4gNS4gQ2hlY2sgdGhl
IGNvdW50ZXJzIGFnYWluLg0KPg0KPg0KPg0KPiBUaGUgdGVzdCByZXN1bHRzOg0KPg0KPiBUaGUg
Y291bnRlciDigJxpcDZJbk5vUm91dGVz4oCdIGluIOKAnC9wcm9jL25ldC9kZXZfc25tcDYv4oCd
IGhhcyBub3QgDQo+IGluY3JlYXNlZCBhY2NvcmRpbmdseS4gSW4gbXkgdGVzdCBlbnZpcm9ubWVu
dCwgaXQgd2FzIGFsd2F5cyB6ZXJvLg0KPg0KPg0KPg0KPiBNeSBxdWVzdGlvbiBpcyA6DQo+DQo+
IFdpdGhpbiBSRkM0MjkzLCDigJxpcFN5c3RlbVN0YXRzSW5Ob1JvdXRlc+KAnSBpcyBkZWZpbmVk
IGFzIGZvbGxvd3M6DQo+DQo+ICAg4oCcVGhlIG51bWJlciBvZiBpbnB1dCBJUCBkYXRhZ3JhbXMg
ZGlzY2FyZGVkIGJlY2F1c2Ugbm8gcm91dGUgY291bGQgDQo+IGJlIGZvdW5kIHRvIHRyYW5zbWl0
IHRoZW0gdG8gdGhlaXIgZGVzdGluYXRpb24u4oCdDQo+DQo+IERvZXMgdGhpcyB2ZXJzaW9uIG9m
IHRoZSBrZXJuZWwgY29tcGx5IHdpdGggdGhlIFJGQzQyOTMgc3BlY2lmaWNhdGlvbj8NCj4NCj4N
Cg0KSSBzZWUgdGhhdCBjb3VudGVyIGluY3JlbWVudGluZy4gTG9vayBhdCB0aGUgZmliNiB0cmFj
ZXBvaW50cyBhbmQgc2VlIHdoYXQgdGhlIGxvb2t1cHMgYXJlIHJldHVybmluZzoNCg0KcGVyZiBy
ZWNvcmQgLWUgZmliNjoqIC1hDQo8cnVuIHRlc3Q+DQpDdHJsLUMNCnBlcmYgc2NyaXB0DQo=
