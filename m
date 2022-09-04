Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501845AC5CD
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 19:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbiIDRla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 13:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIDRl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 13:41:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CEE27FFF;
        Sun,  4 Sep 2022 10:41:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o15-20020a17090a3d4f00b002004ed4d77eso1115023pjf.5;
        Sun, 04 Sep 2022 10:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=HLixh8AuxKfESuPcbTJOaTbih2s3zkiqJSuPtsZAysc=;
        b=gfqXQkVXspmqQKlsyYYRAxHLWuBn418GyAt6VCHjNMxgSvTvS5F7sN8CZTgvUwyZA2
         mTS79eYgwkx1zqruGqyvxg5m+2ypSOIm/nF7m7ADg7Zb8rvcqwj991FwzoWzBVudRuzA
         FAiycAoeYsRONs7vZxoAtD+0UUXzvKfKwRaXmzysXWGyKD8FT5WYC+o51kiHD17GFqtv
         QbT5fNcdYTzOUNHYHBiUQvbvN/KVF+iBiTE7pJAjj58XPG3yVPgjbvMBh0F2UzkmA0ac
         KrC4KxSkTLRdMjnKBY3WZPbgcgwaDtVCbmTf0P3uuKG0bZ9E6al2dRsJO87aUcGxaQCa
         sgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=HLixh8AuxKfESuPcbTJOaTbih2s3zkiqJSuPtsZAysc=;
        b=kQdaRt9hjLDrgIIhgMLmyUH6o9OUj9dCla8xGoRESI3yDB3thZYKdOmVlcup5+w96E
         b81SEfN1o5WRhIlKgSgdEFdFF8ujqlYh3KX0w5Civ6uAQtES6ttJkcw1WmUwamafgEkV
         EdSlax//VkXo5dkcn1Ybgd24qNR+QUxtDUYSPSDI9Ymp8sbX5UWwlCBuvUxuy+vS+jhD
         3T5Bs1UfhnjTbqQxUWmn9KvatrotL5PES36rrDcIP45vubaQNKGBh0ClZlsMgmePnMYF
         gmpdpJPqUKpgTm+MPU2QmAM14HpYlHVrzpdUAdUSJXO9BQkuJPnA5SX3ZpP6xNnh5sN0
         3r2A==
X-Gm-Message-State: ACgBeo2y/4aHUAFXjYJ1+6hNXEGWKrIvtAXMWNCEcXffKzbZrv4eVApi
        Wip+MEu01GLifPgK+yue1in0N9y6WMr9pGlANTs=
X-Google-Smtp-Source: AA6agR4IBUZhdqQLLy7WL9BLiRNQExiwYrZABy8efVfRTE8ZwOMC3ODIltqeIgikaRoCYmNeC+9iuBuJkS+7H9o6iLY=
X-Received: by 2002:a17:902:7796:b0:172:c716:d3ac with SMTP id
 o22-20020a170902779600b00172c716d3acmr44790324pll.137.1662313287999; Sun, 04
 Sep 2022 10:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
 <Yw/aYIR3mBABN75G@google.com>
In-Reply-To: <Yw/aYIR3mBABN75G@google.com>
From:   Aditi Ghag <aditivghag@gmail.com>
Date:   Sun, 4 Sep 2022 10:41:16 -0700
Message-ID: <CABG=zsCTiqt4QuPo70xiGePh1F4ntyNh4-bsVh_DKvSw=CkWjA@mail.gmail.com>
Subject: Re: [RFC] Socket termination for policy enforcement and load-balancing
To:     sdf@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
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

On Wed, Aug 31, 2022 at 3:02 PM <sdf@google.com> wrote:
>
> On 08/31, Aditi Ghag wrote:
> [...]
>
> > - The sock_destroy API added for similar Android use cases is
> > effective in tearing down sockets. The API is behind the
> > CONFIG_INET_DIAG_DESTROY config that's disabled by default, and
> > currently exposed via SOCK_DIAG netlink infrastructure in userspace.
> > The sock destroy handlers for TCP and UDP protocols send ECONNABORTED
> > error code to sockets related to the abort state as mentioned in RFC
> > 793.
>
> > - Add unreachable routes for deleted backends. I experimented with
> > this approach with my colleague, Nikolay Aleksandrov. We found that
> > TCP and connected UDP sockets in the established state simply ignore
> > the ICMP error messages, and continue to send data in the presence of
> > such routes. My read is that applications are ignoring the ICMP errors
> > reported on sockets [2].
>
> [..]
>
> > - Use BPF (sockets) iterator to identify sockets connected to a
> > deleted backend. The BPF (sockets) iterator is network namespace aware
> > so we'll either need to enter every possible container network
> > namespace to identify the affected connections, or adapt the iterator
> > to be without netns checks [3]. This was discussed with my colleague
> > Daniel Borkmann based on the feedback he shared from the LSFMMBPF
> > conference discussions.
>
> Maybe something worth fixing as well even if you end up using netlink?
> Having to manually go over all networking namespaces (if I want
> to iterate over all sockets on the host) doesn't seem feasible?

SOCK_DIAG netlink infrastructure also has similar netns checks. The
iterator approach
would allow us to invoke sock destroy handlers from BPF though.

>
> [...]
>
> > [1] https://github.com/cilium/cilium
> > [2] https://github.com/torvalds/linux/blob/master/net/ipv4/tcp_ipv4.c#L464
> > [3] https://github.com/torvalds/linux/blob/master/net/ipv4/udp.c#L3011
> > [4]
> > https://github.com/torvalds/linux/blob/master/net/core/sock_diag.c#L298
