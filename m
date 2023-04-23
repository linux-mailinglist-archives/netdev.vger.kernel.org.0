Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9680D6EBFC7
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 15:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjDWNd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 09:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDWNdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 09:33:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AA61726;
        Sun, 23 Apr 2023 06:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682256803; x=1713792803;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=XCLyJoVFBKy8LZvgg3hMqJlT2H+RSS6vGRyVWthWV5o=;
  b=YjTT/Q1FKe4SVKCKHv4ZEmiD94OqPtXXIOBmucQDP85z/LjyfGGVntny
   SANxmltWnldsPW707iRLKXTTjI4zDkzB/i3j6vqmXPoeJhBEr3/HVmcD0
   KK+lvVMt+YWDFKaY+QXhXW+FyeQsKa9nISWdljLyjLtQULT0bIE8L2Wo/
   ouxNqLXLc4LBqa68d0D+GlNQlF4Xbl2bjK1x8RsgxwFdgMKGT0Hg6WErE
   jLyGlpmzwcXXerZn9va4KrbTUE2bDTcJjkCBuNtZTZSeR3FmjSBFjsTzC
   QhjoKZmkrREcu1BunJPBRTBmBdXw7FnFWLyE3yBFka8p9IqlHkr0PJYcp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="409213153"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="409213153"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 06:33:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="1022411256"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="1022411256"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 23 Apr 2023 06:33:21 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 06:33:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 06:33:21 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 06:33:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7bKdfwp1UVmFF71ijKogpu06RtTOwlTHrVc4zLzOAsFqdFo3Dy3lXlWejg9Jpnxs3P2tOUI4+D3uENUZ4vAgDyAJuKDX66in/FaxxZ4kF5L77a71dmG7rBux7MRIEY4Dv4zJCBE6Ag9wlU0x/sxX4B6lDowgf/MI0lU3iwXvLCrTYEAMdN5zrIRndMmRJOToUGYggXU/2CuTAXY5d1sEvK7++oX4yChTsj8b4LALt9EM0Crw7lMJfhODGcM6eApmQ1PhOdrv/x/eJUMk7TqwdQuIBMrDoNeenBUchO1nbeIenl9A5FXf7UUAaB2pu1spaC1FjSkWnaWB0T14YXH6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5TXJrplDM3cFnJ+c/DzQnniMQRn3VbiNmnEAUlekw4=;
 b=daObuSJmlBjYicnJkU1QTTpmjcpNpP9TfW6qhU6P7Z3u6R46bWqIVtEwZ4lm1+JoPDJZItucx77YKEwAM/Ox0EA6sC1s6cKsU4R+GbRChOYOexVYWD7jaEU0X9h4ozp2C/pTDXJk0cDHmHtfGtDS6yvgwfDs5rayU01gwqDXJWtj2XvI0tkv0imLcOXAj9EtKpRzobH1bfbetSd3Kl99x7lDcLsPBdHKr0RaZRbVh/krt7eCdErpwkuDwqHENZaJAUT2K40fJFVaQuB6vbynjk3zzb0pbEyE266I6HVq6fayjHd4XA2HUuEkJHbkgKQHEBtCj+XGIjJoPTvdgSEsjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB6996.namprd11.prod.outlook.com (2603:10b6:806:2af::17)
 by CH3PR11MB7273.namprd11.prod.outlook.com (2603:10b6:610:141::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Sun, 23 Apr
 2023 13:33:19 +0000
Received: from SN7PR11MB6996.namprd11.prod.outlook.com
 ([fe80::338b:763a:ac40:d509]) by SN7PR11MB6996.namprd11.prod.outlook.com
 ([fe80::338b:763a:ac40:d509%7]) with mapi id 15.20.6319.022; Sun, 23 Apr 2023
 13:33:19 +0000
From:   "Stern, Avraham" <avraham.stern@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "Greenman, Gregory" <gregory.greenman@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: pull-request: wireless-next-2023-03-30
Thread-Topic: pull-request: wireless-next-2023-03-30
Thread-Index: AQHZbbjNzP9gzb4bwEuw1qGhSN1B8K8xGe8AgAJ/PgCABVt22w==
Date:   Sun, 23 Apr 2023 13:33:19 +0000
Message-ID: <SN7PR11MB6996329FFC32ECCBE4509531FF669@SN7PR11MB6996.namprd11.prod.outlook.com>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
 <20230331000648.543f2a54@kernel.org> <ZCtXGpqnCUL58Xzu@localhost>
 <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
 <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
 <ZEC08ivL3ngWFQBH@hoboy.vegasvil.org>
In-Reply-To: <ZEC08ivL3ngWFQBH@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB6996:EE_|CH3PR11MB7273:EE_
x-ms-office365-filtering-correlation-id: 743e0f00-01bd-4f09-87e2-08db43ff4d3a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HcPxQCYenC+KdARtYJoZfD0A9er+QkCB+JwYc7BfBlQWmInSJLT9RcP7ulGP9y/8wcQlnnsYT7cwK2aNx5EQhbTeXUvjCQwP0hha5MbPH7ucqYAsWslAW95YneKzQvZMr5Qh3X3cURteLZ9dEecRsyYnvILCtZNuOtMfSTM0keXNks5eApUiH217iEKc86+U7fDdDIX9TIfD6LO+RuwwxPgfKGN+QXi0m9dNjePN1kGWsuLrQOvzxXfPEq6ITYVpCKdLYHjtWicemYEmP9ePi3KyBI2uvh2ITAdAvLbVNPrwU72ZnVGRpRLyHzAtwpIL14NNqLVUt2g9hofSmjZDb5hBUrYBd4pwuc7C4bV61zSRwYKv5m2LZcaH+IvyZZYHAFmQO2dhYiOXi5T/Qp9H/RqMzm3KpmYnTYqnlOjEX0NP7nxpoZdJ6qfI13aSE8k7tvjmPH+dU1eZWRHE11a9MDqTen5AyTuIAt6EwoEJVwYV39x0mmdwbmRh37Pl1tvxtdNngvY10l++MI91SHY7X4Z3p6U2ciRqUf7M6/PjYFyS5UuYwnZg/0S7VhnqHMHi/vKQKw5hB+cVuIwXXeuRy6p2WPVf9dyERtBRRTftBPbTR7j27uy1Fwyso+Kamhho
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB6996.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199021)(33656002)(55016003)(83380400001)(54906003)(2906002)(8676002)(52536014)(5660300002)(38100700002)(53546011)(8936002)(38070700005)(6636002)(478600001)(71200400001)(7696005)(6506007)(316002)(82960400001)(122000001)(66446008)(41300700001)(110136005)(64756008)(66476007)(66946007)(76116006)(66556008)(91956017)(4326008)(86362001)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iRMZsahlA0NsDGZ7czWZmfCd1I0xu0DpWt1C+vSU4nBtaCYV7h/yh3SposO4?=
 =?us-ascii?Q?U/mnnN2ZDRTnFacIW94bKhDHSMeQ1DSr9561HP00VaRhssYztzFDoaRKqLXB?=
 =?us-ascii?Q?eyCFklg6uIwxBbZDILZkpSe37P9DUCBJcmE1tEwFbD1K5uJG2CejFbl632N1?=
 =?us-ascii?Q?DsukVFx/T/Q4dJbpM8shrUNZCxHf+qrEJH8epwNbMG7OnBAQlkyRQkf3hgKl?=
 =?us-ascii?Q?Z2dQ65SjP7uZZIpKwTpbHSsb+AN4faD79Uzhm9BZQMDdvcIR8+SXNkzr4IkC?=
 =?us-ascii?Q?BcrisxurGHD4jcMtdg679APcry3VFXFqM4yxizzXCaIuOSZlhwuQ18NKe+TN?=
 =?us-ascii?Q?HA8qkZrVfSepps3PzRzxhdIzsF7I+L1X4dl7bRkeJvSWBlblV110s0RKlJhb?=
 =?us-ascii?Q?TquDSz6AmVnbX81RHbuQ2NKIDowFz0I3mhEI9YzETcV1d8wsOreJhqWNlTUO?=
 =?us-ascii?Q?5UAQMN9KPUo9hBG4wsjAU9fRl5+c8r6VtIn3Yi1X3VjorUM9KH3zoSP0nFLN?=
 =?us-ascii?Q?Z8EkaOr5NG5vGtZ/r13lgSoq07/Guej1dkfv3En3n6GkqlPa83YF8rjaAqZS?=
 =?us-ascii?Q?89YPapbt+VOlhiYjUM5o2lo6XFq1wGfdwHyS0CSgbMED3JMirhN31cHIdbRo?=
 =?us-ascii?Q?E9/PIFjMfg1AEB+8QGDf/9Bw6oDJ5h89heI5dBXhfke+nRbdLi9ShsRllnpr?=
 =?us-ascii?Q?V3jTvJtKuzvfw4qB4o4PbYIuNIjKnwpF/vGfnAiof57q6fgwUcEHjZG5s128?=
 =?us-ascii?Q?lT3iGVTTxAK2ItFBUZILpYSGIYT6e4Cx69LYQgKugzdDMvM6kh8qa4xBcfBx?=
 =?us-ascii?Q?dNg29SGV48VTwI1hNR1+CtmAbbfgK2QIjUGU5LWijzX7w6F5kPcPCy8CCfQz?=
 =?us-ascii?Q?2Iqs/BNcgakd4i/tTDf1IRTPM4bUTCFSme+5cgeKUNyx3IUw5IoqYjuSJwl5?=
 =?us-ascii?Q?rkDA1ehyjHgVIKn5WOtFBbwqiubYVRzTK6SqzzDTP80nM87aD1Jskb77m6SJ?=
 =?us-ascii?Q?7HvvwYjwCKFp8cPQleHhb6Cx2rSFVkIOnTpjvU3MrALUvOVZCkQ4WT9pGcxr?=
 =?us-ascii?Q?vB6Pyq2wHzZGU7lGT/x16knAbLsRFHY3mREP/zJt+iofrRIWYSZhMxYLXLuT?=
 =?us-ascii?Q?7rmHmqAY0ixoYkAC+qahySYJF4NBVNUj2E4Zx/pG6X+yZBPvR5VgtooVOb6K?=
 =?us-ascii?Q?7sftBSl82ntJZ1S7VB9KTFayWc29uv0bvkcBx9dlBneE4QooWsqW5JNazLBA?=
 =?us-ascii?Q?kiI90KGPg+SvQ+8//t3I3jrE3v8pPu6WL/shGrNg+rAVb3cb5fo0ptdS3+oB?=
 =?us-ascii?Q?oRwrglggYXVlUvjvbkVNtbxc8LA9pyo6mldTZyRb2t9jPX7Ef+vCFmZKkHHk?=
 =?us-ascii?Q?04n4WIQ1s+4mNaQxivgyuY1MBZOcOwzN3G2YPPdqBjPOBSy3VWF34a2h81AW?=
 =?us-ascii?Q?1ik+T3kub5jQZV6WNFqR79hSF+G8mwqvkwqptCOfpxcDGhGoGRm5No2rRu6B?=
 =?us-ascii?Q?vfOr1hUk5mNwnLm+VA4W/oawhaByA+dQgS02lDa3jslP8ad1gXe4bCoFGqQv?=
 =?us-ascii?Q?vm8x+7OILy9rhKz/LdwEY8DTOxuZZ3oQjPD2Fk05PH0UXMrcdGTev0HgKQKV?=
 =?us-ascii?Q?9Wj8DVBLf6VCKi3rJdD3RaR2pqa8xQ9dAkLdZo+6fkiD?=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB6996.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 743e0f00-01bd-4f09-87e2-08db43ff4d3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2023 13:33:19.4232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UBof37GoICy4o2e1toU+HegWNLTAvMVtkvwmwseVJgj1H1irU+lR3CNIrnJ4TU6XMGlsUoFt3S5u2Cwbk9CWTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7273
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Richard,

