Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C3F6D4343
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjDCLSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjDCLSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:18:53 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2100.outbound.protection.outlook.com [40.107.22.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B1A30C5;
        Mon,  3 Apr 2023 04:18:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPEYUQ14HaMiYMcerRYFCUaiJ87XYVGH5z7mOd6lxj00zwyhQ+6mqykKS37FB/GoTsADlkEHvE7SrgYvfWAKZeEuwOXXsq+6rusH53AuZGkXYzpfw+YiKM3YVC4cnJE326hLeV57QGVuX9ns21P9U43EUhrr8wHDV+0YAFn4b1tx9eUZNxeUdY6domrXBXnWMuEK4zHfUPBi9wnowI33ChHbSJwFBg+CX4UG6dqehM1mSfsfEoko1CWjeAV/bTYFd+aOSONpKhxFrk6UDtfLJ3soADt084mIkoDGUWFyPJZ60e5EbLtCG9WiqVc9dFx2Cddin0nASTCT2cxTkOocGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IThYrWhJmvqdAEXpS4l2T4gZrm8yB+4sycNPqxPPicM=;
 b=c1IoH4CVZDDVDPjpekbaIsF0psrkPxibNdQKp7P9YnXwca54r4GDboSDDX3+UB37iQURd9ZcODF0i7oqs1DoGcJniGxCzngAMsbGHs6qc6Yk7ordsMB+BFtChuZNEGmvGBQUZLdUuucdpXQNWnKhAiOKWVmsSFAVTgPxoLzaEy8Gv8pFpjU8f0fK23hVDma8iJ+nwd+ys2tmYqollHmImS6Dt8ss7eec5zdUPh698J5V1KgYU6VPWwKnZ/x4mlv/oMVf3tio8zYZYfgjhU4Jk7XzK2qw0g2V2x8DRTnWFgCSb9vDWy+rB9idy8hImLkGzTy1rJydXlzF9wXzCk14aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mail.schwarz; dmarc=pass action=none header.from=mail.schwarz;
 dkim=pass header.d=mail.schwarz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mail.schwarz;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IThYrWhJmvqdAEXpS4l2T4gZrm8yB+4sycNPqxPPicM=;
 b=NoLAltzXRZo3yYOK5Or7GEWYJKJ5ayuHvphjkdGtqdGIJ59dkwwBJB1HpxRkwy19ydiiWa35ek8YdwERcKClqZ+8LYb/6JL8gRkIauz5fcHVwaxSLh0cFjCNtM7NvyvbMQZ70VrQio+43hfSFKO9yQ/W06/V2Sawya0WDE4nfSjrBdxzqZ8ibWXqdiMN64Bn3GgfTREGJOMZJE4x3kvm8owzqt28yQaVQCtz5lBpd+Cug0klEGhbUHr/2NxP4uR6DF+KKK9rJ3Ak0mjTkQaV8ES+37wyXoRmxp4esMRpqx/nfK1IrunX6pyolEAt77Kgv4v8/BvBud20FtjDJx4K4Q==
Received: from DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:34c::22)
 by VI1PR10MB3598.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:139::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.26; Mon, 3 Apr
 2023 11:18:47 +0000
Received: from DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ceef:d164:880a:be9c]) by DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ceef:d164:880a:be9c%4]) with mapi id 15.20.6277.026; Mon, 3 Apr 2023
 11:18:46 +0000
From:   =?iso-8859-1?Q?Felix_H=FCttner?= <felix.huettner@mail.schwarz>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luca Czesla <Luca.Czesla@mail.schwarz>
Subject: RE: [PATCH] net: openvswitch: fix race on port output
Thread-Topic: [PATCH] net: openvswitch: fix race on port output
Thread-Index: AdljmWv5YS2k+yAfSXWo9bXiCkDODgAuIhwAAHCFwEA=
Date:   Mon, 3 Apr 2023 11:18:46 +0000
Message-ID: <DU0PR10MB52446CAE57724A0B878BAA66EA929@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
References: <DU0PR10MB5244A38E7712028763169A93EA8F9@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
 <20230331212514.7a9ee3d9@kernel.org>
