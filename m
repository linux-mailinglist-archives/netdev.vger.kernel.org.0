Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76E6602463
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJRG3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiJRG31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:29:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B061F62F3;
        Mon, 17 Oct 2022 23:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666074565; x=1697610565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ggSqJmvEMExy042NownM5tAtadOWzUQVLHw1l1sfz0o=;
  b=1BmvDITuVRUvgvuB1i+y0lmkD23WAnudiAJW9mHzR9Btc0A4Wg+QZrCU
   RDoLuUZd9EPPr6Xo/S8O7XsUbQKt6+lBZPJ0HNoAuq1Qu6j7R6xTqn32x
   vm/PqCRYULLZe8ZbLo4lh2Tqg3IeHi9CDYYEIE8J06L+JjyiO8DoKPnVr
   wAaA5oBx+FyzAq+nZG5qEcs1n6BKCAOsLjbeYyRpiNQlhSMTIYoYHTX+i
   tabu+EGR9LJRSSxb8uYjzee9cyjwhcvR9HE22ZhkmzBbzOlqGp1/NHxrk
   rgq8G1kt95hupLr0Q+SWSImcxj0oRR8AdN1dWj05B/l1FNECpnZmVgbuN
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="182666425"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Oct 2022 23:29:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 17 Oct 2022 23:29:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 17 Oct 2022 23:29:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PS7ZO2dHUaEP1SbqDyIkJVU7jeIKCIwDJK6+d956+VAHramffNzUv9SmcDkR4oCKDCqnjDS0AIkcmfYZHEvToMGNLn60i+GDMubnPmRXisw/4l8gG9OFXVB7RmKod9u3RDYCQaxpucbkf7CBQKA31zM9gdAfmg7qzPJAGMWHgy3gEQ+QgCpcHWpe2KfY3va7QGwjZh0d5HRTdt5yKVNJ4wgquzvARjn/QdB64XTGOepSOR9NfpalLJrEEfdmBfayb2bM28p1UVk9GvhXedaenvotY7NS6Cl17MrAV1xgSbzN1QKw80Y0qy2QMZpWGY3j8BBLPTcbGMnPqvgpvRsW8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggSqJmvEMExy042NownM5tAtadOWzUQVLHw1l1sfz0o=;
 b=lOHeAn7V29YNGux9NitrNpYvJWxggJQj7OzZXmoQNEELjecdIURlX+4Thmzqbj4iysVjGn6AfxlERdCZANlHH693/zxJZuGLhYY23gAGVREESTTE9AFDhijUQIIxFgGPwZdcCPEkW+76dKfsKjSnRhy/NZbsStRGTBfL0VhLYMXzzVODTlLdqBZ0/gZaiCXcTcYxXVSh1nDdovr/5Otc8D2N6tqFBbcL1I/qRMrg37BSNkbDQ0mthbbUbCV1eNPerxXOPEi7NVRtMB8aZTC6WyWJprISK73QLpNU8Gk7Eck/v5T8RQuBAgYuz/R/Rp73j5IyMIqIqMUfiTvpSnRG1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggSqJmvEMExy042NownM5tAtadOWzUQVLHw1l1sfz0o=;
 b=r7nwlPFY2+UfNShMX99ruWq76uZjYeP4ypWZSfStoZqGaZC95rsbTYIOeZeWrG9ZelwyKpP35J+afERU3+fvFZWZlpDJLySp6mRYF9NMuqlMh+ziu2WHUXM/IMCp2OGtrt4+MVEQzVkAg1h5xhlKPqHTPMYnE1tzqGe1yO8ET2s=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CY5PR11MB6185.namprd11.prod.outlook.com (2603:10b6:930:27::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.30; Tue, 18 Oct 2022 06:29:17 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7%3]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 06:29:17 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Thread-Topic: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Thread-Index: AQHY3+HGUZklSl35HUmvWc+BxQ194q4S8d2AgADEQwA=
Date:   Tue, 18 Oct 2022 06:29:17 +0000
Message-ID: <ce76fa72ad1dd9d4f86a0bdcbd2ae473e2f29262.camel@microchip.com>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
         <20221017184649.meh7snyhvuepan25@skbuf>
