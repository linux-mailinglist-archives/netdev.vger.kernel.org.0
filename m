Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176C44F438A
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386018AbiDEUFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450413AbiDEPvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:51:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CB61BB783
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 07:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649169666; x=1680705666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xs0bm3BzFz/LwjbYy4cm6iDmmJkyHyM+xnFZ7d8nU4E=;
  b=wNEvR4s+pcDLK+8G6lfONebdXeUuMUADxVwL7kOM9LaS53ifX0+hzHQH
   C06nEjOvUhMZfo0wF9LjwX6lRMR3XXWnp6kvleKfWNS64Jt+Gsdr6NLdW
   snCcM/S10yZBwopDPaOR6f2WXb6Ro8Z3M/8eshs2P02cUYoVKiDJyHj3x
   n3IEIZEUij7zpRpFnPlkFMlggqxOVBSw+MQP6GVmn1iuc+JT7y3y75pKK
   0id1+51NPeaQN1+d5/bM00j/2pXGQ0HICyTMxi8kg9dEi6hX6aNaC9E8x
   N6MJI0LYO+8SoajJAhJz626Eb+RbNvxH2ZATdRJj8At4wB5Myn7pR8QZ8
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="159375711"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2022 07:41:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Apr 2022 07:41:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 5 Apr 2022 07:41:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTM3fJLKZAg1YZvMzESigRTx1Qe9Fn95YJqW54hL2ptjaneJTeU2iseLex9U0tsBJVbrl6tjZcX2qTsnEIKsJDHa9OcIg+ZbQd5DK996rWUUIX8MWJBG2k8QqQ8uL9Q0x+zc5FvCzozN2xQa0PGRO1MXA5h0j6EWvmJhMmdvhND0T0IinFQ3995ZxJ7ccJ71ApiMnWGidBFk+A7N2+Gp+1XOLZrQkj/OmS5s3lwZIB2u1VpuLzXRKE+u9qiNWsRXuaNo/iekCfulrM+AvPmbNf8BY9L05tAXtgFZ4Mq3b03GYgpvPT6DDQWm1ZAjP4wKz3b05/pakcdSAkvyJEG8lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xs0bm3BzFz/LwjbYy4cm6iDmmJkyHyM+xnFZ7d8nU4E=;
 b=jHIz6pxeYosSwYGzSUG2pP5G5u7+kiKhmoI6g7/b/rSaxMqwk7ByLNtPSfd0TAT0BTrtrujJbt/gUzK3b11B++vHYhPGsENTvaju/QwZFU1rIDzoO/Yxl7oLRNSL6N3W6A8GCCQV+OC0/YJhS2vjzLFz0mcd6wGMv4ds41aJFPyYuwOyvmyXCK+vOrIcZkpFS5Ifd9LVUdJTBiI/dgutkVDmP1Wb5b9KN/Iv18+2wIoeujriKhU8aO8AxtpBViTyCPbJB2UrqGSGi/7ogPM2nmoFToA7krz7DlBsNV0Wv/dKhMuUoH2KXxCyvYGscO/Qt7MSYRNRgA2DPMMGk2tXAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xs0bm3BzFz/LwjbYy4cm6iDmmJkyHyM+xnFZ7d8nU4E=;
 b=qvVd59uXf1mqgMbWugKKpuh8iU4MMSf08wW3lBe+7hrqbjddZ/cmns0NSt/CinlCjATYbHm9POz4BY6JrhhfJpNXiuVucRMCSIF1E9SrBhO+ZeeHwHcl5giHOzvftJPsl0iAkw+dtruCEHLn7OGCSHle8/L1riBz4RWxSS9+/cA=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:95::7)
 by BN6PR11MB4179.namprd11.prod.outlook.com (2603:10b6:405:76::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 14:41:00 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::dc95:437b:6564:f220]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::dc95:437b:6564:f220%8]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 14:41:00 +0000
