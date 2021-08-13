Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBB63EAFA2
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 07:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238698AbhHMF2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 01:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbhHMF2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 01:28:00 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4164C0617AD
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 22:27:33 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q11so11569225wrr.9
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 22:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l6IRObWVvXBieSlEnu0iCa0joFZ/1yBQgtC0s5S5ShY=;
        b=Og9fxEA5Hye+7EHiS0Us02MKH7wYxSECpRMQPWVuAIHzqtEnL+aIQPp34zfzW2gmLC
         vciqTsYb2YakGMKQdcMxhzkZcrQupgU+MpPdD/9+wMYcjLVuzFzS3bPA4BFbtJQdgUyY
         V2OcWGSx6MP6brBnxMhINryYtRVH9eHVgKR93WTaSoOlwrVwUsSOQDIpT8X5qRurJw8f
         hEfkVpclL9Ifp+HodsRchX2qT0cnxFaFcB7w1kgqPnReyzrbcbfj3Yha1n8Y8cgiN9s4
         Fp2EP6/ZJ+oO5SVKOumSAz6O6wUKM4in50ul2O9ZFW1lqff/gnDzVSU5JDc5g3dwCmA9
         lwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l6IRObWVvXBieSlEnu0iCa0joFZ/1yBQgtC0s5S5ShY=;
        b=iMD42u9UD82a1u5Jftpq8OthyRm7BLIOqRKBezXPiMGrU15PfvTxtY7nsqOfJY51X1
         /5g/YrDSnvLon/2OBgsVH1dfkKpyQUiljLzc+yFptUw5nixBOghe8RBHZyOWc+dtF57z
         EH3p8M0stE2w0wUDsD8XAZ5kT4A69nPpgalVUf+nAR25QRidZDD8gvIRuVEp5Md3vgoU
         DEjcUziuazHmbPN1LFYqFH22kUm8bQVexOqjhDdSpPhG0g4TtRnGnctvQ2NSILfz2Zs+
         G7yFqsu0+Qmc/e65wJxuqtf33thq6vvQ1WpMNoIfDREN/RJuVLeLMxWBUW1XVGRyKoYR
         /vLw==
X-Gm-Message-State: AOAM532T+uKrc+DCzrzlQeiIMeGSA+j94fJi9QdzIIPKs00aUrmxIQ6T
        saWGCummG0hv6p54NEchSw==
X-Google-Smtp-Source: ABdhPJySK/xEIWMhQwnA2tCSKTVFv4POkfTy4uMHRSbAIiYxYKs1t62A6KEnJ8p6sKA0xcR0Pi6w5g==
X-Received: by 2002:a5d:44cb:: with SMTP id z11mr868330wrr.100.1628832452618;
        Thu, 12 Aug 2021 22:27:32 -0700 (PDT)
Received: from localhost.localdomain ([46.53.251.219])
        by smtp.gmail.com with ESMTPSA id z3sm353980wmf.6.2021.08.12.22.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 22:27:32 -0700 (PDT)
Date:   Fri, 13 Aug 2021 08:27:30 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: gc useless variable in nlmsg_attrdata()
Message-ID: <YRYCwjh+5CpccgI8@localhost.localdomain>
References: <YRWRcbWR45+zF9mD@localhost.localdomain>
 <20210812150552.18f32fb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210812150552.18f32fb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 03:05:52PM -0700, Jakub Kicinski wrote:
> On Fri, 13 Aug 2021 00:24:01 +0300 Alexey Dobriyan wrote:
> > Kernel permits pointer arithmetic on "void*" so might as well use it
> > without casts back and forth.
> 
> But why change existing code? It's perfectly fine, right?

It is harder to read (marginally of course).

> > --- a/include/net/netlink.h
> > +++ b/include/net/netlink.h
> > @@ -587,8 +587,7 @@ static inline int nlmsg_len(const struct nlmsghdr *nlh)
> >  static inline struct nlattr *nlmsg_attrdata(const struct nlmsghdr *nlh,
> >  					    int hdrlen)
> >  {
> > -	unsigned char *data = nlmsg_data(nlh);
> > -	return (struct nlattr *) (data + NLMSG_ALIGN(hdrlen));
> > +	return nlmsg_data(nlh) + NLMSG_ALIGN(hdrlen);
> >  }
> >  
> >  /**
> 
