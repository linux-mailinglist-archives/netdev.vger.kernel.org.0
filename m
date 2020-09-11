Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A93F26760F
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgIKWnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgIKWnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:43:18 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9732FC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:43:17 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id p9so15718407ejf.6
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZNQmt+qWe5O7Whc9bnO+zubN0KQNBY4WACuOCEZNtkQ=;
        b=NPImKUG4AUEX3R5iNZrWPnnpVxI6ZbMdtrsoQffb6ZwEfh5HEjUkL4TXA3TFk1Pk0V
         /8GSiHsL1t4x0yckwUxI43c22lF8FoX5tVCBOcMvCiFJE50J6xbeKqMvDAxmE2K/5f2Q
         QWrKXqk3d8Gqm/5MoHUbaQgVEKuYWZGEjN8Rs2R/4EgdpPhLgm0JXQbrqp/FVWUYj8Qy
         ux701au4hY1V88B1EvtId30txFU6IlMHXAfe7X6pncdsJ90tA0k2AJhWSaJLeOrR5Px2
         HhDw6bljzGR5j2ufF+uAvRnZlaAEtKOABZ3SDMmb+wR5DPuwSmarCjkYhn4bZ5ivqFe8
         bM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZNQmt+qWe5O7Whc9bnO+zubN0KQNBY4WACuOCEZNtkQ=;
        b=Qj4RIIFjOS0rrvsZUJ0knLemm/ZY63nJP4011pwROusFmth0lRkrjQoQRIgtvRacnf
         4bB/5T5W10jV1BZDf6W2o1EqPciWfMJoyr0ChsLVVNvHQcpj0ikYihTbbSuYwmyLE+C7
         i7OI+80wRZpjYsUWQyc+TwBFF9GXGitrJXWx9Ua2OxKNq7AFJLfCZ9S7YanQm4JrcI80
         8NI9uCLzgcu50Z8fhzA4f5OK83nAiAZd2Nu0va6t40CqgXTkimu5CbAiOZAtFHKboWDU
         7sUcIwmCTQ0qLsiOXAnEH86h+ByGKIled6VyaETmeclPf2mxNLVTBY+1pMSh02eBj6pV
         kfog==
X-Gm-Message-State: AOAM533j8bEtIIsbSFpORS6rcXLV7OWIzuZrOKYWxYd/DZ3uZtfwj5MQ
        zaRilKKnmCWef00cMUOnKbjj1GAOddw=
X-Google-Smtp-Source: ABdhPJzEjuRP8upj+KrYkRi8qs65lW73sh1bTE/IC8vd81JVAOT1o0zGsDvlMPv5k/io0t/XASK0+Q==
X-Received: by 2002:a17:906:a101:: with SMTP id t1mr3987339ejy.203.1599864196358;
        Fri, 11 Sep 2020 15:43:16 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id b6sm2794410eds.46.2020.09.11.15.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 15:43:15 -0700 (PDT)
Date:   Sat, 12 Sep 2020 01:43:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC PATCH net-next v1 00/11] make drivers/net/ethernet W=1 clean
Message-ID: <20200911224313.qxhhcu2jlizxbyvr@skbuf>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
 <20200911075515.6d81066b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200911120005.00000178@intel.com>
 <20200911131238.1069129c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200911143405.00004085@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911143405.00004085@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 02:34:05PM -0700, Jesse Brandeburg wrote:
> Here is a list of driver files with sparse warnings from C=1, maybe we
> can encourage some others to help me fix them?

I can take care of drivers/net/ethernet/freescale, thanks for the effort
so far! I'll try to send a patch tomorrow.

-Vladimir
