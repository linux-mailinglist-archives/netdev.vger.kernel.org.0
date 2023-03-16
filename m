Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9886BC513
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjCPEED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCPED7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:03:59 -0400
Received: from CY4PR02CU008-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11012000.outbound.protection.outlook.com [40.93.200.0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12296A17C4;
        Wed, 15 Mar 2023 21:03:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYqwZ8HKq+5bK89gp/ByNy+c8xZyFAXVpsXQNHpBJ324lWa++6QOTnm4McXCDxvhXhUxRekUhnGKugSwrxSTufKoyHzxA5hiPBT7gZTswvmx/ccW2os8R9KtnEtisUgaQJpRenJVzc9CsPjJY7QYgkgzHXS999OVgKP9Q2tWO2N3jisTQHF9oVQ/dIUomlqkFPXMt4yagXvq5f9gl4Axv73jLuAgdxu6GNnCouCiQq6rE2nT/NGdii7ytVnsVZqB9XdwDY+4zvriFIW/0c0Mb+6WseMgkQNa63p1uSVWgxAwsNP1itcN//lvfsuBx1qLDpzh9790AavswpdelART2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p66ZWNIC2Jby7MaiBI0VTufVIK7nXOnSSgHI6LBxl/8=;
 b=TMjzUBRZsiYTUad9+yokDIeE0wYFBTAbSMnqa5mydrqg6e7wh69Yl5lTJ4d+fKegQG4LssPfQV4VrrdyryXyhsJsUKR7UQhfSQEW5CNCuRU+zETzn4cOoGeppaiXKBjbd87se8YV8A2jVPMqhsU4260PhvtHQWep58/LtM64E5A4PHgSQ8icSkT9NI2hpoThwlpTXVqSj2EaAUbb+nf1ogm1VkveCP+iI+eQbrhJwz87pOzdgA/XSmtHlimID+eDqTP9YpWtJqI5OszLin3vKmMk2zWmz8/QrTsxoWx77OGhRTEJvK/7j6u30RI3MdFlHaOnAUTBOY1nhpnIZNUcIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p66ZWNIC2Jby7MaiBI0VTufVIK7nXOnSSgHI6LBxl/8=;
 b=TkgaBv7IG0fLPR2D+IXWQkt2fMVk+vk+zpYShTlldv27QBhVmKzG6886tGzL6fblnFRMEUY5dLhokKLaUl7Z+vv6JwnZKccnYdsx/vaTXc3SdjgD0HcIEETmY0rnFohTfcNAM7aN5ZDxh7tKpUgyJpVe+T/Vka35RmW09Z7Mo4U=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by SN6PR05MB5775.namprd05.prod.outlook.com (2603:10b6:805:fb::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 04:03:52 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb%7]) with mapi id 15.20.6178.029; Thu, 16 Mar 2023
 04:03:52 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Topic: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Index: AQHZUgzlNAVJE7qL50u4mFq6JoP4Ta7xmZqAgADvKQCAAKsUgIAHJTAAgADERoD//5SOgIAAf+AAgADlBQCAAJecAP//sNOA
Date:   Thu, 16 Mar 2023 04:03:52 +0000
Message-ID: <1743CDA0-8F35-4F60-9D22-A17788B90F9B@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
 <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
 <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
 <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
 <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
 <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
 <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
 <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
 <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
 <77c30632-849f-8b7b-42ef-be8b32981c15@huawei.com>
