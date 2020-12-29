Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8852E6E59
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 06:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgL2Fkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 00:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgL2Fkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 00:40:45 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5786EC0613D6;
        Mon, 28 Dec 2020 21:40:05 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id x13so11029945oto.8;
        Mon, 28 Dec 2020 21:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=kwkydlycgL+LfXIxFJaVTJYy6HCMNVPuKMi7Zzs4Ziw=;
        b=KaAvqbPCrQU/f25FZSJmnuEloU5W+3P9EAW0+Y/x/c8TiW+fZPdAzXDce5QWixLx4c
         8Cz80BkGa0H2PZvq88GFpfUuE1PHaCCOJsINWZoXPaItabeS52rS04X9WKQdOkcHJ1Ad
         T+0nw3Phllm+BkgtEHU1cnP1LLUch7ACwZ+PUCiVtKVez1Mc8KBN2gUbfKNVzzR1ccvd
         6mQUN3D+zSlZvmcUSpOjBYYxQ8m63grL19N+6D8BBLD6AwJM2td+Yz8OsF/U6I7l85HQ
         sRrAWkBOGXGto4UAoG0GXb+95cAIBf3wlC2UvvV6yWA2v5vWycNM6U7CqVBj5BDXQa33
         hWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=kwkydlycgL+LfXIxFJaVTJYy6HCMNVPuKMi7Zzs4Ziw=;
        b=ivP9aHUevpm7d2JerIpzCYxj7NHI5z/iNR7QSJmYPb8YnKME4EkGAUSgp4pQ6ukEKe
         y7xKYuVJeh+hO5Nc7RgFuuO3niZUQlxWu/3IVmG/m1j8FWQ/saSgEdDJcgmQJen3A4jW
         DdfAM6T/IMcVbgosAuMSSuxdUcS+m4LuL4vmx0+4y6vl9sDwJPKC16j2uLj/GfH8SCyB
         +XzdlPDNlXiwz/MrC/vZ2j1Rx7eQLvdfwLrgWa2rQzw6p3QFSgDHFpGfVblaiuAsj4Sa
         Hnu7wuBljrz0PaNA0Kmw3xicMksMz/MRgkA4wkHNygWxZp5pJAAy5xshv20N8rRj0p8+
         PyEQ==
X-Gm-Message-State: AOAM531Yim4ljUkXpAi4V0z4IzGxR7ehBQMSSQnrVVABBBTsD2huF3lf
        8663pv2OiizX/6Aa0dcd5fk=
X-Google-Smtp-Source: ABdhPJwDE/Hk/4m7aQqZ17RpKsKKmONcsTi2IEcyLBxN1a29NBZv4i4fgEhBh8FBWU8urd/SIgpd/w==
X-Received: by 2002:a9d:68d8:: with SMTP id i24mr36912910oto.31.1609220404876;
        Mon, 28 Dec 2020 21:40:04 -0800 (PST)
Received: from localhost ([184.21.204.5])
        by smtp.gmail.com with ESMTPSA id t12sm9543542oot.21.2020.12.28.21.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 21:40:04 -0800 (PST)
Date:   Mon, 28 Dec 2020 21:39:57 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Message-ID: <5feac12dcbe7c_7421e2083e@john-XPS-13-9370.notmuch>
In-Reply-To: <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
References: <cover.1608670965.git.lorenzo@kernel.org>
 <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
Subject: RE: [PATCH v5 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce xdp_prepare_buff utility routine to initialize per-descriptor
> xdp_buff fields (e.g. xdp_buff pointers). Rely on xdp_prepare_buff() in
> all XDP capable drivers.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Same as 1, looks like a reasonable cleanup and spot checked math in a few drivers.

Acked-by: John Fastabend <john.fastabend@gmail.com>
