Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5384F607015
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 08:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiJUG3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 02:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiJUG3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 02:29:49 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B70233A16
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 23:29:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so1914586pjl.3
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 23:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J9+J6TqrdKWyEehYJ+qdJ0CcFt5kjpQ3w0dEpwrcqY8=;
        b=L8ssRtfV5+sajE8elPTNScgQ4lMfFw7XKX3/AqEQ7zWowZa96JS0xxGpo8RnXsbPq5
         su4eGCK5F9IeIpd+vZ4KewntSpLbos6s8o1itU7VZ6Ye2anf6J+Fz6Ncjxma2IpWSzvX
         DE3wHjvUBF7KKCBLf/GeocnUQwqc/EWzwC/MRNfHjkm5Mb+z9ienzrU2FBLGtQGgw5as
         eEvuJ5+4mMgZSRW1qpAbo806djvvWMpHaglXZdSHglhPTdnXQT6j2UYcbP38kEkj6FFW
         sHyZcUgasBoBHDHv0U4t5z6ls8ldhE2/MmEbK6SV7AMiitUpXJsI/lK+Y47iquKrLPiX
         pSqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J9+J6TqrdKWyEehYJ+qdJ0CcFt5kjpQ3w0dEpwrcqY8=;
        b=tB5SkY43JSLKuDT8vJbLG7kSc81UApr11pn7a3koaEyUF931dX/T9nxghKpo2Lv6PE
         xYAuOV5dhToKznflyHGYeMZpxDJaemqrmZGZktiRXGMEN9VBdpScMADWasIsPYhtZ1/S
         vqMJVFMSHw3l/AWO2hiKGRgEXlOFUwM4FowQiwAouStBbWAZsFhUQX83j33X6k9sobew
         68uIo9NgUji1C/2VsJSVmc570uPhc59dda8fI78gheL6taRyU7bEHH8aZpEX5TrGyXiF
         ikdt7aSDsI6mSY91vsAIvzenRgyYrHs78tRz2jppRnueiQEXAAEY1sdusr6x4C1kwO5b
         tChw==
X-Gm-Message-State: ACrzQf3xrC77sdz4zxdLCyZMvBdNVLVphkdlLbzQNn/Jp8IzV/CSICBp
        MG2qiITpdDsPnInq4A152Zqz98956YYX1hN2aOaBP+ugzTy7KA==
X-Google-Smtp-Source: AMsMyM54xkuApdOHNIV8jK3DePhSeSPMszD4H88khXfs9fI5LB1JUXAOXU61bWpw//W0TlUfGpN1U12YzlBKhVuCWxs=
X-Received: by 2002:a17:90a:7a85:b0:20d:2891:15f with SMTP id
 q5-20020a17090a7a8500b0020d2891015fmr20836174pjf.107.1666333786548; Thu, 20
 Oct 2022 23:29:46 -0700 (PDT)
MIME-Version: 1.0
From:   "J.J. Mars" <mars14850@gmail.com>
Date:   Fri, 21 Oct 2022 14:29:26 +0800
Message-ID: <CAHUXu_WyYzuTOiz75VfhST6nL3gm0B49dDMjgkzEQ0m_h4Rh1g@mail.gmail.com>
Subject: Confused about ip_summed member in sk_buff
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone, I'm new here and I hope this mail won't disturb you :)

Recently I was working with something about ip_summed, and I'm really
confused about the question what does ip_summed exactly mean?
This member is defined with comment Driver fed us an IP checksum'. So
I guess it's about IP/L3 checksum status.
But the possible value of ip_summed like CHECKSUM_UNNECESSARY is about L4.

What confused me a lot is ip_summed seems to tell us the checksum of
IP/L3 layer is available from its name.
But it seems to tell us the checksum status of L4 layer from its value.

Besides, in ip_rcv() it seems the ip_summed is not used before
calculating the checksum of IP header.

So does ip_summed indicate the status of L3 checksum status or L4
checksum status?
If L4, why is it named like that?

Best regards, Mars
