Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2325EBAD7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 08:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiI0GlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 02:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiI0GlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 02:41:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FAC80489
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 23:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664260869; x=1695796869;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=toI1yCCnasnPTIaJ5ZkZAyBmOqC4IEomBs4E92ZkfvQ=;
  b=kXhz+XmHeGLerJkXSRk6f7IWsiAKpfxZhdSBk5FWiq5B0Bg1MfkAjImh
   WaasMzV27KwGQyPnERp5zY35ffdBtyOSXWYbFb6BkQUYj4AKHK0dAwrbn
   5Jx9vp1RoNLS7f53O1rZJsTkp4LVXpKHKzWR0pflIeI9Ejvcb0c2VsyW+
   h2J8bwdYnvSJJVYrG3tlRw9F0ZlBC5KrWl+1ec9zKb5CWxvLGE2FaHx5v
   7+6ZTODyDRib4LLTBKNLAXu0DmiAuvoWk9AHKbdwecQgIBk4Nb31qbIMz
   8CeIim//khv16CbEgrTwyygfvE205eT/hYKqShJoCOs0zDSb6wtJeTDwb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="363075661"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="363075661"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 23:41:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652171454"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652171454"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 26 Sep 2022 23:41:07 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 23:41:06 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 23:41:06 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 26 Sep 2022 23:41:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 26 Sep 2022 23:41:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2gVIUFOT7dzD93uTe/msEiayU5PbMcsnEWp2ufx83cCESwUHfTMCzyjsEF9mbDk2JqTJW0HM43TgdjCw6W7An8aDR/8wS2Jm5PE5338sqoJhnljZIENn7+tCCOiNlrd6s0PrON8Crpsh0PsvkBMUsPfWmMjxRQKSyL8kRaXH+X6b7Gf8v4RLCXv2stDK5bCRNz5WDxzli0ZWob+AGszI7ZY4Wh2e1HHZwUfFjunA3/4wT3QHxBtVvfcvzxLmBRBquQQacqRYf1SalEE9oVf4uvC5XEZriCCOXd3in1p66cigkGUAouL9ofOAZlyT7MfAhuLNPMoaOKPBcDwvsvEbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTFIXZEKXzxzmLaE7J3rCFCb1O7LSA8IOnWP3AlUWiA=;
 b=HR6Z3iFciDRqujF1UXIUiofQTArz711+LAObqLJfZ91wk4tQNopxt7VEl4lH1G9dJYcJUIyKwc6RIN2ewHkxVS7L3XSlXZ0okNQ3kZ1SDBaXTTpzTFLFpbpO1fgQ5tdCgbjbIWmKDkCnmf7oxvjg1gE41kMARHB/1PeU8YVRAsm6WIjjQQEN+PJoEvEBFh8Rxc4mkMwxM8IpMoFPZatMZVX60gmoTBrBllsGtq7Wg5z+E4c4pkZ5JGHphxkF2SEa2QMIG7RqdTv3F4dg70Z99+SV0nr40V97a9cQI5AYuYW/XeXGDqqVhhGoJZ78TGWD0T45i5nli+SIbvSL6o47eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4995.namprd11.prod.outlook.com (2603:10b6:303:9f::22)
 by DM4PR11MB5374.namprd11.prod.outlook.com (2603:10b6:5:395::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 06:41:04 +0000
Received: from CO1PR11MB4995.namprd11.prod.outlook.com
 ([fe80::8a52:fc20:6c52:7427]) by CO1PR11MB4995.namprd11.prod.outlook.com
 ([fe80::8a52:fc20:6c52:7427%6]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 06:41:04 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>,
        linuxwwan <linuxwwan@intel.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH -next] net: wwan: iosm: Use skb_put_data() instead of
 skb_put/memcpy pair
Thread-Topic: [PATCH -next] net: wwan: iosm: Use skb_put_data() instead of
 skb_put/memcpy pair
Thread-Index: AQHY0hS1Kq4YlX1gYkat4XLsr0Hu6K3y06cw
Date:   Tue, 27 Sep 2022 06:41:04 +0000
Message-ID: <CO1PR11MB4995FFF775B81E5CD94C658BD7559@CO1PR11MB4995.namprd11.prod.outlook.com>
References: <20220927023254.30342-1-shangxiaojing@huawei.com>
In-Reply-To: <20220927023254.30342-1-shangxiaojing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4995:EE_|DM4PR11MB5374:EE_
x-ms-office365-filtering-correlation-id: d83215aa-d26c-4a47-c337-08daa0534028
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mbE8SfBbTcnjHtvkv2NnvWApEioDGr4MWocCyahO+fsdds2NPVvSxXHxmsvkPct+P6nZf0LG+7p8dvc4p/BPC093whEITTzh52b+LXuIUOPo+hxTE/K4REfWJbrRIPy2GpijaTeB/G/UHckdmSRDgbTPswfgRQUxKUHsoFtjt1E41KWXG7oNAvjNdyEuNWuiQP0bdAsI2Cf90jKqQP3YGnEzogIK9P33r3JCgV53V6AiP85CfuABX1cTf46lIKAeT9CbB19A7aHMuI6wqTcq2KoeSi07gTmzZIUdL/nefURwcjhVISZ5iVn2Mcgfh3IvqEzpEZdUInh2xVZLJNGZfLqPtIX+morKXVUKI3pzdaTgi02RsWyZNrRHBwaMvGUF1p+p/Z2oL9YKTZUiU/IOIhO3z8NTYaH8Lo+OT7zrPbAXREcD7BwdjXav46P1YFd3wIWEFqBB00iTba5dufkn9xOwwoBr538PYDE15PzOXJAAzwFqzaKZBQaHMkdOfGFVtfGuei6jubdxA7T4FtySA1tGyXWW7TdvDuQpzJUQtJEFrWcQ3XicxXNph282C7rJlqsIffwd/4J8q1b6NH1MzfqeH2yEQJIbBGv+kbqEPeEmWyCFiR79hD+AF/SiS9L/YUonjbCmMu98mo/O+cjGflN+UHCPTaV3m0hkVxkVvSybPGJ8cpNCvFvE4RdxQYHOtgJ+i2NitOMGTwJkT+GwPITHTvyCAPMj6ZtKky13dv0F/bPmXsbCZbO2DY523f5qAX4Krzh8YzaI2Ue3r7IlrLOz5QU0RPDY0l4NMWR0NVY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199015)(53546011)(9686003)(26005)(6506007)(55016003)(82960400001)(122000001)(38100700002)(86362001)(2906002)(71200400001)(5660300002)(478600001)(33656002)(921005)(38070700005)(83380400001)(186003)(41300700001)(76116006)(8676002)(66446008)(64756008)(66476007)(66946007)(8936002)(66556008)(316002)(52536014)(110136005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SPYcG9cVPOTwoD7AiCcfoTC2Ass7eHR7fhaQ09JzMGNzc0TDFmSb0MoXH9xL?=
 =?us-ascii?Q?0chD9NVSnU/HuTj/c/n6A6jIAR9v3F6j8wsKkfReRaRTg41CdkrLKZDDMq3Q?=
 =?us-ascii?Q?x7BAPVjvXlpQayclwHtU7AdH123LmKjdV4bz0IEfHi5C5/xQJn1zn8RbfecM?=
 =?us-ascii?Q?pUolGYxm1D657u95UlqLF3pIInP92yd56jN8wpdVQH6x4qpHwpXzlie7gKJP?=
 =?us-ascii?Q?2G517G9t7kJg08oqAPySh9AkbyazGMl805wf11QbXT/NGTwdawobCpWUjjpj?=
 =?us-ascii?Q?wWLZc1iNMXuMwXiYPlITwNV1fbriCRLdyNwvkXYUvvcZCPUuW5XnkcG6OadC?=
 =?us-ascii?Q?m+oUsilFL/+5ux9shREuVCNKg3Ww3orJl6rifLcAXmb4FDnC48t8/6XYVR4C?=
 =?us-ascii?Q?1+XxBMFrz44RBN4fjCkABUfKk/fRrh2X5n2xNPpu5sILYgIrOnqOUz52M0cG?=
 =?us-ascii?Q?ngN+8lnZA7BTKkd3IV58RqyRjkmy9XLweJZcUj7gNffpT8XlRoyoaydhJ7SL?=
 =?us-ascii?Q?Pupowns0lsAmkpj+E9e5WTsYCX3BYMl+CpqYTSDm6TkmunO09SJV5X9gxM/Q?=
 =?us-ascii?Q?0svh/z2oGKDYOZJMHroRpD2siCulmbIXIsZmt8CfyYHB+kUD9dJTf0xH3F+4?=
 =?us-ascii?Q?N3QU1W6dly9h1gFKf1/Zr4Zs9SZFkGA5xCn2MQI0lqjMrS2DNLsQ3mpwao3C?=
 =?us-ascii?Q?MJg6zYsIEuRuWzlZHffd+m+m3FqfKlrKZKeW9P7QHb5YwWZIuAmaTpFEwbcs?=
 =?us-ascii?Q?LdOJZc4fGLxkGxD5g+7KUm+EnGeR6IvOUPoxGiKB5j1sq4r9/aw/9gdWRBZ/?=
 =?us-ascii?Q?XPa3+NWkGOQLceD6A0WZdoFTJRWBFFPLmsDwWxuFJFR7lW+ZH8XA1qaechNR?=
 =?us-ascii?Q?yuDFjnySI0OwJqrdwygicQMAIZoiik66eQcu8nVE+inJtZqpfh0hmgxclKTW?=
 =?us-ascii?Q?jXlQsRLtsyYeBuK88R0k++R9+7DlZ/PvPTlLdlnvF9Af40OpZO6C/FzbNrQs?=
 =?us-ascii?Q?50AUKnkmDzf7dsK/+wNlGheE5CsYZJ6M4hQ6t95Db25OjZ76ul9BlFinCA5F?=
 =?us-ascii?Q?9iAUYX2ZMLXH2lMJ+IHGVQ2mXBBMxarpqDAeGxyr07q00l2Tcbzp5XRBAubn?=
 =?us-ascii?Q?1+zleW7LHWkOe2F7kdMTm2xaQkSkZBZwiqmkJCiH18XX/seT6IA6K5KW6CPQ?=
 =?us-ascii?Q?dHo1J7/mGRo8dE7PCecWfIQkcCshFbob9yK1OIgJ9jBHGNgzsQzI5TBPahbF?=
 =?us-ascii?Q?LpaDlk6/BUURiPJ/Kcesv+Lsn1EbTiw/wHj7yheAflDxbHIIB0FN3BHhD+H4?=
 =?us-ascii?Q?PBbYMO6SyrZ0pUpY8D2ilyn54eWgtLIcylNbyY7QKcgASuOVdBmz+yyK1JlC?=
 =?us-ascii?Q?sCYb3x7RYvW1VVFJGjlEnSzN2kE+MFdpJN7/u1UBK+aMJA+iH0knpSPGFJkg?=
 =?us-ascii?Q?Rge0h6EJUwOQNEf5/k2poqz2yO064WqmgYoonfFHtR2KuvJQ1TY+RH4ueSfX?=
 =?us-ascii?Q?AB2jCNqBnOin/n2dnw13rgGEIM5GEMKiM8kUtsmYY7uMTL8t1EptFks60bas?=
 =?us-ascii?Q?i1FiCOy7ZAh9OGjZt4qjMvN4LBcFdy87CjMMhj1O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d83215aa-d26c-4a47-c337-08daa0534028
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 06:41:04.5333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 80DTTwfuV21HCfiL5BdpSHxVVtbxiHm4XOEep/5F5xcNZCdQmPr+9I9Ijzh8vqlDe5XWPUNlN1PZ0bTn8ZCKuEjibVmalr7n/6YPs25QT/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5374
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Shang XiaoJing <shangxiaojing@huawei.com>
> Sent: Tuesday, September 27, 2022 8:03 AM
> To: Kumar, M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> <linuxwwan@intel.com>; loic.poulain@linaro.org; ryazanov.s.a@gmail.com;
> johannes@sipsolutions.net; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org
> Cc: shangxiaojing@huawei.com
> Subject: [PATCH -next] net: wwan: iosm: Use skb_put_data() instead of
> skb_put/memcpy pair
>=20
> Use skb_put_data() instead of skb_put() and memcpy(), which is clear.
>=20
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
> b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
> index 57304a5adf68..b7f9237dedf7 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
> @@ -590,7 +590,7 @@ int ipc_imem_sys_devlink_write(struct iosm_devlink
> *ipc_devlink,
>  		goto out;
>  	}
>=20
> -	memcpy(skb_put(skb, count), buf, count);
> +	skb_put_data(skb, buf, count);
>=20
>  	IPC_CB(skb)->op_type =3D UL_USR_OP_BLOCKED;

Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
