Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E779D350
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbfHZPqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:46:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40667 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfHZPqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 11:46:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id c3so15795933wrd.7
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 08:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S9XyfXZPMwNi8B1mhqY6JRsfbgsglWp6bTOIvesrBK0=;
        b=j6cJnVPWCS6crQu/WoyR9tJuGtgqeSjScMteS5FtXWAva0dagJZ8k9x3wJG0zDaJj3
         MPGQtaw+wfmdqsDT//11sjcVeQZJR3xnKJwMWCcpsbj7tmFIVKYUv4N/LypvruW7VQBU
         mBMzZhMqNjKZA817jjHhoTKSqvsckcVHOB3dSyDum+QYt8fKfr/9DNyRG0XciKzpbtgv
         zBCI7oyTXkFoQEgkP6I8Me9zMLurx1vjYmWVNE2AkaoPbOCselmT2JX+eStsf/ic8oWL
         bRuOhMK1hbqvyTjqiAOQ2BGNHRUNomWQ9OQ51zHffwehmCAw6Ql9Huse0E+PSo5IrGAo
         gagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=S9XyfXZPMwNi8B1mhqY6JRsfbgsglWp6bTOIvesrBK0=;
        b=i4zCjb3ukep7bKb0sh3J2nEWJVzLfauKGYVNOLHPPiPBRcyA7/Z7q++i6jsS6gGSDS
         aQfIvObjU/ejev2wbEjpyvrfLj7NtWOkAA2govh+RoJkNmqWgb4Fw7uZQAOGQ1Yrf1pJ
         5nuk6fs/rTMnX0eMZVeHWa3BP3xhE/6rtYyXHUxvtFrP3J5kGyz6Xvfj9RK2Jg6zZTOW
         IG/f0zPNZYzXayFbVRTsjiit4y2cSgsJsbUDzma/LMbBaxX9I1uea2L1UGvVjoY1g47h
         mU3KsSnrYFcW4ptVbsOtxjAaGIlSeAsAfqrzs18Z9lRm6HqwUS5rBXo7L95kMvbGMbMR
         m2AQ==
X-Gm-Message-State: APjAAAVTpo7q0EZx6knTigm/2XCAJf4NsJn2PTiLtmaX0nb9xzUDkXG9
        VkXqN1SJmJMsC+NGY1u5u/cm7w==
X-Google-Smtp-Source: APXvYqyOZiOPREfH5Yviiau0XrExonHOBIgxlTIEdgDdioE7qYYTpzHPW8/BQ8SGtUhL4xwBGTYyjg==
X-Received: by 2002:adf:f54a:: with SMTP id j10mr23628924wrp.220.1566834395405;
        Mon, 26 Aug 2019 08:46:35 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s2sm15560043wrp.32.2019.08.26.08.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:46:34 -0700 (PDT)
Date:   Mon, 26 Aug 2019 17:46:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v3 03/10] net: sched: refactor block offloads
 counter usage
Message-ID: <20190826154634.GC2309@nanopsycho.orion>
References: <20190826134506.9705-1-vladbu@mellanox.com>
 <20190826134506.9705-4-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826134506.9705-4-vladbu@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 26, 2019 at 03:44:59PM CEST, vladbu@mellanox.com wrote:
>Without rtnl lock protection filters can no longer safely manage block
>offloads counter themselves. Refactor cls API to protect block offloadcnt
>with tcf_block->cb_lock that is already used to protect driver callback
>list and nooffloaddevcnt counter. The counter can be modified by concurrent
>tasks by new functions that execute block callbacks (which is safe with
>previous patch that changed its type to atomic_t), however, block
>bind/unbind code that checks the counter value takes cb_lock in write mode
>to exclude any concurrent modifications. This approach prevents race
>conditions between bind/unbind and callback execution code but allows for
>concurrency for tc rule update path.
>
>Move block offload counter, filter in hardware counter and filter flags
>management from classifiers into cls hardware offloads API. Make functions
>tcf_block_offload_{inc|dec}() and tc_cls_offload_cnt_update() to be cls API
>private. Implement following new cls API to be used instead:
>
>  tc_setup_cb_add() - non-destructive filter add. If filter that wasn't
>  already in hardware is successfully offloaded, increment block offloads
>  counter, set filter in hardware counter and flag. On failure, previously
>  offloaded filter is considered to be intact and offloads counter is not
>  decremented.
>
>  tc_setup_cb_replace() - destructive filter replace. Release existing
>  filter block offload counter and reset its in hardware counter and flag.
>  Set new filter in hardware counter and flag. On failure, previously
>  offloaded filter is considered to be destroyed and offload counter is
>  decremented.
>
>  tc_setup_cb_destroy() - filter destroy. Unconditionally decrement block
>  offloads counter.
>
>  tc_setup_cb_reoffload() - reoffload filter to single cb. Execute cb() and
>  call tc_cls_offload_cnt_update() if cb() didn't return an error.
>
>Refactor all offload-capable classifiers to atomically offload filters to
>hardware, change block offload counter, and set filter in hardware counter
>and flag by means of the new cls API functions.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
