Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3888A32E0DE
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 05:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCEEvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 23:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEEvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 23:51:53 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA07C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 20:51:52 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id c10so841813ilo.8
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 20:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TnGi8AEpI5ZKVG6mnh7UvPhO+sCMtGAg+B+k8ek7+Lc=;
        b=ZUDl7FgCgEEyjrIb3yi3eGZNJ9UAicHuInZ+8wrXeUBkj0f+hU00FpRUh9Cqi7031e
         xg0nM5gHs/+/qwvf4ALrzWYxNWXROHlgz326HOTQozczvsec14R+aPBFNH/Mr3V+9GFd
         UuYClmrXCpA5HFjcztUnaUqJnMIUIYg8aYw7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TnGi8AEpI5ZKVG6mnh7UvPhO+sCMtGAg+B+k8ek7+Lc=;
        b=OQ485VXqhdNpXUCExPM1UmwgQ6aAlGTmCBYW+4gTSLfDXS1wPUGUwOQ4jNM6PDJxI6
         oPulnhv2IZev03srC+BsOAKvChAwyDmrRpqBiqjDQzz9aiHOvD8GYql3OiF6RgHxvPc3
         Qyc+DY+NycxNwCWW5SwC6TBBDA/sKpTvLPFfYaHUQeAL68b/FZ37P9PvkEakX6i0JVAp
         doaFA1d21xO8nUKqlI5YaaN68VNDvjpCgWMk6bPgjCRniwdIzNRFhT2ejgPKE3hcP+1T
         +iQUF5qpaAj1LmZ4eoWvoqK55aw96b3A8E/YRG36bkz0gMA/lESTyOoYzC9aNLhwsDND
         PTAw==
X-Gm-Message-State: AOAM5303Mw4qEy1kDZrG+GtXr9ZrvpM7vwF6lrXdhFUgf12na5L1GgCp
        uPzrk1OrmouoNgn9e0qekU8qA5/c0YScWQ==
X-Google-Smtp-Source: ABdhPJyk6h3gmJOUonNz+suqqjPazO+vuk4ZfMZPBeYgmzD5rcx4M/SJNC97QseTC9M+TwEiqYyw2Q==
X-Received: by 2002:a92:6510:: with SMTP id z16mr7617150ilb.88.1614919912445;
        Thu, 04 Mar 2021 20:51:52 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id x2sm797954ilj.31.2021.03.04.20.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 20:51:51 -0800 (PST)
Subject: Re: [PATCH net-next 0/6] net: qualcomm: rmnet: stop using C
 bit-fields
To:     subashab@codeaurora.org, Alex Elder <elder@linaro.org>
Cc:     stranche@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210304223431.15045-1-elder@linaro.org>
 <3a4a4c26494c12f9961c50e2d4b83c99@codeaurora.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <f2d64441-81af-3e11-18da-390f91fbaf15@ieee.org>
Date:   Thu, 4 Mar 2021 22:51:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <3a4a4c26494c12f9961c50e2d4b83c99@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/21 9:44 PM, subashab@codeaurora.org wrote:
> 
> Can you share what all tests have been done with these patches

I'm testing with all of them applied and "it works."  On
the first three I think they're simple enough that you
can see by inspection they should be OK.  For the rest
I tested more carefully.

For runtime testing, I have used them on IPA v3.5.1 and
IPA v4.2 platforms, running repeated ping and other network
traffic tests over an rmnet connection.

For unit testing, I did essentially the following.  I'll
use the MAP header structure as an example, but I did
this on all structures I modified.

	struct rmnet_map_header_new new;
	struct rmnet_map_header *old = (void *)&new;
	u8 val;

	val = u8_encode_bits(1, MAP_CMD_FMASK);
	val |= u8_encode_bits(0x23, MAP_PAD_LEN_FMASK);
	new.flags = val;
	new.mux_id = 0x45;
	new.pkt_len = htons(0x6789);

	printk("pad_len: 0x%x (want 0x23)\n", old->pad_len);
	printk("reserved_bit: 0x%x (want 0x0)\n", old->reserved_bit);
	printk("cd_bit: 0x%x (want 0x1)\n", old->cd_bit);
	printk("mux_id: 0x%x (want 0x45)\n", old->mux_id);
	printk("pkt_len: 0x%x (want 0x6789)\n", ntohs(old->pkt_len));

I didn't do *exactly* or *only* this, but basically the
process was manipulating the values assigned using the
old structure then verifying it has the same representation
in the new structure using the new access methods (and vice
versa).

I suspect you have a much better ability to test than
I do, and I would really prefer to see this get tested
rigorously if possible.

					-Alex
