Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4F05FC34E
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 11:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiJLJxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 05:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJLJxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 05:53:41 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60054.outbound.protection.outlook.com [40.107.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42275A9243
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 02:53:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcbnedD6t2s6tU6et2Nswzn8wVWPQWPWIlPKEqOU8jVNhsYmgDwiIvgNA+dPEGsit5tdEmtFu77lL9yxhEFfbgLKoAg15Mgzhfh07rCoTlCzcOGO7F1PH4oB2lU6baipAa1hZETAoz0qxj/XzYENMqWU6I+5+mGCE1/7go5uFlX4180d3RUdMyCrF2xogrY9YhzcwJaWrxmONxijNZbm9QM460nfrvgOmQz9c+IlBnsbFIs2OCeSF/g+xXbjnNuf/ZIhz1bBNawpNzdZFVOXJi0GNlVfTQkh0/6TN9W+Xx3Wk4kxMQFKiOFw4vi1rcvAbIQmIqxcPz3YMmKzBNazVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Y5Ug6Ga47jwWwhGj+Qs8v3VP+NW9GGNRKW0YnpNYCM=;
 b=V8ofAq9hc24nrYWuU/6duOem5i77JTbaPWCveMlMcZ4idOGjmRHcNEyF5UZfjP3qUDKfkFfMCP52L3Qu3ZROhlECC3gxtifdDZvDQiJNzpXU44FAih8+jzSo8cZMFlq3BdQK4+WbbJb+D/Urkmpx/aymbjWIJWAW5XQSVwrxPtIsxZO9Fc+7uGiGt9NctBfkxlDdJKSTziNT4WMoosXoJS1dIciUUnT9g5O452lQPjq2YuSYpeklIs/uR/KuxgRjDRtHAVqheu/0YBCWbYNzEiHf5jYac6v8VRurm2VxlTUQpTsTd0SE8uZ1rz1qzK4V/AAPFqz4VtqVPj75BYxVpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Y5Ug6Ga47jwWwhGj+Qs8v3VP+NW9GGNRKW0YnpNYCM=;
 b=G/Ytzc/jr/zldM37X2McBptzzRxTtI92pQ1IvXsFa/S16/3E7/35RHtI5y6awavb1xLZ3uHXwwxSC+09XsEBgSvfKRkTAf69zPyGwhiBL/DxeCCayqLALXMJG0XtAtdcfvMzTL/AQ117/HW1jZf12ztum3GlO5EuEa2ZszyHnfw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9363.eurprd04.prod.outlook.com (2603:10a6:20b:4e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 09:53:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Wed, 12 Oct 2022
 09:53:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v2 iproute2-next 2/2] taprio: support dumping and setting
 per-tc max SDU
Thread-Topic: [PATCH v2 iproute2-next 2/2] taprio: support dumping and setting
 per-tc max SDU
Thread-Index: AQHY1+jv9r9fY8c66kKWTiCKKX3uU64GhbuAgAQLcQA=
Date:   Wed, 12 Oct 2022 09:53:37 +0000
Message-ID: <20221012095336.6km44bk3e2wi5cy6@skbuf>
References: <20221004120028.679586-1-vladimir.oltean@nxp.com>
 <20221004120028.679586-2-vladimir.oltean@nxp.com>
 <0c35a3cc-a790-d8fb-a1a2-aeadf35fb9cf@kernel.org>
In-Reply-To: <0c35a3cc-a790-d8fb-a1a2-aeadf35fb9cf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9363:EE_
x-ms-office365-filtering-correlation-id: 076a796c-c45d-469d-ab62-08daac37a2c0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x15W483/Tud1Y8mq/bjiq8eqI4R+sEVKMpRguI4sJuQK5jMOuXKd6Ac0XZFzO1XxvVsoKd8+LgqjNVW5eyjOVAGkebHSVNgygHQd5cXmRB9eTTaJ9I3IXHPVvKSLZ8TIMSX0ClJ4NYytg7E3xAEjvMIDjPDYWbgkKg2Mrzo/8IUiNyPtGcFSdO3p4z/Y9CdUBCdi4h1AElmdKpagccdNlRz7tWl1jOUeaxa8XUrX8wocRj+hyXbWq3nIGBqTkAUb/2025cn4LvNZnEr0D8hWb+o1JLeS5RJhJ1XgHFSgit4k/kIyteO9e78KVqfFfVfIQbBLlsKHoUQ8FqGCvWpYUxK956lH7GFX3XrniMQwBqiw/ir2m4YGbZ9LQpYodg9lyFKqy66v/3wv7kLoSuhG8092soUk+qB6I+X0yzM18sBFuJ6dKesyEWz7k1UPVMJ+x1NsY6s4p2dx09zYaT4yV2Dke0Zl9Ot8LPSOwJ2SWuiTMA0sMSvAHX58O9G9jXdqhbNznh0OtUkjP6LfEAdQiaofUv5Cv+g9zk8hIn5QgBtblUOgku6hLtAzVjhUqikZ3bVOtOfGBF2y/Ofbec4wYk3WRmmEVoJA6Hh0+oUEjqHtvyQpKPkXGIpy4RNSD7nSLbK8LSgpMfX7ISlnPl69Zjq3kctWeo88ryevXCPIJ5ubUh45CdWdPeWqCOfJ4HXkzR5phDnuygoJ5WLsYo7s2VLY905YoEiM9JVetZ9+SiemPc9r7A16PFXCs4hzNO++9g1EjB429hEq84jBbq1LIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(478600001)(38100700002)(2906002)(8936002)(44832011)(41300700001)(5660300002)(8676002)(64756008)(66476007)(76116006)(91956017)(66556008)(4326008)(33716001)(66446008)(66946007)(6916009)(54906003)(9686003)(6512007)(122000001)(83380400001)(71200400001)(26005)(186003)(1076003)(86362001)(316002)(38070700005)(6486002)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ych/sGEE44kDW0av6C0BOxfq8B7dxDT2G/c95J7BQkKIMphsu6dViOXtunWj?=
 =?us-ascii?Q?vw+IwR4J++EkG7rW9Hh95+LpzcL8ewxdho6qpAycuzrocuHIV2DznFLziU8i?=
 =?us-ascii?Q?Qy4tm24CoP5U1KsjG8k2AgbT+cP129L4pXqU+4s+M5SEb5aoY1nQE2zymq2h?=
 =?us-ascii?Q?dwBaIEQGyMmq1dPsXp1AMwuP9x5oDw3VJMmBqMGtil0yLnNud5Wkzwk3Yh57?=
 =?us-ascii?Q?iBTFVdYCtBf79voQS07jy7p6h4t9B5OUvnlu0byPRWxx9E6T4ttttDm0w2Nw?=
 =?us-ascii?Q?0l2mP6fvdQmdwsDi0zYBxx2HQQrTdQTUVjnU+ziHZMbZOSMk0NQxsLrF9i5l?=
 =?us-ascii?Q?sNuIAT8+ij2SFhZ2oqdfbVW5LsYSoZDSppiwgUCqmKKQrEJbgDnL7Z1mFEze?=
 =?us-ascii?Q?kXAnrF4sE8En1UJjpbsRRwnhknrE6fLoocwt0+tlJLnn74nwp9u4cJ1kDUvz?=
 =?us-ascii?Q?h1ICHztfZVwfIDJ5ziYqAL4tdrHeQu0jpI1PJQb8uMRmF+mPuDMLY5q1JrIU?=
 =?us-ascii?Q?dt79PtZd6cY55UUqVCH3BPcMIqrUwzkdXR+hkRcHcAR4lg3ileIh9Pi0rsU8?=
 =?us-ascii?Q?XgPnktGFpNTViQfp2zCYIqUz3efKLbi427+eClKECsry0HRluPk5F82QJUY8?=
 =?us-ascii?Q?kBhPNlSlbixDdnmlCBDBD1Xn3llMvOWwxtGRR65/tPRd6jE7OQOVcE+hW5AF?=
 =?us-ascii?Q?Ej0PXRc0F14bWrR0zhz43x0feVKrj2TtVJ1KLjiBRH5ckrdC05ruGHcbIRw7?=
 =?us-ascii?Q?jgiFnnTmfSS8+O9/riWbc4zIkZnGePq7YmugGJIX+IE95KakU+sCGFILJCE3?=
 =?us-ascii?Q?M6iSUVdOVXKezp46WmaokpcXjB+/F0uA7Ll3vL78R3/8JkBysJylYMy/v3sD?=
 =?us-ascii?Q?u3u/UUHM3XUH4utb4SwC6koE4sGNwNQpKSKDepXnv50yCJxWPMzZGvXN6BKa?=
 =?us-ascii?Q?B79HIxdPZnrsB97iWGkyIWpW3aWY84xMruq0dbpWWNEupOfFNUCc6HWe5dz4?=
 =?us-ascii?Q?14Es4mwkuyQvNu7rto21uhQX+aSksV0Fo8aIj6A4Ytw3RP4sfUUoZeQkeHVU?=
 =?us-ascii?Q?9aAMOq3TajQs3U/TQ3IaiCfsQWPLMsvU0nPxYPpGnMS78AlQoA/B/O2n7hZh?=
 =?us-ascii?Q?wMhL1cciPsFic6//Iajv10lmhAO2gHoQ4l2yOCZlTnoCBM/6mQUUPnWnyluH?=
 =?us-ascii?Q?iU8KZrE6jsAwATcpJFD2FFbSMBbS1ZxTc0a3OvTX3l3C4VUmbfa7uuyLAng7?=
 =?us-ascii?Q?qw9qQbesSddFhjvtItxOEA8vzDFulqGBmZTa+7IDMZnzmqKwLOzSInIRB6mO?=
 =?us-ascii?Q?YCSPL36Cg63M4Dhl63xKA+i5p59UH5whTtznn/rb6VLwissHAUU8Ccojwqdq?=
 =?us-ascii?Q?w4bFHYazjJ+Gbe1ySPllAzW0mWyz/HL1RSEZF2S7poCnJ31jgcg3BFSofIzj?=
 =?us-ascii?Q?RJrxtGk2V+M5LZyuVZP7C2lL7o6JZPNWKcEAN9jiqcFfV6foj7NKrrlFxvvV?=
 =?us-ascii?Q?TNHpnrPqoEli3of7T5/7AFribIFdilwTxf+oVcNTDVFX/8aomNe/CEsOzwd5?=
 =?us-ascii?Q?zOl5Ofw3DTi3v7/n0JjULpG45qyR/WwBTP6md6zV62uitFoA6PBNT4eM9L9Y?=
 =?us-ascii?Q?ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6FA888D6EE491A44B8BA4CD214DDECB5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076a796c-c45d-469d-ab62-08daac37a2c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 09:53:37.9436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +kEqFFHh60EgCgThkArTH5DXCQzlOwBa3Uvo1fp9jcXehnItu9H9HnfqpjOcUrkJVEGxDqUDHZSCgqMvGr6R6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9363
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 02:07:37PM -0600, David Ahern wrote:
> On 10/4/22 6:00 AM, Vladimir Oltean wrote:
> > diff --git a/tc/q_taprio.c b/tc/q_taprio.c
> > index e3af3f3fa047..45f82be1f50a 100644
> > --- a/tc/q_taprio.c
> > +++ b/tc/q_taprio.c
> > @@ -151,13 +151,32 @@ static struct sched_entry *create_entry(uint32_t =
gatemask, uint32_t interval, ui
> >  	return e;
> >  }
> > =20
> > +static void add_tc_entries(struct nlmsghdr *n,
> > +			   __u32 max_sdu[TC_QOPT_MAX_QUEUE])
> > +{
> > +	struct rtattr *l;
> > +	__u32 tc;
> > +
> > +	for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
> > +		l =3D addattr_nest(n, 1024, TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED)=
;
> > +
> > +		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_INDEX, &tc, sizeof(tc));
> > +		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
> > +			  &max_sdu[tc], sizeof(max_sdu[tc]));
> > +
> > +		addattr_nest_end(n, l);
>=20
> Why the full TC_QOPT_MAX_QUEUE? the parse_opt knows the index of the
> last entry used.

