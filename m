Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14423A3F36
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbfH3U5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:57:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14062 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727304AbfH3U5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:57:34 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UKrs06003523;
        Fri, 30 Aug 2019 13:57:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WQ9vc+LMnRSlnfQimrSxmXy4hqkgCWw5WaN8OinDI9M=;
 b=nDgtNT+sUiBCBqkXGVEaX1mtpzG+y/1PdZIHr9rFGKUoX3UYIzk1baq9dO+fQWrHq6OI
 zql+Htw5b1rnJqZBoeZTKmA72TWZr4Ezfivkib6ODuNAo0k+cKZCszx7xVR0onU6wDEZ
 azJcGjpTVzBdYVdeV1SB2EK8vhVgH+Ruy6Q= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uprfd4u4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 13:57:24 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 30 Aug 2019 13:57:23 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 30 Aug 2019 13:57:22 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 30 Aug 2019 13:57:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiifSt+8m2Utkib71Vs5fzANzfM610gkSyGOmzUKQOyw1123J/c3L89slbN5UDifA5vjLBT0BxdFKHgBPVCYtk2y5XWzCnhOs5Jd49mtfOUCzOecng35Jv0GUAIvIMvzrfV/Yc23giyvWD7ZM6AiI5wPrAeYKLA3zTfc6odOOOEU1LRQ+4eDSdjvMyiAOkoynUPqJfT0nN7g/5ihJHK5IIOinL4cpFbZQD7cKA8uJMdSVtYQuDzpyKuL9/tD7Veq/EJPJa/v7QkgJI9moJpvvRlJb0MoaJ99VVNqGEBzNpSW8Z5k6Sr5sJUtEZuv61iznE4bb3we2eZk6ZjK8cJpGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQ9vc+LMnRSlnfQimrSxmXy4hqkgCWw5WaN8OinDI9M=;
 b=WW8c7HIaQVRZKE8PvJCjzLBLaM+pSu9tLVqY/3OxrykvkDronrIoXCQVAw2dRM+ypdlq3lXFI1stJ7i8CwYeHoK8Q9ik2FAHq/jnEItERCooNgw6BcmAT1NMbaKmbVDXUxVdvT2ezrUxooTP26h8D5K/4k0VkW3TVXyR7gscR4yHziodeuD7FQI/INN7jf0jNX32YcJblnosD6DcI4mqBnzJimMWh5eyQXrfC6Jx3D7AjzNI+Kwi5/nuVsJae75Wow1A8GMGFwLvTVaf3KpkVtXVqZGt0K9t1x+nPyLTGs92ljH0LMT/TifOT6pE4lP5DujvkxwrmgNpB1VVGTURsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQ9vc+LMnRSlnfQimrSxmXy4hqkgCWw5WaN8OinDI9M=;
 b=DJiPbmYvYEAm4VKkCxh3M67Nv6kzfE+y+doNYHLw7T9jpqMyoVD4sJHjSeDtAwWrYllJIlBzCSprwvbpv//ZQVulvjcbZI4JsjnlknCwIz0EuCpE8sH2356eCuVemL4a6ul44CN8KdPNh4hndHAl1I39Qp1Yg8LfGVJk54sWit4=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3736.namprd15.prod.outlook.com (52.132.228.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Fri, 30 Aug 2019 20:57:21 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c%5]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 20:57:21 +0000
From:   Ben Wei <benwei@fb.com>
To:     David Miller <davem@davemloft.net>
CC:     "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next] net/ncsi: add response handlers for PLDM over
 NC-SI
Thread-Topic: [PATCH net-next] net/ncsi: add response handlers for PLDM over
 NC-SI
Thread-Index: AdVdK7Dkb5gbkg6XQAi/YA23MivgTgAyLPMAAGApfFA=
Date:   Fri, 30 Aug 2019 20:57:21 +0000
Message-ID: <CH2PR15MB3686B906CA6E822D69F3C225A3BD0@CH2PR15MB3686.namprd15.prod.outlook.com>
References: <CH2PR15MB3686302D8210855E5AB643B1A3A00@CH2PR15MB3686.namprd15.prod.outlook.com>
 <20190828.160032.599086044004802986.davem@davemloft.net>
