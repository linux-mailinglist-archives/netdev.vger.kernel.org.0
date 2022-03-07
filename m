Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011144D00E3
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243073AbiCGORK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 09:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243075AbiCGORJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 09:17:09 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727678E1BC;
        Mon,  7 Mar 2022 06:16:15 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 27so13651785pgk.10;
        Mon, 07 Mar 2022 06:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u+zGEmAlS2RavnRVCimutvLWUuY5OBsSGkT6UPh7SFs=;
        b=SK94RyOfPfeBIbJAbYASy5kOqOk4EUg/UT4wsvDhU55vsJbTYtylCogJ6sA9oezPME
         q5j95oOzbrJfH+HeAtvSZ53SAVTNhVbkLDtHVSnMrfvFgkRU2XU3KCzC69KHmsM8JAoz
         un49UYPXZY0TNDnRQ99sj8p5qdlQ78t+syMUowjoOEtehCbf6K2t/56In54XOykt8oe8
         9hsRm8uvxyL1rxgdbjMBVV2tI24hHeqgWw6dKdGm+L1420jdMdAsJelrGuwA8FntzrX5
         waDBC6SVCaYQSEzq1KLNIpWjRqMK2V+3kDVJNaZ7PqPmutkrEwK1unN1Jhot7egeiGPj
         PzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u+zGEmAlS2RavnRVCimutvLWUuY5OBsSGkT6UPh7SFs=;
        b=mls0yHGVWsW7bMCPh5JhfjE9LeR/D/vMEu6xx4v5XlScUA0xUjy9V24FEIaLLvE5QF
         a0hssvORk7ut0QLTOX9bUF+LD+5NsbRbYz5cKLcqsd1YOWiv+ZStmNcPhC9kcGq0fO4b
         GQ+F3uLTu3BcqmI60H6o759hCbCFd1pPqK+6blC5v8sS/fwB0OrSemi79av8O7xHtElG
         TAqLOHFvKS6TGww/um+x0egrXfzOcXacl5iro/qw/RsB/Hp9Wd666rNXsNU0hySc0Rc7
         6vKDSF1VbJwwoe5jjJaxcbuAy4VVuOjRVa9742tfO6f5/+K0Ewe6+p4EalSy6Hshp9sh
         QUtw==
X-Gm-Message-State: AOAM532UmsW7ZpGFkI9wdLyLQ9kkpk1dbgnPFzm3J50iB5wJTf7VHVFD
        BfUZhmcGI6uQBSOeEp5gy+0=
X-Google-Smtp-Source: ABdhPJwbL3IGmI2wy0DJKooIVfWVzqqbrGa8kJlZKASqPF7Kf7DfSScq502sb8fSss2+xV8mFCPjtQ==
X-Received: by 2002:a05:6a00:2402:b0:4e1:46ca:68bd with SMTP id z2-20020a056a00240200b004e146ca68bdmr12909212pfh.70.1646662574849;
        Mon, 07 Mar 2022 06:16:14 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id nl9-20020a17090b384900b001bccf96588dsm20214055pjb.46.2022.03.07.06.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 06:16:14 -0800 (PST)
Date:   Mon, 7 Mar 2022 06:16:12 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Vadim Fedorenko <vadfed@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ptp: ocp: off by in in ptp_ocp_tod_gnss_name()
Message-ID: <20220307141612.GB29247@hoboy.vegasvil.org>
References: <20220307141318.GA18867@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307141318.GA18867@kili>
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

On Mon, Mar 07, 2022 at 05:13:18PM +0300, Dan Carpenter wrote:
> The > ARRAY_SIZE() needs to be >= ARRAY_SIZE() to prevent an out of
> bounds access.
> 
> Fixes: 9f492c4cb235 ("ptp: ocp: add TOD debug information")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
