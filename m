Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A9E673D1D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 16:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjASPJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 10:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjASPJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 10:09:31 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8181A64DBF
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 07:09:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RU0ltc6/EalFaxQKog5MQ5THqbNuKDfXtAXEg+2g3HjPOVUYlkW4L6TDXbKu+Bn0L/0IPuP6e4c9v7Ppq9dU9jqKHIkvtrIrYvLCAmyiiI9sCwub8IIOw0qWsCYoDhti0pYuSLlBfYlStofWEmNdYbHAFORFLh2rZqD/xjHNutUAZ2RbzbFZ2A9cx6dCH59jOrzBYVDeoAy98ywHIHEPKqbkDdPQqPU6YZgKDvNWTi2JNBW6uA5+etqXhreI6y5bfgyOCEdJUvLhgrgQA9CZ8yhhv/xkY5raVFLqs4Uo2M04mZuBr0WvCuSVSfXvq4TJVITsydoNQDw79U3eHOeHxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/GXmux5mimwYe35uKwKZwzQQEHeZ6aVl6a0kXtC9oo=;
 b=nUmCpGWDMvDmVY+9trgNlKIaE19H1Ad/dnRt6VAsHtERMTvdevHxp4dn70WwKp/+R9KGkqdbuf7hJJj1ycilBhuOs6XNY2KTmMXox5JZ/kSc6XpyHki4YyzNz/kOiVz8HJDzJsOOqz0sNPak81VzinLhGVrn/eqoBC+NwO8ACSCUa1CLuXvmzKDmhEsTj15JJ1rojAznUXYKrupz3dAmJ4CVcuXEGV9HXr/abHwgPdJNzWQ20CXmQBkqOu8dfQoQrr/7TvsoY41JB/DHVbF/U2x2m7+fbsNbN49F/yEqdDUie3kqYqmjqT9GKJRSJA7W1YP5bm5IyJIV2NT8bK9fig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/GXmux5mimwYe35uKwKZwzQQEHeZ6aVl6a0kXtC9oo=;
 b=hURLvB+UQlABdprG19fw4BQxOGxcPZAfbIFMljOs16JFtVJF3ywanUb18Hz+FH91tz1ztB8RF+Nm9sBAiyqk9rlnScxaUYhiGiAHLw0SahJfF5Nk+Dlx9EAQw9PJJu0MmNRN/OHheTw59/Xgsgq79lD5nqquZO/oixzFjYUTue8=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by CH3PR12MB7643.namprd12.prod.outlook.com (2603:10b6:610:152::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 15:09:27 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 15:09:27 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm@gmail.com" <habetsm@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 6/7] sfc: add support for
 port_function_hw_addr_get devlink in ef100
Thread-Topic: [PATCH net-next 6/7] sfc: add support for
 port_function_hw_addr_get devlink in ef100
Thread-Index: AQHZK/nEMuz6Wh6wlUm2jwuAZPXg2K6lrZkAgAAqcoA=
Date:   Thu, 19 Jan 2023 15:09:27 +0000
Message-ID: <433222dd-cea8-fa93-d0f8-1f4f4272ae91@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-7-alejandro.lucero-palau@amd.com>
 <Y8k5glNLX1eE2iKE@nanopsycho>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|CH3PR12MB7643:EE_
x-ms-office365-filtering-correlation-id: c2eb89f8-21e1-446c-0cb4-08dafa2f2856
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PTgY8Pqs8Idt7AR9sC3A+ueA+DMeKquqJnWEn4MPAyZ4gAXc/GhK+g1excaDoVZL3vxZPhK+mliDeoXZFlNjAS4HY1HfoXZc1DFQUUMIkR0+pPC8vENiSdH8j9EWDvfQPGJmmjUqp1Uxq0kg5dcjDdtyVyXaJnFyZfW5ARh/y8kZoV0O6mM5I7TY0lIkFVLhJYhXxR9Ew/N79FERHOtmiKX9ocHZpd3TfST9v6AIqJbE8mEpss0cMXJkm8jkHhIaYMymAImgqRcN88ReEBms/53aHOKJ5qTm/XrQ/g0P22s2CTr+oIkZ7ES9JbDv0Xl9/hdy1AYs9quyBlCW1TExh45ptCADxoFi7b9Ig5w3ExzuT8uQz7kpNwkiUHKE2RcNyjnqALSIRXqwZ4MIOkW7TRdi1yu6D61vQnxj3ui8/cLYe/gjiRKrJbni/uGXcrRLxlogodi/jrrnbcogqJgdEs+kf5m9l2KhjNC03eY3x6e3OKThqwVSIu1/ixBet8H2geU7vnGm378+FKB0Z/fVEUN71tZj8v+tZ6w2M4vSr7GKm2ntLquQyk9SR6bJN6T2l9H9LQifeVlN6zYLo3KkCLToktQs5+2W/XesrcO4RD4ts7Bqt50xIGwRNxeZf4JUXCpJWncCoNH1mHbOw239ZuAzutO8RBbx2r9XnAqRZ2JaGenlUcSKYxu0E9XjTelemAmRZJapg6EQoDPs8t1y/+YxAeDu3rt2tH2vOpej/Ts=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199015)(31686004)(122000001)(2906002)(66946007)(91956017)(66556008)(5660300002)(8936002)(66476007)(31696002)(4326008)(38100700002)(76116006)(110136005)(71200400001)(54906003)(53546011)(316002)(38070700005)(6486002)(6506007)(86362001)(478600001)(83380400001)(36756003)(8676002)(66446008)(41300700001)(64756008)(186003)(6512007)(26005)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGxUQldkNStHWkJEdnFwRHRxRWJodnpPcURFV0lXdkNFZzZMbC8xMzR2cWNl?=
 =?utf-8?B?WWQ3bk13cXN2TXpKbUFSZytoTURSeUV4UDViVVRoZExaalcvYWRIaElkb1dM?=
 =?utf-8?B?bUhSajRxT3RoNGJUaklsUVc0elgvcWg1QlpoVEV1OTFrRWlOa054TkVTcVBJ?=
 =?utf-8?B?TTArMlZaVWRVekJBR1hPMWl4SktLVHkzNFNQaXJHUlhjNm5rbGIzM0R6SUlJ?=
 =?utf-8?B?aDRVb2luVEJqSE9yOUZXN0JndS8wenpDNDlEdFhYS0dNTE8zRFhNZXFFZEJC?=
 =?utf-8?B?MHJSenpHSXNCcjBKZlhaZVVXSWc0blJ4blYwalJrblhLdnBNZ2ZrMU1XRk1S?=
 =?utf-8?B?cnJYbmFPaytSWktKQnNqaU80ZlJHbTJXQ2dORElWeE5VVDREeXdObUlURnkw?=
 =?utf-8?B?Ujl6dFkwMWVIdmJOZW5xQlZWcW5OZDZhR2FJQ2hLSHNFblRQNzBDdHA5RStp?=
 =?utf-8?B?L1JBYmFRTkN6SjVsaUFZWWdPdjkxZ2VWUk0rNjlxeVU1RFRHdC9mUXpZNHFv?=
 =?utf-8?B?d21VaDVsd1RUSGZFNDVsSGg0ZmZWNll2VW9SVVNoTGNaRkFNNzNGVFFXNkRm?=
 =?utf-8?B?eENFQUszVmpFelVweE0vK05icHMrbk5ZUG1QYmVxc3J1K2dYMzZYVXF0aW8v?=
 =?utf-8?B?S0lRVjV4WmNySys5ZXJwalpJWHZJb3hYVUcyMkJLZHhVQWFJQkdiV0N3enlD?=
 =?utf-8?B?Zm5DMTY1QmpVdDFLU0J4MURJbW9Wa056WlRiazJWRktDcjR5aWhMUm9iais4?=
 =?utf-8?B?T2ZLdHRlcCtIT21yT0RDbVlqaVE0QnNqcGhkb1MwRVQ1QTNzZ3l5SElGRDU3?=
 =?utf-8?B?bnF5TmZwalhiMk9mcUJmMmtRK3pDYllUK0tvZklnNmZydzNYemtQcldxTVN0?=
 =?utf-8?B?ZjlldUNnWUs4UFhxZzVpN0dwWW01MzMzN0FhZGlSeDR0NHJQalNRWERPd3Aw?=
 =?utf-8?B?TU1STjFzY1ErcHFvbXZPWnpDSk9HMkI2UzBoOFZ0MHF3REdKaHo0MTZxNUtJ?=
 =?utf-8?B?M1BGeEhncHM4UjNtUnVNM3hQdkxsa2x0dHpyWnpFVjVFK3ZmQ0dWdzFmNkRr?=
 =?utf-8?B?RmFzQ1FuTDJMVGFiT0R5eUZjS1FYdHI3WkR1WW1vODdLNklEMXNLN3MyT0tV?=
 =?utf-8?B?ZnMzWGpKQ0NCMFUrUzN0V3BTcW9rWURmZi9mNnlJeFZzelZFK2w4dm8xZ0k1?=
 =?utf-8?B?OFdwL3ZSejJNVHMyK0pwbyswQmFyLy85Q29hSnpOMWFzNWZ5NXU2LzJMbW5C?=
 =?utf-8?B?ZUxvUWhTaW9Sa09Hclk5b3kvcXA5SkFzcHVCM0NGc2ZUZUxMN1RoTVdIa2lt?=
 =?utf-8?B?U3hOTm5oVzY3ajNGTnd4a251S2RianJad0tNNDQ1K1NHWlVMU1NQQVpVOUho?=
 =?utf-8?B?RkNvaEpWa0Z6cHJ4OFhMbWlPQmQyRmQzTjVBTFA0UU9zNmowOHdpSG9oN010?=
 =?utf-8?B?QUd6cFJibkhlVkRNcjdSbUNvREUvWDFBOWRUZm9wWVBmeGhITDE3M0xPSms5?=
 =?utf-8?B?blFWMTBPd0RLRGdnZDFMbEg0YjRUTncxRHpvb2VUcG41WjBUa1J0OVhYMVkr?=
 =?utf-8?B?SGROTkNSbzZ0WGV0cGk0NnlDWGtjVXpKMDdHNXBGVjZCU2trYVlBdUZaWStj?=
 =?utf-8?B?cEdNL1pnL3Zvclk2KzFIL3lwR01Bbi9ycmEwQ1lUaTNPcm44VUtLM0JRem81?=
 =?utf-8?B?MTYxWVIyYVBlb1FPOVBjaEdBTDczbnRZUm9raitJMDRLV2V2M28wTDNIbldY?=
 =?utf-8?B?dnJiaWVpUXlwZjhhcGdKWks2aWFjaVJjSjRGKzFkU202NE9rM2NnMkhvclFZ?=
 =?utf-8?B?NThxaFYyU1lrdEN4cnNtekUzcEdYeEVEREFQdVJGK20xbEtXQVVDMTZIdXpV?=
 =?utf-8?B?b1RSclcyRlFhSW8yWGc3bndmbVRya1FJcm9qNmZnR0QzRWFOcUtNbVBhVTZM?=
 =?utf-8?B?cTJPTTJjWlhMbkJMQnRtYlA3U2RqNUYrQTVOUDdNUUdkT295aWtEdHh0Sms3?=
 =?utf-8?B?MTVkMGc0aTQyYXJ2Q3FJYkVvaXk5RnVFZ25aVTE4UTdZUXltbXROc21DZHpS?=
 =?utf-8?B?YUtDMEMrWFRnQVdxUVpyREkrTkdwRGdCTU5WaW5uczdFLzFKdmZvRzF5Yk5J?=
 =?utf-8?Q?lw6oFylTmlYl4PcZAUjjREqK3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <951E0F7BDAEADB4688139A7363876794@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2eb89f8-21e1-446c-0cb4-08dafa2f2856
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 15:09:27.3168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EMRDQlw6NhEC3MbgISgmUFtkHduWWYK8M/xLcjahdK+OcU5QVgpOCnaY6ZIxEnCruui+UsjGwlGUNXvcf93TKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7643
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE5LzIzIDEyOjM3LCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBUaHUsIEphbiAxOSwgMjAy
MyBhdCAxMjozMTozOVBNIENFVCwgYWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tIHdyb3Rl
Og0KPj4gRnJvbTogQWxlamFuZHJvIEx1Y2VybyA8YWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQu
Y29tPg0KPj4NCj4+IFVzaW5nIHRoZSBidWlsdGluIGNsaWVudCBoYW5kbGUgaWQgaW5mcmFzdHJ1
Y3R1cmUsIHRoaXMgcGF0Y2ggYWRkcw0KPj4gc3VwcG9ydCBmb3Igb2J0YWluaW5nIHRoZSBtYWMg
YWRkcmVzcyBsaW5rZWQgdG8gbXBvcnRzIGluIGVmMTAwLiBUaGlzDQo+PiBpbXBsaWVzIHRvIGV4
ZWN1dGUgYW4gTUNESSBjb21tYW5kIGZvciBnZXR0aW5nIHRoZSBkYXRhIGZyb20gdGhlDQo+PiBm
aXJtd2FyZSBmb3IgZWFjaCBkZXZsaW5rIHBvcnQuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWxl
amFuZHJvIEx1Y2VybyA8YWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tPg0KPj4gLS0tDQo+
PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfbmljLmMgICB8IDI3ICsrKysrKysrKysr
KysrKysNCj4+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9uaWMuaCAgIHwgIDEgKw0K
Pj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX3JlcC5jICAgfCAgOCArKysrKw0KPj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX3JlcC5oICAgfCAgMSArDQo+PiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYyB8IDQ0ICsrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+PiA1IGZpbGVzIGNoYW5nZWQsIDgxIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX25pYy5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX25pYy5jDQo+PiBpbmRleCBmNGU5MTM1OTNmMmIuLjQ0MDBj
ZTYyMjIyOCAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9u
aWMuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX25pYy5jDQo+PiBA
QCAtMTEyMSw2ICsxMTIxLDMzIEBAIHN0YXRpYyBpbnQgZWYxMDBfcHJvYmVfbWFpbihzdHJ1Y3Qg
ZWZ4X25pYyAqZWZ4KQ0KPj4gCXJldHVybiByYzsNCj4+IH0NCj4+DQo+PiArLyogTUNESSBjb21t
YW5kcyBhcmUgcmVsYXRlZCB0byB0aGUgc2FtZSBkZXZpY2UgaXNzdWluZyB0aGVtLiBUaGlzIGZ1
bmN0aW9uDQo+PiArICogYWxsb3dzIHRvIGRvIGFuIE1DREkgY29tbWFuZCBvbiBiZWhhbGYgb2Yg
YW5vdGhlciBkZXZpY2UsIG1haW5seSBQRnMgc2V0dGluZw0KPj4gKyAqIHRoaW5ncyBmb3IgVkZz
Lg0KPj4gKyAqLw0KPj4gK2ludCBlZnhfZWYxMDBfbG9va3VwX2NsaWVudF9pZChzdHJ1Y3QgZWZ4
X25pYyAqZWZ4LCBlZnhfcXdvcmRfdCBwY2llZm4sIHUzMiAqaWQpDQo+PiArew0KPj4gKwlNQ0RJ
X0RFQ0xBUkVfQlVGKG91dGJ1ZiwgTUNfQ01EX0dFVF9DTElFTlRfSEFORExFX09VVF9MRU4pOw0K
Pj4gKwlNQ0RJX0RFQ0xBUkVfQlVGKGluYnVmLCBNQ19DTURfR0VUX0NMSUVOVF9IQU5ETEVfSU5f
TEVOKTsNCj4+ICsJdTY0IHBjaWVmbl9mbGF0ID0gbGU2NF90b19jcHUocGNpZWZuLnU2NFswXSk7
DQo+PiArCXNpemVfdCBvdXRsZW47DQo+PiArCWludCByYzsNCj4+ICsNCj4+ICsJTUNESV9TRVRf
RFdPUkQoaW5idWYsIEdFVF9DTElFTlRfSEFORExFX0lOX1RZUEUsDQo+PiArCQkgICAgICAgTUNf
Q01EX0dFVF9DTElFTlRfSEFORExFX0lOX1RZUEVfRlVOQyk7DQo+PiArCU1DRElfU0VUX1FXT1JE
KGluYnVmLCBHRVRfQ0xJRU5UX0hBTkRMRV9JTl9GVU5DLA0KPj4gKwkJICAgICAgIHBjaWVmbl9m
bGF0KTsNCj4+ICsNCj4+ICsJcmMgPSBlZnhfbWNkaV9ycGMoZWZ4LCBNQ19DTURfR0VUX0NMSUVO
VF9IQU5ETEUsIGluYnVmLCBzaXplb2YoaW5idWYpLA0KPj4gKwkJCSAgb3V0YnVmLCBzaXplb2Yo
b3V0YnVmKSwgJm91dGxlbik7DQo+PiArCWlmIChyYykNCj4+ICsJCXJldHVybiByYzsNCj4+ICsJ
aWYgKG91dGxlbiA8IHNpemVvZihvdXRidWYpKQ0KPj4gKwkJcmV0dXJuIC1FSU87DQo+PiArCSpp
ZCA9IE1DRElfRFdPUkQob3V0YnVmLCBHRVRfQ0xJRU5UX0hBTkRMRV9PVVRfSEFORExFKTsNCj4+
ICsJcmV0dXJuIDA7DQo+PiArfQ0KPj4gKw0KPj4gaW50IGVmMTAwX3Byb2JlX25ldGRldl9wZihz
dHJ1Y3QgZWZ4X25pYyAqZWZ4KQ0KPj4gew0KPj4gCXN0cnVjdCBlZjEwMF9uaWNfZGF0YSAqbmlj
X2RhdGEgPSBlZngtPm5pY19kYXRhOw0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3NmYy9lZjEwMF9uaWMuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9uaWMu
aA0KPj4gaW5kZXggZTU5MDQ0MDcyMzMzLi5mMWVkNDgxYzEyNjAgMTAwNjQ0DQo+PiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfbmljLmgNCj4+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3NmYy9lZjEwMF9uaWMuaA0KPj4gQEAgLTk0LDQgKzk0LDUgQEAgaW50IGVmMTAw
X2ZpbHRlcl90YWJsZV9wcm9iZShzdHJ1Y3QgZWZ4X25pYyAqZWZ4KTsNCj4+DQo+PiBpbnQgZWYx
MDBfZ2V0X21hY19hZGRyZXNzKHN0cnVjdCBlZnhfbmljICplZngsIHU4ICptYWNfYWRkcmVzcywN
Cj4+IAkJCSAgaW50IGNsaWVudF9oYW5kbGUsIGJvb2wgZW1wdHlfb2spOw0KPj4gK2ludCBlZnhf
ZWYxMDBfbG9va3VwX2NsaWVudF9pZChzdHJ1Y3QgZWZ4X25pYyAqZWZ4LCBlZnhfcXdvcmRfdCBw
Y2llZm4sIHUzMiAqaWQpOw0KPj4gI2VuZGlmCS8qIEVGWF9FRjEwMF9OSUNfSCAqLw0KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9yZXAuYyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3NmYy9lZjEwMF9yZXAuYw0KPj4gaW5kZXggZmYwYzhkYTYxOTE5Li45NzRj
OWZmOTAxYTAgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBf
cmVwLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZjEwMF9yZXAuYw0KPj4g
QEAgLTM2Miw2ICszNjIsMTQgQEAgYm9vbCBlZjEwMF9tcG9ydF9vbl9sb2NhbF9pbnRmKHN0cnVj
dCBlZnhfbmljICplZngsDQo+PiAJCSAgICAgbXBvcnRfZGVzYy0+aW50ZXJmYWNlX2lkeCA9PSBu
aWNfZGF0YS0+bG9jYWxfbWFlX2ludGY7DQo+PiB9DQo+Pg0KPj4gK2Jvb2wgZWYxMDBfbXBvcnRf
aXNfdmYoc3RydWN0IG1hZV9tcG9ydF9kZXNjICptcG9ydF9kZXNjKQ0KPj4gK3sNCj4+ICsJYm9v
bCBwY2llX2Z1bmM7DQo+PiArDQo+PiArCXBjaWVfZnVuYyA9IGVmMTAwX21wb3J0X2lzX3BjaWVf
dm5pYyhtcG9ydF9kZXNjKTsNCj4+ICsJcmV0dXJuIHBjaWVfZnVuYyAmJiAobXBvcnRfZGVzYy0+
dmZfaWR4ICE9IE1BRV9NUE9SVF9ERVNDX1ZGX0lEWF9OVUxMKTsNCj4+ICt9DQo+PiArDQo+PiB2
b2lkIGVmeF9lZjEwMF9pbml0X3JlcHMoc3RydWN0IGVmeF9uaWMgKmVmeCkNCj4+IHsNCj4+IAlz
dHJ1Y3QgZWYxMDBfbmljX2RhdGEgKm5pY19kYXRhID0gZWZ4LT5uaWNfZGF0YTsNCj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfcmVwLmggYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9zZmMvZWYxMDBfcmVwLmgNCj4+IGluZGV4IDljY2E0MTYxNDk4Mi4uNzQ4NTNj
Y2JjOTM3IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAwX3Jl
cC5oDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWYxMDBfcmVwLmgNCj4+IEBA
IC03NSw0ICs3NSw1IEBAIHZvaWQgZWZ4X2VmMTAwX2ZpbmlfcmVwcyhzdHJ1Y3QgZWZ4X25pYyAq
ZWZ4KTsNCj4+IHN0cnVjdCBtYWVfbXBvcnRfZGVzYzsNCj4+IGJvb2wgZWYxMDBfbXBvcnRfb25f
bG9jYWxfaW50ZihzdHJ1Y3QgZWZ4X25pYyAqZWZ4LA0KPj4gCQkJICAgICAgIHN0cnVjdCBtYWVf
bXBvcnRfZGVzYyAqbXBvcnRfZGVzYyk7DQo+PiArYm9vbCBlZjEwMF9tcG9ydF9pc192ZihzdHJ1
Y3QgbWFlX21wb3J0X2Rlc2MgKm1wb3J0X2Rlc2MpOw0KPj4gI2VuZGlmIC8qIEVGMTAwX1JFUF9I
ICovDQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5r
LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0KPj4gaW5kZXggYmIx
OWQzYWQ3ZmZkLi4yYTU3YzRmNmQyYjIgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2Zj
L2VmeF9kZXZsaW5rLmMNCj4+IEBAIC00MjksNiArNDI5LDQ5IEBAIHN0YXRpYyBpbnQgZWZ4X2Rl
dmxpbmtfYWRkX3BvcnQoc3RydWN0IGVmeF9uaWMgKmVmeCwNCj4+IAlyZXR1cm4gZXJyOw0KPj4g
fQ0KPj4NCj4+ICtzdGF0aWMgaW50IGVmeF9kZXZsaW5rX3BvcnRfYWRkcl9nZXQoc3RydWN0IGRl
dmxpbmtfcG9ydCAqcG9ydCwgdTggKmh3X2FkZHIsDQo+PiArCQkJCSAgICAgaW50ICpod19hZGRy
X2xlbiwNCj4+ICsJCQkJICAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQo+PiAr
ew0KPj4gKwlzdHJ1Y3QgZWZ4X2RldmxpbmsgKmRldmxpbmsgPSBkZXZsaW5rX3ByaXYocG9ydC0+
ZGV2bGluayk7DQo+PiArCXN0cnVjdCBtYWVfbXBvcnRfZGVzYyAqbXBvcnRfZGVzYzsNCj4+ICsJ
ZWZ4X3F3b3JkX3QgcGNpZWZuOw0KPj4gKwl1MzIgY2xpZW50X2lkOw0KPj4gKwlpbnQgcmMgPSAw
Ow0KPj4gKw0KPj4gKwltcG9ydF9kZXNjID0gZWZ4X21hZV9nZXRfbXBvcnQoZGV2bGluay0+ZWZ4
LCBwb3J0LT5pbmRleCk7DQo+IEkgbWF5IGJlIG1pc3Npbmcgc29tZXRoaW5nLCB3aGVyZSBkbyB5
b3UgZmFpbCB3aXRoIC1FT1BOT1RTVVBQDQo+IGluIGNhc2UgdGhpcyBpcyBjYWxsZWQgZm9yIFBI
WVNJQ0FMIHBvcnQgPw0KPg0KDQpXZSBkbyBub3QgY3JlYXRlIGEgZGV2bGluayBwb3J0IGZvciB0
aGUgcGh5c2ljYWwgcG9ydC4NCg0KSSdtIGF3YXJlIHRoaXMgaXMgbm90ICJmdWxseSBjb21wbGlh
bnQiIHdpdGggZGV2bGluayBkZXNpZ24gaWRlYSwganVzdCANCnRyeWluZyB0byB1c2UgaXQgZm9y
IG91ciBjdXJyZW50IHVyZ2VudCBuZWNlc3NpdGllcyBieSBub3cuDQoNCkRvIHlvdSB0aGluayB0
aGlzIGNvdWxkIGJlIGEgcHJvYmxlbT8NCg0KDQo+DQo+PiArCWlmICghbXBvcnRfZGVzYykNCj4+
ICsJCXJldHVybiAtRUlOVkFMOw0KPj4gKw0KPj4gKwlpZiAoIWVmMTAwX21wb3J0X29uX2xvY2Fs
X2ludGYoZGV2bGluay0+ZWZ4LCBtcG9ydF9kZXNjKSkNCj4+ICsJCWdvdG8gb3V0Ow0KPj4gKw0K
Pj4gKwlpZiAoZWYxMDBfbXBvcnRfaXNfdmYobXBvcnRfZGVzYykpDQo+PiArCQlFRlhfUE9QVUxB
VEVfUVdPUkRfMyhwY2llZm4sDQo+PiArCQkJCSAgICAgUENJRV9GVU5DVElPTl9QRiwgUENJRV9G
VU5DVElPTl9QRl9OVUxMLA0KPj4gKwkJCQkgICAgIFBDSUVfRlVOQ1RJT05fVkYsIG1wb3J0X2Rl
c2MtPnZmX2lkeCwNCj4+ICsJCQkJICAgICBQQ0lFX0ZVTkNUSU9OX0lOVEYsIFBDSUVfSU5URVJG
QUNFX0NBTExFUik7DQo+PiArCWVsc2UNCj4+ICsJCUVGWF9QT1BVTEFURV9RV09SRF8zKHBjaWVm
biwNCj4+ICsJCQkJICAgICBQQ0lFX0ZVTkNUSU9OX1BGLCBtcG9ydF9kZXNjLT5wZl9pZHgsDQo+
PiArCQkJCSAgICAgUENJRV9GVU5DVElPTl9WRiwgUENJRV9GVU5DVElPTl9WRl9OVUxMLA0KPj4g
KwkJCQkgICAgIFBDSUVfRlVOQ1RJT05fSU5URiwgUENJRV9JTlRFUkZBQ0VfQ0FMTEVSKTsNCj4+
ICsNCj4+ICsJcmMgPSBlZnhfZWYxMDBfbG9va3VwX2NsaWVudF9pZChkZXZsaW5rLT5lZngsIHBj
aWVmbiwgJmNsaWVudF9pZCk7DQo+PiArCWlmIChyYykgew0KPj4gKwkJbmV0aWZfZXJyKGRldmxp
bmstPmVmeCwgZHJ2LCBkZXZsaW5rLT5lZngtPm5ldF9kZXYsDQo+PiArCQkJICAiRmFpbGVkIHRv
IGdldCBjbGllbnQgSUQgZm9yIHBvcnQgaW5kZXggJXUsIHJjICVkXG4iLA0KPj4gKwkJCSAgcG9y
dC0+aW5kZXgsIHJjKTsNCj4+ICsJCXJldHVybiByYzsNCj4+ICsJfQ0KPj4gKw0KPj4gKwlyYyA9
IGVmMTAwX2dldF9tYWNfYWRkcmVzcyhkZXZsaW5rLT5lZngsIGh3X2FkZHIsIGNsaWVudF9pZCwg
dHJ1ZSk7DQo+PiArb3V0Og0KPj4gKwkqaHdfYWRkcl9sZW4gPSBFVEhfQUxFTjsNCj4+ICsNCj4+
ICsJcmV0dXJuIHJjOw0KPj4gK30NCj4+ICsNCj4+IHN0YXRpYyBpbnQgZWZ4X2RldmxpbmtfaW5m
b19nZXQoc3RydWN0IGRldmxpbmsgKmRldmxpbmssDQo+PiAJCQkJc3RydWN0IGRldmxpbmtfaW5m
b19yZXEgKnJlcSwNCj4+IAkJCQlzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQo+PiBA
QCAtNDQyLDYgKzQ4NSw3IEBAIHN0YXRpYyBpbnQgZWZ4X2RldmxpbmtfaW5mb19nZXQoc3RydWN0
IGRldmxpbmsgKmRldmxpbmssDQo+Pg0KPj4gc3RhdGljIGNvbnN0IHN0cnVjdCBkZXZsaW5rX29w
cyBzZmNfZGV2bGlua19vcHMgPSB7DQo+PiAJLmluZm9fZ2V0CQkJPSBlZnhfZGV2bGlua19pbmZv
X2dldCwNCj4+ICsJLnBvcnRfZnVuY3Rpb25faHdfYWRkcl9nZXQJPSBlZnhfZGV2bGlua19wb3J0
X2FkZHJfZ2V0LA0KPj4gfTsNCj4+DQo+PiBzdGF0aWMgc3RydWN0IGRldmxpbmtfcG9ydCAqZWYx
MDBfc2V0X2RldmxpbmtfcG9ydChzdHJ1Y3QgZWZ4X25pYyAqZWZ4LCB1MzIgaWR4KQ0KPj4gLS0g
DQo+PiAyLjE3LjENCj4+DQoNCg==