In-Reply-To: <20190828.160032.599086044004802986.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:6945]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1f69af0-dd7e-4862-2a30-08d72d8ca71f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3736;
x-ms-traffictypediagnostic: CH2PR15MB3736:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CH2PR15MB37369DCEF8F35F3B4C097F7EA3BD0@CH2PR15MB3736.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(136003)(39860400002)(199004)(189003)(2906002)(86362001)(7696005)(11346002)(14444005)(476003)(229853002)(99286004)(6116002)(81166006)(14454004)(33656002)(81156014)(4326008)(25786009)(6436002)(46003)(446003)(8676002)(53936002)(102836004)(6246003)(76176011)(9686003)(186003)(54906003)(6306002)(6506007)(8936002)(71200400001)(71190400001)(7736002)(52536014)(6916009)(76116006)(5660300002)(478600001)(316002)(74316002)(486006)(66446008)(64756008)(66556008)(66476007)(55016002)(256004)(966005)(305945005)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3736;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jADPi299rSSxMtHccBU+IBP4nUyrOUS4Q/u1Mkx3MsqoP4ukhsn0ZAD9kGRIo1GQ42kCcE3jVsLaj0CnsVUS5HzlKfA+dIStKY/XbRPvYeZfQ6Y8C7otvAiOA9m92zM7XHTdGuTILN/iePATJ9OM+nE7LCIInchu/iNvcBza2ZG5JxVk6GlI8fM1GDMZBEahw7OWyO0bLS/99QL2FyBUZ6haoi4OeZQqSzZZB8Y5Bgwofg+6hU7uiXtsViVp6KfAQg6VdLHYd5Z1aY/UBFhKnfsHIUtd4DigFGqPeNGaAQoIWfEf0xVgoi8S5LWuVUjRe8Pr9QH2iTDHN7pfHROEU97PRtKJQIyA0Md+4zoO3YoOSWkrUzEzE8auKFdf11DDWfIAcm79vFj+Z2aszW3OkmloDYKfR/Dpv9I1RUWrxRA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f69af0-dd7e-4862-2a30-08d72d8ca71f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 20:57:21.7733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 34gd2OY0ZsYZzJ2axKRBMOJBCtUaBS5JthFAaUuu7z3uRjpWx8H5OviZLGV2atnI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3736
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_07:2019-08-29,2019-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=784
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908300200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > This patch adds handlers for PLDM over NC-SI command response.
> >=20
> > This enables NC-SI driver recognizes the packet type so the responses d=
on't get dropped as unknown packet type.
> >=20
> > PLDM over NC-SI are not handled in kernel driver for now, but can be pa=
ssed back to user space via Netlink for further handling.
> >=20
> > Signed-off-by: Ben Wei <benwei@fb.com>
>
> I don't know why but patchwork puts part of your patch into the commit me=
ssage, see:
>
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__patchwork.ozlabs.o=
rg_patch_1154104_&d=3DDwICAg&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DU35IaQ-> 7Tnwjs=
7q_Fwf_bQ&m=3DvxOIQa5Sv7aY4LKSUvlobJd_TtHOz1KLjxZw8WXmkJM&s=3DA8rpxgac6iuSE=
H2DqCSzBDdM82Eu3pD8_nGHx9YtGW8&e=3D=20
>
> It's probably an encoding issue or similar.
>
> > +static int ncsi_rsp_handler_pldm(struct ncsi_request *nr) {
>>  +	return 0;
> > +}
> > +
> >  static int ncsi_rsp_handler_netlink(struct ncsi_request *nr)  {
>
> I know other functions in this file do it, but please put the openning
> curly braces of a function on a separate line.
>
> Thank you.

Thanks David. I think the issue is related to my email client setting. I fi=
xed it and resubmitted a v2 version of this patch.

Thanks,
-Ben
