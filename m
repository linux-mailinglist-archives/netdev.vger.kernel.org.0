Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697B126002A
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgIGQpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731063AbgIGQpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:45:03 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20121C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:45:03 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o68so8886377pfg.2
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m8ZlCKxD9/ekWe1bnHgiNEQQ5EftHREOxYf4uHOlNXk=;
        b=zOIVpnp+SSqmjR/3uK/YitVDxeG/vRqVuzg3q0ZVT8rh3hvEDSSoUiW91L0XGbcuGR
         UiBuamD70WOkfEmGUp1Lgj7Lw11CzhLSmNnOkPkCkSIZP1Rgd+hw9P/p1JenM1QYFaSg
         atlLHoFUiGmHxgCzZRP/Ya0NXiO33BmCi6lYPXWmgiZV/CrCbu08F+8Y3ne3ZoX6Odsb
         +4cTgEPRJw197B7AJygPc6TE/NwxVKaWCOZqp7DV3mK965xB8YZCDs3guSxlJolqIDN2
         IorwSvuZSQf9keglAFX4Vc9uzDAdQmCc64G4f3LGDIVGBB+P9Mmd4Jg/fHQISEIBHQyL
         vRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m8ZlCKxD9/ekWe1bnHgiNEQQ5EftHREOxYf4uHOlNXk=;
        b=SG5K/2sftsNHw9iY1drni52pDwpnPUtPdGjT6aXS+1fmJ4vrQ69RxmKB2z/IxDSmAT
         gWkXV9kEUn4jeGmWX34pz6SalmFJHgZ95YjxD45YS8nPbwkPZCC/8XLgPQicuz6Y4NiE
         oDBkmyroat9FjW8ExjLRn6goZSbL8OP+E9raiWprgQYZoo8AJdFKAV6zjXK4Jl3HVoIQ
         M4sspJ8xhA8vh1RIYwwEp7QKfiY8BAh38t2rsHteAaLkPp6wrNg/XgblMtQiUzb6kcyV
         E1TYP4kbPG/ZpYunGrNtnARdNuLMn5xwn/z0k0FLaxbTYuvaZkICmvOOMpHwZiGtrVS7
         DmSA==
X-Gm-Message-State: AOAM532wDI+4X1L6UN4liCdWtvhvsrA5tkKVs6WyaAchUkESSmJxNVNc
        /jB7oD5e8+ouxYsmrG/qVVc38w==
X-Google-Smtp-Source: ABdhPJw8RrGb6FUr3A2ui6aV0tWTRTvL2LTfVn4srVE0ccGmmdvbbRHjgjP5NN1HVMW4pasecyhzQg==
X-Received: by 2002:a63:516:: with SMTP id 22mr17753556pgf.316.1599497102450;
        Mon, 07 Sep 2020 09:45:02 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s6sm13035629pjn.48.2020.09.07.09.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 09:45:01 -0700 (PDT)
Subject: Re: [PATCH for-next] net: provide __sys_shutdown_sock() that takes a
 socket
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
 <20200907054836.GA8956@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <378cfa5a-eb06-d04c-bbbc-07b377f60c11@kernel.dk>
Date:   Mon, 7 Sep 2020 10:45:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200907054836.GA8956@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/20 11:48 PM, Christoph Hellwig wrote:
> On Sat, Sep 05, 2020 at 04:05:48PM -0600, Jens Axboe wrote:
>> There's a trivial io_uring patch that depends on this one. If this one
>> is acceptable to you, I'd like to queue it up in the io_uring branch for
>> 5.10.
> 
> Can you give it a better name?  These __ names re just horrible.
> sock_shutdown_sock?

Sure, I don't really care, just following what is mostly done already. And
it is meant to be internal in the sense that it's not exported to modules.

I'll let the net guys pass the final judgement on that, I'm obviously fine
with anything in terms of naming :-)

-- 
Jens Axboe

