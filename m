Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B2535B5ED
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 17:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhDKPi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 11:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbhDKPi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 11:38:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1CAC061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 08:38:11 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so791490pjb.1
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 08:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uzZK4zKfhkQbjReqTShPAeOuD/MC4re8rtWmQWvCoys=;
        b=AQ2K3q7CTCZ5Z07ZUaIREvBenYvlULHChWst0ONxsxJqH3BJxA2mjcu7WfHyg6eIuE
         KCH8mqLaIXSQATfEDSckJUezYPzQmkPF2IC9fUeCXRyaNN0HiaIUzONKJkM9ey7ENyz0
         1nVZiAiUSPm7HK4pPKSOwBZ6xToGtB7a+ncqACkZDnpS3NGmAWHyhSncUe9kPk4NagM0
         kQNEjC/yq5XsDv/nu8GSq5VKktz4F0oUw7DxP+8y/M+R+K+G0CgUeGZucG0wrw3T9JyP
         G5O0LpYpuFa5H1DGqriMt8kcVWmu9OZ2jtmlI3y4VWT6xohDqo6QJLuBd46HSq8M9TuI
         PnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uzZK4zKfhkQbjReqTShPAeOuD/MC4re8rtWmQWvCoys=;
        b=mxwRTAyC58X3Tiz7Yl2CjOP+GqpTpjFQWQm9BmiG68rhfYc9Ga4H2fYxRub/5IQ5z5
         qVBUZTjI+zkLHVrCNp/dFzOVQCKmOx4VvBovKS0FarVIPme3fnuT502tUcFl7CFvGPtP
         sBfbe2dSrd2O4WmNljQOagFZ5cIMPIxdxGHBlrGD7nK0tS5Ky1nyv/61mghpqnWhoVlZ
         IafNpZty5jgFDms9OyXgC3Kt79hWT86/3UYqQvbRbYmI8ULMX4i/E3jkdp48c3g6biRo
         PLAfuRCWBlcN4N6s5Vsq9h32MC/a2jH6il5E9oDhQpcMAVaOQU4iZ6mBtFoqd4BIsTRw
         Pzxg==
X-Gm-Message-State: AOAM5306f13jOZZmTK2vgeRTfc9Rwyxi6alKN2Q6RB/goPfwzGmNreRy
        HWAepN3ZBpeOtSSDalybUQM=
X-Google-Smtp-Source: ABdhPJxu1sA/lbuylYHBheYaofcc2hAUywOFx/1xoRqXWXpITLAhhEKn4mSyUE4DUTvAJwLnhDGWNQ==
X-Received: by 2002:a17:902:dac2:b029:e6:30a6:4c06 with SMTP id q2-20020a170902dac2b02900e630a64c06mr22485165plx.65.1618155490944;
        Sun, 11 Apr 2021 08:38:10 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p24sm4296805pfn.11.2021.04.11.08.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 08:38:10 -0700 (PDT)
Date:   Sun, 11 Apr 2021 08:38:08 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH net-next 0/8] ionic: hwstamp tweaks
Message-ID: <20210411153808.GB5719@hoboy.vegasvil.org>
References: <20210407232001.16670-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 04:19:53PM -0700, Shannon Nelson wrote:
> A few little changes after review comments and
> additional internal testing.

This series is a delta against the previously posted one.  Please
follow the process by re-basing your changes into the original series,
putting a "v2" into the Subject line, and adding a brief change log
into the cover letter.

Thanks,
Richard
