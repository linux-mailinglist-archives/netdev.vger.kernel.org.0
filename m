Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1996C50F0A8
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241789AbiDZGLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243997AbiDZGLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:11:51 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2074.outbound.protection.outlook.com [40.107.95.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B531299E9
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:08:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUBDDLn0gUvhCCLiCdvyhA6hawbhkuigwIeg/DJ9MUN7s0mfZWQ04YWzPY/Jnv6wXkqSduiwnI5PIlf0H2jUPltQUR+LNlg6+Oe5yJs9n1NbwbKSDZHC80EkiqzEfii0oD0fWjmmJIfyCeAtH+wTodXxKl83FBtHK1TStdq9s2MiwU8VE5cSmJVauAo3+G7zy57WxpzWuh1yDcEWDJu2oi/p2OOwBwXzSIrM7Qf37SsUx5G4JSomO55brf5vnxz6neu3k7pWZfsz2EwpY2HVbd7zs1EL8LiU09ygEr6xRkfdaWcxiuWmlSRFQtqok9VpmvIOacLHlZD4hEeiIgS5XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gwwdVhgaKWyx6F/Ptx/tL1s49QPhjjkKaW4CFXVgrE=;
 b=f7U/M2/TY7CKWXPyCMY6yMsSEqoLZTTFmTpZoMTv3VZKksraZxvfUZLrxAjnn10hvDaPWpM3+elnLPIGGLXp43unwo6wEJvlkoH5rSpcml7VOCFrWa2dMfxAt8Tz97XGzMmkDNwWG+eGODzB1QhvU2ULhSYxc+0ME3becNCEow3HdLHaLPNVaSsIp4POp+ZP3zbC6viUbduG1Aw5t3WtrzWe77a/fHgAAqnM24F7/8zgFE+avkPHttTjyPGwSwzrN+cW4Y/8MBORqqqeg/DC+fzcfef7HnSsz2d4LI+5OtWqNFAwlgTYOUTMuqyGJkfpEXqauNrwx5H90qlf8kxpHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gwwdVhgaKWyx6F/Ptx/tL1s49QPhjjkKaW4CFXVgrE=;
 b=LfooBr5dIkjxmB9ln6P3yngWR7dr+s6XM+dpUKLCJFSKv2NGq2USMa6hhW4DCwap6Nu/O1Snul51EGZaC/laREs4a8AWwHT2UfOJRII6+h7stvRMZToapSmZhAcn9uqwS6FSCNLhTBbKuzecDYncldSUPWeK60nq1P4KChgovxtWhfgL9BAN4AOmgpYpztiaCvIG6Xv/yUeXIefeRiV1WZLrakA3X5rZdv6Xcv8pk6MQt+u83JA2COHrJoIT/m8mMZAXdebhtMjf2BvqfkjPbpigCjHGn6M8mirB1iPd3Z1xlS3pCsu5WHNx2pxsd8k+el8oP0rj1kJOgc57dqAiMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by DM6PR12MB5517.namprd12.prod.outlook.com (2603:10b6:5:1be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 06:08:42 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::dee:5e8a:62ef:3d21]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::dee:5e8a:62ef:3d21%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 06:08:42 +0000
Message-ID: <2c5bce16-eac4-a060-dbd8-62cc67df1bea@nvidia.com>
Date:   Tue, 26 Apr 2022 09:08:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 08/10] tls: rx: use async as an in-out argument
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru
References: <20220411191917.1240155-1-kuba@kernel.org>
 <20220411191917.1240155-9-kuba@kernel.org>
 <01081d46-249f-a081-f130-e0a09180d4d3@nvidia.com>
 <20220425075438.6c87e969@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220425075438.6c87e969@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0246.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::17) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33177699-77e1-488c-0c49-08da274b36e9
