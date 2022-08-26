Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA77D5A2E85
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbiHZSdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiHZSdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:33:08 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2065.outbound.protection.outlook.com [40.107.100.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4607E2C57
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 11:33:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buU4V1tKVXy/aI8SMg8ArI0BnF5myarCH6ryz56+98g02PbfPZlL0u/UHCYViAA9iprWvUKWieRBiCmbSMc6yEBVHQ7F45e9xwqbw8ILfXTCGArRmui7GWf8v0TBtZUM5kR8Eh7kt4IqwQSpIqZl/bw6/16NjnQtctKk+Ouy7RlI71fNflKqq93LYWZCSbOo00Bvghls+PHtVVxkueFhE31bWebOffESPrtMIYFAb4QNxHRYeG68+m3wrNNt7akVDXvrdhx4elDeMf/Mu+tv/Ixi3o7n7uNhl4Gp8N/Lma+mLIxheOLKEhH7ZeK0P8SgF6tl01qEy1QtrJkCHjxaOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qsyzI9LRjLGgI+0Tw11B19ZLh/Eu03wz2p7oj+R+G0=;
 b=f5j84NUXCL01t2Fi8e1iVjKlXXD6qnWdZS75zKUWfZEmVyt2Su0xScC2pOvBl904JU8d3PjTzIe3UPlAyqY08nQe2Vd4+HOrz6QQbiHOmeBPnx+xotsCMPQvbbwYD2CzKcL8Q+W+mDmqrcRTc0nB2F7ju4/mncUdv8ekJqxeAGHtUhX7CQ4C7KBF7zzsgZq3LXqNuC8Xm6OIUFGzdhhyjdsnQ8cmV7uLE2TUOj+nQXRxhR8+CR4iWBuUEg1M/6gBOoE2bsNcGWw+3BA8jpbi9Q9kPO634uLUYqcOgZFlalzp7eLFLgnqbfcWkvOUVb79OnlhdqqBWcLjxTeJXZoVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qsyzI9LRjLGgI+0Tw11B19ZLh/Eu03wz2p7oj+R+G0=;
 b=kYVxw7W/5Jor9iuty95HEtZuQ/MyaK5azgerQIijBALJqUePJH/hMl/44BrDm/KXh0v+YwpOy8FsEMKPIgUE5LBawrqmDDMsoxnzDLqsJuq72ORiWiPgkoFZhi3IcxSThlZCdc0JC5GtOtjOJlS6qcUrWUDJk4BXJyVVNeMBw3kQpTFg+RM0d5IhCUkS30WVR+bVYNQvq+2RqctkerUSJx+mG/MK3mdPbmwo7CBJy04K654yf7v41BQp72iV60N5J0LxDt+mGfBBxhnXF2a4f8mk7nrVMZbK1dFecrGjt3h2oQLu/pgE8Hg55yfEtpAKr1gXNBCypXvswKNNEKsWRw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH7PR12MB6417.namprd12.prod.outlook.com (2603:10b6:510:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Fri, 26 Aug
 2022 18:33:04 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%7]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 18:33:04 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>, Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "mst@redhat.com" <mst@redhat.com>
CC:     Gavi Teitz <gavi@nvidia.com>
Subject: RE: [virtio-dev] [PATCH RESEND v2 2/2] virtio-net: use mtu size as
 buffer length for big packets
Thread-Topic: [virtio-dev] [PATCH RESEND v2 2/2] virtio-net: use mtu size as
 buffer length for big packets
Thread-Index: AQHYuH+wBUa5TQ3am0iRtxWTyhCUA63A4UyAgACAwLCAABm2gIAABtGw
Date:   Fri, 26 Aug 2022 18:33:04 +0000
Message-ID: <PH0PR12MB54817615D702376C33188518DC759@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220825123840.20239-1-gavinl@nvidia.com>
 <20220825123840.20239-3-gavinl@nvidia.com>
 <27204c1c-1767-c968-0481-c052370875d8@oracle.com>
 <PH0PR12MB5481BB5F85A7115A07FBC315DC759@PH0PR12MB5481.namprd12.prod.outlook.com>
 <784140bb-53d1-e00b-f79a-7b95b0c1052f@oracle.com>
In-Reply-To: <784140bb-53d1-e00b-f79a-7b95b0c1052f@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ce21730-5f1a-46c3-3bb5-08da87916a31
x-ms-traffictypediagnostic: PH7PR12MB6417:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RjWZgvpenEJ8uDBxr7YrGOpMUjOGCcqb/YNTX23DaVwMfVa/k+uk1f0ejVfTxWGkA2z01S5dEkrEqPLB1Vl+Y9HArlSjx8O3SykyTxY26+kFxALvcQJbxfZ+ZFagFtFh/bnc1AiCVzkDZegrL5Whugr6HujZUuYl6Qm0eFqh5Ej3gzfgjTjLoPFyE6DunHUlXXwoBq34cFvUrKPCz8aQuCFgH2vNKPooLVuJUfMS2WGf8WJMrLMOUF+Vy9lZ2F4WJOs/RdCxapP8ddAMzrkOf45bCGa5XeMGLuVeV6SlcMnB9f25w0Mh+lbNPL5p3ClFClbJ2VYFVwBokuQQdRu8WpqRt7t1rPckiOAGuJEftaE/TAJpWUKMHsLe2AGr1VUuV+TDnMQmBvolwYmC8qwz/PpKeusOhUk8GpcUSpc8+ypoKKCzIf/wBmtxmwklDtrsy34L5Ct+12gTSZd/bT/8ghtCTwr+yeOngy2k16bg5VdpwiugsTjIdmaU8YPJNa51HZTQ8p4AsFHVZac+stvHCtJ7geRcXzwnS7af1blZDALStjr2IV2TtBNwz19H+1Sgf0OsCQNDpBG4rcP6vLW0Hk1PlWnBtBsOd+7lCO5ooDd/km4a5++czNUVqFvVOdm4B8DXNh0CXhT/ylHf+n6zWDcuDVcoohpiGEqH3zYSvLKsBAPq2NmtCeeCJJxWSDByN3+d2AnjXdsiCVNQhG5D69KjbGk8GWuZbpRWIPHRBIJxGBO4CJqb8KKE09LdRfu9rmGrh293XDuhk91ewRPViNEs9RuzfOSlIdw3lhPzmm8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(38070700005)(9686003)(66476007)(122000001)(110136005)(66556008)(4326008)(66446008)(8676002)(5660300002)(76116006)(64756008)(66946007)(921005)(38100700002)(26005)(7416002)(41300700001)(7696005)(6506007)(478600001)(71200400001)(33656002)(86362001)(316002)(2906002)(107886003)(186003)(8936002)(55016003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDF6RVJyS25VWHZRdzZwc3lNeWt0OHZJdUN1YUZGZlZGWlRWU3Fwa0ZtdHdP?=
 =?utf-8?B?cjBXRUF1bk1ibk5XbUJ3NkZhNEhxT29hbHN2bUlWMjFXc3VHMTl3a1NSeTJm?=
 =?utf-8?B?OHpETW1ubUxseVhaaGhWTVZ6UG5ZaVVCVVhDZjVEa1hldDY3ZG9QWVRjOXU4?=
 =?utf-8?B?OGo1S3ZjQWRnUzRkSU1pYnFoVFJOVnFKd3dramEydEFwOFBqeXR5MTBrYnBP?=
 =?utf-8?B?cWxKWnh5SHNwN25VNVYrRy91azcwVGpDVHZhN2dPU3RBWllvS1hDeUVSamh2?=
 =?utf-8?B?VHJ6WG1PSCt0a3R5OGNoeGRBeDRJWEJDSCtIa3Z2TDVyZmxscFVhQXQvYlpl?=
 =?utf-8?B?ZzRmNGRUQTNRNGxVcTFxWVJ4VGNMc1E1NGEzTGpCTE5vU1d3YmZPdVpxOHY3?=
 =?utf-8?B?U2pxb1p0ZUN0M1N4Z0hIdVNneDRZckx0aWJ3MndHRno2czM0STF2U2VxNFgy?=
 =?utf-8?B?WEtxQTZNZWdVSU1ablNGTklzQ3V1UUYxYmRDVk5Bc0dNZnk1OGZiRUI3bGJt?=
 =?utf-8?B?SVF0VFJzVzRNbUVHSXhINlZuekRxRjJ6dXFROHRPRWsrbDRjV09NR0VXZTk5?=
 =?utf-8?B?R2tqYXFaYUpkZk4rd1hYWUdSRGZMaE0rdS9MeXJIblgvMFhla21uS1FXazBq?=
 =?utf-8?B?N3BTcmthY2xqR3ZGa0xNZUs2bEwrYnRVMWF4SnNrUzd3Y3RlRFUrZlJBSGtX?=
 =?utf-8?B?SVFCYVpHM0RIaHRqUnF4N3pidy9hdnk3amZQT0pMQjlKeUU4R1lOVVVWSWo2?=
 =?utf-8?B?bnhOKzB3cGZEaE54akNIcHVhTlN2d01MMVFYaHFLMEhVVnZsbHB3T3FYdHVM?=
 =?utf-8?B?QjN2cFFRMzF2U3lXdEQxV0lmYllrSVB4YW9lS2xKQ0RWTStoc2pIRUVkUExy?=
 =?utf-8?B?MFFoWlVLOVMrM0grKzFMeVEwRXVlSSs4TkdNenZYYVZFOGdmN0UydmlxZDdu?=
 =?utf-8?B?aWFJVUd0QmJTdnVYSWZlTlRuN1NaazMyVGhEYzY4YlVOVzErSXZ0RkM5VHJU?=
 =?utf-8?B?UjRkMURJRW8vU2xxRzVlT0RNS3RTSTBwblZOdUcwbUhCVEEzY2w1eGswQmRK?=
 =?utf-8?B?Q1NIUlYvcithNEhPZUlsNmVoNEhiSHdUY09SVVQyRzk0dXI5ZDN2Z3RIUEoy?=
 =?utf-8?B?ckVUdUFhTE16SFpRK0FrVEJ5TFE1ZWJEanF3WUhZejQyTmc2RThTY2RSL3R2?=
 =?utf-8?B?YkY2YlUyWmJJZ0dndTZnUlpqZ2lUMjlFVEdoZjBDeXR6ZHRWRWhvRkJ1OVhQ?=
 =?utf-8?B?czRJalB2RUtQS1loYnV0WE1BQ2dGSnplaHhoR3ZkUVYwZ2tDYWxTWW54VUI4?=
 =?utf-8?B?TGdBUlZGbkt0aWlJbmZkRHFnRis5c2t5OHFma1BpUXU2dE9pSG5oQUdvZ3ht?=
 =?utf-8?B?bm82bTJ5V2FEejRqa2pBTnlMOWZKZWlOVHpKVE5uOE5pNTI1eGFvcXhxYi95?=
 =?utf-8?B?YXRRUlVnQTVrNTJOSkdYdEdFQUE1dWtRR2FWeDZubW1SOWtpTGZYdktGOEJD?=
 =?utf-8?B?Z2tpSGlwamJBdENtcjBNNkh6UXlEVVB1MzhmUHRBNkUxUWp5eVZ5a1QwZnhH?=
 =?utf-8?B?S0MxRUF4UXUzOHB6K0ErVzVMK003RVROQlZvbTZoU0haaE9MNXJHaHl3eC9G?=
 =?utf-8?B?K2JmczROTGs5V2t4S0FEaGFOcHg2dXFWQU1sWklmQ3JGdXkxblozUUVmdytL?=
 =?utf-8?B?dGJ1djNGcVUyM0xDS2VrRUg5YWkzMk9uWCtPd0pza1h6OWNGb3N1cTNzeDN6?=
 =?utf-8?B?NHljWjIxN2ZPUHdXdXA3Z0p3QVJWc3AyL0lrNU5pQVFsenVSMTQzY2txcU9J?=
 =?utf-8?B?MXlVUGk3amxXQ0FubmFjQ2cyd29nV2NXTjdiUUs5T3oweURoZ0VMTnJQSm5F?=
 =?utf-8?B?aUFkQXFSd2hkcVZVTjN3bGJMMXcvWnUzNDRPVVRPQVI0NGYxMGtUVTBERito?=
 =?utf-8?B?UGd1YnNRelhKQXgySUc0WEdOWU1aYmRUY3BESS9UWlhxUTNtNm92c21XWDlq?=
 =?utf-8?B?cWh2TUxtbG9yaTZoYzV5QzlFcm1PMTQ3OGxRSlUzMXZkYUVOajFmVE9GYlZ6?=
 =?utf-8?B?aXpKZEYzd0pqcGpiYlhBcVdDWlR5WVEyTUJqR2dZYXFCenl2VHdKVDFGNWhi?=
 =?utf-8?Q?RwBk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce21730-5f1a-46c3-3bb5-08da87916a31
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 18:33:04.7653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bABFbrg9keqMSZvEWAY2ZkEIdYtq6IuRhVZLo6RU3RQkU4yX8ruHGDjcaF8cdnXQRFfN/wQGf9I9GBB2J0y0Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6417
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogU2ktV2VpIExpdSA8c2ktd2VpLmxpdUBvcmFjbGUuY29tPg0KPiBTZW50OiBG
cmlkYXksIEF1Z3VzdCAyNiwgMjAyMiAyOjA1IFBNDQo+IA0KDQo+ID4gKwkvKiBJZiB3ZSBjYW4g
cmVjZWl2ZSBBTlkgR1NPIHBhY2tldHMsIHdlIG11c3QgYWxsb2NhdGUgbGFyZ2Ugb25lcy4NCj4g
Ki8NCj4gPiArCWlmIChtdHUgPiBFVEhfREFUQV9MRU4gfHwgZ3Vlc3RfZ3NvKSB7DQo+ID4gKwkJ
dmktPmJpZ19wYWNrZXRzID0gdHJ1ZTsNCj4gPiArCQkvKiBpZiB0aGUgZ3Vlc3Qgb2ZmbG9hZCBp
cyBvZmZlcmVkIGJ5IHRoZSBkZXZpY2UsIHVzZXIgY2FuDQo+IG1vZGlmeQ0KPiA+ICsJCSAqIG9m
ZmxvYWQgY2FwYWJpbGl0eS4gSW4gc3VjaCBwb3N0ZWQgYnVmZmVycyBtYXkgc2hvcnQgZmFsbCBv
Zg0KPiBzaXplLg0KPiA+ICsJCSAqIEhlbmNlIGFsbG9jYXRlIGZvciBtYXggc2l6ZS4NCj4gPiAr
CQkgKi8NCj4gPiArCQlpZiAodmlydGlvX2hhc19mZWF0dXJlKHZpLT52ZGV2LA0KPiBWSVJUSU9f
TkVUX0ZfQ1RSTF9HVUVTVF9PRkZMT0FEUykpDQo+ID4gKwkJCXZpLT5iaWdfcGFja2V0c19zZ19u
dW0gPSBNQVhfU0tCX0ZSQUdTOw0KPiA+PiBNQVhfU0tCX0ZSQUdTIGlzIG5lZWRlZCB3aGVuIGFu
eSBvZiB0aGUgZ3Vlc3RfZ3NvIGNhcGFiaWxpdHkgaXMNCj4gb2ZmZXJlZC4gVGhpcyBpcyBwZXIg
c3BlYyByZWdhcmRsZXNzIGlmDQo+IFZJUlRJT19ORVRfRl9DVFJMX0dVRVNUX09GRkxPQURTIGlz
IG5lZ290aWF0ZWQgb3Igbm90LiBRdW90aW5nIHNwZWM6DQo+ID4NCj4gPg0KPiA+PiBJZiBWSVJU
SU9fTkVUX0ZfTVJHX1JYQlVGIGlzIG5vdCBuZWdvdGlhdGVkOg0KPiA+PiBJZiBWSVJUSU9fTkVU
X0ZfR1VFU1RfVFNPNCwgVklSVElPX05FVF9GX0dVRVNUX1RTTzYgb3INCj4gVklSVElPX05FVF9G
X0dVRVNUX1VGTyBhcmUgbmVnb3RpYXRlZCwgdGhlIGRyaXZlciBTSE9VTEQgcG9wdWxhdGUgdGhl
DQo+IHJlY2VpdmUgcXVldWUocykgd2l0aCBidWZmZXJzIG9mIGF0IGxlYXN0IDY1NTYyIGJ5dGVz
Lg0KPiA+DQo+ID4gU3BlYyByZWNvbW1lbmRhdGlvbiBpcyBnb29kIGhlcmUsIGJ1dCBMaW51eCBk
cml2ZXIga25vd3MgdGhhdCBzdWNoDQo+IG9mZmxvYWQgc2V0dGluZ3MgY2Fubm90IGNoYW5nZSBp
ZiB0aGUgYWJvdmUgZmVhdHVyZSBpcyBub3Qgb2ZmZXJlZC4NCj4gPiBTbyBJIHRoaW5rIHdlIHNo
b3VsZCBhZGQgdGhlIGNvbW1lbnQgYW5kIHJlZmVyZW5jZSB0byB0aGUgY29kZSB0byBoYXZlDQo+
IHRoaXMgb3B0aW1pemF0aW9uLg0KPiANCj4gSSBkb24ndCBnZXQgd2hhdCB5b3UgbWVhbiBieSBv
cHRpbWl6YXRpb24gaGVyZS4gU2F5IGlmDQo+IFZJUlRJT19ORVRfRl9HVUVTVF9UU080IGlzIG5l
Z290aWF0ZWQgd2hpbGUNCj4gVklSVElPX05FVF9GX0NUUkxfR1VFU1RfT0ZGTE9BRFMgaXMgbm90
IG9mZmVyZWQsIHdoeSB5b3UgY29uc2lkZXIgaXQNCj4gYW4gb3B0aW1pemF0aW9uIHRvIHBvc3Qg
b25seSBNVFUgc2l6ZWQgKHdpdGggcm91bmR1cCB0byBwYWdlKSBidWZmZXJzPw0KPiBXb3VsZG4n
dCBpdCBiZSBhbiBpc3N1ZSBpZiB0aGUgZGV2aWNlIGlzIHBhc3NpbmcgdXAgYWdncmVnYXRlZCBH
U08gcGFja2V0cyBvZg0KPiB1cCB0byA2NEtCPyBOb3RlZCwgR1VFU1RfR1NPIGlzIGltcGxpZWQg
b24gd2hlbiB0aGUgY29ycmVzcG9uZGluZw0KPiBmZWF0dXJlIGJpdCBpcyBuZWdvdGlhdGVkLCBy
ZWdhcmRsZXNzIHRoZSBwcmVzZW5jZSBvZg0KPiBWSVJUSU9fTkVUX0ZfQ1RSTF9HVUVTVF9PRkZM
T0FEUyBiaXQuDQo+IA0KWW91IGFyZSByaWdodC4NCk5FVElGX0ZfR1JPX0hXIHNldHRpbmcgb2Yg
dGhlIG5ldGRldiBpcyBhbHJlYWR5IGd1YXJkZWQgYnkgVklSVElPX05FVF9GX0NUUkxfR1VFU1Rf
T0ZGTE9BRFMgYml0IGNoZWNrLg0KU28sIGl0cyBmaW5lLiBJIG1pc3NlZCB0aGF0IGNvZGUgcHJl
dmlvdXNseS4NCg0KSSBhZ3JlZSB0aGUgY29uZGl0aW9uIGNoZWNrIHNob3VsZCBiZSBzaW1wbGVy
IGxpa2UgYmVsb3cuDQoNCmlmIChndWVzdF9nc28gfHwgbXR1ID4gRVRIX0RBVEFfTEVOKSB7DQoJ
dmktPmJpZ19wYWNrZXRzID0gdHJ1ZTsNCgl2aS0+YmlnX3BhY2tldHNfc2dfbnVtID0gZ3Vlc3Rf
Z3NvID8gTUFYX1NLQl9GUkFHUyA6IERJVl9ST1VORF9VUChtdHUsIFBBR0VfU0laRSk7DQp9DQo=
