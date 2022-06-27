Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098C755D8B4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiF0LRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiF0LRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:17:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F7F654C;
        Mon, 27 Jun 2022 04:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656328668; x=1687864668;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=08Nj5VXaLPwFgPUWUVRdRAsWD/HK6zHKQzzSjMS+vw4=;
  b=ES0+FS4HiENTdETh9zDHHTbH2ClgAuofL66qE2xkj5AOQ56WEtMntaUV
   kx3fR5M0Vye39mYvpgU/YcSSO/JaN2QpimR93v/qrTLjqZWmv/yqyF3KY
   Me6zSUczHx2JJxCj7WBBGCZgqg3dzwCPmv+AzioY/fGyH7zjPmMllhuWc
   xHhF/ssCqP7LPoIqqCpdaq+5z9uvmCyBn32+tOE2+GiQhrB+Vv5ekDCui
   /dK4akrq/dlAnkAQ8Z07BSskBJC9Dbm2UBTkHvv8zr63L4EzwbmwB1uLW
   NV+Wn9AHCv+yZbe+aXiXp5914RWwtypAC3E4F6OD2Olk6Kf8Io/VKggrg
   w==;
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="162185528"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jun 2022 04:17:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 27 Jun 2022 04:17:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 27 Jun 2022 04:17:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXGGdurY3hNO8p5Y1F5S1z10q/vKyXdLrrFkPfPqPyR5XeDYxXtnpghcxt51i87m+olrYxaIKBvOLp477ty7VFcPs+NSkTO6BPdiB+TG/WFG+M5CD1CqCr99/yNHCdK0Y8/UZy2l9FRN6Z11n28R6OTJkfQ4lGC7VtHxmF/xRBzTIMXQL1W0VwcN6ziEOVIZABrOoUMKdiZZK6CilYR5VkZ7QM0axdumSHzOhNMmba6q94WFP8GRmlKgpBQdSiXn0seouqZ/aU18vDsSe+EaxX+fxJBtWxAQbZZr3q+lw0yitbLaHi7ctcDZYdYt7CLlXt54vEhb40UGqH5WRou7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=08Nj5VXaLPwFgPUWUVRdRAsWD/HK6zHKQzzSjMS+vw4=;
 b=fZE0lxQdJQvkmWTzCWYB2Ike46YG9viHZQV70i4UdbzjojZRAeD4mkTZmHfiMHkoA0nxlarnE47tNJU7wGTPxYy8PDjOnbaY4+7V/ljqx0DLaLvO0jg8u1SRje1bWwtwKR7hxfv0hQyf6euA3tMibAgbPP9QzyL/1yRG/hAI++sYwFuwG+0umENOA+v6wylrKFVhkJ0tKjYxlKI2QKzMODgQgM4PTTG1yBB50c3GAjbudxfanvMnsp/+zHupnVIP88uP1+ta2j2S7JEm16oHVOAjjx1w0RoXAbR4LV3BXC+PuE46DLZRvuEPCu8vQvtYx9k0HKxpiHRMSxvJqEhrxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08Nj5VXaLPwFgPUWUVRdRAsWD/HK6zHKQzzSjMS+vw4=;
 b=OVciAV/loyxxtiOntWPoZmxJrD8P/SCUq37x3oxfyrU7w0HmGpdyJNczsqYySSdfc7Oj8THDGBm0VGPDyUK8kurijh+GzXvpUXkmxAsbUi1PuaNISFm502wf02Hfxf4lGpDop0O/lEFFUFzutfG1Bt+ZZH/EVf/VI3piIaxRO60=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by SJ0PR11MB5917.namprd11.prod.outlook.com (2603:10b6:a03:42b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 27 Jun
 2022 11:17:39 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 11:17:39 +0000
From:   <Conor.Dooley@microchip.com>
To:     <mkl@pengutronix.de>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <kernel@pengutronix.de>,
        <palmer@dabbelt.com>, <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH net-next 16/22] riscv: dts: microchip: add mpfs's CAN
 controllers
Thread-Topic: [PATCH net-next 16/22] riscv: dts: microchip: add mpfs's CAN
 controllers
Thread-Index: AQHYiIwO2RhNbJRj0UuhSQdJJDIbva1i2XoAgAAE2YCAAD+SAA==
Date:   Mon, 27 Jun 2022 11:17:39 +0000
Message-ID: <a1b84760-821f-a279-ca2c-b22d5f1a99fa@microchip.com>
References: <20220625120335.324697-1-mkl@pengutronix.de>
 <20220625120335.324697-17-mkl@pengutronix.de>
 <ff40e50f-728d-dba3-6aa2-59db573d6f76@microchip.com>
 <20220627073001.2l6twpyt7fg252ul@pengutronix.de>
