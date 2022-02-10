Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5B04B15E1
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 20:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343715AbiBJTJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 14:09:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiBJTJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 14:09:46 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B17110BA;
        Thu, 10 Feb 2022 11:09:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=De4MXJoMGQ0OFsd0rPXLhHPZLZuPrKmMvDVo0MB4tHPQImrNo9NCcSkxIbvZrfujwCPupF3MIwocDmSCSc1cOI8gp1PJ9qFgtaJxuv1UHqtsmZFaTrX7Y4NPp2XDFbcQiMWVRMbCuLjeAbP+X90b6mExTw4ZOF8N3WHeLA0OFjAb23yGMR2muKXkA1o43Ge6ffUxqD//88zLd20eQ2GXf7KflQo3P49zN3D+GAkds3DssQR2N4a5qToioShsuqJwFf1pT60R/RbkVIpj9zod8EqWG8qMSoRxIuKHBskVOk2oatAiZoBrLDn5ghyJ2VxYYjqVukHSeN6KWRPO1i4ddA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRK3kUW4Ozk/fxdOxAuJtRG0CqQs5oKae6fUDSJ9yIM=;
 b=QfeUnFombOflRqk3UwJvtLN5Gd0SFVxzyX/WBQk2BJlwSvqHMET/Usp5kY1TMKseI00ixeNx8P9PQK0L4+maMIUjquRkDO63mkwA1Fu//IO4qpMN6pYhdcVvNkbkdmPD1iRvFcXQ/Q07BcJoqZkVniljnLE9y6rmxEK/wbAcI57bsLvKwgVp5kC6i5E7ipkEHGN6BZ04LMn5BMot+KN46kJE0mVEsZS4cy0MV5v4inb7IR9CGz7arvTDzgp/jo9ytOXaAfwUcqR2SnlkdDv4zXHCOZp/uCAMjtCaXseYbKRdy6IzynXkBpQlcFRCLeAV1yytBXGWXlAyoHrv7P4V1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRK3kUW4Ozk/fxdOxAuJtRG0CqQs5oKae6fUDSJ9yIM=;
 b=d37MfS7MSa1AYeVJa8uFDUVKCA4qCGp6Dr2M8tXrWmXezqOGkctKA5AXrdK0KmrdQ/9dNGmTT33DYLqVQikyBT+cDUPQl0B69NdL2UkMrNhZOUjx1JlaycSPAa/bDN6Q5eMA3RSd0RLXJ1Bnj2pKqlXcR9f7Ra7kT80VxRZ9kXdem9sexdPI1GASpCU+HMoH9GOD/SAup4teoONNJavJ37vcopo1FqyBr/R0IPE5zNRG6tYLZt7fDMhHAepSc04ECnU4cBBxZ+eTTZ/54bhRjzKIDfOuq174V8g6jT+mBuvc3+MFd+na27HUuDjPaSc5rtx1vY+oIQQEbxZQTSPw+g==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM6PR12MB2716.namprd12.prod.outlook.com (2603:10b6:5:49::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Thu, 10 Feb 2022 19:09:45 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::a0ba:d1b1:5679:8ad6]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::a0ba:d1b1:5679:8ad6%6]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 19:09:45 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 0/4] net/mlx5: Introduce devlink param to disable
 SF aux dev probe
Thread-Topic: [PATCH net-next 0/4] net/mlx5: Introduce devlink param to
 disable SF aux dev probe
Thread-Index: AQHYHQ+MmZHO9aBMsEi8Klfh5rJO3KyKsEaAgABMdoCAAQNNgIAAXhkAgAA5hYCAAIX7MA==
Date:   Thu, 10 Feb 2022 19:09:45 +0000
Message-ID: <DM8PR12MB5480819152FAA88B299B427FDC2F9@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
 <20220208212341.513e04bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgOQAZKnbm5IzbTy@nanopsycho>
 <20220209172525.19977e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgS4dFHFPPMITaoV@nanopsycho>
 <b5b3b3c9-dd31-92ba-7704-c721a26aa805@nvidia.com>
