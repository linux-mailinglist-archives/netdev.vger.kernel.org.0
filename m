Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51D22D4400
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732812AbgLIOMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbgLIOM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:12:26 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2A7C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 06:11:44 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id a12so3283600lfl.6
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=KqQBQ8JEzuTx6ws8mjH1rnUiDuokMJvmtk0iwFMRJEI=;
        b=DeUlVCq29VRyUIVjV6zQtsE35mU5ulnm73WxZdwOIyH5wXbq6xahlqiVLgs876Sjjd
         MBMFjAH5t/oZeJhf3oFtrOWjFDYa7zDvoy60Uno2Dt49ncVHZVDqQ71oj++ofR7IPPVD
         ca/fNT6UcYQrlp0/UrfRdc54Qv8kXlopeMQ/qIEe4vrK0Vhs0XnxlsExsx0j6ImQBta2
         PMZEwnk7Sg08M8bKDHkaejHbbLovwTCcQ7TUWI/G9psv8Ro7YrKbt/K/nunrn7Qc4nsq
         0PFvhy/Z0X3lmo3wnlMOoaoXN12X1LwJlobee6eLlvYtuRcz8JeBjs89z7I1nDW5XG1z
         3MYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KqQBQ8JEzuTx6ws8mjH1rnUiDuokMJvmtk0iwFMRJEI=;
        b=oFSKY9m/XOqssPbZ/d3xxtsqLCp+0TQhGqYDVi6AoY4VqWBIihH0ktl7S3Q8HKri6l
         1yqaMVuAbEP0ExsdeAf0/iJgwUB8/gUZE0Yc8V2NVSevh1J/VVJefR8QXnftQdTDITQV
         +0fP/bN+uZ/0UPRUL1QKIT193jBrK7GgvAJdQetiDDf8q4Thjd8ikcC6eMTgQkvvleiM
         IOnGfqApdqTRi0ATTB9MJToOmwN6FGHhIaC5rZF+99+KlhQ0JmiEXAiKq+rUaC7t1kww
         IvOdgJBpScWI3QUflO5AvuCO4lt5SUZoeMihVH5REW1uoxyk+fQtdNPwjQ5WW849kz7g
         cuEA==
X-Gm-Message-State: AOAM531OBtTtoY580MUnddyRi5dD0zJPihrvRZN5xzbfOcoslJICO/Zm
        1ApggqoCllogqWWB7uLztlr/p9LNWFY/lhUn
X-Google-Smtp-Source: ABdhPJzrkWlsoeUPqnFcCIZgNYwCoV7A4ClqyW/ebfgIqTgwwEQ7fhPWca2jDim6G5lP2Gm69nQygg==
X-Received: by 2002:a19:6e4c:: with SMTP id q12mr1104085lfk.162.1607523102984;
        Wed, 09 Dec 2020 06:11:42 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id a1sm182068lfg.282.2020.12.09.06.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 06:11:42 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201209105326.boulnhj5hoaooppz@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201208112350.kuvlaxqto37igczk@skbuf> <87mtyo5n40.fsf@waldekranz.com> <20201208163751.4c73gkdmy4byv3rp@skbuf> <87k0tr5q98.fsf@waldekranz.com> <20201209105326.boulnhj5hoaooppz@skbuf>
Date:   Wed, 09 Dec 2020 15:11:41 +0100
Message-ID: <87eejz5asi.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 12:53, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 09, 2020 at 09:37:39AM +0100, Tobias Waldekranz wrote:
>> I will remove `struct dsa_lag` in v4.
>
> Ok, thanks.
> It would be nice if you could also make .port_lag_leave return an int code.

Sure.

> And I think that .port_lag_change passes more arguments than needed to
> the driver.

You mean the `struct netdev_lag_lower_state_info`? Fine by me, it was
mostly to avoid hiding state from the driver if anyone needed it.

>> > I don't think the DSA switch tree is private to anyone.
>>
>> Well I need somewhere to store the association from LAG netdev to LAG
>> ID. These IDs are shared by all chips in the tree. It could be
>> replicated on each ds of course, but that does not feel quite right.
>
> The LAG ID does not have significance beyond the mv88e6xxx driver, does
> it? And even there, it's just a number. You could recalculate all IDs
> dynamically upon every join/leave, and they would be consistent by
> virtue of the fact that you use a formula which ensures consistency
> without storing the LAG ID anywhere. Like, say, the LAG ID is to be
> determined by the first struct dsa_port in the DSA switch tree that has
> dp->bond == lag_dev. The ID itself can be equal to (dp->ds->index *
> MAX_NUM_PORTS + dp->index). All switches will agree on what is the first
> dp in dst, since they iterate in the same way, and any LAG join/leave
> will notify all of them. It has to be like this anyway.

This will not work for mv88e6xxx. The ID is not just an internal number
used by the driver. If that was the case we could just as well use the
LAG netdev pointer for this purpose. This ID is configured in hardware,
and it is shared between blocks in the switch, we can not just
dynamically change them. Neither can we use your formula since this is a
4-bit field.

Another issue is how we are going to handle this in the tagger now,
since we can no longer call dsa_lag_dev_by_id. I.e. with `struct
dsa_lag` we could resolve the LAG ID (which is the only source
information we have in the tag) to the corresponding netdev. This
information is now only available in mv88e6xxx driver. I am not sure how
I am supposed to conjure it up. Ideas?
