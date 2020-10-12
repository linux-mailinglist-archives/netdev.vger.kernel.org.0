Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D68428AF83
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgJLIAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:00:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65074 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbgJLIAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:00:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09C7t5kG024459;
        Mon, 12 Oct 2020 01:00:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=bO7iH0A8Rqtk28OX1KU6Wto1kat7EySCmwGImrkZj+4=;
 b=UuwlYOg8OTrbIS8T+qoHBvozS6BDs9iWB77zMutLh8SPqNLZwvmoKArhFuygOM5hVzQP
 PRn8CbdtBZRs1pd4OELpbuDeA3SwBvT7QlnNuOnmn6USnxcXvqL2kxr6JpfH0TcP554i
 jb5qE7jKFX7uA+h5dWTv0/9vrLyzx34kes1MbDLjsJFqyvZyYDnfXQtQ1xJf91lVdCXw
 lclGRmKwAsdHYsF4+WO1nosGE7XHM25b80e43xAEmGPb7jT4fWObxabx37NBaAr7Ge9g
 /G2xuaR/Eq5izjWLjmOdsThqEhpxB/fqmZsG9b6WLDGPHZz1cBB254N33XIy3D11wkc2 Iw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 343cfj4s2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 01:00:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 01:00:13 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 01:00:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 12 Oct 2020 01:00:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWfKDSKEdElPIVuQuvCx57o3Yc84MjPyLrst+ky7gG9Ly74eTb1XNTviuwEa1Uuy8evsiKZuPAjT+2dgPt4AFfn3bCCHGyVRqBjEFMtOdoSnzMrBUttaA/lObMoA1wuDfRqpIEWDVW2y4ULPsPoKKmxWuH8mIDOYwmXkUTWkeF+AiuHwk222l6ZWwNWKubmN56t038tjw48cph6xrLQ7qq+whV7f3q2Pt14pvDECrv1BhqfMa3058ECTfUnK2/6Mq5Anqm6+7zPKFKot1WzwO4oHLQtYse5qNDe7gZtfyNj+VcmUYBJKc2F78KCo5OanLDgR0iYYkgKl9BooBL60AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bO7iH0A8Rqtk28OX1KU6Wto1kat7EySCmwGImrkZj+4=;
 b=BVXnmk1P1tLiYc1o6F/dlTYAuttxJy+syDljGQ5yTGEIMqnLuPdbv3K+zYtihX9V2SjJ7mzc85mkzTwbT7776tKbaniFmA9deerUItVEMTjEsJxXO6u/G9YkcP76zUiEAbSvCdeEZgurvNhLpBvDnL8UtBdXrycPuDfA3PzblOBqgVirqiKPSCQy9WYHuTnAovwM2iRm0qKhwaxYORqqR6x7xQNxscvgmz6ixhgkmpcbyOqjbra7QOSD4lBedq2/8l+D+lA0uO7PtHUfHvzN+DxXp3wySno/D69E9OK7XAmV6oUFic6DnPHVzfzRYzAuF/+svEylvezbtw/tSwJHng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bO7iH0A8Rqtk28OX1KU6Wto1kat7EySCmwGImrkZj+4=;
 b=OBk0roLoec/MFB963ktLFSQ/2vycxo2ejD0/n2bUBaRh2ps0TKTxst31JKIYFkFf5VKo3hBR2XFXI2uox/HfGrwwak+X/rqjIAQhnGHM+zKlFjlLZU9OZ1U3qkkx+Tk/Ztzxv7CSCH8o3ifSwdXEx2OcgJl8uRalDgv8NqQSpfk=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by SJ0PR18MB4108.namprd18.prod.outlook.com (2603:10b6:a03:2e9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.29; Mon, 12 Oct
 2020 08:00:09 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2%5]) with mapi id 15.20.3455.030; Mon, 12 Oct 2020
 08:00:09 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Srujana Challa <schalla@marvell.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "Subbaraya Sundeep Bhatta" <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>
Subject: RE: [PATCH v5,net-next,00/13] Add Support for Marvell OcteonTX2
 Cryptographic
Thread-Topic: [PATCH v5,net-next,00/13] Add Support for Marvell OcteonTX2
 Cryptographic
