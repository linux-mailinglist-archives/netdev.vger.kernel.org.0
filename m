Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCDB2A3598
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgKBUyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgKBUwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:52:44 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176B2C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:52:44 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 13so12204650pfy.4
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8XcE1QyBFEO8vIIhA6GhWfl8pYBx2dM4h5qD5cgTS1o=;
        b=eEO+2cR7woOLCUzcfrfXEhA/eN88aOiEbGr0x1T8hoo6Y0u/ZSPCUrJoKk5lsKzF6b
         h9vBhPgYaTmQ4uEnCMafz11sQCMmia4oQALVnvIRStLRHcvuLexK1Tn1XaK25yxHHhnn
         9Kzo4Rt6WC0VY9/DZy/q8p0ahrvuRNXI4xoFiRBLb7z3gHEEV53Xxn0q2ILj/BWa0d83
         IzixO7k+IIAATe88wnbx03kq+s6daCrlqNUHOz2qMMOKNglAv4gZPKB2/Z6PpWJPABmU
         fcHf/JTr5OXJyT+JSuS+HvwnlgvNhgn5QSchUQSN1w3rCsWeApwHijh5D8Y6lU4MY8+j
         0CJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8XcE1QyBFEO8vIIhA6GhWfl8pYBx2dM4h5qD5cgTS1o=;
        b=djkSa8AAulePm0/AlT0pv148bxeSv7qfdsabSFrFQd9eKu73mLKelG24s3ijiFkv8j
         BGntfvSlNZJt6+HodUsAns0WksKlh8NpkU9L4FB9KtBVgDsnboXID9Z09PMXjEUT2hRY
         ee1PLdptVlGgVBxZOLlEW7F4L6W+po2tLS2nUapAMRHz+5Pz7KpoiYUr4RbYxeDO7ES+
         kaEuzgI9jOQ7tp6PvrXwgyFEmwGTQrJJzHgCb/C9apK3B9U11WiLFdrre8wSFRKpoNeB
         GiH0v7odUNQULFAQHgTMcMcbvnuXw4pRoZfRHtq1zVdtoNFgX2BnGuB3w5bxFZEyRiwZ
         93lA==
X-Gm-Message-State: AOAM533CKHPBAoyvhDUgjvQ7bGTZQLrww7T8dhyULuWsnAN1ER6FGNMV
        ybhudNkRwsiT/Prm5V+jMx0=
X-Google-Smtp-Source: ABdhPJwRwkcVJB/IoXZl0H2AqWgFfLfTXXgJKe/vFbDU6q16zofnmpIX/zH8dx3Hm43ld5BpAzz3WA==
X-Received: by 2002:a17:90b:490b:: with SMTP id kr11mr20451pjb.172.1604350363682;
        Mon, 02 Nov 2020 12:52:43 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f204sm15464493pfa.189.2020.11.02.12.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:52:42 -0800 (PST)
Subject: Re: [PATCH v3 net-next 12/12] net: dsa: tag_ar9331: let DSA core deal
 with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Per Forlin <per.forlin@axis.com>,
        Oleksij Rempel <linux@rempel-privat.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-13-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <21df9110-3989-41be-7397-4ea5a775619e@gmail.com>
Date:   Mon, 2 Nov 2020 12:52:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-13-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> Now that we have a central TX reallocation procedure that accounts for
> the tagger's needed headroom in a generic way, we can remove the
> skb_cow_head call.
> 
> Cc: Per Forlin <per.forlin@axis.com>
> Cc: Oleksij Rempel <linux@rempel-privat.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Oleksij Rempel <linux@rempel-privat.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
