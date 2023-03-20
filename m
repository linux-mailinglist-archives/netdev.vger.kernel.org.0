Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FAB6C0DA3
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCTJqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjCTJqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:46:12 -0400
Received: from outbound-ip23b.ess.barracuda.com (outbound-ip23b.ess.barracuda.com [209.222.82.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6EE1F92A
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 02:45:48 -0700 (PDT)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48]) by mx-outbound-ea21-206.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Mar 2023 09:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eomOMOwO7u3/jxevj8t0M3e9s28ZfSEA5yncVvPe7q25lVUzz9jE2E1afImkNb+3AfQvb5vBHdJsUqmvGD7CQ7radmmOl0p6YPZEBbfOiZO743GZ8poFfMmAxyfxbIS+HeBrWYDM0II0WygzSFG3RAQkhRIhY7mN7JlVMsFXw9SzNbzDgS3j1GiRVrM9w7RLj46AEzy8+cGHSd3FwTPPHznCTU2urvPfCzUJpSCC+YG8xmtRzcH03g8Hp98zAF0uVu2r1xaQDv6GytErwFjwdpWStkXyNhKlNG0Ij/BFcW8axCaos+VcfDXdRQb/e10YkrOyikYpqWSFQozAwo0gfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+rqbEGWdZfsMZl4Pj8N16jgLp+Ltb7+S4G0Onh3AUg=;
 b=PKTaGhTTjA6WqjjTcl+L+ADqVwfw68bIdKsbesAUNrkMz8XntSDIuB8JXpMlYtunp/jW5QxumbsyXiiJGFrZ9BCVZfdXRjX5p5FbLei56eCMkUTnpLw8jkiu/N2rVpAsWCrOOIfvA+YzlYCZ+Q8JGNtLaI+1jbR5Yc0meEyLB/oXoRcIb/6nfLWa6QcSxbsShyRxD+X9f3YZZnsqg8ctRYaXD5YvyQwZ2iFA0n6Ao3xJKzTQSozBe4Wb95qrkNhdM0gZFh2LQOchK3BeXblkf1Mr4eI0k2NhsPCY/V2xGMRdr3ariJIb2dJ+bOtEky1gpa2t/iTC4n6C4Gb0hdJsVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+rqbEGWdZfsMZl4Pj8N16jgLp+Ltb7+S4G0Onh3AUg=;
 b=FB4fhnscsF4mYjP5l7TtGG1O+naRJeDhI6RzjOUt/KWGBDO2IiZ9mIvUToDfaZLCjnBEVukI+zFgyZvULUGLR2jTIy/p+AnxMfiGkUdFky0f28LAd0KYjRmxxK6cvWFLEGWRQk4zEWe9EGMF2XVYjP7QJ51x43A7+DmjV+3v36oqiVpxQKeuxqtaV5rHUwuBTG/v+nNvpf3sunyI+LKK86/WruFmTmD9HlbgNbh+uO3tfPzs00BkIEXDIRuwi2mY6dXFfUz+olrrWb/+HewPepDh+gdzLso5DlxlZM2TKZTr+bgh59XXGSL3TtVup2XaZCAKJ0aTdfubBTt0hBXZkA==
Received: from DS7PR10MB4926.namprd10.prod.outlook.com (2603:10b6:5:3ac::20)
 by DS7PR10MB5103.namprd10.prod.outlook.com (2603:10b6:5:3a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 09:45:39 +0000
Received: from DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::9ee4:1e8a:76b6:959b]) by DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::9ee4:1e8a:76b6:959b%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 09:45:39 +0000
From:   "Buzarra, Arturo" <Arturo.Buzarra@digi.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: RE: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Thread-Topic: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Thread-Index: AQHZWP1FSdAaHxazwkKnE2fAhKZFWq8DUXYQ
Date:   Mon, 20 Mar 2023 09:45:38 +0000
Message-ID: <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
 <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
