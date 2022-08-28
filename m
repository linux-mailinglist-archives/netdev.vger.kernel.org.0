Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E3F5A3C45
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 08:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiH1Ghi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 02:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiH1Ghh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 02:37:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC9851A35
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 23:37:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D65/pOPUQsI4HOjMprhUgaimxAbsTDz2rAJT9MFfWaMdIoi/C6hT8bn1ytUtsz/UjEWzMfEWlYcDS39Aud8aPJdHtJOyX7bH3ixUt7It/NSF9V9q8mGYcmOO1/jLkUm7ICkXoc6Erd220RShf3+fjhiPrMOjcdejhv44WojFl7fbnNdW7z0Y4B3ueDntObe85Ic6LoLe1zWyFRAM7emjfNwrCPSOj/y2Bfmb3ECHRUiWhkE5u0XLb9oTjTMERkVTw6lwnX8SvyRyDQfkN6Dxo+8L+t0RxMBHl5BazNreneZ3C8irvFH0+mEQfK8ALBddUxZWIY/J80jgLYEZGjUaTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEjHBrHWqKN+Gglp+TUOgqBiNt+s7Y2xCnBOOlRTiRc=;
 b=au0sMvB4b6bQEfD66cBqAURimX2C2bopB15oxQ36bROUedzF4pzrdpCMndFFpInI8rahWMiv8cB/XPUNcfPXoSe9NhrLvsssXJfEUzni8bRpBGTg+4Jbf/jJvV9ANulebNBKnAq8tzUOS2lGyxLoFojjS+wdmbkeJl3Mb/KPs/R55508/+936LcaFOn+9CUtOce0JjIKSfOw4dZ7hhE6yUlVYj3eEdJfqFmGYmCGf6zoagtl/BYt8c58dpSZiOdZji9yRcTFtcU/vilIaxxjqb3MMy6pJVTa08Cj0mNjOANiFyF7nZfMIzwz68ff/hNx9oZqwt1XfU5LeNV6T7Wobw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEjHBrHWqKN+Gglp+TUOgqBiNt+s7Y2xCnBOOlRTiRc=;
 b=HPFgx3Ko5ASx6H6G6oYFGJw5kDMWePWOML3hdlMtyWFz6Z5Nxd9R82/FQ+GF5X3pcOk7w8c/Vi/wIAxXveRK7Z4AO6EF2F+yocJgj0Qf8kYJsT3iyVhdNFsWHa0c1e+iXVoocPgs7lN45Vn8KdJlh7ogQ2QgnCX3vcUM/q7+GUQ95xIe+lpcJfIs/AAgBW3Rt0RfUcgmbs3+PkGIFiKi0bw3hVKvLfjEO2XL8rZ5Cyg59JQMiArsIf2iHivndg073nn9T5B86bdjKeOTKnECHxl15nTKq8FEUuQ/oSd29LJUeTCl64iK5Gp1pFIyWxO86WqLaqNiQgn6L24bHOnuEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by SJ0PR12MB5470.namprd12.prod.outlook.com (2603:10b6:a03:3bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Sun, 28 Aug
 2022 06:37:28 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::e034:e0b9:a75e:3478]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::e034:e0b9:a75e:3478%8]) with mapi id 15.20.5566.021; Sun, 28 Aug 2022
 06:37:28 +0000
