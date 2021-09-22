Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBC7414F85
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbhIVSCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbhIVSCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 14:02:09 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63646C06175F
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:00:39 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k17so3388027pff.8
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/E+ZaJAcGZZai2xg7IKnGdqCdVN4fWT167FC5R51m5o=;
        b=lISvdFb1HKDLHkCa6OJs1qTxWFQHWX6pa5mN74G9Uch6+uFqZEira4oXt/SczkuOyv
         feUErMfHjqzgu7VUAw4iZeLjSqpLUQrBpwdi9MAtG2qM+eMsvitEAIfC0a4lClX5i9F1
         UwN9LLSId3zHLCE+4SQBND5dv9HmEvndUwXWYdFDof9YAIDGpm7uqn/I+auVpE9eGsxc
         YAIcvAaITxs/xMkZT7iqBRLUSxnf4xPyyWKvazoKz0KwfSmXtD2nkF0BwamxIN0l4Txi
         Lx927o65ae02strOWTlwZNopyRoJJk+M9dTNKmuOn3ABO74oFRStECkr68Et3768rcp2
         Ihrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/E+ZaJAcGZZai2xg7IKnGdqCdVN4fWT167FC5R51m5o=;
        b=t30Hb2QZqx5WxotUSS6spa0hzWtjpuKep9J/mUzFhS8QzHZZXXb//YMtyJ9Ts0XQDK
         GxRg0oWpcsNhxqrK2WO42yOfTw2v1/U8Mc70uq16Jyhjx3uyvkYheJULtbJNgiT/1rjt
         224ClibRUwI+n/FB8GEJSlKP6vf0x8hk2QhM/3QBj9HZHuIfHSN1O9/Vrq3/7u3Uqa24
         qHbZniTpfFj3BuSc+zkIeIbAlQoaSaW3v0D3ZaNDlM9pyuWGfuRK9lKRDO4EpKiXQAzL
         Tx3w5TEI0++FA3biI+uv/glbcJkPVdGWlI3o7B+XdW4Vi+B0VlNElqa2Qs1kg5dWv+8P
         b9yg==
X-Gm-Message-State: AOAM531VUEkyAbRVNou6FUuCPd9cJ9Pc9zwz8RXQXOgDGbYMMsLfY6AA
        HqHsVAfH3PS84eTDnDwtoyo=
X-Google-Smtp-Source: ABdhPJwUkVp99pguDE5xZb5iTNztIvhZvfZ6P6cgfNqCfcUxUHf45oGeFt8Ja7482uRXhf8y93zVBw==
X-Received: by 2002:a63:a74e:: with SMTP id w14mr209741pgo.104.1632333639036;
        Wed, 22 Sep 2021 11:00:39 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w18sm3168805pff.39.2021.09.22.11.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 11:00:38 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] tcp: make tcp_build_frag() static
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
References: <cover.1632318035.git.pabeni@redhat.com>
 <5e04e52a27a272a19d23162ea20ef62fd91c94b4.1632318035.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8c1c80c5-c802-78b1-a92f-480f5dfcacf6@gmail.com>
Date:   Wed, 22 Sep 2021 11:00:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5e04e52a27a272a19d23162ea20ef62fd91c94b4.1632318035.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/21 10:26 AM, Paolo Abeni wrote:
> After the previous patch the mentioned helper is
> used only inside its compilation unit: let's make
> it static.
> 
> RFC -> v1:
>  - preserve the tcp_build_frag() helper (Eric)
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
