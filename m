Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F365F41486E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 14:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbhIVMHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 08:07:30 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:9665
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235848AbhIVMH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 08:07:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYmdgyN0UvX8YwYo6J83Kuw5GmzBSYjTLoRibG1+j/nr8woxrwNcWsHqISTBC+XbLRs6ZTxn9yQz8TrlWop9it5Qd60BG/4tDXYE51yHsa/2hr79mXW7RPTgRy3ewlP6j5kDPszFzkPfVML4xSXKlt7XtznlBe51+TZnKYY1nxoyvGtXT4Vf+SWR+3S64BdIj4Gxz9eMeDg7Gv8nZvlpNFlZfRjTxEGzTwfAfZ35aLzryjG7dWu+h4z6mMUoaS2lbIxsHhWwN1D7CXO8IuGXJi6qMIg9q/l1rQKeepqgaPoHodQF5T1phknprNulg/ul3k7kHq5aFSg9+Mv3Z9xcHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=deVywolXlaaLH0WF00ihHBcmIxGUFalxWq56bkqI1Ws=;
 b=UOFy8i/Jn2rslbsYCQCQtxG6AInOFNvvbQmvW3E4o5UdX9ybOlc5M0Tvs7oqdrbXA0lj4t/jnJuu/xV3lGYN3UmJ4JeMUCCKzW3Pm9c7sHb17BtJntzVNj5EUxhbbKvMn9/rvajD6jXNth4GL2jzxoOIb1qEAr4HOsX5aBVK9/vbFRq1BCQAcshYnwqmU3gZy3EPZzP0bRUtHFL885rq1O5S1oPz6w99j29Os+Pdhi2ZRHmOBrpYvyA+1xMSTWyF2rbXWvfmey7PV5DqPV53yXqWk0Wb8mdc8k0yOH0bWCEw4lwuYUX7MbJ9w3pXb7LDfHM2dsGJgm85Tm50ThBTgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deVywolXlaaLH0WF00ihHBcmIxGUFalxWq56bkqI1Ws=;
 b=di+0ksp+55yOuwig6asKXdSfDoRay7mnWTYE4Sf3kNpoEt6UzV7di4kWGj88MUzJQYvRkVwIIPsDc+HBtzsLWpFmJpERoMCDXP0LesIOLtVQFqF1KH0p/DrgWo/sEjNPWViYhNLLkWpx0A8mrGi2MMbT/JslkjvHPMCJFIjvsfY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6016.eurprd04.prod.outlook.com (2603:10a6:803:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 12:05:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 12:05:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v1] devlink: Make devlink_register to be void
