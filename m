Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8074522C6F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbiEKGhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiEKGhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:37:36 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFCB102754;
        Tue, 10 May 2022 23:37:35 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fv2so1321673pjb.4;
        Tue, 10 May 2022 23:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZfSoPNQMQ3JtFIIIzzgju0SL8LR4iC7N17yQ0q5g1Gw=;
        b=QvBv2UfaGGwqFWNY/pqXIZh/GYk8NUG2EtFqNMhHJItgzyGdcST13XjgT+C51QFIu0
         wVRUAFagaBzJS1NQ19RnmAjO8E1K4w1zVumajYnd6dT4tvhMTgjaIX7mVrzFjuN+MdQ6
         AjoMhKZnuR5eE4T4wrSqyPkP3cXhfYhVrdfRL9sQmy5ouvNWLQ4VowVZn9rznHpkBK7/
         IbTWBK86znT2+Ma8LKDyx2Et/AwRVPK/pYs0za6VXQeQA/Rk5lUCqkV6hlnQYeLCB42U
         4R5LHx5APkIlgmoX2sHMd6JXdI4qUVaEyN4kplZmkr75KP4eCOHxu7vORlx1aPvDjwnL
         dl9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZfSoPNQMQ3JtFIIIzzgju0SL8LR4iC7N17yQ0q5g1Gw=;
        b=ZUuiyiFAudULwR9dd5iPpX7P8erZv+bFFa04a7O89XUvqY4O1DJtD1XhvykXYKygW8
         hNuB3JrrRlM/geePetWuEsQcexEHwqTjoIA1Z/1Ds5nFpRn8zPkIYYLVrIcLvLY29W9O
         GkOY2KQI0RstTmmLeO1lvM52OBQ1jhogKvPOPBjvOrUBXTd02zpuYy/rfbLmtJU8dhvp
         Ex90+8PLduGPwjzvcRDZse0EAQYDE7HrP/Jjs7wMaMNV0Afcc4s333qI7+TcfzPK1U5r
         vJo/54X71FTXbM90hOKVoE/xgZv9P59HYSx1xANrBQYMhght1YopEvl19HKSlh6Fe8Zb
         QbYg==
X-Gm-Message-State: AOAM533UrhfNs81fidfOTIx+Pw87CdGcErBC84s49bKTi7V92xiSvzn2
        ksJ3lBkS0+HnwL24wOZtKCI=
X-Google-Smtp-Source: ABdhPJwgwpaW/4sIrJ2DtPGOF3tg6+/fSjpKZf+P2/qrsXRtPAFe1BSQEXPb0SCMKuAXhX1wdnAmWg==
X-Received: by 2002:a17:90a:1509:b0:1d9:44a9:28c7 with SMTP id l9-20020a17090a150900b001d944a928c7mr3760102pja.89.1652251054890;
        Tue, 10 May 2022 23:37:34 -0700 (PDT)
Received: from localhost (subs02-180-214-232-26.three.co.id. [180.214.232.26])
        by smtp.gmail.com with ESMTPSA id t67-20020a628146000000b0050dc762814asm732056pfd.36.2022.05.10.23.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 23:37:34 -0700 (PDT)
Date:   Wed, 11 May 2022 13:37:31 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Akira Yokosawa <akiyks@gmail.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] docs: ctucanfd: Use 'kernel-figure' directive
 instead of 'figure'
Message-ID: <YntZqxuLSci6f8Z+@debian.me>
References: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 06:34:37PM +0900, Akira Yokosawa wrote:
> Two issues were observed in the ReST doc added by commit c3a0addefbde
> ("docs: ctucanfd: CTU CAN FD open-source IP core documentation.").
> 
> The plain "figure" directive broke "make pdfdocs" due to a missing
> PDF figure.  For conversion of SVG -> PDF to work, the "kernel-figure"
> directive, which is an extension for kernel documentations, should
> be used instead.
> 

Does plain "figure" directive not currently support SVG file argument?
Because when I see reST documentation ([1]), it doesn't explicitly
mentioned supported image formats.

[1]: https://docutils.sourceforge.io/docs/ref/rst/directives.html#figure

-- 
An old man doll... just what I always wanted! - Clara
