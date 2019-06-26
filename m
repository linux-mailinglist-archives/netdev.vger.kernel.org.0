Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F157756297
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 08:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfFZGtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 02:49:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18500 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725954AbfFZGtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 02:49:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q6j4pb003422;
        Tue, 25 Jun 2019 23:49:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=lEK8EdxNLNBWcqOcU6QPJaG4OnMNrRxUYVp5a04oG2w=;
 b=W1UvrAaEka9W+6+1fJLSWAtThBKXfN/iX53/l1voisCnPxzIbX/N9QJ3P0Uh52+pRiDa
 rp+UZv6HtNnh2CdI61czjukEfOO/HMLSgUwVZZtQp36kiyz9V6r6zNhCVuY3koX/V8ko
 3CcsbPBqIimzUtDo4umbzRc8OxgmE/TT9JNJ9p4ht8MMWphcxjMSMbcUSK8i9iSpPpUe
 Aj7YZCHbG6+87neohEWose3OfPlFMsv9GAUrbtHaNHwjOxKGDVPVGYsXpvvHcjAyhZNo
 NfuDCsXRA1MGooUvdmYL5NulTckHaojScMK9VSkv6U4R6uCL5sg5dstrMd4HY9wZaCtX Wg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tbrte2pg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 23:49:09 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 25 Jun
 2019 23:47:00 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (104.47.34.54) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 25 Jun 2019 23:47:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=BEp7MT6cnXEhKyM9wk1CJLXE4+hYuwCrOSESGZc0U6m5wij0JXlDtfQ9kBACUAOIz1AjJd+6lUuIkYUXilo+vn3E6Wx8aCMSsfTAhapUGRTHCVPD/YVdPtEpG/5swDPMfqqDEwFehljAMhcSqnbeI6xQtiFZqfJEzYh5Nf3cT4Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEK8EdxNLNBWcqOcU6QPJaG4OnMNrRxUYVp5a04oG2w=;
 b=FUkRepDXXbFLp7QqKPWwFw5px8hkjVtwnhRSehWNtgP++OJ0MClEAbsYT0n+wniBs6qXEC0QMW+t+afMueapzHTWyRnaimTNJI2DaSkWfhYWeVtUai4bvEsPwUQ68Rp5oA6Hp++Nv3dfyhC74IDXnw9epq3GIdDkSRpKJZYdajU=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEK8EdxNLNBWcqOcU6QPJaG4OnMNrRxUYVp5a04oG2w=;
 b=XAKyVFvC9IYFpN+KnrrpDDiv20BEAPBaRuTbb18HIgji7Pq7B95skYuKkmzv3suJfSLNj2L2mYBtHifv8AC7niHsARkeFHM1FU7cQlgEbsHf+hSFHXK1zK865GLxWKvmvalQOINv8MwvsuPDzf6o6WC4WU6n+xnWct8/0JYRBP0=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2814.namprd18.prod.outlook.com (20.179.23.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 06:46:56 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2008.017; Wed, 26 Jun 2019
 06:46:56 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Thread-Topic: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Thread-Index: AQHVJQJMBFYAJht0E0S8f7iw9+GZZqagdSOAgAPWPzCAAEVLAIAI9vJg
Date:   Wed, 26 Jun 2019 06:46:56 +0000
Message-ID: <MN2PR18MB25289C051D88D59DF844E667D3E20@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
 <20190617114528.17086-5-skalluru@marvell.com>
 <20190617155411.53cf07cf@cakuba.netronome.com>
 <MN2PR18MB25289FE6D99432939990C979D3E40@MN2PR18MB2528.namprd18.prod.outlook.com>
 <20190620133748.GD2504@nanopsycho>
In-Reply-To: <20190620133748.GD2504@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8377841c-8b9e-493c-2251-08d6fa0214ba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2814;
x-ms-traffictypediagnostic: MN2PR18MB2814:
x-microsoft-antispam-prvs: <MN2PR18MB28146974B359E74DA66C1FDED3E20@MN2PR18MB2814.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(346002)(136003)(376002)(13464003)(189003)(199004)(7696005)(25786009)(102836004)(6436002)(6916009)(3846002)(6116002)(6506007)(68736007)(76176011)(5660300002)(53546011)(14454004)(33656002)(55236004)(186003)(53936002)(256004)(476003)(107886003)(486006)(2906002)(6246003)(446003)(11346002)(4326008)(9686003)(66066001)(86362001)(99286004)(55016002)(229853002)(26005)(316002)(76116006)(478600001)(66446008)(7736002)(64756008)(81156014)(54906003)(8676002)(305945005)(74316002)(71190400001)(71200400001)(8936002)(52536014)(81166006)(73956011)(66476007)(66946007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2814;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I3rnKUBLRTJRQJmWC6aX8J9fT9LlfyVFa+KHpvXt4yL0wsVd7EaEb75k+CWgYIWMrVSo3WuH00v/zrIW4EEfiV+86kJHgcwLkM/RUtEXbpXUAtXTny9ZDb+Ri2dBd2VGqodvCD6w4DUuu8lu/n0Lk9SUCmZOL1QrAQ7TRpUDAF/jAjOf9A+eVDcdEpQdzqk5H5s4tZtEgrgA/PoZK1vmZH+h2G91KBN0d2CmG25HcGY34O6XPE4DjV/Ge/32OzOao6XnQo3rSjy69rDs1d8lZ40K/SN35IpQ5vl41Nl52RFvDcSbh0Yc5ImVmtypbRiCZfUs6zeysARxpXjMshIYH4lPo+N3UbctBqsKwG6X0LmmYMKL/4m3xREZuyWRkeszu1Zm0lWBJYzVFEfqlBQMxunXcnyotUYCYpQkdywgnyE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8377841c-8b9e-493c-2251-08d6fa0214ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 06:46:56.2406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2814
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_03:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, June 20, 2019 7:08 PM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>; davem@davemloft.net;
> netdev@vger.kernel.org; Michal Kalderon <mkalderon@marvell.com>; Ariel
> Elior <aelior@marvell.com>
> Subject: Re: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
> configuration attributes.
>=20
> Thu, Jun 20, 2019 at 02:09:29PM CEST, skalluru@marvell.com wrote:
> >> -----Original Message-----
> >> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> >> Sent: Tuesday, June 18, 2019 4:24 AM
> >> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> >> Cc: davem@davemloft.net; netdev@vger.kernel.org; Michal Kalderon
> >> <mkalderon@marvell.com>; Ariel Elior <aelior@marvell.com>; Jiri Pirko
> >> <jiri@resnulli.us>
> >> Subject: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
> >> configuration attributes.
> >>
> >> External Email
> >>
> >> ---------------------------------------------------------------------
> >> - On Mon, 17 Jun 2019 04:45:28 -0700, Sudarsana Reddy Kalluru wrote:
> >> > This patch adds implementation for devlink callbacks for reading/
> >> > configuring the device attributes.
> >> >
> >> > Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> >> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> >>
> >> You need to provide documentation for your parameters, plus some of
> >> them look like they should potentially be port params, not device para=
ms.
> >
> >Thanks a lot for your review. Will add the required documentation. In ca=
se
> of Marvell adapter, any of the device/adapter/port parameters can be
> read/configurable via any PF (ethdev) on the port. Hence adding the
> commands at device level. Hope this is fine.
>=20
> No it is not. Port param should be port param.
>=20
> Also please be careful not to add any generic param as driver specific.
>=20
> Thanks!
Hi,
   Could you please with my query on the devlink-port-params implementation=
. [had sent the same query earlier to jiri@mellanox.com (based on the copyr=
ight info)].

Kernel seem to be invoking the driver devlink callbacks (registered via DEV=
LINK_PARAM_DRIVER) only when the associated parameter is published via devl=
ink_params_publish(). callnback invocation path,
   devlink_nl_param_fill()
   {
                if (!param_item->published)
                         continue;
                 ctx.cmode =3D i;
                  err =3D devlink_param_get(devlink, param, &ctx);
   }
The API devlink_params_publish() publishes only the devlink-dev parameters =
(i.e., registered via devlink_params_register()), not the devlink-port para=
ms which are registered via devlink_port_params_register(). I couldn't find=
 any other interface for publishing the devlink-port-params.
I have manually verified setting the published flag for port-params (as in =
below) and, observed that kernel correctly invokes the callbacks of devlink=
-port-params.
       list_for_each_entry(param_item, &dl_port.param_list, list) {
                param_item->published =3D true;
      }
Please let me know if I'm missing something here or, it's a missing functio=
nality in the kernel.

Thanks,
Sudarsana
