Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95251179E76
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 05:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgCEECo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 23:02:44 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:41218 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCEECo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 23:02:44 -0500
Received: by mail-qv1-f68.google.com with SMTP id s15so1846294qvn.8
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 20:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=mCxSGFTr8Ldp6bwtnqbh/4BvF/P0vB3ouOrErgIiV84=;
        b=u/9Uo2veonQcRj20ZbJa7H241PKfKCQEou4/AOmuHW5bL+Chz9wRYKUEVi/hr+IIFa
         IEiW4/RrA9TBW0H2fkAUZ/IlBCPbkp1PX7/MNa3cG+fS37t6Vegts37wJriOl9wU9KAY
         OUOW28Br2tQiD69nR4G7k1C90W34HM9O9rUlXKv/IcMj7pQG63kemjEsJ090mIOP/X+0
         fC8GCu4u0/nkF4VXP6muYfT6aPSHGdthPhKT6T9osrmUEmlRH7/WoxJXiyaIlfbP5qHx
         JeOuDzaX4NUnveH5MFPgQrJzyka673Zw2IqVgg4dpZRjvDOjdpirwUJmvduiWWlJoJA7
         P83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=mCxSGFTr8Ldp6bwtnqbh/4BvF/P0vB3ouOrErgIiV84=;
        b=sw6Inl5QjfUnNT86NwRbB3R0ynscfYluHO02Dtgg5BsczBO+n9kksBA7Iji1SVat/O
         M5At/uPOtyHfOR1bM/kLPuK4836IxNEEnKS6OS3Qrn5X4hWptLAtmGvYi0zv+FHyIB8T
         EszUdB4yuDJYs8zdlD/Xxp/nRCDuimy5VS17iOu1AOb1dskFF5X9UcpLvP49lLZIyWAt
         H8FWdjJbkrY3qiwMxy1VswJxWv/AYHhO+edi7TeRNeKa/6p0aqQVOIda3s0xV2Z+Wi6e
         11V2gayi1IvDSVjvPQaZ0OUbNmXa8fuepS2lDsIxNRyHTJvdc0fA+JTIpPcw8fdlATAq
         ZaEw==
X-Gm-Message-State: ANhLgQ0CVedhX/3nBRJ/CEnPb2sindQX+wNRTc1R0uf5xwSSaqhwF5BL
        zHcmwRDcs1TyXu6qr+gMQhSk4F59Ils=
X-Google-Smtp-Source: ADFU+vua3bhX+leSsu/El0qJFk1npwPwKKuIDxv6u7ny/qZVbNySEzydwqU1ALqmgWwtDgcbu/z6Hg==
X-Received: by 2002:a0c:f647:: with SMTP id s7mr4927133qvm.4.1583380962818;
        Wed, 04 Mar 2020 20:02:42 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y62sm14942098qka.19.2020.03.04.20.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 20:02:42 -0800 (PST)
Date:   Thu, 5 Mar 2020 12:02:35 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200305040234.GA2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
 <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
 <d34a35e0-2dbe-fab8-5cf8-5c80cb5ec645@gmail.com>
 <20200304090710.GZ2159@dhcp-12-139.nay.redhat.com>
 <b424f456-364d-d6f1-36cc-5b6fccd13b97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b424f456-364d-d6f1-36cc-5b6fccd13b97@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:07:36AM +0100, Rafał Miłecki wrote:
> BINGO.
> 
> Summary:
> Every "ifconfig $dev down" results in:
> ipv6_mc_down() → igmp6_group_dropped() → igmp6_leave_group() → mld_add_delrec()
> & allocating & adding "struct ifmcaddr6" (ff02::2) to the idev->mc_tomb.

Yes, when link down, we store the pmc info in idev->mc_tomb via
mld_add_delrec(), but later when link up, we didn't create new pmc,
but just copy the pmc info in idev->mc_tomb to current idev via
mld_del_delrec() and free the tomb pmc.

> Should I still try it given my above debugging results?

In the new patch, I removed the "ff02::2" address in ipv6_mc_down()
and re-added it in ipv6_mc_up(). I would appreciate if you could help
try it and see if we really did wrong in mld_add_delrec().

Thanks
Hangbin
