Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37116C1E54
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbjCTRlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjCTRlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:41:17 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C35B25E30
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:37:21 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s19so1747386pgi.0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679333824;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eBEJmQcAfRMgWWbg0MAXbMLQFaCo4Fv9FkMu/CgrZ9g=;
        b=k/mT0jG/hdXi0nLxwoHQHJGaNkzt1dLtlWgU3UWhDXJStU9rNR6OQMhlwyo5JMGOmh
         +LdSnJQAD9uvN9Ra/QAwBWKe3jIkRPX3aFbgyfE552chBKhtIU0gLL70XOcZi+t01iv+
         /qRmBvrzXjNZE8/03akIEwIMivp8elINcw2mg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679333824;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eBEJmQcAfRMgWWbg0MAXbMLQFaCo4Fv9FkMu/CgrZ9g=;
        b=kZ+84gKhe7wpTXhNJvkeDx/ny/f1JfCxng950+Y+TXgnTitaT0lUuyhj889XmmtaUR
         DGel0qi5yxawnQ6/KTMhEyy+oSXQtHi6L1tSUyq6lAhbocs0EKM7BUjqit9lzYU5FW2e
         QRtkIyS+tm8vN/j1U95YXR2BH2pyUGIQxHM3gLAChGAsD7WDcJsHAPhD6PGqpvJGZhi5
         2Zi25duUhBraIZN+xUVeoIUs1t++r06pfzU3w86K6CUF4XH7c0rkNYLgXYuHVAYlDmw7
         mRiTB1P6pIphVgIxGObi9eU+wBN299FQb5gc+42Q6o0th9Fc+X2rTMPu8ZTl8u1sfhXq
         bAqg==
X-Gm-Message-State: AO0yUKUsGwXWjbLez8f4N1aX2Wv/nSF08Ihjul8fzJjbWUeUyxP7iFBq
        QzgfBuYqIk97Q8xDmAPN6h7S6g==
X-Google-Smtp-Source: AK7set/lME1Yhs8Ou5sAKMPNnQ/nln8xDaE/as/0aPzRsy0g8zcqvOHKwpG4+XHr69j41AqKu8uSdA==
X-Received: by 2002:aa7:9593:0:b0:627:fd63:c4c7 with SMTP id z19-20020aa79593000000b00627fd63c4c7mr3437173pfj.7.1679333824250;
        Mon, 20 Mar 2023 10:37:04 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id t2-20020a62ea02000000b0058dbd7a5e0esm6581944pfh.89.2023.03.20.10.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 10:37:03 -0700 (PDT)
Message-ID: <641899bf.620a0220.b49ce.aea9@mx.google.com>
X-Google-Original-Message-ID: <202303201037.@keescook>
Date:   Mon, 20 Mar 2023 10:37:03 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] carl9170: Fix multiple -Warray-bounds warnings
References: <ZBSjx236+BTiRByf@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBSjx236+BTiRByf@work>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 11:30:47AM -0600, Gustavo A. R. Silva wrote:
> GCC (and Clang)[1] does not like having a partially allocated object,
> since it cannot reason about it for bounds checking. Instead, fully
> allocate struct carl9170_cmd.
> 
> Fix the following warnings Seen under GCC 13:
> drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[4]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:126:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[4]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:126:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:161:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:162:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:163:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:164:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:126:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:220:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds=]
> 
> Link: https://github.com/KSPP/linux/issues/268
> Link: godbolt.org/z/KP97sxh3T [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
