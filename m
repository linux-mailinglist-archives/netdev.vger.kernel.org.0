Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3075B35CEE1
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbhDLQve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345637AbhDLQrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:47:40 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30FFC0610E3;
        Mon, 12 Apr 2021 09:42:02 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id w8so13941995lfr.0;
        Mon, 12 Apr 2021 09:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=DmUEYaWbsAlR+VYhVgl0qhMHR79e89X0qZWa+1dURuI=;
        b=OwwF0d5gKiPn94Gi8YtvHotVZxBa6/bCbLbig48/n4GX6hDvPHu+e9W3Hd0Nubbt7f
         iS87rCkk+3vHISmhMlfTTL3HiQaqk1Q3RniZML/O4LlpsnYplRF2w+KdYTt5GhTd3Siy
         WzzLeNdrfyXXNF7rdMRTcxguAMyYNtx9j7J2oGYriWZgK2P3odtHNTIstQ9tqoHQl+AJ
         5VbBe7rxCuERkMgo4e6TNxxfqIB/KvCLFh+N0LRJv1Ag42sbd8RuQvID+/nr4XhQfOn3
         itwOmIjBsFXwCx2pgMjlGJTg6XVii5ccpY3Qv3GasP0DJfudIiDnJpo2jeZ5nAAueFJH
         Fi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DmUEYaWbsAlR+VYhVgl0qhMHR79e89X0qZWa+1dURuI=;
        b=pFfr9Mz4Z4cFFEKE9im6uXCAUdr/rK7STHQTaNK0UAO2RYGgW8/vTGRDYCLTfC3UNL
         SJxtORrYLxI7m9X+OtPjoicNvtWtrsaMQz/RZJZwds/LdpNDIvC9xVAt3vIQkBxX00uK
         Mwp/t4Rhuq9/vT8XhjJNgBjxnnXVMERB5ZexqRyDJiMTRUpupSJE34W2qw8KBqbckSH+
         RDtKQYW7F3sooEyt93jpGSrtMOkrifTYxvR9nypCl8iiikHIIumXcOUBYCfrgLeszAu8
         eYtwk7KHjmaqpjzyj2wYQ0iyL3k+T4JElnBUmoOcba4F2gEVNaPcJyWxzgUV165Zp3nw
         rLlg==
X-Gm-Message-State: AOAM533zNH1UrYgX6kZdop18QcJ6kqwM4B8c5TxnihcZyxSQuYPJ+xen
        qQSvAfzCyWPwQCsTUM0X8Bo=
X-Google-Smtp-Source: ABdhPJw8vslTv3+VDRDH84DU9lTPyMzGBa2PuNznZmKZ0YjMwf68SPcqveSEVnaykL7QSD+/OcSQSQ==
X-Received: by 2002:a05:6512:31ca:: with SMTP id j10mr20125220lfe.459.1618245721495;
        Mon, 12 Apr 2021 09:42:01 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.90])
        by smtp.gmail.com with ESMTPSA id q25sm1434770lfe.163.2021.04.12.09.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 09:42:00 -0700 (PDT)
Message-ID: <dd04fe4401f5e516885798541b6ebb5b0e40892b.camel@gmail.com>
Subject: Re: [PATCH] net: mac802154: fix WARNING in ieee802154_del_device
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot+bf8b5834b7ec229487ce@syzkaller.appspotmail.com
Date:   Mon, 12 Apr 2021 19:41:58 +0300
In-Reply-To: <CAB_54W7R6ZmMQQPscc04PhJsGu_uoaVqVx=PAiLrqb4nZqTWzw@mail.gmail.com>
References: <20210412105851.24809-1-paskripkin@gmail.com>
         <CAB_54W7R6ZmMQQPscc04PhJsGu_uoaVqVx=PAiLrqb4nZqTWzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Mon, 2021-04-12 at 07:45 -0400, Alexander Aring wrote:
> Hi,
> 
> On Mon, 12 Apr 2021 at 06:58, Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> > 
> > syzbot reported WARNING in ieee802154_del_device. The problem
> > was in uninitialized mutex. In case of NL802154_IFTYPE_MONITOR
> > mutex won't be initialized, but ieee802154_del_device() accessing
> > it.
> > 
> > Reported-by: syzbot+bf8b5834b7ec229487ce@syzkaller.appspotmail.com
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > ---
> >  net/mac802154/iface.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > index 1cf5ac09edcb..be8d2a02c882 100644
> > --- a/net/mac802154/iface.c
> > +++ b/net/mac802154/iface.c
> > @@ -599,6 +599,7 @@ ieee802154_setup_sdata(struct
> > ieee802154_sub_if_data *sdata,
> > 
> >                 break;
> >         case NL802154_IFTYPE_MONITOR:
> > +               mutex_init(&sdata->sec_mtx);
> >                 sdata->dev->needs_free_netdev = true;
> >                 sdata->dev->netdev_ops = &mac802154_monitor_ops;
> >                 wpan_dev->promiscuous_mode = true;
> 
> yes that will fix the issue, but will let the user notify that
> setting
> any security setting is supported by monitors which is not the case.
> There are patches around which should return -EOPNOTSUPP for
> monitors.
> However we might support it in future to let the kernel encrypt air
> frames, but this isn't supported yet and the user should be aware
> that
> it isn't.
> 

Thank you for your feedback. I am still not familiar with net internals
yet :) Next time I ll try to go deeper. Thanks!

> - Alex

With regards,
Pavel Skripkin


