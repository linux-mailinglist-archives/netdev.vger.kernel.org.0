Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A1E585688
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbiG2VgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbiG2Vf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:35:58 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8E11A381;
        Fri, 29 Jul 2022 14:35:53 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p8so5645916plq.13;
        Fri, 29 Jul 2022 14:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=QPmr60t9wUVzKIHeOB+ShV7lcz/KtoVA9YkYs2MyKAA=;
        b=CGzyxasmMsfTlwTVKIIOlwPccEPcaJkUzjz6xo1KtzxyHBAxsxElvLIcg+wyCu1Bdt
         Id5kr/OpK/kkVrJ+JlRSFhEdzuHW+yGNQtvSTks1RN5apGuNYKnx1spLnqIZbE7mLujL
         TUeh8XJ6Dlo1YJbNN6knoSwIk8DZkbIm4NZnlhcZ6xwtftDPHmnq6uw6xNO8gq0Q65Jg
         BwJw91VZ4xPb51IA0Y69dqn7YgaVqkzqFLNhYWiXbPfzL1RGTD1Tn6Tvd+rojNcGQLZ7
         bfcp0JguXCPeuPgH3/EE5AwmVghUoHbDbb7EmGirl4G7lA17CXx5x7JMCjIKdeFAEdVX
         l5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=QPmr60t9wUVzKIHeOB+ShV7lcz/KtoVA9YkYs2MyKAA=;
        b=TTJRCuNs1W9wYjSoK/Ycdi3YwkVGs87sZSDwzVhW9Nh0M3L2syfMY4gWjv7Aiy49fj
         /LtuRGIxGOX7F5fQ2DMqZX6sGlcMrKJskeFoiKB4TPNjF7ZfQd+qMxR1tRtGm4EqDTsF
         PqPGdiTkzN2/0cEE8hG/Nx+POE2Ntn7j27X8IYW6qXnBBmFvBTEKvJEBU5Y+GL1xJS3C
         pghOSnR/uQ03kSuhD+Yta/wI6ZxKUAwLuxR4hckV/wdPOIEQjELlBZ4sGHA0sA4em+9j
         jvqSFhFx0lx9Kgbv5zXZCOMTOgiWfkSaNVO0qwTx/nMRneUGeMSZEcrbZOHIs8lLRJpA
         7/JQ==
X-Gm-Message-State: ACgBeo1Oi9OenSag5MvBkpegSUVd79/+47PWh56ue61+C72fYgdCWSbN
        cRV6zb9ynwGwi94ybAintjY=
X-Google-Smtp-Source: AA6agR7+t3zxbYyaYzNcO1HJFGW0OCfG9tiMK7vSmT0jAGyqrGD19TVtfxxXQEZhSVUVbSxTdgDjVQ==
X-Received: by 2002:a17:902:aa06:b0:16c:cf06:c2d0 with SMTP id be6-20020a170902aa0600b0016ccf06c2d0mr5718941plb.117.1659130552654;
        Fri, 29 Jul 2022 14:35:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p5-20020a625b05000000b0050dc762816dsm3360172pfb.71.2022.07.29.14.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:35:52 -0700 (PDT)
Message-ID: <ab2061af-46ac-53e9-87b1-5f609379da5e@gmail.com>
Date:   Fri, 29 Jul 2022 14:35:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 06/14] net: dsa: qca8k: move mib init function
 to common code
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-7-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-7-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
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

On 7/27/22 04:35, Christian Marangi wrote:
> The same mib function is used by drivers based on qca8k family switch.
> Move it to common code to make it accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
