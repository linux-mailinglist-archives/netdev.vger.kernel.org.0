Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00815589C88
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 15:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbiHDNWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 09:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiHDNWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 09:22:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4166E2613D;
        Thu,  4 Aug 2022 06:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659619372; x=1691155372;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I/52W5midqRKu4fZ8u79saD1+3HEqHgOav9HJWjIN6o=;
  b=QWW+c/CCPe+G9XKtBKD3X+qQ6pBjl0tOCS+425s39LUX4fYbLVIcjd5/
   0gZTD4mhepWBoemsMGZM+9PwHKwMJVj1c8uKkRavOfqmlSh863wJqOnEu
   TLUcKQupZJZNIpWqEkkgmV686drFOGclwei0wOxOalh1pCx2uqElhNcX/
   teng0zv5s+ll8PGROouOj/KUrnsk/X7/jbqhcak2Qk8IsNJzU+A+SR2yP
   LTalX3W0kOAZQOYW8IpAzs60As+fPPCIeHW3AZCC40xkFvQKYEuHhYx30
   B0O0Zb4ULh/BtS/qqrMGbq9ixyvl6OcxpV6D6SeyFYucE1eCIY7ZS40HW
   w==;
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="170970070"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Aug 2022 06:22:51 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 4 Aug 2022 06:22:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 4 Aug 2022 06:22:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2kTgNoqLPjmXRTO6jodNegTaaJPJngxZzAD2Oi85XzMd2S6T6uEryd+HOqtddSyzCXOEbeBkkFYx+k2cH9vB+u7sbNi6+0ClKTqW+UpP5fBGY068tXxEJTO9ljjhuhnRwbGT68A2yvZnn6UdnOyNEbUQ/ezRVB7uBEjw4lhtMeB74YFXfaOdLdceD03wK4HHQ5IQqG1lr4tWLMdMxvpaSurhnViPsDt9k++4O/c2GTN84MhP7uwn4qsrRIixS1kO2cHUrNhXF+1TGehJ89qMLiCvots9qRLr09elERn2UYDI0w6tbaQPHdvxUOworLzfZB0Lqfno7bzuVtiyWybiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/52W5midqRKu4fZ8u79saD1+3HEqHgOav9HJWjIN6o=;
 b=komUF0QZlzW4TJTqWUI/xjAScb2Qc7OM5532ujPqnAFOZGVDv0kQz9/PplcvqUBc7jOnVzxTVaBzmazO9Xt4cSyQkG3CtwkTX3bjnWwWnH00vnv5mXhuANwFzVsF8xud0tPnorD9LsNYyJQj5+XUAXUIjCEzlI3ctsaPYir4untgakluKAt33SDPQeN2CTgUU5fV2vZzPezDjYPYkBID2M1lBM+88NCmwaWOGCcJ3qplLNoFFd5mPz42Q/PY4iQ/EiFXx0cKref1gMcucII8AR72lqZSCPS5k0bxf8SmeO0XwX3/chkzWKSYQdnxV04TneNU4VfLzI6pmmIhGMH95Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/52W5midqRKu4fZ8u79saD1+3HEqHgOav9HJWjIN6o=;
 b=Fp8U8w/a+uzeugTHonPwQSosgnfSv0m3WojeC98JnH2rT00nYZxgouB4HZlL1Zr+MwM+Mz5bGlYTA2YoXdnYZ1nxkAVofeGaeSeFV74jo7I+NlB9NKmLFyk+mhELikvL0loNAEcPqf3Qkha5HX4uH79ABig/SRbjI92+0EBA6mM=
Received: from PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5)
 by MN2PR11MB4568.namprd11.prod.outlook.com (2603:10b6:208:266::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 13:22:49 +0000
Received: from PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8d74:5951:571e:531e]) by PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8d74:5951:571e:531e%9]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 13:22:49 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <michael@walle.cc>
CC:     <David.Laight@aculab.com>, <Claudiu.Beznea@microchip.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mwalle@kernel.org>
Subject: Re: [PATCH] wilc1000: fix DMA on stack objects
Thread-Topic: [PATCH] wilc1000: fix DMA on stack objects
Thread-Index: AQHYopXBsLYisv99UkizyRPRMtdn/a2VHE0AgABV2QCAAAuOgIAI4yOAgABZeYCAAAPdgIAABzsA
Date:   Thu, 4 Aug 2022 13:22:49 +0000
Message-ID: <c7bf83a2-9419-5e0d-25ec-82c80ad319f4@microchip.com>
References: <20220728152037.386543-1-michael@walle.cc>
 <0ed9ec85a55941fd93773825fe9d374c@AcuMS.aculab.com>
 <612ECEE6-1C05-4325-92A3-21E17EC177A9@walle.cc>
 <a7bcf24b-1343-b437-4e2e-1e707b5e3bd5@microchip.com>
 <b40636e354df866d044c07241483ff81@walle.cc>
 <6ccf4fd8-f456-8757-288d-e8bd057eaae8@microchip.com>
 <8800236c103839e7996a2d976aeada97@walle.cc>
