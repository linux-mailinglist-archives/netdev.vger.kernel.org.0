Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EF51EA5D3
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 16:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgFAO2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 10:28:50 -0400
Received: from mail-eopbgr40040.outbound.protection.outlook.com ([40.107.4.40]:30670
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727866AbgFAO2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 10:28:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfEOjwPWhMOJLQfTH9twZdxK4jmxJH1NPLBvekB/HfpOR4rQYyHTbqyoyDbpoJvX11ihzeOe9UP1KR9bYqMMcnjIyP3PtmrZaDIj249JWAhL1UQfth8fwfZeltHDyaqKTXwHKVT1m+UTajwicDCVKdFnAeL9K+Bufi89ct4ho39ikHnuDJ40JfhhykqybIcRUrRAWLZupDygF+u5agMeiPMEvJ5eC3PuS44ABxAo09qI8hTSv0WWTMs+KC2n6HiWIoRSnhMo3CHPHj8zLAb1HDhiz0dg7gyvo4cJnMbkkli4NMmJrLRzl/aGzqo8EgWakyG5R2VjsJdjh/QWZGHuRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnxLJs1CSFChl9uZhst9BYasFuWTh/SAXRcw206g9ok=;
 b=nn+8zym0pBfkPDQlU6BTcYyP0rEq7A+pOmvW0WXpJQ2D/Rf2hvKtXbKN9fqkXgVwKbq2FoJWLgF6F6tX2eKLknOesuiyvSY8D3HKIWQj5i1pqQKy58+KGGZiACSzZ4DpXYwnyTCtUuBGbRmtrjdak81JzmgmY7UXeVun9UqHsNEmGMO0uJ0OQNwBOpuG/CSIEApSsXvX7dR3ETXqmzBDA7KzwjZa5y0tSXql4KBOgo36A0YFIF+bVBhIc0jN9UdvMRgLqJIriDBMWRR4RkistTCzhPP1woP3h34VutKhbB+9L8vzz598o4NqJjpS1P0swPW8+MjgFBfFX7lBP13s1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnxLJs1CSFChl9uZhst9BYasFuWTh/SAXRcw206g9ok=;
 b=akpz3jx2aPLTUYOPnFh+mg/yItDS4AE7eweHLUsxNFXoVUHI6DqYC8H4R+5z5UdviuTXesuc6PAftllyuNrPeQboljp8ElyIj2qQFNf0kPbAhA85eRUpuSmOumPkqOgKau1QYOVfA3aqwM5m28tjUyxL5hfHMD5Wk/rvgIQRPDI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6670.eurprd05.prod.outlook.com (2603:10a6:800:141::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Mon, 1 Jun
 2020 14:28:44 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e%7]) with mapi id 15.20.3045.022; Mon, 1 Jun 2020
 14:28:44 +0000
