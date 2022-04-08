Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1174F8FBC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiDHHow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiDHHov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:44:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF441B72E8
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 00:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649403766; x=1680939766;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oYrN5LObT9KOc743fUSzsVyAFukbh5adgSOqEahSupY=;
  b=2KQnXk3PHre9fzIYDZ0Xy7AjDN7GLdp3izaLwvSa56+BxEixIOQdYjLD
   aggzhu3SEHV1h3HYNmA+A6B6XD8aM3HWZ1jY3ISK8w5+b2FyahB3UEmnT
   NCvkNa2oevL0hlkjpGnS8DX7eNMRZCvcrM05PKRq2kUA6dyIZAq3ah85T
   7G15YRQDUaSgp07syDD5Yh5gXhcZNA4ory3amt7RK7X7r7PF5jQdzqDoK
   f3bPaaOwKeercZb6u2KA/rEo8PW/br3ooDlMALYfovwa4ac3YtQue2zVI
   rmDTDF3m32VXqpPF31lwhAYYG1kQ4L9+dDTcWzP6LeGbN7sw32b2Y8yC9
   w==;
X-IronPort-AV: E=Sophos;i="5.90,244,1643698800"; 
   d="scan'208";a="154886557"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Apr 2022 00:42:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Apr 2022 00:42:38 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Apr 2022 00:42:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdTt3ZwB44MOm0VqDoETTrDWt/bS6Pr2Hjm+38xqjNsddhdz0P2nZMQFz1+OgEgLvKGm7U+j3VlHjIrYJfrh5KAdtOPaxzR+uc970JUS+Hs8p7m+eo2Af/VTfIA/VMCDA9jX6CqlJH/do0yEi1imLK0O8jOFk8a+Vm80+/pvqpj2TcBxQ0JlMwCR51ChjE7lNZlEKujR9X3vjc3+cf32X1RKdc/ctrB9V9Fnxti6LgaQkgxYVS5Ix4AJcvkxYNc3NKjjwA5DokXT0OMrJeTpGdKQqYAnHHu0UxSKKjGGdNB1JdoFZlt3fFo3JwzGD8Jm3CWpTj98vb7gjeXtP8IL8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYrN5LObT9KOc743fUSzsVyAFukbh5adgSOqEahSupY=;
 b=Cb4jA1VxM0Z2P3XmSYcQjmES5wY42CNVDVpxykdWbwyUSRArZNFUawRwykL1vulAAU2RKiEqQFnxGKHVKLH7dvnfnHvgwGAdqq1NdQHOru8h5TvmGdGO280WTBG72LWsP64DsDTQGiQsK7k8i1uIryvQRBHb2qLqZUPdNmNEivN5/qPDXgz4sHIGtrqZJDFr7mcbOSXT+PKVJi1cb4kT5PTuFAt/LmkIiF6FZzeLHuzT8pkJdTTWebq9q3Pa4C6pYKDkAmpLK3ZO2y+P9wYC92sKvzk6Nv8hsoEGbV+a+Vf/Nix7o7Pf4kT8kIm59o8AqHUuVlc8NYl7aVx2ofpvyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYrN5LObT9KOc743fUSzsVyAFukbh5adgSOqEahSupY=;
 b=AA9Lgizelms+kpTC2/HlUwxH7ki6mjLFTZno2wm61LMgeFUemLdBQwgjDkgtar+lq2xxaMR+CW00p6kE/bozQqy6uTpLJQCTvlBnOg06QPoxPLt5kbp0YUQXP16HxkTz+QNPPbJZZq5tPtoUglY1j8p2iThTqnsFrMH5ATjCwrQ=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by CY4PR11MB1766.namprd11.prod.outlook.com (2603:10b6:903:11a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 07:42:34 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b%7]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 07:42:34 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <tomas.melin@vaisala.com>, <netdev@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <harini.katakam@xilinx.com>, <shubhrajyoti.datta@xilinx.com>,
        <michal.simek@xilinx.com>, <pthombar@cadence.com>,
        <mparab@cadence.com>, <rafalo@cadence.com>
