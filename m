Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D143C6AB59A
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 05:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCFEWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 23:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjCFEWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 23:22:17 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D2ACA22;
        Sun,  5 Mar 2023 20:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678076533; x=1709612533;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ty6tjr4nDviv3HBFjri3TKD3Nn3e0OS+9rq5Ehod7XE=;
  b=VYnrt4O1xw4G7yodGb9BRF2G4AkhRENa8vKZge/jGIM8jos+aM4UHWPj
   uDo8HnQWfoN0CYQfHwKTEszb2BjD5rUezhwJZFArVKUNUrVMPURN97Ymv
   fXvgYJa4vxIkoJ3/G7emSb25XUQBoHBMUFC5NDUk8Y0VZ3XonZYu3gu0W
   ipZb5ej8ICTX+/Bl7wCTLc6XvJi799wc2VR2AjwEuSPResZbUJXoJhkOo
   oBxlMgUd+wD5fb0zSHT3peUlPCUgZt0gflZmmrMgM/drfK0JjfOhRRmHt
   JXJe05bcN155mMx7oJhEgTC4tG3o9STMQENmrYABGLRIQPR+wVK6yng8v
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="319293473"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="319293473"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2023 20:22:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="708509638"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="708509638"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 05 Mar 2023 20:22:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 5 Mar 2023 20:22:12 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 5 Mar 2023 20:22:12 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 5 Mar 2023 20:22:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBoXC9UlASV4/ZDIayVDhI13VsbI3jlcoS5uWN0MFxpq7vtwSmuxFL974dfpzYndi5qDH25Y9CPeenL/sjeizXQ7TSIufnlut3mAXnymvWKFDY4i7kIji83IZMmacm9qt+KyVtFWwmgcbGeatKqg5kgtGJ/Qdx5IKMBM+nG1i4E+mbqaaYPSupTyryC2PjNKCoUR1c4jWyOnFBN1aCSMwITXPhuLLzZRkS/jBJY9ePV2CMX3k8aRkU1FtDjiF6kaggfwyHYDGUXSypbKOkdDPrfZpAsmKezsCDPq+ZDnejFlv5ymdvcal71rT8YsFedWrt0iSC8nDghjLLnzMwmBRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ty6tjr4nDviv3HBFjri3TKD3Nn3e0OS+9rq5Ehod7XE=;
 b=dgG4wQJL8ahSJjCR6h5BNrzzS6f4HYGzzLJaK1IwwT2GZzAmyzDbQBEab8nExh0vfSry1oyyciv0S1ioOx5VOyR+zSPLKeq/ASQ3EqOUfL9IbtKYfkzSGuI5qI9nJEpXFynAjx1NIok6tSrQC2Wa7GIiu/bfwcAmxcoFpTDYTRLfk0tFTD0UrMcqSSlIhOOgF4uSHMVMr2jRiYv7J3KWOk6CzUyTT0BQKqbCH+2JsYXBUs1AXXCn+MRmn9SBuZq1gyZJ7BLjfK72sz638fEiN9DFAH7Y1cfUzijc4ZT897F71aK9xRu9KbMeDXcBrqRpHuNJXA6yg1PMk4lyaruolw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by MN2PR11MB4613.namprd11.prod.outlook.com (2603:10b6:208:26d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 04:21:59 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444%7]) with mapi id 15.20.6156.026; Mon, 6 Mar 2023
 04:21:59 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next v6 4/8] i40e: Change size to
 truesize when using i40e_rx_buffer_flip()
Thread-Topic: [Intel-wired-lan] [PATCH intel-next v6 4/8] i40e: Change size to
 truesize when using i40e_rx_buffer_flip()
Thread-Index: AQHZQwnyJ2E2zfBQ2Ey5o6PhDAAcDq7tP5Yw
Date:   Mon, 6 Mar 2023 04:21:58 +0000
Message-ID: <MN2PR11MB4045CDA2EA630A7C85AE57D2EAB69@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230217191515.166819-1-tirthendu.sarkar@intel.com>
 <20230217191515.166819-5-tirthendu.sarkar@intel.com>
