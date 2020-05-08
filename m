Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DACF1CB8FF
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 22:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgEHUaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 16:30:09 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:50502
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726811AbgEHUaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 16:30:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCHFliD7vXhJ4wSXlWdqnQBAbGvZ1bQ76qoxnKh3MG9i0pPoMec76Vyfdewp5KSiTeKtWOHWFacVMAtBO2fsISxuVb4zXGBOySj7loQw2HIdUlzcu9/i9nrcEURs/Vw+4OCVmQrmm2W7tbzM++4bK2SXe4/VWJarfu4mQNL2naMwomH6/fgMR/AYFwOzAHrOeeiJF+/uiF20PG1G5D6IT7LsnmdK6HNZBCubJYDJWqnM5r9JDcm55AgWH8iFmN4O5VoFeChGeNxFQjYe0T1aIFdIHK/wEn3zt2LGQsBdrft0NYQPUgMW/Ap7ul2ymOZhROFQrSjfJtXD/gnB7mLVQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7WkoM1H1yusGRnlQBXS6JNXybBRdRFyKDd9dmCVyds=;
 b=PsAm/tfrX6xoGeEkrIyszxjRN07wdGqtB5vB0xW5WnYCJz3rrw1atvr9O29x3u3zEm2BMjJ/tCBnILzKTcS0bgUisB1cT4tPxZNW+IP4mre/jhuVHXBtZPHrFDuNsOv36vT5JQNrkXtg+vAkYLEFu/fYpkKy495kIPROU3ey9tCN7SYNCO3dhCgNif5/4s7/BmpsJu8OEeDkaEJys4+TJDUmiOyfWN4WDjZRflyF03Eba3/+21uMGX/vZCwK8Ti0UQ04D+hqegKz3Br8Cth6iUCJEusnN9hnU3fE1WeEuq9pjZ3RiHgn9+mjbmTRj3/qC/0xo45crRvnucCI9cmwIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7WkoM1H1yusGRnlQBXS6JNXybBRdRFyKDd9dmCVyds=;
 b=CZ2+izTxzf679WUU6ArdFWZ/LFNQsIDRBAm4fzrZJytvoNnziQb6x7RW05HOEE6tQQpse/MN9fk9FykpRe5JzOCoVDFjPhs9MffOFMdleXDMDMWxgZK1TViEy9LW5GEZil6iWEQrYsrer6oAALNGwSLa7YHbQs0EAXYhAltpuws=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com (2603:10a6:802:1d::15)
 by VI1PR05MB5710.eurprd05.prod.outlook.com (2603:10a6:803:c9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Fri, 8 May
 2020 20:30:04 +0000
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::4d4d:706b:9679:b414]) by VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::4d4d:706b:9679:b414%5]) with mapi id 15.20.2979.033; Fri, 8 May 2020
 20:30:04 +0000
Subject: Re: [PATCH mlx5-next v1 1/4] {IB/net}/mlx5: Simplify don't trap code
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
References: <20200504053012.270689-1-leon@kernel.org>
 <20200504053012.270689-2-leon@kernel.org> <20200508195838.GA9696@ziepe.ca>
