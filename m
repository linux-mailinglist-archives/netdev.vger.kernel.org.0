Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDD4606BCC
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJTW7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJTW7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:59:44 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218FC399C8
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:59:39 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e129so894225pgc.9
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuEoLap3fjqYgIGTqyDeOHS3gQj9fKX98K7mwkoxtmA=;
        b=P2h+iyfZjf6LVLj18YASJ4SeRRMEe4iDgopDA+inlyYjKyQ6W+6LiVjR/zxph5p2Nx
         DCibaHHjpWpu/E2flZ06sDm3YrWA8BJHtZhdIc+PRBUpC8jSj0+LGYrrazNwrDWH/cMK
         O/08lllJ6Er9VIOHjRNSSvornkHG6X8vKPmNqeG7SXrxQkuXP2AVPf23yVLq6LP/cG+K
         lUFoeXy4RvV3p/sxtrOXILva+UZzM1yGwMvoZ5I4oNWrPiRfLt6CWFP3GvLWNh72v8eu
         eIQTRY9YDmKh/GeLJuzJEuq+1j7xaQbWJP4cMqyw2qzJHwUxENIbdq9qQED2BuEUEyV3
         3Tow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GuEoLap3fjqYgIGTqyDeOHS3gQj9fKX98K7mwkoxtmA=;
        b=29TrEFr+oGYhovb59CYn0riVBOYyjFFJb3ORWQRpa/+IXI9anVuX/ZmtFHWAeEijJl
         guMPqkJXMSAXD9Bxs7rawUaJPpR8w6qKQGyD0hM3UU6jIA5tFhuhuDxlLpR5u2GLrD40
         LPyw6szAaB5+UYlqFkeTwxNDAs86gLsodptrfU0ZmMAniZv9i+Y7tgFAhZAdPmT+pYj3
         M3jJVFBeurC4ggNxFD6ag89bcOLJtlG9r+MhpyUaA4XRDE48fLi2iCegfSXjCCcjbAD0
         v6Re2GRqRI2hGiyPuu33Z2IRPC9ECqEdNju9YLuo4ZEym/KfoZj/GpgjchYXLUWE63+5
         NQsA==
X-Gm-Message-State: ACrzQf1ko8Fujday3kudQcc0STp1Vhi7PEmuvJTVfzQonNhdgj94U3qw
        FaDKx5fq6pdLXTBPnAtVqs2S2A==
X-Google-Smtp-Source: AMsMyM5mG1wagvLlVBipOVrDdcSw6n2mLS/nrMl+cCWw1i4ZhjjutWserOHBX2jvpUbrgUDvxK/9xA==
X-Received: by 2002:a63:106:0:b0:460:64ce:51c4 with SMTP id 6-20020a630106000000b0046064ce51c4mr13508570pgb.17.1666306779248;
        Thu, 20 Oct 2022 15:59:39 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d4-20020a62f804000000b005628a30a500sm13855390pfh.41.2022.10.20.15.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 15:59:39 -0700 (PDT)
Date:   Thu, 20 Oct 2022 15:59:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hao Lan <lanhao@huawei.com>
Cc:     <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <huangguangbin2@huawei.com>, <chenjunxin1@huawei.com>,
        <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH iproute2] dcb: unblock mnl_socket_recvfrom if not
 message received
Message-ID: <20221020155936.0868a482@hermes.local>
In-Reply-To: <20221019012008.11322-1-lanhao@huawei.com>
References: <20221019012008.11322-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 09:20:08 +0800
Hao Lan <lanhao@huawei.com> wrote:

> From: Junxin Chen <chenjunxin1@huawei.com>
> 
> Currently, the dcb command sinks to the kernel through the netlink
> to obtain information. However, if the kernel fails to obtain infor-
> mation or is not processed, the dcb command is suspended.
> 
> For example, if we don't implement dcbnl_ops->ieee_getpfc in the
> kernel, the command "dcb pfc show dev eth1" will be stuck and subsequent
> commands cannot be executed.
> 
> This patch adds the NLM_F_ACK flag to the netlink in mnlu_msg_prepare
> to ensure that the kernel responds to user requests.
> 
> After the problem is solved, the execution result is as follows:
> $ dcb pfc show dev eth1
> Attribute not found: Success
> 
> Fixes: 67033d1c1c ("Add skeleton of a new tool, dcb")
> Signed-off-by: Junxin Chen <chenjunxin1@huawei.com>

Applied, fixed these two checkpatch warnings in original submission.

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: 67033d1c1c8a ("Add skeleton of a new tool, dcb")'
#74: 
Fixes: 67033d1c1c ("Add skeleton of a new tool, dcb")

WARNING: line length of 101 exceeds 100 columns
#89: FILE: dcb/dcb.c:159:
+	nlh = mnlu_msg_prepare(dcb->buf, nlmsg_type, NLM_F_REQUEST | NLM_F_ACK, &dcbm, sizeof(dcbm));

total: 0 errors, 2 warnings, 8 lines checked
