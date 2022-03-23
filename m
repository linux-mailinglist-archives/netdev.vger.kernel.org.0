Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED424E5028
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 11:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbiCWKSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 06:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiCWKSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 06:18:16 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B550776E01;
        Wed, 23 Mar 2022 03:16:46 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h1so1256259edj.1;
        Wed, 23 Mar 2022 03:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZKZgJV4GC9xGEIlfzshMoCdAQMdiXn2rDfscno1TubQ=;
        b=aBrNChj78Oc4I8xD0ZMbS+VO4sBtz26t6Nd+xP9MfFXKkPsiB/l7qjWZ0nudoelSAK
         1QUlFr2TMAOgt3nnZiEb+Ts/K365LL7vzPtDO0WmdgKE1AMufYd4dO93CDFWALOU2zIC
         9EKtzTp/+kQ3KUlUtO+5lQ6XVQqi6rjOIrearEFDryiZpof2kT6pYvn9gxAtf8pYvUQG
         5v82fG0lnc06nJdnFT4UiFslCDSq+duB+Veop3nwlqd3Grf4TAI9nyVuMhl3H6bor7Sp
         oPqcx6o9RBaijMrgmrFnIfBclgD9/YBv994AG8bhgT274PwaJ2kubAFhIuiHFoZzvkKo
         pFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZKZgJV4GC9xGEIlfzshMoCdAQMdiXn2rDfscno1TubQ=;
        b=AV4sNwGIFzxiNuOggdUVG182k9xOb17nw/zRzcxq/388ik3J+BdmvUEkCg5j+dN3vv
         mk7fKJUTCUjTsNwNXjY/xGo3/d6Ogst42OUV5sGwPwQBzVJmqQd6bfbSz043bfWtjDyz
         NUeLs5seXRO9X3R9kYZX+9qiidNBkZSTM5O4O5Sod6KiXqR5b8lLlFTcgq+qiKgwryzZ
         +576Ky7KCXEuT4BKiI5iCq3N/tNqlw/2QJOj2nerHiV4AAoZo0cXOvN1LYH6sJUZB9uT
         Ugaei6epwcvmfesDPRvB1ibU8nmgIn9d+Uj5eK90yH6SKCed9JFq/OTJMUMviBqm2K8e
         L8xg==
X-Gm-Message-State: AOAM5326Zw9Cdkywesyp4x72U9B9EpSKospnwzgyBJrL05V6x1W8+8ak
        6Q2/rkzjnjSpDuZqR/DkAeY=
X-Google-Smtp-Source: ABdhPJy3i8eh06rnBx6JiEKkwZ+VLalCP/MotS2slHhsBrTTRJ39l4k1Q4orQtxWVE24RG+jTTGPwQ==
X-Received: by 2002:a05:6402:c81:b0:410:a329:e27a with SMTP id cm1-20020a0564020c8100b00410a329e27amr34321304edb.142.1648030605082;
        Wed, 23 Mar 2022 03:16:45 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id u5-20020a170906b10500b006ce6fa4f510sm9634623ejy.165.2022.03.23.03.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 03:16:44 -0700 (PDT)
Date:   Wed, 23 Mar 2022 12:16:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
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
Message-ID: <20220323101643.kum3nuqctunakcfo@skbuf>
References: <20220317161808.psftauoz5iaecduy@skbuf>
 <8635jg5xe5.fsf@gmail.com>
 <20220317172013.rhjvknre5w7mfmlo@skbuf>
 <86tubvk24r.fsf@gmail.com>
 <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com>
 <20220318131943.hc7z52beztqlzwfq@skbuf>
 <86a6dixnd2.fsf@gmail.com>
 <20220322110806.kbdb362jf6pbtqaf@skbuf>
 <86fsn90ye8.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fsn90ye8.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 11:13:51AM +0100, Hans Schultz wrote:
> On tis, mar 22, 2022 at 13:08, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, Mar 22, 2022 at 12:01:13PM +0100, Hans Schultz wrote:
> >> On fre, mar 18, 2022 at 15:19, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> > On Fri, Mar 18, 2022 at 02:10:26PM +0100, Hans Schultz wrote:
> >> >> In the offloaded case there is no difference between static and dynamic
> >> >> flags, which I see as a general issue. (The resulting ATU entry is static
> >> >> in either case.)
> >> >
> >> > It _is_ a problem. We had the same problem with the is_local bit.
> >> > Independently of this series, you can add the dynamic bit to struct
> >> > switchdev_notifier_fdb_info and make drivers reject it.
> >> >
> >> >> These FDB entries are removed when link goes down (soft or hard). The
> >> >> zero DPV entries that the new code introduces age out after 5 minutes,
> >> >> while the locked flagged FDB entries are removed by link down (thus the
> >> >> FDB and the ATU are not in sync in this case).
> >> >
> >> > Ok, so don't let them disappear from hardware, refresh them from the
> >> > driver, since user space and the bridge driver expect that they are
> >> > still there.
> >> 
> >> I have now tested with two extra unmanaged switches (each connected to a
> >> seperate port on our managed switch, and when migrating from one port to
> >> another, there is member violations, but as the initial entry ages out,
> >> a new miss violation occurs and the new port adds the locked entry. In
> >> this case I only see one locked entry, either on the initial port or
> >> later on the port the host migrated to (via switch).
> >> 
> >> If I refresh the ATU entries indefinitly, then this migration will for
> >> sure not work, and with the member violation suppressed, it will be
> >> silent about it.
> >
> > Manual says that migrations should trigger miss violations if configured
> > adequately, is this not the case?
> >
> >> So I don't think it is a good idea to refresh the ATU entries
> >> indefinitely.
> >> 
> >> Another issue I see, is that there is a deadlock or similar issue when
> >> receiving violations and running 'bridge fdb show' (it seemed that
> >> member violations also caused this, but not sure yet...), as the unit
> >> freezes, not to return...
> >
> > Have you enabled lockdep, debug atomic sleep, detect hung tasks, things
> > like that?
> 
> I have now determined that it is the rtnl_lock() that causes the
> "deadlock". The doit() in rtnetlink.c is under rtnl_lock() and is what
> takes care of getting the fdb entries when running 'bridge fdb show'. In
> principle there should be no problem with this, but I don't know if some
> interrupt queue is getting jammed as they are blocked from rtnetlink.c?

Sorry, I forgot to respond yesterday to this.
By any chance do you maybe have an AB/BA lock inversion, where from the
ATU interrupt handler you do mv88e6xxx_reg_lock() -> rtnl_lock(), while
from the port_fdb_dump() handler you do rtnl_lock() -> mv88e6xxx_reg_lock()?
