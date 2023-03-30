Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07FD6D0553
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjC3Mw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjC3Mwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:52:55 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2100C7D9A
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:52:54 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id l7so13912327qvh.5
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680180773; x=1682772773;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gXOBCEw1Lnwy7kHJBjlq4sPchl5Pyfy8g4HHGRcRKcg=;
        b=HrkcrC035zq1esDwOlf96QfhO2bEQd8K8LAZU8fF3Eov8WyGhOJ5F7w0IWQ+AlHn0/
         cEgQhJ1bXpb+z5dQcrAY0VBX9F8Wur+sqHkCBAUifC8AxpGMTDo2WQ8H4SB3tYfY5AGY
         GKDwTgkNOfkchKM/C64FHS+HbMwWXhwXxavgiKe260TBOc0/wnpnq3KMsYPmiK7sc3Sq
         mce5zCUwutpKmJc9naREyx+YNOvq5hzyatVBnMZU5QXQu2a4g4+vxVzSh3RbWtzrGp12
         d2Z8lkLCXv8Dwb8JaFvdZE9vSU120knjrfOqwkLZ7frjFfD2j6Q/2AFdJkHI7VZKcVnA
         pY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680180773; x=1682772773;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gXOBCEw1Lnwy7kHJBjlq4sPchl5Pyfy8g4HHGRcRKcg=;
        b=EJtZsEyOGuw+4PltsdA/vp/gKQXjWEKhcSojr9DarEmUL/efqifPd33bsw6du/OAEU
         ltGL5Qz+2DLrHEl6a9QAZpGvyYAETI662AvhXR6kaFRttI3EZTGE3JGJuQztDmSKA0kz
         ZlwZbJeuwQafWcAm9oc+KDLim74p0elxuwfVTD9o2s2vkOvlNlFDUzkIxyMITeBN9eAt
         ZZaO+AY3h1xtF+6mhJcwFd0ANiRwrKBNaqVMZeJbZyItxSUBGRRH3i0GLt8VJLu1nkly
         FmQUWQXbvAFgzsF00YHbsRysdIx8kwrywXpDRL9Vz/b5xWEJdxmcWkLWtnsu0I8vqvcU
         jSsA==
X-Gm-Message-State: AAQBX9cN78NBUOP2HKWABFoWXFrOLkAWWGZVG2iEx9SZ0rYxKBgLOQdE
        dchCBCt/2EC9WLstzAl6VsE=
X-Google-Smtp-Source: AKy350ZEh7Vaz37IbPdzwyxS9nrfvTwKbI1qIA3cpYoYg/fK6v+wbXExJYC4u8BZu2utZLfJa8UTVQ==
X-Received: by 2002:a05:6214:27c2:b0:5db:4e49:b2bd with SMTP id ge2-20020a05621427c200b005db4e49b2bdmr9463128qvb.18.1680180773248;
        Thu, 30 Mar 2023 05:52:53 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id do2-20020a056214096200b005e147356c5dsm29701qvb.125.2023.03.30.05.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 05:52:52 -0700 (PDT)
Message-ID: <a9ed1380-b06b-5170-18fd-3bdf702e8d3b@gmail.com>
Date:   Thu, 30 Mar 2023 05:52:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Enable IGMP snooping on user
 ports only
Content-Language: en-US
To:     Fabio Estevam <festevam@gmail.com>, kuba@kernel.org
Cc:     andrew@lunn.ch, olteanv@gmail.com, netdev@vger.kernel.org,
        steffen@innosonix.de, Fabio Estevam <festevam@denx.de>
References: <20230329150140.701559-1-festevam@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230329150140.701559-1-festevam@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/29/2023 8:01 AM, Fabio Estevam wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Do not set the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP bit on CPU or DSA ports.
> 
> This allows the host CPU port to be a regular IGMP listener by sending out
> IGMP Membership Reports, which would otherwise not be forwarded by the
> mv88exxx chip, but directly looped back to the CPU port itself.
> 
> Fixes: 54d792f257c6 ("net: dsa: Centralise global and port setup code into mv88e6xxx.")
> Signed-off-by: Steffen Bätz <steffen@innosonix.de>
> Signed-off-by: Fabio Estevam <festevam@denx.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
