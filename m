Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96284F8658
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346426AbiDGRi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiDGRiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:38:24 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188CA173366;
        Thu,  7 Apr 2022 10:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649352983; x=1680888983;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QRB4sLoI1xAXoe+hEwO2AMNxvsJ+fzuxyNd2YhUq91U=;
  b=kPqQhnf60BHjXjEMTP2nb8MG/cp/1n9sDD6RL4wUUgKZuw1AjchSAz1C
   flnhuu4AfSHBMYlAv+X3HtK0VPz+o9i6p4xZUBN4O9SE3col5sF/hgcsH
   NSAUECDxKmtPX8SQtHgbiSJ3uHMw4eMSr75Cc8KnMgd/g3TXHwSEi5Lzh
   NXAWTxey0oYV2jq9fJItVEeobo039Aq66B9xg8kplpkuKhVhKd0vswhkg
   JkBK38VdBvXHojQDP5y+oCOiVSl62hU9cGlvSnxvW1CMfN5doF/PA0EfO
   /XGeb7q2iPueOR/JCNznQRUVMokbHFGIfCXE7NiinSryEWf3UIjoCLfCj
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="347832991"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="347832991"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 10:36:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="609416998"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga008.fm.intel.com with ESMTP; 07 Apr 2022 10:36:15 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 7 Apr 2022 10:36:14 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 7 Apr 2022 10:36:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 7 Apr 2022 10:36:14 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 7 Apr 2022 10:36:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLWsPwOE0hrQzWzn46raABqPwcuvRC5ajxeh9M/lr3lpvGZL1otSdqNr4PoLDXzMAg0lGTgL3cu+URR0SepSEpbhX3HCtOXxqJqKHIhfJGeXNiLREZv3QQnBYEwZhvwPM9/06PCanwgcfHYiLh5M7rbjNYZC79wbCjc+wf4cbHWpdO8ARI6+qIEi8IyBk+jnJhMs36AScXCS8qWU7bgVr8e0g/8VQeexDD3JsVQrp6S0qm7j7zU7wp7SV3hVxV9ojz1E6OQUHjYzmHATyAQT5+s5BMG8apwUDxM7wOGwarrX55Smq8Th3JGNXCPK+HXVNunt3KCD7k44DAtKq6+Zew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pa8/unGzNurhqw/zAorZdCcX94yzz31Zge87Z0Pnk9E=;
 b=BQJrS8a7k1r4zNIzECo20YFGtDIp+v9kYaCFdEsmUo1kQFGoSThKdJvJZwMcZQ5oKzBJGrxfSLVj0OXa49LbAV+sMrcr50EcTRlB5Xl5xbthCYxklSoxA+AodM2z26agHTKKBgOYE83Q53F5dOJVI1SxUnjjXh0XGfscbveDQs7lMFTRjgh1E9HdwWOZE7gC/aWUdqWjJUvfF6IjBZgIppnfouq8k2RNROmkYxhnQsFTOT8HUzaSkKdUTDuj/xgXTrKSWltd0QnqsVK7ndhPPp1gf/Vdo/RkFaQoOOwaNwoMpozLujKSSqnw+gOQgFYHbpWciXsHdEe/ILOO60F9Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0029.namprd11.prod.outlook.com (2603:10b6:301:67::25)
 by BY5PR11MB4210.namprd11.prod.outlook.com (2603:10b6:a03:1bd::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 17:36:12 +0000
Received: from MWHPR11MB0029.namprd11.prod.outlook.com
 ([fe80::ac0c:4806:934a:636c]) by MWHPR11MB0029.namprd11.prod.outlook.com
 ([fe80::ac0c:4806:934a:636c%6]) with mapi id 15.20.5123.025; Thu, 7 Apr 2022
 17:36:12 +0000
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "duoming@zju.edu.cn" <duoming@zju.edu.cn>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jes@trained-monkey.org" <jes@trained-monkey.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hippi@sunsite.dk" <linux-hippi@sunsite.dk>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
Thread-Topic: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
Thread-Index: AQHYSkn4HJrzWeSt/0qrCBQuiFUlDqzkT6MAgAAY8oCAACnjAIAAHSXQ
Date:   Thu, 7 Apr 2022 17:36:12 +0000
Message-ID: <MWHPR11MB00293D107510E728769874DFE9E69@MWHPR11MB0029.namprd11.prod.outlook.com>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
 <20220407112455.GK3293@kadam>
 <1be0c02d.3f701.1800416ef60.Coremail.duoming@zju.edu.cn>
 <20220407142908.GO12805@kadam>
In-Reply-To: <20220407142908.GO12805@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0f5c653-50d9-4c36-9c06-08da18bd1c22
x-ms-traffictypediagnostic: BY5PR11MB4210:EE_
x-microsoft-antispam-prvs: <BY5PR11MB42103BE957664B2D34BEF442E9E69@BY5PR11MB4210.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xny8rlx/IQ5A3bmliW5ooJFanxKXNMz0SI7eLgV9YIDih9igBcLzORz8QsbwKSb6IFBJRm4Wtaxl7V/+GqBFuLzP9M1EQX8izPsElJgfsTAXbNts8uOkrXz8u0IaSzKDWesk661Yg8QxXou9DEsj2QJ/hs2AFrmxW7h9fY+nm5B1gS75BYy/Cw5lcJ9jFfFx+RrX/FLoFuAkSNZn2toC3vVG2xFI/X/z9XI4U42biBjN/xEPqrq3XvbRCKGDM/yZ6o39yGf9glWusUvmRtXhXKBkr0uJfZUBOveJ3i4r6K5KqFsefk1Z6SyqHouUUyshEjTI5Ao0NaA3nST6YCXYaYEVaW+mmPGrwJEeffS6hU9j/qUqswqBFSHiz3utRThoIiB2g+OY0fY39wLferHHY3k0wt2xvxZvXLN+Nz0Kr7l3iwSKUFwhDd6ygY3REBD7otCZPxU6l8MbeNsAj4BLlVgCDiuxWoqosjJ4hrtb0pJr6I1n5oBd1o0VzZ7VXNQvkFAJnRkwc1/NfumIn+GYvb8+wgkx35T6Wop3XSoxqc6y/Vimo1/QfjSHCTwAoYRqtuSbZ34WbRt0vCTL/mElQ9m82FWqMJL1BAX3N4w2jp6YiQtXUCqJEGxM4fq+Iq218gz3jw2wSnEhUKzm80sWZ5J6H2GDYVhnUSZRrIwWnlK50FVaXjRIzPMXhIJ/CQBLn0lSGdNhr+Hcoc7j01bI3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0029.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(5660300002)(7416002)(8936002)(86362001)(33656002)(2906002)(52536014)(9686003)(6506007)(82960400001)(55016003)(122000001)(38100700002)(7696005)(54906003)(71200400001)(26005)(186003)(38070700005)(83380400001)(4326008)(64756008)(316002)(8676002)(66446008)(66556008)(76116006)(110136005)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dd7LHsxYuGsynP3Q2dy5PnnzKLE3MUAuU4pUhQrDecbK4oKnGpfjyf57ZQVr?=
 =?us-ascii?Q?GdRzmRzFSLoxxDZm0gp0cf0z9P7878bW0xIxunKZK0wJq+lRnt0ne4mRSbVr?=
 =?us-ascii?Q?GTFsrWpvhUoKpFjYIoloP2PH9wjLLGm7pmTXDNfaOnSw8YA/WQa/R7tgcUrH?=
 =?us-ascii?Q?INJxDVSPHT5Wx5cyDu+8AMIpjdyXq9D1EULjBzl1eX4FvfyJaOrhB19+ULVV?=
 =?us-ascii?Q?y5nTDwBxrmzg6DELOiecB3vBKBnHBoBTpWFRrOezGCRAgi6fNir7GT4L8ivd?=
 =?us-ascii?Q?NlvNm7qy7eXgvyQFAy3hOzq6Ur4NAS6vcfhQCOw0RiU4pmwgHlD8Ke/I+xFs?=
 =?us-ascii?Q?nbCP9PEMYDWz+X/EVfO60jTPCQGNzp2thbU+T5wSu1DPU1hdvIC5LnzHVPo2?=
 =?us-ascii?Q?Xzw/H8XAGbz638QsfZt43oKFnlXB3NihSm2vp39oFJQ0p3dxpECh4UKbHq3g?=
 =?us-ascii?Q?hevwAC0dDfufeY40QEahr5G04u31uSwyffYSGrNbaFgZl90m8rRgqiBwXi3O?=
 =?us-ascii?Q?Rwrhx+MLU/MaWlWEKJwPth9ZI86gJmVezUZKJvmx8rUUqFTFGlpSaX+MgEpa?=
 =?us-ascii?Q?G2VdWy0JdxvdTG83dsRe1bhwt/yHbnGU6P0FKFXFIw4Q29eo/uJDZ3ydNn/5?=
 =?us-ascii?Q?uE3JhgH38OyBBKC7Dqj6qmxsKKQKbHSy3LYUFzQHSHuPCjahA6r1H51kw7AD?=
 =?us-ascii?Q?U+9NBQrt1phNBWdCdZBvzOMxyHxMpuDDMIBWgsMO4pvyttm3vrnVUdhyaXdV?=
 =?us-ascii?Q?H8hoZWcI37Wsw63scC6K6YAmRrl01pKFzh2hi/89MwOP+WnC+9b3y8kd4rtw?=
 =?us-ascii?Q?3fRSVc2jYAS/vbPIqZ4x/i+kOZP2R0tVcT1z5RhKIPDx+x9T6E82OrQ0IpSD?=
 =?us-ascii?Q?fCMqa2BgJPbF2vKFy5OZGJFJss9YxVx3SHMQ3wcYbnpfI331PPmyR1OoFzx+?=
 =?us-ascii?Q?1Cr50xgGDHD7SL8/7aF9PSHtvn38S1lMuuCAQX8KTIiVUqaXieQ8ivDB8GIh?=
 =?us-ascii?Q?LNO+Q7DIpNg8XIanH+XKrMZrvaqBJhRKszwECJ6kUINr5Op33naoM/n1Zgbb?=
 =?us-ascii?Q?BIxwWk8e8qfo+cRqNfAQgyK/301GquARSHgy4YbC7/0CCbqYpSYDtCqCiPid?=
 =?us-ascii?Q?JDH20NuuE0LZCpoq0dFgXKaQG70VkCA5WZ4wpjcuDmfaCJxUjcvkfMldP+Bq?=
 =?us-ascii?Q?zqR211rL3Rrkv5qB6SYD0d7teolClN47XCMKIQrah+hjTF/SjZz58aqXEng8?=
 =?us-ascii?Q?j7jP9im+nO/ynRZRi7laQlGc6+KIiR43sXkcAlfoqrgI7fD4ubi5XPoHMQHB?=
 =?us-ascii?Q?ErBFlyHbMiRCk2zRwJlZ939E3JF7gDOQVifh2QUcsXOedKNtOe2bbHqMUCoc?=
 =?us-ascii?Q?Q3gEL0l9CWXt2cqJErfS5aQ/BTzrA0eP+QOs1Ncg70bwvyALNuG/PEHFfNSg?=
 =?us-ascii?Q?qII2ewZb00IcO6G0x0EgI6m3QUqSgJMC5mk8rAmW0MQq+ccQme7tzf5HU/d0?=
 =?us-ascii?Q?K0EAnd3a2jylSOhjTwgVrBsHw4hV0NIGG77++CSPrNo7Rvgc9/IZlGn10OAN?=
 =?us-ascii?Q?GzVbfdFI4Xd9ZyvNte3PH1+63b5+2FGnkmJ3TVIgsgsZTWEb23n3mOMTNXvD?=
 =?us-ascii?Q?bfbKGLLKwwwOy3iLjvk2rMM4t4Bb5jqbLxzhzyBRvBJ/mkKsGypSVTlMxX0P?=
 =?us-ascii?Q?HhqqtjHdVlZPqUTM+rRjzls4B14rQTKLnCbtIoDhbj0PUZ/tMaI8hpXAI0E0?=
 =?us-ascii?Q?OS06+xnJ+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0029.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f5c653-50d9-4c36-9c06-08da18bd1c22
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 17:36:12.4856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fTknXxz9EF5b34m5PtrxcgRi2WwbtyC6F+eqk5cFtjCEwlgQj0Odvbv28Fbn6mgyyRlFdE4nkXX5Ef1MVFYJAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4210
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
> irdma_cleanup_cm_core()
>=20
> On Thu, Apr 07, 2022 at 08:54:13PM +0800, duoming@zju.edu.cn wrote:
> > Hello,
> >
> > On Thu, 7 Apr 2022 14:24:56 +0300 Dan Carpenter wrote:
> >
> > > > There is a deadlock in irdma_cleanup_cm_core(), which is shown
> > > > below:
> > > >
> > > >    (Thread 1)              |      (Thread 2)
> > > >                            | irdma_schedule_cm_timer()
> > > > irdma_cleanup_cm_core()    |  add_timer()
> > > >  spin_lock_irqsave() //(1) |  (wait a time)
> > > >  ...                       | irdma_cm_timer_tick()
> > > >  del_timer_sync()          |  spin_lock_irqsave() //(2)
> > > >  (wait timer to stop)      |  ...
> > > >
> > > > We hold cm_core->ht_lock in position (1) of thread 1 and use
> > > > del_timer_sync() to wait timer to stop, but timer handler also
> > > > need cm_core->ht_lock in position (2) of thread 2.
> > > > As a result, irdma_cleanup_cm_core() will block forever.
> > > >
> > > > This patch extracts del_timer_sync() from the protection of
> > > > spin_lock_irqsave(), which could let timer handler to obtain the
> > > > needed lock.
> > > >
> > > > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> > > > ---
> > > >  drivers/infiniband/hw/irdma/cm.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/irdma/cm.c
> > > > b/drivers/infiniband/hw/irdma/cm.c
> > > > index dedb3b7edd8..019dd8bfe08 100644
> > > > --- a/drivers/infiniband/hw/irdma/cm.c
> > > > +++ b/drivers/infiniband/hw/irdma/cm.c
> > > > @@ -3252,8 +3252,11 @@ void irdma_cleanup_cm_core(struct
> irdma_cm_core *cm_core)
> > > >  		return;
> > > >
> > > >  	spin_lock_irqsave(&cm_core->ht_lock, flags);
> > > > -	if (timer_pending(&cm_core->tcp_timer))
> > > > +	if (timer_pending(&cm_core->tcp_timer)) {
> > > > +		spin_unlock_irqrestore(&cm_core->ht_lock, flags);
> > > >  		del_timer_sync(&cm_core->tcp_timer);
> > > > +		spin_lock_irqsave(&cm_core->ht_lock, flags);
> > > > +	}
> > > >  	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
> > >
> > > This lock doesn't seem to be protecting anything.  Also do we need
> > > to check timer_pending()?  I think the del_timer_sync() function
> > > will just return directly if there isn't a pending lock?
> >
> > Thanks a lot for your advice, I will remove the timer_pending() and
> > the redundant lock.
>=20
> I didn't give any advice. :P I only ask questions when I don't know the a=
nswers.
> Someone probably needs to look at &cm_core->ht_lock and figure out what i=
t's
> protecting.
>=20
Agreed on this fix.

We should not lock around del_timer_sync or need to check on timer_pending.

However, we do need serialize addition of a timer which can be called from =
multiple paths, i.e. the timer handler and irdma_schedule_cm_timer.

Shiraz
