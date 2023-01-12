Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E236C667E8C
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbjALTBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbjALTAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:00:32 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28327FEA
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 10:39:25 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-4b718cab0e4so252691107b3.9
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 10:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23TuRY8Uscw3wYyB7HeYKYN6bJDj1xjIuPRk/WYsq5Y=;
        b=rSPdjg/k+MG5Py1mmE+l0sWVZS9lWS6Drj3ExXuwUj1jrvcPmnQHsfRuQs5qeNeHph
         BXpeaG8wE/qpkQSdfawEcV6b0cIGkZdCApVqSMNsOu9OR7QifCslPTGM6D1fA1GPDbpk
         i+CobIn3bskR9ge37OBxDiDt9RJI3Trq1zh8pZqEYgUC790FY04YaWwIBA1EjZ90eMTO
         MrY4nS4usT4B3Fk2P4ta7T5P9boZG3euou6QOwFcJre88JezvxaZ3BmIMlUNYI/yYDuh
         QVGIq/Y1f4+gPNVojgDyCOv/iAsI3nCZW06GY86caS8F11J4MkYw3MniCb0s+jPoqTXI
         1LZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=23TuRY8Uscw3wYyB7HeYKYN6bJDj1xjIuPRk/WYsq5Y=;
        b=25jWvKLfzjAkTfpsRBO7yrSJejpmXZ0hJ2hp9+PZdci5n57pP7I1mDOMP+YnZfWEEZ
         yN45PoaJ3taDIPEey11QjCZ0QiAlQCJe04cSlbGklHD/H2Z/qQbKGMOKb0bIiPNR+TL4
         ns+y9SMZvu72fq89rxZ/JUHxr4bR2Dt+oK5ExAA43fY+5DrlQbvQUzapz4TUFoUFnaxE
         lCfJmA12+umUWQG+3OBw7iVDxgxvemYHDyUfUPKXHP/1vVZP5jM8GAqIXa1L8YrlYeTV
         AXxgHgbI6VIf6dej4ftrVhGG5CBaD55XT1IiZw5Ul6PKtVnyxfoknlz14F3e8cPkG1FX
         sUZw==
X-Gm-Message-State: AFqh2kqcN1ebqKu8gnAAfO38ThSmPiW4TNPoyEPV9QejmzfYQMrIosgI
        tyT6UFuroMfQWn0c57ECOVOzEaOBPVHFBrhT1boSHQ==
X-Google-Smtp-Source: AMrXdXsFuJy/CPoXuGhRI0DtDH8DiK0WOzxYNRnH1nP6q6jXuZpqRyShxPF7ezkVDhU9xEE6oNyzTGlah0UZ3z+JPVo=
X-Received: by 2002:a05:690c:a99:b0:4cf:c11b:f132 with SMTP id
 ci25-20020a05690c0a9900b004cfc11bf132mr1472653ywb.287.1673548764297; Thu, 12
 Jan 2023 10:39:24 -0800 (PST)
MIME-Version: 1.0
References: <20230110191725.22675-1-admin@netgeek.ovh> <20230110191725.22675-2-admin@netgeek.ovh>
 <fa5895ae62e0f9c1eb8f662295ca920d1da7e88f.camel@redhat.com>
 <Y8Am5wAxC48N12PE@quaddy.sgn> <47d9b00c664dbaabd8921a47257ffc3b7c5a1325.camel@redhat.com>
 <Y8AzypbpgDOSzhz6@quaddy.sgn>
In-Reply-To: <Y8AzypbpgDOSzhz6@quaddy.sgn>
From:   Willem de Bruijn <willemb@google.com>
Date:   Thu, 12 Jan 2023 13:38:46 -0500
Message-ID: <CA+FuTSezPJijavANb8879T4eDAP4_53eCUgULhsC2ArW4+Xn0w@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/af_packet: fix tx skb network header on
 SOCK_RAW sockets over VLAN device
To:     =?UTF-8?Q?Herv=C3=A9_Boisse?= <admin@netgeek.ovh>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 11:25 AM Herv=C3=A9 Boisse <admin@netgeek.ovh> wrot=
e:
>
> On Thu, Jan 12, 2023 at 04:47:38PM +0100, Paolo Abeni wrote:
> > I understand, thanks. Still is not clear why the user-space application
> > would attach to dummy0.832 instead of dummy0.
> >
> > With your patch the filter will match, but the dhcp packet will reach
> > the wire untagged, so the app will behave exactly as it would do
> > if/when attached to dummy0.
> >
> > To me it looks like the dhcp client has a bad configuration (wrong
> > interface) and these patches address the issue in the wrong place
> > (inside the kernel).
>
> No, the packet will actually reach the wire as a properly tagged 802.1Q f=
rame.
> For devices that do not support VLAN offloading (such as dummy but also t=
he network card I am using), the kernel adds the tag itself in software bef=
ore transmitting the packet to the real device.
>
> You can verify this with a capture using tcpdump/wireshark on dummy0 vers=
us dummy0.832.
> That's why dhclient has to send its packets over dummy0.832 and not dummy=
0.
>
> The same will happen on a real device. I checked on real hardware, with t=
wo boxes and their network cards connected through a cable.
> If dhclient is started directly on the first box real device (eth0), the =
frame is received untagged by the second box, as intended.
> But, if dhclient is started on top of the VLAN device (eth0.832), the sec=
ond box receives a properly tagged frame.

SOCK_DGRAM writing the tag and SOCK_RAW not writing it is inconsistent.

The driver clearly anticipates SOCK_RAW writers that write only
Ethernet, and fixes up the difference in its ndo_start_xmit:

    /* Handle non-VLAN frames if they are sent to us, for example by DHCP.

That workaround only comes too late for code between dev_queue_xmit
and ndo_start_xmit: tc filters.

Strictly, dhclient is just not writing the right link layer, as
advertised by this device in dev->hard_header_len and
vlan_dev_hard_header. But being pedantic won't make the application
work (I assume it never has).

Perhaps the device can have an optional mode where it does present as
a pure Ethernet device, and handles all the VLAN insertion purely in
the driver code in ndo_start_xmit?
