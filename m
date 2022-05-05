Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82E51C1EF
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379552AbiEEOMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242724AbiEEOMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:12:23 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F15244A19
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 07:08:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id r9so4296894pjo.5
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 07:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hfxlOw/uFAcMcfORhfXQdWWEEspPO62Efp52ySPavfY=;
        b=S2JJzdms5i6ewB8jhMT4EjzEsiO2XW8iUdmgTuz5TeX+0D8kYairXhnHxblPno9KlQ
         OJErquIpe0l0PTJfOUX0S3/yOZf3O4tVYDmBXpltmjN5czWH3AvHV2sBzFwQZWY2Usfq
         r7d8ASNo2nveqvrx/yHCoIDyEnO58UXAhaqDJsyyJpJenhEnJ/D6YHTha9jJiwmWnumK
         RaR/nRB+r8L6OS05dFmUH1rU5UPfDhfiQedUkMNrSvYPUAjmEm4SahKsYAZHv5BGptMd
         w7tReqKdIiaIDHwg78SS6k/cwAflUE1nD9UEj77+k/u5b8E2gSKi4ZOnNAPtx2qwgowV
         td0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hfxlOw/uFAcMcfORhfXQdWWEEspPO62Efp52ySPavfY=;
        b=WMkYVKPMBWIaoJUcxz1JsZTLw/JaA7ZZX2mhj0o467jftPIUMvwguJbIsgAncvdvUC
         NDCxgZgVzWkgc5zOTCC5fU/QrIJwHtIFhMjpANJ+33cs6W9t1M63dO3jPy25sZo0883x
         VeVT3v6jIs9xSCKLWoPYEEATjxR1t4NUSXZIleT+me5Hdrd4mzf+1tcbHmz20AxLvq3U
         4ViPun2yGgQvITXq2NRGdLJqUhqTplXPsA+lYEmcr+ludW5Q9lQXSUtFZBcJyITIV8IK
         /lNPemEUo+xgCdNZxDEPdfj/vsmcdRUi7ThQiPyyALs8PwNZpYGRRgIoXJ+AQCwAcu5x
         zXDA==
X-Gm-Message-State: AOAM5328o/1JVkhVDO+KWo3O+zOlWcST+PlO8dUt9kgbltmqWDT5u5Ga
        wa0kqBSmGXRgo1bF/wq+gSU=
X-Google-Smtp-Source: ABdhPJx8DgRyy3gjsr8Xk+r/Eyf0T7Zkf6w243phFUggppxR0PSkyLhXxr7G7eb0wyEdkQ7KxTLIUg==
X-Received: by 2002:a17:90b:4c88:b0:1dc:60c2:25b2 with SMTP id my8-20020a17090b4c8800b001dc60c225b2mr6383246pjb.133.1651759723780;
        Thu, 05 May 2022 07:08:43 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id cp14-20020a170902e78e00b0015e8d4eb1e2sm1581180plb.44.2022.05.05.07.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 07:08:43 -0700 (PDT)
Date:   Thu, 5 May 2022 07:08:40 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        mlichvar@redhat.com, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next v3 0/6] ptp: Support hardware clocks with
 additional free running cycle counter
Message-ID: <20220505140840.GE1492@hoboy.vegasvil.org>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
 <20220504085552.3ff84d0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504085552.3ff84d0c@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 08:55:52AM -0700, Jakub Kicinski wrote:

> The netdev parts looks sane, I think.
> 
> Richard? Let me also add Willem, Jonathan and Martin.

Series is much improved... one more revision and I think it will be ready.

Thanks,
Richard
