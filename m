Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A6C5FE7CA
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 05:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJNDzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 23:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiJNDzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 23:55:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567846AA1E
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 20:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665719716; x=1697255716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ClSQLP3KnaP3ivhSH0fr0O+AyNOSNd2u4T4bTsizR5w=;
  b=nO5/9Kx5QksCGdXApDib+OhmR/UZAL3whXX2bF9xVdQxmb8bUal1wC9T
   ndUjH2hXgTqz3NO7Ox7lVzxA+TiJOdZuwrGFU+YAkOBcq8c1aNDvuY7LC
   MQew/RNYOnzLELq1rQqPzgHahL3e1tGakwheftxVJwthON4AA6ulyW14S
   V3j640w0jfSLbLoqkIfrO5IhMMU9zAWnoxw58jiCVFG0f3P930Rkt/64z
   yhQ3EgumZGOc0Oux/FZVah9gUGrUTGtdBBGbvuSQsrHZ0hRIwH95/hmsJ
   zNFy+b6Y4CKkflbX2YZkUVMHVbSpJ95VDoxr830BMMwXZ1xevhgHViVIi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="306347164"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="306347164"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 20:55:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="605230350"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="605230350"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 13 Oct 2022 20:55:15 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 20:55:15 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 20:55:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 20:55:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 20:55:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnStBRU3rJDFLu7iA5q/tI/PmJ6pb2ZB5cIpLkRXH7HWOfaZSYXONmBKS/PrSLxNMqM7XlyzfxZQKm16AhsEyB7TEectwflpAQL/0tVKxeI+3ui8//f4H7EAI/7mNDbaFP2CQvl/SeW7NSYjd9dqjvD2D40/nY0+yvahI34tH+lsQh+OwDeiieC3TU0Ltc1sZee6YFapCd2JYLfe2C51MpjKxCfdJIk3DLM5RwdI5CYHshZFlDIsn9aGsV1I8ecRvex7sOhViX7fG0k1iTA/A2zOfrk7XesQ3zWQqNm5hvbi88jwwevM4UAqUsCqsY59/5Kd0u7gmyWAmz7n9DTABw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMYoNnVbKZj1lnM0SVgzuKpufbvxX2YAB0G8YQ1QXIY=;
 b=DkFsQXlUa16Ya8RIRaLQT9DH3uSCjRzEl21bVqw2bksDBS3r4DiHj8d2JC6Hlsyel7U+CwArRyYIJwyEmtlPqQKbMYcq2NRCtgSygLeT50JavWxWCDkX8ehUX04m35XlUnjEufaKUxCV9umdWheT1+LVHQC91puh757/B+px40g6v2a5DGH9PiUdjAhQ2RsKnlJCJtT48Ps8T7cIzfwaeE3717Lxm9WjM7NN7t2tbrZGlp2dz6ZBXwTUPX2IhMLuQi7Uv0NamLHOSUeykms+zuxus37yi3osQtqN8pymEgmPhl+qvkQoouqkiV5qj1wpb8K+TSfQeMzTxuCf+AaO+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by IA1PR11MB6419.namprd11.prod.outlook.com (2603:10b6:208:3a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Fri, 14 Oct
 2022 03:55:12 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d715:691b:4bde:7ead]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d715:691b:4bde:7ead%6]) with mapi id 15.20.5709.022; Fri, 14 Oct 2022
 03:55:12 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Joe Damato <jdamato@fastly.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [next-queue v4 3/4] i40e: Record number of RXes
 cleaned during NAPI
Thread-Topic: [Intel-wired-lan] [next-queue v4 3/4] i40e: Record number of
 RXes cleaned during NAPI
Thread-Index: AQHY2pVw2QsPz5Q/o0Szb9gpc3qoSa4NTD6A
Date:   Fri, 14 Oct 2022 03:55:12 +0000
Message-ID: <BYAPR11MB33672A7992C552CEB09B00F4FC249@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <1665178723-52902-1-git-send-email-jdamato@fastly.com>
 <1665178723-52902-4-git-send-email-jdamato@fastly.com>
