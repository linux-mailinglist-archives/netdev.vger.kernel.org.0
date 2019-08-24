Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077099BE48
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 16:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfHXOoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 10:44:15 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:43970
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727556AbfHXOoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 10:44:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXYkbw3aCfII6rlOHfpwtS+GopXBUyunnrWhc/imBOCZefLyjksMSOZUKsayUVzeHLP+bSqr/ZjJinCfUlHy3P4J2iDtdXhgP29yG8KmW4sItOX5t+jDw0pnFN5ZZqeoU/Mjl6HancfCTGD9aAuTdUKVR6Yiw/hFvZqOev4CIRRZ0pgKZGT03zd6bky/i+cD5NwuC4jMlN6OlI4koljjfk6kGRGFSPIO8vmLKp2+iHzJmTo6P/evMBVu9zH+j52rHi4XXfbJ5DbWn92/84P0gPX4aQXG1qjO5DUNKbdsDlx+lWWHoJvknbvLosgRhoORwZtECPXwpOV1DaDhstcbCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJPYZl4jB7axuFVS6TZjZ2/HvqgrVXVJ3IadVNySyYA=;
 b=aX+F3maOiXNqYVkO7lbWU6OsertDOb0RkfZY7AdnIjRtMZJ0L5/2sxsPtPHnxOhiXgllDehT6WZdw1/Kdjfv5wd112+fKAeu8aX6Ct98P0diz91+LOE4n0LmjAERClNphpVwL1bWH8Xnmb7Ov2RJBhBL4iY/RCA4CYXMWRnwV5F2LyE2iBA68D2wwIfWD6mMmz5gCyuIiiJVd7A4zWdO1Kcn8/JTQVAuFrPsmxXGlaDoBycPwyQCQhrfYr999/mS6Vdd58O2Pazx32cvZ04CPyajKQgEC5/0+7etkH27nUdDw1oy2ajm4CFFzFKznt8b/Oya5mDSKxEtzVxNz9eIEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJPYZl4jB7axuFVS6TZjZ2/HvqgrVXVJ3IadVNySyYA=;
 b=aIaqo1CzAC2myW5QhnmJicWaAaNkGAL4/0wdlAbWd21sTwSaALCl+JNeCTLacfVzchy0XNGH/L72HuKDyBJ6FtUf5WXaqpQwKhgJZWKWFQOYfX9AJh7ghDwV4e2efvT6FDG7Ehq//zT/LX8LrEL7tBZFJIxyPANCE+1WNBbS7ZA=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4160.eurprd05.prod.outlook.com (10.171.183.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Sat, 24 Aug 2019 14:44:11 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.020; Sat, 24 Aug 2019
 14:44:11 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Subject: Re: [PATCH net-next v2 03/10] net: sched: refactor block offloads
 counter usage
Thread-Topic: [PATCH net-next v2 03/10] net: sched: refactor block offloads
 counter usage
Thread-Index: AQHVWePGfEjaYW9RtUGGvYH24ELWfqcJcXMAgADviYA=
Date:   Sat, 24 Aug 2019 14:44:11 +0000
Message-ID: <vbflfvi8vyg.fsf@mellanox.com>
References: <20190823185056.12536-1-vladbu@mellanox.com>
 <20190823185056.12536-4-vladbu@mellanox.com>
 <20190823172648.7777e2b6@cakuba.netronome.com>
In-Reply-To: <20190823172648.7777e2b6@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0204.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::24) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdf4f5a8-1b24-4a53-eecd-08d728a1869d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4160;
x-ms-traffictypediagnostic: VI1PR05MB4160:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB416032CD52DBB87D9F2DB1C1ADA70@VI1PR05MB4160.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(199004)(189003)(25786009)(76176011)(229853002)(305945005)(66066001)(2906002)(256004)(7736002)(6916009)(14454004)(14444005)(8676002)(81166006)(81156014)(3846002)(8936002)(5660300002)(6486002)(86362001)(54906003)(6116002)(478600001)(316002)(66446008)(99286004)(64756008)(36756003)(11346002)(446003)(4326008)(6512007)(66946007)(486006)(6436002)(71190400001)(71200400001)(102836004)(6246003)(476003)(6506007)(186003)(386003)(26005)(52116002)(4744005)(66556008)(66476007)(2616005)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4160;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZeuXKZWqCaWFFvUW9QE5ikQNZWlURd+3fDAE5/mxf5sE7Wk0iwhof6wh9twosw3l1bcuX8V+Op+Nj6YV2gVIN15RYXqYLQ0Qw8IG7D4+Oc4UvNsB3LOLQ9+pHCSs7W20bGW2XjZ6u4WO6lg7HpN6kVAkj9cMA6az8Z/PdMnY4gp+wQEXQqxEQrDyxnuw/P/G8iNWRJMzR1IqZo/TAVkLYPxlnbe9Ony6ATLMCGlk4uc16AkIeqChrwwuqbqlEYS5+eAm9aFVrxd+SHwr55Jz0jWkN5hIxMjYQmGdqmvnlYJIbzL8XFNn8aCZ7RCOuO4Pclp3senazo0pGFJXobsiXulLHj5rqobcEjXb/AGjGvLKcV9DYilzdMYQoNXu7tlDcBwQGKRl55CaCCptLHShUM+6xkA3XZprvK8atAjUEF0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdf4f5a8-1b24-4a53-eecd-08d728a1869d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 14:44:11.2125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FpzJBhGakW9I/VbL3OZSyc5FPJ3vUd5knSwhvEVDm4Rps/hSH6X+hPhZaIpyWPls8I5GOjB07YQqpDJkOgQ48w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 24 Aug 2019 at 03:26, Jakub Kicinski <jakub.kicinski@netronome.com> =
wrote:
> On Fri, 23 Aug 2019 21:50:49 +0300, Vlad Buslov wrote:
>> @@ -1201,14 +1199,11 @@ static int u32_reoffload_knode(struct tcf_proto =
*tp, struct tc_u_knode *n,
>>  			cls_u32.knode.link_handle =3D ht->handle;
>>  	}
>>
>> -	err =3D cb(TC_SETUP_CLSU32, &cls_u32, cb_priv);
>> -	if (err) {
>> -		if (add && tc_skip_sw(n->flags))
>> -			return err;
>> -		return 0;
>> -	}
>> -
>> -	tc_cls_offload_cnt_update(block, &n->in_hw_count, &n->flags, add);
>> +	err =3D tc_setup_cb_reoffload(block, tp, add, cb, TC_SETUP_CLSU32,
>> +				    &cls_u32, cb_priv, &n->flags,
>> +				    &n->in_hw_count);
>> +	if (err && add && tc_skip_sw(n->flags))
>> +		return err;
>
> Could this be further simplified by adding something along the lines of:
>
> 	if (!add || !tc_skip_sw(*flags))
> 		err =3D 0;
>
> to tc_setup_cb_reoffload() ?

Indeed, all the users of tc_setup_cb_reoffload() have same error check
that can be moved into the function. I will refactor it in V3.

>
>>
>>  	return 0;
>>  }
