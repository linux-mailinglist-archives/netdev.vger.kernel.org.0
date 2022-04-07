Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EA74F7C08
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 11:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243975AbiDGJqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 05:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243974AbiDGJqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 05:46:42 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79CB213507
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 02:44:42 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id q26so5712694edc.7
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 02:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DkggEoH1Cy9Q4wekLlHSimO5P2kOetKNoD/TtD4Swy4=;
        b=OIG9QYF1N23IWQlJKss15z7ZfI3zRRClxcMApD9yHcs+hyWr9NwlxxX4Zsln6q0C5p
         QYUG43RA1xSGOm+z0xFQdcBQY+ScaEDt3pNzzSW0UPWY+9u90AMHohXJbQfQZaoizsO+
         snPSxt0908hyk+pHem1V3ziix0WQnkSD5kFrgEn1cTcGk1hLbCjHa2r6CPJIgo0lORGm
         2NyvVusYJMiCTyv37+Oeuld2o0coEcfDMbz5vfSpiR6afkhhtfs7w7Bvw8LeqN35v3vI
         RYxy8mP5iQYmq1ZnCnyGPAb30sazkFwFzen8uylGRTL7YlC2nhNKkhnI/BRz6sQh9e39
         0jTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DkggEoH1Cy9Q4wekLlHSimO5P2kOetKNoD/TtD4Swy4=;
        b=0pbxrk5XdhRhg5V61cfbVHqOjzFRROc9Z497aouCGi6UNF16OS0x2TUsAL6G9LOQru
         uViDEnlA1DHn6Npxk5DVp6dBlHyBypgeUXoUuX7fhfop7drtpmitXAbvY0cM71Gl9RMG
         eoBYNcXRCNU9xdsx9mZ0YXM5V+BZSqKsoJrsjTanJVko1xRELCos4BVs96evmnL7MGcV
         9esI4oPKnOzh893c0QStIENI0QLEH0bsqUc9+4NC+BeKu2yrW19RVHvOsqPKll/aOQHt
         AQ8RB85G2BHcx/BkzZOqLMXS3wJ5hrs/uYqERzt8ibyQ4CqHKwkCSgy1bLhjlfYYE+JN
         b4gQ==
X-Gm-Message-State: AOAM5302QRhXUDm28GQXwCQtKiIXeLy/ZepETfMIO6rjDpslGW23q6TZ
        v/wdy/utoeVjVLdqz7GDvY0=
X-Google-Smtp-Source: ABdhPJx8R8skSLzDlT9e6iyhsVIETvIMK4+84/ZvCBSDMMDEO6cgui4YUpWcpi7vVxJyYuFpO5eeNA==
X-Received: by 2002:a05:6402:50c9:b0:419:3019:2d35 with SMTP id h9-20020a05640250c900b0041930192d35mr13296027edb.95.1649324680995;
        Thu, 07 Apr 2022 02:44:40 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id e9-20020a50e009000000b0041cd2e38a3bsm5245799edl.81.2022.04.07.02.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 02:44:40 -0700 (PDT)
Date:   Thu, 7 Apr 2022 12:44:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Matej Zachar <zachar.matej@gmail.com>, netdev@vger.kernel.org
Subject: Re: [DSA] fallback PTP to master port when switch does not support it
Message-ID: <20220407094439.ubf66iei3wgimx7d@skbuf>
References: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
 <YktrbtbSr77bDckl@lunn.ch>
 <20220405124851.38fb977d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405124851.38fb977d@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 12:48:51PM -0700, Jakub Kicinski wrote:
> On Tue, 5 Apr 2022 00:04:30 +0200 Andrew Lunn wrote:
> > What i don't like about your proposed fallback is that it gives the
> > impression the slave ports actually support PTP, when they do not.
>
> +1, running PTP on the master means there is a non-PTP-aware switch
> in the path, which should not be taken lightly.

+2, the change could probably be technically done, and there are aspects
worth discussing, but the goal presented here is questionable and it's
best to not fool ourselves into thinking that the variable queuing delays
of the switch are taken into account when reporting the timestamps,
which they aren't.

I think that by the time you realize that you need PTP hardware
timestamping on switch ports but you have a PTP-unaware switch
integrated *into* your system, you need to go back to the drawing board.
