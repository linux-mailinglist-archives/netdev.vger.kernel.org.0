Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F3053961D
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 20:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346957AbiEaSTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 14:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242745AbiEaSTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 14:19:45 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D42996B6;
        Tue, 31 May 2022 11:19:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVN4Uqw8J7Z9MqtR3CTCS0lAqrxIHS/N1GeH1NiXWDtQCf9lg7s/3KntUf01Uzw7/McCX9DjHAh2mkE9mZ+eqDr75GhS+EzEChNHs4+tyi5y8+CSHnnT23xhNaJL8Rk1oC6cdRIqB2UqeVyRgGtxPScMJgRYcd73YddyZNV1q3Jhv2f4oqggMYcAjSWFfW8Cl5vSrj1aKeXitVvi4uMlskDIut4r4T44eJZrVkqWHME2vviFNCKkw7Ec5bhvBaiSLl47QaobcUa/qwjCurQ+99kgVX1Rb+XATN/AKMvZB3zADlIf8idNq4/zhwcV5/wxxVoGcXMdw6CqpoJH8kX2JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmPAt/6AFSC+9+v+nNsh2MfnPX2fLNhXGrejOr8UWm0=;
 b=Qyr4Hc1ucSk7Gl6vpxDpp2xdlNhLmwxcU4udadPsa2+XHFePq05ryBcko+WWOXuLvmeJu8RQZxkPiPv0CR/u5g2fgDoE8xXewRNohuoj/jMZ70xsy4WF2pbyWyggXMZq42npaFVL1EamML4dgYLizJS2imSIap1X6Tzf9cZqb2sngqPNTHuG4Xr20zoQ5sQt7zLXIuk+D+kfDn8nGBlcquV/P1QpmBLV8uJzyHMDdzDbqdKRsXHzzPe6euK2C6Cg8Hat9uN9Ro+5UDnMvBiJLMixz7r3doTGaIrKzdURTLM8i9m8WT/Ckr5fXIuHlPxrA9Qe3Dp30WcCgrgShABkvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmPAt/6AFSC+9+v+nNsh2MfnPX2fLNhXGrejOr8UWm0=;
 b=JgZxo9KhJOUGb1b6IvAxByl5echie125C6jwElVyx6rFNekpoSXINYWbXFtIE3FIrBgy5n+zJMuykCd+cctVH9QoDGryg56CmVnU/k+mUdudES/esH7TAbx6fjTo5MufvisvIbPCFpNc6z/delBjEHR08klbE7PER9b1FL7gLTI=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by DM6PR02MB6746.namprd02.prod.outlook.com (2603:10b6:5:21b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 31 May
 2022 18:19:35 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798%8]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 18:19:35 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "harini.katakam@amd.com" <harini.katakam@amd.com>,
        "michal.simek@amd.com" <michal.simek@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git@amd.com" <git@amd.com>