In-Reply-To: <20221017184649.meh7snyhvuepan25@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|CY5PR11MB6185:EE_
x-ms-office365-filtering-correlation-id: cdb2ec21-d912-46ed-d305-08dab0d21589
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WrlborN6s/3cqvbUgbfAembsC86BCUe4FyVH2uSITGj1litofgfbQ/vRYDkP+z0v/hmNne8b+WiPOhFXQiAvRakfpAMvYPEP+BYQ3rLFaJl6/wfVQ4k8eGm/Q5AdvKEb6C5Hws1rIq84vJGVmmShUANmaCgrHlLQ/SVf6FOo5JUFROi+1puMNFY/Hl5pRvqoGbG6aONsio9A7Sh+WLjFs+vaaaXDzjhFGfuGlPj4cIZ9n2UAakbufiI+JTshlb7dnpCKqR1u1ck/wM+e0EZgWqYD9Rf5BUMp/PTy1bdvmZWvFaJg5sxwCozZQbwC9tKM9NSyUOwdAqcdRjPPIWfyejyQUaMJotd69pRrwCVViw2SBQwgAAQWr8Qe/1K3elrWPtoBInFo1vIFPRodJA1CsTorI3pXfmC8zyKyRLmO9n0hxEHJJXlDoRqoGsBNF2AE9s8vfAP4UgVXTQlFblkWstgVvGGFk9NPpk4Pq9ARnmhUu+pGggwJXhsJuxJrZCw1U4hDQew4cYxsA+v3CksrSoi21CuYdcBvJ2CDTGH2AH2igEqBCm1pVeOEUNYARtu1kclD5hh5AjcEBg6qAOUWcKOae6auSRq2saIgollKvUr6Fq2WUikeMUX3lmJMlth4EbBO1qcKkHqLyIQfftI6pwnZaCjT42pkDlzqmLq9T2F/p7W9/bBYFbRPZKU01ZGXVgBTkPu8xEAdUbrP4QQtshQcCNZ9UVFx4ey4BiawRdqzmNf8xsTqDl/JFjssCeS0e2LVzihHwvVyZD3Z/A96YJMa/CbZGTSai4DDibysRhE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(6916009)(4326008)(54906003)(8676002)(91956017)(66476007)(66446008)(66556008)(36756003)(41300700001)(6506007)(76116006)(64756008)(5660300002)(26005)(316002)(7416002)(6512007)(86362001)(8936002)(4744005)(2906002)(4001150100001)(186003)(66946007)(38100700002)(71200400001)(2616005)(38070700005)(6486002)(122000001)(478600001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VU56MXFYTnpBOC9ZaURBdXMzK3BzTDAvYzUrYXlxNnJKbzRHYlJXL1d5cXZM?=
 =?utf-8?B?Y3JWdGxUYVVQS3p4ZTVETXI1eFM5Q1NCakpzanl6TGpSREVaVkVIMFZyNS9k?=
 =?utf-8?B?SjJOejhnQjlWQ0cvL0dleWY3YTViRnRGeU0rbG90TU01cG1SZmovOUd4OWhq?=
 =?utf-8?B?VmZwZ1BLSXFvaTJxeklzcE1nUXB2WnUvTHBlTVhLRnN4d3kyM1N2bWVlUlFj?=
 =?utf-8?B?bGFIL0tqVEU2Y3l5TFlmRTRIbXJCdTV0WnZ1bXU2WEp5c21aalRsT09MTDAw?=
 =?utf-8?B?cHpZMW1KY0FBKzZ4QXM0YXdNNmp6WkN2KzhYejVWUE9MZ3dIaFNkK3ExaW9Z?=
 =?utf-8?B?UmZPWHo5T1VicVFVZ2N0MGJUQ1VvZEVvL1NVOTJjeFZjVHp4ZkZoUkxpKzB1?=
 =?utf-8?B?dGVLbUpRTXplVEI3ZEFPTVdzUGVCcmNaVUVTbDNLekd2a3hDeHRwREZrSlVq?=
 =?utf-8?B?RTJrL2M4QUdINklZOGRNUWp2NWxHWExlOFRNcGJaeHhWUFBGaVNBUGtRNDZT?=
 =?utf-8?B?M09pK0dCSHNYUjFyWXU2djg4TDdxcFQzUG42SlhqY0tFT0s3SFhobkVrbXFM?=
 =?utf-8?B?SlB0U1Mya3Z4VjVzOVVZQmlPbHRlRUs5dS9zNDNtSTQ2VHhqMnNjUnVNeWNB?=
 =?utf-8?B?VEl5VFQxNjAyS0N3WXhXTHgrdzJ6a28zRkpSby9ZN3NjSVFlamZBaElwZnp2?=
 =?utf-8?B?N0oyWXFFakp3ZS9ncGRGZ3pOakpxcW9LaG5HYy9Xemcweitacm4zeVVaV09C?=
 =?utf-8?B?V1Z1MmFsMktzYTFWS0pnVmdCYXBSMjRBdE5yYitVdzVudUd3R0p2RTBUWFB3?=
 =?utf-8?B?d3J0cFRhZWhHUmppS25GRittV1lGaWtSdE4vVUd5Rkg2TFdRK01BOUkwaEtW?=
 =?utf-8?B?OWFLSjZNMzB2dTNKcjdUZGNzcXRpUnVnTzZXRjRPM3crMjNCWjVudlQ1aENu?=
 =?utf-8?B?WXpMQXVCOHozRllkNlNaUjJZckxsSDNMVTdyaHN6bSttRTlVclhYdHlrR2xE?=
 =?utf-8?B?K3lleWo3VGxacFl6cXRhRFF6NXlxekFRTGN1c3dUVGJmbHcyYktjN3FIQS9Z?=
 =?utf-8?B?TFlnRG5VblZXcmZ3MWtTMXZTU25wdzFvK0Z4MVphVzZYYVo1MmJ1QXg4YjFE?=
 =?utf-8?B?Z1YxTzU5TTVsaVZQM05JRkFJdUNpYUhOY2Zjam1jV0pqeHpCbzZGT3IzTmdo?=
 =?utf-8?B?TmlHd2VDZGU0TDdnMkdtK1BtOUtPN0pCcGhiL0xBRXZ5MzNCR0krMll2RC91?=
 =?utf-8?B?dWdDRnBPdmpWcUNuNHNCL1ZmK2pBRmhEd3ZSK3hjeVNpWjViTWhuRWZ3dVJp?=
 =?utf-8?B?cnZtZitnNDhkY2wvMHQvdUpSQTd2UFRCNDhSSWlzRzNmUHZnbkNxVTFwZWVX?=
 =?utf-8?B?SHNVVzY1ZGxVNUU1eC8wcWtCbnJTNjJUN1F5NWxFSE1aTUNpcTZwUlRmMGVL?=
 =?utf-8?B?WHlCZmNLNW9pblRITUpScHl0UWlXKzhqS28xN2FQbnc0TE5WaDhPaHJtdE95?=
 =?utf-8?B?RFl2T1BMc3ppRWVPYmJ2NWxsUE5OelZQcG1hK2pLSVpub2h1QzNaOTZMb0Uz?=
 =?utf-8?B?dXFOUFFsV3pwdm1Tc0g4YjYvQlVyNHZWS3dueFhHK2JzeGxYa1ZUOEh4Sldy?=
 =?utf-8?B?STJtMHNVemVzaSszbkpCTXFIWFpMcTUwU2ZaaVlPenFHSWZaSHNMN3J0OS9G?=
 =?utf-8?B?MmNtcUorUDZZZHI3c3lDK1MrcXRSZExLcXBEYXdBV0lCNnBIdHN2T2JIcSs2?=
 =?utf-8?B?SzlzTFFhUmpEUkFSOEhhejlvRVNUZ0ZHaExZSDRua1l0SGU3VFFMQ2hVc1FT?=
 =?utf-8?B?ZUptM0dVVU1qWkhsVWFuZWhBVXlUanJLL3FjcEV2R1BnRXlEU3BNZUJIUlM0?=
 =?utf-8?B?bWlDT0F6UjZwYzRaVThhcU5BQnlXYmVVYXlJM1pwRlhwQmVlWkk0ZUcyWTJL?=
 =?utf-8?B?Vk1KOGpqMFBSYlM1RE5VVko4bk4xdlNidXBWSXJaOWdOelRTUGNDNVFCMGlP?=
 =?utf-8?B?Y2p4VkVXaHdSbitjVEtPYnV0WUdhVkZHL3hveFo5VE9oWXB5RGRzaHNVbzVQ?=
 =?utf-8?B?S0YrZHVwdWNWRzU3NHNIRmU2QWMzQlI1T01BYml4aWdKMUJIMkxlaExaeDFN?=
 =?utf-8?B?dkhUbGpFODNZTWo5cGdBR0h5WHlyejdDYUJ6VGQyeUxZVXlKM001cmRxYndR?=
 =?utf-8?Q?1j3nOiMNgT3TotbYgYEmjR8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53BF939DE8F3F347A0CFA636B6E0C8E3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb2ec21-d912-46ed-d305-08dab0d21589
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 06:29:17.7164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q/+cjroJCP9QA6bwgX1wbFCyXG/Dcn2U20Qf281IKgI/RHOfZ0XtwpddJjMtFV5MaEkdVcsrOZEUQ3fKvsfp7jiaj04m/ITzy8rvXQ9Pa9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6185
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTE3IGF0IDIxOjQ2ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCkhpIFZsYWRpbWly
LA0KDQo+IE9uIEZyaSwgT2N0IDE0LCAyMDIyIGF0IDA4OjU4OjUxUE0gKzA1MzAsIEFydW4gUmFt
YWRvc3Mgd3JvdGU6DQo+ID4gVGhlIExBTjkzN3ggc3dpdGNoIGhhcyBjYXBhYmxlIGZvciBzdXBw
b3J0aW5nIElFRUUgMTU4OCBQVFANCj4gPiBwcm90b2NvbC4gVGhpcw0KPiA+IHBhdGNoIHNlcmll
cyBhZGQgZ1BUUCBwcm9maWxlIHN1cHBvcnQgYW5kIHRlc3RlZCB1c2luZyB0aGUgcHRwNGwNCj4g
PiBhcHBsaWNhdGlvbi4NCj4gPiBMQU45Mzd4IGhhcyB0aGUgc2FtZSBQVFAgcmVnaXN0ZXIgc2V0
IHNpbWlsYXIgdG8gS1NaOTU2MywgaGVuY2UgdGhlDQo+ID4gaW1wbGVtZW50YXRpb24gaGFzIGJl
ZW4gbWFkZSBjb21tb24gZm9yIHRoZSBrc3ogc3dpdGNoZXMuIEJ1dCB0aGUNCj4gPiB0ZXN0aW5n
IGlzDQo+ID4gZG9uZSBvbmx5IGZvciBsYW45Mzd4IHN3aXRjaC4NCj4gDQo+IFVucmVsYXRlZCB0
byB0aGUgcHJvcG9zZWQgaW1wbGVtZW50YXRpb24uIFdoYXQgdXNlciBzcGFjZSBzdGFjayBkbw0K
PiB5b3UNCj4gdXNlIGZvciBnUFRQIGJyaWRnaW5nPw0KSSBoYWQgdXNlZCBMaW51eFBUUCBzdGFj
ayBmb3IgdGVzdGluZyB0aGlzIHBhdGNoIHNldCBhbmQgaW4gc3BlY2lmaWMNCmxpbnV4cHRwL2Nv
bmZpZ3MvZ3B0cC5jZmcgDQoNClRlc3QgU2V0dXAgaXMgb2YNCkxBTjkzNzAgRFVUMSA8TEFOMT4g
LS0tIExBTjkzNzAgRFVUMiA8TEFOMT4NCg0KUmFuIHRoZSBiZWxvdyBjb21tYW5kIGluIGJvdGgg
RFVUUw0KI3B0cDRsIC1mIH4vbGludXhwdHAvY29uZmlncy9ncHRwLmNmZyAtaSBsYW4xDQoNCi0N
CkFydW4gDQo=
