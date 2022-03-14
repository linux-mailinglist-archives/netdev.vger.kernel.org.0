Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6464D877D
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbiCNOz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbiCNOzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:55:25 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6FE42ED8
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:54:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJHIjFQ499onSjCCSRHAURXZFFzLOFaHY+Zt6ISO6M8uZki3E4ZI7zQgiMDkIaNTswNRDnJJDv+RnQxMqZAS0pz+0AgXDcyza1ayDq8d2Rtq87AEManVoH2XFfRA3d0jHd3jMSAOt6p33EWiwOD8VCLKGuB2KkVYfV4gUG660Z5RG1CBflgp7OqcI5S/Of7+XS7ccLS5q7Mo+ckC/aHJikmPm1YAZOI8qhrpbm8wUU7x8ncFTmrbmeQlX2aeuhEtQUhdBDo6izjivSiu2eN+RiCm5rHjWKyTYdV70zItqcO4L/hb1iUr7j88hvyXsu2Lak19+P8R2MzRwk4orUTojQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3xmF0ZUwzoDvHdR1YbdcbhzmarqyDoKCRGE+kTCJuk=;
 b=h1jLVDUObI/CJpsdZoNCqAdMF0Vp1LxgFMF17+WUsqTv7rIF4NcIHtxqYelwHdssONGS0m3CcT1fbE0Fs/BTYQuehKnmRIZ1wV5EQfdBSL9Q2QVXlTXv4is/ffLZVL+r43tCE61ugxG4a1hEnrogoGXgEIL+PfjLo8Kg6gZsSkR/0vWdvZpUrCMapQiDt8rxiiuJBvR8UL7ynGszuoYJakcyI4bziaLhL5TY2LqQ9dQv9U2fr6Wr285reYPDcuBxohA5tEKlpWGig5wxYX2Zoxu8C/GmgPVjYyPYh8wy6x86CUNHAyNGkPjwkokpuAoSEB4EqA8uHknBuBelvOstPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3xmF0ZUwzoDvHdR1YbdcbhzmarqyDoKCRGE+kTCJuk=;
 b=NuvbNp/JaylLXExqccU/3rpGlS6u5XAqI56FPu0aqGKE2q7H91F6m/nwHCqHLBQlbFH+vU19pbd3xWFVL2hiUiIxA6M61qNlxGoHP6DMVSv2AsUDaaUPuPIdrqjC840m9uEuU/rHSDd3YPHyGp4nzdHjnxeRpPVgqoCYh6kE/62P0tv+89bm444FwVhlvcb9OTH2oHx8/cN0p+fgRUky5P6yKlEDEg0Z/KhgvSoBmlKz/oVYsCeQ7qIH8bjcptnlRjM+S1NCoIlPCTm8ZKbu7nFMaqJp4PmbMVtvglFQ5d5HZHy5GBGKi7CWmvA1n1od2XskIAloPC5mSQatRb4Hjg==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.22; Mon, 14 Mar 2022 14:54:13 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627%6]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 14:54:13 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Subject: RE: [PATCH v7 2/4] vdpa: Allow for printing negotiated features of a
 device
Thread-Topic: [PATCH v7 2/4] vdpa: Allow for printing negotiated features of a
 device
Thread-Index: AQHYNv2IELmBUhoXUkSx7mD3Z/gSXKy9kwwAgAAIGFCAAVz4AIAAAINw
Date:   Mon, 14 Mar 2022 14:54:13 +0000
Message-ID: <DM8PR12MB540047F312D5AFF590192882AB0F9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220313171219.305089-1-elic@nvidia.com>
 <20220313171219.305089-3-elic@nvidia.com>
 <20220313103356.2df9ac45@hermes.local>
 <DM8PR12MB540017F40D7FB0DA12F7AB8DAB0E9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <a9e95f95-6ae7-518a-329b-3195e25a15e8@kernel.org>
