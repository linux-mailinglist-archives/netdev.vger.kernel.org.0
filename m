Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127B31E6779
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405059AbgE1Qdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:33:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42500 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404897AbgE1Qdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 12:33:33 -0400
Received: by mail-pg1-f196.google.com with SMTP id 124so7506759pgi.9;
        Thu, 28 May 2020 09:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XxXOHuyOlTLP5clwe4Wfz+4oQPRkCpYLYjIK2vvc1Vc=;
        b=V5M+o2gHEw668QnUY5F6f44G5KUR6NgQbGhYD/8t5UebEoI1A7tCaNCr2C8ftiVkLN
         34J+wDay4hiC3L3UhEAPS8xtk6AeZNI5Xzw8T/ZrqSMVepQvgAc5PBnjVEjRpKunXgV2
         nPcxBiTpQZAt4E6B/iO7xQu4akNlqGhV1oCb1P6meSSST90w5LgHrxIWAMr5fIFzGNAY
         rkrd9udr4gbTF+n/olKDvjpmXJSZUYeTv9JMHvwojqSLm1XBD9T0sqsA9sROl++7SumZ
         ldNgNVX3DzRXssODuYwN52kE+3cLd5AFrOMYXqv5tPK8OCU5UeaZLsGXElyO7YHXU0jo
         j0uQ==
X-Gm-Message-State: AOAM532NovqiXzIxhh+BtIsZD0CJpqmUlyH86/qqjO0OnpDx5Gv7vJx5
        9bMLR+Zvq3wv2TEAqUxFNF7cynRVHpLoog==
X-Google-Smtp-Source: ABdhPJx1jBQzRGhW2319wh/Cdnj+1/Ow9Nn2swZRY4W4Fm3QkC33znEjHcM8N6hO+Dn0qaSsElNinw==
X-Received: by 2002:a63:c34a:: with SMTP id e10mr3799891pgd.412.1590683611946;
        Thu, 28 May 2020 09:33:31 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id i11sm5189778pfq.2.2020.05.28.09.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 09:33:30 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 09B3640605; Thu, 28 May 2020 16:33:30 +0000 (UTC)
Date:   Thu, 28 May 2020 16:33:29 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, jeyu@kernel.org,
        davem@davemloft.net, michael.chan@broadcom.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        derosier@gmail.com, keescook@chromium.org, daniel.vetter@ffwll.ch,
        will@kernel.org, mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/8] kernel: taint when the driver firmware crashes
Message-ID: <20200528163329.GT11244@42.do-not-panic.com>
References: <20200526145815.6415-1-mcgrof@kernel.org>
 <20200526154606.6a2be01f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200526230748.GS11244@42.do-not-panic.com>
 <20200526163031.5c43fc1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200527031918.GU11244@42.do-not-panic.com>
 <20200527143642.5e4ffba0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200528142705.GQ11244@42.do-not-panic.com>
 <58639bf9-b67c-0cbb-d4c0-69c4e400daff@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58639bf9-b67c-0cbb-d4c0-69c4e400daff@candelatech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 08:04:50AM -0700, Ben Greear wrote:
> 
> Could you post your devlink RFC patches somewhere public?

This cover letter provided a URL to these.

  Luis
