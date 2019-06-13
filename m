Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3EB4468E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393079AbfFMQw4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jun 2019 12:52:56 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34284 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393070AbfFMQwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 12:52:55 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so2396685edb.1
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 09:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0ymyy89d7lOM589UjZFM5ihwy9u+Ix4p70B5qereb8w=;
        b=CtYzv3it98Zg5mAczFxMXFALDdUOvSrDI54mnugn5S3j29IdobPve88FYZLO2LGnBV
         6ujOgxdCXcEh5xxHeBjgKWStLZmay/qo1eN/Xd/htNp3SZ8TJOObcgtnjX8v9/gbZi+d
         zWgYRwkiG15FgkB9us7jL4Recpk5lP/k0uHwhyH/NZiDCfkZmxK5BzwEkwz5ZWollpSl
         7aaIUz5dq1j6kOfldu/ukslnzlVQLCz3V9N4LUPB6iW6aRH3MMlQqqrySj52gGvH0d8u
         lddZ2TTX6WiAzat/BouoTftD6NFjlgxh4c24opxitIOlg3V/fJBjcrRE5ZKQ8QLQc2ef
         +NEg==
X-Gm-Message-State: APjAAAV4aSKTt0pDSpz9E5Y2lNrN0cWg7pChzhI5KH6vJPw99YDpHtxC
        jAkYwz3tFF0822HzpR+Y0CRwe/fhQNU=
X-Google-Smtp-Source: APXvYqy+Av9/cp39EkoD919Ud8uZDinT3KM1OVbj3g/AePAYpPg5Z0k9OkE3jiTeJEWt7gT5I/ZPFw==
X-Received: by 2002:a50:90fa:: with SMTP id d55mr48010605eda.210.1560444774043;
        Thu, 13 Jun 2019 09:52:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id g16sm69028edc.76.2019.06.13.09.52.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 09:52:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9E5691804AF; Thu, 13 Jun 2019 18:52:52 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: Re: [RFC PATCH net-next 1/1] Allow 0.0.0.0/8 as a valid address range
In-Reply-To: <1560442237-6336-2-git-send-email-dave.taht@gmail.com>
References: <1560442237-6336-1-git-send-email-dave.taht@gmail.com> <1560442237-6336-2-git-send-email-dave.taht@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Jun 2019 18:52:52 +0200
Message-ID: <87zhmlctqz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave Taht <dave.taht@gmail.com> writes:

> The longstanding prohibition against using 0.0.0.0/8 dates back
> to two issues with the early internet.
>
> There was an interoperability problem with BSD 4.2 in 1984, fixed in
> BSD 4.3 in 1986. BSD 4.2 has long since been retired. 
>
> Secondly, addresses of the form 0.x.y.z were initially defined only as
> a source address in an ICMP datagram, indicating "node number x.y.z on
> this IPv4 network", by nodes that know their address on their local
> network, but do not yet know their network prefix, in RFC0792 (page
> 19).  This usage of 0.x.y.z was later repealed in RFC1122 (section
> 3.2.2.7), because the original ICMP-based mechanism for learning the
> network prefix was unworkable on many networks such as Ethernet (which
> have longer addresses that would not fit into the 24 "node number"
> bits).  Modern networks use reverse ARP (RFC0903) or BOOTP (RFC0951)
> or DHCP (RFC2131) to find their full 32-bit address and CIDR netmask
> (and other parameters such as default gateways). 0.x.y.z has had
> 16,777,215 addresses in 0.0.0.0/8 space left unused and reserved for
> future use, since 1989.
>
> This patch allows for these 16m new IPv4 addresses to appear within
> a box or on the wire. Layer 2 switches don't care.
>
> 0.0.0.0/32 is still prohibited, of course.
>
> Signed-off-by: Dave Taht <dave.taht@gmail.com>

Well, I see no reason why we shouldn't allow this.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
