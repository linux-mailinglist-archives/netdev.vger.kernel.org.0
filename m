Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3A46B06FB
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjCHMXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjCHMXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:23:25 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB613599;
        Wed,  8 Mar 2023 04:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678278176; x=1709814176;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/9R5P7fF5Bhv+BfuF0ZBBnAQZZDWu5ZWB7J6KAW9xr8=;
  b=dmcZXFzv2DO3/5Q2mg/sNlmZP6BMA6Sh98rd3OVZxPMXqxU7xad3ftGN
   pg43S9Y5D4oCl2FPfaCcSs4RC71BCm7ozo7BlUQoABq/Slgn/W1ebr2av
   kT4mQVbARSP39UG8HKFGWyQpy1gCVvZDd2L8KVp1rR+bo4cdexNUI93Cx
   5dhD3toXZejwU/YBuUPq8CB7PzGEpBYlZL6syyYmondA4mQT8QR4Jl5vG
   sq8/UZfHz+8osO0mXxRGdzLbgg+mZYH/IFq6Pev+jMaPL/ccok7LRNduX
   zE9BQ+yDqWHp9OOj1cj+495DufKQoIPV1bHjduP7ohROGKo9Jq83zgcvx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="333608919"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="333608919"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 04:22:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="765975578"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="765975578"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Mar 2023 04:22:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 04:22:16 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 04:22:16 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 04:22:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wzu3kUgS4GEn14mwvVC3VxC0uDYlJ970/Y8siZQcf+UMDcwm/ZY+ieKpx5xgtxms9O/w/d4Yy9qSXIIcataev/iBV7u6MfrbXh3C/IKdSOLxyJHzp4VdEtwUpJ3pb20MGYHv+2SqdJ0KH+wOqOQJi1C9OPAvvPXntR43R6ekYo4fhFZ9CXS7QbFdhWa0Z7wfAeqBOQ/tjy2ssq7jlt3+wiTHEc0MaSSw3JmhXhj6dgwlQ1qZ6j8Bow3X35UPAvhVBDJ0JMVHsA52Z7wHtW7acDkjx0nXVY369TPfLTaCvMmozgROAsqc6fqyjz3QDFGFIvWU1NWNPu3gEO4AR534wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRUKC+s5rPHH5R0G/v/4Sl/JYkXMiQFQcrwglQlyiPo=;
 b=N/9G/LknGcEM7/w3cxz+idCUJzpJJzZN3aLl9nm/3/f96xgfjoi5cMrfk1MRUx0VX1XzPLGqCqpyR/XCNF/95KFdzHbrHW2LyjHOFyEvfnE9wm32rqs+yhQ7d81RrrWB5D7YFNz+6y7sy7bpFpJvgXY/vdQ+dxyb7qrQjPMmv+J1Wn1HmUb7EnbuonF/SrJu1TIOVysdTbhEXG+Iqg+dPPs8sPAMTScnHAOCCba8fu7LqUb1Rnv6e5/S/2XMXxSXcON9z/O4iKgQ2z0qaEDoL4UQ/OENUYWhXnMcyjxLpxOM/AfqBjl5UGW1h2kmy3VJNAi+HvqZUjjE6s3XvylsKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY1PR11MB7984.namprd11.prod.outlook.com (2603:10b6:a03:531::11)
 by BL1PR11MB5480.namprd11.prod.outlook.com (2603:10b6:208:314::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 12:22:13 +0000
Received: from BY1PR11MB7984.namprd11.prod.outlook.com
 ([fe80::75a8:b854:a936:1d8a]) by BY1PR11MB7984.namprd11.prod.outlook.com
 ([fe80::75a8:b854:a936:1d8a%5]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 12:22:13 +0000
From:   "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Rout, ChandanX" <chandanx.rout@intel.com>
Subject: RE: [PATCH net-next 2/8] i40e: change Rx buffer size for legacy-rx to
 support XDP multi-buffer
Thread-Topic: [PATCH net-next 2/8] i40e: change Rx buffer size for legacy-rx
 to support XDP multi-buffer
Thread-Index: AQHZUG/989vq0szFhkqTpfePsHrtM67wJ6uAgACnZxA=
Date:   Wed, 8 Mar 2023 12:22:13 +0000
Message-ID: <BY1PR11MB79845230285E702988F8536290B49@BY1PR11MB7984.namprd11.prod.outlook.com>
References: <20230306210822.3381942-1-anthony.l.nguyen@intel.com>
        <20230306210822.3381942-3-anthony.l.nguyen@intel.com>
 <20230307181829.5dcec646@kernel.org>
In-Reply-To: <20230307181829.5dcec646@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR11MB7984:EE_|BL1PR11MB5480:EE_
x-ms-office365-filtering-correlation-id: 7faa7d25-e2d5-4e68-2ecd-08db1fcfbf5b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JkEURAvMgRspjpqNbXXoehgSvFOjnT85LDv8uDa9McGH7nwz7CCdytzI/CrtEqBkldDG8FsW+rOkH/jLva2NgyIj+fFTE2dCd/RyfrZwesRYTYNVoRldAMZK4doYE9Z9WqK3OFQErCgU+1BxLrRPlapvr2gincxmU4mzAdw0Cj+jZFBn+mzUmq+rVOQlm5x7DwGkXzqhovM8gdRni0P5U7OBv5SM1UmX5FiDfaNsZaqPoHQCxyLAjmLEtRk5mlOGwbI0p5g4vkX7arK05bOGxq8k7Twu4OV4rquC0go5ufPtwlpsRFkW4rO1uhvx8GQdlJT9vYXelC4zjaiJMa6uEmjCew7WklQ2ALNLL68SJEwb6m/2uBW5qLNk0Y737/0eCAeCTENNhw2QBV1PW92RlUX+yLhkUcS8FYtgatNahDUGUXbfna5ryBMeoRospL/JpyBf4ucET/bBaLU6+a2YJAAT+/bKDlKZ9FgmwJjRt4tW24h5iknx/KQgmEhpqFaaeaDOLXkQ749+meIYE16NOCDaXALgnFdfX9m3EqZeH8fXT/V177B7d8MT8eDgC8IjnlKMo/JLqvCoJCIgzyucw8sJZ/O2Ce7ozy8idrUO6AZb37cyh20wZXqcRL9XC1BOL4rH3lXddKzPjVVLhkH8V8HuFrsMZ7MSZ/pmm373mF4YkHJg0l3f2+HU3uXRxrjEEM0nP/8fWkZnd3tUbLQwYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR11MB7984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199018)(6506007)(107886003)(83380400001)(38070700005)(33656002)(122000001)(186003)(38100700002)(9686003)(86362001)(55016003)(26005)(41300700001)(82960400001)(66556008)(66946007)(66476007)(66446008)(8676002)(4326008)(64756008)(2906002)(76116006)(52536014)(4744005)(6636002)(7416002)(5660300002)(8936002)(7696005)(478600001)(71200400001)(110136005)(54906003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0tT/zQe2IPBasB3vGLtVzSL9rsh6MyhQh4Pu7m4cyjaWrFF42wKb5xVwew6N?=
 =?us-ascii?Q?JRYVGpm5ybUVFtgVOV7DpWvOP83v6p6kvHrvU+1lRDIE6L0b/d6b9+kezRS2?=
 =?us-ascii?Q?dACP0RmGBp0S3Hqc5p7vzUHuQ/f+DvnupvjxTCMoSffF0zFiPZPTLywd7InZ?=
 =?us-ascii?Q?ENFzOVqWgBN0Ir59SA2jKZOg+ZcLyDlm1jm4fhL9gZ+YBhycvbyctjo4IyPd?=
 =?us-ascii?Q?qrOJ7SAEe8P+8Rg39qFJ3ctd5TebRwBTZHoA735ysB6p7vPdKgQrX3CwX0C7?=
 =?us-ascii?Q?FshEYYMqYwArLpvKDwy2NVva7KAgupidIyUBxDBPbYfnlVThWXkLjqWaibHH?=
 =?us-ascii?Q?sMLZwNI53xMXhnJ34YaQPMi4aG48vNQk+/q/lNqP7jzZ3beOKRaujIr2q+pW?=
 =?us-ascii?Q?V08oU3MOXnShkuikQkknXux5CY8jbrT2QFFVEyMLA1rkmK8nAWnsh2xGJT+w?=
 =?us-ascii?Q?0i2I3CKPbVo6YK+8hFgUu0WyMa85YnNDB/fDlh+pDQ2I5uOzKBTMcuxPG7CU?=
 =?us-ascii?Q?YMy+LGblGBD0rS4tWFeaweOfH4Cy3MEAwiMCVSGxl//pmEBPoXO8ojsw2I8L?=
 =?us-ascii?Q?gVoueS9N9BSvMD8ENEPODGWd9PdUBsH1Q6OyuCuW1woecVE51vACK1xqRhpT?=
 =?us-ascii?Q?mO0a7dCtqCKmL5O1poYxvOxaTc2J3ArSRSIfnMOtvAfiv6o+pq5NNKniX2nP?=
 =?us-ascii?Q?5eGTKVh8hBqmmrZoJiT1audxf4WkIdeCVqxUoR54g+E7MLeY6TNxHRK8Mcc2?=
 =?us-ascii?Q?hug/RSe/QtwgaLE6nTSv2+tpVU4EWWkR3erpXD6hl8PTSmkyAy8EibXx38MM?=
 =?us-ascii?Q?SAafCEJJCpJh9vSvVjnV/0DYy1STKsEF70ctMEoLxTZL9End/EYHx3ZjWRli?=
 =?us-ascii?Q?6Pm7wzBA+CJ7MR1EDU7XBw/45fj+0dCR45+lNud+hyEYfiCDxU4LKP6teLms?=
 =?us-ascii?Q?wDHn3RxlbVSNlLsxNZHZibxEAEweVPXyqs0G5iNek9UBTtK2hSjuoxtZWe21?=
 =?us-ascii?Q?7ZIfqpV+lb+OFN1qyAuqei0tzBB0ZYmM/ldr91qB2Fjw49aKKBVtjB+ohHVj?=
 =?us-ascii?Q?MBVDBTJnRdILPj1lZmlZONlS6sJPcfRtOC/t5x7omWzgfin5EypzT0qlX/RW?=
 =?us-ascii?Q?5Ygq8C/XEOXDi25dWhquj5mXwxkT1l1CxwJ05K9OmgNma+X84gvkAOiE/O7u?=
 =?us-ascii?Q?dbQAfOiz75R/Dce1MTvaBxm7i170KT/nfZvP0l4uYn8/ru6f/kTMGCGZwGjv?=
 =?us-ascii?Q?4gHZhzdSNe5JJeyjxng0GavGsQUr0YA2542XaWDPlLRErkbnnL12hti6CuXf?=
 =?us-ascii?Q?uuZ9YDMFe8yCazuflxAE3cYrIRvaiWqYF+dRiogGwsxs+W+RRxPgu1UWcOUw?=
 =?us-ascii?Q?LMlqCe8CVpQG02YT7pp/H41ek/lP4FDPchVourqFNXv3NSeTiAP5/r79fKAK?=
 =?us-ascii?Q?6PiI8ABURfPI2vDTgESqKeYGIF3/JwzfQ3Jzt9M8RwfchUdje4KivS2c52Sf?=
 =?us-ascii?Q?Swyof4px8BK5j20VwBK4t5ld55RpamYvYVwBQ15+aYbTxd4PwdC+U6/JNP1l?=
 =?us-ascii?Q?ccjvkxJU2w5ko8nmKfVLgRZEFP7bN+QeRH/Kigam+HMFI88O7tWCGMZmvlkn?=
 =?us-ascii?Q?rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR11MB7984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7faa7d25-e2d5-4e68-2ecd-08db1fcfbf5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 12:22:13.1859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HeI4WiYJ7wFbpW/YAn3+FXXDyFT2+doJuSanZH5vSze+FtgiuxclaOa0fw5pMQTMf+6ZwWpHVXYO+tChiyWo+KvWOpye+4rCQcfUgo+TCkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5480
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

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [PATCH net-next 2/8] i40e: change Rx buffer size for legacy-=
rx to
> support XDP multi-buffer
>=20
> On Mon,  6 Mar 2023 13:08:16 -0800 Tony Nguyen wrote:
> > In the legacy-rx mode, driver can only configure up to 2k sized Rx buff=
ers
> > and with the current configuration of 2k sized Rx buffers there is no w=
ay
> > to do tailroom reservation for skb_shared_info. Hence size of Rx buffer=
s
> > is now lowered to 1664 (2k - sizeof(skb_shared_info)). Also, driver can
>=20
> skb_shared_info is not fixed size, the number of fragments can
> be changed in the future. What will happen to the driver and
> this assumption, then?
>=20

This is for the non-default path in legacy mode. If for some reason number =
of=20
fragments increase in future, we may have to think of other options like us=
ing
page pools.

> > only chain up to 5 Rx buffers and this means max MTU supported for
> > legacy-rx is now 8320.
