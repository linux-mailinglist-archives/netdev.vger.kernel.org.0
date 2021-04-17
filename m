Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544863631D5
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhDQSbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbhDQSbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 14:31:15 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9526BC061574;
        Sat, 17 Apr 2021 11:30:48 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id e13so22354648qkl.6;
        Sat, 17 Apr 2021 11:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KoE1viHyQhpnKshhGJt4Df5OO9irbP+1SYRgawksjyw=;
        b=J+7rvjIXCkgWGNnHDhGy8D9rsyuu8L1ZSNBX8r44mLL+4IpRZBQH96I1wmSfqRoKlR
         bTMWmBdvJts363ifSXWneDEZoApw8agoRMjyVSJFEL5uj4TybBei3+PB59gLGbqGtteG
         IBIn8TSYzb0j5n9LSq8ViOMzpNFRoUvHTY4PxpqEImgsPU/le/BlXBVfGkKVaPIjNYE4
         C1fsbso30WUPBsMpUches44sdcwizadMwi469e7xLLNxmHuehrcEJBp+6/1/o4I6Vngp
         3LwZjYGP97zIuRyiOw//najt9hJfQzSJ27GOG2K6dCwx3M5T+X/hwc+PhfnZ2CODQIR5
         gPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KoE1viHyQhpnKshhGJt4Df5OO9irbP+1SYRgawksjyw=;
        b=p9WLbvU1FQy6ihjU/jBeLwNR5BfwqPywldkcoru70Xvfnh7TDkuG5o8bFeHrhUjNNd
         Dq1oddEEEhW70HJUf0jRGNJ4CNX/az6aFDZbY2xfeTXtXb43BIhRnal1X+m++9zZPbLk
         2IpWVu1jNHCrZO87eUkaa+m+C02VVYmlJLXBTxMROgNQPztBM+knYJUh3aAcwcdC8hsi
         sCtNFXOhGd13zwrWrZfkQWTtJ5Nob3Jl6nlruJpueegl+Endp6PKmWe8RsQG2ymEelHX
         qA+UGtiLkBkCPZrHZiA1Eozjm7P4I9f94HupHg3fWNICA3sGI+ae7ehWlqRxmyzAKn7d
         Ilmw==
X-Gm-Message-State: AOAM531PDl+QNlEksf/DjNAs8rOTNZ0OtaY204QZroBbY3yBCCs1kquY
        ZfDdinbf5qnkxt/IbBfSO4uliBkVkqA=
X-Google-Smtp-Source: ABdhPJzjsc6t+zqz9n9bMWc5KMZIZhf5PzBums2eRbuF8N5buSrs/LIoQ9u8q3ceYhSpUOL/6Yc8yQ==
X-Received: by 2002:a37:7d84:: with SMTP id y126mr4855073qkc.155.1618684247897;
        Sat, 17 Apr 2021 11:30:47 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:1b53])
        by smtp.gmail.com with ESMTPSA id v192sm6522349qkb.83.2021.04.17.11.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 11:30:47 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
To:     Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305094850.GA141221@embeddedor>
 <20210417175201.2D5A7C433F1@smtp.codeaurora.org>
Message-ID: <6bcce753-ceca-8731-ec66-6f467a3199fd@gmail.com>
Date:   Sat, 17 Apr 2021 14:30:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210417175201.2D5A7C433F1@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/21 1:52 PM, Kalle Valo wrote:
> "Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:
> 
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix
>> multiple warnings by replacing /* fall through */ comments with
>> the new pseudo-keyword macro fallthrough; instead of letting the
>> code fall through to the next case.
>>
>> Notice that Clang doesn't recognize /* fall through */ comments as
>> implicit fall-through markings.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Patch applied to wireless-drivers-next.git, thanks.
> 
> bf3365a856a1 rtl8xxxu: Fix fall-through warnings for Clang
> 

Sorry this junk patch should not have been applied.

Jes
