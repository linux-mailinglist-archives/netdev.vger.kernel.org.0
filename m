Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF56F5E4FC2
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiIUSie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIUSib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:38:31 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60074.outbound.protection.outlook.com [40.107.6.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF361A030B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:38:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avgeaCIzEK1GeiRfxanqfqruOwuYeWprbBIHjuOUIgV6904AHuimK38rb/4OmVDm+DaNXp2Gz/WkGQEOIJEwyBSsArowrkP8z4Be1fBLeNyuCTvf+R52UG5fXHnP0s7kjeYvNnUB+pWhImT4Q/veRHZjggZ6cfCNKLx4dUHw4SodoZK0UHjDS1rbfZXPueni4VISBwfaEuYX0ZNgkxudFqStrjtAdyk68dlhuYAnvwJZCeeY6na4dUfqPJ/Y5LTJEJbCG+3xDKxmI6IqS5GDUHmHUMM6K3kMAF5GB/iTxLypbZZ08XpMs8tSXRxRLmbc4GXG/VDLln/YU3orOM+orQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3scarNXxQ3zRBMRYS9WjfPi0uv1aRkhEYD7bpY2pV/A=;
 b=AqPHSnOthf90VYSPA8hLn0/w2mHsUY9dTyRYoogV4gxYZEMg6jpZ4yx/vBYxnPFYOSUiplLP8fXG+KGTRmd3G45WI9l+TnQ6/f7jXpjzVP0w+KVAwpQ2rU7/JzHynr3ATZa5VirSwYFVz6PwFUumv9NnUt326pxtJhrwxIGs+dVM1R7FKXAc/gDqepngP/fL92i3qj75ZYOXKJFg7l1TW/JL/rBKVMquJsE4MUJMa6BNgsS9Y5X9xCCbX7XsUXZNTg7HcJ4ntBXBijITyqOifPVF2+OV7UycecIT6rhPy/PN4W0FhZSt5JEBy6S22iEfT9mzzZY4696zqNQCdVxEMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3scarNXxQ3zRBMRYS9WjfPi0uv1aRkhEYD7bpY2pV/A=;
 b=p6aB5rhgRtEHBz33/MJ3E1x1+0qey8X80ZowivJWWy7x2NNQhxbu87I/989laLwFzB9cUBdXRiS+nFizaC6ySCwmG3UA5HcoafG7iau1BopjDghPMtgLXzyM/q/wsPEULVOAmOLb9K2TSoXaNTktjVoM1GA9zt8drN6liiePLps=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7271.eurprd04.prod.outlook.com (2603:10a6:10:1a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 18:38:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 18:38:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4A=
Date:   Wed, 21 Sep 2022 18:38:28 +0000
Message-ID: <20220921183827.gkmzula73qr4afwg@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
In-Reply-To: <20220921113637.73a2f383@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBAPR04MB7271:EE_
x-ms-office365-filtering-correlation-id: 1a3d5b97-bb0a-4fad-2360-08da9c0079fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CSAhV9MfI2tLo5/2I/7Bm0uFKeoTSg/DGj5Q4O2OqdgSk03Yd9ROXdHEbk6iFj8XLWd1kty/ULJzVAznCECUawxD4CqcOLT4dMr4AN52I3a59+SJTw7hjlACVdm5Q3RUpoXhrWzVJg2pQSpOO0msJtPEJSWtYh2ldEUL/+ARm/N9AakNpndl5s4amFe+mu78dUDgpy/Km1j54L9IZKWHbhFxiihj+fRdiJHtfOgKaWYC0ELkn0ShWMWdvo+cpLDXGJNpP1cF3byWrWXfVDgu/phDqCRtgV5DERBhAULbtxGMmCFaOWA+outUtyZDNLg4EkUwIbzOhbjEQO0akkEYWDTxzzhsd+cRIgaC/knwZXTvsp+hUELaCmX6/MNcBRMKScbhQ8kf7LxOWv6OBrfgtmuZQyzSx0nnGy4gtyyPS88Dloo2uOB15EcHYu1dhE8Cm15Kq0mrn7B1wyTh8ROXilQqpQ+zQ5hX4mPx9RpqNTOQmiHEmlspFzfXlAQHRjpmxvNquGGl4Q+6GGXrd0twvz8Lno9Pne6liHUtV/brJKgc/H2NUy22XIAzvcCfKEDol06yv8ZqHnV7kCLYev12huGtctX28lVORe723IxGjok+F8qKub/q8s3f+Y50y7DQn/4y0bGNjKqJMjhLN3VROeWbvXDnhY4cpuvFp9DpDUzxXLRnyfdiK7tt/ea/nF7kdqqsoT+6bOYvVVy9qkQflliJCyZH9/9UC4Y/eUIw6c5qXqHKsIoRxJz8sJlb0hik/U8twlHqIHdQSiDly6m9JQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199015)(66446008)(66946007)(26005)(66476007)(66556008)(8676002)(4326008)(64756008)(76116006)(91956017)(6512007)(9686003)(6506007)(71200400001)(8936002)(83380400001)(5660300002)(41300700001)(38070700005)(38100700002)(122000001)(1076003)(186003)(478600001)(44832011)(4744005)(6486002)(316002)(86362001)(54906003)(6916009)(2906002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A8sWrglqaEa3xS+8XfiaTKWy+Dbt80TVcYOkuYfPFjbD96pXhs8FtLYZdsz/?=
 =?us-ascii?Q?srsSYN/LozUhRg+lpSe9m50gHpN01ymaPMgt22b8cDEOzk6MsYpjLz2D1aZX?=
 =?us-ascii?Q?8cISxTTB8xHM+4z5tayieSSmBHJuU8tX3sLPJ4UlH6ReAuXGO4MZCZvv206R?=
 =?us-ascii?Q?om9WIr3INrv3ijVO3z17BIg5vCuuPfCsxfSXe7ikupKE+o+Xk0Kg20CetsMn?=
 =?us-ascii?Q?3H6JDY4klZYn8mU5NFmsk0fiw/AkNI3eAfdcJeMVYDS4nOlDu4t3YNjXTf6h?=
 =?us-ascii?Q?44pGTYH35RjmS22W8PJk5+IjzmGpjWENQ9Xqc7ThYGbzWo5CScehuECYrDow?=
 =?us-ascii?Q?GvBo3FgHhMBYeVQ7etUt70xI2msIHBBdVKeSoEABJvG4x1AdDZJABfLTZSib?=
 =?us-ascii?Q?GW4uOaNN+5oVL+mDEqfXDFsDGDxZ54IO/EWWbfEJOIN0wkjrHTCalMDIpORS?=
 =?us-ascii?Q?TmjQ80SeNYoc01B7kLZM3h4d3Q2nTybJ5g7cx4edMrOONLbuwfMpJ6QoQsxl?=
 =?us-ascii?Q?2wa8vvVN0LSrzSSPw8H3J8HiPpGKs03PbpSPWb8EWv1zQdw/wfadgavQK6IV?=
 =?us-ascii?Q?8Hprv7geI27DxOtdxZaCHNEK90q/iRK5gjfvwhcWw22myJAde0hkN/mygfeb?=
 =?us-ascii?Q?cIkpeXKWNAwyx/fHBc5iVyxyS1ACE7QX5DDc4qw2XLGifwoK3r76ndDjQFc/?=
 =?us-ascii?Q?H4yBPwSNgDfSguMfpPvLl+e5sabKTtaF+ilorEIZBLD2bMTu+GmxBa2uF2XH?=
 =?us-ascii?Q?ZZ09DIJJFB+Qh1ITLNpGVg0IXphZMDJ709+YUzP+eXGKb0E1yeYu3GyZjAzY?=
 =?us-ascii?Q?6ZbRnow50fXeMKdL+4t1I597/iwy8Pg3aJOXbXn61Q8uGb/iRqXbCdSeSkQg?=
 =?us-ascii?Q?UcDevRMGQCTQHIYlYtXUW+JXDMOxCOLWbylv6FUqZyklARzthyfKirKOQ4fe?=
 =?us-ascii?Q?kyQUa1TxzqhOj8mUIxYIqc17ab9o88SB21dTf76Hikwgldhme9Z5BMDBIrbt?=
 =?us-ascii?Q?eNAh7K8HjMfq9Q/dlNesiq+CzHWJfl2wDpiuCBFffnZmCCOaZLNuoNnPGhaA?=
 =?us-ascii?Q?bDLFfbL2GBFUlaIgD7XIORrClQgsT7J+RXvcPL/K1zVOxD+U1HGIubcTlTGN?=
 =?us-ascii?Q?8hIpe7qjvLAW72ay1bcM6KTwkrL6p5K33neVp4FzHapMF5X3ndxYioIRAI4K?=
 =?us-ascii?Q?eCAzDzJrkVZp4djQS3vpbWfuO2yukwgU2jgYtFQ7CYsYu5MJlvbrLvEqc59e?=
 =?us-ascii?Q?l8daQxyU/JtcMuq5On4SUU9peIDSfELjFjEBRYA+D0CFSbCFBSXPZCR9nlWT?=
 =?us-ascii?Q?3DgFaHCUKJIJPdtOn8w+itM0tZo559warIfYoeEv851RcU3flhMMJ0FxbuP1?=
 =?us-ascii?Q?okgSZ3Zm8zBQJk7oKUBlAT8IMqUB8EKb51r6nDoPN3Q/n0hPObDKWEtUjBAP?=
 =?us-ascii?Q?yX+PXVnnPsi6NV50pF7pX6X2M15IYRZJkOpCHSY2H+CtgGTvynL2ds5r460o?=
 =?us-ascii?Q?hTjENOAv88ACvvh6XV4K08eXCQNZghtYpsArkTEkPWuGihbVnJQocNYLLfpw?=
 =?us-ascii?Q?OE19W4HSr8VAJMKHgnMEzyUqtq+cZSSa4/yLd/bJUngIGRo7ZuMgWxqUY87J?=
 =?us-ascii?Q?Zg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B65A658CE78A2A48A023E5914AE7F475@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3d5b97-bb0a-4fad-2360-08da9c0079fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 18:38:28.6090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DiDjwnC5ghFIqu0op19Poxud4p4FYNJM4z9GhISe8RKilglRd7sZQOcxzLCB2yzcnNNN+ljV6o/v+7NW/Fg0Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7271
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 11:36:37AM -0700, Stephen Hemminger wrote:
> On Wed, 21 Sep 2022 19:51:05 +0300
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>=20
> > +.BI master " DEVICE"
> > +- change the DSA master (host network interface) responsible for handl=
ing the
> > +local traffic termination of the given DSA switch user port. The selec=
ted
> > +interface must be eligible for operating as a DSA master of the switch=
 tree
> > +which the DSA user port is a part of. Eligible DSA masters are those i=
nterfaces
> > +which have an "ethernet" reference towards their firmware node in the =
firmware
> > +description of the platform, or LAG (bond, team) interfaces which cont=
ain only
> > +such interfaces as their ports.
>=20
> We still need to find a better name for this.
> DSA predates the LF inclusive naming but that doesn't mean it can't be
> fixed in user visible commands.

Need? Why need? Who needs this and since when?=
