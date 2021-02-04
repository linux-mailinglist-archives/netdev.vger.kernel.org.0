Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CF630F9F1
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbhBDRkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:40:01 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16488 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238689AbhBDRih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 12:38:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114HPMTm004870;
        Thu, 4 Feb 2021 09:37:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=F51hDUENcwIiHCILvK5IqvqaIiNjPkpuOg/BOpgZSFY=;
 b=R38iTeEsidwBzwJiCssgvOuO0hT8BMuk72k1qLrfu2QXJFufVrUNumTrl93mbiI6AJnR
 lt3lIulS9Vdkpr5moqplZqP+0CvrUtq5+xwxAAaxFFOJ/c/OVYcVvE49A/0IqAu4eNx7
 9muZ9dh0YDw7PZXaKKumgG/tR8KXPa8f2FSfi5QQMSdgbKlymPx9wfCx93K68lpoEwfW
 DqNw8T5eoTsqgQ+x7SAcHf3yeqB3zmeXnkMBzpWRI1XnVhoQiW8t17ARn6ZJM5cxxb+P
 QRLSrPTXYl301rqVqGQ9ynX3H9tG6Bh3dAVblsP6XGt/3j6Zs7FLy8zalC59IBekb4Jp 0g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36gg1t1c81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 09:37:44 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Feb
 2021 09:37:43 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Feb
 2021 09:37:42 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 4 Feb 2021 09:37:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTk2lBEFH4i6igtsRBBOmc654GuCb7acR0D+mbCsMQcWfKbYkyYvq2b9TyxpnABgtmv17MRJUSAjVJ/2k7hQ62ygW+ckyS7zQkMRvE93HdY+3ydm3cje2dom5+9vxgTevl/uYrrWpmFhXFDf+WRzEmChWhrlY3S0wGq/P9MX9E/rgirogM2CplrR3PDxCaNzXjviRVajC5KlS21qhto59XmR/b4gyTk34lgunryKywb0vOxFjuXhOtFeWOGdrv1WaivORd6IgwAga36P1QzaiAZMlWP+WpAHHS3yHY8cBk1L1OWRC9D3sszdN9PJaq00xRkjbgvoQMGggacB1bAfMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F51hDUENcwIiHCILvK5IqvqaIiNjPkpuOg/BOpgZSFY=;
 b=GehVun8r2Cy4xcPvRrRJcRE3nZXsg+zgWULMsQKCMhdTy2WOAWDg/YVNetGUgcRWKVlqmEXPjAN7J9NCrtoAcI1Suymv9+drgY/48B/mCieeSbf24BayNUI85Ve4JWVVzg9Uyz0FfPZ3PJaZFbhkfLIeSBhSzgXBfRkVBq9rOs4fGCGEnXWWL6XEUucw3JGXMbmZOKZp6tJqijcIQEdZ+dJGX1jrSuCeKAKGj9Yv69o6cnvb6SmpCZ8++P7Fq4vkB55fe35uy68Mp5xo6uGKl1a0az6J7FZOzYpNAUJv/0rRbwPCLUPVgQSvI07l2KACTvFegkXx63fpOVucuhbyTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F51hDUENcwIiHCILvK5IqvqaIiNjPkpuOg/BOpgZSFY=;
 b=qgoPnq3IW2tC56V0Z5MWw/904+q0DZQokeWDtiDGEoykDwYVK0GoqEk3Zw9L+aTZfjDbp9iyfbxgFA0qbZtlt5ekmWmhJUhhan+fR/w6SemZjHjVT/GiQmyvoWP5wV0LxGaNAfO9SqPg3jHLV/3AR8ktcATAtG1qld73YA8H+aY=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by CO6PR18MB3938.namprd18.prod.outlook.com (2603:10b6:5:350::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Thu, 4 Feb
 2021 17:37:42 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3825.020; Thu, 4 Feb 2021
 17:37:41 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical link
 configuration
Thread-Topic: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical link
 configuration
Thread-Index: Adb7GrFbqvMxRsGhRYGxDzuFoB4Y/w==
Date:   Thu, 4 Feb 2021 17:37:41 +0000
Message-ID: <MWHPR18MB142117DBE8659D68794E18D3DEB39@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.206.234.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63c4afe3-3c91-4b4a-7a48-08d8c93392f6
x-ms-traffictypediagnostic: CO6PR18MB3938:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB39383BC23F9E0416200DF731DEB39@CO6PR18MB3938.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bliP/B2b9XMM/fgNlQhPW4XXlNFil7Dy/0ijxQWBatw+9gsFU2BJSKEbccpRMbLgQsZVbglKBkKfET0/3IZ4yEEOt/nEhCW/BMDxwIBwYaYpSkElSbBd+bFzExjeqZyfAl84Yn2/uCoiHV1QD7/8rT0l6+vOBkcWltzpTzMJS/XfESnrAiYZxdYV8lECSxRZK/3VHwZbx/rdTJLtDqA+tmmmKPJBfNnVzrVwKYcGTFcMq+rkSB6Pb19neebNnnxV1gaufkzORhBgxEg5cJLfeQbhiB5JjBwA8JnK8gIfAoLF+272vvtB+ekwJuOrq6LBWD6nevg3+3T33odiC+9Jy7O51yDYtsGRD//82e44AGxjuUGX9XsrjFoy3a62mKRmQxs3STNI4+ek9yaCDb9jCE7kVISvaNZxb1QMHgcirQx6W2AoGr37Oy/DyChcLJSenK8UmHa6sEt7hNFYNbKoOWHxp2V9fZnstgG09ec1qkCvbvhpqzDyJ1m50AqGq3pJlGpy4EekSea7tY3EUhjbDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(6506007)(86362001)(53546011)(71200400001)(66556008)(7696005)(64756008)(66446008)(66946007)(4326008)(2906002)(107886003)(9686003)(8676002)(478600001)(6916009)(83380400001)(54906003)(316002)(33656002)(55016002)(52536014)(186003)(5660300002)(26005)(76116006)(66476007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xEQ8rfuTTVoCR9cJqJxsanrvQtCSyM1Mui8oOguQlH2R4vfBkkZXWcdzxGmFjRTC4vWr+mxAj87Ktfn/2Bku5Wc0Vbx5KA7TdHOQ0UsJAHWtylqgRmy0XEk7oWiIvY1c/WAHdj7e4Bp2c5hthdmWGyZkksXfUMJk1YYyBxckBkeoxEe1U4TtpLbi59UXowKiUBaa3SXcYqZszWq0t2qegel5xNbmUaOPN1O1nfFYauk9ntCG5ZkbhOUv34w34u4hvbh5xDmqxwd+nOX/VOMaeyWW1Ky83JopjocX6hckCR1npOOY3h+r1h0RV0IPRf4DoepP9c/nDDh2FbJB66bkIOt1ofC3X+/Xvikwkl3zpSWIIRhfj1JCOXobliMSRgBSaj6Y4K9RNnLmvMLFj/wTiJMNSsdqHtoCKSfqO/qlm5Mesk5ghXx8dG4EEpDsZVkNsS8zAbvJ0WIhpcSy2AOg8YrJQyupqlL+WUS2wMR+MTrjQBG99Dl9ZoUE73otL50EmVSkf2WyDiGdMhyzb/NLhEjqBXi4lWYFe5ZF0GFBkXwWsjYkbCTz6uCRw31rDqVb+Yy4Emb+AYic6NfUipkqJmOfCGjBzJCKRUj9QcgJ5CfflXVsJX2lNY9LmkMH6I/LsCQwdiC511yGCcZ24MvexF2As7Hl2eGPtC0zNdbsg12U3YMpCAyYuOURXf57jIewxdDxRSeqTq9yvBjMXFoK7tssarhg3iRu0e9OEiR+ajkz2rxgWYnNwiUtA+xl/jVo
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c4afe3-3c91-4b4a-7a48-08d8c93392f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 17:37:41.7447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xs91Tpms5eqF6bdMSJ8v058NgAtcKaUGKr1j10FBB3qi5zU38IRf966sZDXzolQarv8+ap8SD73c9d95MsVO1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3938
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_09:2021-02-04,2021-02-04 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,


> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, February 3, 2021 6:59 AM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; willemdebruijn.kernel@gmail.com;
> andrew@lunn.ch; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Linu
> Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: [EXT] Re: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical=
 link
> configuration
>=20
> On Sun, 31 Jan 2021 18:41:05 +0530 Hariprasad Kelam wrote:
> > From: Christina Jacob <cjacob@marvell.com>
> >
> > Register set_link_ksetting callback with driver such that link
> > configurations parameters like advertised mode,speed, duplex and
> > autoneg can be configured.
> >
> > below command
> > ethtool -s eth0 advertise 0x1 speed 10 duplex full autoneg on
> >
> > Signed-off-by: Christina Jacob <cjacob@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > ---
> >  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 67
> > ++++++++++++++++++++++
> >  1 file changed, 67 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > index d637815..74a62de 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > @@ -1170,6 +1170,72 @@ static int otx2_get_link_ksettings(struct
> net_device *netdev,
> >  	return 0;
> >  }
> >
> > +static void otx2_get_advertised_mode(const struct ethtool_link_ksettin=
gs
> *cmd,
> > +				     u64 *mode)
> > +{
> > +	u32 bit_pos;
> > +
> > +	/* Firmware does not support requesting multiple advertised modes
> > +	 * return first set bit
> > +	 */
> > +	bit_pos =3D find_first_bit(cmd->link_modes.advertising,
> > +				 __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +	if (bit_pos !=3D __ETHTOOL_LINK_MODE_MASK_NBITS)
> > +		*mode =3D bit_pos;
> > +}
> > +
> > +static int otx2_set_link_ksettings(struct net_device *netdev,
> > +				   const struct ethtool_link_ksettings *cmd) {
> > +	struct otx2_nic *pf =3D netdev_priv(netdev);
> > +	struct ethtool_link_ksettings req_ks;
> > +	struct ethtool_link_ksettings cur_ks;
> > +	struct cgx_set_link_mode_req *req;
> > +	struct mbox *mbox =3D &pf->mbox;
> > +	int err =3D 0;
> > +
> > +	/* save requested link settings */
> > +	memcpy(&req_ks, cmd, sizeof(struct ethtool_link_ksettings));
>=20
> Why do you make this copy? The comment above does not help at all.
>=20
Agreed copy is not necessary . Added this copy for comparing advertised mod=
es with supported modes.
Will fix this in next version.

> > +	memset(&cur_ks, 0, sizeof(struct ethtool_link_ksettings));
> > +
> > +	if (!ethtool_validate_speed(cmd->base.speed) ||
> > +	    !ethtool_validate_duplex(cmd->base.duplex))
> > +		return -EINVAL;
> > +
> > +	if (cmd->base.autoneg !=3D AUTONEG_ENABLE &&
> > +	    cmd->base.autoneg !=3D AUTONEG_DISABLE)
> > +		return -EINVAL;
> > +
> > +	otx2_get_link_ksettings(netdev, &cur_ks);
> > +
> > +	/* Check requested modes against supported modes by hardware */
> > +	if (!bitmap_subset(req_ks.link_modes.advertising,
> > +			   cur_ks.link_modes.supported,
> > +			   __ETHTOOL_LINK_MODE_MASK_NBITS))
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&mbox->lock);
> > +	req =3D otx2_mbox_alloc_msg_cgx_set_link_mode(&pf->mbox);
> > +	if (!req) {
> > +		err =3D -ENOMEM;
> > +		goto end;
> > +	}
> > +
> > +	req->args.speed =3D req_ks.base.speed;
> > +	/* firmware expects 1 for half duplex and 0 for full duplex
> > +	 * hence inverting
> > +	 */
> > +	req->args.duplex =3D req_ks.base.duplex ^ 0x1;
> > +	req->args.an =3D req_ks.base.autoneg;
> > +	otx2_get_advertised_mode(&req_ks, &req->args.mode);
>=20
> But that only returns the first bit set. What does the device actually do=
? What
> if the user cleared a middle bit?
>=20
This is initial patch series to support advertised modes. Current firmware =
design is such that
It can handle only one advertised mode. Due to this limitation we are alway=
s checking
The first set bit in advertised modes and passing it to firmware.
Will add multi advertised mode support in near future.

Thanks,
Hariprasad k


> > +	err =3D otx2_sync_mbox_msg(&pf->mbox);
> > +end:
> > +	mutex_unlock(&mbox->lock);
> > +	return err;
> > +}
> > +
> >  static const struct ethtool_ops otx2_ethtool_ops =3D {
> >  	.supported_coalesce_params =3D ETHTOOL_COALESCE_USECS |
> >  				     ETHTOOL_COALESCE_MAX_FRAMES, @@
> -1200,6 +1266,7 @@ static
> > const struct ethtool_ops otx2_ethtool_ops =3D {
> >  	.get_fecparam		=3D otx2_get_fecparam,
> >  	.set_fecparam		=3D otx2_set_fecparam,
> >  	.get_link_ksettings     =3D otx2_get_link_ksettings,
> > +	.set_link_ksettings     =3D otx2_set_link_ksettings,
> >  };
> >
> >  void otx2_set_ethtool_ops(struct net_device *netdev)