From:   <Conor.Dooley@microchip.com>
To:     <andrew@lunn.ch>
CC:     <palmer@rivosinc.com>, <apatel@ventanamicro.com>,
        <netdev@vger.kernel.org>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <linux@armlinux.org.uk>,
        <hkallweit1@gmail.com>, <linux-riscv@lists.infradead.org>
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Thread-Topic: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Thread-Index: AQHYSO3IJSdXwoud5UqKTAwCCAurg6zhT02AgAAOuACAAAZaAA==
Date:   Tue, 5 Apr 2022 14:41:00 +0000
Message-ID: <60fd1eb7-a2ce-9084-c567-721e975e7e86@microchip.com>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
 <YkxDOWfULPFo7xFi@lunn.ch>
 <98b571fb-993e-9fe1-1cf9-dc09651feb0b@microchip.com>
In-Reply-To: <98b571fb-993e-9fe1-1cf9-dc09651feb0b@microchip.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1917be7e-72cb-45f3-469b-08da17124db6
x-ms-traffictypediagnostic: BN6PR11MB4179:EE_
x-microsoft-antispam-prvs: <BN6PR11MB417992933A5C7FEE00814D5E98E49@BN6PR11MB4179.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: guNXA6oPDGOM2miLRvVvLhFms48Q4hvBj5CtgIwMHgmUGcBylYGXuMAM8WQzjYHoxWx7ozAWJ0n3QRs77SILQNQwisNsvImTNOT02oZbYu1epN24r14fEr9wlD4pD8d1HYMg0vfKj/ng91wFe3tcRCtjtu7TFXnX3ENvX2kpQS0z3zp2sAKCPRXckxqU8q3XhaG+bifPjU6GTVlFEvn2Qnrq3UA4ltE9jYHfLfokbqn2OJJsihulNwyx5aYn3EXBjl6U4qwiLufEhzBnZNOw5JEcH99L4d3d9aDZtkGdx7DVUdKsTkAQPAtx8mkDWqQtmBld8mOx4YcgOmA0vGqDAyfmati6X7Gc07yWk2oOXe47tIcPVEHegXiKgy+PypiotLuccg7Gi1kyZ+Rzls2eEmvkZtEKJOE3HkouUwVnaFD1wozMfHq6WAgOyWqup3r/QV7s20xsGIGkwoVnlqAsyDrHlQEOr6RTQEUO23yOUvB5OIMOEeDQrCMiqOQNGMPY595qeLXdF0WEXtTQUx3l8sZLyabFAKcFdMC3kVj93ZoTNWnDDC1/o1eW3i75vJmOiQNMtpX2QtXjN3VdJLcACrcdu9sLvao7box0k2vXBfKOV7iyfbxNlMAUDevWho8GEy1pai39MGvQiTtadbgP7LQNHajEclkNR9ObGAyyOav/TfegOD2noBpx95vR5CnRocC0Pu9a6wkWB4rnjrnIHAdQ0B2rtTZ/xAlVdyoXakamfsaU2mToLrhIXmBY7g0onc8AWKIG9Sq+pkeFkLs1v0KYDH1whAsEYC58EymhwMj7frkk4nTjNrKITMGyF0SKy3neXdlbEzOkYR6++P7pHaqS2/Pc0nMIa3Au+EghSx++HQLHxTdtpOXteamlbD1I
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(38070700005)(38100700002)(86362001)(122000001)(5660300002)(71200400001)(31696002)(31686004)(76116006)(6512007)(6506007)(26005)(186003)(8936002)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(91956017)(6486002)(966005)(66946007)(316002)(508600001)(54906003)(83380400001)(2616005)(36756003)(2906002)(6916009)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjFnV01zYk9hQnhaSXMwZlRzeGJZcHU5VGtjNG8rY1JTdVNQb2NSSlhhZ2ty?=
 =?utf-8?B?cldrS1RsalRaOEgwMXduUzZaKy84RERvT2VVdXAxWVhUdERPR2JnQzhVRWV5?=
 =?utf-8?B?YjZPZFVBeTlFZnB4Mlplcll3SEl2aS93NEFzTnNndGZ3SXVjK2JuMGliN2VK?=
 =?utf-8?B?UitFYlZIZ1VoWHk0MURlZTh5dHliWGdCeVVPMXp2YXY4ZG1NSXNCN1h6ZS9C?=
 =?utf-8?B?UlNIMzZmVU5ZRWVRdllMbkt1OEVrRkF4V0xYQTZkaWlDUXhaNDlna2JTVHV3?=
 =?utf-8?B?ZnJ5RFJZNFpBQlo4cXQwY0o4bzUzQ2k5MFRNazRaVWdxT3A4NXhTSDVFcHBR?=
 =?utf-8?B?Z0hYdmxYWlRQT0dyV2VQNTRuVEFreWJuUktSUWpHaVhTU1RYRHBIeVJpODlY?=
 =?utf-8?B?aFhqTytoN04rd3liM1p2eTI1anJPa2gwNlpOSEF2RkJBTFg5eWpnVXE1S2FV?=
 =?utf-8?B?QU5TeUY2SmlGNGFZenBwUm5XR3VVc0k1S2V5QUd2UVVUNTVXZjdpTVUwZGZX?=
 =?utf-8?B?ZFBDSUlZOWZKQ29IVy9uZm9wZU1WeG5tVFZ3NDhUdFpCMy9CbHA5dXN1N2sr?=
 =?utf-8?B?c2ZCRDFBNWJna2dmUHpMSXJIWXBEcGNraEdCMUZ3V0k2NmVPL1oybC9EWHZX?=
 =?utf-8?B?RVRlTUM3TG80QnpzZFNVVTkvMk9HSDFaTmlUOU0xS29vSWRWVkVMNWlVZXpV?=
 =?utf-8?B?d2NTeHJ6MDdZUHllbE5XV0hJVVh5L3lBYTZVYmlHRHlzdzZnWjdnY3R6c3dx?=
 =?utf-8?B?SE5KRUhPWWdRMGRxRFFUL0U5aEJkaWhWd3RVbitwV0RSQnhmNDFpb0ZNRDVX?=
 =?utf-8?B?TW91eHRSY3VUVjJ2N1NVR0prSG9MWFNVL1ZFelI2TndIOEkvWlEvazR5OEVs?=
 =?utf-8?B?dGV6V2VySFMxNWZKeVBzYTJhMDBSbXNtVGtUTHRMeUpNYWJ0Sm12WTc5dkFM?=
 =?utf-8?B?a05KbDhrZzdwVVhoRFROUnBERWxxSDlKL3Jta1ZPNFRmQkw2TVNSc2dzMmkx?=
 =?utf-8?B?UTZJYS9saG1sT2JlRzd3bDZPSVZoNjY3Y0MwZHRKbUcvMGhDb3BMUGo5Vngv?=
 =?utf-8?B?R2s3K1lMdG53NnZWanNLaStEMld4VExTZlBldzF4WThaamRHdy9vdzZqdG85?=
 =?utf-8?B?Q0djNFhyVVVYNWJNTVlRS0lZeURJNlI2eVlUU1NDckRCRmxWSDVOczh5ZnpE?=
 =?utf-8?B?NHduZnI3bEc2THJvaVNqZWZnSGlYQVJXeFdQdVliRjVDdU5yaUVhUjRneHlu?=
 =?utf-8?B?cVFldEdDSXZOZSt3cllLbFNwKzFEN0VsV0VFcE5oaTB5UmJXc3RZcFIzR3dU?=
 =?utf-8?B?SHVROVNuUXdoRVlpT202WmpNNEFyQ2NpZlpUWnY2eElrNERhdHM4L1VjY2xK?=
 =?utf-8?B?MjhJeng2YkJWbUtscVB3YnJHeHo0Z0xTRlU0NTFBRzNES3hpRzNDbkw2bDM5?=
 =?utf-8?B?QnZXUWc0TjhuVFpuQWNQQWo3TUtoWjRsSk8zUE5HY0t3WEQ3TWsxUk5SRjEx?=
 =?utf-8?B?SmF4aXBXSWU2RDE2NHl1QTZxR3lESzk3cWUvQitFcUEvY2hybytDcVZJaFp3?=
 =?utf-8?B?TkhRcmFVYjVxb0oweW1OTE0rZ2htNi8yUS9HcjMrekp2eTh4bmo3YzlyQzZr?=
 =?utf-8?B?WFBrUkg2Zk5kRHpJSkdYaXFkUy83VmVha3hPelBuVnNzYTZaMjVQMkQ1eWQw?=
 =?utf-8?B?U0E3TGt0VDc4SjhVL2g0citRNFFIY2VsaEZPZDZhaDRka0VIUHN3VEtYdWpC?=
 =?utf-8?B?Tnovb0RueG5PczFoWk16QzkrM0ZKYkk2OGplZWtqVEtCblZRRExHa2lDM3Ex?=
 =?utf-8?B?SXIxTXNnM2VxZ2hsZ083Q21PekRwdHVvR3NtYk45d3J5VGcxYTZlc1NYVWRC?=
 =?utf-8?B?MVprQmdLcmZlUWlvUWYzYnUraWxGRklTKzNWS25PcU9yQ21QWVE4bFNyWW0z?=
 =?utf-8?B?TWYrNndTa2JhNmpLNFQ4WXFkMjZYOEVMeFl5UVQrdGJlZis0UW1JNUxJNkRw?=
 =?utf-8?B?UTRrT0E5ek96U2hYL3k1VTVUeHRhbXg0L25HQ3FRUHJuSUJPam50NXlQd3hj?=
 =?utf-8?B?RDlZT3RnZlZmWUE4UUROdWN0d0srUFZLL3VTRncwNE4yTHMyZlZMV0RGbmRM?=
 =?utf-8?B?NS9HLzI0VW1qUks3N1ZqeHViTzV2VzgydTdKaVRkaVh2cmJpNUYzUDB1SWxy?=
 =?utf-8?B?T3d4WHJrNUJaWFVVVDI0d1Bpang5NUtBSG1xcXZRbFN3N1NBUDFsT2t3Q2Rl?=
 =?utf-8?B?V2JYWFNvSkxJcDh5WFpieStQeVQ0SEo1eU0vWmFxWnVWQVYwVnJib1VoTE95?=
 =?utf-8?B?cmExeHpLVFJKL0J0WkM5THZzdE1Ielc5RHVVZkdGRmJEdXB0cFZJdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E991C3F6EF0AD4997E718FC661BD8A0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1917be7e-72cb-45f3-469b-08da17124db6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 14:41:00.6206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pFaQyNokkJWMEoOfkaAzesKy+BL+itH02PT06FJzhTlL4uJfNjCOXj0bxrM2l1lOhRlEhvacaiHP6iY/8wTvOf/SsSz95Srw2VaFPhghXgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4179
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDUvMDQvMjAyMiAxNDoxNywgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiANCj4gDQo+IE9uIDA1
LzA0LzIwMjIgMTM6MjUsIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4gT24gVHVlLCBBcHIgMDUsIDIw
MjIgYXQgMDE6MDU6MTJQTSArMDAwMCwgQ29ub3IuRG9vbGV5QG1pY3JvY2hpcC5jb20gd3JvdGU6
DQo+Pj4gWyAyLjgxODg5NF0gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBldGgwOiBQSFkgWzIwMTEy
MDAwLmV0aGVybmV0LWZmZmZmZmZmOjA5XSBkcml2ZXIgW0dlbmVyaWMgUEhZXSAoaXJxPVBPTEwp
DQo+Pg0KPj4gSGkgQ29ub3INCj4+DQo+PiBJbiBnZW5lcmFsLCBpdCBpcyBiZXR0ZXIgdG8gdXNl
IHRoZSBzcGVjaWZpYyBQSFkgZHJpdmVyIGZvciB0aGUgUEhZDQo+PiB0aGVuIHJlbHkgb24gdGhl
IGdlbmVyaWMgUEhZIGRyaXZlci4gSSB0aGluayB0aGUgSWNpY2xlIEtpdCBoYXMgYQ0KPj4gVlND
ODY2Mj8gU28gaSB3b3VsZCBzdWdnZXN0IHlvdSBlbmFibGUgdGhlIFZpdGVzc2UgUEhZcy4NCj4g
DQo+IEhpIEFuZHJldywgdGhhbmtzIGZvciB0aGUgcXVpY2sgcmVwbHkuDQo+IEl0IGRvZXMgaW5k
ZWVkIGhhdmUgYSBWaXRlc3NlIFZTQzg2NjIsIGJ1dCB0aGUgbGluayBuZXZlciBzZWVtcyB0bw0K
PiBjb21lIHVwIGZvciBtZSBbMV0gc28gSSBoYXZlIGJlZW4gdXNpbmcgR2VuZXJpYyBQSFkuIEkn
bGwgdHJ5IGxvb2sNCj4gYXQgd2h5IHRoYXQgaXMuIEVpdGhlciB3YXkgd291bGQgbGlrZSB0byBr
bm93IHdoYXQncyBnb25lIHdyb25nIGluDQo+IHRoZSBHZW5lcmljIFBIWSBjYXNlIHNpbmNlIHRo
YXQncyB3aGF0J3MgYXZhaWxhYmxlIGluIHRoZSByaXNjdg0KPiBkZWZjb25maWcuDQoNCkkgdGhp
bmsgSSBwdXQgdGhpcyBiYWRseSAtIHdpdGhvdXQgdGhlIHJldmVyc2lvbiBvZiB0aGUgQ09ORklH
X1BNDQphZGRpdGlvbiwgdGhlIGxpbmsgZG9lc24ndCBjb21lIHVwIGZvciB0aGUgVml0ZXNzZSBk
cml2ZXIgYnV0IHRoZXJlDQppcyBubyB2YWxpZGF0aW9uIGZhaWx1cmU6DQoNClsgICAgMS41MjE3
NjhdIG1hY2IgMjAxMTIwMDAuZXRoZXJuZXQgZXRoMDogQ2FkZW5jZSBHRU0gcmV2IDB4MDEwNzAx
MGMgYXQgMHgyMDExMjAwMCBpcnEgMTcgKDAwOjA0OmEzOjRkOjRjOmRjKQ0KWyAgICAzLjIwNjI3
NF0gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBldGgwOiBQSFkgWzIwMTEyMDAwLmV0aGVybmV0LWZm
ZmZmZmZmOjA5XSBkcml2ZXIgW1ZpdGVzc2UgVlNDODY2Ml0gKGlycT1QT0xMKQ0KWyAgICAzLjIx
NjY0MV0gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBldGgwOiBjb25maWd1cmluZyBmb3IgcGh5L3Nn
bWlpIGxpbmsgbW9kZQ0KKGFuZCB0aGVuIG5vdGhpbmcpDQoNCklmIEkgcmV2ZXJ0IHRoZSBDT05G
SUdfUE0gYWRkaXRpb246DQoNClsgICAgMS41MDg4ODJdIG1hY2IgMjAxMTIwMDAuZXRoZXJuZXQg
ZXRoMDogQ2FkZW5jZSBHRU0gcmV2IDB4MDEwNzAxMGMgYXQgMHgyMDExMjAwMCBpcnEgMTcgKDAw
OjA0OmEzOjRkOjRjOmRjKQ0KWyAgICAyLjg3OTYxN10gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBl
dGgwOiBQSFkgWzIwMTEyMDAwLmV0aGVybmV0LWZmZmZmZmZmOjA5XSBkcml2ZXIgW1ZpdGVzc2Ug
VlNDODY2Ml0gKGlycT1QT0xMKQ0KWyAgICAyLjg5MDAxMF0gbWFjYiAyMDExMjAwMC5ldGhlcm5l
dCBldGgwOiBjb25maWd1cmluZyBmb3IgcGh5L3NnbWlpIGxpbmsgbW9kZQ0KWyAgICA2Ljk4MTgy
M10gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBldGgwOiBMaW5rIGlzIFVwIC0gMUdicHMvRnVsbCAt
IGZsb3cgY29udHJvbCBvZmYNClsgICAgNi45ODk2NTddIElQdjY6IEFERFJDT05GKE5FVERFVl9D
SEFOR0UpOiBldGgwOiBsaW5rIGJlY29tZXMgcmVhZHkNCg0KPiANCj4gVGhhbmtzLA0KPiBDb25v
ci4NCj4gDQo+IFsxXToNCg0KPiANCj4+DQo+PiDCoMKgIEFuZHJldw0KPj4NCj4+IF9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+PiBsaW51eC1yaXNjdiBt
YWlsaW5nIGxpc3QNCj4+IGxpbnV4LXJpc2N2QGxpc3RzLmluZnJhZGVhZC5vcmcNCj4+IGh0dHA6
Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtcmlzY3YNCg0K
