Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B9468F110
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjBHOoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjBHOod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:44:33 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39B772BA
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:44:28 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v13so20705474eda.11
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 06:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8+MJ/hCoxLQ4ZkyxT0Igfncyofm6E/bHxd/lqh8riTI=;
        b=Awr/YMBhb9pFMRUDTgC87F6TvkKCALd1QAQJR6sRo9U+RXW7dik/1UY82raxCgDeVN
         CdGEGsofEcdr1yvpk1cKy/y9geckQd6mb3z7KpGekhKTQWibX2bxcVdVGZTQKm7iqT4S
         1F9rDBrmSbyGIyAmACXPYGC1tjMs/l17nHB2Q3/ULTeTdmVcJ3Cryrl4+v0pO5fVprLb
         Eq51p5/pxsXKU61phEsbb4QwZ/QyzAZxkQOtjsDIx36s+9d8M3wtmRLbo82f9opfzwEV
         3/4bfmEAO0BR5GXiIj21qzC3QDy5ONSJ1NBm9B2G6JMdSrPiePU79V+u/mePH94RcH2/
         ofPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+MJ/hCoxLQ4ZkyxT0Igfncyofm6E/bHxd/lqh8riTI=;
        b=OFvuR6Pp4qTkdXhFGcqziRzj0HQWloRTJgXO8L86ZhAgS+J6Z2iebKjvglqn48q5/x
         B09TY0tLAORZd95Q5LpqwFOWPHQGyHC4LFSTKD8/tIXk+u/WFA7Dw4IcoIIcjBiPdR4K
         DK2ZBEN7cJete2KIgGP3Dafea4+QRCkBtt59Jy3xrgIokwCGzXgUTMXkHjMCUTud1ZWz
         cKIH9zNpnZijKBHC6iSOvsI/CoIjqAwS/t82q0fsYuuFloBhTeo0/9C3MPzC8hCVetBj
         ykHZA+BsxlgHSQD69DOkPWWwSng/60cv9xrhq7Em783WQi7WC979z/CDTvNxYkLUG7jI
         i4AQ==
X-Gm-Message-State: AO0yUKUgCkMzRzyoQv0cN2gGKWRGRRvTzDsFjTFNDldKsBPnmegW97Cs
        sL0wi3BGOngV2eSEGh0UOR07FA==
X-Google-Smtp-Source: AK7set+9heUrHpgwJrfugET6oI4/ZsZGAx9SGvYdGiPwPk/wazBmlDhUFMSXkf4F81NhLqEEHA3loQ==
X-Received: by 2002:a50:bb2d:0:b0:4a2:5652:d8ba with SMTP id y42-20020a50bb2d000000b004a25652d8bamr2752403ede.18.1675867467501;
        Wed, 08 Feb 2023 06:44:27 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v14-20020a50d08e000000b004ab16281309sm154378edd.29.2023.02.08.06.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 06:44:26 -0800 (PST)
Date:   Wed, 8 Feb 2023 15:44:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 2/3] genetlink: Use string_is_terminated()
 helper
Message-ID: <Y+O1SVodV5hUUwIB@nanopsycho>
References: <20230208133153.22528-1-andriy.shevchenko@linux.intel.com>
 <20230208133153.22528-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208133153.22528-2-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 08, 2023 at 02:31:52PM CET, andriy.shevchenko@linux.intel.com wrote:
>Use string_is_terminated() helper instead of cpecific memchr() call.
>This shows better the intention of the call.
>
>Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
