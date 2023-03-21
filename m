Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FA76C3787
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCUQ7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCUQ7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:59:40 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746482822B;
        Tue, 21 Mar 2023 09:59:26 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id s12so18636560qtq.11;
        Tue, 21 Mar 2023 09:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679417965;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I06jlVpuoS7hc1UUHlUuFgOX+xLS2i4QEhtCoSjNuGU=;
        b=PaEkV8snYe0mqpd6Mdw7rkKGqLTcCaUFkXrnLEdzvEPkLs6ynf3N/Rv5IHHi/sFof6
         r36WO1vhjv7JrQrqSxgB3oF1fAVfO6YQ0ARgeDVvgd7ZOpX9MV+8YdZBl+BQXnqKhpP1
         gKLTp6eXB5/yLjvA1f8go0Rh/peVXrVIquD+3BrEIwifnYc+zimt+kabWDiGqGiQfG9T
         w5YZJTbjQPJ/aal7qZFLqcZMo26MJ2yct4tb8BtG+TCdjDvTGqAJ+tDKJLipooifJ+Zl
         HAIcPqmmNS9BvEUjuu5JgDMp8BlAckZkcZ7OBFJVIC9OTACodiC1MVIsos5/sG6dDce8
         lIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679417965;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I06jlVpuoS7hc1UUHlUuFgOX+xLS2i4QEhtCoSjNuGU=;
        b=Qfvv0MutiFuFgTuykMk5eJAPJdia5kHq9mHxggUPRvN91l1A2FZpUZM2sXQ5BBJHxP
         d4ZDZL6obYcQyi2hBcj37YoXTvh/A+lrXCFRi7hqIeFW6n+8R59Oguwa8YWzYvg0Dycz
         XWgplWa+wLBxHwC1AFCY04f9A9QrOkj+9UTnoAuMKjduCCh7/GPPsRLUEYJZO5phDmqK
         6c71dEqX+j9DmMk02JcYQtfBS/9EF66Ey+yMq7Ta0mh+icf5Oyh7iGtivrpjJKdzkPiu
         PmDh376mFolNV+/sm2hiyFX6aVuotrVdC4i39pyE5cULUj3jhAR6JCCm1l9Zne3jEC9W
         ezMQ==
X-Gm-Message-State: AO0yUKXbPpyEwtejEQexTOaHBtQ4SsXMfVTG9lOgfvIAakRDnCXYbOaA
        x809AhQne6rirfkePje03g0=
X-Google-Smtp-Source: AK7set+Nzp2zR/Mi25MRlxx3AJVgTI4FLqPCsMLSPn79OKDkCWjRNuHKvG9+PCujNwNo3W+km9D99Q==
X-Received: by 2002:a05:622a:e:b0:3bf:d71e:5af4 with SMTP id x14-20020a05622a000e00b003bfd71e5af4mr980852qtw.26.1679417965607;
        Tue, 21 Mar 2023 09:59:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y5-20020ac85245000000b003de68caf5b7sm5783159qtn.35.2023.03.21.09.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 09:59:24 -0700 (PDT)
Message-ID: <355dc00f-8ccf-ef75-c511-3864b4f6c448@gmail.com>
Date:   Tue, 21 Mar 2023 09:59:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 1/2] smsc911x: only update stats when interface is
 up
Content-Language: en-US
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
 <20230320092041.1656-2-wsa+renesas@sang-engineering.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320092041.1656-2-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/23 02:20, Wolfram Sang wrote:
> Otherwise the clocks are not enabled and reading registers will BUG.
> 
> Fixes: 1e30b8d755b8 ("net: smsc911x: Make Runtime PM handling more fine-grained")
> Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

