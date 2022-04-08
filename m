Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAD74F9505
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 14:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbiDHME2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 08:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbiDHME1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 08:04:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9445A8930A
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 05:02:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRFVlk9mc+jC2VuuZzqyc5KYb0+Jm7zljd6duxEIQXBCTis/idg4DXIZbXu4NzuU0dhCZGNNrRaMMoSQvkV46pzTNP13WRgT3FjQJqx5+4jiXHoY2ZhTbJkY6E6gu1yiLTl5LJ2eCjBjR7NwFHkjMAqloNLuW1O+6VPEDiiuChpiJEaMpXNrDrjccTnfKzdIVU8ja1Z1XkryoEU19v9XyaMnR5DGfM6r/2EavNUqOVAhUALCZvoP15gbVwgB4bGLrstAV9zvfYS/Rh1FJGFJIseI4Y0c5+sibH5TTxT2TosnMGS24fZdzpWyahjXABACjrY2CfBvdq2YktEIWXiv5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKXvKFgzwL3B0TWDoT124Pdiy3HJ1xFCc2On/qD2mlI=;
 b=G8OschxoEw2zOQ2Vz/kvcmV6FJ6NRxZm0w4ZfSfnDgBIUQ/h6iXkBu8IKrvMimznqMHawVfCIDhjqn+oipqGqOiBXc6w8aHxJcIsKpbW3eiDGG2Jam+zKhNRI8jzdtejfjsb36znK2ztRIspegBIlhPc8fLflXfBmmuY0sgP3kbM9jeetNG9m75Jvk0so6MhNrqU0waO8ci8aYJ9j0GJZ6FhLRC5JgJldPdVbbY5rmeEc4aJYeGTygX3JVo5yE/m2NHQVXpccdc3hISg8Fh2+8dSto7fn3fApG4oyxHObxuGWKJkDbS1hzeR5Hee4kN8tlqqMt9XFNGwLxC8IE0Nhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKXvKFgzwL3B0TWDoT124Pdiy3HJ1xFCc2On/qD2mlI=;
 b=pD5929zZgAN2dQM6Hinm3TX/Kz+2tnTLE1Ofqtv7GWHpQ2t330AufrEqBx54JM76Xik6sJE++PLtl7/bMDIJOB/4Josx5iEibavqzMAq6EiO0+lCNMqsWiXEHkXqIEm97qcwcqcpAr/kvcYn4RrHMhJtIjVA4Qrw9OoN5tOq7Jc=
Received: from BL3PR02MB8187.namprd02.prod.outlook.com (2603:10b6:208:33a::24)
 by CO6PR02MB7793.namprd02.prod.outlook.com (2603:10b6:303:a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 12:02:23 +0000
Received: from BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::2995:51b8:59a9:52fc]) by BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::2995:51b8:59a9:52fc%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 12:02:23 +0000
From:   Harini Katakam <harinik@xilinx.com>
To:     Tomas Melin <tomas.melin@vaisala.com>,
        "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Shubhrajyoti Datta <shubhraj@xilinx.com>,
        Michal Simek <michals@xilinx.com>,
        "pthombar@cadence.com" <pthombar@cadence.com>,
        "mparab@cadence.com" <mparab@cadence.com>,
        "rafalo@cadence.com" <rafalo@cadence.com>
Subject: RE: [PATCH v2] net: macb: Restart tx only if queue pointer is lagging
Thread-Topic: [PATCH v2] net: macb: Restart tx only if queue pointer is
 lagging
Thread-Index: AQHYSxw1ebe96eaU50Otacnv9gLy/qzlrhuggAAZxACAAAYhYA==
Date:   Fri, 8 Apr 2022 12:02:23 +0000
Message-ID: <BL3PR02MB818723E41D3939482DBAC23AC9E99@BL3PR02MB8187.namprd02.prod.outlook.com>
References: <20220407161659.14532-1-tomas.melin@vaisala.com>
 <8c7ef616-5401-c7c1-1e43-dc7f256eae91@microchip.com>
 <BL3PR02MB818774AF335BBB8542F22072C9E99@BL3PR02MB8187.namprd02.prod.outlook.com>
 <adf4ce47-142e-711c-bde1-cda1fc0a196c@vaisala.com>
