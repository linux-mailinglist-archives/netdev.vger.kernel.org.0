Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBE41FB50D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbgFPOxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729005AbgFPOxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:53:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD08C061573;
        Tue, 16 Jun 2020 07:53:47 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id m2so1705119pjv.2;
        Tue, 16 Jun 2020 07:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UoptLBBgAk/std92D5cqMRyl+scwvvQ9fYGAtvKkiyI=;
        b=R71t+nJNQ2Dd7ooQZUTFArV6914oWMKXYFLPE0IrHug8N99lM+lc8etWGAsw8eo0gG
         aUToVkUwR+VGxgmLsqmv78tDmENaxd04BJhlFIRmMmGVDTzbpnp9w0JefmoHmtqXIzyd
         Ts7sOaaWNUDNtNsXhwvHO8MV/AajsYtowQuCs6KM89/ryIUBmXOCA0tgf7biBfbrhCOj
         QFK/Lmh46KICRF8vdR/i+VHEbUE5Zul0J/PMj9Fkr+N2NluK7UMn5LX1t1Cs70+leqev
         YDSn5MwYjVtygxIUruou1uuo8FapWO3WJPxb12sLrY/PPdgWUCfKNrm7paDl+9lVzUIk
         vmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UoptLBBgAk/std92D5cqMRyl+scwvvQ9fYGAtvKkiyI=;
        b=Bmz1gePnzKB8uU/zpBnaIKpOoI5cwZX35m26mpLRGcQ0LVnfvKW4aiySK0urJOHkdt
         XlvRMvYhMosH9AzTkulKDn/kgaCajAXDHe9FGBhvRAxq0HrtondJvM8JP4eoHATVxYv6
         zcNfuqqJI5w+1gRhR2LZJTw9rFHwRRVKE/NlOho0SB7uZzkInKrJ09KR6uBqUc5BoZYQ
         mBxWJbB4tYX8tGjwJzuJkPcUxuGm/u48CjrvIbk42ZXmuVy8BwYYiIXEcOLFAxOHTFO/
         VbkjV2zuQAweXhJDAqg7Mz0MiIQfW94Rlp5+FiG/jlmnHe5uDa0+F+qT4f0f6EgvkzuV
         P3Tg==
X-Gm-Message-State: AOAM5328LxAqycsZtqV677qW4n5w2oQm1VMSv97usKGLZEUEpA6VeiGn
        UittSuv2R4Kfwf1mE9YK5cY8py1E
X-Google-Smtp-Source: ABdhPJycihT/ot/1nv31K2gqbVmj4sNnebfZ9RGjX+AIgMRHoaH3+MHJzTrk/ETFMJ0oTxejXtDACg==
X-Received: by 2002:a17:90a:39ce:: with SMTP id k14mr3184517pjf.39.1592319226546;
        Tue, 16 Jun 2020 07:53:46 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b5sm2850077pjz.34.2020.06.16.07.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 07:53:45 -0700 (PDT)
Subject: Re: [PATCH] e1000e: add ifdef to avoid dead code
To:     Greg Thelen <gthelen@google.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200614061122.35928-1-gthelen@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b88dc544-9f1b-75af-244e-9967ffeacf0e@gmail.com>
Date:   Tue, 16 Jun 2020 07:53:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200614061122.35928-1-gthelen@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/13/20 11:11 PM, Greg Thelen wrote:
> Commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME
> systems") added e1000e_check_me() but it's only called from
> CONFIG_PM_SLEEP protected code.  Thus builds without CONFIG_PM_SLEEP
> see:
>   drivers/net/ethernet/intel/e1000e/netdev.c:137:13: warning: 'e1000e_check_me' defined but not used [-Wunused-function]
> 
> Add CONFIG_PM_SLEEP ifdef guard to avoid dead code.
> 
> Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks Greg