Subject: RE: [PATCH net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Thread-Topic: [PATCH net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Thread-Index: AQHYbBrHRnAzUOGCX0i3+N8bgO5RS60peu4AgA3uL0CAAHBFAIABerOA
Date:   Tue, 31 May 2022 18:19:35 +0000
Message-ID: <SA1PR02MB856087686FE497BDCE413E89C7DC9@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <1653031473-21032-1-git-send-email-radhey.shyam.pandey@amd.com>
 <5c426fdc-6250-60fe-6c10-109a0ceb3e0c@linaro.org>
 <SA1PR02MB85602AA1C1A0157A2F0DA28BC7DD9@SA1PR02MB8560.namprd02.prod.outlook.com>
 <6f3d43ca-c980-851d-e7b2-869371a1f4ec@linaro.org>
In-Reply-To: <6f3d43ca-c980-851d-e7b2-869371a1f4ec@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c85b0cc3-cacd-435a-3981-08da43321db3
x-ms-traffictypediagnostic: DM6PR02MB6746:EE_
x-microsoft-antispam-prvs: <DM6PR02MB6746F35F1A590FACC9278C40C7DC9@DM6PR02MB6746.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aOzrAWxc3KrvdF2Dsynxs7kFBP3yXxX5bPdgnhwoNvgs7eHq1YzzRX2iRn+0TlEpbDHYItoPOeeikjX5bZC2c7bHoSuWCm8vRShu41jAeGnxHAndiXkqemUoagAy9eY+pFNtIAkVwN3tJ+0R+nGS3D3cs4HHrXo4u825mwQW8liD8PQjPtHK9awb/8zHZJkLIZnqy5WRcqIE4WAXgkfDH7vmTuUK1N+rHmJd0qZnBt9vXpqIWHToydlj3ugp4rdXeg7xosZI9TxuGLMDNBlhhixvBmSYIMH0NL/9DARBkpxq4z+NStuGbwwIhi18cMLEPwxci2ElV/zekuaRJ9Bw976tEaxviEdOrhAngMS3ryL9ysa8Gv406/f/OqPKdDKZYS4xdAts7oTFt4mUlC6tfRwjnvb/WBmtDMzxI5IIavXMXFHOzQw7QPR8Y6e4gVxpJhcnsWS8mrBrwuGJixt/srxi/UyK+ET0XxRFydJ/hViFfQwlLryvWIRaV1clVRNbexcfybx75kKSC/Xr+kdjbzyKvYRuP4ovSKVdAkyTNWb0C4Kk9XVJkf/s20/+wezVnKeA2qj3N/pxYEar072q3EsIzxE6rt4wwXDNRbatv6PPREi1LlSnXfx4fxVp4YUU66W47kGP74ejcPr+WGlSB0EpSw6rbdGSumIbq8ZsbuTNkL7fONCy973+xUYVd/AuXx7OsxBvJwH9aTIjqY35skKjiXOxgbzq1lTXgaVzMVWFZNh1+/Hf7TdMvvYzNVrqMZ7/67rb5ROG6A5yQ7ZdFaL2bk5no1tUqzI8xRhis/Oe7wiIh27PmBubUEPIGAYS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(186003)(38100700002)(38070700005)(71200400001)(122000001)(64756008)(7416002)(76116006)(66556008)(7696005)(5660300002)(66446008)(4326008)(66946007)(66476007)(52536014)(83380400001)(8936002)(316002)(9686003)(33656002)(54906003)(8676002)(2906002)(110136005)(53546011)(6506007)(508600001)(966005)(921005)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3BZSDlHRTlwbU5sQ1lSMlhaV3prWXg0Q1hlTjNQNUJMTG4yZGVLWklnSHdB?=
 =?utf-8?B?eDhwSGVmQjA0c3hVLzMwTFNoY0psVkdndlVDS3R5T2hIVVAwVWI2dk1LTXpD?=
 =?utf-8?B?b2I3a25BcUlzNXk0d1A2RmZ2dmt0QWxSRmVWMDdoZ2o5Umg1QW5rY2pEOGEz?=
 =?utf-8?B?NEg0Y1k4Wko5YmpwRUVtNUF2NmJhN05iSlRXZncrVzQ2cDBBVnJTSGlMRzRZ?=
 =?utf-8?B?aWg5eXBrdjNSMmxXaEJ5TERWUmlMR0xHUWFLVXY2NVdMbTVmbTd4UXAzaWNL?=
 =?utf-8?B?UHIzWkFYWk85K3R0b0pjR0h0MEVGVUlmME9GWThHays0MTNZL2ZCa3NoS2JP?=
 =?utf-8?B?YmRwTEUxbTBSb1FKdTNtMk8vSzZvQXA4bkJ2REEvN29ud0FPWTNONGUyTUsr?=
 =?utf-8?B?djFjQzcwN2FEaWVaSkYrQVZLdzg3a3FkeUlNZ3JNbEpmK3RzWDFsTDRQaE9K?=
 =?utf-8?B?S1ErQU9MUFZKRHcyVldYTDVFZ0w1aTBXenUwVnFOTVlqZlQ1UHUzRmFoWThO?=
 =?utf-8?B?YVpqUnpNSkJ4SGxkNi90UUFtS2pUeGhGME9BTFFOalluRzZpZVQ2RFRYMkpP?=
 =?utf-8?B?aG9FOUJ6aVBod0ptODdOeENVNlFNR21uS2JJZ0oxcmZBSGJDeFowdHY3ZmVR?=
 =?utf-8?B?V1UwQkp2d0xPQUJwY3hWZDFsbjQrcUVqVVg4bVoydzNtajVDOWFEK1Q0Mjgx?=
 =?utf-8?B?ZGw2dDFBUm1LSmM3WlRWTmEwSlpYVHkyd004NDhPOW5zd0Z3alZpcFloMnlC?=
 =?utf-8?B?TjE1UGhTMUtiVmh1S3g0S1N3VW1KdmwyR3Q2emdTNlo0TEZUMHY2OXZGay9T?=
 =?utf-8?B?UTR2ZFMyN040LzRKellOSUZxcUFEbWZKcnczYU5nci8vaTJlTm9DelFiRUhI?=
 =?utf-8?B?RjdBVnpOcExLc0o2UGNBZjVtTnBPWnZ5eWV4bUVsck9lV3krRGlzMEl1OVFj?=
 =?utf-8?B?eUpLSDdUQ2pmRTNZYlNBaUJRTEZCRXlrcUI5TTdpOGY5YUNnVUg3dWs0Ym8z?=
 =?utf-8?B?SE9QQUl2b2pTSlJsbnIvN1YzclJxN1h5UUMzdDhZaXRobkFQNVRUUURSbkdx?=
 =?utf-8?B?K0krVDJhazVMVndWVXpqRGRzL04xZUkvbVR4SEcvZTZHakJMMkhwWVV3Sm85?=
 =?utf-8?B?emRCYU9xV2cra1A2cTljMGY3WlVPREVpWTBuWE1VVm1oVjlZVVYxM3FCVENx?=
 =?utf-8?B?dEdIS1ZhSDNXZUx6VTFOTWxZZ1dpU0FXd2ZhOVkwZVdlVmRyRDlhUENITTRO?=
 =?utf-8?B?dGs4ZXBqSVFUcUNudzJxRlRhSmljU2VWemJxaHlsd3MxRGJGNlRXNUI5NWJ6?=
 =?utf-8?B?cmw5SVJONjRlOVVNSEZVTGFybjc3bHArcUcrWUlmNDlSMlA1SEV4VnZVd3pQ?=
 =?utf-8?B?ZHpoNnpvVXJEdFI2MmlQUndQWXF3eVB0UitQUXpDMVFxSnd3d3dsakRTUXJo?=
 =?utf-8?B?dXMyR1doMHRnRG9iWHZ2U3VrTnhEcXNEeVpvcUFHVURQdk94eHo2NVVib3Q3?=
 =?utf-8?B?TGNjN29XaXhsZXVwalNySDF5aHY2QlB1WU4waXRldmJoemhHYVZpK0tJdnZF?=
 =?utf-8?B?S2lQQU0zeVhoUXM5aEV4VEY2Q3YyN01wc0x1RTFGSEZFV3pZWWNsVVYvZzEr?=
 =?utf-8?B?aTFoK2Q3blI4ZmZkajl5SFhQUFZ3VEVnOXd2OHc2VXpHMkFaSWx3aGhnUXRK?=
 =?utf-8?B?YXFEMU50RDJrb1hOdEU0SEFjSk5xUTBUb3FST2ZGK1k0cFh3dW9XbjlqSVJs?=
 =?utf-8?B?cHI2MDNGbXUwL2szc0N6NnBsdWNOZzVYRG8rQzVCYjZzbFVIV1E4eWpsZUtP?=
 =?utf-8?B?NW1maTBBMjF6ZkluY0UzZnFmM2ZOU1RmNU9XQUNwa0lXVGU5RWlhTXlkbmp0?=
 =?utf-8?B?MkxacnFsWUJraWkyOTNTRnBvak1weEVBNzA5VHoxd2UyeTVtY3FYckxkTjg4?=
 =?utf-8?B?RmxYYWtHVUE1cDVtRFErTW5IQ2p0bmZLSUpxVHFmazY0ZzdNUm1renVabWhG?=
 =?utf-8?B?a2grM2hlK0JUeW5xdVFLK1JLL0h6dFZvREUxUzQ3bVhGQjRRcjlMbmJhakFJ?=
 =?utf-8?B?RnJVdVhEYktYNjRGZGh4RzhSM3lqeVplYlhBY3NnVHcwVEtvOWkzSkdXN25H?=
 =?utf-8?B?Vzh1TGZ6ajluQ0tjait5Wld6bm94NXF6cVZzTkUrVkdxYTFHN3pQMnNnRWV3?=
 =?utf-8?B?S1lYTC8yNlhsRVROTi9RYkVNUFR5SmVHQkIvLy9MVnNPSXRvemNYZnk1YjdR?=
 =?utf-8?B?WjRDeC9ycFJzZGx3NEZZYVBVenpJSkdKdDRUcmhYNHJQQUVYUzg0ZGZ2a1Nz?=
 =?utf-8?B?ZmNwSUVyRUpUTUY5dndyQ0VnNmlCZFQ4bVBLNWZwOXJIckJiM2ZJTHBOMkE1?=
 =?utf-8?Q?UBPtpIyVwBYDkdX4c1xedzNBAYbBS/LWp0LoIpBL1qmwr?=
x-ms-exchange-antispam-messagedata-1: IBFi7mEvvigMHQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c85b0cc3-cacd-435a-3981-08da43321db3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2022 18:19:35.1432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aIvNWavac5LazEZkiw3/zbKfD23F1zmQJYKzxhSsn06YnaJ6T1+1USWZmg7qgjtuyTO7v+8il0jQdDPv/DstYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6746
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tp
IDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQo+IFNlbnQ6IFR1ZXNkYXksIE1heSAz
MSwgMjAyMiAxMjo0MCBBTQ0KPiBUbzogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5c0B4aWxp
bnguY29tPjsgUmFkaGV5IFNoeWFtIFBhbmRleQ0KPiA8cmFkaGV5LnNoeWFtLnBhbmRleUBhbWQu
Y29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBr
ZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gcm9iaCtkdEBrZXJuZWwub3JnOyBrcnp5
c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7DQo+IGhhcmluaS5rYXRha2FtQGFtZC5jb207
IG1pY2hhbC5zaW1la0BhbWQuY29tDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZp
Y2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7
IGdpdEBhbWQuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIGR0LWJpbmRpbmdz
OiBuZXQ6IHhpbGlueDogZG9jdW1lbnQgeGlsaW54IGVtYWNsaXRlDQo+IGRyaXZlciBiaW5kaW5n
DQo+IA0KPiBPbiAzMC8wNS8yMDIyIDE1OjIxLCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdyb3RlOg0K
PiA+Pg0KPiA+Pj4gKyAgICAgICAgbG9jYWwtbWFjLWFkZHJlc3MgPSBbMDAgMGEgMzUgMDAgMDAg
MDBdOw0KPiA+Pg0KPiA+PiBFYWNoIGRldmljZSBzaG91bGQgZ2V0IGl0J3Mgb3duIE1BQyBhZGRy
ZXNzLCByaWdodD8gSSB1bmRlcnN0YW5kIHlvdQ0KPiA+PiBsZWF2ZSBpdCBmb3IgYm9vdGxvYWRl
ciwgdGhlbiBqdXN0IGZpbGwgaXQgd2l0aCAwLg0KPiA+DQo+ID4gVGhlIGVtYWNsaXRlIGRyaXZl
ciB1c2VzIG9mX2dldF9ldGhkZXZfYWRkcmVzcygpIHRvIGdldCBtYWMgZnJvbSBEVC4NCj4gPiBp
LmUgICdsb2NhbC1tYWMtYWRkcmVzcycgaWYgcHJlc2VudCBpbiBEVCBpdCB3aWxsIGJlIHJlYWQg
YW5kIHRoaXMgTUFDDQo+ID4gYWRkcmVzcyBpcyBwcm9ncmFtbWVkIGluIHRoZSBNQUMgY29yZS4g
U28gSSB0aGluayBpdCdzIG9rIHRvIGhhdmUgYQ0KPiA+IHVzZXIgZGVmaW5lZCBtYWMtYWRkcmVz
cyAoaW5zdGVhZCBvZiAwcykgaGVyZSBpbiBEVCBleGFtcGxlPw0KPiANCj4gQW5kIHlvdSB3YW50
IHRvIHByb2dyYW0gdGhlIHNhbWUgTUFDIGFkZHJlc3MgaW4gZXZlcnkgZGV2aWNlIGluIHRoZSB3
b3JsZD8NCj4gSG93IHdvdWxkIHRoYXQgd29yaz8NCg0KSSBhZ3JlZSwgZm9yIG1vc3Qgb2YgcHJh
Y3RpY2FsIHVzZWNhc2VzIG1hYyBhZGRyZXNzIHdpbGwgYmUgc2V0IGJ5IGJvb3Rsb2FkZXJbMV0u
DQpCdXQganVzdCB0aGlua2luZyBmb3IgdXNlY2FzZXMgd2hlcmUgdWJvb3QgY2FuJ3QgcmVhZCBm
cm9tIG5vbi12b2xhdGlsZSBtZW1vcnkNCnVzZXIgYXJlIHN0aWxsIHByb3ZpZGVkIHdpdGggb3B0
aW9uIHRvIHNldCBsb2NhbC1tYWMtYWRkcmVzcyBpbiBEVCBhbmQgbGV0IGxpbnV4DQphbHNvIGNv
bmZpZ3VyZXMgaXQ/IEFsc28gc2VlIHRoaXMgaW4gY291cGxlIG9mIG90aGVyIG5ldHdvcmtpbmcg
ZHJpdmVyIGV4YW1wbGVzLiANCg0KY2RucyxtYWNiLnlhbWw6ICBsb2NhbC1tYWMtYWRkcmVzczog
dHJ1ZQ0KY2RucyxtYWNiLnlhbWw6ICAgICAgICAgICAgbG9jYWwtbWFjLWFkZHJlc3MgPSBbM2Eg
MGUgMDMgMDQgMDUgMDZdOw0KYnJjbSxzeXN0ZW1wb3J0LnlhbWw6ICAgICAgICBsb2NhbC1tYWMt
YWRkcmVzcyA9IFsgMDAgMTEgMjIgMzMgNDQgNTUgXTsNCg0KSW4gZW1hY2xpdGUgeWFtbCAtIGFz
IGl0IGFuIGV4YW1wbGUgSSB3aWxsIHNldCBpdCBtYWMtYWRkcmVzcyB0byAwIHRvIGFsaWduIA0K
d2l0aCBjb21tb24gdXNlY2FzZS4gIGxvY2FsLW1hYy1hZGRyZXNzID0gWzAwIDAwIDAwIDAwIDAw
IDAwXQ0KDQpbMV06IGh0dHBzOi8vc3VwcG9ydC54aWxpbnguY29tL3MvYXJ0aWNsZS81MzQ3Ng0K
DQo+IA0KPiANCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gS3J6eXN6dG9mDQo=
