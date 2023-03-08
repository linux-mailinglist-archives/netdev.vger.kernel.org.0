Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF946B068D
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjCHMEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCHMD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:03:59 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20715.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::715])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B68B718C
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 04:03:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bd5DNZ03/LCjihdwzbM9Y0AbB+UU6hNmpWdehumI9T5tYuUYFPRWS7DZQoidfxtWjseTiehKR7jHGwtWLCmsHK/Megylg3AnNz1yVmBlQW09ItnpjliQOlppq7RyNcEOnmUAxafVUNjkDviFYLgIusgvAvkG52rfrdHMJwhfl1oYRRs/meLaWJu/Myihsmtw8EwPlAJG7a0oWRZvvVBW+t/gbCQ3sBGNcjSRdh6SQJ4Nggc5prWHTXi8Un1Fb8d+MLcQtiHhT5CqkluTUEoiOnBDChFwGVxC4KXKMWWETpDZ3RJXGO9MP7/ECG/hST5wLqTdl8nHQVzJIaOajRQtJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOcPtLYNLOo0yb84fP+mneEXqpwsbfGCgINn29PmyWI=;
 b=SI/PGgsqTwdNEPlGYjJxJRFgg1mI6m+fW1cc0Wd5u12JQBZgxtPZH6PLN3JuBq9kfo/XNk8mOYKspX3LImrHD46nD0S5etw/yP3/cV17wIzBFnLm1sKu4UKwswsqn1P952BndlNP2ePI0fTnUKU1phrB/WmDSDpV1VDytTQgALMq8sRSZWxgRMEyDH8bGy9zKf9+zpedUmAfQGPKnBwu5z4KNYfjlQo3JA7MHJ0DwpibFial2WwFPq7lU1YCe4iVi5qoeIiCsO+o37mchnc5O27kXWMvs0lXPJmC5ibn/vsxUqk71r4VVfh1URbhRVkWi6luxzKqABrO/lPrwDN9Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOcPtLYNLOo0yb84fP+mneEXqpwsbfGCgINn29PmyWI=;
 b=lqHCKUGUcdnxLKs2FrrQnm0gF6TrEDFOOoghZraS1gYpD4zktqcm7iMbI9/NevInp8YA7gRRb/iHTlc4kOtHaM69TSpKwio2XVnrkmraCbq8HI8Hadj/IJlDkrj1fL8MHP6yKZEh5UXd9z9Wh+asbyaMIlUjbDbXMCE/ySLqVOk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5552.namprd13.prod.outlook.com (2603:10b6:510:131::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.26; Wed, 8 Mar
 2023 12:03:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 12:03:53 +0000
Date:   Wed, 8 Mar 2023 13:03:45 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net-next v4] net: dsa: realtek: rtl8365mb: add change_mtu
Message-ID: <ZAh5ocHELAK9PSux@corigine.com>
References: <20230307210245.542-1-luizluca@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307210245.542-1-luizluca@gmail.com>
X-ClientProxiedBy: AM0PR03CA0092.eurprd03.prod.outlook.com
 (2603:10a6:208:69::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5552:EE_
X-MS-Office365-Filtering-Correlation-Id: 69177ba4-c8ff-4f58-d48b-08db1fcd2f52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y6qYt11B3MfbZBUkDUTgc/lWywmmiMxCLdD7sGJJlmvJtbNVPXQva6E5UtWGHcvKeJZPU1DZvxEiLE8ikGHA3Wj2OKs4TGck3v66rOkQqBoM25Tuxy2kSnTtglRXTtWhMCZ/zvMvgQqwpOMTIezDzudN/yPVZXxBlWTm3GrcBuxvTlo1r9TyRD/jeeSOJrb4Ly7KG1CRxSG2PhAFbxrnbptjpZ0N/ypgWvBSHOGSt9mKiTcGqXo5Sz5jrPL009GAINmKun/WcK1u4UOPeG1nQW5sReLsZCENrPaOUeGlgSzjkRZwXC4BeivvcBP81eUWiHdy6GhM8TUPJUAs566rPKK6OSkTRGoeqg+QwKM+fvPFMwMl5MLJAYW63Kik9uzJR7q1wX/Xz9x+5szDAWfbzjzNgECREMeHBVzA5XtnLLVX6g2lPdCmDSho0XlgRw7+xQSUlrj+Iyu3K8cbFNAlRFX21thnNYXM4Z2OcPMZrRIzsO3wrfmHXybn0REez3Jd9yF8bigV0vOauKCysZGBDu+FfBW3Isozzxvz8rU/jFPXTZ8SE7+V6oHIa2JvRB8ktSofnvnrx96RiRC0ksgSBMgG74g4ro+OISl/mq/u6qWQ0AGz9is9py3DWzwftheCCUSBvWbKoJb7Prk3l5Rs7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(39840400004)(376002)(451199018)(6506007)(6486002)(6512007)(6666004)(66574015)(36756003)(83380400001)(38100700002)(186003)(86362001)(2616005)(41300700001)(66556008)(4326008)(8676002)(6916009)(2906002)(66946007)(8936002)(44832011)(7416002)(5660300002)(66476007)(478600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXBYM0YyTm5UL3dVMHY1VFdINDdIOXlaN2xSdzZNczZLNVVGNFZ4ZHBMSTZk?=
 =?utf-8?B?RjlxTkgrVmNQNHkxajFzVUxCd1dzN2dzTDIxWnJMZElyYlkxSnl1SkUvN21k?=
 =?utf-8?B?K3llcEYvM0NHT3B6QnhJdEpuWXd4eXQ5WUpIYlVHN3hBYnlrUnRveHArQTVz?=
 =?utf-8?B?UkFwV055alg3SjMxMEF3a3VibmxNaWlHUkxkekhvanJIM2ZGajdPV1hBNkFO?=
 =?utf-8?B?RjJqaFVaM0dGcjlhclpMeHU0N1h6SUc1c3BTSE9xemZvcWdkdUF6Ty9LNmov?=
 =?utf-8?B?ellVVXAySEcrQzl4YmtleHkxNUg1M29yRXplTkZPcHpSSXNhT2lkR1diTmpo?=
 =?utf-8?B?bVZ1bEh1YURadXB5Qkp4SmNNYURvbk1RcmtzdkNOT241OWJuRWZ3dDVHM1Mz?=
 =?utf-8?B?K0FFYkxBdTlIU0czOEw2VG5XREVuQ3RWM3l6cGxtMWduaU52dllsSkZ3V1Nr?=
 =?utf-8?B?ZDNLN0VXQ3FPVUpKbzN3SmgyS3pHUXhNRWM0bU9mRkJXczYzTmZkR1A3MXVa?=
 =?utf-8?B?YUFUTUd0QXBESjhOdy9VQm9vNmx1VHV3ZUwyZmlkTi82TmJZZHNsNFRnRytG?=
 =?utf-8?B?anNLRkxTTkJSMDBvd2YrOWhHUXJ5eGI4VnY1eWlwZWVmWTM3Tmd5bVBYa0I2?=
 =?utf-8?B?Vy9tMWJ6TUZEeUkzYUFmTVRjQ240UnRKdlBhRm9YZmh3Vmt4MXgveWRrMzBJ?=
 =?utf-8?B?RHVHM2hZQXpwZUVXbXVEWkMwR2J6ZDFHNjRlQ3hnYUlsWEs2RVJ5c0wxbjFn?=
 =?utf-8?B?TExteWtYV2NGQ1NGRStmaW9qeFMzNUVCc2dNL25QK2dZNGhhUk9GWjRjcEl4?=
 =?utf-8?B?SjQwQm0yczl3d0FoUlFKbkFsVjNhZ1VqQ3pWdlJXZ3MzN3M5OXg1RGRKc2Fs?=
 =?utf-8?B?QXdYWFh2dmhWbTZkdVdpbUdRdVFGZzUvNjV6SWJrYW1lb051c2Q1YWVaUWh1?=
 =?utf-8?B?N3RXWFZwR0FnZTg4YVFSWU1Gb0xnYSt2TzVkb1dNaTUzNGV6WFhCMytScmJk?=
 =?utf-8?B?UFdkYjczQkdpWStnK3E5dmhBRzl1ZFBxVUxyTVNLNzV5ViszSTAyT3psdDZB?=
 =?utf-8?B?Ui82Q1llR3Q5UmpJeXAvcWI1OXRVVFc5TXZ3MjVkRlQwbkJ3OGtiNmsvL0Uv?=
 =?utf-8?B?V3JXbHY3dS8wb0k4Y241a3FFMVF4Z1RiUGIzMGYwYUxoSWtQNERseGtpZ3V3?=
 =?utf-8?B?WEVUelNBTnNseXFQemM3aGhVZWFnd0U5ZTN5OEpWek53WmtoSXdTQUg2Q05U?=
 =?utf-8?B?NFkrd0JIL3FxTzAyeGVWWHptMGc0T3N3YlBMQ2Z3bGFvaU1hamFUWXJKY2J2?=
 =?utf-8?B?WUdwcmwvN3RJWm1pYlhDN2FUaC9rMDdIL3BnL292OVV0T2hORXVtZTVIL2Jj?=
 =?utf-8?B?TnVwNmtyKzRieFdqYnJkK0xSRVc4WDRpV0FnWi9WTjdKdzAxcHZOdllESDZP?=
 =?utf-8?B?ZHFVU1J1QmNWQ1lHM3h5VG1QYitCWXY0cWFUNVB1dm9CbWNTTVk3d0oyRWxn?=
 =?utf-8?B?dklJZG1GYUI0Z0xmSzhydVFaUys5Z1RIU05KZ1NyWnBSbnBwRXpSQ1pINFZq?=
 =?utf-8?B?V2dTclVzam1Ob1paaGJBbmhQd1JrN21mdnlGWE8xSVNUcVk1bU9mbEIzdU1a?=
 =?utf-8?B?N21oM2l3RldWQTNMYWFWRkJNcFRkZWdjRlhhT2V3am41YU9ydmw0ZHhibXBx?=
 =?utf-8?B?NVk1TVlRYU4yNCt4eXFvRGVZajgrQnMycUZhYW15cVhabTIwVzRZZVV0UkZL?=
 =?utf-8?B?SS9rV1NNYy9WL2E0aHB0ZDRQR3RtTkp4UFRJYXpLSUFVMGhXazBxVWVPZGdL?=
 =?utf-8?B?d2VyWXh4TmxIZSt1WDZaNGNWTEsxUWlpcmxzcWdXMnFhTFlnS1U0a0s3QVF6?=
 =?utf-8?B?YUNaVG8rdy9odnlyS2JIeGE5c3BZNnBRUGJXVWt6RE5RUXRsVmR0WTFlZ3Mz?=
 =?utf-8?B?RGtQZDJvdFZNeUFpUmRwL3g4RVR0eXRmQmJkRmxqQSt4SjUrQkJhbndFdng2?=
 =?utf-8?B?cFJMY1NpZHhkeGVUUmRzV2N5eGtML2RUY1lScWYxUVBSU2orYUNkMm9DcVk2?=
 =?utf-8?B?ZXVGWlZKTHFMY2hoOTFJRFVSZ1pnODN2Q3dlY0h0QWtKckdBdXp3Vnl3ZCs3?=
 =?utf-8?B?SnVValkwN3M1RlJJczI0NGNURUs2WmhFbWhiVlRUa2l4MCtlaUk2T1RrUW5E?=
 =?utf-8?B?czJkRmhrRm5KeU0ybnhjNytob29GVjUrZHNlMDNrcTBucjVnSDdpMys2MWgx?=
 =?utf-8?B?cUdVenc4M3hRRE5qQzRoMjNVNG5RPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69177ba4-c8ff-4f58-d48b-08db1fcd2f52
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 12:03:53.0144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjfuN2rQhVdKKYGxvLe+fI+jSedr5vQKk+DNOi8Cv8B8W7xQ+OSobNvN4dIL4jh8pzZQBr9o2HEJ8S2NbzkgiTyMWVnuZOGTGm6HYn6xU+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5552
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 06:02:46PM -0300, Luiz Angelo Daros de Luca wrote:
> The rtl8365mb was using a fixed MTU size of 1536, which was probably
> inspired by the rtl8366rb's initial packet size. However, unlike that
> family, the rtl8365mb family can specify the max packet size in bytes,
> rather than in fixed steps. The max packet size now defaults to
> VLAN_ETH_HLEN+ETH_DATA_LEN+ETH_FCS_LEN, which is 1522 bytes.
> 
> DSA calls change_mtu for the CPU port once the max MTU value among the
> ports changes. As the max packet size is defined globally, the switch
> is configured only when the call affects the CPU port.
> 
> The available specifications do not directly define the max supported
> packet size, but it mentions a 16k limit. This driver will use the 0x3FFF
> limit as it is used in the vendor API code. However, the switch sets the
> max packet size to 16368 bytes (0x3FF0) after it resets.
> 
> change_mtu uses MTU size, or ethernet payload size, while the switch
> works with frame size. The frame size is calculated considering the
> ethernet header (14 bytes), a possible 802.1Q tag (4 bytes), the payload
> size (MTU), and the Ethernet FCS (4 bytes). The CPU tag (8 bytes) is
> consumed before the switch enforces the limit.
> 
> MTU was tested up to 2018 (with 802.1Q) as that is as far as mt7620
> (where rtl8367s is stacked) can go. The register was manually
> manipulated byte-by-byte to ensure the MTU to frame size conversion was
> correct. For frames without 802.1Q tag, the frame size limit will be 4
> bytes over the required size.
> 
> There is a jumbo register, enabled by default at 6k packet size.
> However, the jumbo settings do not seem to limit nor expand the maximum
> tested MTU (2018), even when jumbo is disabled. More tests are needed
> with a device that can handle larger frames.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 40 ++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> v3->v4:
> - removed spurious newline after comment.
> 
> v2->v3:
> - changed max frame size to 0x3FFF (used by vendor API)
> - added info about how frame size is calculated, some more description
>   about the tests performed and the 4 extra bytes when untagged frame is
>   used.
> 
> v1->v2:
> - dropped jumbo code as it was not changing the behavior (up to 2k MTU)
> - fixed typos
> - fixed code alignment
> - renamed rtl8365mb_(change|max)_mtu to rtl8365mb_port_(change|max)_mtu
> 
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index da31d8b839ac..41ea3b5a42b1 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c

...

> @@ -1980,10 +2011,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  		p->index = i;
>  	}
>  
> -	/* Set maximum packet length to 1536 bytes */
> -	ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> -				 RTL8365MB_CFG0_MAX_LEN_MASK,
> -				 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
> +	ret = rtl8365mb_port_change_mtu(ds, cpu->trap_port, ETH_DATA_LEN);

Hi Luiz,

Perhaps I am misreading this, perhaps it was discussed elsewhere (I did
look), and perhaps it's not important. But prior to this
patch a value of 1536 is used. Whereas with this patch the
value, calculated in rtl8365mb_port_change_mtu, is
ETH_DATA_LEN + VLAN_ETH_HLEN + ETH_FCS_LEN = 1500 + 18 + 4 = 1522.

>  	if (ret)
>  		goto out_teardown_irq;
>  

...
