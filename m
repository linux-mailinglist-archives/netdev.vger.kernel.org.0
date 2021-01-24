Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A487301DDC
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 18:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbhAXRRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 12:17:37 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbhAXRRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 12:17:35 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OHGNH0015368;
        Sun, 24 Jan 2021 09:16:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=TAPN3ON5Kd5KP4dQYpYhOiBWHGKCgPPTghVpBskJVVs=;
 b=D06CpKb3RhDyT2CCXcsNpMZBLQ1K2j7cs6xg324eAdXpfXXnWNMTij2FHvD9KD6kXGuA
 gGuyHyr/MIEulig30Q+vUar+YeeFTQpDCoSf+a420cz+nZiwTbFXmTcYJQcwJUc5dDoN
 PpYFh6TKBIfINAvDEwLjfjkNdK0f4YIal5EO05+Js1rZ0gY7MTiN6YkceLxh+NRtDkMZ
 LR2s9DTY+YZAtGyy1pmlySJtTd1zI+wQwr0uSL5+h7xW6w3GgHeike5n9bM+Hela67oB
 5GPy6fudeeFqRhoIhJxMYZOZY+xbxkNndDe9F8UejGb30SQDgFBrTIQbPjbekT/xCZm5 qQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6ua81m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 09:16:48 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 09:16:46 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 09:16:46 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.57) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 24 Jan 2021 09:16:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwFP3538KROyluKyTkbGaMJpLBrhMmHLyrzlv3K8vT/IqrSVOlz1tKxIL1p5FBhERETHF1mVfrmGcQlo1h6xBOmVeNl8AKKFqpOpKygjXY23ghuMqxm03/F7JLPsmur9yTcdSnw/QM2RKx1OEp31wg5Dsgq3cVXTRe5/SnCGbh32SMoC3bM2vpq+nkvoGKy0fYmblpe4bPzW+RWgwElLw466QEhjD9tNA+zeui3mfpSOHhOXEDtvHrvKiWNMCHhszP53Tb72hg/YqGZn7u2bd59R9lzm2VK1ltleb9Pp59lJXXeDYrWZJrQ4dgW6wlLHTxgq0Od9gPB9WXMz7uuWdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAPN3ON5Kd5KP4dQYpYhOiBWHGKCgPPTghVpBskJVVs=;
 b=N3YdU5cAS8/mXzl/OuLCjSQ7icajIz2qjADUKfmhnahAOVeClB8DjSY1iB3o4WT5EYY+gEwMZ62OmmNoBhD1HsZ9cxs4u/nljIgPAC7d8iFUh15BvfairMCvAOvyDjq3LEcGp9YKIKZu0YijB0jb7zdBLAKQ5BOByPIWUFnh+mHeKQF7pNGSuPfFtXMRvBu52zoqF3lefPrWE0uAKsiZkE9WlfzjLhYAkQNDo8DNLIz1gluOuCUv8xrlx1CwQPHFzoMfmm3OoiqhmhN6cNgDoa9Dszfel2ycpY/PRpBg1sK8/XbFruScYcOrnoxsL6C/jRDWPkyAxJtwfwmGF3tgDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAPN3ON5Kd5KP4dQYpYhOiBWHGKCgPPTghVpBskJVVs=;
 b=RXQv7MB3DirrR6t54Qr0/p5/hokR7IHf8CEQLEUihB+m+CvzKp4x2IXaPbBJZgKlDFR8yV3t9fuxkT70vs/I5qLGNI/VEP87EsF8lKiQzoSqRnP1cks0oQBvv/PWj23qD72SIIHyFvnP1n3U59XfPtyQfughV4fYHtpFFziXx74=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MW3PR18MB3547.namprd18.prod.outlook.com (2603:10b6:303:2e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Sun, 24 Jan
 2021 17:16:42 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::f5d4:ddf7:7e82:f315]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::f5d4:ddf7:7e82:f315%3]) with mapi id 15.20.3763.018; Sun, 24 Jan 2021
 17:16:41 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Subject: RE: [EXT] Re: [net-next PATCH 3/7] octeontx2-pf: ethtool fec mode
 support
Thread-Topic: [EXT] Re: [net-next PATCH 3/7] octeontx2-pf: ethtool fec mode
 support
Thread-Index: AQHW78qhbWq2R9BK3Uy3kkxbZ9DhMao0oTSAgAJkhJA=
Date:   Sun, 24 Jan 2021 17:16:41 +0000
Message-ID: <MWHPR18MB1421B0E6D74850B6F4535D1FDEBE1@MWHPR18MB1421.namprd18.prod.outlook.com>
References: <1611215609-92301-1-git-send-email-hkelam@marvell.com>
        <1611215609-92301-4-git-send-email-hkelam@marvell.com>
 <20210122202953.59f806c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210122202953.59f806c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [106.217.224.121]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96040d76-9da6-4efd-644e-08d8c08bd163