From:   Mark Bloch <markb@mellanox.com>
Message-ID: <680394fa-b018-a4da-7309-f38730052375@mellanox.com>
Date:   Fri, 8 May 2020 13:29:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200508195838.GA9696@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To VI1PR05MB3342.eurprd05.prod.outlook.com
 (2603:10a6:802:1d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.33] (104.156.100.52) by BYAPR06CA0059.namprd06.prod.outlook.com (2603:10b6:a03:14b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29 via Frontend Transport; Fri, 8 May 2020 20:30:01 +0000
X-Originating-IP: [104.156.100.52]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2f3712f1-b213-491a-bf8e-08d7f38e9693
X-MS-TrafficTypeDiagnostic: VI1PR05MB5710:|VI1PR05MB5710:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB57101C59EB93DB15369F1441D2A20@VI1PR05MB5710.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N4cPd3dWCLrSkP9i2NkT2TQlXhY/mE7o7F6PYd0N7Ibw1CWRTfPJjrnupq6uzM8vQCbLbjGRMRjfMqGHPoXAyIcrA2v2WwkiWiVD2BqjCsYZTM68j6M7vdZzJ0fsyZjibmM792T1+AO477kXo/wTg8JBSHUY6ssLlaxTtkiIDeK2rDgASYPjKtXBvBnG1Fv9SX+ehC8BnN51TcSNfB5tOIKUh6iscjZvSe5FB5d9uW0Kw0qblw6ZLmn039IGoyaTwBMrszd02gi5LLgI8CqD/gLCx/31PvPsOGBK++W+2J+6oltXbwVkSsdar8m661aAz+TPbl2a4uHs1zfSs7rGrp1TQafDd0OjsN+tlFE1o0wAvWIFyzdN/oJ98qhT5KCMrObrhc0kcZXM1lFLMr82T4N2so8fjSg8MW9VTRpVvkIhSL6rD1mFHjoOnIrd/rZKIGFb5fupedQUw6lqiP1wET4yrl929VPXQWcHyTDbNiWAohjSZRd7jgyRN/LGr50LvzuHLapBLSX/92GEHRWZYHJXY+M/ilLJT3vG/Q6YtrpGkM0oJs6X4UrFdy7nU28H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB3342.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(33430700001)(478600001)(6486002)(316002)(4744005)(107886003)(16576012)(5660300002)(8676002)(8936002)(86362001)(52116002)(6666004)(26005)(83320400001)(83310400001)(54906003)(83300400001)(16526019)(33440700001)(66556008)(66476007)(186003)(66946007)(31686004)(31696002)(956004)(2616005)(2906002)(53546011)(4326008)(110136005)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5SThQtJKC8ahLoCQOX97u7OpKnOAVl/6carMApNcx1/T9ml7YHlMHFY22fjmTyXb/2vW2FoGJp2IE0nVfTR/ZQWtLjTXiOCKWSWfT9g87EeU9+G2+JDpowyE9s3H84nc3giGgvdcqCMd2v0B2fRelYMgIUiRMLjHzIvI7TCSL++oWQPHGvj/gmEX2eEP4LXJR6ctFEE8zXipK2b0sYuCiWosRcdlB5Fspa95TspuMU2VzN+ao+assCWCaqkT/bpjwC8wVuFxf8ZpuEeBBahpzx1eM2F7gLwH/sXY2GZbde9aKJFHqFfMraXAFWxACEBiR387+DxNS4kqjYHOLeGXO658Gm025vE+XeFLeCaQwI2fPAoM2o68IHWy9ROFDy6amNPylawYwNLYBNLHtb+wBMq2jSpsU8Cfp9JNIrb57OT0X1XoOz6QGXwkR/17UBcsVY29Y1M1VBQQHG7/sjCYe+OqtkvnCTidlrgBy4ZRkHls7wEQ/b2nafeUjpXb91fk
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3712f1-b213-491a-bf8e-08d7f38e9693
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 20:30:03.9521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZaH3PT+wJSca0krjz3td21Kq4TdC3qwmWvBWTRQe21fzGrrn5DyMIZunQcdl7yw+naQT/eDIyWZAbmk1Qlkwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/2020 12:58, Jason Gunthorpe wrote:
> On Mon, May 04, 2020 at 08:30:09AM +0300, Leon Romanovsky wrote:
>> +	flow_act->action &=
>> +		~MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
>> +	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>> +	handle = _mlx5_add_flow_rules(ft, spec, flow_act, dest, num_dest);
>> +	if (IS_ERR_OR_NULL(handle))
>> +		goto unlock;
> 
> I never like seeing IS_ERR_OR_NULL()..
> 
> In this case I see callers of mlx5_add_flow_rules() that crash if it
> returns NULL, so this can't be right.
> 
> Also, I don't see an obvious place where _mlx5_add_flow_rules()
> returns NULL, does it?

It seems you are right. b3638e1a76648 ("net/mlx5_core: Introduce forward to next priority action")
added that code and it seems from the start it was wrong.

Looking at the code it looks like we always use IS_ERR() to check the result
of mlx5_add_flow_rules() except in: mlx5e_tc_add_nic_flow() which should also
be fixed.

Thanks Jason.

> 
> Jason
> 

Mark
