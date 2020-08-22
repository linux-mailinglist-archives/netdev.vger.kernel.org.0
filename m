Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7476724EA1D
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgHVWul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 18:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgHVWul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 18:50:41 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E32C061573;
        Sat, 22 Aug 2020 15:50:40 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id d11so7173379ejt.13;
        Sat, 22 Aug 2020 15:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qR1urhH66wEedypGFxjNEaBY4ub7u9Uam3EyOXwxQiQ=;
        b=cEqbgIxwnyGaQU/WhUIVZQGz5HblJlFMs28ple4cbroKJDq0Jnnl2vOAenygWWLiZE
         NOhQ0K/pzKc5mMmMo4bU9l5N6HkFY7toziJs5bsrzw5BC7YfgNTD2FVcIS1rWHC3tYaP
         oO4C0Dw26IvHBx6QabOA3X8rGeEVfA6KAIQe94TAHknPSj0DnIsN7XxWCkLGFlKa9um6
         IHG6hwNB7stR/qmPC9lv3ILW8o0JnkpWJMyfGZeqOVIycrI1wrMBF+Fql/oMvrXCx0UU
         hcvLBBM+N6DtgP52priJrRqL418fXyB410fXXHJPPfuUSNCCk/u3k3U5VlcbBKoChPRy
         WASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qR1urhH66wEedypGFxjNEaBY4ub7u9Uam3EyOXwxQiQ=;
        b=qMDMOfK7HClsQ1k16BpCIQcy7UAF+9V+4vaVhb3zLtYyW3zbsU+sHPGqFMtcNTfZMl
         IEE17sRRAPe+Hh2KXxVQVHi6mxILAYayAHj+vfe4IkawOq1VoKPLbV42aJn8DDQY5tWY
         Q20C9s9poTlNzG6VJRTj0Z+960EWhoguBnQUFkU3FTV+OSgzqAry9wkyCviZLkdVppE/
         1PlrToL/9jJhrTClRiQg49AGz3zB+8w2/eEgouhN5s27C5YGtTyl6Hiy+Fgd87RcqqYr
         A4rUExdIIeVexlPdr1sUvWIvstQOGhgHHLniboFb9AZmoy/4pUq9eOYxfXhlet73h2DP
         8uiQ==
X-Gm-Message-State: AOAM5331D6fkBKxNgcwA8KCXu6KOMKa8UQNVe1nsd2rfKJJSl/D4VaFq
        DtFeoQ0vxNmgmoPYjEJOfjC96sJ4wdPJag==
X-Google-Smtp-Source: ABdhPJxsYPiklg2G7SIRT987XZTIH5ZKR50n6lRzV9g9gWMnBzlRiWxhb/guY5j6YmRgB7hT9B/DTw==
X-Received: by 2002:a17:906:6055:: with SMTP id p21mr9397263ejj.173.1598136638084;
        Sat, 22 Aug 2020 15:50:38 -0700 (PDT)
Received: from debian64.daheim (p4fd09171.dip0.t-ipconnect.de. [79.208.145.113])
        by smtp.gmail.com with ESMTPSA id v23sm4186367ejh.84.2020.08.22.15.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 15:50:37 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1k9cLH-000GFF-2O; Sun, 23 Aug 2020 00:50:33 +0200
Subject: Re: [PATCH][next] carl9170: Use fallthrough pseudo-keyword
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200821065204.GA24827@embeddedor>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <1bc53e98-b82c-3f36-13e6-e42131adb4ac@gmail.com>
Date:   Sun, 23 Aug 2020 00:50:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821065204.GA24827@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-21 08:52, Gustavo A. R. Silva wrote:
> Replace the existing /* fall through */ comments and its variants with
> the new pseudo-keyword macro fallthrough[1].
> 
> [1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
