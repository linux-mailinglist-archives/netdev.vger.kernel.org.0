Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F08444AF2
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 23:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhKCWwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 18:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhKCWwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 18:52:31 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026B9C061714;
        Wed,  3 Nov 2021 15:49:55 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l3so1953506pfu.13;
        Wed, 03 Nov 2021 15:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y22+99gCqV197XlZxvdK7gJySp40M5DM7tv6BPbRLOA=;
        b=GJ60OnGPiXDonq9ay0G4pCx49b/YktFNdDdFt3hmwul9i4tBWfV4H/Wol46ZOURR+q
         KFGjBuShzTHpGRLkxitCRm+f/f99xKTiIp3IfoDBECWDGOvFnvH2FSyeDJxZ/ZVg31k7
         xd8WUaEZPruUzCuh3cjfM0QbNR0aEx7Yy7//7UM39MskyrsyVGQBssaXPWe+Po7kp0/y
         PbsgDd5gc/lsI/5LZuF2RyZTwYKwODIovBcrNpoZgTQZ8K/zazpigwDNj+r4ny1s3NjD
         kftH+HefWvl/rx27ZLCcC4LK/pPnku36r2MO6Q0+OEQqxLiIBn/Zp4CnJ0tygi1If2kH
         XIbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y22+99gCqV197XlZxvdK7gJySp40M5DM7tv6BPbRLOA=;
        b=5dH5MOACoRxf7rYBIv/Vtt3uwIMuUYEhGEiCEPVSbzb8ln2ACl2bdRalCPyJVn/4sL
         jfrW/x3vHdTfH0ASaZy51y0vidAaehmSjrPFbxtks6Db5BedLCE3zFDJSjOT6H1Ot1PE
         aOEFLdSvswhKXCUSr1z6Nr7HOCTCDjCClhcW82JHwvi5duzXHMpFFb0YYJ9JdJcCpjfA
         +kpxfCBoEgPJdWh9COIuS195/+fGCdRlZa01xcdPOA8B4FPpTFdISl69F4aJ9o6foppA
         dKtAd7zKzpvdJJuh0VuhQkEf7z/SKmpj9Gc4KcfDOQP8fMfygwRRnVA6Wk0ZpNKiXGYd
         Kfwg==
X-Gm-Message-State: AOAM530s1vF6Dr0CS2LlBDoLh42WKPGorvxTM/8r1gjo3ThGK1gw0S+8
        Tl4XHJvSvI9GIr0mXiS5ph7d6f4tv08=
X-Google-Smtp-Source: ABdhPJyddS8tAf+d5cn2U7YjxcFIC/7TGpOdCEChny/0rdRcY+Sw6PEcntNOvOn3cmLRe4Fiv+HEIQ==
X-Received: by 2002:a63:c:: with SMTP id 12mr36207912pga.477.1635979794340;
        Wed, 03 Nov 2021 15:49:54 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w21sm3626608pfu.68.2021.11.03.15.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 15:49:53 -0700 (PDT)
Subject: Re: [PATCH] tcp: Use BIT() for OPTION_* constants
To:     Leonard Crestez <cdleonard@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Enke Chen <enchen@paloaltonetworks.com>,
        Wei Wang <weiwan@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cde3385c115ddf64fe14725f57d88a2a089f23e1.1635977622.git.cdleonard@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e869d690-939a-a5a5-1a8c-fe4b550b69ab@gmail.com>
Date:   Wed, 3 Nov 2021 15:49:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cde3385c115ddf64fe14725f57d88a2a089f23e1.1635977622.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/21 3:17 PM, Leonard Crestez wrote:
> Extending these flags using the existing (1 << x) pattern triggers
> complaints from checkpatch. Instead of ignoring checkpatch modify the
> existing values to use BIT(x) style in a separate commit.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>

Yes, I guess checkpatch does not know that we currently use at most 16 bits :)

u16 options = opts->options;

Anyway, this seems fine.

Reviewed-by: Eric Dumazet <edumazet@google.com>


