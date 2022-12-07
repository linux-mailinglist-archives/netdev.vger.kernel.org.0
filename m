Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F43645B76
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiLGNyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiLGNyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:54:46 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E084908F
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:54:44 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id kw15so10717228ejc.10
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=duUnwRItpG2/U2bWuMLcopd+jbHjjMzMKCoDTuyYmvQ=;
        b=bvmljO2bCXC7q7aimtV+jvBdd41/vzXXNoWzdPzYbWcpyiLGQ43W5O7yeYLM8ltzhu
         O/IhZ6KP/GpS01OOXYNYZY7luzgB2fZX+zL1JxXo2nVRMij8dl1Du8oG1q/OEFEwMTiT
         ZFXZOUjb32Hgh71Xj7+7VAOMC2TjyQEwsxOtcr8gDnVDrSh/D8xChbCV781t7S0mBNLs
         LjjWHsydwTs25LpizNLWsUxEdX1DwYI+YLqg7arjqmg/H5jg49apgFCCWFZZZpg7Trrs
         UcIVdPi04RY31nmlauuAwQbJBgZen0h4tjB5TR9BQiGmvcHu+vfPuCQmsbGbWgcA3177
         9zxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=duUnwRItpG2/U2bWuMLcopd+jbHjjMzMKCoDTuyYmvQ=;
        b=vDrPmY9ZndUZ/cB0EMGEt2Vh5HZZoT9e1h0iCI9XgQsudEqIpFE/B0NJti46M+yYHz
         s7mvRTKC/K0d+5xOeRDKWRki8ZaRzGJLbmCANluD2TToguF8SbYP8ypUvBIsO1Z1isxR
         JCnnwxYUNuUUDhX7pKk/MXWOL3QnXJUBhRW1/4/eTUpuQDQrbBlP4XTGq1YM8bdo99b4
         X37re3MQ9OLdsARtGO2VvNpSO0IR79huRoWkacmY+3YXNJ5iI3A8YbQ8g7V2F6Xgrcna
         OwpYj1TlzqmVQ2n5SPI/9XlWUVSfJq7Gq+hcagMHpTjurDMGF1pyYs97AlhTGr0DeK7y
         3Xqg==
X-Gm-Message-State: ANoB5pkbMMQ+hFyMBxk5u+x/N+BpwDqCswHQvHDQnstDwMVKTorPiQCp
        PjHLQ4dd4uE3ajfqvSD4+ixZwA==
X-Google-Smtp-Source: AA0mqf62uyZQit6rwOIbsPfG+g/Hl1c7/RiYWfKXAZYXdEywQSoTJObWzB+FJ6537lEGknfFlR68mw==
X-Received: by 2002:a17:906:1445:b0:7a1:6786:444f with SMTP id q5-20020a170906144500b007a16786444fmr59772408ejc.409.1670421283062;
        Wed, 07 Dec 2022 05:54:43 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o3-20020a170906768300b007b27fc3a1ffsm8521518ejm.121.2022.12.07.05.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:54:42 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:54:41 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v2] net: plip: don't call kfree_skb/dev_kfree_skb()
 under spin_lock_irq()
Message-ID: <Y5CbIW/6LsHGbQg3@nanopsycho>
References: <20221207015310.2984909-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207015310.2984909-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 02:53:10AM CET, yangyingliang@huawei.com wrote:
>It is not allowed to call kfree_skb() or consume_skb() from
>hardware interrupt context or with interrupts being disabled.
>So replace kfree_skb/dev_kfree_skb() with dev_kfree_skb_irq()
>and dev_consume_skb_irq() under spin_lock_irq().
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

I wonder if anyone is actually using PLIP these days :)
