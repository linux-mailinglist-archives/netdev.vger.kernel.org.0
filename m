Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2EC50ABEF
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 01:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442511AbiDUXX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 19:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442454AbiDUXXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 19:23:53 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC26447047
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 16:21:02 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b7so7037955plh.2
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 16:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ryMsxMvMEIasRCCZmk0/CzyRBcK4BJR2ClNYl9j1bf4=;
        b=TYpk6n/8Sv2mMN9auZkHnmaKevuOzxsM+btXgSAOJXBPCnXClIEsLLXSngnqB8WbOr
         vVhSBnRyDxk3OIgS/mkElnDwFELJZ8kd70c+gmv80uCahYiEkh36ykz7R6RYuYA8WS3f
         mYqaZ2TcDimX4Od+aZtu/uC4A0aK1j23QfecSYJ/rgiXX/W2ojtJWRsQnmfY0RoQ7yMY
         zVXLNVQ7Nk/H4jmXqfqV/qXc7jhxmmIl0+6T0bnJU8ZTDkO6honLgC1VVHpjWZdmlvcy
         55sUpUqbZrKxOs984I4bxi4wnFZsp3rT6snZgMaRyFoTYxoJKQCMRxjfoUHvgw3VgTVO
         yqAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ryMsxMvMEIasRCCZmk0/CzyRBcK4BJR2ClNYl9j1bf4=;
        b=CgMvfdyylpFFvhUB0q2O3ByrmqSgoiMphySs3Yfdf7T0gX/HyQKqCKInE/A54fGGhe
         8+L0QW2h9ngE2eJkA/fLsZkPKeDMpE4RRUH+vLmbTpYynbsRRA200MSEro2G6+h43x56
         NMYH10m9rVHE8lU1Zx5wJf8LGJ0AduHSQEuMt9J+8RWs17+8GUlCgYatWBu4G5PaYNZ1
         cNX2wMMlbiolz7cP/k8f887J0ovn6DAYEOqHtJ1n8vlVSclEIgrICE+rgSUZO+7aq2mz
         5h2Eh5w2JYPpArYLD69V1eRu/9DW05rHYurTOLlC1HwTMqCBOJrUbuOmz3WwI0m/JJ3a
         AcpQ==
X-Gm-Message-State: AOAM533PfDGyQ+IuKBhVzZXpqoqmJXG6PfSjB5TVyd7u9515M5hBcIAf
        JxuNTS3GcVBmZ8rJoircH6s=
X-Google-Smtp-Source: ABdhPJztlJtD60s64jW5rVSTeXk7HdMP6rRbVqDZ8tjLd2d90emDMKmBtcUKTPelJoVl5B3MWXel+w==
X-Received: by 2002:a17:902:d506:b0:15b:284d:e121 with SMTP id b6-20020a170902d50600b0015b284de121mr1815465plg.94.1650583262257;
        Thu, 21 Apr 2022 16:21:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gb5-20020a17090b060500b001cd60246575sm3929045pjb.17.2022.04.21.16.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 16:21:01 -0700 (PDT)
Message-ID: <be10c925-fbd5-77ea-07e5-873ec940b59d@gmail.com>
Date:   Thu, 21 Apr 2022 16:20:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net: dsa: flood multicast to CPU when slave has
 IFF_PROMISC
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220421224222.3563522-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220421224222.3563522-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/22 15:42, Vladimir Oltean wrote:
> Certain DSA switches can eliminate flooding to the CPU when none of the
> ports have the IFF_ALLMULTI or IFF_PROMISC flags set. This is done by
> synthesizing a call to dsa_port_bridge_flags() for the CPU port, a call
> which normally comes from the bridge driver via switchdev.
> 
> The bridge port flags and IFF_PROMISC|IFF_ALLMULTI have slightly
> different semantics, and due to inattention/lack of proper testing, the
> IFF_PROMISC flag allows unknown unicast to be flooded to the CPU, but
> not unknown multicast.
> 
> This must be fixed by setting both BR_FLOOD (unicast) and BR_MCAST_FLOOD
> in the synthesized dsa_port_bridge_flags() call, since IFF_PROMISC means
> that packets should not be filtered regardless of their MAC DA.
> 
> Fixes: 7569459a52c9 ("net: dsa: manage flooding on the CPU ports")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
