Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7343F5211E5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbiEJKPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiEJKPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:15:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E4A1CC9AC;
        Tue, 10 May 2022 03:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652177478; x=1683713478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/olNCtPnSdhmYt7b0bFruUCGoSsW+sIBhePNzr4Bslc=;
  b=YSPQ6CKNmPOQQwBc77ETf3+nJyu5hK2aVBCv2ckdlaKsyNLzm2XsInTq
   IgGOWripWYuzTKI6waBjKJTgXIN5fTdwaQQZOzC6yidcUwLVOwLFApRsN
   yVvMCzRS1tacQ3EaCKJlbPo8vpcTOBmrpU0wbiiBhAXAjo8n+f/5meQpG
   7COlRsEPIA/pZ7i+YkRVI3N8MqI36kYWL2F5dxjz2NtveToaCMpkq/akf
   CA1OEzPAFH7axGk8C6VkaDV7RwNWqbmqUowRuNJvMSUGMq6ZSpV48+V07
   1+LpDkKLWJWJODTb3um0lnuPq9oC3rbxLUYQdDc/25c7BeD+Ix74dd9yI
   A==;
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="163383341"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 May 2022 03:11:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 10 May 2022 03:11:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 10 May 2022 03:11:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6IE59lNlNLNT6Ur+95NJTwur3eFzzuMi8/sbJY/XInobmVvk62WbSGakgE317KapthfDPMXSpBgD5QCnFMQ6ixww30Va5LDd1VaTcDHNJOgYDvipsQh6wK4OzdgxQM2xHW9CiiW6zEBHOAWvE1Fq+2idoL9EN4f2S8d6oYs5xSaiPnVKYoqTsOzxsW8+BGu/1omijdroqQAP76E8SBHSlWsRebEsO0x2hy9J2ay425D9JSubCBJKxleaYFslWroYl6jaJHI7y1qxsR6mvqqES4+x1PqxFsy7lmTZuwlq48RWouaFpEIEXVHJ33MQOW3otoZ/pfJ2tcNkZwYXzMQvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/olNCtPnSdhmYt7b0bFruUCGoSsW+sIBhePNzr4Bslc=;
 b=hy25sEF/CcVRW4npW/Vu/gyyHHeGFgCNfrI+IDEtJvOzulk0Bqu635kS7ZF9M4vv1GdNzYvkJ1EAzScMRuA8kOPq5PFbGV/U43s3XImTp/R+Eli6jodtR83r1FNVE1hzH3ShqFyQ8vzzO6/8pcZzntVrfT3xCvcYXaFrHUmNzPMayGjjrnJiL7GA2/BnmVfwcw6ZV+fvApvY0X+Y8dE4U+emql1B+rjbXswyhf35sZrPCQLkbmy5c5VlNpQE76CsVF2ebFMs0WJWO8LUr4+ZN0guoXj7pqoDGeqcmvbYQdFZ8lFl5VAY6DRiO0kExt5hKNlMaqU+1N8HUUP1bd8d0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/olNCtPnSdhmYt7b0bFruUCGoSsW+sIBhePNzr4Bslc=;
 b=uHr4FH+1YtKGM10y1WytDPhNaasa19rAfieinwc4dp3EEr9CzaPdSYiru3IrUNJo4UMPmIiigos4gJSqbfK453gQ9uEqLDhn2VV8tvcuNqSSGGLaNvwegdx3SUQi3zu8ewPyQNm6Dxk0NYoib+816yLDcqCRixgxvSJ9Flvha54=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by DM4PR11MB5485.namprd11.prod.outlook.com (2603:10b6:5:388::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 10:11:13 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::e906:3e8d:4741:c0f0]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::e906:3e8d:4741:c0f0%6]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 10:11:13 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <harini.katakam@xilinx.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <dumazet@google.com>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH] net: macb: Increment rx bd head after allocating skb and
 buffer
Thread-Topic: [PATCH] net: macb: Increment rx bd head after allocating skb and
 buffer