Thread-Topic: [PATCH net-next v1] devlink: Make devlink_register to be void
Thread-Index: AQHXr4/5/7WopBFyz0yuv7is/btj16uv9USA
Date:   Wed, 22 Sep 2021 12:05:56 +0000
Message-ID: <20210922120555.lwjggkl2zsxra64x@skbuf>
References: <311a6c7e74ad612474446890a12c9d310b9507ed.1632300324.git.leonro@nvidia.com>
In-Reply-To: <311a6c7e74ad612474446890a12c9d310b9507ed.1632300324.git.leonro@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a457cf6-a020-44ab-fb65-08d97dc15547
x-ms-traffictypediagnostic: VI1PR04MB6016:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB601602919F1BD343ED9FAF3DE0A29@VI1PR04MB6016.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m75Y/W6lEPzMir4A7hSNN59S0+vjPXcZ1dnSFd7rcjnmHygfI6TjcGIxj2mwxOLYUofVj/OfAkl1mJ4B98Fld1z6UFWHKsGyxpU0Qw2r6b8iGRTOkPye4YpDhtuWI4fL/CAgweVftZQWWK2a7id2fjUX8OfgiOVawll9aJhSg8kgB14fAIBUBTcHEOFDFid3IHE/c0v0lB4DSBxngnMGtP8wPBrrtR/csnWdhhURIJAv8V8K3lQ1hYWm9WlSAEy29IsyxdwSrMxDyMBcnnO8LPihMCw+uNbifDeOB61kDBifzdZ0lHGCMUfc0l4uNOZ7N6eZyIBDOoIHQaJW23ltzlTLQUKJIdFXk8Px1BWjwzEkHl61FHAPizLSN/ewhdYzS34PdVwbKpbH0vp0N7j4Yy/jSwJ62EOngkkq3kbf2TwgA/KjhRhFWoswK+tHs536Kpwin4w64s/rNNM2t7IPVGk8O/raj1xFWyCZlcGYVrgcMwoJ/RiPEKmZVjgcAU/FV9Rfs9r7/mymwbtIgtL6cNPNu7Zr2y0DhsYZlp2a9UnJ8ubl3nLLUTk0vd79L4V7HLfFyKIqMI8vhY8rNw1vFuB+GleLhlKbdJNT9AldzVzehiFQJok4o0C5agxWpyDu6QkA1YK5cvyS+vFfJoVXPLtTl4uL0qCQA7Yxp5A0qS6YQqfas2Shim8jAIXyKKVW+jtOwv34BV1jjpgxfTMAUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(86362001)(8676002)(71200400001)(9686003)(54906003)(6512007)(7366002)(7416002)(1076003)(4744005)(26005)(6486002)(508600001)(7406005)(5660300002)(33716001)(122000001)(66476007)(4326008)(64756008)(6916009)(8936002)(66946007)(44832011)(316002)(76116006)(186003)(6506007)(91956017)(66446008)(66556008)(38100700002)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z/PmZ4ghcNs4f16IKRam9L5ePkB4zJQvzOOXnKVNfzMrFlMF0IsZaZWekdoV?=
 =?us-ascii?Q?eum5qIdSXv4mOJGQqxUB7hBbW0i27QbezR6ZfOUg3hwce8MIunHhkoS5u2W+?=
 =?us-ascii?Q?9zpds3D9dXxiCeu/S0cTyz48o99xpmtyExfwubyk5FzB8NrlFXMk6OJZ5YHw?=
 =?us-ascii?Q?2zasrjaYTSEWbTeEb5bs2Fa2lCKfw4tAbS0AMrhwwO81JZEoDZiqy1qf632z?=
 =?us-ascii?Q?0AyxG9LtsVV3uGzazSEqRseRV8/Almvv+THx4wjb51ElJK67mhCp9jtwXLz+?=
 =?us-ascii?Q?r3F6frBYLYlzTmRF3XRlNcelJmHKsTOmiyWtNkjgPJIKdSTkcPyWV+P4AKUj?=
 =?us-ascii?Q?IuMaV2ZjNsraU5lV0BwYEywVjgCdFyRq3fA4HpD5DNQ+2AtWEpfBDNLKxl0k?=
 =?us-ascii?Q?J0kDvysLx8+C2l8o5bR1iWmdsrOFiso/4Hb13NNoe/OwUmfQF5S0vWwc4bjX?=
 =?us-ascii?Q?nDRlzRol/l982WnKFGNmgzQ+rubC6bgumi/ZRdKpuZ7f0zleOOVR+X+64kZW?=
 =?us-ascii?Q?9KNa6NB5Eyb/BLQjbh/FAC4TFEIa6Pjk+CirmiKVFJed1phLorlPbULvpDBO?=
 =?us-ascii?Q?FN189Q1+7kolI5RFk3mdEnocj/F6Fe3iua1rMUxgsNfV7mdizyVIhPEus4IL?=
 =?us-ascii?Q?77XenTE/KmYcaIgU6wZVqnCbY0JK3fu0LMDTT4+yH3VK2qJJYllhkR2Dd2NS?=
 =?us-ascii?Q?2I38YsovipWbEgifrer/tvhJIRPKL2ssHLyJXf3Zk/byl/eeTkib4gOZQA1x?=
 =?us-ascii?Q?tAbw6cZbbYitK7RbwyCZv/RBY46tQ1GMQ43pXLW/pxovTUSAEX5livnChaF/?=
 =?us-ascii?Q?bQzySMToinzNEiFA+5qjUAco6Fr0r5uCXctKaliobx8sZub7HMNlZdoAlcRW?=
 =?us-ascii?Q?2cB5dRKFTOKuj634kjd63Mzhzt4Ey/ha8Zj0Lr6m+UuRTOl2BxMeg2bemnNP?=
 =?us-ascii?Q?bG5iQyU38Q5BUCsDsOD7yiLZX1yBAxFbs3ux7Tl34hbPRErvkrLraTEbGgoU?=
 =?us-ascii?Q?xH5Nozlg6kitlYwGkH2bVXiqDoNqrVsh/dwRMJQsAEVvpNdFCRGCI/e/LH0L?=
 =?us-ascii?Q?3Uah3xOfVug3Z65eE+idNT5B+jxKbc+dZz6BFwaBJ31p19kRZtXgc68tCt5l?=
 =?us-ascii?Q?0c/SQVc0Pa61tely3ElZOxHjM2fHdfmFeZEhmynLL6D0BdXCrdfcsS3doF0z?=
 =?us-ascii?Q?ycVYFWNqNryWiumFx3S5DJNXZQWdrtKIVLKehIUzf6fGT++i6iUBnuoQSOLx?=
 =?us-ascii?Q?pJPUEgsThgO5eWoBYc8x6/hx7b6qKPXkXANdibSsngnNBdhb71l2tFJVA2hB?=
 =?us-ascii?Q?2pm9M3UzHuUMJid0eBzJGA5G?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EE740D3424700B44846654A5F7FE8BF1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a457cf6-a020-44ab-fb65-08d97dc15547
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 12:05:56.1697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AukOysOPYmr0lSIG0Da7CoZVTKhwM6KYBD6xxx+oKHXxH5IWy5+e6ySq6PirV7draML2qoX1QrnuZruLulVg4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 11:58:03AM +0300, Leon Romanovsky wrote:
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index eef13cd20f19..96f211f52ac3 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -804,10 +804,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	dl_priv =3D devlink_priv(ds->devlink);
>  	dl_priv->ds =3D ds;
> =20
> -	err =3D devlink_register(ds->devlink);
> -	if (err)
> -		goto free_devlink;
> -
> +	devlink_register(ds->devlink);
>  	/* Setup devlink port instances now, so that the switch
>  	 * setup() can register regions etc, against the ports
>  	 */
> @@ -863,10 +860,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  		if (dp->ds =3D=3D ds)
>  			dsa_port_devlink_teardown(dp);
>  	devlink_unregister(ds->devlink);
> -free_devlink:
>  	devlink_free(ds->devlink);
>  	ds->devlink =3D NULL;
> -
>  	return err;
>  }

Acked-by: Vladimir Oltean <olteanv@gmail.com> # dsa=
