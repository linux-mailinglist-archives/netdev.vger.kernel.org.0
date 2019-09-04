Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED82CA8330
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfIDMsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 08:48:54 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:56616
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727675AbfIDMsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 08:48:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8vOIxvJRqT5Qy5dlPkd/36p2w+wVJ6vWAslAsuKMdWkkMHhuTWkUy+yJJK/KbYy891ce4vReJshUwesKL3sK51Pq2c0sO6UgYyuCOOa0PV47HKoFsYNIkCpVpfDCb6Cslr6f7FJU7yFTvC9FndEbb5p/KUkuo1XhwI7CMbzYhqP+Aba/mkxyX4oXAJHHE3xxpuc3tJ5HzavKTD68WtKDh2SFw95HXtBYV8TUiQNGvujuy57Udkfpp7DaAOlCngbmPVolKXuiQMPg5hhenozOJpG+5B3Kx8lZ6/adlwYwW1PN5MdPjYCAnzvsgTnMxgtHuPkSlxzaF1QIGexFG4ckw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsGdnGh1HlvSGF+5FlfwKbx1G5TeR5vTYK41aU05nHU=;
 b=H1nwKpybElo52PwQuR8TF5qae0D0kf2Bp6nT7UoHChF9L2+4SMOe0/U2KvMRUp4c0Q9qUIzb6vJPBOQxGTAkVjYOLfK02QKO96eLWZmWa7hP06a0JY+QDrl+8HbujvMzYpcIV+pJ/HDIYkPfS8IGM1XrJMgeYUpDPiOSDbbIo9rDErXrzwh3FSy7vyJJirXS3xy8dD62zGlXOSZ5DHBLfsmoo6jQfqyH7TkdlUIGmKiDVcm+l2//Tx4pCyP1oKVcke74LeGkLNQstZgWzBw6rv5m1gLaUAJ5DqxlqHgbroOjz2fgoxpXqr06Gf94YHb3eA+gfN/JR/tUpvTDyqSz5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsGdnGh1HlvSGF+5FlfwKbx1G5TeR5vTYK41aU05nHU=;
 b=HWIAqIHgThx7TLhXO/GtzKGmsRLE4t5LRM4SSyWb6tDn8AKslTnUCCJMqVLayR/1GlEtmDSac5SPui07SnasU1LnkBeCmRcA/hDsNkO3ks4VWs6OvUK81zkHSH4cmgG4EqVL+Ho9sU5oTxOA4Pm6tfK5wza4FovXJwdYz/1eR4Y=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3232.eurprd05.prod.outlook.com (10.170.238.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Wed, 4 Sep 2019 12:48:49 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 12:48:49 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH net-next,v2 3/4] net: flow_offload: mangle action at byte
 level
Thread-Topic: [PATCH net-next,v2 3/4] net: flow_offload: mangle action at byte
 level
Thread-Index: AQHVYnb/E4qJRxGwlUqfiGrLUAlB/acbeTYA
Date:   Wed, 4 Sep 2019 12:48:49 +0000
Message-ID: <vbfimq88bx5.fsf@mellanox.com>
References: <20190903164513.15462-1-pablo@netfilter.org>
 <20190903164513.15462-4-pablo@netfilter.org>