In-Reply-To: <77c30632-849f-8b7b-42ef-be8b32981c15@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.70.23021201
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|SN6PR05MB5775:EE_
x-ms-office365-filtering-correlation-id: 0306c7cc-2e8c-4f86-e277-08db25d37431
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y4l4T82WSTltCy7O8cVttQyHsyfAh7P/OPnqNaQE8+dJxLgedHU4DxPveEmZnXnvtx4t//NZEwarhL/PhP9f54XsB1UDC/uoe6ScR+wZSYk1i5udsPkeTyTVb1aPPvDPPEV3YHHuPRb1om3lhnbXEPt/kUv5R+74C7pjTRNypjgiqE66GzH3DDN21es3jnPcnJrGSdYdabEFXkRT+CvwQmCSvDsB+1Qd0URmC33QE7u/4GCnRl6H+aiGxT8nK1jFrqfqkM4hy0lhWZ5HhuBR+dH3uXqjA0KDZsCt1PDmohBG2mkVZfHgy89yB92UwZDw2aheO858ThTIWi+wpcQKB4ZrYRwbgEqAJLAeQ4AnTXKbrmVswva9yRg5fjn9gKJ13lsHXWfJGcRiXF5IKqfIFlC/OyHOsW0lAB22bp3Vdy3EozxplJHtuHK8Y0+szLCSgPUFCsFz4SRTL/wpiaGZN4spnD6bKLDzV48hpv/uoxqt+WGO4x7NnP13bxwBxAc6nrWuXzABlo4yS71b+izgDM3DWWMMni4pfyD+78CRknhQ3plZwiJ/dmkBJojUfPDJwRfESt8RpDU/vLJzw4snevra+ynHETXu5PJgMwqIssLgiP8cZohwvkjtYvkD3I+ABl+OKT3xhUW9uINh49O2Zz22m8kxza474oc0g5czm2fM0KemUPtFez2gu/LTYNbj8DtUA8pllMtLkGcL3zlnl0Tvxqpkl1Ti+HuuaL1DmWE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199018)(36756003)(66556008)(4326008)(66476007)(76116006)(8676002)(186003)(66946007)(64756008)(66446008)(2616005)(33656002)(8936002)(86362001)(5660300002)(122000001)(478600001)(54906003)(6506007)(110136005)(38100700002)(6512007)(71200400001)(316002)(6486002)(41300700001)(53546011)(2906002)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkYrWjRmM3lscEJ6MzhtZVlFWUh6ZTQvcGRjZVljakZMWktQbkNoaE92cjRm?=
 =?utf-8?B?TGRXdVNjclNqZzFwdThJdzgwb2tVU0R0YnFTdENwaVNOa0xzTGVPcXRweHBX?=
 =?utf-8?B?MWk1eDhQMDdZZklnOWpnVGN5TmppbHFSU2Q1R2wwWUFHYXdFSENqY1dXSVJD?=
 =?utf-8?B?TWZiL1BLTklrOWxtbUJoekpEVFlwdDlXREpwQ1JTZkdObG9acktNckhqb2VG?=
 =?utf-8?B?VFBQVUxvNFA5SlhJOVd4OWJTOVdSL3ZLMEg1MDJ3QzlZdUIzMjBYNk8wVFRi?=
 =?utf-8?B?bm5WdUV4SUlPa2ExRHllUlc5djJSNUdka2RHWnlMa0g1TFdIdnVJTXlobjZ1?=
 =?utf-8?B?VUMyd09CcTI1YXhBUzR6bENCa2kxVkp1TlJwdGREeWJrQUNuSDhvVFVNZkUv?=
 =?utf-8?B?R0djTVBnUzRpelRzcStUZlBrK0RjQmJaRXI4VWdKZ3RrQ3pZbG4xR2Y2d05j?=
 =?utf-8?B?dTdUc3libHBtTGoxanlHYXV1OVZmS3QzV1lJQ245UWk4R2dJZkVwcmxNK1pk?=
 =?utf-8?B?dHgyK29pVWkwUWdLeXpGSi9nbFNTZDNjVHkrdm1aQjlNL25pMlJlYlh2ZUVI?=
 =?utf-8?B?SU1EZXp1cnRjL3JLblJnQm41cHBRdU1od2pJQVo1TzFyQmRtVnNOMmtNQ3Qy?=
 =?utf-8?B?ZUtQS2VmTnJMazZHQkk0L1pFSEFLdHB5UXl6bmtLRVUwUkVXSjNnQmNSL2lW?=
 =?utf-8?B?RHduQXViSjNwY3VhdlNWYldzWGU4SzlhYW0rL1NzUUhLYU0vNDNMYkFQUjYy?=
 =?utf-8?B?R1MrSFFCZ0F2VVpSa29FNmZ4ajF2TFQ3TDlmbHN5Znk4Tng5YjkrL1R1U2Z3?=
 =?utf-8?B?Q0todkRuQTJldmhFTldzc2VxR2plNGt0VnFhNlI3R09nMTB2SmxsR3Uzczkv?=
 =?utf-8?B?RGpCL2E5Q0hhRy9FclFOVlVsQjFHV0tLQjQvUFlodW8xRzYzMG5ldlVwU014?=
 =?utf-8?B?dGN3Q1M2Sk5CNDZRRzBDR0ZmbUVWeC90MnBxQ1JEQVlnNm5ES01vTDJKZkda?=
 =?utf-8?B?M3BubGZEUEVPbmVIWFhwcFhHWjlOdEFPR3pONFFQVnpmMWRTOGJaSjVGZmox?=
 =?utf-8?B?S2hUYTRGTDFKZm9mM1NlUzE1VlV0c0Z0QVNMQXlPY3RWNUJCMFZlbWJhaEFP?=
 =?utf-8?B?REpnREQ1eDB2K3RUai9md1BvU1YzR1pSOGovSkdLWWVnT0pZZUFHSXAwMlFn?=
 =?utf-8?B?WFZWa2NDUDZDVDlWcUlUeGJtbE5UeUxjclN5dWIwV1NSclhvaFBlL0s3MnM4?=
 =?utf-8?B?elBhOE1jSmhzZUFPRU9kVHJ6Rmlaa1dRVndld2FydVNqQ1N0Nkd4blhjbDRT?=
 =?utf-8?B?aEU0VlQxenpUeG9xMVQ2aG1oUXc4cXI2Z3h3ZkdKVFhDZGhWaGpic3dvejRP?=
 =?utf-8?B?QlU4SGJGcmM4TmRHb1V3SzJMU1B1QXZIY2UyNVVGOUJEbVM3cmZsUVp6amFF?=
 =?utf-8?B?MllHYzAwMUxEYmRYUm1LREtab3N0T3FLSWdHR21KS0ZWTWxnWHR6R1VvTWhJ?=
 =?utf-8?B?QndwR0tKa1B2Y3FmNEdCQmMvYk1FbzgyR1lVTjM1dXBWRUo4VGhtdTd1SjRP?=
 =?utf-8?B?RnpzTzFaNzZKQlJPd2Y0M2hXRmtCaTc3Z1FDdjgwOHdyRGl6SW5pRWZrZWxz?=
 =?utf-8?B?dENpVzhGS0ZrT0lwQm1Bd1VOM2szdFc5REgrRStOMWp0RnRjc2c2SW9iN2F4?=
 =?utf-8?B?eDVrRVJWSjV5VVhMUXA1ZWp3MzVlTExaemR4UGxEZG5QVzVVenhPVXFCbFFh?=
 =?utf-8?B?bXlwUEZIcTJiN1kyK3RlV2JPcUdxdGkydU5DMWpHc3B4aFJlVGpOWWl5UEVm?=
 =?utf-8?B?SXhHQVhldEJIOExlRGVHQm1zVndvSUNuQkJKL0NLYVlQcHR3b0ZHWHVhVWZN?=
 =?utf-8?B?cnV3b1JMZEpVWG5pSFk3ODNteDd5U1ZUbTlsMzFPZDhGekVaSElZOERtTkxS?=
 =?utf-8?B?Znp4aGR0QU5tbmFMYlN5eG5sNmRRR0tUM3ZadnpKNkJpWlROTFFMa2tYWEJM?=
 =?utf-8?B?Q08wSGNyd0xxUVJPUzNMd0VPQTk3cTZ0Z0dwOU9IY0VBMlYrZ1dCWmZOTzdj?=
 =?utf-8?B?dFFMTXU2NFJEbDV4OXlYeUFjTkhzeDBYL3A5U0s0S0xFbHFNL0daZURyZ0tK?=
 =?utf-8?B?MWMxczF3UlIreG5zT2I0SWFNWkJrUE0wVVExY0Jhc290NHo4N0VOOE5FdFlM?=
 =?utf-8?Q?lWtgJ/gW2eYbkJF/qMxsB+1oCE2xZQJ0xQII9DZag2v5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <830000E56B157A4989762B50EADEAECA@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0306c7cc-2e8c-4f86-e277-08db25d37431
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 04:03:52.0498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MkIupcT4HPSnK+J4g0+FT6CoE5tDTZK+6WV2uKxOoPTBNnbI8qWC3+yl+YoCJJjzOwJLwpFvwrrp5skBYAfbqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5775
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu78+IE9uIDMvMTUvMjMsIDY6NDcgUE0sICJZdW5zaGVuZyBMaW4iIDxsaW55dW5zaGVuZ0Bo
dWF3ZWkuY29tIDxtYWlsdG86bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4+IHdyb3RlOg0KPg0KPiBU
aGF0J3MgdGhlIHBpb250IEkgYW0gdHJ5aW5nIHRvIG1ha2UuDQo+IElmIEkgdW5kZXJzdGFuZCBp
dCBjb3JyZWN0bHksIHlvdSBjYW4gbm90IGNoYW5nZSBjYWxsYmFjayBmcm9tIG5hcGlfZ3JvX3Jl
Y2VpdmUoKSB0bw0KPiBuZXRpZl9yZWNlaXZlX3NrYigpIHdoZW4gbmV0ZGV2LT5mZWF0dXJlcyBo
YXMgdGhlIE5FVElGX0ZfR1JPIGJpdCBzZXQuDQpXaGVyZSBhcmUgd2UgZG9pbmcgdGhpcz8gT3Vy
IHByZWZlcmVuY2UgaXMgdG8gdXNlIG5ldGlmX3JlY2VpdmVfc2tiKCkgb25seSB3aGVuIExSTyBp
cyBlbmFibGVkLg0KSWYgYm90aCBMUk8gYW5kIEdSTyBhcmUgZW5hYmxlZCBvbiB0aGUgdm5pYywg
d2hpY2ggQVBJIHNob3VsZCBiZSB1c2VkPw0KDQo+IE5FVElGX0ZfR1JPIGJpdCBpbiBuZXRkZXYt
PmZlYXR1cmVzIGlzIHRvIHRlbGwgdXNlciB0aGF0IG5ldHN0YWNrIHdpbGwgcGVyZm9ybSB0aGUN
Cj4gc29mdHdhcmUgR1JPIHByb2Nlc3NpbmcgaWYgdGhlIHBhY2tldCBjYW4gYmUgR1JPJ2VkLg0K
RXZlbiBpZiB0aGUgcGFja2V0IGlzIGFscmVhZHkgTFJPJ2VkPw0KDQo+IENhbGxpbmcgbmV0aWZf
cmVjZWl2ZV9za2IoKSB3aXRoIE5FVElGX0ZfR1JPIGJpdCBzZXQgaW4gbmV0ZGV2LT5mZWF0dXJl
cyB3aWxsIGNhdXNlDQo+IGNvbmZ1c2lvbiBmb3IgdXNlciwgSU1ITy4NCkFzIGxvbmcgYXMgTFJP
IGlzIGVuYWJsZWQgYW5kIHBlcmZvcm1lZCBieSBFU1hpICh3aGljaCBpdCB3aWxsIGRvKSwgSSBk
b27igJl0IHRoaW5rIHVzZXIgY2FyZXMgZm9yIEdSTy4NCkV2ZW4gaWYgd2UgdXNlIG5hcGlfZ3Jv
X3JlY2VpdmUoKSBmb3Igc3VjaCBjYXNlLCBpdCBkZWdyYWRlcyB0aGUgcGVyZm9ybWFuY2UgYXMg
dW5uZWNlc3NhcnkgY3ljbGVzDQphcmUgc3BlbmQgb24gYW4gYWxyZWFkeSBMUk8nZWQgcGFja2V0
Lg0KDQoNCj4gQXMgYWJvdmUsIHRoZXJlIGlzIGRpZmZlcmVudCBmZWF0dXJlIGJpdCBmb3IgdGhh
dCwgTkVUSUZfRl9MUk8sIE5FVElGX0ZfR1JPIGFuZA0KPiBORVRJRl9GX0dST19IVy4NCj4gSU1I
TywgZGVjaWRpbmcgd2hpY2ggY2FsbGJhY2sgdG8gYmUgdXNlZCBkZXBlbmRpbmcgb24gc29tZSBk
cml2ZXIgY29uZmlndWF0aW9uDQo+IHdpdGhvdXQgY29ycG9yYXRpb24gd2l0aCB0aGUgYWJvdmUg
ZmVhdHVyZSBiaXRzIGRvZXMgbm90IHNlZW1zIHJpZ2h0IHRvIG1lLg0KDQpXZSBhcmUgbm90IG5l
Z2xlY3RpbmcgZmVhdHVyZSBiaXRzLiBXZSBqdXN0IGtub3cgdGhhdCBpbiBVUFQgTFJPIHdvbuKA
mXQgYmUgZG9uZSwgc28gd2UgYnkNCmRlZmF1bHQgdXNlIG5hcGlfZ3JvX3JlY2VpdmUoKSBjYWxs
YmFjay4NCg0KVGhhbmtzLCANClJvbmFrDQoNCg==