In-Reply-To: <20230217191515.166819-5-tirthendu.sarkar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|MN2PR11MB4613:EE_
x-ms-office365-filtering-correlation-id: b01a4a3b-539e-400e-1390-08db1dfa53a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wRxwdOvRakOkpPDSASheNirkiExUq/6GMftspOdJjwkElfSN+7Ig1/3svQJ3W63OjMTDkyskF04Od+TyzLNvSIi/Ttr+Chys29wMYPKUqGnoFdbZIY3cYihhU3/oEGbsJOFKMGEZkfCs2DB5E/1wGkLFPst3KqPYlXyyLTbcu0/xwKyxLRDhTjatFrl9+DDuQGiW2OtR5Z1JfAcCLycag3cISw1qIkzUlc6TCM8kT3SHEGsXwULST9a0bBxlHqCBojTXZFF9bZe37JsRc9I58i8JbKHNoYYmg/K8m7Qak2dxEQUJA8X4uhOFUuKrCi2S1vqWqs6/hH8TyBnuHCDaFINF1x7Y4VojwxrYfju1JD+eJL0Mf91wjCar2eZmoiM9trcMmibg1PmzgzAN0C4JBPXcpHdq1G1NPOwBher5tOr4c5Xs0sny1Qeb4mKpfsXnoUgdjyx8SDvN5MNd85QDB5S0Nk61Qta4h90PlG58DAvCbbsOI8s0O6S8h23w7G2Fu2VlDA94qLaYucSDI5byNgZCSocym0UTr5e+fJCbtVLXlLQ+w8KJBGOj7V6XbnON7TABug/YBjDzs2b4L8q7YUlgUWhVJ7GwCjzFrLLRK1MIsSeT28wIr5zDlwL8aBitID2VrkEJY3+Db4I1vmQR0Ikx6wwruFSgrV7TO9Kt+KCh5TOJrwnAgrpgxNFjw7ZZgZI38L4fkVFXZDUMAEn8SQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199018)(9686003)(186003)(82960400001)(122000001)(38100700002)(38070700005)(52536014)(8936002)(66556008)(66446008)(4326008)(8676002)(66946007)(41300700001)(66476007)(2906002)(5660300002)(76116006)(4744005)(71200400001)(7696005)(478600001)(107886003)(64756008)(6506007)(26005)(316002)(110136005)(54906003)(55016003)(86362001)(33656002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9tGItL1aFX8+dN4oOOhxxHaByaZi4jviCDvD0nj4EwqDNduOYgNUnox1MTyD?=
 =?us-ascii?Q?vrNlUfRZzQO+x7xsly3h4aMyT46V2CgVFcwcD/vFC+TX/HOjwHDQqb+aE389?=
 =?us-ascii?Q?CsSGH7QgG0+W68YnD3Vm/oFY8BJwAwMLhMtF/4eWy3yompSmrr6klp/Cnmvz?=
 =?us-ascii?Q?At2KMl/veEWueROLnKs8bARQOF9+J5SxrlOMqPi2GNE1EoBb+3qcvjZmBgiK?=
 =?us-ascii?Q?/C+8XPBJi38tF1YIJEO5Ngi7iCYvcAIrg7PAUZNILNShcJST/oNGj0Qqoq4r?=
 =?us-ascii?Q?HT0jCRZURQTAOzewo4Esz/xEpHRJIAIw48ox9VvCql9+bRK5rhqnpEyevpra?=
 =?us-ascii?Q?LB6Z4gzKIDEdQZc4F2HXDALvfm/03aYyzFpLyXUXrbLWoZ7eKjsTIcy0XG2k?=
 =?us-ascii?Q?44QVOBTTNU3bmh8TKvTzmHVm2hE2rWwbHevvYP9uoi322vonKH3j19nsXA6v?=
 =?us-ascii?Q?QCqVMdDAhHDWCesJ0uANYVUQYUMPJpETOz3yKHCti7rR5ME2Z0udOB8aIMyw?=
 =?us-ascii?Q?rcGpbjJlLif4AlYok0r7GqEMhgsZP0BrkmqBavJk38AwqF2Dbr4r6gWzE8q/?=
 =?us-ascii?Q?kDbBpEfqVeA9Z9EYubdD2RN3T7iCJn6Uqy7gxkxgL0OZTr5p7SQUr9YpiYct?=
 =?us-ascii?Q?3hvGak82vS4hIEzUw4uCD9DFi44/QB9XvlvIagPV/YPFr2J2Axcs5yvvdMcB?=
 =?us-ascii?Q?CZMJn5ai6vnLbI1SKoPkNn6pHuqxaiwLSM+DTNArv4mHEmfTN/nHl+kVmezO?=
 =?us-ascii?Q?xpi3hN53aoDEq1Um0Hlmism2t0zRyaYVMQHGtpqQP7hPvj2SKztJGAW3zHAf?=
 =?us-ascii?Q?odc1ICX8EAQ8JMui6zELn3bJckYeZVYMEIqDa3Yj7IgfhJDTun0FSlll7gFB?=
 =?us-ascii?Q?bvDkGZY0Pq9Wpg8pFKySfZUsFpxj9oEQLqRX5GWfHAnaCAeSn6X/4RQ3LRBe?=
 =?us-ascii?Q?tCXbH4So2ug7X649gKfuxb0J/N3P6k1liOQxaXnHiPYLp2et8ej3qeOVulWW?=
 =?us-ascii?Q?COkr3Ce3oQXehxKyZ2HcKAvC/ZqMryhZMpT2WLo6aAJ6a84Zef9SUTFfeH8U?=
 =?us-ascii?Q?l7C/IlqqGzNY1l9fPPZrTT4pDzqCUvT+mnH6ULQrh4b2N95EqLLE+YCEnWsj?=
 =?us-ascii?Q?+w2kU4SzRv0rHGTvU81gPMAqeNGW70W3OKoShU0QC6F4uCze67tYne6ncTpa?=
 =?us-ascii?Q?7mY3kSl+OTXUBB7nBCnS7I+QfoHLk6zkBeMqNVCAkopsnM/wV3lj7Mkqwwbm?=
 =?us-ascii?Q?JmDDAtoM/b3bBknKd1tzAosTjDuovM4eyAeNed5ZVZaMNSDlHX07Lxb0caWj?=
 =?us-ascii?Q?x3GVQieDYfLLHvps1D2qu/G+tENDm6quKzBJt08pob6rntUykwnFufhz6yql?=
 =?us-ascii?Q?EcgdFZc0FRJxGIsjCJa9i27hunNLPqnievsC/d2e7Rd4RjxU17L6i92A3Rgv?=
 =?us-ascii?Q?FVuTEoaXadEudkBe5KLqQ7msu3GMWXYuTJrTIitW8wttYZHmMVDlDaBVd6Gj?=
 =?us-ascii?Q?AtmisI0ANp2RbyKNTwfQEK55VFKSz45JlwBX19EOc3xTY6CBAErmSKnW+SIe?=
 =?us-ascii?Q?ZVnkDdoEU1CyYw7suIgxpu9i1X48FyyoZREDDXre?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b01a4a3b-539e-400e-1390-08db1dfa53a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 04:21:58.5051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLOfQCs13nMn0LL3MSmQqrvwkzLCwHXeIXulzltlfMJtCnap6jNb8fFPJHREzsqnkvxsRND4C+QbCRsYf1H0KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4613
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Sarkar, Tirthendu
>Sent: 18 February 2023 00:45
>To: intel-wired-lan@lists.osuosl.org
>Cc: Sarkar, Tirthendu <tirthendu.sarkar@intel.com>; netdev@vger.kernel.org=
;
>Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; bpf@vger.kernel.org; Karlsson, Magnus
><magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH intel-next v6 4/8] i40e: Change size to
>truesize when using i40e_rx_buffer_flip()
>
>Truesize is now passed directly to i40e_rx_buffer_flip() instead of size s=
o that
>it does not need to recalculate truesize from size using
>i40e_rx_frame_truesize() before adjusting page offset.
>
>With these change the function can now be used during skb building and
>adding frags. In later patches it will also be easier for adjusting page o=
ffsets for
>multi-buffers.
>
>Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_txrx.c | 54 ++++++++-------------
> 1 file changed, 19 insertions(+), 35 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