In-Reply-To: <adf4ce47-142e-711c-bde1-cda1fc0a196c@vaisala.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e337ee73-a1b5-488b-5cb4-08da1957a40c
x-ms-traffictypediagnostic: CO6PR02MB7793:EE_
x-microsoft-antispam-prvs: <CO6PR02MB77938FF103EDAB909DACBAE9C9E99@CO6PR02MB7793.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tncFUse8xj+/LGW1FIdcV8A3G97JAUUI2krTck6+vj52tJ/0iFNWaPLMV0FwxU16twXI3SsQYT2Mni3j4sFvgkYOZ7VzDpmba1/6LtFlglKaE916BXc4OQALQcY9YCm8FOenywYTtShw6VmupUcQH6QNsjW0f0ivV81hUbeajw/b/XbiP0LrZAJ6NgS8F6ePWaI76Ka3tGU3z1uoNLyk1ASdkORr0E7g0058UhC5nf09Vbn8hjNqTyFqFUOej3CbsQZJnfxjBoLvv6CQXO60z/M+pe+PdK6rVSWDIonvOrA2SeDigtuMqUWX4ImY55FtXSb64Wbqvm7nz0uPz8qMarxajjbOhoVX/jVFZMKRosoKhBUfx7XqMtYh8tEkcu674rgytqk/ftlI3OlR2R6nAqs4/jw6DVqkbD9H0hKOGI7EAd1syhBo9yYjVVsVSTBG1rmzdSeyxsY1Kqdt9W8kfIXdGV0XQO/oblhwsfqGj8X+wPIL6F7yuV12XEZHFllSQhKTJc8EV7fNuRuhLoEItE4bNS2HbrWkzEa0T13KlJLSNQO/Vh2gs00b8CfV6d6Gsy3hxdhmJvjEyMsv8PHiUDYPpg3kZhasUbRmgddGdjxshnY13XvQNqd2A6p/dNEKxhgHd4WiwZAMvfDysEA/5y7fwLP1vux9iiOTUoSZkox2y/F8OBCP7FXtM1Xrfn+IZ0sueHxr+PBc3daKoiQ+iNSzlW8ZKX/07+qRbpcRUZ38yyvH2nJT/XMuQ1fURZkjymoe5r+fmDXLKUDdKzmQSW3ZSvW8+ayzZsr9JD5iqIw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR02MB8187.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(45080400002)(9686003)(508600001)(110136005)(71200400001)(5660300002)(7696005)(6506007)(53546011)(55016003)(33656002)(83380400001)(54906003)(316002)(66946007)(8676002)(7416002)(66446008)(66556008)(64756008)(2906002)(66476007)(76116006)(86362001)(4326008)(38070700005)(52536014)(38100700002)(26005)(186003)(966005)(8936002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmNYV3Rhbi9aNHJPeVlCVUdjb3BjR1drbTJaQUdxbTliZythQlhIaUVlQnBa?=
 =?utf-8?B?bW1laHpueTFiTTVEd2tKMGhXUWV5akpwdmpsdEhlcXRXSWVEZU1nMnBpWGZI?=
 =?utf-8?B?V0hObitDSlUySUR1Ly9QeDdiUHc0bks4Ly82STZRWklxMU5KRVB0OFpLT0xt?=
 =?utf-8?B?TjhDUlI1Mm8xWW1PSzVWSHZ3TnhJWjIvQlNVZ2NoUWVGd2JucU1IdE5LTjF5?=
 =?utf-8?B?a1BHSmcyUVBLYWg2VWl3eFNCdkZwWkdOMktPQnAzM05SL1VuRU51dkFJVk1P?=
 =?utf-8?B?V3Vaa0ttWjUrZlFNWGdWc2t4NnJmaS9xcEFZTFZaNEpTQ2lkcit4cm94cSta?=
 =?utf-8?B?SWdWS2JjK3lObzBOSjc5d0dNN3pQTzV5ZWxXUDdvNk9wZ1RldzhvY1J2Ylh4?=
 =?utf-8?B?RUhIakJuNWZwS1NXMjVMamxKNFFHNEV3cWtpdThjTlhUQ2hvYVdwMFlpVGhp?=
 =?utf-8?B?YmpzVTAwczF6WkVhSEdFTlJhL2ptNDhZRjBEMDFYZzNrSkR0QVUwR0cvZXRt?=
 =?utf-8?B?emNVcDFRSkFhNC9FbGErRjR0ZFlrL0tWejNDd2gxcGc3Z1lGaWZNd21sRjNv?=
 =?utf-8?B?TUZKcThIRlpnQUQvL08wSTM0ZnVHQmE4N043QlhEbUNQRzU1Qmc5Q3g2SjE3?=
 =?utf-8?B?K2hZK1o1Z29RSkpzSzlKTFlYUG9nMklkUkl2Y3JMc3RNa054dUhoVlkzTlJy?=
 =?utf-8?B?VUlHREs1ZHVqVTFGZzdHUTRhUm9NeWxXekdZM00vZnBiT3R3Y0ltWGxJelBW?=
 =?utf-8?B?MzgrM0drK25PdzdlMm1qTnlPNEl2a3pWM2twZXZKWHQxeW9zNEtvc2ZWdGZR?=
 =?utf-8?B?eXdpOTdpbkNLanBSMmk2NzM1OVV4S25aSmp0M2tHWTZjN2k3ckwyYXFLREpM?=
 =?utf-8?B?RU9HNzJrQzBBdUZZODQ3Y2JSQzFFZExvbVBzdkpyWkFGVmI5YnNIQXUzVDVj?=
 =?utf-8?B?SnBLelZPa0ovRDV3U3hlYjl5QTlEZmg0anNsMTlqSnErYVFPTmxDYmIzREp4?=
 =?utf-8?B?Y2xaVGVOczNZRlBIQTdxbG5RSERRa2JrOFkwM2JycHlibk1zZ3ZWQjBtYlUz?=
 =?utf-8?B?anRmQ3F2anlNdWxXbEE1WjRQcWJCd2JCR2ZlWERIRE5wWkJaU1M0M1VsaUNl?=
 =?utf-8?B?OFFZNVNYVll2TzhKeFNOY0xnWTBuUExiLzg5Uld1T1liR21EMXRGUlI3T0cr?=
 =?utf-8?B?QVZSa0JHaWZib1NHc0NnQ09OK2tBN2RGR01POFFXSE82cyt1N254T09jVmIy?=
 =?utf-8?B?cmY1REJyOFI0VlJrS0x2a2JLSVN1YzJhNFVoeVMrKzM3SUs2a2I1QWc2dTc4?=
 =?utf-8?B?WlplaUFJU1BKaUVlUkZUNThUSGYvR0N2YytPVUlqNUhFMnVpTUJTekl5bTRk?=
 =?utf-8?B?cWpFNlBzd0pleENXQXdldDV6c1puWEw0WTVQaGJhcXd4a3JYMU1yQTQvWWlm?=
 =?utf-8?B?ZGJGQlVMQ1pvdjNraGFzV1B3RFN5R2ZOVUV5cnZDQXNsYndyUGw3ZzNleWxi?=
 =?utf-8?B?c2dxTFEzb1p1ZU05MjZWaEJRZ0ZTR1A5VlRIZEJLVDNWZE5FejN4OUxmamtz?=
 =?utf-8?B?Z1oyYlYxeW83RjNUSDBGdlBzMFZxUnFIUi9tdjJqcit0UW1Cdi9Nd2l0Wkpp?=
 =?utf-8?B?TzUwTUY1ZWRiK0NjODg2WThvWHFweHQzWkxMMmQzRnNPcDRlNkNrSWlyb1M4?=
 =?utf-8?B?VURnb1FCTHlVZFlsVG5uZEJyU1psb0NaQUVHeVpOWmV3OURWSUlJNXoyWnR1?=
 =?utf-8?B?ZS9JQnk2Wlh3NlZoRkMzMjU2anlQN3hpSk1TVDdKeWJXL05QKzk2WTF6VmRL?=
 =?utf-8?B?WGp5VWNMNmpJa2QzTEFZa3QzRFJQL2xyNEhlY01uMFVkZm9WTWw1d2I2Um9j?=
 =?utf-8?B?VUxKdTYwUDlxekd3STFHL1ZOaHRmeUFqWXdIeDhhOVJENWxzZmFFZUV3U2x5?=
 =?utf-8?B?bGtNMHFpQWxCc3luNVlhYmhseGRXSEFUbDhqNVJKa1VBODZneEFweDZOaGJ1?=
 =?utf-8?B?V2p3a2pRZURFRy9Td21sYW1SUUtjOHNHaTJVaXUzQ0Y4QUt5WEpDYUZpK05X?=
 =?utf-8?B?bHNzQjFqcDM4QTkvOC9mZExodkNLVnBzUTRHdElUdHJuUCtUdjhqVm1WRzB5?=
 =?utf-8?B?WUxRVWh5WXNzeU14MkEvRDZBN1htMHRUTTE4SDgvR0ZmQWlZZG1kQVh5cVVM?=
 =?utf-8?B?UGZ1dFZhb3ZydDlZZ0l2b0xSbGFqM1BKSU8reGpGb2k2ZjNWUGJIWlBjRU5D?=
 =?utf-8?B?VnRHWmoyZkp1bllKOWVvUDFHdlZrbzg5WmxvcU5MT0QybVhraFp3WmVHL1dZ?=
 =?utf-8?B?c3R0TnpNSTBiUWk1NVVRZ0U5SzNMTXRwTzdzWklCYys5ekJkOE9LZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR02MB8187.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e337ee73-a1b5-488b-5cb4-08da1957a40c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 12:02:23.0531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WNlkVd/w/UvbYIwdjuQz35OQgZX3N4pP2dJlEoOFXhZ7rEgISSgQCBpsmFIEOfOOq4NsOlEYEgPaut9EaGK2cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7793
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVG9tYXMsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVG9tYXMg
TWVsaW4gPHRvbWFzLm1lbGluQHZhaXNhbGEuY29tPg0KPiBTZW50OiBGcmlkYXksIEFwcmlsIDgs
IDIwMjIgMzoyNyBQTQ0KPiBUbzogSGFyaW5pIEthdGFrYW0gPGhhcmluaWtAeGlsaW54LmNvbT47
IENsYXVkaXUuQmV6bmVhQG1pY3JvY2hpcC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcN
Cj4gQ2M6IE5pY29sYXMuRmVycmVAbWljcm9jaGlwLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
a3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNvbTsgU2h1YmhyYWp5b3RpIERhdHRh
IDxzaHViaHJhakB4aWxpbnguY29tPjsgTWljaGFsDQo+IFNpbWVrIDxtaWNoYWxzQHhpbGlueC5j
b20+OyBwdGhvbWJhckBjYWRlbmNlLmNvbTsNCj4gbXBhcmFiQGNhZGVuY2UuY29tOyByYWZhbG9A
Y2FkZW5jZS5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0gbmV0OiBtYWNiOiBSZXN0YXJ0
IHR4IG9ubHkgaWYgcXVldWUgcG9pbnRlciBpcyBsYWdnaW5nDQo+IA0KPiBIaSBDbGF1ZGl1LCBI
YXJpbmksDQo+IA0KPiBPbiAwOC8wNC8yMDIyIDExOjQ3LCBIYXJpbmkgS2F0YWthbSB3cm90ZToN
Cj4gPiBIaSBDbGF1ZGl1LCBUb21hcywNCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+PiBGcm9tOiBDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tIDxDbGF1ZGl1LkJl
em5lYUBtaWNyb2NoaXAuY29tPg0KPiA+PiBTZW50OiBGcmlkYXksIEFwcmlsIDgsIDIwMjIgMTox
MyBQTQ0KPiA+PiBUbzogdG9tYXMubWVsaW5AdmFpc2FsYS5jb207IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmcNCj4gPj4gQ2M6IE5pY29sYXMuRmVycmVAbWljcm9jaGlwLmNvbTsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsNCj4ga3ViYUBrZXJuZWwub3JnOw0KPiA+PiBwYWJlbmlAcmVkaGF0LmNvbTsgSGFy
aW5pIEthdGFrYW0gPGhhcmluaWtAeGlsaW54LmNvbT47IFNodWJocmFqeW90aQ0KPiA+PiBEYXR0
YSA8c2h1YmhyYWpAeGlsaW54LmNvbT47IE1pY2hhbCBTaW1layA8bWljaGFsc0B4aWxpbnguY29t
PjsNCj4gPj4gcHRob21iYXJAY2FkZW5jZS5jb207IG1wYXJhYkBjYWRlbmNlLmNvbTsgcmFmYWxv
QGNhZGVuY2UuY29tDQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIG5ldDogbWFjYjogUmVz
dGFydCB0eCBvbmx5IGlmIHF1ZXVlIHBvaW50ZXIgaXMNCj4gbGFnZ2luZw0KPiA+Pg0KPiA+PiBI
aSwgVG9tYXMsDQo+ID4+DQo+ID4+IEknbSByZXR1cm5pbmcgdG8gdGhpcyBuZXcgdGhyZWFkLg0K
PiA+Pg0KPiA+PiBTb3JyeSBmb3IgdGhlIGxvbmcgZGVsYXkuIEkgbG9va2VkIHRob3VnaCBteSBl
bWFpbHMgZm9yIHRoZSBzdGVwcyB0bw0KPiA+PiByZXByb2R1Y2UgdGhlIGJ1ZyB0aGF0IGludHJv
ZHVjZXMgbWFjYl90eF9yZXN0YXJ0KCkgYnV0IGhhdmVuJ3QgZm91bmQNCj4gPj4gdGhlbS4NCj4g
Pj4gVGhvdWdoIHRoZSBjb2RlIGluIHRoaXMgcGF0Y2ggc2hvdWxkIG5vdCBhZmZlY3QgYXQgYWxs
IFNBTUE1RDQuDQo+ID4+DQo+ID4+IEkgaGF2ZSB0ZXN0ZWQgYW55d2F5IFNBTUE1RDQgd2l0aCBh
bmQgd2l0aG91dCB5b3VyIGNvZGUgYW5kIHNhdyBubw0KPiA+PiBpc3N1ZXMuDQo+ID4+IEluIGNh
c2UgRGF2ZSwgSmFrdWIgd2FudCB0byBtZXJnZSBpdCB5b3UgY2FuIGFkZCBteQ0KPiA+PiBUZXN0
ZWQtYnk6IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KPiA+
PiBSZXZpZXdlZC1ieTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5j
b20+DQo+IA0KPiBUaGFuayB5b3UgZm9yIHRoZSBlZmZvcnQgdG8gcmV2aWV3IGFuZCB0ZXN0IHRo
aXMhIEFsc28gdGhhbmtzIGZvciB0aGUNCj4gZGlzY3Vzc2lvbnMgYXJvdW5kIHRoaXMgaXNzdWUg
dG8gcHJvdmlkZSBmdXJ0aGVyIGluc2lnaHRzLg0KPiANCj4gDQo+ID4+DQo+ID4+IFRoZSBvbmx5
IHRoaW5nIHdpdGggdGhpcyBwYXRjaCwgYXMgbWVudGlvbiBlYXJsaWVyLCBpcyB0aGF0IGZyZWVp
bmcgb2YgcGFja2V0DQo+IE4NCj4gPj4gbWF5IGRlcGVuZCBvbiBzZW5kaW5nIHBhY2tldCBOKzEg
YW5kIGlmIHBhY2tldCBOKzEgYmxvY2tzIGFnYWluIHRoZQ0KPiBIVw0KPiA+PiB0aGVuIHRoZSBm
cmVlaW5nIG9mIHBhY2tldHMgTiwgTisxIG1heSBkZXBlbmQgb24gcGFja2V0IE4rMiBldGMuIEJ1
dA0KPiBmcm9tDQo+ID4+IHlvdXIgaW52ZXN0aWdhdGlvbiBpdCBzZWVtcyBoYXJkd2FyZSBoYXMg
c29tZSBidWdzLg0KPiANCj4gSW5kZWVkLCB0aGlzIGlzIG5vdCBiZWhhdmlvdXIgSSBoYXZlIGVu
Y291bnRlcmVkIGluIGFueSB0ZXN0aW5nLiBJZiB3ZQ0KPiB3ZXJlIGV2ZXIgdG8gZW5jb3VudGVy
IHN1Y2ggaXNzdWUsIHRoZW4gaXQgd291bGQgbmVlZCB0byBiZSBoYW5kbGVkIGluDQo+IHNlcGFy
YXRlIG1hbm5lci4gUGVyaGFwcyBjYWxsIHR4X2ludGVycnVwdCgpIHRvIHByb2dyZXNzIHRoZSBx
dWV1ZS4gQnV0DQo+IHRoZW4gYWdhaW4sIHRoaXMgZG9lcyBub3Qgc2VlbSB0byBoYXBwZW4uDQo+
IA0KPiA+Pg0KPiA+PiBGWUksIEkgbG9va2VkIHRob3VnaCBYaWxpbnggZ2l0aHViIHJlcG9zaXRv
cnkgYW5kIHNhdyBubyBwYXRjaGVzIG9uIG1hY2INCj4gdGhhdA0KPiA+PiBtYXkgYmUgcmVsYXRl
ZCB0byB0aGlzIGlzc3VlLg0KPiA+Pg0KPiA+PiBBbnl3YXksIGl0IHdvdWxkIGJlIGdvb2QgaWYg
dGhlcmUgd291bGQgYmUgc29tZSByZXBsaWVzIGZyb20gWGlsaW54IG9yIGF0DQo+ID4+IGxlYXN0
IENhZGVuY2UgcGVvcGxlIG9uIHRoaXMgKHByZXZpb3VzIHRocmVhZCBhdCBbMV0pLg0KPiA+DQo+
ID4gU29ycnkgZm9yIHRoZSBkZWxheWVkIHJlc3BvbnNlLg0KPiA+IEkgc2F3IHRoZSBjb25kaXRp
b24geW91IGRlc2NyaWJlZCBhbmQgSSdtIG5vdCBhYmxlIHRvIHJlcHJvZHVjZSBpdC4NCj4gPiBC
dXQgSSBhZ3JlZSB3aXRoIHlvdXIgYXNzZXNzbWVudCB0aGF0IHJlc3RhcnRpbmcgVFggd2lsbCBu
b3QgaGVscCBpbiB0aGlzDQo+IGNhc2UuDQo+ID4gQWxzbywgdGhlIG9yaWdpbmFsIHBhdGNoIHJl
c3RhcnRpbmcgVFggd2FzIGFsc28gbm90IHJlcHJvZHVjZWQgb24gWnlucQ0KPiBib2FyZA0KPiA+
IGVhc2lseS4gV2UndmUgaGFkIHNvbWUgdXNlcnMgcmVwb3J0IHRoZSBpc3N1ZSBhZnRlciA+IDFo
ciBvZiB0cmFmZmljIGJ1dCB0aGF0DQo+IHdhcw0KPiA+IG9uIGEgNC54eCBrZXJuZWwgYW5kIEkn
bSBhZnJhaWQgSSBkb27igJl0IGhhdmUgYSBjYXNlIHdoZXJlIEkgY2FuIHJlcHJvZHVjZQ0KPiB0
aGUNCj4gPiBvcmlnaW5hbCBpc3N1ZSBDbGF1ZGl1IGRlc2NyaWJlZCBvbiBhbnkgNS54eCBrZXJu
ZWwuDQo+ID4NCj4gPiBCYXNlZCBvbiB0aGUgdGhyZWFkLCB0aGVyZSBpcyBvbmUgcG9zc2liaWxp
dHkgZm9yIGEgSFcgYnVnIHRoYXQgY29udHJvbGxlcg0KPiBmYWlscyB0bw0KPiA+IGdlbmVyYXRl
IFRDT01QIHdoZW4gYSBUWFVCUiBhbmQgcmVzdGFydCBjb25kaXRpb25zIG9jY3VyIGJlY2F1c2UN
Cj4gdGhlc2UgaW50ZXJydXB0cw0KPiA+IGFyZSBlZGdlIHRyaWdnZXJlZCBvbiBaeW5xLg0KPiAN
Cj4gVGhpcyBpcyBpbnRlcmVzdGluZyBoeXBvdGhlc2lzIGFuZCB0aGF0IHdvdWxkIGluZGVlZCBs
ZWFkIHRvIHRoaXMgc2l0dWF0aW9uLg0KPiANCj4gDQo+ID4NCj4gPiBJJ20gZ29pbmcgdG8gY2hl
Y2sgdGhlIGVycmF0YSBhbmQgbGV0IHlvdSBrbm93IGlmIEkgZmluZCBhbnl0aGluZyByZWxldmFu
dA0KPiBhbmQgYWxzbw0KPiA+IHJlcXVlc3QgQ2FkZW5jZSBmb2xrcyB0byBjb21tZW50Lg0KPiA+
IEknbSBzb3JyeSBhc2sgYnV0IGlzIHRoaXMgY29uZGl0aW9uIHJlcHJvZHVjaWJsZSBvbiBhbnkg
bGF0ZXIgdmFyaWFudHMgb2YgdGhlIElQDQo+IGluIFhpbGlueCBvcg0KPiA+IG5vbi1YaWxpbngg
ZGV2aWNlcz8NCj4gDQo+IEkgaGF2ZSBub3Qgc2VlbiB0aGlzIGlzc3VlIG9uIE1QU29DIChhdGxl
YXN0IHlldCkuIEluZGVlZCB0aGlzIGlzc3VlDQo+IHNlZW1zIHRvIHJlcXVpcmUgdGhlIGNvcnJl
Y3QgdGltaW5nIGNvbmRpdGlvbnMgZm9yIGJlaW5nIGFibGUgdG8gdHJpZ2dlciBpdC4NCj4gDQo+
IFNvIGFueSBhZGRpdGlvbmFsIGluZm9ybWF0aW9uIHRoYXQgd2UgbWlnaHQgZ2V0IGFib3V0IHBv
c3NpYmxlIGlzc3VlcyBpbg0KPiBJUCBpcyB3ZWxjb21lZC4gSG93ZXZlciwgdGhlIGhhcmR3YXJl
IG9uIHRoZSBib2FyZHMgd2UgaGF2ZSBhdCBoYW5kIHdpbGwNCj4gc3RpbGwgYmUgdGhlIHNhbWUg
c28gdGhlIHBhdGNoIGFzIHN1Y2ggaXMgcmVsZXZhbnQuDQoNClllcywgYWdyZWVkLiBUaGUgcGF0
Y2ggaXMgc3RpbGwgcmVxdWlyZWQuDQoNClJlZ2FyZHMsDQpIYXJpbmkNCg0KPiANCj4gQlIsDQo+
IFRvbWFzDQo+IA0KPiANCj4gDQo+ID4gWnlucSBVUysgTVBTb0MgaGFzIHRoZSByMXAwNyB3aGls
ZSBaeW5xIGhhcyB0aGUgb2xkZXIgdmVyc2lvbiBJUCByMXAyMw0KPiAob2xkIHZlcnNpb25pbmcp
DQo+ID4NCj4gPiBSZWdhcmRzLA0KPiA+IEhhcmluaQ0KPiA+DQo+ID4+DQo+ID4+IFRoYW5rIHlv
dSwNCj4gPj4gQ2xhdWRpdSBCZXpuZWENCj4gPj4NCj4gPj4gWzFdDQo+ID4+DQo+IGh0dHBzOi8v
ZXVyMDMuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUy
RmxvcmUuaw0KPiBlcm5lbC5vcmclMkZuZXRkZXYlMkY4MjI3NmJmNy03MmE1LTZhMmUtZmYzMy0N
Cj4gJmFtcDtkYXRhPTA0JTdDMDElN0N0b21hcy5tZWxpbiU0MHZhaXNhbGEuY29tJTdDMzUyYTUz
MmZlMTRiNDJhZA0KPiAwMWQ1MDhkYTE5M2M2MzIwJTdDNmQ3MzkzZTA0MWY1NGMyZTliMTI0YzJi
ZTVkYTVjNTclN0MwJTdDMCU3QzYNCj4gMzc4NTAwNDQ0MDA2NTA1MjIlN0NVbmtub3duJTdDVFdG
cGJHWnNiM2Q4ZXlKV0lqb2lNQzR3TGpBd01EDQo+IEFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2
SWsxaGFXd2lMQ0pYVkNJNk1uMCUzRCU3QzMwMDAmYW1wO3NkYXRhPQ0KPiByc0JuSkVWbERxcFNV
SWZMJTJCdVh6QWdUVUw0dzlycWFSNkE2T0xBaTlnTlElM0QmYW1wO3Jlc2VydmVkPQ0KPiAwDQo+
ID4+DQo+IGY4ZmUwYzVlNGE5MEBtaWNyb2NoaXAuY29tL1QvI202NDRjODRhODcwOWE2NWM0MGI4
ZmMxNWE1ODllODNiMjRlNA0KPiA+PiA4Y2NmZA0KPiA+Pg0KPHNuaXA+DQo=
