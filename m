Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3E234F5F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFDRz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:55:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33505 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFDRz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:55:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id h17so10807968pgv.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pmpjn4DS/OF19a7rZnvBUz7VafwUTdxQqXsLEBKSy/E=;
        b=ZTGwJpmjYoSjMoPs6HnVVchj1ORJ7CxrjkWntgz/DtvBJrS9Rukj/VyMkyoGcroB3m
         4Pzb8EiPvZ47pKSSuQS7TpHbAe7Q1SefV9X8KQX1WzEEj7SNZlsY4jXn2zPPid9EMDy5
         NhIUYD5mu45qn/8CmJ45p6gax/S4S1SdeBtm/R6PWi5QmlVdx7YFWwFbYslUI4LV0CHq
         DO189lzsSUUxBvjOgA3EjW6BM4+HbyJhBHGKsLi/G8ABT+Z4Al+A0cpmaSLxeX29ryG+
         SFJyMDKZCxslY3moQaGvRAj2Y8aRJlCqRZzAv/w/5hsWm/dCQHugEs45jfafqFLt5UZV
         M45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pmpjn4DS/OF19a7rZnvBUz7VafwUTdxQqXsLEBKSy/E=;
        b=Zsf8rn8izJTXx6N66jliRWmJweQ9mtG17wfyH4PQ4JFZyhT6rvJXaWPPrmyPyZT3my
         oBy7+nmOfcKbsi+SjX70N4btoMGUI8wBsE1HdjdVi2AeHt8YBcKSpeYctV0/eOAqBDAg
         ePkWw+8nEiglqWudmoQQOmn7rZIQD0d+4bKaUQGPO3Oa2d1uMwHl82DuBOPRgCpjgr6q
         f9hF/srd4kTcVYSQeCT5FGTBicVvh77U7GONyW6sARJEzDdXFcWaP2VesTYuNOftTQ9w
         puvcwyaf9e6bXZ2tLF+7e3kl/zvlQ3oqI8v/rU+Pq0ETfx52YoXChVQeNcJnV2gygses
         0iEQ==
X-Gm-Message-State: APjAAAXuHuIuIxq2ld/wgtS+MSVUEw+d0IrEVhnN8f36AnaDVXDWUwto
        RcTBEkTD//DrgLPNB/uYtuQPApCsCiQvwvyfY80=
X-Google-Smtp-Source: APXvYqyXl8RBJ8MiTImBwJkHgAPi31QAft44LwKynGt903mOTVSNwL0/G7z2qTZ+pBqaEeSouNzZnoPjj8NbKq8k+uk=
X-Received: by 2002:a63:8bc7:: with SMTP id j190mr16246821pge.104.1559670925360;
 Tue, 04 Jun 2019 10:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559322531.git.dcaratti@redhat.com> <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
 <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
 <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com> <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com>
In-Reply-To: <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 4 Jun 2019 10:55:13 -0700
Message-ID: <CAM_iQpXsGc2EpGkLq_3tcgiD+Mshe1GvGuURwcmeBEqpmQaiTw@mail.gmail.com>
Subject: Re: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
To:     Eli Britstein <elibr@mellanox.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 1, 2019 at 9:22 PM Eli Britstein <elibr@mellanox.com> wrote:
>
> I think that's because QinQ, or VLAN is not an encapsulation. There is
> no outer/inner packets, and if you want to mangle fields in the packet
> you can do it and the result is well-defined.

Sort of, perhaps VLAN tags are too short to be called as an
encapsulation, my point is that it still needs some endpoints to push
or pop the tags, in a similar way we do encap/decap.


>
> BTW, the motivation for my fix was a use case were 2 VGT VMs
> communicating by OVS failed. Since OVS sees the same VLAN tag, it
> doesn't add explicit VLAN pop/push actions (i.e pop, mangle, push). If
> you force explicit pop/mangle/push you will break such applications.

From what you said, it seems act_csum is in the middle of packet
receive/transmit path. So, which is the one pops the VLAN tags in
this scenario? If the VM's are the endpoints, why not use act_csum
there?

Thanks.
