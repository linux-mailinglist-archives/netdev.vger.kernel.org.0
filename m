Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756296E1CFB
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 09:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDNHMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 03:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDNHMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 03:12:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1958010D3
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 00:12:33 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33E6sNiO030962;
        Fri, 14 Apr 2023 07:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=QF5e4sF6v9Az9tLDV8Sg9mKciYqWtze7Kz/RHHPqoc8=;
 b=pHyzlihoLEPsRHCwXvA5Y9ixpcOP1KbeiaM3u2vPtZp4pz1j919tIkk61va78/C7dXz/
 WZfw9VbM3u4PcHpEwSngHC7aZTQrNorA7Ybbje6RLV7ssbY0RbNkE+hsbQERCN9fd8Qo
 LYmBYUeq9N2N00hiAauouoxxiKTXnpZkFtSX5m5Tw58HVEMRP1kOeCZtb5k9aGtQvn8C
 uQzFTieom1UCQtYI2cUnphVuln+eeUHAglS0+lQCNJbaBxSfuvCtGw+G1T3Oy42POgxR
 IJUt5oEOIXRrjhpK0tvZAdyF38Mj5dIpIydwlbNjfnuiQCneusbTyYWlpouZYqZI0hKy fw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxwfugsq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 07:12:28 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33DNHdPQ027600;
        Fri, 14 Apr 2023 07:12:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3pu0hq2wvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 07:12:27 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33E7CMfe22413888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 07:12:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA3162004B;
        Fri, 14 Apr 2023 07:12:21 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49A8220043;
        Fri, 14 Apr 2023 07:12:21 +0000 (GMT)
Received: from [9.179.15.196] (unknown [9.179.15.196])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Apr 2023 07:12:21 +0000 (GMT)
Message-ID: <e5633e29d989ecd998ee5a9bf9ef89d987858821.camel@linux.ibm.com>
Subject: Re: Kernel crash after FLR reset of a ConnectX-5 PF in switchdev
 mode
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        "alexander.sschmidt" <alexander.sschmidt@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        netdev@vger.kernel.org, rrameshbabu@nvidia.com, gal@nvidia.com,
        moshe@nvidia.com, shayd@nvidia.com
Date:   Fri, 14 Apr 2023 09:12:21 +0200
In-Reply-To: <ZDh76MSj0hltzxwP@x130>
References: <90e1efad457f40c1f9f7b8cb56852072d8ea00fd.camel@linux.ibm.com>
         <20230413110228.GJ17993@unreal> <ZDh76MSj0hltzxwP@x130>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jGVbHRElsy4pRtHXfPoLaLhfirBIa22f
