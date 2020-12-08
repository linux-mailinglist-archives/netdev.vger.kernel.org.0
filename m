Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BC92D1FB5
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 02:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgLHBBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 20:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgLHBBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 20:01:46 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59666C061749;
        Mon,  7 Dec 2020 17:01:06 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id d27so10139294oic.0;
        Mon, 07 Dec 2020 17:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EGTq01zt+FGxGacY/8/eJqiCW+OUcVGtSBBVhTDlMIM=;
        b=tbewH1LbfmWSPPssjZ9fk72VGh8pnG9sjKi8hebInMnZ6uTNo3HR5UWExfMZTUL/au
         1aZYJayKPplg9tmHI2SAWZufD65S+zn0SpLHykGkxjTOnThGlyS2ZlPiXCV3pfCV0Eug
         tLAqh0qz164Oyh5M/xf/CF/Ngtq1we/If65o2U3uvqxHEJdh/+2YwhQ1YzbwoEfcWDQf
         regSaDYJPOWzy/l+yJyJ/Gb1c6l9Nj10t3RT687PWOJJw7dy4gJiyzZ4MbiyhSvrpRq6
         zn/IeQjDVtAYT+21tepkY34FpoJt5cBeVPwKVt4O5k0zgAs4Ubq1WzcU9F6YIbyEmmwJ
         /NLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EGTq01zt+FGxGacY/8/eJqiCW+OUcVGtSBBVhTDlMIM=;
        b=I7uQvOZIMoYKLipu2AeR1mtUeHRmJ5ldNqlPrTBcNpthQo6H0pPuPAk4s+WUlU1ev/
         /2LAltVq4Rz/N9iXpgxqZmFQilbgJTmc/1Al/+DWpe/sliQucUAZOpq35lNPEfhR1bc8
         swngcE3RYV6GKmheYgbD0IeSgB5FuGbuoq0hf/16q53/Byl5U7DK1Zj7PKOvsMnY0v/a
         KLprxxdkJUBVmWpz4840Ak9IZwbUoGqi12m6yEFOHgUYkFDFthOKi1VsZmn7NwqHFIsi
         /xo/osPLrddfJ99uh+dPAih+FtOUWY76SD4WJh6iC1F3r9p3XBT0o0pVIvLIHdNkB7/R
         5aKQ==
X-Gm-Message-State: AOAM531KY5/o60kipBOSWPzPxaAOoqm1zeP1i1Bn1fYVD+aFO2pG45wj
        Z95cv+9e60GpgCQeO8P1gyw=
X-Google-Smtp-Source: ABdhPJw0H04+oK5NlTzWb8Vv5QEDBjnp0rTZpRqCztSA8LiqqlN/nhCTVOVS2SKQMakoGePkp9f9Mw==
X-Received: by 2002:aca:df83:: with SMTP id w125mr1038406oig.165.1607389265684;
        Mon, 07 Dec 2020 17:01:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id n63sm3353769oih.39.2020.12.07.17.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 17:01:04 -0800 (PST)
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <431a53bd-25d7-8535-86e1-aa15bf94e6c3@gmail.com>
Date:   Mon, 7 Dec 2020 18:01:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/20 1:52 PM, John Fastabend wrote:
>>
>> I think we need to keep XDP_TX action separate, because I think that
>> there are use-cases where the we want to disable XDP_TX due to end-user
>> policy or hardware limitations.
> 
> How about we discover this at load time though. Meaning if the program
> doesn't use XDP_TX then the hardware can skip resource allocations for
> it. I think we could have verifier or extra pass discover the use of
> XDP_TX and then pass a bit down to driver to enable/disable TX caps.
> 

This was discussed in the context of virtio_net some months back - it is
hard to impossible to know a program will not return XDP_TX (e.g., value
comes from a map).

Flipping that around, what if the program attach indicates whether
XDP_TX could be returned. If so, driver manages the resource needs. If
not, no resource needed and if the program violates that and returns
XDP_TX the packet is dropped.
