Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8789617EEE
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiKCOIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiKCOIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:08:23 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8376BD5F
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 07:08:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4Sf4AqIzyVL5WK+Wj9jheAasn9fe6UfRTcvPHmP0FihlJvwTMz4P7sCNGEw5pUn9PzO+7nLBAjQqoLXkUsedjCxfr7pPDooLfU8hf7oseAJPHC37U26Op734kBVWRBJMSS/B1RD4m3SsXm2ZQfMNSOA2PMQ1tcFQWWSb142BuF70h9V4WX9sDIh7aIrP/VJqyQnAejDpDTuU/gxGD6ul/K2MpuOJsk7EFb5GZ3lumMB8qndK29lqLnRkv8+mBMwQE1JL5f2azczIHykeYBk8VcRiunhfeq37HhkdAqrkBbaMZIbDCuasujMYZrMlv9IKJWSoYieOucis22f+lpF2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSSXrVwB76OP9cdtRjGycEZLxlIZn+TU2bva6G16yHk=;
 b=mAsCbs+1Pr6ovSt3cyhk3wCa3s3wq6jbBpQtI7XMNTWeaJbsu0aKHTU5Am+w9SY/J9ZcinNs1Iqkr+fkQN5r/cy1mfbrCJmgMdN70uer4XkvxBt+K01jjv++++hj54p91FMklH0YfC26DR+AaL3ucFtV/zYrvU1aCJMqmEjHdnFrXA3+ZJSPXdB0JblglG4yWevCPRTQqYuSKal5B46w3t6yHe58Nl4euini3vBl5Cv3em35vIavVDkbWvT1Xt7teBLq5CBCHjsJ0KxOTQlthemGSPkUUnoyJSGXQlmDWIarW7rhpkBKHAZp6Q0atYxFyl3k3Yr3T/Bic99ob9Lphw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSSXrVwB76OP9cdtRjGycEZLxlIZn+TU2bva6G16yHk=;
 b=a7uBYE0b8oaHh6aeFWcvWlkyjt5SdY2a1bF8AwywWvvxAiX1BLlbLcZRgpHA7bGfRE1vfsXfK7TJaRy5FGbqnHkt8W31RMSoXbDvGjWVfhRkCHHkNFPvIorRwhj9IMbW0Enk4urtMkN2ghRaDlPkEQR+5rA5aK5DVvnhWt22D5E=
