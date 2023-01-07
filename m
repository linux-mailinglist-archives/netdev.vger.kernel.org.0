Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4E1660E4A
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 12:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjAGLiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 06:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAGLiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 06:38:03 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED4D73E00;
        Sat,  7 Jan 2023 03:38:03 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id i9so5647008edj.4;
        Sat, 07 Jan 2023 03:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+wBZl9MGa+gTBo4RGLnIuXFowVF6lF6Hijf8mQXG/oU=;
        b=iLcsHISA6cTPW9hBpl3fB6RIotLN8TD6sxYYdgNEq5ZyMq9e0xq6IxluiCIa5TmnM9
         XCXHt6LyLfoTArfMy/u+MwCeibaV+NGzzsbYQq5FNbEYI7kLyVhQ/CFxlzuu/aW0JbgQ
         JYj4JwRe2wAOv5elh/NIJuXcQJHfMIoL5hKLJcskkmWAlYZ3HqU7u2CZeF4qgf1zynfS
         hsEDRNq/Z9oykbGI9nHSwx921bFAfCYON1XRW/JxlCiw4It06rfMUQAgG99lpAsM5N0z
         rngWLxmJOxdVyLDK/2TLgFjaps1qigjeBpCbV7tcJMKlRCmSTlyQ65BpnhD1NL1uJI22
         nI/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wBZl9MGa+gTBo4RGLnIuXFowVF6lF6Hijf8mQXG/oU=;
        b=5ncrggEd5yyOb3j60rEglAmdM71WVCHsdMkDB4wffWhmgcvr884CC2ksso/IMStc9I
         hINZi0SmUdbcxJ2Z9wJeei+FslJUPtkutedNCHxXs2cp/NpQfI1sKMtzJd4nKy0z4zse
         kIcR7PkkN+01PATeeURZv03QFr2jld5Zx7zugRedJqfjb09F9pvni0OKudDYiGfAxkC/
         CJZnbX+P8bPrh5tga7tR8J8oD/u3mhqFJp+cM5qInXhFGuNbrD2TiTRUpaeKxJ8Ki9rD
         Uf0XnPiSw9piuqU59Zg4XLt7QDv5Fa4gEcVFP1CUxGPnGm3U7khCYkGEuIQTPYljxI3+
         QOEA==
X-Gm-Message-State: AFqh2krfYHXXhFw58+NJI2Hd7C5tgGU53/AWcbfszhB4LjDcH0hD9IdR
        /IIY5iG8jcR0exKfGURn7FvKjbGpD9Q=
X-Google-Smtp-Source: AMrXdXsOVTds73GZ4L4F/mg8c5FgUFzGp5l4A1N8DL5Uke8dz+ZojkgzxcVq5ZLZeLspmL70h+kx8g==
X-Received: by 2002:aa7:d984:0:b0:496:9d0f:3081 with SMTP id u4-20020aa7d984000000b004969d0f3081mr4434720eds.3.1673091481485;
        Sat, 07 Jan 2023 03:38:01 -0800 (PST)
Received: from skbuf ([188.27.185.42])
        by smtp.gmail.com with ESMTPSA id u9-20020aa7d889000000b00457b5ba968csm1408070edq.27.2023.01.07.03.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 03:38:01 -0800 (PST)
Date:   Sat, 7 Jan 2023 13:37:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20230107113758.6t4eqsaceveh5y4d@skbuf>
References: <20230106160529.1668452-1-netdev@kapio-technology.com>
 <20230106160529.1668452-4-netdev@kapio-technology.com>
 <20230106164112.qwpqszvrmb5uv437@skbuf>
 <6abb27f946d39602bd05cdcbea21766c@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6abb27f946d39602bd05cdcbea21766c@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 11:32:06AM +0100, netdev@kapio-technology.com wrote:
> I presume that since I move the exit tag 'out' to this patch, it has changed
> and the review tag is reset?

You can keep the tag.
