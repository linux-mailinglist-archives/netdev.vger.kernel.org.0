Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849224FE4F0
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357172AbiDLPnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357198AbiDLPme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:42:34 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E473B5C843
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:40:16 -0700 (PDT)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0C2363F809
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1649778015;
        bh=1SI9woaE3QEccBerp3cMcRiZsP2b7PbELee0/OtERq0=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=nl3Ms6vOyCvYUnin5pGOjMCGs8OrZePxVivfcZBB0gqkkuHSkjoaUDY9SGdNddeyh
         MjtnrrPDI5YcpIvieqLSi8fMxco6Jc/kwHRdEuDk2BxnmwatDWfKJu3N0mk17zGZpo
         IMUKTvY7PPdvmpOAR/5UaD6knuzeho8XKzYpSJMvqxnfCkgKS1vXxwbayqn2c+CgGY
         DGoAK9BIdEhVbTnCzWKeCVAhX+jbtM4UetNyW8l4qzhDsx+Pybdso2ULtokd2MUdHZ
         XKQd8Ir8EXI8nDh5ovM2R8f5q0EuKPfeD66CIMMqxWUdolCF3Ge4vzIkt5hNUsIQfD
         0uYhbqtWjb6Hg==
Received: by mail-pj1-f69.google.com with SMTP id y3-20020a17090a8b0300b001cb4831a8fbso1883834pjn.1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=1SI9woaE3QEccBerp3cMcRiZsP2b7PbELee0/OtERq0=;
        b=p5EBxRjz4OcRnP3yDOWoDZwVzYMfg4duXnOeykL4iNlLmxE/hy2osUut8dR4UTW5py
         0JcKKl9FzPq4nOU8UfRj/6CP9A4x1IVy7RHRRsVKCpyzPDdOKmze9XETZC+XX330l77X
         WuGZiErbZ9ixq1jIzkKk1ZG3bmDf3aTPf0pP3kTsu+wKnKrfhw7gaLqZNif5W3zWkJ2G
         ZO8DgEymRyEUBJ2A6v5CVWGYuoTamRuQ2axl0u4BhUwdxOtcBKD3ddJlrhQujKFmP9Bv
         Eqhr2PICJfPaRX3p0kTEpmQCl/5YCAHeYgH8CCGi4vmplO5igk9AMlmZaD1tGkqlLBVH
         Fb+w==
X-Gm-Message-State: AOAM532+QeQlof3hgMAlemHW9tXmZI8J4aht6dnDm9sHH2ph9kEPth0A
        A2AgcWvZh/cY5PcPAR3YbsNj6mimskj4Y8NK0gpx5a6CdtDRJpeOZG5U8Axw8NT5WJAtqOCV8Cs
        ZGrymnSXowtZHR4++UKrzL88eCoEcJ6+XcA==
X-Received: by 2002:a05:6a00:2402:b0:4e1:3df2:5373 with SMTP id z2-20020a056a00240200b004e13df25373mr38674207pfh.40.1649778012977;
        Tue, 12 Apr 2022 08:40:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqULQnp6zZ1nYgci2lvQM/8QbUp/EZTAKSUXtsMhYTQ0y4taJHSsMHGGLdrR9h48ujUXHCOw==
X-Received: by 2002:a05:6a00:2402:b0:4e1:3df2:5373 with SMTP id z2-20020a056a00240200b004e13df25373mr38674183pfh.40.1649778012640;
        Tue, 12 Apr 2022 08:40:12 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id g14-20020a65580e000000b0039ce0873289sm3215868pgr.84.2022.04.12.08.40.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Apr 2022 08:40:11 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 4D9C36093D; Tue, 12 Apr 2022 08:40:11 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 471A2A0B21;
        Tue, 12 Apr 2022 08:40:11 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
In-reply-to: <YlUViUt0NQfZYgAG@Laptop-X1>
References: <20220412041322.2409558-1-liuhangbin@gmail.com> <11973.1649739345@famine> <YlUViUt0NQfZYgAG@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Tue, 12 Apr 2022 14:00:41 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19206.1649778011.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 12 Apr 2022 08:40:11 -0700
Message-ID: <19207.1649778011@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Mon, Apr 11, 2022 at 09:55:45PM -0700, Jay Vosburgh wrote:
>> Hangbin Liu <liuhangbin@gmail.com> wrote:
>> =

>> >Add per port priority support for bonding. A higher number means highe=
r
>> >priority. The primary slave still has the highest priority. This optio=
n
>> >also follows the primary_reselect rules.
>> =

>> 	The above description (and the Subject) should mention that this
>> apparently refers to priority in interface selection during failover
>> events.
>
>OK, will update it. How about:
>
>Bonding: add per port priority for current slave re-selection during fail=
over

	That would be better, but something like "add per-port priority
for failover re-selection" would be a bit shorter.

>Add per port priority support for bonding current re-selection during fai=
lover.
>A higher number means higher priority in selection. The primary slave sti=
ll
>has the highest priority. This option also follows the primary_reselect r=
ules.

	This seems reasonable.

>> >@@ -117,6 +121,7 @@ static const struct nla_policy bond_policy[IFLA_BO=
ND_MAX + 1] =3D {
>> > =

>> > static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX =
+ 1] =3D {
>> > 	[IFLA_BOND_SLAVE_QUEUE_ID]	=3D { .type =3D NLA_U16 },
>> >+	[IFLA_BOND_SLAVE_PRIO]		=3D { .type =3D NLA_S32 },
>> =

>> 	Why used signed instead of unsigned?
>> =

>> 	Regardless, the valid range for the prio value should be
>> documented.
>
>I did this in purpose as team also use singed number. User could use a
>negative number for a specific link while other links keep using default =
0.

	Fair enough; I had been comparing to the LACP port priority and
route metric, both of which are unsigned.

>BTW, how to document the valid ranger for a int number, -2^31 ~ 2^31-1 or
>INT_MIN ~ INT_MAX.

	The documentation can simply state that the value is a signed 32
bit integer (rather than giving the specifics).

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
