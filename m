Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA0A694724
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjBMNfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBMNft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:35:49 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84179269C
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:35:46 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id dr8so31827519ejc.12
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aCzM/iOInElA7U3j1OAiM1tBXwY6+Kimu1z58XEeqOc=;
        b=GPQT0UYQiXQBE2dmvpuUNIDlVIW//9Zx+1RuaDfZkXKD5ppMM4ZnhxrhQOObmqkOI5
         RJ8XFrhCO/+Hb25v5bQ9mvz3j2V5/Xnq4zN/DkpoGqRCCcVuGrIs25FDWvJP/uLulQh8
         2OdA+eSzYSBdN9Y/oKYOXrTCBXnTnHUKzdPf1RWtLuT2ehXYLc7OyyRh43eYGO6eOxG9
         CWiJtctDiypfqt+463EFILGCE8+VXPd3q58v0BOXuQUFA8b2Y8RUZJYk4Ro7R3vn29oA
         yvprx3aSY5adoNY07D6Q9d14tV//1oYVeyz5I5DnE71H3+86xT3Osb9xPUD6ntpg6VVV
         j1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aCzM/iOInElA7U3j1OAiM1tBXwY6+Kimu1z58XEeqOc=;
        b=eyZESi43TTKmGLYv86pKxmBhjAsosbVOtQJ4Bo8yEi/ohedI3f3zyK/hdzGQllq6dh
         vvZR+SoJAjMhK3AuKkzaLXOgQt0C7vaTWXk3ZKFNi2A/RsYTzVe5lTRMN8uRoy/D7mUe
         GxLW28MdnscRsyvvLxUV+Oi6Kn27BX07AfENHjqT6/KoaMrGl0dEVxdjY+BAUgHX2mKO
         3+YTnhKqb+IQh6d0nAeoqteDSOaxIpFzeM9qfBuDe0/vzIngapLcgFjRUa2JNZ8I6AXt
         tqTsYFJvsHlPghR1q/feI5F3joKVv7veMZY8zLNEmLxcg62zTQw2IGzLFYMrgV66t9Jr
         owjw==
X-Gm-Message-State: AO0yUKX+IXp05OLtmLyGEny7wJMLaRVa4XzHRiaSmhyXRWC4C/QZjvAP
        No6CKFCcX8duLQarMf3tMBp5bQ==
X-Google-Smtp-Source: AK7set92RzEgTwR0nOPmJ3IZchnKUcdPEywzonbmUCkU74lIYjH+tQTBTf+gse3iwaboDYwuKO8b1g==
X-Received: by 2002:a17:906:c190:b0:88d:79df:7cfc with SMTP id g16-20020a170906c19000b0088d79df7cfcmr23892929ejz.62.1676295345170;
        Mon, 13 Feb 2023 05:35:45 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id gh3-20020a170906e08300b0084d34eec68esm6761008ejb.213.2023.02.13.05.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 05:35:44 -0800 (PST)
Date:   Mon, 13 Feb 2023 14:35:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] devlink: cleanups and move devlink health
 functionality to separate file
Message-ID: <Y+o8r9+BwatYr8S8@nanopsycho>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 13, 2023 at 02:14:08PM CET, moshe@nvidia.com wrote:
>This patchset moves devlink health callbacks, helpers and related code
>from leftover.c to new file health.c. About 1.3K LoC are moved by this
>patchset, covering all devlink health functionality.
>
>In addition this patchset includes a couple of small cleanups in devlink
>health code and documentation update.
>
>Moshe Shemesh (10):
>  devlink: Split out health reporter create code
>  devlink: health: Fix nla_nest_end in error flow
>  devlink: Move devlink health get and set code to health file
>  devlink: health: Don't try to add trace with NULL msg
>  devlink: Move devlink health report and recover to health file
>  devlink: Move devlink fmsg and health diagnose to health file
>  devlink: Move devlink health dump to health file
>  devlink: Move devlink health test to health file
>  devlink: Move health common function to health file
>  devlink: Update devlink health documentation

set-
Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thanks Moshe!
