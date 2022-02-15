Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871AB4B7580
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242830AbiBOSFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 13:05:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiBOSFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 13:05:04 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B2011861E
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 10:04:54 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id 4so21568592oil.11
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 10:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8FkbrW//0IgWQygghqQsiP3JwGJ2D9CY24Xy8wfl6Kc=;
        b=tCVAaYeTHV6om8mv2EbLq/7QqmPUcfldxZOtAV0HONmrxT0EjskE241oYjeqfycv8B
         0DVZRo3e0S8sfb8KsqNbHB35hIn4ZWRVx4/M+gLO1WTSKxxpqiMwjVT1Rgrm1/XT+KUh
         HopiXfN2G4kFIchQzDWKbr0dM9IFTGnEDniw0WMqp/Vj+VABo0PQWUlFH5A36LNrHiKB
         Bv/5D5Q2veFU0ZB2RYh1QrXFrGFiEdBU38g4T/RNOsHqM5x1UDmsB3FV6WcLra7WMjD+
         Evq78pqDmc/INmF2/F/QChm07sjXvKqufL5TWQEXH2seAUfZ+0+U5OZPw4F59Cr7zUBe
         FOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8FkbrW//0IgWQygghqQsiP3JwGJ2D9CY24Xy8wfl6Kc=;
        b=hxpD78ixMK5bJdu6KsGg4YZqNYNe7wsrTc8Hi2F6EROE0ELTmLTXKj1+0srloRqmgs
         3HWiil1oXcI11d8MeKh/3HQHIJYw3VHEPF4+Guu7dH7u70gkymaL1yPthKdFlYwODx8h
         Dag4CHCcXkBqmFjgh0taWGFFb/urD9mVN8solNEAnknM4sYsGtnBtdBY4o8sZGbiMfYB
         mHWGDISwRWMoUWLySQcpz0+svmvn84g32GABW9C0GbIUucnmJDHN3ekc5Et84n4B2Saq
         UiTXhtr39+uBqSgMcep9STwWBAQe0ZHFKu2J7r6x9LuS06AEgpe4flJhBn1EPawH4ASU
         PTlQ==
X-Gm-Message-State: AOAM532uCgZXKrK+u2OTFk9RZhpYi8z8E8B1U33ioHwRNBX6id6yHeDr
        NXsoC1lQa7RiQnCJlKRsEtiyt05sjuwXORbh8FR6MMjlOmUIUg==
X-Google-Smtp-Source: ABdhPJxNDbZDdo2yVpmlNODvXD6j6NahxG5NvwXi4o4t05Om9sq9lRIUr9w01zVeke8/LzOItBWhahCBTG9Hu8KAHqo=
X-Received: by 2002:a05:6808:5c7:: with SMTP id d7mr29618oij.80.1644948293188;
 Tue, 15 Feb 2022 10:04:53 -0800 (PST)
MIME-Version: 1.0
References: <20220214024134.223939-1-haiyue.wang@intel.com> <20220215051751.260866-1-haiyue.wang@intel.com>
In-Reply-To: <20220215051751.260866-1-haiyue.wang@intel.com>
From:   Bailey Forrest <bcf@google.com>
Date:   Tue, 15 Feb 2022 10:04:42 -0800
Message-ID: <CANH7hM5tYYU7GyYLboEVdin6xivV3LmbPxMxEa3sxb_YEBfH8w@mail.gmail.com>
Subject: Re: [PATCH net-next v2] gve: enhance no queue page list detection
To:     Haiyue Wang <haiyue.wang@intel.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tao Liu <xliutaox@google.com>,
        John Fraker <jfraker@google.com>,
        Yangchun Fu <yangchun@google.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 9:52 PM Haiyue Wang <haiyue.wang@intel.com> wrote:
>
> The commit
> a5886ef4f4bf ("gve: Introduce per netdev `enum gve_queue_format`")
> introduces three queue format type, only GVE_GQI_QPL_FORMAT queue has
> page list. So it should use the queue page list number to detect the
> zero size queue page list. Correct the design logic.
>
> Using the 'queue_format == GVE_GQI_RDA_FORMAT' may lead to request zero
> sized memory allocation, like if the queue format is GVE_DQO_RDA_FORMAT.
>
> The kernel memory subsystem will return ZERO_SIZE_PTR, which is not NULL
> address, so the driver can run successfully. Also the code still checks
> the queue page list number firstly, then accesses the allocated memory,
> so zero number queue page list allocation will not lead to access fault.
>
> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>

Reviewed-by: Bailey Forrest <bcf@google.com>
