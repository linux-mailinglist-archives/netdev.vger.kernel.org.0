Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6356618029
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbiKCOxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiKCOxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:53:31 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868AA178B6;
        Thu,  3 Nov 2022 07:53:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSevKsEdBSPv0egU/+C7jqcYz0ax4oxM3jqjQ1zLpKSpPUFNVCYqjJuYVB/woBzGcfuGztFJ65SJsXQmFOEzvNA5iMCIeT3nWyWF7YXgU4+bg9NoFVhDaOE8mv/2q7bA4WiGpIJZW+KkjVjH1W2D0OaQ+Fpdr86MfiskT95e5xVnNe5cIGK+zqWTWF5M8xd7pMj8gFobE/uzZywWc7GXEAtgk0/rdgKn647Cf0Sh0O1eo7CypMWv6S2MThrVKypEee0V4M/iTEeANvvr4i+hYI2QzhRdILWxDANVya6qyEXoiQ2l5iEUgJTIfg7cu+0YGESox0oCp0VRd7aBCJKQtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcRAvbkiDBNp9b+fWvt42Ah/o6JZ345tmp3vrnrno50=;
 b=dsTc50iOwEhmdiWBFy3LRUPrjRs5wCWGsGoiPvRuh2hBv2M7V8CnKATdF2uJhhpaKa/VtlFO9PozrVcXXfBYwU1mCha4NjbzFRohsUAwY9DwdNkWjOuu9iF1QzfMewlpcX0fJn//cR7lcvfg7Y+B1XdBgU8Z6WQO1JPP2WFSo5PF6zLqp5BgpcPgGbaqgdawtKrTHYdNuJ076aaK/j/PiB2Wc/DEyAe9UQCwyPZ4UCyjaWrrRVUIJsaO9lE4Pgod3Fx1i/Wwcsp6F2CnDOp1wIU6J/ELpJ4zCWFnS557Z3NwezrmEHrC6GxFhBQ/8NGKgbO2xXMgUS1er6ATqYlWbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcRAvbkiDBNp9b+fWvt42Ah/o6JZ345tmp3vrnrno50=;
 b=mJQA/b4Zck9ONKB6hH/v0PHUtBivO5XA3fhT7jWhGvQXzneXaH1ujVC+MWPKqKG9TMz5p7S/RMjOGQ+hQF36pVwBHBtDBfgPNsC01Y5ILZB9SwI0TPlf3aATchwVwmn2mt8TqJn7ulVv5UCBvTHBdP5haM0mjpJtvfR5o22LwG4=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8094.eurprd04.prod.outlook.com (2603:10a6:102:1c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 14:53:15 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 14:53:15 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: RE: [EXT] Re: [PATCH v3 1/1] net: fec: add initial XDP support
Thread-Topic: [EXT] Re: [PATCH v3 1/1] net: fec: add initial XDP support
Thread-Index: AQHY7VopsdtynljWEEeLmd6kjPOb764s8C4AgABcb/A=
Date:   Thu, 3 Nov 2022 14:53:15 +0000
Message-ID: <PAXPR04MB91854F7D220BFD4F1617C54E89389@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221031185350.2045675-1-shenwei.wang@nxp.com>
 <4968ca694f800ad4cd5bc0659a13b82758a01b27.camel@redhat.com>
In-Reply-To: <4968ca694f800ad4cd5bc0659a13b82758a01b27.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PAXPR04MB8094:EE_
x-ms-office365-filtering-correlation-id: a574cdcb-150f-4517-f9ac-08dabdab2376
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ukToyeWlAF4H427AhOXwMXj780Ak2ADEAM+8kIMtxMSYOUNfUhbMkbQxo4TVui/ajaObVBRYMxiu/6mVTaE9VFdNWST0Eb3YsoUqjBrNZ1IJU8t2T5J/dT4tnggH8bl9a+LlTqQElm7k+RcC58RBLWDfBNpqli6QhN1BF7LRlGWOhppSRM9QLEMVlyDqJsiTvPYCtCRRpNRQPSSJOIQrAN687jOliIKISyI4JlqereiDr/Jsm2iJ2G0vGYn7u47Gjk7q/2HceTLHTRzoTBJHBBqPpyrcA7wbxakWic14OnkYmiKgjAqQmYwkLwd657BHDLhbClE9qoW2/NtLvRQNupekjWyG9z56qB8YW27P6O8zl5O73BV8kZc3ywxnvgueTd0ES0TJT9Cy1R+hqeZL7eU6CO9/xAR2tMPAzAionHeiEE65vwElZLl/AVYJS0AzW5yookXrtAti+BsNaSHc/dKhBzjadYt5+uJ0aOkZl2JedzGfa57gtLNDA7YfjBiC3IXP07Y9wVB8pDlyJLkX6JDga1GNl2MpPkaFmq1huRtJ2sToZLpfc60Ge/NHjvDd4JUJBFbuXWObXrbCS8Ws/bRe6x8Afgi2MtnVGpWd41DXvFx7cXwhfha18dDRM6kOT9TS6/CnAVVqoOXZQnvmOFUPd8Q1r/PFrJ2AZiuFbc3ZOwsDz1VZ6+a2+UCdu+FOaPbAgRTNEi1xySbIZTEFwsqR8M498cR6YQShu/PXF2hyuehilgP1f3Zj5MOScwn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199015)(122000001)(86362001)(38070700005)(83380400001)(38100700002)(33656002)(71200400001)(186003)(7696005)(6506007)(26005)(55236004)(110136005)(478600001)(7416002)(76116006)(8676002)(66946007)(4326008)(9686003)(66556008)(64756008)(66446008)(41300700001)(66476007)(4744005)(8936002)(316002)(2906002)(5660300002)(44832011)(52536014)(54906003)(55016003)(66899015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnBmM3NmdDExc0J2cEJ6RXc1UjRCdEFJeHBjdHY0NTk1eTYxZVVFM0FEWmFo?=
 =?utf-8?B?K0pPSmxhSXJHaE5WZi91VE5SOHJBTG9FQTlTY2dzdUJEaUd5ZDZXaDIyNXdQ?=
 =?utf-8?B?N05pYk9BQUV6SEY4eFllYkFoRnZJc3pyVEd5eWo3Q01hMXdPYXh2UVBnOTA5?=
 =?utf-8?B?ZENVNTVLWkN6a0pOeStYc3h1MHBJYlVtWUlOemxyakxrU0tCQlF5eDlLVWpy?=
 =?utf-8?B?RGdGWG1ZVlNmU2pCOG9jMzNwVmRKUkpWTDhEanB5OGpHbFJjUW05MDNyTXpO?=
 =?utf-8?B?OXNMRzVXSkZrRjBiZm5iY0Q5SzEweld0YngzNnFzNStUVnpNb0M0QkVIcVEx?=
 =?utf-8?B?WEZCY25hRjdOUENTYk9aN0JTNVJISGRRMEwxbm81c1U0ZWZyL1lJZ1JMME1u?=
 =?utf-8?B?aGZhMGszcTFWREVKUEF2TktGYWRlSEZDa2g5bDZZTUZWQ0tWbCtQczBSQ1Nk?=
 =?utf-8?B?VUgxVEl5dDUwdTcwTkdMbWo1OS9mb3F0TG16dWNhWXJ5RnhNd21vblRnS0hW?=
 =?utf-8?B?bTJ6MUVQaEo2TmtQMmlVbnlxWVlzRmdNV0tDb1YrdHlPZ0VJMzg5N2owejNo?=
 =?utf-8?B?ZEt2Z2lpMVRKeDB2dzhmcTBod2FjUXNPN2Z3disyZm4zNVRLa0RFd3pOMXJ2?=
 =?utf-8?B?MlNoN2VOQWdvWEQ4V0NudGxvelhnR2NQRjI2VmtVTktPeXRuWWpraWlUME5m?=
 =?utf-8?B?YW5nbFRUL3lnSER4RWhYMkVHbjR3WFdTVk1nbWlXd01Hc1dDSmR0blJQNGl5?=
 =?utf-8?B?ckliNXd2b3NJY1lZMGNVWi92SkZNdXlRTHZyYlVTL2NkRGRZMk5RSUltclVt?=
 =?utf-8?B?Vm1QQ3o2UXN0Wmc4U1IxbXM5S0ZPWkYwZ2FqRy8yUlJvTXNrNlBtMkhrVVZk?=
 =?utf-8?B?djJMalgrNFAwWENVTXVnMVJtTE5XZmtCNERXMnNaMjJaZjNVdjBkb3Q3d0tx?=
 =?utf-8?B?LzJhRC96RUhvb0dWaE9kV0pHOXVGTHVqWURMdEk3TGt6WUFBZDgzbVdENkln?=
 =?utf-8?B?WDRpcE9PQ3YvcjkvQ3FQSng2YlVyVmhMMTZBMFRZUHBjdlEwK0VDUGdpTVNk?=
 =?utf-8?B?SXBoNjRDT1MvU2x2T2xCazc0cE9yWVE3VXl3SXNLSzhUTGw2dFJqd1dKcTBv?=
 =?utf-8?B?UkVQVzlNVWNCTFJIMG1KT1RmV09BNTdmSVBtUUF6eEFEZS9LRElrRVJSOEJs?=
 =?utf-8?B?M08vTERUWlhKRmFGV3ltQkpFT0JtZzdPT2NYOG5aL2IyLzZYQjdMVW1pV3ZK?=
 =?utf-8?B?ajZoL1hmMjJkNURBUDNGZ1hqSzJSMldxeUZ0amE3K05meDFCZHlTeHhBcXhy?=
 =?utf-8?B?QnE1MGVIcnNZcDFZaUxUZkp5TDF3UmcvcjA4UGdWV0FGd1IwM1NCWkRTem9Z?=
 =?utf-8?B?b2l0eTlpbTJFaktZYlJyT3FCbnY3N0NSanhzTzA4MVVES1hkUlZENENVbi8v?=
 =?utf-8?B?bGR3cXJwTW5xdWl0N1pzL3FwWGVNdXJkODBBTnU3TGhsTmtqc0NwMFZTNjUx?=
 =?utf-8?B?ZEw0TFNScnI1QXJieDNPMnZWNlEwSmh2UTlJekV1VDZZeldLWjErbms4WDNu?=
 =?utf-8?B?NWlzRHU5bWpEY1FOZm10d3VHdUVRN2ZLUFovQWhxRkVtUkZkdVB1NGNpb2FH?=
 =?utf-8?B?Z3ZETWJONlFqVmdSNlJ4aXl2d2ZHNmRWcnFMQkcwenhpZXgvTU1MVTNJN0JO?=
 =?utf-8?B?Yi9mN0ZXSWdnSXZVRzFMU2puTHJMQ244MHkycHFmQk9NV0l5Rkh3ZHdORDJK?=
 =?utf-8?B?cXZLV3owWTVTemZxRTY5cG10Tm0xNEtBc0NhU1QwODZ4S1NqRTRjOFhTbEFQ?=
 =?utf-8?B?REJGVStvNi9NSnRMaGY5K1BhNjYwYVJxUUpQbVV6bDRuNmRoOUNVMzRUNWla?=
 =?utf-8?B?MTNTU2VhT0VsUHhwbXdITWhQOXpjSXV6N1NrSkkzRzBhbDZQc1V6c0drcVZM?=
 =?utf-8?B?M0pRKy9Wa2tmMmV5YkRIUEdCZ0pZTVgyWGJxOEpwbjBYVnNrVUF2eWVTbGNN?=
 =?utf-8?B?YVBiOWhWMG4wZ3pIY2FwQVl1cnJJazI5SjVIZURoVkI1YzVmRmxIMCs1ZXZy?=
 =?utf-8?B?U2lXak5SdWNLMlh0YWtEV0psUWlLUUk0bllDSmp5bXJGc0ZmcXVqR0tQeGlE?=
 =?utf-8?Q?X4BVL2SRCnrIEDOKnyad41fQY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a574cdcb-150f-4517-f9ac-08dabdab2376
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 14:53:15.7934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6gfMOVlAuOv8nlmKHs2/L2NojdM6kMFv8Aa++Qa6HufZrBlC/HO9YXQeR9pTETyAJP3WBjiLTxfmd6bqBilEDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8094
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgPHBh
YmVuaUByZWRoYXQuY29tPg0KPiA+ICsgICAgIGlmICh1bmxpa2VseShpbmRleCA8IDApKQ0KPiA+
ICsgICAgICAgICAgICAgaW5kZXggPSAwOw0KPiA+ICsNCj4gPiArICAgICB3aGlsZSAoaW5kZXgg
Pj0gZmVwLT5udW1fdHhfcXVldWVzKQ0KPiA+ICsgICAgICAgICAgICAgaW5kZXggLT0gZmVwLT5u
dW1fdHhfcXVldWVzOw0KPiANCj4gTm90IGEgYmlnIGRlYWwsIGJ1dCBJIHRoaW5rIGtpbmQgb2Yg
b3B0aW1pemF0aW9ucyBhcmUgbm90IHdvcnRoeSBhbmQgcG90ZW50aWFsbHkNCj4gZGFuZ2Vyb3Vz
IHNpbmNlIGxhdGUgJzkwIDspDQo+IA0KPiBZb3UgY291bGQgY29uc2lkZXIgc3dpdGNoaW5nIHRv
IGEgc2ltcGxlciAnJScsIGJ1dCBJTUhPIGl0J3Mgbm90IGJsb2NraW5nLg0KDQpBZ3JlZS4gV2ls
bCBvcHRpbWl6ZSBpdCBpbiBuZXh0IHBhdGNoIG9mIGFkZGluZyB4ZHAgc3RhdGlzdGljcy4NCg0K
VGhhbmtzLA0KU2hlbndlaQ0KDQo+IA0KPiANCj4gQ2hlZXJzLA0KPiANCj4gUGFvbG8NCg0K
