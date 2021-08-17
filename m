Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A663EEF61
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238359AbhHQPrr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Aug 2021 11:47:47 -0400
Received: from mx0b-000b4001.pphosted.com ([148.163.143.220]:53504 "EHLO
        mx0b-000b4001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230369AbhHQPrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 11:47:37 -0400
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Aug 2021 11:47:19 EDT
Received: from pps.filterd (m0143840.ppops.net [127.0.0.1])
        by mx0a-000b4001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HFD69v031116;
        Tue, 17 Aug 2021 15:25:31 GMT
Received: from az1-msa-prod02.server.ufl.edu (az1-msa-prod02.server.ufl.edu [128.227.74.23])
        by mx0a-000b4001.pphosted.com with ESMTP id 3afq3404xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 15:25:31 +0000
Received: from exmbxprd14.ad.ufl.edu (exmbxprd14.ad.ufl.edu [10.36.133.40])
        by az1-msa-prod02.server.ufl.edu (Postfix) with ESMTPS id B16F140071;
        Tue, 17 Aug 2021 11:25:30 -0400 (EDT)
Received: from exmbxprd26.ad.ufl.edu (128.227.145.170) by
 exmbxprd14.ad.ufl.edu (10.36.133.40) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Tue, 17 Aug 2021 11:25:30 -0400
Received: from exmbxprd27.ad.ufl.edu (128.227.145.171) by
 exmbxprd26.ad.ufl.edu (128.227.145.170) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Tue, 17 Aug 2021 11:25:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by exmbxprd27.ad.ufl.edu (128.227.145.171) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Tue, 17 Aug 2021 11:25:30 -0400
Received: from BN6PR2201MB1732.namprd22.prod.outlook.com
 (2603:10b6:405:69::22) by BN6PR2201MB1266.namprd22.prod.outlook.com
 (2603:10b6:405:20::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Tue, 17 Aug
 2021 15:19:58 +0000
Received: from BN6PR2201MB1732.namprd22.prod.outlook.com
 ([fe80::f163:3de6:54e2:72fa]) by BN6PR2201MB1732.namprd22.prod.outlook.com
 ([fe80::f163:3de6:54e2:72fa%4]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 15:19:58 +0000
From:   "Yavuz, Tuba" <tuba@ece.ufl.edu>
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "oneukum@suse.com" <oneukum@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2] net: hso: do not call unregister if not registered
Thread-Topic: [PATCH v2] net: hso: do not call unregister if not registered
Thread-Index: AQHWmLFJUXxOb9bp30CoMp3KZfB8UamGkWoAgAB5N4CB8JquAIACH8ms
Date:   Tue, 17 Aug 2021 15:19:57 +0000
Message-ID: <BN6PR2201MB173238B760C0E5B72428E2CF90FE9@BN6PR2201MB1732.namprd22.prod.outlook.com>
References: <20201002114323.GA3296553@kroah.com>
 <20201003.170042.489590204097552946.davem@davemloft.net>
 <20201004071433.GA212114@kroah.com> <YRoLSvowhZsyKbOk@eldamar.lan>
In-Reply-To: <YRoLSvowhZsyKbOk@eldamar.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: debian.org; dkim=none (message not signed)
 header.d=none;debian.org; dmarc=none action=none header.from=ece.ufl.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d12a8c02-8ace-447b-6f5f-08d961927997
x-ms-traffictypediagnostic: BN6PR2201MB1266:
x-microsoft-antispam-prvs: <BN6PR2201MB1266F9B760C78BD3006EFF4690FE9@BN6PR2201MB1266.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xJxWOD49L7apb++7aVhY9UN0foFfI2Sxw0k7ArPkMkIwPi/GlXsAp4CSpI5TxnjUojd2bmQDe4S+BPecEnsmYYwLUcxLYfFtuBOaVgye3K68kNdH2VKz0SF8+sM6b4aCIyB1+QqZBFv4TpRraza4TbpGxJ4PlDT229JRwO2qAn8Iu8tsnnQNrs3/UtJ7iJHdBi/XIiJSJgyOtr2efYS4BLGZQAP0gWLE1oNT1U6rqo31H0FWTBtSjOK8d2G1dhh4s5ApTvEjFacdcQPppnYLJw/DdH43nFiazFvTcOHkIQXVvbIUNgPnxrl0kOc/1sOakzO+v90uqyV+MS1LVxhMc8mePIkhbT7RueEHOXkmceu7IB/tuEMm74wfpGRMZ2m7PRK4x4tEgxk+7E9mIRzkE5r0ofM3O26z9YJf7c9OxADtxk55fR/huSd6yyyHKKdg9ijmD2suNuwR8oQoEaFAjOux5h1Oau8HX+ExArJPcyonXjtW/S3rh3fpNx78C+kGZRmSgtPHrVaOZTm6ro+FIJcy964rd30hi6HrJFi9OYD10lMnJWHUBlUHQE7z9XRjjqGeuUoR4CrD2krAkyH/zFo9PhvM0eUZ6BfluItV5zW/ivPO4V+3d61k7xBqtiHCILRNUxUirXZkJVyx5UvNxMGFZHtUuZrNwKjjcP9NfyNZfUe7cafM+bpHqBiZZSZvaJMAInxY8/rTQsDYyEARGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR2201MB1732.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(75432002)(6506007)(53546011)(2906002)(122000001)(508600001)(38100700002)(86362001)(8676002)(7696005)(38070700005)(52536014)(66946007)(64756008)(4326008)(8936002)(66556008)(66476007)(55016002)(54906003)(33656002)(186003)(9686003)(71200400001)(316002)(786003)(26005)(66446008)(76116006)(5660300002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o0QbKzFF6Yl/aaGBUmQgypAM+VgoCvZoxnMKS3IrMNV6ZC5waqAklzPtRdB0?=
 =?us-ascii?Q?ag4u0PK//1nb2XNFegYegY5pq7zTfB3c8iej87hwtBdCpEeGJRw6KXr2NpEQ?=
 =?us-ascii?Q?yfQF/PJhVqGQcUHT/9HXviKPfDh5DEXKD69wAbb0j4pHZejl6Cx8oEmvFpeL?=
 =?us-ascii?Q?XZbLHWWvSrZZ9elz1XvPLjyhP/fkcz4L0udpyWJk3Nf0nDNlADnichlYInEy?=
 =?us-ascii?Q?PZ0J+w5wdplCyuFMLZYpggGVAi5LFZctA0avG0ookG9xtqLdvV3q6ZSiO50E?=
 =?us-ascii?Q?UpUbNydaDVbnhheE9We37HKyq3Yvymygkqc0IVVxtyJ4D28Z0lgrEBeUWzi2?=
 =?us-ascii?Q?mu66iCZMTMjwktFReeWHVHI58fKWQrx+XD6w83ZmkpKURMO3un4SMSIXuuKf?=
 =?us-ascii?Q?GSu75ORM0qe0uZVjHUHNvXDLhnmPv7pniAxVpxLubK3CS0TFbEg8PqOVFbpm?=
 =?us-ascii?Q?nLPCnb80MA/sWYCPriUtz6mLMPp/koaRH2Q5gLEQB8FKwwH9QZ83oijWY9Z7?=
 =?us-ascii?Q?NJ/Zh+OxSxRP6EE/rZVyopnNPDZuGjyBCgGEEsIKYXwkXsrL+vCLm6tPu8de?=
 =?us-ascii?Q?7aA4WsclOlLYTBZmwoFCPO22Qz0bQuGj3h/Y9Sk9umBaDdkGh1MUOGDltBtC?=
 =?us-ascii?Q?ZyufJJhCTCfdXICCKr5OySt47hHl4QbRjViiFWLlPyRoKmwCd85IXtFiYZjW?=
 =?us-ascii?Q?O9K8CbyxtbjsSLWmdI6gRMkycUMygdkd7K4McdxcjphFaCYdGBOcssLrvCyo?=
 =?us-ascii?Q?OF2ABL/I6U5ZgNWPAqroQJx8x5/3oTjmYL8tclKZgE4Ol4VUuCyRGIR5umK5?=
 =?us-ascii?Q?77Cx+2JOdJzcGibMY/XS6tiqy0gdRVdo3Go///oEB9BEXktFeMZFPXNq7j6f?=
 =?us-ascii?Q?kZTpx1yhGtBxLB6GsrpZp7b0P7EXraALD+5wZV2blz6+/fmJjb2ZxNjDU0wt?=
 =?us-ascii?Q?AzmS9Wz4LQw/rmKVK2qYjEfZgb84z4xMnHO5uab688X2ACyannfRfrEuJxm8?=
 =?us-ascii?Q?yOxGOBdvSKrE1lusiP6i8VVaKBsGjCOCzaFuG/Ktoy316AipNFQYrousIEM+?=
 =?us-ascii?Q?cxkE2IS/Zr88QLixrIBwfXjzahAGgAJw4Wtr27XHleiXmgN62GSF0pLr9Ni7?=
 =?us-ascii?Q?2gKRtJL8s1k+37CmjLo00TlycP6g0rbMLQ4KT3rwUF7hkv2Wg89PpA6uzKq/?=
 =?us-ascii?Q?bDkemqGcYEcy3LWJws1S1rEsd+fLzMPrOpclk+EMEXgFUajIZEleWpn/aLQ7?=
 =?us-ascii?Q?rgMWZWHD+WlzxLZxVVNJ+wt68AaDzjaPJWZLh8jCB4IS6YFomW9bs3Lao3JH?=
 =?us-ascii?Q?RNY=3D?=
x-ms-exchange-transport-forked: True
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrEFPh++bz7oGoLb83vruzwY1zgho2Mt2BBi0TmcFLV6j/TWpABPehNaNSxJXcIzsvHPFOdp6YAIsyFBataYOzI4wdrrKlFrfRZqOqd8L9xAE0ynbQyAHHAN9rwqYIq409Xwfd8smutD0OO+iQk8ZUKyRd7ClbZlF2k2Cef3/ADqGWgUN8xcYWzNewZb+/4576Vvnb6w7zG2vjUeMi+HxSs3Q+Qgogihka9uHDgaKljeDostL0MKvlpG+D9XyOG5E2eiSRZxS8L745nlRG7T1TbKSJl4niLB/xXV/PlVDKwYBX5z9Ln91O7JzSjJfnbYGbb0CdB1RgVdyBTPuuDkRw==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Yyrcuez/HhEhxtbT5WrlnITeKRUtz5TWe3syI3ERE4=;
 b=DmyJ3cF5vPS86xeDqDnD/nXniGrnphThK8WEHOZEfcZJ+TG396CtEqb9Kyk38Xe7y6qUB9Tkp4T7CmQqJhD1nm7RrflfIXOiOwfEWEhpUa6q8IMuPSQf+cGRk18veFivIPO0n8em+1xv4U6G1Dyv5/t9wXp2rYF6a9/ejBpiGmWMVkWHlz8tLF/yOyXo9fs9u2czAasAIJWXDpdx+vYcr8Erlm0JNkqSRwejxiFLqkhnQyQvBdlr7KaN17rIya0vTDw8dtwsXAsnG52m4xD1DJYIPwvDwJqjHzAZa4WLdVRHID4EIuGnvIZj97HLLp9SpwHoAzlJbikgv+0MiWEdTw==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ece.ufl.edu; dmarc=pass action=none header.from=ece.ufl.edu;
 dkim=pass header.d=ece.ufl.edu; arc=none
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: BN6PR2201MB1732.namprd22.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: d12a8c02-8ace-447b-6f5f-08d961927997
x-ms-exchange-crosstenant-originalarrivaltime: 17 Aug 2021 15:19:58.0444 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 0d4da0f8-4a31-4d76-ace6-0a62331e1b84
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: m9aCYVoNt6ZDLai5xDec8pNhiRErtDQCo/mBtt6ShzuxickN4v6YMb+lRe5RhiuZ
x-ms-exchange-transport-crosstenantheadersstamped: BN6PR2201MB1266
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: ece.ufl.edu
X-Proofpoint-ORIG-GUID: lXqRPhaojZffiZKC4xR59Jt_jFTitYt7
X-Proofpoint-GUID: lXqRPhaojZffiZKC4xR59Jt_jFTitYt7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_05:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 spamscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108170094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Salvatore,

I think it would be best if one of the developers of the hso driver could develop a patch along the lines of David Miller's earlier suggestion.

Best,

Tuba

________________________________________
From: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com> on behalf of Salvatore Bonaccorso <carnil@debian.org>
Sent: Monday, August 16, 2021 2:52 AM
To: Greg KH
Cc: David Miller; Yavuz, Tuba; netdev@vger.kernel.org; kuba@kernel.org; oneukum@suse.com; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] net: hso: do not call unregister if not registered

[External Email]

Hi Greg, Tuba,

On Sun, Oct 04, 2020 at 09:14:33AM +0200, Greg KH wrote:
> On Sat, Oct 03, 2020 at 05:00:42PM -0700, David Miller wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Date: Fri, 2 Oct 2020 13:43:23 +0200
> >
> > > @@ -2366,7 +2366,8 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
> > >
> > >   remove_net_device(hso_net->parent);
> > >
> > > - if (hso_net->net)
> > > + if (hso_net->net &&
> > > +     hso_net->net->reg_state == NETREG_REGISTERED)
> > >           unregister_netdev(hso_net->net);
> > >
> > >   /* start freeing */
> >
> > I really want to get out of the habit of drivers testing the internal
> > netdev registration state to make decisions.
> >
> > Instead, please track this internally.  You know if you registered the
> > device or not, therefore use that to control whether you try to
> > unregister it or not.
>
> Fair enough.  Tuba, do you want to fix this up in this way, or do you
> recommend that someone else do it?

Do I miss something, or did that possibly fall through the cracks?

I was checking some open issues on a downstream distro side and found
htat this thread did not got a follow-up.

Regards,
Salvatore
