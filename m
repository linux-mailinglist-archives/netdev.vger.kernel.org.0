Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95C5645362
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 06:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiLGFVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 00:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLGFVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 00:21:00 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D801451330
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 21:20:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtdL8Hbxj8je5GjxGAz0F2ztCJW61IZYZVEQo1XhB6bEFuNp4lcL78oqNaX6Bq2tntj6xFOkuSfYGcK4cS9/yUfXTOCHZw5nzPrbs25Se8m9p19BfnAsROHWMviBCvZaItkBgV44a1St6+K7d4+kgUtuIskWiS6VeGb6WrCU9TgYB75gW5aMoIsTkospcKghyNCd8JlgxJPHupCxu3mVLHcuuq+L8HoLIgRJBHSPeIHndeNAkDMsI4LNC+Lep8nPYvLDlLLCHH6jBrCwmQFpuhUZ5HUUZkTjfQEWLbfP+qWZbhFgkidrat1eeeH2pDaUpjLALfhKBzh5+YIjaw4elw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWX/nLH90GcrsgzDOg0YkKvsRBgMZiUZaDYSPiOagS8=;
 b=UdxTC0PMLOJt+xHkdApSVLayXmjB58Hc2wlZJEMzaW7cpGObQFFZgO+I0eqdG9K9XLrETFrgoLOIwA7+/AzrTlYY+3JtaI21WeX6wHz8P1lYvGGa8nHf+2tdfCZItDN14KfnrIE0EpTKpUbFbCbaCyf4zec41SGYW56hvOuaB7sJCCr+uuUsr4sGRVyOxl/+8Xd2FB61tvrTZyNPCqPhoTwTgbJY++gZ9ZnEDDDw7mjRvNFgt0ZHG3nqgnUKpOw6IPhen+9ngTUQOejkG7ZihMJ46fmGX1ZZ5smaElGnLcyMJc4oeYtRgOAia73OkO7g57z2qSD51nGKgEugLBH1kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWX/nLH90GcrsgzDOg0YkKvsRBgMZiUZaDYSPiOagS8=;
 b=VAT5XttsUka04YuZAtpVLydNI5nUqUb2z5lw0NrLXMB96mmssYEoWEbuuH4oCxONqwfNfs9ibzlvyOcpv2Rw1+fEV5Z2+Yl6NCRa7Lz6nWyFRbpZDjKR/rWj18T+Nt8z+MhZVar7YzmUQYw8M4y/EOh8Ie52cGiZ+JVmWpxQBVStxIc0wUjxbrKf6oZN+P4dW/mUSju9x+L82BfB0XxE2oEy/e/7ti/sIlFwZGefN118RgI9NjfBXFBO7IXW3l4+CizoJlcu3pFucnf73wv1/JP0xFiwfum6HZfe3xx0aBNVdE9Y88OrpL+VMXlhI2tDKQxUFt/cYLBpseaHbprxhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) by
 SA0PR12MB4351.namprd12.prod.outlook.com (2603:10b6:806:71::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 05:20:58 +0000
Received: from DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::d133:4711:a0b8:17de]) by DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::d133:4711:a0b8:17de%11]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 05:20:58 +0000
Date:   Tue, 6 Dec 2022 21:20:54 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: SRIOV, Add 802.1ad VST support
Message-ID: <Y5AitsGhZdOdc/Fm@x130>
References: <20221203221337.29267-1-saeed@kernel.org>
 <20221203221337.29267-15-saeed@kernel.org>
 <20221206203414.1eaf417b@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221206203414.1eaf417b@kernel.org>
