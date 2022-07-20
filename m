Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87ECB57C009
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 00:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiGTW0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 18:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiGTW0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 18:26:00 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E3655B6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 15:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658355958; x=1689891958;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cU3okGqeBu9+Di8bMZfmCQkhDgIt/kUxQCWTzhlYbFw=;
  b=jDD8FXXXbxJ3zw2tuQqH2G8YHHUO/C5qbsrLpky2s9nSge3SOUtDKSnP
   ANY19ZZPfJl6vOwVkq2ImHK4EvXt8HxnfCaTu3mW84ABiuuMg6V3bBDst
   cqHA1Q1iH7oieCzr+3ofc95W3qwH8JSSD76H1O+cFV8IpJyJlKQJOzqoJ
   ixqd4TaFKbs1sLJG7wrkcX86OdMa4FCd//pyEGpPciHNen99r9uhLetAQ
   /XjFxvYDvL2IVwEErGppkmOaCPxRS1UVXckWDdgmkk55WRCXTFGaFft+d
   /lbA2snebj8CjgIiQdGzTBam70ldDdHbctOurMahvoCE+y/pdB2DkzSMS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="286906327"
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="286906327"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 15:25:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="630937916"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 20 Jul 2022 15:25:57 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 20 Jul 2022 15:25:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 20 Jul 2022 15:25:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Jul 2022 15:25:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLVa228yvkKkTmMIa8Cb4lVcqstEpLXnXKs73kJcKWgdbfk3HORkJA9tX8gVbQiSGJdcDsQbcpp+zlvJbYLCaM3WAwc2c8pa7zeBc0LOHdZRNOiNe66OchLjjzQdicGfvTpFvN6gZPsSbCN56mSVIp+TKgYYD1D/5/KxRPOfqYz+nWqc+fBrc+n5ZzSIUUaj9TZ5CgiZJTwr92pyknLHZ/yXGKhSFYNSsRsk1zct+/Eb5y5esh3UjhQEqoUJSepvQa2dbKBYy7lmkC1s9r7FFRw6praDElNpuJIamwy5VQX+fjmQ1mM6ePiZm6bvhxRGmmHY9PbecjpoNzU2n0XOOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xPgM6XV80lsmfmJbqu4ZLOPk2nqJFSiPaEiKZ7ifRE=;
 b=EnvHLojlc9+H525YwsGLRm1PVnKF6l+NkUBCQCMOLHGQV/uh8stcKiwbTTtJ5gOjljx16CFpX3YdGwrwvQNcTFtMiN6Se1LMIFoW5VhwKhiF0oHIuTo9lTUUVfHcEfg3fjcH1l+8Aus+UTlT8C5TqT6aU9yXyCkBR2N1rcE4xs+Dk4JFHoq54/4rTHVOMGJDeqgS/r3VsDYXm2xe9ImTWXvGxG21u3aqDiARNAIX2X2CPaddDwiHx6MxMywmQrZNyCJK2mRrJZS3qV9Rs9CfVvCCpsUAuRIIu+HxHkh3q+odahOaO5OX/0JbsBqsgRqCOkzWxKvSjz5vmYi4tSMzMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by BN6PR1101MB2258.namprd11.prod.outlook.com (2603:10b6:405:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 20 Jul
 2022 22:25:54 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 22:25:54 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "snelson@pensando.io" <snelson@pensando.io>
Subject: RE: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Thread-Topic: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Thread-Index: AQHYnEtCfyuRAdli106siPlhlDJO9K2H1O5Q
Date:   Wed, 20 Jul 2022 22:25:54 +0000
Message-ID: <SA2PR11MB510087EB439262BA6DE1E62AD68E9@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-2-jiri@resnulli.us>
In-Reply-To: <20220720151234.3873008-2-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f38e7c9-fa26-4c61-1c63-08da6a9ecf8f
x-ms-traffictypediagnostic: BN6PR1101MB2258:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7hrhgRgcvwzPkFJM3DV4uAel3j+MnuSQEDOkP225Fna9J++fwfUmmXSHxb8xFTBi2YO/nDud3++cg8LFLqajXsBm4HYO707lv7Sm13YW0gCKTmx3FcgTdM7WIOLapC50+23baUwD+DV+8Trrgwrs0hzeDxY4iEBK6mddu8o/ktE2A0/ZRCjiee+taV4uIPy55HjLiGjbfd2MdRE1TRAWEP5LMZLpEUGQne0z+UuZaIU+uNfEXUCgcxafLEMq0cdpo7FmRQNkaNkke32wGgJC/QTCY+EA4d8k3DPV94sIsGNxjSHe9D4k7zSjRJhDH/vhbUxiDB7xgf/GOff7j3BE/RlSCdKQWVV74bARfuHyrKGyIxtrjhAIXuT4p/vFd9g11OXT3IjH30Jp3HMjZJ8IASFvCmgwGiSlQSJ1z1BGJgR/BDH1y/WK0Vc6JJV3kloze+kFvyPJvROD7JnCBKmMTtkjONNp4xk2Ikkwusz6w4Bb7elWa72vHodHqnEmE7Sfe/Up/g8TqlxYPqiD2CzPDzUatAxrL6Unjw7Ug77Yzkkif5Mty1sJYWPC4pfl7DPx5YFNHzHNzTd5TdAcvgNgPzRN9BFUybq12amqf4eeIDlytyDPQcKwqTX2evI4pvAf6VP8k+sieGTdgtknnnNS/OWoO054BH1nSV4/nsv05ysxwIPlqB4BCQ2q/3SjJ69BnqSLYiYf1p8GBiZsUlWhkbHC5rnF6FAEdbnuRo8g4Am+Hh8RN95u0E8dtgOmp8N9w7gWLpbpzOECYhutPnqFkHMWpKvejtogvWRQpXNIUps5HVnBvXRxv0Kn2nkltZ64
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(396003)(366004)(136003)(346002)(66946007)(41300700001)(8676002)(64756008)(76116006)(8936002)(66476007)(66446008)(52536014)(4326008)(82960400001)(33656002)(71200400001)(2906002)(478600001)(55016003)(316002)(5660300002)(122000001)(7416002)(66556008)(186003)(110136005)(6506007)(54906003)(30864003)(83380400001)(38100700002)(7696005)(38070700005)(53546011)(26005)(9686003)(86362001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pBG4lU/iuosMU9TNAckpkJ8uYWgQPTqPqGK8EKhww9VVAAE5v5P+QfougH7F?=
 =?us-ascii?Q?1HSoni5BR0WddXquF127GC0iWi5E4xym1VQNwtpd+n2Y0a0jH0PD2LMQDDG4?=
 =?us-ascii?Q?DgSUd9Jd6DZRu/SondmFCt94BlQ32AMl4m8pVp7lQepSYCOvh83O4uDIl6Sd?=
 =?us-ascii?Q?41wXIHY8k1iQWW5adbJIb178nf0GSH1MVjzi83WihNJ1doE5nVOko2bXjlpZ?=
 =?us-ascii?Q?rdKBYq24WmqiRS11fWwjOhqlhUH+Am5R4VScoabGoY6PRHlzIPYeWBnuA0f2?=
 =?us-ascii?Q?zwur5jao3L72VU3tBEZ9qifXBmsrCo2LyZHZBaY6y8BAYJdANBk/lrDsG3mC?=
 =?us-ascii?Q?8yZBzjNXeECbHNZm7Alszdorf6FqASaVE3fkFndHhG7EtzdVPE+8LCowiAvg?=
 =?us-ascii?Q?8HfvS8zcEzFfuSjCuD1gkeGw4mtFcjFpFjR0R6Q9EuCtSSkj2T5+P97yzaqt?=
 =?us-ascii?Q?oxRAT1npbFEfSh8dzHdABEQJ+gdW3H63w9gCHK+Ucs6+CjFzY+LTjwHdAhp0?=
 =?us-ascii?Q?oFiBFCHvNlRmUweWywvLdokq02ogduh3a5W4XT1vcP7Yri7k4y1wT4BGrtHE?=
 =?us-ascii?Q?aHslq0DEmguDNYCuQZxoS3susAWp7KfMfFysPK2BdaUXekTzzX+Y3a8K/smS?=
 =?us-ascii?Q?b5zWjXFlaU+AQGAFN7fDpp/8orl/6IHoeyhHpi7CTrXdZeaCmX9+Mou6WYGn?=
 =?us-ascii?Q?TBq4dyOcun/GR26DCBGHAi3DVPjcPCoPFIiknaw2pz+0k3UpdKMD/G1klY88?=
 =?us-ascii?Q?BdJfUCVTHjLvJuOIHPJXCJKy9l80ivAhhDUOqxoHWQ4QUTzn1otaKhBp/HVf?=
 =?us-ascii?Q?WN8IsgBX8AOeIXo9NcBYaZwqSa4f9pi9T2UJ4jQoIWoHAafFEVoKk4s/bdCd?=
 =?us-ascii?Q?ynSV7zQhtLqwkcnHBYXc1OqV2+JilxO4wxoFIpCoufKbmpN8BINRmJw9pxj+?=
 =?us-ascii?Q?cdZXZfSZaS+fi9NmHpDEdFlkwMC1nlnfTAZVwGF3aObPjmoio61VavG7JSSJ?=
 =?us-ascii?Q?vU9Lw4znEYzKhSkppj5xjB414Qa/zJMp3pppb/6HyxZxeSTSyHdBdHj57q39?=
 =?us-ascii?Q?sTv4/h0D1m8aUigzTaXxnOgh53Vu3t8ZC3LTS6EEmNoznd1YlcI+0LKp9j6Q?=
 =?us-ascii?Q?N/Pym3ft9PjW1qiZZf0k5CPACK9ngQLO1NZJrqJrJHdEQmPr155aBIqWi8lq?=
 =?us-ascii?Q?SSKM/BHB01uASvV7hj6K4w0tSrdBk3llU+dFLx1xXFJ762cTZ1q6YUXNI1MV?=
 =?us-ascii?Q?ftb9NqncPnt8MKQwTuHG6p0Hp3vnPpW2zofRWaIoI0FReXgWTsRx2huIranq?=
 =?us-ascii?Q?my45frzevQCDG9xJ1IOigWuKJT5zxWR/O9+qjcPgki/D+hCbQc6HIwN9V/lo?=
 =?us-ascii?Q?f9YbKMJ4s3UGnt3W58RIZQ5QFssNDjJqfQyaSMUY1wrvpe9CCIhJcYt6H3WV?=
 =?us-ascii?Q?X5OAubbW7y2p44TjF9OluaH5Rjh07MVKpbS5fjzcdehAlRFmybKD5BwTgs56?=
 =?us-ascii?Q?MkFB0YlEm30b9yauKe5kfuDr7ERxqFPe5+sb1LxrItNz+4wSKGMdpT3Qc9mE?=
 =?us-ascii?Q?a9nZihaWl1Xf5rJ2Rt8OQVriu79h12CvwPYk47wT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f38e7c9-fa26-4c61-1c63-08da6a9ecf8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 22:25:54.5674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uuVAXtnCQ38PWEmhte7b6d1zGm+NFiWVylo6vPUdSAm+Cm58+cQIw7T5x4LyA4kuYtP6j10f4myxopFZKxgZwhQyLJe6F8aLiahLc9rSPOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2258
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, July 20, 2022 8:12 AM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; kuba@kernel.org; idosch@nvidia.com;
> petrm@nvidia.com; pabeni@redhat.com; edumazet@google.com;
> mlxsw@nvidia.com; saeedm@nvidia.com; snelson@pensando.io
> Subject: [patch net-next v3 01/11] net: devlink: make sure that devlink_t=
ry_get()
> works with valid pointer during xarray iteration
>=20
> From: Jiri Pirko <jiri@nvidia.com>
>=20
> Remove dependency on devlink_mutex during devlinks xarray iteration.
>=20
> The reason is that devlink_register/unregister() functions taking
> devlink_mutex would deadlock during devlink reload operation of devlink
> instance which registers/unregisters nested devlink instances.
>=20
> The devlinks xarray consistency is ensured internally by xarray.
> There is a reference taken when working with devlink using
> devlink_try_get(). But there is no guarantee that devlink pointer
> picked during xarray iteration is not freed before devlink_try_get()
> is called.
>=20
> Make sure that devlink_try_get() works with valid pointer.
> Achieve it by:
> 1) Splitting devlink_put() so the completion is sent only
>    after grace period. Completion unblocks the devlink_unregister()
>    routine, which is followed-up by devlink_free()
> 2) Iterate the devlink xarray holding RCU read lock.
>=20
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>


