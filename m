Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4EE57447C
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 07:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiGNF1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 01:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiGNF1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 01:27:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A004720BCD
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:27:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKpNIUqG1eokvsBTHilUl6+RTbvf2Um3J0RfaPFctHcGLXqOTN92QlRBvbS3/3nZoUD/kNguAYVW/pcQaaAxle02lJ8yf1aQ8upd5chs8JegFO2RRRcYxg9Mrw/yn9S0Y/0SvXvodj6U1d+Mc3jXtinvQ48VVCDHLoajLA5/cHxkbwoksqks18+NHoU3FJr/pXHf3mXr0LXVo2LJfqG7hYJ+Go4M9wO+uzz+hXRgYgB9wXFEZsJCp+VsCVBMJpsiSwvdnG6N6D+2v2sEpSWX6pnu5ZClXbresDMXC4mpAk68TAXAvmxDiERslmauHIZQf9CsmErMMlKfD26InMYHOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYI+2DJnTjohT9I/Ec3te2PZFFPDjfy2BW5AucINMfg=;
 b=AsRLWrRNVIxwQ0usUpuHm99BZ1kPpnJWDXyLlSmSdIiU4Hy9JCMDLROu0jIDfa+KHrMEx4pLV7kqZKNWt4oXOg1ybu7Z+zlhvBsqQoxehdEI7E8jx/kVpZl/Wigf4ZB7PR8NQR4b5ElyC28PjWt3X2R9IqSHRYQWhnT6WFpojn0efU6Jk7qCWLaTPaCS695JaMu6WPbQWiVp4IxtNtQfHVat28bM49DwQWJrDagiNmsPvIltm7py4do4RUFCEIq+WgbydZ3Gvki9FAGbaT88lCefrHOavbsH2hPzlq5Www1Aq7eC8ed7rPx+FOcMbUoab3Zn1mcJGUHXEETshNfP8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYI+2DJnTjohT9I/Ec3te2PZFFPDjfy2BW5AucINMfg=;
 b=ZdCsZK1nUd42qpGjTTfAHq8On+cJexaAZ5meitHiL8jPZhcpUq544VohyO5GcKyYGjsNYy9yU1DEZlZ5nYqSt7XMi98Gg9jD3+Kpg345VClvoSRLdlIJpVi0di8WuSFcrWVlYIgC6h5HZ1ei2/LvIGraRpqlBSwd+b6ykPUOdECP177Lw2/s5CEdVR7r0ONX34S2Mke2C2W2PIBbIS8oeccrlA/KymjjlGfbGKHOzPpf4M4IJJgNMOHhp6kn7EL+CS6JoyQ3pKFOIbNPXEm55bGor8IYjxEty5LsDgigqYDUrqWwOyR0uVrm7U0bMumOIl/VedQ9mJQ/PEqDufiYBw==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13; Thu, 14 Jul
 2022 05:27:32 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::fd63:3074:ae57:c82f]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::fd63:3074:ae57:c82f%9]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 05:27:32 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     David Ahern <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "mst@redhat.com" <mst@redhat.com>
Subject: RE: [PATCH v1] vdpa: Add support for reading vdpa device statistics
Thread-Topic: [PATCH v1] vdpa: Add support for reading vdpa device statistics
Thread-Index: AQHYgGp9IbpSHDHW6EuvFbzMKlhYba13PVcQgAXhPQCAAGQ6QA==
Date:   Thu, 14 Jul 2022 05:27:31 +0000
Message-ID: <DM8PR12MB54000C4398D6AB15A6C56627AB889@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220615034616.16474-1-elic@nvidia.com>
 <DM8PR12MB54007939BDF9777A237A4981AB849@DM8PR12MB5400.namprd12.prod.outlook.com>
 <faaafd40-48c0-1e03-3e7d-549d73ca1df0@kernel.org>
