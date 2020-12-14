Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D3F2D9CF8
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgLNQwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730361AbgLNQwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:52:18 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BECC0613D6
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 08:51:37 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id a109so16347718otc.1
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 08:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=y5nVAsm2UyjPZEHN9RN3Qw4nJSpqnoc2eoqf5Xo569g=;
        b=AjjFRyXKjvJGZefPud9VM1gtXJIC0WuuQHJqjiFSzfck+h+8Vj2FLSit4oSHiWRTXE
         wp0wc6U1LXtLsy9PYUlwWZY6aHav4xYIpHGILTTTRGJkyxsZmom9EjUoW8zrkSIdsPJS
         n8S9lsfS8jHyxZgM4J1aq72q3KSd48oTKRmyxy2O8q5nBm9/9245SmY+qhYPf/Is9kx1
         svWXmKUkBykk+nt/X5yhWTV1RyElxeqXd7vqBMfdDB4ToWaZkidYMkTzAN3xjVirWduN
         hadveYwaluUwogk8cR9Jsv+xROsR455D8bVxz7Cd2Gm8Gg+9jS7yMWb/KvxbqvoJ2vwM
         Zc+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y5nVAsm2UyjPZEHN9RN3Qw4nJSpqnoc2eoqf5Xo569g=;
        b=bWlgOer6XYxpSyFmXTKGPjuiWok23kEPtGIU/8KT/XYhrtahAQpkstxq89f6lsg5q2
         E0M7IBjSoCw3a8chXHa6Dd1qAFT+NiQ5Xt8yRUkOdJzyQtPE7Dnn6Y+C02oWxuDVC7zF
         MJkAP4nxCQrCdz7HRvNvgQ8qPDCnmwZJ6Rdz9oj72angCrEDwiVM2Wkdw1zbJEuG32dT
         qTG7lxBZwVyB00/A74jGGB91ROfcJ5/oUGVr4zf42X56XsDlGJjzCuuI1F350U/E0Iu0
         0LHDjfsM3aSss0RzGoU6N0B3bkcovvzFqk0P85JnOFRgbsmr9zCysIIF44BtmX5ZHIth
         jj8Q==
X-Gm-Message-State: AOAM5307dV7eKJUx3Vzb3Uv1VdNoI5J1HtMbVa70M1x7/R1IImAeSPJR
        bm/9aqGiLoDlvEldRv7o0sw=
X-Google-Smtp-Source: ABdhPJzVt70+WVqhTeymwntslo/ba5lnRm9HT+zKtdK95xOABxrNJ2zgVQLgFmywysCOcujxe8A9/Q==
X-Received: by 2002:a05:6830:402c:: with SMTP id i12mr20525097ots.25.1607964697399;
        Mon, 14 Dec 2020 08:51:37 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id r13sm2209593oti.49.2020.12.14.08.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 08:51:36 -0800 (PST)
Subject: Re: [PATCH iproute2-next 00/10] dcb: Support PFC, buffer, maxrate
 objects
To:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org
References: <cover.1607640819.git.me@pmachata.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4bc2ed3a-0077-1c05-e311-150ad4df5212@gmail.com>
Date:   Mon, 14 Dec 2020 09:51:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/20 4:02 PM, Petr Machata wrote:
> Add support to the dcb tool for the following three DCB objects:
> 
> - PFC, for "Priority-based Flow Control", allows configuration of priority
>   lossiness, and related toggles.
> 
> - DCBNL buffer interfaces are an extension to the 802.1q DCB interfaces and
>   allow configuration of port headroom buffers.
> 
> - DCBNL maxrate interfaces are an extension to the 802.1q DCB interfaces
>   and allow configuration of rate with which traffic in a given traffic
>   class is sent.
> 
> Patches #1-#4 fix small issues in the current DCB code and man pages.
> 
> Patch #5 adds new helpers to the DCB dispatcher.
> 
> Patches #6 and #7 add support for command line arguments -s and -i. These
> enable, respectively, display of statistical counters, and ISO/IEC mode of
> rate units.
> 
> Patches #8-#10 add the subtools themselves and their man pages.
> 

applied to iproute2-next. Thanks, Petr.

