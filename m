Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC2365E781
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjAEJR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjAEJR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:17:27 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409DB50E61
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:17:26 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so844300wms.0
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YziXghO1MbNPEwhThsRY/HdQLiuokqEj9kV5IYkp5bQ=;
        b=SL5p8btHYOxeyEJzxnECxjMcAx9eYyF33w4zhoFIj9ZHMLT00LjaUeVsXpCR3YO1mZ
         pAYB4cuS+E/59sNfwgvgP89N7T1MD94zQs/urBhE//7GOCOiJBbKLVlXt0rkD8EYsFip
         tqMQkYBtNC2ZAj262//MkA4vSzLgtlQvqSnC3rkM0FmUlB3fUPjTWbqHhooH4flpLOgz
         6xXTEo2ay4fJPFNoR7butE0mhXO24PqiCIk4CLRBXrZOBgbciDUb9ds3ZkJWZB3OWY0n
         x6oUkUtctJD1lJosWxHrdYaU2zewzOeJ3b4us/3WSpsgrE0N5O+opnjRJdhX4OFrxHT3
         l7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YziXghO1MbNPEwhThsRY/HdQLiuokqEj9kV5IYkp5bQ=;
        b=uNmLNkJvPEy7Pv+9fDZs93/sddLu1KXg8e7BE+hl3aPnagmKgjBvW2sM6hahPgu/nk
         DHx4RXrXeoaXb/KKsDAHITFh4hHBw7Xubt0PRWtXmy+mDslitxrMnwpzt7FO5lJgV7To
         Vq9GM8ThUIHVjw0BwGzcGjFjU6kdk9r34CkoI7dUCwrSlp6ibqhxmeA7AwLVnnKRyzae
         LQ2/5ocmjX99D+o/8P047h6LVIW4ebbQ2bTRKX8Cw5I5tDgmiDPlUYoFbBB/sBCry/bJ
         tlZrfHPHD/KjRtIzmyb9XY05NkoYaKrE7vq/6RTgnh3uALkiu+e1fzzfdUveaZo6dtmZ
         7K1A==
X-Gm-Message-State: AFqh2krl1CA00QW0tEcmbuhWwlEEsYZSl4TJZ5MvuLIbdUkgCB/oZRMi
        mP1Dk/btOQ9w779anfyXERbUjw==
X-Google-Smtp-Source: AMrXdXuJew/sENxPE49AlbyE48VqwZxKBt8dRQvGxzDaU+KpVoNYY1FnGTfxBiDJGerJVDKh/01OHw==
X-Received: by 2002:a05:600c:4d20:b0:3d3:5737:3afb with SMTP id u32-20020a05600c4d2000b003d357373afbmr36607430wmp.41.1672910244656;
        Thu, 05 Jan 2023 01:17:24 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c125-20020a1c3583000000b003c6b70a4d69sm1659024wma.42.2023.01.05.01.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:17:24 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:17:23 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 04/15] devlink: split out netlink code
Message-ID: <Y7aVo1H400AYZWxR@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040531.353563-5-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 05:05:20AM CET, kuba@kernel.org wrote:
>Move out the netlink glue into a separate file.
>Leave the ops in the old file because we'd have to export a ton
>of functions. Going forward we should switch to split ops which
>will let us to put the new ops in the netlink.c file.
>
>Pure code move, no functional changes.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
