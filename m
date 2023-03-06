Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12F86AC5F0
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCFPw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCFPwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:52:55 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2090.outbound.protection.outlook.com [40.107.96.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7555BBE;
        Mon,  6 Mar 2023 07:52:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTMhpxEKVgA6wIMPlAfog7HCAqPmeA7orUtwPtvdkpwsZuqG4sNPgYs85xKZLZ3AjQbFiiyrhzT1P06YlEKtceP/YGYKa7rs+8S1AQLgWLnr4/srLWHMvTFn4r0rHH8l8Rio0Zf0CkObqKRRjEDiDClhyOqDiyXU4f1rR9m6h/ULLmeeO/n5iSobsUM8ikL6B4moDp3btvWg0m9yCkYUrrxkDXBBwqRQxbB0BchFWLzptYS2DEZSZMftz6ct1ch8x4FZQ0k2G3HdI4bFnobyRYxxR3cV1i8E5KzeTrSum6vQrPO0pVcLzprl7zi/KTGyGYaindH16uFZvcx1wXlJYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xU7RtzzEx6tVgmDsC/p/kakrUDSzxqQr8uHRvjrGjQ=;
 b=bqXY7dGBzjwktdTDonbzMFDNm99krKertNZDCasV55JuQITnPi/PcqCNaJZbchGFzr68M4ckqiw/j6r0kIhmdKm8PO6yr2bk17LgYF8pJ10o8+xkC/L2pt2BdGHeoKZgMsmiMIGO1R++sqNhE+QUljT7dFGMHD7HOrToF1U4tc89NT/+FA61kaaf3SWa/hkbZmI5tFFesZDEoghQ/URbFnQtti0P8ZCBxlsdjG5SWgFzc6bnftJOxeuRVLr/iggeOYHQfFFYGDxiiln1/jM721bCiwGKulPqHyp0ri/0JMO4J2zVx/ERBBYaehoZJ+SYaSoTFeQZG5sg4uMnWfgURA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xU7RtzzEx6tVgmDsC/p/kakrUDSzxqQr8uHRvjrGjQ=;
 b=A10WxFi8qx1SDtudAJhp24cNnccnYDPka7dk0LRTIk8vuy2KQBK7S55OmvaScFZ6Iu98lyFVrDIh+3jBr8/j/IxQR9EtSh8Brsens8tHKpmgW4WTsAplK9hrJaezBVMpItlEXqOCa2ViGJczkfz1tJnQGa5CVMlzl1g9mWqMsgo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3716.namprd13.prod.outlook.com (2603:10b6:a03:225::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 15:52:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 15:52:49 +0000
Date:   Mon, 6 Mar 2023 16:52:41 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH nf-next 1/6] netfilter: bridge: call pskb_may_pull in
 br_nf_check_hbh_len
Message-ID: <ZAYMSdMIPRt4ipBi@corigine.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
 <4c156bee64fa58bacb808cead7a7f43d531fd587.1677888566.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c156bee64fa58bacb808cead7a7f43d531fd587.1677888566.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM8P190CA0030.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3716:EE_
X-MS-Office365-Filtering-Correlation-Id: fdfb2990-2fa3-4b51-129b-08db1e5ad5ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUsEe+OOwk+uQpc7Rhxv3hwLa+A4dt6Hh8qYx46A17gI+xR9w7xOv4RSiOMgHnI028dwiSU6eZ8cPrZYavh/UFL/3N1Q1Z/7ZGch9rhsWEahWjOmQ6tvBEbM1LVhXZabG0BelyH9RSpehJvW5XrajjL4dEbXDPmbAvU7ntZu4UHYfx0rVJQSHoDDBw9hVbyq6ZdsvkNu517Uos70pkm7Jja4azjqb9n3LRLwCKhbV6SFKe6AW4ZbZ+SGsDmul7IKqn2EVb8WPNfoXQcvs53DbcztxzSTAfzJ2idWsDqNQR7cLsH3wgfK1cs1o0tzPh5qp8l5yOqvI5V1OPWo2PMhpwFgzO+kczIfRcWpMaO1IlwetOqvry0MDlL3ZDDHnTjB0uib7pIjX1i1zCjE5Au3LF4QSXsyPE3p39jUbmEuIO9i4q+FhH0Tx0u3yicKKoSJFqs33Kmc2xgTBxbklPUral1/zcD8iACUVr3sswesnU8Pb+QWpzWog7ZeKR+eP2yzMHt3Q8AmuAjOs5P+qAyNL3a8UYGs6HGwSQm+6jmozEb+ekF3NtoJluu6+7OfA+v34KNtxlhmHePHNUc2Xxox7Ler9WPtOuyx782Mt5e2zFvftsX3nRg6h76Vg00BaAvjzzqGfuz80nqfGFujrJNXEcJvh3tjmSb845iquAJQS+EYBSC3ZjvlAhuT7HWGmpGh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39830400003)(366004)(346002)(396003)(136003)(451199018)(86362001)(38100700002)(36756003)(44832011)(5660300002)(7416002)(2906002)(4326008)(66946007)(8936002)(66556008)(8676002)(6916009)(41300700001)(66476007)(2616005)(186003)(83380400001)(6512007)(6506007)(478600001)(54906003)(316002)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hT3la6gh1vJBWWV9ezw+lzxGJj4nkfwdAj/u7nrabOK/CGfQy/Pn0KQNeCM8?=
 =?us-ascii?Q?Nqm28lu6Sl6XbBTnQbYo8/yqelsxj2jO6D5BpOaGyr/8cV9jN3Uij0wEuNgm?=
 =?us-ascii?Q?B5RAfsWDBAuz0rnFk9FPrpL539WoChvQNlMdDgv+A0K8/l2x1tFm/RJQ3B+F?=
 =?us-ascii?Q?wfWYqGXdG6YUwIzn5/vkyqzI2cKCZYEk7mX/ppZAzUyPCB/7H++3P2pch5bE?=
 =?us-ascii?Q?Em3M1IciO9sCEz/CNoRwjVKZY2Z/LxqU4FmsoKLH2Z+7jsD4B3cCFviCgR+c?=
 =?us-ascii?Q?4kBdJ/bICplZNk0We4prRN8bfxTUoKefwHhE42yYEv+yMfTAueWPJrxR0e+N?=
 =?us-ascii?Q?+1ES5NYAu8hN11yLaSwdiOzr7Zml1mJWiBnUbhkmD2ZVgfCMMZwiRORvUCYZ?=
 =?us-ascii?Q?sobVLstjs+Ir5eNrvaqlGMf3f6+OIpFsbrHzju36eETdoBK5ve/sqZ9/MBhS?=
 =?us-ascii?Q?phY29FENnWTJU3VcpdBfV5xOYtXZcYUalzeFLpepGPUZcrgFLjrF3rCZwuiJ?=
 =?us-ascii?Q?/bp4OH70T0YDGIxDHZpiYHkNZrugGYJvUr014XTBe+2/yxCHHJ3kWereVtfK?=
 =?us-ascii?Q?BmjObQeFztRZqWNIiXUPtSXjMZnfHh+g0Oww3/PAFKbqIrBlFy3AC8Jd07J2?=
 =?us-ascii?Q?0HcBAfdY3XMNP+y27EZRAj714JcQPeRRLZgVwdI9naWyn5v4j/GIxn+qBDRK?=
 =?us-ascii?Q?a6TuUIPFdyU/RRpN9DUklWb2g55jtCEukitB46bKvQ7GqBSspYfaLOfAaBuO?=
 =?us-ascii?Q?Je8kbr/yJDrEsyDmaR0Ppjp/RcI+rlDO5QtHjoEFbsSCxCt8ZvMipsauyn85?=
 =?us-ascii?Q?/H/QXnNYuogyy92wqTiwd6oQQkbc7LgrXaktebb68ntKRFGtFRglzkaQBRS0?=
 =?us-ascii?Q?Sh0bWsx0CZc7Om18GZ+ulW7r5nACxU4pnhZROy02MdaHibeqACSA1nKdKOs9?=
 =?us-ascii?Q?xoBmNC4xTAsp4nvJrtFsNG63FZOyfPZlG4zFwkfL/FsysEAG1DNbrflYXOg2?=
 =?us-ascii?Q?Xdd2Ze2ueS0p5MYZ59y7pc7z7chkWWPspId2YSjLOnJD2MFAdtCi5GYFXTpg?=
 =?us-ascii?Q?HcsAe8nPyA2ck1L0KMbMJuQbHrWcPg6WvQIF5fveaYE17Rsb0bgZWNZWxfGs?=
 =?us-ascii?Q?IOffYZTigULb3pnUWm9245xbY75P6L75pKyoweNz91wDMnhsLVqlWdSOWtPF?=
 =?us-ascii?Q?0xZFnuhRCz8274/ajdHZWfeEy5FcpAPoFQy02jhj6xJ4xQoRSd+/r5bmsv0l?=
 =?us-ascii?Q?8XSwfXEqMnHlsXmyq3AeAeXpITVFltQjJI6uHKsRehTHq2f6QfI8RM6nM8EV?=
 =?us-ascii?Q?7eIymU9NTF3mD8UVlmeVGgrVXieHYW457CcxRU1oRk7snbQeQEvm9IdHhmxS?=
 =?us-ascii?Q?uzAxHDEcaANQw8UnLeZC8LA7UI+npTzvKMA0o1BM1uEwx8jAs5vKVHchIq8S?=
 =?us-ascii?Q?cc52eLDkFKzP+oh39YWc2zc5ZoGYOPc+/0P5Jcgh/Zy0UbD8pBp8iZT6KgBr?=
 =?us-ascii?Q?+rR9Q96rpQsHuXxosRiCaxw2p2baWFgeqmtbcBIwPtMTz0tIfKVuljf8xBh/?=
 =?us-ascii?Q?1g204WW3fu+a1cPKfdrD82oJ110qNtOKvXKimwQaxWnkzUX6oeYbZyw9aSQC?=
 =?us-ascii?Q?lyn1RDNSotcMbXUYWmENVFiHuSnJeROrdEh/pxSCljfHKrT0xLF6dwOjkdIY?=
 =?us-ascii?Q?LQnjnQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfb2990-2fa3-4b51-129b-08db1e5ad5ae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 15:52:48.8455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+mKPJ0cIKch3uaVrkBQcEklCjhtOyOCJ32o5LhCuQC3sUdnGmNcKBL6o2XNJcdFg8dPwR/+6EU4pK4UhtErnJGoTDgyOoT+7APJJFoUxgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3716
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 07:12:37PM -0500, Xin Long wrote:
> When checking Hop-by-hop option header, if the option data is in
> nonlinear area, it should do pskb_may_pull instead of discarding
> the skb as a bad IPv6 packet.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/bridge/br_netfilter_ipv6.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> index 6b07f30675bb..5cd3e4c35123 100644
> --- a/net/bridge/br_netfilter_ipv6.c
> +++ b/net/bridge/br_netfilter_ipv6.c
> @@ -45,14 +45,18 @@
>   */
>  static int br_nf_check_hbh_len(struct sk_buff *skb)
>  {
> -	unsigned char *raw = (u8 *)(ipv6_hdr(skb) + 1);
> +	int len, off = sizeof(struct ipv6hdr);
> +	unsigned char *nh;
>  	u32 pkt_len;
> -	const unsigned char *nh = skb_network_header(skb);
> -	int off = raw - nh;
> -	int len = (raw[1] + 1) << 3;
>  
> -	if ((raw + len) - skb->data > skb_headlen(skb))
> +	if (!pskb_may_pull(skb, off + 8))
>  		goto bad;
> +	nh = (u8 *)(ipv6_hdr(skb) + 1);

nit: if you need so spin a v2 perhaps it would be worth
     considering reconciling the type of nh (unsigned char *)
     with the type of the cast above (u8 *).

> +	len = (nh[1] + 1) << 3;
> +
> +	if (!pskb_may_pull(skb, off + len))
> +		goto bad;
> +	nh = skb_network_header(skb);
>  
>  	off += 2;
>  	len -= 2;
> -- 
> 2.39.1
> 
