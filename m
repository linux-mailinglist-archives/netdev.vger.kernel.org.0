Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E1F6A124A
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 22:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjBWVs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 16:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjBWVsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 16:48:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734CBF77B;
        Thu, 23 Feb 2023 13:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677188929; x=1708724929;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ppo+mq/taXoZnR6z0p38USf/BRsdfloAuF2Yn1JAKVk=;
  b=s6yThLOH88JR+b7+qjKxoitgRbEVKWEnj7Vb5iiGWdIBIm7K7SNe44ra
   VaV/TqEhtlwosSqKXPmHY1Q7p7jPkzXcLUCi6gy2Y2APkZ5osCAK+GX8U
   iH6l4wR4oI6U1EkpVWVNEcK0guZ68Cnu4TzS0Bo+KhB7U0Dl0Nm6+/pnp
   1nz6/wkgROR0XPPTqbCfBbCGcVpibX+ckQ9SkE52Mvyo4dJhPF3dMkvqV
   ljhKD6HRVHmJIJBE9gG3QCVcvj81UeJGBgis2JC4CCyIuZxqkI1ujyPgN
   6WHrHbi2Djqm4PimsiJOH5umptLnzWlX01zZES7C9VEpso1yuC4bBuop5
   w==;
X-IronPort-AV: E=Sophos;i="5.97,322,1669100400"; 
   d="scan'208";a="138808877"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Feb 2023 14:48:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 14:48:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 14:48:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jivbm+0CONPSMRYIyB4gkF4fXRyhPZ6FRs2Cj2tLS/sYKtOFeCqdmuI8VERPb8o3Zl+k/bQh8y9XwUOaiQhBO6DA8Ckux+QMpr7EbqmHsFE8uGR0gKaqPvM1Sd5s42rh4Jp0BGFWy2Sl3/llf4Ynd1TrNJNlzrrDFPYJnKNtqZ5JNAqcoJn5SR9IqkTvnrNXoovyi5qN/0EgfHX2EA7b7axbowKAWgOa+7h9D9/yjyfsYqbJm/wfQ/OM3wYG0q+ZvqmDpZPiFL9WHMF72EUegr8lgv7VJ1cnTt3XrQV1HUQW/3/uoPCNmn5+bM2w796LYlsulhPVMatxnJQcrBgEeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppo+mq/taXoZnR6z0p38USf/BRsdfloAuF2Yn1JAKVk=;
 b=Fmy2ssQILCJo5302vld12svdM2MzRK6+5lzrxq1FgrJnDDbAC390rDBFcJVYX04O3+uMoQ2ynC+o44VAYVzNywIVqvCMpSt31wg7p2r3TZ0EYhzRpgwXa0oasKiix2b5cVkDyevhgQlxeCPLhvq9C6MmNVB4sd2L4K+YDJEyq8RXiKwf8e6k3cKE2Y6YQaK8VHJuuLVRQeQ50LtbawKTW9n/xJ5nShFJ0RJdjkk57itn7oLj5ysaZdOzqifLLRuUSGyuNPonggoZKeCL0GSTiZLBhQJX/kdUyq48xiDzzLUkgdSso8ToLAE+qljZyVma/1RucI+vtPMxiDYaAJ8JiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppo+mq/taXoZnR6z0p38USf/BRsdfloAuF2Yn1JAKVk=;
 b=qipwJkryBANWwvNiEP0VVDqyN4GpVd/amcsNXrvVx7MUkaqmABSV/aYOeoWfTzNaYw453Ugy/tT8pISoSP+uzqgx7bte3gbMVE7+3PR1veNjlMP647vFD+CQhShuI1fbDBS1EQtMRu/8Z55ENR1o/03Dcs6/USrtgb9SIcewpyE=
