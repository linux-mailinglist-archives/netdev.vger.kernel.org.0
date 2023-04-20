Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D8A6E9D8D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjDTU7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjDTU73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:59:29 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0FA4220
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 13:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682024368; x=1713560368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hEwe4UBmPfGDApFuY0nB43oTEoqjfVFCyzi7peEa1rw=;
  b=SGYJDqOc2GF+WwW19st+7aFpnaoESQWZL4rqKJF8oWAI2jyO+ijAB8/N
   ayOqHVzvWDtMwnoMXPhqQGs+d+zeVWZSPhuH8sOLjwP40uWXRKtE4pUL8
   Okzo3IjmNUl6w1rKTNOe7+fQJO9v4dvLXMyxu0J/JxmI9SLi2/S4ZlNOL
   IhXicoVhh9FBizQMHKhG+gOOMS7r+cVG5T9vgnlf5AR1LvsZ+lfL/YKEi
   2uCYYb8k/i8IZ7ESojvEWx0pT9rguifQHyGJz6BYC7wEk7NsIWx29XW8B
   wqytbzfKcx30sFZKgfuLUTIlkINW1llgAQWtdKGyW+Te3IYnMxKUZ9Vor
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="347745762"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="347745762"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 13:59:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="816170947"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="816170947"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 20 Apr 2023 13:59:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 13:59:14 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmvnHGVNuSkqniDLVWbktrIQ9iUeGVGrrA0pcgw14T1kG2x4986ZaGjJcmN2PLqFFhMaNCCJpoeoaPBO/V2fSfTCdRqpsTKqrOPHNeCLxAh67choVuyRv4QiLGIC+kd/Pw4iu/PIG9XRgG71eI1MeLXAJbEPH6m1mYCLPT5bZj6YkIJ4OXuE8QUnw7wcivHjLzCmJD7XPHz/VTUL5hDY8aYvBNlhclzeZHbRiZzKBy30MWuMnR57NAbd/fL/8+iXR2AKHJpEzdYxAe9OjhHhNPKHw3VLHezs8StJpiGgEUPiKDa1RPp2WBNZOOtnt7p9m20awJMCQXtp5A3ebDgWMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLxgYYwpFeq7jXe2buCGMP9MHO7QWLDEFxS59SXdy7g=;
 b=ChcPHMQvEVON00+gQSVqLYxQKA00F5tYMYEUksMsIJtSQSl0jBnB1SPioFzi55v5HrCJeN69/N7hxXYLQh7kTgExaKit9h4++w6+Qf2Zpbtu4EYuDvTfdnT1h1SmzTruAF6MxdX/CnJxUrhEE9ksJXT/PiZkh2JnFgp1C3Qs6lR7fAZgGHCAQQjD+WF/8YGiMxgYs0VtBQHY8z0LI361zKhcpyiNWAFgEpHh7M8x9V7D8LDkA+PNMZwF1qZ2EUArhvjRSf1gHdxfdIT5RzwORpPC6A6D3Y3cwFmnf0YfYmX5HelxgkgzrPAA2HkXUBTCeB/+7QZDWcg6cHwmmwmf9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12)
 by MN2PR11MB4517.namprd11.prod.outlook.com (2603:10b6:208:24e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Thu, 20 Apr
 2023 20:59:12 +0000
Received: from CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::bf74:c4e3:c731:b8c7]) by CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::bf74:c4e3:c731:b8c7%6]) with mapi id 15.20.6319.020; Thu, 20 Apr 2023
 20:59:11 +0000
From:   "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 2/6] ice: increase the GNSS
 data polling interval to 20 ms
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 2/6] ice: increase the GNSS
 data polling interval to 20 ms