In-Reply-To: <faaafd40-48c0-1e03-3e7d-549d73ca1df0@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f3cd8de-2c9f-477c-210c-08da65598cfc
x-ms-traffictypediagnostic: LV2PR12MB5797:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oIhlMNFTfZ1hvsBy4MfgUFHpsjEcosUG6GAwyMmWSJvTKXbTap5PynuWQZe1Ob5D2OXEtO5WwOfF0XGPOMOxkjGeZ3BMmgeKM9eTpm024PjPo7QAFijNGuL12mgsBskFGO4axI1QlNvwwJeS33DbozsW+b+3uY2O1Ts+mNCQS1VPBS5vaj/Ma0zBHnz92H1rdp7nmaGQ7qGSrlG8JF/fsXipUpyOPEtOI2XSOEM35MlYwMh/FYI6L598ow8enM2RFrcrkQHpI3UoNOU+NWFUahbFNrblIGJUH64mwwJnGgeYZEGFc0+jHlDo6sBxMs//F8nI2ZBr5hOGvTGioI2Xlmm5kwVH52+MDKhwYDUrSKHrS2hf8XSw8l+G4zQVuCJ+X5l5hmeaIU92E9R70jqujlaaao8M5SxxrnRK72i4/xBDinUzvVVtmv7BQZp5VP/RbhRCWRQmaO2VyqOCmDYAgHsLru5lnSNlmuyzWhx7AfYZ2PXD8AKiYXgDWtVwPcOGeNXBjGvyjZT5e3+uDpkU1IQN8VDhD1RZd0J5+26vqzH1AGSvsC7AC5dX9yoH9+dqS5ncYeFRLCTmw6pnQkgX1U39P+SJsGShIv0LPtyO1JIWn5ihDda3/PxC5X1J5IZIufxXQH/VUjVctCQxvl51rndr3Q9Sl1xYiJfV4N+rXtcAmeR5+7YXIGUvRd+kZopPFUlnyDL2VSX4Ca2daM9oHsXhSRnC2B/g8s7Q+6ALhPADxuaBPPhnu40ktXy8CrXIYfSjcD6k8BUmkT0c1HO6meVtrL+ruFGfbH83EKrg6ulsitJ6XifF08/MVIJQb/ox9g4XBhxe/AArmmsURTsCIKYyyp6OdkOvrVOB6QoUsVm26lXbme4Z9j1lyi351+51jAuhdLo4fwbkXlJgP76WCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(53546011)(41300700001)(6506007)(66946007)(64756008)(26005)(9686003)(7696005)(52536014)(5660300002)(76116006)(966005)(66476007)(66446008)(66556008)(110136005)(86362001)(478600001)(316002)(71200400001)(122000001)(38100700002)(38070700005)(83380400001)(8676002)(8936002)(2906002)(186003)(55016003)(33656002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFV4bVdQOWg2TGI4eXdOY2pxN0RMRy9HM2MveDBCajRrTEpQcWRDeFUxNVd3?=
 =?utf-8?B?azM0Z0pyUmFzTWI4OUgyaGtQUTJaUkdOOVVVU0UvU3JQelhUcFd5ZWkxWTVn?=
 =?utf-8?B?TVh0b3pUdTJ5bUZrY1ZYUmVxYnVISEw3amM0MmhrU29MNzU2TUduQmgxWnZY?=
 =?utf-8?B?a01zSEV5UlN4ZDlpU242V1BWa243dmRRMXpPbDU4emFwdEtmMmg0dVdjdG9Q?=
 =?utf-8?B?ZjBoWk1tdy9YVVR1SG9jY3dpK1l3ZlZ2MEs1TE0zRUY4QmVnZ1dZczBJbXJs?=
 =?utf-8?B?Q2hiNUlNWnExV1JkdVVZemM3a3l4akxFUlBDa2RrL0NFd3dabFh3QjBXRldo?=
 =?utf-8?B?V1dUYW4rNXc3Y2Q2VTBoRFhYSlR4ZEFmWVJrbWdoSFRYRThZUVNZTERRM1BR?=
 =?utf-8?B?dnVDdmFnUTNPT2ZUMUV6RDU3WU5hdDc2VVpSUU10bGZuK3I2ZDdtbTN2WDk3?=
 =?utf-8?B?eVlyOUVmdWxYTFVhcmphYzdrdEhua0F4ZHg2ZWZvVEFGbHF3c3ZWZ2ZQdUdt?=
 =?utf-8?B?bmh1WjY1Wmt5RjNvOUl5bGJuZjV4OXlieU5QbjRMYmFDZGd0UXB3SWRyMUNh?=
 =?utf-8?B?a09OaDVFaEM0a202ZUc1RGhZNzljejdYZjcvd1ZaQk5Ya0xMbG4ybGVrNG53?=
 =?utf-8?B?K2dSZmVsNXZhaHFZQmhycWlmSHhqZHJvRGNHbHFHTll3S1hDZTRNVzY1dmdt?=
 =?utf-8?B?em5nT3NmUHBsZVd0aGhmYk9hQVEwWldaOGFnNlgvZENOQ1pVUWdMcDNZdjcv?=
 =?utf-8?B?MVVzbXR2R0dxYk5UNmpPYkRLdjNPenhPRko2bkVXQU9ncU0zdmVRSElNeFhF?=
 =?utf-8?B?WTFwbXUzcmpXWEtpTlZick1BckNiV1kxRTFEWFBUYlFaMGRPaEg2Vzl0eDQ4?=
 =?utf-8?B?eGRaZXltQXhELzBYampFOGUzaGpCVFYrYkQ1Y2toZWF6Z3MwM0xMQ2txbjRm?=
 =?utf-8?B?Y2JJOVZwWnloR3RLZGJqR0gvTFV5bkNRZEZ0WU5GQ01YWTZuRWNYTEVLR3JR?=
 =?utf-8?B?MjgvYzBxRGhCOEZPTUhSenkxNm5FMHVNaXZ1eEFlaThvYUJ1REhwWjlyNVJV?=
 =?utf-8?B?VGFOQ2t5UGVlMDloZ3IwV0RFT2pRMTdmandoaFlCeHdVZ1hScS9FS0k3YjYz?=
 =?utf-8?B?R2hFSDZRZVV0cnBvbExSZDFDNmpycWZjK0MzdGdPNlJrRHNERkRxMDlFS0Zz?=
 =?utf-8?B?Uk9nWCtPMk43OFRpTzg1VjJYMmh3V241SVVxbDhuWUVxREtQcVJ5ekhKdXcw?=
 =?utf-8?B?OXZHVHJ2aCtDZUgvT0dYdkprYkpvT3NmeTB1ZGZ4LzBzSE5Zb1lSZDQzM1BK?=
 =?utf-8?B?bk9VZUVERXpmaHcvZEZudDB0OWdKU09jYkZVMm9nMldDajh0M2dGcGczTnRz?=
 =?utf-8?B?VVdRTzZ4OXlvRUtlTEZ0ZFJCWTlMR3J5WW8vVVIwb1pRMHAvQ3FvY2dPMXhT?=
 =?utf-8?B?UWhLaWltOElkdHZFTXZOOGxsMVhpTTRtNjVURlp3cGM5YUtoOFRZTUdSTWNp?=
 =?utf-8?B?bDIvbGtmbU1mYVZMY0tGV0ZnZHQ2elcrM2VWaCtsMy9wM0lVczBDYlQrQ1c2?=
 =?utf-8?B?MWpkL1plaEFndExIRWQvditkMG1hbUZTZGkvdDJuY0tGbGxkV1p2KzdiMzJE?=
 =?utf-8?B?UDJoOGViOGdLNWFLZHZtL0VHU3dQaGthZ1ZsYnk4NzlkS0I2cmVVdTJsZHlx?=
 =?utf-8?B?RUZXY2poSVVFUndJVGUxUS9HbEpKN2dXZFRvaXFNaDYrSkwzRFFnU3V4Q29H?=
 =?utf-8?B?NCsyaThPSEVibk9YTUVidnJ2OENJNlA0K3BUQ0JVa2x6bHlsMHZ2QnBHSUZ0?=
 =?utf-8?B?MGZ6ZE9IODJHUG0wQVF2WFRUQXcrS3FiOWFES2dJRmpFZ1NiSVN6M2t5SjI1?=
 =?utf-8?B?MEdyVC83Nm0yRUJFT0U2ZFY0SlBoUXY3cFlZaXBnSGNKNC9pWnZsaldIUHB5?=
 =?utf-8?B?c0hHSWFLdU9jQURlSGV6OVZCMjZBaTlBYzR1T0dBeXA2aXFRdExxMEhZS3JE?=
 =?utf-8?B?aWFBdDF3eEN3YzJxbUp4ZVZPaFU1aGZMY0JYUEZtdnAyRFdYTFpXbnV3M0Fy?=
 =?utf-8?B?c0tRMXUrVGNoV0RvWExMWjhVK0lrSTZGL1VOZ2VjbzVFdUZzYStJU3MrNWk2?=
 =?utf-8?Q?5Iq0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3cd8de-2c9f-477c-210c-08da65598cfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 05:27:31.7706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wmBmcJZ/ZfCo6DxrohNlIdb2vEZOjgQ2Q+Am2Q/3sZRqarg9RWls3PMTuW/c4HRv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBrZXJuZWwub3JnPg0KPiBTZW50OiBUaHVyc2Rh
