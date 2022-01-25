Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C26F49ABC4
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 06:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444656AbiAYF03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 00:26:29 -0500
Received: from mail-mw2nam10on2097.outbound.protection.outlook.com ([40.107.94.97]:5555
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S255359AbiAYFPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 00:15:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5sVr0XhNoqsL1JOEq36qZb8WLhQ1brNSw3tjyDGUgbuAcH9nH9JTNRO/IpKQUMzUOUHsV/XXdgGyq2yIhv/+hGbOqRiW+adlJx5ggfeYvp+WKLYxmQpSw04XHDOyRf9Rl66eOYEcjflIwtyKEo41vgGNPlvdgL9oOOGn2ZyhPq7xuUoyB76+MuljuPmhSja3ai/tSHp8KNsqwtikerp27A1anQnfF7nvkbirfMYoFXKOmiK3FGwQEkkx9P6cK87VfUlzUFFSwtx16idAHbCSEEq3uDLRwbFbRx9CY2ssP2UirGe3LAs7pNKhamBxeh2+R/fDKrnhERvwe7hEev8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5jCtvJKfvLhjs0XtKJn//c5Gjg+uGL4YL5A123l6Zc=;
 b=hDnrONo8EOClGEke9CpY6P1ZAhBGClmjqUQcOJMXaXIiK3Bg0SK1nm7eYUnwDBy+t1DEOu+wNKn1YlJCMWAK/hITymJyy/p+F4I6LMR+/rcpYD9ulDyg3x+BcoutLxhcoFADszNIsyL8o1m6q9822wk5JQ5aG5gXWvp/CeZ1R8usGcmchhiaGHpSnVVvOb5WKNSTxxHyt+8bg7XOiTLake9SOfodVySph2/m47M6L3W+rwdeRaq0McEeWsOK1hzQEAwWbxLc9FtdTtRypgtnYaxWigRjI19sj7SYMQoYPLWBEIzfkBDdC0DbhQwWl40HYLWWQJ63ufUsiekK0jvonA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5jCtvJKfvLhjs0XtKJn//c5Gjg+uGL4YL5A123l6Zc=;
 b=Lo91rc2M24+r0apIc0NdpWQ351BGqtGEkk6g8BhM41Z7uRcqWJkxpCiVd7+uDuo2lXYiRUQnWRZVbmK8qsNBDia2LjrgR58gYUK6mBe/cm4rP9j1TYEruf1FX1XSAavNH62/kfB/nOQMJPS4U62vBXbYijjq1uALuhBENXb17mU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN7PR10MB2707.namprd10.prod.outlook.com
 (2603:10b6:406:c9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 05:15:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 05:15:27 +0000
Date:   Mon, 24 Jan 2022 21:15:22 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: cpsw: Properly initialise struct
 page_pool_params
Message-ID: <20220125051522.GA1171881@euler>
References: <20220124143531.361005-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220124143531.361005-1-toke@redhat.com>
X-ClientProxiedBy: MWHPR12CA0062.namprd12.prod.outlook.com
 (2603:10b6:300:103::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ba1d5d5-7745-4310-07ee-08d9dfc1b2f4
X-MS-TrafficTypeDiagnostic: BN7PR10MB2707:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB2707132B337365CAD1B6227EA45F9@BN7PR10MB2707.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /2ZKI/YdY8mU4cUcY6KvsCkyZT/jGNZktIf0wPxR4xt3HF8CnQ+a0tBZUeNdCE6m3LbqaB8i1oGdQayvg9gV5laZGpIy0gUKjKc7RjZ6dau0aTMvDLYCjOB4pfEjd0EJzTFkLD1s6y7WJOCURkLZT7m3DhH2DmDySx2aWFJNXSib1Rm1BGXkdqS4Su1iV5+sN73yI+/gpuYpPqZ/oX2zGgayNcGjzLs8phYZpoKtLnXN0LSLSXNjag2uLvlBNpjDbixBa/ACZa4UR5xUah5Wrn9Y7sAoDiVrR97OwDbSVwUEwqr8H0N1CDsxiF2cpmnXAoxeunHS80A2VVB9KoJz89ltVdKPGKJ/ZKVOeQQ2cmKBf10GLb7rWhVHRSucTEtsRqhCeqjDvjoi422WmmC5yit0vLsXZiZnhvIxC8jw4aEyMHmdepdOfaGv1QdjNU57iJy6b8BIaC0Bs9pQ6qKC/k7syqwCHZizcsPbYt/70IHSGs00cFXTNDUqkQiFe0BUfm/+yzm1Tlo7syU8sNRI5i3czy4ZimAY8oGmes3XB+opCEil05h/Jzy4q/R2gm6QJjYuwuNrHKWMuGJdf2XkLCVw3iyWqxgWggMXbN5AYdTu9LCGXB4TS65FGHLAuJANfviydpFomlTbENqWZLqiuF13HxRiFx2e643tqbymNy/TGzxtkmyKfm8ub6cTtlgqQfCwlXgn0Il9cocB/VlHQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(396003)(346002)(42606007)(39830400003)(366004)(136003)(376002)(8936002)(66476007)(6916009)(52116002)(66946007)(66556008)(6506007)(5660300002)(38350700002)(38100700002)(7416002)(33716001)(6666004)(2906002)(4326008)(54906003)(8676002)(316002)(44832011)(33656002)(508600001)(1076003)(66574015)(6486002)(186003)(26005)(9686003)(6512007)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sng0NTYrQzdBWk9vanEybnVGbDExNGdNdkkwWjV6d0NHaWdwTUdscnJMVXFX?=
 =?utf-8?B?WVpIN2RIREpwU0hPQ29Fc0w0REZjdzF5dG5uWlB1WjBLTEhwaXl0Z2h2ZC8y?=
 =?utf-8?B?ai9pcFUzOHBKS2pGWXRJTkl1VUhLYW5RZkwvanJHOENlbFBFa2dza3JtUmkz?=
 =?utf-8?B?WEE5V2F1RjBzaEc2YTE1dmlEeC9aLy84bmhiall2d2kzai8vZmt1NlU1bjVT?=
 =?utf-8?B?dlMvcFF1aWR1bDIvSW56c0VaTmRURXZ4QnRaYnFxR2JYMEdlL0NoaDVuQWUw?=
 =?utf-8?B?MUFmTEVzRnFHYnJ6RXp0ZUlrMHpiTisyV2d2a3M4ZExEbUI2eXJhRjVZajRJ?=
 =?utf-8?B?c2pad3UwZ3M5UzBGdUI2TnVaRkhpTnZiSU9la2IxZGR0MFZEWTk1TXd2RGRW?=
 =?utf-8?B?c1dJUzdrcGVpMkgwelUyelgxai83ZC93ZHNDbHA2bTk2VUFYTTVjWll5aDVo?=
 =?utf-8?B?S3czeHpSZjNGYUdMVjVNalZEYll2QVBoYzZVdEJtUWk4WiswczluMmM2UUZR?=
 =?utf-8?B?OWpJU0lEdml5U3Z5T0pIOGhnODNscW9mRmxhZ3VURHJqOFFjdHBENnorNHp4?=
 =?utf-8?B?bEVHQzVPaVJJeXcxUzE4bHJ3OVpBNjM5bFI2YmhmL2ViWnRveUwvVU9adWlS?=
 =?utf-8?B?d2lIc1VKU3NtenVIVUZESXNFaXNFK014QXR4TW5mdHBHWEY3Tnp1bGFQZ2dT?=
 =?utf-8?B?ZTVuODkzY3dBcVVLN3AycGtEZi9PaW42TjZacHp2ZXAyUFVRR3c1VVBwbFB4?=
 =?utf-8?B?eUs3eG5pNFBpL2o0VjgrZWxwQXZYTzZCbHRxNkFSOVJNZlBXaGF6b0MvbTJi?=
 =?utf-8?B?QTF6K2FialJyb0Fybjl1ZjR2RGZZQTkvRGE4VVVqcjFmZHBtNEM5NGhhZEtu?=
 =?utf-8?B?VU9jT2U1VVBBZ0NBTlJPRE9uVmR3NkZYYmt4N1hPTEVOZENyRUljbTBRV2FH?=
 =?utf-8?B?SDdyc0VyZ2RFeHlZNUdITjBnUG1VMlhUZitGN0NGM2R6RmtSSEk2TjNQVHhp?=
 =?utf-8?B?QXlCRVgzdXZrM2xyUzFPclhQUFZJT2lXSUVKSUFRd202RE9uc1VxUVNtdDYr?=
 =?utf-8?B?UGZzb0pTVUJDd0xkQktWaEpUM3Y5N25lVUxuYmxENXg1MmwycC9PSWpHR1pU?=
 =?utf-8?B?YkNjMHVGMXA2czdOSmdYUXRoOFBwU2VDZEFoSWlCdzlkUTFUUVpkRXJQZXFw?=
 =?utf-8?B?QWp5T0EwZGViNVE1UXFRVWRMNDYyYkxFQm1JcHBhMXlJdERrMG8za0FYWmdT?=
 =?utf-8?B?czFpcmY1bVlpcWl0bVJkUDBQOUZTek1yWXJraVI5NXhRUlF2UWl3ZEJXZWpp?=
 =?utf-8?B?LzluOTY1dThsa2NzVGdXR1cvdDFnOFVWTjFLcjlxVUE1K2NsL0liSC9MQmhx?=
 =?utf-8?B?eDZPVVFXdEVVaUhQejlNeTZXdmJIOW4xNTdNOTdnRWJ2SWgyZXg5b0p5N1dt?=
 =?utf-8?B?TGlZTzdQdjVkc250cEU0SlFMVGE2RmZxaG1zU29yQmY2cklMNjUxVVVRelpS?=
 =?utf-8?B?NHRYVVhxWXQ2WllXK21DYUtVQ3BTWlBBb0U3REtHSHFnVWx4NC9SWVMzZ2p1?=
 =?utf-8?B?WnFRUTlFRnBXRmNmQXErT0UwRlhGRVhVZXB4bDJHTnRyUkNVSTkvOVhVZE41?=
 =?utf-8?B?THBNYTNLWUN1QWVjRk1VcytrbWx1QjVxUmpjajVZbTVDN1RvZ214VDhnb25X?=
 =?utf-8?B?RGIzdkR4RWt0eUJnRXE0L2pmTTFnL0NmUEJqNWtNNmMwVnRwdUF1Qi9HOGF4?=
 =?utf-8?B?MzNveGFVcklxOVVJNTVIQ2xGTlZwVkJ6RFc1eENrNW9EVlAwTThjdWg5WmJk?=
 =?utf-8?B?WVVHZUs4dDZqY3oxOExLb0hCRHdsYnAxN3ZGNklEdXRQNzRhMFRJUnhKaFJ5?=
 =?utf-8?B?dUZDMnFodjl4cm53Vy9idVlCTWdlV3M4d3Rxc3FCV2M4YkxhbEtaRE1UdHAx?=
 =?utf-8?B?VVh1N2NxRHdTZUpPbUcxS1d5MFhlNEhBMkNYN2NQRC9UYXR2QTRNSytoUFNq?=
 =?utf-8?B?Z1A4UUxYM2NPak9WSjkwK0JleDEvWUh2U3BzRjlURkxvcVp1dFNvU2N3cTlJ?=
 =?utf-8?B?TFQxTENRdWdNTkZ4U25wUWV5WFpGRE5PYU1IRlArUStTM0gzQVh0Z2ZEQlJk?=
 =?utf-8?B?Q3FuaHIxZU9KUjUzSVJsSEVnOGhXRVFyRG5CSklmMnZpdnBSQW83NW5uU0JR?=
 =?utf-8?B?TmdJYkNoc1oxRzR2SmxPQTVWY0hwVTYvNjl2dkU1T3lXWXZqMnIzYkRVbFY3?=
 =?utf-8?B?TUp1RGpjS2J4Tml4dml1enp6ZmpBPT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba1d5d5-7745-4310-07ee-08d9dfc1b2f4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 05:15:27.7248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DD0ITiL4GsuwjtcM/sQOzlqLwCv9MfVwgMRCKHxi1sntTmsVYhbbkj0my+84RzV7vH5KB/COMdf/+YyZu+n7GCHJKBmy1QppZCbdPIR6We0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 03:35:29PM +0100, Toke Høiland-Jørgensen wrote:
> The cpsw driver didn't properly initialise the struct page_pool_params
> before calling page_pool_create(), which leads to crashes after the struct
> has been expanded with new parameters.
> 
> The second Fixes tag below is where the buggy code was introduced, but
> because the code was moved around this patch will only apply on top of the
> commit in the first Fixes tag.
> 
> Fixes: c5013ac1dd0e ("net: ethernet: ti: cpsw: move set of common functions in cpsw_priv")
> Fixes: 9ed4050c0d75 ("net: ethernet: ti: cpsw: add XDP support")
> Reported-by: Colin Foster <colin.foster@in-advantage.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  drivers/net/ethernet/ti/cpsw_priv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> index ba220593e6db..8f6817f346ba 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> @@ -1146,7 +1146,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
>  static struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw,
>  					       int size)
>  {
> -	struct page_pool_params pp_params;
> +	struct page_pool_params pp_params = {};
>  	struct page_pool *pool;
>  
>  	pp_params.order = 0;
> -- 
> 2.34.1
> 

Works for me. Thanks Toke! Hopefully my tested by tag addition is done
correctly:

Tested-by: Colin Foster <colin.foster@in-advantage.com>


