Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E0558682F
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 13:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiHALfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 07:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiHALfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 07:35:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B891929A;
        Mon,  1 Aug 2022 04:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659353741; x=1690889741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XfPbF+75kore5kYnVE6p20mKqA3CdKS2Eg+AEonRVfc=;
  b=N9jrskI5W2AfyA3EzPhqMIKPklvgGDE8kihU/V7ydeKKG0WkXGlg6JXk
   TGV1HyJb/NuY1ry5EzWhJyCiou72G0/DGXKvFcXxPvnCIz0oO/9r445bk
   +22NPXU4iz5DjYFPMU/BtLRxAkz1oAykHbmFHtRoX99ddZeSkHfP3h6k+
   1kClq872DtYk63G2jOfWGT9YW1j4iDhQMcNInLtt3RPd41DDm4aaye90f
   YTXYIJrzn3GuQiaL2FyJzx2QcaUa+QUQK/weVHnCHaLeeuBhAPSGWIGwa
   KkCGO2CY46nUiNda4SJW4PuxJHQ0Li+fRYq/G97d5fsnJh8GhSj609GF4
   w==;
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="167257886"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Aug 2022 04:35:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 1 Aug 2022 04:35:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 1 Aug 2022 04:35:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZWhg21e2xKeWWO8vdrSHPy57KUlHRClvcxoIGRUebw0R5LvLP/GQkpvP+NnZ5FDM3ugSIGSwLqILuUW192wSY+/mXn3RqHgCuKCSjhDvK1gccz8qsBKRLf02BgQa38MMonFnaWztw27YQdTCGgaeH9at8KOyGqAAom7AgoZZOJedCs2/nfe88nvTSnO3upgQt9+uId8DTeYApqdQFYWR4ws/SLGY35qYjJylQLWujIGejL4RK1wZdeVcen9fx69VbCr3+EfcZmp0tD44c93kf2aY6bJNw4RsMD53PB8l+GAdgls4FTN3C5+U0RGXHW/miGkI2O4hKe08xBTNKP9kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XfPbF+75kore5kYnVE6p20mKqA3CdKS2Eg+AEonRVfc=;
 b=LH2iiG+EzBOPhwAKDxZDEWdyHXrkKaw5ORl3S+vZUNggqT7PcmMdL0jMS3aq/AeiPIS7y4/YBxAkaQ2AjbiwSGltZsdmKNvXHcNJXZDA9rv7pslVcQUgKwVvF7W1/TVrmfpGN+044Fy78T4O7rf4J6LWGNRygf2akJSBq9TAPB0EZkbWM0Vpmbqnlr+cVQGmqhuRC4Aq21g0ldPBTSF9R0s7Ljt1H3HuAOqThVfxTngNrQ/OKpscyyNsJFrb26LkgqDKKTWkc2jyPF924/d5k3mfD0JzNPAPm86uAa80rEgoR4QBfvQi0rIB1cVbJKKA3TQ/dfLZE7Pqp4rQ0NACWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfPbF+75kore5kYnVE6p20mKqA3CdKS2Eg+AEonRVfc=;
 b=XOYjjb/MVhwTSdyhz+3XMHTSWyN8n9WYwqPB77GUPIUeMBIr3KGlRXPaKdRpCqZkPMGVSpMsI0swhK5I3fjYMfSjCCTZRt9YzJyFlBb8gNCfqlLyK4b/WUL9JfyOcZ4GeOjYeY6VSr6ac9LYdpnVwVz+ECwDEP3NAQycEa1lJQk=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by MWHPR11MB1584.namprd11.prod.outlook.com (2603:10b6:301:e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 11:35:32 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%8]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 11:35:32 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <radhey.shyam.pandey@amd.com>, <michal.simek@xilinx.com>,
        <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, <git@xilinx.com>