eSwgSnVseSAxNCwgMjAyMiAyOjI1IEFNDQo+IFRvOiBFbGkgQ29oZW4gPGVsaWNAbnZpZGlhLmNv
bT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LWZv
dW5kYXRpb24ub3JnOyBqYXNvd2FuZ0ByZWRoYXQuY29tOyBzaS0NCj4gd2VpLmxpdUBvcmFjbGUu
Y29tOyBtc3RAcmVkaGF0LmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxXSB2ZHBhOiBBZGQg
c3VwcG9ydCBmb3IgcmVhZGluZyB2ZHBhIGRldmljZSBzdGF0aXN0aWNzDQo+IA0KPiBPbiA3Lzkv
MjIgMTA6NDAgUE0sIEVsaSBDb2hlbiB3cm90ZToNCj4gPiBIZWxsbyBEYXZpZC4NCj4gPiBJIGhh
dmVuJ3Qgc2VlbiBhbnkgY29tbWVudHMgZnJvbSB5b3Ugbm9yIGhhcyBpdCBiZWVuIG1lcmdlZC4N
Cj4gPg0KPiA+IElzIHRoZXJlIGFueXRoaW5nIGVsc2UgbmVlZGVkIHRvIGhhdmUgdGhpcyBtZXJn
ZWQ/DQo+ID4NCj4gDQo+IEkgc2VlIGl0IGluIGlwcm91dGUyLW5leHQ6DQo+IA0KPiBjb21taXQg
NmY5N2U5YzkzMzdiOWMwODNlYTA3MTliNjMzNjIyYmNmZWY1ZDc3Yg0KPiBBdXRob3I6IEVsaSBD
b2hlbiA8ZWxpY0BudmlkaWEuY29tPg0KPiBEYXRlOiAgIFdlZCBKdW4gMTUgMDY6NDY6MTYgMjAy
MiArMDMwMA0KPiANCj4gICAgIHZkcGE6IEFkZCBzdXBwb3J0IGZvciByZWFkaW5nIHZkcGEgZGV2
aWNlIHN0YXRpc3RpY3MNCg0KVGhhbmtzLg0KDQpJIHdhcyB1c2luZyB0aGlzIHRyZWU6IGh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9uZXR3b3JrL2lwcm91dGUyL2lwcm91dGUyLmdpdA0K
QW5kIGl0IGlzIG5vdCB0aGVyZS4NCg0KTm93IEkgZm91bmQgaXQgaGVyZTogZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9uZXR3b3JrL2lwcm91dGUyL2lwcm91dGUyLW5leHQuZ2l0IG9uIHRo
ZSAibWFpbiIgYnJhbmNoLg0KDQpTbyBzaG91bGQgSSBzZW5kIHBhdGNoZXMgYWdhaW5zdCB0aGUg
bGF0ZXI/DQo=
