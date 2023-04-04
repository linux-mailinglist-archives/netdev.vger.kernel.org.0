Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3776D66E7
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbjDDPNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjDDPNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:13:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9896B3C16;
        Tue,  4 Apr 2023 08:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680621195; x=1712157195;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9vI8TeuJdzBGUMKDnvc5otgqXrC0wxT+GQ6gDCPAspg=;
  b=HedKmKrirA0DiT1HSypJ2bVKAvsCEzPzmgpHhKHCaFm3rQh7rHcHmr2U
   ao1/eP/N8d6LyD54A41pcibycFUNlL7/V1pSOswWo0vXVhZxLqcnl404y
   rRAzPM0GoZ4rw2iQT0bndznYNOpf5l6L4lqNYyepXFHAGOC+QpWR5LjjH
   mGixv0wnUw+pDqAz9nsUty88UPcpV7Nhrw6HSRO+9mRQnqkJhTBM0k6bO
   YAbmnj3+2vwVp6TO5aKPI1C04EgYN8/MvIJgzBWYlqsi78pnCtjA3YF1V
   IKq76nBis395J5bUcSi+/4WPlO2pdd6mQENDqZKE9KfZDi+33HIDS39jp
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,318,1673938800"; 
   d="scan'208";a="207691904"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2023 08:13:12 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 08:13:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 08:13:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuWzLVodujW2qRvyNliqhbXprGD7MnKgu9o3GTIwfq1bvvHEEWMw5AQOOlbGJCE+1ggVRIuxWWs096qDrYrm3FvmEbMOSOG7cH+Q5z4vhRm5hExODCLL1BlZSmTY4nBGLl05t5Yh+EVJVd03JiZ1VYPkaFsHOXtT7P7Cf/kRjFK47RrAJjpghTS3CSVe0TzmulLvudfqrP6C9FpAjbG3bRK6SsuhFZuEvazVis/JTR8r+HsAS/+reSiU2Egr0sFDc81do/whrFVXv2qY+4X8VQWRhXGSj0dTj51GmhFcw08xUGHi/Pub+448ER8nGGKLgqtwkZ8kBYWnJZQ3P/y3Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vI8TeuJdzBGUMKDnvc5otgqXrC0wxT+GQ6gDCPAspg=;
 b=iV4+mti36GErvbe+cHtowyPqiJUGxMzKbZlOru1OZ02fKyTRNNPt8pbun8nttSMO8KneHMOLrbSKaHaiw8fH0sl00PIbgVJYbGTZEYzfwWrOpVU4kOt4uFdK+fIVXCKlyeebyzEde664tl5+F785FyvoNEeanFhDZ8tP1ND7Se8lty8lTKb2UouHsdVk9Ga9PNflTe6IKB0gIxkT5FoAYB9frL2gpn12lYQW/pPYt0nhJ+BqmXpdWt1POmOXDPUyT+MBDqnIUTQjgl3APBmEpXSCM4yNRf5PA5P1Xdvhm+gtCophEl/RUuONidJm0QsyaTKXzBcOqT75uHdUgTMA5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vI8TeuJdzBGUMKDnvc5otgqXrC0wxT+GQ6gDCPAspg=;
 b=YRwTUMB+wzs8tzuQbt3hjrZnhgiZcVCNZbw8OEDgFfwFEt6DVopLxEf32ZeV6JHP8jvgypAsIYU4MuLSg773oBVnZCCDC6lOsDjNrtUupvf//yqiykuEmQk+IRtioaEghSkqAvYcz7qfO3AH8DD+mf9+ln0Y69bvaYxwWW4wrQk=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 LV2PR11MB5974.namprd11.prod.outlook.com (2603:10b6:408:17e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 15:13:10 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::5fe7:4572:62d7:a88]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::5fe7:4572:62d7:a88%6]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:13:10 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v1 6/7] net: dsa: microchip: Make
 ksz8_w_sta_mac_table() static
Thread-Topic: [PATCH net-next v1 6/7] net: dsa: microchip: Make
 ksz8_w_sta_mac_table() static
Thread-Index: AQHZZt74uFrYDyaiDECJY8MjXnI/lq8bQi4A
Date:   Tue, 4 Apr 2023 15:13:10 +0000
Message-ID: <72532aaec773c0827d99e0f2f18ed4332a39e95d.camel@microchip.com>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
         <20230404101842.1382986-7-o.rempel@pengutronix.de>
