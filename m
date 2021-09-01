Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7753FE48D
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 23:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbhIAVIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 17:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244853AbhIAVIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 17:08:44 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BF1C061764
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 14:07:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k24so777726pgh.8
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F3dWNJGQ6LgTixBw5Hh1ZhQhsBBgIqvnsSvcWV7sabo=;
        b=lu4uTeVnMam0bXo9mcKPeDuKOfRVDTfiH6BWi4vy3poSh8UcByMt63twfT2DJIaoo2
         VZJphNN1ek6UohVofzeuFMF5h+EZ8Oalt0i793VAHLxtD9eacngJE3EW6keTQSbsO5CO
         Q0lvzOO3B+3LcwjU1ZK33TYBUVhXx/vK5D968=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F3dWNJGQ6LgTixBw5Hh1ZhQhsBBgIqvnsSvcWV7sabo=;
        b=qzyg5SbNwiD4CCWCQM1Kg8NpaZpZ6gyJ/z+buGlwj9zRHsxiizVY9Mj+pXYhFiGPCq
         L/9gUL6Vx5M6tfA2DRXG2+5zEI38Xkw26u3IB3TJ1KsiZE1MXUWbjqsIa10PJM7jZXST
         qVt9X4ynGTYAszWCGHzQ/dhGrdcVhFYL4CEvWzgpZ8QSyXBV+E8Dbv53JNKYREguj2/v
         iot+R+7anSUHG/3Sk52+2tCv/pOK6R6LxNDQsgeXkXl1XGpWQNuWg6IhYIatMuYrQ/KE
         wFayZDW0EH4liNUbHcBQGsqQOi7w4W2PKvcKswsAH3MWSAwTvsNbCKNyaGwBOck6SOPm
         asaQ==
X-Gm-Message-State: AOAM533H0XyROs+FKOmIzNmmEQKmM5E53vGleM2l/Pfdge8dlDMpZfkT
        C5Z9YSPpUHw2SfLS8yNY/p+n3A==
X-Google-Smtp-Source: ABdhPJzYhP2mOJxIUgf/e/cGXoHVfpmUo/dISx+WQIJjJ+h6LP97ULYgJE0691fKOlnRe4UELH7jBA==
X-Received: by 2002:aa7:946e:0:b0:3fa:1317:f5b5 with SMTP id t14-20020aa7946e000000b003fa1317f5b5mr1329159pfq.25.1630530466226;
        Wed, 01 Sep 2021 14:07:46 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:1b89:ff21:8208:947])
        by smtp.gmail.com with ESMTPSA id s5sm599125pgp.81.2021.09.01.14.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 14:07:45 -0700 (PDT)
Date:   Wed, 1 Sep 2021 14:07:43 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
Message-ID: <YS/rn8b0O3FPBbtm@google.com>
References: <20210830123704.221494-1-verdre@v0yd.nl>
 <20210830123704.221494-2-verdre@v0yd.nl>
 <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
 <CAHp75VdR4VC+Ojy9NjAtewAaPAgowq-3rffrr3uAdOeiN8gN-A@mail.gmail.com>
 <CA+ASDXNGR2=sQ+w1LkMiY_UCfaYgQ5tcu2pbBn46R2asv83sSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXNGR2=sQ+w1LkMiY_UCfaYgQ5tcu2pbBn46R2asv83sSQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies for the brain-dead mailer. I forget that I should only reply
via web when I _want_ text wrapping:

