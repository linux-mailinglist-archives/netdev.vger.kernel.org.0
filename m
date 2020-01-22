Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47E5145A09
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAVQlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:41:14 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39184 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725970AbgAVQlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:41:14 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MGeS8k010490;
        Wed, 22 Jan 2020 08:41:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=xn4cmqT6i918SH/43A5ZbWrCfLcsc4fbxU6eHa13d5s=;
 b=VHl1kqNW2om+z7tYXxVAQlS+XQ9MhokETWKQ2WRVProZoCZK903ZtvHIrJyKgSakijKk
 HDnSHcdUI+mqqOxV3iFnR0+K8ZXBm0L5oKFz3Mf5e4AyVICICP4QhqbEcKOdmDYM557z
 iUTmHCWH25tAwOgE6SmGeyVwa4XECkQK4rPhqe04MFMOdnLJeiW6Y7V5VJVP7ro8MaHy
 XOkYt7e/OfsAhOqZuDhx70OR7M8iYo1v5GeweaxQE2/2QErpstC5PYXPfkyF518pTPC4
 5AUMkL7OzQPyxPJsiHXAcSxAk8K3n0gLMPEFuZEz8NXNGKWUFhhOYHVK2M3ZbQm/SMDX Hw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xpm901fve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 08:41:13 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jan
 2020 08:41:11 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jan 2020 08:41:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+KL4E3BoL68sJiaU1skUobQN05EdRnV0f/fJta+qoAa0wK6yuL2oHENA56awujRnIK1OEu98xM/9uAp5WKQkwN9COTmlj580JCySY2raDwfmvAd06C28+Lc9PcUIzr5ReRNmt+7w5gS71emmLepyrhacPvC2sbdl/6qHlcJKRKOsESjb4QTJvZBA0bAxZPaO9U94GQDR649hnSRlrTFJ0KaPN2QKvRkI9iNVv/MEeyoszryWdoyV38fXhFyq99/7zdK33K/ggcjrOEUeT4Q+EvgF87NLd5aJyIzFQUY3kY4hIVC0zGnGu0MAH+lCclOtgMUUbHGzUZ0O9jN71ko3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn4cmqT6i918SH/43A5ZbWrCfLcsc4fbxU6eHa13d5s=;
 b=aUeGZhDxL6JR0Eg+TMIhSdGJv8frKw3ZE7WCipO4xaJe2jwdn0k/VS3qVLprWT2AEblc64+NgmZd5Depg+tZLVSoVn/pCV37N5/RlxgBCvee6yJKYsGFdEQaNA9Y3fqtzJhFzYYOVycg6PPXl4uh5TWYe3cDT2zJzi3OHpCKuBLVhSh0G0uM19O2ewmpF+E9g1kxVCwW41HFUdbxlk6/+J1zAgVVdYbnbJ/XyAlTJwFzL7XP0eG0r6bwgk2BUnixadd7WfwHReyfyRe1sBx0ZDzWIkBg2iIBpM2k2Qluuy22dpfpZ+3+5yES6ojtRXn3UCuevGIN6Uv/7i4a0fCSWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn4cmqT6i918SH/43A5ZbWrCfLcsc4fbxU6eHa13d5s=;
 b=jbRbmLC9+BojLIZshxWghOR5QgBG1BoSCCxdQfv7N35U4Y6+559FIk6ta5sWkpf3oAq7oV9cpl3JA5uqFvrYVnYjdXF8OK1XOKcjdg4DWrhoQN++2bopEKjtF54xD9FqtEopQFWMd43bw3velcxQ8S1ul5y05cnOylc0okrFFVY=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3214.namprd18.prod.outlook.com (10.255.236.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 22 Jan 2020 16:41:10 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 16:41:10 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next 13/14] qed: FW 8.42.2.0 debug features
Thread-Topic: [EXT] Re: [PATCH net-next 13/14] qed: FW 8.42.2.0 debug features
Thread-Index: AQHV0ThpeYgDXoJ9UkGGsegwjBX5+6f21fUAgAACP4CAAAOBgIAABuTQ
Date:   Wed, 22 Jan 2020 16:41:10 +0000
Message-ID: <MN2PR18MB318296DAE2E98F3BD34B3675A10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
 <20200122152627.14903-14-michal.kalderon@marvell.com>
 <20200122075416.608979b2@cakuba>
 <MN2PR18MB3182F7A15298B22C7CC5B64FA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20200122161451.GH7018@unreal>
In-Reply-To: <20200122161451.GH7018@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.203.130.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ce29020-4399-4366-891f-08d79f59e324
x-ms-traffictypediagnostic: MN2PR18MB3214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB32145ADB83C7D53FDE50C9BCA10C0@MN2PR18MB3214.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(189003)(199004)(2906002)(81166006)(81156014)(8936002)(8676002)(4326008)(86362001)(186003)(33656002)(6506007)(26005)(7696005)(6916009)(64756008)(66946007)(66446008)(76116006)(66556008)(66476007)(478600001)(316002)(54906003)(52536014)(9686003)(71200400001)(55016002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3214;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k3B9PCZNMBs4/rjybX/J8IGSX0FnzbQHl6k3aFCgyw/zZJTl4J1MLeHoImMwsFTZOv80PK/naJFWinRSeg82uHBBJ3BxbcIV6XAohj6JW66Ls9ClGOzFrGA5tTe/ADXKR4FtvxuvuzGytFQvdeMYsMI0EjRD1fRteV871xBQ7S+IdZFl3BhF6XGYT8YfQipisgvASHc+LwtwDF512/+5fo9Via72xx1g3KvHgV+MiQpjObmC0HoEbzxh+rPloCiA0BGNRXXruMGl8WngPvG7+KTJWD9uvDcMbf0QtNagDmWiTWOM5TCZ0lgVCB37WVTHpi34CdNDLfO369/1raGUdoZFq3qjY7KJO2UzvjtcPr0HgVjwbCtL9HV50YX1T6zLpQm5f57JQKLSDFDW+IapyTtSFne5NOZ6/+xr95IHoOVjzBlzhMEd+wPsekiQ2hQY
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce29020-4399-4366-891f-08d79f59e324
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 16:41:10.6103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RYlMaTf+ittt1d6R26GBbqcI9Dm9d/o0szaCdD0gUy8Nv1hwRVaugyAfpGjfW5YaE9hP/5Ajon0+1eAB3zwU7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3214
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, January 22, 2020 6:15 PM
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Wed, Jan 22, 2020 at 04:03:04PM +0000, Michal Kalderon wrote:
> > > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > > owner@vger.kernel.org> On Behalf Of Jakub Kicinski
> > >
> > > On Wed, 22 Jan 2020 17:26:26 +0200, Michal Kalderon wrote:
> > > > Add to debug dump more information on the platform it was
> > > > collected from (kernel version, epoch, pci func, path id).
> > >
> > > Kernel version and epoch don't belong in _device_ debug dump.
> > This is actually very useful when customers provide us with a debug-dum=
p
> using the ethtool-d option.
> > We can immediately verify the linux kernel version used.
>=20
> Why can't they give you "uname -a" output?
Unfortunately, history has shown us that in many cases even though requeste=
d uname -a is not
Provided, or worse, provided but does not match the actual kernel run on.=20
Having this information in the dump helps us and provides us with more conf=
idence than uname -a output.

>=20
> Thanks
