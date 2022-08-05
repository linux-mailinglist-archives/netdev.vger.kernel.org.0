Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFAC58A511
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 05:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiHEDhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 23:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiHEDhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 23:37:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276DE402CA;
        Thu,  4 Aug 2022 20:37:31 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 73so1601398pgb.9;
        Thu, 04 Aug 2022 20:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=7gYv8IMV91W9y/lcsTiz87dVJJBW1JRelvY6T6GX6L4=;
        b=hENNQgpKrEI+hW7pjDNc0ybLrgcN8NHOupZ3nHmLpaYslXr8fcCw0XCSTqh+UOFnhy
         kEePYoiQUvwfECIrstCMZOW8+XdEO1Q31IV2QlbEIBXinOPofYtEMVFBWjG2zAy4szOu
         ieY7jsue3JUMuJeUMIAc1x6xkBydZKUqQCbZ8OPtZ9o4Dvdq95QOZEjs/LKDb7JTt7+o
         8pxCxO6hU0e/Sj1B4hwXOSzBFIGlA0SWg66xQ9r3axVeEB3xxPDyvNPbDRxRLVmNf5S1
         xIfpBWgffeFHgMzUsb15UF7Vy+RbqIzMljY4PaWuj6ndS+ac94r6ZKgtyTxKxu/D67Ng
         9ZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7gYv8IMV91W9y/lcsTiz87dVJJBW1JRelvY6T6GX6L4=;
        b=Nq+2Aiu2/X1QZrRJBaskrIP+9rGdw+mD7FML+An/YXBULHK3Yu9cQbSsVYLQ48xbfx
         2mgkSeuct08ja5Pml6HVDq7Av4ewLeSgogIQv8fV8vCcXiRQ1vbtCDw8/7YaRWjLJg+Y
         yNTLPV6UltSBTtROfCbP0o47sIxkcbdBHVv+z4jLrbOupSVG6W95NpIlzdpD0/wx34Vu
         hBwN1hMa/CYjPAZ2GdOHDjplPfavW2i0kQq/gg8j2iGTAGD3hucWNOPgEwzlyQyeBmNJ
         o9hE65C8dG/GQOMA5TuWYxkMOvVKgkvS2pCyB+b6VyHYeC6Bd3wAoWNZxeaQZytC5oOQ
         lVeQ==
X-Gm-Message-State: ACgBeo1jNB1N/ypYhpYqbooVT30XOht1nfSEvEFXVPQZdHmQO5Iwiwvk
        gYfJNkFZeQ3aQCk5heuvzxQ=
X-Google-Smtp-Source: AA6agR5+I9peXzqIMLZOPVwpQwXGqZExtS4C/K3Vc0d6mhzL5s/asNcYSS4pW+Lwfz7Hm7uCMPctdA==
X-Received: by 2002:a05:6a00:2195:b0:52e:6157:904d with SMTP id h21-20020a056a00219500b0052e6157904dmr4900948pfi.44.1659670650557;
        Thu, 04 Aug 2022 20:37:30 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-92.three.co.id. [180.214.233.92])
        by smtp.gmail.com with ESMTPSA id e15-20020a170902784f00b0016c59b38254sm1753982pln.127.2022.08.04.20.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 20:37:30 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id C9CF2103824; Fri,  5 Aug 2022 10:37:26 +0700 (WIB)
Date:   Fri, 5 Aug 2022 10:37:26 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Adel Abouchaev <adel.abushaev@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC net-next 0/6] net: support QUIC crypto
Message-ID: <YuyQdjEu01sxZA5e@debian.me>
References: <adel.abushaev@gmail.com>
 <20220801195228.723273-1-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220801195228.723273-1-adel.abushaev@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 12:52:22PM -0700, Adel Abouchaev wrote:
> QUIC requires end to end encryption of the data. The application usually
> prepares the data in clear text, encrypts and calls send() which implies
> multiple copies of the data before the packets hit the networking stack.
> Similar to kTLS, QUIC kernel offload of cryptography reduces the memory
> pressure by reducing the number of copies.
> 
> The scope of kernel support is limited to the symmetric cryptography,
> leaving the handshake to the user space library. For QUIC in particular,
> the application packets that require symmetric cryptography are the 1RTT
> packets with short headers. Kernel will encrypt the application packets
> on transmission and decrypt on receive. This series implements Tx only,
> because in QUIC server applications Tx outweighs Rx by orders of
> magnitude.
> 
> Supporting the combination of QUIC and GSO requires the application to
> correctly place the data and the kernel to correctly slice it. The
> encryption process appends an arbitrary number of bytes (tag) to the end
> of the message to authenticate it. The GSO value should include this
> overhead, the offload would then subtract the tag size to parse the
> input on Tx before chunking and encrypting it.
> 
> With the kernel cryptography, the buffer copy operation is conjoined
> with the encryption operation. The memory bandwidth is reduced by 5-8%.
> When devices supporting QUIC encryption in hardware come to the market,
> we will be able to free further 7% of CPU utilization which is used
> today for crypto operations.
> 

Hi,

I can't apply this series on top of current net-next. On what commit on
net-next this series is based?

-- 
An old man doll... just what I always wanted! - Clara
