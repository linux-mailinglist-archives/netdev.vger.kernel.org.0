Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7928587FFE
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbiHBQMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbiHBQLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:11:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13C6B60;
        Tue,  2 Aug 2022 09:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659456610; x=1690992610;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LkZjK56t5GAhEyWbpTlCtutaWPRPzLoVTKxoOVVvUEo=;
  b=zkrajqfKt63amNeqByiOAbMxPF7yWRWxxB8DKzAbtv7a8vPHu2BU5cdY
   ESXsC6eJwG2GV5mmpdWcEFFNbswjoiKCKSjn6KB00uMC+mLtd63Id0Hnq
   WubiDfDSNz1JdHS0wNOQHYWg0tTYmJ5JQkb7Xhlrtl148gYNCgVEzZteq
   Sa1oSsx91zn5fmatBuT3keWsVSRniVmX8+gn1Smab5wLYPREoE6CG7IE1
   bAtQwEYeaAXxk/dwqEhtXXw1Ua5gLN7B8mAifpNC1xztBMnaSywDmOl+I
   XYy6qnVxlM5919u0e5tNdHecqEc5srUVNvvTTj5VQ+wmSHF7V5CZxk/gM
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="174775309"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Aug 2022 09:09:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 2 Aug 2022 09:09:45 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 2 Aug 2022 09:09:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHF+MB1LA4DB2fF/u8+yp4hKGmjytZhwKnLzgWmivnTyIyi7ACqqHNxs8CHQM4JKl47nhYjf5mY5sauPewqnt7p+xAQoh/J3g2y00HnLjIqMfVBW/TorcWq+L1wcWX+14wStN1HBjENafj55eFvzsTX68KyU81CC6bZqDd1km33ITsCJrQEdifqXPJWZxc5QBrBEjPmK3FKn+mwrZ4T61p1MfeomlY25TZc75gYxsDNpjhMj1SnNiwx4BsCiBEXAYcKJj0+Wm5INnx9Jh4mr/SUKTWFoz9p/pbqaJdefGCfwgYYIuglntWf/QAr34/IDwtD67CWkmSOBi0fY9bK5hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkZjK56t5GAhEyWbpTlCtutaWPRPzLoVTKxoOVVvUEo=;
 b=cr5RrEeZOOp2N/EZvx5+AtomCjWo6tNy02TfRJlc493kv2MBsBNybmiDNuEuf+b7CqEuI1+bC/e2IPrsl+o1bjsT7rfdpoQHLGWfdqpQ0fyJS/G1q0XXUcUXJ+G7+zwZIMgKUFKqXqkHrsuSOQBvARHvmDfGEsYJN4Wveyi+/3GffP8IhLgakqT0vpX0CRE6WjY13jTJRVSYx+0DS8AuXBDws89ImKHLUR3laRWJyxyvooZ2l0oSReq5ytytk0PKy7kIPgpDNtJq1iapB6fR2VJjO7EyNViJ69yRbfG28X4q+1nu95ZIwMV7PoMSp0tj53t9XSXlfGLkydCJv0ht9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkZjK56t5GAhEyWbpTlCtutaWPRPzLoVTKxoOVVvUEo=;
 b=fr7/aHOaEv+4HelEFdx3VSVyrZJf7Rn1u6Vi86poEACR/6cxEYlqetMJx/vMmCcRwUh1kmcyiOFFRHQBXdw+XvvVfPd7Xnman8OG6GD+mYXxtaftDiPw8k7nsi27XD6c8/FGgK71FsLXi2lrTuWEfFlGWfQkBAfKErvTLHtCQTA=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CO1PR11MB4899.namprd11.prod.outlook.com (2603:10b6:303:6e::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 2 Aug 2022 16:09:35 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::945f:fc90:5ca3:d69a]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::945f:fc90:5ca3:d69a%6]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 16:09:35 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [Patch RFC net-next 2/4] net: dsa: microchip: lan937x: remove
 vlan_filtering_is_global flag
