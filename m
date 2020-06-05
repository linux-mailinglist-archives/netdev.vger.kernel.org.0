Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A731EEF05
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 03:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgFEB2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 21:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgFEB2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 21:28:01 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C6CC08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 18:28:00 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id y11so2949245plt.12
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 18:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oh3RQ6JDQkbPXPvom3KF0z9qoAD4T1POkLA2/3FZv/o=;
        b=m///FmyYDOPzDbvBYVCTMuW319h0aXpB+7c4L4k6zJXXVE/OfuF7rzCeJVPV36mYa/
         lEboonnX6/B3lOSXghTMDk+YeSMvaPy/nXS08S1P8WUoqO/wZdT0twkdzEXxkYTUi7Kc
         yGP9YQl0BpI0Mm0GTSq+KPHu/+AxdFVLpBsj8Y7cNbHbvJ6P/mNVIi1o4EpllHLaKdMi
         fXCJuPbFScyCcWmCI/J7m+nO1+FKutdZfedvdnbUYQIU6s2/qtuU+46oOU0almVsLBLo
         wSdkSDC0xfAIxKrEA3xoXWr3D/tqKPQg4y/eb7A+uemn96s2h0QLZjW9P9ZfDGWi1B5e
         SlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oh3RQ6JDQkbPXPvom3KF0z9qoAD4T1POkLA2/3FZv/o=;
        b=GAuGQW5dm498Z0lc828q76qMLg8b5KG2xb698J0HzuzAxfvMSRgfyC0Oz9BLjH/7wK
         YBd5byI+d4oegWNInOY6YJ5NCbtK2jqmR42HD6JZRBQFEv1bqbFyEMkkYOICXvLiVGDL
         12R19iISuJ75x78U9NxAZ+8hTp46Jg0918/CwhUXOFyJ3bKAM0daKfqg8gwGSApJ9AYd
         Wby9uvrVmUbP04d+k6K8gXy5Fi/nUch4DzMVtt0hlO8oJ7W6mjoM1n/dW5QmfnRD8qJd
         6eHlSpBT0HF37D59kw+pVn/hxTgbuamZQUTb1Mfa0JMLLgw2I4KBmiaFTvGjLn6BGyCS
         d0Qw==
X-Gm-Message-State: AOAM533Qagx98xQmGmhiEmQk1VoRxpF8i0DrzirevmOL1ecrgPymwM8K
        /rbsAaOyT5A1M5l9Jea4Ri0=
X-Google-Smtp-Source: ABdhPJwWsJqt+apUd4niglFtZxTgdn/QeCqQZlGsT5meeMsH2PUtfkAoMPYXKOy396mI8E9j/MSMxg==
X-Received: by 2002:a17:902:6bc5:: with SMTP id m5mr718940plt.101.1591320480100;
        Thu, 04 Jun 2020 18:28:00 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n19sm5407282pfu.194.2020.06.04.18.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 18:27:58 -0700 (PDT)
Subject: Re: TCP_DEFER_ACCEPT wakes up without data
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Wayne Badger <badger@yahoo-inc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leif Hedstrom <lhedstrom@apple.com>
References: <538FB666.9050303@yahoo-inc.com>
 <alpine.LFD.2.11.1406071441260.2287@ja.home.ssi.bg>
 <5397A98F.2030206@yahoo-inc.com>
 <58a4abb51fe9411fbc7b1a58a2a6f5da@UCL-MBX03.OASIS.UCLOUVAIN.BE>
 <CALMXkpYBMN5VR9v+xL0fOC6srABYd38x5tGJG5od+VNMS+BSAw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <878029e5-b2b2-544c-f4b5-ff4c76fd6bd3@gmail.com>
Date:   Thu, 4 Jun 2020 18:27:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMXkpYBMN5VR9v+xL0fOC6srABYd38x5tGJG5od+VNMS+BSAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/20 4:18 PM, Christoph Paasch wrote:
> +Eric & Leif
> 
> Hello,
> 
> 
> (digging out an old thread ... ;-) )
>

Is there a tldr; ?

