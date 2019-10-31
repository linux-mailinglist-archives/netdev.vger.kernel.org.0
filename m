Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFED0EB8CF
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbfJaVQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:16:56 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40047 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbfJaVQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:16:55 -0400
Received: by mail-lj1-f193.google.com with SMTP id q2so1601512ljg.7
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 14:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bqOg5+zD8Qpj1h7Ic7EcL5kmHzAI7gRipZPMSEC5V7Q=;
        b=Z2fAm/dK3ZxXj0TZOs0SS3npbKPsleVuDrlV7Ep2VbXhRuVZ3qJUeVp1b1XyBF3E0B
         EQZtrvQiA6QquqYSckLTE6s/viHWAxzWDglPKVAqPI4VpmSVCdg7Ag1QNUwGQN/vJpTg
         GfwYXIfCFriIhcvBlkPebYsMnJVJQ7Y1WHNzaTx3iT4YHjAZX4iCvzOpVXBelUoD5WEY
         SNqYibKijmtM6W2QzbYCBZStw8Bxe3HpFD0OnU+M26De7KuIb/bcSPuZCnM4Tp/W+uBV
         YTSkNrKcQHQBfaek7SdmPoAzDyRuV4EIFGzuvQdnDaKWm7Ybwmo0DGai/zKO2JJDIMSl
         YVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bqOg5+zD8Qpj1h7Ic7EcL5kmHzAI7gRipZPMSEC5V7Q=;
        b=beHqUfsO7sk7+hXtRAZoBNLW7LGRs5VpA2PN0+WB+rLlnbDC9/WFlNzaTNQoYaDZ4/
         twY6bAVHvjHDK2C+M3IUaCHn8HcANa1Ghdk3PpVvPUdA6+2cjGQQAIH1Z77SN5H4wc59
         wQ+Ha/UYPzP5QtBLQ4wYDWl3JqX1b3uOm7umXB4X7wH8VTjMiE30NWZIqyTFaMLSdGx9
         tQaqoccqLlopv3C1eGF7tIfM2aBnnbuS8X475uaf3+mj7DdqHYEj3axlpBrWTqFe1uc4
         0yWwNegPIObyjfZzArk0HsFbCSKxvO4FQ7pP8h7uk+02AZg1+Io0roBDHMXf2pn2uVKd
         +xzQ==
X-Gm-Message-State: APjAAAUQFuMHz2ikmimWRbF5nc864VJ9CJXi+6mhuvnFnFyj29JoWO8B
        bQF47KhMM1+SvkrmTygjYmfQHw==
X-Google-Smtp-Source: APXvYqyKiWVFriT0CLGCLpVNooib4zSSMSTW/0s46B8dmS+Q1SohSANXo7k+00COIHWBG9zZcfC7Ew==
X-Received: by 2002:a2e:84c9:: with SMTP id q9mr5348786ljh.163.1572556613828;
        Thu, 31 Oct 2019 14:16:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 4sm1707585ljv.87.2019.10.31.14.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 14:16:53 -0700 (PDT)
Date:   Thu, 31 Oct 2019 14:16:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Message-ID: <20191031141644.232af7ed@cakuba.netronome.com>
In-Reply-To: <20191030160542.30295-1-jakub.kicinski@netronome.com>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 09:05:42 -0700, Jakub Kicinski wrote:
> sk_msg_trim() tries to only update curr pointer if it falls into
> the trimmed region. The logic, however, does not take into the
> account pointer wrapping that sk_msg_iter_var_prev() does.
> This means that when the message was trimmed completely, the new
> curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> neither smaller than any other value, nor would it actually be
> correct.
> 
> Special case the trimming to 0 length a little bit.
> 
> This bug caused the TLS code to not copy all of the message, if
> zero copy filled in fewer sg entries than memcopy would need.
> 
> Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> 
> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
> Daniel, John, does this look okay?
> 
> CC: Eric Biggers <ebiggers@kernel.org>
> CC: herbert@gondor.apana.org.au
> CC: glider@google.com
> CC: linux-crypto@vger.kernel.org
> 
>  net/core/skmsg.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Daniel, John does this patch look reasonable? I must admit 
the skmsg stuff in TLS scares me, it'd appreciate an ack.
