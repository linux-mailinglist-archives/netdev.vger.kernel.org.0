Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F8556897A
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiGFNar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiGFNaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:30:46 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140059.outbound.protection.outlook.com [40.107.14.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266CC193C0;
        Wed,  6 Jul 2022 06:30:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nel9OfM742FajLCzYKlue284DANWE/vbYg270Jitj1/F7kZ5W4K5+/OVX6sF63iX/0F3B66K1UFT1dNgsl56KtJg+Q3FFaMd/refGVkbCorFvmyTnroP/5Kp1ewsrV+tnmesTXJZbsE3R3qxvS1LqMhquC+8YnckJS3KpEiKbitbaKmLBOGrnIYkpbFrdvSLSy3kwD7xVrCbsCnA0TUE+TbHvn4FTvCjnHTA0miFD95ejoI7FfAZcrfd7uLDbyRmRyF5bz4iUBBQdwdkNwzBUR6QrK0xy/s6IINr1BQYb482mbAHjsg0VHEv1vdeTn804vTIG/LLMtmfNbi7QDsTvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTtWTWhwNQgR2WrGIWU759G4iVWyTDLzTqEjA7lj5pg=;
 b=eqo2l5w1emq+6Cys6w9fTB3mXWl0usf4RKV8ikNvTdtHfOOyopFx1gNGPZunrCl6kPmQKrFrgkoIbsExPSHWpzwqyLQJyxL4sMTr61Od1G1DDT6VM0mRhzCdvYWB4RJh+aJn0H2XBiN7cE8vgbxgYR8Tm7I1eQKruJ1PuWIqw1mk/hnMyjKUt+zTrRjpYGz8VWWGLMtVcq/jK+ZfWzTNY2aLgQfugLPOVscJTNg4YfHwRfcGpaB6/nsUkn/0VtTgr28U9dEJRP1rvccJ0fRPznTPTAskYCpeZBDa7tYgsKCF2f1DM8FCakQmjv/uRGt++uga9f68/ytc2pwsf3pGwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTtWTWhwNQgR2WrGIWU759G4iVWyTDLzTqEjA7lj5pg=;
 b=LhLCoGTcCohPyCp6ILf8W09tEwZwQ/4eRHHFzAV8cDQP6wBMLA09H7XpxGM7gTrV7vagtz91FGGm4DSbLp0AL1NFgaR9UwIK/z5GfOecr4H14/KzxU75+9GlaXYNdEYGAv843Bd4kwHRjqLHOxmwK+RHmlx2FAv3ApdUKYUxvFg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7928.eurprd04.prod.outlook.com (2603:10a6:20b:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 13:30:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 13:30:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "clement.leger@bootlin.com" <clement.leger@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v4] net: ocelot: fix wrong time_after usage
Thread-Topic: [PATCH v4] net: ocelot: fix wrong time_after usage
Thread-Index: AQHYkTxWR3oKNEKHnk6aIqZkbKC6CK1xVrOA
Date:   Wed, 6 Jul 2022 13:30:42 +0000
Message-ID: <20220706133041.qsmuwnljlb4ng6gn@skbuf>
References: <20220706132845.27968-1-paskripkin@gmail.com>
In-Reply-To: <20220706132845.27968-1-paskripkin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00c58f4c-4a3d-491e-0740-08da5f53b938
x-ms-traffictypediagnostic: AS8PR04MB7928:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zylsYJAwBWm4xYB0bgvaUdc69mK9soYa0HadxSzUoKQpNnygCusjLHD2OqMDd+UI5LJXwlkZpx2VXYXLcHRB2v7RzUfYraTJ2KMy5XrdGNvEFS5YZ+WaVHcMxhDLmz5EWBeqcHWJf3OUyAWhHsLKn4ZnP+vpmbWOZXpKl0VcmGO+8QsA6slg1ztx+frAKik+MOpmcKzaYaajmr1Rij455kQni/9P+4ArCHkJkt8cJEcQUDeVBQQLnMMRTuXajiHStYnv8iygPAuk1QuciN90uarHCj0EiJ7pYMrI9/mfjDuKYSiHgh7q6hOGFBsUhjFYwdc2ADLxaC77o/MOUEg7zT1xjK0c/LCx6p0xYVLR01pKR900WWXmwqKI691AgmGk8voDTpmCvm2DBecjpBMPx5U/Cgd81eO9O9WdR4q/zT6c+XQa8x/otKfBHtOKVgZ4TToaImjVJfNqjOCdHzW2OF9j75HoCBjoUosXnuW8rIq30f3xhLsiZdlEQElUKfsk5KVjErajF+JKKNlMvo7fTX5fHxNPl9JzpHD2LiFkS96l9MdK773vH63wA2ee2BGONDU8VC2qOq34n+ibiBaNPd6fl8dDisMPnV/b0v/gKuhFqrULa5XzeKmxYDGWsR+vfQUvkFX2Id9iX8Czz6+Xs6WTfllFZuyzf1mQx4GuofFdm+dvItdl8xBHolpW8q/i2yuvfX5WojV5tAzjrJkis7Jv8DiDb5jmwXWn6vMRSa1ZymWrxGQscnDqCt25Q8s6t8ajekB2naVQ8QFJ9UnZITUEre+p0Eb4z+Udqz8tJsO5HJyGrqCU02ZGmDkoZCWZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(346002)(136003)(366004)(376002)(396003)(1076003)(6506007)(91956017)(66556008)(66476007)(66446008)(64756008)(9686003)(8676002)(76116006)(4326008)(7416002)(5660300002)(66946007)(38100700002)(8936002)(2906002)(38070700005)(4744005)(44832011)(26005)(86362001)(122000001)(33716001)(478600001)(6486002)(41300700001)(6916009)(71200400001)(6512007)(83380400001)(54906003)(316002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lxwN2rerUPn8E/AsSloPWyqMowz+X39Pm6j6fWuWvBmFH6M2hQzyAa41/r3T?=
 =?us-ascii?Q?AaAyjhtlaPm89f41Puvlhb0z7MatQWnepYdVAUrVadCm5VfNB3wL7nR/RZyv?=
 =?us-ascii?Q?6HSocDd0lR2KYlbNL/vhxAyzpRjjA/i8rAux3q3K2YzHFeuRqTUVEIsHK2Cj?=
 =?us-ascii?Q?N1xD+LUHIUTxKPXgRnVPqUs1Wonpp9Cf12Dx5msXYfrY5/gk9GFMDTIaianZ?=
 =?us-ascii?Q?CkzedgIUZ7CKDnTgh9SO1MHEw/BC03zQewDB18ScEu0mli0i0QHFDj11pJ6y?=
 =?us-ascii?Q?jIsy7R7FkCfqrpe0jHgW3nc52cM6dEm/EVd/0CJKv+KAAuCxEcUQd5GEK6IE?=
 =?us-ascii?Q?XoMOrD3NRMVZunxvKRDV8gcirxTzPXf/BLl0c61l62MyDzxqcuh5O92GsyqO?=
 =?us-ascii?Q?LVdx3kuBEDh0igX3eIsc6StnBSg1awVUOQwKQN58RZu3HI2MKUAaQJBEAzNf?=
 =?us-ascii?Q?JtCbYXCD8/3bdvxeDlGgEuCqvY8pKX2eFBfIxGVjBVV60iO1+jseEufYPMLl?=
 =?us-ascii?Q?h1ZGgnuHqejTLZudx6iRPcLjZNd36Ciey5rECLTtgcvt/NqbdBzd/3ApRsWj?=
 =?us-ascii?Q?4ym9H72IBJP1bX+JAcQMYma7uyTEqkh4OhxBclWJq+nU6sJG65/hCyqlZJXb?=
 =?us-ascii?Q?WrPZCbIjhNH+00HLD/6Bc8Ke0rJVH3DYhTl7PjcNmsGjVgadv/97rMiLw6w6?=
 =?us-ascii?Q?oZwwhkZ94eOf+Yi2oRHSpsXqV1MRVt8QM2+vU0nP9szsWC0CuH01/1uXotQ0?=
 =?us-ascii?Q?+RoMBu6mYHV7aZ4fr3kHJQp6rM5hI+tib9FZ5RpeAEa3MYt/hNSCaMreBHQD?=
 =?us-ascii?Q?WhcjybeclEit//Dj68ScDZu6zpqZHJ1dyqxSNFMjCWi0oiS8ItNHSLIQ6WyB?=
 =?us-ascii?Q?NvEUvSFgMwxJEvhI/IkvVEZoKwi1klTIB0oOYDne9+hUflZlSHDq2NNAucap?=
 =?us-ascii?Q?F8LKOkxpai6Ns5X2u5HmqVCdYoHsOpffvm9NOUd+zyV76Oc+L1QGfDgneo4u?=
 =?us-ascii?Q?5rXXv5W/2wUC7F8/DvFPaxvHgZT/LrY54nYah4k+FRzHkYjBr47EYBRVacJ1?=
 =?us-ascii?Q?RQ3rOOJ+JCpNpoeKBFx9R5woGABdAUhvF7hNcoCuxyJluP7ZU6DOiW3XsuoV?=
 =?us-ascii?Q?5M7q0hpvnTEmbVnNDNM0E5KuqaURMnJdjVmQ6nYZUzxVFI/N7GsBcqWaAZKm?=
 =?us-ascii?Q?HMakHn+M3/5hkXtXK+eddkgb5hRZr+hSDrbHxrJcRSjCYzfCB1gNWuJ//Pwk?=
 =?us-ascii?Q?TM5/nAP+v2OSVUFyhgWUPk1s+odhLjTAyJfZkCEofkdce8TJGILaZ4fJQsOg?=
 =?us-ascii?Q?hP0DbiEtF5CAw6lu6p/XAfzHmOOK5pyh48sjcCUaOBP8BeAM0O9J5CpLKa6Q?=
 =?us-ascii?Q?DHYFlekgOrI+MBq6PnNR7pNAPeLOcrk9vYjuxxDlS4/UTk0QMbS+Bamx5YfO?=
 =?us-ascii?Q?D5o8hDUq0VBiTjr+8nKYoy5MuoICjTB8VgHGxAfz+TajAq4fbvVXr+SQ3rjN?=
 =?us-ascii?Q?SK/tZKGerx+RV8YoOScVMfJjn+m7LLVDFU6vrtjEoahQB3H1GOpmlE+TT4J/?=
 =?us-ascii?Q?8BiUdyumOTpAMSYg3SWbGOzsMFAO4ydmfbwJKb+p7/pzrSNUcRqexdkaCB/1?=
 =?us-ascii?Q?kA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <346EE8F829DBCE41ADAB2886E1731A77@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c58f4c-4a3d-491e-0740-08da5f53b938
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 13:30:42.0258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tl5VqKkMS6ElcHcCEfRdrGbbubk6N403QMr87cy7iFke+eK8fnKI72piNzDNe3v/msUuGL9JjErkeTQlb46E4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7928
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 04:28:45PM +0300, Pavel Skripkin wrote:
> Accidentally noticed, that this driver is the only user of
> while (time_after(jiffies...)).
>=20
> It looks like typo, because likely this while loop will finish after 1st
> iteration, because time_after() returns true when 1st argument _is after_
> 2nd one.
>=20
> There is one possible problem with this poll loop: the scheduler could pu=
t
> the thread to sleep, and it does not get woken up for
> OCELOT_FDMA_CH_SAFE_TIMEOUT_US. During that time, the hardware has done
> its thing, but you exit the while loop and return -ETIMEDOUT.
>=20
> Fix it by using sane poll API that avoids all problems described above
>=20
> Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch should target the "net" tree.=
