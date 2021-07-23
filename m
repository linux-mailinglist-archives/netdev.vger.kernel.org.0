Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758773D3BDA
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhGWNza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:55:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36126 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233665AbhGWNzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 09:55:24 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NEVJsn020029;
        Fri, 23 Jul 2021 14:35:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=C2oXjuAil/ggd67olVoQQ/Ng3ThI7p3StKXxJfrQ77E=;
 b=ua49k7JRnOUIzMZY9HVd/h1Vps7iKXwnJlFptghoe0ek0JkhK/rS0KU3t+NwzH9BVY4N
 OC173+E6Ts2mC5kxxjyn1jrZosCvLije/sCP0qIwOhTnsYxizluc6jvHoTIxqbusS/mP
 N1CwsGt4rneS5AMVPx+Ot3NVBa2oVLJhVP9cEeB0/XImTRSAOr4mhn2GTbe26UXwRsSa
 wH33kVWZDM9w6d5EhagVAqLSDjqyNAjW6mxClb30u4edfg+H+JoIjcym0tR26Rej872f
 Khx7cOOqLfrhah6yHTYttZM67Khfh4eslKjc/RKJaxiGs3QRsLi1SN19neSLNIyYrlSa Dw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=C2oXjuAil/ggd67olVoQQ/Ng3ThI7p3StKXxJfrQ77E=;
 b=yTK1+XS4ojSJI/fy95jdXGtpQN5S2jvAZX8Wuxw8AK/+njW72vQMfNusbYTAPkUmQ45F
 AGe47MfVUgW7Uvqj0gP8iDylHdXuEZi1GU+QlQoq946lzzL1sCewvVC9JVerxNj/VgZq
 AQLUf+1nja9279iL3bhFthJEtEMMKiN9zzMMSy2/XnUpNj9smTFKvrV37byOr+BjSeCs
 StmVUtIEKheySZ/wAF8UjShw3OTcjRqMU9UNpzMupH5kVEbTIhN76G8Yql8agQFhXkVn
 nhViwnSbgGZi7zdRNF9yRqqs/Aq4WkzSOdj/paWXhU+AyNQJtwatfv2nxZ96iC+FckW3 Zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39ya57ancv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 14:35:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16NEVHQC069695;
        Fri, 23 Jul 2021 14:35:50 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by aserp3020.oracle.com with ESMTP id 39uq1dba1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 14:35:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSILay90BAPReh3/MBM8EA7DpmTvvP6MKFJGQhzx+rE42vTVzc7k0LAdm1JGfgx2u0gVTk9JOahmQlBRO3U+GfBtp7UA5IdgSO+pGvoLEe6+COopN4BgX8XdLBvp9tFKeMnWMxvNe6CjeIjimLB+cxvY4XzyKXDE+ee/kCCeylgzCVZR00eHcVXFaAcexovWJuxz45wJrsiJk2U3zMrRvmR81k3jiXHoLd+oPafkS0G5/djc+sXnpOo01p6MoE/KEowwFsIkyFk/POqHTozgNg/uOY0LG/eGCY1TC4DU3TXBsd4VM9ybaSKdPjWtw65ghPb+8vRicmM3hSZmd7W4nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2oXjuAil/ggd67olVoQQ/Ng3ThI7p3StKXxJfrQ77E=;
 b=f5Wnx7OYIx1M858vWj/EQMzWDWWhiyDNDaFV1zlIDqskeWL3pWE1sHixuTVLkBvdfLwsKwcL4WBySaOBAM3kE0CzJz1xkZ3VLGRcdzlWZtcZCY6pAhdJrDte87O1zLH/xpVywc4kxOXFDMWW5hgnmToz39E8zbuPZM3q2tu27Y0JWCIrprMuEXtfQb0OFrcnYFR/GvqvjNqN4bRXLJToeNM9jhETfeipEuwnRhCIZDKuos9SqP3zZ1hmc8Lsw2FlGMh8abSLkKzocbyXGGSzlIQNtTRY8R80UME+fdMzL0tpoBsAdDQ0exl1tT36+dgCBFwW3gP+44XkHBJz3adLxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2oXjuAil/ggd67olVoQQ/Ng3ThI7p3StKXxJfrQ77E=;
 b=ThgcTNvR4Jnau9t4LQ1tmcnH1STtZe0lFn1m9VMb4SgMFG+0Fsdfr7kWX+EqTL9TMT+3lYkBGBwekf++QKBVhqJQc+aolfb/reZAhyklCk5zjDw5azHwrIQt/a+VMTfr0gafuGvOhgacT4NaNyIub7pPfD2akuNPt//4rzMtntY=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1293.namprd10.prod.outlook.com
 (2603:10b6:300:21::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Fri, 23 Jul
 2021 14:35:48 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4331.034; Fri, 23 Jul 2021
 14:35:48 +0000
Date:   Fri, 23 Jul 2021 17:35:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: Fix memory leak on reduce_power_data buffer
Message-ID: <20210723143526.GE1931@kadam>
References: <20210723141152.134340-1-colin.king@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723141152.134340-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNXP275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Fri, 23 Jul 2021 14:35:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8e84d24-02d9-4842-c673-08d94de72999
X-MS-TrafficTypeDiagnostic: MWHPR10MB1293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1293126B94AE903ABCDA5CCC8EE59@MWHPR10MB1293.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jE5ngeSyiLnPieI2W2KVyraRMBBdcFuxScl6P1EZlWh6ds63IGvMtG6tYBj4NNRhZzvWIkDNfAHSID+iZ5P0p0aW7Jt0ehVP0/OEmdwPEgaV1y+TcZueUKxrrxjDEqjS4aa0FkXf0FW2KBEdSTZ9Igk8qZ+0Jc7z3plOR4YoTfXj56DDf3oWgdrhbMr1Ltr3ebMpOXsK5vbDqwqofsiewOBnOnmfOwz95GsOUhZvm6atr+78zN7T3kmOwmGpx/1QlMvsf0JnUM/yVV2+wqAKlBqYMXVTEPvN5trH/L/5XPybDlx+W6r8QSFaE1idn3s4OaAin2ZtzzC7GIqfY9A2NZ3Ezlpzk/uZl0iW+KgaheLXGYngdTAyeCcI3ubJ08HbGz8Df67Af/ydCVTB0JVbDs1SftcYlypy/VqGhW2LbUT6Y/9wOToRgFXqrj80V/F4KoG2uEd32OCtoYE2Aq8aywRsTQB6b5o8z/6rOZpNdldFnp8kA4HU9CfguKibepy0EJW+GSqEf5f+Jf1MEOQP6D5exa/XHM/0s7QJirY7Mq/aF1ZxeQ99RuKNMpWN6lnuk/ZMv7lOAf+g5Oj+m/yc8f2x6pZuYrB0vkH6VEbsr+W/WUy8/wvG6ndOb5OGRYHURe/FmdzO5EylyBcEWlh1UL+4sHDzGxVHdl+bwM5cmDR6hTEamDq2gtUzkPHtOckKRvIBEfPIYRbNYhG5qAzCjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(186003)(66476007)(4326008)(66556008)(8676002)(5660300002)(55016002)(316002)(9686003)(478600001)(6916009)(26005)(1076003)(66946007)(44832011)(8936002)(6496006)(38350700002)(38100700002)(52116002)(9576002)(33656002)(956004)(2906002)(33716001)(54906003)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5nKvi0h+WSCje4KWquFWoggW6S9z5w5XskGGPCKFWqVH5xcmmlgi26gH9k04?=
 =?us-ascii?Q?3XZ0gvEP7nRiTWCySRAtPPgBr0icDZ1Cs6vmFwFEh+dB/VqZDarR4zLU6JL4?=
 =?us-ascii?Q?LbgwpnbNkbSS36xgc6iI/CrgawNK/AJR+JDFsy1B4BSA3ursD/IT4odrbwPy?=
 =?us-ascii?Q?MqcKDxq7KXWn3eKaH9YV2s1QS40lVoQDIwngdxoayyBOmsdah/KQ7zC7/g10?=
 =?us-ascii?Q?6Ft6R4W2svon5xuxFnW14oUCPjpwL8DA616MiM6T6kLYQfdszWg2+H6+NTX8?=
 =?us-ascii?Q?x96bkCtCYv+NSgygPOJKiOyg0hkj5joiFCvaRYWJK72smlv9ST6ACpnUX1XB?=
 =?us-ascii?Q?oyQQ937975czLdx+76BJLqJeveSjDQ9FENNR1R3ETHGIjg0AP1DHuHt80c6s?=
 =?us-ascii?Q?pi92Lh8CF2K+G6IXXJsKiOt5IY1g3PSGNTw7JHJePxUp1Wkm0tQqh/SxB16S?=
 =?us-ascii?Q?O1Tp/d/5IPYRdIGvbHr4X0tL2DY4gQJPbbVrSGJzcWeJqS9Nouqq7xoS1Z9p?=
 =?us-ascii?Q?GPqmbkjjypfdBOSiwCihjOs7XzNXP3D3gndI9X/GifmxpnM3pZ/09NkS4haU?=
 =?us-ascii?Q?IypJdl9Strlez/7wavaz0CxajpxChmesLRMhs+PJLC/rfoEKbBWUARV3WLmy?=
 =?us-ascii?Q?ivq5EGjFddQy3Nah+PyyyOwHa6dYyAFODeq+IE15zDDUomdMbRiuCPNED4mN?=
 =?us-ascii?Q?w22Nm4cXQoehnFLTCL9pqRxY/nCYJvSETzBCJtGqtWMWGeS1sd6yBhWWp72V?=
 =?us-ascii?Q?kE3pxNYa2ddw7g5dmHWEP8uJ7Gcw9rVkjSwoVi5Aymh9S5HWjCFNXjO/SoCx?=
 =?us-ascii?Q?0v3YMARWTGM1e9uGNyoYLdcntmc37KeTVoFP8lz8fU7fZntdC5AgbiJDpBiL?=
 =?us-ascii?Q?L/hTNW+jv4sS8o/M2iMg3LS/KspJE9sOtgdu/eKnSfwd7Q1t/r9/sLCIr+i/?=
 =?us-ascii?Q?xX0VuP4QI0kYqjkqqX9R6jn6NVX6ugvFCHzNf49Rxmum6Pewh0cAtXD+x/B8?=
 =?us-ascii?Q?aX5AvgGsslB3kAuxytfW85RXPgGlRKysVuoZKWanFXjDfOPuHjfAtkKnZnZV?=
 =?us-ascii?Q?40idz5rHbw4zWUN4Kw5OdkNL9LhuWDMmRlFg8mzQ6ds7osp2SKlwsUxdcKfu?=
 =?us-ascii?Q?6yChBuAv4vtk4hxAX/KDVdEX6AmBG3A5RfLspyLIJj2k4QSmPJHSIHIRwmd+?=
 =?us-ascii?Q?FZdhh5uL8R1E1k07ZZatXhXiMpio31y56INEqWluJ4JDD3R3C6pKhYdZetSD?=
 =?us-ascii?Q?aXP9ENub6FMcp4yg2EIM1f7l1HOhjqhMwQ5NCJxPSe0W/gMU6lj3eX5WJQLJ?=
 =?us-ascii?Q?y7vdgsjoYZyv4Uruq5bWjild?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e84d24-02d9-4842-c673-08d94de72999
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 14:35:48.5990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCxuiKYu8EnGaVljp1rZSyu0zVpk2wcOwqZ2v3LQGdAYFHZqtKgvIYR6zUefrNS7JOPAZq+/OxBFNo6EH9wnnZHMvU/SaTC2zeUs0J343/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1293
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230087
X-Proofpoint-GUID: Su5VE0rm4pqrFB4RrSZ3-Y9U-5CBjAZI
X-Proofpoint-ORIG-GUID: Su5VE0rm4pqrFB4RrSZ3-Y9U-5CBjAZI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 03:11:52PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the error case where the TLV length is invalid the allocated
> reduce_power_data buffer pointer is set to ERR_PTR(-EINVAL) without
> first kfree'ing any previous allocated memory. Fix this memory
> leak by kfree'ing it before taking the error return path.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 9dad325f9d57 ("iwlwifi: support loading the reduced power table from UEFI")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
> index a7c79d814aa4..413bfb2ae54d 100644
> --- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
> +++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
> @@ -86,6 +86,7 @@ static void *iwl_uefi_reduce_power_section(struct iwl_trans *trans,
>  		if (len < tlv_len) {
                    ^^^^^^^^^^^^^
Not related to your patch but probably this comparison aught to be done
against aligned tlv_len.

		tlv_len = ALIGN(tlv_len, 4);
		if (len < tlv_len) {

Especially in the iwl_uefi_reduce_power_parse() function.  Or maybe just
if (tlv_len % 0x4 || len < tlv_len)?

regards,
dan carpenter

