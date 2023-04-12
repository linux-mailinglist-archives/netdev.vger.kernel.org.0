Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AC26DFB29
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDLQVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDLQVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:21:17 -0400
X-Greylist: delayed 175 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Apr 2023 09:21:00 PDT
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467AA659E
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:21:00 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33CDASJC003909;
        Wed, 12 Apr 2023 12:17:16 -0400
Received: from can01-yqb-obe.outbound.protection.outlook.com (mail-yqbcan01lp2240.outbound.protection.outlook.com [104.47.75.240])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3pu3d05vr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Apr 2023 12:17:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZkpuoING5vXBhNgDEgbEQskAi+fmVD4XWHy/+zPzxZj5IvrXWtHB83R1T/grrBUIaqY/szwfxkH71HkeoqF7G18xXPM6mYgF+2/10tziABX/06UwrOcaVQ0xVChIZTviW5FicaUR45vCg17fj1XeOsk70ajZM8eFpYCNW/B1OJ2rJwkNq/kjDZlbzmNJqi9dydPyP6YvnKnqDCbWRHQDtvJsJt7EhtEtI6x3tWky2WT66y1c9QkLfLDks6nJ4lWiWM3TT3aiXQvkbvsd/331YiGegXNx27gGwYEX8q5k/8vCvEUybv1WD85LsEMRUE/ahWbf0jP4VCJfwzkCelwvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LFNdwhdfWvCYYtIgRQmkZ+v02c6ZrREenmHsfzplGo=;
 b=UE6cel94xDSOUwyPN+/fOETRrP4VL0+KZR8W6rT6A6LouG9KWbpmIWVpTt/cVKOokg2ByKtpq5zlvjjMX5NkEXK/to4CI/TykFFan8vYSqSipIqkiGSqjvYdMEEYRK6m3BBLHMUEsYlCttWxxObcniWXj/Qdp4lQw1kuIOwBqT3IipLumROtnOMKe4gzFpTfL9+TQsUOO3esEElrtZhZ2lquGH836dxV+9zD5Y+kLbN561VfWakhdLLv3sxKBJCbBd0hlJib1UYrYcz54Y3YXY6kCKQs9RUCP/ESBFdPUrRFN8w5ucm7JUaZVBzUo8ZKaWuRxOhDiipls8jpZ++Wpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LFNdwhdfWvCYYtIgRQmkZ+v02c6ZrREenmHsfzplGo=;
 b=WqZFDY359tDjHHIpLk/LIaQz9HmP/wuj7m8pLgUzInoWgMZlOpiO5xiRfe0ni7mlnKSggxX/qGlidprwHHLygTytEcCuStzMvV/QkumdUmT0tBsR2s+g+tHM7SB60KJSINHCq5zqBvnm2JBnTVr99TTWNxv+R5jyZ3kZePg1QX4=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT2PR01MB6498.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 16:17:14 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6fe:504a:acc7:19d9]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6fe:504a:acc7:19d9%5]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 16:17:14 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "ingo.rohloff@lauterbach.com" <ingo.rohloff@lauterbach.com>,
        "tomas.melin@vaisala.com" <tomas.melin@vaisala.com>
CC:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "harini.katakam@xilinx.com" <harini.katakam@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/1] Alternative, restart tx after tx used bit read
Thread-Topic: [PATCH 0/1] Alternative, restart tx after tx used bit read
Thread-Index: AQHZaZip8Nu0fmRUUESltXR0JxXJMa8nPHiAgACk0YA=
Date:   Wed, 12 Apr 2023 16:17:14 +0000
Message-ID: <8074717519a77fdc5af6c86965beeb5ba0e07d61.camel@calian.com>
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
         <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
         <9bd964bd-8f2f-c97e-dd52-74b9d7051500@vaisala.com>