In-Reply-To: <20230331212514.7a9ee3d9@kernel.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mail.schwarz;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB5244:EE_|VI1PR10MB3598:EE_
x-ms-office365-filtering-correlation-id: 076166ae-da7a-4bdd-e94e-08db3435313e
x-mp-schwarz-dsgvo2: 1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RmpjQbCsWy8rbHjIzMJgFEEafKZCFv6TBmKNI4eRtuRSZbdH2ZiOoSSc5i6w5sKF97EQWhDKuoF8jk8tiDWxmk6IU+bf1ulA8md2L+Ub3wGS/5OcFhfzq5805at1Peq68KZhteoYSOXEc0qei9CMVT4KEhl4SAwyCU7/PVVOS3XJOKDzmf4Q7savYMzQTUCIBHBAI++KErVtatomGZxQZ2VMwT/b7UW04BXzQRSfrskZgImKKYY6qi7x2o96zzGCOo0XizAQqpqZBn1AQZRrkcQuid5fqH81nwFzGGh0IRaNS55ojscfBnqzTq7JCtnkMbl/GMHFGvft43oB+tOoK8acLRky6t4ZMXoTW3luMQrzV+DLk9hDVoQwEmgVTchV7gKu3lqRcCQ0ozEv+b92wN+YQwJE/wFdaK6ZzdZTNyoaCQmcveAPmyG+JtbSZwSLSarbCp+miAgEPg8Ce47EgMwXfFc1cEi9pc4cZjtSg0wv220uRPAfJdOUg5iW6UMvhaeO9bbkPYllKwCKzl0U0r7b5CwxgVvilCnvpqSoFj5VeP2bRgx0v1NBhL6akJxacV78a+3X/pmQ2QAkxd3pBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(55016003)(8676002)(6916009)(66556008)(66446008)(76116006)(66476007)(64756008)(66946007)(54906003)(316002)(478600001)(52536014)(8936002)(122000001)(41300700001)(5660300002)(82960400001)(38100700002)(4326008)(186003)(83380400001)(7696005)(71200400001)(9686003)(6506007)(86362001)(33656002)(2906002)(38070700005)(66899021)(46492015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?y9O4nGpJ9MTbrS+ivGFUaz9D9NT787U5rKEWHoxryLDlcIyu95N1Y/JjbI?=
 =?iso-8859-1?Q?sFrsbPATFkfWxtHYpvX/aIqGR9jjjJvgSj0VqO9Tq6355VPWu95gfd7ems?=
 =?iso-8859-1?Q?KLkEMGWuoh8gLXSbRhtz0HrQJTpX632W1sApBV+WrgDGKX5wIhwT6UaFYv?=
 =?iso-8859-1?Q?S/towWucQtFTyCZXyntU6ZdOAm1bnFTRxYoe+m5kh/QzacQ6/WOnzBgQOh?=
 =?iso-8859-1?Q?wy+HSbNaxgX63SfX1Xx9DLAb2VuvZs8A4BggVdOeRHYH8IBtMQUp3CDGAk?=
 =?iso-8859-1?Q?w5pFM4KScACnFiGpHBdpabCfxzAUiVlVY5NK934j5ExDL6OQDyP5Sdx31T?=
 =?iso-8859-1?Q?pvR5cOCMiBsFFYnbKD6DAMCjnNBVKFySV3QstTbJOZKo47eNi8rm+0cd9j?=
 =?iso-8859-1?Q?V5k4kIxfJ1ufra4IqDdmsKb3r0z2llNmwGko0qP4hNLxA0wU4L4yQCMkwU?=
 =?iso-8859-1?Q?GCEaNBeEsmrD5TmRGisq+zg9YfF1LW9ZmJliHZFJDKpMGX/9bh84Ub7eMj?=
 =?iso-8859-1?Q?XrYNIdc6As8vpUESfwfOTWj5DL//Y3Qb/vO7OZ8z5OUnWWPOTjOo9Zfizm?=
 =?iso-8859-1?Q?hQNYJUWyrcoQD4E2dK8vjvP1mpbQLOKPwJMD+6fDarypTuOKbMvCqFXESL?=
 =?iso-8859-1?Q?d/na4aD3JGrxr42+F+RgE+hsP0VSUfuvHcREUWh7m86t9+FTvfgsTyTn0j?=
 =?iso-8859-1?Q?WKy0L6VGauDqjvioUXha4JYHys2KrEFsX2NXwmcdoP3deMgvaLLcyeYDgR?=
 =?iso-8859-1?Q?pRDEPKxY+tOnQ2fb1XDDZJAiKUxXO3Fo0uVVGCDouv0K9pZtIu9dJTCFPS?=
 =?iso-8859-1?Q?/O5rCaxBqaQUoW9C/VU07j4HFEZVzbRUCGFThx4fRhG/bQHWZAMni1R86x?=
 =?iso-8859-1?Q?aO6WO1zJUgLzZrJHh0woHas29WHvUuVyZ+GTI4nZujfzzggiyWmUXEcs1T?=
 =?iso-8859-1?Q?gE0C1O1I2ketZqRG0FKkXvYstekTEdaOidKfjw5oDVciZziEDpg7Ka0tbw?=
 =?iso-8859-1?Q?5ihAoMt3jJps8OupYJc4LLCz7p+uZ9gINFp5qLZQ4Z1auTxH3bslh8KIaS?=
 =?iso-8859-1?Q?bUtQDqWtz5l0ImATg5Gd6KFaD1s5ysCmHDb24LRHA2WQO+HkhrfKf09K4a?=
 =?iso-8859-1?Q?ir+w5SVZnqPvfB/0BBVP0ZmLWVmkPbZGf+DP4H1FkKmctYwLdoDer7oflH?=
 =?iso-8859-1?Q?VSLNaw1ZI4KP87pa2tGT8Vn5JvD3cef9oxQ3kl/zrl2a+H1OPbeVLAbb9u?=
 =?iso-8859-1?Q?mfYz7lp5fHDNcxLV1cDGrUktMRPTP947MCyRRMPmCtIKTdviRsuZfkokr9?=
 =?iso-8859-1?Q?QlWVRhz6Zew0Y9oo/Exwni/4nq7OqX2jBRDH8aeadaqLQdE0dH7ftpeNBx?=
 =?iso-8859-1?Q?Iib3LeaTdgLe0hthNBJCjIpwSYKOiAdGMeYgZgNbJKcjlXw0UNYFfM+4kh?=
 =?iso-8859-1?Q?pzz9g7fY6NB7LNS7gtxTfzGvn0pkQve9nmp8TfJSuuDX9hDrjZuKbSnnWa?=
 =?iso-8859-1?Q?hgyvCPH0pcyFIQeUgjQVCt1xOBew1DubL7adxkeiUVY5XIhqMMzjbIHzSP?=
 =?iso-8859-1?Q?e7akk4Rn7On15MF+f+Jrvspxae/4zqdWz571HmGeCXQZL70FGBNF52sV+A?=
 =?iso-8859-1?Q?VbH+sCaG0vpWVSqtZh74FVzJQnUFJ/w5YDUKcVk94Gg35hp/u5ctWeX46K?=
 =?iso-8859-1?Q?REFloqsFYKHnZIjB26E=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mail.schwarz
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 076166ae-da7a-4bdd-e94e-08db3435313e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 11:18:46.6757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d04f4717-5a6e-4b98-b3f9-6918e0385f4c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +u8X94vQBhxNEF0yehIrZHT146+PN3DNVhqhBdDCuWe9T6J0Lh4cAAsEOp0YlBx5LSwVLrSSScrEX6ojIdt0RL7DGZ/Fuej2pmCVtX9pXLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB3598
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review

On Sat, 1 Apr 2023 6:25:00 +0000 Jakub Kicinski wrote:
> On Fri, 31 Mar 2023 06:25:13 +0000 Felix H=FCttner wrote:
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 253584777101..6628323b7bea 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3199,6 +3199,7 @@ static u16 skb_tx_hash(const struct net_device *d=
ev,
> >         }
> >
> >         if (skb_rx_queue_recorded(skb)) {
> > +               BUG_ON(unlikely(qcount =3D=3D 0));
>
> DEBUG_NET_WARN_ON()
>

However if this condition triggers we will be permanently stuck in the loop=
 below.
From my understading this also means that future calls to `synchronize_net`=
 will never finish (as the packet never finishes processing).
So the user will quite probably need to restart his system.
I find DEBUG_NET_WARN_ON_ONCE to offer too little visiblity as CONFIG_DEBUG=
_NET is not necessarily enabled per default.
I as the user would see it as helpful to have this information available wi=
thout additional config flags.
I would propose to use WARN_ON_ONCE

> >                 hash =3D skb_get_rx_queue(skb);
> >                 if (hash >=3D qoffset)
> >                         hash -=3D qoffset;
> > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > index ca3ebfdb3023..33b317e5f9a5 100644
> > --- a/net/openvswitch/actions.c
> > +++ b/net/openvswitch/actions.c
> > @@ -913,7 +913,7 @@ static void do_output(struct datapath *dp, struct s=
k_buff *skb, int
> out_port,
> >  {
> >         struct vport *vport =3D ovs_vport_rcu(dp, out_port);
> >
> > -       if (likely(vport)) {
> > +       if (likely(vport && vport->dev->reg_state =3D=3D NETREG_REGISTE=
RED)) {
>
> Without looking too closely netif_carrier_ok() seems like a more
> appropriate check for liveness on the datapath?

Yes, will use that in v2

> >                 u16 mru =3D OVS_CB(skb)->mru;
> >                 u32 cutlen =3D OVS_CB(skb)->cutlen;
> >
> > --
> > 2.40.0
> >
> > Diese E Mail enth=E4lt m=F6glicherweise vertrauliche Inhalte und ist nu=
r f=FCr die Verwertung
> durch den vorgesehenen Empf=E4nger bestimmt. Sollten Sie nicht der vorges=
ehene Empf=E4nger
> sein, setzen Sie den Absender bitte unverz=FCglich in Kenntnis und l=F6sc=
hen diese E Mail.
> Hinweise zum Datenschutz finden Sie
> hier<https://eur03.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2F=
www.datenschutz.sch
> warz%2F&data=3D05%7C01%7C%7Cbc601e5604854cc671e208db32691a22%7Cd04f47175a=
6e4b98b3f96918e0385
> f4c%7C0%7C0%7C638159199209626766%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAw=
MDAiLCJQIjoiV2luM
> zIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3DOiRwLDMENMut92J=
%2Fl0Hs6n8sTWFQO1kc
> Dy7mN%2B4AX8Q%3D&reserved=3D0>.
>
> You gotta get rid of this to work upstream.

working on it
Diese E Mail enth=E4lt m=F6glicherweise vertrauliche Inhalte und ist nur f=
=FCr die Verwertung durch den vorgesehenen Empf=E4nger bestimmt. Sollten Si=
e nicht der vorgesehene Empf=E4nger sein, setzen Sie den Absender bitte unv=
erz=FCglich in Kenntnis und l=F6schen diese E Mail. Hinweise zum Datenschut=
z finden Sie hier<https://www.datenschutz.schwarz>.
