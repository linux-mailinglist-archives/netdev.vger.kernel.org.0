Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468146E04DA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 04:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjDMCtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 22:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjDMCta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 22:49:30 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E69C7281
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 19:49:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id c10-20020a17090abf0a00b0023d1bbd9f9eso16779863pjs.0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 19:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681354089; x=1683946089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVYZS/MTwEUQVxfIJEnf/pQlxKy7ugc8cnKofwa8MZI=;
        b=jUHMfbb6Mgu4tEysm4/TUrrJ+IFAAOcBu+C2idAc/OIg2HHXWdT591+d6UIg8j0UVu
         KG9JXAKF01oF0ZZIFx3/1uONKEAmW4RAbjyclvIOVVX1NaqVvIJXcFUhJWPu9rgZwKoF
         ob9pspBji3WoZrQEc2B/QomWoE3DE2n+mbbieZFNzmVVctVEoy/K8Q08KZ+fJghClHfT
         6BkPTQokjWJdTRJoPAPiMQVaRSny8Dj8ua/DgB+sjuIlKogUikqBz6VlgkGVQ0Sx8ZbF
         ZDhmZNqHw0LgJU62JobDWASBN/MjA+l95AsVepLGvknAqg4mCsmqaW+YJFooJiDucR0y
         0xOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681354089; x=1683946089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVYZS/MTwEUQVxfIJEnf/pQlxKy7ugc8cnKofwa8MZI=;
        b=gsOtOO/KI43QEsDuVqHYwm2fpJRJgs8IAP4LMJAw/BEKliRG2SDovDbHNaT2o6/BMG
         UGz1xZ3hxhjrENLpxlaieMTDVvSSQS8IqmSiBCNAcYfk99UNXilrVbAAhn3xtNuPdArN
         hTgV6Vj6PpBliluyvqoA0V5ZiyW0CRuYG8+MjfbsJpfp6Zr+UILgJ+iO/Siw+fZ0ZTCf
         Xi9Z4C6UZDD9yGZxUaC0gRfPIWDfOY03Dhziv3rfD/4SXPPZw8v7l4z2uKc+Zzz94dvo
         Vq4fTwfpNzFavAe+TK+NfwS9+98XYpPumHbFTBnFla0CqLXPEJlhqZhWqkWNhkKP6hkz
         q41Q==
X-Gm-Message-State: AAQBX9ezn8ncrr3lQOz+ZdSMPhG2P9J4OQbs/Fzf1xUznP7qu6N5OT2A
        czbUMCe016SlQLQ00U+BV6nT6juMjAe/jw==
X-Google-Smtp-Source: AKy350aFZYnbTt196T+hP+Bs7bJoXf5A+68VyMEQXrh98emLqGyz1flWRMrfcw9MIdSfqgbzxiq3PA==
X-Received: by 2002:a17:90a:f612:b0:23f:5c60:67b with SMTP id bw18-20020a17090af61200b0023f5c60067bmr348073pjb.5.1681354089574;
        Wed, 12 Apr 2023 19:48:09 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:7826:7100:99c4:7575:f7e2:a105])
        by smtp.gmail.com with ESMTPSA id gi1-20020a17090b110100b00246ba2b48f3sm4941324pjb.3.2023.04.12.19.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 19:48:08 -0700 (PDT)
Date:   Thu, 13 Apr 2023 10:48:03 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin Willi <martin@strongswan.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] rtnetlink: Restore RTM_NEW/DELLINK notification
 behavior
Message-ID: <ZDdtY7gx95SRPhNu@Laptop-X1>
References: <20230411074319.24133-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411074319.24133-1-martin@strongswan.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 09:43:19AM +0200, Martin Willi wrote:
> The commits referenced below allows userspace to use the NLM_F_ECHO flag
> for RTM_NEW/DELLINK operations to receive unicast notifications for the
> affected link. Prior to these changes, applications may have relied on
> multicast notifications to learn the same information without specifying
> the NLM_F_ECHO flag.
> 
> For such applications, the mentioned commits changed the behavior for
> requests not using NLM_F_ECHO. Multicast notifications are still received,
> but now use the portid of the requester and the sequence number of the
> request instead of zero values used previously. For the application, this
> message may be unexpected and likely handled as a response to the
> NLM_F_ACKed request, especially if it uses the same socket to handle
> requests and notifications.
> 
> To fix existing applications relying on the old notification behavior,
> set the portid and sequence number in the notification only if the
> request included the NLM_F_ECHO flag. This restores the old behavior
> for applications not using it, but allows unicasted notifications for
> others.
> 
> Fixes: f3a63cce1b4f ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link")
> Fixes: d88e136cab37 ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create")
> Signed-off-by: Martin Willi <martin@strongswan.org>

Acked-by: Hangbin Liu <liuhangbin@gmail.com>
