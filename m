Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217D147C329
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhLUPkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:40:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235102AbhLUPkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:40:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640101201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d7lxfq0zXNvxkUIbEo8pSPlfw4MCEj6zU59W7tji/QA=;
        b=T5kt1sYO4MFBSUcHxeZEXl7j0jKJk6vUv8Dzvdi2xBU1kNE4QmGrP4j+hbOTtnKFX+eYHm
        SFcDRLv59Hv92JEnMWuUms58zQhyUvdiGUL3rU82EQ19g9VnCIGmZ+cSUfjfeAgzG4Bhc/
        Rk1p8bWWJXqXEGmkyJyTocCYrRKS06I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-iVKfgLQhPYyUMw5XfJUqHA-1; Tue, 21 Dec 2021 10:40:00 -0500
X-MC-Unique: iVKfgLQhPYyUMw5XfJUqHA-1
Received: by mail-wm1-f69.google.com with SMTP id n31-20020a05600c501f00b00345b15f5e15so914439wmr.3
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 07:40:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=d7lxfq0zXNvxkUIbEo8pSPlfw4MCEj6zU59W7tji/QA=;
        b=kBGGNaAk1uKcswqMOaHWrzqHNuA97V9VEsmir1mlrCHYK+THD34XbpHgZg4r3PjkFp
         xiInhOt2ODZ0XrN6AxK9HV/dNtzhXaip1PSn5knUXj7M/G9aUkY1fkzNfSgdC7O0lJ+1
         32+tCahxJ/Fza3ffF4q5omDa6SfT3D89Bp+oNV4PIAiFyZQXTttB91cZe5Hy5JufOyrz
         1348kcoFjZNa+v5ykSL7eZq/dR7Wv6svHgTEuEWmXkAR6fLN50Sm9zih6pBb/aOw/LED
         iSRQTOxmdeOubtcEk8euuaAmYoS+A56L2XFxULZrz65n2nZkVDTFvgcyseOiN/JJF/DU
         eB3w==
X-Gm-Message-State: AOAM532Na6Mhimnq8NR+VHKy9ZSiAf37IJlbAoQKlA+p8WsiiGW9PqOZ
        5h/NbS1pbDZrXFY8he8vX29h3KJDa5Eo1EeOofbHoizPsPx4TINcuMUVXNxMASnHa7fEfHQOMyW
        hld7rxDbzmyePl0/3
X-Received: by 2002:a05:600c:3844:: with SMTP id s4mr3227463wmr.124.1640101199157;
        Tue, 21 Dec 2021 07:39:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKiz0PUn7JldpNtOSqIYz+i+4cHejVtpU8b70SjUTwMA45GlmTGfk8whKl/9/xudBW1AM+iA==
X-Received: by 2002:a05:600c:3844:: with SMTP id s4mr3227450wmr.124.1640101198987;
        Tue, 21 Dec 2021 07:39:58 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-225-60.dyn.eolo.it. [146.241.225.60])
        by smtp.gmail.com with ESMTPSA id z6sm3332892wmp.9.2021.12.21.07.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:39:58 -0800 (PST)
Message-ID: <cf25887f1321e9b346aa3bf487bd55802f7bca80.camel@redhat.com>
Subject: Re: tcp: kernel BUG at net/core/skbuff.c:3574!
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        Ignat Korchagin <ignat@cloudflare.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Date:   Tue, 21 Dec 2021 16:39:57 +0100
In-Reply-To: <CANn89i+CF0G+Yx_aJMURxBbr0mqDzS5ytQY7RtYh_pY0cOh01A@mail.gmail.com>
References: <CALrw=nGtZbuQWdwh26qJA6HbbLsCNZjU4jaY78acbKfAAan+5w@mail.gmail.com>
         <CANn89i+CF0G+Yx_aJMURxBbr0mqDzS5ytQY7RtYh_pY0cOh01A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 06:16 -0800, Eric Dumazet wrote:
> On Tue, Dec 21, 2021 at 4:19 AM Ignat Korchagin <ignat@cloudflare.com> wrote:
> > 
> > Hi netdev,
> > 
> > While trying to reproduce a different rare bug we're seeing in
> > production I've triggered below on 5.15.9 kernel and confirmed on the
> > latest netdev master tree:
> > 
> 
> Nothing comes to mind. skb_shift() has not been recently changed.
> 
> Why are you disabling TSO exactly ?
> 
> Is GRO being used on veth needed to trigger the bug ?
> (GRO was added recently to veth, I confess I did not review the patches)

This is very likely my fault. I'm investigating it right now.

Thanks for the head-up.

Paolo