X-Proofpoint-ORIG-GUID: jGVbHRElsy4pRtHXfPoLaLhfirBIa22f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_02,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 clxscore=1011 mlxlogscore=948 phishscore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-13 at 15:02 -0700, Saeed Mahameed wrote:
> On 13 Apr 14:02, Leon Romanovsky wrote:
> > On Tue, Apr 11, 2023 at 05:11:11PM +0200, Niklas Schnelle wrote:
> > > Hi Saeed, Hi Leon,
> > >=20
> > > While testing PCI recovery with a ConnectX-5 card (MT28800, fw
> > > 16.35.1012) and vanilla 6.3-rc4/5/6 on s390 I've run into a kernel
> > > crash (stacktrace attached) when the card is in switchdev mode. No
> > > crash occurs and the recovery succeeds in legacy mode (with VFs). I
> > > found that the same crash occurs also with a simple Function Level
> > > Reset instead of the s390 specific PCI recovery, see instructions
> > > below. From the looks of it I think this could affect non-s390 too bu=
t
> > > I don't have a proper x86 test system with a ConnectX card to test
> > > with.
> > >=20
> > > Anyway, I tried to analyze further but got stuck after figuring out
> > > that in mlx5e_remove() deep down from mlx5_fw_fatal_reporter_err_work=
()
> > > (see trace) the mlx5e_dev->priv pointer is valid but the pointed to
> > > struct only contains zeros as it was previously zeroed by
> > > mlx5_mdev_uninit() which then leads to a NULL pointer access.
> > >=20
> > > The crash itself can be prevented by the following debug patch though
> > > clearly this is not a proper fix:
> > >=20
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > @@ -6012,6 +6012,10 @@ static void mlx5e_remove(struct auxiliary_devi=
ce
> > > *adev)
> > >         struct mlx5e_priv *priv =3D mlx5e_dev->priv;
> > >         pm_message_t state =3D {};
> > >=20
> > > +       if (!priv->mdev) {
> > > +               pr_err("%s with zeroed mlx5e_dev->priv\n", __func__);
> > > +               return;
> > > +       }
> > >         mlx5_core_uplink_netdev_set(priv->mdev, NULL);
> > >         mlx5e_dcbnl_delete_app(priv);
> > >         unregister_netdev(priv->netdev);
> > >=20
> > > With that I then tried to track down why mlx5_mdev_uninit() is called
> > > and this might actually be s390 specific in that this happens during
> > > the removal of the VF which on s390 causes extra hot unplug events fo=
r
> > > the VFs (our virtualized PCI hotplug is per-PCI function) resulting i=
n
> > > the following call trace:
> > >=20
> > > ...
> > > zpci_bus_remove_device()
> > >    zpci_iov_remove_virtfn()
> > >       pci_iov_remove_virtfn()
> > >          pci_stop_and_remove_bus_device()
> > >             pci_stop_bus_device()
> > >                device_release_driver_internal()
> > >                   pci_device_remove()
> > >                      remove_one()
> > >                         mlx5_mdev_uninit()
> > >=20
> > > Then again I would expect that on other architectures VFs become at
> > > leastunresponsive during a FLR of the PF not sure if that also lead t=
o
> > > calls to remove_one() though.
> > >=20
> > > As another data point I tried the same on the default Ubuntu 22.04
> > > generic 5.15 kernel and there no crash occurs so this might be a newe=
r
> > > issue.
> > >=20
> > > Also, I did test with and without the patch I sent recently for
> > > skipping the wait in mlx5_health_wait_pci_up() but that made no
> > > difference.
> > >=20
> > > Any hints on how to debug this further and could you try to see if th=
is
> > > occurs on other architectures as well?
> >=20
> > My guess that the splash, which complains about missing mutex_init(), i=
s an outcome of these failures:
> > [ 1375.771395] mlx5_core 0004:00:00.0 eth0 (unregistering): vport 1 err=
or -67 reading stats
> > [ 1376.151345] mlx5_core 0004:00:00.0: mlx5e_init_nic_tx:5376:(pid 1505=
): create tises failed, -67
> > [ 1376.238808] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_change=
_profile: new profile init failed, -67
> > [ 1376.243746] mlx5_core 0004:00:00.0: mlx5e_init_rep_tx:1101:(pid 1505=
): create tises failed, -67
> > [ 1376.328623] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_change=
_profile: failed to rollback to orig profile,
>=20
> Yes, I also agree with Leon, if rollback fails this could be fatal to mlx=
5e
> aux device removal as we don't have a way to check the state of the mlx5e
> priv, We always assume it is up as long as the aux is up, which is wrong
> only in case of this un-expected error flow.
>=20
> If we just add a flag and skip mlx5e_remove, then we will end up with
> dangling netdev and some other resources as the cleanup wasn't complete..
>=20
> I need to dive deeper to figure out a proper solution, I will create an i=
nternal
> ticket to track this and help provide a solution soon, hopefully.
>=20

Thank you for looking into this, do you have an idea what got us into
this unexpected error flow. This occurs very reliably for me but I'm
not sure if it is s390 specific or just caused by the switchdev setup.
It's also unexpected to me that the code reports -ENOLINK does that
refer to the PCIe link here or to the representor device being
disconnected?

Thanks,
Niklas