Message-ID: <2fbe2856-bd90-54f4-014a-4ed13f87c907@nvidia.com>
Date:   Sun, 28 Aug 2022 09:37:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: [net-next 14/15] net/mlx5: E-Switch, Move send to vport meta rule
 creation
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Maor Dickman <maord@nvidia.com>
References: <20220823055533.334471-1-saeed@kernel.org>
 <20220823055533.334471-15-saeed@kernel.org>
 <20220824144328.1535198-1-olek@wotan.strafe.russland>
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220824144328.1535198-1-olek@wotan.strafe.russland>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0224.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::13) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 953798fd-dc52-44ab-339a-08da88bfc6c5
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5470:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: as35XYx8e3XKtHLt89wIIlznMh9hNO9JkPzahWjHEj3LykMpXq1aq2B1LZ1s+uiVuxpmrbDZAbF5QplSq5Ylr+Pw3iMGOgXTMaybqh0nfn0vsR+8O5sqy3TQWy+QxY4EzU+rzTViAF/BDPU0YRyLoNYbxP7p165GoACq/2CCR6q57kKhQlu20D7EIIOgkBNJArIXfkIoYu0Gj1QKhdfht44Qn96rSOx3XLdcV4Y2Yhbjj4GSX38Ovor4u7OLPWxqvzNxnZ3DwuzuIBbU7ZPIhuuunXXKNAD2Q6Osb1e5NGPKluyfhE8mpMotYQlCN5Q6hFLr7uNQ78u76sovcrzbKpuQs5j6DjhdR30lroHqgpS7WxK6dWqB9c9/g1Szr7KEELud1W/cONjpjn7sJN6jibSD+83pm/WXBa4T8OTWvH5Flu1bHh2KeAycQrOcdIVtkn7aZ2rCZ6lqtf8N7ekZuIbISqWVcEkiBmVzzak+tEfoGzMuY4RnxZI7KjcpQ4e2I2O1Th5Q8TUA3iz992vMbn41Y6n+M06pWaeDYzkpFwEGpqmf5i1ABMtpVOVTZI0RTUd/tTEnJPhxmCEjzd1dFs9ashwfbKVfaxkb5u1L9jvmRy7xtVoRJwJI3EKFUpiAUhaWJq9AomifJqDYt/AR5NG+33XSDue8wWJoFgHdJP+7DOKmrfw5jKq6SQwWhfEYb+1PtGEymGLBnvUkJVolPGdWFBaKLlYyZDglLUHGscjWCnyEQJWUktmlxHeM3M7ed3oqeEYpRtBPP16pWTTdYE6q6Qr4k/YzF+j+mavIwv0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(2906002)(6512007)(26005)(107886003)(38100700002)(6666004)(6506007)(53546011)(2616005)(83380400001)(186003)(54906003)(110136005)(8676002)(316002)(31686004)(4326008)(66476007)(66556008)(66946007)(6486002)(31696002)(36756003)(41300700001)(5660300002)(8936002)(86362001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnVNdWZhZkYxVHUyTTBMVUthTW1iOHhXOTFoUk9xSVFLZ3JxRms3Uk1pcjRP?=
 =?utf-8?B?NmlUYlJub1NvT3dPWTYyZnA3ME1EZC8xMitveUovZ0pQbXhRZTVDY2VWSUFX?=
 =?utf-8?B?WEo1Qld2OHROVUxaV2lvVUE2eGJmMEUyL3VUQUhzTDNJelo2N2lCYlZVZHk2?=
 =?utf-8?B?UGY5NFZZWUN3MTQ3TlR4cnpyR2ZqbTliRHlrcGdjYTJSM2Zyb296ZzllTCs5?=
 =?utf-8?B?dnk5T2l3aXB2MDBzMGxFZ2JDenFTS1o5d3NsN2JIc1BIL3o5UE41dUloRGtR?=
 =?utf-8?B?TDFxWDVRT0kydjBNaUlxQ21jQ2ozNktVTGVrU2hVVDdUa1d6cGNQVVNpc2Mw?=
 =?utf-8?B?dGRsV0FWMTM1NnEwM1ozcmlXSFhtczE2RDlkZ3VlYkpzUk1TYjdFV1poYng2?=
 =?utf-8?B?U09rbWJLN2w1UVl4K1VBYWpXM2xyS1ZQWFo4OFJ3N2lxaGF4OFh3TmpaWXdi?=
 =?utf-8?B?V1pCUWdmWEwrRS9HZSsrSzBxellEdXFXQ1RhczEvL0FBWXkrcUxsU1hrU2xo?=
 =?utf-8?B?NDlpNmJKZy9pQmthbVkxUGM0Vmt3N0lHbkUwREpyS0lKVENWbndNTERyQmpN?=
 =?utf-8?B?VjdXcGc3YjFPMHpScjJjbE1TZUxFeFJ6SkZNRmNVNm0zZGlzYkdWYkNya1hr?=
 =?utf-8?B?U1ZCdW5EWkFwZ2pWNnFBcEg3dGFwSEZBZllINi9LZGMxdys1KzZSaC9ZaWd4?=
 =?utf-8?B?b2c5cFcxQWx1L05vNUxJa1BqdjNHZ3dEck9nNS8xdVo3Z0hRaWN5UXVUUGsz?=
 =?utf-8?B?TnV4S0lyM2pBNHp4SVVDNWdzUGlsd1lyUVphOEJheDVKR2NGL3lVUHRVTEdG?=
 =?utf-8?B?aXp0UUYvRURSeEFkS09ieGQ5Q05NUjBBQ2ljWCtXSHdUVGNHOUZpMkt6ZDEz?=
 =?utf-8?B?cHNmZ3V0SmNvTGp6cFE4TnpoZXFDeUFLbUwxVlc0ODIweGk1SjFkV2MxNE0x?=
 =?utf-8?B?WnVzRUt1QjB1TXBOVFdDNDFZalQxelM3b1laNUJDUjhCVU81dDMvRDF1bmRJ?=
 =?utf-8?B?TndPTTNqenk1UHZMbUZPd3I1UUEzMW4xaWlHcktqTXE3ZUdpanBJczM0RWVk?=
 =?utf-8?B?bUNiRjk2RGU4ak5IQ1Z4NzVlWEFSQWlmcmY5bktWSHFpQ3dRcUljNmFnS09m?=
 =?utf-8?B?dEZJM2hBOW4yRDRsdmk5MkNsamVVUTBMM2VnMWtxWkI2NStNVkJiaTVYSk9k?=
 =?utf-8?B?TXdqYjlpMmplN002TDBBOU9ORlFJKzRPbm4rTUMxekRLYy9peHF6NlpTTzcw?=
 =?utf-8?B?QytnY1lEUGhOVjN0OWZQeDlkK0dCOUZYSnQ5VFFnTXQ4SEJTR0p2Z1dpZDNC?=
 =?utf-8?B?WDZ1d01RMlBVSjFQWjRuOUVLcDZ5RFlTVWxHb0VXSFpldnRGSkl1RTdEbUVN?=
 =?utf-8?B?Rkg2MVN0by9EZGcwSHljaGMwSVF0akNNU0psejczb043MHpLSzI5WmFHNGFR?=
 =?utf-8?B?Y1VkVGRqcjRwZ24rdnRjVkd1MlZDOUxFeVBqT09FNmZRMVdObW5ueVZ5VWpJ?=
 =?utf-8?B?aFFaeTIzcDMyVkxpUEI4RkJwUXU2TnpoNmY2SUhoc05pa3hlRzZZcmszRVJ5?=
 =?utf-8?B?c3NteHZYUzlmOSttTk1BMjNqQ01Eek14U0JjU3Zha3ROemxwK1dlMmY0Q3d4?=
 =?utf-8?B?dXdrdmV1UmFxckN0ajNJTklmUkt3dFpiY0pFVUxqV25mYVdOTnU5azJjRDgz?=
 =?utf-8?B?b0tlZ0JXeFdkQmlXTTVCdlRyTXlCNkpwYmQ4c2NIVEtRVDk4endNRkRCS0x2?=
 =?utf-8?B?Nk1KNWJQdU5uOUZ3dWliMlZrRHhPM1lDdDF5dnN5cXVVcFNFcEpCcG1GcWxE?=
 =?utf-8?B?QjRnaUdNcy82WXRMMEpXNFpDeXNCeU1jaGZWWStZeWc2eTNBd2JwRTFRazhz?=
 =?utf-8?B?S3VLRDA5VEFsZUNEbnc3cGhHY0Zobm4wS1ZBQXhRcDY1V29PNTQ3STRQWjdp?=
 =?utf-8?B?bFkrSC9YMENvOG0rYmxQZTFhR0dhZFVFKzU3S3h0N3I5Qm5KK0NiTlVaeFla?=
 =?utf-8?B?bnpSSFFxcFc1bU9YL2tHcnJjN0wydW9YalY5aFJpYkVvSUlPa3hWbEU5dzJL?=
 =?utf-8?B?L1IvaTlqM2c1eFFiVnRFS3BvVHY5NkZHbk80L3JJYW4wOERVQ0xwb3JIRFVS?=
 =?utf-8?Q?HRrdbMUvDdZ+WY/PzcNI+7o6D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 953798fd-dc52-44ab-339a-08da88bfc6c5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2022 06:37:28.3946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pohgdArPbwEqlF+vJDlp0ahLo+l5nJ5Y5fDvqCh3Kkx9ohbuHHcEVbLg1bWeZYW4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5470
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-08-24 5:43 PM, Alexander Lobakin wrote:
> From: Saeed Mahameed <saeed@kernel.org>
> Date: Mon, 22 Aug 2022 22:55:32 -0700
> 
>> From: Roi Dayan <roid@nvidia.com>
>>
>> Move the creation of the rules from offloads fdb table init to
>> per rep vport init.
>> This way the driver will creating the send to vport meta rule
>> on any representor, e.g. SF representors.
>>
>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>   .../net/ethernet/mellanox/mlx5/core/en_main.c |   4 +-
>>   .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  53 ++++++++-
>>   .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   9 +-
>>   .../net/ethernet/mellanox/mlx5/core/eswitch.c |   1 -
>>   .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 +-
>>   .../mellanox/mlx5/core/eswitch_offloads.c     | 112 +++++-------------
>>   6 files changed, 90 insertions(+), 94 deletions(-)
> 
> [...]
> 
>> +static int
>> +mlx5e_rep_add_meta_tunnel_rule(struct mlx5e_priv *priv)
>> +{
>> +	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>> +	struct mlx5e_rep_priv *rpriv = priv->ppriv;
>> +	struct mlx5_eswitch_rep *rep = rpriv->rep;
>> +	struct mlx5_flow_handle *flow_rule;
>> +	struct mlx5_flow_group *g;
>> +	int err;
>> +
>> +	g = esw->fdb_table.offloads.send_to_vport_meta_grp;
>> +	if (!g)
>> +		return 0;
>> +
>> +	flow_rule = mlx5_eswitch_add_send_to_vport_meta_rule(esw, rep->vport);
>> +	if (IS_ERR(flow_rule)) {
>> +		err = PTR_ERR(flow_rule);
>> +		goto out;
>> +	}
>> +
>> +	rpriv->send_to_vport_meta_rule = flow_rule;
>> +
>> +out:
>> +	return err;
>> +}
> 
> On my system (LLVM, CONFIG_WERROR=y):
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>          if (IS_ERR(flow_rule)) {
>              ^~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:489:9: note: uninitialized use occurs here
>          return err;
>                 ^~~
> 
> I believe you can just
> 
> 	if (IS_ERR(flow_rule))
> 		return PTR_ERR(flow_rule);
> 
> 	rpriv->send_to_vport_meta_rule = flow_rule;
> 
> 	return 0;
> }
> 
> ?

thanks. missed that. i see the series got merged so i'll send a fix.

> 
>> +
>> +static void
>> +mlx5e_rep_del_meta_tunnel_rule(struct mlx5e_priv *priv)
>> +{
>> +	struct mlx5e_rep_priv *rpriv = priv->ppriv;
>> +
>> +	if (rpriv->send_to_vport_meta_rule)
>> +		mlx5_eswitch_del_send_to_vport_meta_rule(rpriv->send_to_vport_meta_rule);
>> +}
> 
> [...]
> 
>> -- 
>> 2.37.1
> 
> Thanks,
> Olek