In-Reply-To: <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
Accept-Language: es-ES, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digi.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4926:EE_|DS7PR10MB5103:EE_
x-ms-office365-filtering-correlation-id: ecdfedd6-41d7-4493-d2bc-08db2927dce2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ENoVGe8Tjz/ref2WyzIHDnj6wVLdGUA5xtE5iI0VPjQILmOyrJJzi8df+8h1PLKrnl2NuE24ojdTOf/kggTX6eik/aetPVBrL/AobDXm9hDySnRSAS9V4Ovt2cYOXoT29nz+RHkfMTHrtgYYU/yPZ2YC+j5n59SHHEiNmLr/9Xjhh7+yFE6IBnIefhMDr2TbfO4qF7e7dQSaRVemBFZxTIgVkM4NBDcpQlnfBcaOEEf6lhyFBt7u9VszHEb0v9tuk7zvFxnRk1a1pNcFa7FGpZvLQM4J7gbfmmCKtX8xwuBz26VxNeldLSr3fbOob3pXb1Nh3thSX1qM9ODoWFNJ8xmtmElIaM89DEDOo9/Cp+i2tg7g07muMggzOwwLVbrid8uy6/JgRgx/RlGa72QAZvG/FjnQEB5JFYJq3OQUi8/LS0/7qiILuWDWYoSLKyF9uu1ahCEe9USRovWOIBo7BoMhUuHsPsLxvw/RVRUJ1UPqRrHEm1LZstw+fOuLULznglEhk9Sf5BsZBuI1EzvYH3LcSUJzmHbc8A68aA8uccucNRxguW2hmdNnDDmEb7h9gJZdM5qIlJuXease41A7iOftcJr64xjxZxZHa9imfW89iVXcroLx9qfTmg7S9n/U2KcNuYbvqvK9ZIJLED3mWYGocjQg7d1WmZu9V6jfXxl0Mqa0qPSiWy+ULliqQgLSCkr7K8fWNpFoUHsmNE9ipg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4926.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(39850400004)(376002)(136003)(346002)(451199018)(8936002)(5660300002)(52536014)(55016003)(86362001)(33656002)(38070700005)(38100700002)(122000001)(2906002)(4326008)(83380400001)(478600001)(71200400001)(41300700001)(7696005)(186003)(26005)(6506007)(53546011)(9686003)(66899018)(54906003)(316002)(8676002)(66476007)(76116006)(66446008)(66946007)(64756008)(6916009)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVFQMkZJVEsvMVN0TzBwczFvR1l6dFZMQmx5YXBKT09la1Q3UmtIVnpDczBR?=
 =?utf-8?B?MWRKV29UbnVsWisxQzhIY2psdng2cGZXUWtBZmk5RFV2QVljUGJOSEJUOGlI?=
 =?utf-8?B?YkhQMmRtMWk2Qk1tK1ppRThsblF6V2k5MEtqdm94V0phVExWTGNNWml6cXZa?=
 =?utf-8?B?Y3ByS044Zm01empHWlVNMHRpRW1va0RkWGw5WlF4Qnl3MkpHSWE4WkY1b09S?=
 =?utf-8?B?U2o4SjIrTG9DVDdUZ1laZmFYYXFyUEgwRVAzY3VOZmxzbDRkU0NXTDVYVlFh?=
 =?utf-8?B?R0NkVEN3NFlIdUkwVjlLWnNjdjlWRzBibkpTck9wOEtramZpdlNnT3RQQjh5?=
 =?utf-8?B?MG9KY3B0UjUySXZ1d1ZsRFJTUlZTN1daUE1DaGU2b0VEa1ZESDMwTnlRTWJD?=
 =?utf-8?B?MmQ4QWpoSTVTdjV3akJIUFlWUTBibnhwNjFFaGZBZmpjdXdKVnd0RXkxZEpM?=
 =?utf-8?B?dERwNUh5a3c3d2crOGxsRWlXeE9XckllL1BlU21qdkk2SURITWl4SmQ5MkV5?=
 =?utf-8?B?VFFKQis4M08rcnVsMUIvTDNpaTdwU0JXdVpkSUhJRTNib21jQWkvYjVDK0ZE?=
 =?utf-8?B?VW5SWE9xNGEyZ3BaNjFuRUNjbkY0WFpYdHVaU3E5NDJMZ1IvTVM1aHZ6S1FS?=
 =?utf-8?B?TEMxR0ZSUHc0TWcxQVZ0eCtSenhCcnpZeVZrbkhWMWR3MjBobVFwaTNJY3VB?=
 =?utf-8?B?RWtMNDBUUVlIai9lV1pMSkZBeUJmeXdQN1dMNlpGWEVnOG40YURYU2NNa0hz?=
 =?utf-8?B?bWwrUTFrdEdtMk1ZRWlpUzl3dDluRm5CZ09hQWVrYmlTYndFT3g0THc5LzZr?=
 =?utf-8?B?V0JOSVpuN1pGUnduRUM4Y3Nzd1pDc3lIeFZHWFBTRjNHN0xhcGlWdU95ZWZl?=
 =?utf-8?B?N1RjYlVSdHBDUER5SDdkU2hNUVZkUWphUjVIRnA3ZEZrZDhYUWtYYnI0by95?=
 =?utf-8?B?UjBmV0U5bEN6K3p6SlpaV3JwbVJTbjA4cE9SaXJUdVRGSlM2QkgyanErMndB?=
 =?utf-8?B?NjlTWmpoVlpsK2cva3M4ZEZ5Ti9BaFllZDdJMFlUMjdham1scGtSVS82Zm9E?=
 =?utf-8?B?S3ZyNE1qVVA0UFoxT1Vhc0xTbWExaG1kcG5vRGJ3UG5QNDJMU251bVNyMkZH?=
 =?utf-8?B?K3lzQzg1MzFMeWlaL2hoakFvQzkrZE1XN1hydlNZSCtYQzFwV1BabWFvOVA3?=
 =?utf-8?B?STdkTm1FMVZkTFMxN2YxdGl5Z05QLytSRVRVSm5ISU9GQXVTelc3TEl0dXBK?=
 =?utf-8?B?Ry93Zm0zOWRxUXdSN3djT29DeFJqWFZuN2p0VWszM3RmZk9mOTdOK1RmVGMr?=
 =?utf-8?B?T2JGNE83TlJFWEtRQ3ZUYnp6QWdvUkpnNzk0T0FzVG9OalkvbTUvNmJMZ0FE?=
 =?utf-8?B?THRJRzVDYXQ3cFJQWDJ4SGFBUVIyNkRHNVVHeG9ydjYwU0pvU1I3dkFaUmh5?=
 =?utf-8?B?eE13Z2k2NGR2SlZwR212OEI3cnd0S3Z2L29hSU1vOVM5WGVTeXladXIvV2Vr?=
 =?utf-8?B?QWh3Tkdzc29STGtXOXl4ay9BRXpUVllUNkd0KzNqRzNGd2VJd25YZTVsYitH?=
 =?utf-8?B?WVVOdllObzRram5rak04eWgxTnIxL2FBeVh1WlR6eWVGU3lKK3RwQUQvL25q?=
 =?utf-8?B?WXQxb1dkalc0UmZLMzgxMEc1emYrc3VFWkJiRCswR0dNVm03ajJmcUM1dmdq?=
 =?utf-8?B?L0JBbHgvN1NIeTQzd3ZhS1ZBeVFiR29GTVdQWjRrN2tZYWJLalJrRExjTER2?=
 =?utf-8?B?TDlwQW93ZS9xck5HY3JuV2J6QkN1N2F2MFNDQWpjUHBQT1JJYXpjMThEdVpP?=
 =?utf-8?B?T3ZUYm5mV3ErTHFINXJsbG1HS0owZVVuZnZYVVBQU0NWSGZPQzdEaDNWMnlJ?=
 =?utf-8?B?T05ic3gzVG9ZTkc4ZHJicHJadkdSL1IyUFdOdkN6ak05UEFzbVhRZDBzRHRp?=
 =?utf-8?B?TDJEY0lwMGJDS2QvSXRJZGErRXRzNWdwY0xobDkvOXB2VnRQMGxxbWFpSHNt?=
 =?utf-8?B?UFhnNHp5dkZlNDhHQnd0czErOHc0Zks4ZEJId1ZvRURIeGNjUCtIYUs4NUtR?=
 =?utf-8?B?TTdNdHhvRWNMZ2wzU3UwUi9RdHowdEUvWGJaNGJJREs1VlJxajc4QnNGdVFj?=
 =?utf-8?Q?zGzPU2CaS8TfGxp14PKazLPEM?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4926.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecdfedd6-41d7-4493-d2bc-08db2927dce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 09:45:38.8904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cQ0Z3RTEa8L8ZGSO86jKhM+lSI1BSK0LqGVyV/2E43sYYXvlq/DpqwmK2bCIaGo6afc4Y5BE9VI0b5eNotUbSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5103
