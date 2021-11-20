Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D341D457EDD
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 16:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbhKTPUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 10:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhKTPUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 10:20:39 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC36C061574;
        Sat, 20 Nov 2021 07:17:35 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so9787493wmb.5;
        Sat, 20 Nov 2021 07:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SAdJR3WopYIrbK2mVVoGCJPSAiaXWVlXMd62fQtue4A=;
        b=PSsn0O6gtR5fOZ4JoHKXHRExmTVUfBZ5OOy95GUS+1D7W4Y513R+9liuNOAg9FsMKl
         xNsOErhQnz3D2jcojL2/BJdMSbNbCEYfBAZgkxIlwA8i5ZFpR2i434Ylw4lq4KPK8jSO
         /EWxii2/DcaApGquGOeuiCyVBaKyDAGdTc6qq/egiLItRyDTIUyUaMMoIx3cDjCRiTtR
         xE95rCgXO3CxmngCFNgm4G4/lGrECmdiaByQcrIsHTpHKEmu0/M5v6s0Za7OHeh9icaH
         X5FFPS1DkeQwNBwHB+5KzywAEAPJ2gSvo+oGQzZWDE7sT45q+T+R8F4mHn6NBjdtSAcR
         tL4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SAdJR3WopYIrbK2mVVoGCJPSAiaXWVlXMd62fQtue4A=;
        b=kTB8DsnVdYTK6dSDNLL2wZvZ/WVNbWf155NQnxuQEiMyvO4ctWOxRCNvY/HbMDKypz
         y1gf0JipE2LxJNqnHpH7LPiuDkJVeqcj4zF5DqwJT/U+xjvunTnaON7py8U2SHBHOuDY
         Isbb6RIO5pd/cfAEaKOrnyv6oNRwDMjobAD1Yua/oyszIjU1Yd4TvIlGAlA/Dsf5PV7E
         hXvH0MIeMBOC2uQ1J6rV8wXaOPX7pfGI/J8KGKkch58CArWZkd8niLn0/zDX2Rd22FOC
         1tLCvh7PrdNbxOwlz7MFfd2z6ZZS1OBG5Q8GvtPVwRLJs/GWl3rvpLfi384NGbv95Fo6
         GbdQ==
X-Gm-Message-State: AOAM533LneBdXSa8DRkGHUTt0OmI6VAVf13TFrbI3ettsbKKMjddpDY9
        sd+387HL02aJyyj3EhjU7Lk=
X-Google-Smtp-Source: ABdhPJzusnSUU9G8Bbwwvx4W0Wszg8PyY3GAgQQd9zVKOT7CM/P2i3nUjbJW0qJJN69eQ6svoeCzBw==
X-Received: by 2002:a05:600c:6006:: with SMTP id az6mr11505759wmb.5.1637421454335;
        Sat, 20 Nov 2021 07:17:34 -0800 (PST)
Received: from debian64.daheim (p4fd09ac4.dip0.t-ipconnect.de. [79.208.154.196])
        by smtp.gmail.com with ESMTPSA id l21sm3239781wrb.38.2021.11.20.07.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 07:17:33 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1moRyV-0001WH-Mj;
        Sat, 20 Nov 2021 16:17:33 +0100
Message-ID: <75be2d3b-99c4-f84b-4da5-da0f4c220359@gmail.com>
Date:   Sat, 20 Nov 2021 16:17:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] mac80211: Use memset_after() to clear tx status
Content-Language: de-DE
To:     Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20211118203839.1289276-1-keescook@chromium.org>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20211118203839.1289276-1-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/11/2021 21:38, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Use memset_after() so memset() doesn't get confused about writing
> beyond the destination member that is intended to be the starting point
> of zeroing through the end of the struct.
> 
> Additionally fix the common helper, ieee80211_tx_info_clear_status(),
> which was not clearing ack_signal, but the open-coded versions
> did. Johannes Berg points out this bug was introduced by commit
> e3e1a0bcb3f1 ("mac80211: reduce IEEE80211_TX_MAX_RATES") but was harmless.
> 
> Also drops the associated unneeded BUILD_BUG_ON()s, and adds a note to
> carl9170 about usage.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Christian Lamparter <chunkeey@gmail.com> [both CARL9170+P54USB on real HW]
