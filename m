Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9416E53E23C
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiFFGg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 02:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiFFGgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 02:36:54 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B78FDFF0;
        Sun,  5 Jun 2022 23:36:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nifp7m6IHkPsXW6M8nojGFd3Ujr0pS/x2Qxs0EVty5evBU3Ueeu1iCFy0HC5+VKYLptfRd/a6TL8N72qQu/ggsRBtSZeF49P/TNJSg0PDQiYyBZIdhRDZyNSUjO82+SP+TLlThO/Id6mILTk7EwOHTstEMrtJg0rBjDM0Zf0T+tg5JX+wCxkiCfrFCSb2A5G30b4Zy6MCqvqLd6iXnReZXtkbRDf7g/hiqjYVFSv0u6Mq6YtIqv9JDgOyTLEyXQMl+OwX5sYYRDraWPFI3DkJNKQlnfJikELBqPl4L1QUIiM3J6zryb8uv7nyYk35tGA+X6ahzlUpZttUcc/bS+tLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s2fYu0H8Imp9e0X4VJjqVW85N8thvnKxBvLixgp1qmg=;
 b=O34mT2NVapGCHcrEHSB/YkBv1BD+3AmKNfUbkjVOpSiYPLkMuOuYglSRP1UJX3JLJQRfjoT3NFumztX2i6u0TobL+eOLjecJAn0uAn7o3AmGFYNWb8Ck3oXr/vOi6yhuOz+gPvByTnzkmXoTnNa0Ox//I7ZtffEXRMR+5AkUB0EnqC0TwsGAMbjzYVu2luHmmsqBDi1QbxhT40J+p2k+iSJgB3Ftkurarc7EvqJtGAsFlgpPwqrUEkofh4if3XgTOSaeIJo8xFo5a0Cyyitzu6OG/R/9CAcZVzp5WbRN32aVfvCsDMwv0FPxR6BC8Yx9i09vyL2VyeEYPBGfG9EyVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2fYu0H8Imp9e0X4VJjqVW85N8thvnKxBvLixgp1qmg=;
 b=UInraKg+CkH+qd7e0lMpRF97WNtyraPkN/Wk9dgjwhjoEuzZmvMWnmLAwnxJ5c4dp7cUGPnBj13yRpQAhj/VS/IHbR5md0vSrNnfZ3qXL14YwEtsMdrxE31ZvrpCVW1XL0YOv8ykyOrWuaQXrrF1FcyoQxnH5XfDgNTPy8fVkCs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by MWHPR11MB1343.namprd11.prod.outlook.com (2603:10b6:300:20::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 06:36:50 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::98ec:f6b6:4ac:28e7]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::98ec:f6b6:4ac:28e7%9]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 06:36:50 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     cgel.zte@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] staging: wfx: Remove redundant NULL check before release_firmware() call
