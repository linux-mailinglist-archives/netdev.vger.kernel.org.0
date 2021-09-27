Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC34F4196DD
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhI0PBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbhI0PA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:00:58 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43140C061575;
        Mon, 27 Sep 2021 07:59:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so15571140pjc.3;
        Mon, 27 Sep 2021 07:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8zE3PuAYxjHHyHtMf1uloqpXLjkHYJucyHkh7I4s28E=;
        b=TjY4/pqdywC5d2LPABId7jhu5e/jhL67QaThCH+pIzvqse5lNMK/rhngl3TWKzUqLp
         sfLI6QRIb+ngjDVVhmREts+s13MY/vQy4FZI0Nc95e2clHS+voNg5Kky7hYvtuQUZXGg
         FSZpoejJ/DkpbNmfCC+MSvm23qzRV/jnremoZZcDbJbE1O2/5IEx0St7FGf/8o1/rKZx
         SNiIMnrlAAyCuDTriREIZ4BBESd/uW74E2b8Gi/1elRm6OmLzRThglnCVJ6G78NIoTAI
         j2uLEl9wR8YpQE/xPEYcEjDtdzWlNGIKoOzg5FOZF4H0pZ5cbqUoUiTzQxE9mXRKkiN4
         GIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8zE3PuAYxjHHyHtMf1uloqpXLjkHYJucyHkh7I4s28E=;
        b=SDuw/zJBJIZiMr0HcTrSQnne+kk1ZAk3FNkOBYKamOxq/WQD0u8un0NYragxXZMMfT
         h+eXgkBjP3xryQzWTpIIS/ns+N+MqgGm3YDxDqO0nvuQj6jXd6x9be5///RehDXh1Mm5
         SHsMpT+Do8chQBb/T8Ewfv1oUWnnqUdKFgM7Ljy1NMVASAcxGdLVmwVPkPmuq93Elt25
         ZCvlAwaBD4jQVAtvec/J7oeHvWRfTA5BS4R1GMzCEzlafDCbjrP3pj+oZ0p8uSCEw39m
         MnilluMYZBcspqQkIjnKP3KIRvNNNPCXaLpu6zZOhV4BUlYNqUbw/hnOxpUlyWgxJCrH
         UZzA==
X-Gm-Message-State: AOAM530QsM0tz8/CJBk8qtlZ0zAKMWlHBfZg1dv/pHN2YdRH0LqQPBh7
        asQgwFAzL+ffpUazCo0sAtiuUO2yxQE=
X-Google-Smtp-Source: ABdhPJya670geEx4gl6FtTtPzsQ9WIoY/Yv5q8nsXE7VQtyUM8/zhvTiss05bRdbjvXit7f9J7wDSw==
X-Received: by 2002:a17:90a:9909:: with SMTP id b9mr414974pjp.55.1632754759760;
        Mon, 27 Sep 2021 07:59:19 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x5sm11204423pfq.136.2021.09.27.07.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 07:59:19 -0700 (PDT)
Date:   Mon, 27 Sep 2021 07:59:16 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20210927145916.GA9549@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 11:32:50AM +0200, Sebastien Laveze wrote:
> Add an IOCTL to perform per-timestamp conversion, as an extension of the
> ptp virtual framework introduced in commit 5d43f951b1ac ("ptp: add ptp
> virtual clock driver framework").

I'm not wild about having yet another ioctl for functionality that
already exists.

> This binding works well if the application requires all timestamps in the
> same domain but is not convenient when multiple domains need to be
> supported using a single socket.

Opening multiple sockets is not rocket science.
 
> Typically, IEEE 802.1AS-2020 can be implemented using a single socket,
> the CMLDS layer using raw PHC timestamps and the domain specific
> timestamps converted in the appropriate gPTP domain using this IOCTL.

You say "typically", but how many applications actually do this?  I
can't think of any at all.

Thanks,
Richard
