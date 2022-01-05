Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BE34858BF
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243237AbiAES4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:56:31 -0500
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:27238
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243229AbiAES4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 13:56:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fegh0qi9kvQJQp2FieW1f/guPUrL/xyulZ9B8SnexjOrPWO3jO1cNFdcXteoaCuNI+HZGjx6cpsjGImxqRMUJaCfyUBuEWUDYZAZDoTD1a5Lp3x2bW4SqRLY/mjNvRqvPBN6ftuNymLZrjtHiD4MbqssDPnQrVhSsgdSP/O5BYL5Z+eFPzFnEaJmMQb6XvojC4029FnVHF0WMyiPIJ6BgfilHdz2RXav8hlFy9uMGwLKx7pqtUbOG3ZrIgW9qrR0eYULouGb4ETI8pgdRA4BHDgQCRmy2m6r3NXG1hj3fA5mrSUBWog9+aRGOkvUS9Uu2mHjHTQp1c7cftlRlWDo/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WId/xevKEHPXx5XPuJyzzxXLiKfiaYcA3RxWX+l7LpM=;
 b=m3RffOkhoRPTDfygR++1ELoOo1inqXRhVP49h9bg9ehGXpDmeAvWEjBrVN0EZ9It8aczoBm0AALjwu+V1N94+NOaZV/aeg5bsEnsaaQkN/k6av9i09QtzvvUpfX5O/ru6pAoqc83n4PrUmHBfjOtH3veEBaAlZrUOetrO+qLPAosbbI7Sn+NhsmqxbNiCm+aB+1rde3mdXVrUDfvEwoxB+Jc5oScuDGvpo7kTzAH6ASJf4ghzEBbxNmgdbvxIDRB0/JKJrNX9dpQKn2EYtwWhG31X1nrgebPGCEzYNa+Y63UGBU6QOCLQyXCjme1AfPD3CU3ue0hsX22f6BXb06n7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WId/xevKEHPXx5XPuJyzzxXLiKfiaYcA3RxWX+l7LpM=;
 b=c4aMUZqav6op5IZ4lso8xdy6ul+/vvcltEq1jFvNfwkOc2Oj4qBdzGg7dn/+73S5AbvakbgCphaTlv8SpnfHj7RlcvU1elYk+EcbDSd+rnPm77TP/6W0uRtWoyvoCCB9D17csCVXUHvN26L/m9fGG/R1lPv8mXnzg522D4pwfUw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2512.eurprd04.prod.outlook.com (2603:10a6:800:4e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 18:56:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 18:56:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 net-next 2/7] net: dsa: merge all bools of struct
 dsa_port into a single u8
Thread-Topic: [PATCH v2 net-next 2/7] net: dsa: merge all bools of struct
 dsa_port into a single u8
Thread-Index: AQHYAjc04aU5hROR7Ua9AmYaIwi8WKxUwFAAgAACbACAAAIBAIAAAreA
Date:   Wed, 5 Jan 2022 18:56:28 +0000
Message-ID: <20220105185627.vq6kgnw2yhbymiuc@skbuf>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-3-vladimir.oltean@nxp.com>
 <d41c058c-d20f-2e9f-ea2c-0a26bdb5fea3@gmail.com>
 <20220105183934.yxidfrcwcuirm7au@skbuf>
 <07c9858a-aae1-725e-67e7-fc64f8341f3e@gmail.com>
