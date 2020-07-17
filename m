Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE952241D8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGQRdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:33:18 -0400
Received: from mail-dm6nam11on2132.outbound.protection.outlook.com ([40.107.223.132]:53011
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726090AbgGQRdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 13:33:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hgym1Qo+1/ba/dsg9RLQFeVrk+dwaVGK8+dlWulWrCDDfmjKIyAIreZIGhlmHbulOhu5C3L5gRd2XYfvnpiTdgCS55LtuVgUBUY7Hta07gYg5Kxah6jZADDIF5Rt+p9NnLA76GxmPVTsSFO85Pe0lyRSQeXmxAHb4YJ3HWoEH4N+gq5UYONgIIBkjwryA4Z9Pn4JgBnb6ej9XypJ3fAd4BbSLqxV2NRZHGhgdf/2pTNodCXOi8ME309pHY2qw8+Kvg3Y3ijhPaLJ6XXvC/ZG8EylU+AwcINFQsEzzRaWWAcnzEdHjLFreLuXwE9g3fAJVJUcz28GrWG9UnFUDDRV9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNMzJDxwcwAthU7J4GppMMAYF8dMWAcftzoiC2kJZ1I=;
 b=oEADTyeB603hnTyxNjPU7QQMS1xYWpWHQ8Ln6zJ4Athvmu24iVSTQOUMyVeIdPxcio2F5BAwcxOx5cF0+PYmQVPL5owpE4FIlf89C1bx95PG0aB21Thw+0L+enZczsviNUfIZxqpusIqHkXFpwFNll+GyyF84IiZZT1fEGJZ7MZ18g/WRy4HGf2EJ8LYGAh/vD//0qkI9rMsTa55uzyGI+xNsgO/BOCHQSdRi+dBAK1H0NA8lxcr5+BTbkWfoSRP1VhH9/DV8j6iKsCq04jbRMrWpGf0Y0JVtpiOvz7PFfWECqwbigjq/0/r75IhyIC6cxKtnU3tpU7MLMqgOB993Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNMzJDxwcwAthU7J4GppMMAYF8dMWAcftzoiC2kJZ1I=;
 b=Mkxw5LhlcyQ3JUtN1o9ZQ1E6YpZemtW5brJAslCSYjsHvbBIXt5xJ1KkOTS+F5QQtRleLHZIN7gKBQ+zOOReSAQIBWNEECsgohDtCe37LTYcb21yAVVI1twiqhesi5VE4cP9i0No682Gjwm4h+TA08jbORfUtNnGpskOHRa4osQ=
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com (2603:10b6:4:a5::36)
 by DM6PR21MB1225.namprd21.prod.outlook.com (2603:10b6:5:167::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.7; Fri, 17 Jul
 2020 17:33:15 +0000
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::88cd:6c37:e0f5:2743]) by DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::88cd:6c37:e0f5:2743%3]) with mapi id 15.20.3195.019; Fri, 17 Jul 2020
 17:33:15 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>
CC:     Chi Song <Song.Chi@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>, "andriin@fb.com" <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Thread-Topic: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Thread-Index: AdZb/5iAkDMuWyahRIOBehKiULg7mgATtGGAAAFgBuAAAcsygAAAsQeAAACKiOA=
Date:   Fri, 17 Jul 2020 17:33:15 +0000
Message-ID: <DM5PR2101MB09345765A15DC9F03AADB7B6CA7C0@DM5PR2101MB0934.namprd21.prod.outlook.com>
References: <HK0P153MB027502644323A21B09F6DA60987C0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
        <20200717082451.00c59b42@hermes.lan>
        <DM5PR2101MB09344BA75F08EC926E31E040CA7C0@DM5PR2101MB0934.namprd21.prod.outlook.com>
        <20200717.095535.195550343235350259.davem@davemloft.net>
 <20200717101523.6573061b@hermes.lan>
