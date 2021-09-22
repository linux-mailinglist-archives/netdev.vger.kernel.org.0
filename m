Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E0B414F81
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbhIVSBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbhIVSBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 14:01:03 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E820FC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 10:59:32 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t1so3562107pgv.3
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 10:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GhBgnSi2Lr9WzFotw0hevOMRnfvJcBKLLPZ2j+fhlrU=;
        b=QmCOXOIEvxjz8nTxorKfxdzyoOYK0FfhmJERTBLkT9M8BWHVnPZVSRg2oYXOLb1Wm9
         PuWary6cA/xQakqAdQPQ42ptvkT8IK4dUd3w4W8f23UiQbHfhZq464APLpQfTExgvl3E
         3u/J93Reu1GK+PhSIdNdVk964auhEqY0E2NHynt7zEfMJUKRpHglStnz3lvyaxL9LYme
         QoIkI9flkejMrsfwz7flSbtkVmIN1DvwtnaBu7rPqyLoAK0dCSPQPl+8lRKjlbbStQHa
         r3KGBpr6FPhLNQHujQYiPSUSMsXjLQsazD2oPjp58IY8IEF+1Z1bHz9jJmir3nkGXxyt
         7+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GhBgnSi2Lr9WzFotw0hevOMRnfvJcBKLLPZ2j+fhlrU=;
        b=PuK1qmzHcMBTNCX0b9cx+zTE3YEGdSzlhnqfEOibJ2BQ+LPnl/5zRZMy+Jex7MjPED
         pDTbojPsXzawKyDAsQk7zb5VhyIfhzAu9jMjDr4XujV0TOGmYaS/sa7O8GnAwozp4z5+
         m3Myc4HR+3KI/w/4i8C4gOAG2VhSMpo+JpRTQuQwbJRhrbxchccZI58LZc/WDUvQjztH
         N50QgbNEnquxZ2I+3Nrnrd0fuAqRW2/6p4Ex1r/WLkIDyQiBlzDYQ1q1NuvBNDAM2Twj
         xqjIGyEXC6kz7ty0Izw/umK7woZWQTte7pWBXdsiSMsZG3eBo5gRIQYwMAiBl0/pIxr8
         40og==
X-Gm-Message-State: AOAM531itJFPJ7rPZG0L23k974s0tFrRsbJlrpx7dRKg821WlZkcyNqH
        JEDjX/K6i1SeKV7RQtuaxnA=
X-Google-Smtp-Source: ABdhPJyfvnWTFsWrjbx/qytEzysk2V8EfH3+3Ak19TFm+sLAuVkiffkFFlKYDkOrSOh9bBEiKdteSg==
X-Received: by 2002:a63:b046:: with SMTP id z6mr205719pgo.106.1632333572483;
        Wed, 22 Sep 2021 10:59:32 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e7sm2998344pfv.158.2021.09.22.10.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 10:59:32 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] tcp: expose the tcp_mark_push() and
 tcp_skb_entail() helpers
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
References: <cover.1632318035.git.pabeni@redhat.com>
 <c7a97cc05d33a43991f5789469f254f78aa78ebf.1632318035.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <80871d69-a8e1-16c6-4576-f07d624e5bd7@gmail.com>
Date:   Wed, 22 Sep 2021 10:59:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c7a97cc05d33a43991f5789469f254f78aa78ebf.1632318035.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/21 10:26 AM, Paolo Abeni wrote:
> the tcp_skb_entail() helper is actually skb_entail(), renamed
> to provide proper scope.
> 
>     The two helper will be used by the next patch.
> 
> RFC -> v1:
>  - rename skb_entail to tcp_skb_entail (Eric)
> 
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

