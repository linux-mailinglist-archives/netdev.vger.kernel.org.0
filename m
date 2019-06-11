Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7BD3D0ED
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405009AbfFKPex convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Jun 2019 11:34:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40183 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404969AbfFKPex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:34:53 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so6111962eds.7
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 08:34:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=jdzPAZ1MUaZZQ92cTW/eGNQ6hSIjS5WIkaBdfHvHF/o=;
        b=neEWO2h/fXossjqqAlCkiUB9t1a5BopAKBBCTIBSDG/4SemHEDh/35S8s8d2ZUETWk
         tZus7PigbrWRwEe9L6LT0InfDSiDcFuRkv/EewFtSuOszsCSFqhQFeG3Rk7i6CYBHds5
         PZAFrRHYZKHdph6w9/qpCXTIvCC33aeMpsF0OSoKsqdqjquM6Fkwkswfnnh3iCIN/+93
         7/PSeTDsY/NpZEMxPVJJxEALVzEtD/DYI18WRIm3gYVvv0Mr7jMidrZCMOXL64tuNEcz
         rHKIJI4rSoZ/yBqF83OcNC+oQJvsRZT5yoM7fRgsT6jYe/IyQg6PeDsw6FvSAOHJdG0P
         ZqLA==
X-Gm-Message-State: APjAAAV3BS/z/dTabYEPW2LiZUWtXH8qKGgB6jUM1PCF1l/Q5ElzDIEA
        y4KWoFOUIP9AkORRG2mAXjt7UA==
X-Google-Smtp-Source: APXvYqwZnvbMInAFD45NaNyqAPMAaUQBCZYjzt3iTc4+Iu/55NcIBQYx5kecHRHqnwUZBMj7dxO2wA==
X-Received: by 2002:a50:a53a:: with SMTP id y55mr63219212edb.147.1560267291214;
        Tue, 11 Jun 2019 08:34:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id f3sm2313931ejc.15.2019.06.11.08.34.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 08:34:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 109CA18037E; Tue, 11 Jun 2019 17:34:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paul Blakey <paulb@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>,
        "nst-kernel\@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
In-Reply-To: <da87a939-9000-8371-672a-a949f834caea@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com> <1560259713-25603-2-git-send-email-paulb@mellanox.com> <87d0jkgr3r.fsf@toke.dk> <da87a939-9000-8371-672a-a949f834caea@mellanox.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 11 Jun 2019 17:34:50 +0200
Message-ID: <877e9sgmp1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Blakey <paulb@mellanox.com> writes:

> On 6/11/2019 4:59 PM, Toke Høiland-Jørgensen wrote:
>> Paul Blakey <paulb@mellanox.com> writes:
>>
>>> Allow sending a packet to conntrack and set conntrack zone, mark,
>>> labels and nat parameters.
>> How is this different from the newly merged ctinfo action?
>>
>> -Toke
>
> Hi,
>
> ctinfo does one of two very specific things,
>
> 1) copies DSCP values that have been placed in the firewall conntrack 
> mark back into the IPv4/v6 diffserv field
>
> 2) copies the firewall conntrack mark to the skb's mark field (like 
> act_connmark)
>
> Originally ctinfo action was named conndscp (then conntrack, which is 
> what our ct shorthand stands for).
>
> We also talked about merging both at some point, but they seem only 
> coincidentally related.

Well, I'm predicting it will create some confusion to have them so
closely named... Not sure what the best way to fix that is, though...?

-Toke
