Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C5B483625
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiACRcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbiACRbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:31:37 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF350C0698CC
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:31:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so227647wme.4
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V3ERavC1xqDLvcupJ5EjAT/hJjH8w3hiHmxSlRg9L98=;
        b=KD6S2SRNzExSHpPQAf2bwToIJ3EXjeS7WMiU3ieFBG0ePy4LvloxVP6DXr98KFxelz
         k1HhwAZppD9wn6otQ94or1znYcsNc0M8SS1O8Vkn+hlkX6kp2JYZzollq3sq3IhAhMFA
         W5rUpjSVyfpz2pp36nFxerDezxaOWT9wQWdPiuaFu/XMJXkyxR5rdxOrt0aqWn8HoS+X
         G8RN2MSVOS+TL4cX6/tQ+fehFUg0j6ZHHcWn8sX6vv21rNRrw2E3m4f1Qxa1zEzkwH+b
         U6Owxx6q04QBuKxxRckIEqMN+gFpH95Ju3gD5A9FWrGYvKA5sRRQlP6dgpHbWGmYP2lc
         X8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=V3ERavC1xqDLvcupJ5EjAT/hJjH8w3hiHmxSlRg9L98=;
        b=2SVvSX1Hg29Z+QDldKa4t4uueAAhasbq4GmfCdH3t7ctoJb+WQSmxG1EUHyDXf4020
         xQC2PDLkRTxJNttxoBtYHPZZc7MXg3QQaGt83ptR6KwrhOF10HZrbhNCcxHAC0rMhot2
         8gIDDCKggdbLQ3+oCD9+qcC/YYDr648rehcxPlNMxnRACETKBRFpVcK+gdwduz6KBV7v
         mwbpYqCwRAxiSv/R4AdZWAGk2up2MKnVE/Gzuh9PIaEELq4KxOcji+YjU2LzTa4VHi9L
         8ZUJhnKexYRD6I3hDfEOvcVw3oy+G3X85ox84kzjnjkEvwmQWKAOSMjRb9YL10ZhCRSH
         4J9g==
X-Gm-Message-State: AOAM530Zumz5LwNVifrdEEB1pF3THTkPt2boTHPxUL81TlLl+dwttjcl
        9XqpIQBNI4t9/EmLdkgDNCfJucsV9wMeoA==
X-Google-Smtp-Source: ABdhPJzAXJuYddBYj33sIupv+kk6JNjQOdfaxGkRTXP3Msv/JGvEux01Kblj5aKy+dJOIb7hr7VFUg==
X-Received: by 2002:a05:600c:1f18:: with SMTP id bd24mr39516481wmb.174.1641231064255;
        Mon, 03 Jan 2022 09:31:04 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:b97a:ae5f:e798:c587? ([2a01:e0a:b41:c160:b97a:ae5f:e798:c587])
        by smtp.gmail.com with ESMTPSA id n12sm38754684wrf.29.2022.01.03.09.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 09:31:03 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ipv6: Continue processing multipath route even if
 gateway attribute is invalid
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
References: <20220103171911.94739-1-dsahern@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <a850c493-ec47-d73d-35f4-3666892fceb3@6wind.com>
Date:   Mon, 3 Jan 2022 18:31:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220103171911.94739-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/01/2022 à 18:19, David Ahern a écrit :
> ip6_route_multipath_del loop continues processing the multipath
> attribute even if delete of a nexthop path fails. For consistency,
> do the same if the gateway attribute is invalid.
> 
> Fixes: d5297ac885b5 ("ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route")
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Thanks for the follow up.
