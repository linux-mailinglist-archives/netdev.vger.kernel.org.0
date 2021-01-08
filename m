Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18FD2EF2E6
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbhAHNNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbhAHNNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 08:13:40 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80B8C0612F5
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 05:12:59 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id i24so11110414edj.8
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 05:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9umxs0z1CG9c3LHm6Wmk0CDSP9uDdkoc9g2I+fPg5mI=;
        b=IkYgxW89vAoa4h2gFyJjCChzRstA+SSgaZw73Y7OuiKmux5PPZ+T5SUJSb1y8BbDnr
         yKXd3cFJH703XQCGCWNwfqNAb3+3QroxBfkE7kNZdxMMOt0Smcsf/QfXoIuGN95TS+cf
         hkpq90nmauCTnsGmRT/i1eAihpDwiMkFwaIc/lUknTu7T1ynRfPhtJZOD0ngYtJ0/wgG
         1Di093q+t8X4w8TSq55FHQhtmc2K1yOp+g6NgdmBRpamskZdiLljVJH43h2UZL/3eUhH
         +VPhSYh3df9ZXPxqpeDbe3Lt8r/1b4qeCJH4XtE7nZYdht6KXm7amBrUjp6wnmIQIYZH
         7JIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9umxs0z1CG9c3LHm6Wmk0CDSP9uDdkoc9g2I+fPg5mI=;
        b=tmo6DRrLO1xwKIOkKbNkxYg74p9DW+Po9uOt5Tc3B9uVLOq6WHU71pEBskQsRkAb1e
         VJm7Rq1Sf+FbzM3kgabyEtpJniE/A9Hd0elisg8omKpBTBFENXSMjCvPidLzGpLfrFJK
         E/rTnuwXh5s+1GgKb93pv0dyucCIaNsPHmpiuwTW/SDOxivyi+pjHd8+hJEJ+6KPdTSd
         cNn/SYE31FsUbcAGVFkBgBnxDTGP6o3FSOY1aJ7nSGrScgIqEIqzJ1uqUK6lXT6r9Hj8
         OY5ffxguf8Xp71aaj5F491V3h2+6QRXVNFauDpzv0ZFkOyS2AJd0vTjLDvx9MnCANI5r
         ZL1Q==
X-Gm-Message-State: AOAM533gyxbSS2ka304ylXMWykj6ntfoE/97BTUlB01YpimzNfchlgGi
        wtxnwTcgB+u8d6yHu+L2akJG5Q==
X-Google-Smtp-Source: ABdhPJxji9WZBQI5p1nYXpTJj5Ydv9otkPUCIfGHhAVHbuDh0z1ydork1JbeshH+AbeGMAhvOrWrUw==
X-Received: by 2002:a05:6402:1a30:: with SMTP id be16mr5381083edb.124.1610111578400;
        Fri, 08 Jan 2021 05:12:58 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i13sm3764109edu.22.2021.01.08.05.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 05:12:57 -0800 (PST)
Date:   Fri, 8 Jan 2021 14:12:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] bonding: add a vlan+srcmac tx hashing option
Message-ID: <20210108131256.GG3565223@nanopsycho.orion>
References: <20201218193033.6138-1-jarod@redhat.com>
 <20201228101145.GC3565223@nanopsycho.orion>
 <20210107235813.GB29828@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107235813.GB29828@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 08, 2021 at 12:58:13AM CET, jarod@redhat.com wrote:
>On Mon, Dec 28, 2020 at 11:11:45AM +0100, Jiri Pirko wrote:
>> Fri, Dec 18, 2020 at 08:30:33PM CET, jarod@redhat.com wrote:
>> >This comes from an end-user request, where they're running multiple VMs on
>> >hosts with bonded interfaces connected to some interest switch topologies,
>> >where 802.3ad isn't an option. They're currently running a proprietary
>> >solution that effectively achieves load-balancing of VMs and bandwidth
>> >utilization improvements with a similar form of transmission algorithm.
>> >
>> >Basically, each VM has it's own vlan, so it always sends its traffic out
>> >the same interface, unless that interface fails. Traffic gets split
>> >between the interfaces, maintaining a consistent path, with failover still
>> >available if an interface goes down.
>> >
>> >This has been rudimetarily tested to provide similar results, suitable for
>> >them to use to move off their current proprietary solution.
>> >
>> >Still on the TODO list, if these even looks sane to begin with, is
>> >fleshing out Documentation/networking/bonding.rst.
>> 
>> Jarod, did you consider using team driver instead ? :)
>
>That's actually one of the things that was suggested, since team I believe
>already has support for this, but the user really wants to use bonding.
>We're finding that a lot of users really still prefer bonding over team.

Do you know the reason, other than "nostalgia"?
