Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08225A5DDC
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 10:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiH3IQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 04:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbiH3IQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 04:16:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABF47FE52;
        Tue, 30 Aug 2022 01:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661847363; x=1693383363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vfjPWiPZYyN0kB64ZkCSU99z+OxKlfqmIOBJ4QZiXL0=;
  b=Ld0rpH1FSD14zYjMM3dU+GP/1PXoMXt0ZxkwclNiRVFH+pKJ4gQ73ff5
   0VO04ZGAEiWU/JlNvGNyg1kEy7kKNm9xtry04KjtCdqoI7wIHb8d7ktAy
   AssoL1yRdnoK2zmiYmbPvtm5V+LXCT6YxyD6cXCMRilgGqsLyYQUfTubN
   dZtldJuEY9MnzLfXcONYTRxrxrI7DCOqxu3e5C9fLDMeAtcoaorinUWb1
   ebj3QLPEpfI3XwRzngu7Zkmve32kjxard2C72SCTsEJNtVN/kJahD9olz
   FjB9P791BPi+CgLkca5bi3SLsaASA1p4f8gGcL8qBz4rMWAj7QU+RI+WU
   w==;
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="178407321"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Aug 2022 01:16:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 30 Aug 2022 01:16:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 30 Aug 2022 01:16:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKtyeU5SgAAh92xzE+/71b2llI/2VhCRvXU74CN22atWEMQYtPLQZ3O6g5zEgYogB9D/yriw6WiJ+TecKnfvXZiMDyOpANI2IPhmifU6NKUo0R5+7A3rKd5zNiRIVWUcVbeaw/cKcARhjEEyHA4xIdW2vkFtdiNG5etyTHq1zfRZx2U4oF/c1hDBppEEQ6cWDoExZvw1Tow9/iAwSt6be1u0USxd+6knI0uQ8NlT4QHFjbCDfZszrV/EbdW6OPKNXTAHfq8OYroz+h0nwJNV7W40AxGUCYHQ2DdNBvF31wvT+rZ9nKsE+koEdDq9KFDiaz06s34B/ryZEF8ELfMR3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfjPWiPZYyN0kB64ZkCSU99z+OxKlfqmIOBJ4QZiXL0=;
 b=OVCY5tgoNdrowmzL7VA9/vTw45FqBAFI8DMhb+eSA7AwyonZvBTqwnv1OHURZAHdzUNuK+kz/hgN9Dii5/3u+Xg+Z+HGGdOgLPonkKmfpUIvV8JjeQdzo4uP99ne/YLrd8qX4Xu7ekb2tyq4ragi1xYFVvYzt4sKT5ZxghjA4WyEyEPqeQPJB/vPm3Jx2Pkb43Msb9D/qdsGhJvghSGhij/jx0Gtz7oG3TXhF4dX84dZ4qSZ1TTtnQEu90GD3AHdVYUEho+GabWZIFQtmN5ttbL9EBhFhjc+QMZcf4GpRRn9ni7iPfr5fFudp5FhNarvs2Zz/vMVEfh22Oj9hPIJ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfjPWiPZYyN0kB64ZkCSU99z+OxKlfqmIOBJ4QZiXL0=;
 b=ZCdL1tbamGq5hCXGLrObdDXudzVtrrTEBGXg+k94j4ZZoUC9J2vmHQa6TzzPyVHyG6+67XxpyyOGVBFqfv7oCML+GdNEWEgnde77e0o88Ew98WZw0c6IfX5fdWWhLeAScTzZcpYd6MvVhqu0PmAAhJygP1M+fod2pCQAwJpIstM=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BN6PR11MB1265.namprd11.prod.outlook.com (2603:10b6:404:48::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.16; Tue, 30 Aug 2022 08:16:00 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::e828:494f:9b09:6bb5]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::e828:494f:9b09:6bb5%7]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 08:16:00 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <o.rempel@pengutronix.de>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <san@skov.dk>, <olteanv@gmail.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Thread-Topic: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Thread-Index: AQHYnz/JPjfPUKMERUuEDcRFWSApta3HPH+AgAAWeAA=
