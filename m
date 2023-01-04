Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E81465DADC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbjADQ6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240193AbjADQ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:58:09 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62941B1CE
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 08:56:42 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id ay2-20020a05600c1e0200b003d22e3e796dso27021863wmb.0
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 08:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Tj898HMfcnTLKvr7EFRRyMdmQUuattC6aSz501z5cI=;
        b=wO+juel1DoJzzEy8c1KykH3jVmYxYQg2nPQxdc4p6NADAbbGzYbQVLz6UZhsceuX8X
         D2+mjfyWMy9/CgX70E1EJ/s0S5c6WDN+9HSkquoLwS+6clJrlLvFmGdEmHGxMWRu9eRw
         GF1YsVTMaRuVfoh9QU+3SIhEPS1+kjMAz/fZvSw3C2pSELWx8+udNQlrtQZG5sWpKndE
         cHxBp2A7pzLxgAjm1eQ9qpXvym90oaIL23u1+j/DWn3kyLBodvjHeSSkLpVI+WSr8EOL
         j9Km1bFglJgT2fyajFHL6FvqwzdN2DbE71DLRuTTWx/xY2SH9juv/3QG7TJjoqiopjkF
         6L+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Tj898HMfcnTLKvr7EFRRyMdmQUuattC6aSz501z5cI=;
        b=Njb6uWr8RiJNmKAf3kFod0MibnP2KXJB+P2S78hvpwprZMSxMHFZD4Nc/2WM+EiWCT
         rcMbStmUhGMgpd1pL1riBmSfApOaYyOPL3yOonQQYKEqL9oiKfdS8n4JIRbM01YoHnK4
         NiywI4a5d6vu/gzz+SeGPaioxYVpXztUXr60hC8wd+xyzLEi5E6aMw8xnJPWRRj4cgY8
         U2VySo7YYpjvVex+uYluMZ3NnCHME8FGEYGpdSIM0upRxVeFwfDidJgJuc7NX80pXzjb
         +UvKgtnApEKz0hesy9AyV/vlpkPOomMDJHKiYXNahv99rRHUNhNFt4/Qw0YFcWgMd5/j
         4MuQ==
X-Gm-Message-State: AFqh2krpKg+fOIecjSxPjR8KcG4juu+5hOW6ED7QAXglhDy8IimbJMtI
        DPY4/GoJ+vswalY55AF4Qm8aCQ==
X-Google-Smtp-Source: AMrXdXuvcMdQY/5OBe/jfKJoCrOTVayBHMxqZ5Aye/Mhol4+Shyp64NUz01b5eTKkDLwDbVAUyMWPQ==
X-Received: by 2002:a05:600c:ace:b0:3d1:fe0a:f134 with SMTP id c14-20020a05600c0ace00b003d1fe0af134mr34311461wmr.19.1672851401499;
        Wed, 04 Jan 2023 08:56:41 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v26-20020a7bcb5a000000b003cf4eac8e80sm53003863wmj.23.2023.01.04.08.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:56:40 -0800 (PST)
Date:   Wed, 4 Jan 2023 17:56:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     ehakim@nvidia.com
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sd@queasysnail.net, atenart@kernel.org
Subject: Re: [PATCH net-next 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD
 in macsec_changelink
Message-ID: <Y7Wvx8BSBegYLvTi@nanopsycho>
References: <20230104074651.6474-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104074651.6474-1-ehakim@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 08:46:50AM CET, ehakim@nvidia.com wrote:
>From: Emeel Hakim <ehakim@nvidia.com>
>
>Add support for changing Macsec offload selection through the
>netlink layer by implementing the relevant changes in
>macsec_changelink.
>
>Since the handling in macsec_changelink is similar to macsec_upd_offload,
>update macsec_upd_offload to use a common helper function to avoid
>duplication.
>
>Example for setting offload for a macsec device:
>    ip link set macsec0 type macsec offload mac
>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Emeel, I don't follow, You had version v5 submitted the last time. All
of the sudden, you now dropped both versioning in the tag  and changelog
from this patchset? Could you please add it and resubmit? Also it is
a good practise to put a cover letter when sending multiple patches in
a series, would be nice if you have it here too.

Thanks!
