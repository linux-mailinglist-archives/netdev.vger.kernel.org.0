Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5449A3FAC6D
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhH2PLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 11:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235546AbhH2PLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 11:11:14 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4CCC061575;
        Sun, 29 Aug 2021 08:10:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa17so7810694pjb.1;
        Sun, 29 Aug 2021 08:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N93QZNcq51tQSZUdO0Kv070YOACn4Rc3RLQDyDXZG54=;
        b=HEiWLJHmG5fkIj5xHsycepzBG3dFCxiwDMjEejtdQRbiV4Sa0XVwf7qrS7d1xdNdOE
         Dvpe9irPsJWyJMcsbeEavTvi68Nk4MUAD5nkyDV8usILKHTcfj9HutHi+RQmQVjrYk6W
         uN4npgE2PzBZD44Txw/wFq6ycJ/wAFWCPzO6NUMqFGlMoTt68Irg6N0OnTzvPaXpzi/T
         1mL+ZuPDx96NgBftj8ScDZtH18GlIno+zLlq6FZBcr6854VE0At/bIy7atCbI6pUnoVs
         /799Byw+YPyBhA8A4aINJc03lYVu68ogEGyRun7CcFuXD+l2QJiYJpWEQ7/UE6OH4aVW
         oz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N93QZNcq51tQSZUdO0Kv070YOACn4Rc3RLQDyDXZG54=;
        b=KR80QrHGspZGkpuVKVtyh+qX+/BC2dZzcERjd8nn+XwT+MAEKAfV4Io9+qIYX+omQd
         PqiJzDm2JLToDM6pWyc02jUIfF/LdLY+uSg7UXrx9EdPPh6/Wf+BY4QS+f8XxsS/RW2f
         BZvJNyRLN0NBVpEi753u1T+V1tHdK1IPlNP5av00Zvf+tlsQQBS49d3Etv0wOh3uWIdx
         aW7CRU/bYvmybIqTPL3XEcKYBCtTytJGWvkwWAu/wTme7ioKK4aqZL91NjpyoUmSRibt
         gU+C4KqLyF1DMUuhDe1IKlSDzDsC/NSIg3EQF/968AO8nDPB6OTdNnwuXeoJ6NlJ4VJ4
         hIpw==
X-Gm-Message-State: AOAM533PtLMYjcbPZG7ix6KolgNQArsW2JplzcnHu0fOiN6It1h50Kck
        aIgsdNT/5yXm8f6P3zhLxBQ=
X-Google-Smtp-Source: ABdhPJzBSWrvZ5LmOrzlTLefpc08UQ1K0h4khJQBKanqWU+YIS6xHJxjxHwh7fvTKyhFM18YPMlqTA==
X-Received: by 2002:a17:90a:86cc:: with SMTP id y12mr34607022pjv.127.1630249820771;
        Sun, 29 Aug 2021 08:10:20 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k4sm10378125pga.92.2021.08.29.08.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 08:10:20 -0700 (PDT)
Date:   Sun, 29 Aug 2021 08:10:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        abyagowi@fb.com, anthony.l.nguyen@intel.com, davem@davemloft.net,
        kuba@kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210829151017.GA6016@hoboy.vegasvil.org>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
 <20210829080512.3573627-2-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210829080512.3573627-2-maciej.machnikowski@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 10:05:11AM +0200, Maciej Machnikowski wrote:
> This patch adds the new RTM_GETSYNCESTATE message to query the status
> of SyncE syntonization on the device.
> 
> Initial implementation returns:
>  - SyncE DPLL state
>  - Source of signal driving SyncE DPLL (SyncE, GNSS, PTP or External)
>  - Current index of Pin driving the DPLL
> 
> SyncE state read needs to be implemented as ndo_get_synce_state function.
> 
> This patch is SyncE-oriented. Future implementation can add additional
> functionality for reading different DPLL states using the same structure.

I would call this more "ice oriented" than SyncE oriented.  I'm not
sure there is even such a thing as "SyncE DPLL".  Does that term come
from 802.3?  To my understanding, that is one just way of implementing
it that works on super-Gigabit speed devices.

I have nothing against exposing the DPLL if you need to, however I'd
like to have an interface that support plain Gigabit as well.  This
could be done in a generic way by offering Control Register 9 as
described in 802.3.

Thanks,
Richard