X-MS-TrafficTypeDiagnostic: DM6PR12MB5517:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55171BBDE281316011E59C4BC2FB9@DM6PR12MB5517.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cozHPsYn1DFgUjIC97aaqopXRm9prBLrBYFlqwaBZTcCJGexoSpROr2SIdn6HGVNw8LxhdLAALe2KzNvZo82LiZ4aVC5VdMGGGho3JwEiuyit8/OFwsZU9Nku9kTdTNKgVvHdgL8awXjng+pLv/zlP1dbxQ3iQ1eU1llVeZTBen9wdy0puQRNLkmvvEuOqpa22wU2BxoJrPmGeZ1vDFFRrBHvf4TW+D73zB34iUayIaiUfdD9r++aAS2AWmh5tPsHb2638TeaAWwK+hMDUsN/ejeFYn+qiHkNYLzX2Vo5DG96HCSzMBxQAtzJXx6QGb3ENnaufBUGc52HFOkhbgpxmeGGig+vlCFRYyL/B4J2xfGHClqXwDSSAnZOySyHTX1Yw4UyvLOCWJHuCUz81ut57yzF8ccWD9LsMJtKqkPSJ4bxRKCU+Q2/MimYjqOqz4rwj5n7RK/qwMqRoaer5qprI0a85CsweoGr/kpgEgHikKDIgBfHLtErds/uogENmHKFe7HBLYjIoeD0Vg1d/TTvnySBsun7AdjcmUUrWZbe8G2dxcevQ6cdV7rWbP1gEzjwn1uizPqwM0MvW8uasGNjqTE3iouwA1ISnFe2vUJiGxiCkZYwxAGZnyzL+t+QwrBlSJuWZXKTAQwjaj7ktngtZ7OCfXFMwqA6sU3hX/IEo67WhmdLLd9ipFxLmLRK7+BuvC1cX+cnTuQ4ZvREGS9+ggsI5ez8QNVF5vV3wkRzN0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(6486002)(2616005)(5660300002)(53546011)(8936002)(6506007)(31686004)(83380400001)(186003)(31696002)(86362001)(26005)(38100700002)(6512007)(6666004)(8676002)(66556008)(4326008)(2906002)(66946007)(508600001)(66476007)(316002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEt6Y01RcjlhSTNCMElGY1FWOW1jcGM5UVYxZUJOUlJiSFpscDAyYTJuRWRo?=
 =?utf-8?B?NkxVMUtHVWNway9QWUhRd3Biek1kMCsvUklkM3g4RDJFUXMxNjFOM1dQOE5t?=
 =?utf-8?B?Y3lQclVVdmVTTEJnWFRHZjRWSlg3UXJYajB3YXhJREtvS2pKMHdwNDIvbnJM?=
 =?utf-8?B?cUtJb2lKK0hXaTQ5TFAzbkVYWnduUFJJSmlBZlZ6R2p3eDFVSm44VTllVWYr?=
 =?utf-8?B?RFN4TTZ0am1LTmxTb00vaXFjUVAvR0ZhQ0JZK1d6V0ExNzgwTG9QbHFlaEFX?=
 =?utf-8?B?YzA1d1QvWi9FV2VxQkxhOExNU3BFK0xETDl4cW54Tlo3bEdoTnJaM0JGTVhr?=
 =?utf-8?B?K0Mwb0ZSWmVRUnZ3RlFwbWJXWmtzSFdHR0xBc085aVZxSHp0M2c4eWNSRDMz?=
 =?utf-8?B?OXY3eGV5QnpHY1lYSDlTd1phdDlQSnhISWJMZVlGdnBnTmVsRFRuOHBSb1VO?=
 =?utf-8?B?NFhzRTBUWXZBaGNGTmZKbXBTSnEyVmpqNzh1ZFRkcy9Ibmhja3R1M3ZRRGha?=
 =?utf-8?B?SU1OUm9ncFllTEE5SDVsMTdQYlVHeHBmd043bDJLK3J0NGN2ZXFVY0N3RmJz?=
 =?utf-8?B?blhheHQ3TjhFU2lIc0NCVE5rWkZyWE1YS1Mrb1MvVHZJNHRPcnZ1ZHUxVWhr?=
 =?utf-8?B?RE9lbXM4NlZnNFBCNG5pOXFYSjROWERQRGtRS2NsaGZrMThJR0t3R1BYa2g1?=
 =?utf-8?B?SGh6U1NEczNkYmlvWWVJSi9lWmFrMGNNZ0FMTmNRYjFYOW50dDRBdlJ3ZC9h?=
 =?utf-8?B?RWhVd04vL3Z1NUZuelNIK0hHekRYOUkra0o1MXo4ZFNIZkdNSkFLSVl5RkVL?=
 =?utf-8?B?ajMvOTRiZm9xVlVLL0FMRTVTVzljZDJLVWwwY2IrbnI3OXAybG1CcW1RVTNL?=
 =?utf-8?B?RCtSUEFiTUo1a2xJM2JJaVVtK3ZIOTlJK2oyY1oycWRHYXBOQnl4RFFuckdy?=
 =?utf-8?B?anNLYitoQlNrSmEzTVFzNkdwOVFoeUxuMW15dFd3cEgxRno2QTNnVXBaNnFu?=
 =?utf-8?B?VUMyM1NqYWpjQmpJaEsvQWttVTFsdEhxM1NEMXRqR1hjNVFMd0hIN0xhVXht?=
 =?utf-8?B?NFlGTHk5djVlTFIrYXhMY0UzaFlHaGZXQ2FHOFFHb0NNVStkeUlmNllZb2pD?=
 =?utf-8?B?UVY4TTBsdHhpWUIxT1lRMjNIdzRJSUQzcDQ3NUZzMnZRWHcwaUx1NWJyNzhs?=
 =?utf-8?B?L1JtQ1pwVHl5cm5KcnpNdXYvdFNJSzkybmVnb0E4VjNsS3JOSTc0Ty94dHpE?=
 =?utf-8?B?WlowcXRNK0liWUw2RjFtdDRVNHdTdU42dFhwKzVsZXBvdEdVaThHUGg0b0Zz?=
 =?utf-8?B?SWJzTjNvVm80ckxOTEc0UlIwUnRLQWljSVUzVjFWeTZEZmdMWWk1WFFkZHFq?=
 =?utf-8?B?N3o0V3F6QitjREZId0JPNjBYdkVKWVBSajVSd3ptMWpzamVFMFZVbndOa0xa?=
 =?utf-8?B?eGhjRDd3SVVmQUI5eDBuK0RLTit0Nnk5UVFxMm1ybngxek9uUFZ3VFhIYXgz?=
 =?utf-8?B?aHRlUFV0eEk4VFA3Yi96ZlIvRWdUd2JQZWI3WkZPb1dSMlhZQXk2Z2dxRHpt?=
 =?utf-8?B?enNvVlZJSzQ4YnE3eFdMbXNWK0FSU0t4WUsvejEyNDNWcnpNd2h6TURSNkVS?=
 =?utf-8?B?UE9JckdRZlgzUHFLVjFzQnd0QjRxQm5xbE9Vb0dDWmpxczVkZzVhZGJwV0FY?=
 =?utf-8?B?QmtlZUxVR3N3dm9VK25Rc1pWTXYwQmlaOGJ6MUZocXJtYmlza1ZKaXZ1SzAz?=
 =?utf-8?B?RVRiNTBlUXAzMlJpNGlGdUFxdkdvb2hINDJ1VE5JeW8zdXM0K2R1ZjRWeWJv?=
 =?utf-8?B?ZUNFZDAzZ1dPMno3VEQvT3Vmb3l6eWdJVmVkdEljMXB3ZDlhNktHVk5XWVpH?=
 =?utf-8?B?cGJNZStVYWpUakdkUUtxVDB4L3ZOVmM4UzNYRVdqbUdwdW9La09mbXpaWS95?=
 =?utf-8?B?ZzlVNUpMeW5oMUpjNkRiVzRWOVB3Q0R4bEZWamYyblB2VHBON0lQUTI0czhJ?=
 =?utf-8?B?Vm1vSVFTaVZ1aGRCNmwxNmg5Q01LREtwZ2o4U1pKamIxdDZmUTN1ajBMd1R4?=
 =?utf-8?B?UzJkdXlEUHdTeXo1NFlZTlBOQ0F1OXpUUjdBamdTVjJtQWQrZm9ONXc2bnBN?=
 =?utf-8?B?bU1xd0pMS1ZuMkJrVXp3ek9JLy9hdldydHFSaDQxY2RrNFFuaWswY0swNE5u?=
 =?utf-8?B?aU5uUklwcVI0QTlqK2FqM1NTbTNoMXdNTk5mWVVpb3g0NUFNTS9ZMlJleW1y?=
 =?utf-8?B?SStCQ2dlVDlOWE1ZeWRESjR6ZlBoTUJ0a1BNK1NHeGtWR3lBd2t1UG5xVStC?=
 =?utf-8?B?OGNLVGVwSlNMdThNdTJsYlcrbzRiWktuUGF0ZWoyZXJoSTRqRkVLUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33177699-77e1-488c-0c49-08da274b36e9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 06:08:42.6587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ydrfRnh7ZyWZQkl/hjgyl08fERjl2O+HyfQkZs0ZSMWqZ2pCghWNvXyMBXhd9oTD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5517
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/2022 17:54, Jakub Kicinski wrote:
> On Mon, 25 Apr 2022 10:19:45 +0300 Gal Pressman wrote:
>> On 11/04/2022 22:19, Jakub Kicinski wrote:
>>> Propagating EINPROGRESS thru multiple layers of functions is
>>> error prone. Use darg->async as an in/out argument, like we
>>> use darg->zc today. On input it tells the code if async is
>>> allowed, on output if it took place.
>>>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
>> I know this is not much to go on, but this patch broke our tls workflows
>> when device offload is enabled.
>> I'm still looking into it, but maybe you have an idea what might have
>> went wrong?
> Oof right, sorry. When packet is already decrypted by HW we'll skip 
> the decrypt completely and leave async to whatever it was at input.
>
> Something like this?
>
> --->8---------
>
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index ddbe05ec5489..80094528eadb 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1562,6 +1562,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
>  
>  	if (tlm->decrypted) {
>  		darg->zc = false;
> +		darg->async = false;
>  		return 0;
>  	}
>  
> @@ -1572,6 +1573,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
>  		if (err > 0) {
>  			tlm->decrypted = 1;
>  			darg->zc = false;
> +			darg->async = false;
>  			goto decrypt_done;
>  		}
>  	}

Thank you Jakub!
I will run the patch you sent through our testing.
