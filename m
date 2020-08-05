Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAAD23CAE8
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 15:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgHENOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 09:14:31 -0400
Received: from mail-eopbgr690048.outbound.protection.outlook.com ([40.107.69.48]:32910
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728175AbgHEMfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 08:35:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6XnXKpSL19dpTmDgocqdlACazX0goO/9q7XbIabXGeS49X6YvEhHQIOihqpRXZnUNHXzgav4ciTsppqfRAkkW/oWyzU7EA0+PWmnPS3k/LFQyCNpcgBJG2v2HRbK5pQKYItRBxATPwH+Vuim/0DvO8Ni/1lXB3t4whjoSFq4Ej8d/WqX9EiOuZ3kAML2ParuCFHlnqcqJALAJLw638ruBL4rPkVnZKuhEs8+FI/ilhZIthfNeGtyxqm2E9VtgFh3LhyguJNIWOrCmXIU0hbw4/9OLuAhSiR02b1SeqMvYLq/Z4qu7qLOw6sZy/q8xh9e54famajsKytcZCI94XayQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7skj7IMKw4GED060ZGGpAoLiHBBpVuy1AtExYSdOo38=;
 b=S9wMwWw0WJWlV3dqdC8SzOaC1HehnTwdeaTpYCuut4WiM8A+HI1tI5vzvYONP9PcCV9FVNtNoPMTK6GbvyZ646H8If3lDwEkqjZ8nXAAWaM+PgSbU8SPVCD65b3CbO07zmyUAMwcqOiwYKMuRaNH4spsV2HWZqy5OB2OCQcA4T9qmn5YkSv6JigB6EFxdWn3Z1Cvb/2ntUfLLM0oGCWRg9N6lo+KqzYKgdaqTHRFDoC96LAXPuQ6+9x8OWJu/3OgsJxQ1qvDd5HXxXDTN/7dSm4ATOOlz3uTtkLwVtemkz1AylzQ5BSXQay/GG5lM/sr6zpZir7I6RkSiLz2iDPTAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7skj7IMKw4GED060ZGGpAoLiHBBpVuy1AtExYSdOo38=;
 b=gyGsQl6teXavfebkP8B7OdM3vtXYZx7EP89UXckpRNWjagkEXDA0OYfEcwFEKowpPwP9hpALsVaaM3/uNCtTsRzaU1msnVU+j3rm3IJcE8LrkY3lCawLdKUC9NltfulaXgEgwjVvpw8rKqJkoVGKVFMlEy2RlsWp9FUHZ446/mA=
Authentication-Results: linux-ipv6.org; dkim=none (message not signed)
 header.d=none;linux-ipv6.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB2603.namprd11.prod.outlook.com (2603:10b6:5:c6::21) by
 DM6PR11MB2858.namprd11.prod.outlook.com (2603:10b6:5:bd::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3261.15; Wed, 5 Aug 2020 11:20:02 +0000
Received: from DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::b16c:41d1:7e54:1c4e]) by DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::b16c:41d1:7e54:1c4e%6]) with mapi id 15.20.3261.015; Wed, 5 Aug 2020
 11:20:02 +0000
Subject: Re: [PATCH net 2/2] tipc: set ub->ifindex for local ipv6 address
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cover.1596468610.git.lucien.xin@gmail.com>
 <1806063a61881feadcbf4372f2683114c61b526a.1596468610.git.lucien.xin@gmail.com>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <e6665465-f018-174f-6c83-9f31f8250199@windriver.com>
