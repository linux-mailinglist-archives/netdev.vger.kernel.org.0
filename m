Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EB16E78EB
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 13:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjDSLrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 07:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjDSLri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 07:47:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B687146E8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:47:30 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JAkkL2004557;
        Wed, 19 Apr 2023 11:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wYR6zDi2IRBymKwND9jegUmZmcJFM6FgKtvsP93uiVI=;
 b=gvzKhYlZ2FKtFiOozG62Mu9YTiqah2ckQa6jVooVSJthJ4e9YbePtddT2wI6PM8Nr/cL
 VVbW9tMtqggb/YoXb0wDZXawmNOFd/A0M1Y1mh7qq5N+xN/utcvC1CDtZ/gJz5W62jbQ
 OM9P8PzVFYphG8xk6aCdNkedVm1iocarTi4PhJTuBrtYVffHiJ/Evlm1btXFyAcMCxpP
 Hu9PBzvU5jb03bLQDMRyU9W5MvnR79SUWTleqlOlv6M+/flsWu3IPVSOttYqkpP8PUHy
 aj4MipXl6/kR81jjsiCCmKxmjFngdyw1ja6fPTrE0id3wjGdSoOnB8fxoK2+tO+ZBNDd Pg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1pkxcqhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 11:47:21 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33J5UajB018145;
        Wed, 19 Apr 2023 11:47:18 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3pykj6j819-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 11:47:18 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33JBlDbO63832560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 11:47:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADC812004D;
        Wed, 19 Apr 2023 11:47:13 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03C1120049;
        Wed, 19 Apr 2023 11:47:13 +0000 (GMT)
Received: from [9.171.28.7] (unknown [9.171.28.7])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 19 Apr 2023 11:47:12 +0000 (GMT)
Message-ID: <a699edef43990b6403884097e5eb923b411b36f6.camel@linux.ibm.com>
Subject: Re: Kernel crash after FLR reset of a ConnectX-5 PF in switchdev
 mode
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        "alexander.sschmidt" <alexander.sschmidt@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        netdev@vger.kernel.org, rrameshbabu@nvidia.com, gal@nvidia.com,
        moshe@nvidia.com, shayd@nvidia.com
Date:   Wed, 19 Apr 2023 13:47:12 +0200
In-Reply-To: <ZDnTNvKUGla8Y27E@x130>
References: <90e1efad457f40c1f9f7b8cb56852072d8ea00fd.camel@linux.ibm.com>
         <20230413110228.GJ17993@unreal> <ZDh76MSj0hltzxwP@x130>
         <e5633e29d989ecd998ee5a9bf9ef89d987858821.camel@linux.ibm.com>
         <ZDnTNvKUGla8Y27E@x130>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: exZpyHr7BdlamysbtXv69cEtxcxh2pRX
X-Proofpoint-ORIG-GUID: exZpyHr7BdlamysbtXv69cEtxcxh2pRX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_06,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-04-14 at 15:27 -0700, Saeed Mahameed wrote:
> On 14 Apr 09:12, Niklas Schnelle wrote:
> > On Thu, 2023-04-13 at 15:02 -0700, Saeed Mahameed wrote:
> > > On 13 Apr 14:02, Leon Romanovsky wrote:
> > > > On Tue, Apr 11, 2023 at 05:11:11PM +0200, Niklas Schnelle wrote:
> > > > > Hi Saeed, Hi Leon,
> > > > >=20
> > > > > While testing PCI recovery with a ConnectX-5 card (MT28800, fw
> > > > > 16.35.1012) and vanilla 6.3-rc4/5/6 on s390 I've run into a kerne=
l
> > > > > crash (stacktrace attached) when the card is in switchdev mode. N=
o
> > > > > crash occurs and the recovery succeeds in legacy mode (with VFs).=
 I
