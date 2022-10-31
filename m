Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A04261360B
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiJaMXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiJaMW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:22:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA67F015
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:22:56 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v1so15702579wrt.11
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0+bm1LmIDaeLLgNIqgGkk+nrd4V7AL9cKyZ1Z+64RMo=;
        b=SuhgzMjbq+O3qu7JXKCmkSa9+Vh+Gcs1dIIcbJHN+SiNHxP/ak91znLUCAV3CmmC9N
         squl+1NXFHb+bHy0goTMdlGf+8b/pGDvW8n0FzfNK0RI6pq854sU1DK/lgj0t2LmBLVy
         ZlruZkQTu8R0wDsiogBoIHBtelJQFhJV9S0PC/toBdaP/o8mFkYNtx5yuS6aQ8HkRLRS
         wul549ujWJlm/qfdnZM7gafZoRHrcmCMi85m7GLLrMzlrjBTCo3G1WsigOgZ0v2U5WhB
         k+5lToM+eQWhXTtCyBrRD9nNkySYra/iXrPek0RXcffub81e03YBtm+yY8mbha6C7Zmp
         BgNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+bm1LmIDaeLLgNIqgGkk+nrd4V7AL9cKyZ1Z+64RMo=;
        b=xZNky1bfD/Hx3+tOkcLpH9CyU7U/jrNbQ6cqIE0bHtJzroDfB1Nf+KAb7blUKLcXAh
         yZExGLsgI4nVZosxGKRFlY1XJzVFWefmQPgrjkPhN8T79T5ixtGZP+WWpksqzkiXjkpz
         kLSQFd4E9yapTKrVViAYL7Sd66oq9yD+eY+oj8vcOewYte6UgXVjY9xGqJuRiP2wYqjW
         aAVPCJ2AjEszDFEWW52dJZ9OOu1z2Ft28xapnkON/7uXLJnt1xWa6BQuVMUhPu/KwxNw
         IBkcFGAGYHEZWhuJPHNxMP9Eaav+a4PtVADiQsz9m7z43TK09LF/xTeLxEyKklp8UyWv
         pasA==
X-Gm-Message-State: ACrzQf2DDaLz9Efecvhx2dtQxjDm/9CokUUW9yz0DA8KcBOXHYD6eetZ
        XX7FW35SGZ3s70AoReiRBMV64J5Y0AWo9KBC
X-Google-Smtp-Source: AMsMyM4O/dMCLFE1joXQt6xFSq8kJHusK32c/yFKLUAcFJUrdMH04V6Bje9cw9X3Xz1Bnp63XcumdQ==
X-Received: by 2002:adf:dbc6:0:b0:236:c090:905d with SMTP id e6-20020adfdbc6000000b00236c090905dmr4806883wrj.132.1667218974538;
        Mon, 31 Oct 2022 05:22:54 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t2-20020a05600c41c200b003c21ba7d7d6sm6908253wmh.44.2022.10.31.05.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:22:53 -0700 (PDT)
Date:   Mon, 31 Oct 2022 13:22:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v8 6/9] devlink: Allow to change priv in
 devlink-rate from parent_set callbacks
Message-ID: <Y1++Hcqm67cv30QA@nanopsycho>
References: <20221028105143.3517280-1-michal.wilczynski@intel.com>
 <20221028105143.3517280-7-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028105143.3517280-7-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 28, 2022 at 12:51:40PM CEST, michal.wilczynski@intel.com wrote:
>From driver perspective it doesn't make any sense to make any changes to
>the internal HQoS tree if the created node doesn't have a parent. So a
>node created without any parent doesn't have to be initialized in the
>driver. Allow for such scenario by allowing to modify priv in parent_set
>callbacks.
>
>Change priv parameter to double pointer, to allow for setting priv during
>the parent set phase.

I fail to understand the reason for this patch, but anyway, it looks
very hacky. The priv is something the leaf/node is created with.
Changing it from the callback awfully smells like wrong design. Please
don't do that.
