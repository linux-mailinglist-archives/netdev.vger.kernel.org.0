Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C72D3692
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfJKAxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:53:38 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42490 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfJKAxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:53:38 -0400
Received: by mail-qk1-f196.google.com with SMTP id f16so7377493qkl.9
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LJeFEyGVXk/mGwXcaQPTIO+s6MfjnGYEbGXqRN7NpR0=;
        b=l3p2fC4wycAgJV23evkAk7sh7SIx2wyVEit5jJwYEsY3yLl88VyoMOBFHGzdF8A13O
         ISzxvd2hEuVA1cm71KOSRDvS1s5x+mhvvqI4H2RvDI6OK4k7MazFk6rA3aCTmBbveHi0
         S/Gikj41ZYC1UmbXagVBt/UsUvodZhR9pQ4xhd41TPQvzodmeEsHR+vwBQqLAWNHDa44
         ChYwxC6LU2oo6jG85kJsCNuxu++Rarm3uk/yf12HHTn22QrInbImks5tHFpAVS5KVF+b
         Q+Ifk2EaA4keuOeOfJpbPeyu/VX5OYMiUL3DtipePm0Syutdjlj0Q2DNGh+94tKQd7gF
         sfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LJeFEyGVXk/mGwXcaQPTIO+s6MfjnGYEbGXqRN7NpR0=;
        b=nEPPZaf0siBJxADjAW1bd/aS9luLEmB9gJdk1KZC5YNifFcEeNofmz7f4Ku5I0gaEi
         D7/0d+kv5s1PVi3pHEckttUlBOlCmhP/GJ1BozqM8X6FULPh4Nh7LZtkhtXY7cVDR34G
         kMq02roSuB9NSzI/IfQTHXvarQtZ7wR67cnhl6zunTDOa4ufLX0w61FQpbjNLhkR3Z3D
         rygCLir1Subq0I9Ve48N9pLGn8EXwPbsgP1OhFdGpLwBLZcqDNMHE5qDsdf7RBqtmYuP
         C4EnRmpDcySt4WNTI2JHha9wUcV4C8N7yTGYhTJEbd5coOyGUupcL6IbnZi/8+BlknEp
         jRbg==
X-Gm-Message-State: APjAAAU7rIBy1Bm1qkDsXh+gH5XA7H1q+BN4CLlXXAKMCqHkNhLyJzkQ
        9hjCjpaNQC4gnLEBB+eFnAZfwQ==
X-Google-Smtp-Source: APXvYqx2VFaFaQefkqKDZOvzMLezQN76wMczVjiGgJyKni3IcbQ2vW7SpeaY1XTx4ctFxNRtQlsxdA==
X-Received: by 2002:a05:620a:20da:: with SMTP id f26mr12569659qka.255.1570755217074;
        Thu, 10 Oct 2019 17:53:37 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q6sm3034090qkj.108.2019.10.10.17.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:53:36 -0700 (PDT)
Date:   Thu, 10 Oct 2019 17:53:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Anson Huang <anson.huang@nxp.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "swboyd@chromium.org" <swboyd@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 1/2] net: fec_main: Use
 platform_get_irq_byname_optional() to avoid error message
Message-ID: <20191010175320.1fe5f6b3@cakuba.netronome.com>
In-Reply-To: <DB3PR0402MB3916284A326512CE2FDF597EF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
        <20191010160811.7775c819@cakuba.netronome.com>
        <DB3PR0402MB3916FF4583577B182D9BF60CF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
        <20191010173246.2cd02164@cakuba.netronome.com>
        <DB3PR0402MB3916284A326512CE2FDF597EF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Oct 2019 00:38:50 +0000, Anson Huang wrote:
> > Hm. Looks like the commit you need is commit f1da567f1dc1 ("driver core:
> > platform: Add platform_get_irq_byname_optional()") and it's currently in
> > Greg's tree. You have to wait for that commit to make its way into Linus'es
> > main tree and then for Dave Miller to pull from Linus.
> > 
> > I'd suggest you check if your patches builds on the net tree:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> > 
> > once a week. My guess is it'll probably take two weeks or so for Greg's
> > patches to propagate to Dave.  
> 
> Thanks for explanation of how these trees work, so could you please
> wait the necessary patch landing on network tree then apply this
> patch series, thanks for help.

Unfortunately the networking subsystem sees around a 100 patches
submitted each day, it'd be very hard to keep track of patches which
have external dependencies and when to merge them. That's why we need
the submitters to do this work for us and resubmit when the patch can
be applied cleanly.
