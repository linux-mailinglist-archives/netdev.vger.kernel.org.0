Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5153624243E
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 05:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgHLDTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 23:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgHLDTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 23:19:51 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDF3C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:19:51 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id p13so459053ilh.4
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u79Zq91KtrjKfL0kJU26Yc3K3AnjeKSesBGDqgFPedc=;
        b=fJojYJrVFM6h92HNB/yfIAS5yhx/fxBn4lPO3d5s9LnO6lESDttpWhxMhlqDannOxZ
         pqknJlRlfjxWl1H5sztBErWTrj04Zw0BW5QN1huCYPJBcv7ig/HiOuvhNz54mmmYOWTV
         9sPP/2QDNreKnba+KZrSMObAx+3q1PbTAAWhn+Vy4sbvy4xoy8zNSVb/tvSnIpQH5WJM
         t4EXPohE3qsDfpmMe63Q/j1sIYjWX16FK8XnqeCfy2V5rClkZmjCsjhHkykvL3VPiE+U
         Z0+o9ymkfIICeVSsmIt+GQQIhSP50lEj0r+TPyupGz1Bnoz9nZDFlnxxvKad3aFXzKiz
         AcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u79Zq91KtrjKfL0kJU26Yc3K3AnjeKSesBGDqgFPedc=;
        b=taqnPj4rzvF8BKRTDWrwx4wu5JRQfBGx/WxbEkwY9Km3OF0R5UViWISdHjaMqKz6wR
         PrYTBRs8YFyeXXA/BFSbK6lFfu52VLVJO+88o91Wsjl+4v5/b8bg1G6Qmwp/14zBjs6V
         JZIIx1MzFA1xkI8yoOHqpNntqpE3KpvCjg1BsBtAoGfL/4GjDIn2o8Dx6omR657Xn0XQ
         sC7GwHVs6v9rM9a4XnAxe+X34dPDLx1zUFyYOzbI7Wq0j+ybEyQHLf32IgQEC8lioXTN
         2JPYgrAU/QKyosPv4FkOyCAajVFYn5Iy/cF03A6pxfw43BM+GCcjyyHU/XyiHG2PdYRz
         Tj4A==
X-Gm-Message-State: AOAM532Sw+sSDrwDsCadxK7Oc7wjr+vxC3EKV4N7TobblVJtFDkndqk8
        W8mIpBaqLXTS15Vum1EIebBn7Nhet/gxS68WqtUSew==
X-Google-Smtp-Source: ABdhPJxknfXbAMz2K5jHsswNww+KndNvGeubKIfAdnVAu8lZgxJD9BtRhAHnclot26oFuS3mB7VMU7Z+YJj1HzqeaOY=
X-Received: by 2002:a92:980f:: with SMTP id l15mr17037239ili.56.1597202389210;
 Tue, 11 Aug 2020 20:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200812013440.851707-1-edumazet@google.com> <5b61d241-fedb-f694-c0a1-e46b0dedab66@gmail.com>
In-Reply-To: <5b61d241-fedb-f694-c0a1-e46b0dedab66@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 11 Aug 2020 20:19:36 -0700
Message-ID: <CANP3RGevbWwJ-oEmSjoC6wi1sUNtt6fqvE=sS8mTLnknNVMxJQ@mail.gmail.com>
Subject: Re: [PATCH net] net: accept an empty mask in /sys/class/net/*/queues/rx-*/rps_cpus
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alex Belits <abelits@marvell.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before breakage, post fix:

sfp6:~# echo 0 > /sys/class/net/lo/queues/rx-0/rps_cpus

With breakage:
lpk17:~# echo 0 > /sys/class/net/lo/queues/rx-0/rps_cpus
-bash: echo: write error: Invalid argument
