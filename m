Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2A05025BB
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 08:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350568AbiDOGoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 02:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350562AbiDOGoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 02:44:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270F9AFAE4;
        Thu, 14 Apr 2022 23:41:44 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 11so3927524edw.0;
        Thu, 14 Apr 2022 23:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5H0NkTvkK9p/s/zFBLeQhRPlAabxLu86mDFZRjaQsXc=;
        b=iyFOa4B+WwNsN+h+lDNBD7iDxm1raLPy02+uAnAc+XNZRX1w70gpAZqtygmAFeXjSg
         1GUSmiurrP71xGOpLq2V4+8hSIuCzS5F96z6jeOIkzrISvWEEudwsgm6RzwwlnXcPG9a
         qF7a2xTHOx8a5GiJsY9lEWF+Uho6ZA7vaNxdHeBlI/Wi9LjDuddeBUTS0lm0eGkImDje
         Y7lTz1NSrxwSn3xQtTvCQRVjxClQi+Dz2ezWPmHqsU5nI68lMFWm74KyKRimhArp1eDN
         1y8GQ2Z09zw3xJSYv4or3YzrTl19q7VEvrFUNdkgSWq3/gFIAakmfJp2mOKtJhlto7m3
         0BhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5H0NkTvkK9p/s/zFBLeQhRPlAabxLu86mDFZRjaQsXc=;
        b=Xm4y6PmYs+lspXFpVj8vE/WicT+iORkJhz34bEFRFNKJzgRf5HwmDN/8qqT9Sg4W6K
         GFgTy9bQQQnB7HzvC22OHQtk5PqsSeras7//nCs4DqU4UN2rjfsiMFP2pMjk6tswO3sG
         esBog/yYnpXDrLLj4beSAAGjkiCCTDbkFGYrVKHSDA1bQTZFcwfAtBjHWcGM/gvbG+TY
         Efa/Sj1FUru6MauK6uIi32QLN/f1HJCIUvfo1EBdZ5MSDLIafZMeNBpaDYA5CNzC7m4A
         I2lQvmbRPpoxCygRlrFpS/TBV928uL1Fi4fmQNybRpyBj8ia0u0V5mmRKptEKcEj4Wdl
         Mkkg==
X-Gm-Message-State: AOAM532tVHZPtPBd5HHRO78VFPdJyOuMum4Me8jvg+U4M+vEKk/1HX1f
        iYSnbWxI5ZkWmDfyK9hcoOOSv7truu+0EKB/
X-Google-Smtp-Source: ABdhPJxavdBJugZjTO5NWzDHmyFQ192W3DPA51QTlL3JUiZqLUMj0ftkoqVV6vkYR+MyGK8HDeanwQ==
X-Received: by 2002:a05:6402:1385:b0:413:2bc6:4400 with SMTP id b5-20020a056402138500b004132bc64400mr6918217edv.94.1650004902841;
        Thu, 14 Apr 2022 23:41:42 -0700 (PDT)
Received: from anparri (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id j23-20020a1709064b5700b006e87ae0c111sm1362808ejv.123.2022.04.14.23.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 23:41:41 -0700 (PDT)
Date:   Fri, 15 Apr 2022 08:41:33 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/6] hv_sock: Check hv_pkt_iter_first_raw()'s return
 value
Message-ID: <20220415064133.GA2961@anparri>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-2-parri.andrea@gmail.com>
 <PH0PR21MB3025FA1943D74A31E47B7F8FD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR21MB3025FA1943D74A31E47B7F8FD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 03:33:23AM +0000, Michael Kelley (LINUX) wrote:
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, April 13, 2022 1:48 PM
> > 
> > The function returns NULL if the ring buffer has no enough space
> > available for a packet descriptor.  The ring buffer's write_index
> 
> The first sentence wording is a bit scrambled.  I think you mean the
> ring buffer doesn't contain enough readable bytes to constitute a
> packet descriptor.

Indeed, replaced with your working.


> > is in memory which is shared with the Hyper-V host, its value is
> > thus subject to being changed at any time.
> 
> This second sentence is true, but I'm not making the connection
> with the code change below.   Evidently, there is some previous
> check made to ensure that enough bytes are available to be
> received when hvs_stream_dequeue() is called, so we assumed that
> NULL could never be returned?  I looked but didn't find such a check, 
> so maybe I didn't look carefully enough.  But now we are assuming
> that Hyper-V might have invalidated that previous check by 
> subsequently changing the write_index in a bogus way?  So now, NULL
> could be returned when previously we assumed it couldn't.

I think you're looking for hvs_stream_has_data().  (Previous checks
apart, hvs_stream_dequeue() will "dereference" the pointer so...)

Thanks,
  Andrea
