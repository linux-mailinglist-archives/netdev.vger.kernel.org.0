Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1EB286496
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgJGQfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgJGQfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:35:43 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97FDC061755;
        Wed,  7 Oct 2020 09:35:41 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a200so1612982pfa.10;
        Wed, 07 Oct 2020 09:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JlHSp96jwdaBdct47RiHB7NkTtoShuj526Rv157w8ss=;
        b=AEEkToo+xI/uX/gPobrYsYoRONOlzjQZcIE0nrz9YHQ1ZGPecQ7FBeUaODednrZ66r
         Mwmk3eQv/BDSWaOhY6s1yF4QpPH/EfBe+3i3WdVI3OqTGPcUkPjjHiuP3hmWGCKQW57d
         H+YhKHzFNJOqcwaOJhHB9bwXcf9Whdx3swygfwx/JVy4vz7h6Y/CQbQjCvCEfF8fHnOi
         rCWIVKzrpeUB4we5mZuRXXB+jrg0u8BMlVA2xDQiVnsK3cRwTQJeCsinFEiGl3LUIUCe
         dF1yttZsf1Uu52piAfRevAhJnqesFErk1QtHPt4gXU1+f3KnpiYrGIxHXc1F8ypYH4qV
         mDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JlHSp96jwdaBdct47RiHB7NkTtoShuj526Rv157w8ss=;
        b=PnRk0Fe9iQYgAMgUvfPhU5adFMnJBZBZxAQ+X1vMDeRBlch9gdYv89Z+fC2/wVHBn1
         cJx26Ev0ExvHy5LcEBGLHnKMEhfpcjV8m4fRg1qBn5DWfAzT3ld5sEZbkN6SdoGUbR85
         MK0YQV8H80GPUZDVEK5mOFlcJtXnKAVNkk0uWB8LK6o5jaCIFrtlYgGffyaOL+Ym9w6s
         1cp8fdKAkkXDLyHNyM1dR8hQt5KFb8RHsijz52ni2+TwNOpC1Wd2ow9CjJZWlqQlUKza
         f/9cWz5aUHrbX+kLdwxwuWzafkm6GxGftipOJMrlriGc6xbR97Y3ZRS5nCfMzH0+mnLV
         YbYw==
X-Gm-Message-State: AOAM532RDJafAQdwdNUklJ1FidS588XxeInNezTfBiZRz0qWTTumFJZh
        8JMl9wFnivMC/cwc8MJGL/s=
X-Google-Smtp-Source: ABdhPJy8G4BEoqwWZDL52de8879SFellCj8lLZ2IxrsIOhLmYg9xfEnMC/jjiL5K2jlzthqN59LuBw==
X-Received: by 2002:a63:5a11:: with SMTP id o17mr3589843pgb.287.1602088541346;
        Wed, 07 Oct 2020 09:35:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id q15sm4013229pgr.27.2020.10.07.09.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 09:35:40 -0700 (PDT)
Subject: Re: [PATCH bpf-next V1 3/6] bpf: add BPF-helper for reading MTU from
 net_device via ifindex
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <160200013701.719143.12665708317930272219.stgit@firesoul>
 <160200018165.719143.3249298786187115149.stgit@firesoul>
 <20201006183302.337a9502@carbon>
 <20201006181858.6003de94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANP3RGe3S4eF=xVkQ22o=sxtW991jmNfq-bVtbKQQaszsLNZSA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a8b0dd01-bd6a-2a28-154e-c30a79ce3c83@gmail.com>
Date:   Wed, 7 Oct 2020 09:35:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CANP3RGe3S4eF=xVkQ22o=sxtW991jmNfq-bVtbKQQaszsLNZSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/20 6:24 PM, Maciej Żenczykowski wrote:
> 
> FYI: It would be nice to have a similar function to return a device's
> L2 header size (ie. 14 for ethernet) and/or hwtype.

Why does that need to be looked up via a helper? It's a static number
for a device and can plumbed to a program in a number of ways.

