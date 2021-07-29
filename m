Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7118B3DAE32
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhG2VXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhG2VXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 17:23:36 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA38FC0613C1;
        Thu, 29 Jul 2021 14:23:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ca5so12074967pjb.5;
        Thu, 29 Jul 2021 14:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DghCXD4NppA54luI4u5HZxhnCh8YT8EqcsXoMb7r7pI=;
        b=rcpUKHyIwogZ74v+SW0XAcz9dVgG1o0gg+sG1qZpWuBwYV/SuvQXjvfqpg+U0kFwPO
         xfB1rTjzPCU266k0RFUoFDleqyXSKrRUeLJX+tZhjfzsxsJXE9MNXr49WZO9+yU3XEno
         qKMwUbrl0gYgn5wBRwQJqapA7wwPPEhgxyllu2qp5fUZsGGMmcDc1SpBdil1Hqn83lXE
         TyMzwM6Nki7gFf1rdqslTG5PF1XgsyDtQx9bU77fQ1Pz1RssqySKgdaIYbci8G0OEu9c
         jj5aGEkiIdu8Lteyev1+io3tgv9Bbd/PikZXTCrx4sdMU2+T9T6HEAARbao07as5zl2A
         iy3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DghCXD4NppA54luI4u5HZxhnCh8YT8EqcsXoMb7r7pI=;
        b=Zl4Oj/EVYrb7ZX9R2YM4jb4idL0hmWoNme3unwHH9Ty+j9q2sDh+9i6qf2SIiFmaVv
         7M2suBnvLydgcvttjeoBY+6L7IqjenDE6kOOQkFZicAP2kzmELJhIpsKJnlEDFM8usHR
         CNleGdnxe3r+Mk8tIP1c13/WmhOUtNKmsxTxOnaNPVsHRUS+3e6n3FRQRvp7i2SzWmf0
         mfWE+3pzc5U9FPc2MoVwiFKhcVzD17rqp1zgoVUExny3ZyXrv8gUwQOHrgLlgZf6/VTj
         rFw5bD6IzZbc8q/LyZTQvDgnA9EUyGlVVFLeT5m5Q0Ujd9E2btdkwzthr+d2O+Ix4YRI
         jxxw==
X-Gm-Message-State: AOAM533CcXgwJjdgF1x/gvKj97A75gewR0U5rTBJSAt6Wg6YO8wi3lHR
        CHw0xCShnaAnnb2/DTvOXazuhF11mxY=
X-Google-Smtp-Source: ABdhPJwsa78wu1RIAm2CGcCyrJU3hIpp/d2+mwgn2tgc/eVnmigLoImTdsS5fFGMWf2XaxIYzHX21Q==
X-Received: by 2002:a63:154d:: with SMTP id 13mr5469047pgv.116.1627593810838;
        Thu, 29 Jul 2021 14:23:30 -0700 (PDT)
Received: from [10.67.49.140] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g2sm4788459pfv.91.2021.07.29.14.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 14:23:30 -0700 (PDT)
Subject: Re: [PATCH] bcm63xx_enet: simplify the code in bcm_enet_open()
To:     Tang Bin <tangbin@cmss.chinamobile.com>, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20210729070627.23776-1-tangbin@cmss.chinamobile.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d5079143-00e3-75d3-cdb0-037c377c526e@gmail.com>
Date:   Thu, 29 Jul 2021 14:23:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729070627.23776-1-tangbin@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/21 12:06 AM, Tang Bin wrote:
> In the function bcm_enet_open(), 'ret = -ENOMEM' can be moved
> outside the judgement statement, so redundant assignments can
> be removed to simplify the code.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