Received: from CO1PR10MB4612.namprd10.prod.outlook.com (2603:10b6:303:9b::22)
 by BN0PR10MB5381.namprd10.prod.outlook.com (2603:10b6:408:128::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 14:08:19 +0000
Received: from CO1PR10MB4612.namprd10.prod.outlook.com
 ([fe80::72ae:695b:3731:55de]) by CO1PR10MB4612.namprd10.prod.outlook.com
 ([fe80::72ae:695b:3731:55de%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 14:08:19 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: NET_RX_DROP question
Thread-Topic: NET_RX_DROP question
Thread-Index: AQHY7425gopL1im9FEG80NeHfAHo8Q==
Date:   Thu, 3 Nov 2022 14:08:19 +0000
Message-ID: <7dceaec046d54e8db9cefb2e3b198f25765f6d8e.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR10MB4612:EE_|BN0PR10MB5381:EE_
x-ms-office365-filtering-correlation-id: ece23829-c12d-4357-017d-08dabda4dc19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1xZoJRboja00bUs6eCcV8iKQJOGCnWdHTybpoX/PWRrSi4i2pR4Eum4oPjKyaFylH+gGabb/seMJQep9v1zz0lKc/hOo3alWAvbfAisz30cqsdnSM2yB0mkZgkNelI/1CTQIABLTnn8MN3zJ1jvdds6tr9w4EVOOIJqY7Uu49dnX6Wxpq2oQaciLRLE2JpFMqIxLUq0H2NZhxIBlduipvjZspOxtUwMNBhPufk8g9HA2fvYh0Y4B85ObDOXTznD0OvdpXyC9ai2t9Wat8fAl75rp0IXdVtfEVzsLNGCEIHxrBmZ66pHOXTk+tcL8vJD2wp11nHtGogRbDPRNVgUX1N9o9zKMGAHoeehBYxCdMig+OzPmXa8BLfRzUvWunn6lfhlmZ6c+Ox6CYTcHzdRRIOT5sf4BDoPXlr0L0v5gnuoGZQbxhaooDjdIFPn11v6YnHd3bLg06mcZ0QjEvObHqmDb0ixjPrnpbUundgBn1AByrVdL/JCxutULoQYa6wUxRQaR70EciE0LywpdCi4ZuVg1gxemY7AN7fWJ9fvMM+OlkwP/BDKgrL4QMOVXFtWRgxB21CbGpQhD/8fuVU8nlaX+0MgbQ2Matqxf5MbBjhNoNOTkrBm9Xbr57VtyOPwfanRVupbtSIGYaA78aWfmi1Sd6jf0v6LxXI3XeMTzDkJl9h/SwP+sK74f/9ZacTpB35YVwmEmxD7IjXCb/5KvxH9zbSC6iLbHAoRwJEYAvK63by56hU9Zy1Z8uI9/1Ss+qxMJHShZuqiJcPWLzV1jkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4612.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199015)(86362001)(6916009)(316002)(36756003)(5660300002)(38100700002)(4744005)(2616005)(122000001)(66446008)(2906002)(186003)(26005)(7116003)(6512007)(76116006)(41300700001)(66556008)(6506007)(91956017)(8676002)(66476007)(64756008)(66946007)(38070700005)(8936002)(478600001)(6486002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGpjWC9FVXc1ZEN4c3dSelJCNjErWExWVWJwTlZNSjRiWnkrajlqQldWWC9o?=
 =?utf-8?B?Ny9ac2NTRDhWcGd5QlZGWGF3RmdTL0FEYll0WGNEdzNuMEtiZ01INUtmS1l6?=
 =?utf-8?B?d3lTaXVlbDRLWWw3YVhseWNxWWNubnc4MW5JMFBZeTB0emwvRmsxQjE1Y0cy?=
 =?utf-8?B?SitmMGpNMXFLTGNkT00vU3ZlcUZ2U1BzRDN6VkE0RmN6S2ZoWmx0ZjMvL0FM?=
 =?utf-8?B?SHJaa0kwV1p1aW9Ld0VYRXE2b3RsU095b0dvYTJIbFgvUXVJbEFyVUxFcWlu?=
 =?utf-8?B?eDZwR3JPc1o1SEtzbjJLNlJLYzNhNlVITUZSNW91YktNNlkvTkJRRXdjMUNl?=
 =?utf-8?B?ejMzSmVIcHJmaEJ4MmpudExSQWlqelJXRkwva1JkdThPanNScnA5L0ZkT1Fs?=
 =?utf-8?B?eERQNDFvYVNXN1BvMkRscmVOdTU2MHBsL1BlVE9SUUVveDNyQnM3TDJPYXVm?=
 =?utf-8?B?WlZuNlBqSlJuaUszMVRGZUYzNTFqYmk3R0VUWHpTdkVRT1cvK3AxTWFXTnky?=
 =?utf-8?B?a1dNOEZRQWhCZjJzUGVRdWg2dXdsTVlNdXd3TStBN0xoSmV6M0hHY0VtY1pG?=
 =?utf-8?B?eUxxTUNCRlpRbE0xTWlpQklnbWhNeW55VVgvZ2ZROUpVYVR4QVpqSmNQTWlR?=
 =?utf-8?B?M1Y5Nmo3WlBjTjN5aHRLckhSTXRpenc1V24zaVkvaXR2WE1EamxhQSswdE5r?=
 =?utf-8?B?UVZqNVR6NUZFa2pQVFVLbEo3YkRXYUxLWUp4aDhmdE4xT2grdy9ia3l3QmVr?=
 =?utf-8?B?UzNKV01MTUtTSGJqOTlUL0grdG52ZXhCWFRnRFFES00xcUVoMjNJaUtKVHBu?=
 =?utf-8?B?YzloV1ZLY3pnbkN0cTB3a3ZkelE3TE5naXJ1WGUrdVZlMHpKbjc0OEdsbi9w?=
 =?utf-8?B?cHBXNzJVK2htNFlaMjA3MUxVWmRCd3h2NisxTlFZdnU3aTA3OXg4UytyOVRi?=
 =?utf-8?B?cXVXUjU3V01sOVVkcjlCVm12VlU2VzlRMHVvdmsrTUZFcUtVeVVQZjBvWEo5?=
 =?utf-8?B?N3diTUpzSk51WkJ6dlZGbXk3MVlsV3JTOWJ2RVg2eFdNeVhUMWdRRzQvUUhC?=
 =?utf-8?B?NnFTUjNsUDhQK2tiWm1BZkhOREpnRE9mS1BPTmxlTTdobmFIcVQwc21WZjZv?=
 =?utf-8?B?djhyTUJHcHZENS9nQ095T0dtZGZsQXpua1hGUXEzVE9OMWJkL0tKZUVlRGhG?=
 =?utf-8?B?RmVKMDNFRzN0MXovdlRFQVJLNlNtQU5wc2MyVFhGaUZWSlpVK1RFSFNyMkc5?=
 =?utf-8?B?UFc3WTRsd0JqWU43L1dHbGZNSjhYd3ZaZEo0eDJGSUpMMWtncVJOYUFjcHdX?=
 =?utf-8?B?b3psRk1zRlZBQnRHS1lNaXM5NEZ5cTlScGZ4Rml1NnlNYlo5SFZxcW9jblZr?=
 =?utf-8?B?ckluWXQrVm5wN0FVdTNDSzR2cmV3ZFowRGtlYWpLNFc4enNtbTE3QmNjQ09x?=
 =?utf-8?B?QzJPMmhtM3JDeFBBa3k5OUVYVXgybjZ2WlFrUTJWZDJBR0RDWmtURDBzcjQ2?=
 =?utf-8?B?SVhyYXhwaStiWlBmZkdkWlNUN2JlWWthTGtsM3JjUmloWjdrREU0MGM1SVFw?=
 =?utf-8?B?UFozbGxQTGhaMEVqMzJ5R202eTlmOE5kdkZuRkhoVTNNc0JGVzhVTHFveWMx?=
 =?utf-8?B?YjlvT1dXSkpFa2lkSGt0ZVhnU3pqcmlyNit5Yk5MeHBuRTFUSGJLaG5ubmJo?=
 =?utf-8?B?cGhMU3pXaHFjeUUvYUlURUZhSnptVVcra2FFZmdhWENJRUNpdEJacUF6WHJG?=
 =?utf-8?B?MjJGck1HT2pjUlkvaERNeHJFUkVsdU1icXBDUm0zSjRZYk5MQy9EQXg5QytU?=
 =?utf-8?B?R0x1bFJuK3JFMDh3azl1c3hCUk9rTnF6R0FmOHdLRG1OQWp2QjE2Y0VZSDNz?=
 =?utf-8?B?NEFlT012VTFLaWl5eGlLQW81SjdVRy9TUkFOUDN0YlM1L0dMRzBjVlF1ODJX?=
 =?utf-8?B?MGFzL0JQQ25rVzlYWlJGUlViNTU2OXV0S2FOYlZwWng0eEdLTTZPVEVNejN6?=
 =?utf-8?B?bU9ad1F5RUxGVjRTV2ZodkNtT0xuN1pPRUtpS3J1bWl3d0xFWWtVdFZiQ01J?=
 =?utf-8?B?ZDdNK0xmS1ZYYzFCZjVuS2RCYVByUEY0UnhxSUZiNnFOc3paeXlEc3grR0Jq?=
 =?utf-8?Q?QzeUYPnOe4wBgI9F2hNY4LoaX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EFAF0AEE543FD469B6DD24E11597B67@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4612.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ece23829-c12d-4357-017d-08dabda4dc19
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 14:08:19.0790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ulQBnpmYEe/6cQmFMOHO+NYyLsvN2xL4eM57OEBQeYGA2vzYgVNWLre/SUWK2dDwL4L/PtXo7nVfky3FelLsgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5381
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW4gb3VyIGV0aGVybmV0IGRyaXZlcnMgUlggcGF0aCB3ZSBoYXZlOg0KICBpZiAobmV0aWZfcmVj
ZWl2ZV9za2Ioc2tiKSA9PSBORVRfUlhfRFJPUCkNCiAgICAgcHJpdi0+c3RhdHMucnhfZHJvcHBl
ZCsrOw0KDQpOb3cgd2UgY2FuIHNlZSBkcm9wcGVkIGNvdW50ZXIgY291bnRpbmcgZHJvcHBlZCBw
a2dzIGJ1dCB3ZSBkb24ndCBzZWUNCmFueSBjb3JydXB0IHBrZ3MgZXRjLiBJcyBORVRfUlhfRFJP
UCByZWFsbHkgbWVhbnQgdG8gYmUgdXNlZCBsaWtlIHRoaXM/DQpJdCBnaXZlcyB0aGUgaW1wcmVz
c2lvbiB0aGF0IHRoZXJlIGlzIHNvbWV0aGluZyB3cm9uZyB3aXRoIHRoZSBkcml2ZXIuDQoNCiBK
b2NrZQ0K
