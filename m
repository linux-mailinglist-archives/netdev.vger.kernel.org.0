Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C09484C26
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 02:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbiAEBhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 20:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiAEBhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 20:37:07 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E7C061761;
        Tue,  4 Jan 2022 17:37:07 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id s1so79680905wra.6;
        Tue, 04 Jan 2022 17:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w9H0RMHXELZxjWd3I/ACDf9VOqwYsckamevzKs/JT8s=;
        b=QwBRAKR5sb+6JmBfKpWx5MBc+gE5TWrIBys7KQDlz1SdYJ3j7yco4WoU7dJWv80E2P
         kPadU7lZDdnDwMlpwgCjXBcBQ3YBxCSE5XMUoP55ikCCpcxMxpelm7mRnEt2HDOLnsPl
         oOv0/xMA2hWKYMeszkt05Yu3bNwD/c1jC3uTjhSxf/bNQgQwep0vStLn1DIcR32d7EOs
         vT3kQ/feKUhXilEcfYK0/5kdyFUO9QqDGMIOvJAI9GhO7bjbit4zCTrJ0sgUSuKbpkoQ
         ZnN+bjLVWa9Y+mXdHxYNwRQdQpdl/wEZz+LbGjxFEh37lHDDIwYMk3RypUWCfDaWn19m
         i8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w9H0RMHXELZxjWd3I/ACDf9VOqwYsckamevzKs/JT8s=;
        b=rzgcbkrNcrLSErikZHG+F7q02PV6fLsDzKAeJq0JHKUELkmkm32UWtLWOLPl7TIJ8T
         0QqRzqgoMGUYhKDHx8egDqB1YBMhwsBkOgmzkjz18SEVkSFWguNemX+HehOn8ICNhHq5
         GH43eD6O0tm9gqjjVVzc2bcAv5n8rz+JnXY5LHG7zJunDgoI1pTEdPgUPzfdlSYR4uKu
         oRxAWqU+bZ1Vmkwcpkj1e0yRSzX5ihd3favSW2qV7rJM+efCBQ9Msu784X69bvIFEbZU
         RTpvSZXkaCC8DQdx74r2v/+oYGNo339nQKcRyDbsf1B83IEp+z5dpfsCbL15SZ8O5pQG
         po+g==
X-Gm-Message-State: AOAM5308/RQq1hjJO0kS4NLTFRlHs5p47F21UOlNNbYnCxIj5DSrDyYJ
        t3pEufI10tZwvFS52ZBx6EsfSs2CDuf0xbhXcFFHIcN/
X-Google-Smtp-Source: ABdhPJxvOweL2Cw7kHuiYcMnJpRRLSuLqIN75VpNLpydDefvmhD15Z2ghun+6TAPgmvm+Z2GE6RDojAZxbnc3VEgZk8=
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr45141599wrd.81.1641346625949;
 Tue, 04 Jan 2022 17:37:05 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-13-miquel.raynal@bootlin.com> <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
 <Ycx0mwQcFsmVqWVH@ni.fr.eu.org> <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
 <20220104184340.0e977727@xps13>
In-Reply-To: <20220104184340.0e977727@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 4 Jan 2022 20:36:54 -0500
Message-ID: <CAB_54W6sfWfYNNx9vG2_ZQK2nA86O8-L5RiG-Qg8Dibq2HG7Yg@mail.gmail.com>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 4 Jan 2022 at 12:43, Miquel Raynal <miquel.raynal@bootlin.com> wrot=
e:
>
> Hi Alexander,
>
> > I see that beacons are sent out with
> > "local->beacon.mhr.fc.dest_addr_mode =3D IEEE802154_NO_ADDRESSING;"
> > shouldn't that be a broadcast destination?
>
> In the case of a beacon, 7.3.1.2 Beacon frame MHR field indicate:
>
>         When the Frame Version field is 0b00=E2=80=930b01:
>                 =E2=80=94 The Destination Addressing mode field shall be =
set to
>                 indicated that the Destination Address and Destination
>                 PAN ID fields are not present.
>
> So I think the NO_ADDRESSING choice here is legit. The destination
> field however is useful in the Enhanced beacon frame case, but that's
> not yet supported.

ok, yes I agree.

Thanks.

- Alex