Date:   Mon, 06 Jun 2022 08:36:37 +0200
Message-ID: <5637060.DvuYhMxLoT@pc-42>
Organization: Silicon Labs
In-Reply-To: <20220606014237.290466-1-chi.minghao@zte.com.cn>
References: <20220606014237.290466-1-chi.minghao@zte.com.cn>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P189CA0026.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::31) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd526152-5e1c-4e6b-e3b9-08da4786efca
X-MS-TrafficTypeDiagnostic: MWHPR11MB1343:EE_
X-Microsoft-Antispam-PRVS: <MWHPR11MB134364BF859050C0B10B9B1793A29@MWHPR11MB1343.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTyWCU+2D9EnC2Bb5G2RITtufPFmAuWO10/qBRowjooV92ioVBp+DPTlAVqeIpuO5mIF0C9yGIhAKKhay1qpvd2DT7KbV3K/sWvPeUWMWHM7CNMDAjSkp1fU691HGBPIlAQAVsuFwM5Hid7RpvZ7evnJ3pBH2EUUByIfvvEBNph8WHdYMDyeIISRttuEYUS9C6zgNG4B/dVVPGIeyMEEjcbvB4W+p8Ia4EAE5UmxLqO1T70Gki13JvGX06DJuwMhyZl9sffxzeOYCcjRnVkhU6FVTX4fQNme/S4SKXGzBCoYandvJzN87QWVwr+85xNQVKoFK+GCGgEXfbBZfSA7eMEjqFovtcJu1K40vcX7JYVkzL4VJvEWuHVo20tbHSMgDH1UE5YGNMXTAVeYcxqUDHb0GVsK/gypQG6IsD5s6nj+HbVdNV7rokSHM/m7hMBuh6UJyj5WUIb0DSLWI0TE9bbEDIuP2yOTWl9k2fmDZ8vlmlWw4v4GNGzxm9R8O4ll4m3dQoeTYTR3/CLYJqDmimQzwaLhHFnHwlvR0TR/ytdwT1ItGRA6EpEdymTxPMyhQ+q7b1xyKFlKsLjdL8MupDXxjJZTYce/W08W1UTrWLCvYRWidS6O/UgSZLqNT+TOE+XpC5nAPY7we+n/PMoAR0XpalQe1WYNktQCeoC6aoSDojdPPiiuu7FqcPnTyVdF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4326008)(5660300002)(8676002)(6486002)(38350700002)(38100700002)(86362001)(316002)(6916009)(66476007)(186003)(54906003)(66946007)(83380400001)(66556008)(7416002)(8936002)(33716001)(4744005)(6506007)(6666004)(2906002)(6512007)(9686003)(52116002)(36916002)(508600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?3iFzdBCnIRME25rBT80DN7VXOqpjQiQOmq3rLY8MCY9TiYsaRQxi3zMgeb?=
 =?iso-8859-1?Q?HPFHkzNpWig+02hNZixCnwaVUnMDEu3bNZh7wEUZepTY5kCsZiaQNMEpgA?=
 =?iso-8859-1?Q?djkD5wuuztG+hGzIylJYE7YssLdugZvL5nlKtVwRc0Bak1S1edhPlhU+Hj?=
 =?iso-8859-1?Q?O8ZSpSy32KKf7ytVqPp+fNxkZPLw2WDcsDSPmTzw/56rMxzTtarZX7i4q/?=
 =?iso-8859-1?Q?MHE9BQpcfVroDYIX1ZLAwZwM++HQHM3/N82WASQWuam4Tf6liz0051IdKm?=
 =?iso-8859-1?Q?FazbcOVT+LiaKNCOza7IkLH8kfh+ur74H1nXtFGYzIV3BSK4WVFiewClGk?=
 =?iso-8859-1?Q?7LzwT8YcF2ZMDFw/+eao6Vp3z8KOWrqqLEtAXWbq5yvTNqB4hmSo+luINB?=
 =?iso-8859-1?Q?U64UKOY6+wfHTugplBq0d7hC2zVzyOnKEqEWzykctuyQIi3JvDIYE79FGv?=
 =?iso-8859-1?Q?wNgT4iQ4AezYvz9fGRyJ2paZSdPXuE2AGjU0iOhb6oVoBeOXMFqTiZVnTm?=
 =?iso-8859-1?Q?KQd5OuOVfHqK0U3cPYHLz9XMQ+Irui8JKKbtODMv7JbhW58Xyql5ddLmxc?=
 =?iso-8859-1?Q?H/WS86bdOchFFarIcuj/726ERSJ0oOiRoficPoluv/HmN2etaPWZRRIscc?=
 =?iso-8859-1?Q?AtKa7mNMD02Am3OcumgLGravo/tC4bET2H3rv5R5LHryT/7BWONSm7s8Rf?=
 =?iso-8859-1?Q?1FNK9Ba7vIqUtDXOo35BE+PgJbFjjpKufEozayYzxa7TrkLMTL0Bc0AoTc?=
 =?iso-8859-1?Q?4J/EY4veS7exB+jnJu2lqgyw0blLcfu0gh+VmlMp4/2ksna0vuhibuDM91?=
 =?iso-8859-1?Q?4aFbll/J6Nuz5VXIgmbUhoBPu10Xcm3V19lRMjpI3NMpK7CILsji+5Zvtw?=
 =?iso-8859-1?Q?NaeWJKGdqsVtrPjZi14v1jq8QjL8wz/MyVKYLdlcD0ejWBa+458lHvUd0x?=
 =?iso-8859-1?Q?ruoBf7Ygm7peHfQ9pArG5ngiwrd6IofTGenArm7oMwAXzfWx84bLcdtQQy?=
 =?iso-8859-1?Q?hennOsuScrb3yYqwmmW9AI4yP9KXeY0lI5kOZngjGXuBfqXCkncF21fNGr?=
 =?iso-8859-1?Q?vFPWYnPE5T+tkhUdK9W+RZ+pDMB1ZzbQ+fqmBz+zUqhKwlQRV9NfPpBgJe?=
 =?iso-8859-1?Q?SJ/Z2A/Zj91Zu2oP0Q4mPYIcRivd/vBHSpwVexCYESR+p2aUtkXvqtlpef?=
 =?iso-8859-1?Q?TQmKTQCb3PJaAQytKR3FnzbHMoQkb0v0teLJtv74o68kKkxE2yH/k9Whh1?=
 =?iso-8859-1?Q?KbpUzVVQ0yEjlIgY1hFxG08dJYCxBkKt7TpuNeow7Y+xGxum+zHM/VsV2U?=
 =?iso-8859-1?Q?GEdYFvslw6TKYADCPe5vFbLDLXaXWChvU65LaR7RdWsTCSLLVn1eKA2fuD?=
 =?iso-8859-1?Q?2C05LiegHCVbID2szg0YOKdDfPXUH7ni/UJhlrkrcxTKHjZO6JgDiOJCtu?=
 =?iso-8859-1?Q?yOqSxbeXCm1+PnVXX6E9PJ9USOaK35FOEqDucOB2t1anUj0PNKP7szWM3u?=
 =?iso-8859-1?Q?tf2MRt8+nafCUY2B3VGbHjPvcOwQloOwWfWDBF9yWmm++2KQ52IknWu5gn?=
 =?iso-8859-1?Q?r4VLAcaJT7DLjaatZ3m3d6h4Yn4Jh0oYeZhjwhYoJlikA8PQ+OBqQfuH3H?=
 =?iso-8859-1?Q?V6fR7SjKLk5d3qYSBkOg1o6hIkQzRn+gO9/MPBozVDkCwCZDfI3EcIPqk0?=
 =?iso-8859-1?Q?SSN8MxJxTWTvslMIVtsP4DyxFqNPYuu36BgFDA5EBxrnaZ1Y/IR5qOa82l?=
 =?iso-8859-1?Q?OZodWxr5Oc5uIZuYG6fsi9mLaBTV/Zk9Ra09aznwgQtSXgqW/UQ/2BFmMM?=
 =?iso-8859-1?Q?G3h7GWVPhg=3D=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd526152-5e1c-4e6b-e3b9-08da4786efca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 06:36:50.3087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Xe0G9DuKpz3+WnYGlB7e4zcjDe2U7sNcCe0yDvQkJztiUTYTf7GdTLyoKi5m5nQtTE4aIIAXgEMJZSjygNyqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1343
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 6 June 2022 03:42:37 CEST cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
>=20
> release_firmware() checks for NULL pointers internally so checking
> before calling it is redundant.
>=20
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---
>  drivers/net/wireless/silabs/wfx/fwio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/silabs/wfx/fwio.c b/drivers/net/wireles=
s/silabs/wfx/fwio.c
> index 3d1b8a135dc0..52c7f560b062 100644
> --- a/drivers/net/wireless/silabs/wfx/fwio.c
> +++ b/drivers/net/wireless/silabs/wfx/fwio.c
> @@ -286,8 +286,7 @@ static int load_firmware_secure(struct wfx_dev *wdev)
>=20
>  error:
>         kfree(buf);
> -       if (fw)
> -               release_firmware(fw);
> +       release_firmware(fw);
>         if (ret)
>                 print_boot_status(wdev);
>         return ret;
> --
> 2.25.1

Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>

--=20
J=E9r=F4me Pouiller


