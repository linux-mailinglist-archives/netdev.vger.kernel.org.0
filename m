Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE411F0DFF
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 20:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgFGSZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 14:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgFGSZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 14:25:38 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015A6C061A0E;
        Sun,  7 Jun 2020 11:25:39 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m1so7734536pgk.1;
        Sun, 07 Jun 2020 11:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Ph49GcY3aIPW6rucwTefkRQZ2djxmUWpfLK/Y1wBdY=;
        b=bZiMoy6kE8AOKBmfjDDSx3b8RSH/CoKQJ3U6FaV/6euMuTF9VfzDCIJiC6daTxsUEq
         Xx+EI5zBYSjTyzNv8PLm1xwPM6c/NAcL8ZnfYqIIJzrnIrPjGhQEr+pDRYMdFK7eYdJC
         HOnxKO11v4E9XtN2bTatUlr/UaYd1pq1sEfB3tS+HEYS8YnX7uPsLjQY81+2E3qkG/HZ
         l5HTrBtE/glH6dmKbT44UnyTLRHWeYAm0xl5sheWXSAIQDXHdY0CYdCyc4BPc4yMtfmY
         Gc0I1ztodg0No6BUZLe7aINqz3x65bTyfM9tc3vWKPUvVFWBdTjfSZyO1G8JVB75dLQE
         zuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Ph49GcY3aIPW6rucwTefkRQZ2djxmUWpfLK/Y1wBdY=;
        b=XnEkqhVlYGlZ7tayD0I6pJmcFHQQLhpUOX7mDC+Tm+gH0VlrgTDddJCQsl2KIfE7lP
         /yiXQrC11HjN6nCkT6h4JAksV4gLljaP6zokKzvlxCYSHHQC2/Co7OEcbbWwl7N2J3/e
         3Ivrt3LFlEh2m1Rqx7D3iZVvkzLVl/ZCDpNyA0zf7px2eusSfLO6i5RqQ0KxFQlMsVdY
         e90tXEpCb5hT1ck2z8gpOoZE2CzyMZ6q+/+H+p2oKW0F2gL6BMkZzqw9rqMV8ACIujGo
         o9YcXlKfvsOp8dqDkEujMY7v5cU+VV4EmL12ztwUMOAiV3JI6rw5aogkAxXyykuCop5b
         YSbA==
X-Gm-Message-State: AOAM533tS4xyNRkbt4SlC1LaTc0NZEY0X9AEj3pW3Qng2MW3lTXkk/M3
        86XOoTa967zGL53wzN3VqoS2cK/M
X-Google-Smtp-Source: ABdhPJyR0Ptywo8mEVWAEG7PRsAnOjIpK+XM4lmTbKb4kdj9deD1RS8C3KpBLVVJ5YjWChTqJGcyBw==
X-Received: by 2002:a63:550d:: with SMTP id j13mr5858163pgb.139.1591554338198;
        Sun, 07 Jun 2020 11:25:38 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id o11sm6040967pjq.54.2020.06.07.11.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 11:25:37 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 07/10] mlxsw: spectrum_ethtool: Add link
 extended state
To:     Amit Cohen <amitc@mellanox.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-8-amitc@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7dcb004e-7bab-3026-7863-af16c1a4d556@gmail.com>
Date:   Sun, 7 Jun 2020 11:25:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200607145945.30559-8-amitc@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2020 7:59 AM, Amit Cohen wrote:
> Implement .get_down_ext_state() as part of ethtool_ops.
> Query link down reason from PDDR register and convert it to ethtool
> ext_state.
> 
> In case that more information than common ext_state is provided,
> fill ext_substate also with the appropriate value.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Is the firmware smart enough to report
ETHTOOL_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED only when using a *KR
link mode for instance, or do you need to sanitize that against the
supported/advertised mode?
-- 
Florian