X-ClientProxiedBy: BY5PR17CA0017.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::30) To DM5PR12MB1340.namprd12.prod.outlook.com
 (2603:10b6:3:76::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:EE_|SA0PR12MB4351:EE_
X-MS-Office365-Filtering-Correlation-Id: dd17b8bd-be10-4e65-d9a7-08dad812d1ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9cYQiSzDGzM/jelUa5qtw/ZXa/yqGnFbEjWyqCe0gd8aZSAm3JYlSxb+1xlAlYY4qK9qcql+5fGGzRtp5FVQQHcOBTFUhVp0ntRkAV/YZSwzSNYn3pGjrj4GtsfVsvatsqvtQW8g5YKxWTzZoaMFCnAemnqnXzPzn2I8uc0gaiZf5Jy6OizDSDDeNfnaxu/IB3O6dsaIqHrzwuA4iiOQCEFRv2VBhSJ92JIJ1S7zmAXYUQgussAp+NI010QnAT2pDI6TO4ZTsEwAVzj3jMpRbajmvgp0bodl2hqt5NNmJ2aucacgY87UF57a0hRBddcG1mZxe9L2JCe/v5gV0EAZFeMv5ZgK8/THx+oFcBPBdg9UwTCHXI8PibxDm6+eZksfT/n75qknuPzqgvw+v2f4kYJ+inL9B53CqxaHfMtyjAWSNcSwzWgq4e5+f4qT/ZvcmuAJDV4+6Rs7syLQMtbC0uLhOge9ctuuxyMVImnwDSICc/T2i8bdOoiS8lMhYlAlMlds4vDZuKueV/RcUPrr8WsmxPBbw5d0A2MDgPpjPRF9uC/wgru/NKz8Z6RV05WvsDtnvnc/uIXA00NywzymWah8sIcTMuxN+cdqsaZXvR1t/J0i7cdJfHuk/BYzz+h7ofZ7b6DX7L2hLgr9aXfeSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199015)(186003)(6506007)(41300700001)(26005)(316002)(54906003)(6916009)(33716001)(2906002)(38100700002)(66946007)(9686003)(66556008)(66476007)(8676002)(4326008)(6512007)(86362001)(8936002)(5660300002)(478600001)(6486002)(6666004)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lgJ/jhMC6iurAadPXVzycuaZXXO+b90bQpnCNUBXgK3mwhUsWhDGv0amHn32?=
 =?us-ascii?Q?JR4LsaRE7A8kM0pHvFhDSLZeAaxXGrLLoBQgzGQq7C5cOJOsVdWnM+mTW/tb?=
 =?us-ascii?Q?kkmZSFTeTsXp5+1NQZcqojU8w9gisY0hfOvr57oX2CcOMjBMSG8v6H8xb13I?=
 =?us-ascii?Q?ppIxpdOqlkZHWn1j/m2DRHjugPqVTSFM152DpTJNmg0s6LMoo0FwJoDXQ+Gx?=
 =?us-ascii?Q?GiC2wBaTFCxbCf1PLESqdqTAae1xMEp+nzVS5PHto5F1ZqLOBI0Ben6iYIMO?=
 =?us-ascii?Q?8+7v8B5pwvP3HlehMTuFtepkpYCq2iXW6doT0gETNFqwDvHtpTCSVVqLDv09?=
 =?us-ascii?Q?MXKu0ewKjvwGGOTDdfxYIB/7yNI2AU+J9I7R+ZFFYwdNtunEsco7E0QPy4ax?=
 =?us-ascii?Q?BSRWWM3nnOS1F6euKoWVv7tEVYJbfazV4gUHw98EwMWBtwd+bCOU9SsAa+h2?=
 =?us-ascii?Q?E02ATP9Y3aLfhmHq/MpgNJp2kQx+0E84KkmWkcoJeVUTShi7mbZ2WKUHoKgn?=
 =?us-ascii?Q?Tp46F9LSGXK0HtTO3MNTYn1/V5vEgw29OPoaP+NgOtj8xrkfl4AuE6UJJ9ka?=
 =?us-ascii?Q?kqPbCURr3qk62RD+L1GH6hucPRrriy3Gomy6IXZ3/zVPmHylQg9y382jdxkE?=
 =?us-ascii?Q?zbJImGgQGlAEnDAwZ8BbAibFZBZ2Pwqb5rHakeOnqv+GpOGoff6J1NnISp5c?=
 =?us-ascii?Q?HA7xmGbe1oYpUNO9x1n85Zv1zDHX+kwe8VXDmLILlJ3jMk0jC5kt6X7WLn6G?=
 =?us-ascii?Q?tF2ITrAPnd3rLW9TWwou9n8GAG0xchJy58M+LfBuPuuwyrcVKf1DTKvY+5to?=
 =?us-ascii?Q?ztRSp2bOSPF0yFynMx4JK6H/t2UoDhG3DWjcORlKiTZslR+m7yUtuTi9PvMp?=
 =?us-ascii?Q?NJZ1DtXLvUX9pM+m7KoSkWswIKIK92wSfCnh5PT9gOn7uReLPosO3EMp2ub5?=
 =?us-ascii?Q?CdtmGe2PhsIb+dEwC5C6HZdtF8R5Qc6+sUIAzERX1HTzyGWnjSg5jW1ITk67?=
 =?us-ascii?Q?n9A2hZBY1yr+2BhsY9jMlwK7fzMZz4WNxHGvcl0+Yuu89YzA51oSTDLq90a1?=
 =?us-ascii?Q?AzwsOSm3z68eOQ0tC384KFhoSVDU49GuHX+YwA48b7OTbC8fxve8fO6MFlWt?=
 =?us-ascii?Q?H27C3zdx0T27GkQeiUnmf4HXAgiZ4KeyDufbi7DZbjcxU2Gp9CsQp5tjYV2w?=
 =?us-ascii?Q?uC2rIpzpxG4KNvMQJMP47IYyfsb+BPJ3fcDfs2hQtEGrSxZKIT24IHmwNlht?=
 =?us-ascii?Q?UJ7tj6yOKt964Xd9zywJPFM5uY+VeXRfLwjP0+o7p1A/ps8q8quiXeky3tnV?=
 =?us-ascii?Q?0z4NztaFHFLL2991ZDUOhJAWFaBTB3W+vha+diAsyhpakWwxeBE6UYVEoOM8?=
 =?us-ascii?Q?ElowIsIPHOLXf9JAOjwK6a98h+AsT2hsA9nNgaRz3moVYHhQXEBy8lvtb//r?=
 =?us-ascii?Q?Tj6uffvjg9/Jm+tJSZNSagc1d3lnlYaqF1gzzECmbAlybSOZhabtzi1rU8E5?=
 =?us-ascii?Q?OS6pLwt0g6hHfpYOpZc1Icidz7aaqKyaA+60pFOx6rSF3YPXUYlV/+EXHAfy?=
 =?us-ascii?Q?wDaakinPqr/YjiK48hMUouQqy/QIe/3BniZ9Tw3t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd17b8bd-be10-4e65-d9a7-08dad812d1ca
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 05:20:57.9588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yOf/jqPGK0xfLZJNoswb3fgfFV8qTDWQY243g4fG8TZUAq87lxNBl9SiIhyCNlS2dcqcTj6NfRbBCi08T1pzvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4351
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06 Dec 20:34, Jakub Kicinski wrote:
>On Sat,  3 Dec 2022 14:13:36 -0800 Saeed Mahameed wrote:
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index 8d36e2de53a9..7911edefc622 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> @@ -4440,11 +4440,8 @@ static int mlx5e_set_vf_vlan(struct net_device *dev, int vf, u16 vlan, u8 qos,
>>  	struct mlx5e_priv *priv = netdev_priv(dev);
>>  	struct mlx5_core_dev *mdev = priv->mdev;
>>
>> -	if (vlan_proto != htons(ETH_P_8021Q))
>> -		return -EPROTONOSUPPORT;
>
>I can't take this with clear conscience :( I started nacking any new use
>of the legacy VF NDOs. You already have bridging offload implemented,
>why can bridging be used?
>

I really tried, many customers aren't ready to make this leap yet.

I understand your point, my goal is to move as many customers to use
upstream and step away from out of tree drivers, if it makes it any
easier you can look at this as filling a small gap in mlx5 which will
help me bring more users to the upstream driver, after all the feature
is already implemented in mlx5, this is just a small gap we previously
missed to upstream.

