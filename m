Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEAB336C8E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhCKGyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhCKGyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:54:40 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDE9C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 22:54:40 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jt13so43975849ejb.0
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 22:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o81eKAEtBQ2FJOjpjN2gYeJGKDwK3pecj0Cyefuw1+g=;
        b=UonXAFxS3GNfWC5jvOjKKCMM4yMNiCoRtbNo1Cz5vYV6z5vadc5BCz48flFHLX9aYC
         uZYZ5uajc3qbU3CRICvTZ0Rzo50ZpTkXVUVNFKBpuxiZszrGQiUKxUKqeNGVGi87723E
         7ZsTnl853NdUyinFaOyKGOtOXFrqyNtAZYOJ26XUQ9ti07Q9/9J4ox0Xn77bS1qcQHqO
         kF2eDbkUERJmUEYMVdBLWiKTRfDkFeugWyYM6V9mKN5IiNAqfkV47l/KbUmCSIQPcg2s
         hsGF0ff0F7nPfe1try2/htNVkjSlKD86YRTBK2OC/q8LpQuZ3WC02cgHuihW9f+f8XHw
         qhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o81eKAEtBQ2FJOjpjN2gYeJGKDwK3pecj0Cyefuw1+g=;
        b=gbgo4eE0b1AFAMHUSeaKgBdk2Mv97ImH9i1EV5v+emYlbngTi8l5bTGVgtMfNj9qU3
         7+v1Mv4biUkcHqsNPtBPOruvaQY/xZXG7SByPc0bn2DEIOdcnobMssLbJAeISIPAjDZ6
         9V1g8awX1lC9WwiW7X/SxHlLzLzJ7GooYdgbsgEt3I5efQZkPYdgYZGGBDvS38ujDISK
         QydFnHmtjYXeAj8qniAhUBct9TK1g8Uv5cBH6FlTXOOSjDDHDw1Zg9nsqg5u53l2OyUS
         funiIb5w5iScVSR+PDbsJi9kU2Ep5WtecfyoQF1QfjFQW+iVNhG8whuTTeDv3fXCkPd5
         ZCJw==
X-Gm-Message-State: AOAM532EctwNNS/XR/60wXOVWxUmWe5D4jijTQrzIX0qpL7bn1+FygLL
        zhgB8yNhUPiNqL3wV+wlqds=
X-Google-Smtp-Source: ABdhPJze2cDnig7Kaj47qkiJZb/XFrWrdyqpo4pExpVzRvTgsb22MBwpQ2LrBPVc8VuoDdV3/w5QdQ==
X-Received: by 2002:a17:906:d291:: with SMTP id ay17mr1588778ejb.308.1615445678994;
        Wed, 10 Mar 2021 22:54:38 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id fi11sm769667ejb.73.2021.03.10.22.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 22:54:38 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 11 Mar 2021 08:54:37 +0200
To:     David Miller <davem@davemloft.net>
Cc:     gregkh@linuxfoundation.org, ciorneiioana@gmail.com,
        kuba@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic and
 move out of staging
Message-ID: <20210311065437.wke2a7vhebdxx2bi@skbuf>
References: <YEi/PlZLus2Ul63I@kroah.com>
 <20210310134744.cjong4pnrfxld4hf@skbuf>
 <YEjT6WL9jp3HCf+w@kroah.com>
 <20210310.151310.2000090857363909897.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310.151310.2000090857363909897.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 03:13:10PM -0800, David Miller wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Wed, 10 Mar 2021 15:12:57 +0100
> 
> > Yes, either I can provide a stable tag to pull from for the netdev
> > maintainers, or they can just add the whole driver to the "proper" place
> > in the network tree and I can drop the one in staging entirely.  Or
> > people can wait until 5.13-rc1 when this all shows up in Linus's tree,
> > whatever works best for the networking maintainers, after reviewing it.
> 
> I've added this whole series to my tree as I think that makes things easiest
> for everyone.
> 
> Thanks!

Sorry for bothering you again.. but it seems that Greg has also added
the first 14 patches to staging-next. I just want to make sure that the
linux-next will be happy with these patches being in 2 trees.

Thanks!
