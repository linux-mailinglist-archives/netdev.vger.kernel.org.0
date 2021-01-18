Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D033F2F9862
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 04:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbhARDyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 22:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731813AbhARDyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 22:54:00 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4394BC061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 19:53:20 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id f6so5803804ots.9
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 19:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jHxDJYCV5JbMDmSdZZKfDiBwh6lNh3Xm7sV0ZS+j9qg=;
        b=Zg4ZgLmSMnqz56W2110OzSFGmYoWYT/2nuQAbfGuuGV7gC4upv8d5kMiGll1XYNBVf
         O5OnauRB+SqTUnbgUnSKiRZlygmMizL6ZGeFiLIS0nHorJELbbnzGuIVzjHzGqw5kBwc
         MD4Pm4UFQHcoXkBy1fO77FZ5pDRMD7P0VRHldrd1CwpBmGWL4HPezJG+qSwTTakw39Kj
         0mayJLX8j7U+t/1sZKYapbNkYRnZ7sFvDXaCOnh65IXhmpYNb5LAhE1ziKtP/D9MJDG3
         3G8Y0S6CViEezSYe+SIsbDGWd9lgmPJxwcykruZT2FSiMslZOXUMQX9rccdcAgqqFNcA
         UgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jHxDJYCV5JbMDmSdZZKfDiBwh6lNh3Xm7sV0ZS+j9qg=;
        b=NbCvKw48DOhtIwKb8n9kfxHm7wbeMbxp07p6To0Se6jCebwbMgYfwgFAgFOwN0Xjnx
         fbQc7DvLYwPEidnnG/fOoUZFHikG4GbDD7M/HlbruQ1jKIBSKsYkUjyGI41N3KDWITAk
         l99QKI6uJR5B/eb7XoTV0NzPVpVmZY7+0GrSgy2glE6OBOgFRAO3Hu+F366+c3MJDE0J
         pLRgAthOMRzrbct2fwIED/GWaedOYukrVo7n6iCp03aXDj9xKU375O91GiPd23p+n1cr
         QUCMpvqn/L9UlCKqxgWSSbX0ZWlRj27I4ao1wTELvvdWz/KmISDxg2WAMo4po3tuKSEC
         PIgQ==
X-Gm-Message-State: AOAM530Qv8sq/sRzmEPraHTj+27eGSOxD1Q06znB++B60isyhYGNYkp/
        SJYu+Nrz0VkNGD/y1JPsogeuFos4jHk=
X-Google-Smtp-Source: ABdhPJyLJX/XaO44fO/QxeMQ6BFRVHrqj7qJ8cnfI/5U+SHOQqLS2eM5pNkYqfMT/ZnEvNckcEsNgg==
X-Received: by 2002:a9d:3a2:: with SMTP id f31mr16802741otf.216.1610941999667;
        Sun, 17 Jan 2021 19:53:19 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.20.123.16])
        by smtp.googlemail.com with ESMTPSA id u20sm3550545oor.45.2021.01.17.19.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 19:53:19 -0800 (PST)
Subject: Re: [PATCH iproute2 2/2] vrf: fix ip vrf exec with libbpf
To:     Luca Boccassi <bluca@debian.org>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20210117225427.29658-1-bluca@debian.org>
 <20210117225427.29658-2-bluca@debian.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c06b230f-53bd-7f0f-8267-b878e1303bdf@gmail.com>
Date:   Sun, 17 Jan 2021 20:53:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210117225427.29658-2-bluca@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/21 3:54 PM, Luca Boccassi wrote:
> The size of bpf_insn is passed to bpf_load_program instead of the number
> of elements as it expects, so ip vrf exec fails with:
> 
> $ sudo ip link add vrf-blue type vrf table 10
> $ sudo ip link set dev vrf-blue up
> $ sudo ip/ip vrf exec vrf-blue ls
> Failed to load BPF prog: 'Invalid argument'
> last insn is not an exit or jmp
> processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
> Kernel compiled with CGROUP_BPF enabled?
> 
> https://bugs.debian.org/980046
> 
> Reported-by: Emmanuel DECAEN <Emmanuel.Decaen@xsalto.com>
> 
> Signed-off-by: Luca Boccassi <bluca@debian.org>
> ---
>  lib/bpf_glue.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 



Reviewed-by: David Ahern <dsahern@kernel.org>
