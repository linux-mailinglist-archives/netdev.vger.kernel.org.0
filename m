Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B633644F98
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiLFX3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiLFX3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:29:17 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AC742F45
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:29:16 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id g10so15439236plo.11
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 15:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WmgrCnASburr+5cVUc5KG8Caw9/9YKt8WG6bY9poME4=;
        b=mFGx+LYiH6kZQoSl47u8lZUfR3k8CUegLiAIDtIhHVd2wupq9H4/muVoS/1sNw7WjB
         Kxbz1EbFOMugNDfbTyzuZMHMJenJUk+rQVOBvM9bUCHQz1eyzEKP+pDOQEASSQkGYv0S
         xhkkIJgsQQwJZ6WGZxN7r9WABhzhIAfi3HV+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmgrCnASburr+5cVUc5KG8Caw9/9YKt8WG6bY9poME4=;
        b=yFK4OK2IDWq1Cg4uEnkBNn5Z/bCRm4xBwb5VGX9QZkdhmDBy2us7ViEkuk/MHXAWOK
         0qXVzszA+AsuFdrRFdC1Cf+IYjvL2mO9AH/I3ysC0rkHLuuB7aIETfnRZtUe3C0kntO6
         S+y/jZscBr0HJZOIL6vbxqlZiQc5vW7LH/qpiI9UboFE1TT9A2A03V6FPO1hZiPvQg6y
         oQTK9kbW2XS/NfMTJpzUA5rby6z+OWYsZXmvA2ylRi1uKBXwcnO5Oh7P1INpd5wcbDfS
         vKIZfP4SH5giBEE+Y9JNvTb4W/ZlHwVSr1XIemXgp3y6TDvG+B58UF4OYabkze3qAG0t
         XHWA==
X-Gm-Message-State: ANoB5pnJs8bb2BY8jd14qQV5MKahGw5p0FSZZUoB6HrpVHqTmPLiqk26
        BS77laeK3wrm1Ag2yQ7EU29ggA==
X-Google-Smtp-Source: AA0mqf4kdBuDZu72vaVsTfeJJjSuey29Eib09n2LG87hJibFKu13Kt1VzaGrQ1hrhSf1O+2Hm0uXRw==
X-Received: by 2002:a17:902:caca:b0:189:af2a:1d08 with SMTP id y10-20020a170902caca00b00189af2a1d08mr30309895pld.98.1670369355954;
        Tue, 06 Dec 2022 15:29:15 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y189-20020a6232c6000000b0056b2e70c2f5sm12209798pfy.25.2022.12.06.15.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 15:29:15 -0800 (PST)
Date:   Tue, 6 Dec 2022 15:29:14 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Joel Stanley <joel@jms.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net/ncsi: Silence runtime memcpy() false positive warning
Message-ID: <202212061528.EEA3557C@keescook>
References: <20221202212418.never.837-kees@kernel.org>
 <abd1a8e98d8b6d19520ae41d164ee905a40b3c42.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abd1a8e98d8b6d19520ae41d164ee905a40b3c42.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 11:36:54AM +0100, Paolo Abeni wrote:
> Hello,
> 
> On Fri, 2022-12-02 at 13:24 -0800, Kees Cook wrote:
> > The memcpy() in ncsi_cmd_handler_oem deserializes nca->data into a
> > flexible array structure that overlapping with non-flex-array members
> > (mfr_id) intentionally. Since the mem_to_flex() API is not finished,
> > temporarily silence this warning, since it is a false positive, using
> > unsafe_memcpy().
> > 
> > Reported-by: Joel Stanley <joel@jms.id.au>
> > Link: https://lore.kernel.org/netdev/CACPK8Xdfi=OJKP0x0D1w87fQeFZ4A2DP2qzGCRcuVbpU-9=4sQ@mail.gmail.com/
> > Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Is this for the -net or the -net-next tree? It applies to both...
> 
> It you are targetting the -net tree, I think it would be nicer adding a
> suitable Fixes tag.

-net-next (v6.2) is fine -- this is where the warning manifests.

-Kees

-- 
Kees Cook
