Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1F652C3FD
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242262AbiERUAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242261AbiERUAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:00:07 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D6E15E4BA
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:00:05 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 31so3079332pgp.8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vnjvEW7msPfBl4iLllblWRhZTU1MbC5aUv3JE0KAe9c=;
        b=cRdYIannhtq9AfQ8caKzVGhk2eRrfetLkmJQQEok/vvWOxvrEfmOi3/BqiSHv8aC8U
         VWkCaRNnV9FNIAwIpYdDUMV76FkaaMKNeBBVS2k0W34/SDEbvYfIwi8f6L8UNeJSCNxW
         dIECpPBPxmhJLmhePyRFpXdPvKPskKoFNSsoqEN+E5bCJc5++/TEqOE3pFLpCWy70DHE
         Xx9cS6KxnCWhsHFJrHZhzYZEQC4h+Ra6hP/TOJ5ripQW9aK2R7GyDLfKHWDaTcWhlDCT
         Neks+5JcNACzPs5BCv+EClmmvlrVc5iyBsGACJZeaw9l/DJPx7ZmV2fpeySk9pOQUjm/
         oLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vnjvEW7msPfBl4iLllblWRhZTU1MbC5aUv3JE0KAe9c=;
        b=AiwnXfNyT8g0Cvph1pjXh108k6ErssLjMBjIuk8djwQzmbyeI6WYn2+p3FEK9PayO1
         SwAk/SW8yd8xvVHkqCqzHYMsxq//jcSRAMb0XKRRJkVCK/f0+SGjEfl+d6tXuZTTSi/3
         iU8S7NRhqAYD5n1jP+6lH9DGku/vr0veDmH0ZPprm9L8JqjVF+SEM/g+7jvZJbC9sDbf
         s7XAjbUlUNIKAHrPuTKIHCBPw25DMKFiRkYrFSkh3CUr2Of9aXLm84hthFzEAaJSFEjO
         rMBsdAD8cMnfCdISJE/MgtiQr3JOxE2Pe6AWacrl7ZGZrTTJNXh3vBrVZet1/nYBfsKA
         6UGw==
X-Gm-Message-State: AOAM5312+q7b2Tpzfetmf4YuGZsdcWl0PRTQ028jL4b/Iq2sxtQX7G5H
        wD8wI96Ww2aBOfYl1mlfOYhjWA==
X-Google-Smtp-Source: ABdhPJwkYDqgYFdTAYdFMnrlneydm8/jiQZpsOFNb000864T7c3o3QFtIsLDYS3yxU/WMYZ75RZvLA==
X-Received: by 2002:a05:6a00:244a:b0:4fa:ebf9:75de with SMTP id d10-20020a056a00244a00b004faebf975demr1172422pfj.73.1652904005143;
        Wed, 18 May 2022 13:00:05 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id n12-20020a635c4c000000b003c14af50623sm1911000pgm.59.2022.05.18.13.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 13:00:04 -0700 (PDT)
Date:   Wed, 18 May 2022 13:00:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
Subject: Re: [PATCH net-next] show rx_otherhost_dropped stat in ip link show
Message-ID: <20220518130002.0a1bf327@hermes.local>
In-Reply-To: <CACB8nPkQkH3fJt29kNQ_YqikP8eKPSuBJvh-_cFO_zqie2rw0A@mail.gmail.com>
References: <20220509191810.2157940-1-jeffreyjilinux@gmail.com>
        <YnoPn+hQt7hQYWkA@shredder>
        <CACB8nPkQkH3fJt29kNQ_YqikP8eKPSuBJvh-_cFO_zqie2rw0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 07:29:08 -1000
Jeffrey Ji <jeffreyjilinux@gmail.com> wrote:

> > >               /* RX stats */
> > > -             fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
> > > +             fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%*s%s",
> > >                       cols[0] - 4, "bytes", cols[1], "packets",
> > >                       cols[2], "errors", cols[3], "dropped",
> > >                       cols[4], "missed", cols[5], "mcast",
> > > -                     cols[6], s->rx_compressed ? "compressed" : "", _SL_);
> > > +                     s->rx_compressed ? cols[6] : 0,
> > > +                     s->rx_compressed ? "compressed " : "",
> > > +                     s->rx_otherhost_dropped ? cols[7] : 0,
> > > +                     s->rx_otherhost_dropped ? "otherhost_dropped" : "",

This belongs in the detail part not in the common stats.

Look where nohandler etc errors are.
