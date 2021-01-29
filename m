Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD8730842C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhA2DSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2DSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:18:01 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD92C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:17:21 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id h14so7389020otr.4
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OPOWpyHgpQfbAvBGm1GnWarvC4T7zjRmXQB+hKCXh84=;
        b=tVZeITCslH/14Eb+8JoaLTwFviTHUw9lV6y0atoWquerZbfN0NE/OhHa6OT5r2tajK
         +RrlclL6AmcvCutcSWIfOfrRltaaDB7OmrWeWBYw0eZIpTsH74lcJF8SmldYUG6JY7tE
         WFE7N7/TtO67Wee9l3aNGXuvQXPiLzcSIgeQ2EGa69zYY74FKf/4F6y94DXi8gNJB/1f
         hgeS2NX/fMQjc+Zm9zFMfTU79x+Jq3W3ffS1WIno0dnkWw9ZsgA/1T7K6sJbMXNHzcmQ
         dbs6/EPrsGVqHedmWeXYQcv2jcQCWl4ULBbLbSCyHKYjeRmdFgvorgYsVU99AicGy5AO
         tZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OPOWpyHgpQfbAvBGm1GnWarvC4T7zjRmXQB+hKCXh84=;
        b=MYYIR/Vqi425DhkMhVp8pVSlT88fOlBQAUvPmb5sUmvGGPJvnWC+KbG1kneKWiRtxn
         IySlSdwouxoicoK60xgbQky1ICwDerVseJGBsH4t6JWzrIx0+Awpye+KjqkcfIvd+fJW
         BSL0bqAp6+7qIGQr2CKl2zAL92BTsxE88oFLi8bEfse42BFdrM0AtrGerdJ3mfWXFkyy
         mHglWw8HexMa3t9fyw1EnK2wbwVxYVuQdwxrOJv72gOcXlEhd2mQ/VQgmRmH2UVR5RKP
         1m8qjcZ9J/lmeO67lEcKO85e/ok/ZRmtNq65qe/AY9AGY5wTZx8xMTlC4DxFRF3w9iBo
         diYA==
X-Gm-Message-State: AOAM5312K1qJxJ5g5KANpyCtXij+3kG+o4UrQhSIJ3cAk6PQ93k5/AW1
        4fDugNSy3UGzNZFXWI8sKo4=
X-Google-Smtp-Source: ABdhPJz1uPptoJXaQL9JhRjQdsMhm+3WtAsqpQcydBLdXR1PmQR+GvH0KC/erhaQA3AQPXp2PFaVFg==
X-Received: by 2002:a9d:611b:: with SMTP id i27mr1806567otj.352.1611890241127;
        Thu, 28 Jan 2021 19:17:21 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id v67sm1738293otb.43.2021.01.28.19.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:17:20 -0800 (PST)
Subject: Re: [PATCH net-next 08/12] nexthop: Extract a common helper for
 parsing dump attributes
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <abc4e50cfa17069b15644755da69bf7c1f47855d.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6b2aa244-d9bb-51fa-c362-034e3a0617c4@gmail.com>
Date:   Thu, 28 Jan 2021 20:17:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <abc4e50cfa17069b15644755da69bf7c1f47855d.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> Requests to dump nexthops have many attributes in common with those that
> requests to dump buckets of resilient NH groups will have. However, they
> have different policies. To allow reuse of this code, extract a
> policy-agnostic wrapper out of nh_valid_dump_req(), and convert this
> function into a thin wrapper around it.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