Thread-Index: AQHYZFZHF+FHQ+6oE0a8cetWU9FqwQ==
Date:   Tue, 10 May 2022 10:11:13 +0000
Message-ID: <4fb95509-97af-bce5-bf2f-3be8962e5e6a@microchip.com>
References: <20220509121958.3976-1-harini.katakam@xilinx.com>
In-Reply-To: <20220509121958.3976-1-harini.katakam@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cf4e568-5caf-4cde-8d45-08da326d69ef
x-ms-traffictypediagnostic: DM4PR11MB5485:EE_
x-microsoft-antispam-prvs: <DM4PR11MB5485DD9BDF9E32A1BE5B7D4B87C99@DM4PR11MB5485.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rvdZJ+vlLoYkf1bRqQ1F96ubbIYQ028HXmX25PmZLOPruuQzY9w4dwRrS6NAJBUinq13IyR+TIgU59DY+e0Exik3HabJELXnjTO7+bOvutIJcZ9/4Huo4QAsBiLczRQC2R3BuAgIgwyaepMRc5UKqwqbUNVSj5YPHgM2soPtMg40Dwk0PO5e8vmrq15QO42K1+hd3+XkkCEE9K8hWQH8lVBpL6uSmzEfMk95QcNefip0gk2c+goDIJXzVdjbfTDuZNXpoGjP2CEzZgNjJjYHhC065l9//nAutsSNYGXxUsEC4qHhG/Tlo96GudB6Qn0pvEFN7szUEXC0okHf59gs05uN4ws6Lc02/joBfCd1mwYshyW01+M5CqLLylAE/Uzj8esBieLwyBXKEW6FKyv5nPNeRdnz3YiakOkzt2CxpsL7zi4RtG6mzT+s4tUfmHg2L9TcpPZxLnzz1zJYmd/JEWdNIoC24ghtbBwJopSfCIExsW6ibhH8+2m5B5M5+g8fNwKDnwO4suODxybyWR8uDFggH3TU1Bh2L+Oqp05rYBBWsGyJv91yfi2njXK/QDAUFzVHYuy/b19m5YvmRolIObrCyYQMFoNaszjeZSSIl7YM30b4660eqbUR8skb1/ys21mMYJUSvwx3mvi65AJjgb9t9phhdUcZpvBC4TxgnNWkraZ6zGh++NtpUw+2/yHJCBxZUqX4O2uqIg+CxlBUnG/dtL4/A71ydgXe9r/uJd/3lnjba0ABXaaBqVoJnBjSOE7eLHHoq2lX+lqP/CW0uA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(316002)(36756003)(6506007)(122000001)(2616005)(110136005)(186003)(31686004)(83380400001)(66446008)(66946007)(86362001)(4326008)(8936002)(64756008)(8676002)(71200400001)(26005)(66476007)(66556008)(6512007)(31696002)(38070700005)(91956017)(76116006)(38100700002)(53546011)(508600001)(2906002)(6486002)(7416002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzJYYTR4RzVKYjk4UklRODFVWHhVS01McXBlbUtRWUh3T2JGdGRnYXFoQ1V3?=
 =?utf-8?B?UWRQTjJ1dHpxcGU2dXRLRXFGZXVBVXZYQkxJc2twb3BDYWVLaG45dmgvRFNH?=
 =?utf-8?B?anBNbDlRYWdFMFhLZlQ1MzJUbWJMWDBkdk5YUEFYWDNrNllVTkNFZ1RVZEt1?=
 =?utf-8?B?VXlESU5hYitEOEdZSXcxRk5YcUZZbWZOSUd0QzhRc3RHZUNaRXJ2Uk1rcXhM?=
 =?utf-8?B?VThwb0MzL3psVWVTUGhubDhqM0tYeE1NdFhiWWFuSkU0WFA0amlVU3pvblBY?=
 =?utf-8?B?SlNMWmt6aTVQZldRMEJvdU1IaDVDLzN6WGZYZ2ZzcmEwZmhUbzEyZWF6Q3R5?=
 =?utf-8?B?NjFKOGg2NkY4MVQ0eDVUODZrMTAxR2o4aVFGVXBlaUxIVFg0T0h3ZGcrMlQv?=
 =?utf-8?B?OFp2bFpUMkZSeEwrOXY1WVBLSlJMQU9RMlIxVmtqbkpjZG1KbS9QOFQ5OC9K?=
 =?utf-8?B?VHFUVFVmWE1LNERwRmU4UlZLTVNscTY2YlhjWlVTalJsTXhtOGxDaXBEMmpu?=
 =?utf-8?B?MkdBOFNmbk9wNmFORDBZTE5IVUJkS0dra1RqYlpHSDM2MmJzTmFvVHRKSTEv?=
 =?utf-8?B?SXBnR1NnMXN4SW5acEN5dGdmcHFkdG1jYzI2a3gzZjJ0ZS9xdVB6VTQzYmV6?=
 =?utf-8?B?TkJ4bFBkNDVjOWprL2Q4eDNIU2lSRWM3c1JYc25uZmxXeENkcGlWTmRtN2h2?=
 =?utf-8?B?Z3FISHFZV0VJUXYzWThsT3pPb0I1QzMxWkF4SzFSMEZFUnRTeUs0OFB4eTBo?=
 =?utf-8?B?cHl3ZmRUUzdrbWFaYTBqemhyNlJKWFRVOGRmMHdTVVRzcUlKb2JXUHJBai9v?=
 =?utf-8?B?allNa3dLZ2FJZGtkUUxQcUdZZ1JLbmhjNFNEVkZFNW9zZGJxd0VUdEFJQ1Bo?=
 =?utf-8?B?OUpYdmF4eWFsalY3ZXQyVkcxam9Rb1NPQTVRd0xwMm1qcGJPbFJCS0UwUW5n?=
 =?utf-8?B?L2lvZndLbzVaaEx3WnM2dDFJL0hla0krUmt0ay9JSnhBUHBKaURrMVNOYmpl?=
 =?utf-8?B?ZlNCdDdZSjdEREhkWkM1aFRqekJ2dTRHdDlEVStTWGxTYWoyZ3VrMTF4S3lC?=
 =?utf-8?B?SDhWZENDUzFDSUZFdzRIU0puT1RESjk0c2pDbzV6M1UrM3BpQXlQOXNyODJo?=
 =?utf-8?B?N1NYVldJd1lLVWphb3hOaTZEK3lDSXk3SHdqcWJkbU1sZHF0NFNqQzZDWjEy?=
 =?utf-8?B?bkxDaTdPWGV0UWx2bTNUcks0R3BsY1JUQ1dhdzZMelNreUxuZ21URXZGNVVK?=
 =?utf-8?B?Q05Za0JpVUVaTW91ckFCelQyRWxta2FpS2NqenpmdFRFMDc0ZjhmT1JKL29v?=
 =?utf-8?B?K2JrTGx5RjlqUElZSVhZUU54RnpVRXYvZmE1UXU5eWhNVEhuOFdzcDE1RE52?=
 =?utf-8?B?eDNSRm1GVmF1MlVJY21hV2Y4SXBQK3A2Rm41WnIrbXMxamRNV216WGNvQnZX?=
 =?utf-8?B?aWVkWmdzZVRaZ2svdkNnOHI2a3BFbGNnb3M2THE1aFNkY01RcmhjUCswZUZB?=
 =?utf-8?B?bkxxQktiNWlQckhGWDYyemhwTUtjbW1YZHdHdkZJb2JEVndpekVDS3N2MWVs?=
 =?utf-8?B?OTlST1I0c0RPODRSTk5XNDMyU080S2c5WGZRQkJsUWtIM2ROSDJkLzR6WG91?=
 =?utf-8?B?Zndlc0NJd0w4UTNIUEg3UFFTVmhhZVVMZGtZbmc5ekpZZy9pNmM0Z2NsbHdB?=
 =?utf-8?B?R1dta09KODg3OUorYjZIdmloM1MvNlFFd1FCcS9zQUJuSWI5T3dZbUR0SUJa?=
 =?utf-8?B?eSthOGVLUlJWbm53bnpUdkxHVCtXZXp5d3JaV3pQZnRJcnl4VWc3WjFlcy9h?=
 =?utf-8?B?d3VoS0Z3SVN3N21lZVYrRTJZc3NNZ29QYjUrTk81V1UrTS9JdGlNNDM4cDVW?=
 =?utf-8?B?M1FPM3c4Q3NuWXJ6d0NRS1RucDNUV1pRcWNJbzlyZ0wzZTU5cjYvVjJiTm5M?=
 =?utf-8?B?ZW8xbFowUUp6NzJSeWVWZ1hlR3RwTTFmcjdGN3lBUzA4bk5mZEZCU2JJTmlX?=
 =?utf-8?B?TTRtb1VqNVZjS3NBU1VXOTVqN2RqQ3NtWHdQcnBEcnE2clRlUnhUVjd3TUVI?=
 =?utf-8?B?UGdJUGpmY3NYeVdieGREbFcwdFZJWUlMa0ExQlprVXUzVTNoR0h4SnBQKzFE?=
 =?utf-8?B?OW1Bem13ZFZrbHV4TlgvR0xtRURoR0l4K0RZM2dIK0FDRmlKWW9RTFdRVmFE?=
 =?utf-8?B?Sm9FRUYwWTNYSVFOZnEzaTJhY21nK1hKUTY4ZFB4T3B3Zy9yb1FkODA2NG5X?=
 =?utf-8?B?eEdtQ2k3Y1ZjVmRYZlBHRm56V3VsMjdXNUFORWw2N0k4OEtzT1Bhb3BZKzNs?=
 =?utf-8?B?TktNdXhrNVV2UGVwWUlzamRuSnZHN0FNLy92THl4QjhTQ3ZoQXIzeDZOY1VN?=
 =?utf-8?Q?AUq7Sf9x/90O1INE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA6B98B4F2B3214386CE37EA4ED668E1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf4e568-5caf-4cde-8d45-08da326d69ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 10:11:13.6008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VBCeMEAzDoPVA2S1AYYOGX/wetESfk2fX/IaEqIGpNZ0N6IhpPHSN61XnZysfsjnj23l+R56+jcPf06OWy1FGDd844K1/ObMLNQvKBSrRPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5485
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDkuMDUuMjAyMiAxNToxOSwgSGFyaW5pIEthdGFrYW0gd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSW4gZ2VtX3J4X3JlZmlsbCByeF9wcmVwYXJl
ZF9oZWFkIGlzIGluY3JlbWVudGVkIGF0IHRoZSBiZWdpbm5pbmcgb2YNCj4gdGhlIHdoaWxlIGxv
b3AgcHJlcGFyaW5nIHRoZSBza2IgYW5kIGRhdGEgYnVmZmVycy4gSWYgdGhlIHNrYiBvciBkYXRh
DQo+IGJ1ZmZlciBhbGxvY2F0aW9uIGZhaWxzLCB0aGlzIEJEIHdpbGwgYmUgdW51c2FibGUgQkRz
IHVudGlsIHRoZSBoZWFkDQo+IGxvb3BzIGJhY2sgdG8gdGhlIHNhbWUgQkQgKGFuZCBvYnZpb3Vz
bHkgYnVmZmVyIGFsbG9jYXRpb24gc3VjY2VlZHMpLg0KPiBJbiB0aGUgdW5saWtlbHkgZXZlbnQg
dGhhdCB0aGVyZSdzIGEgc3RyaW5nIG9mIGFsbG9jYXRpb24gZmFpbHVyZXMsDQo+IHRoZXJlIHdp
bGwgYmUgYW4gZXF1YWwgbnVtYmVyIG9mIHVudXNhYmxlIEJEcyBhbmQgYW4gaW5jb25zaXN0ZW50
IFJYDQo+IEJEIGNoYWluLiBIZW5jZSBpbmNyZW1lbnQgdGhlIGhlYWQgYXQgdGhlIGVuZCBvZiB0
aGUgd2hpbGUgbG9vcCB0byBiZQ0KPiBjbGVhbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhhcmlu
aSBLYXRha2FtIDxoYXJpbmkua2F0YWthbUB4aWxpbnguY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBN
aWNoYWwgU2ltZWsgPG1pY2hhbC5zaW1la0B4aWxpbnguY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBS
YWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5jb20+DQoNClJl
dmlld2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4N
Cg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8
IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWlu
LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IDBi
MDMzMDVhZDZhMC4uOWM3ZDU5MGMwMTg4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTEyMTUsNyArMTIxNSw2IEBAIHN0YXRpYyB2b2lkIGdl
bV9yeF9yZWZpbGwoc3RydWN0IG1hY2JfcXVldWUgKnF1ZXVlKQ0KPiAgICAgICAgICAgICAgICAg
LyogTWFrZSBodyBkZXNjcmlwdG9yIHVwZGF0ZXMgdmlzaWJsZSB0byBDUFUgKi8NCj4gICAgICAg
ICAgICAgICAgIHJtYigpOw0KPiANCj4gLSAgICAgICAgICAgICAgIHF1ZXVlLT5yeF9wcmVwYXJl
ZF9oZWFkKys7DQo+ICAgICAgICAgICAgICAgICBkZXNjID0gbWFjYl9yeF9kZXNjKHF1ZXVlLCBl
bnRyeSk7DQo+IA0KPiAgICAgICAgICAgICAgICAgaWYgKCFxdWV1ZS0+cnhfc2tidWZmW2VudHJ5
XSkgew0KPiBAQCAtMTI1NCw2ICsxMjUzLDcgQEAgc3RhdGljIHZvaWQgZ2VtX3J4X3JlZmlsbChz
dHJ1Y3QgbWFjYl9xdWV1ZSAqcXVldWUpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGRtYV93
bWIoKTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgZGVzYy0+YWRkciAmPSB+TUFDQl9CSVQo
UlhfVVNFRCk7DQo+ICAgICAgICAgICAgICAgICB9DQo+ICsgICAgICAgICAgICAgICBxdWV1ZS0+
cnhfcHJlcGFyZWRfaGVhZCsrOw0KPiAgICAgICAgIH0NCj4gDQo+ICAgICAgICAgLyogTWFrZSBk
ZXNjcmlwdG9yIHVwZGF0ZXMgdmlzaWJsZSB0byBoYXJkd2FyZSAqLw0KPiAtLQ0KPiAyLjE3LjEN
Cj4gDQoNCg==