Subject: Re: [PATCH v2] net: macb: Restart tx only if queue pointer is lagging
Thread-Topic: [PATCH v2] net: macb: Restart tx only if queue pointer is
 lagging
Thread-Index: AQHYSxw1ebe96eaU50Otacnv9gLy/g==
Date:   Fri, 8 Apr 2022 07:42:34 +0000
Message-ID: <8c7ef616-5401-c7c1-1e43-dc7f256eae91@microchip.com>
References: <20220407161659.14532-1-tomas.melin@vaisala.com>
In-Reply-To: <20220407161659.14532-1-tomas.melin@vaisala.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cff4aeca-ac17-4c0c-b1e7-08da19335894
x-ms-traffictypediagnostic: CY4PR11MB1766:EE_
x-microsoft-antispam-prvs: <CY4PR11MB176662570590DAC0CD912C8E87E99@CY4PR11MB1766.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t3D7Idyty2pCqu1I8bwEAINjyPyte4RxbEUyYYV1ESmtUDaUJVCP8af/R7uijQ52s4++04Ewu/5elfxNaga6RlMYKLuIL6e8ps6DsP0vYZdzWVOw5D7mACD75rvG2Qyy69KkOiZmWzJ+5pXU5l3x0RELlQDiAl5XNLMU/XfkAnrmDqvyjQbQxdbRLyFKFB9PUgECy8woPo7bRZ2QUA0+mjwQmCILA6yP0Qbs36t3j4WBjTfpZTIu5+SY+dQc58d9y9CTfbMtE25zl8Jxsr0FrHVQR0rsHjaFe6rP+FgwMbdN+JjuH2SgLGgiqj0W60Qp4+uuc/4GKvbsjYHTQ8LB1LllGCVN19ojk7xNzsXn4hlGgGkZZvGQ+wudiZQ5iXw9GFLsimeEo0H8VWuNZk4yyZcFQW4fpgqBmM7hRTQ+eO31SVcsAHtEaPHctFyIlNHo08nBn0f4CkL48815c88k3onq1xNYgux3adkjbUvqrxq/yM3Gr8e1LbrNmpaWJZ3RJXTEVrneRaiGTyWlpLcd3mWaVSMHUuQFg5nInliXMQq2ykiQjiormzKl58tt98zk3DDwKRROCUfmHNS1AbZWb76aVCXsU7iScJvpptOgy3R6vn90P0RvFW7BDg0hWIWKJ3fOFqyouLKs2YEj6XoMxaxpBUe8Fca2dDEUf1Cu0wRVJFOvV7HKhqQQfU2w5Zf/eLFY/vC3tEX1BoiCzLI0YcjE/zW2GSSlkaMMs/CgRxlELvNl1Senkczi95V2KDbi64OflE6SxqY/mNhzAhz9/20cWKSBRRUkA/iMYU4Udmjt2a4aEnj451aiMj+KuYFUFbBSeRnjuWNJld9y/eolLnYA+yY1XALftcqRZ7TGB5M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(122000001)(6486002)(66946007)(66556008)(66476007)(66446008)(83380400001)(38100700002)(110136005)(4326008)(8676002)(91956017)(64756008)(76116006)(2906002)(508600001)(966005)(86362001)(5660300002)(71200400001)(38070700005)(54906003)(31696002)(26005)(186003)(316002)(6512007)(36756003)(6506007)(31686004)(2616005)(8936002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aEtJNWgrZFI1VkF2eTRzUjV1MVkrYm11ZGV5amlkcFA0SzliWlR5bnpxbDNv?=
 =?utf-8?B?TGZ4OThQaGRjdDRSQUlLRHErRkVBZ0lOcGdzZXlzWE8vUHBZZ1luTEJZNlhC?=
 =?utf-8?B?UGZ2NnE5VWk3WlgxQldBanlRZlFtR0JFdnEwTUg3NUJpb3JWZERoV2tDWHMv?=
 =?utf-8?B?QlAzZW9RSklVUGJ1dkZBSmdML1JlZVMwaWdZeVdqR0t2Q1JSc0VhWnhwZThC?=
 =?utf-8?B?QnkwMmMyYnh5V3BNTEdlQUN6RnJ3NVVsWnpKcjNTM2FyUHYyOXhpWklPa084?=
 =?utf-8?B?VVBuNmlwcEMvUTEzdzE0TTB3Q2krNUtUamxUZVZCRFcxeW1tbjZSRkMzWWFw?=
 =?utf-8?B?V29DU1hHb2Q5bnVaRThoZkpLT1ZhbVZ0M0tZcmNIZHNlQXhWSjdXeUVjWVNT?=
 =?utf-8?B?NFpxMzRRVldnWFQ5Sm9vKzRHMzhrK2E4Q0M2N0E3a3FRSGVwekk1b0VkTSt4?=
 =?utf-8?B?dEZPUm52NjZEc3VGaldFd0UwbTg2QWVBWjNKZFEvalRWK21kcXVPTldMRDhZ?=
 =?utf-8?B?UEJHVk12V0pYSnRFOXBmWVQ3NlNXbXdIT1VWSGxENjB2M3Rib2xvZGdkZjN2?=
 =?utf-8?B?VVlxNUFRR0pzeVZBb3cvM0tBVG1SOStoRTZuNWc4U1d6VjhZNFdVTVFiMXc1?=
 =?utf-8?B?dkkwVDFuYnY1eno0TDNHQ1hNdTg3Z0xnbmNiN1prbU5La2loejd6K09FTWMr?=
 =?utf-8?B?eUtlV1hreSttNXZwUXNkUVNTSnI1eU9talhwY2ZHY08wZFF4RXlVTG1iTjlj?=
 =?utf-8?B?ZnZ0NnlXYUpSWC9Ub1d2V3pMQWEwRUl3NG1waFB1WHFCRUROZ242cFl2Qzh1?=
 =?utf-8?B?OWNJT2Z0OUh6eFRJaGI4Zk9ETmZ1UzZHZkMrR0pjUUlCdXJKWWk0Z2ROQ3VW?=
 =?utf-8?B?bUQ3cDQ3eHB5S3V0ZmIySktzL2RlZmZXS0dOTmhSbHdxeUlJeUtUUGlrOUtJ?=
 =?utf-8?B?Nm5Yb20wVFBTYmd1bVVnWGxSem12dklGT1hNL3Rua0JMWGhFbDIrZFcyb0w3?=
 =?utf-8?B?d0Z0eUR2S0NFY2JIb1Rzb2xvQmxNaCtFOHpBNmdTT2N5S1pGNDE5anNBZ1JJ?=
 =?utf-8?B?WktnZXBlWm5VZ01UVUNlTzNUK1AzcWpEdzZyaVE3YWhrRVpPd2txTTBUV29x?=
 =?utf-8?B?NkJJMUJLQ1VUR3VVemJXdXBNKzVZN3Q0Zng2RzJqaFFGbWNsZmt3RlRobzUy?=
 =?utf-8?B?Ym80OUxOZ01BNG5iQ3hBNzFnYkZGMDNTcXQrU3RsdmNGa2NLYXVON0MxeHp3?=
 =?utf-8?B?VU54NVRIT041emY2akVhcCtETHpIS1N5c2ZpRnlDQWJ1bmdrN0Z1ZDRBUlNv?=
 =?utf-8?B?YkVVakVyOWl4WUJQWVBCL21lMmxyaFN5Q0ljcXhJL1cxVVl0NlYzYVBJdlRv?=
 =?utf-8?B?WFFIVlN1Y0R5a1lHUEJqeHl0T1ZPZmJMTGEvTDBIMHhsV1lqdndhY3ZkeE9F?=
 =?utf-8?B?N0RrK214UDJGVjBKTUdZR1ZlVmlBTzFLQUV0TUd1S1gyY3pNQktjQXZCL3RM?=
 =?utf-8?B?dnVnKzRGS3FMcFhOYVByTWhmclFzS0sxODdISjlDRnZHVC83ak84Zm1WL1ZH?=
 =?utf-8?B?ZVNPRWw5Z3VsMlgycHZCVnRLejhjUEhNYXpnTThSV3FZMmI3VVBhOE81ZWd5?=
 =?utf-8?B?VE94VzhtbWx2U21UUXVzWHpMLzgwdlA3alA3NHp1N1A3cDkwRVlLS015OVJr?=
 =?utf-8?B?ZXh3bnBLRGJRZ0YrY0d6U1BHbFZrSWJFc0NSNGVHQ3llR0I0cnVRTkYwUFlu?=
 =?utf-8?B?bVdtUEUzZVNOVXBzOElKcjEyOTJwUWRsN0tyeG9YSGVod0kyUktWTFhoN3BK?=
 =?utf-8?B?bW55blNXMDNsSHptNGl4ZGVVcVY3VzlBcWFJNmpmdDJpbVFGemZGajFSVzNW?=
 =?utf-8?B?YmJCVEpjNWhjcE5hNHE0cGg3WjFsMHpJRmp3Q1I5M1IrUXR0NitWYmltT3Ra?=
 =?utf-8?B?M2RZN0FQT3c0dTZsTGM0QXJRQzhjdllRY0NEZGRZUkhBUy8vUEZ1WjlDSzgx?=
 =?utf-8?B?c1ZiV0lKSDNwS05lUW85U1FBcTBKS3FmbjlxVHJlbGIzR0taeG5aU2RLdm1y?=
 =?utf-8?B?S1NCYXJYalk4NnNpSkk5TkVZbWtObHJrNVIrT3htVExqSGhYS1VTcTBFTW81?=
 =?utf-8?B?WVNzYkUwQVU4UHg4ZUxIQ1ViWDZHTis4RWE3czdyOTBXVFNma2VFcEFVWXV0?=
 =?utf-8?B?bXBMU1dyMllqNW1GN0NsbWJpcml5a2QwaktKbi9NUzB1TTFQY2Z5TkdyT04v?=
 =?utf-8?B?UlI0WHpiZ2VRSXJCNThIUEtpZGxVL1lwSGhpcXVYTDZFRmx0S2hLWXpjMHh3?=
 =?utf-8?B?YmdrVDgyWVVjNG00eGVQekEwMmhJcVBRNk5LVFJ3TGNDSHlVYnlvRkhDT0cz?=
 =?utf-8?Q?61cEfmldFkYTnf2I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0642A36624B9F478D05068BC22B8BDC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff4aeca-ac17-4c0c-b1e7-08da19335894
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 07:42:34.5720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SZivmBx8joiX6/Qzu8GCkw7/VjYXsrsakefN9V7U46IVrdmHeSTHyQTvHKWcQbdCsSfWir1Lr6ACpvGpYkq7u4csvMv/xEQ5ihKGtQgjGmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1766
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIFRvbWFzLA0KDQpJJ20gcmV0dXJuaW5nIHRvIHRoaXMgbmV3IHRocmVhZC4NCg0KU29ycnkg
Zm9yIHRoZSBsb25nIGRlbGF5LiBJIGxvb2tlZCB0aG91Z2ggbXkgZW1haWxzIGZvciB0aGUgc3Rl
cHMgdG8NCnJlcHJvZHVjZSB0aGUgYnVnIHRoYXQgaW50cm9kdWNlcyBtYWNiX3R4X3Jlc3RhcnQo
KSBidXQgaGF2ZW4ndCBmb3VuZCB0aGVtLg0KVGhvdWdoIHRoZSBjb2RlIGluIHRoaXMgcGF0Y2gg
c2hvdWxkIG5vdCBhZmZlY3QgYXQgYWxsIFNBTUE1RDQuDQoNCkkgaGF2ZSB0ZXN0ZWQgYW55d2F5
IFNBTUE1RDQgd2l0aCBhbmQgd2l0aG91dCB5b3VyIGNvZGUgYW5kIHNhdyBubyBpc3N1ZXMuDQpJ
biBjYXNlIERhdmUsIEpha3ViIHdhbnQgdG8gbWVyZ2UgaXQgeW91IGNhbiBhZGQgbXkNClRlc3Rl
ZC1ieTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQpSZXZp
ZXdlZC1ieTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQoN
ClRoZSBvbmx5IHRoaW5nIHdpdGggdGhpcyBwYXRjaCwgYXMgbWVudGlvbiBlYXJsaWVyLCBpcyB0
aGF0IGZyZWVpbmcgb2YNCnBhY2tldCBOIG1heSBkZXBlbmQgb24gc2VuZGluZyBwYWNrZXQgTisx
IGFuZCBpZiBwYWNrZXQgTisxIGJsb2NrcyBhZ2Fpbg0KdGhlIEhXIHRoZW4gdGhlIGZyZWVpbmcg
b2YgcGFja2V0cyBOLCBOKzEgbWF5IGRlcGVuZCBvbiBwYWNrZXQgTisyIGV0Yy4gQnV0DQpmcm9t
IHlvdXIgaW52ZXN0aWdhdGlvbiBpdCBzZWVtcyBoYXJkd2FyZSBoYXMgc29tZSBidWdzLg0KDQpG
WUksIEkgbG9va2VkIHRob3VnaCBYaWxpbnggZ2l0aHViIHJlcG9zaXRvcnkgYW5kIHNhdyBubyBw
YXRjaGVzIG9uIG1hY2INCnRoYXQgbWF5IGJlIHJlbGF0ZWQgdG8gdGhpcyBpc3N1ZS4NCg0KQW55
d2F5LCBpdCB3b3VsZCBiZSBnb29kIGlmIHRoZXJlIHdvdWxkIGJlIHNvbWUgcmVwbGllcyBmcm9t
IFhpbGlueCBvciBhdA0KbGVhc3QgQ2FkZW5jZSBwZW9wbGUgb24gdGhpcyAocHJldmlvdXMgdGhy
ZWFkIGF0IFsxXSkuDQoNClRoYW5rIHlvdSwNCkNsYXVkaXUgQmV6bmVhDQoNClsxXQ0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzgyMjc2YmY3LTcyYTUtNmEyZS1mZjMzLWY4ZmUwYzVl
NGE5MEBtaWNyb2NoaXAuY29tL1QvI202NDRjODRhODcwOWE2NWM0MGI4ZmMxNWE1ODllODNiMjRl
NDhjY2ZkDQoNCk9uIDA3LjA0LjIwMjIgMTk6MTYsIFRvbWFzIE1lbGluIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IGNvbW1pdCA0Mjk4Mzg4NTc0ZGEg
KCJuZXQ6IG1hY2I6IHJlc3RhcnQgdHggYWZ0ZXIgdHggdXNlZCBiaXQgcmVhZCIpDQo+IGFkZGVk
IHN1cHBvcnQgZm9yIHJlc3RhcnRpbmcgdHJhbnNtaXNzaW9uLiBSZXN0YXJ0aW5nIHR4IGRvZXMg
bm90IHdvcmsNCj4gaW4gY2FzZSBjb250cm9sbGVyIGFzc2VydHMgVFhVQlIgaW50ZXJydXB0IGFu
ZCBUUUJQIGlzIGFscmVhZHkgYXQgdGhlIGVuZA0KPiBvZiB0aGUgdHggcXVldWUuIEluIHRoYXQg
c2l0dWF0aW9uLCByZXN0YXJ0aW5nIHR4IHdpbGwgaW1tZWRpYXRlbHkgY2F1c2UNCj4gYXNzZXJ0
aW9uIG9mIGFub3RoZXIgVFhVQlIgaW50ZXJydXB0LiBUaGUgZHJpdmVyIHdpbGwgZW5kIHVwIGlu
IGFuIGluZmluaXRlDQo+IGludGVycnVwdCBsb29wIHdoaWNoIGl0IGNhbm5vdCBicmVhayBvdXQg
b2YuDQo+IA0KPiBGb3IgY2FzZXMgd2hlcmUgVFFCUCBpcyBhdCB0aGUgZW5kIG9mIHRoZSB0eCBx
dWV1ZSwgaW5zdGVhZA0KPiBvbmx5IGNsZWFyIFRYX1VTRUQgaW50ZXJydXB0LiBBcyBtb3JlIGRh
dGEgZ2V0cyBwdXNoZWQgdG8gdGhlIHF1ZXVlLA0KPiB0cmFuc21pc3Npb24gd2lsbCByZXN1bWUu
DQo+IA0KPiBUaGlzIGlzc3VlIHdhcyBvYnNlcnZlZCBvbiBhIFhpbGlueCBaeW5xLTcwMDAgYmFz
ZWQgYm9hcmQuDQo+IER1cmluZyBzdHJlc3MgdGVzdCBvZiB0aGUgbmV0d29yayBpbnRlcmZhY2Us
DQo+IGRyaXZlciB3b3VsZCBnZXQgc3R1Y2sgb24gaW50ZXJydXB0IGxvb3Agd2l0aGluIHNlY29u
ZHMgb3IgbWludXRlcw0KPiBjYXVzaW5nIENQVSB0byBzdGFsbC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFRvbWFzIE1lbGluIDx0b21hcy5tZWxpbkB2YWlzYWxhLmNvbT4NCj4gLS0tDQo+IENoYW5n
ZXMgdjI6DQo+IC0gY2hhbmdlIHJlZmVyZW5jZWQgY29tbWl0IHRvIHVzZSBvcmlnaW5hbCBjb21t
aXQgSUQgaW5zdGVhZCBvZiBzdGFibGUgYnJhbmNoIElEDQo+IA0KPiAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDggKysrKysrKysNCj4gIDEgZmlsZSBjaGFuZ2Vk
LCA4IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNi
X21haW4uYw0KPiBpbmRleCA4MDBkNWNlZDU4MDAuLmU0NzViZTI5ODQ1YyAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IEBAIC0xNjU4LDYgKzE2NTgs
NyBAQCBzdGF0aWMgdm9pZCBtYWNiX3R4X3Jlc3RhcnQoc3RydWN0IG1hY2JfcXVldWUgKnF1ZXVl
KQ0KPiAgICAgICAgIHVuc2lnbmVkIGludCBoZWFkID0gcXVldWUtPnR4X2hlYWQ7DQo+ICAgICAg
ICAgdW5zaWduZWQgaW50IHRhaWwgPSBxdWV1ZS0+dHhfdGFpbDsNCj4gICAgICAgICBzdHJ1Y3Qg
bWFjYiAqYnAgPSBxdWV1ZS0+YnA7DQo+ICsgICAgICAgdW5zaWduZWQgaW50IGhlYWRfaWR4LCB0
YnFwOw0KPiANCj4gICAgICAgICBpZiAoYnAtPmNhcHMgJiBNQUNCX0NBUFNfSVNSX0NMRUFSX09O
X1dSSVRFKQ0KPiAgICAgICAgICAgICAgICAgcXVldWVfd3JpdGVsKHF1ZXVlLCBJU1IsIE1BQ0Jf
QklUKFRYVUJSKSk7DQo+IEBAIC0xNjY1LDYgKzE2NjYsMTMgQEAgc3RhdGljIHZvaWQgbWFjYl90
eF9yZXN0YXJ0KHN0cnVjdCBtYWNiX3F1ZXVlICpxdWV1ZSkNCj4gICAgICAgICBpZiAoaGVhZCA9
PSB0YWlsKQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiANCj4gKyAgICAgICB0YnFwID0g
cXVldWVfcmVhZGwocXVldWUsIFRCUVApIC8gbWFjYl9kbWFfZGVzY19nZXRfc2l6ZShicCk7DQo+
ICsgICAgICAgdGJxcCA9IG1hY2JfYWRqX2RtYV9kZXNjX2lkeChicCwgbWFjYl90eF9yaW5nX3dy
YXAoYnAsIHRicXApKTsNCj4gKyAgICAgICBoZWFkX2lkeCA9IG1hY2JfYWRqX2RtYV9kZXNjX2lk
eChicCwgbWFjYl90eF9yaW5nX3dyYXAoYnAsIGhlYWQpKTsNCj4gKw0KPiArICAgICAgIGlmICh0
YnFwID09IGhlYWRfaWR4KQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiArDQo+ICAgICAg
ICAgbWFjYl93cml0ZWwoYnAsIE5DUiwgbWFjYl9yZWFkbChicCwgTkNSKSB8IE1BQ0JfQklUKFRT
VEFSVCkpOw0KPiAgfQ0KPiANCj4gLS0NCj4gMi4zNS4xDQo+IA0KDQo=