Thread-Index: AQHWoGriq49i26N6kEy0RpleBf3LcamTmGSA
Date:   Mon, 12 Oct 2020 08:00:08 +0000
Message-ID: <BYAPR18MB279153B71CA270ACF465B36EA0070@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20201012073931.28766-1-schalla@marvell.com>
In-Reply-To: <20201012073931.28766-1-schalla@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [103.96.19.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec7010fd-7e19-4a7d-c0b4-08d86e84d6f9
x-ms-traffictypediagnostic: SJ0PR18MB4108:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB410841D1CB875F95C8F3A0ABA0070@SJ0PR18MB4108.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XxKk+i0pFAp2L8IFlCf599vtgFTTN7fsgCMguGbhvjiO6n1Ne7iRWtfKrz6uW/U8nQCnUfPO/mC2DI2JLyY8RgrcyOpEohKU+O6OGPTe0Bw5ptfDrpJYFnbRm0oLacAm1Nvhpmu0h0sjbaQMYlV1ERK86xZa5a9H/6fQKW2narDSAZUg3srbvACeMstx0pwGEwBCPkt205UaED5y6vsWCQ33tn6a8otp+pn+EKLAriIikbQnX6+sWejDBF/+Vnp98M4KMzZDOdqc6aR98fGh/2ey+JbuZzN8X6T4lTNZOjO62JTU7gGLJ845+mt9PBTcwnGhXm8uvcDtK8lhxr/Mr+WRCFQbs1jAMxYZYWEoqYgf2+G4LKYBZXZMyXm9cdXw9Gdx4DBoDYLs7IvDMcY4CQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(136003)(346002)(366004)(83380400001)(110136005)(54906003)(8936002)(71200400001)(9686003)(6506007)(83080400001)(33656002)(316002)(966005)(52536014)(478600001)(66946007)(76116006)(64756008)(66476007)(66556008)(2906002)(4326008)(86362001)(5660300002)(26005)(55016002)(186003)(8676002)(107886003)(7696005)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RYTbU2sha+nT4VKPNsom37Fa8pE7H0jTxrrbORhfqU4tAmA8CYvyJnpGnCD2yPxdaLT8++crSPWcrgOowv4NNu/Rvcu9pSBSi8Hm3B4Ul7eOZl6Cc9ClV7WAUcfWY49K0OLnRg8tCjtu1P4Ce3QHE5V7IuttOmofN7MAmqCzZTQa7oOHHf6JYcQhJrEZlzW8N4wO3eKp0cUVWFQG1yCCj/NmR454CEVmMiPx/58ZCjVqydc5D4X3v6DYuQsdnVEZRrrvtuED/8p0m9H1um8CxOqc/MPVVeA9IoxvEdNDN5vlwZ29zSc9fgoMKegFe8na5BlWPrkUWHUWClDHu9LGhymeDAvDDLVM3fyAEcE8NMGCQLuWWgb1Nk0zoEsKfghmZkauwU1LznY0SRBO93vXF6yoGEIa68+G/4EPpBRfL8o9h09jc0zczCemFtlGplDje8m166p37sbWUrubXR3JLmEpTTylYdzDHATSRfVAw+7/H2JAmW4FXlz8wjHjpjaNb2rJKcinrG41Ket2fYEh89KdVBdWvHl6uwNMgO6Qa+J7rHCgCrm5CVGXwST/Yfl165O8dHAMKoR5TA5JeiwllPMemEWxHPK3GY2+oh4HVyES7Oy/X+WwBlVONXdlotusAvjH/4S16wcdVbinBGrMSw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec7010fd-7e19-4a7d-c0b4-08d86e84d6f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 08:00:09.1557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KU2H2RIDJXhvNwm9W0aStDgI9BK83fNuPFnvRAzJ7OarQ1T+M1UBzl2BnX5jR7+Hz8gJTn9Ea6+xbMd1ySWcYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4108
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_03:2020-10-12,2020-10-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am sorry, please ignore this version of series, it was sent by mistake wi=
thout removing Gerrit Change IDs.

Thanks,
Srujana

> This series introduces crypto(CPT) drivers(PF & VF) for Marvell OcteonTX2
> CN96XX Soc.
>=20
> OcteonTX2 SOC's resource virtualization unit (RVU) supports multiple
> physical and virtual functions. Each of the PF/VF's functionality is
> determined by what kind of resources are attached to it. When the CPT
> block is attached to a VF, it can function as a security device.
> The following document provides an overview of the hardware and
> different drivers for the OcteonTX2 SOC:
> https://www.kernel.org/doc/Documentation/networking/device_drivers/marvel=
l
> /octeontx2.rst
>=20
> The CPT PF driver is responsible for:
> - Forwarding messages to/from VFs from/to admin function(AF),
> - Enabling/disabling VFs,
> - Loading/unloading microcode (creation/deletion of engine groups).
>=20
> The CPT VF driver works as a crypto offload device.
>=20
> This patch series includes:
> - Patch to update existing Marvell sources to support the CPT driver.
> - Patch that adds mailbox messages to the admin function (AF) driver,
> to configure CPT HW registers.
> - CPT PF driver patches that include AF<=3D>PF<=3D>VF mailbox communicati=
on,
> sriov_configure, and firmware load to the acceleration engines.
> - CPT VF driver patches that include VF<=3D>PF mailbox communication and
> crypto offload support through the kernel cryptographic API.
>=20
> This series is tested with CRYPTO_EXTRA_TESTS enabled and
> CRYPTO_DISABLE_TESTS disabled.
>=20
> Changes since v4:
> *  Rebased the patches onto net-next tree with base
>    'commit bc081a693a56 ("Merge branch 'Offload-tc-vlan-mangle-to-
> mscc_ocelot-switch'")'
> Changes since v3:
> *  Splitup the patches into smaller patches with more informartion.
> Changes since v2:
>  * Fixed C=3D1 warnings.
>  * Added code to exit CPT VF driver gracefully.
>  * Moved OcteonTx2 asm code to a header file under include/linux/soc/
> Changes since v1:
>  * Moved Makefile changes from patch4 to patch2 and patch3.
>=20
> Srujana Challa (13):
>   octeontx2-pf: move lmt flush to include/linux/soc
>   octeontx2-af: add mailbox interface for CPT
>   octeontx2-af: add debugfs entries for CPT block
>   drivers: crypto: add Marvell OcteonTX2 CPT PF driver
>   crypto: octeontx2: add mailbox communication with AF
>   crypto: octeontx2: enable SR-IOV and mailbox communication with VF
>   crypto: octeontx2: load microcode and create engine groups
>   crypto: octeontx2: add LF framework
>   crypto: octeontx2: add support to get engine capabilities
>   crypto: octeontx2: add mailbox for inline-IPsec RX LF cfg
>   crypto: octeontx2: add virtual function driver support
>   crypto: octeontx2: add support to process the crypto request
>   crypto: octeontx2: register with linux crypto framework
>=20
>  MAINTAINERS                                   |    2 +
>  drivers/crypto/marvell/Kconfig                |   14 +
>  drivers/crypto/marvell/Makefile               |    1 +
>  drivers/crypto/marvell/octeontx2/Makefile     |   10 +
>  .../marvell/octeontx2/otx2_cpt_common.h       |  132 ++
>  .../marvell/octeontx2/otx2_cpt_hw_types.h     |  464 +++++
>  .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  202 ++
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  197 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  426 +++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  351 ++++
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   53 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       |  533 ++++++
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  424 +++++
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      | 1533 +++++++++++++++
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |  162 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   28 +
>  .../marvell/octeontx2/otx2_cptvf_algs.c       | 1665 +++++++++++++++++
>  .../marvell/octeontx2/otx2_cptvf_algs.h       |  170 ++
>  .../marvell/octeontx2/otx2_cptvf_main.c       |  408 ++++
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  139 ++
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  539 ++++++
>  .../ethernet/marvell/octeontx2/af/Makefile    |    3 +-
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |   85 +
>  .../net/ethernet/marvell/octeontx2/af/rvu.c   |    2 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |    7 +
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  343 ++++
>  .../marvell/octeontx2/af/rvu_debugfs.c        |  342 ++++
>  .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   75 +
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   65 +-
>  .../marvell/octeontx2/nic/otx2_common.h       |   13 +-
>  include/linux/soc/marvell/octeontx2/asm.h     |   29 +
>  31 files changed, 8397 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
>  create mode 100644 include/linux/soc/marvell/octeontx2/asm.h
>=20
> --
> 2.28.0

