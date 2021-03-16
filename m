Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F280B33CCAA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 05:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhCPEog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 00:44:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:16424 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhCPEoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 00:44:21 -0400
IronPort-SDR: T1Ft+KCoIk/oDJ3twQYk7J9waR6rCK6oWtH29+AtYuvyLmE2/XRDU8u8FdfT1ojE6Oaf56PJvl
 rZGVCJdFUOhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="189289598"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="189289598"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 21:44:20 -0700
IronPort-SDR: FarwNpyQIitSAEEqsDkPnU9EXHWwmUMZPuh+E0dGY98pQG6g/JDiAaEfJzEkHiEmsr2SvCfbVI
 7rQrR7fZFTTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="590527064"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 15 Mar 2021 21:44:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 21:44:19 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 21:44:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 15 Mar 2021 21:44:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 15 Mar 2021 21:44:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpTsXwGujVuOP0sVEG/ypH7pXRD4XwZFKorQq5lI8gHgqcp1ct/x/5nOzBuqqCweY0aMQzm64so7WkNxuNlFEFqzqnLiBsqMss/1pi9PaktS3nrgkuQSru2TIMb15QzNg3oZM7DFszvShKjjzXY27VdVRKmPNI2tyXaHQXWc3jFOls3nJDUTQSy2zyualZZ3qc7f9TCHXEPtXaMzPs6n+Xm/ANktB/ahs5d/ali9nM8yQasMeAaoMhE0I4kllEBCTRmzPppEjyU8UXqz7bniWR2yD8ERAnntqNZrLtvk9eUsO7/FRUJEcIlrOC1Xw1PydlBP+7WVvld9ukFWOvQd8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5RZa+C7LCRIdOttRlZNE9o0qv+0sg/tWUTWc16HJ8bE=;
 b=P6k59c6gbA6amS8dvyGNXg+5yofO68QdCxLuiSWCu7RsjsyTgroAKOd4vG6bgULIVbXg31riipChQH3RpXx/6+YD3sYvVZ2XfGcaKo6QW3qc+3Vqb5KqvJnGc/pto1Ux302ksDFI76eu9qk7GKDNu7zFoWzVAKA2m6V6xiCWuiMf2Zwtpw3Tb6rwR6WyO51wQY1vYfbqtw0xLTO4TVCNkz5gQZw0vcxHTVA1Q3bhhXOcs8XobrLHfBB4EaEzWFmsrZ5wldAAdVFoDlp/ELE/3kqVPQR67+QiZGe2TYGanYn6/UOors2Pm8VtBMESMJnx4DSJ8VBRgzP/D4SIUlLcaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5RZa+C7LCRIdOttRlZNE9o0qv+0sg/tWUTWc16HJ8bE=;
 b=u1w5n/V6AYaaXIDsfyB3/SmnFz2BqOi31kMdJhQzUMAZ1eetL0cO8+5Kn1bxaTr/2cJA4Qhkd59ATr7+fZg069BN9GO+9RC96ESdu9pE5MmFusT89me85p5chCnh3Ga4K1QY7IY9jiC/Jw+3qKtMybx5W9txAd7JnrueYIUfC6M=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB2779.namprd11.prod.outlook.com (2603:10b6:5:c6::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Tue, 16 Mar 2021 04:44:17 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864%7]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 04:44:17 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] net: stmmac: add per-queue TX & RX coalesce
 ethtool support
Thread-Topic: [PATCH net-next 1/1] net: stmmac: add per-queue TX & RX coalesce
 ethtool support
Thread-Index: AQHXGWY4iPTB8mxCmEyHuG5mH10Z/aqFdj6AgACUAAA=
Date:   Tue, 16 Mar 2021 04:44:17 +0000
Message-ID: <DM6PR11MB2780933A34D80D27920DB977CA6B9@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20210315064448.16391-1-boon.leong.ong@intel.com>
        <20210315064448.16391-2-boon.leong.ong@intel.com>
 <20210315125059.32fde79a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210315125059.32fde79a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.159.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 627ef3ff-82bb-46ba-2835-08d8e8362857
