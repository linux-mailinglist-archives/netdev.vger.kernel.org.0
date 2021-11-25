Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872AC45D23E
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 01:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344985AbhKYAyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 19:54:21 -0500
Received: from mail-bn1nam07on2127.outbound.protection.outlook.com ([40.107.212.127]:35156
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243756AbhKYAwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 19:52:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmRoCLc8w+aMZ44Bo6Kq1yj8jqrKAM/I1N/ugVjoIjz3bB6oeaz3H/ElqQHk/ASCzACS/4tGCRb3EhpD2ohCrVDcxZ0F9mzYHAcS7DVFBSlsNysUUU/rPLCD7bPqbf3hlR4qiJK1aJ/3FFugMuj1GzIYdexOX2EM20cPkB2JiYGXHsmFoZPnLUBQLmYTZA4IJlQlNZhzOGNx6LIsATDfEeP2GSyAI2DmuVkIfVa3YmIqzYfYSaupg5b2c1AJqNmQlRu2hxy9DNN4ydo3tA3x32yi5ivZT7uVmiFse67duYm5Kf1oGXWBr+rWoEjlMI4H6otZ6kVsq98eWbbDg3SPhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DsY62cD3Whzc88WmDuhLz+qbhnYrDBN5crUW2fLy0g=;
 b=MpmQZc0E5tjOalkJOzKWqfI0tPwe8SAJU3QRfwFgEyhBcxozt845CcZcb9t6loUW2NT+q06mJDTNa1FNo+zyOklBpk7vMbbx6H2dZc0MbZSkfpRpx43yZ5RRsxaCnAUSLy8IZ04qzCF59giDckbORUx096GCd6cBGDdBd0SSEaD05THj1OY8GdAbtu/L9BRRme1wMiVrBASmFI9EDXlWg7k8pBDtvjUYRZHTOhZSit+NrXr5KEu+UxJqWpKJnu77eXI6PqbLQXwZ4mq/ZsAfUCCPAZsGZlcS7mah6apvOBYaMRwUSJmeqjGZ87h7xf56JWM8k/Gmo6M0jfXBWcwpYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DsY62cD3Whzc88WmDuhLz+qbhnYrDBN5crUW2fLy0g=;
 b=GeRKxTLJ7VAZru//HH0VseGLGFJXxySi/eRnvl/ww4g+lPJMGlPDJIDefEiGEDslyh0pSriayb/R3I8+mG1lqjAtkFVps1tXTslxw9VZk0/14nwDvdhhbdO3T+FNJeLFz0ckeGEyZrWvY30wDwEnrpIetm2RYhBZ9VDIQfM1RSg=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB4316.namprd13.prod.outlook.com (2603:10b6:5:34::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.11; Thu, 25 Nov
 2021 00:49:08 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4755.007; Thu, 25 Nov 2021
 00:49:07 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v4 04/10] flow_offload: allow user to offload tc action to
 net device
Thread-Topic: [PATCH v4 04/10] flow_offload: allow user to offload tc action
 to net device
Thread-Index: AQHX3H1ga5WIPFCaM0W10xbzQpwKhKwPftuAgAFJvqCAALgaAIAAbhwwgAAU+6CAAJMrgIAAISRAgAAWdACAAKRgoA==
Date:   Thu, 25 Nov 2021 00:49:07 +0000
Message-ID: <DM5PR1301MB217290C4B7759215BB5B184FE7629@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-5-simon.horman@corigine.com>
 <cf194dc4-a7c9-5221-628b-ab26ceca9583@mojatatu.com>
 <DM5PR1301MB2172EFE3AC44E84D89D3D081E7609@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <404a4871-0e12-3cdc-e8c7-b0c85e068c53@mojatatu.com>
 <DM5PR1301MB21725BE79994CD548CEA0CC4E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <DM5PR1301MB2172ED85399FCC4B89F70792E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <a899b3b5-c30b-2b91-be6a-24ec596bc786@mojatatu.com>
 <DM5PR1301MB2172F332AED4A4940C2ECAF8E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <8fd369db-9256-633b-1b83-2d2684147636@mojatatu.com>
