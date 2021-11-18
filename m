Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9A6455DA0
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhKRONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:13:24 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:37728
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232755AbhKRONX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 09:13:23 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C33213F178
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637244622;
        bh=RcuPdj4LDsIuGdJc7P4U+43wzqpbyrwBq9APiuhmhec=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=IipjOjbzzk7bMlqdlmcLtXGmidNQLcGlIZ6dNSXtRMwBeMQcEXgEIDGaSkDYds77L
         SNX/9uYoNCXbbaTpv/mC5cqQdiNhB3+Ft+vGAG9gXymKwfV//28mdTidOuua73b27E
         ykiOfbYNYq4cjdZCp+GYzeFSK5QGyalQyRrcQOrqBhOuxsdShvu3rxhCropoci4PsC
         Ifcp3CiIi0rP/lUpDGwVDZJT/W+PNFGwEQNVqr95Qzl8BdhrRhRLht/5gjmk37zMsP
         U8agwcA7Z0mZAvedu34OKCYqSWGnq76jxKTAByQDMfPaMA7x7jzu97adxbvurEWmvL
         YXhf71usHe6mQ==
Received: by mail-wr1-f69.google.com with SMTP id q17-20020adfcd91000000b0017bcb12ad4fso1101338wrj.12
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 06:10:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=RcuPdj4LDsIuGdJc7P4U+43wzqpbyrwBq9APiuhmhec=;
        b=NUfY4KA4c6MbgnOfKfXbsprq7utiB8u3GVAX0vIqJ0sBqz21qrEwJCB9caQCTR+RvL
         UmcuG91EnsO2Rpc1v2TRBFtqCKrfMP2A29klA4GKSMG72dIjx0HjH26DkawOgs9hmQ8c
         N3y0BNVSJg29q3ZxPT+wzB9ca387d4OWSpJQ3RVCgRgWTPgg7nB8Qrz/LF/RNRdMRzaG
         rdL9aFxIsDJfHCX49YJb4xpApcQOsrQYcLMKICxjRcEjV8oddQy8qrMQYpGQYuOyLXrj
         ry/QKgRbRKWIzqAOYEkAGW94QfioVJFKHnchDi0kWUsrXZgv5lZDHmKSpl6v1kWTFpFe
         OlrA==
X-Gm-Message-State: AOAM531ubaN34U4g89HvsPl6O2P7iPXUkcXJd+5UfHce/1eIyQ5Tv+aN
        wkljA2GvpIbSt3/+F1DzGblc8S6US70ou4sEsvt8WqYoj+3OvhI3IJJnQZ4IttjiQqJd9p0kgJs
        Up65+nm2oRXlzz1Lf9adab7gh5A+2shbJTQ==
X-Received: by 2002:a05:600c:4104:: with SMTP id j4mr10338379wmi.178.1637244622568;
        Thu, 18 Nov 2021 06:10:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6gRdhwT7GT+oa5S8HaZhY+T2U2+sUF02FPpyNCej5wOHbJIXh9Le/boH4D6IeZ3rxyDE66A==
X-Received: by 2002:a05:600c:4104:: with SMTP id j4mr10338360wmi.178.1637244622426;
        Thu, 18 Nov 2021 06:10:22 -0800 (PST)
Received: from nyx.localdomain (faun.canonical.com. [91.189.93.182])
        by smtp.gmail.com with ESMTPSA id m34sm10399337wms.25.2021.11.18.06.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 06:10:21 -0800 (PST)
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 1CB9B240108; Thu, 18 Nov 2021 14:10:21 +0000 (GMT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 1882C280470;
        Thu, 18 Nov 2021 14:10:21 +0000 (GMT)
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
In-reply-to: <YZWooyiGT9Z3mPwh@Laptop-X1>
References: <20211117080337.1038647-1-liuhangbin@gmail.com> <70666.1637138425@nyx> <YZTSUh0vA1gVZFr3@Laptop-X1> <86277.1637165806@nyx> <YZWooyiGT9Z3mPwh@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Thu, 18 Nov 2021 09:13:07 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.7.1; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <103428.1637244621.1@nyx>
Date:   Thu, 18 Nov 2021 14:10:21 +0000
Message-ID: <103429.1637244621@nyx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Wed, Nov 17, 2021 at 04:16:46PM +0000, Jay Vosburgh wrote:
>> >I didn't explain it clearly. I want to say:
>> >
>> >I'm not using arp_misssed_max as the new option name because I plan to add
>> >bonding IPv6 NS/NA monitor in future. At that time the option "missed_max"
>> >could be used for both IPv4/IPv6 monitor.
>> >
>> >I will update the commit description in next version.
>> 
>> 	There has been talk of adding an IPv6 NS monitor for years, but
>> it hasn't manifested.  I would prefer to see a consistent set of options
>
>I'm working on it now. I should send a simple draft patch in 2 weeks.
>
>> nomenclature in what we have here and now.  If and when an IPv6 version
>> is added, depending on the implementation, either the IPv6 item can be a
>> discrete tunable, or an alias could be added, similar to num_grat_arp /
>> num_unsol_na.
>
>The name of num_grat_arp looks better than missed_max :) . In my
>IPv6 implementation, the function bond_ab_arp_inspect() will be reused
>directly. So one name or an alias looks more reasonable.
>
>For the alias options, do you mean to let both num_grat_arp and num_unsol_na
>change a same option in bond->params?

	The current options num_grat_arp and num_unsol_na change the
same underlying setting (params->num_peer_notif).  Your new "missed_max"
functionality could have "arp_missed_max" as the option name today, and
then whenever an IPv6 version is added, a "na_missed_max" option name
could be added as an alias for the arp_missed_max option.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
