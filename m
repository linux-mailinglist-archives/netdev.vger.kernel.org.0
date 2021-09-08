Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C88A403FA9
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350096AbhIHTQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:16:11 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:23280 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231734AbhIHTQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 15:16:10 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188ISaer020491;
        Wed, 8 Sep 2021 19:14:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=DkXWR2HB6g485xNM8ktupTQUxQ0O/jvy0Gf13uD0zhc=;
 b=AkoH+O+zTTnPdrvYGD1VJ/JJ90wqbOKROTaWA8SEetRd1Jii/W4X10lMbNLAzVs7nDKN
 WOvBkT9BJAQXLoVGbcued9VUzPNnEoBUxpYhq2BOySrDjLGQ9Es11y948qAkIK7CP8bG
 NcFwgthqqy9xboDIgyrO2LBud6UlSTHK3Hq9b4h/HXN41r3e8h8Zqj6YCSEgQ8UVceik
 SR4enEfjIk8L8vaLObmGq6qfly3vlM6Yu2Cs7lldHmY0BMIhsxB51WAhqscbVGDrar3n
 HMccEgSjfDatjHAH3Er2iYQT+Vn6fnwUT1Qb7kuHQa6UcK6f86lC/iMdIOMeD1/R2Eay eg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0a-0064b401.pphosted.com with ESMTP id 3axcmtgwec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 19:14:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mE9HG9XeMoGlxNZvrbbETsK4XfhDgvuKRs67bVhQJUAu3opaRro3PR/IsNbJdpKHgeGn+V5wjKdYqBdMRGHBYcgLx1eZVDwzW00TWQ6e8AlXB9i4j2GWbbNzw5oONVQ49j9PH6gy19cdiFHjVzjCr8Xb0ivvooDm5/Jl38R7qPJbdY8A23weQyqBt4LFZ+tgC1y5WrmbTqVoMB/vzXrEPanjsnonDt3A+d6P6QUfRxNdFN9fH0T8A2qFWqM7lVZnPQHGDEj6sOY5uBThIseIbc1mZFV4mZNyL/m+yd3Nvh7OF7YwcdMuOUpiussrZT7v9WzYkcDUekWdnO3W2tH1Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DkXWR2HB6g485xNM8ktupTQUxQ0O/jvy0Gf13uD0zhc=;
 b=ORIpVu9xUzhutnxI7LGHux1RyvukpqDwVvF7gLkf5huE0wNrmCEj+jxkbhBcgcQqyX2KdLE6uwnDvK9mkWJS5Y7jMQcjuRIxQ2C7+SmxJozMxNys9ehtk1OjOxopQlXyyLQ39tJX0W2gFI6wOhgXmj/ahgqkehulCcgLE5H1mt0PGKipFWalfQa5gucyt6cT1R94JqMuPEY4BWnLdso3tdkSjnVgBKzOoHg449JxvEfFciSseklviC+djvg6CJjfCG44nDr325+dNf7q6SBYMTqcXsWuNXzlUD8hE2cshQ7m+OvLeVusW83QXjHioYFbBi4j8bDXNES1x2svDGpCSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8)
 by PH0PR11MB5157.namprd11.prod.outlook.com (2603:10b6:510:3d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 8 Sep
 2021 19:14:48 +0000
Received: from PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::c596:d88c:c3b9:4498]) by PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::c596:d88c:c3b9:4498%7]) with mapi id 15.20.4478.026; Wed, 8 Sep 2021
 19:14:48 +0000
From:   "Liu, Yongxin" <Yongxin.Liu@windriver.com>
To:     "Ertman, David M" <david.m.ertman@intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH net] ice: check whether AUX devices/drivers are supported
 in ice_rebuild
Thread-Topic: [PATCH net] ice: check whether AUX devices/drivers are supported
 in ice_rebuild
Thread-Index: AQHXoGM4f+39cn/Pe0yRGN5zNh+YEquVDRoAgAVgnYD//5VjoA==
Date:   Wed, 8 Sep 2021 19:14:47 +0000
Message-ID: <PH0PR11MB517545D35B7B90A5A3FCA3A1E5D49@PH0PR11MB5175.namprd11.prod.outlook.com>
References: <20210903012500.39407-1-yongxin.liu@windriver.com>
 <YTRweH4JMbzUtxLf@unreal>
 <SJ0PR11MB49752B60CA91811492A9341EDDD49@SJ0PR11MB4975.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB49752B60CA91811492A9341EDDD49@SJ0PR11MB4975.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e0df46d-1dda-45f6-e5d2-08d972fcecf9
