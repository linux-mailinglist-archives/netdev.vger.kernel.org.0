Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F0DA3A4C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfH3PZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:25:32 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33968 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbfH3PZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:25:32 -0400
Received: by mail-qk1-f195.google.com with SMTP id m10so6488925qkk.1
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 08:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uAGNj/k9sxhyWPF4gW8v9ANxItk70JmBhK3Bz890W+M=;
        b=j+V6+/Z819VI1YZCoOnBj/oMDBF8SifHtR2Py7Q6rcAn92pGtORGovoGCON3Xa0lEX
         mxAwlsSE96mMR4c61G9G8QRLocu2g29Ge8DsiPpZhLQtBn5g7rnvG1bZS0vRFyLLpUTi
         KFDkNrI8kkq2QeMA60xq6RRi5XmiTP6vF7tokvFja6/cKXod0up2/W3LB6o9eFp4H/yY
         LJ6JRhF31aQpNRTjiSXK9uHJasLwOO4iLkUiazLH6+SWDJCh1fQVNiKgaHLXlY6vO7W/
         cdjf95wdC7m+IpXiXMrUqxD3WZVng2GUkXt8H/YEuy8WtKiRq/pMEFgtNh71FTkAJy5g
         TwQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uAGNj/k9sxhyWPF4gW8v9ANxItk70JmBhK3Bz890W+M=;
        b=Sh7tuHC7ob1dP5DFq+3JOee8URyzrwpP8Btshw2fONILltu3A+M5G1pc5maMT3HFBQ
         n+5YaEGYcdqPDOBrFyf7Elk8p2bBHi3xAtIy/6rH52Y3QuN1sF7f6CBRf6y2u5uxiMKT
         Ie7aYMuxTrX505rcCYiGba1SP4xheQ2nbWov+x9mbNuOq5AkAANtGVR2cKMBn5rMbp37
         1F0CtlXYK3lfcTSQ7v8qNbhP8WoBnxb5h+NhOLroaUwh8/W7ejsj1XukpI2EVORn3CDB
         a7+bUiwBRRQNx8W8iBezdzsYML6WSg7pydVKZ0wSZCpZ+o0lm8tAF2FoOTGhpq6cyfZC
         Z8IA==
X-Gm-Message-State: APjAAAVKn7ZouaQlop5GLDqEMUy4gdM4mtPVB5ymE2ueng4Pw56NPZBM
        8VR8P9EhoVObL3FclNy9bEG5DQnrcwI=
X-Google-Smtp-Source: APXvYqw0EhdXHc1wpLtFj5TejUK0OxSVjZ2aoiu/qaTO83bFRR+7CanolrCjPltbXW/VvIZh7EuyQg==
X-Received: by 2002:a37:4d0c:: with SMTP id a12mr15819201qkb.214.1567178731214;
        Fri, 30 Aug 2019 08:25:31 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id l8sm3559996qti.65.2019.08.30.08.25.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:25:30 -0700 (PDT)
Message-ID: <1567178728.5576.32.camel@lca.pw>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
From:   Qian Cai <cai@lca.pw>
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 30 Aug 2019 11:25:28 -0400
In-Reply-To: <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
References: <1567177025-11016-1-git-send-email-cai@lca.pw>
         <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-08-30 at 17:11 +0200, Eric Dumazet wrote:
> 
> On 8/30/19 4:57 PM, Qian Cai wrote:
> > When running heavy memory pressure workloads, the system is throwing
> > endless warnings below due to the allocation could fail from
> > __build_skb(), and the volume of this call could be huge which may
> > generate a lot of serial console output and cosumes all CPUs as
> > warn_alloc() could be expensive by calling dump_stack() and then
> > show_mem().
> > 
> > Fix it by silencing the warning in this call site. Also, it seems
> > unnecessary to even print a warning at all if the allocation failed in
> > __build_skb(), as it may just retransmit the packet and retry.
> > 
> 
> Same patches are showing up there and there from time to time.
> 
> Why is this particular spot interesting, against all others not adding
> __GFP_NOWARN ?
> 
> Are we going to have hundred of patches adding __GFP_NOWARN at various points,
> or should we get something generic to not flood the syslog in case of memory
> pressure ?
> 

From my testing which uses LTP oom* tests. There are only 3 places need to be
patched. The other two are in IOMMU code for both Intel and AMD. The place is
particular interesting because it could cause the system with floating serial
console output for days without making progress in OOM. I suppose it ends up in
a looping condition that warn_alloc() would end up generating more calls into
__build_skb() via ksoftirqd.