In-Reply-To: <b5b3b3c9-dd31-92ba-7704-c721a26aa805@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b47a82f-68a1-4fe4-8c35-08d9ecc8e694
x-ms-traffictypediagnostic: DM6PR12MB2716:EE_
x-microsoft-antispam-prvs: <DM6PR12MB2716A1E4C9539EF7DA0EF4FEDC2F9@DM6PR12MB2716.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c4PC5Qx6aBCwcGp/HD/QpxlCf6d/9qChCp9lxuBbomgVe7R1OPs62rusGnYjzsQTE9akkyUP8OUrNsvBPOWVquqt6gc33YCIi4R9BzCelrdxM/EcLVNRfm2AZuwcudi5cCuc7lLDhavxccloNlqKa3vuBLipx6XqTLE9grmMNGjsCIfjFF8roMInq9PfyAr8RUHXHJ2HbajALwvvSTuGSVCKdcDqhjdN0jbHNyZqwuJEYDVF5LlCWU7iUThDV0zg6Y0g5yVc5JJF5awmv9YzADR7NAMXK9FFfqLnZx8zuTXnly2Jwub6Mfap4a2nKURYP3bRklHhAKtfBHd9zPyA+UXPf0JpiMN7wPKNWHeuvsp0nB5PHMcZgkLL6ghYJRuNBSMGf1mb1kstQjxZmiJGOx6MBo735m1aV5fIrxw9/pDx8opgEuDtCBJa8wN9ntxH9MbneQf9exKbg7qcUAbK9mMcBYQd6YYQtODBdXXHuyIJbnF0Zz3dNg/WgsXKqNdjcAvdxmBnsFEnKNNeykDpB2C2TbKIErJZn1Sm1C3Y5QVIHaGw15WmBndyKVFxgDIAdLF6HW0M0ROLMGYri8V+0pG3Mmyi4I3wApfy1+ne868zMQDgLhK/2pZ3xaL711lq6tY3kX87xdBFWAcRfaDxXRWMM+T7NNKQSmtogqHZF/Es+DKicuYsAil5bzZOcRtMA2V0C/kezC29ZIbF1xCBvx/+yc3Q2UfNUTrJNW9V3z/FwS/Ahoc54DI45UR0UXJUbDr9vR7nYcIEcVjbYlESNuuG0fK1idA13Wh3f6XAzp8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(8936002)(4326008)(55016003)(66446008)(64756008)(66946007)(316002)(66476007)(38100700002)(66556008)(26005)(186003)(38070700005)(5660300002)(53546011)(9686003)(71200400001)(7696005)(6506007)(54906003)(110136005)(2906002)(83380400001)(33656002)(86362001)(508600001)(966005)(76116006)(122000001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1Q2bVlkMzIyS2R6clBjZGpicHRxZGhZb3VEY0FBSmlSUzM1MWRjL1BXS3VL?=
 =?utf-8?B?TThxV25haWRwTjc5NjVxVzIyYnUwWHA2d2d1Wjh2OUNDdHA4TkEvQ29td3pS?=
 =?utf-8?B?ZUdkeEFJTmNJVHhGN1NrUktCWnpwQTdQOTBpT0txMFNjWFRTVXNSalpXcEYw?=
 =?utf-8?B?SHJud3lsUUg0TUVGMGVSeDJIcWdHZmN0OE04c1RuUzVCOWFyQ3lZWFFXQmh1?=
 =?utf-8?B?QUtRUVBqODJQSDFobDZiRGQwcDgxUE8zajZnMlRHOXNFSi80bFZZVDZpaXdU?=
 =?utf-8?B?U1Fmdk5EYmlyTGxWRXFTeDdjVENKaE53WDBCcEVaNExCOTRGb0tWK29xWktq?=
 =?utf-8?B?SmZjVmVtYVBNUlhaRXU0d05nczlPSG9rd0o0Y3Nkd2RBcnBhU2pkRkZ5Tng4?=
 =?utf-8?B?T3Q1RDVMck1QdkFVNU1JNmNUR05ZaiswMDZGcUcvVnVxWldnaTlsdFRnWDho?=
 =?utf-8?B?S3dGdDRyaWFENmswclBWaWJkd29FOThOTXcvejdOWnl4aDJjL0NHUEllRnJw?=
 =?utf-8?B?Y3Nqc3pTdmVPOUJ3cWJqVHQyaFd4Z0N2alNQRmlUYlh1RTdDUUNvY3Jtb0E3?=
 =?utf-8?B?cnF5YUxPdGtkSFdCYTFLbmFub0J3SzlZcjBpS2x4Z3ArWXlRZGUwNFZFNHRu?=
 =?utf-8?B?cDNybm9YS2Q4YjZsa21uRk1udHNJSlZmQmJPOUxaQm51YVFCSFdYS29ZbmNq?=
 =?utf-8?B?c0l6ekViZS9kbXdmY3R1K1UrbXgxYVdQTmprY1E2RU5pZ21jbDU5bkhLcTJD?=
 =?utf-8?B?RFVLMGVnOG80aWcrbDJzVUhjUTUrRFBEcGdSdUlyMzRMbHJ3ekZLRUF3Y2l0?=
 =?utf-8?B?b1VDZ2Z1aE5TRCtySnBkTlY4b0JsbHRKeC9hOU9KWFpDNXkxaHJsNi9jWHFQ?=
 =?utf-8?B?eW9uYWdldUxhMUNMaUZlNzI2UUhOMjJETWt2Y0l5TmVHSXF1SEtKVHdWNkdO?=
 =?utf-8?B?QjRCV0E5OWtaQzRobUJ4VDZtZldSNk5Bc0F5NjRvSlVIMHhaRU1rNC9iTjE1?=
 =?utf-8?B?MHhXK2pwTUNqcjNDU3V2MzhkZTBNUTRmQUxEUVkvelZvdEtZdDhHQmpzWExH?=
 =?utf-8?B?UWt0VE9qQjFqL0xzVDVRbUd0WUlCZDNvdlgvOW9GRDZGYW9IK1ZQRVk3eVRD?=
 =?utf-8?B?RFk4Ly90dDNrUUZnNVpLKzFqc2tzSmwxQ05WeUplekh3WkV0Q2pMTTNqSDcx?=
 =?utf-8?B?WlB1VXZKTXo0a2NvdVMzdWJxVTBWZjJ6TU1mdnZGcnVVWnk5QUcxNUQzYXgz?=
 =?utf-8?B?eldkVmlGVDU3L0hOS2RmSDMzait6T0NkTlo3WXRUdHRhODU2Y2RwclJCMG9a?=
 =?utf-8?B?NGZMMm80WWNRWjd1a0p3akJMYTFrSGhGYXUrK1UrckNncnJqb3JLcGNXeXVL?=
 =?utf-8?B?dlR5MnBMNDJBb2l3Nnh3NDR6Wk8wMVhjNjNJc1cyN0xzKzlmQ3ordmthSUN3?=
 =?utf-8?B?RnJObHpBeDkyV0lYTGI3U050ZDRUa01GdWM0TXZ6d3g0WFdaUW1pa2J3enNL?=
 =?utf-8?B?Tm9LT1NNUEMvdmVqUzhZMWQ3SlVnNi9WL3BUc3hQVmdZTE00TGdoWjBDUWo2?=
 =?utf-8?B?Y1pINFc5OWpWRU1uQTVwelBTZDhDUTRjUERoYVZjUThPRlpXTGgvdkp4QXdx?=
 =?utf-8?B?VUxUV3Ira0E4MmNDK2FyUDBtQjU2TEErTlJnbUhSNWNtZ3BJMXR6c1c2TnF0?=
 =?utf-8?B?TDZ0aHhUelFzNGMwZDNYa1NoZjEvSWUvZEJQdVc0Njg4K2NXbTdjdDFPdUNX?=
 =?utf-8?B?bisxQ0hQRGNlZCtDVGY0U1BkUm4vS0Y3d1RQZjJwdGlOY3N6VkhXL3RPejh4?=
 =?utf-8?B?MERTVnN4THo0Q2dQb0hvdU4rWm8wMGRRNzRoaGFhRHJtMnNLMnJWR3dubXF0?=
 =?utf-8?B?OFdMa2xlV1QrYXNCVTIzTTdSRkoyME9kbUtFTS9iN2VWRS9Jby9tR2pqWk5U?=
 =?utf-8?B?cmVRNHhTZ3I2TXBKM2tkc1VUakhiZCswWmF4V1hQYnRzOU5Cb2M2S2NINUow?=
 =?utf-8?B?clcvOXRBZWY3TFV1Y2ZKUjFzNFRJREg4OFRLK0RlUjZUbjYzM2wwdHFGTDVQ?=
 =?utf-8?B?ajBPNEJqdVI0Q0c5ZklTaFlKV3VLVS9kRTZYc0R2UXVZcWpYUWNPZU56Z2tN?=
 =?utf-8?B?TTJoZFM5Z0s5UmZacC9WakMyancweDRuYXhibXk0SDJ6VlR1T1ZLOUdyRzU4?=
 =?utf-8?Q?aL82dRG7ZfJ/FYq5Xm8mmN4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b47a82f-68a1-4fe4-8c35-08d9ecc8e694
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 19:09:45.4950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jKSdV+fJ8/g5+a6NSZad5YPNhg1BKgZUcSvhYIJbRQXd6vnxkIfimbTVA58XvP47S0GYcy5KpenFmyx76X1i8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2716
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG52aWRpYS5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBGZWJydWFyeSAxMCwgMjAyMiAzOjU4IFBNDQo+IA0KPiBPbiAyLzEwLzIwMjIgOTowMiBB
TSwgSmlyaSBQaXJrbyB3cm90ZToNCj4gPiBUaHUsIEZlYiAxMCwgMjAyMiBhdCAwMjoyNToyNUFN
IENFVCwga3ViYUBrZXJuZWwub3JnIHdyb3RlOg0KPiA+PiBPbiBXZWQsIDkgRmViIDIwMjIgMDk6
Mzk6NTQgKzAyMDAgTW9zaGUgU2hlbWVzaCB3cm90ZToNCj4gPj4+IFdlbGwgd2UgZG9uJ3QgaGF2
ZSB0aGUgU0ZzIGF0IHRoYXQgc3RhZ2UsIGhvdyBjYW4gd2UgdGVsbCB3aGljaCBTRg0KPiA+Pj4g
d2lsbCB1c2Ugdm5ldCBhbmQgd2hpY2ggU0Ygd2lsbCB1c2UgZXRoID8NCj4gPj4gT24gV2VkLCA5
IEZlYiAyMDIyIDEwOjU3OjIxICswMTAwIEppcmkgUGlya28gd3JvdGU6DQo+ID4+PiBJdCdzIGEg
ZGlmZmVyZW50IHVzZXIuIE9uZSB3b3JrcyB3aXRoIHRoZSBlc3dpdGNoIGFuZCBjcmVhdGVzIHRo
ZQ0KPiA+Pj4gcG9ydCBmdW5jdGlvbi4gVGhlIG90aGVyIG9uZSB0YWtlcyB0aGUgY3JlYXRlZCBp
bnN0YW5jZSBhbmQgd29ya3Mgd2l0aCBpdC4NCj4gPj4+IE5vdGUgdGhhdCBpdCBtYXkgYmUgb24g
YSBkaWZmZXJlbnQgaG9zdC4NCj4gPj4gSXQgaXMgYSBsaXR0bGUgY29uZnVzaW5nLCBzbyBJIG1h
eSB3ZWxsIGJlIG1pc3VuZGVyc3RhbmRpbmcgYnV0IHRoZQ0KPiA+PiBjb3ZlciBsZXR0ZXIgc2F5
czoNCj4gPj4NCj4gPj4gJCBkZXZsaW5rIGRldiBwYXJhbSBzZXQgcGNpLzAwMDA6MDg6MDAuMCBu
YW1lIGVuYWJsZV9zZnNfYXV4X2RldnMgXA0KPiA+PiAgICAgICAgICAgICAgIHZhbHVlIGZhbHNl
IGNtb2RlIHJ1bnRpbWUNCj4gPj4NCj4gPj4gJCBkZXZsaW5rIHBvcnQgYWRkIHBjaS8wMDAwOjA4
OjAwLjAgZmxhdm91ciBwY2lzZiBwZm51bSAwIHNmbnVtIDExDQo+ID4+DQo+ID4+IFNvIGJvdGgg
b2YgdGhlc2UgcnVuIG9uIHRoZSBzYW1lIHNpZGUsIG5vPw0KPiBZZXMuDQpJbiB0aGlzIGNvdmVy
IGxldHRlciBleGFtcGxlIGl0IGlzIG9uIHNhbWUgc2lkZS4NCkJ1dCBhcyBKaXJpIGV4cGxhaW5l
ZCwgYm90aCBjYW4gYmUgb24gZGlmZmVyZW50IGhvc3QuDQoNCj4gPj4gV2hhdCBJIG1lYW50IGlz
IG1ha2UgdGhlIGZvcm1lciBwYXJ0IG9mIHRoZSBsYXR0ZXI6DQo+ID4+DQo+ID4+ICQgZGV2bGlu
ayBwb3J0IGFkZCBwY2kvMDAwMDowODowMC4wIGZsYXZvdXIgcGNpc2YgcGZudW0gMCBzZm51bSAx
MQ0KPiA+PiBub3Byb2JlDQo+ID4gSSBzZWUuIFNvIGl0IHdvdWxkIG5vdCBiZSAiZ2xvYmFsIHBv
bGljeSIgYnV0IHBlci1pbnN0YW5jZSBvcHRpb24NCj4gPiBkdXJpbmcgY3JlYXRpb24uIFRoYXQg
bWFrZXMgc2Vuc2UuIEkgd29uZGVyIGlmIHRoZSBIVyBpcyBjYXBhYmxlIG9mDQo+ID4gc3VjaCBm
bG93LCBNb3NoZSwgU2FlZWQ/DQpBdCBwcmVzZW50IHRoZSBkZXZpY2UgaXNuJ3QgY2FwYWJsZSBv
ZiBwcm9wYWdhdGluZyB0aGlzIGhpbnQuDQpNb3Jlb3ZlciwgdGhlIHByb2JlIG9wdGlvbiBpcyBm
b3IgdGhlIGF1eGlsaWFyeSBkZXZpY2VzIG9mIHRoZSBTRiAobmV0LCB2ZHBhLCByZG1hKS4NCldl
IHN0aWxsIG5lZWQgdG8gcHJvYmUgdGhlIFNGJ3MgbWFpbiBhdXhpbGlhcnkgZGV2aWNlIHNvIHRo
YXQgYSBkZXZsaW5rIGluc3RhbmNlIG9mIHRoZSBTRiBpcyBwcmVzZW50IHRvIGNvbnRyb2wgdGhl
IFNGIHBhcmFtZXRlcnMgWzFdIHRvIGNvbXBvc2UgaXQuDQoNClRoZSBvbmUgdmVyeSBnb29kIGFk
dmFudGFnZSBJIHNlZSBvZiB0aGUgcGVyIFNGIHN1Z2dlc3Rpb24gb2YgSmFrdWIgaXMsIHRoZSBh
YmlsaXR5IHRvIGNvbXBvc2UgbW9zdCBwcm9wZXJ0aWVzIG9mIGEgU0YgYXQgb25lIHBsYWNlIG9u
IGVzd2l0Y2ggc2lkZS4NCg0KSG93ZXZlciwgZXZlbiB3aXRoIHBlciBTRiBhcHByb2FjaCBvbiBl
c3dpdGNoIHNpZGUsIHRoZSBodXJkbGUgd2FzIGluIGFzc2lnbmluZyB0aGUgY3B1IGFmZmluaXR5
IG9mIHRoZSBTRiwgd2hpY2ggaXMgc29tZXRoaW5nIHByZWZlcmFibGUgdG8gZG8gb24gdGhlIGhv
c3QsIHdoZXJlIHRoZSBhY3R1YWwgd29ya2xvYWQgaXMgcnVubmluZy4NClNvIGNwdSBhZmZpbml0
eSBhc3NpZ25tZW50IHBlciBTRiBvbiBob3N0IHNpZGUgcmVxdWlyZXMgZGV2bGluayByZWxvYWQu
DQpXaXRoIHRoYXQgY29uc2lkZXJhdGlvbiBpdCBpcyBiZXR0ZXIgdG8gY29udHJvbCByZXN0IG9m
IHRoZSBvdGhlciBwYXJhbWV0ZXJzIFsxXSB0b28gb24gY3VzdG9tZXIgc2lkZSBhdXhpbGlhcnkv
bWx4NV9jb3JlLnNmLjEgc2lkZS4NCg0KWzFdIGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL2h0
bWwvbGF0ZXN0L25ldHdvcmtpbmcvZGV2bGluay9kZXZsaW5rLXBhcmFtcy5odG1sDQoNCj4gDQo+
IExHVE0uIFRoYW5rcy4NCj4gDQo+ID4NCj4gPj4NCj4gPj4gTWF5YmUgd29ydGggY2xhcmlmeWlu
ZyAtIHBjaS8wMDAwOjA4OjAwLjAgaXMgdGhlIGVzd2l0Y2ggc2lkZSBhbmQNCj4gPj4gYXV4aWxp
YXJ5L21seDVfY29yZS5zZi4xIGlzIHRoZS4uLiAiY3VzdG9tZXIiIHNpZGUsIGNvcnJlY3Q/DQo+
ID4gWWVwLg0KDQpJdCBpcyBpbXBvcnRhbnQgdG8gZGVzY3JpYmUgYm90aCB1c2UgY2FzZXMgaW4g
dGhlIGNvdmVyIGxldHRlciB3aGVyZSBjdXN0b21lciBzaWRlIGFuZCBlc3dpdGNoIHNpZGUgY2Fu
IGJlIGluIHNhbWUvZGlmZmVyZW50IGhvc3Qgd2l0aCBleGFtcGxlLg0KDQpNb3NoZSwNCkNhbiB5
b3UgcGxlYXNlIHJldmlzZSB0aGUgY292ZXIgbGV0dGVyPw0K
