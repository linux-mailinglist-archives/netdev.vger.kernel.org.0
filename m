Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378BD12524F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLRTu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:50:28 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45528 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfLRTu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 14:50:28 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so3566516wrj.12
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fU0K104stEqCabDcHL05vs2+3PCVuM6D4oC4kCEqvzM=;
        b=IDZBHq0sbrkjRl3Ip6LOuUMLan/T+gCsJz+nKb1dT9y3wcDLSnC/lnhbD+Y33NqdHm
         5sCJHRKoUQBt7uWuWmD6KbgyQsjqrZquMgLJtxFe7K2lXQH5LuiWSaMPgA2QzbapJOhd
         IiNflHOMMzkRyGbKf1GDxxUxT/hm8Jq5CtF0RKU7x/DRxjUWyoLda6XXwTaVi7OXEJRj
         PQ25pK8G9D+KyxMXt1eAADTHyfstQ1mhArgm4PuVUNFP55l75chFX5eRtXtBCJlCNMt0
         FwwF1xxXifovKz3OWZZTMOA8r3D13jruZQW1YlLKVLyP5nTgSEbpKtI/THdzFANE7ry3
         px7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fU0K104stEqCabDcHL05vs2+3PCVuM6D4oC4kCEqvzM=;
        b=bB3tZh06KDPaBoM1jaQswaZUcl8MoG0WvOmE5qliqcIs5G1Q7o0guBtMCMrRFNjjlq
         bD5uOkXLHHhSJnnu1JjDaDRbDEBL49pNP7RTtugDfq+nrrFINdjkhKZy79VNhd3eGLIv
         hZg98GQ0MCirsGCM2YR7aJxUc6BRE5COjdsAkmyPl7p52sSctbytvP6UFK+weplTsYBY
         zcqNQq1O4qDITaACEiaBrTKCEZySBvr64kIrixSKZtzbPQWBATFUmMKOPHUO2C6PBG7o
         KVM8ewbqVLo2eSK6wYc+waomDsZ1WKqlxhotGV94QzUD07hn2M/oTm0vc33S2YEybt5R
         tKGA==
X-Gm-Message-State: APjAAAXTGZho28FVJiNgEwJqjRu61b6QmnEm+hCuJkMqbmFXwUnwR+uz
        d51grharWP2uDdu77lFNfizYa3SC
X-Google-Smtp-Source: APXvYqzMiNGqfHsMm30W3scYGZFarIKaEBh/l4Xz8opVV3gCr1d84VGgkDqhSxRXLj2A+W7uTf0+fA==
X-Received: by 2002:adf:9c8a:: with SMTP id d10mr4729927wre.156.1576698626274;
        Wed, 18 Dec 2019 11:50:26 -0800 (PST)
Received: from [192.168.8.147] (197.171.185.81.rev.sfr.net. [81.185.171.197])
        by smtp.gmail.com with ESMTPSA id c2sm3728917wrp.46.2019.12.18.11.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 11:50:25 -0800 (PST)
Subject: Re: [PATCH net-next v3 07/11] tcp: Prevent coalesce/collapse when skb
 has MPTCP extensions
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com>
 <20191217203807.12579-8-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5fc0d4bd-5172-298d-6bbb-00f75c7c0dc9@gmail.com>
Date:   Wed, 18 Dec 2019 11:50:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191217203807.12579-8-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/17/19 12:38 PM, Mat Martineau wrote:
> The MPTCP extension data needs to be preserved as it passes through the
> TCP stack. Make sure that these skbs are not appended to others during
> coalesce or collapse, so the data remains associated with the payload of
> the given skb.
>


This seems a very pessimistic change to me.

Are you planing later to refine this limitation ?

Surely if a sender sends TSO packet, we allow all the segments
being aggregated at receive side either by GRO or TCP coalescing.

