Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF864A5DB7
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 14:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238928AbiBANw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 08:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiBANw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 08:52:58 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CC6C061714;
        Tue,  1 Feb 2022 05:52:58 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id y8so14410624qtn.8;
        Tue, 01 Feb 2022 05:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pkH+RswlSIyZFjtv0Mro5CDt277HOkp7LMJ90iXn1wU=;
        b=d2XckV5LjzZSDAsLvl9yGRmggAR0CRNlsdqRbYzPDMVgaHv7N63o147fv0hE2qh4/s
         zw/TI5e0gVjazGEckbyyin8CLhEQejbBfO9OD0RK/G9Aa4Q0+DTYI4O/TMWJkv/yHH4v
         XbN+gzGb/fEVjvekjKITtTKpojKkq2DEGkb6BOMrJieDhoE4UyKGDKwJITJiU+mVaGCI
         AJoifbOsH1WBhIGjLC8yJTu1Wi6Tg4SQ4zAfH0uSNHs9yQnNmBYWMe2Duqh2TcfzQqGI
         732lqYSLTsA36kQ2Fmre3LUjzYYCjpAbdAjQSKRIPWEwrSEn2slKYPWBJAA0w4G1KjNy
         mTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pkH+RswlSIyZFjtv0Mro5CDt277HOkp7LMJ90iXn1wU=;
        b=cyeXgTVSltJoIHZqxCticAzW6gYjsAljk9UCb+jKVb+WQr0d4918zn8tBXvh2KVT1n
         gxrliFh5ieLH7rg+3VKCyEXXRukNgFDgY51gRnZHSwtgHvrJrxZbHiZM9sLDEXVRNiIT
         Fy0T/VJf/zhXHJMxn4+ZyKaZ9M7g/jet8QNJhFtnvq4ryohU8X2DvGXCVFGbbrTOBSH9
         fEfssexgdmqe5qWBTQ/DDMTl4sIek8JkoHikcqGhH/P0ZbFnWfF62AAbDLSPhG7d9YJf
         HeE7KviAQklLXZIJtIsBdrbqtENSgmF7r0Z3xc3cuAhzJMrvqUkSY9rm33mLniTUJ9QW
         XdoA==
X-Gm-Message-State: AOAM531Vx+eDonakcQGjBhekWmTza6GvglIYtfeXpcKXb1AxVrXxjE/L
        gk75O1zLdATaBotbF3wMtV4=
X-Google-Smtp-Source: ABdhPJxN8n52vA9LcHKw0qHFFvqFn0lzXyntuIYuyVZRFK583t6IVU4lsQ5eKMA5PDjZ/lxTtC3RHw==
X-Received: by 2002:a05:622a:156:: with SMTP id v22mr18593903qtw.596.1643723577901;
        Tue, 01 Feb 2022 05:52:57 -0800 (PST)
Received: from a-10-27-1-133.dynapool.vpn.nyu.edu (vpnrasa-wwh-pat-01.natpool.nyu.edu. [216.165.95.84])
        by smtp.gmail.com with ESMTPSA id a141sm10300049qkc.73.2022.02.01.05.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 05:52:57 -0800 (PST)
Date:   Tue, 1 Feb 2022 08:52:54 -0500
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: Re: [PATCH] rsi: fix oob in rsi_prepare_skb
Message-ID: <Yfk7Niu74yv3OCm7@a-10-27-1-133.dynapool.vpn.nyu.edu>
References: <YcnFiGzk67p0PSgd@b-10-27-92-143.dynapool.vpn.nyu.edu>
 <87y22udbyg.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y22udbyg.fsf@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The maximum length allowed (and without overflow) depends on
the queueno in the switch statement. I don't know the exact format
of the inputs, but there could be a universal and stricter length
restriction in the protocol

It is possible to fix the problem at the previous check you propose,
we just need to add input parsing for length and queueno there.

The code here seems prone to overflow, since function arguments
only include a single buffer pointer without a remaining byte count.
Moreover, some of the lengths are dynamic and encoded in the
buffer.

For this reason, I think it's easier and more maintainable to add the
check after existing parsing code and before read/write the buffer.
