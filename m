Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739099D5F4
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 20:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbfHZSmO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Aug 2019 14:42:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35451 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfHZSmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 14:42:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id d85so12369024pfd.2
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 11:42:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=FEUQqpp1Zmdib1zcIn2Q5J462hbvEwGHWCNSVmJC8ls=;
        b=VEWQPmnxI3KQtsmaW22IYRBN6chGCPKIjaiUtyReIkiGW8TxEHmbIVHjClREUV9Rjo
         r3ITn5cHakUbzc3k1XD9YcQ01eFybHjLDPUpn93s432gifXXjTFdWTXKdXxKsdFIxBj9
         CYhaZM+d4hH/f0kTvPAs10PJtM/NS9Xbu2IkTUDNvTCwXnXMsQPNTF97CiNFEGOiG8mo
         QWLydXazRXmPpB8kcrMOQeuzo5GCQUozNNWfEPN30pF+mg+q0BvmUybJrt9kdMliEN6/
         YHRlherQ7mXYrRvm41yCqSYvy46r9NSAeXI9qj3Rgjqe01XBXN/2Fziqu2GbRAi0diCl
         Oz8w==
X-Gm-Message-State: APjAAAVcHALn2+e6KtNkZhrErw/a6MRZlPZ5CApO3XIsKRWevxj3fy7V
        QvY+7q0qQpEFH7hOhSAb0es=
X-Google-Smtp-Source: APXvYqxixwj1LEwDYU22br98jK214e1HbdaZCdfj8S/LuMuKidx0rZYc2SIPl85g9n7UyYXvV0XOeg==
X-Received: by 2002:a17:90a:be07:: with SMTP id a7mr21252482pjs.88.1566844933145;
        Mon, 26 Aug 2019 11:42:13 -0700 (PDT)
Received: from macbook-pro.localdomain (c-73-223-74-184.hsd1.ca.comcast.net. [73.223.74.184])
        by smtp.gmail.com with ESMTPSA id w26sm14475075pfq.100.2019.08.26.11.42.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 11:42:12 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 1/2] openvswitch: Properly set L4 keys on "later" IP
 fragments.
From:   Justin Pettit <jpettit@ovn.org>
In-Reply-To: <CAOrHB_BKd=QKR_ScO+r7qAyZaniEbFur+iup1iXbtiycaFawjw@mail.gmail.com>
Date:   Mon, 26 Aug 2019 11:42:10 -0700
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>,
        Greg Rose <gvrose8192@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C1DB8ED7-2846-4F05-A084-07B83568D67D@ovn.org>
References: <20190824165846.79627-1-jpettit@ovn.org>
 <CAOrHB_AU1gQ74L5WawyA4THhh=MG8YZhcvkkxnKgRG+5m-436g@mail.gmail.com>
 <CAOrHB_BKd=QKR_ScO+r7qAyZaniEbFur+iup1iXbtiycaFawjw@mail.gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>, David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Aug 25, 2019, at 1:40 PM, Pravin Shelar <pshelar@ovn.org> wrote:
> 
> Actually I am not sure about this change. caller of this function
> (ovs_ct_execute()) does skb-pull and push of L2 header, calling
> ovs_flow_key_update() is not safe here, it expect skb data to point to
> L2 header.

Thanks for the feedback, Pravin and David.  Greg Rose has a revised version that will address the issues you raised and also make it so that we don't bother re-extracting the L2 headers.  He'll hopefully get that out today once we've done some internal testing on it.

--Justin


