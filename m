Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B0E6603AC
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjAFPtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjAFPtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:49:22 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27CA7815C
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:49:20 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so5510492pjg.5
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jDwByTfFw0O44sPvjFLWgW6m8XyM2upEPEIVmJlTgAA=;
        b=7OPf96C59T3DjFNRgLDeyAfOJkNc3pfjsYE801MBYiFJhYMP76wYJrW9zfzR08ckxd
         H9QjSisxATz9y4dL0WfYetIVYyto6vXn32CWzN3mtE3QOPCEUDHnVuXICkVuLHDLtik7
         OPAJRpjgLE0WcLVXi+U63EXHQMvIEWgA8W9XaoQoL9+EGsJkugeNfM2HRWpqdYvIZtZ+
         wc+W60S83tInP6BhtsSe5eYU1RqcI4rwFeRTgxPm9JXRL2Q5LZqvfD2+dYrcaoTZkGYa
         PnddmjqHnjetDRThXpAV/gHCd6ANTivFEEKyWluKmHtF258FHvSm349uIkF+8yT6FGbJ
         6Mlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jDwByTfFw0O44sPvjFLWgW6m8XyM2upEPEIVmJlTgAA=;
        b=J6/nEeIsO76ulqVxnoT+cCAroVdPU3v8LcwQA05U9eBOS7WPMj6cB1mDI6U6l4kq9M
         4tKnkA5Z25Df/u/phbWHt6tDFaUofrkQycnsgPINWiuyM43QsDFoeTpORk4BFNtoT3wi
         beORgayVvOEr0My5JREKwJQZ59uIRlu2e+23cqVB5xpoqBRxeiPaGyUQnu57S0bMH5UM
         qYBOe/am+4TyMOXE6QSVgtKrpD/Sq4oyT4mM7JPPpSwBQEU3QPRXLgGVqkUl28TcR+f3
         p4ZzrfMibD/W/pad/rysKsFTYQPJW4g+uN92WIYJDbEhlT/6uwBKy+OUlTM4awzsnLEl
         IRdA==
X-Gm-Message-State: AFqh2koJXsVk9WOES1OZn01hyNRZTIL+R2KHLvKy9f/gLrtGRWuMnjnd
        4B0btTeEzBxhAutz7pI/jnRgLQ==
X-Google-Smtp-Source: AMrXdXtbT3WktlzOu1PmmysaYN7OQlrVpNhJ1DrtWvRsz0b5o3OE5uOXV4Gf3lHIXbIWkvF7rPY+YA==
X-Received: by 2002:a17:902:ca14:b0:185:441e:222c with SMTP id w20-20020a170902ca1400b00185441e222cmr50974199pld.39.1673020160489;
        Fri, 06 Jan 2023 07:49:20 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902cecb00b001925016e34bsm1159531plg.79.2023.01.06.07.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 07:49:19 -0800 (PST)
Date:   Fri, 6 Jan 2023 16:49:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 9/9] netdevsim: move devlink registration under
 the instance lock
Message-ID: <Y7hC/FYhXz+OlM4l@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-10-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106063402.485336-10-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 07:34:02AM CET, kuba@kernel.org wrote:
>To prevent races with netdev code accessing free devlink instances
>move the registration under the devlink instance lock.
>Core now waits for the instance to be registered before accessing it.

This sentense sounds a bit confusing to me. "to be registered" does not
sound correct.

"Core now waits for the instance lock to be unlocked before executing
 access the instance" perhaps would be more accurate?


>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

One way or another. Code looks fine:
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
