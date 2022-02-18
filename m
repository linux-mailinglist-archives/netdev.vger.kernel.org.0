Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECCC4BB75E
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiBRK6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:58:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiBRK6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:58:15 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2084.outbound.protection.outlook.com [40.107.96.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A604617D;
        Fri, 18 Feb 2022 02:57:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrN0gQt9hBMj065P2m+tCNsEfXrEjwlLGrr4wk9r5gbo++XFvHAL9FAa+nry4VS+e0hOe7whAsBBmaufJAEyWV/KEED8IHhNv5OBRqSwTA/Hvp3EOZS66MYNPrJsUQPPT5Y2NAFpoCFF77RaLlyj/XQDVo7ePqaC3RGd6MxXvGhPf1Q5+KMO+xZh4z6IsUckmhyGoinUY8nRiLt7hcLDxHNqwP70ShdGGqaZfD6dQlK1uxi2idmXPa95gYBX0YLbPhgsinukeF+Vb41Og+xRrQ+pdyOYBVjnMmuVNxYmkv3tIpFgcWrW7xKzRZOJgQKkIW82ci/q+wpcp+O8Tmp5NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=as18uPzOVO0WJD5g8Oej/Lj8iSdgUoHfcYMejQHYs3M=;
 b=TL+tmcj4LS52CgXlTB1sODdxSSLO5+95/Sw1FkMojLOIl5uK+GjPR2AmuW05E0h1VtBhK+qpZ0oLmzjmy1F76fkDrs5ggcmy/5q3MLYuHlwdGyYyPQd9cSobvlpfMJFmxpxLH9jyG5zhbsylPht3Y+A3H0Z0SgLsAbZ/h+DslsgbmyhakL/4kjKWtnOD+4DYB3Rl3cqAxK/v5e9eUPsXN+DIbDaD4M9wjuB/a4r+a9DRQq4UzyoPHFCJNiqAp3V5iVJiaFo51WdaPYrtA2Q9/Csi7ynns/0wxBoXUr51oV8GvyxV02usmqE1v+W4DJe5llGdEdL1XsJ27KV016Jy5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=as18uPzOVO0WJD5g8Oej/Lj8iSdgUoHfcYMejQHYs3M=;
 b=OOJs/HF1aI4q8lwaJdvUNq0nvv5NzX+G3uduBs3X+xUY/8oQ3h5gFsGAmBsdFWpczPzrl8jvQP1IjZ1LjzuruXa+d6Ubwe03xz9ey1Tsy0pTW6jIQEFHtumE9FPp02m9eA+IH0mxXR/ktRzb+UrqhBtXcS//uhMvqU3qig4CW8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BYAPR11MB2821.namprd11.prod.outlook.com (2603:10b6:a02:c9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 10:57:55 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 10:57:55 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Riccardo Ferrazzo <rferrazzo@came.com>
Subject: Re: [PATCH] staging: wfx: fix scan with WFM200 and WW regulation
Date:   Fri, 18 Feb 2022 11:57:47 +0100
Message-ID: <2535719.D4RZWD7AcY@pc-42>
Organization: Silicon Labs
In-Reply-To: <20220218105358.283769-1-Jerome.Pouiller@silabs.com>
References: <20220218105358.283769-1-Jerome.Pouiller@silabs.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P250CA0016.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:102:57::21) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96dc157b-3546-4af4-90a8-08d9f2cd845e
X-MS-TrafficTypeDiagnostic: BYAPR11MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB282134F8CF3B2DC31CF37BA293379@BYAPR11MB2821.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W2Ysf+qN5T/QxJBVT4BnqmMMfUC/oq4PeTSDNwgsO5uuBu6s4ujLkCt+Ys2bNyUqER+lrh3UGbedDESX3fwQFc2DhkEuei4pIx6o9qnYW+ccSjVgFL7/ywdrQgWzjbNHg4fhUztrqI3yFEaORJolxqgckEuJmYzVAH+2zEiRFZNEv3Zhwfogg4u49RNC7AKs7YmY4jFwQ9XlueINwTbsYQz3JZXHkOXzqUijUBR7Np4Ov1Y104/W/wCcmGNtiJdfSQqV5zWAxlziGwaJFZTpObVjwlf3Ph8VrCLPBGhM5/zDo+GO1992TFKAKpo3r1UpjFfo+L9FnBwxQhNOFNPb+Z4iT2zbSLC/Zg/6gyl7SyWjrDQXuPKtDlcyifW2+dM2eEc9n0UbM1ebtEI20cuvc/Bjsb7+wf+LRWANFxMdPugKLGZpUcDoZBG0BPaKaI7AwbBswKWJ4x09nsxHyfRj4LX4zBRLIMXM1jL/OKRW4WDrkspMkJnQvc8xycj1tgq77AUQ0kdhwkIQvzv8C+i7bojNEFwB6aIkkXdM/PoovTx3sb4pAlkhnZC5pv1T41ZD047Vhf1xe/YZWK5oK3Lpf50zDBNwe5lHJ6vt/RS810o9cvYsTjbhfK0MfdcMLcnZy358kd5qOE55HUhUnblGQZfaKugTV9Vk3H/0VMjEo41bYzIZ97PFt4v92Z5ZrLq7YZzMLuh0E6Bd9VAh5t3hcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(26005)(66574015)(83380400001)(186003)(6486002)(6512007)(9686003)(6506007)(36916002)(52116002)(508600001)(6666004)(38100700002)(38350700002)(2906002)(5660300002)(66946007)(86362001)(66556008)(8936002)(6916009)(54906003)(316002)(8676002)(4326008)(33716001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?H9iqdVUrr4nZwaOdTYTaG3KuTmyXhUOhBl2Rs33aUbA/gq0bCZFiCQLlCa?=
 =?iso-8859-1?Q?ewv5fw97teIuEKRMPmc0SMGSXvH/cY7fQLLv7mK3TxycTUmey5DTAnG4xM?=
 =?iso-8859-1?Q?8/R8kOUWyoUFIWGT6tLnY2bgLs/nY261GI+nFs8k8aDVuaZOj4rDTySfyb?=
 =?iso-8859-1?Q?3nEWeKOmdNmJs3I+9l1xRx4+7Ie5lyrKe+8tpmIGfoKtu5uwqL0DM8kqNk?=
 =?iso-8859-1?Q?TUx4ZyTRRJUr3WXwWcSxo/U0oD75PCAPpdJ/uUpCjOobRCjqjdV9xqwGBA?=
 =?iso-8859-1?Q?dDdmIwOSdsNoaLk8lC7tGopTSbQMo8ri/Mp3Bqy+2VOIfL8muludbufSEG?=
 =?iso-8859-1?Q?bQc4ffBH0LhpKE1XG8E9ERS8rj/TMwOuO/8Amodb5g7TguA1kCrNSYT9WD?=
 =?iso-8859-1?Q?g4otfLhERT5NDxUXROciClmPpe4mAsdyxajVAtmzlNPic2y00iyMuB9ubG?=
 =?iso-8859-1?Q?kLknaQKSKkoMbV3HcvpBARZOonWS9GXKG2rnj8O6w3islQ/4GkWQ5Ewfx0?=
 =?iso-8859-1?Q?BenJejpvMfxgDhBMHpYqi7gFinVxjVjOkb7rz1NL3OPrfadWNuGDJmYBH/?=
 =?iso-8859-1?Q?h0m8+PV7/ASX/4AVzKeZBrhtCmHK58L2HyRweSj7iZQRTNm8V+YlLGr+JN?=
 =?iso-8859-1?Q?CSkeCEzGsrNBJBgZ6kYIExnNZvawjQBxGk70lO8AoPrj1/1OJtjlTyjYHU?=
 =?iso-8859-1?Q?bpvHETWERA6sA4KI2rtdsONVseVNsxNcaNG500gmBRG9aiROwRiSTqd+F7?=
 =?iso-8859-1?Q?HfspH0nVY8SLMkATBuDM/SpIRLf1GH/YiLgO8QakbUylbRxaVurVcNFgDx?=
 =?iso-8859-1?Q?j9N7WJCN0J1jf5M+0xXS+6/s0aG2aAK6jqHUcMIyAal10iakmOYbb+rIT5?=
 =?iso-8859-1?Q?WWbMn4erBHJtRZtpoXoZmpKI5LhXM0sWM9Lm5wqXUf8Pmbad7sF4Jtuu/5?=
 =?iso-8859-1?Q?vfxVMjDSy3APsdCn7bOn/gt4jKHSNVObEux+KdO8ePlfc0hJ/dxL3n0mPR?=
 =?iso-8859-1?Q?Mzsk/VcBuS5aSDQXHgqAdUy75wV+CgpElYj1269x/NFMZx26xPK52/7aic?=
 =?iso-8859-1?Q?AzZ2uRqnFekiKVP4XmZot5OngpUQ3GbA/quAOF3ZCnqVNWW3PHCEiGVsBW?=
 =?iso-8859-1?Q?9TCDrzG5fnSVG37OIbcmxGq6c3wiGkTW46gWN71kC/63a0pPmyYk0/owEe?=
 =?iso-8859-1?Q?JxpH8wsv8rHgpDF2HF2Tgr13pIwSRxh5ZJQJr7FZdoepbH2Yrd+wpBy70q?=
 =?iso-8859-1?Q?BTkL+hAuBi34ZiDLbbwW3eCOPYEUbhg5q0Of1l2Pd1qgCpwCtQVLpaEOnE?=
 =?iso-8859-1?Q?HiFg3MZp8YVxaWYzE0qWO1uS9f1E19MULeoouAmJR2YmQKNym/+0VgCxCJ?=
 =?iso-8859-1?Q?PIjeMT6UgHiH5BrjDWz/qjlCfRXBPZIckKFDz4mIeTr1G5leoWPLbvbu5U?=
 =?iso-8859-1?Q?Fx9XCgenjBulsLyW31JB6Dz/fxBO7PmI+x+VdRs0aTaa5jx2qHi95Ceyml?=
 =?iso-8859-1?Q?ng6uuewJ/7gw0yq8ldRYm6uBYyM16bw45If8+Kpz0+C7B4J+LOP+oMNhGn?=
 =?iso-8859-1?Q?AVUkaxPcGNCv2GdkdNUsBKlhO6fPVyUtv/Z2uqSkM3drdm+NVTuU0M4QA1?=
 =?iso-8859-1?Q?zu8dZAF8Xvk7zfrp02eDaHjBJBb4LpSuTjY2gOeQgp/9+U5dBYvFc3w3ru?=
 =?iso-8859-1?Q?esLAoEjivn5IGkFaBXc=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96dc157b-3546-4af4-90a8-08d9f2cd845e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 10:57:55.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OFygOH0POiW7iEvdLEah5sjQvkFvhI8r5dXtVAkfb5CAYtYQ2OB1Nv0LZJQXazjkw/GBYWI+fptUOxbh4ycT+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2821
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 18 February 2022 11:53:58 CET Jerome Pouiller wrote:
> From: Riccardo Ferrazzo <rferrazzo@came.com>
>=20
> Some variants of the WF200 disallow active scan on channel 12 and 13.
> For these parts, the channels 12 and 13 are marked IEEE80211_CHAN_NO_IR.
>=20
> However, the beacon hint procedure was removing the flag
> IEEE80211_CHAN_NO_IR from channels where a BSS is discovered. This was
> making subsequent scans to fail because the driver was trying active
> scans on prohibited channels.
>=20
> Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>

I forgot to mention I have reviewed on this patch:

Reviewed-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>

> ---
>  drivers/staging/wfx/main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/staging/wfx/main.c b/drivers/staging/wfx/main.c
> index d832a22850c7..5999e81dc44d 100644
> --- a/drivers/staging/wfx/main.c
> +++ b/drivers/staging/wfx/main.c
> @@ -381,6 +381,7 @@ int wfx_probe(struct wfx_dev *wdev)
>  	}
> =20
>  	if (wdev->hw_caps.region_sel_mode) {
> +		wdev->hw->wiphy->regulatory_flags |=3D REGULATORY_DISABLE_BEACON_HINTS=
;
>  		wdev->hw->wiphy->bands[NL80211_BAND_2GHZ]->channels[11].flags |=3D
>  			IEEE80211_CHAN_NO_IR;
>  		wdev->hw->wiphy->bands[NL80211_BAND_2GHZ]->channels[12].flags |=3D
>=20


--=20
J=E9r=F4me Pouiller