In-Reply-To: <1665178723-52902-4-git-send-email-jdamato@fastly.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|IA1PR11MB6419:EE_
x-ms-office365-filtering-correlation-id: da6dd9dd-4566-4978-b844-08daad97e52f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eD3imP0VhRp9gGyM4UsWLeNSbSMd8SVD8yfCCiszrj90EsVkcYb5xaq1VwnWxp/ZUISi0u0IAjWLBMBLVND5LIxElEchLPCSah8NoeDJHwTvwook3Exni7q35YdcZ+XboD9jNgM1CjkTwetVxjLpb4a+iSMGWtqztvNjZLlY+VkrKpgj2zZagY+7eDlDDe/dQbnUlLirP8nHdp0GjCGAp8X55lqxe8srVQnuLR0pABDii1+W48xamPPJJ7fwIVVC+ks3CEu5zFNk+XXhIopBQG1nku1qAU1qCg9aQIDg7cCu3OVdHs9B+wBcm37RbZY7y+aUSbcLb6ykElrgm1C7OeaBtzKOu2lEc3kvRbQ8xxkBASzbHhkQ14Gelj3d2Vk5+jPdkmPu2dZ9yR87JRe7dl9cn5YBJAyuaaV+Y3jtReKyp9hfLBQ9u4wmU7QAVJ8LBzWlhXLgblBArpcNtBMGyGO9JGZqVBw/PZeBcwwo/ELfJJnWF77tlWc/lg5smnRzK1mJ4Mw9orXVgHB7y9SctlENJ8PNYdB0ujO3NafljdDi+8mz8aoNFZqEhx7/VzLsVFwLoFa99jwvepS5GJTHbm/YuaPcjq1Sdwy32cu+Gp065X8YELWnLDvALIzJN7otvhgJRYmLMg4wUwDW0axelAGfauU3WYsDdhAb3Qrw5Twm7a1/HtUh/9gRnA3ZuiT6Tp3kdaaeLrtF5wdnFInQXS9UoOy5nkf3xmHZAtGK99xFuxkZ/Gjnx/MQgXEQ89urMFqCxYlI4EAGbO2me6kfjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199015)(66556008)(66476007)(86362001)(55016003)(4744005)(7696005)(54906003)(478600001)(110136005)(71200400001)(5660300002)(41300700001)(52536014)(4326008)(6506007)(33656002)(2906002)(38100700002)(26005)(186003)(316002)(122000001)(53546011)(8936002)(82960400001)(64756008)(38070700005)(83380400001)(8676002)(55236004)(9686003)(66446008)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1UQypEQOrAX6PYl5czsj4KI6sJQmIt+7JbM63rhtV99LT2Pws8OhPggF3BYj?=
 =?us-ascii?Q?ZBd1A3ggV4NrfxbQ0AEATTthJSZ0OBNwl0f7bqxJhjVzdJeoiFY8WFP7PvB6?=
 =?us-ascii?Q?2hHVacZNrJUzlxDCrBeSglqx4OMuJUEts1GfZMNMoipQU/aGVj8emgCCJQlg?=
 =?us-ascii?Q?dcGhsROdZYo63WaU12Ep+I34MEll009dbo9Z7LqkWMjw0y8g5xYho4UTO92V?=
 =?us-ascii?Q?7/Gphozqa/oMAWVX4h3hGjzcUGSC90t7CSCrL6PYNrKWs1L52xpp8LAbYta2?=
 =?us-ascii?Q?lY5yyIJzF8r/c41CdOsZ7ktRdBRCLIvJvfjht0Vy6VoeueJKRi4yJaOnU3yh?=
 =?us-ascii?Q?5lVaCp+2SAt6si5CM0CrAjNPvDbHt83sUTL7U7lYbWm9TcMK/jpe4GHJ8Uqb?=
 =?us-ascii?Q?l6sSzprVLAIM7hZTKxgfv7vF0eus3aL2z3PNjH+Mpftf6qk6VVGE/GE5+g50?=
 =?us-ascii?Q?qHvjV8cSupB/QmJj3XgKqLbnccK0cJBuFOIMimGI+LFiwunC4nbap6lXhf8v?=
 =?us-ascii?Q?eYblZnAYiLv5/d0yS+BfNtIM+QIO36xXmosyqLIePfJaynHj2Qwit8y3Fdiy?=
 =?us-ascii?Q?HELVHHBBfsSy1xOBs0Lyjwkp8pAlXjK8kLQC8t4sbuPoGgIbV1XOwgFdc5mk?=
 =?us-ascii?Q?gyj87o9cg06nq8SZ3cq4n0eIqCbi9zSYBgIg28A98N7CeHq5WnExcv8gP3QJ?=
 =?us-ascii?Q?OAZQqQPbBtNrnxMzUwF2HyGR2B2P0om52y6EnJZvDiQ1lObcBdffoKj5bEjU?=
 =?us-ascii?Q?akOPK0u0y9EPCjDwl/eZDA/KHOKNjQNApR078i8kJhhXczIyIIK3+Tec7kSJ?=
 =?us-ascii?Q?iTmSxtvENH1BXB/uWuIGG0euOPKdl31bATzftCo7Ma6g2iB1SYyyuNFfNCWM?=
 =?us-ascii?Q?XiXsdj1zjYhQHk4QNRbO3aaNDBs5hfc0JlRexEBHi0pbNMlFhfzRn3TZbs2C?=
 =?us-ascii?Q?OG8DhWb0RM42VZM7794Q16o4zjzll6yaXiPsgWXezKMB++Yc6sM+/5+bxt8U?=
 =?us-ascii?Q?2rdOtQlAfTLi+NNaajYyOMRBNkyi4nMWHj3tCDycf0s8YeXgoCUj9Hn7/iKK?=
 =?us-ascii?Q?NVmoX0fWhJqVRTU4rkrTK7B8cGKCq5PJsyOjUgyrms6bqEkcoL4tpAZMvv0X?=
 =?us-ascii?Q?J0mdphVr8Sl6CxFWIufxzuRrd2qkMTXU8P1nfuiYd59J4XrJMRUL8Oi/OH5s?=
 =?us-ascii?Q?JFBZpSKzhJSZUYbrlsGWdVnVBxlZidfTU+gHCxBE57E950XHtwwn5CQThktc?=
 =?us-ascii?Q?SH1aRE7sx0z+i9HuQGzzctdFyWoPk7S7j6PsBdw1/e1BxUuyS87Zit08ilj9?=
 =?us-ascii?Q?ecuEg/OYxM+zDmiJzU3lAefAdw5oDGR7quHLW7k1d8T2cY5M0cNNIQu6roGD?=
 =?us-ascii?Q?dqhs2MwrtjzfRO3X+x84+C/xmlT7ewM9CBc4Raj1Lcwj4HkHmaCS05vGejYm?=
 =?us-ascii?Q?SVp40mGlV2raMvyoPB2UD8VnjfYDPJRMlgfGnV0DtniuIlvQpFucgWuZl72c?=
 =?us-ascii?Q?AiIjzbkeE9VlKRx/O0hSJj1fTdIOi6M6zckvR1P2M5D7GsgrD8zENxXYRYKK?=
 =?us-ascii?Q?gATAbmVXpgtjD9PL6FocAyoNgxYNzkUUhm0+f0FO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da6dd9dd-4566-4978-b844-08daad97e52f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 03:55:12.2654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eTvRmjCrwtvkYGYE8HBc7nsM+hO2Q7kEfyUF7wgSZZ5sbyQCiUrlMkcSnCW2LjhkAJMBvPzhoXiHh98LIzabCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6419
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Joe Damato
> Sent: Saturday, October 8, 2022 3:09 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Joe Damato <jdamato@fastly.com>;
> kuba@kernel.org; davem@davemloft.net
> Subject: [Intel-wired-lan] [next-queue v4 3/4] i40e: Record number of RXe=
s
> cleaned during NAPI
>=20
> Adjust i40e_clean_rx_irq to accept an out parameter which records the
> number of RX packets cleaned.
>=20
> No XDP related code is modified and care has been taken to avoid changing
> control flow.
>=20
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
