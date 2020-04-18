Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848941AF57F
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgDRWhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:37:14 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D82C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:37:14 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x77so412615pfc.0
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JpixiLbtDn7Plx1e+Use5v1Kfn1CkanHh1lKCuq2r7k=;
        b=n0obYrUttEdkPbB7DVRIXYBHuLaH8h3G2G3DuCKihKlxtFoUBvbBhKplbToEMeIBSn
         69OrgyzXISgMDrCSUH7njny7JBjhFT2DdiSuF+WdRVLYshuChTQ3y0n5GxLQFfG+Q0uW
         vYpGtClUnETlaapAG07uSm3X38ZuGTOSGeWcqtm4nuZueYSJII6bwGXjk85PeOE6x564
         sRvYHSwaFAvNV/UQSubAKhRnekoRNrHJKUVRYvkMBNex0QtO4DMAZ6IsEgG2o0oyhhUC
         JWRd50YWKKO5dqJmDbAxRDzPkvUBck9cYtYmYvA1KTdJmUAk//SNPAd74RqR7czFxUDH
         L4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JpixiLbtDn7Plx1e+Use5v1Kfn1CkanHh1lKCuq2r7k=;
        b=TSrWf69/B7T/WD4OvXnpF4DQI+XklDlJtlRky+A7qMxAfc0nLy7OR+tcgfBU/MVVfs
         M3XEVFfqYPRBOYB9W1VKvQhvE+JW7sLoxukFBFYVdR3f/ZDgpx3IfF28WcrlvI4p7XUr
         kKCO88n67HAwAz4dmFe9ELX2IQDqmIwBmHid5CKG50Ab/QpHStPcWVlaOvdir1vWjob6
         FURYV/08xxznxk1X2sSzZg7UYxs2Rhv7x8ZBveIxOYJzQUoUbueb/swIair/mhjRLkt+
         oNQ7258o1fRviSbsQCncvpILHHaJH6vsIhOm6BJb1J1ikbH9izU1tDy802h8AeCq6u0O
         RnNg==
X-Gm-Message-State: AGi0PuYHw9bKf8m++HUGizNW7l1vO+PVsszg2rYcc7Cd4RsxauVVlUvK
        XgqZJMnJitiIcav7T/PXQbM=
X-Google-Smtp-Source: APiQypJXhThVsoko1Wk6ln/24aFeKmfKNocbBObc6rJeVQo2BWNy1HzChuAWHKSD/pfFMUHPMVQNcg==
X-Received: by 2002:a62:92:: with SMTP id 140mr9470681pfa.186.1587249433285;
        Sat, 18 Apr 2020 15:37:13 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 23sm8243568pjb.11.2020.04.18.15.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 15:37:12 -0700 (PDT)
Subject: Re: [PATCH net-next] net/mlx4_en: avoid indirect call in TX
 completion
To:     David Miller <davem@davemloft.net>, edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        tariqt@mellanox.com, willemb@google.com
References: <20200415164652.68245-1-edumazet@google.com>
 <20200418.153112.1172624610803498181.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4d4e865c-37c4-a4a7-81a2-3537ac14ae12@gmail.com>
Date:   Sat, 18 Apr 2020 15:37:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200418.153112.1172624610803498181.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/18/20 3:31 PM, David Miller wrote:
> From: Eric Dumazet <edumazet@google.com>
> Date: Wed, 15 Apr 2020 09:46:52 -0700
> 
>> Commit 9ecc2d86171a ("net/mlx4_en: add xdp forwarding and data write support")
>> brought another indirect call in fast path.
>>
>> Use INDIRECT_CALL_2() helper to avoid the cost of the indirect call
>> when/if CONFIG_RETPOLINE=y
>>
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> I've decided to apply this to 'net' and queue it up for -stable, thanks.
> 

SGTM, thanks David !
