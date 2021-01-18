Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9D82FABAD
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394355AbhARUiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387996AbhARKgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 05:36:39 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857DBC061757;
        Mon, 18 Jan 2021 02:35:44 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c124so13101327wma.5;
        Mon, 18 Jan 2021 02:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=sdjxudr61Uts0CJPUO0ptlpFH4t8XuWtSUvltKTeu/w=;
        b=KiBcLdjEMeNXY6KCVUy9KRQrCd+oQFLbB8a3RL9tPKbShfiAw3dOZvnaApZc3dpfwI
         b0pennEhFkL1nsy15iWZ2iz2UIp+DHObfbhe6zVSAVDs4/KMzDF0cGuA41lPvDwciD+R
         TDRimv/OgoK44kz8gu94/SvN/OY6w1CnHk+BsXG3puZ+B+BiHlsnk1KYhmn937QV6ALp
         r1qIer2QAB3dCrH3bTOGCDpmfm8v3PXOCS2ZdP+sBMZHNWQOt/TqSjobwjAigVsImaup
         I8lHibktyhqQM9gC8bT/zQg/4yCPUx/kEiqqEt9h1tnyKhYdLOb1ukuZNAJjwWKBr4Qu
         +Tnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :thread-index:content-language;
        bh=sdjxudr61Uts0CJPUO0ptlpFH4t8XuWtSUvltKTeu/w=;
        b=mcqVOSOByGZ2lbJoWGN9mz9+RRdgA644bj3UG4TaQY1fKyQSUELw0X7w049fMp/ShG
         46NSq6/kDm3SzGH2hLkYMyf9ziVITf08wY5ekyvRHhvF4Ipg40bHicaoSpAdHB5fc7Ga
         tIPW5aqudtwjJUTRnT9QIauFibVYxt9GzrXrbRVuVflJ8p2duF22zrWlXD4272W4UqGe
         bnqLR9Q/spQOwIuRKAShr9FHhqKEuYmEuBf/PUfvBoVAHzYxr63ZwSJkh7ilKW2r9bhr
         GQW0Q0WQ7trnHxArwJrN76sHdl8yCzdjJC3q5kSjrBKhFPw8aDPz/X5s+rTljmNA7XJU
         ny7g==
X-Gm-Message-State: AOAM5311C2kc/OoPS/q+Tayvb8Z8a06caIWEy3w8x8nOKihBUHajbXhd
        qxwaxmT4y9zwkm5jEEx8/NE=
X-Google-Smtp-Source: ABdhPJzC0Mvm9IJPrgzjYLI8UEjrhypmUYqZAuikpTgtyFJQL6Un9LpHRADBfIEfqUSzBjI2HuL3Qg==
X-Received: by 2002:a05:600c:19cc:: with SMTP id u12mr19675937wmq.26.1610966143356;
        Mon, 18 Jan 2021 02:35:43 -0800 (PST)
Received: from CBGR90WXYV0 (host86-183-162-242.range86-183.btcentralplus.com. [86.183.162.242])
        by smtp.gmail.com with ESMTPSA id c20sm24821042wmb.38.2021.01.18.02.35.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jan 2021 02:35:42 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Lee Jones'" <lee.jones@linaro.org>
Cc:     <linux-kernel@vger.kernel.org>, "'Wei Liu'" <wei.liu@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'Jesper Dangaard Brouer'" <hawk@kernel.org>,
        "'John Fastabend'" <john.fastabend@gmail.com>,
        "'Rusty Russell'" <rusty@rustcorp.com.au>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, "'Andrew Lunn'" <andrew@lunn.ch>
References: <20210115200905.3470941-1-lee.jones@linaro.org> <20210115200905.3470941-3-lee.jones@linaro.org>
In-Reply-To: <20210115200905.3470941-3-lee.jones@linaro.org>
Subject: RE: [PATCH 2/7] net: xen-netback: xenbus: Demote nonconformant kernel-doc headers
Date:   Mon, 18 Jan 2021 10:35:41 -0000
Message-ID: <00d601d6ed85$ac1d8f60$0458ae20$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGx99OgEkOz45dOTqKA2L+6769RlgFYXaBkqmxYlxA=
Content-Language: en-gb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Lee Jones <lee.jones@linaro.org>
> Sent: 15 January 2021 20:09
> To: lee.jones@linaro.org
> Cc: linux-kernel@vger.kernel.org; Wei Liu <wei.liu@kernel.org>; Paul Durrant <paul@xen.org>; David S.
> Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Alexei Starovoitov <ast@kernel.org>;
> Daniel Borkmann <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; Rusty Russell <rusty@rustcorp.com.au>; xen-devel@lists.xenproject.org;
> netdev@vger.kernel.org; bpf@vger.kernel.org; Andrew Lunn <andrew@lunn.ch>
> Subject: [PATCH 2/7] net: xen-netback: xenbus: Demote nonconformant kernel-doc headers
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/xen-netback/xenbus.c:419: warning: Function parameter or member 'dev' not described in
> 'frontend_changed'
>  drivers/net/xen-netback/xenbus.c:419: warning: Function parameter or member 'frontend_state' not
> described in 'frontend_changed'
>  drivers/net/xen-netback/xenbus.c:1001: warning: Function parameter or member 'dev' not described in
> 'netback_probe'
>  drivers/net/xen-netback/xenbus.c:1001: warning: Function parameter or member 'id' not described in
> 'netback_probe'
> 
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: Paul Durrant <paul@xen.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: xen-devel@lists.xenproject.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Paul Durrant <paul@xen.org>

