Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04194B89D7
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiBPN2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:28:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiBPN2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:28:06 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6F7151D3E;
        Wed, 16 Feb 2022 05:27:54 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id p7so2451142vsg.2;
        Wed, 16 Feb 2022 05:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W4NWQ4O/W36pB+bOALZ9wlT2YlOr6PG7OHv6tykJwH0=;
        b=lAHHTLBXwuKLLUHWaLseZjIP5cTvJsu69Q9thecmcZ3q0ffGHTCcOfDZJgQ+BsaU7X
         VJaGthSGbyLDnlUhzTNOirmBB5F7Qt2EEk+RrmOT7+T5WuR8cdDnJMknl0tWouNlGuVh
         9mhATRhNi19QIAqUZHBI9t2YXVYTD5EUoVudmzAEgZdEoVQTZuF+8xlDPDcIFRRwOn8g
         aUi/maLv8i6RYOy6i+1AX3tkKmgBfUDfKVKAYtOhjVYzCjYnN86wGxGPqUL7SqtqgDe1
         SUnNRDnQa+P+Bx++qp0oDSbhsRilT2mpDr7NtF0lcnwKAsJa1C4D94jqqd9Cy1g/0u0G
         Sy+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W4NWQ4O/W36pB+bOALZ9wlT2YlOr6PG7OHv6tykJwH0=;
        b=V2sejGUzsw+owRORLV0RcJtv+W8tZmQP0luzIB7ny4catcJ5jZgLqKjNXO0zosbK8Z
         K9hz4BZsoreztivnSTFi4YhG/x4c1v8caRdZnfqhVjsGDhWhAzmlCd6yyNrJBnIDbwkR
         Imoty/50X/c4hwfA0K1O9H/kMDCFCOkpV9DE0dik+zrT34d6Y2NGlsf6KtyW+E6F+uPW
         W6GF/AWvtnDxYgwOQmpdLhXuskmifoOEz29o+M0tO/nYXBSp7v9hFsIRKmR1d4QK9VGk
         L566R+wTVlfyXGayKgf7PDWb5WS99xR2sxWPmB7kYoFr5AuO1ZSdiCDwTntwzCYPw+Sm
         Q3Rw==
X-Gm-Message-State: AOAM533xgAr5V0CWj2R4dQOnW2i3tVFTg4nRvA+kG13wwux6+KwMFHJj
        qQytLTX6qLDlU+GCoyVOcQPzAZ2QFLAj8YMy6A==
X-Google-Smtp-Source: ABdhPJzJi19YNpCvzYwvosnnahkfB/aXCpYLA6aGj448BMw2ojTugtbCg0yk1f4Aj5s3nazDJ7Aob0vZmEcsqQKZVb8=
X-Received: by 2002:a05:6102:2912:b0:31a:5ab3:f44b with SMTP id
 cz18-20020a056102291200b0031a5ab3f44bmr1066907vsb.53.1645018073916; Wed, 16
 Feb 2022 05:27:53 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9rkDXbeNbe1uehoVONioy=pa8oBtJEW22Afbp=86A9SUQ@mail.gmail.com>
 <20220216113323.53332-1-Jason@zx2c4.com>
In-Reply-To: <20220216113323.53332-1-Jason@zx2c4.com>
From:   Rui Salvaterra <rsalvaterra@gmail.com>
Date:   Wed, 16 Feb 2022 13:27:42 +0000
Message-ID: <CALjTZvbS8OuDkAZ+3M9dwTzRd6Rd77dnd4nUdMhUA9BJgYWYEA@mail.gmail.com>
Subject: Re: [PATCH v3] ath9k: use hw_random API instead of directly dumping
 into random.c
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     miaoqing@codeaurora.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi again, Jason,

On Wed, 16 Feb 2022 at 11:33, Jason A. Donenfeld <Jason@zx2c4.com> wrote:

[snipped]

> Changes v2->v3:
> - Use msleep_interruptable like other hwrng drivers.
> - Give up after 110 tries.
> - Return -EIO after giving up like other hwrng drivers.
> - Use for loop for style nits.
> - Append serial number for driver in case of multiple cards.

[snipped]

Everything working as expected here, so this patch (v3) is also

Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>

Thanks,
Rui