Date:   Mon, 1 Jun 2020 11:28:40 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>
Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
Message-ID: <20200601142840.GE4962@mellanox.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200521141247.GQ24561@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7EE04047F@fmsmsx124.amr.corp.intel.com>
 <20200527050855.GB349682@unreal>
 <9DD61F30A802C4429A01CA4200E302A7EE045C3B@fmsmsx124.amr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7EE045C3B@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR17CA0028.namprd17.prod.outlook.com
 (2603:10b6:208:15e::41) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR17CA0028.namprd17.prod.outlook.com (2603:10b6:208:15e::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Mon, 1 Jun 2020 14:28:43 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jflQe-0006R2-Mw; Mon, 01 Jun 2020 11:28:40 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 968d4146-5b7a-4ba1-3ab0-08d806381679
X-MS-TrafficTypeDiagnostic: VI1PR05MB6670:
X-Microsoft-Antispam-PRVS: <VI1PR05MB667008F0FC5469431C93EA78CF8A0@VI1PR05MB6670.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0421BF7135
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lhZqsarE4wrbYlsyVSgkLcsH55rVZF5pnm2FvNBstnALpsrL5idDgwyb0N2Ra2yfV9IoEqO2Ils6HOW2bQB/beBzncCsWwbexEkOeUPEuEOzlrppBjffsLK36Lb9qdi+gdE6OASO5bZ5RMi3gGTM2+afnjJ5fB8GSShLqCN1y2MhNJ/3I4XBdLgShZcHmNaDTqCjJWQxh4XsPRnBpsE414KsmnLcxLejQtkq2J9RncsBBflq9gfTF3SpKJGLV0eu/l2UODCtuiXf6lBnjJlR1YBooDhV5df4rUESNYWyHU3LXrHOsP2xGE1uNdNS/CHQN4FnvimmERjujnykbfrXZTLd1W/hM0DVd4w/KMqizk//cChkRP5M92RxCrFBFwDi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(54906003)(1076003)(316002)(86362001)(7416002)(478600001)(26005)(186003)(36756003)(9746002)(9786002)(66556008)(66476007)(66946007)(2906002)(2616005)(4326008)(33656002)(15650500001)(5660300002)(83380400001)(8936002)(8676002)(6916009)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Yl8jSFpqQ9R6A02t8nx51IcE5LmlQ4L+0smoF394OqDgmptyAKPD5eKB5Rb+eSFj68NY5aBQbaNMTYJYGORa1637L34BpAYqLFv4QmAeMazqJ4qDMXlEq/4IlEwKD266AZfEU0YeBe6kkc10cidHB0tVrQHSIuJg2+AuZFRTyigkYYorxENm8odgxZcQw1Bx+pSXpyOOZL42VgVvftFGw0+RznZ2NZoy3RF3dxwpSsWguxrSAMCdPKnO5ijZJ5C2PvHTuqFG9ajo43e8XcznMynezhRpQQWT89UDhnLxImSHnZq6SeAI1odrHQViqpqDawP1PRXZn+18BCE8ZOKhfmDruDyWbs2MwEvEELlIAOgYSyNPUBL6h914n+KiX2WmkhxIEWf+WTk4CgOEd/k0AQ1sTnXM6i/7MomHk46NB8D7TfUZSpWDxgmJV7NZGX5CyE+DZYOXIWMY/oTmDben2pLwhJXAX5muBUDHLp+7FvU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 968d4146-5b7a-4ba1-3ab0-08d806381679
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2020 14:28:44.2791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JuIKT+KHT7/4MX0CKotsidOUz4qcYgF6lg0RrQwxjl0RGGDdb0/SQZOyPD8x7UZHqaFkz0IweheYeK+azPN6Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6670
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 03:21:05PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
> > 
> 
> [......]
> 
> > 
> > I'm looking on it and see static assignments, to by dynamic you will need "to play"
> > with hw_shifts/hw_masks later, but you don't. What am I missing?
> > 
> > +	for (i = 0; i < IRDMA_MAX_SHIFTS; ++i)
> > +		dev->hw_shifts[i] = i40iw_shifts[i];
> > +
> > +	for (i = 0; i < IRDMA_MAX_MASKS; ++i)
> > +		dev->hw_masks[i] = i40iw_masks[i];
> > 
> > >
> > > we still need to use the custom macro FLD_LS_64 without FIELD_PREP in
> > > this case as FIELD_PREP expects compile time constants.
> > > +#define FLD_LS_64(dev, val, field)	\
> > > +	(((u64)(val) << (dev)->hw_shifts[field ## _S]) &
> > > +(dev)->hw_masks[field ## _M])
> > > And the shifts are still required for these fields which causes a bit
> > > of inconsistency
> > >
> 
> 
> The device hw_masks/hw_shifts array store masks/shifts of those
> descriptor fields that have same name across HW generations but
> differ in some attribute such as field width. Yes they are statically assigned,
> initialized with values from i40iw_masks and icrdma_masks, depending on
> the HW generation. We can even use GENMASK for the values in
> i40iw_masks[] , icrdma_masks[] but FIELD_PREP cant be used on
> dev->hw_masks[]

So compute the shift and mask when building i40iw_shifts array using
the compile time constant?

Jason
