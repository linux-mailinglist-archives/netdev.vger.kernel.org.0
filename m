Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDA71C9601
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgEGQHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727067AbgEGQHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 12:07:44 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4C5C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 09:07:44 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id b20so5002524ejg.11
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 09:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Pn1DEVE6o87WrTlp9kfPfFYCnNUI8GlgM+4KeyMdpM=;
        b=jCLi1CLvh15Oh974hvGVfMGEXR37deitevowfo4M/vowddmSw/QDB36MuQyQQJFfda
         7wz+stWl//bhkgqGfL9nDtmA5IRCR7coRY2aX2O3MGfyEDBxg8sVfsqvMPox803wYAnT
         cgVMqo1wGkJ5FtM4xtJnD6BuzDOjc3xly2n6smOfzhVaSSVLMCkxxYUrYtrk9F+8TbqO
         rzNrYkpAlx4Q4/P/X61hpGMYn0gisdgYr5lXCwRc+NR9YsebZAuU42WydB501M2wDCxH
         LKyzZ3koo+uvD+UsHuQOtgKqvNYx1Cyi5BZKqU0pkkDtXTT4yYMx/h6QGK8Joe/U6E/Z
         SHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Pn1DEVE6o87WrTlp9kfPfFYCnNUI8GlgM+4KeyMdpM=;
        b=W1sjnOuU+3rkJnLDxOhpT9sg5VTLnNx102Ooh15I2dSONcGwTYMA9UQeTOKGpiqiPu
         z4E2YsvdNfRizB+8/0qq4gqcU4PYw4pXx0PO0Kt3S4jY6Jyb6dwf5wemibJhjU4URrYo
         Mba0mVjEo5OmPW3i0YUpl3PBBnRALducA64vigXdzRR6UxNjp5Pm5O1WZ1a43ZRlDi6+
         snaVhukrVYOCnWCWAw5ALP8m5yLPtcKM3fpgMMtZ7lFrdozw0VkaZmlr3wvKZObgE4Mg
         JiqPysg7ase0MI3Dbe4ihjjxNr+Q9NaVttEKdGNYGN9z71dV69/+6//DojKkiJ7Bac2Z
         3h4g==
X-Gm-Message-State: AGi0PuZJJkliYVIFoj0YhewaHJfa8RVOkis0OhBvX49WJkuy1hEUaKdI
        SJVWbiVylVYjSx5LtCC5VSZWN1vF2i3qZ2ezKJE=
X-Google-Smtp-Source: APiQypLLf6jM1I7icccgkb7sUIiweCbDC31vmuqLzXzsSIbxH9t6JLy5HVuS7GkFGEV+6s3XPdlcsO3gI2ZxvSpjHhw=
X-Received: by 2002:a17:906:add7:: with SMTP id lb23mr13377903ejb.6.1588867663226;
 Thu, 07 May 2020 09:07:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200503221228.10928-1-olteanv@gmail.com>
In-Reply-To: <20200503221228.10928-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 7 May 2020 19:07:32 +0300
Message-ID: <CA+h21hpmr9Wey7SV9wLhE--VCSO=vobkqNW_kOB8c+DHE_Zs6g@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 0/4] Cross-chip bridging for disjoint DSA trees
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Mingkai Hu <mingkai.hu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Mon, 4 May 2020 at 01:12, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This series adds support for boards where DSA switches of multiple types
> are cascaded together. Actually this type of setup was brought up before
> on netdev, and it looks like utilizing disjoint trees is the way to go:
>
> https://lkml.org/lkml/2019/7/7/225
>
> The trouble with disjoint trees (prior to this patch series) is that only
> bridging of ports within the same hardware switch can be offloaded.
> After scratching my head for a while, it looks like the easiest way to
> support hardware bridging between different DSA trees is to bridge their
> DSA masters and extend the crosschip bridging operations.
>
> I have given some thought to bridging the DSA masters with the slaves
> themselves, but given the hardware topology described in the commit
> message of patch 4/4, virtually any number (and combination) of bridges
> (forwarding domains) can be created on top of those 3x4-port front-panel
> switches. So it becomes a lot less obvious, when the front-panel ports
> are enslaved to more than 1 bridge, which bridge should the DSA masters
> be enslaved to.
>
> So the least awkward approach was to just create a completely separate
> bridge for the DSA masters, whose entire purpose is to permit hardware
> forwarding between the discrete switches beneath it.
>
> v1 was submitted here:
> https://patchwork.ozlabs.org/project/netdev/cover/20200429161952.17769-1-olteanv@gmail.com/
>
> v2 was submitted here:
> https://patchwork.ozlabs.org/project/netdev/cover/20200430202542.11797-1-olteanv@gmail.com/
>
> Vladimir Oltean (4):
>   net: bridge: allow enslaving some DSA master network devices
>   net: dsa: permit cross-chip bridging between all trees in the system
>   net: dsa: introduce a dsa_switch_find function
>   net: dsa: sja1105: implement cross-chip bridging operations
>
>  drivers/net/dsa/mv88e6xxx/chip.c       |  16 ++-
>  drivers/net/dsa/sja1105/sja1105.h      |   2 +
>  drivers/net/dsa/sja1105/sja1105_main.c |  90 +++++++++++++++
>  include/linux/dsa/8021q.h              |  45 ++++++++
>  include/net/dsa.h                      |  13 ++-
>  net/bridge/br_if.c                     |  32 ++++--
>  net/bridge/br_input.c                  |  23 +++-
>  net/bridge/br_private.h                |   6 +-
>  net/dsa/dsa2.c                         |  21 ++++
>  net/dsa/dsa_priv.h                     |   1 +
>  net/dsa/port.c                         |  23 +++-
>  net/dsa/switch.c                       |  21 +++-
>  net/dsa/tag_8021q.c                    | 151 +++++++++++++++++++++++++
>  13 files changed, 414 insertions(+), 30 deletions(-)
>
> --
> 2.17.1
>

What does it mean that this series is "deferred" in patchwork?

Thanks,
-Vladimir
