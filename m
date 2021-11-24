Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DDE45B44E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 07:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhKXGhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 01:37:41 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:34112
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235213AbhKXGhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 01:37:40 -0500
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id F127440011
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 06:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637735670;
        bh=guuwLJoUHG0Pp+fLEKyXR1ouSwDQ+4obA9pivZjno18=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=nyT5EXqeVUoqE4osVrTI6DpNnNZtBpnOjtVDUKcnbeqh1CD2YPfVYTXPG7+eRB+oH
         MztS42+QQ6e8Dblu0aS/c1mbwtsopd67NSLucmj/Dzat7vcLdMWvy3SkF3BE1ELohH
         D9LBkaE09gZXBYNkqz+VC+yMYMtxdT8H0q8xzfhp+oL00FlkejLW8SVs/lUDPV4hnP
         UZ8iyKp0lT9dIY35iCu9EPz8zJMwWpmeoza+c8D7yToIl0xZEIMjGan7c26YeuWflV
         O8NnouMU7lB8cinsYHhGEuJS0qz0Vx1UXvsrq2RjLqgoEkV6ac1UIAQC/uFV/UjEWf
         SaZs58YCKxA8g==
Received: by mail-ot1-f70.google.com with SMTP id z16-20020a056830129000b0055c7b3ceaf5so1034231otp.8
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 22:34:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=guuwLJoUHG0Pp+fLEKyXR1ouSwDQ+4obA9pivZjno18=;
        b=5EN30hVKzZxxTB5gXFBFMdLrYHLNBLHza/GWdS/pic+i1Kpfi25K7cfKZJomfc7BDU
         ZE6Cl1e55a5C9hvkCdvorm2zo1efJT9COawsWfk0qN5ZUIoSBdv/KPFC/zOpF9766xm1
         p+7c8zmNgBgbQZkT/ZykEuXFoPMGA+ReRQGKl7y+6KqEdmXaUeSA/cR/YA2J1JnSnjEO
         AurUtlF+yMb6Vn+zj2CzMln351y9/9EmeNT8THnDV17JmRbz6nuQycXEBZuEvn0baJMZ
         IITF/bpm+YfnHxxyIIiRlyLbqqsC8CKr7hn4Cjh3X2TAlkLeLcbOLi85nHRIOhnBI2S2
         SQQw==
X-Gm-Message-State: AOAM533YHyfKVB48JGcM3ENl2PQn+31v49fgivOxetYWbD3pBBbe4g04
        XdFQep02HgMc+RzshD0tkmjq6ezq/eTP1+zxUl62Dluey/xe9B80hSKtrF8i+44I/UffC85UMxf
        bSGUOb9+KGhDJHj+wF4OotrdFVsxvxc7mgo/mMQ2tvGfmQqMiRA==
X-Received: by 2002:a9d:58f:: with SMTP id 15mr7638198otd.11.1637735669024;
        Tue, 23 Nov 2021 22:34:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzk0s+woLJZ3U0nArE/e84jqSdDYeQUZMcxSngcU2abNCsW/mVXbjBkfmDt/xiIeXtDQ8KI08M50nmkjwh5xZk=
X-Received: by 2002:a9d:58f:: with SMTP id 15mr7638161otd.11.1637735668679;
 Tue, 23 Nov 2021 22:34:28 -0800 (PST)
MIME-Version: 1.0
References: <20211122161927.874291-1-kai.heng.feng@canonical.com> <14e6c86d-0764-ceaf-4244-fcbf2c2dc23e@intel.com>
In-Reply-To: <14e6c86d-0764-ceaf-4244-fcbf2c2dc23e@intel.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 24 Nov 2021 14:34:16 +0800
Message-ID: <CAAd53p4cQ+3HQKP3--SW68fNPM9LZPbkBrrA68iu12-gA4-B7Q@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 1/3] Revert "e1000e: Additional PHY
 power saving in S0ix"
To:     "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        acelan.kao@canonical.com, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Vitaly,

On Tue, Nov 23, 2021 at 11:22 PM Lifshits, Vitaly
<vitaly.lifshits@intel.com> wrote:
>
> Hello Kai,
>
>
> We believe that simply reverting these patches is not a good idea. It will cause the driver to behave on a corporate system as if the CSME firmware is not there. This can lead to an unpredictable behavior in the long run.

I really don't want to revert the series either.

>
>
> The issue exposed by these patches is currently under active debug. We would like to find the root cause and fix it in a way that will still enable S0ix power savings on both corporate and consumer systems.

I am aware. But we've been waiting for the fix for a while, so I guess
it's better to revert the series now, and re-apply them when the fix
is ready.

Kai-Heng

>
>
> On 11/22/2021 18:19, Kai-Heng Feng wrote:
>
> This reverts commit 3ad3e28cb203309fb29022dea41cd65df0583632.
>
> The s0ix series makes e1000e on TGL and ADL fails to work after s2idle
> resume.
>
> There doesn't seem to be any solution soon, so revert the whole series.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 44e2dc8328a22..e16b7c0d98089 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6380,16 +6380,10 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>   ew32(CTRL_EXT, mac_data);
>
>   /* DFT control: PHY bit: page769_20[0] = 1
> - * page769_20[7] - PHY PLL stop
> - * page769_20[8] - PHY go to the electrical idle
> - * page769_20[9] - PHY serdes disable
>   * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
>   */
>   e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
>   phy_data |= BIT(0);
> - phy_data |= BIT(7);
> - phy_data |= BIT(8);
> - phy_data |= BIT(9);
>   e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
>
>   mac_data = er32(EXTCNF_CTRL);
