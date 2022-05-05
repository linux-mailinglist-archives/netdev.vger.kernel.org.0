Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B72751C1D2
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380311AbiEEOF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241983AbiEEOF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:05:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBF456F9E
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 07:02:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so8088932pjv.4
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 07:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tODh+Vpnr/RRlndDp/IEt1D8eyPswYzuz/rgvaXhATI=;
        b=X84Nq6pqHVoyTYWyMttL/8RybZPFWM1199JLNEj30QxzzpzpAm/0djiyJXO5KCdj6w
         RL5JUpSXyn1d0LM+2R13K859WNxS0yEiR79JGyus0Erly9ejIjUD/UgTuK5vFiJu3eRQ
         Y3+iSHy8lKqgcxFfSBUMhRvhJc2CTyMFJiRA54VaxAEJSo7ZM67pnvLMNfegXD8deBak
         d50vnTdOeRK9ndcVJgesVOscOBiKuv9kQ3pvB+91BSyDsTtFolatMxEGqXdB/SR9DhmR
         +IoOZvQ4AqVdASIMHY1uaMSimm7pTXPjB0YMI2F8VQmNak3Hv01CVB0ZGhBNdXh0Gp18
         OkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tODh+Vpnr/RRlndDp/IEt1D8eyPswYzuz/rgvaXhATI=;
        b=fUeeheLxLC1Q8iDnKyTrHFRz13vQ/3VjewXUAOSYL+dyAJIy0xTJXWTDU5tb8kb6OY
         dpfCC4bI+uS70xRPQNjksMaQ3u+CjZmFWf3+nUTYMJSGaS7WCIDFcClLFsly6NCLVKDu
         4v8oTq4wdxIgicSJyd3Zh/CNSxMraNIuBwz41lbYBp1bMy/7UQhzu3eDTqevmHTtZ06J
         OqNS4nrLB6LTEjvbW6b9NZ3hm2lwK7KhEZuk/XJqGojdLpULS0sffuWvCqnEdgOJjF2t
         eqwuf9mgFlYsu2eFV66HmqaQkTWY/WdwiSDDc6DiPNW4FX8C9+3OFChz7ZywiUnNPtxx
         K8BQ==
X-Gm-Message-State: AOAM530hiuj0Gv617KjvmYTEbtJvnKejE3FPeG2GUnm965SaqZu324L4
        0R/RGrHcJWy/vXBosMPyn9g=
X-Google-Smtp-Source: ABdhPJxL4gF7wsDo0mIHvwMZZ5N+2zSKcYe7eoF6hsMnVAwNdYsaWI/yM9FFGrDW42o8lzzZy5coXA==
X-Received: by 2002:a17:902:d4c2:b0:15e:aa9c:dbad with SMTP id o2-20020a170902d4c200b0015eaa9cdbadmr18670697plg.5.1651759336709;
        Thu, 05 May 2022 07:02:16 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o18-20020a170903301200b0015e8d4eb229sm1536192pla.115.2022.05.05.07.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 07:02:16 -0700 (PDT)
Date:   Thu, 5 May 2022 07:02:13 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/6] ptp: Support late timestamp determination
Message-ID: <20220505140213.GC1492@hoboy.vegasvil.org>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
 <20220501111836.10910-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501111836.10910-5-gerhard@engleder-embedded.com>
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

On Sun, May 01, 2022 at 01:18:34PM +0200, Gerhard Engleder wrote:
> @@ -620,6 +625,11 @@ enum {
>  	 */
>  	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
>  
> +	/* determine hardware time stamp based on time or cycles, flag is used
> +	 * only for RX path
> +	 */
> +	SKBTX_HW_TSTAMP_NETDEV = 1 << 3,

Rather than re-using bit 3, why not just use bit 5?

Then you can:

- remove the magic clearing in patch #2
- protect against future changes that would skip the magic clearing

>  	/* generate wifi status information (where possible) */
>  	SKBTX_WIFI_STATUS = 1 << 4,
>  

Thanks,
Richard
