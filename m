Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5518D631C0B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 09:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiKUIwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 03:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiKUIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 03:52:23 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617A082BC3
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 00:52:16 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h23so7323501edj.1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 00:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5EKX9hkLxhPi34ZOuIB7WgZy5OSr/nuOfldd6jagSc0=;
        b=v2pXUiNWHHlmA3CgFN9RaBA5VmUKVPgU1gePlYZrS3D6SPaht5nDB2w5V4uOZQSLv+
         M7FPH1qscDF6KCdnLC+J2EwNIIM/nEuLJctgMy4zXfvQ83tdg0UmtA3J7f9J71w2RGh4
         RLhGqmnAVEwcyK7qRWSRs9/apwwWN2et6jg0UuYoCWBZPQfAhTA4q0TIZdhxwVABy7e1
         ZH/uPVovN2pAGSv01/Gl6oh1SZEHkLlTIU8erjJQnbTz+2cUinEPhlRdPkzXH8lr3xfE
         dGZDNJOL2etTmGnNsWZRibnLgznRdi0oTPc4vJtXZuz4xVpoBy5OEdBdl8s965GsgZ3r
         0obQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5EKX9hkLxhPi34ZOuIB7WgZy5OSr/nuOfldd6jagSc0=;
        b=o011qSrnbZ2IWdYygj90l+FaNnLvv0kjJvdtvCDzx/gWzFOzoQS/n6y6or0n7MbqhT
         iIGZ0ydDViOEt7ra0S5A+/6PBBcWmP/DJ59GpmV+2oAmiELyEhjEtaSsjH5g82q5dgYn
         QOXXVbD2reMdjKF2ENyzUhMVhaYu4/heAU3M0Mg3foy/RGpD1tgGWP8PQ7QTG1tbQWJO
         Xudg1ov6tF6qOJ1s+UkP/Oz/2d5aruqsD+eJFRqGNgZ7Fx/pruUCFonjS9rdi/gMhRpd
         NK140r3ecU8MPNmYTggbGFGK8IXsNuqQz5rufAhd9xYaPJPaZF3hVGcZzYPQ7usJs/4J
         Hpng==
X-Gm-Message-State: ANoB5pki6WGiEMFDByS25YhKfKsvZ1NL5U2Sx7Ql5rIF+jAFfVqAfVqJ
        Uqc1p7ViwDdJNiKKabWt0QXnxg==
X-Google-Smtp-Source: AA0mqf7NlGBLRMqJJD6VuzgvPTeyKU+9xBzZ2MKufx72NGx3Su8hyH1HugGQukHgksdHhKmkRbZ1ug==
X-Received: by 2002:a05:6402:1015:b0:461:5f19:61da with SMTP id c21-20020a056402101500b004615f1961damr15200850edu.34.1669020734874;
        Mon, 21 Nov 2022 00:52:14 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p13-20020a17090653cd00b007ade5cc6e7asm4762104ejo.39.2022.11.21.00.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 00:52:14 -0800 (PST)
Date:   Mon, 21 Nov 2022 09:52:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [patch iproute2] devlink: load ifname map on demand from
 ifname_map_rev_lookup() as well
Message-ID: <Y3s8PUndcemwO+kk@nanopsycho>
References: <20221109124851.975716-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109124851.975716-1-jiri@resnulli.us>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 09, 2022 at 01:48:51PM CET, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@nvidia.com>
>
>Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
>the ifname map to be loaded on demand from ifname_map_lookup(). However,
>it didn't put this on-demand loading into ifname_map_rev_lookup() which
>causes ifname_map_rev_lookup() to return -ENOENT all the time.
>
>Fix this by triggering on-demand ifname map load
>from ifname_map_rev_lookup() as well.
>
>Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
>Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Stephen, its' almost 3 weeks since I sent this. Could you please check
this out? I would like to follow-up with couple of patches to -next
branch which are based on top of this fix.

Thanks!
