Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92765601A75
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiJQUjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiJQUih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:38:37 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989CF80F5A
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 13:36:26 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id b5so11482047pgb.6
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 13:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0aUWfNVyAb9vaQF2FsnyjOHdVA252Y6Vscje2rS+GNw=;
        b=RqmecjN1a274dMoS5AiB/PYlaI9BwNrkAqjfOyDLAVGvm4wNIfGWLZBCX8/QZRBBbU
         NhTBbos3s2SrejQiseGlAYdlO3zYm4tO5Rr5B5WiphqC21Gi+P3tc0dz52aQDYcV9JYN
         /HN89+d9REaNoLHET95VLKE73Qk4nE2F1jmuw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0aUWfNVyAb9vaQF2FsnyjOHdVA252Y6Vscje2rS+GNw=;
        b=AWlqDUjTrbBq9nMw35jQpcNvar8p0m+mtX8OVsTDbAWOqEHwyosPW3mOfbG9jKCv+3
         hutTOun2v4TsWOSJHPUf7mcmAaZxC+aXRzl1/PN1RF+9RdsVmAB0esNR5r++rV4ICkGb
         LyPDRH7AVmQumeWaxEEhK0ITzNF/ULF+AN8cjbzsp8V8mi9QJ2lGX4kwnAA47mpFHPDz
         JkQrUmBS0376lrMb3Z6CvJOgmktzXkSRq4RmbBGkCodGP7btNbNWXS6sZC/6xULtFErd
         DJ7iKPaJ//jCluKq2eqR6Es9U+HFnieXbXL2iixglHysWD8uUEGVfJ4UZkl3GwIlB2RS
         bodg==
X-Gm-Message-State: ACrzQf0SToyni8aQn4KtAP4JEiawZ8Nn92bk7i/hT801/d6Z6wPVb+ps
        /W9wUIoJIFoxBSfzcv4vBsw766CVQKpO9A==
X-Google-Smtp-Source: AMsMyM68W5CzLd1Q4HNgZTGmwXm6VXlfe1tkL8GEiHKV7LnRsNxYCNpQ9c/sRs89ly6lFJjEFmffyA==
X-Received: by 2002:a63:d845:0:b0:44b:d074:97d with SMTP id k5-20020a63d845000000b0044bd074097dmr12442525pgj.32.1666038983936;
        Mon, 17 Oct 2022 13:36:23 -0700 (PDT)
Received: from fastly.com (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id nm9-20020a17090b19c900b002071ee97923sm9975615pjb.53.2022.10.17.13.36.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Oct 2022 13:36:23 -0700 (PDT)
Date:   Mon, 17 Oct 2022 13:36:21 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com
Subject: Re: [net-queue bugfix RFC] i40e: Clear IFF_RXFH_CONFIGURED when RSS
 is reset
Message-ID: <20221017203620.GA18251@fastly.com>
References: <1665701671-6353-1-git-send-email-jdamato@fastly.com>
 <20221017124555.5d79d3f7@kernel.org>
 <e1d1ed2b-76d6-9f17-5256-6246a3f8e012@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1d1ed2b-76d6-9f17-5256-6246a3f8e012@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 01:25:39PM -0700, Jacob Keller wrote:
> 
> 
> On 10/17/2022 12:45 PM, Jakub Kicinski wrote:
> > On Thu, 13 Oct 2022 15:54:31 -0700 Joe Damato wrote:
> >> Before this change, reconfiguring the queue count using ethtool doesn't
> >> always work, even for queue counts that were previously accepted because
> >> the IFF_RXFH_CONFIGURED bit was not cleared when the flow indirection hash
> >> is cleared by the driver.
> > 
> > It's not cleared but when was it set? Could you describe the flow that
> > gets us to this set a bit more?
> > 
> > Normally clearing the IFF_RXFH_CONFIGURED in the driver is _only_
> > acceptable on error recovery paths, and should come with a "this should
> > never happen" warning.
> > 
> 
> Correct. The whole point of IFF_RXFH_CONFIGURED is to be able for the
> driver to know whether or not the current config was the default or a
> user specified value. If this flag is set, we should not be changing the
> config except in exceptional circumstances.
> 
> >> For example:
> >>
> >> $ sudo ethtool -x eth0
> >> RX flow hash indirection table for eth0 with 34 RX ring(s):
> >>     0:      0     1     2     3     4     5     6     7
> >>     8:      8     9    10    11    12    13    14    15
> >>    16:     16    17    18    19    20    21    22    23
> >>    24:     24    25    26    27    28    29    30    31
> >>    32:     32    33     0     1     2     3     4     5
> >> [...snip...]
> >>
> >> As you can see, the flow indirection hash distributes flows to 34 queues.
> >>
> >> Increasing the number of queues from 34 to 64 works, and the flow
> >> indirection hash is reset automatically:
> >>
> >> $ sudo ethtool -L eth0 combined 64
> >> $ sudo ethtool -x eth0
> >> RX flow hash indirection table for eth0 with 64 RX ring(s):
> >>     0:      0     1     2     3     4     5     6     7
> >>     8:      8     9    10    11    12    13    14    15
> >>    16:     16    17    18    19    20    21    22    23
> >>    24:     24    25    26    27    28    29    30    31
> >>    32:     32    33    34    35    36    37    38    39
> >>    40:     40    41    42    43    44    45    46    47
> >>    48:     48    49    50    51    52    53    54    55
> >>    56:     56    57    58    59    60    61    62    63
> > 
> > This is odd, if IFF_RXFH_CONFIGURED is set driver should not
> > re-initialize the indirection table. Which I believe is what
> > you describe at the end of your message:
> > 
> 
> Right. It seems like the driver should actually be checking this flag
> somewhere else and preventing the flow where we clear the indirection
> table...
> 
> We are at least in some places according to your report here, but
> perhaps there is a gap....

Thanks for the comments / information. I noticed that one other driver
(mlx5) tweaks this bit, which is what led me down this rabbit hole.

I'll have to re-read the i40e code and re-run some experiments with the
queue count and flow hash to get a better understanding of the current
behavior and verify/double check the results.

I'll follow-up with an email to intel-wired-lan about the current
(unpatched) behavior I'm seeing with i40e to double check if there's
a bug or if I've simply made a mistake somewhere in my testing.

I did run the experiments a few times, so it is possible I got into some
weird state. It is worth revisiting fresh from a reboot with a kernel built
from net-next.