In-Reply-To: <07c9858a-aae1-725e-67e7-fc64f8341f3e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73bf4df0-037e-4a05-667b-08d9d07d1469
x-ms-traffictypediagnostic: VI1PR0401MB2512:EE_
x-microsoft-antispam-prvs: <VI1PR0401MB2512B4464693373FCD5D993FE04B9@VI1PR0401MB2512.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aEV0Tf4yy8+hzhXDbKrIpCRsEzWwFx6dqRwe83a0AEp6vJrP5/WfI0n4Eps1puWJbQhxioKo/l/ciRSJTFfYaLEKw8iwMBYoaOtmSvknoedIaTHiWDSGCKXOegrrjqGSC8Th9uelF8KHLjHlTG5E/PG49XH57Eyv4hYTsgTU4bEKzw+oNX/dl+Z1TJITWjqSXgDlRpwPkP2OY+oU7ZRuXxCf4Xo5pIci8Owlnor/imAQmo2SFiaJCRjGpqKYJGAcwTpd0Vt4u0HYPiu+B0nQ/GoJCVvxXASk1tXj/b4hfrQiHkrjg3qTeiRoDIy+ZenQmzFFCfvmSqpFh62Up4ODNy4Vr/H1RUCjCAT2hlNNCt8M80gwezS9iHweBfDAlS4AF4T3lxaD4QdFA6qEDcT/NsJ0+ntcIwuGSA/muVUrgY1CqpDPvwNccW9pl+vavSn1U8eVHarRJrjY0+TjdHkWEWHSsq70hb4IHr1UNfkSnnirs8qkOWAo4RYTzS6S3NuxbBoh3/jx1vk8DSw4Ud42kBcANpOLVE3ya2jopP8JCiarECMjsAzs7Q9K/u+iV80b+vCJaP7SE9s8FLldn3yTLk788QLxfXUHGC2XIjELXktuBIWhsa6/BN3SdDToGPR5pIL30O4qWfCnVahhLvEeoHPHShoAZQhgsUck0VjW0GZJ2TtWYf7BJTGna7ZS+En6YZdFw5gsoN/PS/+e3XVDfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(38070700005)(6916009)(53546011)(8676002)(76116006)(54906003)(6506007)(71200400001)(66556008)(66446008)(33716001)(316002)(64756008)(83380400001)(5660300002)(4326008)(86362001)(26005)(66946007)(44832011)(2906002)(8936002)(38100700002)(508600001)(1076003)(66476007)(122000001)(9686003)(6486002)(186003)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZzDYoaZQ9M6w/DmYygO50+1gAArGUVy26DplhCLJqL9eyfVlIxO3MI7gWNYq?=
 =?us-ascii?Q?HBSQuQWQgc8w57lI3k9DvJay5bhRo7oPrgxM3YJjXy3BWKmm3QbxSfVHkdIW?=
 =?us-ascii?Q?dvOs/jfHkPwjU0frFWRKH/qeZ1mii8c1pymqyoBN+LS6DmzZoJwpehPiKgpW?=
 =?us-ascii?Q?PktuxvWH4WN3vDmZaLvcSokCF+B95tvhlP9Fx876Fk6MDk+0QX3dk/XWwnm3?=
 =?us-ascii?Q?EtISDAawrt80cAkJLvxT9YaNb1pRK52QPizdISIvl6LkWIDEIe5pCxkMYJOT?=
 =?us-ascii?Q?mKzuIV0391tu4Pr8baK3BuJTNVmrQbLkR3upheBsjP7aqhtREIfQeMCycKYz?=
 =?us-ascii?Q?Uvkxi+HrxgxxQkd77bfAsT/5gOTkwaiXz0U8EJdXkZpSeZD8BpCjl/L4cxUZ?=
 =?us-ascii?Q?n2TkC56HFoGpWG5fyd3WZNshg2syWkmkiab54aXKWrO7xjB+2kCspaK+7PXL?=
 =?us-ascii?Q?UbHVRTA5Fa8l//1jvrN17P66+JTO2POzzpbM+3Q91ohDA3uaMSGNAnLEWNd+?=
 =?us-ascii?Q?cnZbTlMelj92zTPQ1MEL45QCt5gyXiDjpxQUqPapihfDFmOhF8t9ZmdA3oQ+?=
 =?us-ascii?Q?DE1TRsByr9YA87A8656Liu264V6TI3XfasqLn9fY1Z4tgdjg1K2x1leVOPGp?=
 =?us-ascii?Q?c6UnvmTNt2rMoRGshTNmmeMj8tgPeVLow2MlJVKAaW3l6CVn23/5lUdH9V2u?=
 =?us-ascii?Q?wUDZD0FpMTIpljwv9i6XnAH7Q7bqnQaJrkLipCNWP+BsU35i4wX32B/fKYFz?=
 =?us-ascii?Q?r5JmWpfOnZAO0/4BTHm60xAUtOs3FZo/e/vqcOcLjC+lpuwLOHAVxjTtZkGf?=
 =?us-ascii?Q?P0y/JCIXDk9aQ00slTI+5mz3A2Ey/OY6yifmEbXNSEDdVjBwTDepmWti7xR6?=
 =?us-ascii?Q?+n9Tt6KayCnFpxSiuWJoVCCIk7Iie+VmHE7u1wwTcZDl3DuHuX010RRTGOTH?=
 =?us-ascii?Q?O5qyCe6fOht3unj/vuUsjUWua0Imv0tDFk1fFYi+Jn8hqNy+6CYgaleaXruf?=
 =?us-ascii?Q?OCXg1V+Cmfvnq13JMZzq8H9qsFuo5Z4i6USteiFtU89wv9YyNu72Hi5AiywE?=
 =?us-ascii?Q?JvZWsQx/rhF+NqxFAtSReUEyO6qBDvgkCRNC8B6dfLEUVRvkc61cXuU720sn?=
 =?us-ascii?Q?RkIa0oQ/ha5rKp6YnVfqJ0xzDhLmdWJBrRgr0hXwsGQ37zu1je+Qr8DTnGq2?=
 =?us-ascii?Q?gfunb69obU4NYN+d7fiCqBX0T8OgIA5uiEa5bjxC4srxFN40x6bxbLRbP/89?=
 =?us-ascii?Q?XUFqiDRavWJT/Zh6QWp1NJTdHpQQk9qhsIZiXF9TiyEACfjiNfCPK9f8H8a+?=
 =?us-ascii?Q?P2CxBdbhPFxN6suBnp75gvE2lbp1e9hjEFjZMzdoaQXSoxtG82ttbkmXduPt?=
 =?us-ascii?Q?PLCNCiQGsD5odvhHAyXINon7uLMSFddxQPIqhjQd77MsGfZ4aN+YegwRg3dF?=
 =?us-ascii?Q?21H86S+F4UuXeV7jGPfHQTxMdmqL07XXLEEiSe6hdklK7qPevj4bBc3GsPRz?=
 =?us-ascii?Q?RzCcBgJPVggGJVte6qQEVPEBwhRqo154gOs8FTceMC3V7Dz0YujTdMu1qpEt?=
 =?us-ascii?Q?N/BaDn/JdXvQiHACYVMl2ONnpKWPR6Z64TA1LYQkOdHgkwe9ixXf+84wqyWb?=
 =?us-ascii?Q?Z9BCox59qTa3YEJIG+mp6Gc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01BB6CAB3577334F8259B689AB40F54A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73bf4df0-037e-4a05-667b-08d9d07d1469
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 18:56:28.0170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wBVyvi6jn/eeCQ++AHJFqj2WUumWEjmp5wOon1MBu1LbjVoHOtblzEXbmimYIpW7wNocjWoagHvreHJfm+LtPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 10:46:44AM -0800, Florian Fainelli wrote:
> On 1/5/22 10:39 AM, Vladimir Oltean wrote:
> > Hi Florian,
> >=20
> > On Wed, Jan 05, 2022 at 10:30:54AM -0800, Florian Fainelli wrote:
> >> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> >=20
> > Thanks a lot for the review.
> >=20
> > I'm a bit on the fence on this patch and the other one for dsa_switch.
> > The thing is that bit fields are not atomic in C89, so if we update any
> > of the flags inside dp or ds concurrently (like dp->vlan_filtering),
> > we're in trouble. Right now this isn't a problem, because most of the
> > flags are set either during probe, or during ds->ops->setup, or are
> > serialized by the rtnl_mutex in ways that are there to stay (switchdev
> > notifiers). That's why I didn't say anything about it. But it may be a
> > caveat to watch out for in the future. Do you think we need to do
> > something about it? A lock would not be necessary, strictly speaking.
>=20
> I would probably start with a comment that describes these pitfalls, I
> wish we had a programmatic way to ensure that these flags would not be
> set dynamically and outside of the probe/setup path but that won't
> happen easily.

A comment is probably good.

> Should we be switching to a bitmask and bitmap helpers to be future proof=
?

We could have done that, and it would certainly raise the awareness a
bit more, but the reason I went with the bit fields at least in the
first place was to reduce the churn in drivers. Otherwise, sure, if
driver changes are on the table for this, we can even discuss about
adding more arguments to dsa_register_switch(). The amount of poking
that drivers do inside struct dsa_switch has grown, and sometimes it's
not even immediately clear which members of that structure are supposed
to be populated by whom and when. We could definitely just tell them to
provide their desired behavior as arguments (vlan_filtering_is_global,
needs_standalone_vlan_filtering, configure_vlan_while_not_filtering,
untag_bridge_pvid, assisted_learning_on_cpu_port, ageing_time_min,
ageing_time_max, phys_mii_mask, num_tx_queues, num_lag_ids, max_num_bridges=
)
and only DSA will update struct dsa_switch, and we could then control
races better that way. But the downside is that we'd have 11 extra
arguments to dsa_register_switch()....=
