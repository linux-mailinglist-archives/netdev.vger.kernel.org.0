Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BF71BA567
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgD0Nvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgD0Nvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 09:51:55 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF45C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 06:51:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z1so7355339pfn.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 06:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d/484kX7Ez5wXfSgagmNY1HgplKl6o0K8JCF0DfsHbI=;
        b=W456BiYIFd2FFcJbU+/7B2iHPo/5hyu3DqTcrE6XaWXAB3tm69nwAhiXlC/K0ilWKE
         79X5zNFXoYFNkw3Sn24QnjdeDSGRRSICt/YPg9qY2E4EFtftfvH8g/MG3KjiIV6uB4Z+
         Gek9/RWDbrj1c9waARiENiVFt9jFRhovVx2T0ihcZFQvz5Lccac/BMoQujj94sxIV2M0
         cDpmXNBj1Xz7eP2O8WL8u8QbwjsZ33WcI/ZikA8//Ej1uGmGrezOHhFxInZnCBwQehZX
         wk1zY0jRjui8ekvVqGcP1w+Fj/ESv6pNbc7N6Vd07dTXqFQ/5HLXEj5xCpx0SqW2UoH3
         63hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d/484kX7Ez5wXfSgagmNY1HgplKl6o0K8JCF0DfsHbI=;
        b=D/caIu2w+nA6gBLn41J3Gb4D0/vIr/Jbg2EjbGn5sftj+VFeVGynCHbzaCKwtY+XjK
         VelCV0bUYNxK0viQ7pDG1jJmbqd+8ktd+D5hfgZKlAWktpz7ztLfuimohGLGccNgcCDT
         n7Ps7l6YecKrVFeZfmnfUmGpD4PgwfwQV35mVGHbD8jNnM6KTrKMkjg5ZRTjuuk3BMdX
         +hbBClb3uPrXHsIB7+r1QM/dADoUzRGBQ3fyA0BNTsUFKN5+RK8H6RuQgQldzjKI/XWZ
         nOfbQFvScQfl+UoVJHIW9Ra4mW56QA66uV9hhOsmM9WbpO+rh+3YAjI62LVlIZ+BdCW6
         yvpw==
X-Gm-Message-State: AGi0PubEegmeWwgqTK1rPdC1WuyO/RnAAsg/Yg9NOA8IRYIbSY7XGvsP
        CCZPd+05lxw+ThHksxDQlN35qT99
X-Google-Smtp-Source: APiQypIskXPKUeBLn02D8sy3hgtrt0/B2CmJRKqARv700XVEcyHwTv01rR3TE7TGb7ZCAU6Etyd6hw==
X-Received: by 2002:a63:5a50:: with SMTP id k16mr21265871pgm.171.1587995514802;
        Mon, 27 Apr 2020 06:51:54 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w66sm12544576pfw.50.2020.04.27.06.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 06:51:54 -0700 (PDT)
Date:   Mon, 27 Apr 2020 06:51:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Li Yang <leoyang.li@nxp.com>
Subject: Re: [PATCH] ptp_qoriq: output PPS signal on FIPER2 in default
Message-ID: <20200427135152.GA26508@localhost>
References: <20200427033903.9724-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427033903.9724-1-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 11:39:03AM +0800, Yangbo Lu wrote:
> Output PPS signal on FIPER2 (Fixed Period Interval Pulse) in default
> which is more desired by user.

FIPER1 is already 1-PPS by default, and the user can load anything
they want in the device tree, so I don't really see the need for this
change.

But, I am not really opposed to it, either.

Thanks,
Richard
