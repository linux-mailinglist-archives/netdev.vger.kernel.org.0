Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E32A42D0CF
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 05:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhJNDNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 23:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNDNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 23:13:20 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A76BC061570;
        Wed, 13 Oct 2021 20:11:16 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so6396271otb.10;
        Wed, 13 Oct 2021 20:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LBPW3fMyICXdUnGUVW6erk1L8DkgBFvdBy+5fInXDF0=;
        b=eM2BngcCRKzUkgGj2QEaruFhcmrYf4k5R86NVmtmMvi47xdD+8uZ/dQ/6drhLV175p
         Wj93T6YEUb/vDoeonJy0AhAcwl0EFbIbsMSkhNUkMGX9ZCvREY/I8eP7Xfz2iIXjuOYY
         +5LyJZvdfUVlPTPUDiKbv/KrTXlEeyaD89jI3Xu0/o+NY6XbBjKt4NNjZgQDZUqrJWFZ
         oYqN0yw+iOnoa+lQ051giMYvAeiKqlXotsouB1FCF5gbkuenA6Bl8Zi8pJen8khmWEhV
         6RGRI+SbB/tq3o8aF7q9Nm6/CzWGaHhI7IMT1jHHDTEXD28r9pZLQYNT0r/+bRNQIhBe
         xutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LBPW3fMyICXdUnGUVW6erk1L8DkgBFvdBy+5fInXDF0=;
        b=0GkCnMG57BuMs8PovxdD0jrfw65He9U6IFjSfKD0x9I5RJGIV+ZDdvQSylrbo+1p4k
         AJfkkbD03KDrq5kVOj/JMAB48OO58pmEsL/TgnmRDsvZm95q2qLw3oNHGiohPVc81bl0
         Y9/emqDu1owV1xmmIO4rDjFIM+/PR+5qmjVkMtER9nKdsZgcIXMYChRUb8Wcw1sD7fkN
         rmA6o4Gk0xo8cSQ1xpgB43ddNMa/LyXd/8+5mEPkVW3atmeDtMO+7fOoSrwW4HcG7yBu
         JuCJ9u087rcumKJ9AFAISjSuhkRXzOAoIeRzHNvWZY+aW/KWnmmNSMcGARjghYSVUU/D
         KFrA==
X-Gm-Message-State: AOAM5322OvwM4hamgr420rCyPU7ix4wT5QGyKoZEFg5I3mtJD3Hl2diW
        6LXeuS/WRtqOolKVzjfeM43E7WzRWEmBnw==
X-Google-Smtp-Source: ABdhPJz82C9z0HnqtBgqMno+vbXO9PXqt7ZzBH9Rgoid0TlRr7o2zfea/0qmiiTwRmjkjf2NDzpRxw==
X-Received: by 2002:a9d:4b94:: with SMTP id k20mr317264otf.203.1634181075684;
        Wed, 13 Oct 2021 20:11:15 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id w9sm297220otp.64.2021.10.13.20.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 20:11:15 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net, neigh: Reject creating NUD_PERMANENT
 with NTF_MANAGED entries
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211013132140.11143-1-daniel@iogearbox.net>
 <20211013132140.11143-4-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4553162b-86df-38f5-cd26-107bdee40116@gmail.com>
Date:   Wed, 13 Oct 2021 21:11:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013132140.11143-4-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 7:21 AM, Daniel Borkmann wrote:
> The combination of NUD_PERMANENT + NTF_MANAGED is not supported and does
> not make sense either given the former indicates a static/fixed neighbor
> entry whereas the latter a dynamically resolved one. While it is possible
> to transition from one over to the other, we should however reject such
> creation attempts.
> 
> Fixes: 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
> Suggested-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  net/core/neighbour.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