This makes sense as long as its ok to drop the rcu_read_lock while in the b=
ody of the xa loops. That feels a bit odd to me...

> ---
> v2->v3:
> - s/enf/end/ in devlink_put() comment
> - added missing rcu_read_lock() call to info_get_dumpit()
> - extended patch description by motivation
> - removed an extra "by" from patch description
> v1->v2:
> - new patch (originally part of different patchset)
> ---
>  net/core/devlink.c | 114 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 96 insertions(+), 18 deletions(-)
>=20
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 98d79feeb3dc..6a3931a8e338 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -70,6 +70,7 @@ struct devlink {
>  	u8 reload_failed:1;
>  	refcount_t refcount;
>  	struct completion comp;
> +	struct rcu_head rcu;
>  	char priv[] __aligned(NETDEV_ALIGN);
>  };
>=20
> @@ -221,8 +222,6 @@ static DEFINE_XARRAY_FLAGS(devlinks,
> XA_FLAGS_ALLOC);
>  /* devlink_mutex
>   *
>   * An overall lock guarding every operation coming from userspace.
> - * It also guards devlink devices list and it is taken when
> - * driver registers/unregisters it.
>   */
>  static DEFINE_MUTEX(devlink_mutex);
>=20
> @@ -232,10 +231,21 @@ struct net *devlink_net(const struct devlink *devli=
nk)
>  }
>  EXPORT_SYMBOL_GPL(devlink_net);
>=20
> +static void __devlink_put_rcu(struct rcu_head *head)
> +{
> +	struct devlink *devlink =3D container_of(head, struct devlink, rcu);
> +
> +	complete(&devlink->comp);
> +}
> +
>  void devlink_put(struct devlink *devlink)
>  {
>  	if (refcount_dec_and_test(&devlink->refcount))
> -		complete(&devlink->comp);
> +		/* Make sure unregister operation that may await the completion
> +		 * is unblocked only after all users are after the end of
> +		 * RCU grace period.
> +		 */
> +		call_rcu(&devlink->rcu, __devlink_put_rcu);
>  }
>=20
>  struct devlink *__must_check devlink_try_get(struct devlink *devlink)
> @@ -295,6 +305,7 @@ static struct devlink *devlink_get_from_attrs(struct =
net
> *net,
>=20
>  	lockdep_assert_held(&devlink_mutex);
>=20
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (strcmp(devlink->dev->bus->name, busname) =3D=3D 0 &&
>  		    strcmp(dev_name(devlink->dev), devname) =3D=3D 0 &&
> @@ -306,6 +317,7 @@ static struct devlink *devlink_get_from_attrs(struct =
net
> *net,
>=20
>  	if (!found || !devlink_try_get(devlink))
>  		devlink =3D ERR_PTR(-ENODEV);
> +	rcu_read_unlock();
>=20
>  	return devlink;
>  }
> @@ -1329,9 +1341,11 @@ static int devlink_nl_cmd_rate_get_dumpit(struct
> sk_buff *msg,
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -1358,7 +1372,9 @@ static int devlink_nl_cmd_rate_get_dumpit(struct
> sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>  	if (err !=3D -EMSGSIZE)
> @@ -1432,29 +1448,32 @@ static int devlink_nl_cmd_get_dumpit(struct sk_bu=
ff
> *msg,
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20

Is it safe to rcu_read_unlock here while we're still in the middle of the a=
rray processing? What happens if something else updates the xarray? is the =
for_each_marked safe?

> -		if (!net_eq(devlink_net(devlink), sock_net(msg->sk))) {
> -			devlink_put(devlink);
> -			continue;
> -		}
> +		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
> +			goto retry;
>=20

Ahh retry is at the end of the loop, so we'll just skip this one and move t=
o the next one without needing to duplicate both devlink_put and rcu_read_l=
ock.. ok.

> -		if (idx < start) {
> -			idx++;
> -			devlink_put(devlink);
> -			continue;
> -		}
> +		if (idx < start)
> +			goto inc;
>=20
>  		err =3D devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
>  				      NETLINK_CB(cb->skb).portid,
>  				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
> -		devlink_put(devlink);
> -		if (err)
> +		if (err) {
> +			devlink_put(devlink);
>  			goto out;
> +		}
> +inc:
>  		idx++;
> +retry:
> +		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -1495,9 +1514,11 @@ static int devlink_nl_cmd_port_get_dumpit(struct
> sk_buff *msg,
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -1523,7 +1544,9 @@ static int devlink_nl_cmd_port_get_dumpit(struct
> sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -2177,9 +2200,11 @@ static int devlink_nl_cmd_linecard_get_dumpit(stru=
ct
> sk_buff *msg,
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -2208,7 +2233,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struc=
t
> sk_buff *msg,
>  		mutex_unlock(&devlink->linecards_lock);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -2449,9 +2476,11 @@ static int devlink_nl_cmd_sb_get_dumpit(struct
> sk_buff *msg,
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -2477,7 +2506,9 @@ static int devlink_nl_cmd_sb_get_dumpit(struct
> sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -2601,9 +2632,11 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struc=
t
> sk_buff *msg,
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
>  		    !devlink->ops->sb_pool_get)
> @@ -2626,7 +2659,9 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct
> sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -2822,9 +2857,11 @@ static int
> devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
>  		    !devlink->ops->sb_port_pool_get)
> @@ -2847,7 +2884,9 @@ static int
> devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -3071,9 +3110,11 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct
> sk_buff *msg,
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
>  		    !devlink->ops->sb_tc_pool_bind_get)
> @@ -3097,7 +3138,9 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct
> sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -5158,9 +5201,11 @@ static int devlink_nl_cmd_param_get_dumpit(struct
> sk_buff *msg,
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -5188,7 +5233,9 @@ static int devlink_nl_cmd_param_get_dumpit(struct
> sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -5393,9 +5440,11 @@ static int
> devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -5428,7 +5477,9 @@ static int
> devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -5977,9 +6028,11 @@ static int devlink_nl_cmd_region_get_dumpit(struct
> sk_buff *msg,
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -5990,7 +6043,9 @@ static int devlink_nl_cmd_region_get_dumpit(struct
> sk_buff *msg,
>  		devlink_put(devlink);
>  		if (err)
>  			goto out;
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>  	cb->args[0] =3D idx;
> @@ -6511,9 +6566,11 @@ static int devlink_nl_cmd_info_get_dumpit(struct
> sk_buff *msg,
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -6531,13 +6588,16 @@ static int devlink_nl_cmd_info_get_dumpit(struct
> sk_buff *msg,
>  			err =3D 0;
>  		else if (err) {
>  			devlink_put(devlink);
> +			rcu_read_lock();
>  			break;
>  		}
>  inc:
>  		idx++;
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  	mutex_unlock(&devlink_mutex);
>=20
>  	if (err !=3D -EMSGSIZE)
> @@ -7691,9 +7751,11 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct
> sk_buff *msg,
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry_rep;
> @@ -7719,11 +7781,13 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct
> sk_buff *msg,
>  		mutex_unlock(&devlink->reporters_lock);
>  retry_rep:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
>=20
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry_port;
> @@ -7754,7 +7818,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct
> sk_buff *msg,
>  		devl_unlock(devlink);
>  retry_port:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -8291,9 +8357,11 @@ static int devlink_nl_cmd_trap_get_dumpit(struct
> sk_buff *msg,
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -8319,7 +8387,9 @@ static int devlink_nl_cmd_trap_get_dumpit(struct
> sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -8518,9 +8588,11 @@ static int
> devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -8547,7 +8619,9 @@ static int
> devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -8832,9 +8906,11 @@ static int
> devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -8861,7 +8937,9 @@ static int
> devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
>  		devl_unlock(devlink);
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  out:
>  	mutex_unlock(&devlink_mutex);
>=20
> @@ -9589,10 +9667,8 @@ void devlink_register(struct devlink *devlink)
>  	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
>  	/* Make sure that we are in .probe() routine */
>=20
> -	mutex_lock(&devlink_mutex);
>  	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>  	devlink_notify_register(devlink);
> -	mutex_unlock(&devlink_mutex);
>  }
>  EXPORT_SYMBOL_GPL(devlink_register);
>=20
> @@ -9609,10 +9685,8 @@ void devlink_unregister(struct devlink *devlink)
>  	devlink_put(devlink);
>  	wait_for_completion(&devlink->comp);
>=20
> -	mutex_lock(&devlink_mutex);
>  	devlink_notify_unregister(devlink);
>  	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
> -	mutex_unlock(&devlink_mutex);
>  }
>  EXPORT_SYMBOL_GPL(devlink_unregister);
>=20
> @@ -12281,9 +12355,11 @@ static void __net_exit
> devlink_pernet_pre_exit(struct net *net)
>  	 * all devlink instances from this namespace into init_net.
>  	 */
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>=20
>  		if (!net_eq(devlink_net(devlink), net))
>  			goto retry;
> @@ -12297,7 +12373,9 @@ static void __net_exit devlink_pernet_pre_exit(st=
ruct
> net *net)
>  			pr_warn("Failed to reload devlink instance into
> init_net\n");
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  	mutex_unlock(&devlink_mutex);
>  }
>=20
> --
> 2.35.3

