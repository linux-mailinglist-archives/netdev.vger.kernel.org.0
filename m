Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4EB5B904D
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 23:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiINVyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 17:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiINVyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 17:54:03 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130077.outbound.protection.outlook.com [40.107.13.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9E017040;
        Wed, 14 Sep 2022 14:54:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XlddqmN7ssdXDjbSEKJrBf6vauaeGURBCOop1S0O9kaSLoUU4bp3zbudXcdrQsj5BjcsigHnBX2awQSTOVvoX8stZJaThTspux1fe7Ir4KIG2VP2vSJHWs5Dxe1+/JtWWxuxzIu82frWMVHTNrowH9P13U1ZFsh1X7/ZMXR1WZ/8qlXnM1E4phqpaHZ9XNuTvGFD4eNq2AEW4P1RyHnHP5dFYjAtAivRX7SnlbLibtr+9BYPo4YWxCUjon+2MN1X9HeCsqpSVVo20RMCzgQAQIn3HkZ6txYg2Diu5AO7VQ2q2J+VxFEqWoU8cdlXc8gMtbJvqUajAQO/NyU0q0nNSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rra5Ut8wDRhXUqxAWDnsfZNecSsCWiRWw6pVcN3sKlk=;
 b=WovfGqN+GRAR15OJOTdEj0WmKhrxqyS4Pxr43VEFfVuo6PGoICMDwUt1lD/Z2OTT80dDLwebRb+mnyj+i/Mx+DwJN7TwNpvrf9My1Ob/T2Dd9Uc7f+LMLONqhZykQhWtFgSpIpWEBcfMzPhfOj9wYd04nVyEhIuAMGn4v98T+rMfjg7lkEgRa/prpGFX90lHMbW6xITKj7flHFbgeZDikQJTm3PtN/4wgma1EWpAPLBAUmIIcolJ+iXjBYiJFo0BFy/TV5IauHd015LWAcrTQh68z5BxRSJ9aaLvSy/aToOp9UOxZ/b1JSqo+o+vuyHk6r4yzj83wZx5WwTCVsz/bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rra5Ut8wDRhXUqxAWDnsfZNecSsCWiRWw6pVcN3sKlk=;
 b=i1vR44jMTuNojZYlBfBD027WMrkz8sMSCqQB3JabBFHui8yLNkMcTuMzDOTwU+WiqlIVDhK6/CFsuqY+uYd//4VToLFntydzTVzdy/lvPxFEKIA+5xgD1fA1B6vGUZe9IngjLZsIlvf4ezpjmN2EHTHvORq2eqetyDFk5s0t/5M=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6828.eurprd04.prod.outlook.com (2603:10a6:10:113::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 21:53:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 21:53:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 3/3] net/sched: taprio: dereference oper and admin
 sched under RCU in taprio_destroy
Thread-Topic: [PATCH net 3/3] net/sched: taprio: dereference oper and admin
 sched under RCU in taprio_destroy
Thread-Index: AQHYyEcskjCPZ7fjpUGbRQIOqb0/Za3feGyA
Date:   Wed, 14 Sep 2022 21:53:58 +0000
Message-ID: <20220914215357.i7kvrnuczrltdsoj@skbuf>
References: <20220914143439.1544363-1-vladimir.oltean@nxp.com>
 <20220914143439.1544363-4-vladimir.oltean@nxp.com>
In-Reply-To: <20220914143439.1544363-4-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB8PR04MB6828:EE_
x-ms-office365-filtering-correlation-id: 0c281ac8-d79f-4837-a74c-08da969ba09f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vyyEpVzLfbPMlPYcGqAKuOMVpERRa9PF+MocYyBtKc1GCVG4RZrrEoJXjs0xrlaVOxEj2SZfqXQvS6/OVBZa5gsf6Cqi/j2FzXBE2lb8G8KfV6P81ZxviXn3HADVFY0UaNm8KCMsU5K1fIMEfEkMWgJDtaRRsX89U9FIne97jG1uVbja5GGH+b1NaCjmkT3DBpxT4MpulH7nYdfvo1jWobJCZYa6Hru8rt9XpSaTYE8RZWINPcG49mGiNekOK8LleTYw6o1vpS6XglfNlzCq1wCue3Z/wzOJLVbA4c1qyXfyEf5en9izQQLNTq4JtVll22E2oxPIaJ4D/SyiBNsAQUDZeTSUhbvVQWDXuEPimX+ihWbAaHdco3X+ArroPM3/Q/88eAW/GiVjI0DKTvIuV4+eIzalGkQ1Hp8QUZsjLIiNnTCnCr36IIjmX2+Z8EkgUn6Wai495/1I42Nebm+Tk380rnEONUhrxWu8KV1P/moJPOwmTJBLwYqMzIJDXU5WwVxgkg2J/m0fsXRUSEXswXsQsOs1cKPmvY9EmCMvRzLtSWE9fOnOAcCjd/nbgd+kgJaSn2fqcqDFYpsF0lgznrCVW90meoZlVLPQtuKEas2uGHDSKVQ6Stc9c/c78pL7pp52dqNq9J2ubfsEwmp10HQ0a6rIgc4KpQO+V8HuMkyL6/+xbR8HV9Bi+nCkn4TFKOvszYFRypfbQ5JKwTSERG+qD5QfoBgG/CPEs6rxGHYUe0/1hi0v7n+8u2FlvlZe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(41300700001)(71200400001)(478600001)(1076003)(186003)(6486002)(83380400001)(6512007)(26005)(9686003)(6506007)(4744005)(7416002)(2906002)(44832011)(33716001)(5660300002)(91956017)(8676002)(4326008)(76116006)(316002)(6916009)(54906003)(8936002)(66476007)(66446008)(64756008)(66556008)(66946007)(122000001)(38100700002)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?swG+gx5g8e345GpA+CgyK9b3RywrwRl8kSMD+7r2cwr+EfwUUnB5gmUyxFGq?=
 =?us-ascii?Q?lF+asVvrNSFUsJx+/JdcHYtpsQtWAydPwpkpaTV5HQflYz+072Rla1HrJfrQ?=
 =?us-ascii?Q?FlfiPPY/kWsyZBm5Ed9xrDH48EEE5oW3i2kVIZHvNB8m54zlJWAUwFu5um/7?=
 =?us-ascii?Q?kV9S+CBanprqSKhQ4RcnvK3BN1AwNNDv3b0414+sK801qoyFXpBb2+KR8b79?=
 =?us-ascii?Q?vg4CdJKhX/eikLwIA2qojokGyhiforbg3TmTV7zVcypBuw1xj83yQLhMaBTG?=
 =?us-ascii?Q?Z0hkzCaoWYslrY46GVBc+xKXZyWVOGBuGA43AcDoIaasVTQSvoK6wjjJ7xUe?=
 =?us-ascii?Q?j5PjEfYznKIBiePHjouQPgyq25NJ7MAWFTJ84+BeLuw5zL5xVFNctkcU/WIw?=
 =?us-ascii?Q?P61TEG8PZdrvxE0iC6hfJ11C6+JvYoG2DW/CTPUBw6UaO4GTTiyR4dUYiFIH?=
 =?us-ascii?Q?Qr1cmFQnYwC4cAoEf2gWW6IYxRvg3fJKlP6QBNqDggco2sL+gvm3sSN30htx?=
 =?us-ascii?Q?zy3wRH+f/iYBgRb9qsN0uGKT2JaP6WlwQvFTnlDtYYekW1AaYkGGYz4vejwC?=
 =?us-ascii?Q?CMBa2+BJXoruoKJe05s0JcQqi17EYyUA1GF3LlaEKgcpaabmx5dsxr/TpY0l?=
 =?us-ascii?Q?D2H72FgVOrzGaMHselM7d6wLzaj2xBjxqGad70ay43wO997oyw52DiADMH+v?=
 =?us-ascii?Q?GruyT2tC1tyMAFxBOy42TL0vJ0EWWWPm1KK2/WutOWQr38IYYSP5VCiesVJI?=
 =?us-ascii?Q?BzI+5+o/GtZVjMOJ2qYZ51qRno+Q1Er6eu3iozvzCSGIyvLZWoOlsmUYMIm9?=
 =?us-ascii?Q?I+yGNo4ceNRVyShrdmUF52lwlCGYEzRePd6bEIZLps7QFJYcaUy3sW04IQIw?=
 =?us-ascii?Q?42CNlFKForUViWj87yiLlvObJJdEcP0WJ31MzMQinuMTe5/z7jrAmahGWD4L?=
 =?us-ascii?Q?U717iVG8C2w+ymYVai0n+bTK33LuoQ7qPf+tlcxYgSczYbVbKpPGm4FNT5Ci?=
 =?us-ascii?Q?wi91xtYXAf2DyebdDzqI75g1wE/wZqpv+RF2JLsbcmx08jREwa1uoUP4+B7z?=
 =?us-ascii?Q?nq1quE7zr8S4edI1FbRKlOA1a9S0gfvwLCPzUZzKigHiHjKWmkDhJy08Ij2B?=
 =?us-ascii?Q?lHuh8nT+wUMhtYH+lgJOXaelq9mXxXH3EiSl3mPmFiT6kG5/X10iRkUAVg2L?=
 =?us-ascii?Q?g2RyxFT545hXJi2Nq78hoRiz4p1U0YjUdMEwe1sJ+ug01hqRY1RD+VyluU6y?=
 =?us-ascii?Q?HnywktgmuiAB+I68/1i2m1ri8ZpPcUCy6xyQFwyZehs/fQee+rjwrmwp0t0b?=
 =?us-ascii?Q?kduhZ9zxABl0COZajmZ8z6R6jYnpKc8PG2TFI5k7o329C83FKWGee6GfBv1h?=
 =?us-ascii?Q?EH+LCJLyJXCv9XEDxqkj7FTk0jZPwXEGzD7jEUwG2el9cwmVLVwD9wufEhQD?=
 =?us-ascii?Q?rpk/NHHQLtLxLnKdyDC0b7hAP5LZ+pzC8ZyiDKQx7rULhUxRXRhHMWQ2lI8M?=
 =?us-ascii?Q?SH3yi60Z246cpY6VZFsOqEDqWQaMdZS6WQlUu9K3v7KWFALIQbvbSv5EH9lt?=
 =?us-ascii?Q?AxQNNTx/72h8x0lCSKNKuDNAdZp51AiuXYkslDVPlXfRLAQ7oUN5WRbfr4+2?=
 =?us-ascii?Q?aA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E41D934CAF1614EBB5A5D87CB8724DF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c281ac8-d79f-4837-a74c-08da969ba09f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 21:53:58.4948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Bs9QM2g8O6IpZMP4xyscGJ50Ousqhuh9qI8iRU/YCC8QU9Ox511tbLZ1nEPuj6qjZeY4TdLpzPG68LkzTZBfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6828
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 05:34:39PM +0300, Vladimir Oltean wrote:
> -	if (q->oper_sched)
> -		call_rcu(&q->oper_sched->rcu, taprio_free_sched_cb);
> +	rcu_read_lock();
> +
> +	oper =3D rcu_dereference(q->oper_sched);
> +	admin =3D rcu_dereference(q->admin_sched);
> +
> +	if (oper)
> +		call_rcu(&oper->rcu, taprio_free_sched_cb);
> =20
> -	if (q->admin_sched)
> -		call_rcu(&q->admin_sched->rcu, taprio_free_sched_cb);
> +	if (admin)
> +		call_rcu(&admin->rcu, taprio_free_sched_cb);
> +
> +	rcu_read_unlock();
>  }

I decided to code up this patch at the last minute, since the sparse
warning was bugging me. But after more testing (including with lockdep,
which says absolutely nothing), I notice some RCU stalls after this
patch. It looks like call_rcu() really doesn't like to be called under
rcu_read_lock(). Please discard this patch set from patchwork, I'll
resend when things will work properly.=
