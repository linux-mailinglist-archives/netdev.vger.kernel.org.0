Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEE044F195
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 06:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhKMFpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 00:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234592AbhKMFpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 00:45:05 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FA5C061767
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 21:42:13 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id o14so10096994plg.5
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 21:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xaxNu9zU+SDGLsTpiDayCICwcc1h6ck38IHp1yHVh08=;
        b=U5WzbMxWOF618/EmrlEmWclFWB5xi9vZmI6W5lqqrWcBDFf7n6aznDJouCuOBAZNDY
         vBK/tyl/bE/d4otLrbnyQAboLxnzuV1X44b9dWU138ANg/7tcQzz/8Kz1JX0nr/JPzTT
         uMOH1/69U9TjK6ug3mrNB1mwud3MXyguVGJ7HUnhQ/L3zvfW1bbGxfjnYmPJT/w8d6tV
         Y8qJua3ydUObXUAAWBmlncShfc9db48fKMQjrOEh9b/c1X3+oNfQ+XdOgITnKr5ZAn65
         /N55yIMILPaoayYAKHOb+VE4TQZUATFXR1++9eH7x5d3/GbfTRb4+24ds1eUdBr4MekS
         svLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xaxNu9zU+SDGLsTpiDayCICwcc1h6ck38IHp1yHVh08=;
        b=tkQU4UGSldbZrYR4hw81+RiOUzAzltDtYkUaX+tmd4bmLgdRDTC+cyhrr62LZgGUKY
         +3f2hixvRm1P8TwqGy+rMcwZ3HFZdMVNpfiXvglDryFnt6YfM1s3Zy9Rr1SmxzaWJ5Bj
         XbN9Uzaoxg/+hdY5qpJKMhpEug4+nWjXyjhJuEmJWpAAxoDxRw4YcYDbr/R15oNySNPE
         0JHKNWds0cfX+/ooItxEK4b2mnW0m/8FcEoSzyvjWEVogBiNCf32CF8U4/a5qXXijw5e
         8G9lKl0zTrKWERrJQN13PF8V/JrfhHPXzL+9w1Pyd6JcuCbs/MUufng2vULS5zunJTjR
         Sssw==
X-Gm-Message-State: AOAM531UsDSNrB9HnyjsMf6LkEV3bLroJhBS08YIJB7tpST9asy8hcW9
        oPOfE4LerqioNLBF0fgp1wX+eFkYEfFjPYvdFG8=
X-Google-Smtp-Source: ABdhPJwmcIVJEMXdk+vSm2H3TQ2aTXI5rOJi8ZA5JGANEOALzp+ER60zCbfPOgzLzbxUZ/JJi3Hiwg==
X-Received: by 2002:a17:90b:2309:: with SMTP id mt9mr43793508pjb.213.1636782132877;
        Fri, 12 Nov 2021 21:42:12 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id y28sm8161156pfa.208.2021.11.12.21.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 21:42:12 -0800 (PST)
Message-ID: <997876b6-39b4-64f0-648a-8b042b03a3a8@linaro.org>
Date:   Fri, 12 Nov 2021 21:42:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] tipc: check for null after calling kmemdup
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jon Maloy <jmaloy@redhat.com>
Cc:     Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
References: <20211111205916.37899-1-tadeusz.struk@linaro.org>
 <0f144d68-37c8-1e4a-1516-a3a572f06f8f@redhat.com>
 <20211112201332.601b8646@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20211112201332.601b8646@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/21 20:13, Jakub Kicinski wrote:
>>> @@ -597,6 +597,11 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
>>>    	tmp->cloned = NULL;
>>>    	tmp->authsize = TIPC_AES_GCM_TAG_SIZE;
>>>    	tmp->key = kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
>>> +	if (!tmp->key) {
>>> +		free_percpu(tmp->tfm_entry);
>>> +		kfree_sensitive(tmp);
>>> +		return -ENOMEM;
>>> +	}
>> Acked-by: Jon Maloy<jmaloy@redhat.com>
> Hm, shouldn't we free all the tfm entries here?

Right, I think we just need to call tipc_aead_free(&tmp->rcu);
here and return an error.

-- 
Thanks,
Tadeusz