x-ms-traffictypediagnostic: PH0PR11MB5157:
x-microsoft-antispam-prvs: <PH0PR11MB515713EA18652A494C218E5FE5D49@PH0PR11MB5157.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 52QMcyGZxyWJz11iozeCkGvZuuMuvXG3gSaD63POXpqIZdoirkcRjdLyLSORQ/1ViplNsClJJ+vkXj84h6I4xEGNwBI6OUr0KiXiNwTrg5eWtqKEaII2Caf9WJsI7NtiKYPb2wEbv50OBcgSsU5uTLD3C4Usp8Ur06WGmVKZgh2AtPiH6iJYVZJvj+ApErO2ycTM4yqsZL8vtQhE0LSUJlYnIEAitRGJkcc6Izd7HxLdSI+nNG8UngnYq7Zu5oi0Qq/umeRpXJm2CU3lokyWb8LE5M5n8NTKEQxFfvFeMU2wwFsfU6zsEnVmOQDHm6fJWVnQHplqx3DYbo7fHxdOSERJiJyjJqYMDkO+DO2m9TXOCcysX1vbC9ic4EZmEcrFXx34XwG0JSsLT2GUPoizahu2wSFUv97Be8L1KwXb2Rf43a38yL1DTcZgRA2SsXlveXQSvAFRPWKJ7BWSLEZeCjwCkoccMglGNnUhUWZPEWABn+/ZVCzUz8nbygqEblO44yL47NmFpMCD1wvlJc5wkSmoumIKfg3AqhOjqVI4jkITaHG49+svacmdYe7xGe91hTmIlfFdTddcrgllLRbXOpLLEo/D3gTSAyR3WPklBX1biYKExnLzOkNJQvHA8h0lUVtT/HcVtGI+A0hnBRkfBoObrJURhMeb7n4wMPget/1Xd+1T0aX2rfeeLWFiTBhUdOjybIMy5bv0NySiEVMoFmTXpUo+bhE1FqSd7C9u8tk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5175.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(396003)(376002)(136003)(38070700005)(5660300002)(8676002)(76116006)(53546011)(66946007)(26005)(186003)(86362001)(6506007)(110136005)(66446008)(64756008)(66556008)(54906003)(71200400001)(66476007)(55016002)(33656002)(7416002)(122000001)(478600001)(38100700002)(4326008)(7696005)(9686003)(2906002)(83380400001)(52536014)(316002)(8936002)(9126006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qGJgf1nxZKXilTCxe4ZZ9Tu6gsgyjVOboJv4OdC3xyaJxIl+nuFhTCe/e6Vt?=
 =?us-ascii?Q?4sN25l+bNREAiRYp4JnlkFuMUBq/dR84A9FVy8uihioF3sltR3wTY8PoNvCx?=
 =?us-ascii?Q?5UVVwrNGH0XxOGz2bOqEStmpi+yez9Wj5z9fqSFQqjfFXlS8ln4lGdoj1uNw?=
 =?us-ascii?Q?PIivG4drOUnyewKSVJtuxkMwOuv4UjMrBlRkaOUzb2JDGDpZjGIbqrpkJtPP?=
 =?us-ascii?Q?UCuDeKAiGyPn2jlWYMo6NfxUXNu8sy9GtngcCzDYHbIpLCdcnRxaJLzmGD+i?=
 =?us-ascii?Q?kWYSxyQTcKdtEzLHDXr956CaSIeu9fbVSluLxX1RS3/WThMQjY7uZBumasjt?=
 =?us-ascii?Q?28FH7snz9qJ4PEQZVNDlMbZRATtDI8XlT3GuMMgFdtmXwk7OAR6eeoC3I0zV?=
 =?us-ascii?Q?iMkzANUQIKWqt8G7zLw4fEUp4+wWQlbaGIa783Gx1QBPkaa2Sl2d8WKqfzLa?=
 =?us-ascii?Q?LOFpwXRz+Nh5ddVkrP7qvj4YigX1fi3Z2g9xxCuqdYM050cjCND63B136vJ7?=
 =?us-ascii?Q?mvpITasGiAX0cIzBvquVlKhLVCusMFjnycd3/MdTk5V7mamPcdd9JxXtWOub?=
 =?us-ascii?Q?wMFZ9O1mEv1v0+EqtFN2Z5QgpsF/6e3JoRIu85CyC46i2PypTncnXI8gDY07?=
 =?us-ascii?Q?64hXGAEvCFWpFkH4ZVTgPtbkM2Ikym2z1xGuOoK1lb4GnsbBAzD19WYi3iCP?=
 =?us-ascii?Q?I5tRm0o+I8rRKyrFcVu1QIJj9pp8p8JtTENY7tFm5puWbRyYLw4VIvYHypF9?=
 =?us-ascii?Q?sHs9jj7grOauzRlEOsdvxmZzWa4MGo3UMR6JcnhappgeiiuD6zMkYe5b2UW/?=
 =?us-ascii?Q?wckc3BoCE7tvrCgIwS6Sg7FjfvGgZLUtSDDuCuHDe6pjs2jnPMVkrlkq7qYN?=
 =?us-ascii?Q?kesM+Z4rz2crIXR75Qlq+IMLh8M1ycxshveyFJ+pm6nbDIr5k1BPZcd8JcU3?=
 =?us-ascii?Q?5t+EtGtLt+HcalxHNzu1tjo4VgNlwnpA05BlVa3tlBj6rBNAzVa6UwSTx7kN?=
 =?us-ascii?Q?C2kvGx79ewMVSO2/GDGx6d44dADpRS0y8DHDuM3K7IaBpliKymmHBFR+Ly3s?=
 =?us-ascii?Q?erJHOE0YDRTNhfuZpwosGAQ/kU5q+/XHm6ltFqPcxfoGxZEpTBxkwkYbptj9?=
 =?us-ascii?Q?evJHWxtDFFxj7IikbEpCSTLHzz3bGspIdBXhmAEbuEWIR3/M0jazzAOdLMIu?=
 =?us-ascii?Q?SJlm7w3odXKWmF68GsjeFc+FlpAsu+Edx+RrRu65doTZS7lomMQFfuTXlLHD?=
 =?us-ascii?Q?ZXjTXy8GIQXrFJDNQZVLkDdq5U0+ESjJ5QikLjgIFejOKxKAlwLHF5uaJApZ?=
 =?us-ascii?Q?PvY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5175.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0df46d-1dda-45f6-e5d2-08d972fcecf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 19:14:47.9893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wY3vWU1gGQsLWIKE+toIQdYwpcS+uU5n2siSXVCyinW23UBx7ZNJ16YKuWmOgSK7hNxQwUPRJopemgKPprkqCV2CyoLnYm73hquWgFHn7is=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5157
X-Proofpoint-ORIG-GUID: y0YwVxZOz6wFDfQ8L1f9aJOgINH3TpMA
X-Proofpoint-GUID: y0YwVxZOz6wFDfQ8L1f9aJOgINH3TpMA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_06,2021-09-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 clxscore=1011 mlxlogscore=999
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ertman, David M <david.m.ertman@intel.com>
> Sent: Thursday, September 9, 2021 1:31 AM
> To: Leon Romanovsky <leon@kernel.org>; Liu, Yongxin
> <Yongxin.Liu@windriver.com>
> Cc: Saleem, Shiraz <shiraz.saleem@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; davem@davemloft.net; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; intel-wired-lan@lists.osuosl.org;
> kuba@kernel.org
> Subject: RE: [PATCH net] ice: check whether AUX devices/drivers are suppo=
rted
> in ice_rebuild
>=20
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Sunday, September 5, 2021 12:24 AM
> > To: Yongxin Liu <yongxin.liu@windriver.com>
> > Cc: Ertman, David M <david.m.ertman@intel.com>; Saleem, Shiraz
> > <shiraz.saleem@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; davem@davemloft.net; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; intel-wired-lan@lists.osuosl.org;
> > kuba@kernel.org
> > Subject: Re: [PATCH net] ice: check whether AUX devices/drivers are
> > supported in ice_rebuild
> >
> > On Fri, Sep 03, 2021 at 09:25:00AM +0800, Yongxin Liu wrote:
> > > In ice_rebuild(), check whether AUX devices/drivers are supported or
> > > not before calling ice_plug_aux_dev().
> > >
> > > Fix the following call trace, if RDMA functionality is not available.
> > >
> > >   auxiliary ice.roce.0: adding auxiliary device failed!: -17
> > >   sysfs: cannot create duplicate filename
> '/bus/auxiliary/devices/ice.roce.0'
> > >   Workqueue: ice ice_service_task [ice]
> > >   Call Trace:
> > >    dump_stack_lvl+0x38/0x49
> > >    dump_stack+0x10/0x12
> > >    sysfs_warn_dup+0x5b/0x70
> > >    sysfs_do_create_link_sd.isra.2+0xc8/0xd0
> > >    sysfs_create_link+0x25/0x40
> > >    bus_add_device+0x6d/0x110
> > >    device_add+0x49d/0x940
> > >    ? _printk+0x52/0x6e
> > >    ? _printk+0x52/0x6e
> > >    __auxiliary_device_add+0x60/0xc0
> > >    ice_plug_aux_dev+0xd3/0xf0 [ice]
> > >    ice_rebuild+0x27d/0x510 [ice]
> > >    ice_do_reset+0x51/0xe0 [ice]
> > >    ice_service_task+0x108/0xe70 [ice]
> > >    ? __switch_to+0x13b/0x510
> > >    process_one_work+0x1de/0x420
> > >    ? apply_wqattrs_cleanup+0xc0/0xc0
> > >    worker_thread+0x34/0x400
> > >    ? apply_wqattrs_cleanup+0xc0/0xc0
> > >    kthread+0x14d/0x180
> > >    ? set_kthread_struct+0x40/0x40
> > >    ret_from_fork+0x1f/0x30
> > >
> > > Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide
> > > RDMA")
> > > Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_main.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> > b/drivers/net/ethernet/intel/ice/ice_main.c
> > > index 0d6c143f6653..98cc708e9517 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > > @@ -6466,7 +6466,9 @@ static void ice_rebuild(struct ice_pf *pf,
> > > enum
> > ice_reset_req reset_type)
> > >     /* if we get here, reset flow is successful */
> > >     clear_bit(ICE_RESET_FAILED, pf->state);
> > >
> > > -   ice_plug_aux_dev(pf);
> > > +   if (ice_is_aux_ena(pf))
> > > +           ice_plug_aux_dev(pf);
> > > +
> >
> > The change is ok, but it hints that auxiliary bus is used horribly
> > wrong in this driver. In proper implementation, which should rely on
> > driver/core, every subdriver like ice.eth, ice.roce e.t.c is supposed
> > to be retriggered by the code and shouldn't  ave "if (ice_is_aux_ena(pf=
))"
> checks.
> >
> > Thanks
>=20
> Hi Leon and Liu -
>=20
> First of all, thanks Liu for tracking this down - it is an issue that nee=
ds
> to be fixed.  The ice_is_aux_ena() functions only purpose is to determine=
 if
> this PF supports RDMA functionality.  In probe(), the aux devices are not
> even initialized if this test returns false.  If this check fixed the iss=
ue
> for you, the PF you are on does not currently support RDMA.
> The bit this test is based on is only set one place in the driver current=
ly -
> at probe time when we are checking the capabilities (common_caps) of the
> device.
>=20
> That being said, the call to check this should be in ice_plug_aux_dev
> function itself.  That way it is taken into account for all attempts to
> create the auxiliary device.  There is another consideration about disabl=
ing
> RDMA that needs to also needs to be taken into account to avoid a similar
> situation.
>=20
> If it is acceptable, I will create a new patch today and get it out eithe=
r
> this afternoon or tomorrow.

Thanks Leon and Dave E for your quick response and input.
Please go ahead and I am expecting this issue to be fixed in a more reasona=
ble way.

Thanks,
Yongxin

>=20
> Thanks,
> Dave E
>=20
> >
> > >     return;
> > >
> > >  err_vsi_rebuild:
> > > --
> > > 2.14.5
> > >
