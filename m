Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7F0E4A8A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393570AbfJYLzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:55:54 -0400
Received: from mail-eopbgr00077.outbound.protection.outlook.com ([40.107.0.77]:59510
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726484AbfJYLzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 07:55:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBTtFd7Ho0uGTTdnc45ENeDK1XonydrO/7JrmiApeSwhTBCBaqUZtLKmmO9LTfMfTjiJwIJl5DT0Clh3P4G5+O0Ip2YFisOfXJXMq9GJnNrYFT9SSNoshaPCfV8YV6TA96JkqsByoKi6HhaacCv90aLJ6ihV4w4DtqRIeQOUVREvWyrmV0nMMxQJyz2azyQZop+Tg1qI/NLabJxBYqINvH0hr8tZG2U3cBCA/n75ixurTiVFCRduW5zPfoaodFo+qsS6EJ/wOmyTA0z8OH1RR7xu1D00BvhU90o0ncRh396ER/FrbjtdK18/0OjsZ0WryOX5JtnenPYSOVAJBzeKhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFBupiwffWH7Zt2KmHhMyr73Rn8ITvJHPwOHQ4JTksY=;
 b=oPYFok5r/69OO8h2dxUlM+IQ6y1fxI1dO3bflTiA0CvAnYkmGJWvY7SZP6bgE+TzXroYLoOqkZuNM2RBVZqX3Z7+FT7qdHPTkHkaySBxhmXU+hxxAdyMU9004ddPRSYKAhzRECyqzWB+iiurspRTGVo9RJzFoQCZIhUDHJu64h8BVi3h/TGZNvV03LX83+wr4vFvoXrUgPHBzONuoqhp5brzZWYYjAMqnzl9gy5og9Ti132hzfh9jS26afRWXLQu11FvGmbBDMXBcRiV0DfuYURnGY9dlj3QMEBBNEO8C6DeoK+xM27C/eyUO8wWsGIkqR0yi7q1O0a/lnvJk6lVEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFBupiwffWH7Zt2KmHhMyr73Rn8ITvJHPwOHQ4JTksY=;
 b=eVSlRFTaLtPFQUvoB/yaoTYnVDNjORqTAIsdPNu0JSf2jJ40JIm7NQOaJzRSVr21tK1WxOUxGR/kTHEF24/iXB1qWrV0vZjNj1Sag3ntRkNrsxmnkvNSdyzTpj7AzrVEb3yQBWEplIVDAjiotm8RVppdVwbCaepFVsoGH8+pzeQ=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5581.eurprd05.prod.outlook.com (20.177.202.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Fri, 25 Oct 2019 11:55:49 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 11:55:48 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Topic: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIAACQIAgAAJDQCAAA1uAIABKGwAgAACuoA=
Date:   Fri, 25 Oct 2019 11:55:48 +0000
Message-ID: <vbflft96num.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbfv9se6qkr.fsf@mellanox.com>
 <200557cb-59a9-4dd7-b317-08d2dac8fa96@mojatatu.com>
 <vbfsgni6mun.fsf@mellanox.com>
 <2f389edd-a0d1-2e44-4e14-64ddbd581d3d@mojatatu.com>
In-Reply-To: <2f389edd-a0d1-2e44-4e14-64ddbd581d3d@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0450.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::30) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f6fa6fde-e412-4e3f-4662-08d7594246d7
x-ms-traffictypediagnostic: VI1PR05MB5581:|VI1PR05MB5581:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5581CF90382962F50A8A3ECAAD650@VI1PR05MB5581.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(199004)(189003)(186003)(76176011)(66476007)(102836004)(386003)(86362001)(66066001)(53546011)(6506007)(25786009)(3846002)(6116002)(8676002)(4326008)(11346002)(81156014)(2616005)(476003)(486006)(446003)(14454004)(4744005)(64756008)(66446008)(4001150100001)(81166006)(478600001)(6486002)(305945005)(7736002)(26005)(66946007)(8936002)(54906003)(99286004)(316002)(229853002)(6246003)(6916009)(6436002)(5660300002)(2906002)(36756003)(71200400001)(71190400001)(52116002)(6306002)(6512007)(66556008)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5581;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rv5ZpFEc0ZvMcnsNujuNXgZCNjVCg2KpWE1bQf7VNdnBQEoWofE7paf220wZJOXF1agpag0xEjhQlQ5uTmbBsjQwMNOi8O0u489HbJ9m5NHEA/OAiRZayvCYLZc8akZQOLh+hAslGQyltWe4VItyYOLs2hvbMQBRRCTFPa56iyH4G0dYpo1DbxGnddJlahfiLBjj6v4fDXfylvKnyBS5dtxA/nJqIMgSWF5yzR57/YhM8ynMffOvEiLvIu+MNoQvO0LbqQpYrWDRvqP7lZ2vTz0Ac3/vsSrppyB0ZxsQb0wFZHgoPorFtl41K5jgLZ/aq1KQzVB4pNxxoPVLlvJ+ELhdsAi7Hbiw2kFBjqQYqA50TWrUbOfZCdv2MCpTnAO50pgMqm719JioDm4aBt2zYIAe9zb8XUJSqaBEjjQMU0XD3/LXXnBQ94hvQ7kYMd/agHgTkFN2pUhRcbzwV2tGrYdUOeucwc4HH2cSgvZ8vm0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6fa6fde-e412-4e3f-4662-08d7594246d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 11:55:48.9040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FLKYKZ/kX1Oi04u2UJ+HnB0z0q+jO9RzZpzyXvUWqeyLHQldoOoaocje7Hufw5lZ389q+NBZY3To7EbDWb45Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5581
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 25 Oct 2019 at 14:46, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-24 2:05 p.m., Vlad Buslov wrote:
>>
>
>>
>> Yes, of course. I was talking strictly about naming of
>> TCA_ACT_FLAGS_FAST_INIT flag value constant.
>>
>
> Sorry, I missed that. You know discussions on names and
> punctiations can last a lifetime;->[1].
> A name which reflects semantics or established style
> is always helpful. So Marcelo's suggestion is reasonable..
> In the same spirit as TCA_FLAG_LARGE_DUMP_ON, how about:
> TCA_FLAG_NO_PERCPU_STATS?
>
> cheers,
> jamal
> [1]http://bikeshed.com/

It looks like I'm the only one who doesn't like to hardcode internal
kernel data structure names into UAPI. Will change it in V2.

Thanks,
Vlad
