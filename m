Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B3213B710
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 02:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgAOBjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 20:39:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728848AbgAOBjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 20:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579052339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tKAaW9zZdUMl/X3Y3pjw/ZQo39z5yYT+FqpKcVm7um0=;
        b=XUaITklwCOL4g4eli2HMhR3qh/A3s87JhnmoLW2Qk2mrnoYqR02nTvmVRQD5dMvV+1gF/8
        eIYV0XFzPpM2l/m78ZNUYEq8FYu94aVnCUZeckcl3QIPnThIlCnN3diMVYbmITCy8Nfxu6
        CbSi+ry0N4K7WNl/53+JSgEN/Eej4u8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-siZM8M5iMvebyRAuej__5g-1; Tue, 14 Jan 2020 20:38:56 -0500
X-MC-Unique: siZM8M5iMvebyRAuej__5g-1
Received: by mail-lj1-f199.google.com with SMTP id w6so3537900ljo.20
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 17:38:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tKAaW9zZdUMl/X3Y3pjw/ZQo39z5yYT+FqpKcVm7um0=;
        b=F0uY8lGQAHmlT3OI2WTHMgIfMiLDj5lT34toc2uZwK1LMnWYSdWvISpR+ECUnOhi8L
         XyCABwwYV134tIvqyu0IEmt3/GOyxXPdAo6tTpzkFuYxryfZPoT0k7eBgSCvLAq/r9cT
         f2PNcw5Fj1+U4+0VHvf9YkTGd9j4+PpAjINGJFSlmiYfhjlvxWrrh2JoCOcmJ4Z4HlJz
         Bq2NlbbNyvP4drTGESFyjtNf1zcyplqD/6EXBTnzuU/oNWMxLS3h02mh+7O6AHFtWkXj
         ODgqWmYHcSF5f6JF6xmXbRa1PujzTn6WaqtCMn8e4YhN2e8kZGW5FjnTC9YnUQ/jfyrF
         5lbw==
X-Gm-Message-State: APjAAAUjV3wr36e4OzAvgMojMHWIOQcQee8tES9jZ6rIuAx5O+iaW6Lq
        OGwPcgqAyrM9nF5IEKWXIVLi72y0pU79ugR8FQuQc69FQPIC7qmf7c3x8tQEqmGSx8jXCEpMfi1
        BNNWxGvYEzLLQqrsKZA+UnT5AhBtSiwqM
X-Received: by 2002:a19:7b0a:: with SMTP id w10mr3377267lfc.90.1579052335136;
        Tue, 14 Jan 2020 17:38:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqyFhjtMseR79v7q/Eg5U9N3mVbSf8BTAvP7lU726oSG9hQGqArNrmISIkV1ZElFaRLedJer5eiLVEpDwosHrzY=
X-Received: by 2002:a19:7b0a:: with SMTP id w10mr3377259lfc.90.1579052334976;
 Tue, 14 Jan 2020 17:38:54 -0800 (PST)
MIME-Version: 1.0
References: <20200114210035.65042-1-edumazet@google.com>
In-Reply-To: <20200114210035.65042-1-edumazet@google.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 15 Jan 2020 02:38:20 +0100
Message-ID: <CAGnkfhx-V2xrRCbyjzZtiap0-gqQ+nDvf2E-5mRFZM8LVQLqWg@mail.gmail.com>
Subject: Re: [PATCH net] macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jurgen Van Ham <juvanham@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 10:01 PM Eric Dumazet <edumazet@google.com> wrote:
>
> I missed the fact that macvlan_broadcast() can be used both
> in RX and TX.
>
> skb_eth_hdr() makes only sense in TX paths, so we can not
> use it blindly in macvlan_broadcast()
>
> Fixes: 96cc4b69581d ("macvlan: do not assume mac_header is set in macvlan_broadcast()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jurgen Van Ham <juvanham@gmail.com>

Tested-by: Matteo Croce <mcroce@redhat.com>

-- 
Matteo Croce
per aspera ad upstream

