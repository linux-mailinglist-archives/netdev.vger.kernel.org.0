Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6470D48FFF8
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 02:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiAQBfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 20:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiAQBfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 20:35:21 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB41C061574;
        Sun, 16 Jan 2022 17:35:21 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id v2so4586743ply.11;
        Sun, 16 Jan 2022 17:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yRoTtwlAnLRR60MEEBnO0WsRacU0q0bQ1keqyNzRUO4=;
        b=meug70q8IUVJ+mG/Y4HyFLhoGiteTRliwby8YcKSPF9495mq1JrDtObgvrT8kH8f6u
         9cR1Zqcve5CYkZ8MLnTBWYWaAjZTaGBMn4Xuv3RSas+db2pa3yHNFDv973rbr7QAI6H9
         ClkoPL4Ds2bQdxH6IGteb7WxeY/t2njF1JByb98MtZcbYIWhBhpBhTOb2D/lV0V8lTbq
         00A1jBdZ1I3D/DI7oWGfTl7YzicgD5hZ2KBEFpC3sqxfE3uB6ql3b0WKef9v/fNkyg9R
         xN1NUFFNDkhoady+D6Xm7oQUmv3xposCGQWTrolj/T7P7lqm9Qik82D3vUf9Uxa/sH3z
         Zp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yRoTtwlAnLRR60MEEBnO0WsRacU0q0bQ1keqyNzRUO4=;
        b=WZTXYhFDfoSqc1OF3AWM692acpi1yqtPDtImE9jAwrVDLb6S7rFJd1ifqWSbqhSO4B
         oVfU+RaGwniAryxzPJpwLEi4a5xKzU3172sCzNKWoc/INOewZ76bgJPlaSjU+ANb/L0o
         /DfWWUtgUyetyjpUjlXjsBLEIZHBDa2W/ArESz+rmPOrX3lOn9QpiXQ+l3er2G9G1lq7
         9s7lmrCuqUs32Ut+itYC4f9gKSh7odhoEipt1DVt5fZ8d7YQqUuvIZYqMuyz9v2GN2Si
         q4lNAQXmgQBdhUeWLrzUr+IqmU6yD/GIW5rx7kLajzyfHOUDE/G4rcAOKd/SHTii74hZ
         TdjQ==
X-Gm-Message-State: AOAM532bjrsSCtpPC3Cn5O6gysGAEcn3vMCw5sH3lv4sxJZkhgcGRshY
        doE5PqJtBNrjIjI7GJ1Knl+7QQLt0exR7wK/
X-Google-Smtp-Source: ABdhPJybUDORmXN4RznS1NWXnTU92u+5CquSRy34zQ2o1SKpZwKtkJrcv0ifJF1arVs9pvG91uTt2A==
X-Received: by 2002:a17:902:f24a:b0:14a:bc6c:c327 with SMTP id j10-20020a170902f24a00b0014abc6cc327mr2449527plc.24.1642383320757;
        Sun, 16 Jan 2022 17:35:20 -0800 (PST)
Received: from [0.0.0.0] ([209.97.166.32])
        by smtp.gmail.com with ESMTPSA id rm11sm784643pjb.54.2022.01.16.17.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 17:35:20 -0800 (PST)
Subject: Re: [PATCH net] ax25: use after free in ax25_connect
To:     Eric Dumazet <eric.dumazet@gmail.com>, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111042048.43532-1-hbh25y@gmail.com>
 <f35292c0-621f-3f07-87ed-2533bfd1496e@gmail.com>
 <f48850cb-8e26-afa0-576c-691bb4be5587@gmail.com>
 <571c72e8-2111-6aa0-1bd7-e0af7fc50539@gmail.com>
 <80007b3e-eba8-1fbe-302d-4398830843dd@gmail.com>
 <ff65d70b-b6e1-3b35-8bd0-92f6f022cd5d@gmail.com>
 <8fc4701f-c151-0545-c047-a5df90575d69@gmail.com>
From:   Hangyu Hua <hbh25y@gmail.com>
Message-ID: <aa1abfd4-e76b-f708-e2de-8018298ff07b@gmail.com>
Date:   Mon, 17 Jan 2022 09:35:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <8fc4701f-c151-0545-c047-a5df90575d69@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I get it.

Thanks.

On 2022/1/14 下午11:19, Eric Dumazet wrote:
> 
> On 1/13/22 22:54, Hangyu Hua wrote:
>> Any suggestions for this patch ? Guys.
>>
>> I think putting sk_to_ax25 after lock_sock(sk) here will avoid any 
>> possilbe race conditions like other functions in ax25_proto_ops. CTING) {
>>
> 
> As explained, your patch is not needed.
> 
> You failed to describe how a race was possible.
> 
> Just moving code around wont help.
> 
> How about providing a stack trace or some syzbot repro ?
> 
