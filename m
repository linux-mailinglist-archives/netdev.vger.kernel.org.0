Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C382D468699
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 18:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378790AbhLDRl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 12:41:58 -0500
Received: from mail-eopbgr30095.outbound.protection.outlook.com ([40.107.3.95]:20896
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345154AbhLDRl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 12:41:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdE5lfbU/fw6m6639KGNRnBGZ4B2or9Lml27JnPKsPWLrS3GkhrcVOvKC2AUkxlpFHwNhe74HfI+eoL0Ijr95bgjTFPjxZhOBUgHYEccJCd+nGcu/LXz6KpZsnVbKmSp83ij2a4zqHW1qXHAhQUrKIcLa+spVxRphErv7dAtw8VomqWbI8HTEbnqZjeMP4L/QucZuwTlW7H+TVRKeKq6hPQ1nEn7sMiLS7WXq++QPbI6yd2ZRz+tQyXJ+a+8yiu48wlcLNXY7C1qLsKJZ/TTgmpQBT9vkDLuItL3GP0x1V9vtzDpf1T7LMYtNvyzSpFxnVXczN5Mop9P+Mk0sQh3Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4q1HSCMggkmfjOm1+sw8flvgExTDotSu3x3RAegOqVA=;
 b=D3AI1yGNi4vZERP0LgSGndNY6hZu0e4zRQHYmilnIrTQOPw62eHSy6rWxK9+EJ6HaREwIldk0CidB5v/3sI+6ZFs+LXz6JDzALhGDqW/OLblgoDGZbZ2hy5MPwTPs2pN6qdVeDijw/noGgoJcGPuFxpwrVfodBxP7dXHGzH1uO5zwNN/45LtXZPNt/wbVyrQ79ke1HrEB38RXXvNLRnRcbe2ucjAf2simTbw3W2d3B4/Z5rX/moeIydB0dEXEnhb+PPrOjijyrSW7I4eIraudbafvyLAE0WkeYA8gmXKOFN2BBuB2Gd7J+s34asBZEoaVdmDko55pYIrY19OG2k7qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q1HSCMggkmfjOm1+sw8flvgExTDotSu3x3RAegOqVA=;
 b=MAnhhWm5s+FVTfYdD0wsIDNK3txai8fn1feYNDG5oTuXeYba27JZLJeRYjugmeZo4Zf9JEDmL4TyCMjOS6h36SFHuZkgfbvZWpNJZ1BozDwfw8FpoujcN5ZpUHaORA2hN8+PPPawcwNKO9+AeuXzQNn3sb8xDLGCTlgc13WK3iM=
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 17:38:22 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 17:38:22 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>,
        "tchornyi@marvell.com" <tchornyi@marvell.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
        <kernel-hardening@lists.openwall.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>
Subject: Re: [PATCH] net: prestera: replace zero-length array with
 flexible-array member
Thread-Topic: [PATCH] net: prestera: replace zero-length array with
 flexible-array member
Thread-Index: AQHX6TJoO6FI/rILGEyrETfPVUIdZqwil9RC
Date:   Sat, 4 Dec 2021 17:38:21 +0000
Message-ID: <VI1P190MB07344B3C160E9A73165422A28F6B9@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
References: <20211204171349.22776-1-jose.exposito89@gmail.com>
In-Reply-To: <20211204171349.22776-1-jose.exposito89@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: ed3d7c75-69dd-49c2-6c18-3da2cb76fad2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a657d6e-56a3-4ee9-35c1-08d9b74cde16
x-ms-traffictypediagnostic: VI1P190MB0399:
x-microsoft-antispam-prvs: <VI1P190MB03993ECF66CB93F3DAE205128F6B9@VI1P190MB0399.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9th5kkOhGGXj6HyaouCOGY6IuPA7ewETMrDfgF5BSqbmVNMoszDPG2rt8e01T4CGdSKMCAubdcD7OUB5q1IyraO+6GDZXvIKCJ2n/ciY+4iIPoh4fGC/KyNcjkedeUl8tnOT8x7g1AzFXoiTvOmVdYnxyiaYuBpvSpW/yGieGwLrsb1yCyfVSOrY/U9b1Zl+BWwXSgghlKUEDT5RIqoa3f7Pxa4W0zc5JSsNahpH5IQBzUuoglHMn3xO1//kqQ6uGuzJX66iR927zz7jmYBp89xg1upoUs4DHvFmykTAa2yU9kfgwe3vsZTJKzGzPdrB5c/qrU0fGyUGr+EK+hCVFOgiVN35/GxhO0zdua5/5WEX0ByloJBDSmLMA0NofSlAU7L4Jz9zohXR1qnyZXC/yn06BWW0lwjtM/eJFLv1Yw3jAbJThMRYx/Xy7D8wr1//hqs8DhDLlUmCntt7CjYtFQhHUd+n9JOM20AYg3EJpUDt1dPN5k/XI81asj9pRrj4ejrioifnWkziTufdkIdjY7mXEPMkKeF1tKC4+QJAbOkc2guZyRSsDlvIVMgWp7aLBXgdkACB6gM/NOW11o9b4nCQHEAsNjZuL8vY1uTse4bWEGk6MIZADryLwt7hsf7gzu/jZqDwVeRwq01VRc+WnAWEUrnmePYF9z4qaYdVUy5QP9nObm6KizoWUsK4Z2BxoSoXJrkLfLg8UbM4BilIfGOQugwqsToHVRqbIEWr3qb4aH0i0ATxLkhe9FceRW+PZbIHgaPzJYsp6Tq9xkHAyLEerKuaXxqVniel4e8UAvw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(39830400003)(366004)(376002)(38070700005)(9686003)(966005)(66476007)(71200400001)(33656002)(66556008)(64756008)(38100700002)(5660300002)(66446008)(44832011)(76116006)(186003)(26005)(83380400001)(54906003)(8676002)(316002)(91956017)(86362001)(55016003)(8936002)(2906002)(6506007)(66946007)(4326008)(52536014)(122000001)(508600001)(110136005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?o01F/TWItclpEDHXRCEpTlTi0ULgPhzeM6ZwtJFWZ5+v2gW64m7HjEZKne?=
 =?iso-8859-1?Q?Ty8CPZ3rKJAqmss+czunPzVGWnWVJaQvTQSLRxUffEWdO+bY4QGpqPOQDA?=
 =?iso-8859-1?Q?7ZYcsV5gChhhBlG3RL+kJ9FmB/+qb44UoCyuAY7u/50kkvy4yl2lH4XiLR?=
 =?iso-8859-1?Q?LyVmt4aXE6HsyHl/zGcOKu/gCsIB3oHugvW7kyR+pma65C2wqIhOQTa6AJ?=
 =?iso-8859-1?Q?25GHKYHf2vUCIqfb9M6jItZy7SUBlt/8mhaEjjg8W33oYyDcHBYs0wT0Kt?=
 =?iso-8859-1?Q?P11n43PoCVW9Rpqk02gjVS/pl2AOybg9r874/dq+Qwn7np+UyLHQlexYZr?=
 =?iso-8859-1?Q?RW6ZWDSTpeXVN5/kljB+Wsul/y/V0MsXNUataNuXjPkIILQrC8mQHly3ic?=
 =?iso-8859-1?Q?1hp8ZhZOCv/Jll0VOjXEO5knPl6RtljcNN+LFOib0wdXrK755t2ntSundm?=
 =?iso-8859-1?Q?67gYg7xNIuda8QxWABphN0V8VnzGls701WasfKipPZKVtP8KZTWEsLANmp?=
 =?iso-8859-1?Q?+dgo2PEQyrWtPc4etckAu5z+SJwj/Y1grC6qvUlqI2yvDUjNphGgGZ1TjU?=
 =?iso-8859-1?Q?HHOLy/4iYTLe0RLH81X3zo872jMx7QnA/07oKKkrgW8QeEWYgDblXwkdxy?=
 =?iso-8859-1?Q?NNz1qcpld4udw9NAulUN+bcl8kdqHVsEqk2GGxy92cttogy5IvfJj9U3An?=
 =?iso-8859-1?Q?b11pAFudQf0it+n+7dSgrRYqhEA16r53Wf+oohJDCUQ6xqUtRoXqd7XQio?=
 =?iso-8859-1?Q?t/uYj43dj4GoqS20xtHFYAv7mgMvGZhKv1Z+EHLgdplNAJHAHCX4RWQt9q?=
 =?iso-8859-1?Q?4VK/uDooQ0J1vktGelXZa41TfftIN1FTku9g6f1+I4ovqL0EQuzhG6MyPx?=
 =?iso-8859-1?Q?x1BERQKLP8fBFDCFfvYzZjzCoGeJ6V2XedUVVzVMJbx6q2bQeKqmD0A2rg?=
 =?iso-8859-1?Q?F0o+qjrRmtxTiYkd0cQISEKLCMeF910dLT2I2gMFZi7S1m9/BYYloKNxWu?=
 =?iso-8859-1?Q?Dh3wjJr/l2KuZ8TXTrsQz5FY3LHJkPi6bqQ6oRLf2uHG2D3WVJZJuPiGW8?=
 =?iso-8859-1?Q?OlIX3EI48Ey9Buo+z2Zfe7p3vsWbLZ1DmdCskA5W3uZBxHDSOWbo4nzm9B?=
 =?iso-8859-1?Q?dMrlfyOJmUzuOC0qm8bbsacVoSSTWikQ+B+jiWIJlSCoubiMbc1hEVAf1S?=
 =?iso-8859-1?Q?+WZbF6BIEtSXJUmIlDO5CZoeF/vATy1gbE5XcokH/ME2oU7gXsVr7nYxBj?=
 =?iso-8859-1?Q?p0/okyOe6p+xbucN8bZSQWdoE1MfavT7l+hp2Sq6y7HtkkPkgXL+hAAkPy?=
 =?iso-8859-1?Q?nsh70Kjn59UvmPItzMV99hEUS0Gl3M6Bri4AZEaWWJkT6LMOj9esggpGe0?=
 =?iso-8859-1?Q?qctyZO5uTW8raVuCmub821c/w0mjQe752rx4FTpmT+dfo4w+7+kR+AfHMq?=
 =?iso-8859-1?Q?fmgJmw8bBe4OC92iYnYIcS3zPgPmjZeLjeMDrHey9IHcH2ESLLC9jOYT6X?=
 =?iso-8859-1?Q?VOKFd7/SrJzK65xPW6Jg8QY94qXvqUbxXNM5gx1LTHGhlMu6xrPGmRlFfJ?=
 =?iso-8859-1?Q?RzYhkCEez9u4D8OOYAuZHlxJq00R2qEJKs++QlwLrJZhXAH/CqoYEO7Go6?=
 =?iso-8859-1?Q?gtUB5etu1F7CYujReONGiHbJKAsS6N794g0JEtyH0Iv3g34ECNKogURftu?=
 =?iso-8859-1?Q?dC7vnPYGgJT4mN2IgcwSoW/+KcQkqqSQo4N2BqKE?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a657d6e-56a3-4ee9-35c1-08d9b74cde16
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 17:38:21.8442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tXBBaiUiOu7KNIRpCcjLPQRIfL5QjjzY8sYzqQc4KjfxN4TuVT4IxCeqxzUzAHPuAFsdql0NL/m9JfKj5N/OMO+QSbDOc/dzk+9cWpU4cXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH] net: prestera: replace zero-length array with flexible-a=
rray member =0A=
>  =0A=
> One-element and zero-length arrays are deprecated and should be=0A=
> replaced with flexible-array members:=0A=
> https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-lengt=
h-and-one-element-arrays=0A=
> =0A=
> Replace zero-length array with flexible-array member and make use=0A=
> of the struct_size() helper.=0A=
> =0A=
> Link: https://github.com/KSPP/linux/issues/78=0A=
> Signed-off-by: Jose Exposito <jose.exposito89@gmail.com>=0A=
> ---=0A=
>  drivers/net/ethernet/marvell/prestera/prestera_hw.c | 4 ++--=0A=
>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/driver=
s/net/ethernet/marvell/prestera/prestera_hw.c=0A=
> index 92cb5e9099c6..6282c9822e2b 100644=0A=
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c=0A=
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c=0A=
> @@ -443,7 +443,7 @@ struct prestera_msg_counter_resp {=0A=
>          __le32 offset;=0A=
>          __le32 num_counters;=0A=
>          __le32 done;=0A=
> -       struct prestera_msg_counter_stats stats[0];=0A=
> +       struct prestera_msg_counter_stats stats[];=0A=
>  };=0A=
>  =0A=
>  struct prestera_msg_span_req {=0A=
> @@ -1900,7 +1900,7 @@ int prestera_hw_counters_get(struct prestera_switch=
 *sw, u32 idx,=0A=
>                  .block_id =3D __cpu_to_le32(idx),=0A=
>                  .num_counters =3D __cpu_to_le32(*len),=0A=
>          };=0A=
> -       size_t size =3D sizeof(*resp) + sizeof(*resp->stats) * (*len);=0A=
> +       size_t size =3D struct_size(resp, stats, *len);=0A=
>          int err, i;=0A=
>  =0A=
>          resp =3D kmalloc(size, GFP_KERNEL);=0A=
> -- =0A=
> 2.25.1=0A=
=0A=
Thanks.=0A=
=0A=
Reviewed-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
Tested-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=
