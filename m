Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611CD590E8E
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 11:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbiHLJ7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 05:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbiHLJ7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 05:59:08 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606C0AA4DC;
        Fri, 12 Aug 2022 02:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660298345; x=1691834345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QO+Ivg19T0ryzf6rMimJWxTM4i8fWxrCy788xZqvSMg=;
  b=VXJ6AfNHUeT/UGfJdCpbAB4D1gIIeKzFZlrdAQbXHs3uulTWD1RER7Gr
   QrXiEC+dRssgx4GzjDGzBz76GQuvWeO2gB+2ofRNLl5sd+6K6Qc8JRCeH
   VAOartDuaRQRdZ+5Gbi2TMassdxB1/Kxqcz7uHqhb3zmmt92Aemtq3a5v
   caJlMbkerSkl3N8pN5tXlFPchxV1F449E9f8Vfmlnb+tB8eENOs23qKWH
   PbfslWqLD9YFVLcpdmbMQiBIybdKgDKmONv2gOxDFowK9D5PbHGDxob4S
   7B8iaxgFHK9RFBzcP291JRVZAAHWOnXbv6lFHf0uv9BsLqCZPvlPUKFpU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="278515954"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="278515954"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 02:59:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="582032745"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 12 Aug 2022 02:59:04 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 12 Aug 2022 02:59:04 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 12 Aug 2022 02:59:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 12 Aug 2022 02:59:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 12 Aug 2022 02:59:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPLe1/1Thk2B/9ZasrgjbCuEebgE8ve/murLbdxkbxz66kJfkAwTsHGrLl9gh2/gYu1Qyd5dRt6Am9DY6cjSbkGJE6ViOPDWkgAM1J/sWuMFK64FWMpBuZK+Z/dcQS877qXXlTzv1Ly0PbnG7SoSUawr3nBBGZnlrCmkOa82hV/ICHJNynin/UagGZvf5o2Rh2zUkGQ32VLYTfCjQSAhjFlD4ZOOCr01PhZZMF5IUfZnMt4zhISNYzJHOHGC93IM+QaC9gN6wjgzBELGu1sdRSjHU1xqZg12GyI2FDyufVuIn3Ax6+XoW01w3ErPXIJxYQCKdFjZ8UGxaLUfJ9BsrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2SkbkS3YlxIKltpU2XGZEhMkUDAGX3+2yUMXVUQQh8=;
 b=AxDaJT356yq3tpCU1aJeQK14sDSxSypixpG7ieaMKVdkCkv5YetyR3MGYLwd88/IBEkvXdN0/9gFsTcHxwlOYzglAPf7a+dnxdMzYfk3VXV4lde+nAtsFf7U359Jirno8lzUNX8kPlC5HkGYfUBhmlzrg5VZ9EPxhYG1WiyR52HZtQPl0NthxdzGzV3nsjNKBT7TJ9Sn5aLz/ZbZy+W7yxzRvFlnS4VR1BwHe4pXYNYB6/b/E4R3pnvBEbBCL5CbflJZwngYKyNwWX6HHPfiKcHQa6Y+pHqwz3vDBNVhMk7A3WujoF40yzAqMomXGAgnSwX3ZgHloW7UwdyKhj5a4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 CH0PR11MB5506.namprd11.prod.outlook.com (2603:10b6:610:d5::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.10; Fri, 12 Aug 2022 09:59:02 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::d45a:9b13:46a1:8a35]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::d45a:9b13:46a1:8a35%8]) with mapi id 15.20.5504.025; Fri, 12 Aug 2022
 09:59:01 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Stefan Assmann <sassmann@kpanic.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net] iavf: Fix deadlock in
 initialization
Thread-Topic: [Intel-wired-lan] [PATCH net] iavf: Fix deadlock in
 initialization
