Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F043409A8
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhCRQIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhCRQIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:08:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2817C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:08:04 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so7100967pjb.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T4af8BpGIjOoDjkxSSRwHhxsShH+5EpQKRzrwSExico=;
        b=p5Jai2fRb4py7SaKv2v8llWvk0h6NBUBCBrwhWeQhehIAAt5Iwi0dfuTMrjuFUOdSh
         IZdGDJYEHp2W1/PHsaikzWxT7ZVKM5xPk2NuoQi/4WOMHwZrfyEjRwpe2TNpYsgcAY5R
         yIW51RXUmkKp8MsO0aSUcSdmTnWc1p7YRHs2DktvE8G5PHHxw0jnhkGSdwrCG8BLoy+c
         vwecWakNpGCzDBGLd+syL7ZZy0OHrLZH/pUq2Tws1/mRx+eAb23vr/CCw00JG8Ao1VW0
         GADs+/m8WHQbbZyoJn8vuLV+IQU62fnd9bDSahWgj2GB+JQJhl2IfMoU1mBqcZNEbrVv
         emFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T4af8BpGIjOoDjkxSSRwHhxsShH+5EpQKRzrwSExico=;
        b=Y4xqzBiV7ZrVyj5MuNjiTp27Ph3apjF8oqd/OkvvLBACkX7FQO4NHY0GLJ0Bfu9k3C
         FflsXqkp2aS9HDoqXmgIfuy2YGtktPPtEn55WyJaHp7ZIt61xCAp7eyaPV3fatovdxZe
         nr+ncZYHTBctKE6O4QLFFENLhUw4Tl6OMb2C2ssljZ1TIhue/LvnsISsIXtsOrHshdVz
         zucZiti865NgEaZ10WXbk9ZF6nVhPUn86K7VSNMIaGYiExaYUmkrE29g4UgSL/fQYhSP
         JO0n0mggC9/5kt7n0PIgflTSzD2P0c/cwA10VILkV4KPGihqaLC8GxJkQU8fhZ3zo1g5
         8BPw==
X-Gm-Message-State: AOAM530SDG8ChFjhsRCXznBzigLVM+rAhDDCrf8Em8WzFU8JdhQYz747
        IGZLnMQBdgH0GzLRiTjMUbXAaL6AjGw=
X-Google-Smtp-Source: ABdhPJw9VKKDuct3Vw+OqtpdiurzL82L1qJGvtORGVxlQ/M3r3Eu61L1b7XjiOzgotkIoOS2n2xp0A==
X-Received: by 2002:a17:90a:c289:: with SMTP id f9mr5190037pjt.105.1616083683928;
        Thu, 18 Mar 2021 09:08:03 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 202sm2853654pfu.46.2021.03.18.09.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:08:03 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 1/8] net: dsa: Add helper to resolve bridge
 port from DSA port
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-2-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <87470400-052b-c132-9db8-96034ebfd252@gmail.com>
Date:   Thu, 18 Mar 2021 09:08:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318141550.646383-2-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 7:15 AM, Tobias Waldekranz wrote:
> In order for a driver to be able to query a bridge for information
> about itself, e.g. reading out port flags, it has to use a netdev that
> is known to the bridge. In the simple case, that is just the netdev
> representing the port, e.g. swp0 or swp1 in this example:
> 
>    br0
>    / \
> swp0 swp1
> 
> But in the case of an offloaded lag, this will be the bond or team
> interface, e.g. bond0 in this example:
> 
>      br0
>      /
>   bond0
>    / \
> swp0 swp1
> 
> Add a helper that hides some of this complexity from the
> drivers. Then, redefine dsa_port_offloads_bridge_port using the helper
> to avoid double accounting of the set of possible offloaded uppers.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
