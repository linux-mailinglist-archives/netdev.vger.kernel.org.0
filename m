Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280DED53A8
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 03:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfJMBDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 21:03:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34031 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfJMBDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 21:03:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id k20so611175pgi.1
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 18:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kj6eOXZz9GyQzhMyxuS7LgKCMI4y1lGlpAkLU4/acCY=;
        b=sh79YnuwBmmzt0+oeett/u6RA1B5Ow7WccpIoBrSKJt0nJlAcA4BubKO0ua7RqJlA/
         aCeege/U/RrMZZhfdhbN0Db6xzVqnzKaetqDlMlGR3pMCSpVdiFuioSuA57QpPEsLjae
         nmkGKqpMFOH9Ml0a8rE7XvulC/nt2adRvno34vMzzZd9aLN0+DaqZI9yO+jYCMnk7hAb
         sBmoNhTFEH+rKAcTkmSpCvcHDiQLOKAlSp4ffm2vZeNRqQflZ5tuEukfj8gF7igf+C36
         LbofJpYwihJlIVLkrG8GXB7JA5FIIKzS6b+zKHsXWIlrmMQ/DOstuj9z9jKto++tngU9
         VE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kj6eOXZz9GyQzhMyxuS7LgKCMI4y1lGlpAkLU4/acCY=;
        b=eyQ4h3+Q1xl80SrH6aDXac9omZDfLUpXmIDKFp0WVPRz5h0wmHDiXrZNukS/dGfVhZ
         oawjHQ0C300LqdifzxhiQ2s4QXMx1EnxtkO+hk4OUbBdgTgC98Rqu3nZOC1fTqxLW8gt
         tytX2kKd2g9wcXV8cxLWz2CMJ9SxcwPW7jeNgNLVKAV7u5fHsHvj3ALvmuv4vAyLKjoy
         MaT3BlWGDeDqpRvLnH0P+F55P5hOrZRXVCql4RjHRk6IcPqSI7d2PvwtRMjIFcTqC71z
         9OBXsds6e4bKsTmNVWxb0LSVW+WlDLATTeeeJF8AntmWiWUdnWK0Hy2r2prjPpoZ41w4
         BnnA==
X-Gm-Message-State: APjAAAU7HLa5qvG5tFEa3lj7d8W9L3qZg7ooDzrLEIo/k9FjkGMWUkG2
        CtrOOwXvDtBUiVrzZQWiuDW0Rw==
X-Google-Smtp-Source: APXvYqzWRhONGqr+742j1q1YF4UpoLk477iFpwGfBuVaqsKV6+n3NDsqxg3+RRJkvkuIdACsB32QpQ==
X-Received: by 2002:a17:90a:fb92:: with SMTP id cp18mr27517836pjb.2.1570928624428;
        Sat, 12 Oct 2019 18:03:44 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::2])
        by smtp.gmail.com with ESMTPSA id q76sm29768368pfc.86.2019.10.12.18.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 18:03:44 -0700 (PDT)
Date:   Sat, 12 Oct 2019 18:03:40 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Anson Huang <anson.huang@nxp.com>, Andy Duan <fugang.duan@nxp.com>,
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
Message-ID: <20191012180340.57e5fbfb@cakuba.netronome.com>
In-Reply-To: <CA+h21hpp5L-tcJNxXWaJaCKZyFzm-qPzUZ32LU+vKOv99PJ9ng@mail.gmail.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
        <20191010160811.7775c819@cakuba.netronome.com>
        <DB3PR0402MB3916FF4583577B182D9BF60CF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
        <20191010173246.2cd02164@cakuba.netronome.com>
        <DB3PR0402MB3916284A326512CE2FDF597EF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
        <20191010175320.1fe5f6b3@cakuba.netronome.com>
        <DB3PR0402MB3916F0AC3E3AEC2AC1900BCCF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
        <CA+h21hpp5L-tcJNxXWaJaCKZyFzm-qPzUZ32LU+vKOv99PJ9ng@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Oct 2019 12:55:20 +0300, Vladimir Oltean wrote:
> > > Unfortunately the networking subsystem sees around a 100 patches
> > > submitted each day, it'd be very hard to keep track of patches which have
> > > external dependencies and when to merge them. That's why we need the
> > > submitters to do this work for us and resubmit when the patch can be
> > > applied cleanly.  
> >
> > OK, I will resend this patch series once the necessary patch lands
> > on the network tree.  
> 
> What has not been mentioned is that you can't create future
> dependencies for patches which have a Fixes: tag.
> 
> git describe --tags 7723f4c5ecdb # driver core: platform: Add an error
> message to platform_get_irq*()
> v5.3-rc1-13-g7723f4c5ecdb
> 
> git describe --tags f1da567f1dc # driver core: platform: Add
> platform_get_irq_byname_optional()
> v5.4-rc1-46-gf1da567f1dc1

Ack, you raise some good points. AFAIU tho, in this case broken
patch, the dependency, and the fix are all targeting 5.4, so there
will be no real backporting hassle, while the presence of a Fixes 
tag makes it clear where the regression was introduced.