Thread-Index: AQHYq1CTzhNOgMwenkWTZUFv8x+wia2rDYhQ
Date:   Fri, 12 Aug 2022 09:59:01 +0000
Message-ID: <DM8PR11MB56218E84938884F39FA2BB69AB679@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220808175845.484968-1-ivecera@redhat.com>
In-Reply-To: <20220808175845.484968-1-ivecera@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65e5679e-9376-4afd-7be5-08da7c4948a1
x-ms-traffictypediagnostic: CH0PR11MB5506:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kTZVU2Fc7w3MZxF482DVY+cFKdykZWT4MrjPeQRLbPsHwdzLHSRXFCrP8ocbcALoAx3l5+sQNsL1c4GZN18dxvmjtR+YzlZbX0dpXuG4VLv3MG4YApW8pucmHuP0ms69XYKRL6yl9o+MvjB3MJDCs3kpE9Vbqf9sugS0eUieINZhhaUb6eZEy7Fy9BSRoF7/RMz3poOMfX7NhP962eHW6vtsYtn70n8pYUZ0HQp4Ic3uPiFfQtK671Du2BGR8EFKk8ICSKJHELT0RpwgP2pIbmX3ti0QQ7PQLvvtAgE1XohOLxGKjO5aHFJgAHEK8lKBTzChiwDNSBMdyC/Dc3I4liTmxo/IfZ6yZEAzHqOzImqglAC5+Z9VRux6gDqc2p6R4HMtJ189oVpsiJT878f2oZ4r9iwX1xk9C/QFO+KYKAJcDexilL5lhyJKOa229D8qo641+q1z+kENrKP8vj7Ddov+99bQoWpVaYIpGMbpxnVMvmXha3y/H0VmUHPVfL2I7XVOzD4tFxGz19JSaPJQAGlRh4A4u7IXsEMJSHVmj+k4NZZPqYovTeLLKEvnQeVE7Rutc/r5iACir2mFiVRqVmawLZp0cI7aQ6DUkQC6SfD5cgD62/cLJ6TdIHC+vf0G+5XRfj299HEZHEVu8luystVwy6qs6UJx69kjnwXJtfDZ+OzzKuaAyj+rleQOt0QAWagy2jy8nNK5sYtI6l7dbuT+VyKev3yEm6HE8cD1Kw7WCQNIJLzo/IXORozTATVWdion6sSDi3N1SAxolgIjNGaabLTOZD3oRv52w3RCfC4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(366004)(39860400002)(136003)(376002)(2906002)(33656002)(8936002)(5660300002)(52536014)(26005)(86362001)(55016003)(66476007)(38070700005)(122000001)(82960400001)(53546011)(186003)(9686003)(7696005)(41300700001)(6506007)(71200400001)(83380400001)(478600001)(316002)(64756008)(66556008)(8676002)(4326008)(38100700002)(76116006)(66446008)(54906003)(66946007)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y3VD3WQNOpAbvJtw8MdbSxcgFGrwF1dqa84NuojLd+Y86nDQ3Kt9sjoJCvhb?=
 =?us-ascii?Q?y9SDQ5FrFTFfAu3qU/12ojZuflntyyJDqGHVSaZzWvuF1SireXYQYndkQUHk?=
 =?us-ascii?Q?coZB1peI0oMJDJV0oxo2an8K6frtn1HVefZDMhAsCyeIgrpWptDw/Dga1CGO?=
 =?us-ascii?Q?jcCTVeMhIWB7VvIpiMdh88lwlBp9c9DKnO8p53Gc+x6k+YQVqsGX+bVLN6HU?=
 =?us-ascii?Q?fBHw7EDMiGRySs3EWXl6c1/ebawPzOfAVcyp18Joci8j0XRQbANemrazbBoD?=
 =?us-ascii?Q?s6Me7kQwOf7j0Jw1OcmOobUZ2g9DRUlJC1YTJ2/RldNmnJ4qAM/VA5yNZHn6?=
 =?us-ascii?Q?dWHuyEa/r34UJI3OD1NFfdFq1V1aYPnldGgissEjDGZpEqHt937mDNRx/1D1?=
 =?us-ascii?Q?5Dr7OEgblF+X4S7RFaWN1+qgIuwPlpdc7KgAFBWpl1ltH8HwLAAxlwZhc1zB?=
 =?us-ascii?Q?Ph9TR0k3nce4HyX9enWHvqT+jZT7UalM43Kvuu4ILqJB8SDYAWjcWomZgLia?=
 =?us-ascii?Q?02c7y9WWo3WTZJEnYx+lypURFnOvdGsk0wRqjRI2ZqkqwbdGai5H+PAehHAr?=
 =?us-ascii?Q?aXf9qxA33b1evKMkwAAjrkR1/Z4pksBeq4aTXEPpj903EvKG6+yxLk+Yp8eD?=
 =?us-ascii?Q?WszRTujn/3dfwuo/3VO2iGLpL/iKa8tcqQb+qSb3WUmJNUQmlXs1uZx90Ipn?=
 =?us-ascii?Q?o0RvEoIU05IkqFH5Wxuf0madh0ZoKkFxDi7ip6FoUc7PcbfovuCKVovU/8i8?=
 =?us-ascii?Q?29ThFm6JaLdKmTN3ti9Y0xRxvjMhpd8JTTMdXYVHI7bxU5m3H912sw0OYG8S?=
 =?us-ascii?Q?yIqouZjBb0gcqWVpSZLGBMrYe6c4vOq3FQ/PDdj2rIEvKv3HfoHRMeJOilF2?=
 =?us-ascii?Q?aPYgKEnN+A8qvy97WJCFgyhqCydOR2eZ4wK6S4h532bCsyQTcioxWcI7gbja?=
 =?us-ascii?Q?AaNBXQl0ZEP4pv5w1qdGo/qUNiAPyU8cPhsk1JwT922cvhBDeq/qHFengrtH?=
 =?us-ascii?Q?6bSXkcKVKzXE4yyAekKaN2ZwSnPCWRrnavJID+HN35Zf8ZaN1RLxbhHNZETQ?=
 =?us-ascii?Q?IN0Wn+Q490PdhasHNK5tTGwz3fJzPey1uxcpVcv++wacIilMp/3sf2nYVe7h?=
 =?us-ascii?Q?wyGxTgAK39gxYFkov40CYlgyN8eoqEwZuWaBdqmGYN9Cl0STj+xBvTIikSHE?=
 =?us-ascii?Q?15wUuClsetQ1bfYBY0qcJcw0HRfPaZTkC9gnuCQjfHiOuemCM2Z9VNyK2QFI?=
 =?us-ascii?Q?EL2UPtXf30rWrQt8I+7edRD+0mYqAt7ZGsllIaK5lNJTHYyYeQCsHiCV7xd+?=
 =?us-ascii?Q?LGSq5pFFK/chp7mBEzGThFEPJd5BHAYYmzr1JNbEimVLeJk2r0kP9QvRUTWw?=
 =?us-ascii?Q?CbjFGcZjKCVsyEPHRhS1+eNYqb9Gz1IKU9ZB6jG53Sssqey06TFtzqaHz/mp?=
 =?us-ascii?Q?HgEs9AWSK4Q1o7LXNO0xuyld15h8OLnSU+MXdXtA1do5l+mRM39Ju2gX9qAq?=
 =?us-ascii?Q?XopfF6+4NJbl9v3WWrdR0SX3sSeDG3fWbM05Qs8fJlS3lili8RnpOPHFdxaY?=
 =?us-ascii?Q?QYD5uHQ2dFlIApfTwjeiBjLoyjpiH6ZmBptzaYto5SnqqZ4XWCHUSdszQPZn?=
 =?us-ascii?Q?LA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e5679e-9376-4afd-7be5-08da7c4948a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2022 09:59:01.8877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /o1XsbbZgPSog9nrwfIRagsO+mtxyN6Sum+jL/GeF0W6Sj/hOIBefZpcjIOtz4Gr8KoflRHqMKfBYN4Wp//wfCO2G3DxoFO9zGjvD64CNDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5506
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Ivan Vecera
> Sent: Monday, August 8, 2022 7:59 PM
> To: netdev@vger.kernel.org
> Cc: moderated list:INTEL ETHERNET DRIVERS <intel-wired-
> lan@lists.osuosl.org>; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> open list <linux-kernel@vger.kernel.org>; Stefan Assmann
> <sassmann@kpanic.de>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S.
> Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net] iavf: Fix deadlock in initializati=
on
>=20
> Fix deadlock that occurs when iavf interface is a part of failover config=
uration.
>=20
> 1. Mutex crit_lock is taken at the beginning of iavf_watchdog_task() 2.
> Function iavf_init_config_adapter() is called when adapter
>    state is __IAVF_INIT_CONFIG_ADAPTER
> 3. iavf_init_config_adapter() calls register_netdevice() that emits
>    NETDEV_REGISTER event
> 4. Notifier function failover_event() then calls
>    net_failover_slave_register() that calls dev_open() 5. dev_open() call=
s
> iavf_open() that tries to take crit_lock in
>    end-less loop
>=20
> Stack trace:
> ...
> [  790.251876]  usleep_range_state+0x5b/0x80 [  790.252547]
> iavf_open+0x37/0x1d0 [iavf] [  790.253139]  __dev_open+0xcd/0x160 [
> 790.253699]  dev_open+0x47/0x90 [  790.254323]
> net_failover_slave_register+0x122/0x220 [net_failover] [  790.255213]
> failover_slave_register.part.7+0xd2/0x180 [failover] [  790.256050]
> failover_event+0x122/0x1ab [failover] [  790.256821]
> notifier_call_chain+0x47/0x70 [  790.257510]
> register_netdevice+0x20f/0x550 [  790.258263]
> iavf_watchdog_task+0x7c8/0xea0 [iavf] [  790.259009]
> process_one_work+0x1a7/0x360 [  790.259705]  worker_thread+0x30/0x390
>=20
> To fix the situation we should check the current adapter state after firs=
t
> unsuccessful mutex_trylock() and return with -EBUSY if it is
> __IAVF_INIT_CONFIG_ADAPTER.
>=20
> Fixes: 226d528512cf ("iavf: fix locking of critical sections")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 45d097a164ad..f9dcaadc7ea0 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -4085,8 +4085,17 @@ static int iavf_open(struct net_device *netdev)

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
