Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C97D425523
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241981AbhJGOST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:18:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233362AbhJGOSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 10:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633616183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7UDBXhMLG5JFK9qk43R1XDNPh//+qZc1lFbQJXtP7Yo=;
        b=Is7AwruzISK+oIghdFREDoRQImdpEEjR4EFtN9vLhhDLC/M+PgXp70T3YdDeCN1jrnYNnT
        XXJ98yn+v64gXZVbDUacfG1oqqRuMvji7dbwMEtHvy0NfQQKrDw9c5ubGmvHfDdZfbgyki
        up2gCzS2DtsCRN6ximpu3dFemh5OYlk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-gh0_wmEpMpqDdDE8ZCJJbA-1; Thu, 07 Oct 2021 10:16:22 -0400
X-MC-Unique: gh0_wmEpMpqDdDE8ZCJJbA-1
Received: by mail-wr1-f69.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso4807997wrg.1
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 07:16:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7UDBXhMLG5JFK9qk43R1XDNPh//+qZc1lFbQJXtP7Yo=;
        b=zzg0Edz/G+DaR9jipFPkftBR87ZXA126/BKwKYJiwP1ln7quR9VGxxlFQLqRC2Avq2
         7hi7MnCbdFVVU6+Ixu+bDYUYxe1ZhmnImmuOvC3E/mTrpn0I0N6wHea0txzqWR28xnyT
         VjXhWgrMR1bMfG1tgGHpRl+ByZbaggNjCg/ccYrfUEE3/TfsR9/V4qeRNtcXG08VrTk2
         HAwh+5683az5P6FrecT7thWZ/MhHbxrOo/xWfJo/se39F816P44XePQ9NjG4PayVy9jx
         VACn0pe8QZrMN7CAPNTm7fxgnBeEfpInbKNFOe0anlJ2r75Mg9v6KcS26SjLg9Dp7xuB
         JSLQ==
X-Gm-Message-State: AOAM532LlzrAHkDHoCrIU3kr4DmcA6fr7A8a9hFYkDROW/KAUXVs5UE2
        T3VO02dBpHWVH83V1Qlu23429nDDYPbr9dsTfDyisNIigQ1GrNHQts71mO4xa32WNHkD87Zwz73
        1UnQMblh2fLWsjf5V
X-Received: by 2002:a1c:9a4d:: with SMTP id c74mr4847518wme.139.1633616181726;
        Thu, 07 Oct 2021 07:16:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwu6FrlrvSx4eWdI61YER5pJxykAO1GosQlESm09LVvjcfG8iJmCv1rEegM+G49zVLB5pp/hw==
X-Received: by 2002:a1c:9a4d:: with SMTP id c74mr4847484wme.139.1633616181465;
        Thu, 07 Oct 2021 07:16:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-183.dyn.eolo.it. [146.241.225.183])
        by smtp.gmail.com with ESMTPSA id o26sm8927547wmc.17.2021.10.07.07.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 07:16:21 -0700 (PDT)
Message-ID: <17268de9236e6e3c5bb118352984ec8638f0df4f.camel@redhat.com>
Subject: Re: [PATCH net-next] net-sysfs: try not to restart the syscall if
 it will fail eventually
From:   Paolo Abeni <pabeni@redhat.com>
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     juri.lelli@redhat.com, mhocko@suse.com, netdev@vger.kernel.org
Date:   Thu, 07 Oct 2021 16:16:19 +0200
In-Reply-To: <20211007140051.297963-1-atenart@kernel.org>
References: <20211007140051.297963-1-atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-10-07 at 16:00 +0200, Antoine Tenart wrote:
> Due to deadlocks in the networking subsystem spotted 12 years ago[1],
> a workaround was put in place[2] to avoid taking the rtnl lock when it
> was not available and restarting the syscall (back to VFS, letting
> userspace spin). The following construction is found a lot in the net
> sysfs and sysctl code:
> 
>   if (!rtnl_trylock())
>           return restart_syscall();
> 
> This can be problematic when multiple userspace threads use such
> interfaces in a short period, making them to spin a lot. This happens
> for example when adding and moving virtual interfaces: userspace
> programs listening on events, such as systemd-udevd and NetworkManager,
> do trigger actions reading files in sysfs. It gets worse when a lot of
> virtual interfaces are created concurrently, say when creating
> containers at boot time.
> 
> Returning early without hitting the above pattern when the syscall will
> fail eventually does make things better. While it is not a fix for the
> issue, it does ease things.
> 
> [1] https://lore.kernel.org/netdev/49A4D5D5.5090602@trash.net/
>     https://lore.kernel.org/netdev/m14oyhis31.fsf@fess.ebiederm.org/
>     and https://lore.kernel.org/netdev/20090226084924.16cb3e08@nehalam/
> [2] Rightfully, those deadlocks are *hard* to solve.
> 
> Signed-off-by: Antoine Tenart <atenart@kernel.org>

AFAICS, the current behaviour is preserved and the change is safe. I
think that preserving the current error-code for duplex_show and
speed_show is the correct thing to do.
Reviewed-by: Paolo Abeni <pabeni@redhat.com>

