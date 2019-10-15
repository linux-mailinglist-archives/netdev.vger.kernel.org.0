Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC59D73F4
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 12:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbfJOKxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 06:53:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34685 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfJOKxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 06:53:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id j11so23290338wrp.1
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 03:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=t9JNwNnz0MMTe3QyxhZNifL/YXLeokq/XWr1Cby0nIk=;
        b=K6B6JJj1TENhjw2ZnCPorz9mWOiEHjvOIa1JlAYB7QKtjJ1RgCwUV6ZRboPWlCCCED
         aBe3yfxxrWUj3WQN3s0UlcqE1PZOEtK8dxbTlnU2/a3L0COi09XY0wZqIMq6KHCsPIdR
         JUGGjpQIYNG2h3QQffPw0pyhZmyjO69ifC+v8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=t9JNwNnz0MMTe3QyxhZNifL/YXLeokq/XWr1Cby0nIk=;
        b=n/kfSBEPxd1lbq53Na3qsoCADu7jk3BscjbbY1iCaSxVkdwxw0BpQVwh+jCtX7mZAp
         ptl6zukiStYn4TwLJyXIcnila1LQHp2yQnFCHS8M9CSrE7cfpcfveDmkiViWU0PmrnPJ
         qFDvkdTAmZraZKaVECbJ/i1Yh2+w/rXAcyP+aNgwextHxcpSQU7oxXUe4YgN81MSzoR/
         FFKjFjNB9lhlzMGk2izcE1oRMblDvNJ1mL6Jmzde7cjuf/d2kF8Z0dZUk3PaLbz1eN/3
         ea/iIDWdWdGBN1KZYQdWVWQhS/O3TXFEfxk9Ztzt3v9p90uXrZT9p0OukH1ZhZEp5rY0
         xXgg==
X-Gm-Message-State: APjAAAV0SIS1MvOZu7xjlDfADbjrAbf4TXi8ztg/SyALgYD8CCfIoc1F
        Hffmds5iL7r3DX+rZFPr7CyqiZsRmyA=
X-Google-Smtp-Source: APXvYqwVWCXaOCc1JiydfZnDENNmiEk+GlNIPEm5oXDo4GldG8TK0564EBItrS/ak4F49iW3VqeI6Q==
X-Received: by 2002:adf:fa12:: with SMTP id m18mr30408123wrr.248.1571136824149;
        Tue, 15 Oct 2019 03:53:44 -0700 (PDT)
Received: from localhost ([149.62.203.53])
        by smtp.gmail.com with ESMTPSA id q22sm18554433wmj.5.2019.10.15.03.53.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 03:53:43 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:53:39 +0200
In-Reply-To: <3A7BDEE0-7C07-4F23-BA01-F32AD41451BB@cumulusnetworks.com>
References: <CAFLxGvwnOi6dSq5yLM78XskweQOY6aPbRt==G9wv5qS+dfj8bw@mail.gmail.com> <3A7BDEE0-7C07-4F23-BA01-F32AD41451BB@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: Bridge port userspace events broken?
To:     Richard Weinberger <richard.weinberger@gmail.com>,
        netdev@vger.kernel.org
CC:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Greg KH <gregkh@linuxfoundation.org>
From:   nikolay@cumulusnetworks.com
Message-ID: <5A4A5745-5ADC-4AAC-B060-1BC9907C153C@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 October 2019 12:48:58 CEST, nikolay@cumulusnetworks=2Ecom wrote:
>On 14 October 2019 22:33:22 CEST, Richard Weinberger
><richard=2Eweinberger@gmail=2Ecom> wrote:
>>Hi!
>>
>>My userspace needs /sys/class/net/eth0/brport/group_fwd_mask, so I set
>>up udev rules
>>to wait for the sysfs file=2E
>>Without luck=2E
>>Also "udevadm monitor" does not show any event related to
>>/sys/class/net/eth0/brport when I assign eth0 to a bridge=2E
>>
>>First I thought that the bridge code just misses to emit some events
>>but
>>br_add_if() calls kobject_uevent() which is good=2E
>>
>>Greg gave me the hint that the bridge code might not use the kobject
>>model
>>correctly=2E
>>
>>Enabling kobjekt debugging shows that all events are dropped:
>>[   36=2E904602] device eth0 entered promiscuous mode
>>[   36=2E904786] kobject: 'brport' (0000000028a47e33):
>kobject_uevent_env
>>[   36=2E904789] kobject: 'brport' (0000000028a47e33):
>>kobject_uevent_env: filter function caused the event to drop!
>>
>>If I understood Greg correctly this is because the bridge code uses
>>plain kobjects which
>>have a parent object=2E Therefore all events are dropped=2E
>>
>>Shouldn't brport be a kset just like net_device->queues_kset?
>
>
>Hi Richard,=20
>I'm currently traveling and will be out of reach until mid-next week
>when I'll be
>able to take a closer look, but one thing which comes to mind is that
>on
>any bridge/port option change there should also be a netlink
>notification which
>you could use=2E I'll look into this and will probably cook a fix, if
>anyone hasn't
>beaten me to it by then=2E :)=20
>
>Cheers,
>  Nik

I meant the notifications could be used to configure the port mask once th=
e
netdev is enslaved as well as for monitoring changes to them=2E=20
Generally we prefer using netlink for configuration changes, some
of the bridge options are only accessible via netlink (e=2E g=2E vlan conf=
ig)=2E=20