In-Reply-To: <9bd964bd-8f2f-c97e-dd52-74b9d7051500@vaisala.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: YT2PR01MB8838:EE_|YT2PR01MB6498:EE_
x-ms-office365-filtering-correlation-id: 3385fbbe-4ca2-4cfe-d203-08db3b716094
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n08Eq9N5hvdAR6G1fzsMuN9KApqxICNufO0cBL+EA3BsSpZKZAiif1s9dn2ln46xAs94zDC7kKZSGI2Q4GrYlVzU8FNOUkzYUD8HSrNJ2qs8ic+Q05US3umCIdq5MkEJUsPKs9kSO9VgZjzbNRw5tKt9vBKmh02lozbeOyZfdoeM2k3CLIrgPKaUIlGLfnDvKty0mKecma+R/98zX5LApF2O3QYLCRKzPw3qRnuUOCib3vd6c9se/ABIq5wV+O89ZJpCxYJhWmK2RZM9ByOSISCX9IEg79nrOos08IEWOzUoWzFlLApCtMyZ3hkPxzeoNEuLBzceLgjjTbG9fZNcQFt6KqaID0IKwyFfZetNztRSI8Mer1Q/qmYUrG3ZC4iei7mdaWan3AtFU8aAI7RzCNV6br9pxpozPAHAo+xlQ1xphCpoR2mVu7LEw2xzx6mXEikdYwOltRqMAPhRq6FaHLsNj2WGPLJ956CPq+y0HhYX57K0dtjM6rayonKlQTTi2WnLRIwrlV+HgWWRRt+MRyj8ZGvZzfptRnnqED1B2Kjoiv0OFVgrnjehw2abMTZzLDXcce/CqfV5GWleTobsldogEVMZ15FciAH27sB6Dqc4J94R8LdnRG2or6Ikso3XbvGX4YSAfdJXIpwQVZAIBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199021)(91956017)(66946007)(64756008)(4326008)(66446008)(76116006)(478600001)(66556008)(66476007)(316002)(110136005)(5660300002)(54906003)(44832011)(8676002)(41300700001)(122000001)(8936002)(38100700002)(83380400001)(53546011)(186003)(71200400001)(6486002)(2616005)(6506007)(26005)(966005)(6512007)(86362001)(15974865002)(2906002)(36756003)(38070700005)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWk4RkhNK3had0VrWlMzV0FDOWRZRTlieDNUK09LM0pVZVk2eDJzV1U2U2xj?=
 =?utf-8?B?MGRXRXZ3ZHl2L3VRYXY3RGJON09FSm9QUVVLdXczNnltQW50VGdLUmZ4U0c2?=
 =?utf-8?B?STlDUFdxczNJWnhneC9vOUFleVk3N0J3N2t4MUpDMzN5WWxCZnJaSitLSFBl?=
 =?utf-8?B?b3pVK29kVUdScTB6Tm9jdEpOSnJqUlVRdkZlc25QOVdYbnBOTllrMHExRER4?=
 =?utf-8?B?aGJSV3ovNkozcmNHYVhPUFM1a0Z2NUxCcy8zSU9HWTArUDcwZDEreENoRDVR?=
 =?utf-8?B?V1hpMDNodlp1USt5UVdxZ3l4VVFjQWdkdUtaa1VFdW94RVR3ZEZiWXdMR0ZJ?=
 =?utf-8?B?bVZuMm1Vb251NTRzZlhIaGhkQ3JUS0FUQW85dkJFTEV4WVpSdUJIRTJ3RGtG?=
 =?utf-8?B?THliRlpYc3Y3dUdRY2MyMlFwQ25PRjBXTXVvejJ2WURRR3J2bndON0NQNjcv?=
 =?utf-8?B?NDRGVWdzcnFWUmw0MnJldHZsZWF6OVNVN215VGVwODBlVVk5VGlOeWhJU0cz?=
 =?utf-8?B?Y1pVRDVFTGlPdDNCSTJLRHU1RlhIc2xDOUNjMUluby83ZzZkWG9lZE5LWkUv?=
 =?utf-8?B?Y1pjc05EQ1d4dkRVTGZQN3NpUlJiaTlmSDhVWjA4S1FxN3plcG52S2xDQUFG?=
 =?utf-8?B?Q04yYUVRREdFQ1MyRk43NDlDd3J3SzZSUW9HK0l2aXk5SzY3Q1lGa1c2c3Bl?=
 =?utf-8?B?WWpBMUhCaVVTa1ZlTUltMjd0a2hUejFVRk50SEFrY0hsTjZGSVBZYVRKNkJD?=
 =?utf-8?B?MnN2M3FGaE5EMG9PK0daam5SWGEraHBGd2laQXJpcVpTaHpZWExnQkdVNFNU?=
 =?utf-8?B?dkx0a0NXVFFocVpBUjFyZ1FCNStLMXhTN0l1ZGF0ZEM5NldXQUc0dDBoWWZ3?=
 =?utf-8?B?Q1BjRkExVXQ2T29Md210anhLZ0RCQ24wMU13N3lvRXJhRHNQVDZja0E4SHAr?=
 =?utf-8?B?U2dUYUttWmVGWjFSUnpIMUhHR0NrZ29WSHFhUmMyN1JxSnRiSkRwaG51UUlG?=
 =?utf-8?B?VGxRTG5qTjJzMVBrbUhIZFYrOHdpbStOZUlIMzlXNXY5ZCtjZENuRkpNSzdW?=
 =?utf-8?B?K2VXTUE0cFkyQVZ6K0lmLzlJbjFXbWZ3L010b1NHZ1NLMCtBMXladXowenpP?=
 =?utf-8?B?OGJOMUtPd2NjOEt0aWtVcjJHN085OTZxSGI5RlNkRXVtN1hYQjB3U1VLeHJ5?=
 =?utf-8?B?Vm1wSHhoRStMTm03SnAya3BBREMyRnFVcTQyMHFyQUhNMVkzd2RhOHhrb3Jv?=
 =?utf-8?B?cW8vdUh0SEpNTzNzRHZhU2QyZWVnLzJ0UU40NnphR0w4WHpTcit2T2lWa3Fq?=
 =?utf-8?B?cWwrMUs4N3RwS2E5eWpTcENWZVBhVlYybmVjKzVQUDRGdnRPdlp2K3RTVzk4?=
 =?utf-8?B?emJwYzY4RDNSU2RGdWVCblpRK2xjZHJqYkJlZWdBRXk1TGtpNllQVmpUS1dq?=
 =?utf-8?B?eGdMd3dtREFLNWh4djl2d2JJZkwzVmdIVUJvUW1IekdSWFBvRzVReS8wb0hL?=
 =?utf-8?B?VS9jWnd1NklJOTVkeFZ6cWhKQ3NKdHRVSVIreTFSZ01SalBKZlFicEZYNWYy?=
 =?utf-8?B?bVE1Z0R0M0krNXJnUTZYQlE1L1ZkbkVtVUJ1clNveUdtMW1XOWxIbnB0bitC?=
 =?utf-8?B?aTVFRmxwREd0dHgyY0trdEpYMVpYcE5GUVV3alYrT3NMMUEvSEhoRmRSWDda?=
 =?utf-8?B?cGNoSyt2QUtsb2svNFhEZzBzdVZvOGY5WFdNYmIwTXpLdWtmVm5maTJkYmZ0?=
 =?utf-8?B?VmI2MkdNMU5SWmh4U0U1ZlBVL3N3Q3lmUDlWRVlOKzRJcDMyTWFWdk9aUFlH?=
 =?utf-8?B?L0c4UDA3N1NLVVdCcVRsOE4wd1JCVEUySytBNm9haE1qbzRMa2s1b1NYWk94?=
 =?utf-8?B?dThrQ2VydmVOZlU4Q0o3Y1RiSGdTbG1CbE1aNW1OOUlvbVhnNzlmUWp1eVN0?=
 =?utf-8?B?dEdmdHJlV0hvMXRQQUVzWDU4QU96QVovYmlWbEY3TVlsWHBQNDJKbmIxbnoz?=
 =?utf-8?B?UzBxMHkrWjV2S1NENUVoSnJQR0hyVHMrSWsyLzA4b28ySmtGTWo1VWZTRldK?=
 =?utf-8?B?TmFqbDlJYjk0aVVyWnhVYXFBRXVlNzBmU2hTT2MyT2dUSEd4S29paVhPTXdo?=
 =?utf-8?B?aWdObE9iTFpPSklycXBCTFFqM0grdHc3L1RKUG8zZFlRdFhGWEs2RTVXTXRl?=
 =?utf-8?B?S0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <084CB0562AE1F94BA8DDF80693C2EECB@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NGNZNEM0ZG1ZN2k0Wm81bFVqdHZzNmt5bVZsdE8xUnVoSkRIdVpRbkVCL2VY?=
 =?utf-8?B?VmdoYW9ibEJQNmZ1V0s2RDJ5aytvZmlpU0VkaThvSmdEeTJnMzFaUTJZbUNs?=
 =?utf-8?B?MHdWYmFFeFZvUTAyMUNqQ3piZE1GWXF4eWV2SnRodXphdlp6RzNEcEFESk93?=
 =?utf-8?B?K1B6eVJ5aitXT1EwOVkwMStxUUNuaG9kdHNza0VpYW16Nk1tL3h2QWFySlBZ?=
 =?utf-8?B?cmE0ZGJvTmRuZDkrRUgxZDFuWFJGVVFRM2tmb2o4WGIrQUJ3Y2psY0E4Y2tr?=
 =?utf-8?B?UzV1ajY0dFh0dDJHUUVRTFhZQTMvY0RLdGlhY2YrNE5xRVF4KzMxMVN3aC95?=
 =?utf-8?B?cjlSMmc4cXhuemZkNnZjZGRXZVFNU3BsTlBSOTRxb1pwakkxdytsQzRES0ht?=
 =?utf-8?B?SURsTTZkWXFuWGxQemd3T0hqaGxuQStVUUJ1WTRzcmpKeUdQUG81MGx5TFVV?=
 =?utf-8?B?MWRIc01kREJtelZpQkJrL1o1Q0hmTG1XTWsrbGh4dUdIbXlrMmswblpvQ0Zs?=
 =?utf-8?B?R05CdnEvRURVYWkzTmlFdEJGT0E3d2VtNGkyVFpEY2xzMnVCRmIrWkZ4YTVi?=
 =?utf-8?B?M3VXNllOUWJvUmdyakJHN293b1hFNDg4bEhUTTljYjJ5VUdObEZNenRBbU5p?=
 =?utf-8?B?NENJb2dZaWRmRXh2VTVCTm52a2VPa1NxREhRSzBtSHIrLzdaa1c3ZnJPUFNM?=
 =?utf-8?B?SlVxR2pTNnUzdGRpc1FROEJXSUt2UlhDSk1QeDlNQzYzQkRUY1hwMG9GRi9C?=
 =?utf-8?B?dVN0VUxkTEI4Ny85ZjNuaks5ajNpWGdGSDJuc2FmWjdpK3NjOEN6d3ZKYUE5?=
 =?utf-8?B?Mit4eFB6UnhudENOaVlLV3FQZTFCVlZucjM4TE9JbHF4QUNCS1htL2R2eXQ1?=
 =?utf-8?B?ZUNxSC9ocXNBZndBcFVvV3JUaWh5WDBZdW9TU0tJT1RlcDBVZEtPUnlwWVg0?=
 =?utf-8?B?cVJSSW95RktCd0g1WVZrWFplVUFqZS8xSmtvc0pudG1WZk5JMHJtdFljOSs5?=
 =?utf-8?B?V2FuVXRzck9UbWZ5eWthdzFGL3hTSllaMU5iT1pEOGR2dktqYjVkOTkvYi9L?=
 =?utf-8?B?eEsrYklJSUdMMG02NVZwZ2lEd1d5SnNvckpmSjVLVGtlYmNXT2lJQTR6cWNw?=
 =?utf-8?B?dHRwRnZ6UUNqQXpwTEgxcjhoMDByd2g3TjgxdUhwd0F0WXVLS0pIQ2k1VFA3?=
 =?utf-8?B?UEo2Z0NnMGtaZVk5M0VyMG9WWngzUVYwaTJ2UzE0elNoTm90QlVVTS92MTY2?=
 =?utf-8?B?T2xTdWU4NFpQVGw1VTY0ZWphR2lNczBnZm54WnZZWjR6NUI4cGE2MmlaVzhr?=
 =?utf-8?Q?0kPxZXNseCEVQ=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3385fbbe-4ca2-4cfe-d203-08db3b716094
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 16:17:14.0541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MokKnK08Fd5eGm+KBv6kFe//I2CwBW8VGAHjoLURoDefQ2RJv4zeyzy6YYoVQ4cCNYtOTAz/V/yckK1LC7T7NBpMEdQ1OuOvKwIcmXAM6PM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6498
X-Proofpoint-GUID: 0Cge-SaS41DpwMimS9GUXPs5lo39hHGm
X-Proofpoint-ORIG-GUID: 0Cge-SaS41DpwMimS9GUXPs5lo39hHGm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_07,2023-04-12_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304120141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTEyIGF0IDA5OjI3ICswMzAwLCBUb21hcyBNZWxpbiB3cm90ZToNCj4g
SGksDQo+IE9uIDA4LzA0LzIwMjMgMDA6MzMsIEluZ28gUm9obG9mZiB3cm90ZToNCj4gPiBbWW91
IGRvbid0IG9mdGVuIGdldCBlbWFpbCBmcm9tIGluZ28ucm9obG9mZkBsYXV0ZXJiYWNoLmNvbS4g
TGVhcm4NCj4gPiB3aHkgdGhpcyBpcyBpbXBvcnRhbnQgYXQNCj4gPiBodHRwczovL3VybGRlZmVu
c2UuY29tL3YzL19faHR0cHM6Ly9ha2EubXMvTGVhcm5BYm91dFNlbmRlcklkZW50aWZpY2F0aW9u
X187ISFJT0dvczBrIWlGdmdhakU4dm5KUlptcFRWZzllNGRPeEp5UG5uaWFXcGZjRDREUEVXbGN2
TDJUSDVBVG5yYlBKRXpPbXVZdHhQZGF0aWpwYzR6VER0U3R4Si1WU1RjQWhYdyQNCj4gPiDCoCBd
DQo+ID4gDQo+ID4gSSBhbSBzb3JyeTsgdGhpcyBpcyBhIGxvbmcgRS1NYWlsLg0KPiA+IA0KPiA+
IEkgYW0gcmVmZXJyaW5nIHRvIHRoaXMgcHJvYmxlbToNCj4gPiANCj4gPiBSb2JlcnQgSGFuY29j
ayB3cm90ZToNCj4gPiA+IE9uIFdlZCwgMjAyMi0wMy0yMyBhdCAwODo0MyAtMDcwMCwgSmFrdWIg
S2ljaW5za2kgd3JvdGU6DQo+ID4gPiA+IE9uIFdlZCwgMjMgTWFyIDIwMjIgMTA6MDg6MjAgKzAy
MDAgVG9tYXMgTWVsaW4gd3JvdGU6DQo+ID4gPiA+ID4gPiBGcm9tOiBDbGF1ZGl1IEJlem5lYSA8
Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4g
T24gc29tZSBwbGF0Zm9ybXMgKGN1cnJlbnRseSBkZXRlY3RlZCBvbmx5IG9uIFNBTUE1RDQpIFRY
DQo+ID4gPiA+ID4gPiBtaWdodCBzdHVjaw0KPiA+ID4gPiA+ID4gZXZlbiB0aGUgcGFjaGV0cyBh
cmUgc3RpbGwgcHJlc2VudCBpbiBETUEgbWVtb3JpZXMgYW5kIFRYDQo+ID4gPiA+ID4gPiBzdGFy
dCB3YXMNCj4gPiA+ID4gPiA+IGlzc3VlZCBmb3IgdGhlbS4NCj4gPiA+ID4gPiA+IC4uLg0KPiA+
ID4gPiA+IE9uIFhpbGlueCBaeW5xIHRoZSBhYm92ZSBjaGFuZ2UgY2FuIGNhdXNlIGluZmluaXRl
IGludGVycnVwdA0KPiA+ID4gPiA+IGxvb3ANCj4gPiA+ID4gPiBsZWFkaW5nIHRvIENQVSBzdGFs
bC7CoCBTZWVtcyB0aW1pbmcvbG9hZCBuZWVkcyB0byBiZQ0KPiA+ID4gPiA+IGFwcHJvcHJpYXRl
IGZvcg0KPiA+ID4gPiA+IHRoaXMgdG8gaGFwcGVuLCBhbmQgY3VycmVudGx5IHdpdGggMUcgZXRo
ZXJuZXQgdGhpcyBjYW4gYmUNCj4gPiA+ID4gPiB0cmlnZ2VyZWQNCj4gPiA+ID4gPiBub3JtYWxs
eSB3aXRoaW4gbWludXRlcyB3aGVuIHJ1bm5pbmcgc3RyZXNzIHRlc3RzIG9uIHRoZQ0KPiA+ID4g
PiA+IG5ldHdvcmsNCj4gPiA+ID4gPiBpbnRlcmZhY2UuDQo+ID4gPiA+ID4gLi4uDQo+ID4gPiA+
IFdoaWNoIGtlcm5lbCB2ZXJzaW9uIGFyZSB5b3UgdXNpbmc/wqAgUm9iZXJ0IGhhcyBiZWVuIHdv
cmtpbmcgb24NCj4gPiA+ID4gbWFjYiArDQo+ID4gPiA+IFp5bnEgcmVjZW50bHksIGFkZGluZyBo
aW0gdG8gQ0MuDQo+ID4gPiAuLi4NCj4gPiA+IEkgaGF2ZW4ndCBsb29rZWQgYXQgdGhlIFRYIHJp
bmcgZGVzY3JpcHRvciBhbmQgcmVnaXN0ZXIgc2V0dXAgb24NCj4gPiA+IHRoaXMgY29yZQ0KPiA+
ID4gaW4gdGhhdCBtdWNoIGRldGFpbCwgYnV0IHRoZSBmYWN0IHRoZSBjb250cm9sbGVyIGdldHMg
aW50byB0aGlzDQo+ID4gPiAiVFggdXNlZA0KPiA+ID4gYml0IHJlYWQiIHN0YXRlIGluIHRoZSBm
aXJzdCBwbGFjZSBzZWVtcyB1bnVzdWFsLsKgIEknbSB3b25kZXJpbmcNCj4gPiA+IGlmDQo+ID4g
PiBzb21ldGhpbmcgaXMgYmVpbmcgZG9uZSBpbiB0aGUgd3Jvbmcgb3JkZXIgb3IgaWYgd2UgYXJl
IG1pc3NpbmcgYQ0KPiA+ID4gbWVtb3J5DQo+ID4gPiBiYXJyaWVyIGV0Yz8NCj4gPiANCj4gPiBJ
IGFtIGRldmVsb3Bpbmcgb24gYSBaeW5xTVAgKFVsdHJhc2NhbGUrKSBTb0MgZnJvbSBBTUQvWGls
aW54Lg0KPiA+IEkgaGF2ZSBzZWVuIHRoZSBzYW1lIGlzc3VlIGJlZm9yZSBjb21taXQgNDI5ODM4
ODU3NGRhZTYxNjggKCJuZXQ6DQo+ID4gbWFjYjoNCj4gPiByZXN0YXJ0IHR4IGFmdGVyIHR4IHVz
ZWQgYml0IHJlYWQiKQ0KPiANCj4gU2luY2UgeW91IG1lbnRpb24gYmVmb3JlIHRoYXQgY29tbWl0
IHRoaXMgdHJpZ2dlcmVkLCBoYXZlIHlvdSBiZWVuDQo+IGFibGUNCj4gdG8gcmVwcm9kdWNlIHRo
ZSBwcm9ibGVtIHdpdGggdGhhdCBjb21taXQgYXBwbGllZD8NCj4gDQo+ID4gDQo+ID4gVGhlIHNj
ZW5hcmlvIHdoaWNoIHNvbWV0aW1lcyB0cmlnZ2VycyBpdCBmb3IgbWU6DQo+ID4gDQo+ID4gSSBo
YXZlIGFuIGFwcGxpY2F0aW9uIHJ1bm5pbmcgb24gdGhlIFBDLg0KPiA+IFRoZSBhcHBsaWNhdGlv
biBzZW5kcyBhIHNob3J0IGNvbW1hbmQgKHZpYSBUQ1ApIHRvIHRoZSBaeW5xTVAuDQo+ID4gVGhl
IFp5bnFNUCBhbnN3ZXJzIHdpdGggYSBsb25nIHN0cmVhbSBvZiBieXRlcyB2aWEgVENQDQo+ID4g
KGFyb3VuZCAyMzBLaUIpLg0KPiA+IFRoZSBQQyBrbm93cyB0aGUgYW1vdW50IG9mIGRhdGEgYW5k
IHdhaXRzIHRvIHJlY2VpdmUgdGhlIGRhdGENCj4gPiBjb21wbGV0ZWx5Lg0KPiA+IFRoZSBQQyBn
ZXRzIHN0dWNrLCBiZWNhdXNlIHRoZSBsYXN0IFRDUCBzZWdtZW50IG9mIHRoZSB0cmFuc2Zlcg0K
PiA+IGdldHMNCj4gPiBzdHVjayBpbiB0aGUgWnlucU1QIGFuZCBpcyBub3QgdHJhbnNtaXR0ZWQu
DQo+ID4gWW91IGNhbiByZS10cmlnZ2VyIHRoZSBUWCBSaW5nIGJ5IHBpbmdpbmcgdGhlIFp5bnFN
UDoNCj4gPiBUaGUgUGluZyBhbnN3ZXIgd2lsbCByZS10cmlnZ2VyIHRoZSBUWCByaW5nLCB3aGlj
aCBpbiB0dXJuIHdpbGwNCj4gPiBhbHNvDQo+ID4gdGhlbiBzZW5kIHRoZSBzdHVjayBJUC9UQ1Ag
cGFja2V0Lg0KPiA+IA0KPiA+IFVuZm9ydHVuYXRlbHkgdHJpZ2dlcmluZyB0aGlzIHByb2JsZW0g
c2VlbXMgdG8gYmUgaGFyZDsgYXQgbGVhc3QgSQ0KPiA+IGFtDQo+ID4gbm90IGFibGUgdG8gcmVw
cm9kdWNlIGl0IGVhc2lseS4NCj4gPiANCj4gPiBTbzogSWYgYW55b25lIGhhcyBhIG1vcmUgcmVs
aWFibGUgd2F5IHRvIHRyaWdnZXIgdGhlIHByb2JsZW0sDQo+ID4gcGxlYXNlIHRlbGwgbWUuDQo+
ID4gVGhpcyBpcyB0byBjaGVjayBpZiBteSBwcm9wb3NlZCBhbHRlcm5hdGl2ZSB3b3JrcyB1bmRl
ciBhbGwNCj4gPiBjaXJjdW1zdGFuY2VzLg0KPiA+IA0KPiA+IEkgaGF2ZSBhbiBhbHRlcm5hdGUg
aW1wbGVtZW50YXRpb24sIHdoaWNoIGRvZXMgbm90IHJlcXVpcmUgdG8gdHVybg0KPiA+IG9uDQo+
ID4gdGhlICJUWCBVU0VEIEJJVCBSRUFEIiAoVFVCUikgaW50ZXJydXB0Lg0KPiA+IFRoZSByZWFz
b24gd2h5IEkgdGhpbmsgdGhpcyBhbHRlcm5hdGl2ZSBtaWdodCBiZSBiZXR0ZXIgaXMsIGJlY2F1
c2UNCj4gPiBJDQo+ID4gYmVsaWV2ZSB0aGUgVFVCUiBpbnRlcnJ1cHQgaGFwcGVucyBhdCB0aGUg
d3JvbmcgdGltZTsgc28gSSBhbSBub3QNCj4gPiBzdXJlDQo+ID4gdGhhdCB0aGUgY3VycmVudCBp
bXBsZW1lbnRhdGlvbiB3b3JrcyByZWxpYWJseS4NCj4gPiANCj4gPiBBbmFseXNpczoNCj4gPiBD
b21taXQgNDA0Y2QwODZmMjllODY3ZiAoIm5ldDogbWFjYjogQWxsb2NhdGUgdmFsaWQgbWVtb3J5
IGZvciBUWA0KPiA+IGFuZCBSWCBCRA0KPiA+IHByZWZldGNoIikgbWVudGlvbnM6DQo+ID4gDQo+
ID4gwqDCoMKgIEdFTSB2ZXJzaW9uIGluIFp5bnFNUCBhbmQgbW9zdCB2ZXJzaW9ucyBncmVhdGVy
IHRoYW4gcjFwMDcNCj4gPiBzdXBwb3J0cw0KPiA+IMKgwqDCoCBUWCBhbmQgUlggQkQgcHJlZmV0
Y2guIFRoZSBudW1iZXIgb2YgQkRzIHRoYXQgY2FuIGJlIHByZWZldGNoZWQNCj4gPiBpcyBhDQo+
ID4gwqDCoMKgIEhXIGNvbmZpZ3VyYWJsZSBwYXJhbWV0ZXIuIEZvciBaeW5xTVAsIHRoaXMgcGFy
YW1ldGVyIGlzIDQuDQo+ID4gDQo+ID4gSSB0aGluayB3aGF0IGhhcHBlbnMgaXMgdGhpczoNCj4g
PiBFeGFtcGxlIFNjZW5hcmlvIChTVyA9PSBsaW51eCBrZXJuZWwsIEhXID09IGNhZGVuY2UgZXRo
ZXJuZXQgSVApLg0KPiA+IDEpIFNXIGhhcyB3cml0dGVuIFRYIGRlc2NyaXB0b3JzIDAuLjcNCj4g
PiAyKSBIVyBpcyBjdXJyZW50bHkgdHJhbnNtaXR0aW5nIFRYIGRlc2NyaXB0b3IgNi4NCj4gPiDC
oMKgIEhXIGhhcyBhbHJlYWR5IHByZWZldGNoZWQgVFggZGVzY3JpcHRvcnMgNiw3LDgsOS4NCj4g
PiAzKSBTVyB3cml0ZXMgVFggZGVzY3JpcHRvciA4IChjbGVhcmluZyBUWF9VU0VEKQ0KPiA+IDQp
IFNXIHdyaXRlcyB0aGUgVFNUQVJUIGJpdC4NCj4gPiDCoMKgIEhXIGlnbm9yZXMgdGhpcywgYmVj
YXVzZSBpdCBpcyBzdGlsbCB0cmFuc21pdHRpbmcuDQo+ID4gNSkgSFcgdHJhbnNtaXRzIFRYIGRl
c2NyaXB0b3IgNy4NCj4gPiA2KSBIVyByZWFjaGVzIGRlc2NyaXB0b3IgODsgYmVjYXVzZSB0aGlz
IGRlc2NyaXB0b3INCj4gPiDCoMKgIGhhcyBhbHJlYWR5IGJlZW4gcHJlZmV0Y2hlZCwgSFcgc2Vl
cyBhIG5vbi1hY3RpdmUNCj4gPiDCoMKgIGRlc2NyaXB0b3IgKFRYX1VTRUQgc2V0KSBhbmQgc3Rv
cHMgdHJhbnNtaXR0aW5nLg0KPiA+IA0KPiA+IEZyb20gZGVidWdnaW5nIHRoZSBjb2RlIGl0IHNl
ZW1zIHRoYXQgdGhlIFRVQlIgaW50ZXJydXB0IGhhcHBlbnMsDQo+ID4gd2hlbg0KPiA+IGEgZGVz
Y3JpcHRvciBpcyBwcmVmZXRjaGVkLCB3aGljaCBoYXMgYSBUWF9VU0VEIGJpdCBzZXQsIHdoaWNo
IGlzDQo+ID4gYmVmb3JlDQo+ID4gaXQgaXMgcHJvY2Vzc2VkIGJ5IHRoZSByZXN0IG9mIHRoZSBo
YXJkd2FyZToNCj4gPiBXaGVuIGxvb2tpbmcgYXQgdGhlIGVuZCBvZiBhIHRyYW5zZmVyIGl0IHNl
ZW1zIEkgZ2V0IGEgVFVCUg0KPiA+IGludGVycnVwdCwNCj4gPiBmb2xsb3dlZCBieSBzb21lIG1v
cmUgVFggQ09NUExFVEUgaW50ZXJydXB0cy4NCj4gPiANCj4gSSByZWNhbGwgdGhhdCB0aGUgZG9j
dW1lbnRhdGlvbiBmb3IgdGhlIFRVQlIgaXMgcmF0aGVyIHNwYXJzZSwgc28gdG8NCj4gYmUNCj4g
c3VyZSBhYm91dCB0aGUgc2VtYW50aWNzIGhvdyB0aGlzIGlzIHN1cHBvc2VkIHRvIHdvcmssIGlu
dGVybmFsDQo+IGRvY3VtZW50YXRpb24gd291bGQgaW5kZWVkIGJlIHZhbHVhYmxlLg0KDQpJdCB3
b3VsZCBiZSBuaWNlIGlmIENhZGVuY2Ugd291bGQganVzdCBtYWtlIHRoZSBkb2N1bWVudGF0aW9u
IGZvciB0aGlzDQpjb3JlIGZ1bGx5IHB1YmxpYy4NCg0KQ0NpbmcgSGFyaW5pIGZyb20gWGlsaW54
IHdobyBhZGRlZCBzb21lIHByZXZpb3VzIHdvcmthcm91bmRzIHJlbGF0ZWQgdG8NCmRlc2NyaXB0
b3IgcHJlZmV0Y2guIERvIHlvdSBoYXZlIHNvbWUgbW9yZSB2aXNpYmlsaXR5IGludG8gaG93IHRo
aXMNCm1lY2hhbmlzbSBpcyBzdXBwb3NlZCB0byB3b3JrPyBHaXZlbiB0aGF0IHRoZSBkcml2ZXIg
aXMgcG90ZW50aWFsbHkNCm1vZGlmeWluZyBkZXNjcmlwdG9ycyB0byBhZGQgbmV3IGVudHJpZXMg
cmlnaHQgaW4gZnJvbnQgb2YgdGhlDQpoYXJkd2FyZSdzIGN1cnJlbnQgcG9zaXRpb24gaW4gdGhl
IHJpbmcsIEknbSBub3Qgc3VyZSBob3cgaXQgY2FuIGJlDQphdm9pZGVkIHRoYXQgaXQgZW5kcyB1
cCBwcm9jZXNzaW5nIHN0YWxlIGRlc2NyaXB0b3IgdmFsdWVzIGFuZCBlbmRpbmcNCnVwIGluIHRo
aXMgVFhVQlIgc3RhdGUsIHdoaWNoIGl0IHNlZW1zIG1heSBzb21ldGltZXMgbm90IGJlIGhhbmRs
ZWQNCnByb3Blcmx5LiBNYXliZSBpZiB0aGVyZSB3YXMgYSB3YXkgdG8gaW52YWxpZGF0ZSB0aGUg
cHJlZmV0Y2hlZCBlbnRyaWVzDQphZnRlciBtb2RpZnlpbmcgdGhlIFRYIHJpbmcsIGJ1dCB0aGF0
IG1pZ2h0IHN0aWxsIGJlIHJhY3kuIElmIHRoZQ0KcGVyZm9ybWFuY2UgaW1wYWN0IGlzIG5vdCB0
aGF0IG11Y2gsIGl0IG1pZ2h0IGJlIGVhc2llc3QgdG8ganVzdA0KZGlzYWJsZSBUWCBkZXNjcmlw
dG9yIHByZWZldGNoIGlmIHRoZXJlIHdhcyBzb21lIHdheSB0byBkbyBzby4NCg0KDQo+IA0KPiBU
aGFua3MsDQo+IFRvbWFzDQo+IA0KPiANCj4gPiBBZGRpdGlvbmFsbHkgdGhhdCBtZWFucyBhdCB0
aGUgdGltZSB0aGUgVFVCUiBpbnRlcnJ1cHQgaGFwcGVucywgaXQNCj4gPiBpcyB0b28gZWFybHkg
dG8gd3JpdGUgdGhlIFRTVEFSVCBiaXQgYWdhaW4sIGJlY2F1c2UgdGhlIGhhcmR3YXJlIGlzDQo+
ID4gc3RpbGwgYWN0aXZlbHkgdHJhbnNtaXR0aW5nLg0KPiA+IA0KPiA+IFRoZSBhbHRlcm5hdGl2
ZSBJIGltcGxlbWVudGVkIGlzIHRvIGNoZWNrIGluIG1hY2JfdHhfY29tcGxldGUoKSBpZg0KPiA+
IA0KPiA+IDEpIFRoZSBUWCBRdWV1ZSBpcyBub24tZW1wdHkgKHRoZXJlIGFyZSBwZW5kaW5nIFRY
IGRlc2NyaXB0b3JzKQ0KPiA+IDIpIFRoZSBoYXJkd2FyZSBpbmRpY2F0ZXMgdGhhdCBpdCBpcyBu
b3QgdHJhbnNtaXR0aW5nIGFueSBtb3JlDQo+ID4gDQo+ID4gSWYgdGhpcyBzaXR1YXRpb24gaXMg
ZGV0ZWN0ZWQsIHRoZSBUU1RBUlQgYml0IHdpbGwgYmUgd3JpdHRlbiB0bw0KPiA+IHJlc3RhcnQg
dGhlIFRYIHJpbmcuDQo+ID4gDQo+ID4gSSBrbm93IGZvciBzdXJlLCB0aGF0IEkgaGl0IHRoZSBj
b2RlIHBhdGgsIHdoaWNoIHJlc3RhcnRzIHRoZQ0KPiA+IHRyYW5zbWlzc2lvbiBpbiBtYWNiX3R4
X2NvbXBsZXRlKCk7IHRoYXQncyB3aHkgSSBiZWxpZXZlIHRoZQ0KPiA+ICJFeGFtcGxlIFNjZW5h
cmlvIiBJIGRlc2NyaWJlZCBhYm92ZSBpcyBjb3JyZWN0Lg0KPiA+IA0KPiA+IEkgYW0gc3RpbGwg
bm90IHN1cmUgaWYgd2hhdCBJIGltcGxlbWVudGVkIGlzIGVub3VnaDoNCj4gPiBtYWNiX3R4X2Nv
bXBsZXRlKCkgc2hvdWxkIGF0IGxlYXN0IHNlZSBhbGwgY29tcGxldGVkIFRYDQo+ID4gZGVzY3Jp
cHRvcnMuDQo+ID4gSSBzdGlsbCBiZWxpZXZlIHRoZXJlIGlzIGEgKHZlcnkgc2hvcnQpIHRpbWUg
d2luZG93IGluIHdoaWNoIHRoZXJlDQo+ID4gbWlnaHQgYmUgYSByYWNlOg0KPiA+IDEpIEhXIGNv
bXBsZXRlcyBUWCBkZXNjcmlwdG9yIDcgYW5kIHNldHMgdGhlIFRYX1VTRUQgYml0DQo+ID4gwqDC
oCBpbiBUWCBkZXNjcmlwdG9yIDcuDQo+ID4gwqDCoCBUWCBkZXNjcmlwdG9yIDggd2FzIHByZWZl
dGNoZWQgd2l0aCBhIHNldCBUWF9VU0VEIGJpdC4NCj4gPiAyKSBTVyBzZWVzIHRoYXQgVFggZGVz
Y3JpcHRvciA3IGlzIGNvbXBsZXRlZA0KPiA+IMKgwqAgKFRYX1VTRUQgYml0IG5vdyBpcyBzZXQp
Lg0KPiA+IDMpIFNXIHNlZXMgdGhhdCB0aGVyZSBzdGlsbCBpcyBhIHBlbmRpbmcgVFggZGVzY3Jp
cHRvciA4Lg0KPiA+IDQpIFNXIGNoZWNrcyBpZiB0aGUgVEdPIGJpdCBpcyBzdGlsbCBzZXQsIHdo
aWNoIGl0IGlzLg0KPiA+IMKgwqAgU28gdGhlIFNXIGRvZXMgbm90aGluZyBhdCB0aGlzIHBvaW50
Lg0KPiA+IDUpIEhXIHByb2Nlc3NlcyB0aGUgcHJlZmV0Y2hlZCxzZXQgVFhfVVNFRCBiaXQgaW4N
Cj4gPiDCoMKgIFRYIGRlc2NyaXB0b3IgOCBhbmQgc3RvcHMgdHJhbnNtaXNzaW9uIChjbGVhcmlu
ZyB0aGUgVEdPIGJpdCkuDQo+ID4gDQo+ID4gSSBhbSBub3Qgc3VyZSBpZiBpdCBpcyBndWFyYW50
ZWVkIHRoYXQgNSkgY2Fubm90IGhhcHBlbiBhZnRlciA0KS7CoA0KPiA+IElmIDUpDQo+ID4gaGFw
cGVucyBhZnRlciA0KSBhcyBkZXNjcmliZWQgYWJvdmUsIHRoZW4gdGhlIGNvbnRyb2xsZXIgc3Rp
bGwgZ2V0cw0KPiA+IHN0dWNrLg0KPiA+IFRoZSBvbmx5IGlkZWEgSSBjYW4gY29tZSB1cCB3aXRo
LCBpcyB0byByZS1jaGVjayB0aGUgVEdPIGJpdA0KPiA+IGEgc2Vjb25kIHRpbWUgYSBsaXR0bGUg
Yml0IGxhdGVyLCBidXQgSSBhbSBub3Qgc3VyZSBob3cgdG8NCj4gPiBpbXBsZW1lbnQgdGhpcy4N
Cj4gPiANCj4gPiBJcyB0aGVyZSBhbnlvbmUgd2hvIGhhcyBhY2Nlc3MgdG8gaGFyZHdhcmUgZG9j
dW1lbnRhdGlvbiwgd2hpY2gNCj4gPiBzaGVkcyBzb21lIGxpZ2h0IG9udG8gdGhlIHdheSB0aGUg
ZGVzY3JpcHRvciBwcmVmZXRjaGluZyB3b3Jrcz8NCj4gPiANCj4gPiBzbyBsb25nDQo+ID4gwqAg
SW5nbw0KPiA+IA0KPiA+IA0KPiA+IEluZ28gUm9obG9mZiAoMSk6DQo+ID4gwqAgbmV0OiBtYWNi
OiBBIGRpZmZlcmVudCB3YXkgdG8gcmVzdGFydCBhIHN0dWNrIFRYIGRlc2NyaXB0b3IgcmluZy4N
Cj4gPiANCj4gPiDCoGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYi5owqDCoMKgwqDC
oCB8wqAgMSAtDQo+ID4gwqBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5j
IHwgNjcgKysrKysrKysrLS0tLS0tLS0tLS0NCj4gPiAtLS0tDQo+ID4gwqAyIGZpbGVzIGNoYW5n
ZWQsIDI0IGluc2VydGlvbnMoKyksIDQ0IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IC0tDQo+ID4g
Mi4xNy4xDQo+ID4gDQoNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNp
Z25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg0KDQo=
