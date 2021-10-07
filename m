Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B93425D18
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhJGUV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbhJGUVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:21:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F69C061570;
        Thu,  7 Oct 2021 13:19:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so6058280pjb.5;
        Thu, 07 Oct 2021 13:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e/YpkKIE5V6t4jxfXyZfu6YNrRapkO8I3i7VrwNsmgo=;
        b=Ik7548FW1CsZktkuXqabNxc2k4f6WZy2M7/RvyEA7Ho2dAuBOPKlzY6kFCVnPUfQ57
         cfDDxZRwMHu9ssq5EBvvWkQmA97bmtKjmWtcZZQ0lCmGjvAnOAKmc10+Z3UkLnqNGD4j
         3XUIQiawHjPSrLN3VXCTU9V89Pbk7JJskHwuixar7cSGwyDtngBnxFTc6DxRD/sikP/c
         AM50aRoGWqID1XNLhVBIGsmhPgaX8SnZdqF772rvUTFiSMgAd+jbAkAksrxqdXDSk11Z
         ohlGbx/SHQIi3JsrR/BfItJDSKo1YZ/XFOxykE6B9Geb3en3T5XB2xrF4cxviU+VptSX
         6EtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e/YpkKIE5V6t4jxfXyZfu6YNrRapkO8I3i7VrwNsmgo=;
        b=Iqd+rng7yT9k7u/nOCAamfYPX6xZlQrpeWaVYLCQjce67dtujq5wnTFn3IVZcPJdoh
         bvuspO+Cn+azqEvRShyi2c+3iLjrSnMtrIqG2sslkESKg+MmrY4Q983SO6DBMc2+paQ+
         JnWpqSR53BmIVwWS8+l4wyOmWqJH18L7cXVlIMio55dwbXS+iCxdy/rkWhsX979fDGGq
         DrGbTP1uBr7xMfosUlCFs6JRcuvyMJNQlorESv/aMqBTZxXo+duTMzAo/0EWD0LOQFCp
         cGNPuUmkAwgXNIYiU1dgwIXAfgay2+f57wR3Jt5prh2PDtpQV8KesLopnKZ1r6sxrcRq
         xm6A==
X-Gm-Message-State: AOAM53386bS5O/G6SlZACCAROofixJ6Qv9sPae0d3vctVqC8BrGvbv1D
        cXC1uqEbDlCHihnEQWtBk20=
X-Google-Smtp-Source: ABdhPJwSwnWVUspzEs/GcA6pZDZOGLTgtpVtvAlJaqH5FZFCtbqMICuRXigTQvWSj9qeCqu0ronAwA==
X-Received: by 2002:a17:90a:1f05:: with SMTP id u5mr7127131pja.193.1633637970033;
        Thu, 07 Oct 2021 13:19:30 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k190sm177087pgc.11.2021.10.07.13.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:19:29 -0700 (PDT)
Date:   Thu, 7 Oct 2021 13:19:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20211007201927.GA9326@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
 <20210927145916.GA9549@hoboy.vegasvil.org>
 <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
 <20210927202304.GC11172@hoboy.vegasvil.org>
 <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
 <20210928133100.GB28632@hoboy.vegasvil.org>
 <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
 <20210930143527.GA14158@hoboy.vegasvil.org>
 <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 03:31:43PM +0200, Sebastien Laveze wrote:
> For example:
> Let's take a worst case, the PHC is adjusted every 10 ms, vclock every
> 1 sec with 1 ppm error.

You can't justify adjusting the HW clock and the vclocks
asynchronously with a single, isolated example.

If two independent processes are both adjusting a clock concurrently,
asynchronously, and at different control rates, the result will be
chaos.

It does not matter that it *might* work for some random setup of
yours.

The kernel has to function correctly in general, not just in some
special circumstances.

Thanks,
Richard

