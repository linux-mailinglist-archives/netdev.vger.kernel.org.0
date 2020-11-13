Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624CB2B252B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgKMULV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgKMULU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:11:20 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456D6C0613D1;
        Fri, 13 Nov 2020 12:11:20 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id y3so2453303ooq.2;
        Fri, 13 Nov 2020 12:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5WrITl8G1ZJ8uxn4Xdou0W06LMVdC9M8ctyRP2jkkxw=;
        b=P3dCuKkqZzDmoEnAQnflafPqsvn6ve9+yXycEeUHtR4+vJ5OMSi1KDM3TQ51yY4sAj
         yqFoUA7fQDQJ8tvHevBbNzgIhY4eTERVWLv9l+zNym+JoyuCWvYJ65LCe47TXMnRW/vW
         iG1gsqrklpkV0AIvyEDv6Ol0/U54siP/yCT+LZsLqvSMDQ0phThOET1EXGfoR4f5kzk0
         9HoT5sVA6JLJsB+0LHcDpz5Lq0popcWiRQG2gEgey2ZQHuWze4OF63F3NBYp732r8IT9
         Uufc0JoBjcRiFcW0c5+20RGSNkst6GaT1nCxIVhC0yJEb1WYQFsivFDo/WgpDF27nRH4
         f1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5WrITl8G1ZJ8uxn4Xdou0W06LMVdC9M8ctyRP2jkkxw=;
        b=d1L9+m3hnnpnx/cu6+eF/xecY8dAmwkfVF2ZZ+10GwMPGubQOF3z5VcmOCcUb1aIo3
         +8w22nBmtWp8BbzRqtFztQXBePy64KxO1iwmCApMpCegJtltENHrLQmWlmXFRSe5Ow2Z
         I9xVOht3jNLQdHMRFy4cUdydYzvx2xaJZD/40Nzil59/+1rpJFY/9JwSqD62rpuZ2wSj
         Ox3Sk8h/18N3s0e4BzOond+zZY/CT3z9bSYzb7pS6m/5QWdLHChGzNUk2vhh+ubJ8DsA
         ELCRPPrn1o6msyBftdioKAkpnvbtxcYiD94pRp4uNfXWG0ItAHZdV8ZF6U1T+HlBmX85
         MJCw==
X-Gm-Message-State: AOAM532Ksya67WnhthRgqAbI7vFWXCG08J8O4TJBepBj6ZUfFnB4cWyU
        RVOCMrG0X+F2+97InQZzXd8=
X-Google-Smtp-Source: ABdhPJxGLBOTq+GUIwLhBjIwxw67Vk5FbHBjIz103bDgBohVOkrDdAD/20KjlHYMvkkLJkt0e1hChQ==
X-Received: by 2002:a4a:4444:: with SMTP id o65mr2876296ooa.52.1605298279706;
        Fri, 13 Nov 2020 12:11:19 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f34sm2180525otb.34.2020.11.13.12.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:11:19 -0800 (PST)
Date:   Fri, 13 Nov 2020 12:11:12 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, john.fastabend@gmail.com
Message-ID: <5faee8607f18f_d583208a5@john-XPS-13-9370.notmuch>
In-Reply-To: <250460319fd868b7b5668fc1deca74dd42813a90.1605267335.git.lorenzo@kernel.org>
References: <cover.1605267335.git.lorenzo@kernel.org>
 <250460319fd868b7b5668fc1deca74dd42813a90.1605267335.git.lorenzo@kernel.org>
Subject: RE: [PATCH v6 net-nex 5/5] net: mlx5: add xdp tx return bulking
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Convert mlx5 driver to xdp_return_frame_bulk APIs.
> 
> XDP_REDIRECT (upstream codepath): 8.9Mpps
> XDP_REDIRECT (upstream codepath + bulking APIs): 10.2Mpps

Hard to argue an extra 1+mpps.

> 
> Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 22 +++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
