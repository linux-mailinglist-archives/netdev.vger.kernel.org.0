Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A4C2CC697
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389783AbgLBTZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:25:24 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:65472 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389776AbgLBTZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:25:24 -0500
Received: from pps.filterd (m0170395.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2JGvEs027966;
        Wed, 2 Dec 2020 14:24:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=OkVeZ9s/9y22LM6sLS2fpR6C2ILrW+dWk6Lb9wzhUBY=;
 b=uCbmkQ9duLsdH8ZdC2psqIvoSftJZCJuy4MXq1Mdw7Oo/boFIt/b1lQwFROFRm5vzKwH
 ChDD3KjoDVDpm6Q1kCBk0vVfvDLj7+YgqCfyrIgvQfvBGjExoFgg9e1ZjW4+wRQS4ReU
 5uo1uyeQauXA6q0r5UCx/d0CsY3fyHQezznLnoRf0rMHTLI/c26tZKnfimiRXZE6e/rU
 25LgZodpfM71PjG7qeO7uIsrzTlvCt6wIU0lFOpLsSLa3DFeXauhkstBlg/qzL2ecnoT
 cmgSW9VSo+cGS3Z7YAwmadALN/QoKUIlklIixtpuo/y1wRXfyXOH/bU7FXEuiPwrse6+ 4g== 
Received: from mx0b-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 353m3t9gj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 14:24:32 -0500
Received: from pps.filterd (m0090350.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2JLcub068453;
        Wed, 2 Dec 2020 14:24:31 -0500
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0b-00154901.pphosted.com with ESMTP id 3568jhrenp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 14:24:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNtlUy5LETeez6iIKIdhT9whV8aciBJLe2xL3QC/lJwySbzfV74a+1zDWsLqCViwd89GDg/X384LtpTM1w46f/AWVBJvLQXAIqCSgoVuWmbEAYj7IDRo5VFCMTofGi84qkjR6Kv//9TDCxJSMZRbFB6iPu5LTJKHVwxdwqc7iLkKs6mM4XUfrer73NHtEXOxgUj6mAbniKlu9EH5jyoM7fCiqhEHqN/inP6C8/Hu9daoigiMvxTVaLmyBCubnrRLsaBhttPgpWTrD/w9cwV1tTcf9x/ttQ+fUEUAbr38nApy1EO3EzW9D+pbVUK+y7HXXi29djFXhwZeMp4ypRrMwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkVeZ9s/9y22LM6sLS2fpR6C2ILrW+dWk6Lb9wzhUBY=;
 b=kguh7GkCaYZkwO1P6l6OlnI29BjWKSZR3dWOP7Rrwf76uH23YqhCR8/lqkuP5VCtmoH2z4GsB3sgQkLekRSNU25DHkpeoccL7RWtsYwqTRO1ZWxjz2HNwksn4Pd+TqBHMnAlP1jpJrox0pRo8ELQ7Sad8lNt2lVpMArhlS9yweO9lMS8b0giAgqvtW9RyGif8LZtQEZR/hsVk6GH9Jxkgz1kMgok/QNufeX/FeOXjKgrI4pCr0YfGv0PExz2iE5iReDxonT9Rc2nrzcPCEIDNRIYwKpOPoMYhxJ9dvfnG88gD7llpTzGXcora7NrOKJqnn78P3g41HvmVNW4zE+FLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkVeZ9s/9y22LM6sLS2fpR6C2ILrW+dWk6Lb9wzhUBY=;
 b=fR07rISp9h8uUITaDWrVjmOED9CWkKQtKZlT3Dqdgyu5yOzHQ+XafMOv3YuY/Jlzs91E1IDCYuOajPNlNn6oj+O1kxmt3Tg5sw+1SSVx1DMqOaQbUAVh+/CQFrMJ996TBjxNwwdsM5nEvWAnaMRXLwalCQPbn/N7ypq5T2MlJyU=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DM6PR19MB3212.namprd19.prod.outlook.com (2603:10b6:5:5::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.20; Wed, 2 Dec 2020 19:24:29 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914%7]) with mapi id 15.20.3611.032; Wed, 2 Dec 2020
 19:24:29 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>
Subject: RE: [PATCH v2 0/5] Improve s0ix flows for systems i219LM
Thread-Topic: [PATCH v2 0/5] Improve s0ix flows for systems i219LM
Thread-Index: AQHWyMa4QDPSYh8b4U6WaEiBVk3soKnkKvoAgAADISA=
Date:   Wed, 2 Dec 2020 19:24:28 +0000
Message-ID: <DM6PR19MB26365E4B4EA330B499A325CBFAF30@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <20201202161748.128938-1-mario.limonciello@dell.com>
 <20201202110640.27269583@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202110640.27269583@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: helgaas@kernel.org
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-12-02T19:19:36.3276232Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=51c6d241-61d4-415d-b38c-2956cf9716c3;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f33b21e-61e1-4a3d-b241-08d896f7e390
x-ms-traffictypediagnostic: DM6PR19MB3212:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR19MB321240B3817F6315FF49BD16FAF30@DM6PR19MB3212.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U6NYc5hhhLxOsALoq7km6ZPwEZjNr//PwCOaDEh7xyfi31qyCm5Yt2id4MX4jSmADS7bK076sk9UsT3h/0iWCqTTcVkUh3Xe4c0GsD5zQ9vaeKcqzS8opfDeJMZ/S5P4UuBCD04HeHQvNKfw8bcfQK3bmKT8yRY3XBE7GnvZvx7h3yh8Q7gCTYQuoNRkNiOfoYdD+pqjUtUu1U9zNEpWkmWdXzE0tG/C6WCnzk0dlDxlfNLew6L+W+X/yW1YYayB9xjh3cU0s8GdGjpmg0C4TH+c06JSCzJOOwcnWHOdRPpoRhSb+Dl0EJjeb9yjlQ9u56/xyvq0CRcQ3j5F6KwUBAE/OXmt4+y/ZrB4X3ATrXyYUZ3noEh+mBpjyZeO/n2ZNxPbpL/x02wdhqz2mttiiB7sCAIC6pFVoHytH6fp3sMxyeBciQvvVQ8RpMpNG5qs2aUXVR5gBbC73mCR7JNqTKz4rtMj77EX2WbKOVbgq0g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(86362001)(4326008)(5660300002)(316002)(33656002)(8676002)(66476007)(55016002)(186003)(66946007)(64756008)(76116006)(26005)(66446008)(66556008)(52536014)(53546011)(83380400001)(966005)(7696005)(107886003)(786003)(71200400001)(8936002)(2906002)(478600001)(7416002)(6506007)(54906003)(110136005)(9686003)(32563001)(6606295002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fcf6fCKyP5UMqpOE8HtsSiWBonXM7GJIQ0EyJ7Syl/1TeQi8bXVXPe5Iegk8?=
 =?us-ascii?Q?bQunBZW9vkp36Xz7n7eb5RaWJDzC7+dE2YZEAGfwR3W3+wP9YNn9Jd4Il60F?=
 =?us-ascii?Q?+UXJg8N7u0tobD8uFDZpErHEd7znmGrRzCKGTig+p3PILF2qGRbYKL5f9fjx?=
 =?us-ascii?Q?JzSQKiopcZ1nYOgq2i7QIAUUV2BYvWOmCBeoPiJYxw4WRuwMWkwy8F0iSIMt?=
 =?us-ascii?Q?wBAZErur5dyyDL5p4TZWWSarWEvsvDl3i4NAwv8YgDiVF01TzK6dR3U7721M?=
 =?us-ascii?Q?y3h0Ezcs9wCCSiiiL10ZXxLNFq70uCOE1oXgXXm+mi/E+w6qePxNsLlodHkn?=
 =?us-ascii?Q?PfhIzVBAMwEtph0BlLnC05pCIA2NU2ClPj07nABkHrYf/VtFXbJJF+vvFIZv?=
 =?us-ascii?Q?6nqh/lfpO0pN2luBUw7K28YM5DGAXlYHTRhmkSVlT4r7EqXE9VVOBRGIIL+B?=
 =?us-ascii?Q?oGiPtQL7VufKhd0tSGnSAEfDNE28reiqZQZzxupvZLahcScpFiIutAvE7E0X?=
 =?us-ascii?Q?X6lBYHtEWu+dcEqpdlldzpyd/tQYcrL+VNjiFmJxPWCyV282VMZmGHygm8+H?=
 =?us-ascii?Q?hWhIygjci8ej4sX78bscCDoHwEpR3U+f2JPFXle6mZj7MGAUdf2Qt9ChIZl4?=
 =?us-ascii?Q?Cx9OYvFZuSzlt3y779T95WM3cjLkqSTGLpExSjoJ/nvyljXeXoVolEk6XDEo?=
 =?us-ascii?Q?hXnuXWpON/0offGhXnkBNKeVWmpCFVulIn6IiE6bSydgbmqMN3immTp21ivf?=
 =?us-ascii?Q?7ElhJ0o1Ag1+grGFn/ldixjhiBRHWQq0/Vdz3vYbRrHLRPJSy8+01o1up/AO?=
 =?us-ascii?Q?K/COIxTd9thSeMg2NIC+nsEig9/cgX8XLfeO4M7KoLwCLvAzYVsrXqnK82Z1?=
 =?us-ascii?Q?O3IGCPi4bwBEjMtM5o7ynI+CESHmgOD7PRzDkkrwpNQzxKqPNAZNuqzlT2s5?=
 =?us-ascii?Q?lHJE+bUMQmTQ+gvEHiRIyR7v0cWxCZPx/YmdPrPLnAg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f33b21e-61e1-4a3d-b241-08d896f7e390
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 19:24:29.0715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G09tPiXv5JMRa1k3w+a/Kr4qiFHCDgi9A6y4fZ33QWDKJpygiuz9zap+U4iJm791bhePh137Phgx01eOc0B7q5vwPc0LNgKt9p5/+saYFNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB3212
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_11:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1011 phishscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020113
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 2, 2020 13:07
> To: Limonciello, Mario
> Cc: Tony Nguyen; intel-wired-lan@lists.osuosl.org; Linux PM; Netdev; Alex=
ander
> Duyck; Sasha Netfin; Aaron Brown; Stefan Assmann; David Miller;
> darcari@redhat.com; Shen, Yijun; Yuan, Perry
> Subject: Re: [PATCH v2 0/5] Improve s0ix flows for systems i219LM
>=20
>=20
> [EXTERNAL EMAIL]
>=20
> On Wed,  2 Dec 2020 10:17:43 -0600 Mario Limonciello wrote:
> > commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME
> systems")
> > disabled s0ix flows for systems that have various incarnations of the
> > i219-LM ethernet controller.  This was done because of some regressions
> > caused by an earlier
> > commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case"=
)
> > with i219-LM controller.
> >
> > Performing suspend to idle with these ethernet controllers requires a
> properly
> > configured system.  To make enabling such systems easier, this patch
> > series allows turning on using ethtool.
> >
> > The flows have also been confirmed to be configured correctly on Dell's
> Latitude
> > and Precision CML systems containing the i219-LM controller, when the k=
ernel
> also
> > contains the fix for s0i3.2 entry previously submitted here:
> > https://marc.info/?l=3Dlinux-netdev&m=3D160677194809564&w=3D2
> >
> > Patches 3 and 4 will turn the behavior on by default for Dell's CML sys=
tems.
> > Patch 5 allows accessing the value of the flags via ethtool to tell if =
the
> > heuristics have turned on s0ix flows, as well as for development purpos=
es
> > to determine if a system should be added to the heuristics list.
>=20
> I don't see PCI or Bjorn Helgaas CCed.
>=20
> You can drop linux-kernel tho.

Correct, that was intentional that PCI (and Bjorn) weren't added.  Since I =
came
up with a way to detect platforms without DMI as suggested and this is enti=
rely
controlling a driver behavior within e1000e only on systems with i219-LM I
didn't think that PCI ML was actually needed.

Since you disagree, I'll add Bjorn into this thread.

@Bjorn Helgaas,

Apologies that you're looped in this way rather than directly to the submis=
sion,
but the cover letter is above and the patch series can be viewed at this pa=
tchwork
if you would like to fetch the mbox and respond to provide any comments.

https://patchwork.ozlabs.org/project/netdev/list/?series=3D218121

I'll include you directly if any future v3 is necessary.


