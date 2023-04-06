Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619446D9BB6
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbjDFPGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239455AbjDFPGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:06:35 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA4A5FCE;
        Thu,  6 Apr 2023 08:06:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lj25so2139842ejb.11;
        Thu, 06 Apr 2023 08:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680793593; x=1683385593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jpVWorwXOmwB6F9aalVF/BJLXYdyvcrGxRcPnrYyuGY=;
        b=Mq/ugyTreF1tq8eO1viaJiMjXXsdq1csjTuAMrBlPqXOtwE1uxjW/+HGWe2364Hq58
         +zdEpFb5xdsShlJiYKOqsenhVwfK9AMiL5HW1P9Dew8esiiPTyh/xZJgn946Od9skPdm
         Jkg2d1Mg2dbnFxmaVqAKmm4e7QzmiyMGZaugpC5GGPfCwgBe2XoK9mUD5YRu54kWSe7s
         ZN/s4P0XGE3ftLr889p1ivMrEc2GzxheqtdLERo9rVG3XcKNd1iUxwllDkFfFveanllP
         +MVT0d79C2Ev+vpDV6xb0Gc4QBChRY5a8aU6XsBZJCcyidoRlX+i9GTcpsRLgijRyPGt
         DG/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680793593; x=1683385593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpVWorwXOmwB6F9aalVF/BJLXYdyvcrGxRcPnrYyuGY=;
        b=O9KPpJVtjnF+QB8RWI4KQMW29oCre9P7OJUYU1lMVpMv0/cxi0uzz0XuQ7fBaHyReQ
         k4GfQNWrxLiQcgWEKe9Um0qXVrEVGdzFnkRwasDoGOA8COJkC76GPvpdAlwyVquaSOex
         me6xp0rTEZQ4dk7VUt/WBbM4atypU+do0lHTFfIbp8tTBaau6aj2vObBIGnuppWHJj+p
         fUBLcmd5+H6YCd92QpMbm5PzLgmoCVy5wBRQFaMTKsYWKlIfEFmtAruzY6wxqMg+fHLb
         A5cb9qyTuHqPHlS6OZrCH3FYUqmhg8l7WiPWakyg9QTGIorEbr3fuYfP91Q53hD59kdv
         wnsQ==
X-Gm-Message-State: AAQBX9fhIf1PqIMbYUQdIBPfG+m9NkyHD+GxofSlyWZwdFSnBRj3IaXM
        IsAP82Q/zBOi5UYNdNy+5zY=
X-Google-Smtp-Source: AKy350bwkLXyJWEmQ5ppR9OTGGlu3H0nRdbtPmGaReJArAh1ETH2lWrPn2HUHAehrCEUaoIfSsjY9A==
X-Received: by 2002:a17:907:6c17:b0:931:6f5b:d284 with SMTP id rl23-20020a1709076c1700b009316f5bd284mr6443576ejc.57.1680793592963;
        Thu, 06 Apr 2023 08:06:32 -0700 (PDT)
Received: from localhost (h130e.n1.ips.mtn.co.ug. [41.210.147.14])
        by smtp.gmail.com with ESMTPSA id lr7-20020a170906fb8700b009476dafa705sm908185ejb.193.2023.04.06.08.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:06:32 -0700 (PDT)
Date:   Thu, 6 Apr 2023 18:06:28 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Sumitra Sharma <sumitraartsy@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Remove macro FILL_SEG
Message-ID: <bff9626d-095c-4bed-ae8b-2be50610aee7@kili.mountain>
References: <20230405150627.GA227254@sumitra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405150627.GA227254@sumitra.com>
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 08:06:27AM -0700, Sumitra Sharma wrote:
> +	err = err || qlge_fill_seg_(fmsg, &dump->core_regs_seg_hdr, dump->mpi_core_regs);

I have not seen anyone do this before.  I sometimes see people do:

	err |= frob1();
	err |= frob2();
	err |= frob3();

I don't like this very much, but it basically works-ish...  I don't like
that it ORs all the errors together and that it continues after it has
errors.

Another idea would be to do:

	err = err ?: frob1();
	err = err ?: frob2();
	err = err ?: frob3();

BPF and networking have a couple place which do it this way so maybe
it's going to become trendy.

regards,
dan carpenter

