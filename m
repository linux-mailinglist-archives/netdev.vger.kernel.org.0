Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4365E60D0FB
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 17:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJYPv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 11:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJYPv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 11:51:26 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D23DB760
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 08:51:24 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f193so11901813pgc.0
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 08:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3IsRHkRc4bEl50neUQe2Cwg6NxTTrju09y+ZMRWKHg=;
        b=WCIrwZWCW2YycWO9vWIVT2sAc6cNdb2o80CB+qu5lLpmpYArQjP5+LZukvbY4B1/5N
         4O6Stk4CVXUI00ciswJC1ytUhidkC4sDt4Zjy+Yt81IVxZh3MdEfZyjUHZr2wEYMDB7D
         hawUdBrGOtvxRaYynvjOuYVtq1CvkU1Mn476ydzEt2nU9UHxdn4uyZSFhgYqzoy5uS4x
         /9SqokTROQC9FbfAfQt46zfl6+2wi8BQadJAZIMezGpMYNKCZbDdWzdnz5MMqmdGGC60
         eZq6n8E9Dmt+xSkG8idqXl7+QlDOTB9iKgxapnZ7z9llpJD1dCx+k3LXJoFBsNQn0Jqi
         aHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p3IsRHkRc4bEl50neUQe2Cwg6NxTTrju09y+ZMRWKHg=;
        b=FE62mHrSJ5E0df2M8rgqb+e5BZ8WqqiW32kdxatDROeBJD+/7xzeqNkGApvNx/LZKd
         erOxFzAIpcjyrotgbp130vnpkVX4UYC1smLEg+TMKVPPGLEh0hPSCnE71M/KeVtJ26+g
         xdwYxFBZGr4bGZJqOx3wbykzHnupGg7HuBPAUq2zFxwq2H7O55lxgxWIoOln7AVbuQ9y
         31JiTXWhS37hj+J5jvqsA8UC717cSSdRn7AfZecOrxePKgmXOIUZ//CSqFsBLZ7bquIy
         hP2lEl6rnrrXecirAuoN2tZcLPNs1V3G1JiIrArnJjWbjhP2qzPvdi9ezvOPFQ1nl+17
         aKJw==
X-Gm-Message-State: ACrzQf3dAvDigWwdQumwfzSMCN0/HroHHN8SsuLQg6+BjMkY03KvKdd3
        u/o9X48uSRf8/dpkG/VKBdMYxQ==
X-Google-Smtp-Source: AMsMyM4J6klp650HU/VWvGmKFG0A7GlUEZyBTQMEIEX2npsoiEHGz+hIfWcOpijO9zqwIO+I1JQoOQ==
X-Received: by 2002:a65:6055:0:b0:42a:7b2b:dc71 with SMTP id a21-20020a656055000000b0042a7b2bdc71mr33054438pgp.23.1666713084160;
        Tue, 25 Oct 2022 08:51:24 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f137-20020a62388f000000b0056bd6b14144sm1524847pfa.180.2022.10.25.08.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 08:51:23 -0700 (PDT)
Date:   Tue, 25 Oct 2022 08:51:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2 3/4] ip-monitor: Include stats events in
 default and "all" cases
Message-ID: <20221025085122.3e1e58f9@hermes.local>
In-Reply-To: <20220922061938.202705-4-bpoirier@nvidia.com>
References: <20220922061938.202705-1-bpoirier@nvidia.com>
        <20220922061938.202705-4-bpoirier@nvidia.com>
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

On Thu, 22 Sep 2022 15:19:37 +0900
Benjamin Poirier <bpoirier@nvidia.com> wrote:

> It seems that stats were omitted from `ip monitor` and `ip monitor all`.
> Since all other event types are included, include stats as well. Use the
> same logic as for nexthops.
> 
> Fixes: a05a27c07cbf ("ipmonitor: Add monitoring support for stats events")
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>

This change has caused a regression. Simple ip monitor command now fails.

$ ip monitor
Failed to add stats group to list

The failure is from setsockopt() returning -EINVAL

Using git bisect this patch is identified as the cause.
Please fix ASAP or will revert from next release and maybe even make
a point release to remove it.

