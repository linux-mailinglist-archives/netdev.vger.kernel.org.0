Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E39E6DE8E9
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 03:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDLBb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 21:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLBb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 21:31:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F052044B9;
        Tue, 11 Apr 2023 18:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681263117; x=1712799117;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tTMOEsa/O7Qe2fT0T9RoaqvruS18IZ/rj/c1bPuUNXw=;
  b=mHMdIZ/AF0T10wRiyLqRyr9dGwtXzu183WG5FsssxOHtUzOvwfxAD4wa
   Dj80Jc4Rj4BPRPkoBKMlYZPIVg2xalhIkuoCRGYmNMtl+ci/UEJe8mUme
   OZUpeuNGR75vui2xnjM8ph0r4A9oP7LjhrVQpghoXdubp9GO8956OpvXh
   WfyHrwyJ2yNaw9hhYW8UHBk+Ezp9WRCMZPUFa0ZCfKXdwDtj4iMSTn3lk
   LwQ71h15ASj9v4rdsn96SObdEvDrj9TqsuNMMonEw5JqwrPDgYu0tqzKn
   NGFmTz4ADsfUKpjIB6FN+5vweUMYTBck+eeYJGZZRdJmm+swbmDh3EoKn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="341262732"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="341262732"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 18:31:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="758053520"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="758053520"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 11 Apr 2023 18:31:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 18:31:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 18:31:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 18:31:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 18:31:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQ5vteYVFoQe0y5YpTiwtG1XS5yx4gDbdNJdUPZdgSRh/jPMZ75PPwytvRspVtM5OdNKEsClY3PfCsgCvBcca+D9TTruJj3TSmtYKt7qBpCdR8gy9wgLat+aT1ZwNprOQxKFeLk8nxacJVW0NTdN/kRjvPGgETMFsPXPTKyFldzkdlmRM5TWzmvo0fRpora6MFHissbTzmqqJ/X8RuxPUtf+uttsT5Z+MfaliXH2m/y/4BhNZRFDS0fZ1BL3M+1ih4sIxLblyh2DwdtcFdXahnqgdc6372CHsqzZM8sc0N+fuoxwM3sCUW94lgAvX88XLzV7gPaxkgE0zk+nBIfzdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2XKivswDUvz+3C5PRz87CBYxbPqSSOwElx/4BTZug8=;
 b=fz+HlUNztOdPzddmUuXTuXfQ5ChqpzmCeHz4Zr1XxxLbMHxFxC35DLXvol44/uFuVuHO6hmkS4TXZE9aNOeS4weucP6HvI9oY3iraPDC7kqg7SnTgNzrVDdmvut07+5tatj44nQMpC+/IBxnDzak3IrFFLGx5FCtKZFC2FlqKpx3gJ1SyDtgu+p/dfwAS884m8nFjAL8XYZdyRrSc6fKKi8Hbbb80HbZucUyrwZJhCJ6vn3Mmf/yn5RXOLJibhad+9/KYgTrpFswlAtMhnemme1505DWGOfwec3pPlWGqZ8I6FgkAZtTIjXzAmoypMfCMQXzaiBWM/f+e3hotzJOxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by BL3PR11MB6409.namprd11.prod.outlook.com (2603:10b6:208:3b8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 01:31:19 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 01:31:19 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>
Subject: RE: [PATCH net-next 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Thread-Topic: [PATCH net-next 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Thread-Index: AQHZa5S9mRB50P2QwkG1pXlh2ZtnBK8kuuaAgAIgiBA=
Date:   Wed, 12 Apr 2023 01:31:19 +0000
Message-ID: <PH0PR11MB583042FF9988C2B445B7B06FD89B9@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230410100939.331833-1-yoong.siang.song@intel.com>
 <20230410100939.331833-4-yoong.siang.song@intel.com>
 <ZDQ4a9UIVysA6hgd@google.com>
In-Reply-To: <ZDQ4a9UIVysA6hgd@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|BL3PR11MB6409:EE_
x-ms-office365-filtering-correlation-id: f48a4881-712e-4663-a1c4-08db3af59dce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TORLDu785xFrc9db3SXa+C/r9StgqEYuzfJ+IxNW1nFQW33R4BLStk7E0F7TMwZbtTPBuYJmVuiK7t77K5JUvx0jW5V0fNMjaoNH/7mqGMUHq91Urp5OXVxni5+Ofj9hOD3EZBZJ6bPh4TqkssiSljwxqc8DCFXUHFCkGX+lE0nwTNZAA3bF8Jl/OTxOjtjI/zI4Ah6qdX43RopQUhtpvGz2l0RqxDc7VeutFAxG8Zll9HtUST9+Fqth7Bon7j+oIHUESIdQnzjbMujgY8GbGNTXSl1LpA1HJ+HW9jbSbX3iK4zfwj5DREcpmEMnesoPM6d3+PmFLsvcmZdrpsN7XseQpKkrFLt7PxBi3hupYUEeduMc5cYi7Ey8NIWbTyGjtCv7kP1IySgPwKS4iadfdhT5j+/lKCClrglkmFGM5SCunAiyCyxvUr+x/3VJonhBGNzgRsptb0ycYy/JgpyCOYDqMWqtJfShg2t1dgcDS71iVbxWEnOd2+NXQD5NTO/QbS0nVUq0fBt4EHnafJ91w27ONxBDpkvTYQogk+ZEOg7aK42eSGBRTRP8a9IvfyurZzS/46iw6PhYk2Bvd/7lAdVtf47zGKlutD8O7Y+2aiPbUV86XXLm+EGAOYZw/fqk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199021)(55236004)(53546011)(33656002)(478600001)(9686003)(26005)(6506007)(54906003)(38100700002)(186003)(82960400001)(8936002)(8676002)(316002)(41300700001)(66946007)(66556008)(66476007)(64756008)(66446008)(6916009)(76116006)(122000001)(4326008)(86362001)(71200400001)(7696005)(55016003)(7416002)(2906002)(83380400001)(38070700005)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vQjTuyF89KPy2jbGTIDHDJEEf4bZqssOgxhvKYcO2RAef+8Il53PmS45OOtY?=
 =?us-ascii?Q?WI/Tb2Di0VXhlJfH99/UbNn3AuvbNqTNRRPwlMcfqNChmIVacmdrk5J6e7ax?=
 =?us-ascii?Q?wd7jyGQKmqzrjG4txY18pYd1a6xofM5cAm311pX9qnjEFIOFx7r4l5mnUBg2?=
 =?us-ascii?Q?twI9574RNJS6V2ZAkPJB4psoDHfSr7bAALWj2gF1ITXayu40XygipSzEAQ91?=
 =?us-ascii?Q?1AZ0lsCLcCsLvZTmevb4m6SMGpIxiGHP0B/n1p0QL9NIjBPNOzAD9BNLiX4e?=
 =?us-ascii?Q?px8nwAeS+vevoMaKU5Fm8hv10UxUhH0WEswrzLcKxG/7sCPQgWnv9+wnHbGP?=
 =?us-ascii?Q?DAL+4lxIWYu+dGnSglh1xjDIhSTX88BqGC7aKa/8amrg/8Lo7dcWIdTp16gA?=
 =?us-ascii?Q?GYYJOtRuiR4WCiA3UmEuCbnH+RSA99mWtv/swvea7ez/5YGnRjRNIqDcoDBv?=
 =?us-ascii?Q?AnIv2KQ1wTNmCOUQj2xkBKIViIt9R0YKOVPj0mQTMD6oVRysMLf8bTCC8Kzl?=
 =?us-ascii?Q?TRzvP56DeRilF5GrpdoKzKEJcyDx+Z0Jw8y6XJAlJ/2ZLEiKaKM0wTW/u7Zf?=
 =?us-ascii?Q?bGhg47axmtva6oME/wb0lT0WO1UkbfSQ7sJSGdmrHkEYw9Y3622Hp3MLJgdP?=
 =?us-ascii?Q?UfqkGW215HiPJNjAPvTkasBjOhnH76opkI1Neyrcp09hj7VkLnFNk0DY2VdR?=
 =?us-ascii?Q?s0fg2D1VVMrmF6Ey7WI/QIPygYz4t8KS6WlgRDiDi9d2CIdUne3kMtTbdu44?=
 =?us-ascii?Q?yQbmENl7Iv7UIO7v9WTmEg8dbbhc88jMHezHBlLTK/jG+SfsSfNLJJliqzvF?=
 =?us-ascii?Q?31t89POmAQ7fLixAm1S92rJ+cWbHSk0G0P6HOIRbequ+M1U9r+fuJ+fv8EV4?=
 =?us-ascii?Q?zwmArJJVmFvyucp/oefGV+FljJaaS63YwFtFNzSmpjzFLJ6ZnMgRyNQlDa/X?=
 =?us-ascii?Q?qQ7dsDr1KCOtf91TGsYLmJ4tL35+7+hTS3ihR8qVDcUn80U8K1Uwq0yQjNC6?=
 =?us-ascii?Q?Pvr+7/YfdTlivt+IbkkR4iCklQX+rsQdiSiHA+JZZ1ua1moqzwfd1snKh1Kw?=
 =?us-ascii?Q?/x4NFn14Xr5YI8t8qor3bcoCu1O9PARBl7b0Sr/79EBHR68sR3c1pyAOLaGY?=
 =?us-ascii?Q?K1cQgJWT8CWrKm4AKWcrMEWKa3OHsr1EJgwXVBPrCI93WA2MXpGcYNEAhBs4?=
 =?us-ascii?Q?PPEKDfP21KVU38K0gEJVdvOtPzyjAmVSTs/vpk9NTtqaK05KkVVvL2Z8pfPm?=
 =?us-ascii?Q?YIH3CeEDSKUOPWeM9n0cn/7A2CIEIQN/P1LJ0ODcqeLBLD7cO5BW1jRBwmRE?=
 =?us-ascii?Q?BnplWvQ8CBISTGS6nvdU4jgXYAlsEi3t4/BBaz4KU9DWN8cZjAn+iRZ0Vgdq?=
 =?us-ascii?Q?8nxHdGJFVmd94IfXlPge07Im2PZTmb+Nw5NAx3R+Ijf+ixbIRjuH9OSrmvKJ?=
 =?us-ascii?Q?N2ryvzjtRnd2GCE1vNRsawyAFhXUrjBoL8NI0EbG+rh7RWo+frGFLNmDbUc/?=
 =?us-ascii?Q?z9zRe9zfKhWPZOtdA481smwTezuAMTUDlMAW3X3pWm/p0XXWAGLORJQOAxuQ?=
 =?us-ascii?Q?xaaI2R3/ISKDcZ6rjEqd7RRQXWblw3HIWMGSJWC1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48a4881-712e-4663-a1c4-08db3af59dce
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 01:31:19.1444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hIozsoWiUlF3CHbJNShTKp4y/Ms2QQExDRLBBCjtgqgC2KqxpxZfnn50Ag7h/rePPeMJcUN4SiN0QHfGmmlPMO6hGB0ZG+LtvkXx9hQzC8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6409
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, April 11, 2023 12:25 AM, Stanislav Fomichev <sdf@google.com> wr=
ote:
>On 04/10, Song Yoong Siang wrote:
>> Add receive hardware timestamp metadata support via kfunc to XDP
>> receive packets.
>>
>> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
>> .../net/ethernet/stmicro/stmmac/stmmac_main.c | 24 +++++++++++++++++--
>>  2 files changed, 23 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>> b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>> index ac8ccf851708..760445275da8 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>> @@ -94,6 +94,7 @@ struct stmmac_rx_buffer {
>>
>>  struct stmmac_xdp_buff {
>>  	struct xdp_buff xdp;
>> +	ktime_t rx_hwts;
>>  };
>>
>>  struct stmmac_rx_queue {
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index f7bbdf04d20c..ca183fbfde85 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -5307,6 +5307,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int
>limit, u32 queue)
>>  			}
>>  		}
>>
>
>[..]
>
>> +		stmmac_get_rx_hwtstamp(priv, p, np, &ctx.rx_hwts);
>
>Do we want to pay this cost for every packet?
>
>The preferred alternative is to store enough state in the stmmac_xdp_buff =
so we
>can get to this data from stmmac_xdp_rx_timestamp.
>
>I haven't read this code, but tentatively:
>- move priv, p, np into stmmac_xdp_buff, assign them here instead of
>  calling stmmac_get_rx_hwtstamp
>- call stmmac_get_rx_hwtstamp from stmmac_xdp_rx_timestamp with the
>  stored priv, p, np
>
>That would ensure that we won't waste the cycles pulling out the rx timest=
amp
>for every packet if the higher levels / users don't care.
>
>Would something like this work?

Hi Stanislav Fomichev,

Thanks for your comments.

Original stmmac_rx() function is already calling stmmac_get_rx_hwtstamp() f=
or
every packet. This patch move the calling of stmmac_get_rx_hwtstamp() earli=
er
so that rx timestamp is available before running bpf_prog_run_xdp(). So, i
think no additional cost introduced here. Any other thoughts?

Furthermore, stmmac_get_rx_hwtstamp() will check whether hw timestamp is
enabled in driver and  available in the descriptor before getting the hw ti=
mestamp.

>
>> +
>>  		if (!skb) {
>>  			unsigned int pre_len, sync_len;
>>
>> @@ -5315,7 +5317,7 @@ static int stmmac_rx(struct stmmac_priv *priv,
>> int limit, u32 queue)
>>
>>  			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
>>  			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
>> -					 buf->page_offset, buf1_len, false);
>> +					 buf->page_offset, buf1_len, true);
>>
>>  			pre_len =3D ctx.xdp.data_end - ctx.xdp.data_hard_start -
>>  				  buf->page_offset;
>> @@ -5411,7 +5413,7 @@ static int stmmac_rx(struct stmmac_priv *priv,
>> int limit, u32 queue)
>>
>>  		shhwtstamp =3D skb_hwtstamps(skb);
>>  		memset(shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
>> -		stmmac_get_rx_hwtstamp(priv, p, np, &shhwtstamp->hwtstamp);

Original stmmac_get_rx_hwtstamp() function is called here.

Thanks & Regards
Siang

>> +		shhwtstamp->hwtstamp =3D ctx.rx_hwts;
>>
>>  		stmmac_rx_vlan(priv->dev, skb);
>>  		skb->protocol =3D eth_type_trans(skb, priv->dev); @@ -7071,6
>+7073,22
>> @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
>>  	}
>>  }
>>
>> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64
>> +*timestamp) {
>> +	const struct stmmac_xdp_buff *ctx =3D (void *)_ctx;
>> +
>> +	if (ctx->rx_hwts) {
>> +		*timestamp =3D ctx->rx_hwts;
>> +		return 0;
>> +	}
>> +
>> +	return -ENODATA;
>> +}
>> +
>> +const struct xdp_metadata_ops stmmac_xdp_metadata_ops =3D {
>> +	.xmo_rx_timestamp		=3D stmmac_xdp_rx_timestamp,
>> +};
>> +
>>  /**
>>   * stmmac_dvr_probe
>>   * @device: device pointer
>> @@ -7178,6 +7196,8 @@ int stmmac_dvr_probe(struct device *device,
>>
>>  	ndev->netdev_ops =3D &stmmac_netdev_ops;
>>
>> +	ndev->xdp_metadata_ops =3D &stmmac_xdp_metadata_ops;
>> +
>>  	ndev->hw_features =3D NETIF_F_SG | NETIF_F_IP_CSUM |
>NETIF_F_IPV6_CSUM |
>>  			    NETIF_F_RXCSUM;
>>  	ndev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
>NETDEV_XDP_ACT_REDIRECT
>> |
>> --
>> 2.34.1
>>