Received: from PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5)
 by IA1PR11MB6468.namprd11.prod.outlook.com (2603:10b6:208:3a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 21:48:38 +0000
Received: from PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::b962:f188:39d6:8811]) by PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::b962:f188:39d6:8811%6]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 21:48:38 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <heiko.thiery@gmail.com>, <johannes@sipsolutions.net>
CC:     <dcbw@redhat.com>, <kvalo@kernel.org>, <michael@walle.cc>,
        <kuba@kernel.org>, <Claudiu.Beznea@microchip.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <Amisha.Patel@microchip.com>, <thaller@redhat.com>,
        <bgalvani@redhat.com>, <Sripad.Balwadgi@microchip.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Topic: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Index: AQHZO8ksXzruIoRs50KxNC39W3lrs67G3K6AgAAJKoCAABHAgIAAJdqAgAADPYCAAMi3AIAAAkmkgACj2ACAACYQAIAHxvcAgAvzWwCAALmuAA==
Date:   Thu, 23 Feb 2023 21:48:38 +0000
Message-ID: <37294e87-b2c0-b096-7470-5d3fcae68cff@microchip.com>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
 <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
 <20230209094825.49f59208@kernel.org>
 <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com>
 <20230209130725.0b04a424@kernel.org>
 <2d548e01b266f7b1ad19a5ea979d00bf@walle.cc>
 <CAEyMn7bpwusVarzHa262maJHf6XTpCW4SL0-o+YH4DGZx94+hw@mail.gmail.com>
 <87bkm1x47n.fsf@kernel.org>
 <2c2e656e-6dad-67d9-8da0-d507804e7df3@microchip.com>
 <aef63f6a367896950f9e61041cfcff4b99bd6c7d.camel@redhat.com>
 <e455e26830a0d8f2ce728461b74e6dbd4b315df5.camel@sipsolutions.net>
 <CAEyMn7Z-4apxxSns+eJDv6nHqGz6UvGCWa4+MmFTv4NXHyYiqw@mail.gmail.com>
