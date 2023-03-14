Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91206B9225
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjCNLxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjCNLxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:53:03 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF819AA33
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:52:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so9940756wmq.2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678794752;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aedh/JywdEDddUhtE7uVGsi7gtYL/10VJ/CukUBA1H8=;
        b=vvT+5UdeB8eGOFM81g4n+k4wQ9SVBSS11dhgcVOho/2SIHAyUa6SAVGc36AQmewtqr
         ArHxEVjkZaVN2wVJgFRRnqptlu06+4lUeR9djPAcFSaeUQShiB5TM91waN7zIk0/G1JL
         k+NuPV2LOt+uCiaFDzbsRzBlHmwIHUWB3aKbrASxbtXw62tPCe6JT5sTXTffDlw9Bb6w
         GK+SKKefR7hNspP0KiFAIyKZb5FNTUvrM55zmajbOBbJjIAXJxGlLVPBaj4fYGsXx004
         fE78b1lLSyX0BeqBvP2slTilJw+vOPJffC0UwFyBSQ/SEL2EeVaRAHL7La7CGkyZqlO4
         /mHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678794752;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aedh/JywdEDddUhtE7uVGsi7gtYL/10VJ/CukUBA1H8=;
        b=RToSc2X0igrxNLCtyKLjudvguJNDVic4hdyos48Pv0QDsExDNTC/kRJG/nZBey5YoA
         m1pH0JmaV1DIc0Zy3/jNDnGHJL9C5LQidONf+X8DXvHjY57xPeGa1Y06hQQSORQcMWX5
         aiI6GpvcGTPWfqp80VT6K8VugZbU5fDPDWZ7uk/opBVvDDsKEJ38MZE5K5vodw2R7UBD
         xZNl5MuitlqPzFvzhRvBSn2ipVGz6w9sN1QQQBKwGqiiEMLGm3EXL3BuNdMuDChPUNY8
         3op2XvNQ+Quf69YBfihbylz5p5SFILUrchN3m35RdC5UWSsX3H+FeYEtyFNB/dBTJGP6
         9j0Q==
X-Gm-Message-State: AO0yUKWJt5/MEMeLO5MNlXKeNy6Asax2cHqBPLadq10tq2w9VL18FOOl
        PWYCCytFVRK8nZ8rFj8JHphhMQ==
X-Google-Smtp-Source: AK7set+cNk8lszF+XqJrXfffx6akHX/q+EmpmlPIAUuC7Vc/3+4C3af5qQXQkWFpem/k4kz2J1iCqQ==
X-Received: by 2002:a05:600c:190a:b0:3e0:6c4:6a38 with SMTP id j10-20020a05600c190a00b003e006c46a38mr13658284wmq.33.1678794751960;
        Tue, 14 Mar 2023 04:52:31 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id q24-20020a1cf318000000b003dc522dd25esm2514742wmq.30.2023.03.14.04.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 04:52:31 -0700 (PDT)
Message-ID: <2097d3df-050e-ad7a-66dd-93019365b19d@blackwall.org>
Date:   Tue, 14 Mar 2023 13:52:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 06/11] vxlan: Expose vxlan_xmit_one()
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-7-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-7-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> Given a packet and a remote destination, the function will take care of
> encapsulating the packet and transmitting it to the destination.
> 
> Expose it so that it could be used in subsequent patches by the MDB code
> to transmit a packet to the remote destination(s) stored in the MDB
> entry.
> 
> It will allow us to keep the MDB code self-contained, not exposing its
> data structures to the rest of the VXLAN driver.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/vxlan/vxlan_core.c    | 5 ++---
>  drivers/net/vxlan/vxlan_private.h | 2 ++
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


