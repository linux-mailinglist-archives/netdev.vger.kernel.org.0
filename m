Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762E94F632A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbiDFP2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiDFP1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:27:32 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85645576B43
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 05:26:10 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id e16so3735084lfc.13
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 05:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=OrbMPwY+ceFHK1tWcAh49PgHycaB+KWkjNAMgz/yS4M=;
        b=N+eHoLMjz3aQX1BeMPlfMi/xG6UAb28JIvV7p/OfS6xSk4ZOR26TxjfuWmlA9BwB4P
         vL83PXdRPq7Cd3t2ljwIYCig1xh4XPjwU6FViSXf68PXO2d37GjXzOMHYd980/MvAkBw
         bX5lOfnmsPfvQgO3Q3IQu0G9932zH9NZJkDD7G8jGin9VZFdHMriDeZEtUNzF7mp7alA
         iI0P/pvX9l1BvnQd8/uoDuAQPcsg7q70g9QUD7dev4/empMWEC8gN2+JWpVuOISl0hgR
         UbHKnSHgrKDMi/EQ4hJZbwZwGD8eqZpvnkKTYsu/7PJjwnqIahq9DsbBWj4m2MmB8OiV
         J5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=OrbMPwY+ceFHK1tWcAh49PgHycaB+KWkjNAMgz/yS4M=;
        b=ltw3zY8yDlWfKefGoHmjIXt6SKRLNqq42hBz0sAfkIBV7QjmVIYE1OEUz9k3GtbEQw
         cU+vv494C89rTImd5y0NnvnzjdjpUHRB+++SbfrucjD0wS6AHkW0sMh3I3Vyf1/w2BT0
         GmtqaFyp8hDTEVmf6B67k69bocdt3qWHlVK1b0+gHHjvGM8mzKttZdbg/0+qjWxT7azP
         IFoRR29x3s13BF5CR8Wp5rAXHFRl2/AtbpRa45PbEuF+wlxIGFXOuFL8yVO94/k7zQhG
         /reLmXPkSiR5YjO9OIrI+B7Qc/JbmCro2BgKXXrXr5xIWjIg9sAHAm12Ruo0BDA2+vsm
         dK6A==
X-Gm-Message-State: AOAM530U7aB2gTwAUsDsUl6SBKWgNmkJAGAaZwSGQge3YpX5WvzslHel
        3va1WJN9Y+doxX03LfXylM8xes1ai68k6Q==
X-Google-Smtp-Source: ABdhPJwNspnN+I75P3HM8/RHDBAOXPPc6hPRk3KFkmNOcshYQEQ0aziZr9h9+f6kZMIe/m5kohxYqQ==
X-Received: by 2002:a05:6512:3b0a:b0:44a:2e21:ef25 with SMTP id f10-20020a0565123b0a00b0044a2e21ef25mr5718111lfv.333.1649246282128;
        Wed, 06 Apr 2022 04:58:02 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id br32-20020a056512402000b0044a1fdb8e85sm1804471lfb.134.2022.04.06.04.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 04:58:00 -0700 (PDT)
Message-ID: <73e88719-1082-1b5e-b565-c2b12af23b5f@gmail.com>
Date:   Wed, 6 Apr 2022 13:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 net-next 0/2] net: tc: dsa: Implement offload of
 matchall for bridged DSA ports
Content-Language: en-US
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
 <20220405180949.3dd204a1@kernel.org>
 <84412805-f095-3e39-9747-e800c862095d@gmail.com>
In-Reply-To: <84412805-f095-3e39-9747-e800c862095d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-06 11:24, Mattias Forsblad wrote:
> On 2022-04-06 03:09, Jakub Kicinski wrote:
>> On Mon,  4 Apr 2022 12:48:24 +0200 Mattias Forsblad wrote:
>>> Limitations
>>> If there is tc rules on a bridge and all the ports leave the bridge
>>> and then joins the bridge again, the indirect framwork doesn't seem
>>> to reoffload them at join. The tc rules need to be torn down and
>>> re-added.
>>
>> You should unregister your callback when last DSA port leaves and
>> re-register when first joins. That way you'll get replay.
>>
> 
> So I've tried that and it partially works. I get the FLOW_BLOCK_BIND
> callback but tcf_action_reoffload_cb() bails out here (tc_act_bind() == 1):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/sched/act_api.c?h=v5.18-rc1#n1819
> 
> B.c. that flag is set here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/sched/cls_api.c?h=v5.18-rc1#n3088
> 
> I cannot say I fully understand this logic. Can you perhaps advise?
> 

I cannot see that tcf_block_playback_offloads() -> mall_reoffload() is called at all in
this case.