It doesn't make a difference if I send netlink attributes with zeroes or no=
t.
I was thinking the code is more future-proof for other per-tc attributes.
If I then add support for other per-tc stuff, I'll have num_max_sdu_entries=
,
num_other_stuff_entries, etc, and I'll have to iterate up to the max()
of those (or just up to TC_QOPT_MAX_QUEUE), and add the nla only if i <=3D
the num_*_entries of the corresponding attribute.

Anyway I don't have plans for other per-tc entries so I'll make this change=
.

> > +	}
> > +}
> > +
> >  static int taprio_parse_opt(struct qdisc_util *qu, int argc,
> >  			    char **argv, struct nlmsghdr *n, const char *dev)
> >  {
> > +	__u32 max_sdu[TC_QOPT_MAX_QUEUE] =3D { };
> >  	__s32 clockid =3D CLOCKID_INVALID;
> >  	struct tc_mqprio_qopt opt =3D { };
> >  	__s64 cycle_time_extension =3D 0;
> >  	struct list_head sched_entries;
> > +	bool have_tc_entries =3D false;
> >  	struct rtattr *tail, *l;
> >  	__u32 taprio_flags =3D 0;
> >  	__u32 txtime_delay =3D 0;
> > @@ -211,6 +230,18 @@ static int taprio_parse_opt(struct qdisc_util *qu,=
 int argc,
> >  				free(tmp);
> >  				idx++;
> >  			}
> > +		} else if (strcmp(*argv, "max-sdu") =3D=3D 0) {
> > +			while (idx < TC_QOPT_MAX_QUEUE && NEXT_ARG_OK()) {
> > +				NEXT_ARG();
> > +				if (get_u32(&max_sdu[idx], *argv, 10)) {
> > +					PREV_ARG();
> > +					break;
> > +				}
> > +				idx++;
> > +			}
> > +			for ( ; idx < TC_QOPT_MAX_QUEUE; idx++)
> > +				max_sdu[idx] =3D 0;
>=20
> max_sdu is initialized to 0 and you have "have_tc_entries" to detect
> multiple options on the command line.

Can remove.

> > +			have_tc_entries =3D true;
> >  		} else if (strcmp(*argv, "sched-entry") =3D=3D 0) {
> >  			uint32_t mask, interval;
> >  			struct sched_entry *e;
> > @@ -341,6 +372,9 @@ static int taprio_parse_opt(struct qdisc_util *qu, =
int argc,
> >  		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION,
> >  			  &cycle_time_extension, sizeof(cycle_time_extension));
> > =20
> > +	if (have_tc_entries)
> > +		add_tc_entries(n, max_sdu);
> > +
> >  	l =3D addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_=
NESTED);
> > =20
> >  	err =3D add_sched_list(&sched_entries, n);
> > @@ -430,6 +464,59 @@ static int print_schedule(FILE *f, struct rtattr *=
*tb)
> >  	return 0;
> >  }
> > =20
> > +static void dump_tc_entry(__u32 max_sdu[TC_QOPT_MAX_QUEUE],
> > +			  struct rtattr *item, bool *have_tc_entries)
> > +{
> > +	struct rtattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1];
> > +	__u32 tc, val =3D 0;
> > +
> > +	parse_rtattr_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, item);
> > +
> > +	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
> > +		fprintf(stderr, "Missing tc entry index\n");
> > +		return;
> > +	}
> > +
> > +	tc =3D rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
> > +
> > +	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
> > +		val =3D rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
> > +
> > +	max_sdu[tc] =3D val;

