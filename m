Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A09BAC49
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 03:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388556AbfIWBAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 21:00:15 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38958 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbfIWBAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 21:00:15 -0400
Received: by mail-oi1-f194.google.com with SMTP id w144so6213114oia.6
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 18:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1C/4G/4KI1ZmCJbMoEyYTd0tEbLYYitIesgy+1qUaZA=;
        b=EYL4df32vrOSsAosHCvlHmiloua34TDkCUFCL1In28oY3UFu2TprTDNcuG/88Vzl8g
         QzBU5V6Ma+Cg1QUKru8T4C2d9oRchMvYf1axH3yAQEBOwdPYfVQQHcpKzLa5Genbu2PM
         l1CidXCXfM0WoWqSul2H/Bpj+5tG54eDb9pu4OuxxNgtl/u07u07rWhsLB4K8yzKps1W
         S6tBX/VkZ4FnjGjKChcnZB4Eocej4wm4VSJBaWYFKfhS0K8WS6MzhDJvJXQ0cUwnKCFd
         WrSDvWuNuSbxrEuiJ/g3Z2xcIvgYa0G3zGjWfCSHKWI7BWwyqCuEdsaXncvs/TfGJTrn
         HLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1C/4G/4KI1ZmCJbMoEyYTd0tEbLYYitIesgy+1qUaZA=;
        b=QJXdFNB+A5Bgk3c0Wy7ZNdTjFbyqgP5ida+oxh/5D+cuQ0076jK2hwMrsF/KhgNrLL
         jehqYn+Fpy7OpVdnvrWPhEswPvvv90P8cT/A1ynakmtOZLnA6mNsUc/UoRU3vYIvOvzN
         K5zZQTONQyF6UJXr2zUlxKrRhYo1OCALc3MVZxVc7ZG9X0Tea40aZdSRXqWCa6saGZKp
         atnZkHkXiytmc3+Ed0UPr+ouX+1TfcJYFRG9CPzAxXfKh5i3Feqz/0NULAeVuTfVd93y
         GIoKb1HjXLuZV0NRBE0o9ph+0r/FcawHEQhmycMw/NebNMK6qZnbsUZB6eaP5cevzp0j
         X3oA==
X-Gm-Message-State: APjAAAW7/Doh+Yo24J14TstZwJ5nUrtRGWytaQLaq0NObVqBMcPxhn3f
        8uYqUJy1QxThjy/m5bL2A3hbfv+PVRjRN8a8Hho=
X-Google-Smtp-Source: APXvYqyxEeBRh2TXA/CtLB5zl6QrCT3vado7JXPe+w9F2tKRmg32WEeOMnnjGlYnZUXC6qKHa1q8BOSXXpx8IOtidmM=
X-Received: by 2002:aca:da87:: with SMTP id r129mr11924559oig.177.1569200414279;
 Sun, 22 Sep 2019 18:00:14 -0700 (PDT)
MIME-Version: 1.0
References: <1568734808-42628-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_DONiJ7Z41xAm5DhkjcrXDrgu6XNpscw1qf592wdMH5bg@mail.gmail.com>
 <5d86ef21.1c69fb81.d4519.2861SMTPIN_ADDED_MISSING@mx.google.com>
 <CAOrHB_CeDqYw4WR2AmUS5TN93mGptgZN-KNjtNNnHxQa7DqZ-Q@mail.gmail.com> <5d8719a6.1c69fb81.fb123.2f76SMTPIN_ADDED_MISSING@mx.google.com>
In-Reply-To: <5d8719a6.1c69fb81.fb123.2f76SMTPIN_ADDED_MISSING@mx.google.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 23 Sep 2019 08:59:37 +0800
Message-ID: <CAMDZJNUXnPcJXjwjC1P28JBZEZpzhF5xvOZovyPNVShNd-6r9Q@mail.gmail.com>
Subject: Re: [PATCH net] net: openvswitch: fix possible memleak on createvport fails
To:     Hillf Danton <hdanton@sina.com>
Cc:     Pravin Shelar <pshelar@ovn.org>, Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Taehee Yoo <ap420073@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 2:50 PM Hillf Danton <hdanton@sina.com> wrote:
>
> On Sun, 22 Sep 2019 14:42 from Pravin Shelar <pshelar@ovn.org>
>
> >>
>
> >> On Sat, Sep 21, 2019 at 8:48 PM Hillf Danton <hdanton@sina.com> wrote:
>
> >> Was that posted without netdev Cced?
>
> >
>
> > I do not see your patch on netdev patchwork, repost of the patch would
>
> > put it on netdev patchwork.
>
>
>
> I did send it and you did see it, so no fault on your side and my side.
>
> Where went wrong?
>
> A bit baffled.
I did't not find your patch in the linux upstream, so I send my patch.
Please resent your patch and I hope you should add comment on the
vport->dev->priv_destructor = internal_dev_destructor;

To explain why you move the code here, that can help others review the codes.
