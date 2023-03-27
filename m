Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B127C6C9D59
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbjC0IOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjC0IOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:14:11 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7CF40CD;
        Mon, 27 Mar 2023 01:14:07 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id d11-20020a05600c3acb00b003ef6e6754c5so1270694wms.5;
        Mon, 27 Mar 2023 01:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679904845;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qUMg8u3fYkxxNNqq3JGdpb2eRGzVPcLLm8VE266HQfg=;
        b=kdpKr5qETjbzmKKRrCGSbz3+TE8TX7fazWI90/imT0PL7XCtOAUdYrhiFqjSYXXyGE
         wq193TYkRUPbBRLb4Zps/X2+WNcZbcWZe8UUUDT7c1aAWvqgJpYsbvGhbyfquab51zlD
         JH1FupvWq49p6fBvslPQHL2b4vo7HvkArwmdl4kinOdYMIOenuP3UePFOZGCnmxY2/F3
         UNI8wq6EmdArcZ0FawhXprt4Xr5hNLfJ7l3AIaSG0moumABcDr2kBPDuBVE9J5ZHejPi
         v5Kze4aOPCDPHmwzSMiTnTDp8/0npTd75YUZMXzt9UHXTyBYZeIFrpCLgCfoEbmTtL9x
         Hkyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679904845;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUMg8u3fYkxxNNqq3JGdpb2eRGzVPcLLm8VE266HQfg=;
        b=ADEgMXR79IiBQ3ByLnyxsDCEjRpAMVlrHbv3udp6ZzyJW9tFFIdk2639bPtgqneqCx
         Uv/fNVFfy5wAvsJPp6cJAs9XKSaq33PHVpge1ReFDgqq+ohMSLnez1Kx7sAVF6tPyUmI
         VyefFN9k6IasR4V/hLxDLNr2vCts/z6NLcXmjBjI4fte7cwHkZQybKfQlkDsInwrwp+U
         zEsTnCf5AJ1Ize/rLmgIcpA5FPFE8B7WvqjNJBE0m59gPlFp4LLstDKnDbt+bc5QlGjQ
         vqOL4/zz6vOCS/ZVlzo3sEGdRar9ixIqrFU4huoPXED1XXRwEDTfrlgBHMY+M3xhP6/0
         09JA==
X-Gm-Message-State: AO0yUKVgnm650pKC4osQMurlhyC0MCtYWHNFSlG6VUr+4n2dMoFfpY1E
        Yr2bWNQpT2GAro3+MdvVbGdN8LxIwmogRw==
X-Google-Smtp-Source: AK7set8XcOe1WbYGfNPTVqeKPxulz8CTgutu/4O+MumO9oRmqHOzrUk/sKhmst9JL351hKkNrTjzaQ==
X-Received: by 2002:a05:600c:2304:b0:3eb:f5a2:2d67 with SMTP id 4-20020a05600c230400b003ebf5a22d67mr8502142wmo.33.1679904845439;
        Mon, 27 Mar 2023 01:14:05 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id s12-20020a1cf20c000000b003ed1f111fdesm12703309wmc.20.2023.03.27.01.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:14:04 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 2/7] tools: ynl: Add C array attribute
 decoding to ynl
In-Reply-To: <20230324203837.1e12be44@kernel.org> (Jakub Kicinski's message of
        "Fri, 24 Mar 2023 20:38:37 -0700")
Date:   Mon, 27 Mar 2023 08:57:42 +0100
Message-ID: <m2edpaiq2x.fsf@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
        <20230324191900.21828-3-donald.hunter@gmail.com>
        <20230324203837.1e12be44@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 24 Mar 2023 19:18:55 +0000 Donald Hunter wrote:
>> Add support for decoding C arrays from binay blobs in genetlink-legacy
>> messages.
>> 
>> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
>
> If Stan's byte-order support gets in first consider supporting
> byte-order in arrays as well:
> https://lore.kernel.org/r/20230324225656.3999785-2-sdf@google.com/

Ack. I'll watch for it. 

>
> Otherwise LGTM:
>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