x-ms-traffictypediagnostic: DM6PR11MB2779:
x-microsoft-antispam-prvs: <DM6PR11MB277919602299DEC9D6FA422ECA6B9@DM6PR11MB2779.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 70Y5fhh57GIPGt39ryZtM+5Ah6TqJS/8/jP76+BsE1hcBseZZUMP86mmFCNCyAz5TIiq5L+HyWJbLrypdfRDBXwVEYD9+OzzhC6itaoI1geWYs9NBSd//6NnoGoiuEPXO7H2eqXo2bJ4UJEygcc6ChLd0rfYvOi1AqrXY6czLVArwFpq4I2HBD8ZHKvBvIF7OKsf2jBbHBtnBXRc52VJBJ89AxLg/7EJs5FF3F2hk9seVLW50h8i5y6lxNH/CO2ieZBF6NpXD6KyNnQ6PVIDw+Y6w3mBnmSuU41dl/GWZ7HYeh7g3dl0tUb8oTdkxLpKMQp0zapnuy1iLcZpdTPztX/wmlxyZ+2bjYSTuZB/hRg2hKHWvHqJTn0TrFrZFDIxUSkOglHd/wrbnnlEUiHqQD9HLaQwcQaxGa5lX36XyKXoCpuzuKTjfOnEv04UR1kJDsCbK5yTonPZlAO/wtRT+kd3hi+GeF241snqaO82q0irOoZoYoa5NPWc5lBlUTI2IC3PgeqmqZBRoMFr4GNa4fixJqEmGb6NniljoJfk9nr+ARL1dntUHyxVSewndNfY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(346002)(376002)(396003)(66446008)(66946007)(5660300002)(64756008)(76116006)(66476007)(186003)(66556008)(52536014)(26005)(7416002)(33656002)(316002)(6506007)(478600001)(6916009)(7696005)(4326008)(2906002)(55016002)(86362001)(83380400001)(9686003)(8676002)(8936002)(54906003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?EZJPAfk+9q/cPGg5nWqef5tVdopD9oni2B6isyZNr8qeXyu6cFG9RytosT5J?=
 =?us-ascii?Q?eqBE8nmyPTmmCSmPfHjXkWoUVFsgfDYKcJSLkPiy+5PTMJhFy2s5rd+EUGLY?=
 =?us-ascii?Q?+lrotAcaLSeRmXkFAkRvPIrlNFh6XvCLq34neNZFG4JtbNhAW89QB/Iv/gKo?=
 =?us-ascii?Q?5i6R91cg7vhYDkGK1Y8WL5Myx5CjiTp5jpWbVBdkPsaIvUM0hxRujKxoFBG+?=
 =?us-ascii?Q?iLxdB2EzJ4pT/KtuuDd/pwWS0X29V9ZIvw+h0A77Kg+zGHASpk67BrDvqRYE?=
 =?us-ascii?Q?x/VUq0xrTYdbAuSQZuy486ktTnVWLWYstamoKe5VyWSCfKJ9se5uvLhW3y0I?=
 =?us-ascii?Q?BxNigLySX/v+F7kLvo0xIV9zCcCHlkLcY3LiBTgenuPSvi1LXIwkmSJu2smL?=
 =?us-ascii?Q?4THV2gmgAU6t7gBty6m8/4XtUYk/staxdqmjismZJSz+7U27wRlcBciuJsLG?=
 =?us-ascii?Q?vapKW7ZyRnqYgthz09nSUhqJaIVLMzz/jMGepTR6DE/1FkBD8aJTt/pZB+Nx?=
 =?us-ascii?Q?9FBI3bbTbgmBQExBqa/V6x7wtxE5FUH+h+3ysDm8ZXx8AgXhE7b9Uy8Ebbug?=
 =?us-ascii?Q?sCPfafVnBqkw17K/jvjAsz70jOu25ux218hM1HHcsuK6LGilt4iMd9Lhoe4P?=
 =?us-ascii?Q?xf6KSJwratvKdx7/Qy2HBgL1FTF1Gmgd7t1IUJp4eGfxpGjiIbVVMN+hRUPR?=
 =?us-ascii?Q?lNxQPKViPajqcMr9z9YDybJU0skekX6uDP5L6Cjfycr+Yue/LadwWmf4x8Mb?=
 =?us-ascii?Q?1BhGBSZoUNUccGeJocSSVq8DLyM38rtYmp+CKnr+gbsNrUjNCBVG9iD7T+2j?=
 =?us-ascii?Q?kt3WPoKSPDWogKSaKa3nsJs/ItnSVkYbMW2PfErXaYIuiy4mpm95Rke/b/n2?=
 =?us-ascii?Q?M3O0WWcJ7guzkdvogtsBNPi1IyFaEeTnmHUiX57LlxglUZeUX6UtR/Oy2b1K?=
 =?us-ascii?Q?C3I3mFgsli5WHx7EDhFUEzM3c18iT4MXNi4PCfRF/WkBeO7pch3IzfEqvvUi?=
 =?us-ascii?Q?XZcFp+MdYBAAgWr2sVUK+hapzZ2E1fP6+VYb66wRhbyPTLM5bpWgBTRWlTkk?=
 =?us-ascii?Q?vUDB3WnGcZlHSY9hmvc3vuAsQBF6V6RdBToGGZEiYKv5qoZfkQKiBdVTwAY/?=
 =?us-ascii?Q?fKHuorELQ3vohZa5ii8HmN2SPANPBONrdR2mbz2qKCiKzmiMNFMhCFag+KH7?=
 =?us-ascii?Q?qdco0CX3EN/S7AQ6bfEcHjYrGnsYpzsDvauESrXnhZioomanxiS2ANgqEnvO?=
 =?us-ascii?Q?r3XkLk+4Jw7CdJQUjjUExuICjymk26NLUlva4ePAlVq0A5iMlyzlZYlI1Dlf?=
 =?us-ascii?Q?OYfAnfqlECPC+znBN+fSW3l3?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 627ef3ff-82bb-46ba-2835-08d8e8362857
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 04:44:17.4424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64m9Zw40B+ItqF7wCLwxcfnfEXkzE7DPvKC05lMs3ePxUOomLoGMcjpJe0Dg8ovedatskNrF1R3++UW6E2Em3bwjt8lCIDHNB7sOxnbcclw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2779
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +	if (queue < tx_cnt) {
>> +		ec->tx_coalesce_usecs =3D priv->tx_coal_timer[queue];
>> +		ec->tx_max_coalesced_frames =3D priv->tx_coal_frames[queue];
>> +	} else {
>> +		ec->tx_coalesce_usecs =3D -1;
>> +		ec->tx_max_coalesced_frames =3D -1;
>> +	}
>> +
>> +	if (priv->use_riwt && queue < rx_cnt) {
>> +		ec->rx_max_coalesced_frames =3D priv->rx_coal_frames[queue];
>> +		ec->rx_coalesce_usecs =3D stmmac_riwt2usec(priv-
>>rx_riwt[queue],
>> +							 priv);
>> +	} else {
>> +		ec->rx_max_coalesced_frames =3D -1;
>> +		ec->rx_coalesce_usecs =3D -1;
>
>Why the use of negative values? why not leave them as 0?
The initial logic was to return negative value to unsupported TXQ & RXQ
since they are invalid. No preference here. So, we can leave it as all zero=
s.

>
>>  	}
>>
>>  	return 0;
>>  }
>>
>> -static int stmmac_set_coalesce(struct net_device *dev,
>> +static int stmmac_get_coalesce(struct net_device *dev,
>>  			       struct ethtool_coalesce *ec)
>> +{
>> +	return __stmmac_get_coalesce(dev, ec, -1);
>> +}
>> +
>> +static int stmmac_get_per_queue_coalesce(struct net_device *dev, u32
>queue,
>> +					 struct ethtool_coalesce *ec)
>> +{
>> +	return __stmmac_get_coalesce(dev, ec, queue);
>> +}
>> +
>> +static int __stmmac_set_coalesce(struct net_device *dev,
>> +				 struct ethtool_coalesce *ec,
>> +				 int queue)
>>  {
>>  	struct stmmac_priv *priv =3D netdev_priv(dev);
>> -	u32 rx_cnt =3D priv->plat->rx_queues_to_use;
>> +	bool all_queues =3D false;
>>  	unsigned int rx_riwt;
>> +	u32 max_cnt;
>> +	u32 rx_cnt;
>> +	u32 tx_cnt;
>> +
>> +	rx_cnt =3D priv->plat->rx_queues_to_use;
>> +	tx_cnt =3D priv->plat->tx_queues_to_use;
>> +	max_cnt =3D max(rx_cnt, tx_cnt);
>> +
>> +	if (queue < 0)
>> +		all_queues =3D true;
>> +	else if (queue >=3D max_cnt)
>> +		return -EINVAL;
>> +
>> +	/* Check not supported parameters  */
>> +	if (ec->rx_coalesce_usecs_irq ||
>> +	    ec->rx_max_coalesced_frames_irq || ec->tx_coalesce_usecs_irq ||
>> +	    ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce ||
>> +	    ec->pkt_rate_low || ec->rx_coalesce_usecs_low ||
>> +	    ec->rx_max_coalesced_frames_low || ec->tx_coalesce_usecs_high ||
>> +	    ec->tx_max_coalesced_frames_low || ec->pkt_rate_high ||
>> +	    ec->tx_coalesce_usecs_low || ec->rx_coalesce_usecs_high ||
>> +	    ec->rx_max_coalesced_frames_high ||
>> +	    ec->tx_max_coalesced_frames_irq ||
>> +	    ec->stats_block_coalesce_usecs ||
>> +	    ec->tx_max_coalesced_frames_high || ec->rate_sample_interval)
>> +		return -EOPNOTSUPP;
>
>This shouldn't be needed now that supporter types are expressed in
>dev->ethtool_ops->supported_coalesce_params, no?
Wil fix this. Thanks for pointing out.=20
