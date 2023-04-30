Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229036F2A39
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 20:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjD3SSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 14:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjD3SSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 14:18:30 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2081.outbound.protection.outlook.com [40.107.8.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1630F1735;
        Sun, 30 Apr 2023 11:18:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCWaxPnUmioPZiYZI/YYFk0YWZ5onqx7VBxF9/DgU0ieqB8MUPGyTkMFAWfiWCyf7m5K8UzLvKrIBcH4FOVia1dHghYo4Ft78t1rj92jBs67EvpfwvuwT+d4N13C9KSCCU+YeNPR+sP+qz014aVgjObdxIe17QdDjpk6mCnnG1k8Urg2x8sbuBLEa+T+8cCQsXgqSnJnIyRIN0RTehQWuBoaFNuvT5c5fM256qWpHHQYIwMtAt215E4cR7rWtNw7pi8fgIsPWc0QokPVcwLCPBgJhfSIv9capDjwI2obdK6FniUIoxpr9h7VmamIANmVDsfGsJTF+Fbn2CmZaWoXfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxOhW3pYZI74m933wIIwuNIHyEmdorE9jVAM1F6UWdY=;
 b=U22/CbubJYtjViNt4xaoVjQmn3ZGPYaDVrJp3BDhAXzMrZVzr7KjrFVBePWGSHQsK058WgN+gKJak4+mf7/66ODKNXrAwYRlFz3frOaJEv17cmCjp3IosYlFrXU2Wo2ODrisd5RVsSzYIzm5hnBPjzcAEcQdRRlTsWn43LDxTAruvOpIpkAFgdnN3RwEb9CTh64AQ5u4MVqGE2eX29aTvaZj5lfxXYLkibEAg1mXr43RI23uOONCdpY+9F9mCs5YX7+Av1zT6Qbm5rMXOcno7/xLG6DwuSDaLzuU+ID5/kQH6KWN0TT86aOtXM3rL93sfpNWCc7YNCg8vx6mx6e91A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxOhW3pYZI74m933wIIwuNIHyEmdorE9jVAM1F6UWdY=;
 b=rlKgwVP78c6LWpGi6sHCHLfLEb/oVqfjcTZX7Ff1c0efHDB5uID7Of/cjiUDXxb7gPfQmGYo209ny6kXxlm366OSBUfhxvvEukMuTFboFUywK7qbfv1v/Z5h/1wsMInXz+jzvlUtK7xxnqFyGbcmN1IFBxCFgSoYua2Noyv5S+8=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by PAXPR04MB8797.eurprd04.prod.outlook.com (2603:10a6:102:20c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Sun, 30 Apr
 2023 18:18:25 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106%5]) with mapi id 15.20.6340.026; Sun, 30 Apr 2023
 18:18:25 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC PATCH net 1/3] virtio: re-negotiate features if probe fails
 and features are blocked
Thread-Topic: [RFC PATCH net 1/3] virtio: re-negotiate features if probe fails
 and features are blocked
Thread-Index: AQHZe2XWXCxBWFWtXE6IKtn3GaLogq9D2DEAgABQpw0=
Date:   Sun, 30 Apr 2023 18:18:25 +0000
Message-ID: <AM0PR04MB4723E4FB8898BF5464822C02D4699@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
 <20230430131518.2708471-2-alvaro.karsz@solid-run.com>
 <20230430092142-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230430092142-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|PAXPR04MB8797:EE_