In-Reply-To: <20200717101523.6573061b@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-17T17:33:13Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c806d5b1-7276-4183-aff1-a0e05585cc2b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 117819bf-de4f-41af-daeb-08d82a777ca4
x-ms-traffictypediagnostic: DM6PR21MB1225:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1225BDA193D1095B038B2FCECA7C0@DM6PR21MB1225.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5AfwNNgeztAZdeI9OC4j8WwMtFV0veZGXWolbJn2vSpcj7FQKGn0NPl8HdyF9euIdeGdIz+EpK9dAAYmJ36u1n7QW00nDvF4Dc1P0m58uAn/ACgJ5Ok1by0XoS6PLEqWQfu9YUs4C84mtU+D4f237DMtzkuALrWFVM1dLVszP7Qg5SNnSrtPtstxN2XACj+2EJRjdP3QiMinpFwMpzP0dyVbghxPH180QbOZBwlRwmn7l82jQZo67ZEvZDaqm0aUs8nR6vdMbKt8OVRX6nNUQFQQ3lyIWqNL1CIttnmWkE78fz+oxOsTyu/bpks0EWjzGnegVjgYq/QPo9eS1sQFAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB0934.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(71200400001)(76116006)(66446008)(8990500004)(66476007)(66556008)(66946007)(7696005)(6506007)(186003)(33656002)(53546011)(26005)(316002)(83380400001)(54906003)(86362001)(55016002)(7416002)(110136005)(52536014)(2906002)(82960400001)(9686003)(10290500003)(64756008)(8936002)(8676002)(82950400001)(4326008)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ONWJ3pNHMyuoRR1iEzO/TnZ3BO3TNFkJBn8RxItzDyZ1ik1XKgrQ3z8Snt4b53S7rIUo8kssxf3FCyeP5CVSLzKSdkkXngESzUfZpFW5yfjy2EXZvp1fb7Cm3E3KPXHv42nMFStPIsw420aVn8v02QwOaxFlNWS4qHwuPrxpPQDN7K5tTEYQMTO9h8iYSe8Jl0tlIyo0990Pcc0zz/vn9kJaXk7m6qKAwf0qlm9dwSNjN1GbrB4QLY25v3O59xJ5tEjwY3NqEU8t9T+jRGHNkTDeOoe594J7c8czV1hlSQd8UNR61tPgh2NJ5DMB5snHjWk5M5x0nsHGiyH/6E3aLa6nPJvkqCp/hBHf2/zKNChjrXtCjHF0W2MpyJQeLHBCT9y6U7cGhdbCQ83evsifRo+s9eFSJQF0V56Wk3q8YyTeJlcl/OMclBKWTfXy9Csbh2KvoOCTfzozZLcaXOYx8JiYvAY9agJY4q9qtnq8RG4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB0934.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 117819bf-de4f-41af-daeb-08d82a777ca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 17:33:15.2709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P8uR5xew2FFuEWkNSBfGIbpUwl8XETgOlg6uDuR7OUZbbZg7ZDb9uApEaqYrzF6+4MDUeRq3fMUpVFRTjP/i+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Friday, July 17, 2020 1:15 PM
> To: David Miller <davem@davemloft.net>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; Chi Song
> <Song.Chi@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org;
> kuba@kernel.org; ast@kernel.org; daniel@iogearbox.net; kafai@fb.com;
> songliubraving@fb.com; yhs@fb.com; andriin@fb.com;
> john.fastabend@gmail.com; kpsingh@chromium.org; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
> indirection table
>=20
> On Fri, 17 Jul 2020 09:55:35 -0700 (PDT) David Miller <davem@davemloft.ne=
t>
> wrote:
>=20
> > From: Haiyang Zhang <haiyangz@microsoft.com>
> > Date: Fri, 17 Jul 2020 16:18:11 +0000
> >
> > > Also in some minimal installation, "ethtool" may not always be
> > > installed.
> >
> > This is never an argument against using the most well suited API for
> > exporting information to the user.
> >
> > You can write "minimal" tools that just perform the ethtool netlink
> > operations you require for information retrieval, you don't have to
> > have the ethtool utility installed.
>=20
> Would it be better in the long term to make the transmit indirection tabl=
e
> available under the new rt_netlink based API's for ethtool?
>=20
> I can imagine that other hardware or hypervisors might have the same kind=
 of
> transmit mapping.

I think it should be a good long term plan, if going forward more NIC=20
drivers start to use TX table in the future.

Thanks,
- Haiyang
