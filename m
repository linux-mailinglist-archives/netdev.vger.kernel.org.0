Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB2646E839
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbhLIMUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhLIMUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 07:20:22 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D31C061746;
        Thu,  9 Dec 2021 04:16:49 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id 30so10295870uag.13;
        Thu, 09 Dec 2021 04:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f0cycxH+/hvcYJ7HIZ9t/9h9STsg8qCuIOcXKXVi1i4=;
        b=Jnxc2KnIFfmR5slhLfCOTXIRPLQo3wleJ0IFU53FCXoF5ZZN9bYBy14HYw6jkQEAf8
         fDR/kTsJ9zj+6WYXfdps2Ff2HF200aqQTKRWvI9rnrNu2ByD5Vcoe6+RB+rA13vE8OJ/
         ujCip+fWAGkMIQEi0hiGl9uFF8BzDpuPRYDY0ioZkNvSjHTUCWzfx+b3J8lLLxMWyfCT
         wgDoFdj3d01ATwOhXpeGyN9LJzD6MQtvPEDf9DtsES5KMKHRbPd/ehObrkd8637xOqeQ
         idp10DTkWw8MBhQgh4EPmkKi+8O3l6rnNOBQwR9e+FlopiEFomIQAFr8Km1Ariim7o41
         lGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f0cycxH+/hvcYJ7HIZ9t/9h9STsg8qCuIOcXKXVi1i4=;
        b=R0kBoC6H8INAsFttTzyynCB1HrNKm/Vbe6lhmF8EqDd6ASBHfv6BPNtrDdD06eCrMp
         GnC3ev4MOCdeI6nMHOrERuHg53o+a9hQy9isIIc8k54H/cJH5tuQbzPpjabQpUSxFs4+
         iw4E9MxDeg3OrH0L5gPOxyScBMTbmhNHqlm0VwDOLth00XTZ9o8+3wvBSA2enYa26jzw
         p5JZcH4Stag5nn/G2dqlx6MNgIz7rW9jFfpFxVu68YV0oIN3bNV18WTMAUlOekNpAYSY
         6TghFXPAT8UiwYWRroRoWGqWP6UMVgdI2+4QZR8lXFJRgRzt2gKKTl/h34HYhsfdtf9S
         6SiQ==
X-Gm-Message-State: AOAM530vjV8jx78qz6EabUmbLy6BsJF3C/wC29sNFWtv6re4fP/iqVlf
        u9tcI29gC76ToBLIpKsE780=
X-Google-Smtp-Source: ABdhPJwgAQUJXrZqPA3MJEEP59ocb1qejGRh1KuchakJvYqznYykNfYe+xeFZSutWyKO249qKQM+vg==
X-Received: by 2002:a67:ee09:: with SMTP id f9mr7219170vsp.50.1639052205973;
        Thu, 09 Dec 2021 04:16:45 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:c8c6:42ae:ac00:c4d1:ee21])
        by smtp.gmail.com with ESMTPSA id v16sm3697487uap.12.2021.12.09.04.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 04:16:45 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 65B79ECD29; Thu,  9 Dec 2021 09:16:43 -0300 (-03)
Date:   Thu, 9 Dec 2021 09:16:43 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] sctp: Protect cached endpoints to prevent possible
 UAF
Message-ID: <YbHzqwvR+fdrOQim@t14s.localdomain>
References: <20211208165434.2962062-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208165434.2962062-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:54:34PM +0000, Lee Jones wrote:
> The cause of the resultant dump_stack() reported below is a
> dereference of a freed pointer to 'struct sctp_endpoint' in
> sctp_sock_dump().

Hi,

Please give me another day to review this one.

Thanks,
Marcelo
