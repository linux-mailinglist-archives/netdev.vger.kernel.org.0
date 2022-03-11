Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9D24D5DEF
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 09:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbiCKIzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiCKIzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:55:14 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53F91BAF37;
        Fri, 11 Mar 2022 00:54:11 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 3so13873091lfr.7;
        Fri, 11 Mar 2022 00:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=j6acDEiAsPScytcFYe7n74snBh1CBbKGv8AV6qLb7RA=;
        b=gLC8+ByaeMZ4VdumDAV4qKPM3A8f2f6ephk00Jiow5uRbiEvzMr+brV4pYW8iWSKmM
         D7Ds8kt8rOveaPFDwMiZ86UWkYIjggkahPGUkbmdoqypiTTHvSnptLY0T9BLQ7DO8ERv
         N6vUfFZij5BS8yyanPvSniFRuS3yFHZMbiICvpqF1mRglEkDoWjhHSEMbJCZR5mpJuUl
         RfaIRtHOsi6KduMg9E1tNmS5Rioe+S4/ix6bsVzn6gzBYcSiri6oo4iealNBs0xCiykH
         BX7HGqsKNd9bMLmrd70AVNx1MoA86incx5AHvMQ5aoGaMHD+84xectrO0HtgPCYm1R8d
         ZpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=j6acDEiAsPScytcFYe7n74snBh1CBbKGv8AV6qLb7RA=;
        b=bqcY5DgZaj7TQVsCwDb3OWo+3IoxbeEM5Bw5U0tcMbx6KXVOE2atCgdv4QsFt6lRae
         +aS3zo3CpeCNwrG55znYHPC1wH6m/64tjOTIA5Ma7tEh4wgUAQxVOs0aFm/bcXPX+VLj
         5f7pKDKY2WaNS9cLQAnLJhTBcciC2cH9slp9MYlYE+uqxhmsQdNj7Xve4MKXW0MsGKxt
         3vc2OiF4wGotpOh9r8/x4REkwpSwpldgddJwAn/XnEeQfWLs4XxW1THZYVzVhYEDTkL2
         sC/VbNtgyoT2lHWBJvteWocc6nLh4xwyxiZqyy2oYbwSF9u/nhc7T6erhMCptcC50QNS
         jWhg==
X-Gm-Message-State: AOAM533oqDjQHsG+WQIaM0W5XCqxklMJIB7iT84RWrQ1UjIjdcfr5Eps
        rx3bi+awZiUkqBcgwG3RExlhpzCP8OGjLg==
X-Google-Smtp-Source: ABdhPJy0MJqtdeZ+KyzZVDJtwsZhMmqESJnSTwcKIbhmRjD5mVJT0roGFf/B0zU8+07Aqq4eAp/qwQ==
X-Received: by 2002:a05:6512:12d5:b0:447:87d0:ae74 with SMTP id p21-20020a05651212d500b0044787d0ae74mr5490866lfg.291.1646988849727;
        Fri, 11 Mar 2022 00:54:09 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id x16-20020a0565123f9000b0044839be14ddsm1489132lfa.76.2022.03.11.00.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 00:54:09 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH iproute2-next V2 0/4] Add support for locked bridge
 ports (for 802.1X)
In-Reply-To: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
References: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
Date:   Fri, 11 Mar 2022 09:54:07 +0100
Message-ID: <86v8wkdg40.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On m=C3=A5n, feb 28, 2022 at 14:36, Hans Schultz <schultz.hans@gmail.com> w=
rote:
> This patch set is to complement the kernel locked port patches, such
> that iproute2 can be used to lock/unlock a port and check if a port
> is locked or not. To lock or unlock a port use the command:
>
> bridge link set dev DEV locked {on | off}
>
>
> To show the detailed setting of a port, including if the locked flag is
> enabled for the port(s), use the command:
>
> bridge -d link show [dev DEV]
>
>
> Hans Schultz (4):
>   bridge: link: add command to set port in locked mode
>   ip: iplink_bridge_slave: add locked port flag support
>   man8/bridge.8: add locked port feature description and cmd syntax
>   man8/ip-link.8: add locked port feature description and cmd syntax
>
>  bridge/link.c                | 13 +++++++++++++
>  include/uapi/linux/if_link.h |  1 +
>  ip/iplink_bridge_slave.c     |  9 +++++++++
>  man/man8/bridge.8            | 11 +++++++++++
>  man/man8/ip-link.8.in        |  6 ++++++
>  5 files changed, 40 insertions(+)
>
> --=20
> 2.30.2

Hi!

Would it be an idea to add a switch to iproute2 commands that would list
the supported features of the current version of the command (or all of
iproute2)  instead of having to deduce it indirectly?

F.ex. a feature I am adding will only work indirectly with iproute2, and
thus it will be difficult to determine if the feature is available or
not.

Hans
