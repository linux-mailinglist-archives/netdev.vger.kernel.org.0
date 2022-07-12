Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0596B571523
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiGLIyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiGLIxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:53:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61025BC9F
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657616028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RmeJ6RmARqcusrrBXrqjwb/ys+w6/1G/zq4xruuGus8=;
        b=PBt4PNk9uvbnggZid5hlr5H366oPHHvmNlNa78kTdEKBS+zXDzkOhHK/tWcmYDoLQI8Gdo
        rOfjWDXRqj0UQoX94rZOpj9qELV1oxoDmSYfmcmC5WLVm1aFjToz8Fo0Pq8WN2fXlMIn19
        +d+fuJnSEP+dGhko1BBBH66/yF8wSE8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-XJel-lVTNdysC7mLsb9vMQ-1; Tue, 12 Jul 2022 04:53:40 -0400
X-MC-Unique: XJel-lVTNdysC7mLsb9vMQ-1
Received: by mail-wm1-f72.google.com with SMTP id z11-20020a05600c0a0b00b003a043991610so3496454wmp.8
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=RmeJ6RmARqcusrrBXrqjwb/ys+w6/1G/zq4xruuGus8=;
        b=VJvqvcMWraksDpA9VIPSNaZUnnch2PEc9O1GLkUW3sBfq48co6VfSjiu/YKj1BeZGT
         s/P1cuxJts2iUqUaOj+NDAamSVud8kaUdc1U+puvjSng/KQOzzsS/4eR2/sRAkiJhcNW
         M3E0Izjw4bcPGfZ5hb1+21piInJfd2PJ9eY6mnPDcsi1zamLDMVA4A0Q5qo5qKI8++v7
         ASPeRKaGN9HltwoQCr6k/6wWUmJU1jmXwM++15JvLqjctCECCNMgeG/QUD7WIni60ZiF
         tTl4RriqyMVzJWzDkBwEo90ZjRsi83LveUtdwvRgoDibEx92qAqHFzYIS4a3si+s4VVT
         RQHg==
X-Gm-Message-State: AJIora+rzqOlo+0zZW4Lurxc8y5Ncqj3gOhYzqp901DDof4Cg/xie61W
        heRK3xAq15zVv21rRQeWciFkwKZg2qpATTMM2mtrxvQQSrsC/JNOZ4FXfeNw7fN3cka0rPyK9YQ
        6SK3yLp44wVfiq9Ws
X-Received: by 2002:a1c:7405:0:b0:3a2:de4f:5f07 with SMTP id p5-20020a1c7405000000b003a2de4f5f07mr2672206wmc.117.1657616019632;
        Tue, 12 Jul 2022 01:53:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uBJyDBdCq4BU2UYl/sm6riUe34hWHWNq8fkge3ucla3eazkCaf2M1EbHEU+e8PnYVKtaokaQ==
X-Received: by 2002:a1c:7405:0:b0:3a2:de4f:5f07 with SMTP id p5-20020a1c7405000000b003a2de4f5f07mr2672192wmc.117.1657616019423;
        Tue, 12 Jul 2022 01:53:39 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id h6-20020a05600c2ca600b0039c63f4bce0sm12385692wmc.12.2022.07.12.01.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 01:53:39 -0700 (PDT)
Message-ID: <fbb2e0580c0ac108db8ee47b4342c4981f4d66b1.camel@redhat.com>
Subject: Re: [patch net-next v3/repost 0/3] net: devlink: devl_* cosmetic
 fixes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, moshe@nvidia.com
Date:   Tue, 12 Jul 2022 10:53:38 +0200
In-Reply-To: <Ysw0XA2NC3cGxWIY@nanopsycho>
References: <20220711132607.2654337-1-jiri@resnulli.us>
         <Ysw0XA2NC3cGxWIY@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-07-11 at 16:31 +0200, Jiri Pirko wrote:
> Jakub, this will probably conflict with Saeeds PR. Let me know and I
> will rebase. Thanks!

Indeed there are some conflicts. Could you please rebase? 

Thanks!

Paolo

