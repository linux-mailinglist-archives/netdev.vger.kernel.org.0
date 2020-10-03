Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F32E2825E9
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgJCSnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 14:43:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbgJCSnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 14:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601750601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HWM0RfrM0HZAs25gIGx3NLfFo36RAwB9ram8EBWXtH0=;
        b=NzL8+jxeAT74Xoye5npss0OvEUdXZQIqDGyUesVHTbcMOakxAgGGW0EhLyybungMtHp5r9
        n9aO2gLq03wr+xNYAtifB7yTHUJFgmCtRiL94hZqJOldVnZMFhIg0NIys/VRfJKKkGhCcA
        2urgq237/GVFZlc/1+JvIyldM5ZApXw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-H_h_rk79NR2ClrtGZtblGg-1; Sat, 03 Oct 2020 14:43:19 -0400
X-MC-Unique: H_h_rk79NR2ClrtGZtblGg-1
Received: by mail-wr1-f70.google.com with SMTP id d13so2040308wrr.23
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 11:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HWM0RfrM0HZAs25gIGx3NLfFo36RAwB9ram8EBWXtH0=;
        b=PfAQaZvEHo2/dZC/rzcvYPV+EaKSLRi2sh/xgpkrbZsWvWFGgfbNHhgt/M5tju0QSg
         rQqqFFWkgyxppSTCzy6lBkOIvQr5Drx8SvOSfFCMv4nhQNjCMjvu/G5U7fPfqZBkdT//
         u5/ZhfGODazPI2OUdcNncsGs7acXR/M6lbZnOAg+xc1bcQuwVAnAPOgxmKi5Jls432Wi
         1o17kSVrc0Ocuwu6vrWYYBIQ9GL/IoYVuaviefNpuEIIYJQzSpUd1P2LjybHnv7VSq+V
         H4+wMFs6oSm1/+DAv3+zU92tU6SOKwgj6M1Ri5yARJvzml12rGi3wlTulUc0mSDOroHM
         WxOQ==
X-Gm-Message-State: AOAM531JoZ4y3EYc0AAFQ2NoXdKGL8T4Xl0kksCalQUa8TvfXvFDtDWc
        sKHIP3xevMim0A3NFz0wO031p1FX+unBzSKtC0YEuh8EpkUkDYoz3/so2F+XGbgv7Eeo+XPJ5rs
        zCFWkgpciaTG0k77T
X-Received: by 2002:adf:e852:: with SMTP id d18mr9744710wrn.40.1601750598430;
        Sat, 03 Oct 2020 11:43:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy038Yccnpob9//W8sOr1lm3wbsl6dgaQoAhcFw98vUjFVu1T3n44Gs2WlgxSmLiPyyNgs9bw==
X-Received: by 2002:adf:e852:: with SMTP id d18mr9744690wrn.40.1601750598224;
        Sat, 03 Oct 2020 11:43:18 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id z127sm6091271wmc.2.2020.10.03.11.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 11:43:17 -0700 (PDT)
Date:   Sat, 3 Oct 2020 14:43:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     anant.thazhemadam@gmail.com, jasowang@redhat.com, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [Linux-kernel-mentees][PATCH 0/2] reorder members of structures
 in virtio_net for optimization
Message-ID: <20201003144300-mutt-send-email-mst@kernel.org>
References: <20200930051722.389587-1-anant.thazhemadam@gmail.com>
 <20201002.190638.1090456279017490485.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002.190638.1090456279017490485.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 07:06:38PM -0700, David Miller wrote:
> From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> Date: Wed, 30 Sep 2020 10:47:20 +0530
> 
> > The structures virtnet_info and receive_queue have byte holes in 
> > middle, and their members could do with some rearranging 
> > (order-of-declaration wise) in order to overcome this.
> > 
> > Rearranging the members helps in:
> >   * elimination the byte holes in the middle of the structures
> >   * reduce the size of the structure (virtnet_info)
> >   * have more members stored in one cache line (as opposed to 
> >     unnecessarily crossing the cacheline boundary and spanning
> >     different cachelines)
> > 
> > The analysis was performed using pahole.
> > 
> > These patches may be applied in any order.
> 
> What effects do these changes have on performance?
> 
> The cache locality for various TX and RX paths could be effected.
> 
> I'm not applying these patches without some data on the performance
> impact.
> 
> Thank you.

Agree wholeheartedly.

-- 
MST

