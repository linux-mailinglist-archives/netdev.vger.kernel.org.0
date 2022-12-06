Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E13644EB6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 23:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiLFWt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 17:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLFWt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 17:49:26 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34239101F;
        Tue,  6 Dec 2022 14:49:25 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s196so14698285pgs.3;
        Tue, 06 Dec 2022 14:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pe1eOciIXEJ+05IC+V1OUGdVr7z9y/treN6lOvW2ZCI=;
        b=OwEJvuf/JOQglAYaq6BU9UsJlJfr3meImRdp9x/CoksF2U5mAD159MFnPwbeqjeEyM
         RUAWcqPcQouMLqLpvL8rUCF9UN8j5uRADokKyNqIb77Bh3Oul5F1PZYTAPfeRWa4GdPH
         AESGxMxcBXfCyoq7g0SUQKyGoowDNuOlxrbR+KN/jqYv659XYwG5BM5FgpGQ9pSnObxO
         TQlWW4ztqJCtCh835Sjyjf+VyXAznrR5stb9yMgbn8eNkJgYkLKwaqRqyWUrzTq9jCaP
         z1WCbE8AlOCQoYFguhtlF8B/guKFl3p7wDPWwOlSrjKYJkVeht93X1D34qj0j+5VlVY0
         rizQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pe1eOciIXEJ+05IC+V1OUGdVr7z9y/treN6lOvW2ZCI=;
        b=VmM0CvLqRraJoHuHqJPJ9d0wd8REI3UeQXMS9oM1m6zRnDrtRUV/U8BA3IrqwssJBC
         VNugjnMq9iJUpZQYFOFid+zxbiQiao7WmOsF88AsOAh+dKe2pEaRrrTI/vqPdO2wEsDX
         Cl1/hwNZ5evDG13I379JlsPL3O+5xA/wOYlei2pqdJjidZHHlpwQ6m1yriuWR1UPUU/1
         A3svOJ72SDwM7SZKGO5zr7+Rst8nvCpM9R0N0uS8AyltG+yN2k/ANI6KVjP3dye9p/uY
         aVHRHFHzIIQ42halYGgk6K43b759hQYGHDLkkIupLsa5zCEu6X06UuKt1fJ7WsY7FfkB
         P00A==
X-Gm-Message-State: ANoB5plfQP/2gOLRkgJtFSBdCpbo3icwlXIvHju99iSNF9cJ7nl3OCkn
        xb0EcD8dHVoU9/eLI/W46YYc0iDaCpE=
X-Google-Smtp-Source: AA0mqf7IfCRwxmsc0rRgNngVMIeMwL16nWO5Ls60aK7lhp8auFmnlXqSTynUfJkX/RzkZ7LXcvkU+g==
X-Received: by 2002:a05:6a00:2396:b0:56c:318a:f808 with SMTP id f22-20020a056a00239600b0056c318af808mr73933355pfc.11.1670366964596;
        Tue, 06 Dec 2022 14:49:24 -0800 (PST)
Received: from localhost ([129.95.247.247])
        by smtp.gmail.com with ESMTPSA id s15-20020a170902ea0f00b00189b910c6ccsm5587954plg.125.2022.12.06.14.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 14:49:24 -0800 (PST)
Date:   Tue, 06 Dec 2022 14:49:23 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <638fc6f33c755_b05f2082c@john.notmuch>
In-Reply-To: <88d6a1d88764cca328610854f890a9ca1f4b029e.1670086246.git.christophe.jaillet@wanadoo.fr>
References: <88d6a1d88764cca328610854f890a9ca1f4b029e.1670086246.git.christophe.jaillet@wanadoo.fr>
Subject: RE: [PATCH] net: xsk: Don't include <linux/rculist.h>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET wrote:
> There is no need to include <linux/rculist.h> here.
> 
> Prefer the less invasive <linux/types.h> which is needed for 'hlist_head'.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Let see if build-bots agree with me!
> 
> Just declaring 'struct mutex' and 'struct hlist_head' would also be an
> option.
> It would remove the need of any include, but is more likely to break
> something.
> ---
>  include/net/netns/xdp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/netns/xdp.h b/include/net/netns/xdp.h
> index e5734261ba0a..21a4f25a187a 100644
> --- a/include/net/netns/xdp.h
> +++ b/include/net/netns/xdp.h
> @@ -2,8 +2,8 @@
>  #ifndef __NETNS_XDP_H__
>  #define __NETNS_XDP_H__
>  
> -#include <linux/rculist.h>
>  #include <linux/mutex.h>
> +#include <linux/types.h>
>  
>  struct netns_xdp {
>  	struct mutex		lock;
> -- 
> 2.34.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
