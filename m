Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F1C24A7B2
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgHSU3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSU3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:29:18 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9648EC061757;
        Wed, 19 Aug 2020 13:29:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id g15so7485807plj.6;
        Wed, 19 Aug 2020 13:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=7ddsMD+oAMSxDYFcv0EBBJa/q2PE7PVd6TOOolF+FKE=;
        b=Znkt7jfxdz3lB3BgaB3TtINMjI5C95O4H8XyNOEg6TmIVs2wUD7Uptc5ZIYwzne0oG
         Brh1AoSmTN0DzkRJjcdCbctKzS2eh2ztgfAuOy8oqmOPySJRzc7oh0CRftcG9wfG/KJ/
         y2ZvkBoIMYOAonlT3SJkTCzf3tOswPANpBjWWlFkRylTB2Cja82Gy+DZVcK7yiueche6
         ynuHWyR156rq5YHNYLNnisia2COfW5Vx1ZRwMW66lJeJJuEPWi4kpZJDTtmNMycvnpPc
         EW37PibyYowFRntjNKe4WLuy/u2qAKAmSU7QfZgUEFKOUDPc8JgIEpl0Mfe01BMo1AbR
         pEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=7ddsMD+oAMSxDYFcv0EBBJa/q2PE7PVd6TOOolF+FKE=;
        b=m+wJtUtbLJvsHy5b01XH/vFRoLfWelasHTcIG5goknbbQv2ejCmpTc6ewXLZp+dJiO
         2INE/Y5jIj64r5NAh5TpEC9zDF8xkqm3raQO2JK+Ts3dCfMNyaY9sQ6ETuZCToSNHS/J
         fDEBbW3HWKdPMbDHpYQoSH/YpPpyduJF+F9e1tlgj8/DhfbIDsVe+oX8iF/1/GjrE8U3
         M5xa/ZH6xUMBktL4kUIJRHhUtG+DJ2bjCF59Dl96CyvMdbbZ2//2KfokP97P01SbrQW7
         0xQojYuWIXPNriYkD3SkYrkaCfbKw+8ZsPJROSnAF3b3QaFWtQI9He8+esG369AgS5dB
         VQ7w==
X-Gm-Message-State: AOAM532d0p4Rr3KEHbdzhiHMDFl3gSdNPUZBeZS33JgQOGvDSzotoFA2
        k5Vj/djfAim9SA7CpjfPtj4=
X-Google-Smtp-Source: ABdhPJx82ioiATacMPxNACBfUGAxX3ntOC2vzGkafztdooYo7CjFuNBGKwz6ysYaShcle6/wPIO1ug==
X-Received: by 2002:a17:90a:f290:: with SMTP id fs16mr5372763pjb.35.1597868956644;
        Wed, 19 Aug 2020 13:29:16 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a15sm54495pfo.185.2020.08.19.13.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:29:15 -0700 (PDT)
Date:   Wed, 19 Aug 2020 13:29:07 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, jakub@cloudflare.com,
        john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5f3d8b93e7aa9_2c9b2adeefb585bcd1@john-XPS-13-9370.notmuch>
In-Reply-To: <20200819092436.58232-4-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-4-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next 3/6] bpf: sockmap: call sock_map_update_elem
 directly
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Don't go via map->ops to call sock_map_update_elem, since we know
> what function to call in bpf_map_update_value. Since
> check_map_func_compatibility doesn't allow calling
> BPF_FUNC_map_update_elem from BPF context, we can remove
> ops->map_update_elem and rename the function to
> sock_map_update_elem_sys.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