x-ms-office365-filtering-correlation-id: 4fed4089-9de2-4685-abdf-08db49a74a24
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D190/A+4n/ngP2X5prPaW0F0WkfLy2JjiX3fiyRfzCHuXXhV/XyGBeTcBDk9WCJ+4gQ1XvUT8qsfKjRAiZKYsKSXOIOkeLegKGwEecVIm8BCxBBBmDwRoA5VsuthS/vF6hJseo1O+kIv6asWFXZOHGDQsSE0ILXNLyX7neEt7S3iDOCsD1tNedyuNhcCKoVwBH5ZWon6qMmwUMQvsVCwJ8VxRUDB+PKE4WfemYZGF/4M4x9X3kPAIQY3+mJbdTXyifSAQGfvb6pheTAOM1zwQ4J8Ia4oyFCY811/PNOdhh6uPlrl+DwvHWX6mEJ8YAO7sG7aaplGUNbm9qYG44jZCc4hkU18zSoM2k8eaeZeIDCzLiVXW73a5wjXcPp9vAHVND42DLIHordiM4fssAPoKRUt8JiYy5KCNCgzCysv3XHg5SsHe3uj0PHFrWiOp3VKIwde9oOI/cO1hZlQqShZTDftO107N3wAz0YXtrF506l+Xzt35hEwQXzwprPwWpmM7dnC00evdrAtbS09V/Cg6DgIjr/rnvTzDvKmbhvBciFfc7rjPPjFAU2uA9s5FYJ9zh6xWfqRETM1Uyj9keKxsBAK7m59rZwwhY/XrvrvaO05ttJDnjbSQmffYh5+nLBN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(366004)(346002)(136003)(376002)(396003)(451199021)(2906002)(478600001)(41300700001)(316002)(4326008)(6916009)(66476007)(66556008)(66946007)(76116006)(66446008)(64756008)(91956017)(55016003)(15650500001)(5660300002)(44832011)(52536014)(54906003)(8676002)(8936002)(7416002)(38070700005)(38100700002)(122000001)(9686003)(6506007)(83380400001)(71200400001)(86362001)(7696005)(186003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?TlyJx4KcM8g0f4flm+E8AToqXDj7+Zpu1KruiaRGMuBNBrwUpmT0Bn7HG+?=
 =?iso-8859-1?Q?DjJjb9QShToMrFWbMyWkHXP+2U36aReSJjKEWpi6o66m5sYS4E9ddzMEXC?=
 =?iso-8859-1?Q?I4kfd3C0dRf268AEaxbdA9Zct000DBr0wVmeCxmLdjKpALbPN0r2BzuXJY?=
 =?iso-8859-1?Q?wfSWyWlTt6n1DsY5C0J63gaO5aTdaZWc0qFkRItf1rTQvWzMz8W2PeCBYd?=
 =?iso-8859-1?Q?CZcIj5EOP35OrbYDuYJ0ThRgX2sdhIlwHJJ1VEiqf3KPnDenBhLwciB22X?=
 =?iso-8859-1?Q?Um5e5lYaE550VuexPEvK888//jgrqT9mLTAo72M+T+pX0uQbc/72TJLRoz?=
 =?iso-8859-1?Q?RTiNfAZOEbJihUOaopZJcDrQJE9YRMocSm3x5yXJRQpQbGpgw83iHwvX+B?=
 =?iso-8859-1?Q?Rc0I45ApgMmedyMMH0kgcF6ZkbfcZDr/Ev9bQDAUbTki9cLGCxan2p52At?=
 =?iso-8859-1?Q?55YERa/X0unKN5obg8ZT5dagYzr/Ne8f2GtXaIlpL5Tlmhuh9DOcyiiXkM?=
 =?iso-8859-1?Q?aavn4LTE1YKxoTTCeSx/jwALgZo8+RbxiMrqwtrKuC3DM9rrOpaCfX9BK4?=
 =?iso-8859-1?Q?Qc8Wtb8ffhoUy8LvYdTPppIIGeinYwq+vNMw5YmeqBBpzP9UoXuod6W5AV?=
 =?iso-8859-1?Q?JUfRqU/dlIPWy7z2FRMjjECnmBVnfSckPvngeZ1BSM4P69i8YX2uNdYsIi?=
 =?iso-8859-1?Q?sGtgJ1h2UeiI2WmrUeZA3Axu1FUKH5tNrmWvJWYMZhvKwLb2DoA4I2JPXC?=
 =?iso-8859-1?Q?IKOBcvfCH1pp22CbTZd9xeiOgGK1pj6xei6SyAbAO+EQEcI45KECYkvpXV?=
 =?iso-8859-1?Q?uFteIXlOcutCtvdAzViSENhgYTKsuNkT24J+YKwJQbsWXLBws3XiF7/4EH?=
 =?iso-8859-1?Q?EHdGRNGI99eOv9RHlvqHLdpetVYO25l/uQNIO8LZCDgSMTen4ageQS2sb/?=
 =?iso-8859-1?Q?E32C/9mtQ44LytRHM4xewZfkY/bL98rrEYiGzDaspL8f3ZSizPjMs3O3df?=
 =?iso-8859-1?Q?61r3X2WeiBPxTYX3RJafp3x9E+TuVijlxWIbZeIN0FHQ1evSF1g6BQlUrd?=
 =?iso-8859-1?Q?JtJRZEp2YFBzv5iqnDoJrlQP9yQrlacN0spD7P6T0ErrASDIKX4kLnhnKA?=
 =?iso-8859-1?Q?9urNqTSpM4hQEFA5Xc0B+RyTXXPeO2jZX10hs2SdCQwUwp2EBjybLDvnAT?=
 =?iso-8859-1?Q?Qt/dYxUn3VZ/C5nJnQSiLFRQCqwe51HuOvyYgkTAmpa+ZePifp5OURwcE+?=
 =?iso-8859-1?Q?PApTfckF8zv3wOco9cLyFfxGkKsKNh3KN5qr66CjGEZ0LWX1FM+TmXXT1e?=
 =?iso-8859-1?Q?NDGfiPL8GY4GXSH3jPbEchrdb1r270IOx3MNEiW++q+F5ICdt/badvHMfo?=
 =?iso-8859-1?Q?GaR7tJ3JhiGVaiwyY52f4Bq32sdWBqpYJ1hIeM11AAEZDtfKDT3BoK27wk?=
 =?iso-8859-1?Q?af0MjHaOprOnDHh16VicqdUxPH6x9J+/6+Bkd+BQKDAv+pwisKt6qfSrjO?=
 =?iso-8859-1?Q?92IeJyJA3MTBJQRImkpI21BmTTio5WwlG83bo1ohzXhJ9u8FdTeI9sqpx9?=
 =?iso-8859-1?Q?MS8MTgJwmaWrLjbtpHxosoWJuCJz1oC/4OWSnPktLqS2akgCF86T/vUB0n?=
 =?iso-8859-1?Q?a3xNhXJtAxN3B9oTIZacugcgQ0rcLkYAD0RFIxBR5Kzo3LhyZg2XPygXkG?=
 =?iso-8859-1?Q?p6JvO195e4ryXR27YSkJTkIlyKMhVgoAvlWBVw3hpLc7+YAEjv7GEPu91K?=
 =?iso-8859-1?Q?HQMg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fed4089-9de2-4685-abdf-08db49a74a24
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2023 18:18:25.4748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XaSOswya2QIAwt4yhFRpWK1G60Nd8gQJX3iADK1XxvNigGY/qlfFZ3ZHsobANUBSg4ZtbEbzwduGuBRdF0lBTdGpypj0pVu4lmQik6LA1Us=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8797
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +void virtio_block_feature(struct virtio_device *dev, unsigned int f)=
=0A=
> > +{=0A=
> > +     BUG_ON(f >=3D 64);=0A=
> > +     dev->blocked_features |=3D (1ULL << f);=0A=
> > +}=0A=
> > +EXPORT_SYMBOL_GPL(virtio_block_feature);=0A=
> > +=0A=
> =0A=
> Let's add documentation please. Also pls call it __virtio_block_feature=
=0A=
> since it has to be used in a special way - specifically only during=0A=
> probe.=0A=
> =0A=
=0A=
Ok.=0A=
=0A=
> > +     /* Store blocked features and attempt to negotiate features & pro=
be.=0A=
> > +      * If the probe fails, we check if the driver has blocked any new=
 features.=0A=
> > +      * If it has, we reset the device and try again with the new feat=
ures.=0A=
> > +      */=0A=
> > +     while (renegotiate) {=0A=
> > +             blocked_features =3D dev->blocked_features;=0A=
> > +             err =3D virtio_negotiate_features(dev);=0A=
> > +             if (err)=0A=
> > +                     break;=0A=
> > +=0A=
> > +             err =3D drv->probe(dev);=0A=
> =0A=
> =0A=
> there's no way to driver to clear blocked features, but=0A=
> just in case, I'd add BUG_ON to check.=0A=
> =0A=
=0A=
Ok.=0A=
=0A=
> >   * @features: the features supported by both driver and device.=0A=
> > + * @blocked_features: the features blocked by the driver that can't be=
 negotiated.=0A=
> >   * @priv: private pointer for the driver's use.=0A=
> >   */=0A=
> >  struct virtio_device {=0A=
> > @@ -124,6 +125,7 @@ struct virtio_device {=0A=
> >       const struct vringh_config_ops *vringh_config;=0A=
> >       struct list_head vqs;=0A=
> >       u64 features;=0A=
> > +     u64 blocked_features;=0A=
> =0A=
> add comment here too, explain purpose and rules of use=0A=
> =0A=
=0A=
Ok.=
