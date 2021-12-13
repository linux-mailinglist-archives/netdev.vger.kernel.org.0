Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADDF471F9E
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 04:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhLMDfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 22:35:19 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:58146
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231502AbhLMDfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 22:35:19 -0500
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9AC9D4004E
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 03:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639366514;
        bh=WxXM4jyaAfim4In51kFlNAC+ZCUZPdZC2EcFP94mchw=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=O5bEm0WqqbO6tT44fcW+/U40Lk4ZDVbj3B4plkh+nSEB1tNuL6F0+VP5uS9Ix0sTE
         F3dVTjuYv+nTEoxvYeRcKxRPzeF3MjhF2wF0X81PJpU4CvAUqtETusFmL/EAwjVadJ
         vu98P+DKXii0K1NdkC/IokRi5PE5ApyRTLNnSP4UOUCPfKG0PPXX0RFdpzYhXqu0CJ
         OR1jhPiV6fxfWQO56nKjhSXVgSoATiC6TO8jWQ1/itnyrRd4oLXGUyrxEAPH4tDYiu
         kekLMnKXuBOqUWCIVDSULQLYYkS7UTWQBW+JN/NPpww1TKR4yYCxFsusHqUzITMrr+
         uA49lyeDtwD5w==
Received: by mail-oo1-f70.google.com with SMTP id g1-20020a4ab801000000b002c63cddd8f6so10170644oop.5
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 19:35:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WxXM4jyaAfim4In51kFlNAC+ZCUZPdZC2EcFP94mchw=;
        b=s2nBwdPFGI2XxLwUPMU5IAFaJpwQmMnJi8bciFBKOwaovf8+69PA1OVZg0QsLsXiMx
         5/rC1BsIfkfCm6+vTS3c/sLbgA4cbcGOLNMsQGW1vl/njeAda8GKzW0bed2Cm9xadGZh
         cP7M5eyijT1rh9T+puUWuGWY/2ftlTBVskU1BUNxTRaVZqQv8Rny+iQ9As+RifJxIxjw
         3R4dPBmlVxC+2PmCtlwAcKN/tyDO1T2Pop+hWcEGmmYAx7vrulT7oW9oRMbucNIPycw1
         W9Bt/SIqLP8jhOHofvfi/imrTBmxZ5cyLVJ3CnuMo1h+la9ac2p+04W1iilfXXXpF/D3
         FFjQ==
X-Gm-Message-State: AOAM533ZitqmCGvvO2HMsV583jhAimaMlOkEU4fT5h4VwPa2B/5FKxxw
        05z+5mfOvW3YE83Z9HhbJmAgKuANdpHyiP9v5BbTZdL2jbqcXKV51PzEL0kAmUVFqTEdXng8p5J
        fFM5u0oG1wj1epY9fxC5eMcGb3wrRMsvgg3vD7TsHyJuyArz/Yw==
X-Received: by 2002:a05:6808:199c:: with SMTP id bj28mr26139379oib.98.1639366511553;
        Sun, 12 Dec 2021 19:35:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2Jy7YvzKyAwTVwOJsnFzMt1E8Lv8cfRVZtR3ZcuTEDyo+hZ/52vVzx+j4rK67PXijH9rfcTzGJ2rLJTw2v+c=
X-Received: by 2002:a05:6808:199c:: with SMTP id bj28mr26139358oib.98.1639366511305;
 Sun, 12 Dec 2021 19:35:11 -0800 (PST)
MIME-Version: 1.0
References: <20211203020931.1419572-1-kai.heng.feng@canonical.com>
In-Reply-To: <20211203020931.1419572-1-kai.heng.feng@canonical.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Mon, 13 Dec 2021 11:34:59 +0800
Message-ID: <CAAd53p4v6BWSmd-4jNBs95y2Tf8TY1iedvgN=P_3nC3oa1_oTA@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: Increase microcodes loading timeout
To:     luciano.coelho@intel.com
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dror Moshe <drorx.moshe@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Abhishek Naik <abhishek.naik@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Ayala Barazani <ayala.barazani@intel.com>,
        Harish Mitty <harish.mitty@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 3, 2021 at 10:10 AM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> Intel AX201/AX211 device may not work at boot:
> [    8.875307] iwlwifi 0000:00:14.3: SecBoot CPU1 Status: 0x7267, CPU2 Status: 0xb03
> [    8.875418] iwlwifi 0000:00:14.3: UMAC PC: 0x80481126
> [    8.875426] iwlwifi 0000:00:14.3: LMAC PC: 0x1541c
> [    8.875430] iwlwifi 0000:00:14.3: WRT: Collecting data: ini trigger 13 fired (delay=0ms).
> [    8.877906] iwlwifi 0000:00:14.3: Loaded firmware version: 64.97bbee0a.0 so-a0-gf-a0-64.ucode
> ...
> [    8.878997] iwlwifi 0000:00:14.3: Failed to start RT ucode: -110
> [    8.878999] iwlwifi 0000:00:14.3: Failed to start RT ucode: -110
>
> Increase MVM_UCODE_ALIVE_TIMEOUT to 2 seconds can solve the issue.
>
> The PNVM loading can also fail:
> [    5.159949] iwlwifi 0000:00:14.3: loaded PNVM version 4b50f925
> [    5.414211] iwlwifi 0000:00:14.3: Timeout waiting for PNVM load!
> [    5.414219] iwlwifi 0000:00:14.3: Failed to start RT ucode: -110
> [    5.414224] iwlwifi 0000:00:14.3: WRT: Collecting data: ini trigger 13 fired (delay=0ms).
> [    5.416618] iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
> [    5.416619] iwlwifi 0000:00:14.3: Transport status: 0x00000042, valid: 6
> [    5.416620] iwlwifi 0000:00:14.3: Loaded firmware version: 64.97bbee0a.0 so-a0-gf-a0-64.ucode
> ...
> [    5.914276] iwlwifi 0000:00:14.3: Failed to run INIT ucode: -110
>
> Trial and error shows that the MVM_UCODE_PNVM_TIMEOUT also needs to be
> bumped to 2 seconds to fully eliminate the issue.
>
> The timeout values are verified by rebooting over 10k times.
>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

A gentle ping...

> ---
>  drivers/net/wireless/intel/iwlwifi/fw/pnvm.h | 2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
> index 203c367dd4dee..b730330d8feac 100644
> --- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
> +++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
> @@ -10,7 +10,7 @@
>
>  #include "fw/notif-wait.h"
>
> -#define MVM_UCODE_PNVM_TIMEOUT (HZ / 4)
> +#define MVM_UCODE_PNVM_TIMEOUT (2 * HZ)
>
>  #define MAX_PNVM_NAME  64
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> index 6ce78c03e51f7..0c5375f7baecf 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> @@ -24,7 +24,7 @@
>  #include "iwl-modparams.h"
>  #include "iwl-nvm-parse.h"
>
> -#define MVM_UCODE_ALIVE_TIMEOUT        (HZ)
> +#define MVM_UCODE_ALIVE_TIMEOUT        (2 * HZ)
>  #define MVM_UCODE_CALIB_TIMEOUT        (2 * HZ)
>
>  #define UCODE_VALID_OK cpu_to_le32(0x1)
> --
> 2.32.0
>
