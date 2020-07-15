Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388B62201A9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 03:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGOBOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 21:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgGOBOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 21:14:33 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD64EC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 18:14:32 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id c25so209249otf.7
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 18:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dDpEfalZd80pxzIMAH9pHyhZ2/L+PHatx75CG9yn/3Q=;
        b=R5pUo9TKPNWJ5jTGI6nwSnZYDn8EeiO+0AnZbuC1ybXlz33wXkgr63lehgypSd0PpC
         V+CSuJeWNeYMtTtKEl0JhIYocRVbLm1ogRvOEbNXey7pObM+pZSwguMd5Shc48xdvYuy
         UFjHb/D8CFlJNdIypAJWkbpSpZDUQKWo4TAA2C9UTIN/3kwq2JRSKSrCrGXFD9mEd+B6
         x64LCqIYrxLTjegMLnURp7bP0gkqeACWYk7JGAzrP6E03AB3xQr50dvKj+CLn1btebaX
         KVJUtM6V8kej2xUZspyrrkDCFj+fOOFQXTGT++74mCkb+cYmEpygvghGmWrhVPQ59Pzj
         7t+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dDpEfalZd80pxzIMAH9pHyhZ2/L+PHatx75CG9yn/3Q=;
        b=Qz6hIHZ0EC/vv898341lMD8euiwuW8toaNqxyFCNjnXQFAoFswu75YeTxGfyMrsCM4
         g/WEPIr+me6aCyCGtChP5vpVSOGsftyAu7OuT8dky5tnJ2rM0djXM6EHFnUd0w4wPsFp
         JCHUDx5nk10g0VJbPmeA0r49r2DFIRfLrHoiTMGwE1KxZU/PdBUU+GuztJyn4cgIA1Ka
         iZ8kYAnqwMgl2Rg9mqST5wIBJvDncE0ucB4T9MYu/YR1yU89i6nwWYeVTIt+WDH5A7Me
         TYo/SnAayn2RDkeh/wXIf9GI5dK/f7dT3uaalwY0sSFi/TNH5FMKGg2/7cxDZkspYDVE
         glxA==
X-Gm-Message-State: AOAM533PDr3spozflm/J08oGFXVlxCUg0BqwczkGmi2MeOxaBiA0dU13
        F7tXrRlV5dk+xg6n2YIreqs=
X-Google-Smtp-Source: ABdhPJyFdMciWFFqLCCkUO4NSgyG0p2Jbloa8iIFfw5xLzq55/RmrBo4b+QTtNNZ1pnCuuKV39CxZg==
X-Received: by 2002:a9d:a25:: with SMTP id 34mr6512310otg.5.1594775672099;
        Tue, 14 Jul 2020 18:14:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e4ed:f887:7532:1a74])
        by smtp.googlemail.com with ESMTPSA id c206sm137488oob.22.2020.07.14.18.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 18:14:31 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/4] net/sched: Add skb->hash field editing
 via act_skbedit
To:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Jiri Pirko <jiri@mellanox.com>
References: <20200711212848.20914-1-lariel@mellanox.com>
 <20200711212848.20914-2-lariel@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e2741150-466c-576f-5534-c20339c886e1@gmail.com>
Date:   Tue, 14 Jul 2020 19:14:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200711212848.20914-2-lariel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/11/20 3:28 PM, Ariel Levkovich wrote:
> @@ -156,6 +173,17 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
>  			flags |= SKBEDIT_F_INHERITDSFIELD;
>  	}
>  
> +	if (tb[TCA_SKBEDIT_HASH] != NULL) {
> +		hash_alg = nla_get_u32(tb[TCA_SKBEDIT_HASH]);
> +		if (hash_alg > TCA_SKBEDIT_HASH_ALG_ASYM_L4)
> +			return -EINVAL;

tcf_skbedit_init has an extack argument, so fill in a message stating
why it is failing EINVAL.
