Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE031370451
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 02:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhEAALG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 20:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbhEAAKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 20:10:53 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEC0C06174A;
        Fri, 30 Apr 2021 17:10:04 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m37so7906292pgb.8;
        Fri, 30 Apr 2021 17:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=v6iX4wiVzn0CF0AR8f9+wiH67gWfwkDuxVsnuyMU9ao=;
        b=QYVsbJTr7ice6Yurwsp+f0783kQ3AiQnSc6Xc8n+XR924Cj2LWvIPogDcBiMmpo2Gz
         XYOhpUET9TWlIovXH0G0+y+2T6sFHV86QC1Y7jHnbrjcVjFHmZDgXRZj+haxPfKHwug4
         MSg82LZ4kj1HD/GRh27on3ag+c+e7SuhWHpAGjqYlsQnpQ8dD/cHfRREwbVVxzy0ZVBv
         OrpM988RT3eT46Iky57tapKHnVqlnGJKiZ//M7qvaeyx2F56+cgil/0fjpAgzpEnM4ic
         +jpq+ut4fmceBtA8GrXGyYSVRK9CaG1Q9xvkw88doYRo+0Zrcq4xyZUYe3bcmzdmYprA
         ultA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=v6iX4wiVzn0CF0AR8f9+wiH67gWfwkDuxVsnuyMU9ao=;
        b=KdYtR1XhnT2Lg9s8CDhoF+cSDqlKXlK+rmau11swI4e7mdeNHgkldwZlKnvw2tnGer
         g+SYvVW34G3m2/V7S0jYtUFfr7ghQxQhoHWotUoG9+yh6r5hoousfm4MMut0d49MxG0b
         1pWd56WSRf1IdxFQnTihJxjKbt1js7TjJGiXJUd+WpZ/aW8V2nEcF092hYt0HMoc4MoG
         flJm2/a8qRzwfds+6QcmVTo+b/nQap5Su9lQxk314fJSe3GXuvKQkiY3cjxy95Qav3IF
         6vHj7bP+1c77708Q0yGrGuw8SvyvvCj/1TS3cXs1X/iNY3akauZY9RIGM4RvP5jYDqui
         ll+Q==
X-Gm-Message-State: AOAM533dNWDpMiIkIypvtwISVBgjxP28PF7tysQ7IZ/v1oZt81CWQsaU
        gwuFWrf/FvIih82c4NOlqBI=
X-Google-Smtp-Source: ABdhPJy6ogV528OF9EBbdDXDiXjNuOt7DXwKoMOX9SVQ/DB16Jl86H49Kb5c+AJLs2bXMqqo80lPhQ==
X-Received: by 2002:a63:4652:: with SMTP id v18mr7142249pgk.386.1619827804247;
        Fri, 30 Apr 2021 17:10:04 -0700 (PDT)
Received: from ?IPv6:2601:646:8100:c5c1:bacc:5f54:da58:762d? ([2601:646:8100:c5c1:bacc:5f54:da58:762d])
        by smtp.gmail.com with ESMTPSA id 1sm2884019pjx.46.2021.04.30.17.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 17:10:03 -0700 (PDT)
Message-ID: <8e420732d2aabccca8b5e932b589ce90d9f70d6b.camel@gmail.com>
Subject: Re: [BUG] ethernet:enic: A use after free bug in
 enic_hard_start_xmit
From:   Govindarajulu Varadarajan <govind.varadar@gmail.com>
To:     lyl2019@mail.ustc.edu.cn, benve@cisco.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 30 Apr 2021 17:10:02 -0700
In-Reply-To: <65becad9.62766.17911406ff0.Coremail.lyl2019@mail.ustc.edu.cn>
References: <65becad9.62766.17911406ff0.Coremail.lyl2019@mail.ustc.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-04-27 at 10:55 +0800, lyl2019@mail.ustc.edu.cn wrote:
> Hi, maintainers.
>     Our code analyzer reported a uaf bug, but it is a little
> difficult for me to fix it directly.
> 
> File: drivers/net/ethernet/cisco/enic/enic_main.c
> In enic_hard_start_xmit, it calls enic_queue_wq_skb(). Inside
> enic_queue_wq_skb, if some error happens, the skb will be freed
> by dev_kfree_skb(skb). But the freed skb is still used in 
> skb_tx_timestamp(skb).
> 
> ```
>         enic_queue_wq_skb(enic, wq, skb);// skb could freed here
> 
>         if (vnic_wq_desc_avail(wq) < MAX_SKB_FRAGS + ENIC_DESC_MAX_SPLITS)
>                 netif_tx_stop_queue(txq);
>         skb_tx_timestamp(skb); // freed skb is used here.
> ```
> Bug introduced by fb7516d42478e ("enic: add sw timestamp support").

Thank you for reporting this.

One solution is to make enic_queue_wq_skb() return error and goto spin_unlock()
incase of error.

Would you like to send the fix for this?

--
Govind

