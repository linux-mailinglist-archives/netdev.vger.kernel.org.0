Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D41554C222
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 08:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243176AbiFOGt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 02:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243415AbiFOGt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 02:49:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448F445781;
        Tue, 14 Jun 2022 23:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655275765; x=1686811765;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BJ4ZWbsPxavOnTo/Zfw20kGad9XxZgQQLJzXd5vf0vU=;
  b=okcS5+0UhLBXA4wwXFW8+sNU9f0BtRQTavCkwEtPJ0ALqK8jEeJNiT6i
   b9WfTnaUpLKj7QxmOVaNqH0yBoOyDkOztG+n4ZUcGdlWzfx9pEfflBOe0
   MJyQeLQ/O4mCXdyzfdHFDx8dkaulETA6CKTEQ8+5XE5HZF81+m7/kYCY9
   iRT4GOMrpVf8SdhqSYcgB/u6IkNKIClHOAjWceMWJ7EQDPUb0a3aONAvT
   VoTsi/KLLD0r4kI6OyZ8vkOzvog6SJ+7zhrD4tH3OjJ9cm6GMQLyJDJSx
   3X/WMOO2KFeLjkYYEqHmOs3yT5EVD8bo1k17IRYIEgwjvIbZ/7XubADeL
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="178013409"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2022 23:49:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Jun 2022 23:49:25 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 14 Jun 2022 23:49:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWc22Cbiv1X0MZMFT8nITd9eoKA1w2NoYM5hHmXEKE+J6xBQN5E0V5NhCUYr8uvqCgKp4DUnbtobvWRlJjfgAq3jvFWL7ZdHI6NLrDZX/4M8wbz3d3scoZ/C6dRZS6f28MQECpJsfo0+k6ZuSy5y0cWaKK2m1O1RV1rGowHJ1kC5T2gDJZLQCeypY4SCiNqXOV52uojVQA46i58ur1JKJCe+u8pWzWxJmP598glMAOmqcT1AkQxJCg2JtNEklZDBecEwIS5NoZTn/o49i9u8mk0Cujp/VEvrLTUCwSVxXXagYtV52lgvqkVYdUt/EtMiH0fiYZclga+7cSERykNcgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJ4ZWbsPxavOnTo/Zfw20kGad9XxZgQQLJzXd5vf0vU=;
 b=oeMyQJWU2PvkiSoZ4eej0yJCN0AgOA0zMHXH0WbWQ3mQTyr05l54azxjHOtmu4z2CiUlzyN+dYode5hDZvx77EW+5JJwNAM8XdEo8N12ZCWwujN0lPEJ55gP+mGRJX1P1zfU0ZRVNcM64kfwDEt3uLtCfIuyVHbWQ7fvdYhMzhInP+U9flkkEYCfvR06RYAmX+t4udgmaCL5pxchxFjrbadjLy1qB5zj3N89sdlluwAfGUEgOI74lxYCqqNJuQo7YqR1zV+37WWW3twUrt6lUd3okpO3+z0iflPZV5UPXNtv8aVKKushGvZjmcigyvKSx2g7I2PYxxuJLwQS0T9X+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJ4ZWbsPxavOnTo/Zfw20kGad9XxZgQQLJzXd5vf0vU=;
 b=afqKbSJCCcfZiUWSeUx1Uyq//FQySdYkr78LtpNSmOqyL37X/pNJwxeSV4/5dmozQRpoO9N9+Gt8a271o0GBYofDQOnPOQXIqeNDB981FFD8MQphPVWwUENWHZxjy9WGJAAejr5zCv6eHU2DjaXQ6kKL2sPLbsqEoNkngc8w19g=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (10.164.155.28) by
 BN8PR11MB3684.namprd11.prod.outlook.com (20.178.219.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.14; Wed, 15 Jun 2022 06:49:20 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5332.020; Wed, 15 Jun 2022
 06:49:20 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 06/15] net: dsa: microchip: get P_STP_CTRL
 in ksz_port_stp_state by ksz_dev_ops
Thread-Topic: [RFC Patch net-next v2 06/15] net: dsa: microchip: get
 P_STP_CTRL in ksz_port_stp_state by ksz_dev_ops
Thread-Index: AQHYdBI5WnLROnI49Eug+kIRUbgKzq1NKIQAgAL3cYA=
Date:   Wed, 15 Jun 2022 06:49:20 +0000
Message-ID: <0978da15ac79d71c007c25d9b1bdc352b8ef3a9b.camel@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
         <20220530104257.21485-7-arun.ramadoss@microchip.com>
         <20220613093116.2gc3mc5uvzoy5jrf@skbuf>