In-Reply-To: <20190903164513.15462-4-pablo@netfilter.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0164.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::32) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da301924-6860-45bf-781e-08d731363b56
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB3232;
x-ms-traffictypediagnostic: VI1PR05MB3232:|VI1PR05MB3232:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB323250B99AE3D389CDF4CDF8ADB80@VI1PR05MB3232.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(52314003)(199004)(189003)(66556008)(66446008)(66066001)(14454004)(66946007)(7736002)(86362001)(66476007)(305945005)(64756008)(229853002)(5660300002)(71200400001)(71190400001)(256004)(81156014)(6486002)(81166006)(14444005)(8936002)(6916009)(478600001)(8676002)(3846002)(6116002)(186003)(36756003)(99286004)(102836004)(52116002)(386003)(6506007)(76176011)(26005)(316002)(54906003)(6246003)(476003)(2616005)(53936002)(107886003)(11346002)(446003)(6512007)(4326008)(486006)(6436002)(2906002)(25786009)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3232;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q47CsSjalvWIV3FEvhpcki26j/7fI3kgkLImx2JQkY6WL+Sn83Su9kVT2CpqaOGqOifALnfPr1h1WhVdYB13R6yplBtKJFN1RTNmN4eDj5fA0G6Gya/pFQbKDFZk8VDAiY2zLQb3YiL96CaIFRe0xQ2E6Ymif3SoBjXcodRdQLNQgfc1MPahDLTxeop9UJDOkvMkMM44g2ZuYhbdzzmoyVn2rte+nFcILfVrMDmH3/ShrxmE1z80jb9VojAnZs6YEamDEj9JpIUWD9BPlA19BP8GvUlTbgw2rRgkGqI5rC2WT4u+JVXRGwwbC3Fwam4Frjus2aWAx7KYPtmQVFnSwDMT/shMaBmO5ai91YpZmIbDiKTtJj4bkh6avXZktEvN6iUW1L4oIS4xWGLvRn2xFgJ89SdDJNApMT5iG9UqFlE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da301924-6860-45bf-781e-08d731363b56
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 12:48:49.1631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YoD/KM9y2/KFwbE5CBzc9TIlpwnwnAnCDoJwvkoRlmdgqFmjcFztbyV6N/uqnqLoaqUhl20IGF0gWUinLsrvBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3232
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 03 Sep 2019 at 19:45, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The flow mangle action is originally modeled after the tc pedit action,
> this has a number of shortcomings:
>
> 1) The tc pedit offset must be set on the 32-bits boundaries. Many
>    protocol header field offsets are not aligned to 32-bits, eg. port
>    destination, port source and ethernet destination. This patch adjusts
>    the offset accordingly and trim off length in these case, so drivers g=
et
>    an exact offset and length to the header fields.
>
> 2) The maximum mangle length is one word of 32-bits, hence you need to
>    up to four actions to mangle an IPv6 address. This patch coalesces
>    consecutive tc pedit actions into one single action so drivers can
>    configure the IPv6 mangling in one go. Ethernet address fields now
>    require one single action instead of two too.
>
> The following drivers have been updated accordingly to use this new
> mangle action layout:
>
> 1) The cxgb4 driver does not need to split protocol field matching
>    larger than one 32-bit words into multiple definitions. Instead one
>    single definition per protocol field is enough. Checking for
>    transport protocol ports is also simplified.
>
> 2) The mlx5 driver logic to disallow IPv4 ttl and IPv6 hoplimit fields
>    becomes more simple too.
>
> 3) The nfp driver uses the nfp_fl_set_helper() function to configure the
>    payload mangling. The memchr_inv() function is used to check for
>    proper initialization of the value and mask. The driver has been
>    updated to refer to the exact protocol header offsets too.
>
> As a result, this patch reduces code complexity on the driver side at
> the cost of adding ~100 LOC at the core to perform offset and length
> adjustment; and to coalesce consecutive actions.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 162 +++++----------=
-
>  .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h   |  40 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  90 +++------
>  drivers/net/ethernet/netronome/nfp/flower/action.c | 203 ++++++++++-----=
------
>  include/net/flow_offload.h                         |   7 +-
>  net/sched/cls_api.c                                | 145 ++++++++++++---
>  6 files changed, 309 insertions(+), 338 deletions(-)

