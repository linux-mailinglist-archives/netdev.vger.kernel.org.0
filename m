Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1358069C747
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 10:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjBTJF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 04:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjBTJFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 04:05:25 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF7816AC7
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 01:05:15 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m14-20020a7bce0e000000b003e00c739ce4so292719wmc.5
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 01:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3NzsKNt/2StFwmBGlLKg1YKwThtdU664PWy+Pq1Qgac=;
        b=THtmGgdsL+SNW5vH4G+FXfHq+UeCVLVW4mjLfB3aPVyk1uqTVsbRgDZ/UU6ZnAMZOC
         /lNr1tYwSedlJ6eBUX8d0xrq7435dCpaokUtELMUL3KpJBIm3sqT8PD/tODy0YwNd0TB
         KlWJLjPUcUn1K82pvqpVjyJ9sINB4Bt2XeQ5MnAGA7kecEqr1EyyXxfXErBdOND3uub1
         iiDIkb6cmm2CZ53pF/xbrUFeBil4tcu2it0Lvjelokh6hmKeNu6VbLYsD1CW68f3pO/G
         fynxBHuPfPDVysoA6qj8SNCgh7wKhxM6EjfRn3l4cCYnBM3zpjsHk2CerWuWscG88On0
         90sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3NzsKNt/2StFwmBGlLKg1YKwThtdU664PWy+Pq1Qgac=;
        b=Vlr4OCSDkwZ/iwW+CvDfqs7Ac/r+fz5PGwOpLqPkVz73RbrLalq2DvukctHCUW7XWr
         2/fFsIgMwoecO41kVXRfUuc0msSOpsdrHOITU1Rna3Bq4Z7Tu7fMGqGd3Sc7lLsje0HD
         kIb2e9W5Ll6HGOa2sI/VdHILV7sEzYMSX42zBv2y6JSRm5eoxq2IAyz3/DhbC926uHkU
         C8ROhtw7FDR8scrcUhcQdcmNEvVvluM7rU0Cwa2ksYomoMMIAl8I3DyM42H/fmhXSBoj
         l8dRUTbO4kIyx/Kql/oJKu2pF5SYWwt4fDYSRcEom4V5ueD+iTd27CA72hCevbOkBNHs
         AicA==
X-Gm-Message-State: AO0yUKX40VFixQTCKSw4f7pigRZAwgFTd0AoE1meOi5DnqqbMDwTYqjL
        JU1gfkN1V8tUJ+GFuOvY2cQY7g==
X-Google-Smtp-Source: AK7set/wncKhoBWVo3Px6BzJi3K7TZtTFhUlkzoUg160K4XLEbQKgRV0RXI4O6VtjabLlI3m3AjsyQ==
X-Received: by 2002:a05:600c:130f:b0:3df:ffab:a391 with SMTP id j15-20020a05600c130f00b003dfffaba391mr241983wmf.24.1676883914077;
        Mon, 20 Feb 2023 01:05:14 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c214a00b003e209186c07sm554629wml.19.2023.02.20.01.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 01:05:13 -0800 (PST)
Date:   Mon, 20 Feb 2023 10:05:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next] devlink: drop leftover duplicate/unused code
Message-ID: <Y/M3x6f0LVLnvEpK@nanopsycho>
References: <8ad783f77a577505653d90fb47075ea4c9ca5d97.1676657010.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ad783f77a577505653d90fb47075ea4c9ca5d97.1676657010.git.pabeni@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 17, 2023 at 07:09:20PM CET, pabeni@redhat.com wrote:
>The recent merge from net left-over some unused code in
>leftover.c - nomen omen.
>
>Just drop the unused bits.
>
>Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