In-Reply-To: <a9e95f95-6ae7-518a-329b-3195e25a15e8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1645e263-52a4-404c-7fca-08da05ca816a
x-ms-traffictypediagnostic: BL1PR12MB5380:EE_
x-microsoft-antispam-prvs: <BL1PR12MB5380B64E3A22DBD20F13EAD4AB0F9@BL1PR12MB5380.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k4d7rxHw4xg2sfquj+8CPm/9NbLbrX5N5+G8bdIFRpLdHhYoCj1IuYmB4RyIOCBOK3JjeF+pGAltVSNoUcTMZwCLtWG1eKXufvM5IMt8WN6cgwz4/rpOZlwSfK+8Q0KkPuhYTQOWIYYtgsEb17Ws4HV/LqCIH8vdE1C6RfIp/dmX0aKYMLZ3+uuWjhsZ1S87Rh7qwJ5WFJbXTJOPavpxqgBDlkE1VlBOORV83rlBbdpUgptZ8oi3HFoATX88b4xY185v6+vu1LeHRDJNLNeHkKRQS0GnjcKnpQNfJGg+WRgpPTgbBu4CKRsPGxRWLoqz+EK/B504q0LhZeZCAyc1fJL6xCWqFMNtY+Q1FB2FDzC1KNxqvaI9tHHlTL6G9w8BQgV9CmPe+z1pwm/hqQbWTBIFfmwD9rdI6MoFDzfTtrHhD6YY0FKr+c5JCrdlJb/GlS1HV9DSxAADBGTcdW8eE8/kqyE6H7jKhPJAoPv8VnFaQk5RjBbKUYrZ+XB7n5S/IWurqpJR0JHJLw3nox8CAYs003Tc8zWxVPYVOyUE4MRAX9OyMwf+wPoC40rc8gSj34CILU/q4yGEgFv4Z1DkUjdybqF+Jbmt7AyBelumtyaBH18/kKRGMyNu1YVyoJubn9jXs+1CcOuHHbPFtrsDlZ7qQRFixUN2r7yYLjDaPTfM8iCZ+EZttLknbLME0DZaLAW+BKPkpDoza6u5JQ/OcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(52536014)(86362001)(5660300002)(8936002)(33656002)(508600001)(9686003)(4744005)(6506007)(7696005)(53546011)(2906002)(55016003)(122000001)(38100700002)(26005)(186003)(110136005)(38070700005)(64756008)(66476007)(66946007)(66446008)(66556008)(4326008)(54906003)(8676002)(316002)(71200400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZCtsRzRkN1J1bTZ6YzUzL1pLTXpmUWZ4ZjBUS2hGZitwNk5jbFRwMXE5OEhN?=
 =?utf-8?B?dDdsekxTMGRWM1pINWo0TldBVEt1U2piMmVXZjh4c0NTVXpkeGl5TWxiQkR1?=
 =?utf-8?B?WUFld0lnbmdXT0pacVZhUUhXRUMyNi8zcy9RQy9LY1lxbDY4cjJhVlJnMG1Q?=
 =?utf-8?B?NVJKVm5mNlNHMUFmc2FJdW5QdHo0bG9lKzBnczJZRmpRMzZmTFhDbG5ocklt?=
 =?utf-8?B?dHVZaHZoRFlyUjFlYUFiY2tWTUxMVHRXeUtTaC9BNEtBSTdHaDFzNXdqK0gr?=
 =?utf-8?B?cE9ZV1oyTWVFdGt5K090bVZzLzZYRW1BTjFLS3FBRUcxam5qM0xNaW5uUmta?=
 =?utf-8?B?a2NxOXBncks1eUY0SDFyRitLdmJ5NCtKaUtQWkduaVNncFMyTVhPNUdKaWsv?=
 =?utf-8?B?Wkl1SUtFWFZOc1Y2T3pnTjJIbHROMDIvOC83amlHZmpSb2RuME5XSDI2eHB5?=
 =?utf-8?B?VWRETmpJSEtsMnh2SzVKTVJpTnE4NnU3OTNmRkRUWjFZTExrc3JyN1ZmTVkr?=
 =?utf-8?B?VXpkYzB2UVVpb21jV0U0cU80UUdYK0hhbUxBbldOMjl5WXdLelVZNzRPRWJo?=
 =?utf-8?B?dnZCS1pDV2s1SFIrWGxBSlVFSzRaTFFkZnNpVHdJanJ1LzIrd1NzczE3VjFW?=
 =?utf-8?B?WlBDbFkrcTkrMWkzRDRWbjNrUU5YbERsYzBXeGZHMXlYT0ZDL2UzckUrV0wy?=
 =?utf-8?B?cTZKdVlBV0lEaElqWDlVVDB4QmlFZ1FTQTQ2bHA4UHFkU050T0NXWkpsa3k3?=
 =?utf-8?B?a3lLVHFMNjljMVZ6MHFOSHZMUkpWUUJ2OVNJdTVtNXR6WXZLdFVaQ243UFJo?=
 =?utf-8?B?VEpqRGZqYXFBQ3B5Q3BpQjhsN3ZtWnRLWGtxNFdPS2YvMk9IOThJNzNIb3Uz?=
 =?utf-8?B?dHl4R3hFRno0U3JxSlhMMTluclNjZFNFazNVLzNZdGNoU3RvNGxsT1JzK1RQ?=
 =?utf-8?B?Q0xXSEFNZlF5REU4WjU4Vm5JUTlud1krbkttNTRaaWIzdmI5R1hCd09LTEVp?=
 =?utf-8?B?RUI4eWFwSnlzd2l5Zk5CYTFLbGJmeDIrdDhnZ0JMREpsN3h1UmJyODZua1o3?=
 =?utf-8?B?M1JJRkZUbEtpTEh1OXpnb200bDNuVWdiSzlUWE5zZThKTHd5Q1l5QVBwOHJ1?=
 =?utf-8?B?NFdHRjVZRTlWclRnMGtHYTQxajBBVzQrbHZaUW12NFJMaUUwb3o1ZnNQdlBY?=
 =?utf-8?B?bzNYSEcyTitJZFRmQkVQNzBBc3dzZElWRS9jdUQxeGxhTzN0cDFQMW1ic0dj?=
 =?utf-8?B?NUI5aEdXZTZXb09BRk1oTlZQaDFFR2F0TGJBUUYwaFp5UE4va3IzRnpWSWZx?=
 =?utf-8?B?ZnRQa01Jd3B2eE5Vc2FCL1NGVWxySG5peWErZzFPKy95d0ZUcGVYOCsycDhB?=
 =?utf-8?B?YTNvOUVGZ09BQ0pPMi8xY0dkMjFTSm9LRm9lbmtFT0lTeVp4eVU4am9WSkRy?=
 =?utf-8?B?UDcvYWxrUFBlZ2l3ZzRJT2E4bDRhWE05azBRcnZDNkFWS1RCNm1xdGVmV3Jv?=
 =?utf-8?B?MXBxeC9EYW9aNWdpSm9SYXdjZ1dwTFNCaXU5OFduMWZTRnlyaFZJcDVpU2VN?=
 =?utf-8?B?N0dxUXYvcGhkejF0RHViVTlJenJaRjhOZnRtNzc2UTF0V3dueENuSCswRENa?=
 =?utf-8?B?N0JScGpYOWxzcTRmeDZNd1FVd1o0SVdRYkM3S0lXcTFNc1VRSHpaVU5KOTNp?=
 =?utf-8?B?dmVYMmJYWmQzWFQzWGlGcCthRWdrMERJMlU0TDU1bzA3Uzlob0tqbzJsaTho?=
 =?utf-8?B?dFBMWkdLbjhFNmlHTVpEOEVTRWJDcWNyOWdlUVFZa1F6cGFIanZhUjVKQ2Nx?=
 =?utf-8?B?NjdJVmtKQ0YzVUlhOUlzaWpvVjJmTmFqdkRKajZmaUs0a2tqalZkUmtsMTlK?=
 =?utf-8?B?aTRWVG5BeGlFRklsaTBaTUZpeWRWTDhURUZIL0xOeUZXTFdDVEsvai9CNmtB?=
 =?utf-8?Q?RQiO14dPVSo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1645e263-52a4-404c-7fca-08da05ca816a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 14:54:13.8026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sMaF5bCv+cotnFSlC+7DARLROwwgfm8t3WT/hBRR79dr/aE8pzxCqMRQzyG+SD6c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT24gMy8xMy8yMiAxMjowNCBQTSwgRWxpIENvaGVuIHdyb3RlOg0KPiA+Pg0KPiA+PiBP
biBTdW4sIDEzIE1hciAyMDIyIDE5OjEyOjE3ICswMjAwDQo+ID4+IEVsaSBDb2hlbiA8ZWxpY0Bu
dmlkaWEuY29tPiB3cm90ZToNCj4gPj4NCj4gPj4+ICsJCQlpZiAoZmVhdHVyZV9zdHJzKQ0KPiA+
Pj4gKwkJCQlzID0gZmVhdHVyZV9zdHJzW2ldOw0KPiA+Pj4gKwkJCWVsc2UNCj4gPj4+ICsJCQkJ
cyA9IE5VTEw7DQo+ID4+DQo+ID4+IFlvdSByZWFsbHkgZG9uJ3QgbGlrZSB0cmlncmFwaHM/DQo+
ID4+IAkJCXMgPSBmZWF0dXJlX3N0cnMgPyBmZWF0dXJlX3N0cnNbaV0gOiBOVUxMOw0KPiA+PiBp
cyBtb3JlIGNvbXBhY3QNCj4gPg0KPiA+IElmIHlvdSBpbnNpc3QgSSB3aWxsIHNlbmQgYW5vdGhl
ciB2ZXJzaW9uLg0KPiA+IExldCBtZSBrbm93Lg0KPiANCj4gSSdsbCBjaGFuZ2UgaXQgYmVmb3Jl
IGFwcGx5aW5nDQoNCkNvb2wsIHRoYW5rcy4NCg==
