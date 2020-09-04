Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5917925D3F2
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbgIDIuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:50:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38832 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726575AbgIDIuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 04:50:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0848kLKe011029;
        Fri, 4 Sep 2020 01:49:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=2y1nM9q/dkuXYa3LJUXVUuQVPJWuly1xCiNvvA/wehc=;
 b=UZOa5xmQCOx3PNhKnRI0YJputQTWHlOk4pBWcctXU4EgqR2kvm/zMxDjLKRz+A1c3n2h
 J4h8nbXBQM+l49XsBOKUO/yQSZwcrX/SkrpfpKMpDuYIZNHEZNuW+EjLY4VwmmHgnAcN
 z4VPvYPgmUR8+OkXEoEeXP3vTRc5ZvU3SnnlA0HXH9gIdKTkeVocpaDZ6btj4ppAHnuG
 UMcVnx/YyB9xDTHmO+CsVbogy5SYUSrEUFCE0svaa9gJPsScDuSgh6EKvmw/tpwcGYjt
 IL9dnkzrsvPJ69A4X+oa+vMdXEPnoTNLnTfn8og7fJw8RLyleV/GEv9L/JxRyE2Ei2dj ig== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phqgtvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 01:49:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 01:49:50 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 01:49:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 4 Sep 2020 01:49:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JM5Y7Rxykj2S3ItmqF3dHscqcY/Hzc43oxLaML9NdU+bJ1y1aL8hnsI1OoqOJVSLePybtbe2JC7DDxomSD1hBWFqhN+ZAn0iXCuLFSnL4ooCY+2jrJP77/vG224TvBWrvOIFqsZbLD6ZPUxadTqDTMCCuAZthZxGkKwDEm77SWU+87KlagDq6J3H7uG1S1hoDR5MlsHewQD+My80lEAVG4orEndC0QXb1A8lbCoBfhqUjE7XRGbWWM7jv+KYAhbt/21YP6OOdqKmuMBcmapZYWWwnoH8XEZ14jRSTiDDNZzs9nnoGEvwA1gvLZ+vOVK81YiblbssI6EzbOZKvGZALQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2y1nM9q/dkuXYa3LJUXVUuQVPJWuly1xCiNvvA/wehc=;
 b=b/N66WmEe8rNuYWoPAk1KcSUQNFVt2JYzvoqKWx3B9H75nYYk4MIq60yyiAOVaX0xYOLyd4fLLW9CnXcmw88wM++s6xQbN3alCvdx94Al4KMxlPkJzSwZrEKMLjCP6ImNsjwuZ20+SPeF39Fd8C0guhZG/n8h+CLCPe+em9fGu8tCnY3+/X56E6wK1LEv8weHi1ZXH+PSP1JbLFahwpsgE7qNNY5vH4dVRSAp6ULw4kk0oqtOv6oHGfTn2nIE8FiYL7eZWQdkuWCM/XW+M7DYCpofe6CzbCBg3sQOOVlQrpyDSUwNMS213pf4T2wmr86a8oKk9UvrAK6QlsjLbJIhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2y1nM9q/dkuXYa3LJUXVUuQVPJWuly1xCiNvvA/wehc=;
 b=V9WcIQr872ZNu0ghpwQxPRTNLzkGoJ0KF1o1q6QHXh/h8OgCG9lBNG6sw8c0TFqdUlFG/ncHMgOrk5+iwA+pJ4e5gG37Vf3vJDTVCPpx2+CPbm5EeD+her+maw4lCgjx4uZ3bzo5xnuiJHUWG++G6Xj0QgVgAKl8evDw/VA9dCc=
