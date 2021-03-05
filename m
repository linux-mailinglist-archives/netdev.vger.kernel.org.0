Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A34232ED78
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 15:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCEOuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 09:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCEOu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 09:50:28 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73BFC061574;
        Fri,  5 Mar 2021 06:50:27 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id a24so1507983plm.11;
        Fri, 05 Mar 2021 06:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/CfVIAQFkmtf7QRx/0l0Cqj2uolvt+E+hBzw2tUvPKY=;
        b=H3j3xqiLjFoFh9ELEi1SBVd2DnvtGRw+DOgGh+hRuLX0hQqTVLOwxMBe2kWvW+B5yj
         xfblJZpXx9VcvVvEBC+bFkCMCkrnunebY8JQhSWUz9jkRc8Nnj41nQnVZen67QvZlkOd
         Ecu2BPA+BJJu5TogdXQKR32A/HS4bL7g0xbHRn8oedyoRikx9NjNmfOW1vkW1KNeSmyi
         pfBvvv61AXK4+xzs5oCFH7qE+07gNMTLcOq/O8hCnBDzv9pfSuahvWgtEuDEFK2fRqSa
         qVGND2fawYr/A4QHG2HC27+TEqwLCUrIgilHOG2jjSjV9cyJo0u4821Jan4GGF1CBMAQ
         S79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/CfVIAQFkmtf7QRx/0l0Cqj2uolvt+E+hBzw2tUvPKY=;
        b=CVcJfsf/iF/PVvap6Ien80P+wAtCIVp0suZRmqCpa5ezRiRuG2+C32SJRz0K1oW19A
         cpNp5b0b97qIyxX0m8DUe1Aiagd2MD+la/P73Ow9LlBX53I4+ZYlxYDl9CIRc4DT1Wkr
         PtcIZTrP4imqZKrhxPpWAbucmbz8MGctXSqVhr6Mr1LNxtrX5US6P1URIur8jpI8URDb
         SVnqGPMaS+xHHb+jRB3ex/MIJSTLSHRXMzOoctT8P8ADIx7+00J0lo9o7AVGLjSyyz5v
         zme5FqXazJ0y6fhoedS4mkzAXMpI0SPhfkAldSeTWL9Focv5TmlZV12shE789nxwIU9P
         Fu6w==
X-Gm-Message-State: AOAM533jCqcWYO0uhh4/R+sBTeNF4YfxiM2nUIxO/IUd/LdmUZ/X7e9/
        /Vd8EyJlfLe915QZWIxiOGltdzOACxJhJw==
X-Google-Smtp-Source: ABdhPJxNfosO+A/6cS3uqlac2/Hk0XHcvaWKnF2dtA4widlyoweiw8rZhtna7eBzdLHEQNN9CPmpZw==
X-Received: by 2002:a17:90b:a04:: with SMTP id gg4mr10868747pjb.51.1614955827453;
        Fri, 05 Mar 2021 06:50:27 -0800 (PST)
Received: from [192.168.1.18] (i121-115-229-245.s42.a013.ap.plala.or.jp. [121.115.229.245])
        by smtp.googlemail.com with ESMTPSA id y2sm2820124pgf.7.2021.03.05.06.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 06:50:27 -0800 (PST)
Subject: Re: [PATCH bpf] veth: store queue_mapping independently of XDP prog
 presence
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        makita.toshiaki@lab.ntt.co.jp, daniel@iogearbox.net,
        ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com
References: <20210303152903.11172-1-maciej.fijalkowski@intel.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <3c05a530-633b-03ce-2362-8dc9d5a76d98@gmail.com>
Date:   Fri, 5 Mar 2021 23:50:23 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210303152903.11172-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/03/04 0:29, Maciej Fijalkowski wrote:
> Currently, veth_xmit() would call the skb_record_rx_queue() only when
> there is XDP program loaded on peer interface in native mode.
> 
> If peer has XDP prog in generic mode, then netif_receive_generic_xdp()
> has a call to netif_get_rxqueue(skb), so for multi-queue veth it will
> not be possible to grab a correct rxq.
> 
> To fix that, store queue_mapping independently of XDP prog presence on
> peer interface.
> 
> Fixes: 638264dc9022 ("veth: Support per queue XDP ring")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

I did like this in order to keep the default behavior for non-xdp case,
but generic XDP should behave the same as native XDP, so

Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
