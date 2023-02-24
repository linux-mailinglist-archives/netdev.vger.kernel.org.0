Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62CA6A1E6C
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjBXPWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBXPWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:22:19 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468AC69AE6;
        Fri, 24 Feb 2023 07:22:18 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id j3so9677155wms.2;
        Fri, 24 Feb 2023 07:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dPU7obtAHP0j+i6BVBTm256HJzPDdg/f2QDMD3fsybc=;
        b=qFqjN0tGOa/CffmdzVtFfP8BURkLu0ILQld82UQxVn/3vkvExcg8I+NiSUATN8ZJJW
         6nfnOGAWjHIoJfBgFDmAx7zQlds+ip9xI8ndqAgsmFWQ2nl4i0scFyzpOXwMUNQrlI9d
         6DrMizcpKMNSa+/K3+pTyYwqkpdGfRp09CsiR5LxIDSOvZuVc6jJknrEB5Vq5jbcwKPI
         QUnamK9fPPttauz8Qiy0mcaO/OTtKd77L6JasGKIwRbDYPGGAFzj5FNdC2QoKvRaP99z
         IamDLYWWSCLv7UXiEnMBtDLEP4H9EvqFP++HJ93jFzddrsxq0bbW+ImN2C0TcJPcugWi
         Cwxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dPU7obtAHP0j+i6BVBTm256HJzPDdg/f2QDMD3fsybc=;
        b=XIcn08NYcASUilM9BajRlG42KNUTDv5ApCpEQoYHn9LHfqPK0RrCZgcUT1I3W2e/GU
         3bxHAY1wycfSmYe3sMH/H9dilszUqQv4wIhWwy/2YW7TAF6wE6/YeMPhDge/Nvo0PjTU
         BgGmfPkJIG2SKBnSz7kS30hCLMFJ5/d1AU5pVokMUI0Nc/aB2DxU8mdf8kbCs0sOmdKE
         613P1TXGIWfK5NO70vs4hHeHh4HMvD74s50Id9AjzPeGi6fXuz35icjoeV+Zx3CNVjjL
         vD17pxDvhU0xIYOnxu1Ty5MThh3NNPkDfttvYRSg7NYBxAFlYNE3LR6GF2JLXK5bdcrh
         tVCg==
X-Gm-Message-State: AO0yUKUcpwr3RxyN4NROsRJVvyOv8saoAAZQvjTiL4yQ3kR/F1DDvbSE
        dzyCIQKO7PH9Dx5OHqSGVuQ=
X-Google-Smtp-Source: AK7set9oJ3vs562AAGzj/rc6M2xZoLHToKsKthDDFfee4SOYI5rSWoOFYNDUBhfoE8g/mW/bSqmZuA==
X-Received: by 2002:a05:600c:331b:b0:3dc:4318:d00d with SMTP id q27-20020a05600c331b00b003dc4318d00dmr12068491wmp.11.1677252136554;
        Fri, 24 Feb 2023 07:22:16 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id f22-20020a7bcd16000000b003e21638c0edsm3064935wmj.45.2023.02.24.07.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 07:22:16 -0800 (PST)
Date:   Fri, 24 Feb 2023 17:22:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nick Alcock <nick.alcock@oracle.com>
Cc:     mcgrof@kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 27/27] lib: packing: remove MODULE_LICENSE in non-modules
Message-ID: <20230224152214.qb2ro3uvf7th5ctj@skbuf>
References: <20230224150811.80316-1-nick.alcock@oracle.com>
 <20230224150811.80316-28-nick.alcock@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224150811.80316-28-nick.alcock@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 03:08:11PM +0000, Nick Alcock wrote:
> Since commit 8b41fc4454e ("kbuild: create modules.builtin without
> Makefile.modbuiltin or tristate.conf"), MODULE_LICENSE declarations
> are used to identify modules. As a consequence, uses of the macro
> in non-modules will cause modprobe to misidentify their containing
> object file as a module when it is not (false positives), and modprobe
> might succeed rather than failing with a suitable error message.
> 
> So remove it in the files in this commit, none of which can be built as
> modules.
> 
> Signed-off-by: Nick Alcock <nick.alcock@oracle.com>
> Suggested-by: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: linux-modules@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: netdev@vger.kernel.org
> ---
>  lib/packing.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/lib/packing.c b/lib/packing.c
> index a96169237ae6..3f656167c17e 100644
> --- a/lib/packing.c
> +++ b/lib/packing.c
> @@ -198,5 +198,4 @@ int packing(void *pbuf, u64 *uval, int startbit, int endbit, size_t pbuflen,
>  }
>  EXPORT_SYMBOL(packing);
>  
> -MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("Generic bitfield packing and unpacking");
> -- 
> 2.39.1.268.g9de2f9a303
> 

Is this a bug fix? Does it need a Fixes: tag? How is it supposed to be
merged? lib/packing.c is maintained by netdev, and I believe that netdev
maintainers would prefer netdev patches to be submitted separately.

Note that I was copied only on this patch, I haven't read the cover
letter if that exists.
