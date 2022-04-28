Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F84513B38
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 20:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347203AbiD1SOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 14:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350748AbiD1SOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 14:14:09 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166E7B7C75
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 11:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651169454; x=1682705454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MMUYNbI+Cyhu1vsslCLDWmELqpnwyZkmPeH+xQquJmU=;
  b=Jg+52rjufEZ/SyrMDmdxB+ik+BsKKRr83qSfxyjNpXJL9Mmcj+ioqymZ
   qKNGYw+0snYu4BIfWnoMpzE0t0lzGMsW3c7m72PO6e0xvuaj3m1OIIESc
   SaFrUrbz7N4BfFRdoizQn2hW56U45ax2/XELltdk695HtkbtE58hzsQ5j
   ohVi/In53swcAjRFK8D2E/mnUs7r1Yb/0qeL8jr65q/3upl71JMQy33op
   Hp5hIypoJjqELYE3HoWuYaFdicRgQlirAz7clIHH8udpXLB0+YkvxSCbx
   aGPtsxeablDD+6AaeD3ckWZO3nfaLPY+CJ6eNn5vzRSjUPJ3UR5yxcJ56
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246291519"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="246291519"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 11:10:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="706163234"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 28 Apr 2022 11:10:53 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 11:10:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 28 Apr 2022 11:10:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 28 Apr 2022 11:10:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyjaIkWd8dCsp+YCj0PMxLTLM9V54zMwPAqWZZ1EvHe2WcXJEhHAT4LQpNazML2mt/0blV05Tesq09tqPNZn3eCQYiX/O7Vgd9KDT63o4ppVOqQV/hVOFx6toOrDujNCgOkOlIf0a5wyVY7UNIkNc/VDaLiWzPtEglCKRpGHPop8Q/5BCn+fvo4fO++ozJ9jj0W1caimEXsiQiow1agutbH/d2nWnaKlplFekGBqLI3GNN+NSIQJhByxsh28oK1Cn/e4oVbkoiHlkYjWJ6UYzuPhi7MZFnl/a97HO2m+J7NUUlmR+rDKRANTI1PIZ0r3ySgzIXl+tk/PAy6YmQqSew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgvZa/8TbY11dtY0uf7UvbU5jNkhdeaU7IP1cMX+QhE=;
 b=RdAPfLXYKc9LI4fxdJrep4Y7AJGTJNxkRuhU0eauulWW0DWHHhmLC11Ozz9EOGbEKo1ZX28HJn13C5bO9ct2cOzXEst/ZF5uRqzWx124kDsU9+j2dksDk9YXWfW9oZEBR4F6GB5QIn+zEeqWKltHdBz4UB97Z9Yq3sYVls3lSRUtUqjwR37/0muPdAT7aNNbLdP50BEbXvrmbU0nOfByG/lEVRt3C5ZVcjQW0UvOvrbIZFeH8rx9Omi4mms0JKvFVyyGJ/QjJeBOxOioNQTgaLZfW1gpvB+VbCqpjQQVHmOBzkZ7bd5ZKOeaXnaQelBhWDNQs9iJDXsi6XjOTaigjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5430.namprd11.prod.outlook.com (2603:10b6:208:31e::24)
 by MWHPR11MB2062.namprd11.prod.outlook.com (2603:10b6:300:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 18:10:49 +0000
Received: from BL1PR11MB5430.namprd11.prod.outlook.com
 ([fe80::49c5:bec3:a36:c4e5]) by BL1PR11MB5430.namprd11.prod.outlook.com
 ([fe80::49c5:bec3:a36:c4e5%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 18:10:49 +0000
From:   "Maloszewski, Michal" <michal.maloszewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: RE: [PATCH net 1/2] iavf: Fix error when changing ring parameters on
 ice PF
Thread-Topic: [PATCH net 1/2] iavf: Fix error when changing ring parameters on
 ice PF
Thread-Index: AQHYVNwqx8tU1ZUFuEyko1AvZMprh6z8jEYAgAkgk5A=
Date:   Thu, 28 Apr 2022 18:10:49 +0000
Message-ID: <BL1PR11MB5430A4AD0469C1C4BDCBB5C486FD9@BL1PR11MB5430.namprd11.prod.outlook.com>
References: <20220420172624.931237-1-anthony.l.nguyen@intel.com>
        <20220420172624.931237-2-anthony.l.nguyen@intel.com>
 <20220422154752.1fab6496@kernel.org>
In-Reply-To: <20220422154752.1fab6496@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.401.20
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f489857-159d-426a-ae70-08da29426cc8
x-ms-traffictypediagnostic: MWHPR11MB2062:EE_
x-microsoft-antispam-prvs: <MWHPR11MB2062A31D157A21452B635F7086FD9@MWHPR11MB2062.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wcI7fT5hHFIv3oNYR3DGZpIMiHaOMmlIEjw8G7Lx8WGOzyVEBD/UFzXqKH2/lyO2IaydCwQeXPlR4QMwMP2nq1BYVKsk5E70b0aSh2uon70IVsBJTm5r0HRBbbLj3I0R/nM9Vi/cG6su2WC1FWVpBCGr6nx9W2NJOV4Zip037+dIPYcRYgl5eEdKHWuTPAUMDT6VYZrE3eKG2uB9H3Kn2IZSXmFeCPUAw4Qco82kBBfaJ9fqMODb21kpS0AJzgcNVRyuTtC6PLVgWTdQW5Dy6B9AHOseU6/ispc38gFqMxZOXVDpXZrRDvUx6HX1Q/Lg0Cb7qgoSOoM5YxS9HZSfiHuANObj+cV+5JLKqvlKUt68ZfAjkNDM0HNjBEUaJE8M6TVWpD6cly4C4lGbRt5ATs2pP28BdxhQ+i5q7INRSV7H/0a3bUKkN3x08kVJMO4gpqp4baAtYazVeMUp4BYtG1GL4+VWigizlDDphzV16ikHFJJne9hxgJVOI6lTbP5irnHduT9XIRmoKCaN8LMoULFRB4+IFlKWmBv0z6fFynHdLhDxIXtICyhVAoHZwI3pCuT0Y5TEH5N0waIouoJ8KOSaYqqOEZtK/ky0Di52qOtnu8cfGdN3MaNF3tNvJiYrz/kTk9ltrzo06pcmQ3W1yb0tIxvJlAgsO9FM+WolmQ9Fk+HAZpMIsdaJSBeld7+RN9BWBuzVlE8mY7DJrm20Sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5430.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(82960400001)(38100700002)(38070700005)(122000001)(6506007)(7696005)(9686003)(53546011)(71200400001)(316002)(6636002)(26005)(110136005)(186003)(508600001)(54906003)(55016003)(52536014)(8936002)(5660300002)(2906002)(8676002)(4326008)(107886003)(66574015)(66946007)(66476007)(66556008)(66446008)(76116006)(33656002)(64756008)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?AXTiYa98+dFF5jvEipx17np2qxd09wOFDi2TGNzQu6FRwcq7KsTNgT35/p?=
 =?iso-8859-2?Q?hD5O6X974g9gJA2AaKdOs5oFFgR1drtkWoljeEBU7qrJK01TwXCioJp4e2?=
 =?iso-8859-2?Q?3aPP3URAaloxvDlondgLkS0Wf8YrBtw4BQOEBTLImx7Shajobj2RDLkRAC?=
 =?iso-8859-2?Q?LV7z5Zva6x5rAOxTL2AaAA5s9b5cER45E9HEc5/ioZJI7PfkhDl3sjJhrc?=
 =?iso-8859-2?Q?wpnoRIIEqTHDonn13Snu80LDdNljrO9b/uAokLLawnH4L10VOKfPWkzcqC?=
 =?iso-8859-2?Q?VSP2lNR3SIJx+T5NnMbd99VIIARkVilWMNiWowYdwIy5dc4AHNfzZaYFej?=
 =?iso-8859-2?Q?ywLyKymVE+r17r8Xubrj2sTVRaRaUmHXgR920swzpox0yfUDVWEMqgQG1P?=
 =?iso-8859-2?Q?D51EAYoewbp+mO8o9tqpz8tiSmlvn0now1adaeZ7+v7fDWDhyRbaTS1w0K?=
 =?iso-8859-2?Q?2PsdiYB3CjCS6Y+dFPD7AyRlgmsvfdkYBXWx9gNGiAaGfqRuqFtAGmjaJX?=
 =?iso-8859-2?Q?w12MAaeZ9fSlhDh+X+Bdhxyq8VM8PgDhLB3n6e2UnSNXyaj1Q+4tfco/vh?=
 =?iso-8859-2?Q?LuFL+fRgXYNwFYuwsfYNwp6Tw1nc8iBat1OZh9nE5Hf1Ay3zN5arvGtFO9?=
 =?iso-8859-2?Q?LOUqyPZ2asafLPRrEQOsk1qXXpWHcyD+0PDFLdVmWejQsTjKUL5uRdCiLg?=
 =?iso-8859-2?Q?ey4O5a6VvPixD2I4lWd5MfvyGHT77vHXbB/VybJFMgX/qlAUhQWbwUsDiw?=
 =?iso-8859-2?Q?ph81jWmrSymHr6xv/l0TclogIT0em8S1Y70eRUseYtLcx2ioohsqBv+0Ek?=
 =?iso-8859-2?Q?oEvqQBfR8Ew+vuhadi7dY5DlrMz9miqYXeLE/D3s/qtvk50cC8Ino76UJp?=
 =?iso-8859-2?Q?cwJ4OqYi858fX0NaTL031LC+TroVAYtA80tExz+p7S/gQvuBd+0f2oKOq0?=
 =?iso-8859-2?Q?6TzGaJpoQeZ011f8zWKfh4ygkuCBf4M08j4PQ04WD81zmrEpZhizvma+El?=
 =?iso-8859-2?Q?hYO+pfqqEfKnyJncscZcWYBEVWkW2dbvwb5e28XtwrB97NWtXjASbocCxZ?=
 =?iso-8859-2?Q?8zQEN2rr/YmMmBL5FNGLJ3/qhbBAQ6EHXcbEsPN3DKa3OrTNUkKyuF7yZ6?=
 =?iso-8859-2?Q?nk40iRXH8WuYmx9vzzaUX+UvIAF/60voaj48Mc+QmnKpi9N5jjEOcNpo4I?=
 =?iso-8859-2?Q?mOP5j7BL3nH3HlgtxpPTDvi1HKOaqYuHY+gkfSwZfNLKLc4lcGzJaXM/mH?=
 =?iso-8859-2?Q?B6JmC3Mv9JNx2tr3VBaCdVOrgQ0P88HlrFMO7iQyksdKBDYBtJiej0PWDN?=
 =?iso-8859-2?Q?jyAVDfePMwUTDiRPnflMdMwP6LCzEUBhYyGgpgDDnbG69wZOQwCaYcUXxJ?=
 =?iso-8859-2?Q?3XH6BJeNYN/1+Wtuc5bF6vXBJmfYB8GC45Zsxg/yfLIg1ks3hyDq9X4/mq?=
 =?iso-8859-2?Q?ShqR9YPfdfYaWhZ9ufMuT/pyWvWqstPe1BxSPjkZXgi8pCVzCgXJJWippY?=
 =?iso-8859-2?Q?nZHeGeo5SPg7uxIh4szxA8BiR25j4UPs8Zzxe8aHlmd+0Jc1Kw04LAhtqx?=
 =?iso-8859-2?Q?5dBH/7PQWygAM2JoXNldrETeqN0fCBkQIZDuPw35+Ko5Hov5w235vJYZuY?=
 =?iso-8859-2?Q?pocAZDSzaGusJEKl+NwCBc1tbvk4AoJXcS4B+FdKh1zlzHZ8R13Ng/KP6U?=
 =?iso-8859-2?Q?cZSWHLgS1gCY1npAKIPvCZZevzDDpPbGZ+NuT2AytQN8rliEBghhQIGI6v?=
 =?iso-8859-2?Q?pKvBVs0VGOju9p0Tw549Rwc62EgfnPMobd4H3NkexkVeavdQ6ldWSmrzKw?=
 =?iso-8859-2?Q?mj3qJ6W4YX1djUC8OfkPyRyJyQakZA0=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5430.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f489857-159d-426a-ae70-08da29426cc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 18:10:49.5393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KMx0S1Ird2uaieGklE9UghVcqHEr1VEjm/l2HQYOptoLP1mYAm9duJnIRhip4zcPqRXiqoPkyNrMRKFAmuSNROhpCotFYRCZ5is4GJsFO7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2062
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

>Can't we wait for the device to get into the right state?
>Throwing EAGAIN back to user space is not very friendly.

When we have state which is running, it does not mean that we have queues c=
onfigured on PF. =20
So in order to configure queues on PF, the IAVF_FLAG_QUEUES has to be disab=
led.     =20
I use here EAGAIN, because as long as we are not configured with queues, it=
 does not make any sense to trigger command and we are not sure when the co=
nfiguration of queues will end - so that is why EAGAIN is used.
=20
>nit: why add this check in the middle of input validation (i.e. checking t=
he ring params are supported)?

You are right here, I changed the order of 'if' statements.

Thanks,
Micha=B3 Ma=B3oszewski

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Saturday, April 23, 2022 12:48 AM
To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net; pabeni@redhat.com; Maloszewski, Michal <michal.mal=
oszewski@intel.com>; netdev@vger.kernel.org; sassmann@redhat.com; Sylwester=
 Dziedziuch <sylwesterx.dziedziuch@intel.com>; Jankowski, Konrad0 <konrad0.=
jankowski@intel.com>
Subject: Re: [PATCH net 1/2] iavf: Fix error when changing ring parameters =
on ice PF

On Wed, 20 Apr 2022 10:26:23 -0700 Tony Nguyen wrote:
> From: Michal Maloszewski <michal.maloszewski@intel.com>
>=20
> Reset is triggered when ring parameters are being changed through=20
> ethtool and queues are reconfigured for VF's VSI. If ring is changed=20
> again immediately, then the next reset could be executed before queues=20
> could be properly reinitialized on VF's VSI. It caused ice PF to mess=20
> up the VSI resource tree.
>=20
> Add a check in iavf_set_ringparam for adapter and VF's queue state. If=20
> VF is currently resetting or queues are disabled for the VF return=20
> with EAGAIN error.

Can't we wait for the device to get into the right state?
Throwing EAGAIN back to user space is not very friendly.

> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c=20
> b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> index 3bb56714beb0..08efbc50fbe9 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> @@ -631,6 +631,11 @@ static int iavf_set_ringparam(struct net_device *net=
dev,
>  	if ((ring->rx_mini_pending) || (ring->rx_jumbo_pending))
>  		return -EINVAL;
> =20
> +	if (adapter->state =3D=3D __IAVF_RESETTING ||
> +	    (adapter->state =3D=3D __IAVF_RUNNING &&
> +	     (adapter->flags & IAVF_FLAG_QUEUES_DISABLED)))
> +		return -EAGAIN;

nit: why add this check in the middle of input validation (i.e. checking th=
e ring params are supported)?

>  	if (ring->tx_pending > IAVF_MAX_TXD ||
>  	    ring->tx_pending < IAVF_MIN_TXD ||
>  	    ring->rx_pending > IAVF_MAX_RXD ||
