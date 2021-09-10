Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575BA407055
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 19:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhIJROP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 13:14:15 -0400
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:9440
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230482AbhIJROK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 13:14:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XidminucJci+D+tLd8zlgRlxHhLKmJwlICo7Y3R4g5HUOob0D2XdZOHVyrVmEmMqZVzOPWMOA1nlJJCi+Txb8eUa52U6Vif977JVutcyr2Kmo6N7An8cXSGqzPiwtv5GEiGw+yGUBYcJzgqkBx7MVW3pO+8MAC3fnp14UiC7QfpAwB0GLRtJW0WgtzDdQtBY3K45ubzEG9qyF7s1d0qy3fxkFkgsZ5b9oO7UYbdMaMxUdhK0/r5zV6lwP/hKVeq08RxSzNhngguB1HzmjPUbZPZSBO/UgWs4Cud8DaRkmFUn3D/z5xM/iZYAqFks3hESsHSj10J27HLCpU6PE9pXsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZsEkt88Z1I2OuQnXTAW7Zg0InpvHjN9Cs7ZjIkzxZyk=;
 b=AzPZstsJitXb1XuQ49sM5EAn/2eocI9kRN6Mmx/mw7Q4uXv+HuS9DI/PIsdyL1hACuAfWHeKQZTUustj3lh1y9PKaS/IMcBxioC7gVa7znpWGMVIM47aVH2Txd4yOR6hyIuOzLSuSZkc/Hbnvur9h5CAL1DXm6v370IsheAZt6c4U7GViRuMMFO0BXsoNPzeRN2dr6zPhSnX8tH9xGFN8leomqG93SE9TZOq95iESDaZCL+8oppn2MGPb2YLDkAhzYBmIjPFUtFzzBZyBQmDiKMptIrIBheQWegHF0eZxxNRi1p/65aXHgck/LuhyEXpsQzr1ZitxHsunDD0+QUSzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsEkt88Z1I2OuQnXTAW7Zg0InpvHjN9Cs7ZjIkzxZyk=;
 b=nP+K3cNQWwZGjkZB4VZyml0PPOGoBEj3P19P8mWs7ECc7z5ifw62tpw4Bnwg4Ofx9ToW60VeCzFcX3obWfn8A/lwnZc/nTMcBue0W5ulvTzKiPLBS56T2UPfTdLNc3KFk9Bbk/ukKHAOd+fnkRW9ysIP1POc8WrkmFIuCGUWC0M=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4688.namprd11.prod.outlook.com (2603:10b6:806:72::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 17:12:58 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 17:12:58 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kari Argillander <kari.argillander@gmail.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/31] staging: wfx: do not send CAB while scanning
