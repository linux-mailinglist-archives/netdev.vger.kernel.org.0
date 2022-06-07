Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790B953F445
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 05:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiFGDEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 23:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiFGDEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 23:04:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C1AE8217A
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 20:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654571059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SQhfKMsVuNsue9Bo/8dSPtMyaBIV0FNl9cHVowhaNTI=;
        b=Zc1cg8XhQmn/P90EmwxG6ROtk5DPiVhAzynatBs+A1pv5QjKrCzesHTUfE2GsSqqmwy3dE
        Zz4Sb9+1M1WOlney0iS9aaQaa5q/ixSndxXwVgtc0+H2/Hmh7G9u8h3HIwFk3pC1prdsf+
        1QfMdHLqrKqkp3Y9LWrRHxcSVV+6ra4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-pkvfowQoMTetyI06MnuTBA-1; Mon, 06 Jun 2022 23:04:18 -0400
X-MC-Unique: pkvfowQoMTetyI06MnuTBA-1
Received: by mail-qv1-f71.google.com with SMTP id z10-20020ad4414a000000b004644d6dafe3so9992600qvp.11
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 20:04:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SQhfKMsVuNsue9Bo/8dSPtMyaBIV0FNl9cHVowhaNTI=;
        b=tGWfLV7y//pgKVrqUA3E3qqsAKkKM+wZz0PsxDjHDT1x2Iik9pCLoz2bb+duHgfT7V
         Iit/4nuAVdNelqEZDoarpSuh+SwdxLSg6mYu08rOIbVh5fQ/ZYEcoMcWPFt9HCNp2BOR
         docBrqqp/0CJpbMkTTrKQQ3taEQH07FiIXPf6qIw8E1dQJR1rvXFQ6mK1JO1q2xelj6b
         P/ImGL1NVIAdFLXGcKkEdLQz5yqgjdfDJtAVwYQACXU9ywBEujgwruPReptnNr0oungu
         7kQrdv9ePS5zZcHazPE7qFG6/DASllklNritKBaWv1FB9QcAWA1fbC3Kmy29m0diuXCy
         2q3Q==
X-Gm-Message-State: AOAM531jBSDLp77gI6K14IL7EqYUv0cKcY5Esqi5rYjzeUHSYOjdbg9+
        PQprUBJrItyLhbl53tMB1Qk2og1HDu6JjcXOAlB8tUuOjuPZRM9STf8JJoqM7TxBhQ3+cAuaxP7
        qe8smJr+M4AvdRj/Pr2eIzemcaWDF9tPH
X-Received: by 2002:ac8:5a91:0:b0:304:d3b6:ff5 with SMTP id c17-20020ac85a91000000b00304d3b60ff5mr18954967qtc.470.1654571057559;
        Mon, 06 Jun 2022 20:04:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTBrxg4VlIVGlSVT71V3tF0QqEvqQsNFvEZ/wL6qRU+cXzB8OTzuA5IDI2v5gYLHZ+AWVlaQoaxPJ9z2yfVYs=
X-Received: by 2002:ac8:5a91:0:b0:304:d3b6:ff5 with SMTP id
 c17-20020ac85a91000000b00304d3b60ff5mr18954956qtc.470.1654571057316; Mon, 06
 Jun 2022 20:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
 <20220603182143.692576-2-miquel.raynal@bootlin.com> <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
 <20220606174319.0924f80d@xps-13>
In-Reply-To: <20220606174319.0924f80d@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 6 Jun 2022 23:04:06 -0400
Message-ID: <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator interface type
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 6, 2022 at 11:43 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Fri, 3 Jun 2022 22:01:38 -0400:
>
> > Hi,
> >
> > On Fri, Jun 3, 2022 at 2:34 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > The current enum is wrong. A device can either be an RFD, an RFD-RX, an
> > > RFD-TX or an FFD. If it is an FFD, it can also be a coordinator. While
> > > defining a node type might make sense from a strict software point of
> > > view, opposing node and coordinator seems meaningless in the ieee
> > > 802.15.4 world. As this enumeration is not used anywhere, let's just
> > > drop it. We will in a second time add a new "node type" enumeration
> > > which apply only to nodes, and does differentiates the type of devices
> > > mentioned above.
> > >
> >
> > First you cannot say if this is not used anywhere else.
>
> Mmmh, that's tricky, I really don't see how that might be a
> problem because there is literally nowhere in the kernel that uses this
> type, besides ieee802154_setup_sdata() which would just BUG() if this
> type was to be used. So I assumed it was safe to be removed.
>

this header is somehow half uapi where we copy it into some other
software e.g. wpan-tools as you noticed.

> > Second I have
> > a different opinion here that you cannot just "switch" the role from
> > RFD, FFD, whatever.
>
> I agree with this, and that's why I don't understand this enum.
>
> A device can either be a NODE (an active device) or a MONITOR (a
> passive device) at a time. We can certainly switch from one to
> another at run time.
>
> A NODE can be either an RFD or an FFD. That is a static property which
> cannot change.
>
> However being a coordinator is just an additional property of a NODE
> which is of type FFD, and this can change over time.
>
> So I don't get what having a coordinator interface would bring. What
> was the idea behind its introduction then?
>

There exists arguments which I have in my mind right now:

1. frame parsing/address filter (which is somehow missing in your patches)

The parsing of frames is different from other types (just as monitor
interfaces). You will notice that setting up the address filter will
require a parameter if coordinator or not. Changing the address
filterung during runtime of an interface is somehow _not_ supported.
The reason is that the datasheets tell you to first set up an address
filter and then switch into receiving mode. Changing the address
filter during receive mode (start()/stop()) is not a specified
behaviour. Due to bus communication it also cannot be done atomically.
This might be avoidable but is a pain to synchronize if you really
depend on hw address filtering which we might do in future. It should
end in a different receiving path e.g. node_rx/monitor_rx.

2. HardMAC transceivers

The add_interface() callback will be directly forwarded to the driver
and the driver will during the lifetime of this interface act as a
coordinator and not a mixed mode which can be disabled and enabled
anytime. I am not even sure if this can ever be handled in such a way
from hardmac transceivers, it might depend on the transceiver
interface but we should assume some strict "static" handling. Static
handling means here that the transceiver is unable to switch from
coordinator and vice versa after some initialization state.

3. coordinator (any $TYPE specific) userspace software

May the main argument. Some coordinator specific user space daemon
does specific type handling (e.g. hostapd) maybe because some library
is required. It is a pain to deal with changing roles during the
lifetime of an interface and synchronize user space software with it.
We should keep in mind that some of those handlings will maybe be
moved to user space instead of doing it in the kernel. I am fine with
the solution now, but keep in mind to offer such a possibility.

I think the above arguments are probably the same why wireless is
doing something similar and I would avoid running into issues or it's
really difficult to handle because you need to solve other Linux net
architecture handling at first.

> > You are mixing things here with "role in the network" and what the
> > transceiver capability (RFD, FFD) is, which are two different things.
>
> I don't think I am, however maybe our vision differ on what an
> interface should be.
>
> > You should use those defines and the user needs to create a new
> > interface type and probably have a different extended address to act
> > as a coordinator.
>
> Can't we just simply switch from coordinator to !coordinator (that's
> what I currently implemented)? Why would we need the user to create a
> new interface type *and* to provide a new address?
>
> Note that these are real questions that I am asking myself. I'm fine
> adapting my implementation, as long as I get the main idea.
>

See above.

- Alex