Subject: Re: [PATCH v2 net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Topic: [PATCH v2 net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Index: AQHYpZrOVcttQx4yeE6JUFSlUeGuJQ==
Date:   Mon, 1 Aug 2022 11:35:32 +0000
Message-ID: <ca9a0357-676e-3eff-5900-7c5914cd844f@microchip.com>
References: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1659123350-10638-3-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1659123350-10638-3-git-send-email-radhey.shyam.pandey@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 820dfe62-889b-4268-5e3e-08da73b1f160
x-ms-traffictypediagnostic: MWHPR11MB1584:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u0HkdbCU2aEptE2sgVdKo1P9L/y7yaBGSYs3JCWfQkXMnlwmibEsPBF7v4sxD9rtnHKgIYcTIcdkFONEptPL7nmYyIY2jN+edrPfvpe1LeF24BekB+cfR7X5fYWU85BeRJ62WM/e3eaj0dObbKUxJCaA2TSNmkEuNME6iXeeQgqD6hykD7u6fZPQryvSOq1Fc+UH/67MCDpGSl6wgbyjVB/9SX1iJscwtUctzG/tr1BsJ83PG8HK7U8DxaMfkT0kWW6RyaUBgAsI/PQg0z8aVfIJJW0txE8bDsbP9sDRhWWQUTx2RDqn+42JQhHh4BBE6Ybl349U4jq9kr7iLvefp1ipErLLUqLNrigLRyJFOMAuwo6UzLwKHFgd6TUyX+KY5p90/lOGBsitzgFlmxrPgU70/b3VnT7gI6nCrEmwv0sI4o8/evNfEe+wBUp/g2tc6GK8GMlJQzhq7jz3BSc3A8YkqueHl4b0vd2pPqxk68Dh/Ml5g3wZe4scIEV6AfrBiEh1kAKMzXLF3yNc0ogtS6CPZCxF2K6wUsultyMANYdVgNVYF7avNyKeA86t9jqq5I5Alj0Z1CGyGehCSa+iN5m+vPhd2b4Nc9PLeGba5BaxWHtXCeshTa27nfdCcWljGVEeimzOxL7McUpNt7vWAqiDq31JVoKhQE5VarLz+SgPlzHxcY+5lk17XVx48qHf0xsTvqud0G123SAYjcnDF6KYgmxmVQPoigqWS5S2Bwu8aa6WbiQaUwcOyfQjWOK5Jn8ObhI8NRagnpKuJeppfEdVwGElzh3FjaF8fybAeEqzg+efRwNUVal8x20Odf/SWIxKG6KQYafDMKOHiyCcW9op2l/Efrdqbm7sRLKofeg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39860400002)(366004)(136003)(396003)(53546011)(316002)(86362001)(54906003)(38100700002)(36756003)(110136005)(6506007)(7416002)(5660300002)(31686004)(38070700005)(31696002)(8676002)(8936002)(122000001)(71200400001)(83380400001)(76116006)(91956017)(66476007)(4326008)(66556008)(64756008)(2906002)(2616005)(66446008)(66946007)(26005)(478600001)(41300700001)(186003)(6512007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHY3R21MT3JmN2Ywd3FZaEJ4M1VvZ09YSU50SFV6dHRjaFpSRzYrOUhobUxz?=
 =?utf-8?B?c2ZDRi9TbHhrZW5CdDRMTW1oKzJ5bHpkTmc5djdpa0lNN0dOdllyQTNhUWRr?=
 =?utf-8?B?NmtBVjdRSXdGaVpUYmVSSElHZ1lUL1VteFRMNWVtNktGUHFERG9ESWtZZVlI?=
 =?utf-8?B?NVlnc21MOWJXVjh2S1BId1J4cElTTCt0V3hhb1BkTFVVSDkyOHc1Um1EOXpw?=
 =?utf-8?B?bTA2L3lMbDBOWmZ2NFdZOU5JWE45clArZlBvWW90bmt1eGIvMEo2bzJZOG9z?=
 =?utf-8?B?SHNtMjkxdnFiZXFlalFYSnJPOURLMG1zN2FkaDdWdjRCUDJqR1dVZnBCVXZr?=
 =?utf-8?B?VFAyMi8vKytiaEw2TUVyYy9oRDAwYVdmTDkxU21oOTM4S2hldXRPc04yUVBM?=
 =?utf-8?B?c2F5dHBiT3lBZU5YcVhtUUtqeEJMR3E4cGNOWjBBY0k0bkpwc2dsYjhQa0hx?=
 =?utf-8?B?SFZIK2RBZ2N1NnROWGM2NWhVQkZHemo2Z3MrWmI5TU9XMGhuS3BiMFd4ZjFz?=
 =?utf-8?B?Y3A5aGNmS20xUVVLQ014RDNSQVdIU1VKSDl3bnFyc083M1lzbFRUditqd2U2?=
 =?utf-8?B?RGw0R1pZaXloTGRDUnBSN0h2VzlTQmJZSTZtMFloU2ZVYVFubW1XQVZ3YzRx?=
 =?utf-8?B?Ukxqek9iVVpoNGRQdEF3OGZjdmZVRndydElQdXZ4WlF0eXpsNklSTzVHS0VQ?=
 =?utf-8?B?eURjbzRBR2V4dGFmVHVXM0RvUFRZRW84MVA4NmVMS1FlRlRpRU5iZGFsd2Mv?=
 =?utf-8?B?S3lwQ0sxK1lqYmpibE5aSTRReVo5ODJrU1BLVzBXSHBzSG9PQmNIMXpXM3o2?=
 =?utf-8?B?WFVGSEh6T050c25ObWhuU1Z0R0IvdHVuWmNZNTZuRFB3TVlJRy9FbWNIaXlE?=
 =?utf-8?B?elpuWEFndE1GancxVUZza3g5ZTFaYUczdFl5bFZGQjhIaHFRVDNST0s4VVhX?=
 =?utf-8?B?YkVqQVpJRGU4NndWMzhoK0VpSVVhMUg1dmlQTU5SbW9xTlJibG9qOWJKSkVt?=
 =?utf-8?B?SlpQQi92Tys4U0RSbEVOMTFrZHhDbVVnYWVmWjVzcWJtVGhLeDdjSWpmWmtT?=
 =?utf-8?B?RHErWjgyTFh0WWw4djdkbWF2VDFWM1NYRURZMTJSaytGSWQ5c1A4eXRtQVZT?=
 =?utf-8?B?OXVsTXQydlZETFpITVI5TGRkRWxHNGdoRDdseU1QeDNBeFJoMWo0T0NDcDN2?=
 =?utf-8?B?azZtZzU5MGpXWjJZZ2RpdDRlZFR6cFdXTlB1dU9sTUJFVWRDMTVQdHhyTGhZ?=
 =?utf-8?B?VGR0d0x3UDd6dUhKTTNOdVBJaE5yZHhLMWxtOS82cEErZmltM2Jpd2xtNXNR?=
 =?utf-8?B?SkdmTFozL2RKeXQrSll4Z1FGL0k2SmpkVFViUFNTNCthWGFrYUhaa1FhcGlJ?=
 =?utf-8?B?RmNZWU5JWTBoOWJLOHRBS29NS0JDY3J0a2Z3MlFNa3ppditpaGUyLzVKN3Q0?=
 =?utf-8?B?RjZ5cno5SDgxOWgySFIvQ3VnZGM4RERmclpSZ05wc2VYRHVlMG9VTmJqaTZ4?=
 =?utf-8?B?RDVMaGhtR3dtWVdNR1hOQkVheUluUnc5L0JrOWVlWWdlN1FhSjdxZ24wU1lJ?=
 =?utf-8?B?SlBpTThOZGFGV0JGdnFoOERPMFNIeDRZZ3lCWjJjUXo1VjVsNjdaemFPa1pt?=
 =?utf-8?B?eFUrN2lNUHVDUnlZRkU0WWxMMmVvNS9lYlZ5OFJETE5Cbnd0cEJJcTJJMDdI?=
 =?utf-8?B?N2VUUEErZ3V0YUNpc1NwbTRaK0t2MEVqZkRJQ3o1bkhuZzV4eUJ1Nm1tcFlt?=
 =?utf-8?B?WjdzRWxoaklzdFp4d1czQlVCdHY1S2xRVVRyZ0lDU25KYUJSRHVreGxmSzI3?=
 =?utf-8?B?S21wSU5WU3dkNDY3eEtKL1VpS1RocjRFWndkd1VOTjdySklTREpHcE5za041?=
 =?utf-8?B?NTRoL2dtdTNiTEhGM3hndVRpZ2hSZCtNcHI4dlNLck5EY25rMjFkRlNDNGo0?=
 =?utf-8?B?M1FnV3ZCeUx1UGFQTlJHZVFGZ2l5aXRJVm8zYlJaMGg2SGFpN3lVWTZWeldH?=
 =?utf-8?B?RTA0cHdkNmdXYlp0MTRXaHNYTnNsNE9PVGEzRjM5UlkrNHNTWGp2bjJTL1Yy?=
 =?utf-8?B?WE5zTE1HMjdENmVGclJSTmhkdDJvNUZyUGREcXplTTNmbDRtMCt0V0VNSG9j?=
 =?utf-8?B?MWs2YVhOQURyb0dEenJVTk9iOUU2Y2RkTVVOSzlNbkhGZzJiaGdBWjJwUzUx?=
 =?utf-8?B?VHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EFC93AEBAD6BA458C545FBD8E950799@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 820dfe62-889b-4268-5e3e-08da73b1f160
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 11:35:32.1908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 38jFyTlkKuTxr2LE6hiPGGDffF8Zwi9wNcsi9KudBskYjgTaWjlcZPsuOfuLt6UboDYXSfCWAsgSbvjT6Gsl/wwhcyQ8gkc1tXBfR/UWpNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1584
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjkuMDcuMjAyMiAyMjozNSwgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBBZGQgc3VwcG9ydCBmb3IgdGhlIGR5
bmFtaWMgY29uZmlndXJhdGlvbiB3aGljaCB0YWtlcyBjYXJlIG9mIGNvbmZpZ3VyaW5nDQo+IHRo
ZSBHRU0gc2VjdXJlIHNwYWNlIGNvbmZpZ3VyYXRpb24gcmVnaXN0ZXJzIHVzaW5nIEVFTUkgQVBJ
cy4gSGlnaCBsZXZlbA0KPiBzZXF1ZW5jZSBpcyB0bzoNCj4gLSBDaGVjayBmb3IgdGhlIFBNIGR5
bmFtaWMgY29uZmlndXJhdGlvbiBzdXBwb3J0LCBpZiBubyBlcnJvciBwcm9jZWVkIHdpdGgNCj4g
ICBHRU0gZHluYW1pYyBjb25maWd1cmF0aW9ucyhuZXh0IHN0ZXBzKSBvdGhlcndpc2Ugc2tpcCB0
aGUgZHluYW1pYw0KPiAgIGNvbmZpZ3VyYXRpb24uDQo+IC0gQ29uZmlndXJlIEdFTSBGaXhlZCBj
b25maWd1cmF0aW9ucy4NCj4gLSBDb25maWd1cmUgR0VNX0NMS19DVFJMIChnZW1YX3NnbWlpX21v
ZGUpLg0KPiAtIFRyaWdnZXIgR0VNIHJlc2V0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUmFkaGV5
IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUBhbWQuY29tPg0KPiBSZXZpZXdlZC1i
eTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBUZXN0ZWQtYnk6IENvbm9yIERvb2xl
eSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+IChmb3IgTVBGUykNCj4gLS0tDQo+IENoYW5n
ZXMgZm9yIHYyOg0KPiAtIEFkZCBwaHlfZXhpdCgpIGluIGVycm9yIHJldHVybiBwYXRocy4NCj4g
LS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgMjUgKysr
KysrKysrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDI1IGluc2VydGlvbnMo
KykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2Jf
bWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBpbmRl
eCA0Y2Q0ZjU3Y2EyYWEuLjUxN2I0MGZmMDk4YiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IEBAIC0zOCw2ICszOCw3IEBADQo+ICAjaW5jbHVkZSA8
bGludXgvcG1fcnVudGltZS5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3B0cF9jbGFzc2lmeS5oPg0K
PiAgI2luY2x1ZGUgPGxpbnV4L3Jlc2V0Lmg+DQo+ICsjaW5jbHVkZSA8bGludXgvZmlybXdhcmUv
eGxueC16eW5xbXAuaD4NCj4gICNpbmNsdWRlICJtYWNiLmgiDQo+IA0KPiAgLyogVGhpcyBzdHJ1
Y3R1cmUgaXMgb25seSB1c2VkIGZvciBNQUNCIG9uIFNpRml2ZSBGVTU0MCBkZXZpY2VzICovDQo+
IEBAIC00NjIxLDYgKzQ2MjIsMzAgQEAgc3RhdGljIGludCBpbml0X3Jlc2V0X29wdGlvbmFsKHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICJmYWlsZWQgdG8gaW5pdCBTR01JSSBQSFlcbiIpOw0KPiAgICAg
ICAgIH0NCj4gDQo+ICsgICAgICAgcmV0ID0genlucW1wX3BtX2lzX2Z1bmN0aW9uX3N1cHBvcnRl
ZChQTV9JT0NUTCwgSU9DVExfU0VUX0dFTV9DT05GSUcpOw0KPiArICAgICAgIGlmICghcmV0KSB7
DQo+ICsgICAgICAgICAgICAgICB1MzIgcG1faW5mb1syXTsNCj4gKw0KPiArICAgICAgICAgICAg
ICAgcmV0ID0gb2ZfcHJvcGVydHlfcmVhZF91MzJfYXJyYXkocGRldi0+ZGV2Lm9mX25vZGUsICJw
b3dlci1kb21haW5zIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHBtX2luZm8sIEFSUkFZX1NJWkUocG1faW5mbykpOw0KPiArICAgICAgICAgICAg
ICAgaWYgKHJldCA8IDApIHsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcGh5X2V4aXQoYnAt
PnNnbWlpX3BoeSk7DQoNCkNvdWxkIHlvdSBtb3ZlIHRoaXMgdG8gYSBzaW5nbGUgZXhpdCBwb2lu
dCBhbmQganVtcCBpbiB0aGVyZSB3aXRoIGdvdG8/DQpTYW1lIGZvciB0aGUgcmVzdCBvZiBvY2N1
cmVuY2llcy4NCg0KQWxzbywgSSBub3RpY2UganVzdCBub3cgdGhhdCBwaHlfaW5pdCgpIGlzIGRv
bmUgb25seSBpZiBicC0+cGh5X2ludGVyZmFjZQ0KPT0gUEhZX0lOVEVSRkFDRV9NT0RFX1NHTUlJ
LCBwaHlfZXhpdCgpIHNob3VsZCBiZSBoYW5kbGVkIG9ubHkgaWYgdGhpcyBpcw0KdHJ1ZSwgdG9v
Lg0KDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGRldl9lcnIoJnBkZXYtPmRldiwgIkZhaWxl
ZCB0byByZWFkIHBvd2VyIG1hbmFnZW1lbnQgaW5mb3JtYXRpb25cbiIpOw0KPiArICAgICAgICAg
ICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiArICAgICAgICAgICAgICAgfQ0KPiArICAgICAg
ICAgICAgICAgcmV0ID0genlucW1wX3BtX3NldF9nZW1fY29uZmlnKHBtX2luZm9bMV0sIEdFTV9D
T05GSUdfRklYRUQsIDApOw0KPiArICAgICAgICAgICAgICAgaWYgKHJldCA8IDApIHsNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgcGh5X2V4aXQoYnAtPnNnbWlpX3BoeSk7DQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ICsgICAgICAgICAgICAgICB9DQo+ICsNCj4g
KyAgICAgICAgICAgICAgIHJldCA9IHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyhwbV9pbmZvWzFd
LCBHRU1fQ09ORklHX1NHTUlJX01PREUsIDEpOw0KPiArICAgICAgICAgICAgICAgaWYgKHJldCA8
IDApIHsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcGh5X2V4aXQoYnAtPnNnbWlpX3BoeSk7
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ICsgICAgICAgICAgICAg
ICB9DQo+ICsgICAgICAgfQ0KPiArDQo+ICAgICAgICAgLyogRnVsbHkgcmVzZXQgY29udHJvbGxl
ciBhdCBoYXJkd2FyZSBsZXZlbCBpZiBtYXBwZWQgaW4gZGV2aWNlIHRyZWUgKi8NCj4gICAgICAg
ICByZXQgPSBkZXZpY2VfcmVzZXRfb3B0aW9uYWwoJnBkZXYtPmRldik7DQo+ICAgICAgICAgaWYg
KHJldCkgew0KPiAtLQ0KPiAyLjEuMQ0KPiANCg0K