Thread-Index: AQHZbRexnPEHQSjlm0O020NtRv7YIq80uJPg
Date:   Thu, 20 Apr 2023 20:59:11 +0000
Message-ID: <CO1PR11MB502897D2BF6739A6AFF437F7A0639@CO1PR11MB5028.namprd11.prod.outlook.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-3-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-3-mschmidt@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5028:EE_|MN2PR11MB4517:EE_
x-ms-office365-filtering-correlation-id: b3be10db-2dc5-4718-4bde-08db41e217a6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qZRDWyYHmfd8S9hnZ6iOn5RWnc2MRnF3qenSIAbYeX0IT0ikqte7lzSc4pj/HCAVzo1Bn5P8x2JwQ3/uBwdZKaUTwHRpbNw607gR5sfHLPk45VFO75t1ebV1TDw+C7jANs9fkbZxc3cxL0ewrMYZ7/rT4J6ZrwQCvsAt7EKFWpowkeVJqK8zaNSpybygBdXJ2rPug4CKYFQTUjqNUU3UEVpr9KZeAXo/cB5EVQsUfu+WJG2BhcdYumaaMGSiZnKaQMGXDelvYQWO3qEG9W85sK+iUP6q0PhQUdi3/Adjv8ORkeV+nMksry5lXXMglvxsJkOshsbcdgh91v1ATQOqVLfIva+JzutSTtpTbwcyprd25F8jArse0O4Y0aFlY5oMKomQhZlk/J9+MPjToBSgNAN/fTEoRMpZWp6NYrsgptGAFI0g2lGJqPtrM/DIoS0zFMMpYLWu4BgITAHAUa1v4s+XKPwrRCLsIUcDdKz3S9ifCyzRb+aQi29kTJ9y/075dJsGYiOjqNwHtoPCvCBooOv5AMmg4ctIAHM25fIxOrVZkC5lOjJOPICH5IG7BsBUIfWsnqdNpgVrxxMcJE0xsPvjhBDSKR9hq+YrA9WsV9FRnbvaPzmkAwnMb+CVMxS6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5028.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199021)(38100700002)(8936002)(8676002)(54906003)(122000001)(41300700001)(82960400001)(5660300002)(52536014)(4326008)(316002)(66476007)(66556008)(66446008)(64756008)(76116006)(110136005)(83380400001)(66946007)(4744005)(2906002)(38070700005)(186003)(7696005)(55016003)(478600001)(71200400001)(33656002)(26005)(86362001)(53546011)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ueajXEIYEiGlejzVDoGcUdEYS6kbBP+9IbDPJfeTm28JvAr1XFDRbn99Jwwf?=
 =?us-ascii?Q?TeSYJ4kGtxHh8v25P7NoxwdG+hCzegF5yvLEdXKqwMEb3ZsHv2HWVZOhQf9n?=
 =?us-ascii?Q?/AlafHu/506ZGicvMhwHnaB34j1b8+P69UMtLiW/HQ3ZefH9U2m6TM5gXisK?=
 =?us-ascii?Q?kRoSQ6NWCZ0CjkYKPaTiw4x5p9rPtt0JDhG0BWySPKf8Ed9EjHR+zO+2kLqM?=
 =?us-ascii?Q?7TfODSYO+q7USJ0TfQJseq7MK9q8icE+5+QAefMror1gnH0V06knMLYBSJ28?=
 =?us-ascii?Q?nfj68CxgyEu6m8DJwWAxwKJxy+/zDEK3KWJ2D1S74X5ygKA4cY68iheSjdMn?=
 =?us-ascii?Q?WGHEbqF5kVCPac9PsGbtWqBVJKbmMlgVB90Yu2iImmapl7VRh1QJN4082tqq?=
 =?us-ascii?Q?IvwvaNCVXSzowqQHRjJ4TJdZ5OrKacJF7+wCA+yKP10jID1zLL/OYZLOhBUG?=
 =?us-ascii?Q?PqsCWhkmkxBA1AXWRM10W4DjFE8lfUsHJ3gHLR1aOCepgkigRdY8LKR2++TL?=
 =?us-ascii?Q?XTUr0LewLztWDUul78GwLHCWl1ps+JyMVq4Ab0jRzvJOTDcaIbOgGH8C6qfT?=
 =?us-ascii?Q?j/4xsa1w+BpUmnwz7VT6/3Gn6Ab6O88skR90KL17b4fk/xh2MoAj0jcMW2lR?=
 =?us-ascii?Q?JMOayziOVavfmvln0YEYGbHpk3xJVo4yY77y1G2a9L/REh+A2MpJsvYcu+XH?=
 =?us-ascii?Q?tyCIrOp8qbr2TuGShp0swqC8m8LkhC9DZCRUqdWDIwWKvoPXsyvju1myaxp8?=
 =?us-ascii?Q?RhNDKfNcRVB+dDa8U9NlH7N2RhgQ9oMEot+uAVoNGRkc0jp6yv4vRryDNpsW?=
 =?us-ascii?Q?byJCiSTPgSeLgcItPAja2BM793L/cjciOeWrxwWkle1nYJU0xYuRvOLnjV+X?=
 =?us-ascii?Q?wNd2PcuMSNUAzWp06CU7jTN5dqlJ4TPaXsC9Oi1W8N2r4DgmBwykbFWnm8e4?=
 =?us-ascii?Q?4hIt75WjfUASfax0tU1gzJAnXSJiwmEU1uN2hErubedRz5s8aSs1qSgu4Qwy?=
 =?us-ascii?Q?7nnIW8oHaPzPiWa5sGhz3OznWcWhFVFZIuQjEceVysRmCZd7OBbx/zvRmdFN?=
 =?us-ascii?Q?fIp/ly15LkoJYuUhhW0RK3fWL8EuKXVFTjP06jYBuHpA9IiBvHc1LLXlREm8?=
 =?us-ascii?Q?d90v7aAQhmbDhJ5+N6jDGoRbiINA5luNNhrDPYxCKKcu1eZwpTrK7vpuQ7fK?=
 =?us-ascii?Q?cjSbzWA3aMoECdJZtPX949NqSqFBXQ0o2DKOrQhw0ANlOl2dn0FEldeCCeoZ?=
 =?us-ascii?Q?kbWymk7WsHsH/Ou0KGwkIXgIkpKX3mVe41SGvFARYkF6JCS5S4kbV3C5InFv?=
 =?us-ascii?Q?sm/UteYiMV9dRrARpp4sx8BNkTXU5uk0/mBlwU+/l/7/+vAPLNbSlavTsaQy?=
 =?us-ascii?Q?XhWaZLuxyQvD7RiLoNQZAA/zEVpVFI8lr0rQ2mqEl03M0O0P/fft1yaqk/ng?=
 =?us-ascii?Q?eJZlB1o7gglz40JOsV2DRUFQCy5XRDYoWLiIRCN9PYDQkIsEz/UCa99Vkiw/?=
 =?us-ascii?Q?uOdoO60o4msyvZ0bSSzNfilv8hVSnYSINMEdx9XfFl36k+mlaEAWypboiKOp?=
 =?us-ascii?Q?VsEllgWdBdbJ43LgAHh2PJQ7jAOzXbhN+YqvcciurfgId+Ct1q6q3Z/2d3I2?=
 =?us-ascii?Q?ew=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5028.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3be10db-2dc5-4718-4bde-08db41e217a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 20:59:11.7964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XsioHQsX1gxdwB2RIjvyLsFvQLXf7iU9CL10ZbGfM5LA4xPEJ4ws/FLygrWhm0GqdJ98Snwx5bKAVGQAFHEox3gj8o4OiHLZ+AAyWD4t6o0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4517
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
ichal Schmidt
> Sent: Wednesday, April 12, 2023 1:19 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Andrew Lunn <andrew@lunn.ch>; netdev@vger.kernel.org; Brandeburg, Jes=
se <jesse.brandeburg@intel.com>; Kolacinski, Karol <karol.kolacinski@intel.=
com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Simon Horman <simon.h=
orman@corigine.com>
> Subject: [Intel-wired-lan] [PATCH net-next v2 2/6] ice: increase the GNSS=
 data polling interval to 20 ms
>
> Double the GNSS data polling interval from 10 ms to 20 ms.
> According to Karol Kolacinski from the Intel team, they have been plannin=
g to make this change.
>
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_gnss.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worke=
r at Intel)=20

