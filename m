Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE04D886E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbiCNPrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiCNPrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:47:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103A33D48E
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:45:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWjqPbw3xxp9YEIIs8OF+rM4kQkXvCYiGJUc30R63ILShrLa9ynrMllRUWomSbwQCZFEEW6OL/WiMAoRAUMgtV/zXFOw4vft81/f9jr9SoXNRCHlu3/wjGunm/Dy9+CIzCDzMOGKDsoxz/idUYW9xrzZQgBudureuSz4jpYzsbChXSfoj+JkKk+59whDu1B3hzE9SmIu+bVq0slM2rHvhlsbLDTh0b8mAutCKItAa42a+bMB1ktumWp/K4teLitcEXOBkALlCUq16WY6GX00z0mnRFX1ceZYPCkK9QkNBmjDWoreBM6w0Ug5uOS1V8uoy3eJbr8QmmJKoSR8qG91lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wm0JYWwOOHfyg5atvty6Qb1wuxd9XLBX80yn1BrFT4g=;
 b=d40x+qn9vdEfJrV4ffVikuiYz3WgDdA3re2Vb1AfxMweq6KcDu8im64q2YFOKP1noPZkdbsjsBoNGm3Arx+UUlnC6i3IESar4SMLDpU92CaQ1WwHtUDqKBjj4ndIhKw/ESWxkInwXSztRBNQYjteN2Z1aQrbJEx1iiIJRT+i/2fNZShkhPn/wn6neeX9sIC5PaCC4j6h0MMRwV+Hvt2kJITksvE4PdLsRD7WUEWJdBge8ZN5zDwBhu78L4R5OzmfYmmkZpd5WGX5f44y2m4jG36EboQfVHTJiParm8CcImKnAKo26NhvBWBTWdNnTXU5qrMIL5HOFDAZh5r8woXQ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wm0JYWwOOHfyg5atvty6Qb1wuxd9XLBX80yn1BrFT4g=;
 b=e1m/u4Kok7OF8B3slJe19NEQJSTJh51HihgXsopHhs1QT5lYUAmuxNfdVetGFeq/vEVI0hVCHDLR7aYOeQaOj8jjhtUv1E0mMKd5JRquxyToNyu5wP6sHXiu2n16zvAIZK0NU58IrKxi8zF+Tdej27zLurxuhz1igB/rXtPQJ52CsI69gXFoB+IJZuOPFaGBoy1fD+VRDIH4/BJ/uv69ndSjKZTiHupbG9vfUmQYqkza0FiAFF7SiqPAdQRhnNxwXsaNYPQgJl2gEbx3juwh/IZCvQcPe/+7LxtTgwe67kY2e4bo5lnUTLq3Mqs2xdhL4HVhcC+hXkhl3lzUmx8Kkw==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 BN8PR12MB3393.namprd12.prod.outlook.com (2603:10b6:408:46::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.25; Mon, 14 Mar 2022 15:45:55 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627%6]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 15:45:55 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     David Ahern <dsahern@kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Subject: RE: [PATCH v7 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Thread-Topic: [PATCH v7 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Thread-Index: AQHYNv2LN/8GLIMU7kW3y9RiVsKR1ay+/OUAgAAJ3fA=
Date:   Mon, 14 Mar 2022 15:45:55 +0000
Message-ID: <DM8PR12MB540011BD3BCED32FEE7522F8AB0F9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220313171219.305089-1-elic@nvidia.com>
 <20220313171219.305089-4-elic@nvidia.com>
 <6d9e4118-ee4d-0398-0db5-bd3521122734@kernel.org>
In-Reply-To: <6d9e4118-ee4d-0398-0db5-bd3521122734@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ac17702-32bf-4d88-0e4b-08da05d1b9e4
x-ms-traffictypediagnostic: BN8PR12MB3393:EE_
x-microsoft-antispam-prvs: <BN8PR12MB339368C850D603D1FA6E743DAB0F9@BN8PR12MB3393.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UPCqnomd55+d3s+kTAKi7kLokOe/srqebkZLmsX9s7l+3HPfS1oRy+fc1yGIzXoqQusyljixEMWXEnmgvSwh+EeWM0Wfsdc57Y2pcdUwq9WtCbK3iYSOBn57DE8aF+K8zwE2KIQ1R7OJdp+c3uZN8pMdOaKR8FoF2Bw+QDChjTsA/Gcl8bSyfmwD6E/iIQqUJdxORFI5LqyroThy1DgIzrmZWcVH9wEewJBMpWrr6m+la6YMfASO3gFXgX41bPA7n0xeQzxYRjaqwl4Vsy7A6mKwHNjdjFpv+/fa9roaQKlM5SN+drxRReQPE4X3yoA/Xg8xhVmk+b6tqrjuZeKseAnKLieZNtTJOXa23AYesd5jk/Nt6sXjBO/qTxDyRHrGVewdOlkK8rdIo4HmihzcrxR+IIeGxpcGDNDRHgwG+ylDjR+dnpLqIICuHyEcrSLUpgCBHlS+tKqZtHaQEi8OcZ/TMCY/Kvbq3YNfs4jvjftnFG4WIWKWrmPfNlBI1YZ+ierVdhsyk8swo8kWB1Xjm3gBM9nElDOCW1NhSLHMrVt1y/4M9nEVvPZgNIIkBkVH9QS8470E7cel4nTpZpaeb+4eC4v0AdpKNZ1Rscn+BL9lY0UHzPWVbi6IP1wyfZ/uiz0xxPOlCA+qFN8hHF2ZzbcImnwe08b2xXPFXtO84R8EdKK1xMQR7KxpIpd7+xQ+KZSb4Ur1303nnJ0LkLUV+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(38070700005)(52536014)(8936002)(71200400001)(5660300002)(110136005)(54906003)(8676002)(316002)(76116006)(4326008)(66476007)(66556008)(66946007)(64756008)(26005)(86362001)(107886003)(186003)(6506007)(7696005)(9686003)(122000001)(55016003)(2906002)(33656002)(558084003)(83380400001)(38100700002)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXZWdXIwVWF0TkFPSUsra1d0S0NBVzhuYk41Q3ZIWlFOU0gzaWoybEIxdnhO?=
 =?utf-8?B?VlFlUTl6WnpsUDdCWU96WURVOW9HcmJpZ2huWk9OdTlwcDVsUGt5SjFIRTVs?=
 =?utf-8?B?Uk1PL3ErNGdpOU16N1VGYUhOTXBubS9vYVBRT3J0QnVKMTVIYXhrZWdMOWw5?=
 =?utf-8?B?amN0eGRHVmE3b0xtdzlBbldLcUxDa2ZDbExKV2lnMTBKU1p0ZmxwTHpiWG8y?=
 =?utf-8?B?anAxVzVta08wNGtyOGI5aFB3SW9CRkg1a0psUjFxQnJKNXd0MkFtTkRyL2tN?=
 =?utf-8?B?WVVlUjlnS1ZCa2c0dUR0UW5vdUJTSmwvUjZHMVJIK21BcmtoMnBRRkpJeVBJ?=
 =?utf-8?B?aDZ2cnZPTjBJSXhWNFFibW9tcFE4NTMzdG9zSnZaMVdZVjdEYlJiR1B2TmhH?=
 =?utf-8?B?ZWN5MFBBNDBoOHZZVW9ZYmF2MmNDclh0eExaMG11UzZ2dWNlcUJUaHBXOGVx?=
 =?utf-8?B?M2JobjBqT0FlVHJ4OHBRbDRDYUNoYi80Y3NxYXRiRDhadzRKRXIyaTdMYjBS?=
 =?utf-8?B?Wmlma21SdmJJdDFMSFZ6Y095OXY0c29HenhKZmtDeXNpYW9PZ1VIeitMYk1B?=
 =?utf-8?B?NjQvYi9XL3pBRmovM0w0OVgxTSs2Y3hzOU1UMUJQWHhLOFNuL2RqSEdMZjJm?=
 =?utf-8?B?dWNvTnJ3aytQSjQvYzNZQzlCOUV5NzVjbzZmQnhGRXZJMFB2WVVDYldCYWhH?=
 =?utf-8?B?bUludnhHekNNelBHb3FCc3JqUk0rR3NNeGt0SDU1RUhMN0RpYkV0ako2WTd1?=
 =?utf-8?B?cXVYZERjU0tOdC9nVXg5bUZxVjlnaWMvSEo5UUE5WmNOaFdkUDdZdlpmeE1a?=
 =?utf-8?B?dXRtN3ZXcWxoTUIvUHRwdU9HdFhScUZVM1owZEdiMzdCa3hmQUlzV0N5cE9W?=
 =?utf-8?B?dFB3WXVxVVNsSlJ2RkhVYmM4Zjc4ck5ERGdMWU15T3JGTVkrTFVJVWVWK0s0?=
 =?utf-8?B?Rld6UjV1bHlVT0xmbElVR2lpUXplMFljc0k2WlNFSnorQ0hJZlVmUlBpR2FF?=
 =?utf-8?B?czBZYTF3RXFTQzBZZUR0NklDZkRoN2sxZ3lJMWVuaTlaeWtsK3pPNnlyQUZt?=
 =?utf-8?B?VGZRUExPRU8xbXN3cnBZSUdteDJSeEIvRS91M1V2WjNrMTJXc3NMQ3g5SWEr?=
 =?utf-8?B?UTd1Ym1RY3VOSzFyQXB3ZW5lcWVkUXUvZnRIL2EzY0p3MkhnZGNaNUlJdzVG?=
 =?utf-8?B?NWlQUkpsOFpMNURQWEgyNUFPSHlzV0xVUkJ5ZkpiN05hUE5MSVN6Q09xY2pH?=
 =?utf-8?B?V2lUN3dibnh5RkZ1SzlPRTBkQ3VKUWUwM0dxZFc5dGJ0aWVCeVJXZGg0S0ZM?=
 =?utf-8?B?MWE2eUpaM2l2R0JBMlNQSVlWVkNsakJYSmFBSGtVczlwYWx0elFuaGFBNTNj?=
 =?utf-8?B?bk5rangzT0x3a25UY3dQbm9oNEVsQTh5dkQzQzZaOW56RFprRjhKS0lOYVJL?=
 =?utf-8?B?RkhMcnZNcFk1aS9yNC9sU0hQQzdZYWk3cFV2bXdkbUNqc2hZb3BPYWcxdDdk?=
 =?utf-8?B?OCttcXB3MkJOckVQYjkxNDB5WkkwMTh5WGZvNEEyRktNMVRVU0VOOFR4V3Za?=
 =?utf-8?B?dkNsbVc3citjNzVBZXh2akdLeFkxYm05QkxLaTQxN3A3Zm9QL3VmUUoyNHFq?=
 =?utf-8?B?d0V2YXlucGpOWXFTR3pLV25ieHAwZzBSaHZBS0NGclQ4ODVDa1YzZmtSZlJ3?=
 =?utf-8?B?UElWWFJVMzhNQ0JHQUVHZ1g3bXBxdGtBMkhGamFYampYakVLQlREdDhkYnV0?=
 =?utf-8?B?NGJkd051NldCVmlacDFrRHgzQklXV0h6Ni9iSFlIeWVXT0pOaTh0aVhDSmto?=
 =?utf-8?B?M0dsREVaQThDaWhxdW1YMmpWSldQYU1BZWtPK2l1VWNPbnU1REpndURDVjRM?=
 =?utf-8?B?UkhIM1lMNjNUa3RZVzF6Z05wTkhKVnd3dmg0OUsxbXJsd3kvM0JNY2NiWmVr?=
 =?utf-8?Q?ORE9cBASE9A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac17702-32bf-4d88-0e4b-08da05d1b9e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 15:45:55.0756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a9KntHIYARMAv/cyhHvdMrjvo93p+t8j3oWtD0FdGwUW6yjHZWcMhYxhmpi5O2V7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3393
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gbmV3IG9wdGlvbnMgcmVxdWlyZSBhbiB1cGRhdGUgdG8gdGhlIG1hbiBwYWdlLiBUaGF0
IHNob3VsZCBoYXZlIGJlZW4NCj4gaW5jbHVkZWQgaW4gdGhpcyBzZXQuIFBsZWFzZSBtYWtlIHN1
cmUgdGhhdCBoYXBwZW5zIG9uIGZ1dHVyZSBzZXRzLg0KDQpIb3cgd291bGQgeW91IHByZWZlciB0
byB1cGRhdGUgdGhlIG1hbiBwYWdlPyBXaXRoaW4gZWFjaCBwYXRjaCBvciBpbiBhDQpuZXcgcGF0
Y2gsIGxhc3Qgb25lIGluIHRoZSBzZXJpZXM/DQo=
