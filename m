Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DF8EFAB8
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 11:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388299AbfKEKRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 05:17:35 -0500
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:9803
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388124AbfKEKRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 05:17:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKPnlwQghKwifFJK9nNzxBbYPXkbH3K8Khrhe/VY2vIOGtNW8VCHCJpWtMrBIc/sgn9orUkQA3lXkucczlKOxePXeUUgdISL33k+aGiYEd6/gnEkFohvFrcSRubG/6aWbBjY25FwkK4waildekdAqtIoVO+BSJJdA/iHLPFAm4A0atyY+cqPfgtBAjP3PvuVEnhiMbSmpdWFEr1ngmld/yESz++rynPSU0SXSFyPCXaKH+Kgq+n/bQvnIauH9DtYurYOUgMgeZH7xZ/+IaFEY2v9ucW2FwWttHjyXpsHp63dFBuGcDy3yZQ7RU71d1S0pb9vjaIezmj0TqI16PNwKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CL6RtK86RJ8t2SW/HAJppVCGWmiNAzitta8Y45yq10=;
 b=Mxlr8Ob0458HXrh0E1AoMfJsh53zgZWyYM84ung6Z5vyHRrgLzMsn4Agp43zHmD9KPoMT5nOG8b/YuYHVv3u4Jsu+Isp6T/LAGwdzu3lNwPdIQoNhxYZWnTRZ32VoQf8+JtdCwf9h0J9Y6xYLpVzCNXnnifqDrCvvNrjX2RKXGGe9JsQR/VT5bf2nc6Dyh+O2gMMsumeeGlOpcBpcZI0NtkUI13d2bopLV8RDKB9TzH8Ck9iAp0/JngFuhFoBAslLjhw6rSVtFApeVrCmYy++a20KvNv6sc8Zi5JBJi6BbcTb2MBdmkrxZJOj15tk4/UGV3CBcv1pSz2tyWEGFkvCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CL6RtK86RJ8t2SW/HAJppVCGWmiNAzitta8Y45yq10=;
 b=lVX+datN/fYuZ4s+z8sBBcPgn3pMtHCVLh1s7maelfHx8t/7tBBaNZNVjllqdNGb1fPVr8ZCiXIEz258LMlwWsK4TjmK3d10in0agJjM42HewVzwM2qOkeKBWBc9/xWGlXa0p4sdEes8LiumTcpiQHJ8okitAFRyASbZMhfLDoA=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6077.eurprd05.prod.outlook.com (20.178.126.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 10:17:30 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3580:5d45:7d19:99f5]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3580:5d45:7d19:99f5%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 10:17:30 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2 net-next v2] tc: implement support for action
 flags
Thread-Topic: [PATCH iproute2 net-next v2] tc: implement support for action
 flags
Thread-Index: AQHVjy1BeXUyBu84t0S1Y0G5hW0U2ad7QVWAgAEkwQA=
Date:   Tue, 5 Nov 2019 10:17:30 +0000
Message-ID: <vbf36f2y6dl.fsf@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
 <20191030142040.19404-1-vladbu@mellanox.com>
 <CAJieiUiemsOJ6YkerOCA5XwduRLDEKZeHgXNpy0K3S9fXcm=tQ@mail.gmail.com>
In-Reply-To: <CAJieiUiemsOJ6YkerOCA5XwduRLDEKZeHgXNpy0K3S9fXcm=tQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0220.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::16) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 28409b74-20ee-476b-1700-08d761d95d65
x-ms-traffictypediagnostic: VI1PR05MB6077:|VI1PR05MB6077:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6077809BAF1360827BA75AF3AD7E0@VI1PR05MB6077.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:586;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(199004)(189003)(66556008)(54906003)(25786009)(478600001)(66476007)(7736002)(86362001)(66446008)(64756008)(6486002)(14454004)(6506007)(386003)(53546011)(102836004)(26005)(81156014)(81166006)(8676002)(8936002)(76176011)(52116002)(486006)(6512007)(66066001)(2616005)(11346002)(476003)(186003)(36756003)(446003)(229853002)(316002)(107886003)(6436002)(305945005)(6916009)(99286004)(6246003)(6116002)(3846002)(14444005)(4326008)(5660300002)(2906002)(256004)(71190400001)(66946007)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6077;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bCHZc4+GBJBNw0jLceVyEzp+8aNEAp+oPgBtg0dB6ODL1PkIfOoVNLQU4p0ZLQWz53yQO1ot3sUkPQS4pzLs0uNCnU9stMVJKtFF3qyKxSBz9UCJTX2ohWMc4Ka4plFV3Amlp6/PwFYZxLyBkOtNe9qi6byJInbHeKRqmgGpZndlkb8/mqqz1WQGRMpFMniKHEV9RSjA9zRZngZsuDmBuU3XBYCixBg8yA66Pk/lU0lHIl08n+rP5QmYHVvsaWlbMyojx+Ey6YgR7oj1gumD82kfhB6wdqiL7vLVsjaqb34LMDBpLUauRDTjmoZaukmIUtcGmPTlDQjuG23LUBN4EY8xsjiOQadAxTRn7fGsraj1ZN+pxqcYIOD1E6ZsbJXQNoVYxWCmGwmoUChp/5cyl0eoFmMmc8SFHpZivxgC89NlIVBI9OVmdM6w3HCsBlWp
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28409b74-20ee-476b-1700-08d761d95d65
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 10:17:30.0747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ANflZXShn7RE1xxVHFl6mo9MKR0tSgDXxbIThitBGDu2DSjo4LOj6Mu+7iU7VAg+FGOKT4Ft9aaouNMOSxTpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 04 Nov 2019 at 18:49, Roopa Prabhu <roopa@cumulusnetworks.com> wrote=
:
> On Wed, Oct 30, 2019 at 7:20 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>> Implement setting and printing of action flags with single available fla=
g
>> value "no_percpu" that translates to kernel UAPI TCA_ACT_FLAGS value
>> TCA_ACT_FLAGS_NO_PERCPU_STATS. Update man page with information regardin=
g
>> usage of action flags.
>>
>> Example usage:
>>
>>  # tc actions add action gact drop no_percpu
>>  # sudo tc actions list action gact
>>  total acts 1
>>
>>         action order 0: gact action drop
>>          random type none pass val 0
>>          index 1 ref 1 bind 0
>>         no_percpu
>
> would be nice to just call it no_percpu_stats to match the flag name ?.
> Current choice of word leaves room for possible conflict with other
> percpu flags in the future..

