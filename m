Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3452BFE42
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 03:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgKWCtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 21:49:18 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29006 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgKWCtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 21:49:18 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AN2ksDb025569;
        Sun, 22 Nov 2020 18:49:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=xHXcU843iH45OU/HheEh/3T8yBAeMTunUJCdg6eiYCY=;
 b=hMu1Sky4ewG8OBjH35bJwV2xtMBbsyOsbwwWnJcOjMOi8Q37/dom9srzxexJgPzeS78D
 MvvGl38G9yEdDs81YaMUjmZYI64UpsdJepkKcXdaAo5QxHFfOfT31Divw5Tc9PPcK5Oy
 3KO08w2OV9PWPa2pKPNEssbpvbvn0XlDa1/xhKawT1CIjocQLQkKXvnZLlQmdfEwoReY
 aZV1zQO8cetRnUA6+/8YhazqhNNVX59uXbzBB7WCytaCytNP/poZtHa/63II3oh8N1Qf
 lWX2lWFTeOkPlq05O3asb/N91G0/m7bfD+7zpBJRsfDrNlgHqL2DQfb2vRp9fWakdTni WA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r3v7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Nov 2020 18:49:11 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Nov
 2020 18:49:09 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Nov
 2020 18:49:09 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 22 Nov 2020 18:49:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcJzg27smZLbRoEjbfNVkZ7FGr6KLIrxetR8uZ7VlLzelFqBX6GYO9/XZeqCbG/xofo/pSjiVwZARxJcXHT12b5rHh0/twBRt26re2hr4I5lNmcFb5i43xNjhyDTHcpnouXgedUJzBSc9SynCv7PNROeNL1RMnvo1YfSJrI13aKYGomPyp1fLglvLmZFQ+q/XMCo6hReYYVAQtEOti+CAKZ8NiwbsO6vric5IdxISI8oVUYQVpfcJ0sbh+44RLFBoWLde5y5r9434t0/8XG17y/HVG7gr7g4oQ/Hpc1wvRtVtODA7ktXfMPbZJqwe140QUnwGU4sfxbmVGIZN57LYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHXcU843iH45OU/HheEh/3T8yBAeMTunUJCdg6eiYCY=;
 b=JuMx85OgSo9x0yAShQrB9Peu3OKnWguctmIxfU71OHt6WaSAxmXY9+2OAKH9lb7z42QSFApgzdKvTBV7Ek5CWGLKQdBT8zqbuij5V4tOxCsKWBMo9Q4uicx3OtXww42CizgzjBJQWGpVRxRJM1kaB+UpPOl4tq4foDSiOqQiFVR+89CRsZjuBK28cSNHXlDHCzskffaZR8kd/ikIcdb/9HWojknP71Ft+ehGwYF28sxWYca/w4vhMTs7YVK2djQqeLUk82tqDJQ2g6wniQoWMefz3o90abqc4gxvOGpNKC3WaYB7n0Ogk3btZNIf2MG0lxr5akVbVC5zhW20UHgsjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHXcU843iH45OU/HheEh/3T8yBAeMTunUJCdg6eiYCY=;
 b=MKbfVl6Ju2ngCe/eMGFezZCnOVlnRAueVVLC1/B/Rn/iwX+oKRCWTNx7zhOLZPNmAuMNj9aLm1OfW76KbH6zZNZOEkXeX3woJHQJY0KAEDoQ6oUIveeDLFHI1zqvtiqk12Bee/xqJd9jAOfriG3SekVfiODCI2q+W5/lzdpLLpU=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by BYAPR18MB2902.namprd18.prod.outlook.com (2603:10b6:a03:10f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.25; Mon, 23 Nov
 2020 02:49:07 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a%7]) with mapi id 15.20.3589.030; Mon, 23 Nov 2020
 02:49:06 +0000
From:   George Cherian <gcherian@marvell.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "saeed@kernel.org" <saeed@kernel.org>
Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Topic: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
 reporters for NPA
