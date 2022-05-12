Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5609E524E4F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350637AbiELNbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354466AbiELNbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:31:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9980662122
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:31:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGfx4nRPqo1a254JYxPqDK6+cHDJ1smcYcKD3sALM9CD76mvRzuYVh/P+voN6H4j5yrD9j9kBuEuZqeMGF9DjQreuBAP4XySa5Juiv0XJmY/kEolX4d+K9Jc+thRotdgg6AHMTJ4xaTcsEtpeBhNAkMO1MoOzjw7Lli14ucenttiN1xSEtFbo1Xeq3SB0PTX9o/QaOEX0E3g0WdqXVG/KPid8oh2HfvcH66adR1YW2ehrEp59UG8CeIg7g/de/vPMb0vYJP/tZ5oS8Iy4THOvHRRkKDbRH23ibfRw5Htnb0vyRgzTl9F/csTp29IRIDcp8kRyM7WCHPB/JpBeBX0FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xV1ZUFh5W1d+piKSs/CmEpFBZ4hM5HN5StPxPfiRZGE=;
 b=VCDa/NwAiuUWoedvLZFJQ/f+E/HpnwGSIR+AhKe5/nIkRgUm2ADx2J0HgS7XNqd+OwTAiO1SQ54/QJlmkLnS8XM9Bq4nLpHSzHe1yoKDEbxM2F7mq1E9VUQa7MNOPtIm0czquyZvhMNrHbawBlBGej/0HRndCiTC0L22DKftcXP5hv2yr8TXB01BJHVwTU076FJmTTBvohADjJBJYgwz+gV59gvQm1Q66xNeHHCYEz7kjO86BHYl5Bn3ikaZJ+IOOUl47vpc65GNZdBQ/kqT6HJ3IcfRdYMl10gB65nTECsaZ5olxNMpPgmdxguWbjg1xAEyY/cwAwM/BLfzsRo1kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xV1ZUFh5W1d+piKSs/CmEpFBZ4hM5HN5StPxPfiRZGE=;
 b=s0H8cCps7C6VAVMFEa52K0q9zM+EtOqEKB1JjZTUOxJm8TcwSLP6jaleFG6ancH78O9r3T4zuKGQxZ7Y6vv9GVI5EVG1UJKcebUJLPwP9Y3iAuoz4Tc+XKZeDRzVCDHyFgvmaqG8tuyjxNGUtNQtP9fzTwy1y0Zrl8pNfNHTZpFCCqW1tvA98ZGqzwQ7jbKNWLESmWXN1P9WzAuF/0zezYX+v05ZQ4izOerxuZjKoyCKxbcCmY46lPFxPUta1xxDyFqXL8wAuWnLgJGG20I9AXzI1pn/zl93j4zKbBd+m99R2z424kAkl9avnL82nNI9VnGirIoLnVXgXPGB75DzpA==
