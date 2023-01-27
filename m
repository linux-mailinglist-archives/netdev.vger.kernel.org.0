Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4B967EC7D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 18:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbjA0Rcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 12:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjA0Rce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:32:34 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419F07B429;
        Fri, 27 Jan 2023 09:32:33 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o13so5243179pjg.2;
        Fri, 27 Jan 2023 09:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cyayte7rNg2NCJ6jPKmWFL1WfNKxwC/JMC/OKuubiGU=;
        b=WaPr0KeYTiDLX8X2RriP4gLi9IPbq/+D88103NJbzxQtCIomVyr8nKGlKe6VzdOg3Y
         9G0SfGMWLwVgj3rZJ6XHH9+x/20aRzkUqpJAMXpNhUox2/2ytqqgDIVCuRjGspxFbLY9
         JMLBl0C2+PkIKGZiRG2haBcLDg4TMcNdoZ2jYUvejO//io+QtnW211g7EoXJOla74WUu
         42f8qFGBA3lRzNmtUfdkE/QveOsc7BmLMqi8QR89FD1VxhUQcjG6snYjMIA9VHbZegmj
         jJ8v11WSar3PWWz+L9Sh7O3h2NLnA+PDOdqZiR6x3er0mIoqa6LkzGcQ5f/oYtOD7k53
         8Scw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cyayte7rNg2NCJ6jPKmWFL1WfNKxwC/JMC/OKuubiGU=;
        b=0B0wZnxEGdfsSe0i0bw1yGCG5YU/JkINOcq9o+Y9Mjx+AaW06SdyrErBuMaW3wYz1u
         Syhgze3XS8OIHyKX1R6Ps3NPxkkxDu855fzZGzR+X1ZN28VRNK84ZpESgMLeAX39/9Li
         SPdFoXeOmAEASiN99dnkn+APmfnxVuA/PqqaYGLX9d5K82QCIdjWwFFdJE3IwJRUDi6T
         uiFExvA+tIgABOqjAeAXk9gEw6wQiNK85Q2uT1M0MGgI14127+YkGt8yUzDQh5JpYTIK
         ul8tE4jtDEZLRuY1MYX8eZrfYxRqd2DFAjW2mhXjjvy4GcorvTv4LapK7nZC2RpHCuPs
         YizA==
X-Gm-Message-State: AFqh2krFKHlQJUI9wq0u0yYuNxf/CZa88MSEWmXxqO64JQWedUHrWdTQ
        0/ub6qvS40/zxAwygpgWFEw=
X-Google-Smtp-Source: AMrXdXtnk+xIcjnPAxmSRN+4u8WzyrGUdpyQfv2f7eXuPRTl1cJpWvD8/J17MOOq8o2D24kuuKphaA==
X-Received: by 2002:a05:6a20:8e03:b0:b8:a19f:4f6c with SMTP id y3-20020a056a208e0300b000b8a19f4f6cmr57481427pzj.62.1674840752687;
        Fri, 27 Jan 2023 09:32:32 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u144-20020a627996000000b0055f209690c0sm2903262pfc.50.2023.01.27.09.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 09:32:32 -0800 (PST)
Message-ID: <2d2e6c03-7351-1c8e-4fa7-51794a9164bd@gmail.com>
Date:   Fri, 27 Jan 2023 09:32:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v1 net] net: phy: fix null dereference in
 phy_attach_direct
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Xiaolei Wang <xiaolei.wang@windriver.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20230127171427.265023-1-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127171427.265023-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 9:14 AM, Colin Foster wrote:
> Commit bc66fa87d4fd ("net: phy: Add link between phy dev and mac dev")
> introduced a link between net devices and phy devices. It fails to check
> whether dev is NULL, leading to a NULL dereference error.
> 
> Fixes: bc66fa87d4fd ("net: phy: Add link between phy dev and mac dev")
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
