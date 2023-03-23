Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E756C5CCA
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 03:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjCWCq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 22:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCWCq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 22:46:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF1618B3A;
        Wed, 22 Mar 2023 19:46:25 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso2589370pjf.0;
        Wed, 22 Mar 2023 19:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679539585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F57MJj6F7aifzKTWNIu/6TzVSNIYejDepQS3opnsa+w=;
        b=NVlTFfJl83eAXd6sVHfYwcELNYkJSu2MlkzvFrwC4AD7IGk9ZZlx6Vhgc5PIrorZN5
         ogEUrB2vwaYjkiOAbSJZaC8fUmZ9jgP4M4HDO0AAFUAfoCMYXfx0LbY/FhWofiWrnUsq
         a9VLZX5vNzBmhIlFUPMNW0kZReRHHEsb5Vgj6QI73pJyGj0IZk7xU+SDXiworLJXb5vz
         vCgZmED4ImdxmpwvVXPug2zBFsoP7ahTWssFJ0KKK6fRKTXf1Hfp6DfgN2/ZrOlL9EUf
         GRP3tG7UuHJvRqhnR2GBVzvVDpnR7T7QI8IgCuoTJX3x/E2dSk/X9g30Beji4TDno4pa
         GwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679539585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F57MJj6F7aifzKTWNIu/6TzVSNIYejDepQS3opnsa+w=;
        b=ebshOKfKjMUgPU+ju+3cYzoA9t9zN6WlfvT/ETqV/b7OERTIllIkkrlaaoZNnU9kTQ
         2G0dG4fvolKN81mpJeYQTG2QSubYz43ne8HWjNIrvGk++3WOgW4TgiI+SBRZBilnB91f
         9S6U3YVBZb1/uWDUneMyX++a7gGWt57rV3vJaeUFMkEmPA21OvE3pWxL61frgzUozNC4
         Hibl5WGZxiJ+1uV/3TeRMHshIlnHf6MTz8dOU8E0X7G5rZYpMXgAoNVMzSfXY0ZuBGYN
         XguAdCgZexHv7jQzsGvYCIVmrAgx3vFEsPWSkLxKvmdEqETc6pqzSW3VQADvLOYnEgud
         RgXQ==
X-Gm-Message-State: AO0yUKVa6qP0f33Tn0aRUUW3/SG2j52UIBARgirKyogLtTjRh3k2j+pA
        jnCPNjtlbT3oWsxN6KcDYvE=
X-Google-Smtp-Source: AK7set/KKpNAs8Z2pueKPemj2d1nOMHOxr1HQ0yytoF52hVl+GNHtVLXGTa6T2evJ6TK0T0xvV/rNA==
X-Received: by 2002:a05:6a20:1585:b0:d9:a977:fae with SMTP id h5-20020a056a20158500b000d9a9770faemr7801582pzj.3.1679539584722;
        Wed, 22 Mar 2023 19:46:24 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c12-20020aa7880c000000b00625d5635617sm4378330pfo.67.2023.03.22.19.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 19:46:24 -0700 (PDT)
Date:   Wed, 22 Mar 2023 19:46:22 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Min Li <lnimi@hotmail.com>, lee@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH mfd 1/1] mfd/ptp: clockmatrix: support 32-bit address
 space
Message-ID: <ZBu9ftxTmtMc/BmG@hoboy.vegasvil.org>
References: <MW5PR03MB69323E281F1360A4F6C92838A0819@MW5PR03MB6932.namprd03.prod.outlook.com>
 <20230322125619.731912cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322125619.731912cf@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 12:56:19PM -0700, Jakub Kicinski wrote:

> Could you to split your patches into multiple steps to make them easier
> to reivew?

+1

I was thinking the same thing.

Thanks,
Richard
