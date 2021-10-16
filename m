Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D95430461
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 20:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbhJPSx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 14:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhJPSx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 14:53:26 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B60C061765;
        Sat, 16 Oct 2021 11:51:18 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id s18-20020a0568301e1200b0054e77a16651so310129otr.7;
        Sat, 16 Oct 2021 11:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lRaBgEyittHKBK2h5gC0f8naLdNIyPapK0kNW0wm3kQ=;
        b=UybbvQLPI+afwna+vM/UogpVn+VEnL3jWkLtd2alLQFXeNtHhFBcMulpb1C1tofdwF
         hm8gLGCOwbC6n/A3s7tD3UtR6+szyLIyzMsif7QyKRxBcBCBbaTBZRin79nh6JQxeNpW
         N6Kg3gWWOFErFf37GxqzJF4gib2Px2P6CXQIKxHz97/VnZaMme0OqDCreJ5yNGowcSx5
         rWnqyP3KjZeAgfTzlbNOX+JGcS9krQrYQDRRa6bfsDrZNsJHYeAHAjSbM8oHwSZx+Lrm
         OvO02RUAvLIdVlLpH1CI3BgmWh2+1UOycBVii0Vn0p/cMKkSZafLJtGqcdCl0POsOr5s
         eb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lRaBgEyittHKBK2h5gC0f8naLdNIyPapK0kNW0wm3kQ=;
        b=1u9SY/YBiNsg5Q5BEidEM+avBABWVXbIcBwA/B6TJh7O6KOYr63jRfyVysNSgR1yBK
         P3XXqJnrKslz9F1709b1JX4N+YcGQMfVrUmxsOJgdBGs/pRb5kV+ttasimwc1I3UoxED
         EXbXNap/J9VWyHTwY954lPstYpuUeosGuodqgghqaPp/rQCJTTudFxd2L4i91isZgkkB
         yrI/0792uq6niUMZdamqdjObHv8Z7nOcI5wNdAT026lKXkKwEIwGhA69QOjRtS9E/GhS
         K2W1bs6h4aCz7ZYKsKYbDGIEwlDAQJMBcNDcpco6/ITBA/FXFfZ7W80QuZhxQYcNGlEh
         DFQg==
X-Gm-Message-State: AOAM530RIG3TavUBznGbPsJPovC+2DwyxIhrVYwHZTWMYizfhPj3eR+O
        5hD2HpXpA8+NrfK6MAOVupG0gQTP1Jhx8Q==
X-Google-Smtp-Source: ABdhPJxC7pnO20RU0QQvtDmAV42p3fMRxruB/NTy+64av3Z2ooFInADExU1ZGTLwfEqGhVsYesCjRA==
X-Received: by 2002:a9d:19e8:: with SMTP id k95mr14230024otk.284.1634410277926;
        Sat, 16 Oct 2021 11:51:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id i205sm2000009oih.54.2021.10.16.11.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 11:51:17 -0700 (PDT)
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
To:     Florian Westphal <fw@strlen.de>
Cc:     Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
 <20211013092235.GA32450@breakpoint.cc> <20211015210448.GA5069@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com>
Date:   Sat, 16 Oct 2021 12:51:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211015210448.GA5069@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/21 3:04 PM, Florian Westphal wrote:
> I'm working on this.
> 
> Eugene, I think it makes sense if you send a formal revert, a proper
> fix for snat+vrf needs more work.
> 
> I think this is fixable but it will likely be not acceptable for net
> tree.

Thanks for jumping in, Florian.
