Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1986F2D45BC
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbgLIPpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730836AbgLIPpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:45:18 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32681C0613CF;
        Wed,  9 Dec 2020 07:44:37 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id o11so1766310ote.4;
        Wed, 09 Dec 2020 07:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L9Pq6BNyXG8ajxZyez3wZsQ0mKu/8ydF/Z7laX598Co=;
        b=sn11wMPpiZyhhkIWsiIm01K/deqwOxQ5hJ3ajWCWQ0rjiAhA9iuHbUrzz4PiSP/KIN
         gQ6bU2F0CYPk9f5AZHuPamZlk1giLV3ZzMEsY+56niIQbjnitaBHta+t145GUDQbvqJI
         D02+U/LYN1/g9pExDtsEAT1LBGm1p6Oa8TqF+rsv9DXS2O/AMrU1ZKDZjGq0m86YFzt1
         eEXlyQFAog26HzPxIkhad8O0mo3dcXHaL2noTuPPDz6h/PZif8mCc1lqD16uHg43mwwZ
         C0xrVS6NU95pKKzi1MN1UY+VWl+nV4ZSNMd1fSq8L9bh7YdbylHIY6vtds/+wciLT6aC
         uDbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L9Pq6BNyXG8ajxZyez3wZsQ0mKu/8ydF/Z7laX598Co=;
        b=hs9dXlPkERT+f6v8SdCOHaiLDmOQzLxiq3+mDdPGj6Mi5H6Ub+HtLSGsDx79bKWkQi
         fpqrqcNO3Lsc+TUvhl3FPKznkhdCjchZzBrRxGuXOLGAEsV0F9clePJ0qI70iPekltsV
         KcP2jMF5ZTQX4ESfb1eBNw62jAeQpffirQ1BfBEE0UIc3mDHYf+XCmGiwEE10YkGKHHa
         EoiBpesstjkjVueaId00m86Xlxwy65lyB3oRh/2UFnvQ8sq9AnbKgtCrSt0tuQQ4SpHk
         cRqF3ijpbQptGYJp0vDt7cacg42HkW5m/zFd7m0y5P5CoSUzV/5m+ojuDoPzw6Pg3S7W
         l9jg==
X-Gm-Message-State: AOAM532dcsXNftApY/vrIfp4d7CIoY1Ym33mbj3OvWcbvC6BnIhNB7KA
        ePjnWqIUTnKOB9NP9Dh5ryM=
X-Google-Smtp-Source: ABdhPJwf3/fYJzlqB2LPqMIKJHGAdXaozX1tdzHebBwDewhAxnnjKAvPoU3ss3ZqGK6l69aHoKypNg==
X-Received: by 2002:a05:6830:1b7b:: with SMTP id d27mr2393689ote.132.1607528676657;
        Wed, 09 Dec 2020 07:44:36 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id v13sm381328ook.13.2020.12.09.07.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 07:44:36 -0800 (PST)
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <20201207230755.GB27205@ranger.igk.intel.com>
 <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
 <20201209095454.GA36812@ranger.igk.intel.com>
 <20201209125223.49096d50@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6913010d-2fd6-6713-94e9-8f5b8ad4b708@gmail.com>
Date:   Wed, 9 Dec 2020 08:44:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209125223.49096d50@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/20 4:52 AM, Jesper Dangaard Brouer wrote:
> But I have redesigned the ndo_xdp_xmit call to take a bulk of packets
> (up-to 16) so it should not be a problem to solve this by sharing
> TX-queue and talking a lock per 16 packets.  I still recommend that,
> for fallback case,  you allocated a number a TX-queue and distribute
> this across CPUs to avoid hitting a congested lock (above measurements
> are the optimal non-congested atomic lock operation)

I have been meaning to ask you why 16 for the XDP batching? If the
netdev budget is 64, why not something higher like 32 or 64?
