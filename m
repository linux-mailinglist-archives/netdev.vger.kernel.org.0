Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5777A2B1777
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgKMIrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMIrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 03:47:05 -0500
X-Greylist: delayed 66 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 13 Nov 2020 00:47:03 PST
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5752C0613D1;
        Fri, 13 Nov 2020 00:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1605257224; x=1636793224;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yAJzaL6E1Ou/8GDr9JUabB3IujzsyMl+Vw2CIVIkMRk=;
  b=lsqaBdfr6Xmrx2+LKh6kjG1y/JTw/SBG4pWDjfsjN9JL16thcoLETvPp
   i+avgivCuIuKoIY2WBh6KP0jbfJH93naDUi8IK72UF6/5f6dMbDVsV1lm
   Z6wgrkfgWYY6edT9ekD1MKSNfUGX/totYwI4LRuE80AwUM/yUc9SaSSg5
   c=;
IronPort-SDR: mvLqvLW5yf4lkfE5qnpZKFk9qBaw91x2xyL1GGgrB96H3PH58HpFKUIv8uhhYQTwhYO6L/rko2
 PAu73Id9S2Nw==
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="76739433"
X-IronPort-AV: E=Sophos;i="5.77,475,1596492000"; 
   d="scan'208";a="76739433"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 09:45:54 +0100
Received: from MUCSE708.infineon.com (MUCSE708.infineon.com [172.23.7.82])
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Fri, 13 Nov 2020 09:45:54 +0100 (CET)
Received: from MUCSE709.infineon.com (172.23.7.75) by MUCSE708.infineon.com
 (172.23.7.82) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256) id 15.1.1913.5; Fri, 13
 Nov 2020 09:45:51 +0100
Received: from MUCSE709.infineon.com ([172.23.106.9]) by MUCSE709.infineon.com
 ([172.23.106.9]) with mapi id 15.01.1913.010; Fri, 13 Nov 2020 09:45:51 +0100
From:   <Chi-Hsien.Lin@infineon.com>
To:     <zhangchangzhong@huawei.com>, <arend.vanspriel@broadcom.com>,
        <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <Wright.Feng@infineon.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <Chung-Hsien.Hsu@infineon.com>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] brcmfmac: fix error return code in
 brcmf_cfg80211_connect()
Thread-Topic: [PATCH] brcmfmac: fix error return code in
 brcmf_cfg80211_connect()
Thread-Index: AQHWuYX2LsrVIVcLDEeEhdSUn8X2dKnFvg+Q
Date:   Fri, 13 Nov 2020 08:45:50 +0000
Message-ID: <ea4b55d801ed418f9b0430ddba559457@infineon.com>
References: <1605248896-16812-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1605248896-16812-1-git-send-email-zhangchangzhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.247]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fix to return a negative error code from the error handling case instead =
of 0, as done elsewhere in th>
>
> Fixes: 3b1e0a7bdfee ("brcmfmac: add support for SAE authentication offloa=
d")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Chi-hsien Lin <chi-hsien.lin@infineon.com>

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c =
b/drivers/net/wireless/broadc>
> index a2dbbb9..0ee421f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -2137,7 +2137,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct =
net_device *ndev,
>               BRCMF_WSEC_MAX_PSK_LEN);
>     else if (profile->use_fwsup =3D=3D BRCMF_PROFILE_FWSUP_SAE) {
>       /* clean up user-space RSNE */
> -             if (brcmf_fil_iovar_data_set(ifp, "wpaie", NULL, 0)) {
> +             err =3D brcmf_fil_iovar_data_set(ifp, "wpaie", NULL, 0);
> +             if (err) {
>                       bphy_err(drvr, "failed to clean up user-space RSNE\=
n");
>                       goto done;
> }
> --
> 2.9.5
