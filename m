Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6A266206A
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbjAIImb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbjAIImN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:42:13 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999DE12D0C
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:42:10 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d15so8756524pls.6
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 00:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cUsbpWzjnZOHhczNvjXLsFVdT4g0v5PmVSv6BdprEog=;
        b=VE/S0Dl7FD4dnFvxAgbb7ZmzoVtjgNEvxD6xw6Uv16DBEzis6d9UJjVqMoAU+ZYUBo
         SZ9to4HeeTEXLszUUojow743FnEc1VZwiBx8k8/0/37ZDC2y45BvywnUxakLrL8xn83l
         J2B76E1x9+M3/MtkueSaD3Xnw9m60j814ApLojBRMobQnnFZgvDj/b/0B/Tkedt59V5f
         omD6/20Ys5NOQf5yREU2niGWQpFcTIpAcAviyl0n1nimC50e0phaI9pvIWU8L3CEOPxO
         9/M1QwbuswHr1MiATHqXFRjNZInxbilJzkH7hfFgfDx2OAaLswpjj90SrdlpQHhWE7Yd
         1nzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUsbpWzjnZOHhczNvjXLsFVdT4g0v5PmVSv6BdprEog=;
        b=ErMJuROr56CZg1lYSg1wLMpeiOT9Yi67jmBF0O6s45qKdf99UHar00A+BmLa1EKOQM
         T8BuK0m82n9fvGgmCRjq8fkWRkVA5Tsx40D78V7YRiL804UcMCEUv0w27t92eceEviW0
         Zd6RB9eevKqKvEzBZPlpEJp+qlbM56KZ+AJ1GFQ14wBuuycYZW1kwzY42vWQEiRqDrsk
         26BA4XcVFuECScq0ZCDNbFYv1fsfd0rtEVYtlQl5Xdkg/SQDCJjEWYjztE2/dsqVXKMG
         eGSuYY4Q2OcxzVRIXatI6xv8O7IrJ+xJFmIEUkhr0KXjh8Hq5xtXullBbgC/pVT7GCdb
         VeYQ==
X-Gm-Message-State: AFqh2koe5BoYZchmA6XWueNm83Jbp+OvpnzzUW04zEFEdCeNURqhgWmY
        1+dpzgZiPcnx0v493r04u7ep6w==
X-Google-Smtp-Source: AMrXdXtfm9cqYaDu0uUCv4Q8Np3QDmYnQyYcSYkcqaIlLM8iRTI8Cj4WrNumrmF1jABiXyno9pG2kg==
X-Received: by 2002:a17:902:a402:b0:191:7d3:7fe4 with SMTP id p2-20020a170902a40200b0019107d37fe4mr57952304plq.59.1673253729400;
        Mon, 09 Jan 2023 00:42:09 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902680a00b001708c4ebbaesm5362045plk.309.2023.01.09.00.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 00:42:08 -0800 (PST)
Date:   Mon, 9 Jan 2023 09:42:06 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v2 2/9] devlink: remove linecards lock
Message-ID: <Y7vTXv9/rCZid7kE@nanopsycho>
References: <20230107101151.532611-1-jiri@resnulli.us>
 <20230107101151.532611-3-jiri@resnulli.us>
 <Y7rkdULcKqIWlkRB@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7rkdULcKqIWlkRB@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 08, 2023 at 04:42:45PM CET, idosch@nvidia.com wrote:
>On Sat, Jan 07, 2023 at 11:11:43AM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Similar to other devlink objects, convert the linecards list to be
>> protected by devlink instance lock. Alongside with that rename the
>> create/destroy() functions to devl_* to indicated the devlink instance
>
>s/indicated/indicate/
>
>> lock needs to be held while calling them.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks.