Thread-Index: AdbBQev7zGu3StU+Riy1ChUQhWNnmA==
Date:   Mon, 23 Nov 2020 02:49:06 +0000
Message-ID: <BYAPR18MB2679FA2CCEBC4E921C3E078DC5FC0@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.68.99.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44f8b30a-8a95-4e16-de35-08d88f5a588c
x-ms-traffictypediagnostic: BYAPR18MB2902:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB29029696BAF96D0740C16C8AC5FC0@BYAPR18MB2902.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Vjq+2Dm4vWOjUmY1Tgq8SAS4U62k7QXQdpXyPUMtQcDxau68w6/rwj6FNx3J9LoxdLSa4PekAHyCbNFuLWBWSENDN1OGoHAGHtkhbJQmV3JDnOnfiioDC+BU7gsJWwXITFBkp9Isl8hTX6Lt774E1UbtWKyitAQ9j0DAvUxMC1C+sSSpo7U6ygyGfq7DIPP/1BlngagEM/1/92G9nqN+0aUAI2MruAnavMkNeGkgNgBVjNwrpGJiHlA4tzcvtI4PzgRsiX35E77f2Zd1gJY+FEYgHx8kpB3qW2ghRSAdGFGo0Y6U31QBDaKfNCUUTwSbuEn7mASOuwG+KsIPFGsdBtoPddNk2qo/toucAcOPiLL6WTs8WUDM4c/FZTH1yqzT/fXcjj5lSOoqNHZbpzUrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(136003)(39850400004)(5660300002)(33656002)(71200400001)(8936002)(52536014)(4326008)(86362001)(55236004)(478600001)(9686003)(83380400001)(53546011)(54906003)(8676002)(6506007)(316002)(7696005)(2906002)(186003)(26005)(76116006)(6916009)(66556008)(66946007)(64756008)(966005)(66476007)(66446008)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YlqapqEBEqqcGXC1IzhLXMmKluYiQWensuWeW+hzT7nshgccwcSXdWmkWtatg+0H6Ax+M3jnUW7xkZvs7cKAXs4EMyObuUMeXqRLX4KEgHAe1EYifwWJlGp817gn1XV87morxSqI7iiPepPnyjbIxO5FwV9EixsN+QxOiqYvL1DI9hq+ST0NgHeis0v7HxY/8vOse8//hRy/sQjRYiV1C1UCHGPsJXrnoHVpfDVdUVaoL4Z+R16e28OJlBErte0uf3ZyLLZHqVunOqYas5ug7jpySw+Vf0k0kAyrq2eS2rN/r0cLHsNsP/TLihGPjlrfvlauFmuiZbaAkZ2FI+SRmM3/QkSQnnpcnEH8cydMiDDQfPiHBwCmTmV8OoTh/hX7KsQIZKQ8/totOP9DpdO5uJCPq7rgunZ7Rk2qqQjhj5moiNOCbZx3CUFwKl0oW+5arVR1ZDHPs+jxf1sbVMYXbkHSmm5n1tgdXA1s6qGbFmtwIQyz3afJm5UC2lf/AvL8A/8lwZ9oaetDughqteQ47FXAH24vQukOg6kUGRm+K2HUJ/Nl4BZLkSM7psH6e2WsxKgMUp2iB2Z5trsPFQSQQ2S/Jr/TzCgAAeJq6SvmJF3L1YwERaovSym6oVs7/tU46qYeIgnP6XifKyGJ0pSEV5GQ0I2EKd7f8jkRhbCP0a+o/Do+S9iglh/raxmjH5GmoaFsAoubA4cwsKemsRBhWllokuL+VhKScITGNLNJICRIcMAY8Bn7pq2lHMkY+jLQph4Hhh1xGS+H2suu8Xgg4OoavtlGQX+5fmWuzMVlp3bNlhuolI5PDQ5VE8scOmjFxtwOGiBFT98PRqpey9BamziJeM3QEfsIZYp2KBfJKhyj1qYkGGRD0Xeqhy043SJ4cLIgC9wR5YMeeZvaDkQXvA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f8b30a-8a95-4e16-de35-08d88f5a588c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 02:49:06.7521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gS+Hax49ELND1uoDWiBGs0kGmmihDmLxK5E6bL3BLpjq3BFKSlT8TJ0cXZlAoX1sK8LeAvqleOLnVy8S25vXGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2902
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-22_16:2020-11-20,2020-11-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Saturday, November 21, 2020 7:44 PM
> To: George Cherian <gcherian@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> kuba@kernel.org; davem@davemloft.net; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; masahiroy@kernel.org;
> willemdebruijn.kernel@gmail.com; saeed@kernel.org
> Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
> reporters for NPA
>=20
> Sat, Nov 21, 2020 at 05:02:00AM CET, george.cherian@marvell.com wrote:
> >Add health reporters for RVU NPA block.
> >NPA Health reporters handle following HW event groups
> > - GENERAL events
> > - ERROR events
> > - RAS events
> > - RVU event
> >An event counter per event is maintained in SW.
> >
> >Output:
> > # devlink health
> > pci/0002:01:00.0:
> >   reporter npa
> >     state healthy error 0 recover 0
> > # devlink  health dump show pci/0002:01:00.0 reporter npa
> > NPA_AF_GENERAL:
> >        Unmap PF Error: 0
> >        Free Disabled for NIX0 RX: 0
> >        Free Disabled for NIX0 TX: 0
> >        Free Disabled for NIX1 RX: 0
> >        Free Disabled for NIX1 TX: 0
>=20
> This is for 2 ports if I'm not mistaken. Then you need to have this repor=
ter
> per-port. Register ports and have reporter for each.
>=20
No, these are not port specific reports.
NIX is the Network Interface Controller co-processor block.
There are (max of) 2 such co-processor blocks per SoC.

Moreover, this is an NPA (Network Pool/Buffer Allocator co- processor) repo=
rter.
This tells whether a free or alloc operation is skipped due to the configur=
ations set by
other co-processor blocks (NIX,SSO,TIM etc).

https://www.kernel.org/doc/html/latest/networking/device_drivers/ethernet/m=
arvell/octeontx2.html
> NAK.
