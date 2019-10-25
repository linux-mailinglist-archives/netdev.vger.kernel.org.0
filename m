Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15C82E51A1
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505739AbfJYQxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:53:38 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:57873
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502610AbfJYQxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 12:53:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfzrSN32nELtCTpQJIxgcVS7fNkumb2AyMGrFG6QL3n2dSDlbxQZUiBFQG7Z6AxX+9DRbe1XAwkzaYl7Uj3j4++30rexY5nREwhhDSG2LKFD823pH3zw4GL5KNntAFBbvu4B3x3aC8KApWvRCJlKWQv9ki/uaSYOuyz8OkNfN5cuXl1keUxe2kwlvaFGsWMRbIg1whKL8WHgniyvzQ6ysxkPFUBZUroiVtg5Qp+QocBf6cCDizV4LXe72gzndu6gO+cW7TCBbTr5wuns7GsIdpkctFNKLObI0MCw2U7zSRwhfXmS/W0l1oIBeGzxrreVZ+InlKwdJ7zvkk/QlB5y6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHDfwumSV3km6u7H5ZHGRUFmkPJkH2Kksct56CO58+0=;
 b=YfuYK9wjgQmVY8HcIMe5zielx7pzU7+MKBb+RnzKVY8NGp/pdQBqwvqZN//4pP7ZJpSEOYDGDtPPXNM2zd9mrguB8aipvgrcYFo17uLS1zIWlOUNSMQBRKdWOxdM3Nl+jvKijSXBBFdxnnCNGXpIgXEagn/iceGIIPtnSDXjKoUD2/1baZHsEsPEwoJOgpNXVCA0MBaUUsWl5eeYcx2EKu36U38kPhtTJCDxMVB4UXfnOb02Y0aP7Y4LOS5yF/1hrEjCK+8Zlz8PS+z28MKT2qzOgHAQA6dfu7SEY1IQdqiYwtUHgJ505EtnvR5x5o0wl6TeDr4wRTV8w0CL3Byqdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHDfwumSV3km6u7H5ZHGRUFmkPJkH2Kksct56CO58+0=;
 b=GAhxmFxelj9w94LuH0ZPUz9fq5Hv0ByYPQ5q+nD6N0VX3wKTovYHMv6FGT2EWPQ5mMk3qira6GCmpBQRYgGrV4d1AY8fzoPG12302/ela+h9Y7WduL8mMpwo7+fwaNVGeJEwLyb8Pq9/u+e0kyAiukFFSWNBnDlzt68Nbvo0Wuk=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3278.eurprd05.prod.outlook.com (10.170.238.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Fri, 25 Oct 2019 16:53:06 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 16:53:06 +0000
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIABdMWAgAAIhYCAAAMgAIAAAvYAgAAG7gCAAAZJAIAAATEAgAAFeYCAAAZxAA==
Date:   Fri, 25 Oct 2019 16:53:05 +0000
Message-ID: <vbfmudou5qp.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
 <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
 <vbfpniku7pr.fsf@mellanox.com>
 <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
In-Reply-To: <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0393.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::21) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ddad91e6-fcd5-4820-50fb-08d7596bce92
x-ms-traffictypediagnostic: VI1PR05MB3278:|VI1PR05MB3278:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB327876492AFD7F730356D723AD650@VI1PR05MB3278.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(199004)(189003)(386003)(102836004)(53546011)(3846002)(256004)(14444005)(14454004)(52116002)(76176011)(6116002)(99286004)(6916009)(2906002)(6506007)(71200400001)(71190400001)(6436002)(6486002)(6246003)(6512007)(4001150100001)(86362001)(7736002)(66066001)(305945005)(81166006)(81156014)(8676002)(316002)(8936002)(5660300002)(36756003)(478600001)(486006)(26005)(186003)(2616005)(476003)(11346002)(64756008)(446003)(66476007)(66556008)(66446008)(4326008)(229853002)(25786009)(54906003)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3278;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jg3aeYXmDTp4xv4X5rqI89yk49kWoOLNOmAc3lhphDgBzrJblhetKziH8GUC7wyMGWxAnMmowYMxtvu9LYuU2eCIxEdNPdNI5J1VUm5MYFk98sBaurgaQBE7eqJbpIaAPtgLBmMmVCePGzt7sW/3bTAOQbTIjmeX65KSJIXctGPUFCKkJvOJ9Bi0ZotLLLTWwkt4d2jm+xDp2sK2/H+UtD+bxKxDKxEWAynER5NFmjS4v7IgUCfOecxscDaxeoJexLS3/exE8FSy4lnm3sNy+I1ceHBqj5B3KYyoNLrDnXhCfhYo2CfDycs8Vi+lO8sOexho87g0AvSvvV2ja8SnyWhcK0V6u/TrArzLwsXALOartTd2zEm5gjVkbQMNI93T/kYzKAPRrUD+yhkVIB7wgKRc0EzkH73060O5jOWqfMSAW12jC92itLCu92MGOu2D
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddad91e6-fcd5-4820-50fb-08d7596bce92
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 16:53:06.0121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e+pSmu5tjn957kFm0782jkrHGhpkXOQI+9jKDPfQbylJBi3B/GQb7swMAd36qRASunGqHnp9mk2VKcD/t+H3KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3278
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 25 Oct 2019 at 19:29, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-25 12:10 p.m., Vlad Buslov wrote:
>>
>
>>> Hold on. Looking more at the code, direct call for tcf_action_init_1()
>>> from the cls code path is for backward compat of old policer approach.
>>> I think even modern iproute2 doesnt support that kind of call
>>> anymore. So you can pass NULL there for the *flags.
>>
>> But having the FAST_INIT flag set when creating actions through cls API
>> is my main use case. Are you suggesting to only have flags when actions
>> created through act API?
>>
>
> Not at all. Here's my thinking...
>
> I didnt see your iproute2 change; however, in user space - i think all
> the classifiers eventually call parse_action()? You can stick the flags
> there under TCA_ACT_ROOT_FLAGS
>
> In the kernel, tcf_exts_validate() - two spots:
> tcf_action_init_1() pass NULL
> tcf_action_init() before invocation extract the TCA_ACT_ROOT_FLAGS
> (similar to the act_api approach).
>
> Am i missing something? Sorry - dont have much cycles right now
> but i could do a prototype later.
>
> cheers,
> jamal

I don't exactly follow. In case of act API we have following call chain:
tc_ctl_action()->tcf_action_add()->tcf_action_init(). In this case
TCA_ROOT is parsed in tc_ctl_action() and tcf_action_init() is called
with one of its nested attributes - tca[TCA_ACT_TAB]. When
tcf_action_init() is called TCA_ROOT is already "parsed out", but it is
easy to pass it as an argument.

For cls API lets take flower as an example: fl_change() parses TCA_FLOWER, =
and calls
fl_set_parms()->tcf_exts_validate()->tcf_action_init() with
TCA_FLOWER_ACT nested attribute. No TCA_ROOT is expected, TCA_FLOWER_ACT
contains up to TCA_ACT_MAX_PRIO nested TCA_ACT attributes. So where can
I include it without breaking backward compatibility?

Regards,
Vlad
