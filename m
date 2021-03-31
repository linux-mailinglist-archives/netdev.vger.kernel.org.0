Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7E0350A93
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhCaXKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:10:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:3663 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233002AbhCaXJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:09:56 -0400
IronPort-SDR: Cxam3nAHsvZHm4IqZhib7ochBUZRXAZLyqkTrnceB7u9zY9Uy7+nqHGIhlwKuiLflmnyRTRaSr
 jYSrb1cMMAPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="171525853"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="171525853"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:09:55 -0700
IronPort-SDR: 0JoIRlvsMjeodGWhszHQ5TpKEysAw5QyXThRkgFoUYww0e0CwCY7yA7IcH8SSMHee7lQLOT0Mg
 IQnsVqkxq3QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="517092645"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga001.fm.intel.com with ESMTP; 31 Mar 2021 16:09:54 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 31 Mar 2021 16:09:54 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 31 Mar 2021 16:09:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 31 Mar 2021 16:09:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 31 Mar 2021 16:09:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/2vblEoCeNCbPi0dLArVEFynKtQxNnRxiK7Iw3d+Bi2Cmo7pqXHqiFAMJEg2CAqcnil5yzIvHnCqSI3CK+Md7qh77o3FQ6/qRVVNpOUK+/5Mry10tUhkXKhNjBcQ0casJyVPPpfpF6mVHHRHB62HccjMllXhKFeE2GlmM0Xl91ld8weuB6FtNS6+uQG36XmJXzfdLeCpLsUjST64XS+u+ryYdrnoW/O8MRQ3COBoodE9jSuAI/yoBQtgZQhLy3rAFSoZmbI1szMShydj8T6le6zBIZlO9t98GWYA+Yxoy70zlG7/JeSCNZgRFzMiHM6TqtXMASrEe5n0X0ZFhjpKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FwrLgIy9JsbZlnhSv3jkZDyPAg97Q+G9h+i8AQCYic=;
 b=XhJ11uv6mVIfyR21p0pIXBrVbvb4hsfTnbxurqcF2FW4YitEd7JlG5qg+0wJcZB3Dr/y5diOSFRo+3/LYm5t6jr98UtD4+awPAQUDt6tXuiiAtInW4XdNCA3D3HIpjf1YlgoJjl+EmtQrwYb7t9q2aSzL0wylCdVtDwhTIsiIKF5rZxzZA6VS5xSd0XssBOLP9pmZ0u9j7Qz+6C0WWqFHCRPkmlEJa4O7u7WiCMkW9Yj4VX0f9qGVc5i/LQ0KqhhJRyL+4/IWj1wfjPKdkZshscH0xTX92HTzm8MTmeoI7pFOAJ8x2RrvvOgJ7TScgPomfhdIuhkBClWjOLvKDWe1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FwrLgIy9JsbZlnhSv3jkZDyPAg97Q+G9h+i8AQCYic=;
 b=LD51lPvoEwTbIHMFqGfUxM+XOvRJqpNVYWrLW8KA8nG5HazZXxIJzl1BQZa4HQZ7Cnkswx/CjV+dnH3phmusfNQgiPun7rXcl2k8yBH4GZ5W8CFtSmOQB42NWhH+ef9uRG3NqaSBUT2zX+jvWEdYLjXIVMFtc3B1B7OLFiN2S+w=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB2570.namprd11.prod.outlook.com (2603:10b6:5:ce::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.29; Wed, 31 Mar 2021 23:09:49 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864%7]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 23:09:49 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH net-next v3 5/6] net: stmmac: Add support for XDP_TX
 action
Thread-Topic: [PATCH net-next v3 5/6] net: stmmac: Add support for XDP_TX
 action
Thread-Index: AQHXJkPRS3lry65MNEi+4FFr/HBf7KqeoP6AgAAWzJA=
Date:   Wed, 31 Mar 2021 23:09:49 +0000
Message-ID: <DM6PR11MB27806DC9AA797C2AA8554581CA7C9@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20210331154135.8507-1-boon.leong.ong@intel.com>
        <20210331154135.8507-6-boon.leong.ong@intel.com>
 <20210331144235.799dea32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210331144235.799dea32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.147.247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1c23f37-d64b-4b47-d65a-08d8f49a1557
