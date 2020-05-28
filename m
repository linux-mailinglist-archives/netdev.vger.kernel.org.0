Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878431E52A5
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgE1BGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:06:25 -0400
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:50746
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgE1BGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:06:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5+Y1NdXNjf4ZceWTbUs58pArm/fa5dbQ6hXxGjsSvC+F5AiMVka9KUpyXyi6l6UVOaU20xs9+tEQAggykYr7tCSdNIwzva1lKkP8TYJEh8LInvwZW78/kaX3KjJr34YC0e8rwP+OPfyQ+7LHE+S4UQJgIOQZuzeK94VhXbIHVcPvdqPzzhzYblJaL+eSjI4KBHDh70dVBVF/ffZHz7x6nCkDkgP8sAS8f4Lj8m3GsFNvFb3bpkUKlcyisp3bL0sLJqYJ4TGs4ZDsK8tWGQxjt38DF/AdAQnglNtk12AuNInVWMth6i6pJmqM0o9sgmgrdDtxoJMzsB1pP8/VZtw3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mjjy7B2HI5UsepwjjMh7aYrlYzVcmN+pBpJh26xrCc=;
 b=N7I9CBoQaCbq8fojRr+dzNxw1ltsxiebxj8+ZUvxm8Gr7jU6UdPGvSRdjC8KmZFhGgOTOGYOjrImM3MydW0MIsarqJ9g6dwZQLaLAIQMK6k1yOjmjjOL0A+0TYCskqM8RyXWrIwjjk8tuJ8pKmU/BsZNRuWF934ZdE80itPBpaplMNskvkWl6iXPWG0uo6m16pNK86yO/PeQZDstZfDxls3y12AkIkHjj8bfMgXWtw+ek8N9PQ9IwjY6VbeAxJWUuP8vwqdv4Bdc08N/nnr3BQ9fc31ywyw0uRsTg9/Jjm9SmdszSDRovYWpwryxDVttD4Dv3NDDEQGI1TvWUocYOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mjjy7B2HI5UsepwjjMh7aYrlYzVcmN+pBpJh26xrCc=;
 b=EqAA8LizGfyPFiHk97pPoA2I05EvAaArZa0VtPI86fATMIb9kCMMFtZlkPorPCRXFnkjD/OdzJFaUJ63FDgeqSso7pp0WTatzYgsuKB4s0lyPaxjrE8vRsLeJlMrGn1kPUaQ1W9sN9fd3N9srB224pZCGdXgScL8djuypaVLaCA=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6925.eurprd05.prod.outlook.com (2603:10a6:800:188::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 28 May
 2020 01:06:20 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e%7]) with mapi id 15.20.3021.030; Thu, 28 May 2020
 01:06:20 +0000
Date:   Wed, 27 May 2020 22:06:15 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Max Gurtovoy <maxg@mellanox.com>
Cc:     dledford@redhat.com, leon@kernel.org, galpress@amazon.com,
        dennis.dalessandro@intel.com, netdev@vger.kernel.org,
        sagi@grimberg.me, linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com,
        aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com
Subject: Re: [PATCH 0/9 v2] Remove FMR support from RDMA drivers
Message-ID: <20200528010615.GD24561@mellanox.com>
References: <20200527094634.24240-1-maxg@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527094634.24240-1-maxg@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: YQXPR01CA0118.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:41::47) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YQXPR01CA0118.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:41::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:06:20 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1je6zw-0006Al-0B; Wed, 27 May 2020 22:06:16 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f31f9b5-1de5-4508-0f3d-08d802a35513
X-MS-TrafficTypeDiagnostic: VI1PR05MB6925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB69257E77495859EF83CBED2BCF8E0@VI1PR05MB6925.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fb17bjBK62chUxAnDF4HwICiO/I3QkffXnKS5brp5PY7HtIq74l4fsmDhviL3NMThAmF0g94r6hepdjFEPWMPrW5yXHhoZMHaEFOLgKOUWIdAhRJPdcT9I9zmkt3Mo5JOaJpvGfSrZKvJLwLAojmG7uyogac4kO6XlmfFqOdUmbvBVSYcAI/u5L4n4unDQY0qDSfvhQ6hwSN/skDb0/IQ2TGwbgtF5Ivhayk3sMRG8LZIsjxTBAQklYuyB5UPwWWKCTA8SEBAHmYSX6TYLhDIt8ypeDwDk7fYTo6n37gYEVE7ewIdIRGfuLgtIUxjYp1D6MNC/PSUsMGwuvXQ/49aRDuBHoIbVyhtJNStCL3YKUNzWTw1Ls2sc2rplPh4dNY0BcKMAvOa1US/xzP/EsZG6waGZC7rruIggeE2ui0KMnR0hnMi+jP5nRvpup1wRIlJ3ltSmDgxCEDXb+mhl1s0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(107886003)(33656002)(316002)(83380400001)(86362001)(37006003)(2616005)(8936002)(36756003)(7416002)(66476007)(9746002)(66946007)(6862004)(26005)(9786002)(2906002)(186003)(5660300002)(8676002)(1076003)(478600001)(66556008)(6636002)(966005)(4326008)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CmvyRMi9v21FjCwB3pu7oGBjDBUbxUB/FV0unjXa9qOIXteSidhBmFSyybFNCHdukYSvb+VQHjfzVIqgMdNCAIVldki8rszkR6HbA3T868rPtM+s85qt/efp4AFnPrrQrQyxxBhkGcp73Wv/QFMaK7rtNHtit8aS2l+MQcJ4OmrDzjyYz76sSjVFMtiMZ5m1m/CO1SDtYhfmLSUlU4X/7WAVRMvFT8V5FnPjqJoQfhWawy9j1T9klgppkcZqYE5kifWE+ol5mspxybd5DCaW+IdY2un9llMSfBcLQ3OKvtWSZWl+8zPF3DP/qVWb3bhFCZHdq+mBgzPxy7BqF607lho53OCSvMUFqudPTRQYkKHHPCOJdM2rduXLH99jzRmlrAD1qWG/sWaHm6sO22hIrIaUnD4njKw5UMcCs14D3iKU3pdTaxL7ActymQedntn3cuUJoAOFEx05HkQSuOVIR8XEMiCNXae5dfxjjgcwu4aPEUMtZL/0JZ+9N9Z8ukvT
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f31f9b5-1de5-4508-0f3d-08d802a35513
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:06:20.5431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QaxeQXbFaEHfKlaa751T7GrvADn/OhvPOaobhcmMF0f8Yk3rwVi1Z6DBjiuJtkqWVLnMTzjWQsdW5PD5vAPpjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6925
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:46:25PM +0300, Max Gurtovoy wrote:
> This series removes the support for FMR mode to register memory. This ancient
> mode is unsafe (rkeys that are usually exposed for caching purposes and the API
> is limited to page granularity mappings) and not maintained/tested in the last
> few years. It also doesn't have any reasonable advantage over other memory
> registration methods such as FRWR (that is implemented in all the recent RDMA
> adapters). This series should be reviewed and approved by the maintainer of the
> effected drivers and I suggest to test it as well.
> 
> The tests that I made for this series (fio benchmarks and fio verify data):
> 1. iSER initiator on ConnectX-4
> 2. iSER initiator on ConnectX-3
> 3. SRP initiator on ConnectX-4 (loopback to SRP target)
> 4. SRP initiator on ConnectX-3

I looked at this for a bit, and it seems like there is still a fair
amount more to remove, I came up with this:

https://github.com/jgunthorpe/linux/commits/for_max

Can you check?

Thanks
Jason
