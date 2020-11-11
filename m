Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C5F2AF6DB
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgKKQrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbgKKQrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 11:47:32 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB83C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 08:47:31 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id w13so3606346eju.13
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 08:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eiOK2q32GbsWI3FsiUTk0GCoUa/T9/oJgnazWEvpmaQ=;
        b=RdRE7oHsp07FwcbAJ7IdX4Gm8nta1tpXPtDuh3lrnF2GosQ8ujoQquwhlPt8ool95M
         XDXNuofVRx4eT23pttiU/04wD0lCzoobjwyBeu8FF8neZz0g0H0xzgnxCu3eIxZBLuFO
         xm2vFQxHwe3B8kmZ/S1ZyVNw1sd2E26plrFGcvd4t6bmDWfss5Sk27R96XdD+VHzVMpk
         jXUCrt1XY7Wp5fKFZt78cj1++zNk6v/7MMSVJ6nRT2Q4dmBNZ77FPyMT6mDyrXAjAnGb
         DK9UaSllHOxKyFw34qK0hzzxEFLDLWX9I4OmccWBpPxYvl+m3XVQir8O/GeCKo8cBwSQ
         AgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eiOK2q32GbsWI3FsiUTk0GCoUa/T9/oJgnazWEvpmaQ=;
        b=sflooOLvI4dLACAmvJ7NP5k4rEFjuodleZgAXHpw88VLXIBrQpgULlC519af5F93na
         BLZMKJhGMujy9DlVG/1cZPt5CuKigx6bzQGomCXp7tvAkYnFyNRjX2xfMmoh0vqqVQ0x
         p1Qq2SbuVxg1wRCdYfsBG/ls9KWCOnsrNucq4siVIr2WggBggCbnkh/UtojdcNCOARsY
         IQAtFyom/GEnlSv5lhc5zePPJ89hCIZY+jXXneAOlMlwQPGsDE33dAsDvulxZKSBvXeL
         I/fPwtCnh253MFHNqn34zSP9/4qmTFJmJijCaiLssf6JkD1AAMjyslfdtxQTRC+FuCHk
         VSEA==
X-Gm-Message-State: AOAM531FpULNwjw/MVYX7x2LoIPFTvZOs62y5ne9zzHJinO8FFp4HW8F
        xXh5l0gWmIHOFxdimpnaRsg=
X-Google-Smtp-Source: ABdhPJzwdWk7lv6l1a/dOlZFK/my2LewpgjpjV9X2bS0tFhlbwhCfwlu/oXqj9/GuI+DVQX2y6x/bw==
X-Received: by 2002:a17:906:b852:: with SMTP id ga18mr27166496ejb.80.1605113250491;
        Wed, 11 Nov 2020 08:47:30 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id b1sm1060161ejg.60.2020.11.11.08.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 08:47:29 -0800 (PST)
Date:   Wed, 11 Nov 2020 18:47:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Markus =?utf-8?Q?Bl=C3=B6chl?= <markus.bloechl@ipetronik.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201111164727.pqecvbnhk4qgantt@skbuf>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
 <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3df0cfa6-cbc9-dddb-0283-9b48fb6516d8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3df0cfa6-cbc9-dddb-0283-9b48fb6516d8@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 07:56:58AM -0800, Florian Fainelli wrote:
> The semantics of promiscuous are pretty clear though, and if you have a
> NIC with VLAN filtering capability which could prevent the stack from
> seeing *all* packets, that would be considered a bug. I suppose that you
> could not disable VLAN filtering but instead install all 4096 - N VLANs
> (N being currently used) into the filter to guarantee receiving those
> VLAN tagged frames?

Are they?

IEEE 802.3 clause 30.3.1.1.16 aPromiscuousStatus says:

APPROPRIATE SYNTAX:
BOOLEAN

BEHAVIOUR DEFINED AS:
A GET operation returns the value “true” for promiscuous mode enabled, and “false” otherwise.

Frames without errors received solely because this attribute has the value “true” are counted as
frames received correctly; frames received in this mode that do contain errors update the
appropriate error counters.

A SET operation to the value “true” provides a means to cause the LayerMgmtRecognizeAddress
function to accept frames regardless of their destination address.

A SET operation to the value “false” causes the MAC sublayer to return to the normal operation
of carrying out address recognition procedures for station, broadcast, and multicast group
addresses (LayerMgmtRecognizeAddress function).;


As for IEEE 802.1Q, there's nothing about promiscuity in the context of
VLAN there.

Sadly, I think promiscuity refers only to address recognition for the
purpose of packet termination. I cannot find any reference to VLAN in
the context of promiscuity, or, for that matter, I cannot find any
reference coming from a standards body that promiscuity would mean
"accept all packets".