The array dereference here can potentially go out of bounds with future
kernels which might provide a TCA_TAPRIO_TC_ENTRY_INDEX past TC_QOPT_MAX_QU=
EUE.
I will add a check for this, and ignore it (or error out ?!).

> > +
> > +	*have_tc_entries =3D true;
> > +}
> > +
> > +static void dump_tc_entries(FILE *f, struct rtattr *opt)
> > +{
> > +	__u32 max_sdu[TC_QOPT_MAX_QUEUE] =3D {};
> > +	bool have_tc_entries =3D false;
> > +	struct rtattr *i;
> > +	int tc, rem;
> > +
> > +	for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++)
> > +		max_sdu[tc] =3D 0;
>=20
> max_sdu is initialized to 0 above when it is declared.

True.

> > +
> > +	rem =3D RTA_PAYLOAD(opt);
> > +
> > +	for (i =3D RTA_DATA(opt); RTA_OK(i, rem); i =3D RTA_NEXT(i, rem)) {
> > +		if (i->rta_type !=3D (TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED))
> > +			continue;
> > +
> > +		dump_tc_entry(max_sdu, i, &have_tc_entries);
> > +	}
> > +
> > +	if (!have_tc_entries)
> > +		return;
> > +
> > +	open_json_array(PRINT_ANY, "max-sdu");
> > +	for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++)
>=20
> you can know the max index so why not use it here?

Can do. The kernel will always report TC_QOPT_MAX_QUEUE entries anyway,
so it doesn't really have a practical effect right now.

I'd like to avoid using an array as temporary storage in the first
place (see the comment about kernel potentially causing out-of-bounds
access), but I only want to call open_json_array() if there is at least
one actual per-tc entry present. I'll think about this some more.=
