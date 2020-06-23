Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C2D205804
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732928AbgFWQ5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:57:15 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:53890
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732292AbgFWQ5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 12:57:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hakgffZJY4+x08mR1OfSu6oW02F+JAfnTEla2A7fB9Nz03o7kXGPZs0eE2noC93tALc2kE9cUlNp4c8CXetoZ8jBNYHgm9BDp0tq/QRXSC5BSMrCo4+bWlZVHycgmtGmrcvuIoXeCsSAdH+uLZpxSVdJNV0vAinQZ/UBYGUTNilQjpoKZS9dy1YdwFu+XIiBaeKno5eWG1puT8TkNiN4nVYWbmG4QjLan/PlOyvRWZ3CU6DOFNZt0oqpXLN5wEjgNmu2rh5YHKhWGxFsyoYhgKRepHjBCnIThF5XYxWWwfkEY2rLCSqNekPbTK1bQsLtGPQWTQ1KwR6xmSD3FyuSgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pz++yekS0cTzj0OUi6Bjo+9r9h2hLcPjKZ8PRRq/Cv8=;
 b=VY1hwNi/sFxFWvza7xdJRbqZtgd/WiELnpkmqM8KtdKkDiuznr5glEV+xmd5IbZAtPC4s3r9t++RHe47ZeuQcb+bkHOyxqbOW+5C/k62U0bb6mYzemgrH7yqs4ZQ3/vnOVaSUIagAXYnQbrdzeJtcuM6JXPjhanpQ7X2gNbNLGmW+DcXPS0Ftjt/WBdgG7gc6d8pPKdMpeXrh1g93DoquHO/P30lQjIVN/Pr82eAqxmBg1est3h+h+FWhow3dwFqZapyC3oBqJDpQBkns8H3uxO7RILte81M64mbUDljOaXdnEDTv5bkFnqY5HZe2hPcQm3vW9qaJJhgzgLKzryT6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pz++yekS0cTzj0OUi6Bjo+9r9h2hLcPjKZ8PRRq/Cv8=;
 b=cbhyDGaKeOf9GXeppqwwcyItQpvXHGHWLLMkmz647XAK8OldDTyiWDIKfQaR8qzv2iQa3E1NNLX0ZDXL/ouaHQj1E3mSQiIuPn+TCg0/xzvKf2MV2VoVwD3xdngVGiXWNj7/gLT2OYaiCIcqqpKdThDuwljknYXT2dYC2cWoRPs=
Authentication-Results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM6PR05MB4933.eurprd05.prod.outlook.com (2603:10a6:20b:a::20)
 by AM6PR05MB4358.eurprd05.prod.outlook.com (2603:10a6:209:3f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.24; Tue, 23 Jun
 2020 16:57:11 +0000
Received: from AM6PR05MB4933.eurprd05.prod.outlook.com
 ([fe80::d85c:64e7:699:b5ff]) by AM6PR05MB4933.eurprd05.prod.outlook.com
 ([fe80::d85c:64e7:699:b5ff%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 16:57:11 +0000
Subject: Re: FW: [PATCH net-next v3 4/4] bonding: support hardware encryption
 offload to slaves
To:     Raed Salem <raeds@mellanox.com>, Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
References: <20200619143155.20726-1-jarod@redhat.com>
 <20200619143155.20726-5-jarod@redhat.com>
 <AM0PR05MB5250242D3F80160817117F60C4940@AM0PR05MB5250.eurprd05.prod.outlook.com>
From:   Huy Nguyen <huyn@mellanox.com>
Message-ID: <b6c69a4b-3db7-b840-085d-883b6775865f@mellanox.com>
Date:   Tue, 23 Jun 2020 11:57:03 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <AM0PR05MB5250242D3F80160817117F60C4940@AM0PR05MB5250.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: DM6PR14CA0037.namprd14.prod.outlook.com
 (2603:10b6:5:18f::14) To AM6PR05MB4933.eurprd05.prod.outlook.com
 (2603:10a6:20b:a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.44] (72.179.1.249) by DM6PR14CA0037.namprd14.prod.outlook.com (2603:10b6:5:18f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 16:57:09 +0000
X-Originating-IP: [72.179.1.249]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ddce06c3-67fa-41aa-a446-08d8179678c9
X-MS-TrafficTypeDiagnostic: AM6PR05MB4358:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB435813CBDF814E5EA8C25BE1AF940@AM6PR05MB4358.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pnCVtuIDeeJ6mYGnXud+YubVsW0csFAuvBO0B6GaFHfp+aOH8/X/WDnclGik9WikfMtgV7lFfGrvdQQvhADaND3iYPG1gEO6INSzQm36lnKFq9bx3CtEMYcFUVK++1oa+wZRHAeaMc83ggOikJh6aQlrjNyykTp7jYfs0v2fDzrF7uCfV9Sw674033AZhv2qOSkvtiljtrWDRFqG63g2RmxbYFaR5x4ADsP0Y0574J1Kh3BQiEllVWsFY+8yz/DALocNGVbLNBuVv6vMLgRAf4lyn76CZg5Oe1F5FiJjMxGhHV8jqdnVsSf9dnlNzmVM4dkVLcM3hpxwZYmYShuXUH6APNe/6puy6OcprzpgELBUx82a+2vZjQLbkQQMUw1Bs3MOdgTRBemdHv9PX0O1aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB4933.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(136003)(39850400004)(346002)(66476007)(66556008)(66946007)(5660300002)(478600001)(558084003)(6666004)(6486002)(186003)(26005)(52116002)(86362001)(16576012)(110136005)(36756003)(316002)(16526019)(7416002)(31686004)(2616005)(31696002)(8936002)(8676002)(956004)(2906002)(921003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: R2neVrm0JitOHtMzu97D0gArrCjfeaVrdoXgmCmhcSl3uKSiAfN+R3gtvkHS32+C9fC+njKYzAmqQ4WJopHwxlwEYzkb+YmLi4usaX9VeFJ+1baUmsvAYx/P/rYtIlgUYjUnue9sxgvdWJVqcwCwpXz3ZYlojnyu3b2hC5MYCC936DIygX/BvM8h3sE86jdTLpBX3LoGfuwNXSc5XCfc/+Sncqrq/HxT+NWJn9VG9+QJqdN2QeYKFhT+AG5u0TFBvQtyG9BPjT6tNiQ8+fCxQA891uxgimKbtWls4ch6z+/w+02AJ/+yXbUgP2D0T71NyFnDsup4vqHIkSRF+lnEUjq8n9DKBYfLkvWZNX4FHiLKL/vPsnTak8KWUdaYPOtbheEhqIKkSfIuukW0SlbeCTrr86D4l1wCYInRv0rKGsC5ngygwB03Uqkf8wGzn9VPK54AGk4c75AK7Qtn30xATVMhwy1AC81jTlcC03d3wK4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddce06c3-67fa-41aa-a446-08d8179678c9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 16:57:11.3898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWvSwhX1vHgQuMU0mKZzn38RgQnw/GlHrAjXsTadix7t0cStm2KhWMb2QxWBAztfporUhE8qu8JFByaCoEYoAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4358
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#ifdef CONFIG_XFRM_OFFLOAD
> +	struct xfrm_state *xs;
We must support more than one SA right?

