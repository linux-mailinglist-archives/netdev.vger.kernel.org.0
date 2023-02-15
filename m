Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE6E6977B0
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjBOH5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbjBOH5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:57:07 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F34B29E25
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:57:06 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id hx15so45992384ejc.11
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=siTfL/yZSt5KB6RuHE8DL5yeufXgA42G2FTvpMR4eps=;
        b=68msxAi1Gj9+NUxb8pOd5zGsrZxE7lKaTposBva0cyKHTgydmpvg/4YsD1/k6iWuhd
         gWuwTL/FHI6SuUJkBExEcp97gZo3aFNNFagLw0EmzgSClukozPHOeXWBpkPvPPpXfn1B
         uQgSeT2l6TQy/rAaZ0uIG7wrdrP31YJb3HATdRdzq1M+RAWcEfa79NV7EN6Aqxhn/Mot
         6pEnzRIIoRthV4ECqNKiDA6IiR/HgoP+stgO2Wt/yriubz3Ulo/gx5GkHctLGWYp++k2
         PWaoE97JiTyQ3obKPjpZPgdY6+pA7ywVXDQ2rXvXyTI6KFpSCinJJptts3PtDdtwibv2
         GLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=siTfL/yZSt5KB6RuHE8DL5yeufXgA42G2FTvpMR4eps=;
        b=lSgBsKD1rxzQiEufuElK0kZsDn04mwnuPrE+ZYeAkZzjVqvUpWVSh/jvcIdHBQvXlX
         xSg0Pcz1zfuKuaqOJwrqzN1/NSMh/h3ka+mcJbBwvEtg3zsO1LI1ZTGd2zaw5C0Slme3
         PFEc2B4Ci4X7MXskme/gFrjErJAQNBk2OgFuxw3I6dZ4i2C2cfXdnQDhweklQfjM2gwt
         eBGY1hiYBWvaDy9TgXvHf1Ou5XP86xOv//E2JohMvuME8Wwe4h8Y18A9cSwjiK/UqrcV
         q9HITsKU8imG8oVMZ9L7ZkDvd4bpN2Zsfi9FrzfGaiRYMbAi1NJ7my3tUxQIl8/cnMjN
         33Zw==
X-Gm-Message-State: AO0yUKXIx+KqVH+oaFw0QTAR30AWdGGNYdjsMD9aEQ4hMVSPj2+i4BdE
        hh/Rf50M9+eH8VM0AbcEogOEFg==
X-Google-Smtp-Source: AK7set+BpFgInr+UcPaaQK9BBYtOi3lYGXtNUbZFnHnEaIN84N0Ge+YxG6NXL1j1zZfOz/4HX+8vtA==
X-Received: by 2002:a17:906:13d1:b0:8b1:3b96:3fe8 with SMTP id g17-20020a17090613d100b008b13b963fe8mr1334042ejc.52.1676447824759;
        Tue, 14 Feb 2023 23:57:04 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m6-20020a170906258600b008b0fbd27fc0sm5035312ejb.121.2023.02.14.23.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 23:57:04 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:57:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver
 Updates 2023-02-14 (ice)
Message-ID: <Y+yQTnI0okJU++q7@nanopsycho>
References: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 14, 2023 at 10:29:58PM CET, anthony.l.nguyen@intel.com wrote:
>This series contains updates to ice driver only.
>
>Karol extends support for GPIO pins to E823 devices.
>
>Daniel Vacek stops processing of PTP packets when link is down.
>
>Pawel adds support for BIG TCP for IPv6.
>
>Tony changes return type of ice_vsi_realloc_stat_arrays() as it always
>returns success.
>
>Zhu Yanjun updates kdoc stating supported TLVs.
>
>The following are changes since commit 2edd92570441dd33246210042dc167319a5cf7e3:
>  devlink: don't allow to change net namespace for FW_ACTIVATE reload action
>and are available in the git repository at:
>  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
>
>Daniel Vacek (1):
>  ice/ptp: fix the PTP worker retrying indefinitely if the link went
>    down
>
>Karol Kolacinski (1):
>  ice: Add GPIO pin support for E823 products
>
>Pawel Chmielewski (1):
>  ice: add support BIG TCP on IPv6
>
>Tony Nguyen (1):
>  ice: Change ice_vsi_realloc_stat_arrays() to void
>
>Zhu Yanjun (1):
>  ice: Mention CEE DCBX in code comment
>
> drivers/net/ethernet/intel/ice/ice.h        |  2 +
> drivers/net/ethernet/intel/ice/ice_common.c | 25 +++++++
> drivers/net/ethernet/intel/ice/ice_common.h |  1 +
> drivers/net/ethernet/intel/ice/ice_dcb.c    |  4 +-
> drivers/net/ethernet/intel/ice/ice_lib.c    | 11 ++--
> drivers/net/ethernet/intel/ice/ice_main.c   |  2 +
> drivers/net/ethernet/intel/ice/ice_ptp.c    | 72 ++++++++++++++++++++-
> drivers/net/ethernet/intel/ice/ice_txrx.c   |  3 +
> 8 files changed, 109 insertions(+), 11 deletions(-)

Tony, could you please send the patches alongside with the pull request,
as for example Saeed does for mlx5 pull requests?

Thanks!
