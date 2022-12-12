Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B6364A3AC
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 15:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbiLLOqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 09:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbiLLOqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 09:46:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5D66424;
        Mon, 12 Dec 2022 06:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670856368; x=1702392368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Rdw7r/oyvljUyHVMom78aAV2IkP+OidtdOwfrTxZ9eo=;
  b=e/1Wch5KGfWkNJM9LvNvATLXhZyJNsZAwKdeBKzdkAamsSt523q9ohE1
   e8LbUj9Lm0rV+r/tvxgRJ25dwYdHLliP+M5EBikkdmXTTP7L+IAp7DrJ2
   L6zG38r2rlQ2q3a4Cz5xfyI7a+mwoB5CbNWSmsCjhWqSkkEzo2WjJ1Bgo
   1QTEbwBJDPVgx1IqYRcX9V/yIKgzt8oYO32a8lD2edcCDVtf3GW3oC87z
   6tG3mD6EPrVCgHMWASFYp165shLUXE/8POKrzH78nMB9b2X/ZfYLbtWDI
   LDZidQ3NDFiVi8iHdG05AWx9W0rQfGtqwNiRwwNRoHDJ3o6TQY7bjvZUp
   w==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="187732907"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 07:46:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 07:46:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 07:46:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dg+CL2OBNuavaZ6CFmJvOJVeg47Ov8atqeDVE/efUXKVfUWjtdEYkHQb8PDqnCyyNuvhcoa4nRTqi/5m7cqM0tFDq35M4kP0f+0CqeJ+auycvNbXAgNgxSdjGhZQj0pGiZzSv2yGLzAApC4WkubYzpjvkmRVY035JvY3XKjSVIs2eIi/IV9XW59b3+lFRxEAxHxDCOvs+cqw2QtH/VPNPVs5Fm8oqBaEwds25D8zMvrsoSrgqVOjahzTuAawpEJq4i0ch8tHzyfmBwMXvHuj/SPY19c97JKZVIcaMSVSFcp2Fjo1JHo9gkvX3gpkHZ2ocn+TNoZp1MG1bcEjzbvsCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rdw7r/oyvljUyHVMom78aAV2IkP+OidtdOwfrTxZ9eo=;
 b=CHWnV74vt19dM3rFndfToIHXVGALHWQJL3LvCc6O51S1ZHBB4LRbd55QmrMU0/zWNcFpj+4V4B+zWsd9HXQF/3NQh3XDW2L95rB2BPaIYh9pMpj8O1gWkErrJ8ImYITx34UmcCPOdLYSrvqXfkddelQUcmOKyjs9YobA+XlHuh/q7pnaJ/xVg6t0EqaM0o3mHuhZiubKyM9Bya9ea4LmFtay+IkpbeyrejE1grBc3RDbx3odcdbQMDhsk3WLAFFS2o3vxi2hkG4ai+SDEdJZdPLMoNyASQk0NYng1ugiXinOhNRkb3hYRhBsQMqkTAqx7t5XuT8G7K3s4HyhCyScXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rdw7r/oyvljUyHVMom78aAV2IkP+OidtdOwfrTxZ9eo=;
 b=M6uNm5e4ptVqOwn8zzhpMxA4+WKwIegg/wO4D/kekAFh0fqz8JKMNDj9Fvmhe6paN3e1RKHnunVozESNu2wGkc4HDAwBgYodYCiv59i+apqdycYe6r5GEDEh8EJK96/0SAXFd5EDOF7jqeb0YodMw06JekTWBX8eT+50/XjnWC4=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by MW4PR11MB5933.namprd11.prod.outlook.com (2603:10b6:303:16a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 14:46:03 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::98f6:c9d1:bb68:1c15]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::98f6:c9d1:bb68:1c15%10]) with mapi id 15.20.5880.019; Mon, 12 Dec
 2022 14:46:03 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <Sergiu.Moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Thread-Topic: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Thread-Index: AQHZDjh1lu6Nr6LaGkCWpa2jrelsQQ==
