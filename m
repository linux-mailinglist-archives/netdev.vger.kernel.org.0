Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0B3143D5F
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAUM5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:57:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39323 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgAUM5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:57:02 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so3072289wrt.6
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 04:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ppHhJe+cYSe6JY9odSbewA4gghJk+5h6czZIx3erz0E=;
        b=RD+v+iDD7HTA2HuMwO3NP2FzEKL/bjLkY8nRNdbnUTos/7YfsLpSD/7WZrjJpBs2Pp
         wKwJI9/OZPs7pS3kMy6CJ+Bif9IX1FvMsV3Kbek0jV6OtDOx3OHAjh7IyG9cv7Pohp5W
         5ZFY6HuwPbVA/ZTO2dPEfBca7vMp6G1RPpag6PS488N+RLf/2mqlYPTyUdjquxdYGTpP
         jxWZGxZab8NiwHZBQN82hfReXDAg+Kvmqh7//OX4GSVrWhzbVd5fzqqkL6lwrfifps2V
         bkYpWFR1od/5/cQfaEQboAFOy/QVpyA0FBPQ4vbPdb3g7YKVfXP+RPvkVRaMuJhBXP20
         L6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ppHhJe+cYSe6JY9odSbewA4gghJk+5h6czZIx3erz0E=;
        b=jaeSN1kw87vT1plYkm0l9ZFas0nJ+YGgNLbAq9/fBMOTWKDfoGMSnT3HcZxOUmKxGU
         TbZlzM4yBNU0M38bK9EX8uZRWCuhUHyB9a4kVmrRF07fspwcvYIOwH6ZKBUWxPtyOg1N
         5p3fQT9n90jlUGRJEcdrYnK1CCyMXghSNiD+qFFVaiWiLPbwfq7X/rNjeAjjWpXp/iw1
         3oOW/zwP+fxBPiPi0f99aR6FGC2IG9flT7L1F1avBKl/m16Y7kkhUZi2KI5PbCwi+wPN
         VGwHJVb/i91m1+XdpVWdLag5EWz9ZrmkCJOspXyit5jtBpRPFI5sTUqW53PrCQNJlP6d
         zqiA==
X-Gm-Message-State: APjAAAXJuaxP5WHntp2t0TG1yV2yC640fcrOD9RHd+2CY3OZcjsESo8S
        O+0kZoEVGz4h/RBfnOw21KM1CxNqFsI=
X-Google-Smtp-Source: APXvYqzZVG+fwNnRiHV+YAoqmyzzpmEgX8zNb988WoSpHoaEm4NJL2cZbfAXZ3kIgdMwSW/J1YZHlg==
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr5119222wrs.200.1579611420588;
        Tue, 21 Jan 2020 04:57:00 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:281e:d905:c078:226c? ([2a01:e0a:410:bb00:281e:d905:c078:226c])
        by smtp.gmail.com with ESMTPSA id a9sm3596817wmm.15.2020.01.21.04.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 04:56:59 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] net, ip_tunnel: fix namespaces move
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@nicira.com>,
        William Tu <u9012063@gmail.com>
References: <20200121123626.35884-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <45f8682a-1c72-a1e4-7780-d0bb3bc72af8@6wind.com>
Date:   Tue, 21 Jan 2020 13:56:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200121123626.35884-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/01/2020 à 13:36, William Dauchy a écrit :
> in the same manner as commit 690afc165bb3 ("net: ip6_gre: fix moving
> ip6gre between namespaces"), fix namespace moving as it was broken since
> commit 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.").
> Indeed, the ip6_gre commit removed the local flag for collect_md
> condition, so there is no reason to keep it for ip_gre/ip_tunnel.
> 
> this patch will fix both ip_tunnel and ip_gre modules.
> 
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Maybe a proper 'Fixes' tag would be good.


Regards,
Nicolas