Received: from DM6PR12MB3066.namprd12.prod.outlook.com (2603:10b6:5:11a::20)
 by BY5PR12MB3668.namprd12.prod.outlook.com (2603:10b6:a03:194::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 13:31:01 +0000
Received: from DM6PR12MB3066.namprd12.prod.outlook.com
 ([fe80::d93a:92ca:5f0b:9d5f]) by DM6PR12MB3066.namprd12.prod.outlook.com
 ([fe80::d93a:92ca:5f0b:9d5f%5]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 13:31:01 +0000
From:   Amit Cohen <amcohen@nvidia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shuah@kernel.org" <shuah@kernel.org>, mlxsw <mlxsw@nvidia.com>
Subject: RE: [PATCH net-next] selftests: fib_nexthops: Make the test more
 robust
Thread-Topic: [PATCH net-next] selftests: fib_nexthops: Make the test more
 robust
Thread-Index: AQHYZgHxi2oIqwAybESekZ4bjmd9R60bPDOg
Date:   Thu, 12 May 2022 13:31:01 +0000
Message-ID: <DM6PR12MB30664C27CAD526E0376BEE8DCBCB9@DM6PR12MB3066.namprd12.prod.outlook.com>
References: <20220512131207.2617437-1-amcohen@nvidia.com>
In-Reply-To: <20220512131207.2617437-1-amcohen@nvidia.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fea8ef1b-197e-4818-2bcc-08da341ba7f7
x-ms-traffictypediagnostic: BY5PR12MB3668:EE_
x-microsoft-antispam-prvs: <BY5PR12MB36684D9D231E3305B59C629BCBCB9@BY5PR12MB3668.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AV1WR+miF/OuWc61WffJKAHdH3fMPSlOlgpN6TRoRkOyA//MbEfvrlGZOcDlxS2dPO/exFX+YtdZnEAMnnMwSG5WF39wAeo/e+NEj8F5Xz5o5Z486w2Ws9E2iuCWJkw9XkzZVp1ve3XwGAS69Z/jxEKy8hjltZLMQBS7hzFWyV0S98wUTkdKK5/Euk+Y/8xcOIUVi0M9DDgQJkra+tcvSPF71jCvef2y/XeOfV8fSvEzczzq1XSQvLJEAClgX0kZli4kl7QO7EnD40ybtVCGrb0yoPk/oN0FHktP7cDlstrNfEcHhW5XybQQhtfXkTfhsMPN38tBw3nD74iWvxHA79sTMQxy3kaaGGe0EvvsTas06r0H5fa6pSVwG70lKYv8v64PiwoJfbEOUYasq2+uAvfnB3dPrXFfNtYVcb8KpBVQF+1mfwPL+J607fRnvpK2iwjJngY1iURYugm8NRCuTf8uAJvXjipagH5od814Bg4rC6s4TXsIuRRljrG9XM4U6TR/2eH1RgQ9QBtBbK6lUlczwBytzAoEFPo5uxpAOi3EltMkTlsK/lCFLByXGiP+GKoAlbYnCVw5nITHqg/uEQL7Di2M4h9Hazeh1MwEoUGaD6d54HrXd14vz4Yze8n8gl1DXuJ7Cz44fpTO3YIDusiZrnTJDNCMa9nSkZEHH0vj97zyefhdcNV6B3PFVkkByyIBAMNN1s2XIPLIuc+Vcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(83380400001)(4326008)(64756008)(66556008)(55016003)(7696005)(76116006)(6916009)(71200400001)(508600001)(186003)(53546011)(6506007)(38070700005)(54906003)(316002)(8676002)(107886003)(5660300002)(2906002)(9686003)(122000001)(86362001)(38100700002)(8936002)(52536014)(66446008)(33656002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FIHdhzAW+meFcntzgvAP3T9ISpUb2wHp0A01jhfqeSwoRyjAOe9xxfZIw2Wh?=
 =?us-ascii?Q?qiKxbyyK4xniEGjij9rRZGBM1+oR034MfMT/+Ioz7tRrIB1tFgm/DKE07eBw?=
 =?us-ascii?Q?Wl3ZgOVpucivnjPxJkqa08kFy+h+DsUszCIFZby/TIAqg2Ry6QQm3NrUjkHL?=
 =?us-ascii?Q?QIVfNoxkjFst2XLrq7hL19K1zHxtMKVsQPNyfI5PGrl46SujWPoyLSsNCEfT?=
 =?us-ascii?Q?UrSaSw21joWVbyg6TAdQv9iKF5I7raKrM1RpfM9ntOdzV7+ik96fG+A+RzN3?=
 =?us-ascii?Q?XLelIloQQyobEIxFrzOW9dZi+1eBiUOLd3leHFz0bp7KxPaZ6iUlEPh0DPWI?=
 =?us-ascii?Q?q/6IWJhUSESMyxodeqiluGTVMCzhmsOZpnzPfQV6Rf7CyHPsAWWj3DI6dMYg?=
 =?us-ascii?Q?rVHNM6R6xKuT6DOi1o34TyG8mIRgW9nux5GyDNRRiAVBdoHPdWNPNnN0Q7wU?=
 =?us-ascii?Q?GlxJ/EPmUtL4v24dMdSRiT0+Dsn6d0lvw/cMv4wMOYGcWLJGEUnr5jN+j68R?=
 =?us-ascii?Q?Cfs/qgXlwh8uwJbNaD/lZlXUTh6dcImfmNrdm4OQ+MKzxZF0GKPmnveWbYtD?=
 =?us-ascii?Q?Xe6NYzh/ALIGXs+iXRNtbaW6IuE/LtG/hjYEBJe988lmC3LDEKzCUcJqjBM6?=
 =?us-ascii?Q?AReK6YmEPy4hpFMSutexR5IwOAUBXSJJiSR0rMBmZ+YTOke+Q45MjeLRml48?=
 =?us-ascii?Q?N0Lnf3wc/0E8OVS9bTFSBww2CfoAg3I7hWydvTDbuMGl4IQSWT4Ts8o+zpIL?=
 =?us-ascii?Q?1+G7664qPRo4I68y+0Ok3vo3PHFjDukLcSxm2+zj+o/ETu++c13Vl9JUBavL?=
 =?us-ascii?Q?5PbUif2aeqPcERPdkSlEYOrUic1sSSM7KwJZTjSi8qIpWFmJGfWbsuRdniHc?=
 =?us-ascii?Q?NSTSvAfmlpO+xEZmCT9Rg8vdeC2fyAtIOfWEbIM2DZTvCpUsI0qsxfYB/rcD?=
 =?us-ascii?Q?EcIQ2k/Etu5kItyR2CbRb9Xfz7IqgMmNEDZkXq+AnZKgMWo1L7UoGz6TaFxk?=
 =?us-ascii?Q?+Ylomj+sUkN3PhwO6iEQrf4EbxAMslL4X5Cs/+Zw2WCe3oUgE62xTnuovibY?=
 =?us-ascii?Q?FLtHDJzZOyww19nyBXmnUW7zizOTACSA1ECqnfUwEv5SezEzBWnz73zpHthg?=
 =?us-ascii?Q?YnFd20T5tLJX6JUgoQiEFGbufnbeWqZoyCHn9yMCVWgt6NoyaR+cj1qW6DjM?=
 =?us-ascii?Q?OqwT+A4l0H0iTerAHrOEnzCAqsbOx85mWfM7cuZxe2UGx4TgD4HxxrSD40PV?=
 =?us-ascii?Q?JReXeGkaVZkwysu4DFoHPP6k3ETz/LuHX6Frh1CN4CV+yZ/GN7snNHxDUjtM?=
 =?us-ascii?Q?ZX8Rk55cW1CxnC0zpMe2ub5ONAdSYjv+U+c6wIBPVdAB6JfF60u/ivuRDbBR?=
 =?us-ascii?Q?sB/E7/MUwL9cMxaaJCm0fgpu4EtNNOZmFh5EVEHRU+gXckROqW4Ho1BThXYB?=
 =?us-ascii?Q?luCGQ8XeA4QGnvVE5yfiXd6qAN7xk5DkMQ4Msu0Oh72TmlwO3IOYJrOLtAY7?=
 =?us-ascii?Q?O2Af9tyoIuEn0gpmpiLNhb4mk0UhaMztEOaUjY+/M7dosxxoFgMBAmfTfMll?=
 =?us-ascii?Q?EFQG0Gf4pfZ/kX6R5F+nEG6UKyAhPtgdWM244znHicQOevduflKlgqnnPvfz?=
 =?us-ascii?Q?O/RL2e3mtrkZePXXDVhGqgn3ei3NqySixp/zCp9rTaDoKuEu+jOcqlU2Hrt+?=
 =?us-ascii?Q?VGFUsYQJIuncrrsSZseBacDLlkHGg7DDD2NfoT7SLz6HJ4lCAaFIC0eDNjVe?=
 =?us-ascii?Q?UeVXs4dKVD31p5qlK6WWzkhMmbH+llyqNju67K9exkYmZXcRp29LvlIHQ4ut?=
x-ms-exchange-antispam-messagedata-1: pyD6XXVqygNhBQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea8ef1b-197e-4818-2bcc-08da341ba7f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 13:31:01.2789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YigsfdO7DJQi7mrPigaBF0OiLz4n+n2HPXZ3YDx5o7IjXb9vTYeeB8+sYZlPMTSWJGo5ChIsaXVs4EYPVsRg6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3668
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ David Ahern

> -----Original Message-----
> From: Amit Cohen <amcohen@nvidia.com>
> Sent: Thursday, May 12, 2022 4:12 PM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@red=
hat.com; shuah@kernel.org; mlxsw
> <mlxsw@nvidia.com>; Amit Cohen <amcohen@nvidia.com>
> Subject: [PATCH net-next] selftests: fib_nexthops: Make the test more rob=
ust
>=20
> Rarely some of the test cases fail. Make the test more robust by increasi=
ng
> the timeout of ping commands to 5 seconds.
>=20
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 48 ++++++++++-----------
>  1 file changed, 24 insertions(+), 24 deletions(-)
>=20
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/=
selftests/net/fib_nexthops.sh
> index b3bf5319bb0e..a99ee3fb2e13 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -882,13 +882,13 @@ ipv6_fcnal_runtime()
>  	log_test $? 0 "Route delete"
>=20
>  	run_cmd "$IP ro add 2001:db8:101::1/128 nhid 81"
> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  	log_test $? 0 "Ping with nexthop"
>=20
>  	run_cmd "$IP nexthop add id 82 via 2001:db8:92::2 dev veth3"
>  	run_cmd "$IP nexthop add id 122 group 81/82"
>  	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 122"
> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  	log_test $? 0 "Ping - multipath"
>=20
>  	#
> @@ -896,26 +896,26 @@ ipv6_fcnal_runtime()
>  	#
>  	run_cmd "$IP -6 nexthop add id 83 blackhole"
>  	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 83"
> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  	log_test $? 2 "Ping - blackhole"
>=20
>  	run_cmd "$IP nexthop replace id 83 via 2001:db8:91::2 dev veth1"
> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  	log_test $? 0 "Ping - blackhole replaced with gateway"
>=20
>  	run_cmd "$IP -6 nexthop replace id 83 blackhole"
> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  	log_test $? 2 "Ping - gateway replaced by blackhole"
>=20
>  	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 122"
> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  	if [ $? -eq 0 ]; then
>  		run_cmd "$IP nexthop replace id 122 group 83"
> -		run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +		run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  		log_test $? 2 "Ping - group with blackhole"
>=20
>  		run_cmd "$IP nexthop replace id 122 group 81/82"
> -		run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +		run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  		log_test $? 0 "Ping - group blackhole replaced with gateways"
>  	else
>  		log_test 2 0 "Ping - multipath failed"
> @@ -1003,10 +1003,10 @@ ipv6_fcnal_runtime()
>  	run_cmd "$IP nexthop add id 92 via 2001:db8:92::2 dev veth3"
>  	run_cmd "$IP nexthop add id 93 group 91/92"
>  	run_cmd "$IP -6 ro add default nhid 91"
> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  	log_test $? 0 "Nexthop with default route and rpfilter"
>  	run_cmd "$IP -6 ro replace default nhid 93"
> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>  	log_test $? 0 "Nexthop with multipath default route and rpfilter"
>=20
>  	# TO-DO:
> @@ -1460,13 +1460,13 @@ ipv4_fcnal_runtime()
>  	#
>  	run_cmd "$IP nexthop replace id 21 via 172.16.1.2 dev veth1"
>  	run_cmd "$IP ro replace 172.16.101.1/32 nhid 21"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 0 "Basic ping"
>=20
>  	run_cmd "$IP nexthop replace id 22 via 172.16.2.2 dev veth3"
>  	run_cmd "$IP nexthop add id 122 group 21/22"
>  	run_cmd "$IP ro replace 172.16.101.1/32 nhid 122"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 0 "Ping - multipath"
>=20
>  	run_cmd "$IP ro delete 172.16.101.1/32 nhid 122"
> @@ -1477,7 +1477,7 @@ ipv4_fcnal_runtime()
>  	run_cmd "$IP nexthop add id 501 via 172.16.1.2 dev veth1"
>  	run_cmd "$IP ro add default nhid 501"
>  	run_cmd "$IP ro add default via 172.16.1.3 dev veth1 metric 20"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 0 "Ping - multiple default routes, nh first"
>=20
>  	# flip the order
> @@ -1486,7 +1486,7 @@ ipv4_fcnal_runtime()
>  	run_cmd "$IP ro add default via 172.16.1.2 dev veth1 metric 20"
>  	run_cmd "$IP nexthop replace id 501 via 172.16.1.3 dev veth1"
>  	run_cmd "$IP ro add default nhid 501 metric 20"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 0 "Ping - multiple default routes, nh second"
>=20
>  	run_cmd "$IP nexthop delete nhid 501"
> @@ -1497,26 +1497,26 @@ ipv4_fcnal_runtime()
>  	#
>  	run_cmd "$IP nexthop add id 23 blackhole"
>  	run_cmd "$IP ro replace 172.16.101.1/32 nhid 23"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 2 "Ping - blackhole"
>=20
>  	run_cmd "$IP nexthop replace id 23 via 172.16.1.2 dev veth1"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 0 "Ping - blackhole replaced with gateway"
>=20
>  	run_cmd "$IP nexthop replace id 23 blackhole"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 2 "Ping - gateway replaced by blackhole"
>=20
>  	run_cmd "$IP ro replace 172.16.101.1/32 nhid 122"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	if [ $? -eq 0 ]; then
>  		run_cmd "$IP nexthop replace id 122 group 23"
> -		run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +		run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  		log_test $? 2 "Ping - group with blackhole"
>=20
>  		run_cmd "$IP nexthop replace id 122 group 21/22"
> -		run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +		run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  		log_test $? 0 "Ping - group blackhole replaced with gateways"
>  	else
>  		log_test 2 0 "Ping - multipath failed"
> @@ -1543,7 +1543,7 @@ ipv4_fcnal_runtime()
>  	run_cmd "$IP nexthop add id 24 via ${lladdr} dev veth1"
>  	set +e
>  	run_cmd "$IP ro replace 172.16.101.1/32 nhid 24"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 0 "IPv6 nexthop with IPv4 route"
>=20
>  	$IP neigh sh | grep -q "${lladdr} dev veth1"
> @@ -1567,11 +1567,11 @@ ipv4_fcnal_runtime()
>=20
>  	check_route "172.16.101.1" "172.16.101.1 nhid 101 nexthop via inet6 ${l=
laddr} dev veth1 weight 1 nexthop via 172.16.1.2 dev
> veth1 weight 1"
>=20
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 0 "IPv6 nexthop with IPv4 route"
>=20
>  	run_cmd "$IP ro replace 172.16.101.1/32 via inet6 ${lladdr} dev veth1"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 0 "IPv4 route with IPv6 gateway"
>=20
>  	$IP neigh sh | grep -q "${lladdr} dev veth1"
> @@ -1588,7 +1588,7 @@ ipv4_fcnal_runtime()
>=20
>  	run_cmd "$IP ro del 172.16.101.1/32 via inet6 ${lladdr} dev veth1"
>  	run_cmd "$IP -4 ro add default via inet6 ${lladdr} dev veth1"
> -	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
> +	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
>  	log_test $? 0 "IPv4 default route with IPv6 gateway"
>=20
>  	#
> --
> 2.35.1

