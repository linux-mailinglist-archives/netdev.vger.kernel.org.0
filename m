Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1352D5173
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgLJDfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729311AbgLJDfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:35:32 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D38C0613CF;
        Wed,  9 Dec 2020 19:34:52 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id f132so4224974oib.12;
        Wed, 09 Dec 2020 19:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y1+dVCzQPF0KymNAnO7YyR5jmkfWoYWWIbPSsgMPYLA=;
        b=EnbmGH79WOZ62PwDLomNtwuOxaxkeklUHmggDWLdKBkrX9fttVRYl1Q3PwS6Ivgeoi
         lCDs2I8VSbMsXqX4sQDpnMLgqwdnMF7toP0juXHPGP35ppEVwoSDi5rG4olkfpOkVkZK
         QwCSoMHmxQmXiaJH78lvnpjO4pzkct4NcEnvjoR2ZMP8xVn3ixfk/0YBphO24R/g69tH
         xgcWJpeGMQ8SUiamyg/dCHeeJBAUvdRYp+JF0MRhuntqPHWbQo4Tcx7VctIRIqHu19yq
         G0LDYjpqL0RflKnxBWXvel5gtqKGwAQojZWngU1cyTBLmpFeB94BhOibcZNJnQtLipYF
         421g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y1+dVCzQPF0KymNAnO7YyR5jmkfWoYWWIbPSsgMPYLA=;
        b=rh1et+RwWljliIiADo3OzWUPFAxw1pjJwb81OqO5hPHibl/2pjzYJq+yKIdR/RaviR
         JUJUkr8Ru3hDMgYX50kOlhV+37jN01musIOiGJkt+TgGyszxZ8byh+LwP5tuxPUWVeLP
         WtehGVi/HpTQReCAAoFZCEw31iElHR5RRLn2X0bKQgZcMKzXUf5+LqGSCc07zkKy2jzB
         /QEOdGQvPfWOQer2ycfYrhVHhCEulNwTPfSP/E0jaQjuP7xYkCjuE+WNGdeNgQ0AksNC
         ZzBIrlaX2LjjTde9ovTlhWpkvOtx/bOMWBQaohNVfGM0WdyZtffcv867fXeKM0GwwUWA
         8WKg==
X-Gm-Message-State: AOAM533L/jfmnRl2qi4SQ34v3NSwaRSuZHndE1DiLnrviUSCmKqMCEaX
        pBSo69BPNbycyYwhLOGlIp0=
X-Google-Smtp-Source: ABdhPJzvkIhOSVedyOxoxH8BUW/CNlgcIw8xGfoa7nq64uZje5/VqHunyhjnc2jL+lVivqKAwTHbsw==
X-Received: by 2002:aca:dd08:: with SMTP id u8mr4079603oig.85.1607571291718;
        Wed, 09 Dec 2020 19:34:51 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id t26sm170715otm.17.2020.12.09.19.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 19:34:50 -0800 (PST)
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     Saeed Mahameed <saeed@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
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
 <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
 <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com>
Date:   Wed, 9 Dec 2020 20:34:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/20 10:15 AM, Saeed Mahameed wrote:
>> My personal experience with this one is mlx5/ConnectX4-LX with a
>> limit
> 
> This limit was removed from mlx5
> https://patchwork.ozlabs.org/project/netdev/patch/20200107191335.12272-5-saeedm@mellanox.com/
> Note: you still need to use ehttool to increase from 64 to 128 or 96 in
> your case.
> 

I asked you about that commit back in May:

https://lore.kernel.org/netdev/198081c2-cb0d-e1d5-901c-446b63c36706@gmail.com/

As noted in the thread, it did not work for me.
