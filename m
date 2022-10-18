Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394D4603461
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJRUyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiJRUya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:54:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392AD62F4
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 13:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666126468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hO1LFELXQEUpYNdXEw0Kt4gZtU698gtGrVoO0zJ7b2o=;
        b=fOjq6pAPc5M2mut1doNaAqbEClvS85ocZXYvrv1s0nP9OtAIwPqJX4gp2EEYYo4kPxm8kc
        XOKpGUoBSqUC8kNoRjzdszqh44rb8IPkqWRJSjAlZip+PV5AHIGU6IPGVbalKHxsIdU+8X
        dZ1uvoDwm+Wk5z8QtqJ4Hrmcgz0MJYE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-381-TDgX9Or4OaWKfxSOxC59Bw-1; Tue, 18 Oct 2022 16:54:26 -0400
X-MC-Unique: TDgX9Or4OaWKfxSOxC59Bw-1
Received: by mail-wm1-f70.google.com with SMTP id 133-20020a1c028b000000b003c5e6b44ebaso11800771wmc.9
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 13:54:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hO1LFELXQEUpYNdXEw0Kt4gZtU698gtGrVoO0zJ7b2o=;
        b=gdhYlwRaK4e+zaPJc/rGmKiBPLGVC9N1WVd2tSsdErRC55j2ANP6fxfZJaODW5J5N/
         yGHCSE83PyHDZvsyJjk3Kjg/jVoG0BycTlnx92uw0Rs+uksvvjTqHsKfCjjT1Yf3n1Lp
         JfG2z5MYE6MCe1hizUBbLNdOQeazi8lhUhXFXZslCV+tNGW0EIoOOp1uo5l0zU7SdfmJ
         JqMvM/b3RDxkHrX8KxCj8gE5yqMjhz8+Bcs1i0qAy9dTc/31lTrYIjCkBfDtco5sba4L
         Qj2HRu6XHyQMZtglwgqonhkK10T2KFp/64ZjZJ7ckGIbAEhAebmkqhknKmJls5Y2kHFy
         6Mjg==
X-Gm-Message-State: ACrzQf07HMSy6+4bKezy5jbupHr6adRt9Xd2Nnr7oplyM+wRPU4oDTLL
        GvLEa5/UxVgnwGG7Yp4cCo+zYB1QZpMAqLAcp6u1QSagLJlZ0ImaqL8tROu6nx6+YWoQHEwhJk8
        t1ZwefJ55Xc+wuP4TWzEURJ5WUppidbiw
X-Received: by 2002:adf:fad0:0:b0:22e:4998:fd5d with SMTP id a16-20020adffad0000000b0022e4998fd5dmr2986815wrs.267.1666126464683;
        Tue, 18 Oct 2022 13:54:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM56AO+wk6RlK4KVfT9P3LmtwBvOvRZ6AIQAfU74yH274huUcfE7m3JRGMgA/Z6UR6c4Q7uE8soGGYtHsMbqYuw=
X-Received: by 2002:adf:fad0:0:b0:22e:4998:fd5d with SMTP id
 a16-20020adffad0000000b0022e4998fd5dmr2986803wrs.267.1666126464448; Tue, 18
 Oct 2022 13:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221018183540.806471-1-miquel.raynal@bootlin.com>
In-Reply-To: <20221018183540.806471-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 18 Oct 2022 16:54:13 -0400
Message-ID: <CAK-6q+gRMG64Ra9ghAUVHXkJoGB1b5Kd6rLTiUK+UArbYhP+BA@mail.gmail.com>
Subject: Re: [PATCH wpan-next v5] mac802154: Ensure proper scan-level filtering
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Oct 18, 2022 at 2:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> We now have a fine grained filtering information so let's ensure proper
> filtering in scan mode, which means that only beacons are processed.
>

Is this a fixup? Can you resend the whole series please?

- Alex

