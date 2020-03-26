Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558CC194139
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgCZOYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:24:48 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]:43095 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgCZOYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:24:48 -0400
Received: by mail-qk1-f174.google.com with SMTP id o10so6513814qki.10
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 07:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FawNfbhTNFlqgEKikXkcncuYy5KV1ryJEyorEMU2PEs=;
        b=d3MhLlHGs6GCAxE2JRYxCCuHw3WTOt16RmM7ERacpBEPNfL8ACswpAat8Igju6+jBn
         6lJhFtPq5E1AORRIwRyfWACS0NnTjZdV8C9Mqj5wQ/2WAowHVSWcVkfbWgVKJVo+P8Ys
         H+fnS8j317C6geubV73IpIyrzykHoFS3+pBXj5KFvcRxWEIL6tXHSlaQpehMdIzwFZIo
         pdE4rY2h2GMHC2qM+vFMMQ6MF4nsdF+lscb8NWYW4EJK0jAclcO9Wk+o90SgK6RVqkdb
         xxd3vc77TGhWMdISX3Z6ejTwZIbNtPE2ehsv8Ks0zDapeXnLBDBfWlIutH/JCn2YyyeB
         jaRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FawNfbhTNFlqgEKikXkcncuYy5KV1ryJEyorEMU2PEs=;
        b=s8PJXAkDBbbS9ue+cVcXLKqVYf+3eToP9AlMTrCmKIItxR+LJF1xOH49xke/7lgHje
         c0CwCVkjGaE6/gTE+I5UEmr+Nnq41xrxwXzBcL421F15vJ5Oe1pS+izyxONGwg/LVc6p
         FNWdBWhxgMtNMpyjA4ksGCNwN4ecx5O4vCH+nTWwvIL1Qag7LBz7Lv9ZICctQZ/YlLlW
         1EEkRuu3CTb8qB3CHwvHeIGreBKQxY2ptm6ecpWtsxaCM+JOhBvqMLcZqjCpLhRXZgzC
         atUhK4EFHOqD7oy2kd3i4hqP0ClLEZy7Ocbyhe7UpCvmV2IRGtbSh39L9adTCwJuyew7
         vOFg==
X-Gm-Message-State: ANhLgQ3R9bENV9dNBu1dmieOtuIXGJOFvFlSSyokspv0qWueLveCKi5L
        Nhxz2Olnqox6oB738aTPM9glq7ZBYGfYzrVrhC+CQSepsqm29g==
X-Google-Smtp-Source: ADFU+vskKO5INSP9emvFx8CHZJHnxWiJj7cKM3C7CBDyZoijoihv1iIwUQLYOHRQAQir8f6J/ZkvEK4MUM0WBhM0buQ=
X-Received: by 2002:a05:620a:109c:: with SMTP id g28mr8206722qkk.409.1585232686875;
 Thu, 26 Mar 2020 07:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
 <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com> <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
In-Reply-To: <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Thu, 26 Mar 2020 15:24:35 +0100
Message-ID: <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Mar 25, 2020 at 6:43 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > Are you able to test an experimental patch attached in this email?
>
> Sure. I'll compile new kernel tomorrow. Thank you for quick patch.
> I'll let you know as soon as I have anything.

I've compiled kernel with the patch you provided and tested it.
However the problem is not solved. It behaves exactly the same way.
I'm trying to put some printk into the fq_codel_reset() to test it
more.
