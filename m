Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C451130BC
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfLDRYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:24:16 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32969 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfLDRYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:24:16 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so199711pgk.0
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 09:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ta7sXADMoeMu5thVXdyfcOFD1YBnYCSzWzG4BUqRpA=;
        b=gIiW/DVgQ+/HjAeR+5F6AG3GLclCLyOqQhWG9nIMxfDfGpzENKB/AizJ09LhgQnjX7
         Tv7t63FljDeOD2I9Pov/5oPWVmOIjtRylEwuvodhCn8nS+wyJRspqHbgQttG57W6137+
         ofs9CLwgDgH5AZ8sO4Esl9x2F9Lungdkx9tgZqV3w6n3AAkNDeIPpmun1XG9UHkZQJm2
         IxWK/O84e4DDAwj1PLKXD5hOLP8P466JdpgDqLwU1+CPhXX8OtvuFoSiDahzEGS1SKL0
         BU8U38GVqujFyApWaismGAaAwFbB0cavOhxfamhaLsGVE2IfUZ4OHFcJKiiQHW8lrn9z
         2zYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ta7sXADMoeMu5thVXdyfcOFD1YBnYCSzWzG4BUqRpA=;
        b=uPcPuazqdS5adZjo3+spvu8i+32ZqD+wx3uUYkIF4/FgbSlNM3ZarVqwDcyDUxKWUE
         KqNZmPZuV3DoDO6uXEzoMhY1rPyDngskkMvQhWBsLDfKLhJN2QY33jafJUF8jfQ8T9nL
         BcDRubpvF7yaBcEv0/JvQYG8HPjT3hffU1cxPg9t1+L01vHS4Mxb0oHJNmPmZISRorlj
         rIsODH8ztt7IdbfSVV4rfCf4RN9g29Kzvoc15r/3LlN9hcC2zRr+s5cUa010+p4HKeht
         Ni0Foq1RbopEEy2qmwmOb/F2Tt/V4InB1utb/16ZSOZ0NkMUcdorv74fFCqcvafJVLbk
         L3Uw==
X-Gm-Message-State: APjAAAU+WdhbvOQNOJpypyw2BGg1bRwIzXtkJoyDeKf25euDc0nD23yX
        qMTnid2LuUHIsL6Oa5OkRGIvSOat4q7tBBIjWfQ=
X-Google-Smtp-Source: APXvYqzDWAVNIcfM5xvOCTNnnJxHRGvn42aG3hAC+yCbfEDF3mucBwfMcSkahpQjy/T6uUGDc2o1eIr3ZfRV5ihD/WE=
X-Received: by 2002:a65:44ca:: with SMTP id g10mr4720125pgs.104.1575480255545;
 Wed, 04 Dec 2019 09:24:15 -0800 (PST)
MIME-Version: 1.0
References: <20191130142400.3930-1-ap420073@gmail.com> <CAM_iQpWmwreeCuOVnTTucHcXkmLP-QRtzW22_g6QWM2-QoS5WA@mail.gmail.com>
 <CAM_iQpWYrFx-NbnHpHWmVaf7AoF3Zvi1s6i0Egsf7Ct064X0Xw@mail.gmail.com> <CAMArcTXO1Nd6g+3a=R83fFq=tWxbRdR25NAg92mrUUdYVkDsyw@mail.gmail.com>
In-Reply-To: <CAMArcTXO1Nd6g+3a=R83fFq=tWxbRdR25NAg92mrUUdYVkDsyw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 4 Dec 2019 09:24:04 -0800
Message-ID: <CAM_iQpXkXs_RKewfyTKiTi33CH5P-QjfegEhyQG3XuCfU-aetg@mail.gmail.com>
Subject: Re: [net PATCH] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        treeze.taeung@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 1, 2019 at 8:08 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > Does the following patch help anything? It just moves the list_del_rcu()
> > after synchronize_rcu() only for master port.
> >
>
> Thank you so much for providing the testing code.
> I have tested this patch, but I could still see the same panic.

Yeah, I think the RCU rule requires the "unpublish" to be done
before grace period. New RCU readers could still jump in after
synchronize_rcu()... :-/

IOW, checking NULL is the only way to fix it. So your patch is fine,
although the rcu_read_lock() is unnecessary, as the caller already
acquires RCU read lock. But it doesn't harm anything either.

Thanks!
