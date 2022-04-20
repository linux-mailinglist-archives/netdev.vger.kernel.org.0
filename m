Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DB1507DEC
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 03:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358679AbiDTBOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 21:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236644AbiDTBOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 21:14:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89A918E1A
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 18:11:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso472822pjj.2
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 18:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iET8OU19T1TD5t9K/JLvJVOQz31t9Cfk+wnAN3465CM=;
        b=MAbO6CdC6Hpfk+h4xGPN+r4kag6lIRB01vvwcpatya+wsWX35Mpoqjd6LKBF8+vbN1
         kMNnRkKfwErY3uDBGwlLTgY4ljwxvzFl+bYuOzOITXOb/8/MsU8X/Jt1VzG9D7CxWbe+
         +ZSTzqQihBcoY9c27GO7uN7qKu3eV+nvLLHxq4c4/MzH6Bkda3Ddo9P34A1TdJnVhfgG
         dMnFMi4i99yHrOo/+FQETSQGBworSdGOkQ85Ok9CTKH71jmN+xb3eVlL8/X1aL38RUpx
         A1rsJLN0FKPmxEBW8YwlzDMKM/UhJFOzPNXQp3hJ1ZOXogIZdOg/DjK1UUD7VNADK8Mw
         BDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iET8OU19T1TD5t9K/JLvJVOQz31t9Cfk+wnAN3465CM=;
        b=x+i+E02lWBDfp3siMiZQM2dMEByNJ16faD+UByV2XgbEZLPZZBTTVMNEcLNaKZe6ut
         +YBauwuOxmszImsSSZu3SIpZ9zUfk9LW3q4NFDsW8NJP2E/+vcoppytWOCN6+EW2HGTI
         SMxq9F5l/mcSdKNK4BDeXE9EB2EFoiSnR3xIkeXY9ekeWR3HcfzbSrDHtgL7Qpn2ZgH3
         TD5udMoB36dhI8CWEo3r5VWFUmMqXcjUklhGHZzwyTijN3OZu1K4Z7OKOy/RH1i5fzw+
         sJKcXlp2aWsVc8tt/EKIJ+fuQGEY6E9DsFDjWjnc2zDRdTpUB6Z3VdtUd5+OEHW57ZHD
         TqKQ==
X-Gm-Message-State: AOAM532pgiNrj799fDG5Dst093izPH+g9gngvYkWd1ckyqCYL50sYdbf
        eIpqbtDkPZPD/v46DDNKyCI=
X-Google-Smtp-Source: ABdhPJxZI7GiZvdJ5Bp9H49wZzNftT3M5zL2Y1zPQ0+1im8iLGNEhbHSjIwZD+/AaxI/30sPaKKEbQ==
X-Received: by 2002:a17:902:c3c4:b0:158:85b8:1459 with SMTP id j4-20020a170902c3c400b0015885b81459mr18513429plj.10.1650417119244;
        Tue, 19 Apr 2022 18:11:59 -0700 (PDT)
Received: from Laptop-X1 ([119.254.120.70])
        by smtp.gmail.com with ESMTPSA id f19-20020a056a00229300b004fb157f136asm17572676pfe.153.2022.04.19.18.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 18:11:58 -0700 (PDT)
Date:   Wed, 20 Apr 2022 09:11:52 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Mike Pattrick <mpattric@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 2/2] virtio_net: check L3 protocol for VLAN packets
Message-ID: <Yl9d2L39BzUiLINN@Laptop-X1>
References: <20220418044339.127545-1-liuhangbin@gmail.com>
 <20220418044339.127545-3-liuhangbin@gmail.com>
 <CA+FuTSdTbpYGJo6ec2Ti+djXCj=gBAQpv9ZVaTtaJA-QUNNgYQ@mail.gmail.com>
 <Yl4pG8MN7jxVybPB@Laptop-X1>
 <CA+FuTSdLGUgbkP3U+zmqoFzrewnUUN3pci8q8oNfHzo11ZhRZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSdLGUgbkP3U+zmqoFzrewnUUN3pci8q8oNfHzo11ZhRZg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

On Tue, Apr 19, 2022 at 09:52:46AM -0400, Willem de Bruijn wrote:
> Segmentation offload requires checksum offload. Packets that request

OK, makes sense.

> GSO but not NEEDS_CSUM are an aberration. We had to go out of our way
> to handle them because the original implementation did not explicitly
> flag and drop these. But we should not extend that to new types.

So do you mean, the current gso types are enough, we should not extend to
handle VLAN headers if no NEEDS_CSUM flag. This patch can be dropped, right?

Although I don't understand why we should not extend to support VLAN GSO.
I'm OK if you think this patch should be dropped when I re-post patch 1/2 to
net-next.

Thanks
Hangbin