[...]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tc.c
> index f29895b3a947..b7b88bc22cf7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -2201,19 +2201,24 @@ static int pedit_header_offsets[] =3D {
>
>  #define pedit_header(_ph, _htype) ((void *)(_ph) + pedit_header_offsets[=
_htype])
>
> -static int set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
> +static int set_pedit_val(u8 hdr_type, const struct flow_action_entry *ac=
t,
>  			 struct pedit_headers_action *hdrs)
>  {
> -	u32 *curr_pmask, *curr_pval;
> +	u32 offset =3D act->mangle.offset;
> +	u8 *curr_pmask, *curr_pval;
> +	int i;
>
> -	curr_pmask =3D (u32 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
> -	curr_pval  =3D (u32 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
> +	curr_pmask =3D (u8 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
> +	curr_pval  =3D (u8 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
>
> -	if (*curr_pmask & mask)  /* disallow acting twice on the same location =
*/
> -		goto out_err;
> +	for (i =3D 0; i < act->mangle.len; i++) {
> +		/* disallow acting twice on the same location */
> +		if (curr_pmask[i] & act->mangle.mask[i])
> +			goto out_err;
>
> -	*curr_pmask |=3D mask;
> -	*curr_pval  |=3D val;
> +		curr_pmask[i] |=3D act->mangle.mask[i];
> +		curr_pval[i] |=3D act->mangle.val[i];
> +	}
>
>  	return 0;
>
> @@ -2487,7 +2492,6 @@ static int parse_tc_pedit_action(struct mlx5e_priv =
*priv,
>  {
>  	u8 cmd =3D (act->id =3D=3D FLOW_ACTION_MANGLE) ? 0 : 1;
>  	int err =3D -EOPNOTSUPP;
> -	u32 mask, val, offset;
>  	u8 htype;
>
>  	htype =3D act->mangle.htype;
> @@ -2504,11 +2508,7 @@ static int parse_tc_pedit_action(struct mlx5e_priv=
 *priv,
>  		goto out_err;
>  	}
>
> -	mask =3D act->mangle.mask;
> -	val =3D act->mangle.val;
> -	offset =3D act->mangle.offset;
> -
> -	err =3D set_pedit_val(htype, mask, val, offset, &hdrs[cmd]);
> +	err =3D set_pedit_val(htype, act, &hdrs[cmd]);
>  	if (err)
>  		goto out_err;
>
> @@ -2589,50 +2589,18 @@ static bool csum_offload_supported(struct mlx5e_p=
riv *priv,
>  	return true;
>  }
>
> -struct ip_ttl_word {
> -	__u8	ttl;
> -	__u8	protocol;
> -	__sum16	check;
> -};
> -
> -struct ipv6_hoplimit_word {
> -	__be16	payload_len;
> -	__u8	nexthdr;
> -	__u8	hop_limit;
> -};
> -
>  static bool is_action_keys_supported(const struct flow_action_entry *act=
)
>  {
> -	u32 mask, offset;
> -	u8 htype;
> +	u32 offset =3D act->mangle.offset;
> +	u8 htype =3D act->mangle.htype;
>
> -	htype =3D act->mangle.htype;
> -	offset =3D act->mangle.offset;
> -	mask =3D act->mangle.mask;
> -	/* For IPv4 & IPv6 header check 4 byte word,
> -	 * to determine that modified fields
> -	 * are NOT ttl & hop_limit only.
> -	 */
> -	if (htype =3D=3D FLOW_ACT_MANGLE_HDR_TYPE_IP4) {
> -		struct ip_ttl_word *ttl_word =3D
> -			(struct ip_ttl_word *)&mask;
> -
> -		if (offset !=3D offsetof(struct iphdr, ttl) ||
> -		    ttl_word->protocol ||
> -		    ttl_word->check) {
> -			return true;
> -		}
> -	} else if (htype =3D=3D FLOW_ACT_MANGLE_HDR_TYPE_IP6) {
> -		struct ipv6_hoplimit_word *hoplimit_word =3D
> -			(struct ipv6_hoplimit_word *)&mask;
> -
> -		if (offset !=3D offsetof(struct ipv6hdr, payload_len) ||
> -		    hoplimit_word->payload_len ||
> -		    hoplimit_word->nexthdr) {
> -			return true;
> -		}
> -	}
> -	return false;
> +	if ((htype =3D=3D FLOW_ACT_MANGLE_HDR_TYPE_IP4 &&
> +	     offset =3D=3D offsetof(struct iphdr, ttl)) ||
> +	    (htype =3D=3D FLOW_ACT_MANGLE_HDR_TYPE_IP6 &&
> +	     offset =3D=3D offsetof(struct ipv6hdr, hop_limit)))
> +		return false;
> +
> +	return true;
>  }

With this change is_action_keys_supported() incorrectly returns true for
non-IP{4|6} mangles. I guess naming of the functions doesn't help
because it should be something like is_action_iphdr_keys_supported()...

Anyway, this results following rule to be incorrectly rejected by
driver:

tc filter add dev ens1f0_0 protocol ip parent ffff: prio 3
flower dst_mac e4:1d:2d:fd:8b:02 skip_sw
action pedit ex munge eth src set 11:22:33:44:55:66 munge eth dst set
       aa:bb:cc:dd:ee:ff pipe
action csum ip pipe
action tunnel_key set id 98 src_ip 2.2.2.2 dst_ip 2.2.2.3 dst_port 1234
action mirred egress redirect dev vxlan1

The pedit action is rejected by conditional that follows the loop in
modify_header_match_supported() which calls is_action_keys_supported().
With this change modify_ip_header=3D=3Dtrue (even though the pedit only
modifies eth header), which causes failure because ip proto is not
supported:

Error: mlx5_core: can't offload re-write of non TCP/UDP.
ERROR: [ 3345.830338] can't offload re-write of ip proto 0
