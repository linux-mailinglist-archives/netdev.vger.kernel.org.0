Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA9C54511F
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344601AbiFIPoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344604AbiFIPoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:44:02 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094E764725
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:43:59 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-313a8a8b95aso11447487b3.5
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 08:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lba8HYDhLjYoRvoJVD3wy6sF0ZtkLMn6vxd8ghX/gMs=;
        b=kEAcbUSPdo6qET8OTi0sueyBN0am0hn04OcmQ1OQXnxpH13sXrpuH660NBWitZpeZA
         eK8/fVabJLbAZfBgmU2mio2n2IWbkWRxnecYTgnSPyQ2RqAh79wkqeb7pHG4zsadw8AS
         bF24oI/i/iw9UdynGoxxX+zRXu9934L92nHkGklxrnNRRlhYyNv49mUNQwc0o2SsSIe8
         LB4oXrvLtP0ZFqtj1imIg0V/MION6807GY77GOsHDJ0BE8psUB4fY/fhDbDRZEaWQp5b
         RBwUX8FRBSPXwakmNVXoG2Sx/r9tI9yCghPpmMvgucUTABgImhxS51RAzvGZvrSJ1M/t
         oViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lba8HYDhLjYoRvoJVD3wy6sF0ZtkLMn6vxd8ghX/gMs=;
        b=exH5G6q2uiEFfdgoWS0dvq7fdycV+h6ii/5lqhXaMY2/S1TmedW2KdlMRWaWn6iDP+
         nQG9+1MO6nJtXXy/4uguImRu3yGVfUQ6D5YUyBl57egCBBNRQbByiYEokkJIdLe30NgE
         2VDWZ/zazxlLIXL86VDlm+kegfqNt9vtV1e2pUC/m3xndVrTO4QvRPIUYOawJh2/jCdL
         77C/ihw5iumo9mhL3m9oLaPl5y6pCaVTFj5VDc47AhjqOJL7Bav2K0SuSQtD0kY51f/Y
         5IEf4XnKleaDbcxlXrVUV0Bp38NRwA0G3bdVl524ZrHQbxxw2GhFaUfVno5+pVCmy8pt
         WGow==
X-Gm-Message-State: AOAM532BCVMnEI6mvnfZBxCSB3DVJglRoiSSfroql3SlgZ7AU7dhIJRY
        TlpEYUq8wXPhHonC+yz8Y2yiffpbdWIFpxTBlxZDUQ==
X-Google-Smtp-Source: ABdhPJwzkmhHf86qAAu2x4MF3dIrrscDINBVAICvPAFTWXdv5gS/RAVxW8aa0jMSb8Fp6t6RZUlTALs8X0L72y0yGTo=
X-Received: by 2002:a81:6ad4:0:b0:30c:45af:ae3f with SMTP id
 f203-20020a816ad4000000b0030c45afae3fmr42352894ywc.55.1654789437873; Thu, 09
 Jun 2022 08:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-5-eric.dumazet@gmail.com> <CADVnQynuQjbi67or7E_6JRy3SDznyp+9dT-hGbnAuqOSVJ+PUA@mail.gmail.com>
 <CALvZod78+NA+x4Fd2rwytCyf4rBQd8aGbWa=-kQ=zFGGTjcp-w@mail.gmail.com> <CADVnQynhMUCYMSO5BopDEuhaDPia7vEAtMnmT0aNwh0cfxNDnQ@mail.gmail.com>
In-Reply-To: <CADVnQynhMUCYMSO5BopDEuhaDPia7vEAtMnmT0aNwh0cfxNDnQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Jun 2022 08:43:46 -0700
Message-ID: <CANn89iK3nsoWOxE5X0afcyCEuab57v5jrKn-b5ZwNO3njO_7pQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: implement per-cpu reserves for memory_allocated
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 8:09 AM Neal Cardwell <ncardwell@google.com> wrote:

> Yes, sorry about that. In parallel Soheil just pointed out to me OOB
> that the code is correct because at that point in the code we know
> that local_reserve is negative...
>
> Sorry for the noise!

No worries Neal, I made the same mistake when writing the function :)

Once we determined the new pcpu reserve X is out-of-range (-1MB ..
+1MB) we have to transfer it to shared memory_allocated

Regardless of the value X, the transfert is the same regardless of
initial raise/decrease intent :

pcpu_reserve -= X;  // using this_cpu op which is IRQ safe
memory_reserve += X;  // using atomic op, IRQ and SMP safe