In-Reply-To: <CAEyMn7Z-4apxxSns+eJDv6nHqGz6UvGCWa4+MmFTv4NXHyYiqw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5176:EE_|IA1PR11MB6468:EE_
x-ms-office365-filtering-correlation-id: 874d8e0d-6bcf-419a-1676-08db15e7b8a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UKnSW3FBEvUKfTytW/8P6wLpuoX1LpvOx2ObtsSJBNYy6eAkjZeGQ/vgcJ3EN50/a/lkTyLguS6950w8xc49Qh0yOuzriyn133ngMrw/z+uqYmQ7okJxJ9P8sMy0JNJ6gqM98AFIJDdndx4UoFfuxtD4BfffxdSYIRIIulu5FWhqnazwRO3ia9mQNvfWs/wzePJeVwLYW+luNOiETEqgBVRfh3q3zEue83p1MJSAw3e3QH4jdSth1jyNrxsXVyiBJOWip9itOKEyCQvPYJDsOLAY87aUkrz7nMk/6XdJ7/kxW1e3Lm/YY6jueokVqG8u+n1QpcMNGTpgSfLWMIhBkIb+1K7hQcgYRuKwN61lhHNoD8fDFF5TI3WonH9zS8nd3Wlbi7pMpHHsOWDn3O2W81t+MV3dPjC26ncPXeBzmlcBdn0gDTMYZ8HSXtZZ5j5TOBl6X5F126GL4T4eGPcTzpNg/MYY2r5DgxEa2e1uTybhljI6AV3G1dL/4fcORB5qh/P2yySutW6tP1bRfJ2vZExWRAK38p9k0qztQDDMxg+F+6wBttZHtrvDRALuCRtyoAvm9+82qVo68pmqROxktrA6jBXAkdu2TEnhqDJ38Pj0J2wN0eRmP1IKJEaIClxpi0SCG9NEZBH4HofKl5jbVg1zrKaF7BKACtQqO9rD5g5m3M028t7D6pxjW+LEEesHR7fbtJ94uZWnSxpZwN2BL5NlQXvoJYvXBWk3s6yB3OpkR6EjQFuou9ckTgJR2nOYRkjpT+YmLL91wHhDR7GODg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5176.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199018)(186003)(26005)(6506007)(107886003)(6486002)(6512007)(53546011)(31686004)(2616005)(316002)(110136005)(478600001)(54906003)(71200400001)(83380400001)(217773002)(64756008)(66446008)(66946007)(5660300002)(41300700001)(76116006)(8936002)(66556008)(4326008)(66476007)(8676002)(7416002)(2906002)(122000001)(38100700002)(38070700005)(36756003)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekFiVjU0MzRrQTArRFpOUC9uVlBqNk9JM29Ic291aTZ3OGZrbXpzMnlxVWRP?=
 =?utf-8?B?Z1NkbHV3QWh4dnVzMWRQYk90d2NPT1pUcjZPV2t2cUF5QUZoSzlnK0N5Vmty?=
 =?utf-8?B?aUtxaEVScllNc0RIVkMzQzZNcGhGcmgvL0oweUdRSm5HMG4yVWJnUCs4bU10?=
 =?utf-8?B?cUozY2NETWpYL0lVWXBsZzRyUW1JcEtZcUZTVklrNHp2OCtFQ1VCcldpNDdz?=
 =?utf-8?B?SFM3cU1VaG1rTGZYZ3pKQVQrS1hlQnY0RzlSWTB1ZHcwd2tpd01YWFhJOE5Z?=
 =?utf-8?B?QnQwRG8wRkorK2FzcUh6MXBici9hekd3SmhNZ2RBd3J2SmdaeXk1SzNEc2M5?=
 =?utf-8?B?eDF5V2M2Wk5kYjZUY2prWURRMlF6WGFwTUg1ZlpIUVZBTkNKWUhCYXNFV2NF?=
 =?utf-8?B?YW9jdmpDREowUndLRnNwRkpCQzlWOXdCQVdhWTNpUExlTEhqYW52VUJrUWJQ?=
 =?utf-8?B?bTFDNHpHRXk3UUJSaGcrNDhWbWhaU1V6U28vaVQrdnkwWFY0dzRld3J2L3J6?=
 =?utf-8?B?b3ptYmovcEtGSHh4TDVKU2FNQjBnOWlTZFJuOVNXRFBOYlRsNm5CeHlkTk5O?=
 =?utf-8?B?RndkeU8yVUx1MVM1YkFjamc0Z0dkbDc4dEtaUUUrQ3NxTm8yMktCb0V6ZVBV?=
 =?utf-8?B?Q21rMnpwNkpTck5sbHh4M0E0TWJ3RXhvZ3NrSTdWS0t4dVA4cDVMZkNES0kw?=
 =?utf-8?B?NHptVHkrVmZMYzljUmw2dGFZN0hGMnhBWkNtMDR3ME1sdTlJUi9Kai94SC8x?=
 =?utf-8?B?NzNvR0hyRExidTdWWVlGUnhUU0pQNXd6Qk1YMGFkNzd1cGxCV1RZMjdjQmw5?=
 =?utf-8?B?NytJYXhBU2JOZ0dOb0JUNlNIWHRQZ2d2Z051V0dyM0J0dkttcVFmNjMxei9z?=
 =?utf-8?B?aTV5emRkSnVQMlBuRmNkelpTWHVGSDBQUTBwczl2eGZtTyszbXAxUG4zL0hh?=
 =?utf-8?B?QmZwaHdhdStrb0JjaDBTeWRTdklLYStZbVlRa1huTU5Kb2l2QW0xMSt2MzI3?=
 =?utf-8?B?Q0tyd1h0b29JMTlkNXZlaHVzem1BTEdlanc2OUpEeTdGeG9kQmo0bkVGaThy?=
 =?utf-8?B?Z1k4UjlRa29QOXZGcHZCUmhoLzlWdnZjaGV5aFByUEtOelM4Zi84SGdiYW9k?=
 =?utf-8?B?TktYQ0Vzb25vRmtRTlVoM3JrNXBra2pZWFAzdlZqbjlUaEh6am1FNDRVMDlJ?=
 =?utf-8?B?K2RDSWkwak1xTERiZFNJZkg1TDQ1L0RkZGUwRHc1R0ZTclZpekxWaEx1ajdu?=
 =?utf-8?B?ZGozY0Z2R0REUjg5aW9iUnp0czg0eSs3WW02YlZZcHl5NHNodmdFMDFkeTh0?=
 =?utf-8?B?eUJoV25WclR6ZHl0M3p4R2JzdnFuWnFOcHdJUlRRdmMxaTZEdFYybnRrUTFp?=
 =?utf-8?B?bU02b3FRekJQcG9rUWNReG5tQlUvN1hnUXl4a0QxWWdqelpxR2Q4bGtBbXNi?=
 =?utf-8?B?bks5VmJxQVFlQ0R2dTk2WVVTZ21BMU9SOEcwbUtpSE9kSk5MU0w4cVRiTXZI?=
 =?utf-8?B?KzZTZXVPMHlqd0RoS3lKYTB1NGpKa254cXBmZVRSbmxMNnNFZnozL1dNZXZ4?=
 =?utf-8?B?UkNJcW1CZlNtbE1xNER3ZHZBZmZSN0R0WXUyakRFZm4yQXh3OW1mRmpRYTdj?=
 =?utf-8?B?ZWNCZHF4R2VJOUNHc1Q4b0tqLy9QTG1VVjI0b0xhTW4ydTFlVVVUdXA2YnBF?=
 =?utf-8?B?ZzlGbHg1d3I2aEdKTGJFYXNSVHV0bFNFcVNvL0txcG9OYkxsR3NaeVN5djRZ?=
 =?utf-8?B?VVcrNVVDVE1qc2RXZkd4Zzltb1lxR1RSbTEyODBlbEJhdlRiSFBmUXZMK0NF?=
 =?utf-8?B?MjVwdXJkWlR0TnZ4NGdwTHVqY2paSHhQM0dXWGQyc2lGRzEzVHMvcDQ3Y0VY?=
 =?utf-8?B?aXRhRXY1NHFOSWQ5Mk5uOWF3QnZ0VmQ0ZlVua1dzT1BHNDlPYTU3V054MTFT?=
 =?utf-8?B?aGZUamZjTmJ6U1F1b1RVTjF3azYyaWkrRDF4YTJiSkxaUkhCV1hDM0RqU3RP?=
 =?utf-8?B?V0FydlFBOEJ2dGI1a0JBY0t0QTZXUGU0RXlpUlZCcWgzQStNV3d6Ti92cEhI?=
 =?utf-8?B?QTlrY3pVaGlPM1R1RHoxalB0L3lBbGJRQkV4a2dWbEhXaTRrT01ZQmxBWlRU?=
 =?utf-8?Q?UxbEoZA3qH1J9fZPF+kIUZqc7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <541DF311033E994F8592EAB26126CD21@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5176.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 874d8e0d-6bcf-419a-1676-08db15e7b8a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 21:48:38.2306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YDADhdBN2hFFJ/wVoV/lA5qCdQXC9EQdU+APrsm/qgSk9Gv5o4ghXLCFy+8ZFt8ff1kNBwhTJDlDUmvxcLtbF/zHZDHzMb2C+RQtGvzmbzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6468
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGVpa28sDQoNCg0KT24gMi8yMy8yMyAwMzo0NCwgSGVpa28gVGhpZXJ5IHdyb3RlOg0KPiBF
WFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5s
ZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEhpIEFqYXksDQo+IA0KPiBB
bSBNaS4sIDE1LiBGZWIuIDIwMjMgdW0gMjE6MTQgVWhyIHNjaHJpZWIgSm9oYW5uZXMgQmVyZw0K
PiA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD46DQo+Pg0KPj4gT24gRnJpLCAyMDIzLTAyLTEw
IGF0IDE1OjI4IC0wNjAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+Pj4+DQo+Pj4+IEluIHdpbGMx
MDAwLCB0aGUgYnVzIGludGVyZmFjZSBpcyB1cCBpbiBwcm9iZSBidXQgd2UgZG9uJ3QgaGF2ZQ0K
Pj4+PiBhY2Nlc3MNCj4+Pj4gdG8gbWFjIGFkZHJlc3MgdmlhIHJlZ2lzdGVyIHVudGlsIHRoZSBk
cml2ZXIgc3RhcnRzIHRoZSB3aWxjIGZpcm13YXJlDQo+Pj4+IGJlY2F1c2Ugb2YgZGVzaWduIGxp
bWl0YXRpb24uIFRoaXMgaW5mb3JtYXRpb24gaXMgb25seSBhdmFpbGFibGUNCj4+Pj4gYWZ0ZXIN
Cj4+Pj4gdGhlIE1BQyBsYXllciBpcyBpbml0aWFsaXplZC4NCj4+Pg0KPj4+IFNvLi4uIGluaXRp
YWxpemUgdGhlIE1BQyBsYXllciBhbmQgcmVhZCB0aGUgYWRkcmVzcywgdGhlbiBzdG9wIHRoZSBj
YXJkDQo+Pj4gdW50aWwgZGV2IG9wZW4gd2hpY2ggcmVsb2FkcyBhbmQgcmVpbml0cz8gVGhhdCdz
IHdoYXQgZWcgQXRtZWwgZG9lcw0KPj4NCj4+IEZvciBhIG1vcmUgbW9kZXJuIGV4YW1wbGUsIGl3
bHdpZmkgYWxzbyA7LSkNCj4+DQo+PiBZb3Ugc2hvdWxkIGFsc28gbG9hZCB0aGUgZmlybXdhcmUg
YXN5bmMsIHNvIGl0IGJlY29tZXM6DQo+Pg0KPj4gcHJvYmUNCj4+ICAtPiBsb2FkIGZpcm13YXJl
DQo+Pg0KPj4gZmlybXdhcmUgc3VjY2VzcyBjYWxsYmFjaw0KPj4gIC0gYm9vdCBkZXZpY2UNCj4+
ICAtIHJlYWQgaW5mb3JtYXRpb24NCj4+ICAtIHJlZ2lzdGVyIHdpdGggbWFjODAyMTENCj4+ICAt
IHNodXQgZG93biBkZXZpY2UNCj4+DQo+PiBtYWM4MDIxMSBzdGFydCBjYWxsYmFjaw0KPj4gIC0g
Ym9vdCBkZXZpY2UgYWdhaW4NCj4+ICAtIGV0Yy4NCj4gDQo+IERvIHlvdSBoYXZlIGEgbWVhbmlu
ZyBhYm91dCB0aGF0PyBUaGF0IHNvdW5kcyBsaWtlIGEgdmlhYmxlIHNvbHV0aW9uLg0KPiBXaGF0
IGRvIHlvdSB0aGluaz8NCj4gDQoNCg0KWWVhaCwgbG9hZGluZyB0aGUgZmlybXdhcmUgYXN5bmMg
YXBwcm9hY2ggbG9va3MgZ29vZCBidXQgd2lsYw0KaW5pdC9kZWluaXQgc3RhdGVzIGFyZSBjb3Vw
bGVkIHdpdGggbWFjX29wZW4vbWFjX2Nsb3NlIHNvIGl0IHdvdWxkIG5lZWQNCnNvbWUgcmVzdHJ1
Y3R1cmluZy4NCg0KRmlyc3RseSwgSSBhbSBjaGVja2luZyBvbiByZWFkaW5nIHRoZSBNQUMgYWRk
cmVzcyByZWdpc3RlciBieSBqdXN0DQpicmluZ2luZyB0aGUgU0RJTyBidXMgaW50ZXJmYWNlIHVw
IHNvLCB0aGVyZSBpcyBubyBuZWVkIHRvIGZldGNoIGl0DQp1c2luZyBXSUQncyBjb21tYW5kLCB3
aGljaCBpcyBvbmx5IGF2YWlsYWJsZSBmcm9tIHRoZSBmaXJtd2FyZS4gSSB0aGluaw0KaXQgaXMg
cG9zc2libGUgYnV0IEkgbmVlZCB0byBjaGVjayBtb3JlLg0KDQpJZiB0aGUgZmlyc3QgYXBwcm9h
Y2ggZGlkbid0IHdvcmssIHRoZW4gSSBhbSBnb2luZyB0byB0cnkgbG9hZGluZyB0aGUNCmZpcm13
YXJlIGluIHByb2JlIGFzIHN1Z2dlc3RlZCBiZWZvcmUuDQoNCg0KUmVnYXJkcywNCkFqYXkNCg==