In-Reply-To: <20220613093116.2gc3mc5uvzoy5jrf@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9484481e-9df4-475e-8d95-08da4e9b2cde
x-ms-traffictypediagnostic: BN8PR11MB3684:EE_
x-microsoft-antispam-prvs: <BN8PR11MB36846A86F76538325E608D97EFAD9@BN8PR11MB3684.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XedOvcS+nqr103EmeR6F2jRNSZTMeUIhRolLJsei5wYHekfL0SPhlZkMQvULViOIEhpOZWe3SPZwigypUfiSI/8312XdO/8aUVpwXvonTOrdnTiupUy20+v+ylnc4rcITUl6UIfk8Ug5mKNAdHhzeG53NLSDHkRy1yq09802DmUO28FmrxWIyReVLSXCM3pL+FtEBc2+uz0Y83nKShsl+mstKeIDbrCTAX2ND/4bJPEkYFgA6wWO7xhZDNPkWU4RaHnL9iU1AL1PDAhP7p4Y0YEE4IQ9HJ7+OWprgZ0dztvi/oJRxuhu26nTHI72ZPu/j3AN09Iyv6mhgOoDFxO7DeIdQj6CEeIrr9zD4Szb9J6vbAMp/adexxBqRn4xGyfGBm5kn5ou5lM77qv17++nrnRWTqU+si/qauolH3NWrEhx2orPb1wVySK93J7LrqtR97rA5JmfmbDgltG9ATxclT8G4M+sOx1kB1HUxvNgH/gO8R7mL58MH0mq1Ks05Y2l6hxm5G71NATjl9lQgAlYu7DGwBFZu7lcVGhfBuAVRE8YKTJp+3xI35YeP4YXVZUN0euw9SO0/nJRTlheX95wEgxAbkRTcn/eslrCTClU7c2IkJBEr7QaHSurNuDexVBrwpuqSkqNN9Junrvy5WL5OksTIPy2+XpghZRceAdcSBMOsdoQTKQg4KoEbx48NgE6FkNgq9U4BoKV5f5pXgEogloVEmH/psQ/H50mHCeqE6Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(122000001)(36756003)(38070700005)(8676002)(38100700002)(5660300002)(6506007)(76116006)(86362001)(83380400001)(2616005)(91956017)(186003)(26005)(6512007)(71200400001)(66946007)(7416002)(2906002)(316002)(6916009)(54906003)(6486002)(508600001)(66476007)(8936002)(66556008)(66446008)(64756008)(4326008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmhlZjRvQmk5ZjlPWDFqRys2K2NwN2haekpMVkswdkFqR3NnOTg5V3ErWTZM?=
 =?utf-8?B?cHRFVWZWcWRWUXZBekJCWkdXMUtEM1RtOHFNL1JFemE4ZWlITmpOL2tHNlA2?=
 =?utf-8?B?OXVUNWtvMGhNYlU2K0x3WXRjK1FqRDVaL2dHbC9wR3ZiOTV4cEFKRHdMK0Vj?=
 =?utf-8?B?VERlcGlWZThxakJBTWlLOG41cEFyWm5ldzM4VDNQeFFPSENzazlYY3dOdGU3?=
 =?utf-8?B?enJkaWFKOGNDNEUwNlVmOXdpRkl6c1o5T0tITG1rQWgvSU9Gc0czL3JOZ2h0?=
 =?utf-8?B?NCtxaDlidEZDcmJ0amJzYmFvNksrWmg3YUtmL3hzanAyaGV3WEdrYmdsSlcx?=
 =?utf-8?B?elZEOW1nNGRydGxxUFdOdXIvWWxHVy9xaC9GOHFjZk5FZi9NWkxzdTVGcjFh?=
 =?utf-8?B?OWprdFZBanBPWk5XZzU3dm16TW10VTA2c1packFmMUpzbjhlVm1zbzIzMko2?=
 =?utf-8?B?R3dUK1VBclpsazhZaG8wN2tVdTIzZ0xZeXF6QnE1TlM4ZnU5R3NQOEdac2Rj?=
 =?utf-8?B?ZkUrUDRXRkpobzJLZjhJTU5JUUVmN241U3o1SUQzSzBvQTJUdnJzbUVBM1p4?=
 =?utf-8?B?TEZYQ1pyS0ZSY3IwRC9xMUFZbWlsNkVOanJUS3VvSmxJVUdkNlp2ZlRXUFdw?=
 =?utf-8?B?anNQcDc3Qmw3d1hBc2s4S2tsdjZlZTRQb2dDNUI3RHlrVTA5dlhjdlFRbFJr?=
 =?utf-8?B?WUxQdm5CUTVrZmxtNGhQWTlRSDlZbEN5cEJDVHVRcGdaR2tySVo1dDgrUzVX?=
 =?utf-8?B?emVIRXR5QjlWQkdNYmVBVTRWWDRpZURLbldBeGhaOURycFhhdGZsenJyRzYy?=
 =?utf-8?B?NnZ6Q3FBc3NuZTE4c2VMeEMwMG5sTTVLUlhudWRSa1ZnT0tna1hIaFpjbU8w?=
 =?utf-8?B?Yi85dEJ1WXh0eWRCWUJsVGZ5UEZtTk1PZ2FjckRpRUVqeEV3aUd0Tjk4ZWdz?=
 =?utf-8?B?SjNxSzc5M2R6bmtjemltR0NvSFdob3Zpc09uTFEvVzJuQXBMQjVnZGx3eDVB?=
 =?utf-8?B?L0FoaGRUQ2cwc0dKRlc2cUJ2K3k5dURVQWY5cER2VXZyci9BdDJaNXJEUEVy?=
 =?utf-8?B?ZXpiMEtBcXVKSGpSTnYwRWVWRkFXY08zOTB6WnJqRGlteUlRbUdVRG1EQWlI?=
 =?utf-8?B?M2tZN3ErbmR5S2Q5ekhoVStxOSsvTmozeWQ1WHk3L3Blc1pSYmlMUTd1Qk5i?=
 =?utf-8?B?YWJuTnZWWUc5WlJQSDJQdDVXbTdDN0dWYk1IaTlaNW9nUXJMYWcvRGxXM1Jv?=
 =?utf-8?B?OUlJM0dBNi90SVhaUUtkN3ZMcDQ1SDlhandhYXRzYmk3TWs5TTFPVGRWZndM?=
 =?utf-8?B?WG54STdmcXNpNUs1ZVpETjBoUysxS29yNG5yS0w5RjZFRFFsQnpZRzdsb3Ba?=
 =?utf-8?B?QzJ3cUlGVUYvcWNzV3RyUUtPSlBqR2t3Yk9NbUphMEtpeUtBSk1rVjN6ZXpN?=
 =?utf-8?B?YW9MM2laVGxSc1hzaEdUOE5VMm1oVUFEMmxSYk5sMXBWblVrOHk2cVY2UW4y?=
 =?utf-8?B?TGZTQ0pGMWZ1TVA5eHc3Q3QwOUpGZ0dSU3dJTDQ4aGh6VjBCRHM3dU9BTHlw?=
 =?utf-8?B?UTh3QlBqK2F5RkxpTHcrU2xHMDFGTll3RHBSUll2S0YvS1BUZzR2a2JYejB3?=
 =?utf-8?B?QjUyalJ0bEJyaStvWkluWnBSSW1yWktzOHdPWjRnSnF0L3I5VEZRRFdKeEVH?=
 =?utf-8?B?c1QvM3RFSmtGamNlZ2YvRWtQdk9EdmZwaXZHMEpjTTlJT0pvelhGQ3VVdmEy?=
 =?utf-8?B?Y0ZQVHhEZTgvQk90YnZOSmJTcUYvNlc3Rm9RWEdzY0U0V0U0YmNMZUNkMkg4?=
 =?utf-8?B?ZU5vM2hsVDhqSEJ2RUY4SDlZenV2YmZYUlh5K2x2QlpmdXN0TEdrSkZ2b0d5?=
 =?utf-8?B?ZmtYSUpIRG1WSkxTVXZDVTNaU2ZycWZBZXZYK25zelRqNTA3NlkxK1FId1Nk?=
 =?utf-8?B?TnJyeHZUNE1KL3hURmZSWmloYlQyQWcyanMwTnAxai9LdVpzWHh0aStHQUlm?=
 =?utf-8?B?VnZKZGg2VytJRUNaNVpUWldjeFFCWDA1alhhaXgvbHoyWGhIVWFKTW9IcW00?=
 =?utf-8?B?a3hxMm13KzZqbjZNTzVTcHJpYXpKelF4T2ppSk13TlBYZDJrb2NacjVJeU9X?=
 =?utf-8?B?UmQyZVVsUzBycUNvcGNJWHFqYXJOb2VxWGFmR2M1VDRkN2FBUHlJenBhajNw?=
 =?utf-8?B?TkJVcEMzTjhIZjRqUnU5UHZ1OUlKM1NNVmxwNUN1M1ZYa005Vm9rWjVtQUJL?=
 =?utf-8?B?Q1JvcGlrN3o4NlFyRFlxa0RycEl5R3hsV1l1dktEQWhrbEpjV3Bic3dtR0FK?=
 =?utf-8?B?Z0VZZkhXRjBtNkt3WjVTQlVpdHBhd09oNE9hWmJyU1JxV2M5cS9EdUpxcm9Q?=
 =?utf-8?Q?eTX2gseqUU+ei/huYVN2ucoGTggGZXA7Wi1La?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9F0ED31B752564B98D46754A0F72C29@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9484481e-9df4-475e-8d95-08da4e9b2cde
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 06:49:20.5714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p6epG4D0KJ3tGXPAPcehvtYPBTpK2rxnrL84ZI2nH/WnznRZZt9zyoVOH6qSL6t0eo0MfuxPjH5F9TDOHx4SaAASqdeL1GDO9F3xQh6TnVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3684
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA2LTEzIGF0IDEyOjMxICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTW9uLCBN
YXkgMzAsIDIwMjIgYXQgMDQ6MTI6NDhQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBBdCBwcmVzZW50LCBQX1NUUF9DVFJMIHJlZ2lzdGVyIHZhbHVlIGlzIHBhc3NlZCBhcyBwYXJh
bWV0ZXIgdG8NCj4gPiBrc3pfcG9ydF9zdHBfc3RhdGUgZnJvbSB0aGUgaW5kaXZpZHVhbCBkc2Ff
c3dpdGNoX29wcyBob29rcy4gVGhpcw0KPiA+IHBhdGNoDQo+ID4gdXBkYXRlIHRoZSBmdW5jdGlv
biB0byByZXRyaWV2ZSB0aGUgcmVnaXN0ZXIgdmFsdWUgdGhyb3VnaCB0aGUNCj4gPiBrc3pfZGV2
X29wcyBmdW5jdGlvbiBwb2ludGVyLg0KPiA+IEFuZCBhZGQgdGhlIHN0YXRpYyB0byBrc3pfdXBk
YXRlX3BvcnRfbWVtYmVyIHNpbmNlIGl0IGlzIG5vdCBjYWxsZWQNCj4gPiBvdXRzaWRlIHRoZSBr
c3pfY29tbW9uLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEFydW4gUmFtYWRvc3MgPGFydW4u
cmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3o4Nzk1LmMgICAgfCAgOSArKysrKy0tLS0NCj4gPiAgZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o5NDc3LmMgICAgfCAxMCArKysrKy0tLS0tDQo+ID4gIGRyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jIHwgIDkgKysrKystLS0tDQo+ID4gIGRyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oIHwgIDUgKystLS0NCj4gPiAgNCBmaWxlcyBj
aGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gPiBiL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+ID4gaW5kZXggODY1N2I1MjBiMzM2Li5l
Njk4MmZhOWQzODIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3o4Nzk1LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0K
PiA+IEBAIC05MjAsOSArOTIwLDkgQEAgc3RhdGljIHZvaWQga3N6OF9jZmdfcG9ydF9tZW1iZXIo
c3RydWN0DQo+ID4ga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwgdTggbWVtYmVyKQ0KPiA+ICAg
ICAgIGtzel9wd3JpdGU4KGRldiwgcG9ydCwgUF9NSVJST1JfQ1RSTCwgZGF0YSk7DQo+ID4gIH0N
Cj4gPiANCj4gPiAtc3RhdGljIHZvaWQga3N6OF9wb3J0X3N0cF9zdGF0ZV9zZXQoc3RydWN0IGRz
YV9zd2l0Y2ggKmRzLCBpbnQNCj4gPiBwb3J0LCB1OCBzdGF0ZSkNCj4gPiArc3RhdGljIGludCBr
c3o4X2dldF9zdHBfcmVnKHZvaWQpDQo+ID4gIHsNCj4gPiAtICAgICBrc3pfcG9ydF9zdHBfc3Rh
dGVfc2V0KGRzLCBwb3J0LCBzdGF0ZSwgUF9TVFBfQ1RSTCk7DQo+ID4gKyAgICAgcmV0dXJuIFBf
U1RQX0NUUkw7DQo+ID4gIH0NCj4gDQo+IFNpbmNlIHRoZXJlJ3Mgbm90aGluZyBkeW5hbWljIGFi
b3V0IGdldF9zdHBfcmVnKCksIGNhbiB0aGUgU1RQDQo+IHJlZ2lzdGVyDQo+IGxvY2F0aW9uIHN0
YXkgaW4gc3RydWN0IGtzel9jaGlwX2RhdGE/DQoNCkkgd2lsbCB1cGRhdGUgdGhlIGtzel9jaGlw
X2RhdGEgZm9yIGhvbGRpbmcgdGhlIGFkZHJlc3Mgb2YgU1RQX0NUTCANCnJlZ2lzdGVyLg0K
