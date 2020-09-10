Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B94264E56
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgIJTLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgIJTIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:08:21 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28243C061756
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:08:21 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id q13so10317830ejo.9
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KjSatM5fo5YsskcaA9AyBQVMuW8PO2eA24TlPUqAq20=;
        b=oIdFvKgpe9Of6pt5/YQ4eraQ2yCQxV0LBa39kNx8ldWaihQT5xDc7jm2cjM+e+wXDH
         pg3+mbhaf4NDwjhS8iyatM+NEYxjghvUSkR16KiQRfOM6cIC6gNwrpo1xepeKtw6dbKW
         H8Oyka9YOjGrR9vIPtDOZFZUeEdzqEJMwz+08196ovePJ8YoEv7jmlROpZIEV5Nr/Mty
         LvrMDJe6IIS2EZeWcDdYRb40BllbqOIlvRTs3JOcsijH/20GvbJ83jKnAV0WUvW4jvE7
         0faIzPTtS01YobUtVwxBbdfViJ9JfgIKoCKvnMxRc1LSY3rspXFyor7aNy7PfCsz/F6j
         ihxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KjSatM5fo5YsskcaA9AyBQVMuW8PO2eA24TlPUqAq20=;
        b=jqmaEYGYsvGxvG0CbEmsWOtEOYOmRHXnopWoVrRsqq/6/WCXKKBB6qkbZnpHocpbXp
         9Dk/pQ3iHZtQPFdM4+OXhJ65uYp9HQ2Yo1MZbJ973lKSD/HPfRcS26Vq64nAK2vDoYKr
         qUeZ2hJF2TIfDdDkyQ4t9CYzCjxv6Oz82CPwkRWtGOnV3+zohLjJnRDz2A+85Lqm7zHh
         i2GnfxYvft9YZ7S0SqguDj3dgQoHkKnRJpHce99ENxjPdVCF0TRT28ch2Txick+w0/aB
         YpzfthnulEOU30Ui4jzNKF9xvScest4N4KWq6BEDoiJnRe0rr83ZL8ndRCWh3j4xB0c2
         qV4w==
X-Gm-Message-State: AOAM533QSe65xGuJ6sgeXlEJdpr1f8C4cEvVvd498cod/P3B+zrlgS3d
        Wn+nzlo+AF3DA8kMbyxkKeo=
X-Google-Smtp-Source: ABdhPJxc6hgMvs43h2FUpMH4Okn3Xticxta5LiCfCBmAcEwTpkMF5b46sO3ptYWkGUk4Fuh3hPPUyA==
X-Received: by 2002:a17:906:2618:: with SMTP id h24mr9879976ejc.198.1599764899854;
        Thu, 10 Sep 2020 12:08:19 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id v5sm8050939ejv.114.2020.09.10.12.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:08:19 -0700 (PDT)
Date:   Thu, 10 Sep 2020 22:08:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: VLAN filtering with DSA
Message-ID: <20200910190817.xfckbgxxuzupmnhb@skbuf>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
 <86ebd9ca-86a3-0938-bf5d-9627420417bf@gmail.com>
 <20200910190119.n2mnqkv2toyqbmzn@skbuf>
 <7b23a257-6ac2-e6b2-7df8-9df28973e315@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b23a257-6ac2-e6b2-7df8-9df28973e315@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 12:05:17PM -0700, Florian Fainelli wrote:
> On 9/10/2020 12:01 PM, Vladimir Oltean wrote:
> > On Thu, Sep 10, 2020 at 11:42:02AM -0700, Florian Fainelli wrote:
> > > On 9/10/2020 8:07 AM, Vladimir Oltean wrote:
> > > Yes, doing what you suggest would make perfect sense for a DSA master that
> > > is capable of VLAN filtering, I did encounter that problem with e1000 and
> > > the dsa-loop.c mockup driver while working on a mock-up 802.1Q data path.
> > 
> > Yes, I have another patch where I add those VLANs from tag_8021q.c which
> > I did not show here.
> > 
> > But if the DSA switch that uses tag_8021q is cascaded to another one,
> > that's of little use if the upper switch does not propagate that
> > configuration to its own upstream.
> 
> Yes, that would not work. As soon as you have a bridge spanning any of those
> switches, does not the problem go away by virtue of the switch port forcing
> the DSA master/upstream to be in promiscuous mode?

Well, yes, bridged it works but standalone it doesn't. A bit strange if
you ask me.

-Vladimir
