Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD704E3F66
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 14:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiCVNXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 09:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbiCVNXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 09:23:33 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBAA7E5BE;
        Tue, 22 Mar 2022 06:22:04 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id q14so10624612ljc.12;
        Tue, 22 Mar 2022 06:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=AjcCl508/3oBfoVa+HHFPodqa5oQijS6CmLfzMEJ/u4=;
        b=RbgTHNgJumkKhypcVJzqThV2d98m5yX0RD5BZKNJlLmXSNgMuLiLI24cCu53Me2Y41
         kFFJPAq2f+tJChxDH/EPhvnv5EnETOgWfdtGRGm2jijKSd2anzrZEG6GYmHaxxLEpNHE
         ki3QBs951g5pKa6JoS9uSl2NWDERGyfhhT3If/gClFoO0owTBcU+bW5dcSeiVNzrUQr+
         GYah0ydJN+vLiU7DBBSjo7XlkmcB64QodtXu7Bsssvb0CTNrkR9OhyyK1KDFj5eWVPF2
         pPfLPxmeUl/JtK3y93wMJRS2xBBYUgp6feZdgCppceRbeg881nn/wlcQSuETg3D0yCWL
         W3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AjcCl508/3oBfoVa+HHFPodqa5oQijS6CmLfzMEJ/u4=;
        b=Fjliz4ymDuf+8IROMCPXyX+9kIiCeks76f/z46e1J6W7VOv1kX+41bRt2hU0zQ4AaT
         E1+P983+D6sN3FDTbk8QOupwiz+axBbSgcM9PQeXygyeCmVjTaY2gb+PjzGHiIfEtgjP
         mZw4zYNBmNp9l1td57Dm6ahU2CKUxd0Siyk3RfVaBq/xSrclzuYwufEtIlw+W+VKZARO
         KcwIfTwtegkAsh73iPzO/eoBJNPl2bH2n8IbbEL6NX3fPdhoGCn+pId8kWAWJ9eYjnRg
         hVOlgbAsX6ry4KkoG0a8I7Sa8XoiupjaX2vXLPUQlcaLbO3Yhes2/AcBXwDPsrruMyMA
         udzQ==
X-Gm-Message-State: AOAM533dXufsdyFdelTC6wZftaeiUISAwn0GDS5bmAfvmC7cTQm1Muk4
        0/5UvMZ5r4iTUYz7rJKdDco=
X-Google-Smtp-Source: ABdhPJzFswqUOAuAWZ/WBTHRItFTQwUGjyxdjYGlpcmIQYC2z/Bnt3kcgiq8Zgmq2gEsp5Ka7wtgyQ==
X-Received: by 2002:a2e:bf04:0:b0:246:7ace:e157 with SMTP id c4-20020a2ebf04000000b002467acee157mr19388105ljr.241.1647955322452;
        Tue, 22 Mar 2022 06:22:02 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id x11-20020a19e00b000000b004488bf4137esm2204467lfg.245.2022.03.22.06.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 06:22:01 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20220322110806.kbdb362jf6pbtqaf@skbuf>
References: <20220317153625.2ld5zgtuhoxbcgvo@skbuf>
 <86ilscr2a4.fsf@gmail.com> <20220317161808.psftauoz5iaecduy@skbuf>
 <8635jg5xe5.fsf@gmail.com> <20220317172013.rhjvknre5w7mfmlo@skbuf>
 <86tubvk24r.fsf@gmail.com> <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com> <20220318131943.hc7z52beztqlzwfq@skbuf>
 <86a6dixnd2.fsf@gmail.com> <20220322110806.kbdb362jf6pbtqaf@skbuf>
Date:   Tue, 22 Mar 2022 14:21:58 +0100
Message-ID: <86ee2ujf61.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tis, mar 22, 2022 at 13:08, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 22, 2022 at 12:01:13PM +0100, Hans Schultz wrote:
>> On fre, mar 18, 2022 at 15:19, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Fri, Mar 18, 2022 at 02:10:26PM +0100, Hans Schultz wrote:
>> >> In the offloaded case there is no difference between static and dynamic
>> >> flags, which I see as a general issue. (The resulting ATU entry is static
>> >> in either case.)
>> >
>> > It _is_ a problem. We had the same problem with the is_local bit.
>> > Independently of this series, you can add the dynamic bit to struct
>> > switchdev_notifier_fdb_info and make drivers reject it.
>> >
>> >> These FDB entries are removed when link goes down (soft or hard). The
>> >> zero DPV entries that the new code introduces age out after 5 minutes,
>> >> while the locked flagged FDB entries are removed by link down (thus the
>> >> FDB and the ATU are not in sync in this case).
>> >
>> > Ok, so don't let them disappear from hardware, refresh them from the
>> > driver, since user space and the bridge driver expect that they are
>> > still there.
>> 
>> I have now tested with two extra unmanaged switches (each connected to a
>> seperate port on our managed switch, and when migrating from one port to
>> another, there is member violations, but as the initial entry ages out,
>> a new miss violation occurs and the new port adds the locked entry. In
>> this case I only see one locked entry, either on the initial port or
>> later on the port the host migrated to (via switch).
>> 
>> If I refresh the ATU entries indefinitly, then this migration will for
>> sure not work, and with the member violation suppressed, it will be
>> silent about it.
>
> Manual says that migrations should trigger miss violations if configured
> adequately, is this not the case?
>
Yes, but that depends on the ATU entries ageing out. As it is now, it works.

>> So I don't think it is a good idea to refresh the ATU entries
>> indefinitely.
>> 
>> Another issue I see, is that there is a deadlock or similar issue when
>> receiving violations and running 'bridge fdb show' (it seemed that
>> member violations also caused this, but not sure yet...), as the unit
>> freezes, not to return...
>
> Have you enabled lockdep, debug atomic sleep, detect hung tasks, things
> like that?

No, I haven't looked deeper into it yet. Maybe I was hoping someone had
an idea... but I guess it cannot be a netlink deadlock?
