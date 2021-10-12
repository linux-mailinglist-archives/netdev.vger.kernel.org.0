Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F8342A0E8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 11:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbhJLJXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 05:23:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235386AbhJLJXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 05:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634030457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQvvX7DYevVvifiKrUIFSDiboyiIsSpy6G0Ys71FCOg=;
        b=c/qUJUm23gubkCjkKaJTg0BJoNmbmO/zqoqec20IGXYP3x5gtxnGqgbdn1WPt1jjsOy3nJ
        xoxz4yCVncxZ/nJtPA6Z2MFMYlP6PvogEXXR1pSwklIcT1w2d3SBZOGkPxL16tBOggIz4r
        r9TWaDid2L5PdXKPWrVuQIkrnWu4kIM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513--xYDd7-vNtaIAZ_GZ0nwjQ-1; Tue, 12 Oct 2021 05:20:56 -0400
X-MC-Unique: -xYDd7-vNtaIAZ_GZ0nwjQ-1
Received: by mail-wr1-f72.google.com with SMTP id a15-20020a056000188f00b00161068d8461so4927997wri.11
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 02:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NQvvX7DYevVvifiKrUIFSDiboyiIsSpy6G0Ys71FCOg=;
        b=DhNCSGzwhoDFDSO8FIhr+lVg5tGSF+KBIjJeQun6RVvOzzwNWmSWRtI2Z6vBsG57VO
         bUM5nMvx/FXoB6YSYCsVH1SYggRRFcGdlKFFP1QgdcnxSFA1GtGOaujMN1SBh78dDxda
         69R/sfr8upVrz2c32M9Zoyo5O/aDBaOsTRkmiFrvq2MUi39RHP+Z5IjhREmnDTqu2y9k
         xyLfJ0X8av09YHJYLJdF0SGnSG22pJFiXjWMOkf100D1cwU2MM7XmTlh9GTj9ETbPozR
         qFdQ/RlSEvq/+iFLkvxysrbhRsgzTn2bQIowPzYWfJM2XPGiJHKkHgg5d2i9yi+JhDLN
         If7A==
X-Gm-Message-State: AOAM533tQADNts38gQfcBvJ1CTepwQyZB3yYXR10P5ry2vUQg/J9uakj
        Xwi8dhHFXayaDJO9JrZoc7bykR02Ug3m/kTDY/a2IeFn6pcE5ZGlCPAo7Z+YHce/jZ/2LjwGqMK
        HYMdGgI5b+mjbW+7x
X-Received: by 2002:a1c:a9d5:: with SMTP id s204mr4267003wme.193.1634030455616;
        Tue, 12 Oct 2021 02:20:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywk9hzf7x2/zkP49ad7b+yMh+89MNX7bHIg+1V/CfDIKZ/l9tK1gZVUSfBDowQDZu+/gW3aA==
X-Received: by 2002:a1c:a9d5:: with SMTP id s204mr4266983wme.193.1634030455431;
        Tue, 12 Oct 2021 02:20:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-231-16.dyn.eolo.it. [146.241.231.16])
        by smtp.gmail.com with ESMTPSA id p11sm2137819wmi.0.2021.10.12.02.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 02:20:55 -0700 (PDT)
Message-ID: <b6441514ee17eb12934dad304854939308f5c4c1.camel@redhat.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in veth_xdp_rcv
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+67f89551088ea1a6850e@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date:   Tue, 12 Oct 2021 11:20:53 +0200
In-Reply-To: <20211011164747.303ffcd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <000000000000c1524005cdeacc5f@google.com>
         <20211011164747.303ffcd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-10-11 at 16:47 -0700, Jakub Kicinski wrote:
> CC: Paolo, Toke

Thanks for the head-up! will look at this soon.

Cheers,

Paolo