Date:   Tue, 30 Aug 2022 08:15:59 +0000
Message-ID: <67690ec6367c9dc6d2df720dcf98e6e332d2105b.camel@microchip.com>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
         <20220830065533.GA18106@pengutronix.de>
In-Reply-To: <20220830065533.GA18106@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4b28111-178c-4a07-6eee-08da8a5fdf66
x-ms-traffictypediagnostic: BN6PR11MB1265:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: brVQIiR2Ej8Z9XkTZo9sOYE5PZH8yK1lIuzL727ofZGDHFS6SBMIaqKA4kiYQqWW2DWw73dXRtO2d2IdsnYCsHN5sIMRQTRO7zj+c0H39O9VLWfFnoyl0kqkS/O4gzX2zVL7Q2JvSIwO+B5D2+5Aap3OK6MUV/+bdfuCNINO3itihaOcDfjJX3WxdJF6cmMziS+2H38ltcpQS4xgUbcKCWnVwMILCpvlnxuZf6ahUlFTPAEahnz2I0vuxM20GTyFHRs3c/XgcuRqbLiYGcUfeO0H6tTY83ffdinByYUDNt/5KilHma98AxToxLbLFENBDaCoPkb4mMvMGuI1o0kECog/QTrWeWXOSdDHT3RdvpRf2eRQ4S/3bdfwf60MoO+4m9kKpe0WxZLWbVwTowz/P4JSy0y7/Sp1nAJQrD/vizbAVfERyaKiaBFzBwSxL3uIEzvePhws9LAae/BZMghW/CGuYne3dARhmSKaG5vgSHxAUy+pzAe9qYQw24MVq75TL5F0v4XtJa9tZTvpJs0lO8SCfWpvEfdaI0QrB512mD5I7+fx4cBOnYw1PpztbLg4taKUlV0iVhkxJ5L8Q9pXJ94qIrdahXVWAG6lg/PlZOgDyqp1J0Oenu9kEa2AtMvwnLLTZxvquudz0KXkWZ5zd1TWwopWGdIPH89Q0gFladu2w0/KFZbuoTrhKIwN/Zn9vfW0L29ZHwfLqBAw9t1Ccecc0NXZGZYLcpRLtXA2ZHOXhmwJ71WWzbu8dXm9qATtMXnV6XzB7cnXantsSPo4R5x7a7M051jk9agWoyWqtGvbj7uwVX/zQRXp2LP6qwoa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(396003)(366004)(376002)(346002)(2616005)(186003)(2906002)(83380400001)(122000001)(6916009)(64756008)(316002)(54906003)(45080400002)(91956017)(4326008)(66556008)(76116006)(66446008)(5660300002)(66476007)(66946007)(8676002)(26005)(6506007)(6512007)(966005)(478600001)(6486002)(41300700001)(71200400001)(8936002)(7416002)(36756003)(38070700005)(38100700002)(86362001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEluYm1DMHc0ZVJ6bm9EWElyc2dHd011NG9vZjlxZHh6NkE0M1pJK09WQmww?=
 =?utf-8?B?ZGJBNVJkTysxY0VZWGR6eERMU2hWNTQzT2ZDb0pHUkxnaXVlNmJyT0s3V3Vi?=
 =?utf-8?B?UHByNXdWV0U0MGFUSldEbllveDQ5aThLbDRjbDczcUFaV2pGOTZkbU1SS01K?=
 =?utf-8?B?RW82UENWZ2h0bC9GMVAyYng2eXMvWFQ0d1pxeDRwbDRjdjJ1Nk1yaUFuaTZI?=
 =?utf-8?B?VkR0bkxmYkg3YXN1eXlmMGJwczVPaHY2d1Z5Vkk0ZnpqeVkzV1RwSWFuejQ1?=
 =?utf-8?B?TktTNjRpczFOZXF0eWV5WjhuWWU2MG5GelhTWkxoYUd6L2FGNXFxOE5xdXN3?=
 =?utf-8?B?bGxFYnR0UTNmUVQzMmtVMGV0ajZmSXFSMlNoeGpJVXhPVkd2QTJ3bkdJYXZh?=
 =?utf-8?B?OS8vb0lwbER2WnlkTGVPQlY1WHpiaW1abWlZbDBDcWswVG1DeDhxTTlaWHg4?=
 =?utf-8?B?NkFYU0I4cW9jWndUbTQ4VDNuRmx5OEJzbTVuTWZEY3Ircm9yNytCakZvdUxx?=
 =?utf-8?B?bHJ0K2tnUGhacHlPcmpad2VqcFpkNHJxWk9GajhUZHBKNXdTV1N4NjFXNFha?=
 =?utf-8?B?NTJpcmxmRU56WitvVkxiSUprT0V2Mnk2d2pnQ3pBYjBvL0hhb0xFbFZkSGxP?=
 =?utf-8?B?bjIwbVFqTDhOY3NMSklyOEVmMmx2aXBUcWxUMmFNbnBxZzRVdkhjZmNBbDhp?=
 =?utf-8?B?aEVBVVY1UjFlUUhEM0JTK1liZ2kvUUJaa3VCRWJLRStFSis3Vzg5MkFHQ2Y3?=
 =?utf-8?B?YituSzNYSzE0MjNRdkJUaFhsMVRCRi9DZEZwRW9BSE5vang0bmpDb1NuVHVz?=
 =?utf-8?B?SDZiSHlFcVRuWmJRQlpjZllFWU9rNXU5aEE3YXIyV3lOOWFQM1VCVjhuMldj?=
 =?utf-8?B?TmhZRVRTZmtjN2J0Q2h0a3EvV2tETmxJUVBWaU9jTzVRL2hnYnViRk50L1pk?=
 =?utf-8?B?OTFYN29PLzRYUTBwN0I2ZzEraXJ2NExaM1ExM1V1S0V6Qi9GMDVmQUtQT2VZ?=
 =?utf-8?B?RWZmdG1UVjdnc1BzbDErOG5zMWZpcDhuZFIrbEgrb1U2Q3AvQ21vUnhEWkhv?=
 =?utf-8?B?VG5zbjM1VDJBaUtWaUIxeVFiWFNNRFN4RWtoKzF0MnZ3ZGNpSlQ3VHVRZlF0?=
 =?utf-8?B?VUh0cHV4VTI3c2YxdUNSTTJ0dllCUk1VOURlOE1iN2Fnb2laQm0yWGx5WDB3?=
 =?utf-8?B?b2NHT2UraWlkVi9oM0Z2cHY2UDhDRHFDVGJia3pSMStnUVlkMU1GTU50N0Zj?=
 =?utf-8?B?Y2owQVpyZWFNdjkwYklRT2o3MVAydUI0dXd1SVA5ZFlWYTJYSWtpV3cxbURL?=
 =?utf-8?B?VDRqT1RySDhuUUt1RGhOMFJDWjA2MEs3L0F0QTI3VnB5V05OdU5xbU5iNWNx?=
 =?utf-8?B?aHFsWkZoN1lNODR6WkNNQ0RWU0Q0WU5kZVlhd3ZQeGpoTzZBRWhEeU82M1hQ?=
 =?utf-8?B?WDBvNVAzZUJJazdMaG1MWm5zYjc1TWpHVnRxdGhKK1FYcTdqV2ZnOCtzbDl6?=
 =?utf-8?B?QXl5QlJFSno0di9LcW1sV3BvTFRuRGxMY0MweHpqdTRQOEJ2YXRhWVFaU2Zp?=
 =?utf-8?B?NnQrTGxnbFNycUo1T0dPZzZFdWpFampsdzg0cHlkME9DN1B6eURKLzBXeVVa?=
 =?utf-8?B?N0FJK1RmY0VVSEw3aExDNXI3NVJRZGw5Zm1DS2tUU1lCbENwNHppU3JManND?=
 =?utf-8?B?dmVDR24yRHBhQ1hmNWt0c3YrN0lTKzJYeGt1R2FBSUFuaUx3QTVpcGc4cEEz?=
 =?utf-8?B?dHNkNWNXcTNWMVFVVW51aHNtcXdBUk9icGFLR0w1UHJ3V0oyN3R5dWRhK2JR?=
 =?utf-8?B?TElRTkp4OEZDdEpkUnFuMkpBRUhVZ1d1K2k1UVc3V0hXazlLMEVBa3J5UWhK?=
 =?utf-8?B?YXR4TFBSb0cxTUpuaDRQem5WWjBhb0JhT2k4M2wycVNORmtSdm9VVEdYMGhs?=
 =?utf-8?B?OEd6REdWV3cxK2VxUXppemJxd1FsU0g1K3lYLzQ4T250MmlrSE1LWUt2cXZS?=
 =?utf-8?B?eU9tN0tiTkVsTVBISkp6SmtaSTZVVmFIaWlqUEJRSDIrR0VBbkZnMkYyeng2?=
 =?utf-8?B?M2w0TDFyQmx6V0ZtV0wrZlAxK2Q5WGtUOVBsWnZrMU1kN01lSDhtSC82Q3ov?=
 =?utf-8?B?aXZYclBLUXhjMkZIVWZjR1ZHL0xDU2VaNVRkNUhrQ1ZSd29DM3haZldWTU5r?=
 =?utf-8?Q?8YUZfSu0v5o/yYah3F+B9go=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5143367A661B441866232FF9EA8FC30@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b28111-178c-4a07-6eee-08da8a5fdf66
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 08:16:00.0279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N3nunk0j4+qdl6hr8EGy4SHfFWRIZIpaVX4oAdPU9TIsLuQkeuX7mjEtpthTLgbxkXO6ohZr+RRWFLqK1fb2gmG+gJ5YRmgypPZKiDLlXzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1265
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCklzIHRoaXMgQnVnIHJlbGF0ZWQgdG8gZml4IGluIA0KaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGttbC8yMDIyMDgyOTEwNTgxMC41Nzc5MDM4MjNAbGludXhmb3VuZGF0aW9u
Lm9yZy8NCi4gDQpJdCBpcyBvYnNlcnZlZCBpbiBrc3o4Nzk0IHN3aXRjaC4gSSB0aGluayBhZnRl
ciBhcHBseWluZyB0aGlzIGJ1ZyBmaXgNCnBhdGNoIGl0IHNob3VsZCB3b3JrLiBJIGRvbid0IGhh
dmUga3N6OCBzZXJpZXMgdG8gdGVzdC4gSSByYW4gdGhlDQpyZWdyZXNzaW9uIG9ubHkgZm9yIGtz
ejkgc2VyaWVzIHN3aXRjaGVzLiANCg0KDQpPbiBUdWUsIDIwMjItMDgtMzAgYXQgMDg6NTUgKzAy
MDAsIE9sZWtzaWogUmVtcGVsIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNr
IGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50
IGlzIHNhZmUNCj4gDQo+IEhpIEFydW4sDQo+IA0KPiBzdGFydGluZyB3aXRoIHRoaXMgcGF0Y2gg
c2V0IEkgaGF2ZSBmb2xsb3dpbmcgcmVncmVzc2lvbiBvbiBrc3o4ODczDQo+IHN3aXRjaC4gQ2Fu
IHlvdSBwbGVhc2UgdGFrZSBhIGxvb2sgYXQgaXQ6DQo+ICA4PC0tLSBjdXQgaGVyZSAtLS0NCj4g
IFVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCB2aXJ0
dWFsIGFkZHJlc3MNCj4gMDAwMDAwMDUNCj4gIGtzejg4NjMtc3dpdGNoIGdwaW8tMDowMDogbm9u
ZmF0YWwgZXJyb3IgLTM0IHNldHRpbmcgTVRVIHRvIDE1MDAgb24NCj4gcG9ydCAwDQo+IC4uLg0K
PiAgTW9kdWxlcyBsaW5rZWQgaW46DQo+ICBDUFU6IDAgUElEOiAxNiBDb21tOiBrd29ya2VyLzA6
MSBOb3QgdGFpbnRlZCA2LjAuMC1yYzItMDA0MzYtDQo+IGczZGEyODVkZjEzMjQgIzc0DQo+ICBI
YXJkd2FyZSBuYW1lOiBGcmVlc2NhbGUgaS5NWDYgUXVhZC9EdWFsTGl0ZSAoRGV2aWNlIFRyZWUp
DQo+ICBXb3JrcXVldWU6IGV2ZW50c19wb3dlcl9lZmZpY2llbnQgcGh5bGlua19yZXNvbHZlDQo+
ICBQQyBpcyBhdCBrc3pfc2V0X2diaXQrMHg1Yy8weGE0DQo+ICBMUiBpcyBhdCBhcmNoX2F0b21p
Y19jbXB4Y2hnX3JlbGF4ZWQrMHgxYy8weDM4DQo+IC4uLi4NCj4gIEJhY2t0cmFjZToNCj4gICBr
c3pfc2V0X2diaXQgZnJvbSBrc3pfcGh5bGlua19tYWNfbGlua191cCsweDE1Yy8weDFjOA0KPiAg
IGtzel9waHlsaW5rX21hY19saW5rX3VwIGZyb20gZHNhX3BvcnRfcGh5bGlua19tYWNfbGlua191
cCsweDdjLzB4ODANCj4gICBkc2FfcG9ydF9waHlsaW5rX21hY19saW5rX3VwIGZyb20gcGh5bGlu
a19yZXNvbHZlKzB4MzA0LzB4M2QwDQo+ICAgcGh5bGlua19yZXNvbHZlIGZyb20gcHJvY2Vzc19v
bmVfd29yaysweDIxNC8weDMxYw0KPiAgIHByb2Nlc3Nfb25lX3dvcmsgZnJvbSB3b3JrZXJfdGhy
ZWFkKzB4MjU0LzB4MmQ0DQo+ICAgd29ya2VyX3RocmVhZCBmcm9tIGt0aHJlYWQrMHhmYy8weDEw
OA0KPiAgIGt0aHJlYWQgZnJvbSByZXRfZnJvbV9mb3JrKzB4MTQvMHgyYw0KPiAuLi4NCj4gIGtz
ejg4NjMtc3dpdGNoIGdwaW8tMDowMCBsYW4yICh1bmluaXRpYWxpemVkKTogUEhZIFtkc2EtMC4w
OjAxXQ0KPiBkcml2ZXIgW01pY3JlbCBLU1o4ODUxIEV0aGVybmV0IE1BQyBvciBLU1o4ODZYIFN3
aXRjaF0gKGlycT1QT0xMKQ0KPiAga3N6ODg2My1zd2l0Y2ggZ3Bpby0wOjAwOiBub25mYXRhbCBl
cnJvciAtMzQgc2V0dGluZyBNVFUgdG8gMTUwMCBvbg0KPiBwb3J0IDENCj4gIGRldmljZSBldGgw
IGVudGVyZWQgcHJvbWlzY3VvdXMgbW9kZQ0KPiAgRFNBOiB0cmVlIDAgc2V0dXANCj4gIC0tLVsg
ZW5kIHRyYWNlIDAwMDAwMDAwMDAwMDAwMDAgXS0tLQ0KPiANCj4gUmVnYXJkcywNCj4gT2xla3Np
ag0KPiANCj4gT24gU3VuLCBKdWwgMjQsIDIwMjIgYXQgMDI6NTg6MTRQTSArMDUzMCwgQXJ1biBS
YW1hZG9zcyB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIHNlcmllcyBhZGQgc3VwcG9ydCBjb21tb24g
cGh5bGluayBtYWMgY29uZmlnIGFuZCBsaW5rIHVwDQo+ID4gZm9yIHRoZSBrc3oNCj4gPiBzZXJp
ZXMgc3dpdGNoZXMuIEF0IHByZXNlbnQsIGtzejg3OTUgYW5kIGtzejk0NzcgZG9lc24ndCBpbXBs
ZW1lbnQNCj4gPiB0aGUgcGh5bGluaw0KPiA+IG1hYyBjb25maWcgYW5kIGxpbmsgdXAuIEl0IGNv
bmZpZ3VyZXMgdGhlIG1hYyBpbnRlcmZhY2UgaW4gdGhlIHBvcnQNCj4gPiBzZXR1cCBob29rLg0K
PiA+IGtzejg4MzAgc2VyaWVzIHN3aXRjaCBkb2VzIG5vdCBtYWMgbGluayBjb25maWd1cmF0aW9u
LiBGb3IgbGFuOTM3eA0KPiA+IHN3aXRjaGVzLCBpbg0KPiA+IHRoZSBwYXJ0IHN1cHBvcnQgcGF0
Y2ggc2VyaWVzIGhhcyBzdXBwb3J0IG9ubHkgZm9yIE1JSSBhbmQgUk1JSQ0KPiA+IGNvbmZpZ3Vy
YXRpb24uDQo+ID4gU29tZSBncm91cCBvZiBzd2l0Y2hlcyBoYXZlIHNvbWUgcmVnaXN0ZXIgYWRk
cmVzcyBhbmQgYml0IGZpZWxkcw0KPiA+IGNvbW1vbiBhbmQNCj4gPiBvdGhlcnMgYXJlIGRpZmZl
cmVudC4gU28sIHRoaXMgcGF0Y2ggYWltcyB0byBoYXZlIGNvbW1vbiBwaHlsaW5rDQo+ID4gaW1w
bGVtZW50YXRpb24NCj4gPiB3aGljaCBjb25maWd1cmVzIHRoZSByZWdpc3RlciBiYXNlZCBvbiB0
aGUgY2hpcCBpZC4NCj4gPiBDaGFuZ2VzIGluIHYyDQo+ID4gLSBjb21iaW5lZCB0aGUgbW9kaWZp
Y2F0aW9uIG9mIGR1cGxleCwgdHhfcGF1c2UgYW5kIHJ4X3BhdXNlIGludG8NCj4gPiBzaW5nbGUN
Cj4gPiAgIGZ1bmN0aW9uLg0KPiA+IA0KPiA+IENoYW5nZXMgaW4gdjENCj4gPiAtIFNxdWFzaCB0
aGUgcmVhZGluZyByZ21paSB2YWx1ZSBmcm9tIGR0IHRvIHBhdGNoIHdoaWNoIGFwcGx5IHRoZQ0K
PiA+IHJnbWlpIHZhbHVlDQo+ID4gLSBDcmVhdGVkIHRoZSBuZXcgZnVuY3Rpb24ga3N6X3BvcnRf
c2V0X3htaWlfc3BlZWQNCj4gPiAtIFNlcGVyYXRlZCB0aGUgbmFtZXNwYWNlIHZhbHVlcyBmb3Ig
eG1paV9jdHJsXzAgYW5kIHhtaWlfY3RybF8xDQo+ID4gcmVnaXN0ZXINCj4gPiAtIEFwcGxpZWQg
dGhlIHJnbWlpIGRlbGF5IHZhbHVlIGJhc2VkIG9uIHRoZSByeC90eC1pbnRlcm5hbC1kZWxheS0N
Cj4gPiBwcw0KPiA+IA0KPiA+IEFydW4gUmFtYWRvc3MgKDkpOg0KPiA+ICAgbmV0OiBkc2E6IG1p
Y3JvY2hpcDogYWRkIGNvbW1vbiBnaWdhYml0IHNldCBhbmQgZ2V0IGZ1bmN0aW9uDQo+ID4gICBu
ZXQ6IGRzYTogbWljcm9jaGlwOiBhZGQgY29tbW9uIGtzeiBwb3J0IHhtaWkgc3BlZWQgc2VsZWN0
aW9uDQo+ID4gZnVuY3Rpb24NCj4gPiAgIG5ldDogZHNhOiBtaWNyb2NoaXA6IGFkZCBjb21tb24g
ZHVwbGV4IGFuZCBmbG93IGNvbnRyb2wgZnVuY3Rpb24NCj4gPiAgIG5ldDogZHNhOiBtaWNyb2No
aXA6IGFkZCBzdXBwb3J0IGZvciBjb21tb24gcGh5bGluayBtYWMgbGluayB1cA0KPiA+ICAgbmV0
OiBkc2E6IG1pY3JvY2hpcDogbGFuOTM3eDogYWRkIHN1cHBvcnQgZm9yIGNvbmZpZ3VpbmcgeE1J
SQ0KPiA+IHJlZ2lzdGVyDQo+ID4gICBuZXQ6IGRzYTogbWljcm9jaGlwOiBhcHBseSByZ21paSB0
eCBhbmQgcnggZGVsYXkgaW4gcGh5bGluayBtYWMNCj4gPiBjb25maWcNCj4gPiAgIG5ldDogZHNh
OiBtaWNyb2NoaXA6IGtzejk0Nzc6IHVzZSBjb21tb24geG1paSBmdW5jdGlvbg0KPiA+ICAgbmV0
OiBkc2E6IG1pY3JvY2hpcDoga3N6ODc5NTogdXNlIGNvbW1vbiB4bWlpIGZ1bmN0aW9uDQo+ID4g
ICBuZXQ6IGRzYTogbWljcm9jaGlwOiBhZGQgc3VwcG9ydCBmb3IgcGh5bGluayBtYWMgY29uZmln
DQo+ID4gDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jICAgICAgfCAg
NDAgLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NV9yZWcuaCAgfCAg
IDggLQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYyAgICAgIHwgMTgz
ICstLS0tLS0tLS0tLS0NCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X3Jl
Zy5oICB8ICAyNCAtLQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24u
YyAgIHwgMzEyDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKy0NCj4gPiAgZHJpdmVycy9uZXQv
ZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmggICB8ICA1NCArKysrDQo+ID4gIGRyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAvbGFuOTM3eC5oICAgICAgfCAgIDggKy0NCj4gPiAgZHJpdmVycy9uZXQv
ZHNhL21pY3JvY2hpcC9sYW45Mzd4X21haW4uYyB8IDEyNSArKystLS0tLS0NCj4gPiAgZHJpdmVy
cy9uZXQvZHNhL21pY3JvY2hpcC9sYW45Mzd4X3JlZy5oICB8ICAzMiArKy0NCj4gPiAgOSBmaWxl
cyBjaGFuZ2VkLCA0MzEgaW5zZXJ0aW9ucygrKSwgMzU1IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+
IA0KPiA+IGJhc2UtY29tbWl0OiA1MDJjNmY4Y2VkY2NlNzg4OWNjZGVmZWI4OGNlMzZiMzlhY2Q1
MjJmDQo+ID4gLS0NCj4gPiAyLjM2LjENCj4gPiANCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4DQo+
IGUuSy4gICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8DQo+IFN0ZXVlcndhbGRlciBTdHIuIDIxICAgICAgICAgICAgICAgICAgICAgICB8IA0K
PiBodHRwOi8vd3d3LnBlbmd1dHJvbml4LmRlL2UvICB8DQo+IDMxMTM3IEhpbGRlc2hlaW0sIEdl
cm1hbnkgICAgICAgICAgICAgICAgICB8IFBob25lOiArNDktNTEyMS0yMDY5MTctDQo+IDAgICAg
fA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiAgICAgICAgICAgfCBGYXg6ICAg
KzQ5LTUxMjEtMjA2OTE3LQ0KPiA1NTU1IHwNCg==