In-Reply-To: <20230404101842.1382986-7-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|LV2PR11MB5974:EE_
x-ms-office365-filtering-correlation-id: e5d8b2b9-da39-4e2d-7fd0-08db351f1a6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1W+41e3IuPSjlDBwWrd54g16QrzVB77ubLo2VIChX5BVtpxvKEGIEBKxvRbqHg3AwFPJlMfpC4IYWL8bshq1v7n6tiMWShlTEpZsVghTKDzGQkYuiwGTnCT34Z4umE7njrXrL9iWuwIdR16QQqPHcxu16ZC8c4sh99R3mq+1akQ6jv6BeUrkEYZd5NGsRWodNL4dAM9qL3adz3LhHHZfQqIwvZeAHuSnVVUuSRtlCd9WzBLuBt6v4zM/eZYUgzEOu106Sj/WWYb7n4bpwSBOLR5FZ9toM3XEDvzUI2puRlfTtmB/KpeorijlVY77KF/8rEq2w0Cd9vOzHNdgJWcHzIEJJ73PxOZWLtXFTP77p+/zDZTYokXsFVCIZu+8U+yu1hR4Y+KHkvjlAf/+Mwj48aHRspnsOst0KViaikGjM7dbkd22CHaaSTrg+TeygaxUjR/NMlowwjsrXI4RI14ICK5y7QObZSOlyshHrh+yISTPcGsI7gV6NH7pm1hKckIYFbtmqUbx+A5b1KdK2fGo3WxjK8F4Gvt76pNhqYdz+Hh1zdZ4sbBQbsmPLXHYX1TJ8i0my29qudwqezjfSrND3tNoJqIZPuryN3sVHYlskJZlfjw5+ZlhPnLsGwWfG5+lK/HqxamqI+iwS1svDogJyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199021)(83380400001)(7416002)(6506007)(558084003)(2616005)(122000001)(38100700002)(6512007)(186003)(38070700005)(86362001)(8676002)(5660300002)(41300700001)(8936002)(110136005)(478600001)(71200400001)(6486002)(316002)(36756003)(64756008)(66946007)(4326008)(91956017)(76116006)(66556008)(66446008)(54906003)(66476007)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVNFcG5zVlRaejdDejZBeW1ldFJwd1hUOXh4ek1lM0dyUGhxWktoRFFkdEt4?=
 =?utf-8?B?eW5ySnFGUTZwN3NjaVd2NDByTmVVd3duK0NSTjNGeHozeWFlWVpSWmNsbkp1?=
 =?utf-8?B?czQ1NzVQUDRDZ1krRWdWSStUK2RkeGJ0cTM5SnQzZlY2aUtoUGh6cFhXa3cr?=
 =?utf-8?B?SWdVUCtITTVSVlVtVktVL0RGZFJId2U0aTlxNVZkMWE5OWZJcGQyc3Z3WFRW?=
 =?utf-8?B?a1A4ZVh1bzhkeUNicXVnWkl4ZGFEZm1nek4vTG5aOTlZQ0R1dXljOGh4RjIv?=
 =?utf-8?B?RFd5RldjNUljcHpyUUpHZWgzcjhOYVdUTnJjN1lvdWZHd2RSVzUxdmJMaU9L?=
 =?utf-8?B?c2Q5REFiK2ZBMHpMbTNURHdwSVBJTXovaDVPSGt5WE9DY3Y1WUdwUVJRTXVW?=
 =?utf-8?B?UklPamFua2NwNFZhZytIbmhoZ050M0lIdXpKNERmS29hUm9YQkVYOE1tZnNM?=
 =?utf-8?B?b3pvTmdsbVZ2cVYrM1FIeGpKeU1sRFREcHNRSWdZSDk4c3hETWNEdCtlSXZ1?=
 =?utf-8?B?T0I0VDZwYjZjZGp1OE9HSnZQeFdoMUliQXg1em53eUtYa2JNcHdnREZnZk9Z?=
 =?utf-8?B?Zm5kVHBaZTBnalBQVCs1WjZkd3ZETnh3eCtMYVJyZ2xTbVNqRnpnNVJpeVE5?=
 =?utf-8?B?Q3h6MjlGQUNqTWZTMlRRdE85bWtrY3ZVcWhNc3d4ajNoeElKaEg5WVRpb1lh?=
 =?utf-8?B?RmJsRTVidURqcGZiWkRucmlsbFlKclZyUitpVjk2Q2MyNDVNMUFrQk8yWWxh?=
 =?utf-8?B?Zlp2RnQxaU9ZaFI2N3RkZ05GS0R5WDZtZDRJNXVzM1AzVHF3K2syNjdMZCtS?=
 =?utf-8?B?WFE2cDQ0akU4SndIakpYWU1jK3R6dGJZUUUveUpjc1pxakxwdEhQditBVGVI?=
 =?utf-8?B?YmpkUGNmclp1NEJiSG9tdHRXdWtvdjRJd3F0SDZNemRQSFEzZTR3bk9DOUN6?=
 =?utf-8?B?OHdDZFBndERBRDYrcDZTRnEzemF3eCtxTTVDNFN4WXdYZUNMVzNyemxWU1po?=
 =?utf-8?B?cC85emlTM1dPVTY5L2tmcERmaFB0ejM5a3I2Z3FSc1BPb2t6NGNKdUtrbmV1?=
 =?utf-8?B?OWYxY1h6N2JGamU1dHoyMlltOUlvc29wRW5MS1RHSWY3SUxEL1Q5VnhZSS9O?=
 =?utf-8?B?NHNSSGZIS2VRVklkWEtKRk5wMnYyUzhiV0hXWUxjTFdWMkhiblhzYkJIWWtL?=
 =?utf-8?B?OWNrWEZsQ3lhN1lvUDE0QWNyazgxMFgwaXRpTFUyQklzRGZHNHprMWlHSnla?=
 =?utf-8?B?YWZ4VjI3WDRxZXkxbitQYk1sdnlab09lYWNTY1JQQm5hZ21GOCtRTUx2bjJr?=
 =?utf-8?B?d0ZmWVRIZ0huYlNOejFNb1Q1T3phQStMRlozVEttZ0ZwcHRKUlRNYUJvYmVZ?=
 =?utf-8?B?V0FPaHU0VnZBM3RkbDVlUjlJMUgwbWt1djlqNFZFSnJnUXF1MWRYRndrSnRv?=
 =?utf-8?B?dDVDQ0gyRTlacnZoRmR3RmVxMHVqWGlBdFpsL283eEpmTU1VdnQyZDVNTFlT?=
 =?utf-8?B?QXo3UHRuRDRUN2dxY29Zc084Q2pRUERTZDNVWWFxOVlneis2YkJ1Z0djYkhU?=
 =?utf-8?B?MXV1VElKejdPNHp3czF1SzNCZlQvbnRxYTBRd0ExeFFYc2l2ejk1QWdDMVB4?=
 =?utf-8?B?VGJQWUl3eis5eUxCSmNNYnNqT3NMZi9VdGpPMVpxVHdJSGc3c0V0ZUh2VkdV?=
 =?utf-8?B?aFQ5bFNWQlluc0tTRkJGWEJyTkJPbmdJVXh1dDhpcjUvdEU3bWZZL05IdGRE?=
 =?utf-8?B?WGlEOFNPLzVBRVdVRDAraHU2LzFMNmJXWnNxVUVjVG5SOVNVdVZZVFdqYUpV?=
 =?utf-8?B?VEo1RmJEc3hBdXdPc3BaRUozN2orckM2WnUzSTA0MkUraXA4a29uU2cyZDNj?=
 =?utf-8?B?U2pWa0dVS3lXcDUwSFphYURDd2Faa2Q0cVU5dmpEalo0cExPZnIzU3dkM0Iz?=
 =?utf-8?B?TVN0NDliVkY4dm43M091RU4ya3Q4OUM2MGluNHNKV21PdWVaYVYxMzliTC9Q?=
 =?utf-8?B?cHJDNTJ3ak41ZjFpMnF4R2RCbVlnYjlwLzlpSnJSTWNzSXVCZnNzYWhZVks5?=
 =?utf-8?B?bDdUY01WWVlGSGV1dy9BeGIxU1YxT1R6OHRjdkVuTm9yR2ZjVi9yb1VJOHU4?=
 =?utf-8?B?ZEhYSVlhellycmVSbHRZcFg0ZzFrSVNmb0haMzNNR3dBNUZHR09YY0o1WDZ0?=
 =?utf-8?B?emdGTUQwZ1JMQTFhQTJScDYyWkQzcUE4Vi9XdW9vVnpDS2JySjhoVk1aaXU4?=
 =?utf-8?B?MlBFMUNJU0ExUzMzUGN3cVJaL2FRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA975988D08BA64F85613F5A2C5BF089@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d8b2b9-da39-4e2d-7fd0-08db351f1a6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 15:13:10.6542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i1L2dWC3xWgdCj9pv2xzzVX2DfUY6e8gKvPM4tQcDFoFYDndYUOePGdRMxBJkfVGDkuuzb6cQvg+wUhw4vipVp3i4XcrFZxUInoWZx7i4lU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5974
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gVHVlLCAyMDIzLTA0LTA0IGF0IDEyOjE4ICswMjAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBTaW5jZSBrc3o4X3dfc3RhX21hY190YWJsZSgpIGlzIG9ubHkgdXNlZCB3aXRoaW4ga3N6
ODc5NS5jLCBtYWtlIGl0DQo+IHN0YXRpYw0KPiB0byBsaW1pdCBpdHMgc2NvcGUuDQoNCkFja2Vk
LWJ5OiBBcnVuIFJhbWFkb3NzIDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+DQoNCg==
