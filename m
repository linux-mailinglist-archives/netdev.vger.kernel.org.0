Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3BE397DB3
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhFBAkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFBAkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 20:40:10 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47478C061574;
        Tue,  1 Jun 2021 17:38:27 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c31-20020a056830349fb02903a5bfa6138bso992661otu.7;
        Tue, 01 Jun 2021 17:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5bf4YzypzuLYRxXllTngjIxMycW0hM5btc0BbcP4pGQ=;
        b=EpUeOPldVcaG6JyVgTky4Lswy3xM0/LQ+apM+dqJwFBqrnPSX0P5RSeFPeIXNJGBQI
         EI6B1dpBjdeNUAD/sb1uatmRduombvSTGzGdwtrNOImPpJmLynGSFFAwy3ZzWUll7HkC
         YXeDFOIsWEEzt+q1eoaXhRSjpvG+ePrSxJ9p8IqHY/R+esqd2m96ajobsAlUuuwdalgz
         P3V7NNoTfJpW/DtruOUo95DodZiKfq4qUbSh4zF/l9kdsLjiacJYVhmnORyzq5aSWv8O
         F0ZGQbmS+MuTtpRLlxpo4lStiuQ+6lr1xRBzSlSU8KwPEka6CeUZlyh3G40xPuAZalCj
         /k/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5bf4YzypzuLYRxXllTngjIxMycW0hM5btc0BbcP4pGQ=;
        b=D43zOSq19TQNTKYJC/ckJ5nKjXXpAvX74g1AH64HEcJIppIgLkPw5jpoBRY9qhIVUM
         XEYoMUeW6+QVTmXTgDlxXsC00mK/7NLD0FpAnQ2sFpatQYCDKFbmMm+ycbP0X3E0j+r+
         5SrHJrHpeoLvATHQQNRbixLic6n/HWuBNbCSzaYbSsQMYQfk6BfaEM/uZCG7QJgfOViD
         KkjD3ZWtQrghK+jESi168DPZCCHhpvx8ZJtu0BP/9V8NSvtb7k6VFO7ojLudivHBi2si
         dDy+yU4o6YnSbTEtlChE/kPu/hDe2H9a/HHaSGvTwhUvTri3SPTNO5YLpQJo1Y76WcO9
         r5zQ==
X-Gm-Message-State: AOAM533W/bLJsBXOxycVbpoBjxuCo+m2rE2LXXZJUqT7KeP3T+dS8wK6
        YXTe9yZiLnLzyIDXMT2JU90=
X-Google-Smtp-Source: ABdhPJzJiWvLC/ae7Gp5Fc6qFYk/xLmDP/aKqAySyNqBoLY+ltYsC4P4mi18p87bVFFitpB+zf0zUQ==
X-Received: by 2002:a9d:554b:: with SMTP id h11mr23553952oti.4.1622594306582;
        Tue, 01 Jun 2021 17:38:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id p25sm614586ood.4.2021.06.01.17.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 17:38:26 -0700 (PDT)
Subject: Re: [PATCH] ipv6: create ra_mtu proc file to only record mtu in RA
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com
References: <20210601091619.19372-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7087f518-f86e-58fb-6f32-a7cda77fb065@gmail.com>
Date:   Tue, 1 Jun 2021 18:38:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601091619.19372-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/21 3:16 AM, Rocco Yue wrote:
> For this patch set, if RA message carries the mtu option,
> "proc/sys/net/ipv6/conf/<iface>/ra_mtu" will be updated to the
> mtu value carried in the last RA message received, and ra_mtu
> is an independent proc file, which is not affected by the update
> of interface mtu value.

I am not a fan of more /proc/sys files.

You are adding it to devconf which is good. You can add another link
attribute, e.g., IFLA_RA_MTU, and have it returned on link queries.

Make sure the attribute can not be sent in a NEWLINK or SETLINK request;
it should be read-only for GETLINK.