x-ms-traffictypediagnostic: MW3PR18MB3547:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3547A007BFD3B5F810D78B2DDEBE9@MW3PR18MB3547.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wGKSzxjesNkrioe9EvPXDNajPfK8msLqOiKOLALRLQ1aD0RbUqHaRyF9D+kIy3yNb0kA9GzdCNFBTSPF5asSMDbdIj/a0ioH+DkCo+JEx2gVCDraNSPBO12m5dSld18+imTezgh9DpSm6Pv+3WX80schw0lXkZ9kIELzMLNEafjIrDn8/Jtkp/dASfVleJUKJgmi0xVLkp/QVIV9dIkIwLrmVxFGjNHwNvFzalGw6kQf1Ue76cxcJ7yfp9znNZwNIgjhige0knrhw3lHU+iZ8gCldPh+mFBPhy7D0uVtNas7UWak8Yq4IAbwDgxAmeCwtZ11pfYlFOqnsPJAAp4dePepgI0uyqp4Xiz0MH6crwWemG8EzKYdS7CmnKKmznLMX/XAUH4iXsn3KIM2MIGmNlU9FftCWK19X9XVDuSwOF+S4UeggWvP/cxWVygKNrS3ykgt3HzsT8DuAha2mMqFAOPQquWT5QpyuF36tBGHZFNB/hXoSOSDpcbb9rS42yKz1M2Y6hdR6ys5Ez8UDu8t/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(8676002)(53546011)(6506007)(76116006)(7696005)(6916009)(52536014)(86362001)(54906003)(5660300002)(4326008)(478600001)(2906002)(107886003)(55016002)(316002)(186003)(33656002)(66446008)(26005)(9686003)(8936002)(83380400001)(66476007)(66946007)(66556008)(64756008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gYq8GWD2TFKUiW7PjHHw4d9KQ6CXOhqarKC6xUJf7TjLclp0q79jKIuk7EBP?=
 =?us-ascii?Q?5YulH3keAymIXaUmDOqaU5v7aDy/Fp0c+M1cFOzHQsemAi3Zj10utIHlTRRB?=
 =?us-ascii?Q?xVE3ce4MkJDnrwPV2Q78SUY+lRNPM/neH52cgx3Zsuu5GewPAOBm6CvIcYA3?=
 =?us-ascii?Q?jiAiAZryvuOiFgfeUR7tkndatf3GEP8sMtd6WkOA2uM1LVO+r/mI53NUl8Te?=
 =?us-ascii?Q?8mIIsxwXGaK2JhhjToykO8wliWYyhMjVqzryIKF53q/hPi3jyqnsytfYwKfV?=
 =?us-ascii?Q?KiKc3czlX+hqnBvG8g/Efa67WhUGTDDNIhgCqMz5KHep9pvnOrsk1PYrO+1d?=
 =?us-ascii?Q?1A9e7YD1Juse/LH/Am7nRcfWFC1bNUHY/Na9A1aHQ0FqYufna17mBlKyZJvI?=
 =?us-ascii?Q?zo+cXn5Rs1fH7FPNo01cE/6NAFJEYffcfe+SckaCHBp2DqaC9is2bEQlIbLP?=
 =?us-ascii?Q?7lbDV+GoJ9gzJvNHHsFKRD7kLGAwGMJvgpOBLFFoGN8IHIbEZQEaUzi+eCGJ?=
 =?us-ascii?Q?Y60C5Kr3narlH9HhSc1G8NxSj8rW0FE5BIiWEfsXYzj2CcquhOQBJueD9lIz?=
 =?us-ascii?Q?Q7n9gcGPSRH7C3IN1LZEauw5Sl3cb9MGS4AVkWYFg66eAO6J2WJwczOxfDT7?=
 =?us-ascii?Q?iqe2kjGvFApIE8hnh2gWGT4kaO4YLsSrmjl7hZKQiVlyOF90jTctE76BbrLr?=
 =?us-ascii?Q?qGEVU0ax3L75dfa5PgeYdbVtGZNj5aibL5oaJ2hwJYCEur7UV3LulDh2Qa1U?=
 =?us-ascii?Q?7iMGdQTyEaZ6qQ38Z2l8IdE8YXYbutxcWvieADphUI1fC040C/jBUkGuhNrD?=
 =?us-ascii?Q?n7wjIAcF2H/Z6RoduS5NCx6yFzrJ0W88VLWf6GEFYRyYECxN8ZJ9hKwIAKiW?=
 =?us-ascii?Q?ASVKxaqqMLhyAFvTkogla0rMRUgxk42XYPgPakGNrvsyiuOevZJaJowZn8k9?=
 =?us-ascii?Q?TriIjTne/i0hKPAk9HkjzwylWykLUQTVCQ8YIPqnL9LmVF+DPw1RSS+jQfQU?=
 =?us-ascii?Q?fQ2biGKi38DriIvhMhHf0zrhCLDRBJSU+5zQNcxE0z/zqQI+LZfdG675n9bx?=
 =?us-ascii?Q?Tk9VLTq/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96040d76-9da6-4efd-644e-08d8c08bd163
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 17:16:41.7484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QDNe5kmrHhH39iYAFffhrGKLoIjz1T9IV2H63vBQTit70yD7TREnmUALEr9KXRY8OEzctKiSisluQA0BD+fDlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3547
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-24_06:2021-01-22,2021-01-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, January 23, 2021 10:00 AM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Christina Jacob
> <cjacob@marvell.com>
> Subject: [EXT] Re: [net-next PATCH 3/7] octeontx2-pf: ethtool fec mode
> support
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Thu, 21 Jan 2021 13:23:25 +0530 Hariprasad Kelam wrote:
> > From: Christina Jacob <cjacob@marvell.com>
> >
> > Add ethtool support to configure fec modes baser/rs and support to
> > fecth FEC stats from CGX as well PHY.
> >
> > Configure fec mode
> > 	- ethtool --set-fec eth0 encoding rs/baser/off/auto Query fec mode
> > 	- ethtool --show-fec eth0
> >
> > Signed-off-by: Christina Jacob <cjacob@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > ---
> >  .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  23 +++
> >  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 174
> ++++++++++++++++++++-
> >  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
> >  4 files changed, 204 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > index bdfa2e2..d09119b 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > @@ -60,6 +60,22 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf)
> >  	mutex_unlock(&pfvf->mbox.lock);
> >  }
> >
> > +void otx2_update_lmac_fec_stats(struct otx2_nic *pfvf) {
> > +	struct msg_req *req;
> > +
> > +	if (!netif_running(pfvf->netdev))
> > +		return;
> > +	mutex_lock(&pfvf->mbox.lock);
> > +	req =3D otx2_mbox_alloc_msg_cgx_fec_stats(&pfvf->mbox);
> > +	if (!req) {
> > +		mutex_unlock(&pfvf->mbox.lock);
> > +		return;
> > +	}
> > +	otx2_sync_mbox_msg(&pfvf->mbox);
> > +	mutex_unlock(&pfvf->mbox.lock);
> > +}
> > +
> >  int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx)  {
> >  	struct otx2_rcv_queue *rq =3D &pfvf->qset.rq[qidx]; @@ -1491,6
> > +1507,13 @@ void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
> >  		pfvf->hw.cgx_tx_stats[id] =3D rsp->tx_stats[id];  }
> >
> > +void mbox_handler_cgx_fec_stats(struct otx2_nic *pfvf,
> > +				struct cgx_fec_stats_rsp *rsp)
> > +{
> > +		pfvf->hw.cgx_fec_corr_blks +=3D rsp->fec_corr_blks;
> > +		pfvf->hw.cgx_fec_uncorr_blks +=3D rsp->fec_uncorr_blks;
>=20
> double indented
>=20
I will fix this in V2.
> > +}
> > +
> >  void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
> >  				  struct nix_txsch_alloc_rsp *rsp)  {
>=20
> > @@ -183,12 +210,42 @@ static void otx2_get_ethtool_stats(struct
> net_device *netdev,
> >  	for (stat =3D 0; stat < CGX_TX_STATS_COUNT; stat++)
> >  		*(data++) =3D pfvf->hw.cgx_tx_stats[stat];
> >  	*(data++) =3D pfvf->reset_count;
> > +
> > +	if (pfvf->linfo.fec =3D=3D OTX2_FEC_NONE)
> > +		return;
>=20
> Don't hide the stats based on configuration.
> Getting number of stats and requesting them are two different syscalls.
>=20
Agreed .  While getting number of stats also  , check is there to ensure in=
terface=20
Has valid fec mode.=20
	if (pfvf->linfo.fec) {
                sprintf(data, "Fec Corrected Errors: ");
These checks ensures number of stats and request them are in sync.

> > +	fec_corr_blks =3D pfvf->hw.cgx_fec_corr_blks;
> > +	fec_uncorr_blks =3D pfvf->hw.cgx_fec_uncorr_blks;
> > +
> > +	rsp =3D otx2_get_fwdata(pfvf);
> > +	if (!IS_ERR(rsp) && rsp->fwdata.phy.misc.has_fec_stats &&
> > +	    !otx2_get_phy_fec_stats(pfvf)) {
> > +		/* Fetch fwdata again because it's been recently populated
> with
> > +		 * latest PHY FEC stats.
> > +		 */
> > +		rsp =3D otx2_get_fwdata(pfvf);
> > +		if (!IS_ERR(rsp)) {
> > +			struct fec_stats_s *p =3D &rsp->fwdata.phy.fec_stats;
> > +
> > +			if (pfvf->linfo.fec =3D=3D OTX2_FEC_BASER) {
> > +				fec_corr_blks   =3D p->brfec_corr_blks;
> > +				fec_uncorr_blks =3D p->brfec_uncorr_blks;
> > +			} else {
> > +				fec_corr_blks   =3D p->rsfec_corr_cws;
> > +				fec_uncorr_blks =3D p->rsfec_uncorr_cws;
> > +			}
> > +		}
> > +	}
> > +
> > +	*(data++) =3D fec_corr_blks;
> > +	*(data++) =3D fec_uncorr_blks;
> >  }
>=20
> > +static int otx2_get_fecparam(struct net_device *netdev,
> > +			     struct ethtool_fecparam *fecparam) {
> > +	struct otx2_nic *pfvf =3D netdev_priv(netdev);
> > +	struct cgx_fw_data *rsp;
> > +	int fec[] =3D {
>=20
> const
>
Will fix in V2.
=20
> > +		ETHTOOL_FEC_OFF,
> > +		ETHTOOL_FEC_BASER,
> > +		ETHTOOL_FEC_RS,
> > +		ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS}; #define
> FEC_MAX_INDEX 3
> > +	if (pfvf->linfo.fec < FEC_MAX_INDEX)
> > +		fecparam->active_fec =3D fec[pfvf->linfo.fec];
> > +
> > +	rsp =3D otx2_get_fwdata(pfvf);
> > +	if (IS_ERR(rsp))
> > +		return PTR_ERR(rsp);
> > +
> > +	if (rsp->fwdata.supported_fec <=3D FEC_MAX_INDEX) {
> > +		if (!rsp->fwdata.supported_fec)
> > +			fecparam->fec =3D ETHTOOL_FEC_NONE;
> > +		else
> > +			fecparam->fec =3D fec[rsp->fwdata.supported_fec];
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int otx2_set_fecparam(struct net_device *netdev,
> > +			     struct ethtool_fecparam *fecparam) {
> > +	struct otx2_nic *pfvf =3D netdev_priv(netdev);
> > +	struct mbox *mbox =3D &pfvf->mbox;
> > +	struct fec_mode *req, *rsp;
> > +	int err =3D 0, fec =3D 0;
> > +
> > +	switch (fecparam->fec) {
> > +	case ETHTOOL_FEC_OFF:
> > +		fec =3D OTX2_FEC_NONE;
> > +		break;
> > +	case ETHTOOL_FEC_RS:
> > +		fec =3D OTX2_FEC_RS;
> > +		break;
> > +	case ETHTOOL_FEC_BASER:
> > +		fec =3D OTX2_FEC_BASER;
> > +		break;
> > +	default:
> > +		fec =3D OTX2_FEC_NONE;
>=20
> IIRC fecparam->fec is a bitmask, you can't assume other than one bit set =
is
> NONE.
Agreed . Will fix in V2.
>=20
> > +		break;
> > +	}
> > +
> > +	if (fec =3D=3D pfvf->linfo.fec)
> > +		return 0;
> > +
> > +	mutex_lock(&mbox->lock);
> > +	req =3D otx2_mbox_alloc_msg_cgx_set_fec_param(&pfvf->mbox);
> > +	if (!req) {
> > +		err =3D -EAGAIN;
>=20
> Why -EAGAIN? When does msg allocation fail?
>=20
Agreed . Message allocation fails incase No memory. Will fix this in V2.
> > +		goto end;
> > +	}
> > +	req->fec =3D fec;
> > +	err =3D otx2_sync_mbox_msg(&pfvf->mbox);
> > +	if (err)
> > +		goto end;
> > +
> > +	rsp =3D (struct fec_mode *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
> > +						   0, &req->hdr);
> > +	if (rsp->fec >=3D 0) {
> > +		pfvf->linfo.fec =3D rsp->fec;
> > +		pfvf->hw.cgx_fec_corr_blks =3D 0;
> > +		pfvf->hw.cgx_fec_uncorr_blks =3D 0;
>=20
> Are you clearing stats every time FEC changes?
>=20
Netdev driver gets fec stats from firmware. When user changes fec mode , co=
unters local
To netdev driver becomes stale. So clearing fec counters.
> > +
>=20
> spurious new line
>=20
Will fix in v2.
> > +	} else {
> > +		err =3D rsp->fec;
> > +	}
> > +
> > +end:	mutex_unlock(&mbox->lock);
>=20
> label on a separate line
>=20
Will fix in v2.

Thanks,
Hariprasad k
> > +	return err;
> > +}
