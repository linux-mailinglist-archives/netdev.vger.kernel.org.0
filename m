Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA58715339A
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 16:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgBEPE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 10:04:59 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:35771 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgBEPE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 10:04:59 -0500
Received: by mail-wr1-f53.google.com with SMTP id w12so3161531wrt.2
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 07:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PlDhaJ8Sw38uoJM3gdrliBfBfxA9sPnzc4qiaTjySx8=;
        b=edgdigrInsb4WIj7e+1PxKft/1odNezSKF8PIf2TaSYgXkmgVuS0ZpfWTZdMbkuqc1
         DGTBF9s8DLusXu6NPGwle6sRzs0XzmNHb0PwO06jZWEFZbPTyh5MUjm2DQJglBNZwFwa
         roAh0WKyi1DaD34QTdoOkQ/GV00ebPg12yEUfHCoZjoGus4CfurEYbdwfx5kmjRtF+y7
         B7IQgMCJS2OADWWAZMlT0QBG0VQ9k+iITGt1vQL6d1TEfwzjKvmHHJizQ4WVcmi5ZHsI
         hNHvbC8R5RyuN3tMyVEnezcCNFhBMbm0nNA307x6xLlbOcjzpR2t4KxCncbVHEXRQTVa
         t9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PlDhaJ8Sw38uoJM3gdrliBfBfxA9sPnzc4qiaTjySx8=;
        b=jwH7Ug7d804VumXBdzgNXn9OVQe18SxYeCVmbBkxuvUJ5j1CZRM78iram4iDKX7EmK
         OzoSShqKqDoK6AbOk+Zgs4icnkia0T3YSMeKzszBJ71+QimtVSpiUjnHiUjixW3xtiDX
         As+3CKLBBTP90YVq3a80dReR3nadAPzYZEgeipcUxiHTdCfZ4cLm72ShzmmkHexNYUHP
         4DrPH7RvmLoiqbV6UUYvCi4/l+SCijoIsvhLsld6PR0n0fxO3793byOOccS84kv7VGGR
         eDogRGh+gEMoTK4bPO2AmBzj6Qm50FkcrQfnVN2A1zO8hJkx0c78GHen5v4NeejTRNao
         7X7Q==
X-Gm-Message-State: APjAAAU0mr7ZbzHYmmKAYmhckrjSrMSa2zIa8X7Tc+bP3n9bHz9l/cSo
        ZApTDS4OB2qg4XnCk0AuA49CRpvKcAo=
X-Google-Smtp-Source: APXvYqw9q2tga1R2FVuaZwNW2vPqfiBOJgI+jQKBdb5qgR4V6S7A1egt/KH6vkcZDy/CpBGwl+/ISA==
X-Received: by 2002:a5d:488c:: with SMTP id g12mr29501007wrq.67.1580915097210;
        Wed, 05 Feb 2020 07:04:57 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:9c0f:f129:76a:d5c? ([2a01:e0a:410:bb00:9c0f:f129:76a:d5c])
        by smtp.gmail.com with ESMTPSA id f1sm83640wro.85.2020.02.05.07.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 07:04:56 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] net, ip6_tunnel: enhance tunnel locate with link/type
 check
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
References: <20200205145725.19449-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
Date:   Wed, 5 Feb 2020 16:04:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200205145725.19449-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/02/2020 à 15:57, William Dauchy a écrit :
> With ipip, it is possible to create an extra interface explicitly
> attached to a given physical interface:
> 
>   # ip link show tunl0
>   4: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ipip 0.0.0.0 brd 0.0.0.0
>   # ip link add tunl1 type ipip dev eth0
>   # ip link show tunl1
>   6: tunl1@eth0: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ipip 0.0.0.0 brd 0.0.0.0
> 
> But it is not possible with ip6tnl:
> 
>   # ip link show ip6tnl0
>   5: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>       link/tunnel6 :: brd ::
>   # ip link add ip6tnl1 type ip6tnl dev eth0
>   RTNETLINK answers: File exists
> 
> This patch aims to make it possible by adding the comparaison of the
> link device while trying to locate an existing tunnel.
> This later permits to make use of x-netns communication by moving the
> newly created tunnel in a given netns.
> 
> Take this opportunity to also compare dev->type value as it is done in
Please, don't mix patches and problems.
You will have to split this.

Thank you,
Nicolas
