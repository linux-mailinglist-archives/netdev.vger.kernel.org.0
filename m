Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207EF36AA97
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhDZCcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZCcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:32:08 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF5EC061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 19:31:27 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id e12-20020a056820060cb02901e94efc049dso7010111oow.9
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 19:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IxAI/mgIy2q+f0V1oWqgPnnZYIM9N1YjbTvBrudlesk=;
        b=aDtSGSfdcpV6Bv03FpTCIpKuQpgpSiVetmqUWbBYKlqIAEW3BQOwhBo6rxJOWqxgqC
         zYFoi4g/OkLXYJmYS+c/s9XcKcF5z6ATb5YhKXXqduHNQsVHDBJcOPqPRG5+gZYKOONq
         Ml7qhTGIoZUgssDKEO4g1+bzgXK8VK3297dTfsh45yd2W91Ylu64ytRZtIEv4jAlWuO5
         2jY6AbW9bwTlNmApxxwEV0FA3s7Fxda5jCynNbS6qKfEpEWPGfmp8RZbmfAJ7ZSwS2Sn
         2BqCc6iVHs60z8lMpct/1iOiRoxtS85MtYUuA71TdOV0IPl+NB48b9r+joLt69Wy0CGz
         IJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IxAI/mgIy2q+f0V1oWqgPnnZYIM9N1YjbTvBrudlesk=;
        b=OGdVXHLH5/4vXiLQrXcY6LGbTAMNSwhnbUWFqn6/nLcn3OTvGMmHo786xdbB9W053G
         cfWcYGl6sgyGbtqE3obMWYXUj0FQfdvQkslWapQODRKV3FajAJfMIFvr5OOmzS4T1l1L
         P221FA7vmNyaOwNUpqUTYwFB51KRkyydVst3CtsGLcp91v6pMDiWBNVzcvCPNps6QXLd
         hJ9tRYzounaRQhSKLZp2qOkGdidS+fKEH29vqMjfT7SqPiPgYYYun+6Er/kg2NL7k2DK
         UTTDf+bk99g3Q5XXaL3YuUQWMtXfvLDaaPy+uk4JEhO+eltMV2d20EEq2ME7HI51wKZY
         1Pfw==
X-Gm-Message-State: AOAM533TqXNAXhGcpAJhf8DmfMyguhrE/pkmxu93Jw4KrC76JXn/lp1z
        /pGPR/y1SJUStiltmnFrMfmo0w+Pp5A=
X-Google-Smtp-Source: ABdhPJz8LNlE9F5HAsClp4VLxk+FgGE5DtkQukWtxQOP5BYtdnnpb6qcDHspo7kZ+S7jL0BkxB0Vew==
X-Received: by 2002:a4a:855d:: with SMTP id l29mr11357931ooh.29.1619404286761;
        Sun, 25 Apr 2021 19:31:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id b12sm3173913oti.17.2021.04.25.19.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 19:31:26 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2] ip: drop 2-char command assumption
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
References: <9008a711-be95-caf7-5c56-dad5450e8f5c@gmail.com>
 <20210420082636.1210305-1-Tony.Ambardar@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e1811823-9675-79ce-3821-c3855b4f0eef@gmail.com>
Date:   Sun, 25 Apr 2021 20:31:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210420082636.1210305-1-Tony.Ambardar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/21 1:26 AM, Tony Ambardar wrote:
> The 'ip' utility hardcodes the assumption of being a 2-char command, where
> any follow-on characters are passed as an argument:
> 
>   $ ./ip-full help
>   Object "-full" is unknown, try "ip help".
> 
> This confusing behaviour isn't seen with 'tc' for example, and was added in
> a 2005 commit without documentation. It was noticed during testing of 'ip'
> variants built/packaged with different feature sets (e.g. w/o BPF support).
> 
> Mitigate the problem by redoing the command without the 2-char assumption
> if the follow-on characters fail to parse as a valid command.
> 
> Fixes: 351efcde4e62 ("Update header files to 2.6.14")
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
> v2: (feedback from David Ahern)
>   * work around problem but remain compatible with 2-char assumption
> 
> ---
>  ip/ip.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 

Applied. Thanks,