On Wed, Sep 01, 2021 at 02:04:04PM -0700, Brian Norris wrote:
> (b) latency spikes to ~6ms:
> # trace-cmd record -p function_graph -O funcgraph-abstime -l
> mwifiex_pm_wakeup_card
> # trace-cmd report
>    kworker/u13:0-199   [003]   348.987306: funcgraph_entry:      #
> 6219.500 us |  mwifiex_pm_wakeup_card();
>    kworker/u13:0-199   [003]   349.316312: funcgraph_entry:      #
> 6267.625 us |  mwifiex_pm_wakeup_card();
>    kworker/u13:3-4057  [001]   352.238530: funcgraph_entry:      #
> 6184.250 us |  mwifiex_pm_wakeup_card();
>    kworker/u13:0-199   [002]   356.626366: funcgraph_entry:      #
> 6553.166 us |  mwifiex_pm_wakeup_card();
>    kworker/u13:3-4057  [002]   356.709389: funcgraph_entry:      #
> 6212.500 us |  mwifiex_pm_wakeup_card();
>    kworker/u13:3-4057  [002]   356.847215: funcgraph_entry:      #
> 6230.292 us |  mwifiex_pm_wakeup_card();
>    kworker/u13:3-4057  [000]   356.897576: funcgraph_entry:      #
> 6451.667 us |  mwifiex_pm_wakeup_card();
>    kworker/u13:0-199   [004]   357.175025: funcgraph_entry:      #
> 6204.042 us |  mwifiex_pm_wakeup_card();
> 
> whereas it used to look more like:
> 
>    kworker/u13:1-173   [005]   212.230542: funcgraph_entry:
> 7.000 us   |  mwifiex_pm_wakeup_card();
>    kworker/u13:3-1768  [005]   213.886063: funcgraph_entry:
> 9.334 us   |  mwifiex_pm_wakeup_card();
>    kworker/u13:3-1768  [002]   214.473273: funcgraph_entry:      +
> 11.375 us  |  mwifiex_pm_wakeup_card();
>    kworker/u13:3-1768  [005]   214.530705: funcgraph_entry:
> 5.542 us   |  mwifiex_pm_wakeup_card();
>    kworker/u13:1-173   [002]   215.050168: funcgraph_entry:      +
> 13.125 us  |  mwifiex_pm_wakeup_card();
>    kworker/u13:1-173   [002]   215.106492: funcgraph_entry:      +
> 11.959 us  |  mwifiex_pm_wakeup_card();
>    kworker/u13:3-1768  [005]   215.484807: funcgraph_entry:
> 8.459 us   |  mwifiex_pm_wakeup_card();
>    kworker/u13:1-173   [003]   215.515238: funcgraph_entry:      +
> 15.166 us  |  mwifiex_pm_wakeup_card();
>    kworker/u13:3-1768  [001]   217.175691: funcgraph_entry:      +
> 11.083 us  |  mwifiex_pm_wakeup_card();

That should read:

# trace-cmd record -p function_graph -O funcgraph-abstime -l mwifiex_pm_wakeup_card
# trace-cmd report
   kworker/u13:0-199   [003]   348.987306: funcgraph_entry:      # 6219.500 us |  mwifiex_pm_wakeup_card();
   kworker/u13:0-199   [003]   349.316312: funcgraph_entry:      # 6267.625 us |  mwifiex_pm_wakeup_card();
   kworker/u13:3-4057  [001]   352.238530: funcgraph_entry:      # 6184.250 us |  mwifiex_pm_wakeup_card();
   kworker/u13:0-199   [002]   356.626366: funcgraph_entry:      # 6553.166 us |  mwifiex_pm_wakeup_card();
   kworker/u13:3-4057  [002]   356.709389: funcgraph_entry:      # 6212.500 us |  mwifiex_pm_wakeup_card();
   kworker/u13:3-4057  [002]   356.847215: funcgraph_entry:      # 6230.292 us |  mwifiex_pm_wakeup_card();
   kworker/u13:3-4057  [000]   356.897576: funcgraph_entry:      # 6451.667 us |  mwifiex_pm_wakeup_card();
   kworker/u13:0-199   [004]   357.175025: funcgraph_entry:      # 6204.042 us |  mwifiex_pm_wakeup_card();

vs.

   kworker/u13:1-173   [005]   212.230542: funcgraph_entry:        7.000 us   |  mwifiex_pm_wakeup_card();
   kworker/u13:3-1768  [005]   213.886063: funcgraph_entry:        9.334 us   |  mwifiex_pm_wakeup_card();
   kworker/u13:3-1768  [002]   214.473273: funcgraph_entry:      + 11.375 us  |  mwifiex_pm_wakeup_card();
   kworker/u13:3-1768  [005]   214.530705: funcgraph_entry:        5.542 us   |  mwifiex_pm_wakeup_card();
   kworker/u13:1-173   [002]   215.050168: funcgraph_entry:      + 13.125 us  |  mwifiex_pm_wakeup_card();
   kworker/u13:1-173   [002]   215.106492: funcgraph_entry:      + 11.959 us  |  mwifiex_pm_wakeup_card();
   kworker/u13:3-1768  [005]   215.484807: funcgraph_entry:        8.459 us   |  mwifiex_pm_wakeup_card();
   kworker/u13:1-173   [003]   215.515238: funcgraph_entry:      + 15.166 us  |  mwifiex_pm_wakeup_card();
   kworker/u13:3-1768  [001]   217.175691: funcgraph_entry:      + 11.083 us  |  mwifiex_pm_wakeup_card();

Brian
