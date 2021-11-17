Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C127454AC5
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhKQQTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:19:50 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:54342
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236705AbhKQQTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 11:19:49 -0500
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A22423F1FC
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 16:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637165808;
        bh=rbNRuBbmDWqlqFKfFvW31w/wL3KSG1UWbc2Mqf+JMCg=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Fwnq9B/Ztlc/zl7VfVhiJFVY8Qh0QZCVs8oI2ID1iJKshnBKSAW67dgehLIcts2E+
         fSctYCtcM3mOV9EWJD7WEP7bPwYMYwveZBEtu9Z+2vAOBiJsSADG09+JvldtkTnoeN
         rGK+mQihu9AyafttrZrbbfvktd/mbGqeJ0W/k19lwcf5w9C8qGQ/vihqyrsitqHuOA
         y/l1LkyvW3UQ0Rp5MG8DPFH8shv9naWQ3mjqHVox9senvJGM4IPWq/89Z033u2s/0E
         gxXudAHo6p2eERJG0/8ZCqouaYAXbKt92HY9Un1jX/ypD3jom2JjpHfQr9rRbbrGl4
         s+5sftVbeqZNA==
Received: by mail-wr1-f72.google.com with SMTP id q5-20020a5d5745000000b00178abb72486so508429wrw.9
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 08:16:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=rbNRuBbmDWqlqFKfFvW31w/wL3KSG1UWbc2Mqf+JMCg=;
        b=xmANaerdSSxgve/cK/md4a0jMRZVs/i4F/yYzOAU78Ya+lO4ulRlf0eeRou+ULvAtn
         J3ZT4wZNVyMWnu/hEOHy3/JDuMm/Zln6bjQP5Euc790+DaCw93pq2HwJYt8OXs3tPGhF
         lxPEl7obKsfcxyiOBPdC0xrAjYBiYq0vqdTQiEMAePQxPNsgP9GOnhc5EU7495+50JJH
         rCGzN0Layfszcs5k+NkNvtJVEbERBNZ4azU6RUM19d79SenQenv+0esiQYTvjkPXHzfh
         6LxycwHXRI+oDflBcdL1FiGrgmtB7pR6WTg9HB61rJmB0w7k8+EiNwe9unNgPNoGlwVo
         RAkA==
X-Gm-Message-State: AOAM531iTZX1rx4LghudFOstHX3EaIFxpLDdjBDJfka36yF5CSwV56Pa
        /k6+BaVjm3eiAb6xDm6eXYDvMUBJ6wn6Tj3HJFgDk37200EheoEICK97xrbtQbuw2p2DguBSMNL
        0/rbWInpdETFga4LaClHNev0bBoCoGK694w==
X-Received: by 2002:a05:600c:354b:: with SMTP id i11mr1018796wmq.61.1637165808221;
        Wed, 17 Nov 2021 08:16:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+W3AU7giazDCbRIX4xSugqMalFi05DGw5uHzfXoomWba1mB5whs0OptP+4HE4M9zI/6IS/A==
X-Received: by 2002:a05:600c:354b:: with SMTP id i11mr1018774wmq.61.1637165808037;
        Wed, 17 Nov 2021 08:16:48 -0800 (PST)
Received: from nyx.localdomain (faun.canonical.com. [91.189.93.182])
        by smtp.gmail.com with ESMTPSA id p2sm6680429wmq.23.2021.11.17.08.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 08:16:47 -0800 (PST)
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 5D2C72404A3; Wed, 17 Nov 2021 16:16:46 +0000 (GMT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 55E9728023B;
        Wed, 17 Nov 2021 16:16:46 +0000 (GMT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 net-next] Bonding: add missed_max option
In-reply-to: <YZTSUh0vA1gVZFr3@Laptop-X1>
References: <20211117080337.1038647-1-liuhangbin@gmail.com> <70666.1637138425@nyx> <YZTSUh0vA1gVZFr3@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Wed, 17 Nov 2021 17:58:42 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.7.1; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <86276.1637165806.1@nyx>
Date:   Wed, 17 Nov 2021 16:16:46 +0000
Message-ID: <86277.1637165806@nyx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Wed, Nov 17, 2021 at 08:40:25AM +0000, Jay Vosburgh wrote:
>> Hangbin Liu <liuhangbin@gmail.com> wrote:
>> 
>> >Currently, we use hard code number to verify if we are in the
>> >arp_interval timeslice. But some user may want to reduce/extend
>> >the verify timeslice. With the similar team option 'missed_max'
>> >the uers could change that number based on their own environment.
>> >
>> >The name of arp_misssed_max is not used as we may use this option for
>> >Bonding IPv6 NS/NA monitor in future.
>> 
>> 	Why reserve "arp_missed_max" for IPv6 which doesn't use ARP?  If
>> the option is for the ARP monitor, then prefixing it with "arp_" would
>> be consistent with the other arp_* options.
>
>I didn't explain it clearly. I want to say:
>
>I'm not using arp_misssed_max as the new option name because I plan to add
>bonding IPv6 NS/NA monitor in future. At that time the option "missed_max"
>could be used for both IPv4/IPv6 monitor.
>
>I will update the commit description in next version.

	There has been talk of adding an IPv6 NS monitor for years, but
it hasn't manifested.  I would prefer to see a consistent set of options
nomenclature in what we have here and now.  If and when an IPv6 version
is added, depending on the implementation, either the IPv6 item can be a
discrete tunable, or an alias could be added, similar to num_grat_arp /
num_unsol_na.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
