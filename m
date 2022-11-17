Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DC462E96C
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 00:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbiKQXR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 18:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239771AbiKQXQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 18:16:57 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1560748C5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 15:16:56 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p12so3036524plq.4
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 15:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFHM35UNmfkldWlBK35cn48oG6HZgrQ/KKBOkaB7rqU=;
        b=ATU3KjrZtjnHaTJObubyH+A7KNgBJz/4UaptmzMu4aSuS9NdqlPG0tYK4xIrw4V0NB
         4RU5QBMu8DWiBXX1/TktUDKtbUKAnZx48Xhzr5n3cj0tYPXPgg6lNQQwF68TEdbEM6dh
         1Bx+Y3+kimUVDCJga+7SSlvRvh7BS7Opi4JuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFHM35UNmfkldWlBK35cn48oG6HZgrQ/KKBOkaB7rqU=;
        b=5QBV0hBcKPswWowTP+i/mH04H65DY2DLVX4yJHMnNfyiATZ4T2kvK6FrLZ7Zn+xwk7
         KxBaQoARkv8gYCPy7QHYas6L3Cv47FYL6dBT4jXp782Ed8NGQJColmJeg//wYX2ax8ec
         2gnUHdZjAm2hsFuQOdRsstAZwRGtWMdY8GUFo9evXTOAYfdgJRIru+Iu66OjmpKX7L9/
         9G99pwvE3BkIgZqjz4kfj36MGvCgkyh4rsMMCYZ3QPplR090rt7t+jdYNJuuHshduLLB
         lVlDKebT5DbWgj8hc/+2cH8mjbDtEWjiYdfsmpjpoODlBBGK96vzeW3XcnS395GegqdX
         kKvA==
X-Gm-Message-State: ANoB5pnMaxgrjYoIZ185Wg2B+HAxFEZTUsYGwi7kvnM7Om1YTwSYXMjy
        iVdJB3K1eORaDPMmjKZknEdQxA==
X-Google-Smtp-Source: AA0mqf4Z52LhYoKCKnrcJ/sZ0XNkqqlzxYRePSfLz9EXsNXDAWUPh3OJgEchOas5UoNkbsmIaRRXqA==
X-Received: by 2002:a17:90a:6e47:b0:205:a550:e529 with SMTP id s7-20020a17090a6e4700b00205a550e529mr5065529pjm.25.1668727016281;
        Thu, 17 Nov 2022 15:16:56 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ls5-20020a17090b350500b00205f013f275sm4149719pjb.22.2022.11.17.15.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 15:16:55 -0800 (PST)
Date:   Thu, 17 Nov 2022 15:16:55 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/2][next] wifi: brcmfmac: Use struct_size() and
 array_size() in code ralated to struct brcmf_gscan_config
Message-ID: <202211171516.19C8EB37@keescook>
References: <cover.1668466470.git.gustavoars@kernel.org>
 <de0226a549c8d000d8974e207ede786220a3df1a.1668466470.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de0226a549c8d000d8974e207ede786220a3df1a.1668466470.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 05:02:06PM -0600, Gustavo A. R. Silva wrote:
> Prefer struct_size() over open-coded versions of idiom:
> 
> sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count
> 
> where count is the max number of items the flexible array is supposed to
> contain.
> 
> Also, use array_size() in call to memcpy().
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
