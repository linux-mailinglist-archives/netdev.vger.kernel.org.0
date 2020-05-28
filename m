Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2881E5743
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 08:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgE1GI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 02:08:26 -0400
Received: from mail-eopbgr00043.outbound.protection.outlook.com ([40.107.0.43]:56293
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726791AbgE1GIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 02:08:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjZEgvyqoSe6v0E0YbtxXWaxkINnoDQosGyyC+npZp2cbL7gwRef+DjMxzIbOl9eSi5N3nj/FS0hwbs5vCgju4niDMaIwKbelTHgK6IwWAzD+vkOpqW6+SNy2sUaQmmVepDza1F7TxcUMvygENlmXSKb4PdyY0hvQO7XJL1fawpFth9kvIIj6Ti7+1r4bCJXZWo+DaOjf24SksK2zViSmTABImJnfXmUVx6qgQe87ZRPOebxEQgF7qZkmvPZP4AfDUPLXEaabZO2mhAjSQvMa+LPxM1d0uIbk0xe3/FFdGv+lWKJ4CaQRqzPfhfSS1a6ae4/qgiP9tNDquDPtpleWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7ZEDbHWjsv49glfx9NWsXIj4V38E+FgTM3Kt7GibsA=;
 b=kVaFva0RhWaUCBuxpDB90kpSSiu6jAJ1Zt8raJaXuuwsIBudgVAfKRQ7WfUUHFCEkxFcTqar3Yy2S//wEEVhvvj1HhQa0AZiqkn0ApLd7zkkdeSzPJPIVcT2OJik4de2zdefDYax/BEgNZCD/L4JGxKBp7HgHr3D5WHWof7vvfrPDP32JOs6shCTOWod4lHc5aYsGIbP0Z14J7U78iVsAWLgroETrWbB95Sd9QVPl5hmhIv90UNyAHdg+j3DNnZJnp2h99moYzqH2N/x0pu3O0QozlkhA5MlMoRytQHbzgSn6/s1F/+QC431GiU4yNLU1xIOnZMHRpw2UqDP/HdRqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7ZEDbHWjsv49glfx9NWsXIj4V38E+FgTM3Kt7GibsA=;
 b=phI5e6H5s3C2By+95o+V/k4BGYD6m5h+Hs5/YG1zxvYOVCG3fa79hQ5HgA+axTEk7xK4SfvN9YvS8XLqbU5GA9PX8A+i8SSQs/leY81PKAIlxQ6qht/ObuEALvOhaoTUFfQdqBiDCOg/VR32HIctGcJHPpKD8VfeifhKIMNOzrs=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM7PR05MB6726.eurprd05.prod.outlook.com (2603:10a6:20b:13b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 06:08:23 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f%8]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 06:08:23 +0000
Subject: Re: [PATCH net-next] net/tls: Add force_resync for driver resync
To:     Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
References: <20200527092526.3657-1-tariqt@mellanox.com>
 <20200527153248.53965eee@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <b0a8a3fc-b132-5df5-46cb-2b54b9c8de4d@mellanox.com>
Date:   Thu, 28 May 2020 09:08:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200527153248.53965eee@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR03CA0052.eurprd03.prod.outlook.com (2603:10a6:208::29)
 To AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (213.57.108.142) by AM0PR03CA0052.eurprd03.prod.outlook.com (2603:10a6:208::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Thu, 28 May 2020 06:08:22 +0000
X-Originating-IP: [213.57.108.142]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06f954c2-869d-463a-7faa-08d802cd8739
X-MS-TrafficTypeDiagnostic: AM7PR05MB6726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB6726CD29069E8E9570813088B08E0@AM7PR05MB6726.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SGhkzzP0a7yprvHFsPWWWo9U+cs23T25M4ohAaibjB90CRu6I9C5Y9PqYI5pFOIE15pB5w9sSdNK+LsMSgh1NkbkgjGugHdeGBvxioNk3s3yrC6A0HlXWFYjTCEFWmygWJqMbf0U1nq5GAI0fFtoeRZN0kuLLspfx8YWHwd6ph5lVU7Bc+eD+y8up42H8CnpYCjna3aMG9gR9STDd2bdgOhMMygey7MR/Ai+5dSGLmlqiatZvpvFa7HP75UqcAn/JEkmengCbNIfUouOvWncVPuTgKP7adKaNVr3DoU3rycUyuROS2jybIG0YXLA/GhSMrapVrO8awx+JsbTCZTD7JHiNN8469yq+NG761lvJ5kmZqJVoI41rsLj10KYlBHd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(2616005)(6486002)(316002)(54906003)(16576012)(66556008)(66476007)(4326008)(66946007)(4744005)(110136005)(5660300002)(2906002)(8936002)(186003)(52116002)(83380400001)(16526019)(956004)(478600001)(6636002)(31696002)(36756003)(8676002)(26005)(31686004)(86362001)(6666004)(107886003)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gMHsXtM9VksenQvWgpD40r7JCl+x0OL9+OeFLGNvoooyH1MTIPXLupOqxjZXXS20FaJKCScefjUIn3d84zxEk0ntd06Xq4iYArFEQPzCFmUMGgabjBHE9r2oPFJpvpjlsXhAYdIhZ9Ppbq1IIl/yoXOdDNn9WMkf1EflJgnPKJ2eDAu1kUyp1PpQYflNdSIh3cfz54Y4vd3fsJG5nHyneIgAkyPyoobwBBAq5ps7agiUbBf/LKd6watDR/DJqwl4zC6L2TgNrPpzltQx3LbQ46ThjNOCouRsCxun3ZaWozePCMsymswjLzlAZxsf4KyIhFq9WBXcJr9a4LfJm/UykVcZbgd6lNPpVM15T2Padog1wFsPZku42Jm1zOEkxp4q3/BAIaPSFe+aTriRLr6mc29imZNYHqT9FAHm2VIgz+1c6R45oc2CFUiCHFryKW80ven+7v7k9KQDl7YkImi3ZtoZMlL753XKvWwGFHkXS1+hQpIEwUnlGCE7DyFUuclw
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f954c2-869d-463a-7faa-08d802cd8739
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 06:08:23.4154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ph7OpVHx7vzyY9oDDWwuwfaETb/Jd9lS1UG43ulPT7dqbniXWdfevr5ovi8+aF9yUlH1NIHzFYZbBNhI9zpWEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6726
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/05/2020 1:32, Jakub Kicinski wrote:
> On Wed, 27 May 2020 12:25:26 +0300 Tariq Toukan wrote:
>> This patch adds a field to the tls rx offload context which enables
>> drivers to force a send_resync call.
>>
>> This field can be used by drivers to request a resync at the next
>> possible tls record. It is beneficial for hardware that provides the
>> resync sequence number asynchronously. In such cases, the packet that
>> triggered the resync does not contain the information required for a
>> resync. Instead, the driver requests resync for all the following
>> TLS record until the asynchronous notification with the resync request
>> TCP sequence arrives.
>>
>> A following series for mlx5e ConnectX-6DX TLS RX offload support will
>> use this mechanism.
> Please document this, in tls-offload.rst.
Sure, I'll take a look at it next week
