Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3890353B18D
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiFBBky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiFBBkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:40:53 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3FE3BE
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 18:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654134052; x=1685670052;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vLZFNzKApkETAQH2u3N6gyhJyB5Y6HABdtGhjqBneQU=;
  b=lKU7UMFhfLj/UhI8iGpnqoiJ70JCu4zk7HfD4a4+XDANDqhNxvoQKX74
   Vn4SQRK3Amta/1e6RYNSpjgLaG/ow92UBTEioTfpwbV/T74TTiUtANBjs
   TVl3dG3tz6Pg0IARibKqqIJevo30mdwSGQsjLVrDo9/jvfz2lZBc0iqXW
   lKNoCCsCyI4xyEjPhVF5hA3rYvdRywr69XgchEw5HpCrQTJ7zG89Rxgaw
   YXohI3WILckNlu/t9ozp/RAsh/F8MoUkDhePuk0KpYVl59ralBvabioF1
   zfAl7Msxs/TD82fMKYUN5C/fz9sgOOANeftle4P/yya8IoQjsKs8Hc1/9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="263425437"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="263425437"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 18:40:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="577241190"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2022 18:40:51 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 1 Jun 2022 18:40:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 1 Jun 2022 18:40:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 1 Jun 2022 18:40:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRsuWv0oKJYmhVVE8S6R3144Y7b0ShjQdnjkEwTsqhPA4vAzniKzXFQqEpK/PXRLs72MeoTkEpL0t1LA6UBg/RdoiCqiJ1pW+oeAJmlUvGGvCb+j/4WFG/GgXn8aSpVsG+kZC1dFAi9R5B7D2PY7RBOj3AvqvUh/lIHoMwIfnAQeNVL4t1c041kgL3h4vPFMGDq40I3OI0ki7oUG1OoKT1XeQYJYWx0dxl09Y6o2hUl2PPZ40XJbVXBQSt9/F5HA1g4XtIMPvaS7qu5e4ahq06Nl9YQKRRE3iYAoz6edJVMTQ8H7dGltdF7vC69UFEw5QlPhlGFm4HvAe0ZszbRHMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLZFNzKApkETAQH2u3N6gyhJyB5Y6HABdtGhjqBneQU=;
 b=SzWzefh+hCzvuvxu5RIdQucStG9+dDQy2y3/Ifrans1jAlYxD473zX2rdovOs5YquZYu0RL7aOgnFVmUk6VWZS40GB6kiaManL2AaNhPeTJn9dZ+EymoDm13hjzfmkpO11uxgw9WtsEjj/WZGinG7tm0G8X+GvvTfvH7FK9yFaks2JnVgtBAkEP60WU+JIsWm2qBXSen8aiEI8KIAaTyhX010/DH0kKQ5m/fXqDyg8Z9qTYpJU+FRR+3lLc/3nNm/uRHvvrFaimvqXwFaL/Ntgl8kA+wlxD+zFcMGBEd5vLYToKO3MheMKAYDqKbGKEyCe8dw1mqMCulOKXKCFcRwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4041.namprd11.prod.outlook.com (2603:10b6:5:195::30)
 by DM5PR11MB2012.namprd11.prod.outlook.com (2603:10b6:3:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Thu, 2 Jun
 2022 01:40:49 +0000
Received: from DM6PR11MB4041.namprd11.prod.outlook.com
 ([fe80::e163:f492:d5be:58a3]) by DM6PR11MB4041.namprd11.prod.outlook.com
 ([fe80::e163:f492:d5be:58a3%4]) with mapi id 15.20.5293.019; Thu, 2 Jun 2022
 01:40:49 +0000
From:   "Tham, Mun Yew" <mun.yew.tham@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Joyce Ooi <joyce.ooi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: eth: altera: set rx and tx ring size before init_dma
 call
Thread-Topic: [PATCH] net: eth: altera: set rx and tx ring size before
 init_dma call
Thread-Index: AQHYdJm4sKF2KsWnIUSCVkC7By8xEK057C+AgAFn8BA=
Date:   Thu, 2 Jun 2022 01:40:49 +0000
Message-ID: <DM6PR11MB4041B9228DFE49FB48E6CDF4C2DE9@DM6PR11MB4041.namprd11.prod.outlook.com>
References: <20220531025117.13822-1-mun.yew.tham@intel.com>
 <20220531205011.4e17bc11@kernel.org>
In-Reply-To: <20220531205011.4e17bc11@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5de2358d-eeea-473d-8f14-08da4438ebcc
x-ms-traffictypediagnostic: DM5PR11MB2012:EE_
x-microsoft-antispam-prvs: <DM5PR11MB201286F053871F7FAC733C46C2DE9@DM5PR11MB2012.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Em/1pT7ThX3hJncz4dKulnTLBZ/YXYdehDkiMIKc/TBzGK6Mt41rEu7w3CduBVi5ptjUaHTaQkGQoZ3FFUg1ZMGsqrequsZcivoH7pMhDhQ+YCQyz0PK72MkCTeGRAj+9jNuWlMaytdvuxa0GgPlL/oapXpOF06h9TJtDYMH9rahvlDE6kUPpP3e4SPh2nTKFcaJDmF7W4z6GyRSrtHS2rnnbQV3H1kz+vALuW1/uN0YiAWjHQ/KJhSPQg+WVDycfKH5MEfSOjdOFGqOd1eyH4MUfz5PcjJGz89zi4eriqHJWMbt9Hp4aatNcGvwMg/OdZCakabnD0LZenjYJ6FwcqO69weFLMuoIIUg4jV4kII7cgTnS/iqfRPfvX00RlMBBuNm3jBoSxfWSffMTurkVtLUYpfg9PAqn8QfaAqNvq1rSiikW5+gwu3tTOyi9ntCqZm2ZGxGqKBHR+JgNXYgsfkfMfTYdPE7hE5sxmC5KmTjWrNcajibhwGqFjsB/wVosaOJ4KmNhLG4JF1uP5PoTpIHtYSEtahffBifq4Qd/Ye3bgA/r3N/v1avxVmrAN8De3AFrnx8KNfhk6MXsq3Q4loMDVHZ8AhfAlNgkKHPYZAuHLi4tOuRv5nFm87xAUJPau9bFjrfGVGUFC9L/JNpVdVq9MgZ7U0MJNDgfZmGgf7mJKl4N+nm7Woijjk7HRytWpwGvJCogvaWHw74Y0VuUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4041.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(5660300002)(64756008)(66446008)(66476007)(66556008)(4326008)(33656002)(316002)(76116006)(71200400001)(508600001)(8676002)(55016003)(186003)(86362001)(8936002)(52536014)(66946007)(26005)(9686003)(122000001)(38100700002)(82960400001)(4744005)(38070700005)(6506007)(7696005)(55236004)(54906003)(6916009)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FgG5pVX7AWNo56887jZsYKqVvPMfY6znP4IDKkRghIQeaPzZefHOvv8JO1Wv?=
 =?us-ascii?Q?LweFEuq9cy2BVeFtHSXilFhUGBTmc6f5ueEw6p285Md3+QoUporjdOGeTQbf?=
 =?us-ascii?Q?4u3my2i9UMLVx90x5BJ4MUf6EeHuthOL/wzz8UcELDyjRUB9LM1fU8kBAx8Q?=
 =?us-ascii?Q?lfcPG9SUcaDlupGVGf3vYdKaMooqDItA8DKv/yZok3Ip99X4yAfPYELqtJwO?=
 =?us-ascii?Q?T0piFM1XkqT9XMEowZ3t3S0hnb85OUrbGJe0yceHlSX3MB3iY1TX6Lb+MZJ9?=
 =?us-ascii?Q?38JBjvb8aGF6KcVgzTt5KuqqsoQjb5Jc/rDyW4OYMwlVp91OUj4CPhSakzPd?=
 =?us-ascii?Q?oSYz6F97lxCrDW+LnsH4jznShfGPLIky0U85SZkxW/tWvlaSWKgSeGJzlP7w?=
 =?us-ascii?Q?3YNTMxxCjxC7J5hPJFkFtyBYvsbl62BSFgypFtoxiXf9PVCO1QyMaF5Af0mU?=
 =?us-ascii?Q?kEn4cJQMr6amYE97hjlZY+9mFr8vviZC1u6Dkq9x24MjaQC6CjVizLJ/16tF?=
 =?us-ascii?Q?Py/G8dOnX0gqQnMgXl8MWdRL9qtNFhLxnK7H9h9R3zKMueiW033GjMd4gW6y?=
 =?us-ascii?Q?mED4pP7XPrrM0fKpSk8w3IZHCPI6e6Z6MJL865K7B3x3whbx0jHmIMeE4LQH?=
 =?us-ascii?Q?wB+8IvxDS1p+ac7tTwhNvL+kJXayIjwiHV7S53b9KABK/FRqN8L2ck8AJJEy?=
 =?us-ascii?Q?lK8DgNIm6zvKNsuamTD70AgM4H2OF2yWEggiLyR1jP2iGyh0YgcvLkrgSsYE?=
 =?us-ascii?Q?hANW+2uclevhb+ydsTegNed3F7GA/jSdM/hxQSdvJxSNwJLXA35upCmW2hde?=
 =?us-ascii?Q?S2fG0VGjAApTrWFV0MqlWEqEPM0rLny3VnDMNWbfswIUsEC5+WXXtLYRXswf?=
 =?us-ascii?Q?1eX6clRvq/CRJYioWuB243uAjWLDk2XYLTxgFoFQYxP+GsTB6AMYnsksuhOv?=
 =?us-ascii?Q?FVIG7/ENE/hyXaw2Amosg62jUzRJUQFQjKcbPosclRqjBPqrJWh6Yb1zwcco?=
 =?us-ascii?Q?IZI2LTQsrsrxV7EC2bR//Njk35UJ8qlTak0Z/OTSkmUtlY5tj4u95KWQImlz?=
 =?us-ascii?Q?edVADFDSf4b065JYJpCkhd13kpt09qm99zUPaKG8n8yI5q2J0ViEpOwZ2e64?=
 =?us-ascii?Q?TiOXa3+2xP6fvsb3KgJDzef6b/9+gjFyZiH0v0FdpDqRdOBHB4zP486Dz98f?=
 =?us-ascii?Q?WLPQ6b/G3cecumEZqicUUyHdSTwFI5dKyp/oj7Peo98vTblNKoRDbLg96yhE?=
 =?us-ascii?Q?yDMtGC67ZOezjkYg/3SjWI0yaxTMD0Ay3HA6FzG3GITEnJEgGG4R7CWTYu8f?=
 =?us-ascii?Q?I+LI54jkRPAZTgTZVtNcHyG84oCu+nDBNS/ByFvPX73MEZCn1LOt5K5YV1b9?=
 =?us-ascii?Q?pXxwW6n0StX5u9ObzDJcjf75XZKp23e6nBsJvN7Hi8cJWMbXa3qKug1IcjhF?=
 =?us-ascii?Q?zsP98ETL0wnDMkfypHb/qpdtsxZRM7wS9jJp0fTv18sZH+VPTRanMCx6tcgj?=
 =?us-ascii?Q?81KV5EhX3OZubwcVBq8lqw/nqw8IjySdbOtHAlqZIb5T3M3oZQKptFL6AQ0j?=
 =?us-ascii?Q?nsZmZei/oFWYyY8cjAkboYENW+n1NigLgNIZb9TnfWCTR7aT3WQNnN43F0ej?=
 =?us-ascii?Q?FaPOGJjZUssNsFddPTszR9OnUBAUx12ZljNjuQ2NDE2uie1gnJQuONcy9t4A?=
 =?us-ascii?Q?9Od0M43XnrIUO3ltysF8FIjHnB+FCeHK26n84jtTL6cGSBfgbKuVk1nA5hg8?=
 =?us-ascii?Q?qdDn3xvvbQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4041.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de2358d-eeea-473d-8f14-08da4438ebcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 01:40:49.0943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ccfu7g5aI/ZdWguxxEHVwRA3QBk91cNa2cfflHVxyAjvkZlw0QvuT4E+bRpZ9dp1AeqoQuikOS2wqPP58QvLVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2012
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

> On Tue, 31 May 2022 10:51:17 +0800 Tham, Mun Yew wrote:
> > It is more appropriate to set the rx and tx ring size before calling=20
> > the init function for the dma.

> Improve the commit message please, this tells us nothing.
> It's hardly a well know software design best practice to set some random =
thing before calling another random thing.
> AFAICT neither dma implementation upstream cares about
> priv->[tr]x_ring_size, do they?

> If you're doing this to prepare for adding another DMA engine, please pos=
t this patch together with the support being added.
Noted, will post this patch together. Thanks.