Date:   Mon, 12 Dec 2022 14:46:03 +0000
Message-ID: <887723a9-7a8d-9190-3f15-e9a07c4ba65f@microchip.com>
References: <20221212112845.73290-1-claudiu.beznea@microchip.com>
 <20221212112845.73290-2-claudiu.beznea@microchip.com>
 <Y5cizXwsEnJ3fX0y@shell.armlinux.org.uk>
 <b2f0994c-432f-9ac8-485e-ac9388619674@microchip.com>
 <Y5c5uzpee1jrwWgz@shell.armlinux.org.uk>
In-Reply-To: <Y5c5uzpee1jrwWgz@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|MW4PR11MB5933:EE_
x-ms-office365-filtering-correlation-id: 09e0691f-cac3-44af-d3d3-08dadc4f9804
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x2hcyx7pIQ3+AkzzVFN+0S75FlvG9an0f647UAmpuXbxioeUD/G5kJpCOrKY8fibdLp5QvGmcSqhswcgr7ZB0xC3W0xtdh72kW4YEM5UQBVmnW5vbU6jIsEhXEV3PEu29CPxRnl9mU+kE5hjQ9f76yYzr1NPGFSRHztft2IDaAvon9IvgRwHVVakQUr20nJdM73CZtqOsvcfZhmgkF1bRCPCKbNS9dMBh9G7ro/yw2j8nlVkx8QnyAz6NEprj/+HE5q6vAZRA4lmO0EB/O/QjOBFL1YGvmXcaneEeP+TTn4DY0mZp/TrYwh8NchTZZFlQ1INJmvN8+zis4iYikfwGC2GgRP+GduaOd9vK6vTjyo4XdsKsR3v3I+YwOEeqCywUvctlMR6B7sa/H+qtYFpG4yC1iLuMdLUhNSkYrGZiEjKdPtxbNZLwjMP5IlaT72YM9Wa7IoZCYVwkkO8wTYqOa1asgbxLX30tGW6mRXzDf/UdlEkCCmzDa1eQ1x67DrfY8Ehm1DJF8ntDwNtJWTC1z0XY1M1ukVAymQe3grMkwF89eWGue6avMkG+dzhqbjbEIReEP5nE/tWfu5R5jmqlrdpRCIunEBSCWESKKrEB3eNMHMw4QWISQssdKG2kuYkeiIoCRmIzchZHQdy6pFvT1wM+m3ellpDVfkosZtEtzbvV1ZNhota560i9pBR0tukZPK9G/3Cy6xLL1gkX20BETLXVzwgoEozyTQo3F2Q29x5zv0W0CJYo85FacJpmDCB8XNQkBoOPPgU6B8UmiCbkKqm56X+SYTMIxbl9yN3Usg403QyWJW1yxW8Ci1y7mMrQqbxD0trcY01F/Q4hT8//g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(122000001)(64756008)(86362001)(31696002)(83380400001)(38100700002)(66476007)(66446008)(6916009)(66556008)(54906003)(66946007)(8676002)(316002)(76116006)(91956017)(5660300002)(2906002)(8936002)(4326008)(41300700001)(2616005)(186003)(478600001)(26005)(71200400001)(6512007)(6506007)(966005)(6486002)(31686004)(38070700005)(53546011)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MEFZS2gwQ21kdW0vUzVSMFhESUM3bHZXV29xVGhyUEVaQXdtMXc4S1hoNjRF?=
 =?utf-8?B?b0c1UHRiNlJSck1XUTBBOHF1c0FaK2NXNlpzMEFMbTIwWDBpZXBmd1EvNGhr?=
 =?utf-8?B?YWNVMHRheERxVGtRWkV6bXYzQlc3TUZ4Y0NKb1RMR2lYZ1dqQTd6YkZ3ZkhL?=
 =?utf-8?B?eFhPVy9jdTBLVmxKVWtlWHJHc21hRmNHUkFEM0NGK2gvT0NkVmxWTjV2NEIz?=
 =?utf-8?B?L0lZT3lxdTl6K1NYMWt5NGdHSDFjeVpIVzc4T2xheGljaGNORnNtdXlQTlQv?=
 =?utf-8?B?aW12TzNITUdNNmJwWXBwT3pHNmNDQVVkY1Y4d3p5Tm5LaWhrNmZIZy83cXdX?=
 =?utf-8?B?Umw0cTFGWUh6d1oyOFRNNFB4K2l5dzRlN0tyUS90TDRFUm5IYWlDMkNRNVpR?=
 =?utf-8?B?MmVLcVVJWlhnUmFmQU1oSWxPa2doenZFa3ZwTk1VSnFONEtocmRnMk5EYmVY?=
 =?utf-8?B?NFd0Njg4dVVIUzA2RW5yRUlHdTN3dWVQcnViazVISjdpMWdkeTgxdlhkc3dW?=
 =?utf-8?B?U1FCRWh3RDQxNHEySEFEVUNCS25tMXc1bnJOZzJsdlNpbG1reGY0aDZXajBI?=
 =?utf-8?B?ei82WVZ1QVRJSDVmZ0s3ZGN0TXloaXBQUDg1V09xdEhFbENvN0N4YzBBdlNQ?=
 =?utf-8?B?SXVlSGV4cWh0UVBuYmVLbXptWkdmbzEwSWYxSm9TaEkrLzE1SjZVajFjcjgz?=
 =?utf-8?B?TXRhSVFFNDZPUDkra2dBSVBCUkRWeWZvUUNtdmJQWStkdU4wcUlaVCt2akZO?=
 =?utf-8?B?V0E3OEFydzd6aDB0aDQrSUg4WUozWWp1NnJ6ZmxrRjVVU0ZwcEFXUi85UE9P?=
 =?utf-8?B?N3lSM0pSMGVkYzdDNXlLM1dWYmJzaW1aeXV3WkFjN0sybUlVMERxY0Vza3Mr?=
 =?utf-8?B?R0FsY1djL3BYRHhxYy80Q1grbE1YSGQrNEt2MllYKzdzKzg2b3A5Q2ZvaUYv?=
 =?utf-8?B?V0NhTUhKQ2RvMHJwb2NHTEhrS0xmckpLdVpBTnFoWU12RjJrVTU0OUhlRjBQ?=
 =?utf-8?B?UUdndDd5SDBEV2pmelpWNDFOWmJ6OHU3c0xhVHIzc3IzUnI1aXpQVkJLcUg1?=
 =?utf-8?B?Z0g2ekorQ3A0WDJGZzBuNzVJcGRTamgvMFdEUDZGQlluV2dreWhJQk5XaFFu?=
 =?utf-8?B?MHMxczQ1aXJNdmNnVGt2bVVLMjZWR1hpelFNcEpKeEk3NEJxemVvY0xHYnAr?=
 =?utf-8?B?c2QyRkpyem1CeVVsekZmc2JrMU9rRjJOMDhCaTI4YUF2RjhQdkwyc2I1blRZ?=
 =?utf-8?B?WmdhamVFMitmV1VBcDY2NmdiSzZnOEdRNEVqZmlBYmN6OXRyamFQSGc5aFlM?=
 =?utf-8?B?dTNqbW1BVWI2RmFxUWJacjdTVW9VSlZLdU1qYVk5b05COTZ3OElYczMwL0Zs?=
 =?utf-8?B?dEM1ajU3ZVI5MkdpNG9QYVc4MGUveWlhR0FUV1lGeUt2Ulhsbm5wZWdCWlpZ?=
 =?utf-8?B?cjFXNktQb0EwWWJaR0RRVjJXcVRPTEdnTzJjOTBSUXd1bmEzNlBGZzRQL2o3?=
 =?utf-8?B?ZURFcEQ5K3BMZDRrN1UxWlA4b2J0aDhyNHJSTzJRVEtRWHVZWGpabmhTTlNh?=
 =?utf-8?B?UWtKY0ZPc294c0pDaTlhU1VCQ1RTSlZkdm5WdEc4R3BzNkZmbURnMTlqY21W?=
 =?utf-8?B?bXJwcVZWdHAxdU5vSUdzZjVIOTVqWEZXS0VCaHNmWDRhVlBiWFBhaEZRUi84?=
 =?utf-8?B?OGtxZlNLV2VsMXpOS2hmZCtWd1k1TStsU2JaOVk0Z0luM2E2OHZxeWpHcThi?=
 =?utf-8?B?bkdKZ1V4Q1puWU5hcFZPUUdIaHZ4QXZLc3duQ2F0UVBZZ25pQ2FzUUpLNklp?=
 =?utf-8?B?VGxFQjhNRDgvaDBnQVYwb0NIdE9oYkhCTkpFNGJJZ21OTzM4VDBuaGMyQkh2?=
 =?utf-8?B?d3Bjb2Rid2dQNmZBdElVRUlVaWpyeXlCNWNEYVU4RmdSbmdOQ3NnTG9Sa0Zz?=
 =?utf-8?B?K0kzZUZnZjB4RFhHeEN3Ri9lUUxxM0lHbS9Pc1M1K3ErRDBMTFFBUkVKQmFQ?=
 =?utf-8?B?TTdGUG9ENUFKZGJPTUpKWXlvV0pmQ2dUQ0dnYWY2QzhoL3lqc2dMd1RFTUtE?=
 =?utf-8?B?MzZ0ODRLRzk0U0x3c01ITCt3ZUk4NjkvZlRDQ214K0EzTE1lekppT2w4WnlN?=
 =?utf-8?B?aUpaSHN4eWZWV3hRUkgyUmorTlJTeERyVmhJdWliQU5Ub2FoME9keVdCdzI5?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0472D5F2D5070F4D934DF88790D7B4DB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e0691f-cac3-44af-d3d3-08dadc4f9804
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 14:46:03.6858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M470nWMHLCwZXDBuTL2pkSB6H2qtnNHom47AXVahi1EiDX1k0B5wleTu8VJk4Q+4j+ibmbpmLJBcfHPWRugvcwvpAboowZvi8S63hl1idRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5933
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIuMTIuMjAyMiAxNjoyNCwgUnVzc2VsbCBLaW5nIChPcmFjbGUpIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIE1vbiwgRGVjIDEyLCAyMDIy
IGF0IDAxOjI2OjU0UE0gKzAwMDAsIENsYXVkaXUuQmV6bmVhQG1pY3JvY2hpcC5jb20gd3JvdGU6
DQo+PiBPbiAxMi4xMi4yMDIyIDE0OjQ3LCBSdXNzZWxsIEtpbmcgKE9yYWNsZSkgd3JvdGU6DQo+
Pj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+Pj4NCj4+PiBPbiBNb24sIERl
YyAxMiwgMjAyMiBhdCAwMToyODo0NFBNICswMjAwLCBDbGF1ZGl1IEJlem5lYSB3cm90ZToNCj4+
Pj4gVGhlcmUgYXJlIHNjZW5hcmlvcyB3aGVyZSBQSFkgcG93ZXIgaXMgY3V0IG9mZiBvbiBzeXN0
ZW0gc3VzcGVuZC4NCj4+Pj4gVGhlcmUgYXJlIGFsc28gTUFDIGRyaXZlcnMgd2hpY2ggaGFuZGxl
cyB0aGVtc2VsdmVzIHRoZSBQSFkgb24NCj4+Pj4gc3VzcGVuZC9yZXN1bWUgcGF0aC4gRm9yIHN1
Y2ggZHJpdmVycyB0aGUNCj4+Pj4gc3RydWN0IHBoeV9kZXZpY2U6Om1hY19tYW5hZ2VkX3BoeSBp
cyBzZXQgdG8gdHJ1ZSBhbmQgdGh1cyB0aGUNCj4+Pj4gbWRpb19idXNfcGh5X3N1c3BlbmQoKS9t
ZGlvX2J1c19waHlfcmVzdW1lKCkgd291bGRuJ3QgZG8gdGhlDQo+Pj4+IHByb3BlciBQSFkgc3Vz
cGVuZC9yZXN1bWUuIEZvciBzdWNoIHNjZW5hcmlvcyBjYWxsIHBoeV9pbml0X2h3KCkNCj4+Pj4g
ZnJvbSBwaHlsaW5rX3Jlc3VtZSgpLg0KPj4+Pg0KPj4+PiBTdWdnZXN0ZWQtYnk6IFJ1c3NlbGwg
S2luZyAoT3JhY2xlKSA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPj4+PiBTaWduZWQtb2ZmLWJ5
OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4+Pj4gLS0t
DQo+Pj4+DQo+Pj4+IEhpLCBSdXNzZWwsDQo+Pj4+DQo+Pj4+IEkgbGV0IHBoeV9pbml0X2h3KCkg
dG8gZXhlY3V0ZSBmb3IgYWxsIGRldmljZXMuIEkgY2FuIHJlc3RyaWN0IGl0IG9ubHkNCj4+Pj4g
Zm9yIFBIWXMgdGhhdCBoYXMgc3RydWN0IHBoeV9kZXZpY2U6Om1hY19tYW5hZ2VkX3BoeSA9IHRy
dWUuDQo+Pj4+DQo+Pj4+IFBsZWFzZSBsZXQgbWUga25vdyB3aGF0IHlvdSB0aGluay4NCj4+Pg0K
Pj4+IEkgdGhpbmsgaXQgd291bGQgYmUgYmV0dGVyIHRvIG9ubHkgZG8gdGhpcyBpbiB0aGUgcGF0
aCB3aGVyZSB3ZSBjYWxsDQo+Pj4gcGh5X3N0YXJ0KCkgLSBpZiB3ZSBkbyBpdCBpbiB0aGUgV29M
IHBhdGggKHdoZXJlIHRoZSBQSFkgcmVtYWlucw0KPj4+IHJ1bm5pbmcpLCB0aGVuIHRoZXJlIGlz
IG5vIHBoeV9zdGFydCgpIGNhbGwsIHNvIHBoeV9pbml0X2h3KCkgY291bGQNCj4+PiByZXN1bHQg
aW4gdGhlIFBIWSBub3Qgd29ya2luZyBhZnRlciBhIHN1c3BlbmQvcmVzdW1lIGV2ZW50Lg0KPj4N
Cj4+IFRoaXMgd2lsbCBub3Qgd29yayBhbGwgdGhlIHRpbWUgZm9yIE1BQ0IgdXNhZ2Ugb24gQVQ5
MSBkZXZpY2VzLg0KPj4NCj4+IEFzIGV4cGxhaW5lZCBoZXJlIFsxXSB0aGUgc2NlbmFyaW8gd2hl
cmU6DQo+PiAtIE1BQ0IgaXMgY29uZmlndXJlZCB0byBoYW5kbGUgV29MDQo+PiAtIHRoZSBzeXN0
ZW0gZ29lcyB0byBhIHN1c3BlbmQgbW9kZSAobmFtZWQgYmFja3VwIGFuZCBzZWxmLXJlZnJlc2gg
KEJTUikgaW4NCj4+ICAgb3VyIGNhc2UpIHdpdGggcG93ZXIgY3V0IG9mZiBvbiBQSFkgYW5kIGxp
bWl0ZWQgd2FrZS11cCBzb3VyY2UgKGZldyBwaW5zDQo+PiAgIGFuZCBSVEMgYWxhcm1zKQ0KPj4N
Cj4+IGlzIHN0aWxsIHZhbGlkLiBJbiB0aGlzIGNhc2UgTUFDIElQIGFuZCBNQUMgUEhZIGFyZSBu
b3QgcG93ZXJlZC4gQW5kIGluDQo+PiB0aG9zZSBjYXNlcyBwaHlsaW5rX3Jlc3VtZSgpIHdpbGwg
bm90IGhpdCBwaHlfc3RhcnQoKS4NCj4gDQo+IElmIHRoZSBNQUMgaXMgaGFuZGxpbmcgV29MLCBo
b3cgZG9lcyB0aGUgTUFDIHJlY2VpdmUgdGhlIHBhY2tldCB0bw0KPiB3YWtlIHVwIGlmIHRoZSBQ
SFkgaGFzIGxvc3QgcG93ZXI/DQoNClllcywgdGhpcyBjYW4ndCBoYXBwZW4uDQoNCj4gDQo+IElm
IHRoZSBQSFkgbG9zZXMgcG93ZXIsIHRoZSBNQUMgd29uJ3QgYmUgYWJsZSB0byByZWNlaXZlIHRo
ZSBtYWdpYw0KPiBwYWNrZXQsIGFuZCBzbyBXb0wgd2lsbCBiZSBub24tZnVuY3Rpb25hbCwgYW5k
IHRoZXJlZm9yZSB3aWxsIGJlDQo+IGNvbXBsZXRlbHkgcG9pbnRsZXNzIHRvIHN1cHBvcnQgaW4g
c3VjaCBhIGNvbmZpZ3VyYXRpb24uDQo+IA0KPiBXaGF0IGFtIEkgbWlzc2luZz8NCg0KQXMgZXhw
bGFpbmVkIGluIHRoZSBwcmV2aW91cyB2ZXJzaW9uIFsxXSwgd2UgY3VycmVudGx5IGRvbid0IGlt
cG9zZSBhbnkNCnJlc3RyaWN0aW9uIGxpa2UgdGhpcyBpbiBhcmNoIHNwZWNpZmljIFBNIGNvZGUg
KHRoZSBvbmx5IHBsYWNlIHdoZXJlIHdlIGNhbg0KZGVjaWRlIGlmIGdvaW5nIHRvIEJTUiBhbmQg
ZGV2aWNlX21heV93YWtldXAoKSkuIEkgaGFkIGluIG1pbmQgdG8gZG8gaXQgYXQNCnNvbWUgcG9p
bnQgYnV0IHRob3VnaCB0aGF0IHVzZXIgd2lsbCBoYXZlIHRvIHJlLWRvIGFsbCB0aGUgd2FrZXVw
IHNvdXJjZXMNCnJlY29uZmlndXJhdGlvbiB3aGVuIHN3aXRjaGluZyBiL3cgc3VzcGVuZCBtb2Rl
cyB0aGF0IGN1dCBvciBub3QgUEhZIHBvd2VyLg0KVG8gYmUgY29uc2lzdGVudCB0aGlzIHdpbGwg
aGF2ZSB0byBiZSBkb25lIGZvciBhbGwgZGV2aWNlcyByZWdpc3RlcmVkIGFzDQp3YWtldXAgc291
cmNlcyAoZXhjZXB0IHRoZSBmZXcgcGlucyBhbmQgUlRDIGluIGNhc2UpLiBBbmQgdGhpcyBtYXkg
YmUgYQ0KcGFpbiBmb3IgdXNlcnMuDQoNClsxXQ0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxs
LzQzNzVkNzMzLWVkNDktODY5Yy02MzVmLTBmMGJhNzMwNDI4M0BtaWNyb2NoaXAuY29tLw0KDQo+
IA0KPiAtLQ0KPiBSTUsncyBQYXRjaCBzeXN0ZW06IGh0dHBzOi8vd3d3LmFybWxpbnV4Lm9yZy51
ay9kZXZlbG9wZXIvcGF0Y2hlcy8NCj4gRlRUUCBpcyBoZXJlISA0ME1icHMgZG93biAxME1icHMg
dXAuIERlY2VudCBjb25uZWN0aXZpdHkgYXQgbGFzdCENCg0K
