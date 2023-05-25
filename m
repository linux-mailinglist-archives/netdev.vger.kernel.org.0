Return-Path: <netdev+bounces-5373-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB50710F4A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84FAF280FC1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E39182B2;
	Thu, 25 May 2023 15:16:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C671095C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:16:06 +0000 (UTC)
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE19898
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:16:01 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-2532d6c7ef2so865705a91.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685027761; x=1687619761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J2b/3uRdLQvB1a1AkQjbqm2CzIjwmLhcA/Nedq80Teg=;
        b=L/pu/CjMwbKnOylyo/twBsrPieht5GtBjY5UZNv9dWqGcUYuz8rSd6VFXV1GttQO99
         tg0qNGxKyWVzJY/im04K9ecqgSyVWQgBdwaySgrajv0RHy1zNefwnb2Se8I7apwqGm5y
         yRvgLW2tviemOJllMT5l8h724pLWbCzsO+R6STUWQ5Txd6YXvDTL262A3R7Ked7h4rCL
         yt38NwUK8LJYmr96PSKHig3xlh48mgd8cWrYsI3G3cq+/fMbCf4WFkea/eovkiodpXAA
         nbDKKJlEHRpYK42UovrWleB4SjQ2tbEy4MUQbKxCfldGkRLuZWnMrKBacuWa0JZdSYtx
         cUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685027761; x=1687619761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J2b/3uRdLQvB1a1AkQjbqm2CzIjwmLhcA/Nedq80Teg=;
        b=GGxJ+S/lWSdocbZHXSHVhGQagMWomozwnFHr7PN7CxJvncBmV3s7Ql4pStmTgOEnZd
         PEqKMmwVKWOk59UWLmSfI3X9XntF7aoNKwX6d+HJuPFVjpOvoGPoHPZtXJqYx3ss886E
         m8QRgQFuzBWnNuQ0oaA2DURsSGKGc+nED1v8BMGCvfT5TZr1TFFURDDFrK4XMJfxwqHZ
         ikFqXJWL2g/XRlJtmBqH41XMeDxaTDTjm7cZjggib9ZJT707LfCAJJFdYRCcxzCKZzml
         vpJqA9HnVotaoBbytqgh3DwWLNpub4s5KWHWpLz9r1D/ydw7dLyjgZv+54i+WiIrbRMI
         82/Q==
X-Gm-Message-State: AC+VfDwKoViR0W/qwqFVTRQtiqRungctps5Y1pbaBoIHSFQ7unhhlZvJ
	WKLmHzMrtVI6pp5EhaQxdBUdBpX5+CcduprDGxZaxg==
X-Google-Smtp-Source: ACHHUZ5TspX7WMA1iRK7o+XSK3OrnMnx0zO6B1jFAfxxFIV4uJxjjPK5hgFbWllTIb10llojyp5Vyg==
X-Received: by 2002:a17:90a:d994:b0:252:977e:c257 with SMTP id d20-20020a17090ad99400b00252977ec257mr1958267pjv.23.1685027761044;
        Thu, 25 May 2023 08:16:01 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id me15-20020a17090b17cf00b002471deb13fcsm3218714pjb.6.2023.05.25.08.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 08:16:00 -0700 (PDT)
Date: Thu, 25 May 2023 08:15:58 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: bugzilla-daemon@kernel.org
Subject: Re: [Bug 217486] New: 'doubel fault' in if_nlmsg_size func by
 syz-executor fuzz
Message-ID: <20230525081558.38ee5cde@hermes.local>
In-Reply-To: <bug-217486-100@https.bugzilla.kernel.org/>
References: <bug-217486-100@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Not much info in this bug report.
Blaming if_nlmsg_size() is not right, something is passing bogus data.


On Thu, 25 May 2023 12:40:12 +0000
bugzilla-daemon@kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=217486
> 
>             Bug ID: 217486
>            Summary: 'doubel fault' in if_nlmsg_size func by syz-executor
>                     fuzz
>            Product: Networking
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: 13151562558@163.com
>         Regression: No
> 
> in syz-executor fuzz test, system panic in "double fault" err.
> by the kernel log, only get one dump stack info, "if_nlmsg_size+0x4ea/0x7c0".
> I have vmcore, but don't know how to debug "double fault"? what't first fault ?
> 
> if_nlmsg_size+0x4ea/0x7c0 code:
> ```
> static noinline size_t if_nlmsg_size(const struct net_device *dev,
>                                      u32 ext_filter_mask)
> {
>         return NLMSG_ALIGN(sizeof(struct ifinfomsg))
>                + nla_total_size(IFNAMSIZ) /* IFLA_IFNAME */
>                + nla_total_size(IFALIASZ) /* IFLA_IFALIAS */
> 
>                + nla_total_size(4)  /* IFLA_MIN_MTU */
>                + nla_total_size(4)  /* IFLA_MAX_MTU */
>                + rtnl_prop_list_size(dev) // this
> line;if_nlmsg_size+0x4ea/0x7c0
>                + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
>                + 0;
> }
> ```
> 
> dis the code of dump stack, like this:
> /include/linux/list.h: 
>  <if_nlmsg_size+1325>:        mov    %rbp,%rdx
>  <if_nlmsg_size+1328>:        shr    $0x3,%rdx
>  <if_nlmsg_size+1332>:        cmpb   $0x0,(%rdx,%rax,1)
>  <if_nlmsg_size+1336>:        jne    0xffffffff8a5b86a6 <if_nlmsg_size+1766>
>  <if_nlmsg_size+1342>:        mov    0x10(%r15),%rax
>  <if_nlmsg_size+1346>:        cmp    %rax,%rbp
>  <if_nlmsg_size+1349>:        je     0xffffffff8a5b8659 <if_nlmsg_size+1689>
> 
> 
> kernel log:
> [ 3213.317259] CPU: 1 PID: 1830 Comm: syz-executor.6 Tainted: G      D         
>  5.10.0 #1
> [ 3213.317404] RIP: 0010:if_nlmsg_size+0x53e/0x7c0
> [ 3213.317415] Code: 00 0f 85 2e 02 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
> 7b 10 49 8d 6f 10 48 89 ea 48 c1 ea 03 80 3c 02 00 0f 85 a8 01 00 00 <49> 8b 47
> 10 48 39 c5 0f 84 4e 01 00 00 e8 90 ff 1a f7 48 89 ea 48
> [ 3213.317420] RSP: 0018:ffff88809f4ca570 EFLAGS: 00010246
> [ 3213.317428] RAX: dffffc0000000000 RBX: ffff88803767c000 RCX:
> ffffc90006714000
> [ 3213.317433] RDX: 1ffff11008037c92 RSI: ffffffff8a5b84aa RDI:
> ffff88803767c010
> [ 3213.317439] RBP: ffff8880401be490 R08: 0000000000000cc0 R09:
> 0000000000000000
> [ 3213.317445] R10: ffffffff9287d2e7 R11: fffffbfff250fa5c R12:
> 0000000000000640
> [ 3213.317450] R13: 0000000000000950 R14: 0000000000000008 R15:
> ffff8880401be480
> [ 3213.317454]  ? if_nlmsg_size+0x4ea/0x7c0
> [ 3213.317457]  </#DF>
> 


