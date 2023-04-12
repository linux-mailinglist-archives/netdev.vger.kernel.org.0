Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF1E6DEA15
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDLEAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDLEAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:00:30 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E38F40FB;
        Tue, 11 Apr 2023 21:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681272028; x=1712808028;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e2feOiZFtRi1YnQLkrzWK4eznEOYotza5zO3LjXDyeE=;
  b=auCCmHBtc1N6hQcrGZzfaO3/zp82no5bsQlqpu6UWZTTS6k6Q7tRFkpM
   c+XyXLaBvIMp3wl2JkvDVnaf8tATtIxWAmCLAeO50YzGM1e/ng4kkoTFI
   uswkE7BvVnWJb0wbdYHl8YEnxgV8DH9O0CAOvwZnQxxV4kXGPzph4VdRu
   cwmzccylTyMVSqHaPQXp4oh41NQNgv78k8jb51ttJPHRQ+HtPjO49c+k9
   QdpzhJD/gZRZLvDOU1QnVatOLtPKdmLuQu63P+0Rhfj769pvcdSFNuSdJ
   T9x/Hrmvb3l61+2L6VJXGVzE7xRIRXpDS73WYrcyBRegveG17AzKsCjrz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="371644678"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="371644678"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 21:00:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="688808182"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="688808182"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 11 Apr 2023 21:00:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 21:00:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 21:00:26 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 21:00:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRDlg/zXWLfC7/kAylvGc1/r2yQHSbMKb2uHntCvSAfYahpTwiXYCGloGtcVnJMSiIb3GCh1j2kwBgL7eEPgEao8waUo5xpbM4957xYb3gQm70jSH/zI3BWDFDzZ9aI0RV4ofjqTcTEaBIYhb5Qhah5cekr3nFvIKIE0ewD6ebEtrUUmFN1ugXtus9dZEXE4TrNcw/yeIab+syifbmfWPKLXlq8fhNkti+uYi0rDavUfbm0J4ft/2McyxSh0m8eltjXcG6HDYOPj9sR+PaJCQO3LqS6ltwk5sEpa/O0lcNC9uOqaPAElZ2FmRGu+FDFoITY2+hz6smk31C/bojQADA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=if9dXD1Hb/NClR2z/GI0r9fdiQmaZkymY8o0VcuUJIE=;
 b=VO5lxi3itypHTcEn6Uqi+NUa3suNDbKSNLq6TPNTcaMVwJAQRBDbd4hNQCyCtMGjQVrTgvF50r5EQQm0Gn29DFsnHNG3vO5imkPfauIbpQCKw+7kqgLEu/x95btfmf3kZWcQ7uUUBy4bVaTGjSTh/h8+mutEPolYRSapI06BEJvZcnOvhJ9tzhMTGPYBk7+dW0r2GGuevLObWsde4epc9Zi+gTMQi+M2d96k7FDCNxJ3HfYC9VXzOXf73/8UWG1v3+Hc131Fmxx7keDBG8UbGXEbU2zavzHKzl8oH07Q/+azMElaF4PJIlxXqIUwdRz/c7KI7B2z0tO7hgQgd2YnUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by SJ0PR11MB6719.namprd11.prod.outlook.com (2603:10b6:a03:478::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Wed, 12 Apr
 2023 04:00:24 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 04:00:24 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        Stanislav Fomichev <sdf@google.com>
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
Thread-Index: AQHZa5S9mRB50P2QwkG1pXlh2ZtnBK8kuuaAgAIgiBCAABn7sA==
Date:   Wed, 12 Apr 2023 04:00:24 +0000
Message-ID: <PH0PR11MB583054F75B9B76ECF4F207DAD89B9@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230410100939.331833-1-yoong.siang.song@intel.com>
 <20230410100939.331833-4-yoong.siang.song@intel.com>
 <ZDQ4a9UIVysA6hgd@google.com>
 <PH0PR11MB583042FF9988C2B445B7B06FD89B9@PH0PR11MB5830.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB583042FF9988C2B445B7B06FD89B9@PH0PR11MB5830.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|SJ0PR11MB6719:EE_
x-ms-office365-filtering-correlation-id: aa52ca83-c2b8-47a5-28a4-08db3b0a718c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2NLNxRdJ4+8aZkez07pCbChJPtvMpBwhKJg3wgTCX8ko4zHCQ+McXXEtM/4eIgmryNe2dBPPySLQCgGd/29j0zUjiz/k/It958XjbpwAGeOMv3kKJHbiUjsJjYtrc+BO9kfYBVerwK5gZk5OY9+StVIhamxKQx0fPYcRKWxaXDZZ5SuSCAQVqZVKcEimItyhhkL3mh6P6XdUfD4nRJyT/L4TexDFkg2C4IEQpQbu7HkysFFF7OYgrc7HtK1QKoOheM1o/gdB7gGZC6cslkigC1lbfM7spQfWLsG97MqM02MHS+pGcFXbIFke1zyz9U71cEozqWSd5GEJtcT9G+jLoZSyaEmMESjJI42+0cI2nJbJ6XKUwLhfG2gGIy/CxILIh6eItAGQgvZWYOL/w+FFbqaEb9hSO3S8ZH3pG4SVej+7JzvMpNaIpoOKrixjxAouO7PVJRkcwOfHKBhhiZz+hMflli2zQVN4imOqg2ohNWaPFhG8b6CVC8r1ncd08imQCpAzOBiu+kSKy6l1Yzpmcd29Kt90xlmGlxGQuzXpuJkKK1ARKxmTUUnnq7ZcYAjDPrTt6b+e2bWCJ3+ICgz79/PFpqNiFf/eEmYKhDitdd0TpV8UZ8CMq+lL12SE5Rz3QsFzJd2Y0lJQcqrgu2yJ6c0FFyqtO1Qw+NmFLIFwiVE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199021)(8676002)(52536014)(4326008)(38070700005)(76116006)(64756008)(110136005)(66476007)(41300700001)(82960400001)(316002)(66556008)(66446008)(122000001)(54906003)(7416002)(66946007)(38100700002)(8936002)(86362001)(478600001)(5660300002)(2906002)(71200400001)(7696005)(53546011)(33656002)(55016003)(26005)(55236004)(2940100002)(9686003)(6506007)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QNfCCreyeltbj1PfH03Xhmd73lOTSTfQ9QPESF1szykak4GWKYBwsZSCHhFK?=
 =?us-ascii?Q?d1tMh+ZhqMGn2A+LTUsORkhIPr66iCs6xqqYHz2ehSZwkZsdAs4jFbJiFqGK?=
 =?us-ascii?Q?oxp6tPYUV9Y3ZhEnSb9GUxTy4W8SLaGz+FotJqsyP1Qq3FWAKxFL+Em2FNLa?=
 =?us-ascii?Q?1tyH3u8eqc8c3u1T7iTB57x6zbms9JRX7HecT6Tu5T91exSqHU0K+pmb7vEC?=
 =?us-ascii?Q?tFz283dgXksQ+Pq76qM3t992r8GPRnmZ+gDvQqIq1fObFpiv//Gw6/83PBz2?=
 =?us-ascii?Q?Omaqmq5Q8jhVg68/DhKjsJm8ZXRYkJZ68hXCifLKnloN92I5Ln/DE/M1DiWO?=
 =?us-ascii?Q?1BrV/KiUrDTdpGxZ2DLH6PSpawSg0c0LzX3K7PT7Go2UQvJJP4VM2TKYbbtO?=
 =?us-ascii?Q?BUkA8p2qYSd+K/MD8VFr81xChwy4sfg3bPZy5wcW4WIHSbjjxnFS62ncht7d?=
 =?us-ascii?Q?JAIpkz8bxa+wyqz/8LTrYku3MRhPagQSpcrxalXrDWmjxFGWz7kKpj1oWHfg?=
 =?us-ascii?Q?weSqYQvDEpfJULoq3KhSWa3XTH01FdZ7GxYGk1sYSLOLGnt/Cl0h3GSVJIpJ?=
 =?us-ascii?Q?JULMrO5p7xh8rDpi9hRDRWdwGLPXHIvSNkGJykOcsYKS9IHC/dHO1K+vnz6X?=
 =?us-ascii?Q?3WLL/F+7/DrDun9YdfpwJgRMTU6GyoWypbSoWn0/y7xQObhtiy3rkmi7mLOL?=
 =?us-ascii?Q?MAOHkjTQ1RxfiqTlWg6u/x+wHa19k/yG/pl7vdcnqwKheafwDxhliyp9gyK+?=
 =?us-ascii?Q?xoXL560ptI3fmF76ZP6ZCY9fdX5/0h0tkIgatifK4QWJVBCORmsx2wTBKUQB?=
 =?us-ascii?Q?5ACnfR4zEy0OpZ5OHOCpGbLcSvbvMY87h+AF3GyhXc/RYtkxinoXglGlJeoI?=
 =?us-ascii?Q?cKRg/FlzGzPL4ezEdOi0Pj+X2QI7oMOLUKK8L5Gp2lC7z5gxcYmmYp+/Qkm9?=
 =?us-ascii?Q?IRlS7wtj7TzozN5jonmRiwy1K2L5PA4+zodSj/1+yDD8l3ZbGtYQvrA5UiF4?=
 =?us-ascii?Q?wz3lm+8+nWspe5COMsRgqgckkTlbpyb++nAX9fbY6VQLYIl3H9j/qZRuBio1?=
 =?us-ascii?Q?7cntyEyUsNmZLy9uQKsjx22bzQntgLZJVkVG+MpVMiBOyosFwVGUzzDAlWx0?=
 =?us-ascii?Q?7bTvgI+oDB+q4biiSQHEf8z4qJZDYqDDF2jWn3lEvKe5NsvJeOJc1OTuwIO7?=
 =?us-ascii?Q?duRnBz09D4BbSVccrqgzGpwEuIivVpGcphiQPSo4CcneAAiOnuk3zxNomP0g?=
 =?us-ascii?Q?r0bron/ZyuDUjhhVhExB1lO5RMGmo4PGeHuUUzbAgn03gGoI2tZcGMKlZAOk?=
 =?us-ascii?Q?KUgx2GbhExP226Om0lP3JC7WZHo23biPKMW3nsZ9FYEIIhgP2mxqVtQEmBpW?=
 =?us-ascii?Q?zX6amhUJhesMsls9hVOT2A3rckm6CWSrLrHjonEAERYrD2sPcvNBt60UCzJ/?=
 =?us-ascii?Q?IDI2yixUd/SgquG18hkdu+4GE7y7qoLUe1EIQ2xI42fZfX6nNlSBkKL0GySb?=
 =?us-ascii?Q?7kax5GT697/vwwiwcxT4MEv/0GDyuifOhodMIKLbByp2aIxbbuH+WjwB5PBC?=
 =?us-ascii?Q?Z8xCsC1zWAxIeLay2zCy6wh7Kzjv1kxhUdL91zzO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa52ca83-c2b8-47a5-28a4-08db3b0a718c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 04:00:24.3447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HWmsLcZLuPBa+/5RKo92gcsbL5UZYjHmB586/gzRa4P0tZ5LbnYrrD/24nf6/jL6R5lWuU+5hJlEZdI5OfXZz1qLAyl+ySGVSuTK8VF64Dk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6719
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, April 12, 2023 9:31 AM, Song Yoong Siang <yoong.siang.song@in=
tel.com> wrote:
>On Tuesday, April 11, 2023 12:25 AM, Stanislav Fomichev <sdf@google.com>
>wrote:
>>On 04/10, Song Yoong Siang wrote:
>>> Add receive hardware timestamp metadata support via kfunc to XDP
>>> receive packets.
>>>
>>> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
>>> ---
>>>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
>>> .../net/ethernet/stmicro/stmmac/stmmac_main.c | 24
>>> +++++++++++++++++--
>>>  2 files changed, 23 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>> b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>> index ac8ccf851708..760445275da8 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>> @@ -94,6 +94,7 @@ struct stmmac_rx_buffer {
>>>
>>>  struct stmmac_xdp_buff {
>>>  	struct xdp_buff xdp;
>>> +	ktime_t rx_hwts;
>>>  };
>>>
>>>  struct stmmac_rx_queue {
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>> index f7bbdf04d20c..ca183fbfde85 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>> @@ -5307,6 +5307,8 @@ static int stmmac_rx(struct stmmac_priv *priv,
>>> int
>>limit, u32 queue)
>>>  			}
>>>  		}
>>>
>>
>>[..]
>>
>>> +		stmmac_get_rx_hwtstamp(priv, p, np, &ctx.rx_hwts);
>>
>>Do we want to pay this cost for every packet?
>>
>>The preferred alternative is to store enough state in the
>>stmmac_xdp_buff so we can get to this data from stmmac_xdp_rx_timestamp.
>>
>>I haven't read this code, but tentatively:
>>- move priv, p, np into stmmac_xdp_buff, assign them here instead of
>>  calling stmmac_get_rx_hwtstamp
>>- call stmmac_get_rx_hwtstamp from stmmac_xdp_rx_timestamp with the
>>  stored priv, p, np
>>
>>That would ensure that we won't waste the cycles pulling out the rx
>>timestamp for every packet if the higher levels / users don't care.
>>
>>Would something like this work?
>
>Hi Stanislav Fomichev,
>
>Thanks for your comments.
>
>Original stmmac_rx() function is already calling stmmac_get_rx_hwtstamp() =
for
>every packet. This patch move the calling of stmmac_get_rx_hwtstamp() earl=
ier
>so that rx timestamp is available before running bpf_prog_run_xdp(). So, i=
 think
