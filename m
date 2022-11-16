Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014BB62CD8D
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbiKPWYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiKPWXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:23:55 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8851EECA
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:23:54 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m14so3350pji.0
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tK/A0JOC27A19vLbVWBAPmg5Wb7Cd8nSiAzhgk2OroU=;
        b=cKkj4SCAV5XoyT4U9NqaVHQ9R1xyL6HfTtEO/kpxTpR5RuTl5eXZJsS1y616Ml1Sq1
         dNg7UdTxT/Cwo+ZlxEJ5J+axRloWDDyZ97leyLNO0qozaT7kiQrMxFC6xHDFV+V8xdyj
         7Q0h099lkSkH8GemQWQu1AAiVEyo1ucIb7dHU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tK/A0JOC27A19vLbVWBAPmg5Wb7Cd8nSiAzhgk2OroU=;
        b=7TZGeWY19VxJllkse9wQja46FA9x9t/cRM8Q9T2fOlSSTfmhdhesPIWlvSIErwCjST
         FtX/iHVRL+2X/ONtxgGhsXayR9CNNyBIbc8YUNlZ+JkMxUu+2EqcLC8Ma5zA3/V/6QjL
         3vYQFm6k9ocoJNBiyOQqyryIi35cbsQXrjqVPCcYaTsT6HdqxogCzUQdTn190lrDICMN
         6Z+X0yUl9aP1wyO4YQApNuAC8+4wsyTJJMWwEx500y5h2hh/yftZ6XSpiskuT05CFAXN
         rhDwiLBv4F/E45qA07l6aggk/EnaSPBgBcB2fTCoenGkV3EtiCzXhm0YUh1k42qgra4P
         qL8A==
X-Gm-Message-State: ANoB5pkXXqO/4f+6gbtnT9yWHYIBh6Cf1r/bxqOprilnrFwcwcJ8GODi
        UjocQAQ1IxJLlalbzInVu+rNfQ==
X-Google-Smtp-Source: AA0mqf5pZQ9l2S/XqCYN0+ZJaxMH65eucNOvAo0YRg6+EuX5cSJzCFbSMcYggLTABXEBYPJjwi+cng==
X-Received: by 2002:a17:90b:b04:b0:213:c04:42be with SMTP id bf4-20020a17090b0b0400b002130c0442bemr5718426pjb.61.1668637433862;
        Wed, 16 Nov 2022 14:23:53 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id y127-20020a623285000000b0057210dc5f23sm7520958pfy.218.2022.11.16.14.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 14:23:53 -0800 (PST)
Date:   Wed, 16 Nov 2022 14:23:52 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/2][next] wifi: brcmfmac: Use struct_size() in code
 ralated to struct brcmf_dload_data_le
Message-ID: <202211161423.2531CADA73@keescook>
References: <cover.1668548907.git.gustavoars@kernel.org>
 <41845ad3660ed4375f0c03fd36a67b2e12fafed5.1668548907.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41845ad3660ed4375f0c03fd36a67b2e12fafed5.1668548907.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 03:55:34PM -0600, Gustavo A. R. Silva wrote:
> Prefer struct_size() over open-coded versions of idiom:
> 
> sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count
> 
> where count is the max number of items the flexible array is supposed to
> contain.
> 
> In this particular case, in the open-coded version sizeof(typeof-flex-array-elements)
> is implicit in _count_ because the type of the flex array data is u8:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h:941:
>  941 struct brcmf_dload_data_le {
>  942         __le16 flag;
>  943         __le16 dload_type;
>  944         __le32 len;
>  945         __le32 crc;
>  946         u8 data[];
>  947 };
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