I didn't find any other places in action code that uses percpu allocator
directly and decided to name it "no_percpu" since it seems to me that
iproute2 developers prefer brevity when naming such things (notice "val"
and "ref" in example output).

>
>
>>
>> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>> ---
>>
>> Notes:
>>     Changes V1 -> V2:
>>
>>     - Rework the change to use action API TCA_ACT_FLAGS instead of
>>       per-action flags implementation.
>>
>>  include/uapi/linux/pkt_cls.h |  5 +++++
>>  man/man8/tc-actions.8        | 14 ++++++++++++++
>>  tc/m_action.c                | 19 +++++++++++++++++++
>>  3 files changed, 38 insertions(+)
>>
>> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
>> index a6aa466fac9e..c6ad22f76ede 100644
>> --- a/include/uapi/linux/pkt_cls.h
>> +++ b/include/uapi/linux/pkt_cls.h
>> @@ -16,9 +16,14 @@ enum {
>>         TCA_ACT_STATS,
>>         TCA_ACT_PAD,
>>         TCA_ACT_COOKIE,
>> +       TCA_ACT_FLAGS,
>>         __TCA_ACT_MAX
>>  };
>>
>> +#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator f=
or
>> +                                        * actions stats.
>> +                                        */
>> +
>>  #define TCA_ACT_MAX __TCA_ACT_MAX
>>  #define TCA_OLD_COMPAT (TCA_ACT_MAX+1)
>>  #define TCA_ACT_MAX_PRIO 32
>> diff --git a/man/man8/tc-actions.8 b/man/man8/tc-actions.8
>> index f46166e3f685..bee59f7247fa 100644
>> --- a/man/man8/tc-actions.8
>> +++ b/man/man8/tc-actions.8
>> @@ -47,6 +47,8 @@ actions \- independently defined actions in tc
>>  ] [
>>  .I COOKIESPEC
>>  ] [
>> +.I FLAGS
>> +] [
>>  .I CONTROL
>>  ]
>>
>> @@ -71,6 +73,10 @@ ACTNAME
>>  :=3D
>>  .BI cookie " COOKIE"
>>
>> +.I FLAGS
>> +:=3D
>> +.I no_percpu
>> +
>>  .I ACTDETAIL
>>  :=3D
>>  .I ACTNAME ACTPARAMS
>> @@ -186,6 +192,14 @@ As such, it can be used as a correlating value for =
maintaining user state.
>>  The value to be stored is completely arbitrary and does not require a s=
pecific
>>  format. It is stored inside the action structure itself.
>>
>> +.TP
>> +.I FLAGS
>> +Action-specific flags. Currently, the only supported flag is
>> +.I no_percpu
>> +which indicates that action is expected to have minimal software data-p=
ath
>> +traffic and doesn't need to allocate stat counters with percpu allocato=
r.
>> +This option is intended to be used by hardware-offloaded actions.
>> +
>>  .TP
>>  .BI since " MSTIME"
>>  When dumping large number of actions, a millisecond time-filter can be
>> diff --git a/tc/m_action.c b/tc/m_action.c
>> index 36c744bbe374..4da810c8c0aa 100644
>> --- a/tc/m_action.c
>> +++ b/tc/m_action.c
>> @@ -250,6 +250,16 @@ done0:
>>                                 addattr_l(n, MAX_MSG, TCA_ACT_COOKIE,
>>                                           &act_ck, act_ck_len);
>>
>> +                       if (*argv && strcmp(*argv, "no_percpu") =3D=3D 0=
) {
>> +                               struct nla_bitfield32 flags =3D
>> +                                       { TCA_ACT_FLAGS_NO_PERCPU_STATS,
>> +                                         TCA_ACT_FLAGS_NO_PERCPU_STATS =
};
>> +
>> +                               addattr_l(n, MAX_MSG, TCA_ACT_FLAGS, &fl=
ags,
>> +                                         sizeof(struct nla_bitfield32))=
;
>> +                               NEXT_ARG_FWD();
>> +                       }
>> +
>>                         addattr_nest_end(n, tail);
>>                         ok++;
>>                 }
>> @@ -318,6 +328,15 @@ static int tc_print_one_action(FILE *f, struct rtat=
tr *arg)
>>                                            strsz, b1, sizeof(b1)));
>>                 print_string(PRINT_FP, NULL, "%s", _SL_);
>>         }
>> +       if (tb[TCA_ACT_FLAGS]) {
>> +               struct nla_bitfield32 *flags =3D RTA_DATA(tb[TCA_ACT_FLA=
GS]);
>> +
>> +               if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS)
>> +                       print_bool(PRINT_ANY, "no_percpu", "\tno_percpu"=
,
>> +                                  flags->value &
>> +                                  TCA_ACT_FLAGS_NO_PERCPU_STATS);
>> +               print_string(PRINT_FP, NULL, "%s", _SL_);
>> +       }
>>
>>         return 0;
>>  }
>> --
>> 2.21.0
>>
