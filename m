Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B874960D99D
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 05:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiJZDUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 23:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiJZDUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 23:20:31 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5429356FF
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 20:20:29 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m6so14084170pfb.0
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 20:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UijfZkhhOd/9Z5y9Qv0h/3Zkv1JGI7ZbtS+5gBiOpBk=;
        b=CO5MWBJcTWDMD/v/VQiGPQEGy2l1mdNYtq7s5s3XCL7o8ohzqiTax3dbkoCRcwS7jr
         S8768t7abubpUHSuEbHQSqJzt1PSDJjNiX6+hb9hhJx9J592qig3XnEnJqYYJ6RbRDWw
         xa/1JlwRIoL2mkWhno1/Htah4T8sAP+c9nSRiTyxnIr1lWB/pjzRcKkqJg7tE9E24KGS
         t/aC7xnlwgvB9gR6NoVw/5anpKnVKwiBaSOs+whmw22yrsh3RGhVPtLN7sXnH2BL5wO3
         UECyyYf4TEOuwrL6vO12klYNVIYJ4HJGsH4XCjQF16xdQ5zqZjdK55SrpGFBp1xmCs+k
         aNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UijfZkhhOd/9Z5y9Qv0h/3Zkv1JGI7ZbtS+5gBiOpBk=;
        b=OAcAgm6ZEoyp5CGPGizoImEdxoF4JMYxb50wDDQKKhpXFapC0gRtdcX98b8GT7o/Ta
         nfkazTbAjth9DMss6m7qAwbAvSC4WQOlA1CT6brWwLershMQpEPduUnB0rAJz6mLxXua
         8spBpzFSQF91tH+JWeLVLMJqZPhMhxwouQi1SHqUImok1AVoZTCOFOqHCZgJne/NA7Gy
         ZZ/9KJ992EhQ3NJv5jp6q1HHKibOXJHsB6L3XDgOOFjuR8hDh3HB2TMDE0TK+wvVgpBU
         9N3zlraCjHUt/Ow5qT1U66UEVfV2oMHIfVre+IYFtfxPnOj8TRDLXzf8A+Ottw6uLMDx
         N1vA==
X-Gm-Message-State: ACrzQf2pGrSawfGLyqT0fF5qqrilBGZBo97vd3eA45Yl5wFWXRpy3PW+
        QsgVtpIcYUA6VyIOyBA2jPwPPX3qGBQjGA==
X-Google-Smtp-Source: AMsMyM4d3u8dLSiDCFgBCzejU6LdAMHeRIhZ7RhJdT82TqtwNqlBcPDAzomgo2q3eR/z6VZNfAow7w==
X-Received: by 2002:a05:6a00:16c4:b0:535:890:d52 with SMTP id l4-20020a056a0016c400b0053508900d52mr42344739pfc.9.1666754429093;
        Tue, 25 Oct 2022 20:20:29 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u1-20020a17090a1d4100b0020dda7efe61sm318534pju.5.2022.10.25.20.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 20:20:28 -0700 (PDT)
Date:   Tue, 25 Oct 2022 20:20:26 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2] ip-monitor: Do not error out when
 RTNLGRP_STATS is not available
Message-ID: <20221025202026.68d92100@hermes.local>
In-Reply-To: <20221025222909.1112705-1-bpoirier@nvidia.com>
References: <20220922082854.5aa1bffe@hermes.local>
        <20221025222909.1112705-1-bpoirier@nvidia.com>
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

On Wed, 26 Oct 2022 07:29:09 +0900
Benjamin Poirier <bpoirier@nvidia.com> wrote:

> Following commit 4e8a9914c4d4 ("ip-monitor: Include stats events in default
> and "all" cases"), `ip monitor` fails to start on kernels which do not
> contain linux.git commit 5fd0b838efac ("net: rtnetlink: Add UAPI toggle for
> IFLA_OFFLOAD_XSTATS_L3_STATS") because the netlink group RTNLGRP_STATS
> doesn't exist:
> 
>  $ ip monitor
>  Failed to add stats group to list
> 
> When "stats" is not explicitly requested, change the error to a warning so
> that `ip monitor` and `ip monitor all` continue to work on older kernels.
> 
> Note that the same change is not done for RTNLGRP_NEXTHOP because its value
> is 32 and group numbers <= 32 are always supported; see the comment above
> netlink_change_ngroups() in the kernel source. Therefore
> NETLINK_ADD_MEMBERSHIP 32 does not error out even on kernels which do not
> support RTNLGRP_NEXTHOP.
> 
> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
> Fixes: 4e8a9914c4d4 ("ip-monitor: Include stats events in default and "all" cases")
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>

There are two acceptable solutions:
1. Ignore the error, and never print any warning.
2. Don't ask for the stats feature with the default "ip monitor" and "ip monitor all"

Either way, it needs to be totally silent when built and run on older kernels.
