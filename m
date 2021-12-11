Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D5B4715A6
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhLKTY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhLKTYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:24:21 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE3DC061714;
        Sat, 11 Dec 2021 11:24:20 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id o20so40288190eds.10;
        Sat, 11 Dec 2021 11:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=84hUlvKVgZDC+ZcGqUWLm8LxXshIZ4qu0ulOtjIo8fw=;
        b=U4XQpvqNX7Ys4mSMsp/DkX7ErKQINfCKPeIbbk2VeBZiwmD6pbBeRIH5c8a8gYL2ru
         AbKgxxQIyvE2rmWuv7vbIbIgt2Or0rQbhGGhLY1UCGPuvf44ZfAPlUgAioTq3oGa90QA
         QCKrO8IDT1EdLPwKUtwfLYSPSrVe3keJ6UAeva16C7gttXANfkJk3bPlvvybLXgh5LiY
         5LGSKHepNpdXNESWEh9EE3ep5KN7qZ3R+azIkbDUi27mHctLY9vNzovQ+gJoGFYaQcy1
         UHbQyll13SFKMFDji+s4PNZaXl2nLePJAbcHEnRUdkemclKSB+a7xuT32OgAOlwLJl+x
         v/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=84hUlvKVgZDC+ZcGqUWLm8LxXshIZ4qu0ulOtjIo8fw=;
        b=vrlDuJ8O6w48Cp3z4fKeMlir/Q9sPWcfEh4Wo+5/7orV/UIEHLlqIWTCvrTgdLhP8L
         wMtI0xAOri2BtZyZDMo8tGuyEq204kSgw7ZY4wCkDaoJDKdPBR3XB7yZ9kvkTnp8oo+z
         6vBwl61yJJXEpEoDcMyoVLPCVgL0TsW7wUR/CpFMsgjahsra2TdYGAdJ8BXYutu32Eas
         EN5yaoWYEHv9ng92Z8EFaKeoPC7kkMmNHj6KG3IBPWX/XHmgkqpfm2NqX6sWs3+OhHCZ
         OFZrIM6+x9CAwyT3Uynw5FWMkplAzDFA38dXOv/k8HMqLAIDfedc7dolxI8BMqGf4Ffb
         6bNg==
X-Gm-Message-State: AOAM533iAnwFyf4cLihM0aCtAqUlxm3ulOyWYIjXrk3AV977Syag3EWR
        7F6F8Hu9Rp/RFiav3bZSQ14=
X-Google-Smtp-Source: ABdhPJztpWpCMFwm8PQ5kxnnY9fltNkaYjrulKtdM9e+vgMeZiTldKn7IATnl3pxUkVNVKjPQS5uog==
X-Received: by 2002:a17:906:c112:: with SMTP id do18mr33497385ejc.103.1639250659211;
        Sat, 11 Dec 2021 11:24:19 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id hx14sm3423140ejc.92.2021.12.11.11.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:24:18 -0800 (PST)
Date:   Sat, 11 Dec 2021 21:24:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [net-next RFC PATCH v3 07/14] net: dsa: tag_qca: add define for
 handling mdio Ethernet packet
Message-ID: <20211211192417.n5vzf6jniqqxfwir@skbuf>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
 <20211211020155.10114-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211211020155.10114-9-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 03:01:40AM +0100, Ansuel Smith wrote:
> Add all the required define to prepare support for mdio read/write in
> Ethernet packet. Any packet of this type has to be dropped as the only
> use of these special packet is receive ack for an mdio write request or
> receive data for an mdio read request.
> A struct is used that emulates the Ethernet header but is used for a
> different purpose.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

These patches (the ones with /14 instead of /15) are duplicates. I think
you forgot to wipe your output directory when running git format-patch.
Also, I don't think you need to copy the BPF maintainers just because
you posted a netdevbpf URL, even if scripts/get_maintainer.pl says so :)