Received: from BY5PR18MB3298.namprd18.prod.outlook.com (2603:10b6:a03:1ae::32)
 by BYAPR18MB2725.namprd18.prod.outlook.com (2603:10b6:a03:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 4 Sep
 2020 08:49:46 +0000
Received: from BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::fd34:4df7:842f:51c7]) by BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::fd34:4df7:842f:51c7%4]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 08:49:45 +0000
From:   Sunil Kovvuri Goutham <sgoutham@marvell.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "sundeep.lkml@gmail.com" <sundeep.lkml@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: RE: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Thread-Topic: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Thread-Index: AQHWgickhZqxv/ypi0Wop/9//E5UfqlX9gtAgAAyzoCAAAHrkA==
Date:   Fri, 4 Sep 2020 08:49:45 +0000
Message-ID: <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion>
In-Reply-To: <20200904083709.GF2997@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.205.243.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f2f286f-5f25-46ed-c022-08d850af7964
x-ms-traffictypediagnostic: BYAPR18MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2725BFF4A44260FE1EA28B73C62D0@BYAPR18MB2725.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bUyZmimtNOUB1Bqty01WMtLdxKGaOAWkOVSBu2S2ByRQNLnNM5Q8hiO6p3HhouAt49QDciiwlj4b3YanjJVqJ2K3yLuxfPrgH5zqHPYpht2MRfrDu57HaCgocRhBCpoXspCbyjSDK4KOetGs4k5oE5CgS0voaAghJt+OYWOXbo8cD+bqTdKCuE4vfpQoVL59adBtZvOEP0erpJ3PjTiOTcjOzOSOQbCT700WCnlaTKMq0lu44MEwcX+sdiLfVZj38lxKqaJKwp3KZmfLPOpdIkXe3MMEA9eJZxFKuaqMwluOwaTy+icfOT6191UdQcSO3rLMWnGZeXaKkHzx8V0XDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3298.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(83380400001)(7696005)(4326008)(54906003)(186003)(478600001)(316002)(33656002)(107886003)(6506007)(53546011)(6916009)(71200400001)(55016002)(26005)(86362001)(2906002)(66556008)(9686003)(5660300002)(66446008)(8936002)(8676002)(66476007)(76116006)(52536014)(66946007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GVnwtLF2IybwfsFs/j22y671IdO0p8cM4jLe2F1iZzKkAT4ybMQC7QqyyQz0klQ99xUuNHrBOEDmzIEFLLKmbXuzEkDsobFCQNksWSaJ/rpVYCWNoKX8NL3V6InkG4QBsRzAPWHjoKDbyvfrUCOqzNyZVsirVlR8+WN4v/jwWj00ZdqEZ7yXPUo2FFsThBX2bUwzW37kbnV+cruuTx8t94hp8cW9fUkrRqmUMULgIx4wvC7w6Ex2Hda+I841lDVKx6kO55WO8eVYUT/ULCLM6q6bSfVgMNPs3I9O0V2pYxRH3U2bRSaL59Z9Fp+0RfLDFP3kX2yXrgapGVkY2XDfP6XrcEr6a5sQ4WbGGT+SxXlGwvnX9xui+kA10RXDUJ/4kpmzyYpuwnSJO90o4rvSqh7XAnlaR2HGEoqplSt8Es3OX29pUceKWI8ZOYwzJbfAmrqMvhrarBjQx0NEzkz9p+lDRZ79pdXMdUfBEkL6810Yii4VArLaNb0WxaAjQvXktkBAm1cmgSilTC9PaWXjVm3gzTs3m+geQebwvxwHnGBEcqoSlFigD7ZLynvx4f/UDRn2GErneqFWcyf/khEagGC4WxG8yLDRPdi2ZV+PA+Y7m5Q6cy8RIaDB2qcVj996qIQjPhUKz913bKDrC0tggA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3298.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f2f286f-5f25-46ed-c022-08d850af7964
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 08:49:45.7650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QLUVXMoV7G+GOUyPinFuhCky5rpyP3jyTvE9XrH9MrvxIG4NZmCFb8lNibe4SLlluBc8QZ88xN14qXQ6dswRZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2725
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_05:2020-09-04,2020-09-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, September 4, 2020 2:07 PM
> To: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; sundeep.lkml@gmail.com;
> davem@davemloft.net; netdev@vger.kernel.org; Subbaraya Sundeep
> Bhatta <sbhatta@marvell.com>
> Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints fo=
r
> Octeontx2
>=20
> Fri, Sep 04, 2020 at 07:39:54AM CEST, sgoutham@marvell.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jakub Kicinski <kuba@kernel.org>
> >> Sent: Friday, September 4, 2020 12:48 AM
> >> To: sundeep.lkml@gmail.com
> >> Cc: davem@davemloft.net; netdev@vger.kernel.org; Sunil Kovvuri
> >> Goutham <sgoutham@marvell.com>; Subbaraya Sundeep Bhatta
> >> <sbhatta@marvell.com>
> >> Subject: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints
> >> for
> >> Octeontx2
> >>
> >> External Email
> >>
> >> ---------------------------------------------------------------------
> >> - On Thu,  3 Sep 2020 12:48:16 +0530 sundeep.lkml@gmail.com wrote:
> >> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >> >
> >> > This patchset adds tracepoints support for mailbox.
> >> > In Octeontx2, PFs and VFs need to communicate with AF for
> >> > allocating and freeing resources. Once all the configuration is
> >> > done by AF for a PF/VF then packet I/O can happen on PF/VF queues.
> >> > When an interface is brought up many mailbox messages are sent to
> >> > AF for initializing queues. Say a VF is brought up then each
> >> > message is sent to PF and PF forwards to AF and response also traver=
ses
> from AF to PF and then VF.
> >> > To aid debugging, tracepoints are added at places where messages
> >> > are allocated, sent and message interrupts.
> >> > Below is the trace of one of the messages from VF to AF and AF
> >> > response back to VF:
> >>
> >> Could you use the devlink tracepoint? trace_devlink_hwmsg() ?
> >
> >Thanks for the suggestion.
> >In our case the mailbox is central to 3 different drivers and there
> >would be a 4th one once crypto driver is accepted. We cannot add
> >devlink to all of them inorder to use the devlink trace points.
>=20
> I guess you have 1 pci device, right? Devlink instance is created per pci
> device.
>=20

No, there are 3 drivers registering to 3 PCI device IDs and there can be ma=
ny
instances of the same devices. So there can be 10's of instances of AF, PF =
and VFs.

Thanks,
Sunil.
