Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFF31FAF0C
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 13:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgFPLYD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 07:24:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50784 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbgFPLYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 07:24:01 -0400
Received: from mail-pl1-f199.google.com ([209.85.214.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jl9hA-0005PV-7C
        for netdev@vger.kernel.org; Tue, 16 Jun 2020 11:24:00 +0000
Received: by mail-pl1-f199.google.com with SMTP id c4so4272952plo.6
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 04:24:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RKV/iihpMFOKrX8Dy/UHawwcIU/eq1oQLDV9xYsClvQ=;
        b=nlotF0nsu3t15m+qQal+ZNV/U6n7UxVcFeOcZWgHdOXzQ8Kcz1qZNBexh//oqzciXA
         rGzxOvOXDSuP2uq4PU6Ug/wkk04NZogTZttDrYasDIpL/eCGpt+lMEOV8Eibn4iwj9K6
         sa7fEjgAKKBx5495rg0AqZ3i3llh+X2UfbRl9PltSqpzHTf1SU4p0hPNlit922UY3GbK
         v+DSNm66wNW78Dji+zmIbzMj5s6Bh64mZn0XQLeUO6qqbaueuHrKVC5gO2BJiZMDK6yR
         qOmaoUWSOlXO+QP19pk2vAMZ+66emy7V4ex/3O1Y/r1Zm4Gtex5PqjKl3u3JU+yERe4a
         2ScQ==
X-Gm-Message-State: AOAM533RCQ4QCItr8fIZJZtLTDh1rD8MVb8IYEVeTMVbtwakXd5kfKxy
        uE6mYXGaCa8MU6pgWaU3g4R7LCbywo9bqMF7Hd8pNNMrTYfWUECZyc/BDrfUKBHXRH7qqEN3YLF
        V7s2GboebOANNIneS8uzsjQEWnxHoJpmaRg==
X-Received: by 2002:aa7:9f10:: with SMTP id g16mr1692904pfr.47.1592306638259;
        Tue, 16 Jun 2020 04:23:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxn76cJL80QgLRqpVQR9LS39Yxme3oExRkYxI5UyhE9Nws2RV5nZr3RTYu817dCcgb8VQkTjA==
X-Received: by 2002:aa7:9f10:: with SMTP id g16mr1692885pfr.47.1592306637881;
        Tue, 16 Jun 2020 04:23:57 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id gg10sm2268181pjb.38.2020.06.16.04.23.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 04:23:57 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] e1000e: continue to init phy even when failed to disable
 ULP
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200616100512.22512-1-aaron.ma@canonical.com>
Date:   Tue, 16 Jun 2020 19:23:53 +0800
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vitaly.lifshits@intel.com,
        sasha.neftin@intel.com
Content-Transfer-Encoding: 8BIT
Message-Id: <4CC928F1-02CC-4675-908E-42B26C151FA1@canonical.com>
References: <20200616100512.22512-1-aaron.ma@canonical.com>
To:     Aaron Ma <aaron.ma@canonical.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 16, 2020, at 18:05, Aaron Ma <aaron.ma@canonical.com> wrote:
> 
> After commit "e1000e: disable s0ix entry and exit flows for ME systems",
> some ThinkPads always failed to disable ulp by ME.
> commit "e1000e: Warn if disabling ULP failed" break out of init phy:
> 
> error log:
> [   42.364753] e1000e 0000:00:1f.6 enp0s31f6: Failed to disable ULP
> [   42.524626] e1000e 0000:00:1f.6 enp0s31f6: PHY Wakeup cause - Unicast Packet
> [   42.822476] e1000e 0000:00:1f.6 enp0s31f6: Hardware Error
> 
> When disable s0ix, E1000_FWSM_ULP_CFG_DONE will never be 1.
> If continue to init phy like before, it can work as before.
> iperf test result good too.
> 
> Chnage e_warn to e_dbg, in case it confuses.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
> drivers/net/ethernet/intel/e1000e/ich8lan.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> index f999cca37a8a..63405819eb83 100644
> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> @@ -302,8 +302,7 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
> 	hw->dev_spec.ich8lan.ulp_state = e1000_ulp_state_unknown;
> 	ret_val = e1000_disable_ulp_lpt_lp(hw, true);

If si0x entry isn't enabled, maybe skip calling e1000_disable_ulp_lpt_lp() altogether?
We can use e1000e_check_me() to check that.

> 	if (ret_val) {
> -		e_warn("Failed to disable ULP\n");
> -		goto out;
> +		e_dbg("Failed to disable ULP\n");
> 	}

The change of "e1000e: Warn if disabling ULP failed" is intentional to catch bugs like this.

Kai-Heng

> 
> 	ret_val = hw->phy.ops.acquire(hw);
> -- 
> 2.26.2
> 