X-BESS-ID: 1679305541-105582-1671-428596-1
X-BESS-VER: 2019.3_20230317.1746
X-BESS-Apparent-Source-IP: 104.47.66.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVqYmpsZAVgZQ0CwlMTnR0CLN0s
        TMMNXAwNjMyMIgKTnV2MjIzNAkJdVCqTYWACQT8GZBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.246918 [from 
        cloudscan20-106.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkkgd2lsbCB0cnkgdG8gYW5zd2VyIGFsbCB5b3VyIHF1ZXN0aW9uczoNCg0KLSAiV2Ug
bmVlZCBtb3JlIHNwZWNpZmljcyBoZXJlLCB3aGF0IHR5cGUgb2YgUEhZIGRldmljZSBhcmUgeW91
IHNlZWluZyB0aGlzIHdpdGg/Ig0KLSAiIFNvIGJlc3Qgc3RhcnQgd2l0aCBzb21lIGRldGFpbHMg
YWJvdXQgeW91ciB1c2UgY2FzZSwgd2hpY2ggTUFDLCB3aGljaCBQSFksIGV0YyINCkknbSB1c2lu
ZyBhIExBTjg3MjBBIFBIWSAoMTAvMTAwIG9uIFJNSUkgbW9kZSkgd2l0aCBhIFNUIE1BQyAoIGlu
IHBhcnRpY3VsYXIgaXMgYSBzdG0zMm1wMSBwcm9jZXNzb3IpLg0KV2UgaGF2ZSB0d28gUEhZcyBv
bmUgaXMgYSBHaWdhYml0IFBIWSAoUkdNSUkgbW9kZSkgYW5kIHRoZSBhbm90aGVyIG9uZSBpcyBh
IDEwLzEwMCAoUk1JSSBtb2RlKS4NCkluIHRoZSBib290IHByb2Nlc3MsIEkgdGhpbmsgdGhhdCB0
aGVyZSBpcyBhIHJhY2UgY29uZGl0aW9uIGJldHdlZW4gY29uZmlndXJpbmcgdGhlIEV0aGVybmV0
IE1BQ3MgYW5kIHRoZSB0d28gUEhZcy4gQXQgc2FtZSBwb2ludCB0aGUgUkdNSUkgRXRoZXJuZXQg
TUFDIGlzIGNvbmZpZ3VyZWQgYW5kIHN0YXJ0cyB0aGUgUEhZIHByb2Jlcy4NCldoZW4gdGhlIDEw
LzEwMCBQSFkgc3RhcnRzIHRoZSBwcm9iZSwgaXQgdHJpZXMgdG8gcmVhZCB0aGUgZ2VucGh5X3Jl
YWRfYWJpbGl0aWVzKCkgYW5kIGFsd2F5cyByZWFkcyAweEZGRkYgKCBJIGFzc3VtZSB0aGF0IHRo
aXMgaXMgdGhlIGRlZmF1bHQgZWxlY3RyaWNhbCB2YWx1ZXMgZm9yIHRoYXQgbGluZXMgYmVmb3Jl
IGl0IGFyZSBjb25maWd1cmVkKS4NCkF0IHRoYXQgcG9pbnQsIHRoZSBQSFkgaW5pdGlhbGl6YXRp
b24gYXNzdW1lcyBsaWtlIGEgdmFsaWQgdmFsdWUgMHhGRkZGIGFuZCBvYnZpb3VzbHkgaXQgcmVw
b3J0cyBjYXBhYmlsaXRpZXMgdGhhdCB0aGUgTEFOODcyMEEgUEhZIGRvZXMgbm90IGhhdmUsIGxp
a2UgZm9yIGV4YW1wbGUgZ2lnYWJpdCBzdXBwb3J0Lg0KQSBmZXcgc2Vjb25kcyBsYXRlciwgdGhl
IEV0aGVybmV0IE1BQyBmb3IgUk1JSSBtb2RlIGlzIHByb2JlZCwgYnV0IEkgdGhpbmsgdGhhdCBp
dCBpcyB0b28gbGF0ZSAoIHdlIGFyZSB3b3JraW5nIHdpdGggdGhlIG1hbnVmYWN0dXJlciB0byBp
bnZlc3RpZ2F0ZSBpdCkNCg0KLSAiIElmIHlvdXIgUEhZIHJlcXVpcmVzICJzb21lIHRpbWUiIGJl
Zm9yZSBpdCBjYW4gYmUgcmVhZHkgeW91IGhhdmUgYSBudW1iZXIgb2Ygd2F5cyB0byBhY2hpZXZl
IHRoYXQiDQpJIHJldmlld2VkIHRoZSBQSFkgZGF0YXNoZWV0IGFuZCB3ZSBtZWFzdXJlIHRoZSBw
b3dlci1vbiBsaW5lcyAocG93ZXIsIGNsb2NrLCByZXNldCwgZXRjLikgYW5kIHdlIGFyZSBjb21w
bGlhbnQgd2l0aCB0aGUgcG93ZXItb24gc2VxdWVuY2UuDQpBbHNvLCBJIGltcGxlbWVudCBhIHJl
dHJ5IHN5c3RlbSB0byByZWFkIHNldmVyYWwgdGltZXMgdGhlIHNhbWUgTUlJX0JNU1IgcmVnaXN0
ZXIsIGV2ZW4gd2l0aCBhIGxvbmcgZGVsYXlzIGJ1dCBuZXZlciByZWFkcyB0aGUgcmlnaHQgdmFs
dWUsIHNvIEkgYXNzdW1lIHRoYXQgaXQgaXMgbm90IGFuIGlzc3VlIGluIHRoZSBQSFkgaW5pdGlh
bGl6YXRpb24uDQoNCi0gIiBBcmUgeW91IHJlc2V0dGluZyB0aGUgZGV2aWNlIHZpYSBhIEdQSU8/
IFR1cm5pbmcgYSByZWd1bGF0b3Igb2ZmL29uZSBldGM/Ig0KQXMgSSBzYWlkIGJlZm9yZSwgd2Ug
Y2hlY2sgdGhlIHBvd2VyLW9uIHNlcXVlbmNlIGFuZCB3ZSBtYXRjaCB3aXRoIHRoZSBkYXRhc2hl
ZXQsIGZvciBvdXIgdGVzdCBwdXJwb3NlcyB3ZSB0cmllZCB0byBwZXJmb3JtIGEgaGFyZHdhcmUg
cmVzZXQgKHVzaW5nIGEgZ3BpbyBmb3IgdGhlIHJlc2V0IGxpbmUpIGJ1dCBub3RoaW5nIGhlbHBz
IGhlcmUuDQoNCi0gIiBEb2VzIHRoZSBkZXZpY2UgcmVsaWFibHkgZW51bWVyYXRlIG9uIHRoZSBi
dXMsIGkuZS4gcmVhZGluZyByZWdpc3RlcnMgMiBhbmQgMyB0byBnZXQgaXRzIElEPyINClJlYWRp
bmcgdGhlIHJlZ2lzdGVycyBQSFlTSUQxIGFuZCBQSFlTSUQyIHJlcG9ydHMgYWxzbyAweEZGRkYN
Cg0KLSAiIElmIHRoZSBQSFkgaXMgYnJva2VuLCBieSBzb21lIHlldCB0byBiZSBkZXRlcm1pbmVk
IGRlZmluaXRpb24gb2YgYnJva2VuLCB3ZSB0cnkgdG8gbGltaXQgdGhlIHdvcmthcm91bmQgdG8g
YXMgbmFycm93IGFzIHBvc3NpYmxlLiBTbyBpdCBzaG91bGQgbm90IGJlIGluIHRoZSBjb3JlIHBy
b2JlIGNvZGUuIEl0IHNob3VsZCBiZSBpbiB0aGUgUEhZIHNwZWNpZmljIGRyaXZlciwgYW5kIGlk
ZWFsbHkgZm9yIG9ubHkgaXRzIElELCBub3QgdGhlIHdob2xlIHZlbmRvcnMgZmFtaWx5IG9mIFBI
WXMiDQpJIGhhdmUgc2V2ZXJhbCB3b3JrYXJvdW5kcy9maXhlZCBmb3IgdGhhdCwgdGhlIGVhc3kg
d2F5IGlzIHNldCB0aGUgUEhZIGNhcGFiaWxpdGllcyBpbiB0aGUgc21zYy5jIGRyaXZlciAiIC5m
ZWF0dXJlcwk9IFBIWV9CQVNJQ19GRUFUVVJFUyIgbGlrZSBpbiB0aGUgcGFzdCBhbmQgaXQgd29y
a3MgZmluZS4gQWxzbyBJIGhhdmUgYW5vdGhlciBmaXggaW4gdGhlIHNhbWUgZHJpdmVyIGFkZGlu
ZyBhIGN1c3RvbSBmdW5jdGlvbiBmb3IgIiBnZXRfZmVhdHVyZXMiIHdoZXJlIGlmIEkgcmVhZCAw
eEZGRkYgb3IgMHgwMDAwIHJldHVybiBhIEVQUk9CRV9ERUZFUi4gSG93ZXZlciBhZnRlciByZXZp
ZXcgYW5vdGhlciBkcml2ZXJzIChuZXQvdXNiL3BlZ2FzdXMuYyAsIG5ldC9FdGhlcm5ldC90b3No
aWJhL3NwaWRlcl9uZXQuYywgbmV0L3Npcy9zaXMxOTAuYywgYW5kIG1vcmUuLi4pICB0aGF0IGFs
c28gY2hlY2tzIHRoZSByZXN1bHQgb2YgcmVhZCBNSUlfQk1TUiBhZ2FpbnN0IDB4MDAwMCBhbmQg
MHhGRkZGICwgSSB0cmllZCB0byBzZW5kIGEgY29tbW9uIGZpeCBpbiB0aGUgUEhZIGNvcmUuIEZy
b20gbXkgcG9pbnQgb2YgdmlldyByZWFkIGEgMHgwMDAwIG9yIDB4RkZGRiB2YWx1ZSBpcyBhbiBl
cnJvciBpbiB0aGUgcHJvYmUgc3RlcCBsaWtlIGlmIHRoZSBwaHlfcmVhZCgpIHJldHVybnMgYW4g
ZXJyb3IsIHNvIEkgdGhpbmsgdGhhdCB0aGUgUEhZIGNvcmUgc2hvdWxkIGNvbnNpZGVyIHJldHVy
biBhIEVQUk9CRV9ERUZFUiB0byBhdCBsZWFzdCBwcm92aWRlIGEgc2Vjb25kIHRyeSBmb3IgdGhh
dCBQSFkgZGV2aWNlLg0KDQpUaGFua3MsDQoNCkFydHVyby4NCg0KLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCkZyb206IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+IA0K
U2VudDogdmllcm5lcywgMTcgZGUgbWFyem8gZGUgMjAyMyAxOToyMQ0KVG86IEJ1emFycmEsIEFy
dHVybyA8QXJ0dXJvLkJ1emFycmFAZGlnaS5jb20+DQpDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+OyBBbmRyZXcgTHVubiA8
YW5kcmV3QGx1bm4uY2g+OyBSdXNzZWxsIEtpbmcgLSBBUk0gTGludXggPGxpbnV4QGFybWxpbnV4
Lm9yZy51az4NClN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5ldDogcGh5OiByZXR1cm4gRVBST0JFX0RF
RkVSIGlmIFBIWSBpcyBub3QgYWNjZXNzaWJsZQ0KDQpbRVhURVJOQUwgRS1NQUlMXSBXYXJuaW5n
ISBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uISBEbyBu
b3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6ZSB0
aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUuDQoNCg0KDQpPbiAxNy4wMy4y
MDIzIDEzOjE2LCBhcnR1cm8uYnV6YXJyYUBkaWdpLmNvbSB3cm90ZToNCj4gRnJvbTogQXJ0dXJv
IEJ1emFycmEgPGFydHVyby5idXphcnJhQGRpZ2kuY29tPg0KPg0KPiBBIFBIWSBkcml2ZXIgY2Fu
IGR5bmFtaWNhbGx5IGRldGVybWluZSB0aGUgZGV2aWNlcyBmZWF0dXJlcywgYnV0IGluIA0KPiBz
b21lIGNpcmN1bnN0YW5jZXMsIHRoZSBQSFkgaXMgbm90IHlldCByZWFkeSBhbmQgdGhlIHJlYWQg
Y2FwYWJpbGl0aWVzIA0KPiBkb2VzIG5vdCBmYWlsIGJ1dCByZXR1cm5zIGFuIHVuZGVmaW5lZCB2
YWx1ZSwgc28gaW5jb3JyZWN0IA0KPiBjYXBhYmlsaXRpZXMgYXJlIGFzc3VtZWQgYW5kIHRoZSBp
bml0aWFsaXphdGlvbiBwcm9jZXNzIGZhaWxzLiBUaGlzIA0KPiBjb21taXQgcG9zdHBvbmVzIHRo
ZSBQSFkgcHJvYmUgdG8gZW5zdXJlIHRoZSBQSFkgaXMgYWNjZXNzaWJsZS4NCj4NClRvIGNvbXBs
ZW1lbnQgd2hhdCBoYXMgYmVlbiBzYWlkIGJ5IEZsb3JpYW4gYW5kIEFuZHJldzoNCg0KInVuZGVy
IHNvbWUgY2lyY3Vtc3RhbmNlcyIgaXMgdG9vIHZhZ3VlIGluIGdlbmVyYWwuIExpc3QgcG90ZW50
aWFsIHN1Y2ggY2lyY3Vtc3RhbmNlcyBhbmQgYmVzdCB3aGF0IGhhcHBlbmVkIGV4YWN0bHkgaW4g
eW91ciBjYXNlLg0KDQpXaGVuIGdlbnBoeV9yZWFkX2FiaWxpdGllcygpIGlzIGNhbGxlZCB0aGUg
UEhZIGhhcyBiZWVuIGFjY2Vzc2VkIGFscmVhZHksIHJlYWRpbmcgdGhlIFBIWSBJRC4NCg0KU28g
YmVzdCBzdGFydCB3aXRoIHNvbWUgZGV0YWlscyBhYm91dCB5b3VyIHVzZSBjYXNlLCB3aGljaCBN
QUMsIHdoaWNoIFBIWSwgZXRjLg0KDQo+IFNpZ25lZC1vZmYtYnk6IEFydHVybyBCdXphcnJhIDxh
cnR1cm8uYnV6YXJyYUBkaWdpLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9waHkvcGh5X2Rl
dmljZS5jIHwgNCArKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+DQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvcGh5X2RldmljZS5jIA0KPiBiL2RyaXZlcnMv
bmV0L3BoeS9waHlfZGV2aWNlLmMgaW5kZXggMTc4NWYxY2VhZDk3Li5mOGMzMWU3NDE5MzYgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvcGh5L3BoeV9kZXZpY2UuYw0KPiBAQCAtMjYyOCwxMCArMjYyOCwxNCBAQCBpbnQgZ2Vu
cGh5X3JlYWRfYWJpbGl0aWVzKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgcGh5ZGV2LT5zdXBwb3J0ZWQpOw0KPg0KPiAgICAgICB2YWwg
PSBwaHlfcmVhZChwaHlkZXYsIE1JSV9CTVNSKTsNCj4gICAgICAgaWYgKHZhbCA8IDApDQo+ICAg
ICAgICAgICAgICAgcmV0dXJuIHZhbDsNCj4gKyAgICAgaWYgKHZhbCA9PSAweDAwMDAgfHwgdmFs
ID09IDB4ZmZmZikgew0KPiArICAgICAgICAgICAgIHBoeWRldl9lcnIocGh5ZGV2LCAiUEhZIGlz
IG5vdCBhY2Nlc3NpYmxlXG4iKTsNCj4gKyAgICAgICAgICAgICByZXR1cm4gLUVQUk9CRV9ERUZF
UjsNCj4gKyAgICAgfQ0KPg0KPiAgICAgICBsaW5rbW9kZV9tb2RfYml0KEVUSFRPT0xfTElOS19N
T0RFX0F1dG9uZWdfQklULCBwaHlkZXYtPnN1cHBvcnRlZCwNCj4gICAgICAgICAgICAgICAgICAg
ICAgICB2YWwgJiBCTVNSX0FORUdDQVBBQkxFKTsNCj4NCj4gICAgICAgbGlua21vZGVfbW9kX2Jp
dChFVEhUT09MX0xJTktfTU9ERV8xMDBiYXNlVF9GdWxsX0JJVCwgDQo+IHBoeWRldi0+c3VwcG9y
dGVkLA0KDQo=