> > > > > found that the same crash occurs also with a simple Function Leve=
l
> > > > > Reset instead of the s390 specific PCI recovery, see instructions
> > > > > below. From the looks of it I think this could affect non-s390 to=
o but
> > > > > I don't have a proper x86 test system with a ConnectX card to tes=
t
> > > > > with.
> > > > >=20
> > > > > Anyway, I tried to analyze further but got stuck after figuring o=
ut
> > > > > that in mlx5e_remove() deep down from mlx5_fw_fatal_reporter_err_=
work()
> > > > > (see trace) the mlx5e_dev->priv pointer is valid but the pointed =
to
> > > > > struct only contains zeros as it was previously zeroed by
> > > > > mlx5_mdev_uninit() which then leads to a NULL pointer access.
> > > > >=20
> > > > > The crash itself can be prevented by the following debug patch th=
ough
> > > > > clearly this is not a proper fix:
> > > > >=20
> > > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > > > @@ -6012,6 +6012,10 @@ static void mlx5e_remove(struct auxiliary_=
device
> > > > > *adev)
> > > > >         struct mlx5e_priv *priv =3D mlx5e_dev->priv;
> > > > >         pm_message_t state =3D {};
> > > > >=20
> > > > > +       if (!priv->mdev) {
> > > > > +               pr_err("%s with zeroed mlx5e_dev->priv\n", __func=
__);
> > > > > +               return;
> > > > > +       }
> > > > >         mlx5_core_uplink_netdev_set(priv->mdev, NULL);
> > > > >         mlx5e_dcbnl_delete_app(priv);
> > > > >         unregister_netdev(priv->netdev);
> > > > >=20
> > > > > With that I then tried to track down why mlx5_mdev_uninit() is ca=
lled
> > > > > and this might actually be s390 specific in that this happens dur=
ing
> > > > > the removal of the VF which on s390 causes extra hot unplug event=
s for
> > > > > the VFs (our virtualized PCI hotplug is per-PCI function) resulti=
ng in
> > > > > the following call trace:
> > > > >=20
> > > > > ...
> > > > > zpci_bus_remove_device()
> > > > >    zpci_iov_remove_virtfn()
> > > > >       pci_iov_remove_virtfn()
> > > > >          pci_stop_and_remove_bus_device()
> > > > >             pci_stop_bus_device()
> > > > >                device_release_driver_internal()
> > > > >                   pci_device_remove()
> > > > >                      remove_one()
> > > > >                         mlx5_mdev_uninit()
> > > > >=20
> > > > > Then again I would expect that on other architectures VFs become =
at
> > > > > leastunresponsive during a FLR of the PF not sure if that also le=
ad to
> > > > > calls to remove_one() though.
> > > > >=20
> > > > > As another data point I tried the same on the default Ubuntu 22.0=
4
> > > > > generic 5.15 kernel and there no crash occurs so this might be a =
newer
> > > > > issue.
> > > > >=20
> > > > > Also, I did test with and without the patch I sent recently for
> > > > > skipping the wait in mlx5_health_wait_pci_up() but that made no
> > > > > difference.
> > > > >=20
> > > > > Any hints on how to debug this further and could you try to see i=
f this
> > > > > occurs on other architectures as well?
> > > >=20
> > > > My guess that the splash, which complains about missing mutex_init(=
), is an outcome of these failures:
> > > > [ 1375.771395] mlx5_core 0004:00:00.0 eth0 (unregistering): vport 1=
 error -67 reading stats
> > > > [ 1376.151345] mlx5_core 0004:00:00.0: mlx5e_init_nic_tx:5376:(pid =
1505): create tises failed, -67
> > > > [ 1376.238808] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_ch=
ange_profile: new profile init failed, -67
> > > > [ 1376.243746] mlx5_core 0004:00:00.0: mlx5e_init_rep_tx:1101:(pid =
1505): create tises failed, -67
> > > > [ 1376.328623] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_ch=
ange_profile: failed to rollback to orig profile,
> > >=20
> > > Yes, I also agree with Leon, if rollback fails this could be fatal to=
 mlx5e
> > > aux device removal as we don't have a way to check the state of the m=
lx5e
> > > priv, We always assume it is up as long as the aux is up, which is wr=
ong
> > > only in case of this un-expected error flow.
> > >=20
> > > If we just add a flag and skip mlx5e_remove, then we will end up with
> > > dangling netdev and some other resources as the cleanup wasn't comple=
te..
> > >=20
> > > I need to dive deeper to figure out a proper solution, I will create =
an internal
> > > ticket to track this and help provide a solution soon, hopefully.
> > >=20
> >=20
> > Thank you for looking into this, do you have an idea what got us into
> > this unexpected error flow. This occurs very reliably for me but I'm
> > not sure if it is s390 specific or just caused by the switchdev setup.
> > It's also unexpected to me that the code reports -ENOLINK does that
> > refer to the PCIe link here or to the representor device being
> > disconnected?
> >=20
>=20
> I believe this is not related to s390, and should happen on  x86 as well,=
=20
> I just learned yesterday that you already filed this issue through our
> support and we already have an assignee working on this, let's work throu=
gh
> the support ticket and reduce clutter on the mailing list, I am sure we w=
ill
> come up with a patch very soon and will all learn what went wrong :) ..
> I have a clear idea what the issue is, but the solution may require a
> bit of refactoring..=20
>=20
> -Saeed.

Sounds good and thank you!

Niklas