In-Reply-To: <8fd369db-9256-633b-1b83-2d2684147636@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3559e966-2915-4902-885a-08d9afad6345
x-ms-traffictypediagnostic: DM6PR13MB4316:
x-microsoft-antispam-prvs: <DM6PR13MB4316EE5F296283859D60FA23E7629@DM6PR13MB4316.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iCbriQubGO3IE5a/Knq9FLQ2yT66oqDom4TVw+sWVQuQfB+Jkz8pXuddSe4qMDslidGjRhIP/OCyHfeNimAWjU9b1HrViV0z35lU/VXimHS7YrKSorJfPqR3RxEeEQhzRsD8arS28cRyItK2lJJpmsxUkOEwYQTQSAfNfb5vzGLX1Xfo4GkixsZ1HoQsdrBzBdD1kVgF6M5bNqViIT85QslG33KCkp6M9RBaFUb6W8gTTr3OH3FVhQ9LYnnHj+xOcDgbYYgWZ0DaewR0k2lGki+RJ/+yHahUxQqEE4cVPn+/SoDLUKQi+MSXCom9GbmkjdJhSEQnnwildhJFkTODp4RSxAGXEdtzrfqAlXnDLDN9ozSSDj9dPV/48eP5SUGUQErKubQdIW8OpM4OjJRhRqwj3PabN7wzD0vtj6Ep/juFum15BN9BpGMj1LN769ioDM8frJGaANTYNllYyaBMT76zUczuUUvmsi9jfPpIQoa7zaxwk5X0XUZ22EQ8GwlenwzmeuAhvFdYctaT8UjO/D3PC7lRfD2Mwmtq1oRhpHb8fOcvmxeGoVuZlbcQQoHa9xHwdiF4vFewmxZmnUL06+3XVkRDYUEBLGMtQh/Q5JFXl0OAJ224Od26emt7YsAvhjVJVRLMS4+B0XtDpzmFSt9imd3cuZKUNVH6QJzRSchA5rIeZkGfIyYEMCimdeI2THR8TeuQOOB9aS/K++RElE6wBx9BzE4vm/ce/bvZeB/lQiIMSzg7QB3UFNw864dV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(39830400003)(366004)(64756008)(66556008)(66446008)(66476007)(71200400001)(54906003)(4001150100001)(76116006)(122000001)(26005)(86362001)(9686003)(66946007)(52536014)(8676002)(5660300002)(38100700002)(316002)(110136005)(53546011)(6506007)(55016003)(186003)(38070700005)(107886003)(2906002)(508600001)(7696005)(33656002)(44832011)(8936002)(83380400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?all3Zk84cmZ2dzJsRHg5RXl0TnJZY0c2N0dXZ1o5NytOK2RaYkJJRXdmdFEr?=
 =?utf-8?B?Rm9lUjR0T3NJbndYbCtFWGYvRndVcU9ldzIzUWlhcUl5SW5jekRWVUJtdFNi?=
 =?utf-8?B?R245NzhkUTU2LzJTdCtROWpCNXFGQ3pzMHhNMWdENUZrY3FsTU1uTGVYUlM0?=
 =?utf-8?B?SWZtRjNxdm4zZ24rd0U4bElXd3dqdEcxOHNjWFcvazJScWd5WkR5RjhGanhO?=
 =?utf-8?B?N0FZcDRVdFduTDBhRUo4b0pTZzRCVU9ObWN5blc0UktBcUVOcWtLMGFRTnZF?=
 =?utf-8?B?RVJmS2RLalU1ZDBrUUVCQTNwSDlxekpEQXZFcldjM1U2TGRVRTl1aVNNUi9t?=
 =?utf-8?B?eDl4bFQwOGY3TUcyVWFzeHdYY0sycHljUTJxMEhwRkllUGFhdVZhQ2ZVaGRN?=
 =?utf-8?B?YUVCYjB1dnREQnFFcyttMW0yTXR4ckFCZWVtTmdQVHd3L0VFU01VSWFrVjJD?=
 =?utf-8?B?eUJWTkRRV1h1VnBjZm9pTXFYMDRMQjZkeW1TRjIzMU1NelFmaEJlVFA4dlRJ?=
 =?utf-8?B?ZHFpcHNJOTNUM2dkNzJSVXh2aklxWEhaNnN5bVRVNncvRWlXWDZudXZHcmt3?=
 =?utf-8?B?aWZiQWhnVExJT0JIWlljS1VvSm9vQUxNbFVFS3ZpTlg1ZTBIcWtQTnFTb3pS?=
 =?utf-8?B?OGFiQlIvcDlwc25DZTl4V2hTdmVMQW90MUw0MXRGUkdlbTgwVUEyTUVqbDBQ?=
 =?utf-8?B?QStKTExjZWd6Tk1HYnBsM3IvRXhhYWlOdExld0k3Vm16UXUxa0tyaFlnVmFK?=
 =?utf-8?B?STYwSzN5M3VPaHJPdk0rVWxTSjVtbGhKclVuZzgyR0lqZTRQQ29ndUJDNlpu?=
 =?utf-8?B?WTVIRklKZHY3MlpLdUhGZll0b0NMZE91SkJ1djJUNDVwOWVYalpjQUtRYjhW?=
 =?utf-8?B?OUpxblM4WEorSmhobXI3Zld0bTZWYi9PVU45Sy9SOWNsSFlqeUtjTTJ4eTRF?=
 =?utf-8?B?T1B6QjJxbXlqK3k3cDFLV25Oa01pbTM0cUZmTFJHTnRwQnh2VWxTNHAvRENt?=
 =?utf-8?B?bmp0NW81TEdZMHo1cDBIcG5PcDZLNTdOWmNlSWlnTWUxdS9ZdW85VENPb1Y4?=
 =?utf-8?B?enF4T0VQaGNjUzNJaGpYc3hrSHd1dG4vOXlIL0k1Uk85VTlYbElDZVZ4Y1U3?=
 =?utf-8?B?WVAxSmtJcEw5L3pjZFd5RVIybHRTdjIydWljVzhGeTJaYWNtSnVLeThBbWs5?=
 =?utf-8?B?NENzaks1TzhwZFJzTC9KUmkzRlBwL1ZoRnp5SDBFYVNTTUNMd1ZXVk53SjlY?=
 =?utf-8?B?SGVtUFcwZlc0amsrVnl5Q3o1WEtSMWd4dm5qcVdrRjRHSW9ueDVmTXFyVVFF?=
 =?utf-8?B?dTZZWEpLY1ZFNzhqTlpMcFd5SFlES2o1cW55dTBxaTVQMVJWeGc5S0dad3BU?=
 =?utf-8?B?VHloRnRyTVNrenFuOTY2RlZubzByMGNNR1JyQlVwU2NPK25sbUhzNVZ5K3FL?=
 =?utf-8?B?SHovM1dPU2FEbmEzV2k0MUFpYUprRTB6ZkJOWjFITzFSMTJIblRBaStML2sy?=
 =?utf-8?B?ck1kMGR3YnNnU3d2aEJra3RzR3dIQk5URURLSW1HVWx2elVFVFpUYU1oM2ln?=
 =?utf-8?B?aVRPdGtzeW9DMzQxTHp5Y0ZKQmRHUUNwaHF0Qmx0T1VOd2pMN3hoQVpnWFgz?=
 =?utf-8?B?ckZqb1dBWjhWL2gzS1MzbFVQY3hUUTZlVkFTUzd6aVNNSWJOQ1ZHMkJ5WHls?=
 =?utf-8?B?c1o0dGxib2ErelN3Y3dBWlNUUjU4RCtrZHdwbmlhUVZFWVFtUVZWZlZVTk56?=
 =?utf-8?B?Z2h1WFRmMTN2bmVVc3lKOWNjWk5jenJZQ0lGaVJiTDZmV3JUYlh1b2xsNEpk?=
 =?utf-8?B?SzAzM0tXY1dHMnhoZnZCWWYybTVFbVVsWGJ5aFdBVFdLWTVYejYrTTdrOUhk?=
 =?utf-8?B?WjdTK3BjdXQzRzNMR1VsZG9hQUl1bEEycFlzUXRLLzdKdjVMS0MySU55U2Y2?=
 =?utf-8?B?eTkyNU9RVVhPRERnY3pKOTltOFpsSVYyM1RjNGlKZUhEbGJ1NkhlcE1jc0Rq?=
 =?utf-8?B?R09JS29Bbk9QbndtTWZqZVZyQkV2dGhsdUUwOFY5bGUyOHZKN0hlaGFOM3l6?=
 =?utf-8?B?VFlwT0JGWkEyc3E2L05nVTgveUxQOTA5T3VyOVUwa1Nna2RIT1pzR3A0QXA3?=
 =?utf-8?B?UHZEZzJQVjN5VW1aYldwamp1Vjg5UDFFd1paQzRtVTNyWnZPQ0lNcXBZZDRC?=
 =?utf-8?B?d2Q3cCtoWGI3cFkzMU8wcFZXaGZXN1IwSXp5VmdSd1daVUZvMkEyZlJtN0Vx?=
 =?utf-8?B?Zlp1M2tIQmtEK2RGQzFoL2pZWlRBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3559e966-2915-4902-885a-08d9afad6345
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 00:49:07.7820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dl3XrwoJrQg6XOlKHvvLCC/O3JXe1qYFeIunJYl030UC+7HYVLXyI/054KmpvvYBYp41WBcnSC3SD4yhmgX8ZvINKvAeghJ1eNmWHeLpYz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4316
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgMjQsIDIwMjEgMTA6NTkgUE0sIEphbWFsIEhhZGkgU2FsaW0gd3JvdGU6DQo+
T24gMjAyMS0xMS0yNCAwODo0NywgQmFvd2VuIFpoZW5nIHdyb3RlOg0KPj4gT24gTm92ZW1iZXIg
MjQsIDIwMjEgNzo0MCBQTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj4+PiBPbiAyMDIxLTEx
LTIzIDIxOjU5LCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+Pj4+IFNvcnJ5IGZvciByZXBseSB0aGlz
IG1lc3NhZ2UgYWdhaW4uDQo+Pj4+IE9uIE5vdmVtYmVyIDI0LCAyMDIxIDEwOjExIEFNLCBCYW93
ZW4gWmhlbmcgd3JvdGU6DQo+Pj4+PiBPbiBOb3ZlbWJlciAyNCwgMjAyMSAzOjA0IEFNLCBKYW1h
bCBIYWRpIFNhbGltIHdyb3RlOg0KPj4+DQo+Pj4gWy4uXQ0KPj4+DQo+Pj4+Pj4NCj4+Pj4+PiBC
VFc6IHNob3VsZG50IGV4dGFjayBiZSB1c2VkIGhlcmUgaW5zdGVhZCBvZiByZXR1cm5pbmcganVz
dCAtRUlOVkFMPw0KPj4+Pj4+IEkgZGlkbnQgc3RhcmUgbG9uZyBlbm91Z2ggYnV0IGl0IHNlZW1z
IGV4dGFjayBpcyBub3QgcGFzc2VkIHdoZW4NCj4+Pj4+PiBkZWxldGluZyBmcm9tIGhhcmR3YXJl
PyBJIHNhdyBhIE5VTEwgYmVpbmcgcGFzc2VkIGluIG9uZSBvZiB0aGUNCj5wYXRjaGVzLg0KPj4+
PiBNYXliZSBJIG1pc3VuZGVyc3RhbmQgd2hhdCB5b3UgbWVhbiBwcmV2aW91c2x5LCB3aGVuIEkg
bG9vayB0aHJvdWdoDQo+Pj4+IHRoZSBpbXBsZW1lbnQgaW4gZmxvd19hY3Rpb25faW5pdCwgSSBk
aWQgbm90IGZvdW5kIHdlIHVzZSB0aGUgZXh0YWNrDQo+Pj4+IHRvDQo+Pj4gbWFrZSBhIGxvZyBi
ZWZvcmUgcmV0dXJuIC1FSU5WQUwuDQo+Pj4+IFNvIGNvdWxkIHlvdSBwbGVhc2UgZmlndXJlIGl0
IG91dD8gTWF5YmUgSSBtaXNzIHNvbWV0aGluZyBvcg0KPj4+PiBtaXN1bmRlcnN0YW5kDQo+Pj4g
YWdhaW4uDQo+Pj4NCj4+PiBJIG1lYW4gdGhlcmUgYXJlIG1heWJlIDEtMiBwbGFjZXMgd2hlcmUg
eW91IGNhbGxlZCB0aGF0IGZ1bmN0aW9uDQo+Pj4gZmxvd19hY3Rpb25faW5pdCgpIHdpdGggZXh0
YWNrIGJlaW5nIE5VTEwgYnV0IHRoZSBvdGhlcnMgd2l0aCBsZWdpdGltYXRlDQo+ZXh0YWNrLg0K
Pj4+IEkgcG9pbnRlZCB0byBvZmZsb2FkIGRlbGV0ZSBhcyBhbiBleGFtcGxlLiBUaGlzIG1heSBo
YXZlIGV4aXN0ZWQNCj4+PiBiZWZvcmUgeW91ciBjaGFuZ2VzIChidXQgaXQgaXMgaGFyZCB0byB0
ZWxsIGZyb20ganVzdCBleWViYWxsaW5nDQo+Pj4gcGF0Y2hlcyk7IHJlZ2FyZGxlc3MgaXQgaXMg
YSBwcm9ibGVtIGZvciBkZWJ1Z2dpbmcgaW5jYXNlIHNvbWUgZGVsZXRlDQo+b2ZmbG9hZCBmYWls
cywgbm8/DQo+PiBZZXMsIHlvdSBhcmUgcmlnaHQsIGZvciB0aGUgbW9zdCBvZiB0aGUgZGVsZXRl
IHNjZW5hcmlvLCB0aGUgZXh0YWNrIGlzDQo+PiBOVUxMIHNpbmNlIFRoZSBvcmlnaW5hbCBpbXBs
ZW1lbnQgdG8gZGVsZXRlIHRoZSBhY3Rpb24gZG9lcyBub3QNCj4+IGluY2x1ZGUgYW4gZXh0YWNr
LCBzbyB3ZSB3aWxsIFVzZSBleHRhY2sgd2hlbiBpdCBpcyBhdmFpbGFibGUuDQo+DQo+WW91IG1h
eSBoYXZlIHRvIGdvIGRlZXBlciBpbiB0aGUgY29kZSBmb3IgdGhpcyB0byB3b3JrLiBJIHRoaW5r
IGlmIGl0IGlzIHRyaWNreSB0bw0KPmRvIGNvbnNpZGVyIGRvaW5nIGl0IGFzIGEgZm9sbG93dXAg
cGF0Y2guDQo+DQo+Pj4NCj4+PiBCVFc6DQo+Pj4gbm93IHRoYXQgaSBhbSBsb29raW5nIGF0IHRo
ZSBwYXRjaGVzIGFnYWluIC0gc21hbGwgZGV0YWlsczoNCj4+PiBzdHJ1Y3QgZmxvd19vZmZsb2Fk
X2FjdGlvbiBpcyBzb21ldGltZXMgaW5pdGlhbGl6ZWQgYW5kIHNvbWV0aW1lcyBub3QNCj4+PiAo
YW5kIHNvbWV0aW1lcyBhbGxvY2F0ZWQgYW5kIHNvbWV0aW1lcyBvZmYgdGhlIHN0YWNrKS4gTWF5
YmUgdG8gYmUNCj4+PiBjb25zaXN0ZW50IHBpY2sgb25lIHN0eWxlIGFuZCBzdGljayB3aXRoIGl0
Lg0KPj4gRm9yIHRoaXMgaW1wbGVtZW50LCBpdCBpcyBiZWNhdXNlIGZvciB0aGUgYWN0aW9uIG9m
ZmxvYWQgcHJvY2Vzcywgd2UNCj4+IG5lZWQgaXRlbXMgb2YgZmxvd19hY3Rpb25fZW50cnkgaW4g
dGhlIGZsb3dfb2ZmbG9hZF9hY3Rpb24sIHRoZW4gdGhlDQo+PiBzaXplIG9mIGZsb3dfb2ZmbG9h
ZF9hY3Rpb24gaXMgZGVwZW5kZW50IG9uIHRoZSBhY3Rpb24gdG8gYmUNCj4+IG9mZmxvYWRlZC4g
QnV0IGZvciBkZWxldGUgY2FzZSwgd2UganVzdCBuZWVkIGEgcHVyZQ0KPj4gZmxvd19vZmZsb2Fk
X2FjdGlvbiwgc28gd2UgdGFrZSBpdCBpbiBzdGFjay4gIFlvdSBjYW4gcmVmZXIgdG8gdGhlIGlt
cGxlbWVudA0KPmluIGNsc19mbG93ZXIsIGl0IGlzIHNpbWlsYXIgd2l0aCBvdXIgY2FzZS4NCj4+
IERvIHlvdSB0aGluayBpZiBpdCBtYWtlIHNlbnNlIHRvIHVzPw0KPg0KPkkgdGhpbmsgaXQgZG9l
cy4gTGV0IG1lIHNlZSBpZiBpIGNhbiBleHBsYWluIGl0IGluIG15IHdvcmRzOg0KPkZvciBkZWxl
dGUgeW91IGRvbnQgaGF2ZSBhbnkgYXR0cmlidXRlcyB0byBwYXNzIGJ1dCBmb3IgY3JlYXRlIHlv
dSBuZWVkIHRvDQo+cGFzcyBhdHRyaWJ1dGVzIHdoaWNoIG1heSBiZSB2YXJpYWJsZSBzaXplZCBk
ZXBlbmRpbmcgb24gdGhlIGFjdGlvbi4NCj5BbmQgZm9yIHRoYXQgcmVhc29uIGZvciBjcmVhdGUg
eW91IG5lZWQgdG8gYWxsb2NhdGUgKGJ1dCBmb3IgZGVsZXRlIHlvdSBjYW4gdXNlDQo+YSB2YXJp
YWJsZSBvbiB0aGUgc3RhY2spLg0KPklmIHllcywgdGhlbiBhdCBsZWFzdCBtYWtlIHN1cmUgeW91
IGFyZSBjb25zaXN0ZW50IG9uIHRoZSBzdGFjayB2YWx1ZXM7IEkgdGhpbmsgaQ0KPnNhdyBzb21l
IGNhc2VzIHlvdSBpbml0aWFsaXplIGFuZCBpbiBzb21lIHlvdSBkaWRudC4NCkZvciB0aGUgaW5p
dGlhbGl6YXRpb24sIFZhbGQgbWVudGlvbmVkIHRoaXMgaW4gYW5vdGhlciBtZXNzYWdlLCB3ZSB3
aWxsIGFkZCB0aGUNCkluaXRpYWxpemF0aW9uIGluIGFjdGlvbiBkZWxldGUsIHRoYW5rcy4NCj5j
aGVlcnMsDQo+amFtYWwNCg==