Date:   Fri, 10 Sep 2021 19:12:55 +0200
Message-ID: <90855195.zGc3oIiVrW@pc-42>
Organization: Silicon Labs
In-Reply-To: <20210910170105.6lbdnonxyfoo6kbb@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com> <2897625.p8pCB6X8cM@pc-42> <20210910170105.6lbdnonxyfoo6kbb@kari-VirtualBox>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SN4PR0801CA0013.namprd08.prod.outlook.com
 (2603:10b6:803:29::23) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.localnet (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0801CA0013.namprd08.prod.outlook.com (2603:10b6:803:29::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 17:12:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c22591a-0e47-492d-a402-08d9747e3ce2
X-MS-TrafficTypeDiagnostic: SA0PR11MB4688:
X-Microsoft-Antispam-PRVS: <SA0PR11MB468875D90F12C4A00DC1343393D69@SA0PR11MB4688.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7TydkyMiOPcsfFsma9ZR0QgUhx2Fvv+WZfy7bPhnfWHMujotaYki5x9e0Kl/b4TThpdQr91nFNBONQVoVoXscpI4YbMQr/NQgZauOjAafOI8vqzlcMVIYC1oBo2l2/chwrsysLK2SjnGBf6L4WlmsJDTrrl8urWV1m6yc6j49ppjKnRhCgHTWXS5fPprUx4iLZQhsdb2Fbz5nbOBLCywOYz3ncrusB/999Pv2mkWns/OWi315EdIOs0In45ZYluCjZH1XeO8+b6wmt9/GiGUl4ZrL5trElN/3U0z9Oye5UPRp5hkuMlHToqbaZe/yqYOJ1de1Tv2OGvAuM6zrHZpi0MDlNCMeYuAl/L4o7JvZKb8X/IvD6wm4BxC+JIy8KoVJYBw62II2f4frK3L12xp/7P2nhHsIC+a0SYZLMHd78wSDmqAx2JQUp1aIUNxrbqKY6RjwB63ORpARAjjdYUklwe6VuZmJOkGOlqat256KqiQ4aoarTArf1OuK/eDiuSLSSO5asuXgsYRe8Egakk5HidGn7blsBD4+oqPSs7BigcSsPfQdDPrFc8n8nCwpIyAxfm0sb6AGtS3K+JzYyn8cxrbNn5htHZ3J+A/mY/edgpEkR7mDeG1srKdGM4XaAtaCMEmHHObW9slEM8N8nPWVyfrWHtNKZIlZvLeLtrOKWBZNaLLIYtZTjLZEOjL4nTMvTfy6Fa0TNa437mZVvNVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(376002)(39850400004)(186003)(83380400001)(66574015)(4326008)(8676002)(86362001)(66556008)(66476007)(6506007)(66946007)(6486002)(54906003)(6512007)(9686003)(52116002)(8936002)(316002)(478600001)(33716001)(5660300002)(6916009)(38100700002)(2906002)(36916002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?wJwS3CSmYfjpzjFFKjY4SuORku6X00R+Yc8+m/P9B8zd/7iZXS6lEh4Ipz?=
 =?iso-8859-1?Q?Vb8zpxZ6u7S3xVu7IbNTegC4RaJe9bAhcvI6Y9vheK9kp5ZVfEtEf81tVM?=
 =?iso-8859-1?Q?IYk+Fs+HFFHpZdS/1MMZaABudYy1gzEkfli5j8xlulV6uO9O+mbpH94FZ8?=
 =?iso-8859-1?Q?ZXXAc+htCWxVZiTCSXT4P+G4VznVTr9KrZQHiwP+KIvI/qnRc3T0Ip3BRz?=
 =?iso-8859-1?Q?1MEcgBEO4EFpX0IbEaeG4ne/adcigN4/amgygbBpobGGpqBcLca79JZ6L2?=
 =?iso-8859-1?Q?z51N0ihDgh9Kte3tlQi+VmYRxIWmJFffnid2q0BmVUgh1hruZePi8LoT6b?=
 =?iso-8859-1?Q?ha67I2zXOkD/eWRsXbnca1sIM1lEixLwLF8PmeF4zrk56N/h+ZN5LVNNOt?=
 =?iso-8859-1?Q?v6qG3XZYpQiaPPijukNrznmm+Q0tBYt3aszUP2zTwaybaOxsATqs8eSwFc?=
 =?iso-8859-1?Q?2vNhslRsQkLj4ASmlGOD3rvXxWKDFZIyW1+UeydgXCq91itCoomfG0Lk2P?=
 =?iso-8859-1?Q?0OSGNGc46vDbNR1YvP3c9lZiDOIFDQsncdc32IW/6/I9YcgdvvDbDrmKlL?=
 =?iso-8859-1?Q?tJNn3d9kPaSlL4ZY2diF5K2P8D22IADhbicTmMqu3GlbRfWuN0VuzOAsqJ?=
 =?iso-8859-1?Q?JCzG3Lnyss/6Ow2bKXJGZ6Q+n4ftAW7KGTO96INe+JLtsyyYSZlmptZrnw?=
 =?iso-8859-1?Q?clblGcJSiLIlSYOsSSQLUKlGQq1YIBLdWFdpaeHIH+j40Bwp/L9fUw2I0y?=
 =?iso-8859-1?Q?7YkHJU+XUkgGyrZYVdGUKQ6dcmafBctYLUxSWwSBWYh7YnSXqfw5hidak8?=
 =?iso-8859-1?Q?Nc3bQJ23e/UvrfZggAZ061dHbJ7fXRW6sL2WJsU+PvUcXHHqmnqvLOOy4E?=
 =?iso-8859-1?Q?6HITeCkFRCqGtQ29/nZ3HhRr9Z9u47HUcLxN3EbPUsbCzJJpo2h4pfblx0?=
 =?iso-8859-1?Q?93xzWEll5JMh8siajmYSwLWCKii0By4X50wlsaAuq1U7zt9PJvX4Ol0Ggf?=
 =?iso-8859-1?Q?PJ2lvwULpsTePYYCexjwnFYG8kHu21ylMnFzRlOhLpipWCd53AoF8bZYR5?=
 =?iso-8859-1?Q?Fv96GVkF25YmAtDWk//ZGG7pt4/zVf1Aee0gM0MlIZmMabUQV3MQCPIO8j?=
 =?iso-8859-1?Q?Q0j/OT4S99VHcgezshZzHwT4C0uVX0dLIqAGHyrPp+1ADfdsH52EVnCNAT?=
 =?iso-8859-1?Q?L1RR4YKw2O+OlvN4r8HYBsIN/DJ4n+KrcIcdLQ+gDWjB9FEwp2jNw7W34e?=
 =?iso-8859-1?Q?7OKM6zqxZL4wP5kQgLFa97+LCLtqbY5rdVu2O5i1Do2QMTSGecQNz7JWq0?=
 =?iso-8859-1?Q?l2d5bT+63MD/9zdxcVOwZucvSzXGr7GjVZ4eUiuifmoFU8K4h9NlOcx6uS?=
 =?iso-8859-1?Q?Jqy1Z9/Uh6swcQevt0juhBe7ryDJorxCu6jSX7Pf20Mg76OsaucK7b0ud/?=
 =?iso-8859-1?Q?wWWis/vIIko6MdaF?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c22591a-0e47-492d-a402-08d9747e3ce2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 17:12:58.7122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KS93PhDnZNPNSeNiEY3QbMTELCy4lBjTbZQf/oq9W0Pm3cx4yh3q8K/gQrME6iQIKt0k6IyZmVTO/bBy2ALPjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 10 September 2021 19:01:05 CEST Kari Argillander wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> On Fri, Sep 10, 2021 at 06:54:36PM +0200, J=E9r=F4me Pouiller wrote:
> > On Friday 10 September 2021 18:31:00 CEST Kari Argillander wrote:
> > > CAUTION: This email originated from outside of the organization. Do n=
ot click links or open attachments unless you recognize the sender and know=
 the content is safe.
> > >
> > >
> > > On Fri, Sep 10, 2021 at 06:04:35PM +0200, Jerome Pouiller wrote:
> > > > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > >
> > > > During the scan requests, the Tx traffic is suspended. This lock is
> > > > shared by all the network interfaces. So, a scan request on one
> > > > interface will block the traffic on a second interface. This causes
> > > > trouble when the queued traffic contains CAB (Content After DTIM Be=
acon)
> > > > since this traffic cannot be delayed.
> > > >
> > > > It could be possible to make the lock local to each interface. But =
It
> > > > would only push the problem further. The device won't be able to se=
nd
> > > > the CAB before the end of the scan.
> > > >
> > > > So, this patch just ignore the DTIM indication when a scan is in
> > > > progress. The firmware will send another indication on the next DTI=
M and
> > > > this time the system will be able to send the traffic just behind t=
he
> > > > beacon.
> > > >
> > > > The only drawback of this solution is that the stations connected t=
o
> > > > the AP will wait for traffic after the DTIM for nothing. But since =
the
> > > > case is really rare it is not a big deal.
> > > >
> > > > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > > ---
> > > >  drivers/staging/wfx/sta.c | 10 ++++++++++
> > > >  1 file changed, 10 insertions(+)
> > > >
> > > > diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> > > > index a236e5bb6914..d901588237a4 100644
> > > > --- a/drivers/staging/wfx/sta.c
> > > > +++ b/drivers/staging/wfx/sta.c
> > > > @@ -629,8 +629,18 @@ int wfx_set_tim(struct ieee80211_hw *hw, struc=
t ieee80211_sta *sta, bool set)
> > > >
> > > >  void wfx_suspend_resume_mc(struct wfx_vif *wvif, enum sta_notify_c=
md notify_cmd)
> > > >  {
> > > > +     struct wfx_vif *wvif_it;
> > > > +
> > > >       if (notify_cmd !=3D STA_NOTIFY_AWAKE)
> > > >               return;
> > > > +
> > > > +     // Device won't be able to honor CAB if a scan is in progress=
 on any
> > > > +     // interface. Prefer to skip this DTIM and wait for the next =
one.
> > >
> > > In one patch you drop // comments but you introduce some of your self=
.
> >
> > Indeed. When I wrote this patch, I didn't yet care to this issue. Is it
> > a big deal since it is fixed in patch 27?
>=20
> No for me. Just little detail.

OK, right.


--=20
J=E9r=F4me Pouiller


