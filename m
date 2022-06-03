Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE72153CAAF
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 15:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244636AbiFCNbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 09:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240806AbiFCNbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 09:31:00 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5ED26135
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 06:30:59 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id ea7so5526392qvb.12
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 06:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YPHZ5IixDsHhu6/M9FlB5ep8HRyf5/mGExkSFFdUPwk=;
        b=dcLvV+p5KXJ3OnV9TLJTf39L0rdT/bZhCKl0hfiDyEuRo1q+2uuHrff9N7fZgR1SEC
         kOqE1ovwNAR9wD2MF7VketnxEPS67AvWoD44vCsMyXatjN2jN+cXiHVAEKJ8xjahxUdG
         J4TN6bEgSpWgXuYGWXG0Nl1+Z/Y6K9VDnmqOQYoempiWJxNFV6VhzFUgG8MagYMztQRH
         ko06/oauXhGPZ19jwYf/ZXbv7FW6Ha9G3rqzqJ0Tu/JSn3GmNiNYzcCyK25FKX3zTPMZ
         admcS/26Sq0sv35II3NkSoaO7UqpVMWk69fcMsBWRWt4PZMK7vICo5X6JFazztzSbvb9
         KqbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YPHZ5IixDsHhu6/M9FlB5ep8HRyf5/mGExkSFFdUPwk=;
        b=e/CESHuULb2eLHoznWzTqCO29dDHtoPJmaolOYGpDW721v0JL1nigY/Jc158mLk5rE
         JnXGulQPXIkSP7kNIcdb3ow3RFARwiE76+1uLu52GbjIxPltHEvXCf9P61R2cH9qGTT6
         0UA3TxbSc3Kb1+PyBjcpit8uYyEuxBRxO+Ibdri1qi/v3aXsI/1WiZepuFmMU+xkj2NJ
         t+HLE4unnKZAYLQjp5bvEEk+ppQVnwRq2VyjQMxUnnQdSFDZrZq5F66UzEIbTvjTNCwR
         Z8owuHjtILQlmwgEDnKAWJ8j1NW5FjY8sTzxqaAwnhxesyFiaEHH67hsyVGGvkMVSUP7
         DmuA==
X-Gm-Message-State: AOAM531/lFJXfnrxKSQPB8LS17WjAyIQfFpEk+iwD4ZeXY/FW249IpBW
        o2O8PTc3gYNYt9U7KiXD54RsbDF/PV8=
X-Google-Smtp-Source: ABdhPJwHiRdBd+tfL0jNu31XWhisIrGEn0TRnCk96oqdkJUu/UqVYaKttZWONflr9m1w7tNFYJ6/Sg==
X-Received: by 2002:a05:6214:5197:b0:469:dbf0:899b with SMTP id kl23-20020a056214519700b00469dbf0899bmr785104qvb.59.1654263058519;
        Fri, 03 Jun 2022 06:30:58 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id bs33-20020a05620a472100b006a67eb4610fsm2839360qkb.116.2022.06.03.06.30.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jun 2022 06:30:57 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id i11so13702823ybq.9
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 06:30:56 -0700 (PDT)
X-Received: by 2002:a05:6902:138b:b0:64f:cb1c:9eac with SMTP id
 x11-20020a056902138b00b0064fcb1c9eacmr11022314ybu.457.1654263056343; Fri, 03
 Jun 2022 06:30:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220601024744.626323-1-frederik.deweerdt@gmail.com>
 <CA+FuTSeCC=sKJhKEnavLA7qdwbGz=MC1wqFPoJQA04mZBqebow@mail.gmail.com>
 <Ypfvs+VsNHWQKT6H@fractal.lan> <8362c86f9b004b449ad4105d8f7489e9@AcuMS.aculab.com>
In-Reply-To: <8362c86f9b004b449ad4105d8f7489e9@AcuMS.aculab.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 3 Jun 2022 09:30:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeqbu=MPdmOVSHBDy39ZxrHZUjgGmP4LhPXjWsfc_Qa+g@mail.gmail.com>
Message-ID: <CA+FuTSeqbu=MPdmOVSHBDy39ZxrHZUjgGmP4LhPXjWsfc_Qa+g@mail.gmail.com>
Subject: Re: [PATCH] [doc] msg_zerocopy.rst: clarify the TCP shutdown scenario
To:     David Laight <David.Laight@aculab.com>
Cc:     Frederik Deweerdt <frederik.deweerdt@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 9:18 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> > Sent: 02 June 2022 00:01
> > >
> > > A socket must not be closed until all completion notifications have
> > > been received.
> > >
> > > Calling shutdown is an optional step. It may be sufficient to simply
> > > delay close.
>
> What happens if the process gets killed - eg by SIGSEGV?

The skb frags hold independent references on the pages. Once skbs are
freed on transmit completion or socket purge the pages are released if
there are no other page references.

Otherwise there is nothing zerocopy specific about closing TCP
connections when a process crashes.
