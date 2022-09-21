Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914025BF66E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 08:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiIUGfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 02:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIUGfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 02:35:08 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CE5474F6
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:35:05 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so3146367wmq.1
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=K8UT/sDGoc5+8sb9aAEd8YbPkQ5ZW4khLA46CgiEWOw=;
        b=DOkvVGcV9OM+FqAAw4SofheyllXU+lIRalHQe/+CyKE+SPrZ1766x4NaBs/dMTU5Gk
         ELGfqSlVnVwEjyhE6r7ddyM3Ak43O2CQnD2uBWUnhX3S14Onqb3qMA0/sXm8N0PS518h
         ZKgxt7K/aUsW9Mx9b2BhAj5ERudHVTG6ZfGBDzFgvryBerdzGS8eHxFAZ23J9zXVdJb3
         Gtkjoj8WIkSxgWyXJVkL+JE0nVGZ/oi9WvRCqphyQ1WA2YyAd1i7suqwWOICne11t5Xm
         GaRZWCDXMARoR7Goxm/Ow9wiDJBMvsQIlCcezCj50cYE6O935JpYOp26WduySHFTSPwn
         3r8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=K8UT/sDGoc5+8sb9aAEd8YbPkQ5ZW4khLA46CgiEWOw=;
        b=PEEn3B68VAKiydCai+JBJMuDywxUGavUeV/sAnWWfStasVFdLrbTQmRomC9bYy7zYj
         PlGBCcVYlW5B8wLqlzIPoKpPwgUjJPzWM2o6csRNN4MtzOW95Yusu3rkPI2tTVD8aA+h
         EFuxVt4Lt8QIAWONx/z/v1XQJMr+7++YOWSBbNL+icDYsqMl5yP50YBUR2jIiZFHFndu
         VNiwFPxa+LKM3tN/W/SPsVcYOfOhfk9zjKWQnsYcNkchekcQUwQL2YJJjNNtjeYt1dqi
         h0oMvQEls8mdZmJbxsRlT07zEK2MwjHmjgFKHWDrjst8TL48d5yEP/2hailPNFCkDxf8
         TblQ==
X-Gm-Message-State: ACrzQf3hFId44cl5vtQAcXQoMsqTQy8lrnemgLISvANKkhfA/Qzdh1vR
        2/8vzdgbWdqvWRT/qE+EO+aL0w==
X-Google-Smtp-Source: AMsMyM5t7XEZ9VqBV3zxswQ0FkvRD/xTJ24n4nktdQqT8Lv/iskEb0YO9YwjsPGp951ug7w2xveUEw==
X-Received: by 2002:a1c:202:0:b0:3a8:4197:eec0 with SMTP id 2-20020a1c0202000000b003a84197eec0mr4733663wmc.83.1663742104305;
        Tue, 20 Sep 2022 23:35:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:d6f:4b37:41db:866e? ([2a01:e0a:b41:c160:d6f:4b37:41db:866e])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c3b1500b003b47a99d928sm2003903wms.18.2022.09.20.23.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 23:35:03 -0700 (PDT)
Message-ID: <4e6d2e4b-7f08-59f0-531a-103e4bae7173@6wind.com>
Date:   Wed, 21 Sep 2022 08:35:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2] tun: support not enabling carrier in TUNSETIFF
Content-Language: en-US
To:     Patrick Rohr <prohr@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Jason Wang <jasowang@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20220920083621.18219c3d@hermes.local>
 <20220920194825.31820-1-prohr@google.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220920194825.31820-1-prohr@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 20/09/2022 à 21:48, Patrick Rohr a écrit :
> This change adds support for not enabling carrier during TUNSETIFF
> interface creation by specifying the IFF_NO_CARRIER flag.
> 
> Our tests make heavy use of tun interfaces. In some scenarios, the test
> process creates the interface but another process brings it up after the
> interface is discovered via netlink notification. In that case, it is
> not possible to create a tun/tap interface with carrier off without it
> racing against the bring up. Immediately setting carrier off via
> TUNSETCARRIER is still too late.
> 
> Signed-off-by: Patrick Rohr <prohr@google.com>
> Cc: Maciej Żenczykowski <maze@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
