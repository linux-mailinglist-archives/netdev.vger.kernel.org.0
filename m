Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1711A598ABD
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345289AbiHRRzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241499AbiHRRzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:55:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F63BB99F7;
        Thu, 18 Aug 2022 10:55:45 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27IHppYj001616;
        Thu, 18 Aug 2022 10:55:32 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3j1t6r00b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 10:55:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7vG7woZE8EwMktMCAG7+mBtlRTJbuUgl3yCs+EZlKaolfdLy/zC8OSwxQtW1f9O4dsNMjWIzyiVncdKM2GKBCsA6uTR64P7dpICOr1Hw/OeyYIa6OpHrfQfYMnXSxSoXVRsq4IaLRNkGhBWdrP/4PK5kLVcGbB/nodAKmKmU8FA22FB2c/7uW9UGcwkL2Lk+6A/tUcqABJUEWQERddc5yaMeIjhLlrFTzJGy7GPg7Dhpw/pPyL3+UcEN2hQLyXngTyU+aBBAU9VBihmWC605Ds5kQFgOucXO67ONTYb+UfdBDHsCupHuz63ZRpcOXNujSSiRELEtmGqPW4yCuRZpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPBjTZ0dqZxbEYb7/yYE5sFSFf1WgX9+ObN8s4eOk+s=;
 b=mLIXt1rWDJ+sWXAVD1FYlKErYqTIQe3+89ox/dHV27+YkLrvIPjEGlotQKeXMc1a6NKgq2jRYrFxuIyN5A775Pd+nJgNVy+YoD1C4vbOP9obg3eq5b+eHpuSi1kxYi8WZV6SjJgwnD9YPJOtQg5396OUX9/jdpcVq9n87YPKsN7476LUN267rUM33WOHzUZlvGrGb2KsUOBu7T5JxCnRk1HFAOHZ3uXmhEc/PmJeBd03IyUaTBCc0CtM9YkmJyCFd+XxaKxwEizVyzFjGW/EoE/TgfgxA4Rw8FIb2C/PdsV8AlOQ48jIljuXnaNOLWzwMOkvaTR+A3iCqJlnDTEXbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPBjTZ0dqZxbEYb7/yYE5sFSFf1WgX9+ObN8s4eOk+s=;
 b=VhGfr6bM6CEwGNdzG2jqj/7KlDZV4pDG5GtdtQEwg5xN9MaCwPkAU0RWLcVSiGVhIWQi1XcbKd1IyaRCUelLvDPvWYU2ulaOUX6uj54eHLkw94MNj/FtbRGrL7ovJ2Rf8NhYDVee33SU/BI8vTWieuUTah9fip9IjpVr/SHoDS8=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by DM6PR18MB2892.namprd18.prod.outlook.com (2603:10b6:5:171::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 17:55:28 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::408f:c7c9:f84e:d5c4]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::408f:c7c9:f84e:d5c4%8]) with mapi id 15.20.5546.016; Thu, 18 Aug 2022
 17:55:28 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Ariel Elior <aelior@marvell.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Alok Prasad <palok@marvell.com>
Subject: RE: [EXT] Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
Thread-Topic: [EXT] Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
Thread-Index: AQHYpmM1EiFRfp08ekyzVXo+zae/Oq2b/goAgAEZ7gCAADk8gIAXCIOAgACOKQCAABkjIA==
Date:   Thu, 18 Aug 2022 17:55:28 +0000
Message-ID: <BY3PR18MB4612295606F0C22A1863FF44AB6D9@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <CA+QYu4qxW1BUcbC9MwG1BxXjPO96sa9BOUXOHCj1SLY7ObJnQw@mail.gmail.com>
        <20220802122356.6f163a79@kernel.org>
        <CA+QYu4ob4cbh3Vnh9DWgaPpyw8nTLFG__TbBpBsYg1tWJPxygg@mail.gmail.com>
        <20220803083751.40b6ee93@kernel.org>
        <CA+QYu4poBJgXZ=RLTpQVxMeTX3HUSenWA7WZCcw45dzdGeyecg@mail.gmail.com>
 <20220818085106.73aabac2@kernel.org>
