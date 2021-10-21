Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB2436D35
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhJUWEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhJUWEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 18:04:49 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E87EC061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 15:02:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f5so1489903pgc.12
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 15:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WnJ8dTET/uElGQB+u+TeGLr7xa/N5ihJJAuq9m/mi/w=;
        b=GtKwPrTITzUWVxRxe9zVWaParHEQN7+p67bbgE6IfmZQQmn4Sdo7bIihoV/+xs0w8C
         Hsf96WdNgavTTgvAs+81Gnj3wwBuCaHSJjRIpg1s9oE2Wu/ojRMDE/OGI9JQoOaSKEjt
         fUpP62Gi/JlnkovtvyBFhe5q8Qh86lb1qfVpfwCY4TQGFAzHSxU1ZP7AR05arPVZlQOE
         nHu6hkhomZATff9zGrGfFeT97PkEJQbuhrYnDQPYta/fKlUPH/oNUrnp7+gRNkGd2+SK
         2ExO7zc97oYkJXyj/mC76syov1PukGGfzUg/lOuM9OODMltu2k8G94KCIFmb8uvcvVeb
         8hbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WnJ8dTET/uElGQB+u+TeGLr7xa/N5ihJJAuq9m/mi/w=;
        b=Wk6WGj6uajusSwmH2Cy2YyTuABW/8ciKOKmGXozatI9EN2Ewv4eh1I33nOgk2nG9jV
         ZyotDpkvzWOGURRqblGnqDN8EPokEHw55nTG8+BXBLeAf2rjs5ILrEE64SZlbJp99942
         whKAV30gTHsRC5fFezuhchZ3jsw60PxYZiuKfgDm5hxSNllXu+cEHxJSPb6H8H2xGr1I
         E0f3KtZnfy5ESEEEmBu0tREiFwyDG3YPvr3vz4JniYD9c4Tqrhd6K8KE99OZeNvrUlOI
         j1v6iqoPbc6E6BnZqebl2tCMhqQ79ICPIjB0oaZBqtJ3CcuLYDborYyeCsdX6rHfrEBX
         uMMQ==
X-Gm-Message-State: AOAM5333o60MqRQ/euBaCwDyA/x2ocsC7fgqCrjWQ/cIvzWkiP+965L1
        m0RfOXi1+AHp+gQUDX8ULAk=
X-Google-Smtp-Source: ABdhPJyz1btGi4m7F90RcJ0A6o5wekvpsMxhw3NGuFIaEM9n5diJFeVI2s0OpGhR0ujYxdl8sqZ4CQ==
X-Received: by 2002:a63:6a05:: with SMTP id f5mr6378007pgc.97.1634853753073;
        Thu, 21 Oct 2021 15:02:33 -0700 (PDT)
Received: from [192.168.254.15] ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id 17sm6738943pgr.10.2021.10.21.15.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 15:02:32 -0700 (PDT)
Message-ID: <1903d7cb20ac31d95e2440424a00190522facb47.camel@gmail.com>
Subject: Re: [PATCH v5 0/2] Make neighbor eviction controllable by userspace
From:   James Prestwood <prestwoj@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Chinmay Agarwal <chinagar@codeaurora.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Date:   Thu, 21 Oct 2021 14:59:09 -0700
In-Reply-To: <a33c3f84-7333-294a-9e78-580cbdac6ec1@gmail.com>
References: <20211021003212.878786-1-prestwoj@gmail.com>
         <a33c3f84-7333-294a-9e78-580cbdac6ec1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, 2021-10-20 at 20:33 -0600, David Ahern wrote:
> On 10/20/21 6:32 PM, James Prestwood wrote:
> > v1 -> v2:
> > 
> >  - It was suggested by Daniel Borkmann to extend the neighbor table
> > settings
> >    rather than adding IPv4/IPv6 options for ARP/NDISC separately. I
> > agree
> >    this way is much more concise since there is now only one place
> > where the
> >    option is checked and defined.
> >  - Moved documentation/code into the same patch
> >  - Explained in more detail the test scenario and results
> > 
> > v2 -> v3:
> > 
> >  - Renamed 'skip_perm' to 'nocarrier'. The way this parameter is
> > used
> >    matches this naming.
> >  - Changed logic to still flush if 'nocarrier' is false.
> > 
> > v3 -> v4:
> > 
> >  - Moved NDTPA_EVICT_NOCARRIER after NDTPA_PAD
> > 
> > v4 -> v5:
> > 
> >  - Went back to the original v1 patchset and changed:
> >  - Used ANDCONF for IN_DEV macro
> >  - Got RCU lock prior to __in_dev_get_rcu(). Do note that the logic
> >    here was extended to handle if __in_dev_get_rcu() fails. If this
> >    happens the existing behavior should be maintained and set the
> >    carrier down. I'm unsure if get_rcu() can fail in this context
> >    though. Similar logic was used for in6_dev_get.
> >  - Changed ndisc_evict_nocarrier to use a u8, proper handler, and
> >    set min/max values.
> > 
> 
> I'll take a deep dive on the patches tomorrow.
> 
> You need to add a selftests script under tools/testing/selftests/net
> that shows this behavior with the new setting set and unset. This is
> easily done with veth pairs and network namespaces (one end of the
> veth
> pair down sets the other into no-carrier). Take a look at the scripts
> there - e.g., fib_nexthops.sh should provide a template for a start
> point.

So the test itself is pretty simple. The part I'm unsure about is how
you actually set the carrier state from userspace. I see "ip link set
<dev> carrier {on,off}" but this reports not supported for veths,
wlans, and eth interfaces I have tried. AFAIK the driver controls the
carrier state. Maybe some drivers do support this?

Is there a way to set the carrier state that you, or anyone is aware
of?

Thanks,
James

