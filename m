Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3313946A4B1
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241820AbhLFSie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240707AbhLFSib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:38:31 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B15C061746;
        Mon,  6 Dec 2021 10:35:02 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id h16so11216390ila.4;
        Mon, 06 Dec 2021 10:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=RAb96UCiaXw6MtSUrhTS6T7fSHFOHo/BOxPMDP2JWfc=;
        b=SQL4tepQawv0TamQBhHwckCu9lzXyTwWDJLk2VGYh4HhvhC26U8tUaaLO2ag02I1vn
         R37BG6W0xCkZMQr+0z+4H3qDrHJYokVL5X1r0z7qGWYXSl0RlTBSx92LOSvVg/1WtRAk
         xbC7OweT8dW/v1nyekrJnR9Agyth4/2iqUbts2RrmCqs+YaNPYGjmh5UssotdbA6myf6
         T06KQI8TbPowcCWSTTLuWeD8AXsHmFBAkUyhZc1kGwvI92GDvwdDk0CkWm9qbClWdTzm
         pt6lUQq9pB1jKWO5DEKAq9E/jZRqPqsW8dkT7Va/vuAFDM8XcGkEoCDeMp2i2/BYBpP0
         06Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=RAb96UCiaXw6MtSUrhTS6T7fSHFOHo/BOxPMDP2JWfc=;
        b=MM3Irj+ear6+IcAnRyY9T1NOC5rmTj/cpP+lvvlRr3+lwpZgjWw+gzs5oCWJM/mYJm
         jNRAdLTreiPwTMuXUgnVQrCGK/p9b5pGABcFBPJfLC9G4ZCM4XGhTCYnuj/ffY5Q25Jl
         fGEs9n0OzYBu98MsCzq4UFCDkjlhS9ZP6T/1E4RyqAzmhyk9YmB+rrfRZrLrjdOCx9Z3
         91meGWABEvYNe8cj0d79IJSvylQs0xCLGM+8T0pgor8i2AHPM5h8uXuA28e5sftxC1Bc
         pURu40pbVsD+YPeuNaK/9dMD3Yl6KNhIk3fKyzQWVpFkmtKD4xD/KMonLaJ/W+zjCUXA
         GFXA==
X-Gm-Message-State: AOAM530TrC8J6UIT4pQONNCY1eapGanzjAuGGQF4veF9mPHLnyogfOYI
        pJ+F+YnLKy8TQbnOM503VSlts0DmNtDdxw==
X-Google-Smtp-Source: ABdhPJx/M5U81lqSD1KKvUxNn50uIqEQCXiibFuwGeeQ7jYU06FcYTDArqSycPYL0szRMsd7bTCJTg==
X-Received: by 2002:a05:6e02:931:: with SMTP id o17mr31776472ilt.174.1638815701798;
        Mon, 06 Dec 2021 10:35:01 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id p14sm5071457ilo.11.2021.12.06.10.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:35:01 -0800 (PST)
Date:   Mon, 06 Dec 2021 10:34:54 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ae57ce93424_8818208f2@john.notmuch>
In-Reply-To: <f29bf20c59ebecb3b49785b4eea36d5910146e5b.1638272239.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <f29bf20c59ebecb3b49785b4eea36d5910146e5b.1638272239.git.lorenzo@kernel.org>
Subject: RE: [PATCH v19 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer
 utility routine
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Similar to skb_header_pointer, introduce bpf_xdp_pointer utility routine
> to return a pointer to a given position in the xdp_buff if the requested
> area (offset + len) is contained in a contiguous memory area otherwise it
> will be copied in a bounce buffer provided by the caller.
> Similar to the tc counterpart, introduce the two following xdp helpers:
> - bpf_xdp_load_bytes
> - bpf_xdp_store_bytes
> 
> Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Nice. Thanks for working on this.

Acked-by: John Fastabend <john.fastabend@gmail.com>
