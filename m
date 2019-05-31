Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B82314DE
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfEaSmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:42:53 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37033 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfEaSmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:42:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id a23so6726122pff.4
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n0juzIkDdI11DFqyCTbZT/22xVt4E7SD4jFcq+LITLk=;
        b=GYXfYcsCPIvEYOvAixl4tDKGsYWTkt3cfQChLHIV3nQpiE+gZ5HRNrBo9UInsG+Ujq
         Vty5Nhuyq8PetN4QfFdyJrZyC8vPPSM14jZOdfMsZ2UxlEk51nEqs5iRIMo3aEhoFeDX
         zNJBI6nuapygNjnPgU6OozGqwkQGv+gym0Yuh2GFr1Xi0kswP/ONSkbId4Cevluha84e
         X1FW5IGXwI2yXa8w5jhRuVGISBw0dGZxGt68QlrnHIR/Wp+mLDSiRi3iFjsrhVsUYOTE
         yY4gwJv9+UR5Fu77nnxx5my0ufS8geT21cPj82MAPefDBA5d2sPUnzIJwS0XM5v5Y7M6
         QogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n0juzIkDdI11DFqyCTbZT/22xVt4E7SD4jFcq+LITLk=;
        b=kNZixLG1WPCt/f6otjET7h5hD1j8bPGz9+xQqBthpEWKhBrsla8HUCsEcurno6pNJU
         4m8HVm8seeTrAeWtAVqzftWhzYon0YtCqzW30LCE3W11JHgvCMHOEwtNzFzR0Wt7IzGS
         ze9HgoNgQc95qlIR3dBtYmGd5NNmjYaLtAdRv3PbJvKQa8FXyLCm8vHho59fWiQUh4Wf
         +96rPAR8rT7Uee5aKYsduizHP/42hISMK8HhnmvaKM6gXEoWBVQ3O974RuJOTsJgTKwp
         fKTDRGyFWDVqjMbqz+63ZG+IaOgOLPs7QDNIg5/LhwEd98mEWm5PZK8dEiNUVNNXa8+p
         7olA==
X-Gm-Message-State: APjAAAXw+3iXeYP7oxyvo8F1/ABmLR+TSB6aBL3IyWyL1rwkb5SMh2v0
        YgZ/aXDhcIgYVbc/rHCCajJdkbwQ18LwyNcHEVs=
X-Google-Smtp-Source: APXvYqxKHTzvo5+mq0Fa0P4MMyiOIAzIVW1jA0m1bkTMH0mTZOj0Jr93f3nONYyuGgRQXqG8kO5TLeJbKpIu9Ti8u1c=
X-Received: by 2002:a63:1d05:: with SMTP id d5mr10740776pgd.157.1559328172391;
 Fri, 31 May 2019 11:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559322531.git.dcaratti@redhat.com>
In-Reply-To: <cover.1559322531.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 31 May 2019 11:42:41 -0700
Message-ID: <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
Subject: Re: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Eli Britstein <elibr@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:26 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> 'act_csum' was recently fixed to mangle the IPv4/IPv6 header if a packet
> having one or more VLAN headers was processed: patch #1 ensures that all
> VLAN headers are in the linear area of the skb.
> Other actions might read or mangle the IPv4/IPv6 header: patch #2 and #3
> fix 'act_pedit' and 'act_skbedit' respectively.

Maybe, just maybe, vlan tags are supposed to be handled by act_vlan?
Which means maybe users have to pipe act_vlan to these actions.

From the code reuse perspective, you are adding TCA_VLAN_ACT_POP
to each of them.

Thanks.
