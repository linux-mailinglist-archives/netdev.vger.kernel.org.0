Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E35A3FCFF4
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbhHaXfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240043AbhHaXfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:35:05 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881A0C061575;
        Tue, 31 Aug 2021 16:34:09 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id m11so1657926ioo.6;
        Tue, 31 Aug 2021 16:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=YwKcv9v0vy0tKQEYXiqpZoaW0Cp8BuWuqSYFJgeoiMg=;
        b=oRDNOE7um0tPEQZce8BFRmVs62r/8R+GqErAAhawSae61X2zaNvzeS19XFemsGnpR6
         cgBHRp/U8V2r6jpMDYp4hOF0Z4t8NqHH/uynR7SxoMRmWcKPgaxnQ+QhBdINPPS+1y0R
         EpPuVsHpPafDRzBKM3p3V8qOvkwebbF+If+EZpNV3AmREgVTGuhbZpsqUm3k2+oM4xIe
         9c3UwWnE3CVmxprtq/f1FGzv3Xj6mT3gh/QFYwiEPdt8OW+Cb8slI3HrcQbl9VrD4Ejv
         g9rvHIPlEFJrA6XbnVhtGTxpMDhnpO20t2QLltW+O3ErVjaAbnfzw6SFIdK6MQ2kVb8P
         Iwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=YwKcv9v0vy0tKQEYXiqpZoaW0Cp8BuWuqSYFJgeoiMg=;
        b=AFmkmVxuQIIAGmC6GaS304eFwZLOCE8FE+9efNcEqxg74RV3mA4ez89nwT2qQsyGE9
         0/MtL3dU5fluL7AveJZzEFzo3D57S6LfkUytpBCSYSKk8AgDaemjEiMxQHVe6G03NSnD
         rHFTSfxigByLEdBUV6xwcgIeivCVWZlzCQ1d3+sACBvi2YnDXh02yUu65WzqsSnIuiud
         icDrv3NeDJ440KIbVN6c9IQYOigA4e/V44/HK9eWeUSnmeBNJz9o28HxSKvYe4fQDEeR
         Y8JUOz5BL8BtzqgXNMGjHGpq0kpZMj7y9Y2hb8NOZuSWTru+zsgujdNgtAvx1yxisOmQ
         kXZQ==
X-Gm-Message-State: AOAM532MEQQVZJRrFJ5G2RdbpKpNgpJHE3cMpSey1GlJI1jJ9DT8svBh
        6viiIU3UYhlOeA2xqdM4Q5I=
X-Google-Smtp-Source: ABdhPJyqyJEAFMOoDi8LGxCOM5p4zQOGNfrQTSqPejZytc+QhRq2asbILUesm/F1aXhr9w2ouM7Feg==
X-Received: by 2002:a02:2a07:: with SMTP id w7mr5141206jaw.96.1630452849005;
        Tue, 31 Aug 2021 16:34:09 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id a9sm11440598ilr.36.2021.08.31.16.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 16:34:08 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:34:01 -0700
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
Message-ID: <612ebc69e8a00_6b872086d@john-XPS-13-9370.notmuch>
In-Reply-To: <07376cc8434f63d7381486194c0e221812e1e217.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <07376cc8434f63d7381486194c0e221812e1e217.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 04/18] net: mvneta: simplify
 mvneta_swbm_add_rx_fragment management
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Relying on xdp mb bit, remove skb_shared_info structure allocated on the
> stack in mvneta_rx_swbm routine and simplify mvneta_swbm_add_rx_fragment
> accessing skb_shared_info in the xdp_buff structure directly. There is no
> performance penalty in this approach since mvneta_swbm_add_rx_fragment
> is run just for multi-buff use-case.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