In-Reply-To: <20220818085106.73aabac2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92d6c8ab-b349-4452-1bd5-08da8142d623
x-ms-traffictypediagnostic: DM6PR18MB2892:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M0/bc2U9+7OOQrYwi9Xh307YrfocVjQiz0fju7PzMM0Z/E/0v9okGPIw+mfu8d2uOboR2tnChz493cVegi3qNr4ri03fB32apsHKURpPAkl0E7B8cCBmHl9CFgTkDJmSca6ljRAefors1wH4MSVwFhhKrcdrkIRwr/i2/d+QxvuZ2qhRn//Qb8JwOfhfYtOZauJgBnRFUiuJa2KxfY9p1yDtl+Husci8RNufinBOGv/gdB8yv5GuKrBAEyVi/19FPYQEmh1r8Nz58GNsZuQSNONrnybkHvLFBtgCMbGk3MHiLGDf0TwdW6GeVCNdelv+9POA+6pncw/wN5HsYF7k5PARbCpf/CXaXdVZZeWxDanH43zyDinn8ssHU7sXH/GTQV1DHhPYQnfwAoDr5uRH0c9zDtTlTYrhgBSCPsI0XnWxQ85jj2TDPqc0gnRPPQEQoKCmoufBkVQ3disgBpzKp13BDSChhpT+GXTytsoGonmTTQMdevE4eSkqlRKX7GKnGWxCXxOPKumw0yOi6TLl+pXQtQq/VUHDgySw+RWm3PukPhbBugYHeR3gMo2U2+iNvTiiUdgUYF7te8/e4fBHSQhNTi91tgu+JsaJZDEtfIw9tHUYzg+cnXI+hBteYZv35/KRLSqHlqZ6GiKA54Nzw7GyBA5D35CEOVhS2HmTjJ5AKBlMN7Q/I3TfoB0Ge9EyNhraY2XFYZQJv5juNBxOJ6FhH8XmKj8i+/a0UVLRBEjZ1i8+hYvriacyWwbdEw3IRwXAaENW3jTFFkDC9Xxc0I8+SAs5zA4PH0PeBFKMEXzETIdALnxTJ9HQCvt13nwAzIfL+TQGEN/CXpr5EcXYXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(38100700002)(86362001)(76116006)(19627235002)(66946007)(8676002)(66476007)(122000001)(4326008)(316002)(66446008)(64756008)(66556008)(55236004)(5660300002)(6506007)(55016003)(38070700005)(52536014)(53546011)(966005)(478600001)(83380400001)(7696005)(45080400002)(30864003)(33656002)(41300700001)(186003)(8936002)(54906003)(71200400001)(9686003)(107886003)(6636002)(2906002)(110136005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gLF+CHCznZyBg4M362OEYqboTzXoYIZVWr/4p2otZHUOpwBbeQ8fOYxhckze?=
 =?us-ascii?Q?Cr8Ug8Utj7S2KZstWghdoLkmM1UPFrMALilGwW7MlLXkfzyyAKRdzNQubjKH?=
 =?us-ascii?Q?/A7ypxOQj3kCnoO6HGe5FAQYBiV/sWJ9fXAW6XccT4mLJcrtWeCqc6sA0TMw?=
 =?us-ascii?Q?r5JjV6tpGw40lRubU8CvViin9BXK5pADYLnRXZk89ncDMZstGRYbyPQ8PuYf?=
 =?us-ascii?Q?4qnM2leG48eYHpKRP2jad1V2sjfO8/o/YAafu4sIbpxAZ7eEisawl8ExEUrT?=
 =?us-ascii?Q?APZQZvGm7Z8EPi+LxkbmSYP8OcSt4kPfka+JQG/GCmsIA9XNxHvCQCMMfQUM?=
 =?us-ascii?Q?/YS7EjzbK84BpED4YtZyLTdo6RP82UiB9VtZQKHsAYAUTu/QwNHCZtM8hp4J?=
 =?us-ascii?Q?MyGScouihWh1DcdrgNjClvdA/brAnWgmvKFMmhMDKSj3nsfOpCk9FKUbAdHp?=
 =?us-ascii?Q?7OrXmKy5L+kpUW2+1GoWN0guj+urcy+OGMUH0Xjb2XiTS7B+ZAdUMy5nfqBF?=
 =?us-ascii?Q?iwx59/jaXAlTZVRMrWR6ydd35TxMZp20ul470tIYERlmNUVIwJJ02lDNIBVD?=
 =?us-ascii?Q?E0wxcJlW2zuohETlTfSlZwA4rbEgi83Zdc/rz1a/ceBPOe/Jxja8Jh8OAbr+?=
 =?us-ascii?Q?vRGnOx210dG7lu1s8kZ/7JPycRFR9qwsstXR/fwqm9kvBIL0fgVJGgdC9jk6?=
 =?us-ascii?Q?HKpL5GsOQH67bzbsCBD56IAfdQ0q0S0UtQAbPVn1H4vnoMotjZF3Xhr1SSdo?=
 =?us-ascii?Q?n47aAHBal/hHiQ+xNWmdM3Y6Ar87XxBhungPjkc7TPXNT//R+Q1oNEQBSxYQ?=
 =?us-ascii?Q?3S8MRuwhy+1wSnzAxmO4lV+8ti41vrpEuHquU6oF1y54B3tdvap0WHJ9Vxhe?=
 =?us-ascii?Q?gQ9PPE6CsheXqYoMQUDcbMGTXcD4X0UqfRTKkpyWJ7RqIumNgHGIIex5RFw7?=
 =?us-ascii?Q?h9gb0aI4BUA+nSLNGX63oQhgYljSWWtEoojV1esHbsVmzj5vFAr9lzgNZRFL?=
 =?us-ascii?Q?D9GH+DAd5+M5FtlwiKNrnr1lHlXh0WMbKLXPqqHtCI8SbU+MyaXTeghH9qmF?=
 =?us-ascii?Q?7jseeGR2XtqDBLRyHsMIuY2Ks1kBqdrRekd/CFHbct5M2rtMGSHBfXWDyW2R?=
 =?us-ascii?Q?b57q6vygLC5MRnAQgsUsuZjPQ2ePY9ui+a8oDU6ujYkFAFE2KneiioRJpzQm?=
 =?us-ascii?Q?7Uv0CcQHNM121wBmyP8nibpVFbIs2ZtWjgqGbW/TmdnfMAEnxyz8ngfDrSSS?=
 =?us-ascii?Q?VaQ7mw2RHbbQWwP0iYtm2HfKPmMUz02xBJFsnbQGok9zeYqNkQgVPz2GHsT+?=
 =?us-ascii?Q?bYV/x03DRBKZWzCaae+EKl6PB5zyufqUn+z7lkMGpK4uXlKZOVH/9WfmRTgh?=
 =?us-ascii?Q?0mb670ldzdktHmmLOjgYy9khBnZmVy83MBZuBAXRWq2rpj9o1ErHcP9ZEr2A?=
 =?us-ascii?Q?xInrKt49GiSJaeQm/l89ETw/q5pmyh5tED0wRfiM7CpsxUNDwNL3dM0B+vAB?=
 =?us-ascii?Q?vwrjNJrnzWDogClng7ueB3+7CBzfzAoe14X1DI9xJLCaWZQI05SkZ9OwnfOK?=
 =?us-ascii?Q?3ezTFMW8jovGz/W4AKtJieX9aiKtfEpOl37Rlnhy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d6c8ab-b349-4452-1bd5-08da8142d623
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 17:55:28.6171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W85DthTS+imMFu2KUsSNyV0SDR9W4XzAkIHOqVPrMN1869rChG5A4hS0zXZNmp8rbg/lvPFsp6zUotUuvX301w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2892
X-Proofpoint-ORIG-GUID: uahpymKBtBywcM5QWT5KBHDx9k5fDL5G
X-Proofpoint-GUID: uahpymKBtBywcM5QWT5KBHDx9k5fDL5G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_13,2022-08-18_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, August 18, 2022 9:21 PM
> To: Bruno Goncalves <bgoncalv@redhat.com>; Ariel Elior
> <aelior@marvell.com>
> Cc: LKML <linux-kernel@vger.kernel.org>; Networking
> <netdev@vger.kernel.org>; CKI Project <cki-project@redhat.com>; Saurav
> Kashyap <skashyap@marvell.com>; Javed Hasan <jhasan@marvell.com>;
> Manish Chopra <manishc@marvell.com>
> Subject: [EXT] Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Thu, 18 Aug 2022 09:22:17 +0200 Bruno Goncalves wrote:
> > On Wed, 3 Aug 2022 at 17:37, Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Wed, 3 Aug 2022 14:13:00 +0200 Bruno Goncalves wrote:
> > > > Got this from the most recent failure (kernel built using commit
> 0805c6fb39f6):
> > > >
> > > > the tarball is
> > > > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__s3.amazonaws=
.
> > > > com_arr-2Dcki-2Dprod-2Dtrusted-2Dartifacts_trusted-2Dartifacts_603
> > > > 714145_build-2520x86-5F64-2520debug_2807738987_artifacts_kernel-
> 2D
> > > > mainline.kernel.org-2Dredhat-5F603714145-5Fx86-5F64-5Fdebug.tar.gz
> > > >
> &d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DbMTgx2X48QVXyXOEL8ALyI4d
> sWoR-
> > > > m74c5n3d-
> ruJI8&m=3DzBBoyokuEgJ25hD586tidMPozXvZjlserj2qf3Iqn2o5V-ds8
> > > >
> Jb7IkFIggvHpm4H&s=3DsjyeF4V5YfoiaDBRrtfGEXdVs3el3AdmvUNVQbteSu4&e=3D
> > > > and the call trace from
> > > > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__s3.us-2Deast=
-
> > > > 2D1.amazonaws.com_arr-2Dcki-2Dprod-2Ddatawarehouse-
> 2Dpublic_datawa
> > > > rehouse-2Dpublic_2022_08_02_redhat-3A603123526_build-5Fx86-
> 5F64-5F
> > > > redhat-3A603123526-5Fx86-5F64-5Fdebug_tests_1_results-
> 5F0001_conso
> > > >
> le.log_console.log&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DbMTgx2X48
> QV
> > > > XyXOEL8ALyI4dsWoR-m74c5n3d-
> ruJI8&m=3DzBBoyokuEgJ25hD586tidMPozXvZjls
> > > > erj2qf3Iqn2o5V-
> ds8Jb7IkFIggvHpm4H&s=3DwV1Vq1lhXX02fbTXIWy_NRHxb9LgDz
> > > > Enst11oy-RTpM&e=3D
> > > >
> > > > [   69.876513] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > > > [   69.888521] Hardware name: HPE ProLiant DL325 Gen10 Plus/ProLian=
t
> > > > DL325 Gen10 Plus, BIOS A43 08/09/2021
> > > > [   69.897971] RIP: 0010:qede_load.cold
> > > > (/builds/2807738987/workdir/./include/linux/spinlock.h:389
> > > > /builds/2807738987/workdir/./include/linux/netdevice.h:4294
> > > > /builds/2807738987/workdir/./include/linux/netdevice.h:4385
> > > > /builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_m
> > > > ain.c:2594
> > > > /builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_m
> > > > ain.c:2575)
> > >
> > > Thanks a lot! That seems to point the finger at commit 3aa6bce9af0e
> > > ("net: watchdog: hold device global xmit lock during tx disable")
> > > but frankly IDK why... The driver must be fully initialized to get
> > > to
> > > ndo_open() so how is the tx_global_lock busted?!
> > >
> > > Would you be able to re-run with CONFIG_KASAN=3Dy ?
> > > Perhaps KASAN can tell us what's messing up the lock.
> >
> > Sorry for taking a long time to provide the info.
> > Below is the call trace, note it is on a different machine. It might
> > take me a few days in case I need to try on the original machine.
>=20
> Thanks, looks like KASAN didn't catch anything, it's the same crash :( Le=
t's CC
> all the Qlogic people, Qlogic PTAL.
>=20
> > [  110.329039] [0000:c1:00.2]:[qedf_link_update:613]:9: LINK DOWN.
> > [  110.330183] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI [
> > 110.340728] CPU: 56 PID: 1810 Comm: NetworkManager Not tainted 5.19.0
> > #1 [  110.347435] Hardware name: Dell Inc. PowerEdge R7425/02MJ3T,
> > BIOS
> > 1.18.0 01/17/2022
> > [  110.355088] RIP: 0010:qede_load.cold+0x14c/0xa08 [qede] [
> > 110.360348] Code: c6 60 fb 40 c0 48 c7 c7 40 e1 40 c0 e8 b7 21 28
> > c8 48 8b 3c 24 e8 fa 06 2d c7 41 0f b7 9f b6 00 00 00 41 89 dc e9 c2
> > 3c fe ff <0f> 0b 48 c7 c1 60 d0 40 c0 eb c1 49 8d 7f 08 e8 36 09 2d c7
> > 49 8b
> > [  110.379101] RSP: 0018:ffff888162ab6e00 EFLAGS: 00010206 [
> > 110.384338] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> > ffffffffc03ed524 [  110.391479] RDX: 000000000000006b RSI:
> > 0000000000000007 RDI: ffff88810401a758 [  110.398621] RBP:
> > ffff8888a20f2cd0 R08: 0000000000000001 R09: ffffffff8bba9e0f [
> > 110.405761] R10: fffffbfff17753c1 R11: 0000000000000001 R12:
> > ffff88810401a758 [  110.412895] R13: ffff8888a20f2c08 R14:
> > ffff8888a20f2cb6 R15: ffff8888a20f2c00 [  110.420036] FS:
> > 00007fac3a412500(0000) GS:ffff888810d00000(0000)
> > knlGS:0000000000000000
> > [  110.428129] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [
> > 110.433875] CR2: 00007fac38ffca88 CR3: 0000000123528000 CR4:
> > 00000000003506e0 [  110.441009] Call Trace:
> > [  110.443464]  <TASK>
> > [  110.445585]  ? qed_eth_rxq_start_ramrod+0x320/0x320 [qed] [
> > 110.451110]  ? qede_alloc_mem_txq+0x240/0x240 [qede] [  110.456106]  ?
> > lock_release+0x233/0x470 [  110.459958]  ?
> > rwsem_wake.isra.0+0xf1/0x100 [  110.464163]  ?
> > lock_chain_count+0x20/0x20 [  110.468179]  ? find_held_lock+0x83/0xa0
> > [  110.472032]  ? lock_is_held_type+0xe3/0x140 [  110.476245]  ?
> > lockdep_hardirqs_on_prepare+0x132/0x230
> > [  110.481397]  ? queue_delayed_work_on+0x57/0x90 [  110.485852]  ?
> > lockdep_hardirqs_on+0x7d/0x100 [  110.490221]  ?
> > qed_get_int_fp+0xe0/0xe0 [qed] [  110.494703]  qede_open+0x6d/0x100
> > [qede] [  110.498664]  __dev_open+0x1c3/0x2c0 [  110.502171]  ?
> > dev_set_rx_mode+0x60/0x60 [  110.506105]  ?
> > lockdep_hardirqs_on_prepare+0x132/0x230
> > [  110.511254]  ? __local_bh_enable_ip+0x8f/0x110 [  110.515711]
> > __dev_change_flags+0x31b/0x3b0 [  110.519906]  ?
> > dev_set_allmulti+0x10/0x10 [  110.523935]  dev_change_flags+0x58/0xb0
> > [  110.527783]  do_setlink+0xb38/0x19e0 [  110.531370]  ?
> > reacquire_held_locks+0x270/0x270 [  110.535910]  ?
> > rtnetlink_put_metrics+0x2e0/0x2e0 [  110.540538]  ?
> > entry_SYSCALL_64+0x1/0x29 [  110.544478]  ?
> > is_bpf_text_address+0x83/0xf0 [  110.548762]  ?
> > kernel_text_address+0x125/0x130 [  110.553218]  ?
> > __kernel_text_address+0xe/0x40 [  110.557585]  ?
> > unwind_get_return_address+0x33/0x50
> > [  110.562386]  ? create_prof_cpu_mask+0x20/0x20 [  110.566755]  ?
> > arch_stack_walk+0xa3/0x100 [  110.570781]  ? memset+0x1f/0x40 [
> > 110.573939]  ? __nla_validate_parse+0xb4/0x1040 [  110.578481]  ?
> > stack_trace_save+0x96/0xd0 [  110.582504]  ?
> > nla_get_range_signed+0x180/0x180 [  110.587042]  ?
> > __stack_depot_save+0x35/0x4a0 [  110.591335]
> > __rtnl_newlink+0x715/0xc90 [  110.595182]  ? mark_lock+0xd51/0xd90 [
> > 110.598773]  ? rtnl_link_unregister+0x1e0/0x1e0 [  110.603309]  ?
> > _raw_spin_unlock_irqrestore+0x40/0x60
> > [  110.608285]  ? ___slab_alloc+0x919/0xf80 [  110.612222]  ?
> > rtnl_newlink+0x36/0x70 [  110.615896]  ?
> > reacquire_held_locks+0x270/0x270 [  110.620440]  ?
> > lock_is_held_type+0xe3/0x140 [  110.624634]  ?
> > rcu_read_lock_sched_held+0x3f/0x80
> > [  110.629353]  ? trace_kmalloc+0x33/0x100 [  110.633207]
> > rtnl_newlink+0x4f/0x70 [  110.636704]  rtnetlink_rcv_msg+0x242/0x6b0 [
> > 110.640815]  ? rtnl_stats_set+0x260/0x260 [  110.644836]  ?
> > lock_acquire+0x16f/0x410 [  110.648682]  ? lock_acquire+0x17f/0x410 [
> > 110.652533]  netlink_rcv_skb+0xce/0x200 [  110.656385]  ?
> > rtnl_stats_set+0x260/0x260 [  110.660408]  ? netlink_ack+0x520/0x520 [
> > 110.664166]  ? netlink_deliver_tap+0x13c/0x5c0 [  110.668626]  ?
> > netlink_deliver_tap+0x141/0x5c0 [  110.673083]
> > netlink_unicast+0x2cb/0x460 [  110.677015]  ?
> > netlink_attachskb+0x440/0x440 [  110.681294]  ?
> > __build_skb_around+0x12a/0x150 [  110.685667]
> > netlink_sendmsg+0x3d2/0x710 [  110.689609]  ?
> > netlink_unicast+0x460/0x460 [  110.693710]  ?
> > iovec_from_user.part.0+0x95/0x200 [  110.698348]  ?
> > netlink_unicast+0x460/0x460 [  110.702456]  sock_sendmsg+0x99/0xa0 [
> > 110.705963]  ____sys_sendmsg+0x3d4/0x410 [  110.709895]  ?
> > kernel_sendmsg+0x30/0x30 [  110.713740]  ?
> > __ia32_sys_recvmmsg+0x160/0x160 [  110.718200]  ?
> > lockdep_hardirqs_on_prepare+0x230/0x230
> > [  110.723358]  ___sys_sendmsg+0xe2/0x150 [  110.727124]  ?
> > sendmsg_copy_msghdr+0x110/0x110 [  110.731576]  ?
> > find_held_lock+0x83/0xa0 [  110.735425]  ? lock_release+0x233/0x470 [
> > 110.739271]  ? __fget_files+0x14a/0x200 [  110.743120]  ?
> > reacquire_held_locks+0x270/0x270 [  110.747674]  ?
> > __fget_files+0x162/0x200 [  110.751524]  ? __fget_light+0x66/0x100 [
> > 110.755286]  __sys_sendmsg+0xc3/0x140 [  110.758964]  ?
> > __sys_sendmsg_sock+0x20/0x20 [  110.763158]  ?
> > mark_held_locks+0x24/0x90 [  110.767099]  ?
> > ktime_get_coarse_real_ts64+0x19/0x80
> > [  110.771990]  ? ktime_get_coarse_real_ts64+0x65/0x80
> > [  110.776879]  ? syscall_trace_enter.constprop.0+0x16f/0x230
> > [  110.782375]  do_syscall_64+0x5b/0x80 [  110.785963]
> > entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > [  110.791021] RIP: 0033:0x7fac3b54f71d [  110.794609] Code: 28 89 54
> > 24 1c 48 89 74 24 10 89 7c 24 08 e8 ea
> > c4 f4 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00
> > 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 3e c5 f4
> > ff 48 [  110.813362] RSP: 002b:00007ffd3b5c7da0 EFLAGS: 00000293
> > ORIG_RAX:
> > 000000000000002e
> > [  110.820938] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
> > 00007fac3b54f71d [  110.828081] RDX: 0000000000000000 RSI:
> > 00007ffd3b5c7de0 RDI: 000000000000000d [  110.835221] RBP:
> > 0000563d7ac60090 R08: 0000000000000000 R09: 0000000000000000 [
> > 110.842361] R10: 0000000000000000 R11: 0000000000000293 R12:
> > 00007ffd3b5c7f4c [  110.849494] R13: 00007ffd3b5c7f50 R14:
> > 0000000000000000 R15: 00007ffd3b5c7f58 [  110.856639]  </TASK> [
> > 110.858837] Modules linked in: pcc_cpufreq(-) rfkill intel_rapl_msr
> > dcdbas intel_rapl_common amd64_edac edac_mce_amd rapl pcspkr qedi
> > mgag200 i2c_algo_bit iscsi_boot_sysfs libiscsi drm_shmem_helper
> > cdc_ether scsi_transport_iscsi usbnet drm_kms_helper mii uio ipmi_ssif
> > k10temp i2c_piix4 acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler
> > acpi_power_meter acpi_cpufreq vfat fat drm fuse xfs qedf qede qed
> > crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel libfcoe
> > libfc scsi_transport_fc crc8 ccp tg3 sp5100_tco [  110.904398] ---[
> > end trace 0000000000000000 ]--- [  110.909039] RIP:
> > 0010:qede_load.cold+0x14c/0xa08 [qede] [  110.914306] Code: c6 60 fb
> > 40 c0 48 c7 c7 40 e1 40 c0 e8 b7 21 28
> > c8 48 8b 3c 24 e8 fa 06 2d c7 41 0f b7 9f b6 00 00 00 41 89 dc e9 c2
> > 3c fe ff <0f> 0b 48 c7 c1 60 d0 40 c0 eb c1 49 8d 7f 08 e8 36 09 2d c7
> > 49 8b
> > [  110.933068] RSP: 0018:ffff888162ab6e00 EFLAGS: 00010206 [
> > 110.938314] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> > ffffffffc03ed524 [  110.945466] RDX: 000000000000006b RSI:
> > 0000000000000007 RDI: ffff88810401a758 [  110.952616] RBP:
> > ffff8888a20f2cd0 R08: 0000000000000001 R09: ffffffff8bba9e0f [
> > 110.959772] R10: fffffbfff17753c1 R11: 0000000000000001 R12:
> > ffff88810401a758 [  110.966925] R13: ffff8888a20f2c08 R14:
> > ffff8888a20f2cb6 R15: ffff8888a20f2c00 [  110.974092] FS:
> > 00007fac3a412500(0000) GS:ffff888810d00000(0000)
> > knlGS:0000000000000000
> > [  110.982198] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [
> > 110.987971] CR2: 00007fac38ffca88 CR3: 0000000123528000 CR4:
> > 00000000003506e0 [  110.995131] Kernel panic - not syncing: Fatal
> > exception [  111.001311] Kernel Offset: 0x6000000 from
> > 0xffffffff81000000 (relocation range:
> > 0xffffffff80000000-0xffffffffbfffffff)
> > [  111.012016] ---[ end Kernel panic - not syncing: Fatal exception
> > ]---
> >
> > kernel tarball:
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__s3.amazonaws.com_
> > arr-2Dcki-2Dprod-2Dtrusted-2Dartifacts_trusted-2Dartifacts_604654489_p
> > ublish-2520x86-5F64-2520debug_2813007034_artifacts_kernel-
> 2Dmainline.k
> > ernel.org-2Dredhat-5F604654489-5Fx86-5F64-
> 5Fdebug.tar.gz&d=3DDwICAg&c=3DnK
> > jWec2b6R0mOyPaz7xtfQ&r=3DbMTgx2X48QVXyXOEL8ALyI4dsWoR-
> m74c5n3d-ruJI8&m=3Dz
> > BBoyokuEgJ25hD586tidMPozXvZjlserj2qf3Iqn2o5V-
> ds8Jb7IkFIggvHpm4H&s=3DWXbt
> > GecipcXSY_rwTu6JrCEI7VFKToDZ3UfZ4ciloWk&e=3D
> > kernel config:
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__s3.amazonaws.com_
> > arr-2Dcki-2Dprod-2Dtrusted-2Dartifacts_trusted-2Dartifacts_604654489_b
> > uild-2520x86-5F64-2520debug_2813006987_artifacts_kernel-
> 2Dmainline.ker
> > nel.org-2Dredhat-5F604654489-5Fx86-5F64-
> 5Fdebug.config&d=3DDwICAg&c=3DnKjW
> > ec2b6R0mOyPaz7xtfQ&r=3DbMTgx2X48QVXyXOEL8ALyI4dsWoR-m74c5n3d-
> ruJI8&m=3DzBB
> > oyokuEgJ25hD586tidMPozXvZjlserj2qf3Iqn2o5V-
> ds8Jb7IkFIggvHpm4H&s=3DedaLwi
> > kEZyvLAk8hrsZNE-Esjsn9HZ5luaW_FARAlCw&e=3D
> >
> >
> > Bruno

Hi Bruno,

1. How do you reproduce this issue exactly ? Any specific instructions or a=
ny special kernel CONFIG with which issue reproduces ?
2. Is there any Bugzilla opened for this already ? Can you please provide t=
he complete crash logs ? (vmcore-dmesg.txt ?)
3. You mentioned about commit 3aa6bce9af0e ("net: watchdog: hold device glo=
bal xmit lock during tx disable")
    Do you mean issue started surfacing only after this commit ? Driver cal=
ls netif_tx_disable() from these two relevant contexts -

    a. One in ndo_stop() flow=20

      	        /* Close OS Tx */
        netif_tx_disable(edev->ndev);
        netif_carrier_off(edev->ndev);
  =20
   b. Other in LINK events handling from the hard IRQ context

        DP_NOTICE(edev, "Link is down\n");
        netif_tx_disable(edev->ndev);
        netif_carrier_off(edev->ndev);

Thanks,
Manish