Thread-Topic: [Patch RFC net-next 2/4] net: dsa: microchip: lan937x: remove
 vlan_filtering_is_global flag
Thread-Index: AQHYo16BzwThXQSQjk226zoYpXBUB62bcf4QgABbxoA=
Date:   Tue, 2 Aug 2022 16:09:35 +0000
Message-ID: <1fe46b15172ff82125c46369d9ed235f67ed5afe.camel@microchip.com>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
         <20220729151733.6032-1-arun.ramadoss@microchip.com>
         <20220729151733.6032-3-arun.ramadoss@microchip.com>
         <20220729151733.6032-3-arun.ramadoss@microchip.com>
         <20220802104032.7g7jgn6t3xq6tcu5@skbuf>
In-Reply-To: <20220802104032.7g7jgn6t3xq6tcu5@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42eb1be2-7a42-4886-1145-08da74a1648e
x-ms-traffictypediagnostic: CO1PR11MB4899:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XSETXTRkCg1bVJKsd32rQZIrI74tYhVQJQNdbMmMrlm3N+GyfywA4ZRPfz52cZQUOq6I5aWsaGxXtE/ewBqTv8LxRDo2azU3y1rHt3vkFR6GubinAMkLngVBakIyrzPd2Q04H0/Z+L0McebRjBEznIXwV5h+v/06HJFxbP9VOgKS29o8wtSBlMEEYsQylLxN43QDhN9e3muqIcy9OAPJRkEwnJah/6X7qPsEKg65nOdpqqcyXuIS6lchmhwCHTDDngCW6gatISukcZG46u3pLtI9yOpR9ey4aNxsKFAuuVIZ0eFkz8JrtMU4cHTbD7Cu3yOS2XG2I88oyzDkbS9GI0WaaGEGzoL5gWgWn4BdzZ5ymKJu7PCdm7PndwLCqimDsaRLr80ssUezC8vMJrkMZ53VqRmQCM6/9FRBjLS/N6jLia3R68pPnD2uy33QOya7GeuTcOE2vAHcwrxi0rZHeX1G7FOxQgFEqdxbZNcxMFieu4ta+ics0SDq3QjZT9FT4oXxcsQoIeERvZh+yS8RmfPyDB0dl4nZKTpleU/fsQuqqAJfK5m+rXPHXaIUQzgOAZ+rcWeOwwcdO+/7nlhTozxJ8jjD09luxtTFyCMw1rGYGEEIBjHdNysB5uf7NaNm7HWD1rwPSokeLq+nG8p7wHI02k1oj8udDcPszbFGRfk3aJd6fL2qB49VULVCsFWhHm1O4PHsq3e4H4SWI1KNpO/kRf9pOx/QwvgetI3UC0kKct/Tj2nOyJ0uTw+VXQnb5C7J44Wboqh68zxZkqJg5l0NBetQQy6e8TrSsESF4obPna1ZK2nG7H7mMmbu2KW2EEoi1elqXZF8t307KIN1qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(366004)(39860400002)(396003)(6512007)(186003)(86362001)(6486002)(83380400001)(478600001)(36756003)(2616005)(122000001)(6506007)(6916009)(71200400001)(54906003)(5660300002)(7416002)(4326008)(8676002)(66446008)(66476007)(76116006)(38100700002)(66946007)(66556008)(316002)(64756008)(38070700005)(91956017)(2906002)(8936002)(41300700001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXZpcndHeVdUcmZHYTNOM2t5L2RHSEpaL2pUNXpQS0lOOGg0eHFJK0Npb3BF?=
 =?utf-8?B?R1JlcTlSd0NxR3ExRUVJUEFmRVRkUGJ1MjY1NUV1ZDZQN1k1b0F6TDNVUTRx?=
 =?utf-8?B?Y2JmeUJWZFp3d3JSc1R1YTVNSXJKQUVXTzRYemlEdXZTeVcvNTc2aTZ0L0NI?=
 =?utf-8?B?MXZpVkROeXFqSXJLLzhRS1BDSGlCUU9rZEtpU0VzZGtEMzU2QThabE44M2tu?=
 =?utf-8?B?S1pyVWoyMlFOdzhUY21xbWdyZktvdDNsejdQVE5sRHJaVDZtN0pYZUZXb0xx?=
 =?utf-8?B?dGNyVkdNSzRqMW9NVDlvcWcwcXQzYm5FOElXVjlXSUw2NHhWbHFJMkZFZmFj?=
 =?utf-8?B?OUErdWRybWpoK09KaGJqanJoYkZJUWdnWHNHa0xPTTZnMGV3RUFIRllGNXp2?=
 =?utf-8?B?M0o1MVU2MmcraUNJRy9laG9rMzdCTWduWDE4bXlzMTZ0a3UxR2dUbmdiSjJu?=
 =?utf-8?B?N1NtcjFQa1ZQWmxwWmtUdTVaaTJHWWxVSFNKNHlubTZNU0xxLzhWNVBuY0FP?=
 =?utf-8?B?VllwR0xYSy9LK0RIT0RaUzVjMTZMaXZYcjhVdE1mSzhLR2tjZ2FCeWxQRCsx?=
 =?utf-8?B?Nmh4ZUNtdU5tLy8ybkdGNlNGck5nWVlWQzF3dEIxYUpMK3VOMHJVSjRxRUps?=
 =?utf-8?B?V3JQQmRNNjFPUjZMd1R6NXBMMEdrNlJnS2xPZmNTbWR1YkczOURhZnNRb1FZ?=
 =?utf-8?B?OTMwM3JESVdIQXV3OVlmMUVKUXdJazVtUDBnM2Z4d1gyWHBPd0lNS0cvTi9w?=
 =?utf-8?B?THJENzZVRzFGQjdVd0Y1VllPQmFkZjhVZjkzQ0ZBVkdxRFpRb2x2NVpldEFk?=
 =?utf-8?B?T01hZEQ0T1QxbHplMUFxMWN4TlBOSzVDUXgweHBYVGNpdm8zUU9sOXpTTEpr?=
 =?utf-8?B?dXRRbUEzTXNlZjByZEgzVkVmTXUvVTNzbUVGLzhta3l2ZlIrNXdka0xETnZa?=
 =?utf-8?B?em5zRi9UQ2k2bGx0SVNlQ01jQ3dTVG8vVHp2MUdwbVE1ZGdUZU1Ndnl0NU1y?=
 =?utf-8?B?RWdvdWVhemMrYXRQZDhoa3crajVJV3k5OXBUVW9DanF4OG5zR2JZZUdwMjdO?=
 =?utf-8?B?SEIvV2NwVE9ROGsxRHpNZVllOHRMcTU3TzZ5ZVN3RldvVDlUWHdRUk9VMDBN?=
 =?utf-8?B?QTFJekJIVWxJckU1SENwenFVV1NsQ2l0T0NucWZkZE9qa21leFdZdDZ1dTAr?=
 =?utf-8?B?NngrV09CS25qb2JnV0toanVGeXdJQ2RablJkSi9BNE5abWJBT3U0Tk1TS3Zq?=
 =?utf-8?B?VmhhM3lOQnhNZVZtVXd6L0hTbXlkdTV5Q2JaR1RxL1NQbUE1VGtkZU9mempY?=
 =?utf-8?B?SW9OV3B3U3dXSHpLUmorbyt3cWQ5cGRpZlBvRzlzTnlvSUlZQVk0MHRzUy9O?=
 =?utf-8?B?UWRPenp1aHgreW1zaUdMdkd1Vk5nL0d0YlNweFdYNEppR2pTVjdUT3RMVXp5?=
 =?utf-8?B?Um1BczUwbzBuNkdWRTNmOXNwTEN5dzloZ2dMRHlTV3RtWHpYVnJ0a2E1WHpL?=
 =?utf-8?B?TC9YNEE3RGw0SmhIV3NuZUhrU1UvMG9wMnZ1UWQ3YnhJSlZrUHNySitDTXVm?=
 =?utf-8?B?SFhrMHRURlJ2aXl3cHNCQXVHVEZ6aWswRzVTeml1MzBEdzZLT3Y1Z2VLWFRF?=
 =?utf-8?B?QlhmazhFL013WVpxVExtTWRJdG5pamlkTXVxMmVISjNnNWE5S2hLWE41Tmhs?=
 =?utf-8?B?M1JlWXdXVTZ2U2hZZFFjOFFleDJrOTNJOWN6alJ0ZHZpQ1VHeG1vQm1WT2g4?=
 =?utf-8?B?T2hRbVorUEhTTEJtZHJrYkYyRWswMVNtbG5TQ040R09QZDRRN21JQW1GRi9J?=
 =?utf-8?B?dkpWRlp3ckVzOEd1UWpRa3o0UkdlKzRQcnFlcXQramVBRklYemlWU3doMGFO?=
 =?utf-8?B?ODQ0bExVS2dqU2JMVG5FU1ZXbkZET3R6Qjl1SGhocVZudkZYcnRabWNueHNr?=
 =?utf-8?B?bityWFRpNStwNTVaWEgwN2FTZ1hRd09TZERGcXhTdmVwV2tDYXgxOUNMRjd3?=
 =?utf-8?B?SWxISFAwNkdaL0NhOWhPNDRjMytRenpoSW9CYVZ0NnJkVlJYei9zcGtFbmRn?=
 =?utf-8?B?RVVkdmNLVnBGeG5aTlJqMWFWUzk0ZG5QUVlCTjVtSnE3bnNqeXdTWlQ0SEg5?=
 =?utf-8?B?Qlc4VkZpVk12RVdrNk1DZmthZnh3OWhkOWs0NmdmaE5PNTRRS1RJWHljb0NV?=
 =?utf-8?B?TWMyMEhLcmRZOGg2ZThPd2NHbHBaVjAwTnpCN0xhaXQyK2NkVTBkbmorRXBM?=
 =?utf-8?Q?gs55p4qDzerGkS14OI17a5jsPkqXORJKlgwViEjD+8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65112CAA61823C4A9811E6FBE08D591C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42eb1be2-7a42-4886-1145-08da74a1648e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 16:09:35.1622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yqTq5I3m7XyDNZxfZFpvYHg/P25dO4msJKSQ7sL6MDygAxfFSciSRtJ9PRir5j9zrIOIRI777xU7bOgTuWWwu/VjnmT8eQ5Z02lFxCPQBEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4899
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHRoZSBjb21tZW50Lg0KDQpPbiBUdWUsIDIwMjItMDgt
MDIgYXQgMTM6NDAgKzAzMDAsIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4g
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBGcmksIEp1bCAyOSwgMjAyMiBhdCAw
ODo0NzozMVBNICswNTMwLCBBcnVuIFJhbWFkb3NzIHdyb3RlOg0KPiA+IFRvIGhhdmUgdGhlIHNp
bWlsYXIgaW1wbGVtZW50YXRpb24gYW1vbmcgdGhlIGtzeiBzd2l0Y2hlcywgcmVtb3ZlZA0KPiA+
IHRoZQ0KPiA+IHZsYW5fZmlsdGVyaW5nX2lzX2dsb2JhbCBmbGFnIHdoaWNoIGlzIG9ubHkgcHJl
c2VudCBpbiB0aGUgbGFuOTM3eC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBcnVuIFJhbWFk
b3NzIDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAvbGFuOTM3eF9tYWluLmMgfCA1IC0tLS0tDQo+ID4gIDEgZmlsZSBj
aGFuZ2VkLCA1IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2xhbjkzN3hfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2xhbjkzN3hfbWFpbi5jDQo+ID4gaW5kZXggZGFlZGQyYmYyMGMxLi45YzFmZTM4ZWZk
MWEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9sYW45Mzd4X21h
aW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvbGFuOTM3eF9tYWluLmMN
Cj4gPiBAQCAtNDAxLDExICs0MDEsNiBAQCBpbnQgbGFuOTM3eF9zZXR1cChzdHJ1Y3QgZHNhX3N3
aXRjaCAqZHMpDQo+ID4gICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICAgICAgIH0NCj4g
PiANCj4gPiAtICAgICAvKiBUaGUgVkxBTiBhd2FyZSBpcyBhIGdsb2JhbCBzZXR0aW5nLiBNaXhl
ZCB2bGFuDQo+ID4gLSAgICAgICogZmlsdGVyaW5ncyBhcmUgbm90IHN1cHBvcnRlZC4NCj4gPiAt
ICAgICAgKi8NCj4gPiAtICAgICBkcy0+dmxhbl9maWx0ZXJpbmdfaXNfZ2xvYmFsID0gdHJ1ZTsN
Cj4gPiAtDQo+IA0KPiBZb3UgdW5kZXJzdGFuZCB3aGF0IHRoaXMgZmxhZyBkb2VzLCByaWdodD8g
SXQgZW5zdXJlcyB0aGF0IGlmIHlvdQ0KPiBoYXZlDQo+IGxhbjAgYW5kIGxhbjEgdW5kZXIgVkxB
Ti1hd2FyZSBicjAsIHRoZW4gbGFuMiB3aGljaCBpcyBzdGFuZGFsb25lDQo+IHdpbGwNCj4gZGVj
bGFyZSBORVRJRl9GX0hXX1ZMQU5fQ1RBR19GSUxURVIuIEluIHR1cm4sIHRoaXMgbWFrZXMgdGhl
IG5ldHdvcmsNCj4gc3RhY2sga25vdyB0aGF0IGxhbjIgd29uJ3QgYWNjZXB0IFZMQU4tdGFnZ2Vk
IHBhY2tldHMgdW5sZXNzIHRoZXJlIGlzDQo+IGFuDQo+IDgwMjFxIGludGVyZmFjZSB3aXRoIHRo
ZSBnaXZlbiBWSUQgb24gdG9wIG9mIGl0LiBUaGlzIDgwMjFxIGludGVyZmFjZQ0KPiBjYWxscyB2
bGFuX3ZpZF9hZGQoKSB0byBwb3B1bGF0ZSB0aGUgZHJpdmVyJ3MgVkxBTiBSWCBmaWx0ZXIgd2l0
aCBpdHMNCj4gVklELCBhbmQgdGhpcyBnZXRzIHRyYW5zbGF0ZWQgaW50byBkc2Ffc2xhdmVfdmxh
bl9yeF9hZGRfdmlkKCkgd2hpY2gNCj4gdWx0aW1hdGVseSByZWFjaGVzIHRoZSBkcml2ZXIncyAt
PnBvcnRfdmxhbl9hZGQoKSBmdW5jdGlvbi4NCj4gDQo+IElmIFZMQU4gZmlsdGVyaW5nICppcyog
YSBnbG9iYWwgc2V0dGluZywgYW5kIGxvb2tpbmcgYXQgdGhpcyBjYWxsDQo+IGZyb20NCj4ga3N6
OTQ3N19wb3J0X3ZsYW5fZmlsdGVyaW5nKCkgd2hpY2ggaXMgbm90IHBlciBwb3J0LCBJJ2Qgc2F5
IGl0IGlzOg0KPiANCj4gICAgICAgICAgICAgICAgIGtzel9jZmcoZGV2LCBSRUdfU1dfTFVFX0NU
UkxfMCwgU1dfVkxBTl9FTkFCTEUsDQo+IHRydWUpOw0KPiANCj4gdGhlbiB3aGF0IHdvdWxkIGhh
cHBlbiBpcyB0aGF0IGFsbCBWTEFOIHRhZ2dlZCB0cmFmZmljIHdvdWxkIGJlDQo+IGRyb3BwZWQN
Cj4gb24gdGhlIHN0YW5kYWxvbmUgbGFuMi4NCj4gDQo+IEknZCBzYXkgdGhhdCB0aGUga3N6OTQ3
NyBpcyBidWdneSBmb3Igbm90IGRlY2xhcmluZw0KPiB2bGFuX2ZpbHRlcmluZ19pc19nbG9iYWws
DQo+IHJhdGhlciB0aGFuIGVuY291cmFnaW5nIHlvdSB0byBkZWxldGUgaXQgZnJvbSBsYW45Mzd4
LiBJbiB0dXJuLA0KPiBmaXhpbmcNCj4ga3N6OTQ3NyB3b3VsZCBtYWtlIHNldHRpbmcgdGhpcyBm
bGFnIGZyb20gYSBjb21tb24gbG9jYXRpb24gcG9zc2libGUsDQo+IGJlY2F1c2Uga3N6OCBuZWVk
cyBpdCB0b28uDQoNCkkgaGF2ZSBkb25lIHNvbWUgc3R1ZHkgb24gdGhpcyBTV19WTEFOX0VOQUJM
RSBiaXQuIEJ5IGRlZmF1bHQgdGhlIHB2aWQNCm9mIHRoZSBwb3J0IGlzIDEgYW5kIHZsYW4gcG9y
dCBtZW1iZXJzaGlwICgweE5BMDQpIGlzIDB4ZmYuIFNvIGlmIHRoZQ0KYml0IGlzIDAsIHRoZW4g
dW5rbm93biBkZXN0IGFkZHIgcGFja2V0cyBhcmUgYnJvYWRjYXN0ZWQgd2hpY2ggaXMgdGhlDQpk
ZWZhdWx0IGJlaGF2aW91ciBvZiBzd2l0Y2guDQpOb3cgY29uc2lkZXIgd2hlbiB0aGUgYml0IGlz
IDEsDQotIElmIHRoZSBpbnZhbGlkIHZsYW4gcGFja2V0IGlzIHJlY2VpdmVkLCB0aGVuIGJhc2Vk
IG9uIGRyb3AgaW52YWxpZA0KdmlkIG9yIHVua25vd24gdmlkIGZvcndhcmQgYml0LCBwYWNrZXRz
IGFyZSBkaXNjYXJkZWQgb3IgZm9yd2FyZGVkLg0KLSBJZiB0aGUgdmFsaWQgdmxhbiBwYWNrZXQg
aXMgcmVjZWl2ZWQsIHRoZW4gYnJvYWRjYXN0IHRvIHBvcnRzIGluIHZsYW4NCnBvcnQgbWVtYmVy
c2hpcCBsaXN0Lg0KVGhlIHBvcnQgbWVtYmVyc2hpcCByZWdpc3RlciBzZXQgdXNpbmcgdGhlIGtz
ejk0NzdfY2ZnX3BvcnRfbWVtYmVyDQpmdW5jdGlvbi4NCkluIHN1bW1hcnksIEkgaW5mZXIgdGhh
dCB3ZSBjYW4gZW5hYmxlIHRoaXMgYml0IGluIHRoZSBwb3J0X3NldHVwIGFuZA0KYmFzZWQgb24g
dGhlIHBvcnQgbWVtYmVyc2hpcCBwYWNrZXRzIGNhbiBiZSBmb3J3YXJkZWQuIElzIG15DQp1bmRl
cnN0YW5kaW5nIGNvcnJlY3Q/DQpDYW4gSSByZW1vdmUgdGhpcyBwYXRjaCBmcm9tIHRoaXMgc2Vy
aWVzIGFuZCBzdWJtaXQgYXMgdGhlIHNlcGFyYXRlDQpvbmU/DQo=
