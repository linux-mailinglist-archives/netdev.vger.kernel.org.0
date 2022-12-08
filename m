Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2C26473E6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiLHQIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiLHQIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:08:00 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2125.outbound.protection.outlook.com [40.107.220.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7F614036;
        Thu,  8 Dec 2022 08:07:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXydRQquRHjjGbQplLQzdGmDMj1KVB8pNzJAFIs8KX2ZoxUhpxdQX0e/AGK4c2piM2cAWD6gEn/ZD2n63tc7GA4Hevvxx8Dn3EVDosPv4nCmfsG7jK3NLSwYeBnRKP7NbHtTo+x/IsIwtah1cN3Btl0Izx1XlvDm+rk+o7v8BLmT+QGUfgXHBCPucIZjFrqqCOK7y/oJh9bNjzbWUsQMu3/dPiRQ9prdRILgA6NyhEcXqL7MieIYPJXVUu66ubPbFRJTKqi2g0YE54jp7mc/aQx/sA/P+Zca41HAZL8ORCQ1iFrxjiY1K6hkPyFRlKuAs1uYa4qyUTimDaC7G8iWwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CLo0ILF8/1ADG1zY8fkk9R/OXrU1KerLEBEV/05uBE=;
 b=KQr6jlNTSmqXgIEH/+3Y9VdciCdGhUP1ZZ2riujxbkVvPDF3szg+g8T4rj8xIEhnn6Zf4ilL5AHLrD8jL8VzLYptR4f4F46oHWcgoItL1lR4w5ehnVPrv95/FIbe2uSrgFTmoc+9dooMMc/GjoYBNx8MXTNT5b6Im1C8WJmcfhA2NgB/t7QnAAkmstuWG8+pHg4xgt+Zj9LpZRw0rOkGcas1HdfKM6M9S7NU9faEu+eDIvYP2K8PEJCyViDFRMl5HFlof/aIxrIV+8a9beJTulH2uLTYvO5dDJGAO0HG+f/J3N2hwkCKkwfda8gDx+nd4GVZpgBwQx7bFQJ9yb6rjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CLo0ILF8/1ADG1zY8fkk9R/OXrU1KerLEBEV/05uBE=;
 b=uqtTldclGgXzLZrOXHkmr7tPpW2kzJN4zuszV1H+m3qC7pKUxeuVYZDRYGZSCZZrMubcdhSyBmZN/if4nVgDYdO3yRIX+UVrWKxwu4WkjnlYmlCzyyaKxl6X2YjjYmvxzBk4VTVnMI+0wTUOOwxN7ipMArFy7Rfx6JcbNnE+h9o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5726.namprd13.prod.outlook.com (2603:10b6:806:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 16:07:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 16:07:56 +0000
Date:   Thu, 8 Dec 2022 17:07:50 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     yang.yang29@zte.com.cn
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH linux-next] net/liquidio: use strscpy() to instead of
Message-ID: <Y5IL1up0Z4uT2TVc@corigine.com>
References: <202212081955061873542@zte.com.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212081955061873542@zte.com.cn>
X-ClientProxiedBy: AS4P192CA0014.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0809ae-8730-4025-0090-08dad9365e4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oPV5Qal9vHN0zvpa0f2ItpLXnTtK/sqJvbIl1HN8ay5xeJZQSI+O0wtcGpJLshHwAKseCEX/tiPGblzosC57hwcjYq9035EhQqW47oNRLWBZ3ej6/hKDh7SKuDKJ1NvN1SQHUMaLQI5a8xDGX90KriFjpgdHq9Al31guh0dlNr1REBbTNS3oyfw+QX/+bZm2mcFrsIvnpKMLoh0MhS+zelfH0ZMW7C9cMCjnuftGTQ1vJI3vvfGzP2rdcNTr+5Xa9mTDMZXGNurZI8V7xPFYh9KUMuVpKecB/+xOttdUhjuXS5AWsVrBRe9zWplNyx/lqtubItz65+QyRkr1TpwLzE/b+Kkw0kwZzxPQTmc63s1Nq0ouwSIBAM8uNUhEQD1uVMbT28jcxLooxGdp6D6x41nKgkGTD2CEL68qaI4uuNdmp2/5lFBIg3++lU+LkEOymUo4LtGhxdDr2otD/CgBtjrYRX6NZ1Eybb7ANk4l4iGFvGY7xAmHq9Aymdg8n/ezbpjNNKAZlYExUI2fbFwHX7ivC+FF7oOwkSV14VWDgBnEj3qNM07FCrT/S5ITjZilbkxpna3RjLrYEhwsHiWWensFBKI1JcuzaIwdMEI/ijbOU1yHeD0xGk/cmFLbuh8/H5PkZ/LLtbr4w5tWxH87MWokX3+WBDn5sqnHuPbvRVC4ZKkwUir7kHB+JPqK5Xh8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39840400004)(136003)(366004)(346002)(376002)(451199015)(36756003)(86362001)(6506007)(6486002)(478600001)(6512007)(6666004)(8936002)(41300700001)(44832011)(7416002)(66476007)(2906002)(6916009)(4326008)(66556008)(8676002)(5660300002)(66946007)(83380400001)(38100700002)(186003)(316002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nDhfQmUtxHIseOd2D36QhY6a2xD2Mj4xucL7HbOvvzVjGmkZ3gdV2yd501i8?=
 =?us-ascii?Q?JfO2LzqbJsGtYB5ZBp8HSggEJs8g3tcpDRrUb7xga7ElecYQ+oS8pgDFrUnA?=
 =?us-ascii?Q?BKN0ovFGaSzMVKTaSfO48hrsnwp6Y3i/A5NJ7HEFo4yNPnUVKXTAWYvdqfG4?=
 =?us-ascii?Q?DwPgQdl8gFjoihJniE4W6IhpNV3yHFL4LDJyn2oNHX3+8HHM+rf1PRnVume/?=
 =?us-ascii?Q?gRsx+bzAFiEyVrU+WK3vJdLy4AkgUX1FvL9pRkBOT8Iec0ujbuPIVnDr3HE8?=
 =?us-ascii?Q?j1gInmIAUVNhIQTdgmUVTO3+ppqcPx5NDR60fPGJ5NGw5oRLcGmdBBhwfqTG?=
 =?us-ascii?Q?UoYf2Wx6OCcevk3MwKxNAWzm1XuXtnD2kufF9IUgGe2QRSZPWMsK09aycQ3X?=
 =?us-ascii?Q?Y5ltACWm/w4rl+yzxcM7uDUvaBy3Z7vJfmIl62OKkXoWbgtceQih1/36xWtO?=
 =?us-ascii?Q?mIcKGxm3gS0ri4jR/wtvH5VSW/GKuczKE/KeJHou1/2Zjq4o1HUDH+7s/Ytn?=
 =?us-ascii?Q?OOfqY/RwDnogBUAUcjxZj6pw2LRm7riE6smISr8LPAJxdsavyYJfiNdjUDXY?=
 =?us-ascii?Q?q4GRlrlfrBA/PGMt5/i+sc4OhP5ZvVrBx4EmXoMAnfWXaqEt1V4wnzeG5gfP?=
 =?us-ascii?Q?wVAEKeVKjngajxcewXx5JtraTsrPoHMMvOsYpwHj5FDOi5duMoG5TFvta+rK?=
 =?us-ascii?Q?qnZhmlYWhVLwbcNsKyBAFnpylpN1aLsUyMHGNPTur+gw9jcJbI7wmrn7O3RI?=
 =?us-ascii?Q?uzDb7rysgDdtaWS/kj23/eflsrGm+zg615kPI9dtSUUvKq4P2Q4OaxRi3XKE?=
 =?us-ascii?Q?wMUhS8PpKo+6A+k5i9CV2s1h2ReErtjrcQTqIkgXSxitYkbblnAB4CqMNSE3?=
 =?us-ascii?Q?ujwZFharScJXok+jtVs7LIl+jI7lw0nDERpqZX4H7ioCYsbtmGuMwvAUjnGt?=
 =?us-ascii?Q?OqOx6TUxp9QGGvzj9UzU+r9kVkhpLLIIa9/hM9NXICrzDiJRBzgh8YJKFGeM?=
 =?us-ascii?Q?5Xe2l8MOjhERKQNxUcDNkqZGajDAwv3GDX/4bKHMm8CDm2z0S16s4WR96F2K?=
 =?us-ascii?Q?Un9sOMFnxXK2yzrwL4oePvV7/L0cnETWjz5rSuzSCSwlcXX1R37gnMiqnUHn?=
 =?us-ascii?Q?LqNmXxBouRk4lM98UugYdxlZVhTRm8Ul4+M7rqdbDf2dmhI7FDPBofzJa8RH?=
 =?us-ascii?Q?ILACZzCkk6aePRGKn6A7duA8zu7QuVhG1uuaDWBpf1fnGXBd7/TpuemlCg/8?=
 =?us-ascii?Q?BgVSyHUimJJ97UakElTcnbNGYKeswQliGLqrkUfI5+tnQAsL4MXib5Y3xsf0?=
 =?us-ascii?Q?f9BdgfjOH6Epc57mAu3FVejwwgTN/q6ocJg3AgxpWuQpFDZSLzuAndAqnpuz?=
 =?us-ascii?Q?bsYLYgjixZ4kgYG6r49U1gUJE0VRDhSO0Rr88NqL0/htAtHw2vwZFCSPwvpV?=
 =?us-ascii?Q?kn1wViEn3puFL5FHRhOPkPaRgAycnOiJHokX63ZXYut/CgHwdcuKcF3eKxTN?=
 =?us-ascii?Q?rYQ2gGYf5IsjSPC7lLWf4OQW86FeDdtCR+UxxXhBWZfsjosjraOvRMyR6gRY?=
 =?us-ascii?Q?p1VOSzPjVNXGugwzcICM9FmA6MJWIoquBWUzqnAcRWrNE696QLGyZRUIZN+n?=
 =?us-ascii?Q?bk1PSVflu3LsXcP072f3wQdu/709/gic7KkK0EjNpgRLoYWYW6772Dmr/eGI?=
 =?us-ascii?Q?3CXwpA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0809ae-8730-4025-0090-08dad9365e4d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:07:56.2412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOkwwx3XDn/+Ac6Sms79hJ5y4vNRythPAWFQCUtiQQE5EU/kOnN7Lcobe+mQdJoRBLgqgLygudkiOcfeyYHdPVH4VJznntV6ZvYtQ2ExaKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5726
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 07:55:06PM +0800, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL terminated strings.
> 
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>

This change looks good to me, but I think the subject should be:

[PATCH net-next] liquidio: use strscpy() to instead of strncpy()

Also, in the same file, does this need attention?

        /* Save off any leftovers */
        if (line != &console_buffer[bytes_read]) {
                console_buffer[bytes_read] = '\0';
                len = strlen(console->leftover);
                strncpy(&console->leftover[len], line,
                        sizeof(console->leftover) - len);
        }

> ---
>  drivers/net/ethernet/cavium/liquidio/octeon_console.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_console.c b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
> index 28feabec8fbb..076e11f7cbec 100644
> --- a/drivers/net/ethernet/cavium/liquidio/octeon_console.c
> +++ b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
> @@ -247,8 +247,7 @@ static const struct cvmx_bootmem_named_block_desc
>  					struct cvmx_bootmem_named_block_desc,
>  					size));
> 
> -		strncpy(desc->name, name, sizeof(desc->name));
> -		desc->name[sizeof(desc->name) - 1] = 0;
> +		strscpy(desc->name, name, sizeof(desc->name));
>  		return &oct->bootmem_named_block_desc;
>  	} else {
>  		return NULL;
> -- 
> 2.15.2
> 
