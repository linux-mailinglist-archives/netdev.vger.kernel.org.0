Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A60965BCD1
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbjACJJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjACJJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:09:13 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BD6D10D
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 01:09:11 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so20276399wms.0
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 01:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q4VpH6JpHYPTb5N2QEbasH2uVz/byLh3cdPoaV+heNg=;
        b=7mDgAIHeRGltGKdfPnbQWDWxMdgrISNNEmr8ZEWWLq07C+IEHgsYbgcR6k0zBYc/aO
         H+7ZJ3ns8QTYMtH6GPC73xLC46L5SM21YFcSSi/WxokMkmUvkozmDpn5iVGQcqZOVaSe
         PUAI/uJBK/8kkTOICrCLiHDyZ28Oi3SFFXFAhmfM6rPAHT6BsUsrj9L7wq+mfRDJyQBc
         64qOneJttg7RjbsCl7R2yBGuCDPTdEbWfkOah9jk9qv8flepwSdUDbmBd8MfTv6nc8WV
         dlD2o5/Uo8Nwo/9pLLNpLrvbEMvZc1N964hBMzHP1gDQdMuc1Cjj4RBx3SQlq+ktbGAR
         JGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4VpH6JpHYPTb5N2QEbasH2uVz/byLh3cdPoaV+heNg=;
        b=PqIL2NCYzU6Z7ek3mDitqI7YSaLwc1qnCCOx84JH2HY9h1OmEvK5HqmBzC/rolomtq
         5JUauCH1O/tnatCYKO+SVDKhMc8zRc1vrwCZsBrtK3QCvEow0mDVjLebTH/hWvP8vVaO
         wqMgHWLGNjpwe8OJ1pV9vOJej4sgn+OpQx+wDzCJEasfZdKZIJ+hb8H55wRRu1H6Rynh
         xmvDVwoRFlCMche1tDxBkcYzfuvGFfEbQMkosSf/q3LLVXh66NiIlVbAQRoqxoqBJz/U
         HcOaltXaNBLMDCefyAqJS59GmaTW7rCCZl6ysW4FbZfzDSTmGpssYVtwhGWwrtVaELGC
         IY6w==
X-Gm-Message-State: AFqh2koLIYCyXekFuniKRhuqBEtUHUBaI3SjoP2JX521JlMhRwfmcWql
        QjYWEXtixs9fm3fJnGFGTgAWIw==
X-Google-Smtp-Source: AMrXdXthod9gNBtDKzM2/ooc897BFsfcfFr9DFrnqllE4RM8cMaiskR8rtfsDxEbCRXDVt3ZdpqNjw==
X-Received: by 2002:a05:600c:18a1:b0:3d2:3ec4:7eed with SMTP id x33-20020a05600c18a100b003d23ec47eedmr33796593wmp.10.1672736950329;
        Tue, 03 Jan 2023 01:09:10 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z13-20020adff74d000000b002366f9bd717sm35847028wrp.45.2023.01.03.01.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 01:09:09 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:09:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Christoph Heiss <christoph@c8h4.io>
Cc:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: alx: Switch to DEFINE_SIMPLE_DEV_PM_OPS()
 and pm_sleep_ptr()
Message-ID: <Y7PwsyuZKiQqIp9Z@nanopsycho>
References: <20230102195118.1164280-1-christoph@c8h4.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102195118.1164280-1-christoph@c8h4.io>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 02, 2023 at 08:51:18PM CET, christoph@c8h4.io wrote:
>Using these macros allows to remove an #ifdef-guard on CONFIG_PM_SLEEP.
>No functional changes.

Net-next is still closed. Please re-submit when it opens.
