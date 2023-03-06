Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FD56AB942
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 10:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCFJHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 04:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCFJHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 04:07:32 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2CB1F5E4
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 01:07:28 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o12so35398892edb.9
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 01:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678093647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S1UTt4DO5EMkPVciGar3ib0Qx9uHBfOwmWIzMq/trQk=;
        b=hugdiMZ7pSe9GbfKN1rytTwezAhKbYL63OVcDPys2gQVl7vNhdnMLSLV5bJPuC0MsF
         XEceVOkgSua0OnNLYEHszRO9juNIqEl2QvC5ehX8ufSosV6FQa8dfPVmOQrDotgzrBLA
         PBQcssrNXh9V8RO8w3Nxh79nk8J6X6AgYFZPBs9fshDIz7IHzIIRhhfi1y0Nl+fpgEI4
         HXhzLXhaxrRNXZkJ0TTprvIqbfYiksO3+vdy21zS2JNtM0KMCJF/pvEaqoUv5XjNnY8i
         9M7NvKR6p+9/5ylEs/3uGyqywydW+w1JFvox4VqIqwhHD9CWd9MY6QOTQJCw31iPCF2v
         zEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678093647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1UTt4DO5EMkPVciGar3ib0Qx9uHBfOwmWIzMq/trQk=;
        b=BwvMYQaOETefeiADD7GUIWNDYjfl5Skf1G2REFh0+IcGEW9rbX97VHqNpPHM/oI1KN
         d5QGNjOGILN8Y2y2LR/jK+p+YQI6Smoez+wwLbgeFOUgEwciSkqiWPwb58gOZ5cHakAk
         drLOei31ZP2ULcRVi6cDBHgIMX6KqBxBjr++0Stj9XQ2t9e1x7gJjvznrjR7P6H7J3Yw
         NFCqv1pG5wcf+1nwpsBO8b3HUvaDKiz3EAhmw0BIem7+NEr2NWnQ0PoxBUYnJ38ePxt3
         nY3vNRgTAnzhlVp1+ecskoAE0fwrH/8R0f8YsXMI753qywS/eSpTSNE0WG06Sj5BIfte
         0uQQ==
X-Gm-Message-State: AO0yUKU4eYcADf/hAAifWEduipeGrHww4aFbaEK/nREzT1diYAckzHxY
        pedxXnm0SbnCsN1l2cYSDtU=
X-Google-Smtp-Source: AK7set93L6+14+MRDbmnXRmj28LzM2yIkEySkxnQo+M4ypSaseZ5nGGNrsZiEcPTsJ+vjq48qo2RAA==
X-Received: by 2002:a17:907:6e8f:b0:8de:e66b:27e with SMTP id sh15-20020a1709076e8f00b008dee66b027emr10929045ejc.16.1678093647324;
        Mon, 06 Mar 2023 01:07:27 -0800 (PST)
Received: from localhost (tor-exit-3.zbau.f3netze.de. [185.220.100.254])
        by smtp.gmail.com with ESMTPSA id 23-20020a170906005700b008e3e2b6a9adsm4306459ejg.94.2023.03.06.01.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 01:07:26 -0800 (PST)
Date:   Mon, 6 Mar 2023 11:07:20 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Adrien Moulin <amoulin@corp.free.fr>,
        borisp@nvidia.com, john.fastabend@gmail.com, tariqt@nvidia.com,
        maximmi@nvidia.com
Subject: Re: [PATCH net] net: tls: fix device-offloaded sendpage straddling
 records
Message-ID: <ZAWtE34EJw79Oqkx@mail.gmail.com>
References: <20230304192610.3818098-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230304192610.3818098-1-kuba@kernel.org>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 04, 2023 at 11:26:10AM -0800, Jakub Kicinski wrote:
> Adrien reports that incorrect data is transmitted when a single
> page straddles multiple records. We would transmit the same
> data in all iterations of the loop.
> 
> Reported-by: Adrien Moulin <amoulin@corp.free.fr>
> Link: https://lore.kernel.org/all/61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr
> Fixes: c1318b39c7d3 ("tls: Add opt-in zerocopy mode of sendfile()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Thanks for the fix, looks good to me.

Acked-by: Maxim Mikityanskiy <maxtram95@gmail.com>

> Maxim, can I add a .mailmap entry for you? get_maintainers
> will complain if I don't CC your @nvidia address :(

Yes please, that would be great. You can also add maximmi@mellanox.com,
in case someone refers to some old commit.