In-Reply-To: <20220627073001.2l6twpyt7fg252ul@pengutronix.de>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10588e6e-e810-4c58-a957-08da582ea592
x-ms-traffictypediagnostic: SJ0PR11MB5917:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wz/OOtUxDwiDK3zyB2T3ia+cubnXhoUUVkxQc9O7UF/0HoTiN9XoGZycfp5fzehM5svcCcXsOqzHF4qK9VeAZu3/8st2fWNWm3gHHHVcNtPg/Pv3jDTonslLQgpTFqWBu9UzSmIssFg110jKMXqvhqaR/BjC+2e2iPY6c0WjQoCjgYkuqc+0Y3ulz3nVOs9dy5dXPru91tI3oIuIndDgJPXyw3Ep9a6m3wtZBAWCF4GZa/SjoQnkcMnJXy0wUDsLQA6md+5oQ9DlEbZs7L1eBUwvVLKK54iibUvF3/L9tfnWBAJ5GumGUHip2AHO3DlItKe5KLh1a4LhFonbinj78asjq5PVKVzhAWYU5vZT+M2oA4zCbYlb4mFb6/V1otupW9/zIweGBB/B44Q30H/YwkfByCfvl8IMYJQPmsRFjPD5AXEzFl+w8QvOFcrrubZEh3A+tqwZSFAtYNEeoMgRV11/hQRHWFS2KWs/8GH/hq6Ykcn6NauUoEVQqf077j8r/tX9Fe7Ys4t2kd88E9SpJ0sUngvFFyidWZQCBLwzRa5P1HlpxJUHW6mJq+BeBpp13kpRnZ2cVIAz3pRWSTWY3rBvvytvVKEHuuWajw3Y8sjA12+aBeeLZSHFATisQ8JMxOMzZJyLZF7Vicl60uEEainJpugfW8YNqnDaElMWsl2YbMWe+AP80w7QWxL7zVGfWdGEsUrCBx0Vb5H4uBylsIyIM+RYj6zFZYJeajxEjgVC0xhiEqwHj5+gpxurFRu6hnuMUwoPpVjjSJFq07ugV8q4MLesfzifYhoIT+p/7/EFLtC8DdasKutwkBWouW2Xs7Z0qfWaKyNQcAXvUDPZTqBuuTwAjLfhBmpx/JWA3MhiFg99PRH/JJu9BUjS1l3wS/iKThwRDidNhGUlUlTn1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(346002)(39860400002)(376002)(36756003)(6506007)(66446008)(8936002)(76116006)(186003)(38070700005)(2906002)(26005)(6512007)(478600001)(38100700002)(91956017)(966005)(71200400001)(53546011)(66476007)(8676002)(31686004)(122000001)(6486002)(31696002)(54906003)(66556008)(86362001)(41300700001)(64756008)(6916009)(2616005)(5660300002)(4326008)(66946007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2JGQ3AwVGMvY3d4a0ljR05maFJtaG1nUXR0MlhPWnUyeEJBZzYxc2h1VW5m?=
 =?utf-8?B?YUwrUm9jY3lnNlF3Sm8xd0hzNWtCMHZQZGZ2RlZXcUUwWjdUWUk3M2tNb1M1?=
 =?utf-8?B?bUtaRk50bVpQbnhKWlVRQWR0aGdmOUZaZGhKS3dKeGdDQ0FZNmpudE82T04x?=
 =?utf-8?B?a1FOK3BPSTdCeWU5dzFCaVBxV2hVOWxVQ0RvSFNsYzZhS3VZcWJzOTBva1lD?=
 =?utf-8?B?cUx6Y08xRE1DdmVjeHNMVVd0RTJnRll6WWM1WGN5bDBDZFkxbVUrdStjR2JG?=
 =?utf-8?B?eHlORGJpOFplcnRGK01wVHhIemkydlkzSDZMU1Nqa1BJa0dwWGYyTTVPQzk2?=
 =?utf-8?B?cDhSSWZ0Um1JNkQ5R0c2c2VFVnJYVWhySmIzUTB0VXVWUDNtKzg4b0xhdEpl?=
 =?utf-8?B?bHpmZWhDdUgwN1RjMjczQkRVTkJ2bS96cUxhOWJyS0lrZFFHaExJb2t4NCs1?=
 =?utf-8?B?VVFxMTFIZWJpNVorRVhxVUVwbURxWE10SUEyUWRVV0dQTVZua2tDQXFxRisv?=
 =?utf-8?B?dzBRcEY5WVorUVRZTTZvRHZlV09xZHdYN05UYlVIZWhLbGkrOGNVdU1XY0ly?=
 =?utf-8?B?cEZCdEpZdWI3S3B4MktpMzVvVW9vYjBPYVZzbTZkaVV2ck95UXJvcys3RkxU?=
 =?utf-8?B?N3lqa0tjRDVRdHdVK2RIVHg5bUtBN1JWT0lyWDBMdHErWTdwdGFZRk96eTNY?=
 =?utf-8?B?c0Fmd3FaZkkrRnFsK0w4WmxxNHp0M3BycGcyWHlZMVVubzduc0xpUlRvc0FG?=
 =?utf-8?B?SUVsQVgySkhXTHJlcVJwd1FvcGhFYkV1VnBSaHBHOEdvazRHcjA5dXlwdTR6?=
 =?utf-8?B?OTE0TDFrenlSTVNIZjVZdVgycWxSUEZQRy9CNVJGZGM2LzNZZWxLVXIyR1NS?=
 =?utf-8?B?cHNjREJPNlA5UmxwdVdYVFc5dVo1ditCb2RkNmJUdWYrNG8ydG5CRHZxcnQ2?=
 =?utf-8?B?cUs1UU9oZ3E1Ulk0NjZDbnViVEtDRXFhUWprejlTVmo1OHdrdkpTcnpENklG?=
 =?utf-8?B?T0t1RUtiT0tSMSsrQU9hdU9BejNFVXBBOXgzWEZVQnlDUlNoQTcrL1J1R0ZR?=
 =?utf-8?B?T1lSRzZrNm9HK0RmUDVRcVBkMG5iSGg5bmwwS3dYUWFMbmhJV1dFOE1JcUNu?=
 =?utf-8?B?anJPd3UremJYK2lzQ2F1OGlBRy9WbnhHT0xBemI3VFZIcUkzOURORFVGR2Ir?=
 =?utf-8?B?Y2RuYmcyOFU4c3NJOGQvUFNyWEdiMUZyQngrdTNUWE1HUjZBVFYzRkF5YUpX?=
 =?utf-8?B?QUZOR3dkcGRKQ3BhYmpHbktmNDV6N245SFZOUHV5Q0JzY005THhGMS9pbUNG?=
 =?utf-8?B?RFJOeXpBM0N1TUpUTGlWM0JCL2tBd3VSQTNzR21EZXUxSHNIaTI3ZU1BTk9o?=
 =?utf-8?B?eXgxZTAwSjdtQ01wVDRnVkI2YU5SblViYzJieFNnWlNodTRXVkVXZGRVSGZw?=
 =?utf-8?B?WlR0Nm4wWGRXZnlPZDJwUWFDM1BUaTNPZDRyVWo5bklzUVI5Z3RyV0hXaVQx?=
 =?utf-8?B?bzBJcjJqWFQyMDcrRDFxaGJySzF6N0JKR3RWN0RqMjdPVGJwOXd4YjBjbEtG?=
 =?utf-8?B?T3hlTzROdXEyYjJwNmorelozVUtOSjI2VU1CNW1VWDFzdEZhRHFMaWpmM2Js?=
 =?utf-8?B?azI2TEdZQW1IRWlnR0VZQTY2WC9sS04wNjRBb0UyaFlQT2pNaCtWUkhielRw?=
 =?utf-8?B?Q29RR1lkZ3JGeTNmSGZ0RmN1NmNtNXlPaCtvdWF5ajFiMFArVjVWWE0wd0w1?=
 =?utf-8?B?SzhDdnVib3J2aTlvRmtwMjZJK25KTmN2eG0xVG03OSsvWk9tV0JZMXlTQ1VE?=
 =?utf-8?B?cm82NEFyYmNxSWtTWkRQMGJZd3o5OTRQTm40Snd5QWFpZmZLOE52NTlBUmJq?=
 =?utf-8?B?bFgxYkd1TFpVams0UFM3b0tDQXdXSGYxeS9sV1BORVlTVncyWW5CNHFCVzVn?=
 =?utf-8?B?Uml6U3ltZFgrT3BodGkxWENzWTVaSzh5aGtucGVsZ252WkNudzBoM2ovNC9G?=
 =?utf-8?B?QVRjbXJVc2xITEkvRmJNN01xTjZpdkk4bHJ0a2t6b3ZRejg4S01KNmZlZlla?=
 =?utf-8?B?V1Zhb3VoTldlOXJFNEdJUUpOSFdGWEtSTWhDTDZTOGlnQnJtME5EZE5EeTU5?=
 =?utf-8?Q?8cGyy1ioqprdjHYLRIZBxhfCt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B75DFD07EBC5DB4CA843E2E5E80D2606@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10588e6e-e810-4c58-a957-08da582ea592
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 11:17:39.5625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kxTiwAsiWszriPHGYkpqw3K7OrxY1kzHRpC8h+1EINLhEWPOGkfqmemnn2Gi1dkhd1QNQknQpcAhwchtJjDgzs6yh7z5MRWD8GFHsJWHcCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5917
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcvMDYvMjAyMiAwODozMCwgTWFyYyBLbGVpbmUtQnVkZGUgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiBPbiAyNy4wNi4yMDIyIDA3OjEyOjQ3LCBDb25v
ci5Eb29sZXlAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4+IE9uIDI1LzA2LzIwMjIgMTM6MDMsIE1h
cmMgS2xlaW5lLUJ1ZGRlIHdyb3RlOg0KPj4+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sg
bGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMg
c2FmZQ0KPj4+DQo+Pj4gRnJvbTogQ29ub3IgRG9vbGV5IDxjb25vci5kb29sZXlAbWljcm9jaGlw
LmNvbT4NCj4+Pg0KPj4+IFBvbGFyRmlyZSBTb0MgaGFzIGEgcGFpciBvZiBDQU4gY29udHJvbGxl
cnMsIGJ1dCBhcyB0aGV5IHdlcmUNCj4+PiB1bmRvY3VtZW50ZWQgdGhlcmUgd2VyZSBvbWl0dGVk
IGZyb20gdGhlIGRldmljZSB0cmVlLiBBZGQgdGhlbS4NCj4+Pg0KPj4+IExpbms6IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2FsbC8yMDIyMDYwNzA2NTQ1OS4yMDM1NzQ2LTMtY29ub3IuZG9vbGV5
QG1pY3JvY2hpcC5jb20NCj4+PiBTaWduZWQtb2ZmLWJ5OiBDb25vciBEb29sZXkgPGNvbm9yLmRv
b2xleUBtaWNyb2NoaXAuY29tPg0KPj4+IFNpZ25lZC1vZmYtYnk6IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+Pg0KPj4gSGV5IE1hcmMsDQo+PiBOb3QgZW50aXJlbHkg
ZmFtaWxpYXIgd2l0aCB0aGUgcHJvY2VzcyBoZXJlLg0KPj4gRG8gSSBhcHBseSB0aGlzIHBhdGNo
IHdoZW4gdGhlIHJlc3Qgb2YgdGhlIHNlcmllcyBnZXRzIHRha2VuLA0KPj4gb3Igd2lsbCB0aGlz
IHBhdGNoIGdvIHRocm91Z2ggdGhlIG5ldCB0cmVlPw0KPg0KPiBCb3RoIHBhdGNoZXM6DQo+DQo+
ICAzOGE3MWZjMDQ4OTUgcmlzY3Y6IGR0czogbWljcm9jaGlwOiBhZGQgbXBmcydzIENBTiBjb250
cm9sbGVycw0KPiAgYzg3OGQ1MThkN2I2IGR0LWJpbmRpbmdzOiBjYW46IG1wZnM6IGRvY3VtZW50
IHRoZSBtcGZzIENBTiBjb250cm9sbGVyDQo+DQo+IGFyZSBvbiB0aGV5IHdheSB0byBtYWlubGlu
ZSB2aWEgdGhlIG5ldC1uZXh0IHRyZWUuIE5vIGZ1cnRoZXIgYWN0aW9ucw0KPiBuZWVkZWQgb24g
eW91ciBzaWRlLg0KDQpkdHMgdGhyb3VnaCB0aGUgbmV0ZGV2IHRyZWUgcmF0ZXIgdGhhbiB2aWEg
dGhlIGFyY2g/IFNlZW1zIGEgbGl0dGxlIG9kZCwNCmJ1dCBpdCdkIGJlIHZpYSBteSB0cmVlIGFu
eXdheSBhbmQgSSBkb24ndCBtaW5kICYgdW5sZXNzIFBhbG1lciBvYmplY3RzOg0KQWNrZWQtYnk6
IENvbm9yIERvb2xleSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+DQoNCg==
