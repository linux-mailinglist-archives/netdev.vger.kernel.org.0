Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3DD386F82
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346092AbhERBni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346089AbhERBnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:43:37 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96090C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:42:20 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id c196so110932oib.9
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jNcPX5FbLH0YqNh/uMQAHB5aEt4BHHXLeWkcuFkhW0U=;
        b=kMajEdI4vtBz4P/6F7S+ys4OoIxsHCFvaURBpDHQhW68wcy0DJcmdXhapYG9wiKbSG
         pMeRnMBUOnjn2QwWZj3lrbVOoRB0yQD+zTENExa+oxf93vzZ0CDzbJ5deiwhaQj7MwrF
         nTp4fwsjO7uXVelGauPwwev+hlMF6afoEluUUT/p6y3vud+z/dvLb2T1SCunp/FePNoc
         SbwfPyuIjuRRtsLuBWwjXZhNpEJ49p2as/MGul782ptO+tOXYSypeT9Bz3+7bxWcNBRx
         EPRZ54fgyOV7diyIQ45+6qVOvZxJCDVFSDsIKBg9VxdQdj+JlpdNjy3zGVunVNBOMrjj
         oUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jNcPX5FbLH0YqNh/uMQAHB5aEt4BHHXLeWkcuFkhW0U=;
        b=dMJhjugipEIgksajGZwkeMGwE5Xj/N7ZFS2qn3GV554MpGZ2WZnUglq7mASDN5ybz4
         0DZLribTVPNKR4ioIky9gKLqApXSNSGk5lEpK+/IHG7/WOTnmBFP1zph1popSTfsmY11
         ZUvTwQl1pv+HS0P8nyEI/To7axCbTKgT2CWNCnrEfi1+4vHTWvJXxC6uzcqjTBGgx+oP
         lgRorxzvyZlkd+Q3HgG3R5umVLT9x8N7HHl2RcRNQj+3fMrY5+szK3xpytLUzY87WZ00
         TK3f6rNRjgfKBIaM70eLKs3yS161yG9U+gXWwgdNEEukzLO7lAEFzIFks2GbHgEmdyOp
         nuzw==
X-Gm-Message-State: AOAM5316IVzSVNLkF8o7htUR7B8WYu2Hrh3K+PX6n/ToVOZ7x2bToogw
        vc7lnMm8yNP5fLGhJoc4PwI=
X-Google-Smtp-Source: ABdhPJxOSvLHd2IrhvTWa8u6zvOGoCR3Riw7ngGLvflV7vqTxTTmWAMArvXY3fN0pSNGEZT98Ie8uw==
X-Received: by 2002:aca:230e:: with SMTP id e14mr2075100oie.58.1621302140121;
        Mon, 17 May 2021 18:42:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id u6sm3539327otk.63.2021.05.17.18.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:42:19 -0700 (PDT)
Subject: Re: [PATCH net-next 03/10] ipv4: Add custom multipath hash policy
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-4-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2f933d9c-905b-0d2d-d115-90a256a63c01@gmail.com>
Date:   Mon, 17 May 2021 19:42:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-4-idosch@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 12:15 PM, Ido Schimmel wrote:
> Add a new multipath hash policy where the packet fields used for hash
> calculation are determined by user space via the
> fib_multipath_hash_fields sysctl that was introduced in the previous
> patch.
> 
> The current set of available packet fields includes both outer and inner
> fields, which requires two invocations of the flow dissector. Avoid
> unnecessary dissection of the outer or inner flows by skipping
> dissection if none of the outer or inner fields are required.
> 
> In accordance with the existing policies, when an skb is not available,
> packet fields are extracted from the provided flow key. In which case,
> only outer fields are considered.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  Documentation/networking/ip-sysctl.rst |   2 +
>  net/ipv4/route.c                       | 121 +++++++++++++++++++++++++
>  net/ipv4/sysctl_net_ipv4.c             |   3 +-
>  3 files changed, 125 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