Date:   Wed, 5 Aug 2020 19:03:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1806063a61881feadcbf4372f2683114c61b526a.1596468610.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0189.apcprd02.prod.outlook.com
 (2603:1096:201:21::25) To DM6PR11MB2603.namprd11.prod.outlook.com
 (2603:10b6:5:c6::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.155.99] (60.247.85.82) by HK2PR02CA0189.apcprd02.prod.outlook.com (2603:1096:201:21::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16 via Frontend Transport; Wed, 5 Aug 2020 11:20:00 +0000
X-Originating-IP: [60.247.85.82]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc591d41-a84b-4476-4a97-08d839317f0a
X-MS-TrafficTypeDiagnostic: DM6PR11MB2858:
X-Microsoft-Antispam-PRVS: <DM6PR11MB28584DDE74F233F576F6714E844B0@DM6PR11MB2858.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dMly64DqYrT9upF1IQW63Po8OlIImXmamOwVXc0dhDUEeBQeU/vmpwowvjMQtIiFLTafWA4YQ95CBmaqtVaBAmzZPlTDGKwp7IgF8ZiEQ0uN/45Rt7QkCaDAy8LnOYW+01T0U1Fm7NbeVjO177geLQIsm85aWhQES0fRX7RGzv1Lghur8WL+OAVMkLElY1UV5bXdCiWLxjSuKiMcfAHh9FmmjRd65T0RWp8NRbrDtyNAfIUOStqmNlntU2BIX/HBrg1Td8grCH3qk5N/1JMKgY2/PZxbFwAGTXrV2YS6oe4TVNk5RxoSMjvK4h8C9EJaiwWAki22JoQCVZvYdFDPq2KkyWnbFX6W3+tY0+Eb12aj2x7bN1N8rn8GiYYh5+TXbI5bEy9ZbY9HHbgr594N7eZU003oG8XVB1eO60sIItQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39840400004)(396003)(366004)(346002)(376002)(136003)(6666004)(36756003)(44832011)(186003)(16526019)(26005)(2906002)(110136005)(2616005)(54906003)(6706004)(66946007)(5660300002)(16576012)(31696002)(316002)(6486002)(956004)(53546011)(8936002)(66476007)(478600001)(52116002)(86362001)(8676002)(31686004)(4326008)(66556008)(78286006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: S7Mu5lf7WEEttWSJofsl6VGzvXPFnfbg+IzlLIq9aUVBl3oS3ETwwEZ4pgseaILHnkQ/1zQ6Fk1vyk15HxuLg5GmmY+Ex2ZAabvbaOHUJiANF2E+Tf3YAvltQXRclbmho7X81q3otfhz7u9frc9eAaipVmc1FBItGrJ3nA1vpK2BYeRi+cwPoB3UYWqxrzmesPpoVft8pu4DKug9WhmB45pEDgXrra/HJbg6kQavCc7PhCvlDIwwJ+QCZVintApny/tsAni1/wC1ml0SCGOw4rTR+aM53fmJJ7xe7NVjU1hc31XRWCev8CAXA+nmHSzw93NxSsKumjfv/1K/dRMCdGGvbxhgHGH+LscGNlxf+ycW0/rDmyyv+mIac3a9rvuKTmYl+G9BRCd+ntoUAg2oEpkPuYEdvJkv/KkvaE/I1poc+ZXe5S4ZftoZXpQ+F5/Cvs8yopTUQtyE8fvLXtsTvVSmADnAM82onG3ja99nzDOlP/8IDNjd7dWFtBKLoW0TFQZGmjzXHV6G5Sq2ihv4To61CSeZnJ4zohz1q4jhb2x6n7h2L5B22rrZN3m9l4dYFeUxaE58/s5B2GNpRJ9lj9iWIB8FEFvDxquCWjnedfqU4r6w4tOAGKxhh07hElfUy48ZtcTc04PPLGf/qlVukw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc591d41-a84b-4476-4a97-08d839317f0a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2020 11:20:02.1925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MyRRe4O9kmGjgRjDFWYkJeWQsHOFv2Yrr5aOKSD0vgz4oPap1eZQPQch6FnvNZ4CRdqscTEnnLt/NPRxIj/+vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2858
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 11:34 PM, Xin Long wrote:
> Without ub->ifindex set for ipv6 address in tipc_udp_enable(),
> ipv6_sock_mc_join() may make the wrong dev join the multicast
> address in enable_mcast(). This causes that tipc links would
> never be created.
> 
> So fix it by getting the right netdev and setting ub->ifindex,
> as it does for ipv4 address.
> 
> Reported-by: Shuang Li <shuali@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Ying Xue <ying.xue@windriver.com>

> ---
>  net/tipc/udp_media.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
> index 28a283f..9dec596 100644
> --- a/net/tipc/udp_media.c
> +++ b/net/tipc/udp_media.c
> @@ -738,6 +738,13 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
>  		b->mtu = b->media->mtu;
>  #if IS_ENABLED(CONFIG_IPV6)
>  	} else if (local.proto == htons(ETH_P_IPV6)) {
> +		struct net_device *dev;
> +
> +		dev = ipv6_dev_find(net, &local.ipv6);
> +		if (!dev) {
> +			err = -ENODEV;
> +			goto err;
> +		}
>  		udp_conf.family = AF_INET6;
>  		udp_conf.use_udp6_tx_checksums = true;
>  		udp_conf.use_udp6_rx_checksums = true;
> @@ -745,6 +752,7 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
>  			udp_conf.local_ip6 = in6addr_any;
>  		else
>  			udp_conf.local_ip6 = local.ipv6;
> +		ub->ifindex = dev->ifindex;
>  		b->mtu = 1280;
>  #endif
>  	} else {
> 
