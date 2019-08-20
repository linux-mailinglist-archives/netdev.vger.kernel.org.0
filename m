Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5840F954F0
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 05:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfHTDQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 23:16:37 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38579 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbfHTDQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 23:16:37 -0400
Received: by mail-pl1-f193.google.com with SMTP id m12so1978013plt.5
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aDEKXRrRE5yK/7N3DVNmchFKRUFPKDwOWjOpGzfUqCc=;
        b=QiW5x39snlKSH3WVRRspta43yjiCOtv7FzpZH6wvLzMw4EWCmVAWhVlq8fnBNSMUbp
         9qFQmPcUNaXNKvFGapNy3orLyv0lWBdpUSvFAAdm/tqz9Z0fk5JIyl0rnroctcQ75cZr
         H1MPy57bKhKGIirGqmIfxsSSCevvi55QWCmlWs+bW6IbJcNLc9CjVB2aeU7LDmVzbYjW
         9Jf6tRaaPHXJf7YWNaciUnlOa6yzNB6w/QVLcjHQpaz0CIyL/wGN+4y4hY6tWDdWDUqj
         JmjXVpvu+qwSOgQkO8NnStkHeHrlQOqfs0fdlzdYkxy1nMWttlur6PsshJTy1+qFRWbm
         jmoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aDEKXRrRE5yK/7N3DVNmchFKRUFPKDwOWjOpGzfUqCc=;
        b=nYqfZ3w+HUChJjenLQwGfzb7gUTxs2qp8yBNZ/BuP+glPw0a3M6FB5tyNDub/Q6j7s
         ya27rESaj4mWec5Oqq/7FZwnbkjSaB5ADOGkHUq2mrxYhk1dS9FHQ2oCnmbo/T5lew35
         J7Fe8a4Hg+134VXIMz6CMmLUNOBVOZuKh1w8M7+3o7y2C3BNHP9p9Ctyb7e05uGGkXR+
         BYAlCQwiZAz130DDeOCNFxKic2JBa4r6bXSN0cm39QYuRQwwnD9HJxpU9SFUXBX3EgtW
         JZWRUVKKdyng0pVYIYpW1tuCFETP+sbZSk0OqeLeqV6QBQ4qvGB9PzryUGuKhpnVwmA0
         dFBw==
X-Gm-Message-State: APjAAAWmVH1hKEjfjqJPUDlWCxLgSn1QwOG47HVjleZMv+18Him+WH6L
        HFcxoF0NotO/JwVho4/o2C5Di64q
X-Google-Smtp-Source: APXvYqyYZi9BAuA9LM9lWHWJ4NTS2tBqKM9DkDKgYoDboWc8BsaeX65/VEi1vY4EsSdLfL1b5z17IQ==
X-Received: by 2002:a17:902:2f:: with SMTP id 44mr26445695pla.5.1566270996600;
        Mon, 19 Aug 2019 20:16:36 -0700 (PDT)
Received: from [10.230.7.147] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id b6sm15250234pgq.26.2019.08.19.20.16.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 20:16:35 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] net: dsa: tag_8021q: Future-proof the
 reserved fields in the custom VID
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <67b13152-49d5-7572-36f0-f1f71873d83c@gmail.com>
Date:   Mon, 19 Aug 2019 20:16:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820000002.9776-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2019 4:59 PM, Vladimir Oltean wrote:
> After witnessing the discussion in https://lkml.org/lkml/2019/8/14/151
> w.r.t. ioctl extensibility, it became clear that such an issue might
> prevent that the 3 RSV bits inside the DSA 802.1Q tag might also suffer
> the same fate and be useless for further extension.
> 
> So clearly specify that the reserved bits should currently be
> transmitted as zero and ignored on receive. The DSA tagger already does
> this (and has always did), and is the only known user so far (no
> Wireshark dissection plugin, etc). So there should be no incompatibility
> to speak of.
> 
> Fixes: 0471dd429cea ("net: dsa: tag_8021q: Create a stable binary format")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
