Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B44113547
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbfLDS7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 13:59:47 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:45281 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbfLDS7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 13:59:47 -0500
Received: by mail-pj1-f68.google.com with SMTP id r11so172389pjp.12
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 10:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pBrHsGyBn53w6jItt7hpVmXyOYYGDRNVoEFpBteJ+nA=;
        b=NqmWYoYbCmwY9L8bIei76YGL6zNleiOBnPB1JLdAQLkrqYZZNdhzWAZVB2xPEq98XI
         uDS15JyR9t15cTxlDft+7Lv/M6b97ylbjIA8wILk6yhMnfLVH+xHgJXdtchTJG4kHMo/
         ZQFXRcSx0H9MB0HjkGi3xrbxfEc6Yhp08g4NjB1gMbV6tb2knvPU6c2/bu2uXQCUm9+b
         FUhaG29ZGQ4MuJD7iZ4b/FHnQOIGsbBGjD69Ws36ftrI4JPeNYm75taTVG8MCPwp7TfX
         pJZNslz8xlbSpbjxkPO7LM9gaHR5wvLRqTUpeuCELXagOesQkxERnXxvWbbctRvxqH0W
         HHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pBrHsGyBn53w6jItt7hpVmXyOYYGDRNVoEFpBteJ+nA=;
        b=UkNs3zeL1+tXJwRvSj+qwPxLfQXYzfCF7H33mRbTePSTFBVWejpGLtQJRVkFbeDirf
         EbrLcKG0pAkRqtHN4W6QvFVWpICZJdy46gcUlD3kjABjFmnmW94ZD0odiffZ7EFNjm19
         9Htmd7zICNvS7ALofn1/80C9SM6ZjdDi7pyiWEgIcXwiCG1uLtZ3qlPinGYKURrhxAnf
         BRYKR4jKKBICFdBL1VHMAVvO3ONTYqL5PpGIFP2NvFKCG4ZZQdTFXFuQfTTaCJ2I7CYv
         1bE6peiaHCjan+ZdazzkxayuzujqdC9wNd2VBZLFykJxwe6ylVCQ1f7ezYAanII6GnnI
         CXtQ==
X-Gm-Message-State: APjAAAVE8wv86IcxNNc3/cZ1xid+Y/JTrvN3zD8oTWvD5b9O+6nCX/s8
        CCjsORWOcxVY0ylbtgxLyydWZA==
X-Google-Smtp-Source: APXvYqyEe1uo03vzSO76sbF45V0SgwfHhgGuy1VC3aBJKX6PM1cH/kr5xWoUWDkD7FRwk1vX+SLNmA==
X-Received: by 2002:a17:90a:374f:: with SMTP id u73mr4895895pjb.22.1575485986708;
        Wed, 04 Dec 2019 10:59:46 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k21sm8195827pgt.22.2019.12.04.10.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:59:46 -0800 (PST)
Date:   Wed, 4 Dec 2019 10:59:43 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Gautam Ramakrishnan <gautamramk@gmail.com>
Cc:     netdev@vger.kernel.org, Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Subject: Re: [PATCH iproute2] tc: pie: add dq_rate_estimator option
Message-ID: <20191204105943.5423f535@hermes.lan>
In-Reply-To: <20191126115807.27843-1-gautamramk@gmail.com>
References: <20191126115807.27843-1-gautamramk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 17:28:07 +0530
Gautam Ramakrishnan <gautamramk@gmail.com> wrote:

> PIE now uses per packet timestamps to calculate queuing
> delay. The average dequeue rate based queue delay
> calculation is now made optional. This patch adds the option
> to enable or disable the use of Little's law to calculate
> queuing delay.
> 
> Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>

Applied.

Note: pie and several other qdisc need to be fixed to support
JSON and oneline output format.
