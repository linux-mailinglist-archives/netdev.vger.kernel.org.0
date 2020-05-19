Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B521D9EE7
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgESSLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgESSLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:11:30 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4682C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:11:30 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n14so471515qke.8
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dM3hQnXd+9exA5NjGkA80fd7WRkZgNXz6zMARfHdwSc=;
        b=vadcOj0wml8nyuzYpIOw+SoOXgMR/4OHMr45XXc6F1BjQaPbcCJ7sgtHXN2mqL6tAH
         NVSsSckzL41i8JnyMvwTVTAxUayipdYTNf0Dc0Oe8t7uHHV2mg4J192gqVb9fUAv6B9t
         ec8p+sjkpbG8+fSCT9lHWULqvd5T+ULgfa2Up91E7sfj7Qltwonokf2EvYoW06nlfnb/
         i2pewlcvfEKqFU9m66yeN2+ffY1oiy/iIfk/JAr9jsb7f7cM9sX3V9qMgVqG/O+BWEiO
         8z/HE1WfTmn/jpkwwq3DdlCh00DY3Yfm5kJsMERtMpOnIhDM+X2P5/UTnrU64IuzpUZE
         WKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dM3hQnXd+9exA5NjGkA80fd7WRkZgNXz6zMARfHdwSc=;
        b=WniUANkWr5Ozf1IELV+k5KXVtJTs+S9RNPy/O9H/8Iqjcu/1n4HtuywsBpSCgK5kgC
         EVfKcpzVSrPUqjXLODyGaiUwU3m7ZhaMlszqAcdsmYKznzNEkoChR9E2JP92d3kssJbu
         Aco/8q46D5ZO3h8dHLNtsgAE7jvVXum4dxYhedKNSW2+GzzR89cjmn58UQuZcdd9Nhsv
         auVMmdzalXPIbDpOLUMRGQT0bQkosA6z2w6A9UzjvIyAjYq6crC5H2lpP3daRYJaOnrS
         JnUh1+oix53YrMIaRn71J6k9a1pUre43wX8b362r8qjk9L1jg3bNO0XnEB+jVMtoiKMo
         BaEg==
X-Gm-Message-State: AOAM531djXSbQKtgTehjp59yppMJze604nVG08SiwkpTYsyBJdicIVuO
        ysc8deUlUl2c37nQ6E9XMiE=
X-Google-Smtp-Source: ABdhPJxpCJSRgTM3rssgQYBF70XrpoWbAUiXre9mozj77aUT9xlyaXZNJPIs99MMlAh/s6Oy/9iFHA==
X-Received: by 2002:a37:8d3:: with SMTP id 202mr655156qki.237.1589911890036;
        Tue, 19 May 2020 11:11:30 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id s30sm321821qtd.34.2020.05.19.11.11.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 11:11:29 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first
 used
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        kernel@mojatatu.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6619cab4-02bb-51e7-0c2c-acb0cb13d022@gmail.com>
Date:   Tue, 19 May 2020 12:11:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/20 7:28 AM, Roman Mashak wrote:
> Have print_tm() dump firstuse value along with install, lastuse
> and expires.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
> ---
>  tc/tc_util.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 

I can merge master once Stephen commits the bug fix. Then resubmit this
patch.