>no additional cost introduced here. Any other thoughts?
>
>Furthermore, stmmac_get_rx_hwtstamp() will check whether hw timestamp is
>enabled in driver and  available in the descriptor before getting the hw t=
imestamp.
>
Hi Stanislav Fomichev,

I think twice. It might add some latency for certain verdict if the hw time=
stamp is
enabled but the user app dint need it. I will take your suggestion and try =
to pull
the timestamp per need basic. Will submit v3 soon.

Thanks & Regards
Siang
>>
>>> +
>>>  		if (!skb) {
>>>  			unsigned int pre_len, sync_len;
>>>
>>> @@ -5315,7 +5317,7 @@ static int stmmac_rx(struct stmmac_priv *priv,
>>> int limit, u32 queue)
>>>
>>>  			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
>>>  			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
>>> -					 buf->page_offset, buf1_len, false);
>>> +					 buf->page_offset, buf1_len, true);
>>>
>>>  			pre_len =3D ctx.xdp.data_end - ctx.xdp.data_hard_start -
>>>  				  buf->page_offset;
>>> @@ -5411,7 +5413,7 @@ static int stmmac_rx(struct stmmac_priv *priv,
>>> int limit, u32 queue)
>>>
>>>  		shhwtstamp =3D skb_hwtstamps(skb);
>>>  		memset(shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
>>> -		stmmac_get_rx_hwtstamp(priv, p, np, &shhwtstamp->hwtstamp);
>
>Original stmmac_get_rx_hwtstamp() function is called here.
>
>Thanks & Regards
>Siang
>
>>> +		shhwtstamp->hwtstamp =3D ctx.rx_hwts;
>>>
>>>  		stmmac_rx_vlan(priv->dev, skb);
>>>  		skb->protocol =3D eth_type_trans(skb, priv->dev); @@ -7071,6
>>+7073,22
>>> @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
>>>  	}
>>>  }
>>>
>>> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64
>>> +*timestamp) {
>>> +	const struct stmmac_xdp_buff *ctx =3D (void *)_ctx;
>>> +
>>> +	if (ctx->rx_hwts) {
>>> +		*timestamp =3D ctx->rx_hwts;
>>> +		return 0;
>>> +	}
>>> +
>>> +	return -ENODATA;
>>> +}
>>> +
>>> +const struct xdp_metadata_ops stmmac_xdp_metadata_ops =3D {
>>> +	.xmo_rx_timestamp		=3D stmmac_xdp_rx_timestamp,
>>> +};
>>> +
>>>  /**
>>>   * stmmac_dvr_probe
>>>   * @device: device pointer
>>> @@ -7178,6 +7196,8 @@ int stmmac_dvr_probe(struct device *device,
>>>
>>>  	ndev->netdev_ops =3D &stmmac_netdev_ops;
>>>
>>> +	ndev->xdp_metadata_ops =3D &stmmac_xdp_metadata_ops;
>>> +
>>>  	ndev->hw_features =3D NETIF_F_SG | NETIF_F_IP_CSUM |
>>NETIF_F_IPV6_CSUM |
>>>  			    NETIF_F_RXCSUM;
>>>  	ndev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
>>NETDEV_XDP_ACT_REDIRECT
>>> |
>>> --
>>> 2.34.1
>>>
