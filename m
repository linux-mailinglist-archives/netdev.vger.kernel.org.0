Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E5A42BBBB
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbhJMJib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:38:31 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:42110
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239168AbhJMJiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:38:24 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 371153FFE1
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 09:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634117779;
        bh=QJ9OOcKk0SAqcC6odR/kUKnKxAUEab3yB+Cct//JQn0=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=OpbJdOll+aqtFjEFBIERMn3pW8UWSncCDp2cP7B4eMW1U4AfccEyQ5Qep9i4gByRD
         mt5FdfLIZjS6+pEmlOyAan5wdPszqLN0STSqj32jPU2dXFxT4gi93SDPHpirmewk51
         knaT3+uWgdCcgaSRlmw7y5mPcXai2hQM9kOHn+zSL4vReE4RwVr8i0+YH96PUY5rAj
         QynpaTF2uxKjadiIhpIrt4xKP2uLrAWgUdYWaekedSneZKq406YxmEXRti+3x4txp3
         RmMt0+QQ0PpPfGHMUORRlUet9if2XlOFsgm34Id29sduErkhdQTQKOG2bcdZYvIBm1
         NgYkG7652URww==
Received: by mail-lf1-f71.google.com with SMTP id bu34-20020a05651216a200b003fd7bb9caa1so1603203lfb.0
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 02:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QJ9OOcKk0SAqcC6odR/kUKnKxAUEab3yB+Cct//JQn0=;
        b=WxbpY8/ZG+cUP/hHa5gn4GLgOCiPr20cyyU1Qny0ZvZRG/xM9fgq/wVy0NenpDGj3z
         ZTAQeCTW/8oIz4L5yzeF1+w7o4cjnbAHguv08z0FH21dH8O3DsHXIlASUlqtHoAFMtXv
         iCHCwQyAYVoDj0DZ8wwpzeOhxleUmNfI3Y2E4HKe6oZp4itatvfk6qhQHCOv7OrVezGn
         h0Re4wEjEq7roUVtvOcN0VX+RPqMEbj6Vc7y7jOIPugj6cJaOG+pWfYMy+V9SyAi/s3r
         nQRWu229hPFS39t08Ys7vav+Gz4t4f926gcJBSKbzJnV4Iom7L+AlRYa4N1Zcc67CJGf
         GcwQ==
X-Gm-Message-State: AOAM5317jPKX5v2DMNS4mrcd9Ja2QKf9Yv09+r/FpitGwV0U/xzYhKfT
        SzYskz2icLD86NYsqHcf7BUrv5jubhtAjXIjCIP8sn1RkYgtonNptmePmVnfC1+nqPo+mUhK/WF
        qIkdUE94v6quW7eihwFkhLX8QycwVdtMRgA==
X-Received: by 2002:a05:6512:3054:: with SMTP id b20mr40337990lfb.316.1634117778612;
        Wed, 13 Oct 2021 02:36:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhlBGhq00YFwto8tqrsM/9fdr+Ez4zPx7BkVS2CPoWkqy/IentT5VVYEHDNYt3eHr6Up0CGQ==
X-Received: by 2002:a05:6512:3054:: with SMTP id b20mr40337972lfb.316.1634117778427;
        Wed, 13 Oct 2021 02:36:18 -0700 (PDT)
Received: from [192.168.0.22] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id t13sm1277182lfc.34.2021.10.13.02.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 02:36:17 -0700 (PDT)
Subject: Re: [PATCH net 2/2] NFC: digital: fix possible memory leak in
 digital_in_send_sdd_req()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634111083.git.william.xuanziyang@huawei.com>
 <56fbe3414c94916d197a1a1b3e438eaa129d5c9f.1634111083.git.william.xuanziyang@huawei.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <ce121b1c-9415-ee8d-5c2b-042f7df7e3a1@canonical.com>
Date:   Wed, 13 Oct 2021 11:36:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <56fbe3414c94916d197a1a1b3e438eaa129d5c9f.1634111083.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/10/2021 09:50, Ziyang Xuan wrote:
> 'skb' is allocated in digital_in_send_sdd_req(), but not free when
> digital_in_send_cmd() failed, which will cause memory leak. Fix it
> by freeing 'skb' if digital_in_send_cmd() return failed.
> 
> Fixes: 2c66daecc409 ("NFC Digital: Add NFC-A technology support")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/nfc/digital_technology.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