I will try to clarify.


> > Then, the timestamps are added to the rx/tx status
>> via mac80211 api.

> Where?  I don't see that in the kernel anywhere.

> Your WiFi driver would need to implement get_ts_info, no?

so, the rx/tx timestamp is put in the skb hwstamps field, and the ack (tx/r=
x) timestamp is put in the mac80211 rx/tx status.
if you follow mac80211/cfg80211 patches sent earlier, you'll see that mac80=
211 uses these to fill cfg80211_rx_info and cfg80211_tx_status with
the timestamps.
eventually, these are sent to userspace in nl80211_send_mgmt() and nl80211_=
frame_tx_status() as part of the frame's meta data.

since wifi uses management frames for time sync, the timestamping capabilit=
y is also advertised using nl80211 capability (NL80211_ATTR_MAX_HW_TIMESTAM=
P_PEERS).
implementing get_ts_info() doesn't seem right since it's usually queried ov=
er a data socket, and the wifi driver doesn't timestamp data frames (since =
these are not used
for time sync over wifi).

>> Actually, we already have a functional implementation of ptp4l
>> over wifi using this driver support.

> Why are changes needed to user space at all?

As you mentioned, time sync over wifi leverages the existing FTM protocol, =
which is different from the protocols used over ethernet.
In particular, FTM uses management frames unlike the ethernet protocols tha=
t use data frames.
So obviously for ptp4l to support time sync over wifi, it will need to impl=
ement the FTM protocol (sending FTM frames via nl80211 socket) and use the =
kernel APIs added here
to get tx/rx and acks timestamps. Then it can pass the collected data (t1, =
t2, path delay etc.) to the existing logic to calculate the time sync itsel=
f.
Note that for time sync the FTM frames also need to contain a vendor specif=
ic IE with all the time sync information (which is dynamic since it contain=
s timestamps data from each measurement), so using FTM offload is not a goo=
d option.

I hope this clarifies thing a bit.

Thanks,
Avi

________________________________________
From: Richard Cochran <richardcochran@gmail.com>
Sent: Thursday, April 20, 2023 6:43 AM
To: Greenman, Gregory
Cc: kuba@kernel.org; linux-wireless@vger.kernel.org; johannes@sipsolutions.=
net; netdev@vger.kernel.org; Stern, Avraham
Subject: Re: pull-request: wireless-next-2023-03-30

On Tue, Apr 18, 2023 at 01:35:50PM +0000, Greenman, Gregory wrote:

> Just a few clarifications. These two notifications are internal to iwlwif=
i, sent
> by the firmware to the driver.

Obviously.

> Then, the timestamps are added to the rx/tx status
> via mac80211 api.

Where?  I don't see that in the kernel anywhere.

Your WiFi driver would need to implement get_ts_info, no?

> Actually, we already have a functional implementation of ptp4l
> over wifi using this driver support.

Why are changes needed to user space at all?

Thanks,
Richard
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

