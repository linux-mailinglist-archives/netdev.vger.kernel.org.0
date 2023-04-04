Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08E26D6743
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbjDDP16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjDDP15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:27:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EEC4491;
        Tue,  4 Apr 2023 08:27:56 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334EgTuB004246;
        Tue, 4 Apr 2023 15:27:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=O9XrjVx+x40QVB09UmyJ8DMy2DCEub230J9/Ih3XMtA=;
 b=tl4hrMf8ebrGfBvICt3Wwk/AeYdLJ7zjc3HUMt0i4bbLfJRe+uRdGpW37llSj/0zhLSe
 hvL1eiJsCQpMpNFjL6C+er+YLe5n8ITbwT60aJGXLp+FwAhHyyDyqD55Q3bERn+oBQFf
 NIM8sks4X6wF164LyIdAeKHxTvCgOjprbPiiUNRtC3TCC2gmrFn304eSzE+xRwy++XkJ
 9sM+67qceVabiVNFbguOSkZzWuSCfhttDIAYRLUE3tBKBi6VYnaTNHVOZ7jiK2aOQH3E
 K1gkrH285OQjmte2wG3P5TMCgcIVQULKpa63Cjj2Cqlmjh5IDTUJ0E7KSd8zuR/7UcYL SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prmh4mupe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 15:27:42 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334FGxbb012836;
        Tue, 4 Apr 2023 15:27:42 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prmh4munj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 15:27:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341lc4m023645;
        Tue, 4 Apr 2023 15:27:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2m91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 15:27:39 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334FRa1N47317518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 15:27:36 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 489F72004B;
        Tue,  4 Apr 2023 15:27:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC8A520040;
        Tue,  4 Apr 2023 15:27:35 +0000 (GMT)
Received: from [9.155.211.163] (unknown [9.155.211.163])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 15:27:35 +0000 (GMT)
Message-ID: <a25455eac6a02eeb9710d9204dfe0b91938f61a1.camel@linux.ibm.com>
Subject: Re: [PATCH] net/mlx5: stop waiting for PCI link if reset is required
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Alexander Schmidt <alexs@linux.ibm.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 04 Apr 2023 17:27:35 +0200
In-Reply-To: <20230403182105.GC4514@unreal>
References: <20230403075657.168294-1-schnelle@linux.ibm.com>
         <20230403182105.GC4514@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KSOKikWBu51tUSlcAoH1KzvH5iF1Nxvk
X-Proofpoint-ORIG-GUID: 36_dKQ-S0GYJnTH2R6MItLTu3i7Wr5Yd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_06,2023-04-04_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040139
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-04-03 at 21:21 +0300, Leon Romanovsky wrote:
> On Mon, Apr 03, 2023 at 09:56:56AM +0200, Niklas Schnelle wrote:
> > after an error on the PCI link, the driver does not need to wait
> > for the link to become functional again as a reset is required. Stop
> > the wait loop in this case to accelerate the recovery flow.
> >=20
> > Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
> > Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers=
/net/ethernet/mellanox/mlx5/core/health.c
> > index f9438d4e43ca..81ca44e0705a 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > @@ -325,6 +325,8 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *d=
ev)
> >  	while (sensor_pci_not_working(dev)) {
>=20
> According to the comment in sensor_pci_not_working(), this loop is
> supposed to wait till PCI will be ready again. Otherwise, already in
> first iteration, we will bail out with pci_channel_offline() error.
>=20
> Thanks

Well yes. The problem is that this works for intermittent errors
including when the card resets itself which seems to be the use case in
mlx5_fw_reset_complete_reload() and mlx5_devlink_reload_fw_activate().
If there is a PCI error that requires a link reset though we see some
problems though it does work after running into the timeout.

As I understand it and as implemented at least on s390,
pci_channel_io_frozen is only set for fatal errors that require a reset
while non fatal errors will have pci_channel_io_normal (see also
Documentation/PCI/pcieaer-howto.rst) thus I think pci_channel_offline()
should only be true if a reset is required or there is a permanent
error. Furthermore in the pci_channel_io_frozen state the PCI function
may be isolated and the reads will not reach the endpoint, this is the
case at least on s390.  Thus for errors requiring a reset the loop
without pci_channel_offline() will run until the reset is performed or
the timeout is reached. In the mlx5_health_try_recover() case during
error recovery we will then indeed always loop until timeout, because
the loop blocks mlx5_pci_err_detected() from returning thus blocking
the reset (see Documentation/PCI/pci-error-recovery.rst). Adding Bjorn,
maybe he can confirm or correct my assumptions here.

Thanks,
Niklas

>=20
> >  		if (time_after(jiffies, end))
> >  			return -ETIMEDOUT;
> > +		if (pci_channel_offline(dev->pdev))
> > +			return -EIO;
> >  		msleep(100);
> >  	}
> >  	return 0;
> > @@ -332,10 +334,16 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev =
*dev)
> > =20
> >  static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
> >  {
> > +	int rc;
> > +
> >  	mlx5_core_warn(dev, "handling bad device here\n");
> >  	mlx5_handle_bad_state(dev);
> > -	if (mlx5_health_wait_pci_up(dev)) {
> > -		mlx5_core_err(dev, "health recovery flow aborted, PCI reads still no=
t working\n");
> > +	rc =3D mlx5_health_wait_pci_up(dev);
> > +	if (rc) {
> > +		if (rc =3D=3D -ETIMEDOUT)
> > +			mlx5_core_err(dev, "health recovery flow aborted, PCI reads still n=
ot working\n");
> > +		else
> > +			mlx5_core_err(dev, "health recovery flow aborted, PCI channel offli=
ne\n");
> >  		return -EIO;
> >  	}
> >  	mlx5_core_err(dev, "starting health recovery flow\n");
> >=20
> > base-commit: 7e364e56293bb98cae1b55fd835f5991c4e96e7d
> > --=20
> > 2.37.2
> >=20