x-ms-traffictypediagnostic: DM6PR11MB2570:
x-microsoft-antispam-prvs: <DM6PR11MB2570DB52FEED2BF8EA1D0B59CA7C9@DM6PR11MB2570.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MclpCMTfHX/41QqI9LapU9LQVbVGanihoJZdpopLzFM55/Z0OGimEO7KpVWfjYLlj7aM73GTyK9h5mJuYf8+2zB0fbaGAs1d+CvzuDtb0OV1bUKUpyG3tg3/h/XiiRAuHVpgugDl0xyaVNPQbR/YTxEa1eoLweVhINgOgYVR0PdajxMmSI6rOf5rMctnItDCaTpPsJJUrM5I+X8IYjmtdEMWhP7tt2zlUoDQ2RcJdL8Kv8WfXJ2Aj612KCmFFW7yOWEnD2bejSIwrbWgonn/ECJu1HEDCcQDOFlVwzPyAa3p0EjfCrnKqTicEElwBz0YoUTpW5DTAF9Nm79FPXBSxUViWtFF0um5O0KfgeTVejja2yO71AqBrPWwu1MvS24OvZJp2/8ZRuUvySrOOOhRyzxxjRKk1ghyI50SOaTXT6JHmHgzNPkWrpGaItmrs5BAGmexP2LpoG1EGYMiwPF+M+PXqZ/MCpGZQ+rIIo6UL4GtFz6PCqZcei+GctfSIkRSBMv29mePJdGlgKRW5gqlU+oFvxNcmH++S8b2WcSTysLC2TRm4hqGTk8bRR4ZkS5u5+fGsCOpTgJ/CcYJmoWfoxXmniGFgEXCOwc0jNNfBrISCpyMkuQUiiFDZXjOtMCM4FtJUpJYT4Fx/SpE7ZffMPC1UOISxYLgLQx2elFfa1g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(396003)(366004)(8936002)(38100700001)(66476007)(316002)(76116006)(6916009)(71200400001)(7696005)(5660300002)(8676002)(83380400001)(54906003)(478600001)(66556008)(2906002)(55016002)(86362001)(186003)(26005)(33656002)(66446008)(6506007)(66946007)(52536014)(64756008)(4326008)(7416002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KV0TBRe6qDFPMMWlMM5hlA78YMHdSKC1fQcxLk4ssXB1li1epzR31QYBckSc?=
 =?us-ascii?Q?eSn/myJjNDTJKvcSFUzffOceT/9zxzvMoTjrKoxd8NPe4G7kSaSdxIQufL9u?=
 =?us-ascii?Q?hif98dpKMluIyUhmQ91n7CFw4QxrHaCz1GR8de0+ZpkpkbsJknJ4gmCEImSE?=
 =?us-ascii?Q?C5b005q5K+MwdYRWNj+WQBEJTRP78CInrIcFZuGTfk2IBLFDC9jY/6so+Nml?=
 =?us-ascii?Q?1Ejno4mfjgy17dxON5IAa0yOaArYO9TT2+jrMdHiLKaDWPxnbEzbnANthMyU?=
 =?us-ascii?Q?IJ/jD1wvTf0pTUI3FWrX0dEDtCqpD3Hnnb69qx/fbtaDo5KgFUsZBbxB/vLS?=
 =?us-ascii?Q?Kzv0zVAvAlIYYDiQDIgWNMNjV95p8scW10223zuuOy1fyXK5E4npofRVJXyv?=
 =?us-ascii?Q?79lJv9+5M6g2XdDjTr6X8EHxGDB3OUw4WGUVMkRbGnp+SH/RleVj/oWLVqXe?=
 =?us-ascii?Q?x/hgjuif/wTffuPENY0F6OJbtNnRTunUkyBhWQXg460Vndz8dPlZmuiLjsAL?=
 =?us-ascii?Q?vCGden90W/v1vbvDDrILZmXfDs25czFY0rCHBFvYIN29j4DENbeYcoqh9CHJ?=
 =?us-ascii?Q?1gvjc1rbGpuJ3f3CUeYRq4+q6taV2Mf6aJr6mo697IUuK+2frav4ouL/26JZ?=
 =?us-ascii?Q?ETxH6D/2MVQj+UVBX2uyxGGqNDmVhtwVwEhK8L55/2ScgUTP/OGglTwSSwK+?=
 =?us-ascii?Q?hkxhJsxtQyE5ysoTdK9ELa6E0rEQ+JJGL098UdwJStWFM1vg2l8+P3Hmkr+f?=
 =?us-ascii?Q?Bxy/b5oWRpNU+Kfy6wA/KF1vR7ShE7R4nmWarlWZg+Y33fs2RxDJVO0esCg9?=
 =?us-ascii?Q?k+YOEp4gRek4KkyFSHHIvK8wX8oGw/mdmv4RS7d1COzrYP3JIBHlcZHp4U0c?=
 =?us-ascii?Q?v8GAeXGJgMoymWpyK/iz8t14hTd7Ap/mLUtIdNHvPVL0YZq4mXTYYsYnqb1H?=
 =?us-ascii?Q?EGYCF0fKzyIg3u/acDe79IOskaYSpPZud1mHplj+9QjTwLBUCeg8LsMgdcN+?=
 =?us-ascii?Q?fgHDwAI116LEYdCpoCUCEy168cUkptItIhPy0iQNuso05lEknXR4ujMQ1/yH?=
 =?us-ascii?Q?iOIfmmL3vtSOKAPQLNkVwFkIJqboeIatLmmd1GAwjt85yCj0IKOvHxSUXKbI?=
 =?us-ascii?Q?LsGYHa2+cFTJD5PoPceFz8lK5ibssLonc1S91o7zBP6y9mpRjWRRqbqpOf+K?=
 =?us-ascii?Q?wAliiA5SwrFC8Zyo+ynDszwglpYXxoZfIeuC4eZC9ZQ0jjhPxEvOF3XufpJf?=
 =?us-ascii?Q?5r1e+0RiX+cA9hSRIZsW6nxmBqooYjx38DIedKH+vwJ/TmDPK8eUX/fd0Prz?=
 =?us-ascii?Q?OIdPmStrmiBiF0CDw6TsJkbu?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c23f37-d64b-4b47-d65a-08d8f49a1557
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 23:09:49.2634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RaGVSFe7wmlyriKObsJ5Pwm0bXRv+0CEvwtjVBZ15wzVVyHuvYE5/9tKcp4d0qvEgdljQL/CM0JLzm1SZ17lv9tEq8nzdRz8AXRuNtnRkko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2570
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +static int stmmac_xdp_xmit_back(struct stmmac_priv *priv,
>> +				struct xdp_buff *xdp)
>> +{
>> +	struct xdp_frame *xdpf =3D xdp_convert_buff_to_frame(xdp);
>> +	int cpu =3D smp_processor_id();
>> +	struct netdev_queue *nq;
>> +	int queue;
>> +	int res;
>> +
>> +	if (unlikely(!xdpf))
>> +		return -EFAULT;
>
>Can you return -EFAULT here? looks like the function is otherwise
>returning positive STMMAC_XDP_* return codes/masks.

Good catch. Thanks. It should return STMMAC_XDP_CONSUMED.=20

>
>> +	queue =3D stmmac_xdp_get_tx_queue(priv, cpu);
>> +	nq =3D netdev_get_tx_queue(priv->dev, queue);
>> +
>> +	__netif_tx_lock(nq, cpu);
>> +	/* Avoids TX time-out as we are sharing with slow path */
>> +	nq->trans_start =3D jiffies;
>> +	res =3D stmmac_xdp_xmit_xdpf(priv, queue, xdpf);
>> +	if (res =3D=3D STMMAC_XDP_TX) {
>> +		stmmac_flush_tx_descriptors(priv, queue);
>> +		stmmac_tx_timer_arm(priv, queue);
>
>Would it make sense to arm the timer and flush descriptors at the end
>of the NAPI poll cycle? Instead of after every TX frame?
Agree. The Tx clean timer function can be scheduled once at the end of
the NAPI poll for better optimization.=20


>
>> +	}
>> +	__netif_tx_unlock(nq);
>> +
>> +	return res;
>> +}
>
>> @@ -4365,16 +4538,26 @@ static int stmmac_rx(struct stmmac_priv *priv,
>int limit, u32 queue)
>>  			xdp.data_hard_start =3D page_address(buf->page);
>>  			xdp_set_data_meta_invalid(&xdp);
>>  			xdp.frame_sz =3D buf_sz;
>> +			xdp.rxq =3D &rx_q->xdp_rxq;
>>
>> +			pre_len =3D xdp.data_end - xdp.data_hard_start -
>> +				  buf->page_offset;
>>  			skb =3D stmmac_xdp_run_prog(priv, &xdp);
>> +			/* Due xdp_adjust_tail: DMA sync for_device
>> +			 * cover max len CPU touch
>> +			 */
>> +			sync_len =3D xdp.data_end - xdp.data_hard_start -
>> +				   buf->page_offset;
>> +			sync_len =3D max(sync_len, pre_len);
>>
>>  			/* For Not XDP_PASS verdict */
>>  			if (IS_ERR(skb)) {
>>  				unsigned int xdp_res =3D -PTR_ERR(skb);
>>
>>  				if (xdp_res & STMMAC_XDP_CONSUMED) {
>> -					page_pool_recycle_direct(rx_q-
>>page_pool,
>> -								 buf->page);
>> +					page_pool_put_page(rx_q-
>>page_pool,
>> +
>virt_to_head_page(xdp.data),
>> +							   sync_len, true);
>
>IMHO the dma_sync_size logic is a little question, but it's not really
>related to your patch, others are already doing the same thing, so it's
>fine, I guess.
Ok. We may leave it as it is now until a better/cleaner solution is found.

=20