In-Reply-To: <8800236c103839e7996a2d976aeada97@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66f7bf30-d1e1-4c03-af07-08da761c6d66
x-ms-traffictypediagnostic: MN2PR11MB4568:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N8W1t+9lPc4laKDU7+yK8+o9Pc4zx/cngTL0K6ddjw4F4Nqv0PgIEojYySGC9f+Bq+376KGMnRoTAxBAV7Emfp/XUPPhszFniFmATXZ1yE5ymFoFYgfbgby8vKpHdRgdfN/JjMzaFdSPRqQo+MseZCGIitiwfzQzoKi+buqz/31mXyaT0ArAGsBMyJ5wmLB0V30MqLb/D7/+JdHkDJ+6GsqZGRD7/mFoDKWdmpkwZtuEsK+ci+TxzGTEfm0iaoNq6EQroIbUZUKT7cPRuO4s/WTuCZI9DTXFaAOoItraBFQybizNbOFMWr0hq4JyXYQCwLvDlbI/UpmQy8sALeKnZn9aSRJXM6nQBh/Wk4MSAuAbHhwQ8/6j7VRjCFWlMp9hPilNsOhutPNkIm+nTwB9x4feVQcNB48D0QGlJdN5zAE/Dbf+XhumhihkduLocDc/8hnTBnyw6RZqvpNGVEpymjn/NH300pxjBUmbGLSLI3/uwgQEkdTQc3LyIB2hB8lYr+7qxEFd3vDKLPfqZE18D0oLZs4ZE1EXHxux75i2LFkdzmrubPJhBEiIFJXZRmK7cTJMlPkmWLAOHEHZgW/KPYWiZ4z7NiW5W3UGkR5bneuW09xrGHVhUVm4n3aPVviVZW8v8RlZ3kCuq6sOlV1y0q/buKxbD3kGIkBePYWSm4gOWcW+DXzWGO/l4pszTU/YQKeV7nY9pBRZXbQkQbDOCHscyi4IMgYHZTQRLSTScgQIE25yo9cBgEHdH1uO1beF7e9JVjskivm7ZldgwD4G3OMoKNT5BjCppJpvSze0ZH+OqyK9/2zzgGwSloOUkhDZcKiTzd/+s17fzWqLM9d0VNflUyTg20oCxcIuyfQEIp8TBtIQ0sV63RB/QRWBUuFy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5176.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(39860400002)(396003)(136003)(186003)(2616005)(6506007)(31686004)(122000001)(7416002)(2906002)(71200400001)(478600001)(5660300002)(6486002)(36756003)(66946007)(86362001)(76116006)(31696002)(4326008)(66446008)(8676002)(64756008)(66476007)(66556008)(41300700001)(38100700002)(8936002)(91956017)(54906003)(316002)(26005)(83380400001)(55236004)(53546011)(6512007)(38070700005)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VklnS3IyajVuRnZkdVlVS3ZPaFFPaTcrOVZoVVppY21iNHBTZGc3dEF3Y0Ra?=
 =?utf-8?B?cXZsdmROQlFQSXBlRXZBNUhRaElxNGRUajBrMmpodXZuL2dGQTVraGs0bmhi?=
 =?utf-8?B?QnNsaE9wbTBGNWpTaXNFRUZpNE9zK0tMMUIxTytnQnUrSW5hbU5OYldadXlB?=
 =?utf-8?B?UGh1TUJVeW5nNkdnSW8xbWRZQVFLekN4WFJvcDBSaTFlaVVXYktRRHo5SWUy?=
 =?utf-8?B?dEZqa2l3WS9yMHE1QXlZSm0vNWFSa1BxYzNCbVR0Qi8xcjYwMFZ0eVF0eVA3?=
 =?utf-8?B?NlJvMnRvQUwyWWtyWlFTUnpRUkQ1dTBYcnJCa0ZmTlVkSFJqdHFwTlV0bWxB?=
 =?utf-8?B?TExKSklDVzhFbUg0RUJ2RE5sQ3JtV25VUWV0Z2x6VUZ3Ti9LZlF1Rk5GYkM1?=
 =?utf-8?B?RkxVckRRM1J1RVdHY2FpNEN3U25YSDY4eTlGZ0s4MXlNelloOVUrVWdRQUkv?=
 =?utf-8?B?Vm9HVjc2VktiMk5PSS9hQURveFpuS0FKWHcvMStWWTZ3QzZJUEhiTlpYZTdw?=
 =?utf-8?B?OHdHalZ4NldZR2pMd2hhM1F2dHdSck1UNk5GZytNcEJCTFdjTVU2KzlmcnF3?=
 =?utf-8?B?NnNnZ09abW0wNndNOGdIaFVDNG5wM0ZqREh0dmQzZFJZbVRhUFVxZndjc3J4?=
 =?utf-8?B?WndxZUxqYXhHaHB5QWtiQk43UDExaWloMG5KaEt3VFR6Umg1cUh5UTZLbWg0?=
 =?utf-8?B?Wm9QalRwL1VFQWVIaHUzZm1WOUptRnZid1l0aDZXMzdrOGxRQVpzNC9VQ0dH?=
 =?utf-8?B?ZmxkRU9OQWJRRkJjbCtrYnpFbnlVaWJYTytnaFJaSzFXdDJLYnFnZ3pibW5S?=
 =?utf-8?B?MlJ3MHE1Z0h5b1F6elUxbDdxUTlpNTdzQ2VENjVmelN0bzNPUGI2NUJ4MWlw?=
 =?utf-8?B?NzBBUUt6N1REQUhGeEV0dEZtbUFTaUlOMEw3d3U5bDRYTTR5a1pra25WU3lz?=
 =?utf-8?B?UERiWFZ2Wm1KSXBUb25heGV3T0d0QU5VL3J6amc5bWc5ZHNuQVNxMnNhU2Yw?=
 =?utf-8?B?SHRERFpmb3NucTVxbTIyTjFIQTlUSmtCTWZjcnJkZXNJUnJwM05KZExhRjhR?=
 =?utf-8?B?V1VhNnB2YzdBS2NUNlltbkhFMURzK2VueFA2ZW1aaXhLS1hjbXc0Z3JyNWQr?=
 =?utf-8?B?R1FTTFFVL2FGWFR1bUJMRnA3VGdQRE5IVkF2cjRKWEQ5Ny9Wb3RtbVg1YzF3?=
 =?utf-8?B?K1U4TTQ0QjZHOGpITkVNeWY0VzVvd1ZFUlBTT2Zka3NvRXJ4YVRNZDJyQ1hX?=
 =?utf-8?B?SHE3R3FPcFdVdXFPWU5jczNWa2t6K05iQ2pQbG93WEM4QVRIZ0NubGhjZTl5?=
 =?utf-8?B?dVlkREQzUjgxR1h5UHFzKzgvVWF2MmFkeE41U01wQUo0cDE1SEhScmZ6ZzBx?=
 =?utf-8?B?YnVHeDIrK2FWSHRYUzY3SEM5dHhnR21CUFhubDA5NnZVT3Z4OWZ2bTdnNTlU?=
 =?utf-8?B?a2xmUEd5djlzYU5FQkpoUkJzSC90VEdWd3FXMDYzNU9qNCtaSW5rZ0hPVVBZ?=
 =?utf-8?B?SjRxejBSQk1UbUhnTnh0M20xbUNHNjlPTEEwaFZqbzZhcWozYWVhVnhZZmUw?=
 =?utf-8?B?eU5zL1JHRU5FQmNoZklEZHJLZzBSQTJEM1h5am9pd3Uxb3h6UjdWcjRWNGlT?=
 =?utf-8?B?Y2dRQmxxblVCM3UvdkpoQ082emhrYVk2YmJKUmlRWm1zcmxmUThSOStXU21L?=
 =?utf-8?B?akJDd2xqaHlRamlyZGJFMWVMajd0UFZuTWxyS0oyNFdmMXNkTWlDTmxoMFZ1?=
 =?utf-8?B?d3hZaGVMalFtTWhYMURFYzZpdFRxWEVKS3hpL3JBS0FRZ2VSUHdka1ZaQ1Vy?=
 =?utf-8?B?bzYyblJ3ekJodm5oRlQ2MWN2REpxYU15cUZDMmRkSGFySEJ5MUNWY0tEZXNi?=
 =?utf-8?B?TEJGVjgzeC9ieEFQbUV6T3U2LzM3Z3BmMmpDdUZVcFowNnFMN0tZR3N3ZTdm?=
 =?utf-8?B?ODBZTTFiR0JiUzhxbENxTSs5aW1yb3NtV01LRzNqQTdGUkdmVGhmZmcrSjlO?=
 =?utf-8?B?eWJRZjdTbVVHQXhkbG9kTEcwTFViUjVUVHZDeFJNUHY3bjBsTkJDalFFZ3V1?=
 =?utf-8?B?b2J4bVJhYjAyVFZCeng2QVNRM2NsTjZUS1AzYmhUS3ZTZkFvTENTZ3RwR25q?=
 =?utf-8?Q?3S2T2qd3jE6aAcd4XrunM2Bpv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5ACE3BB08DB24243A10CFBA0C4DDC7F8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5176.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f7bf30-d1e1-4c03-af07-08da761c6d66
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 13:22:49.2485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4mEO0F2tV459kD1fTQ4WE8W31560F/FkDjvvuJ5UpxUSE5A9YKlVpFfT8/SrGJw/05kJYVmGtBcHa8ew74JS8DUiccurtctLPN+YAL6qWE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4568
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDQvMDgvMjIgMTg6MjYsIE1pY2hhZWwgV2FsbGUgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
DQo+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4NCj4gQW0gMjAyMi0wOC0wNCAxNDo0Mywgc2Nocmll
YiBBamF5LkthdGhhdEBtaWNyb2NoaXAuY29tOg0KPj4gT24gMDQvMDgvMjIgMTI6NTIsIE1pY2hh
ZWwgV2FsbGUgd3JvdGU6DQo+Pj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBv
ciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdw0KPj4+IHRoZSBjb250ZW50IGlzIHNh
ZmUNCj4+Pg0KPj4+IEFtIDIwMjItMDctMjkgMTc6MzksIHNjaHJpZWIgQWpheS5LYXRoYXRAbWlj
cm9jaGlwLmNvbToNCj4+Pj4gT24gMjkvMDcvMjIgMjA6MjgsIE1pY2hhZWwgV2FsbGUgd3JvdGU6
DQo+Pj4+PiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNo
bWVudHMgdW5sZXNzIHlvdQ0KPj4+Pj4ga25vdw0KPj4+Pj4gdGhlIGNvbnRlbnQgaXMgc2FmZQ0K
Pj4+Pj4NCj4+Pj4+IEFtIDI5LiBKdWxpIDIwMjIgMTE6NTE6MTIgTUVTWiBzY2hyaWViIERhdmlk
IExhaWdodA0KPj4+Pj4gPERhdmlkLkxhaWdodEBBQ1VMQUIuQ09NPjoNCj4+Pj4+PiBGcm9tOiBN
aWNoYWVsIFdhbGxlDQo+Pj4+Pj4+IFNlbnQ6IDI4IEp1bHkgMjAyMiAxNjoyMQ0KPj4+Pj4+Pg0K
Pj4+Pj4+PiBGcm9tOiBNaWNoYWVsIFdhbGxlIDxtd2FsbGVAa2VybmVsLm9yZz4NCj4+Pj4+Pj4N
Cj4+Pj4+Pj4gU29tZXRpbWVzIHdpbGNfc2Rpb19jbWQ1MygpIGlzIGNhbGxlZCB3aXRoIGFkZHJl
c3NlcyBwb2ludGluZyB0bw0KPj4+Pj4+PiBhbg0KPj4+Pj4+PiBvYmplY3Qgb24gdGhlIHN0YWNr
LiBFLmcuIHdpbGNfc2Rpb193cml0ZV9yZWcoKSB3aWxsIGNhbGwgaXQgd2l0aA0KPj4+Pj4+PiBh
bg0KPj4+Pj4+PiBhZGRyZXNzIHBvaW50aW5nIHRvIG9uZSBvZiBpdHMgYXJndW1lbnRzLiBEZXRl
Y3Qgd2hldGhlciB0aGUNCj4+Pj4+Pj4gYnVmZmVyDQo+Pj4+Pj4+IGFkZHJlc3MgaXMgbm90IERN
QS1hYmxlIGluIHdoaWNoIGNhc2UgYSBib3VuY2UgYnVmZmVyIGlzIHVzZWQuIFRoZQ0KPj4+Pj4+
PiBib3VuY2UNCj4+Pj4+Pj4gYnVmZmVyIGl0c2VsZiBpcyBwcm90ZWN0ZWQgZnJvbSBwYXJhbGxl
bCBhY2Nlc3NlcyBieQ0KPj4+Pj4+PiBzZGlvX2NsYWltX2hvc3QoKS4NCj4+Pj4+Pj4NCj4+Pj4+
Pj4gRml4ZXM6IDU2MjVmOTY1ZDc2NCAoIndpbGMxMDAwOiBtb3ZlIHdpbGMgZHJpdmVyIG91dCBv
ZiBzdGFnaW5nIikNCj4+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBXYWxsZSA8bXdhbGxl
QGtlcm5lbC5vcmc+DQo+Pj4+Pj4+IC0tLQ0KPj4+Pj4+PiBUaGUgYnVnIGl0c2VsZiBwcm9iYWJs
eSBnb2VzIGJhY2sgd2F5IG1vcmUsIGJ1dCBJIGRvbid0IGtub3cgaWYgaXQNCj4+Pj4+Pj4gbWFr
ZXMNCj4+Pj4+Pj4gYW55IHNlbnNlIHRvIHVzZSBhbiBvbGRlciBjb21taXQgZm9yIHRoZSBGaXhl
cyB0YWcuIElmIHNvLCBwbGVhc2UNCj4+Pj4+Pj4gc3VnZ2VzdA0KPj4+Pj4+PiBvbmUuDQo+Pj4+
Pj4+DQo+Pj4+Pj4+IFRoZSBidWcgbGVhZHMgdG8gYW4gYWN0dWFsIGVycm9yIG9uIGFuIGlteDht
biBTb0Mgd2l0aCAxR2lCIG9mDQo+Pj4+Pj4+IFJBTS4NCj4+Pj4+Pj4gQnV0IHRoZQ0KPj4+Pj4+
PiBlcnJvciB3aWxsIGFsc28gYmUgY2F0Y2hlZCBieSBDT05GSUdfREVCVUdfVklSVFVBTDoNCj4+
Pj4+Pj4gW8KgwqDCoCA5LjgxNzUxMl0gdmlydF90b19waHlzIHVzZWQgZm9yIG5vbi1saW5lYXIg
YWRkcmVzczoNCj4+Pj4+Pj4gKF9fX19wdHJ2YWxfX19fKSAoMHhmZmZmODAwMDBhOTRiYzljKQ0K
Pj4+Pj4+Pg0KPj4+Pj4+PiDCoCAuLi4vbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9z
ZGlvLmPCoMKgwqAgfCAyOA0KPj4+Pj4+PiArKysrKysrKysrKysrKysrLS0tDQo+Pj4+Pj4+IMKg
IDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPj4+Pj4+
Pg0KPj4+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dp
bGMxMDAwL3NkaW8uYw0KPj4+Pj4+PiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93
aWxjMTAwMC9zZGlvLmMNCj4+Pj4+Pj4gaW5kZXggNzk2MmMxMWNmZTg0Li5lOTg4YmVkZTg4MGMg
MTAwNjQ0DQo+Pj4+Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxj
MTAwMC9zZGlvLmMNCj4+Pj4+Pj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlw
L3dpbGMxMDAwL3NkaW8uYw0KPj4+Pj4+PiBAQCAtMjcsNiArMjcsNyBAQCBzdHJ1Y3Qgd2lsY19z
ZGlvIHsNCj4+Pj4+Pj4gwqDCoMKgwqDCoCBib29sIGlycV9ncGlvOw0KPj4+Pj4+PiDCoMKgwqDC
oMKgIHUzMiBibG9ja19zaXplOw0KPj4+Pj4+PiDCoMKgwqDCoMKgIGludCBoYXNfdGhycHRfZW5o
MzsNCj4+Pj4+Pj4gK8KgwqDCoCB1OCAqZG1hX2J1ZmZlcjsNCj4+Pj4+Pj4gwqAgfTsNCj4+Pj4+
Pj4NCj4+Pj4+Pj4gwqAgc3RydWN0IHNkaW9fY21kNTIgew0KPj4+Pj4+PiBAQCAtODksNiArOTAs
OSBAQCBzdGF0aWMgaW50IHdpbGNfc2Rpb19jbWQ1MihzdHJ1Y3Qgd2lsYyAqd2lsYywNCj4+Pj4+
Pj4gc3RydWN0IHNkaW9fY21kNTIgKmNtZCkNCj4+Pj4+Pj4gwqAgc3RhdGljIGludCB3aWxjX3Nk
aW9fY21kNTMoc3RydWN0IHdpbGMgKndpbGMsIHN0cnVjdCBzZGlvX2NtZDUzDQo+Pj4+Pj4+ICpj
bWQpDQo+Pj4+Pj4+IMKgIHsNCj4+Pj4+Pj4gwqDCoMKgwqDCoCBzdHJ1Y3Qgc2Rpb19mdW5jICpm
dW5jID0gY29udGFpbmVyX29mKHdpbGMtPmRldiwgc3RydWN0DQo+Pj4+Pj4+IHNkaW9fZnVuYywg
ZGV2KTsNCj4+Pj4+Pj4gK8KgwqDCoCBzdHJ1Y3Qgd2lsY19zZGlvICpzZGlvX3ByaXYgPSB3aWxj
LT5idXNfZGF0YTsNCj4+Pj4+Pj4gK8KgwqDCoCBib29sIG5lZWRfYm91bmNlX2J1ZiA9IGZhbHNl
Ow0KPj4+Pj4+PiArwqDCoMKgIHU4ICpidWYgPSBjbWQtPmJ1ZmZlcjsNCj4+Pj4+Pj4gwqDCoMKg
wqDCoCBpbnQgc2l6ZSwgcmV0Ow0KPj4+Pj4+Pg0KPj4+Pj4+PiDCoMKgwqDCoMKgIHNkaW9fY2xh
aW1faG9zdChmdW5jKTsNCj4+Pj4+Pj4gQEAgLTEwMCwxMiArMTA0LDIwIEBAIHN0YXRpYyBpbnQg
d2lsY19zZGlvX2NtZDUzKHN0cnVjdCB3aWxjDQo+Pj4+Pj4+ICp3aWxjLA0KPj4+Pj4+PiBzdHJ1
Y3Qgc2Rpb19jbWQ1MyAqY21kKQ0KPj4+Pj4+PiDCoMKgwqDCoMKgIGVsc2UNCj4+Pj4+Pj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZSA9IGNtZC0+Y291bnQ7DQo+Pj4+Pj4+DQo+Pj4+
Pj4+ICvCoMKgwqAgaWYgKCghdmlydF9hZGRyX3ZhbGlkKGJ1ZikgfHwgb2JqZWN0X2lzX29uX3N0
YWNrKGJ1ZikpICYmDQo+Pj4+Pj4gSG93IGNoZWFwIGFyZSB0aGUgYWJvdmUgdGVzdHM/DQo+Pj4+
Pj4gSXQgbWlnaHQganVzdCBiZSB3b3J0aCBhbHdheXMgZG9pbmcgdGhlICdib3VuY2UnPw0KPj4+
Pj4gSSdtIG5vdCBzdXJlIGhvdyBjaGVhcCB0aGV5IGFyZSwgYnV0IEkgZG9uJ3QgdGhpbmsgaXQg
Y29zdHMgbW9yZQ0KPj4+Pj4gdGhhbg0KPj4+Pj4gY29weWluZyB0aGUgYnVsayBkYXRhIGFyb3Vu
ZC4gVGhhdCdzIHVwIHRvIHRoZSBtYWludGFpbmVyIHRvIGRlY2lkZS4NCj4+Pj4NCj4+Pj4NCj4+
Pj4gSSB0aGluaywgdGhlIGFib3ZlIGNoZWNrcyBmb3IgZWFjaCBDTUQ1MyBtaWdodCBhZGQgdXAg
dG8gdGhlDQo+Pj4+IHByb2Nlc3NpbmcNCj4+Pj4gdGltZSBvZiB0aGlzIGZ1bmN0aW9uLiBUaGVz
ZSBjaGVja3MgY2FuIGJlIGF2b2lkZWQsIGlmIHdlIGFkZCBuZXcNCj4+Pj4gZnVuY3Rpb24gc2lt
aWxhciB0byAnd2lsY19zZGlvX2NtZDUzJyB3aGljaCBjYW4gYmUgY2FsbGVkIHdoZW4gdGhlDQo+
Pj4+IGxvY2FsDQo+Pj4+IHZhcmlhYmxlcyBhcmUgdXNlZC4gVGhvdWdoIHdlIGhhdmUgdG8gcGVy
Zm9ybSB0aGUgbWVtY3B5IG9wZXJhdGlvbg0KPj4+PiB3aGljaA0KPj4+PiBpcyBhbnl3YXkgcmVx
dWlyZWQgdG8gaGFuZGxlIHRoaXMgc2NlbmFyaW8gZm9yIHNtYWxsIHNpemUgZGF0YS4NCj4+Pj4N
Cj4+Pj4gTW9zdGx5LCBlaXRoZXIgdGhlIHN0YXRpYyBnbG9iYWwgZGF0YSBvciBkeW5hbWljYWxs
eSBhbGxvY2F0ZWQgYnVmZmVyDQo+Pj4+IGlzDQo+Pj4+IHVzZWQgd2l0aCBjbWQ1MyBleGNlcHQg
d2lsY19zZGlvX3dyaXRlX3JlZywgd2lsY19zZGlvX3JlYWRfcmVnDQo+Pj4+IHdpbGNfd2xhbl9o
YW5kbGVfdHhxIGZ1bmN0aW9ucy4NCj4+Pj4NCj4+Pj4gSSBoYXZlIGNyZWF0ZWQgYSBwYXRjaCB1
c2luZyB0aGUgYWJvdmUgYXBwcm9hY2ggd2hpY2ggY2FuIGZpeCB0aGlzDQo+Pj4+IGlzc3VlDQo+
Pj4+IGFuZCB3aWxsIGhhdmUgbm8gb3IgbWluaW1hbCBpbXBhY3Qgb24gZXhpc3RpbmcgZnVuY3Rp
b25hbGl0eS4gVGhlDQo+Pj4+IHNhbWUNCj4+Pj4gaXMgY29waWVkIGJlbG93Og0KPj4+Pg0KPj4+
Pg0KPj4+PiAtLS0NCj4+Pj4gwqAgLi4uL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAv
bmV0ZGV2LmjCoCB8wqAgMSArDQo+Pj4+IMKgIC4uLi9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dp
bGMxMDAwL3NkaW8uY8KgwqDCoCB8IDQ2DQo+Pj4+ICsrKysrKysrKysrKysrKysrLS0NCj4+Pj4g
wqAgLi4uL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xhbi5jwqDCoMKgIHzCoCAy
ICstDQo+Pj4+IMKgIDMgZmlsZXMgY2hhbmdlZCwgNDUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlv
bnMoLSkNCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3Jv
Y2hpcC93aWxjMTAwMC9uZXRkZXYuaA0KPj4+PiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3Jv
Y2hpcC93aWxjMTAwMC9uZXRkZXYuaA0KPj4+PiBpbmRleCA0M2MwODVjNzRiN2EuLjIxMzdlZjI5
NDk1MyAxMDA2NDQNCj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dp
bGMxMDAwL25ldGRldi5oDQo+Pj4+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hp
cC93aWxjMTAwMC9uZXRkZXYuaA0KPj4+PiBAQCAtMjQ1LDYgKzI0NSw3IEBAIHN0cnVjdCB3aWxj
IHsNCj4+Pj4gwqDCoMKgwqDCoCB1OCAqcnhfYnVmZmVyOw0KPj4+PiDCoMKgwqDCoMKgIHUzMiBy
eF9idWZmZXJfb2Zmc2V0Ow0KPj4+PiDCoMKgwqDCoMKgIHU4ICp0eF9idWZmZXI7DQo+Pj4+ICvC
oMKgwqAgdTMyIHZtbV90YWJsZVtXSUxDX1ZNTV9UQkxfU0laRV07DQo+Pj4+DQo+Pj4+IMKgwqDC
oMKgwqAgc3RydWN0IHR4cV9oYW5kbGUgdHhxW05RVUVVRVNdOw0KPj4+PiDCoMKgwqDCoMKgIGlu
dCB0eHFfZW50cmllczsNCj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21p
Y3JvY2hpcC93aWxjMTAwMC9zZGlvLmMNCj4+Pj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNy
b2NoaXAvd2lsYzEwMDAvc2Rpby5jDQo+Pj4+IGluZGV4IDYwMGNjNTdlOWRhMi4uMTlkNDM1MGVj
YzIyIDEwMDY0NA0KPj4+PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2ls
YzEwMDAvc2Rpby5jDQo+Pj4+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93
aWxjMTAwMC9zZGlvLmMNCj4+Pj4gQEAgLTI4LDYgKzI4LDcgQEAgc3RydWN0IHdpbGNfc2RpbyB7
DQo+Pj4+IMKgwqDCoMKgwqAgdTMyIGJsb2NrX3NpemU7DQo+Pj4+IMKgwqDCoMKgwqAgYm9vbCBp
c2luaXQ7DQo+Pj4+IMKgwqDCoMKgwqAgaW50IGhhc190aHJwdF9lbmgzOw0KPj4+PiArwqDCoMKg
IHU4ICpkbWFfYnVmZmVyOw0KPj4+PiDCoCB9Ow0KPj4+Pg0KPj4+PiDCoCBzdHJ1Y3Qgc2Rpb19j
bWQ1MiB7DQo+Pj4+IEBAIC0xMTcsNiArMTE4LDM2IEBAIHN0YXRpYyBpbnQgd2lsY19zZGlvX2Nt
ZDUzKHN0cnVjdCB3aWxjICp3aWxjLA0KPj4+PiBzdHJ1Y3Qgc2Rpb19jbWQ1MyAqY21kKQ0KPj4+
PiDCoMKgwqDCoMKgIHJldHVybiByZXQ7DQo+Pj4+IMKgIH0NCj4+Pj4NCj4+Pj4gK3N0YXRpYyBp
bnQgd2lsY19zZGlvX2NtZDUzX2V4dGVuZChzdHJ1Y3Qgd2lsYyAqd2lsYywgc3RydWN0DQo+Pj4+
IHNkaW9fY21kNTMNCj4+Pj4gKmNtZCkNCj4+Pg0KPj4+IElmIHlvdSBoYW5kbGUgYWxsIHRoZSBz
dGFjayBjYXNlcyBhbnl3YXksIHRoZSBjYWxsZXIgY2FuIGp1c3QgdXNlDQo+Pj4gYSBib3VuY2Ug
YnVmZmVyIGFuZCB5b3UgZG9uJ3QgbmVlZCB0byBkdXBsaWNhdGUgdGhlIGZ1bmN0aW9uLg0KPj4N
Cj4+DQo+PiBUaGFua3MuIEluZGVlZCwgdGhlIGR1cGxpY2F0ZSBmdW5jdGlvbiBjYW4gYmUgYXZv
aWRlZC4gSSB3aWxsIHVwZGF0ZQ0KPj4gdGhlDQo+PiBwYXRjaCBhbmQgc2VuZCBtb2RpZmllZCBw
YXRjaCBmb3IgdGhlIHJldmlldy4NCj4+IEJ0dywgSSB3YXMgdHJ5aW5nIHRvIHJlcHJvZHVjZSB0
aGUgd2FybmluZyBtZXNzYWdlIGJ5IGVuYWJsaW5nDQo+PiBDT05GSUdfREVCVUdfVklSVFVBTCBj
b25maWcgYnV0IG5vIGx1Y2suIEl0IHNlZW1zIGVuYWJsaW5nIHRoZSBjb25maWcNCj4+IGlzDQo+
PiBub3QgZW5vdWdoIHRvIHRlc3Qgb24gbXkgaG9zdCBvciBtYXkgYmUgSSBhbSBtaXNzaW5nIHNv
bWV0aGluZy4NCj4NCj4gRGlkIHlvdSBicmluZyB0aGUgaW50ZXJmYWNlIHVwPw0KDQpZZXMsIEkg
dGVzdGVkIGJ5IGJyaW5naW5nIHRoZSBpbnRlcmZhY2UgdXAgb24gU0FNQTVENCBYcGxhaW5lZCBo
b3N0Lg0KDQo+DQo+PiBJIHdvdWxkDQo+PiBuZWVkIHRoZSBoZWxwIHRvIHRlc3QgYW5kIGNvbmZp
cm0gaWYgdGhlIG1vZGlmaWVkIHBhdGNoIGRvIHNvbHZlIHRoZQ0KPj4gaXNzdWUgd2l0aCBpbXg4
bW4uDQo+DQo+IHN1cmUsIGp1c3QgcHV0IG1lIG9uIGNjIGFuZCBpIGNhbiB0ZXN0IGl0IG9uIG15
IGJvYXJkLiANCg0KU3VyZS4gVGhhbmtzLg0KDQoNClJlZ2FyZHMsDQpBamF5DQoNCg==
