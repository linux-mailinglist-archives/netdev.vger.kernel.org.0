Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC2A486F67
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 02:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345035AbiAGBHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 20:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiAGBHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 20:07:38 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AECC061245;
        Thu,  6 Jan 2022 17:07:36 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r10so397130wrc.3;
        Thu, 06 Jan 2022 17:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dvXxCoWY1kNIwylg7uDB23lhx3elqxgvYvaRNhf4uco=;
        b=YP5mxIzb1ywJEJ+1FwbfBQVYgec6CLpOdXuDvKoB+1l7m1P2awgxVwsd+2MB6nRB2k
         eHuweQVPdumYfnyKQmzkoRzfDUiDIJcJZaB6i7byD4QKQ6ce/9ckPYp14JSAJaRCqjgK
         YyRj34N2lVvPFxxIisBmLjtNdAMkeb1+UGnW9+uTfeAiiMvM2vDECkdf2oIoAv7oCLab
         6xyS2ksKgFUbj+QduRqLjt+rm6ZxFGgspQzl7nqRDTIbJbf8k5lPwgaJmDGcGU8S4FJR
         1u9H4IvxEhVgKREyr4PE5z0MKMGod90GVNFXIyEGtZVfznFGa2P93Lv5cgX++SrcKXKF
         RGgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dvXxCoWY1kNIwylg7uDB23lhx3elqxgvYvaRNhf4uco=;
        b=wLSHpqGfZyohsBhcw3Ra86iVGDap9geQkfCPNTDGDiBwXteLofRSqE8Ybus2p1x2b2
         O2durPAiUj1MV11PxoOXIlvi82L+QAsVmFU46OnxhxtRsmVpPIJ8L1LAiyBQXFSF2YSo
         4jkhhKM/PsUTApKsy1tHDcwuczKJrsrsPt9YZ995xKfmB8hZVDCTmnt7wQOHgnrwWuTx
         U8gU85C2urZt/zMuPQjnU+8v0CN7ijFmeQJc7AYIPaiAHEPFsMMVeLx3y67Q/Fbp1R7p
         RJKWgRpBoVbfh+ReSBRfnJq32WD82haT29yPiFm9MTqc5WWfW9OqWJMsZSSvRjjjMw50
         fj7w==
X-Gm-Message-State: AOAM532m7Y9Q4Yv9ukbBGQWskZDrYebx/J7zf/SU2ewN8LxmtmewTQax
        0Whn4fHQatSNag1xmor5GjSZdTdWrqCxBEI5UQg=
X-Google-Smtp-Source: ABdhPJz28xWGhRkfa+YhhQVOCNAW0dU2b8FyNJ9xTaC1t/SQuT6p8oodmCKD3Zo4nnmfY7r3XUVb21vMh/1/eI0UBtk=
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr53336911wrd.81.1641517655399;
 Thu, 06 Jan 2022 17:07:35 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-13-miquel.raynal@bootlin.com> <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
 <Ycx0mwQcFsmVqWVH@ni.fr.eu.org> <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
 <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
 <20220104191802.2323e44a@xps13> <CAB_54W5quZz8rVrbdx+cotTRZZpJ4ouRDZkxeW6S1L775Si=cw@mail.gmail.com>
 <20220105215551.1693eba4@xps13> <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
 <20220106201516.6a48154a@xps13>
In-Reply-To: <20220106201516.6a48154a@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 6 Jan 2022 20:07:24 -0500
Message-ID: <CAB_54W5=6Zo7CzwfZw-OfRx6i4__pRt=QdmNbWdm6EQS5tvE7w@mail.gmail.com>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 6 Jan 2022 at 14:15, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Wed, 5 Jan 2022 19:38:12 -0500:
>
> > Hi,
> >
> >
> > On Wed, 5 Jan 2022 at 15:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > ...
> > > > rest in software is a bigger task here...
> > >
> > > On the symbol duration side I feel I'm close to a working PoC.
> > >
> >
> > oh, ok.
>
> I think it's ready, I'll soon send two series:
> - the symbol duration update
> - v2 for this series, which will not apply without the symbol duration
>   update.
>

ok. Thanks.

> > > So there is 'only' this item left in my mind. Could you please clarify
> > > what you expect from me exactly in terms of support for the promiscuous
> > > filters we discussed so far?
> > >
> >
> > I think for now it's okay to set the device into promiscuous mode and
> > enable the flag which checks for bad FCS... we can still implement the
> > filter modes later (and I think it should work on all supported
> > transceivers (except that SoftMAC/HardMAC thing)).
>
> I considered the following options in order to do that:
> 1- Hack all ->set_promiscuous() driver implementations to set
>    IEEE802154_HW_RX_DROP_BAD_CKSUM as long as it was not already set
>    initially.
> 2- Set the above flag at scan level, ie. in
>    scan.c:mac802154_set_promiscuous_mode(). But this would be a bit
>    ugly and I'd need to add a persistent field somewhere in the
>    wpan_dev structure to remember how the flags settings where before
>    the scan code hacked it.

I think there exists two layers of "promiscuous mode": there exists a
phy level and a mac level. I am not sure at some points what's meant
now. Whereas phy is regarding the filtering mode whatever will be
delivered to mac802154, the wpan (mac) level is what 802.15.4 mac says
it is. The mac promiscuous mode requires the phy promiscuous mode (so
far I understand).

> 3- Add more code in hwsim to handle checksum manually instead of
>    by default setting the above flag to request the core to do the
>    job. This way no driver would actually set this flag. We can then
>    consider it "volatile" and would not need to track its state.
> 4- We know that we are in a scan thanks to a mac802154 internal
>    variable, we can just assume that all drivers are in promiscuous
>    mode and that none of them actually checks the FCS. This is
>    certainly the simplest yet effective solution. In the worst case, we
>    are just doing the check twice, which I believe does not hurt as
>    long as the checksum is not cut off. If the checksum is cut, then
>    the core is buggy because it always remove the two last bytes.
>
> I picked 4 for now, but if you think this is unreliable, please
> tell me what do you prefer otherwise.
>

I think we have some flag to add a calculated checksum
"IEEE802154_HW_RX_OMIT_CKSUM" which is currently not used by any
driver. I think your case that the checksum is cut off does not exist
in 4.? So far I understand we can still move the FCS check to the
hardware by not breaking anything if the hardware supports it and the
behavior should be the same.
So do the 4.?

> > One point to promiscuous mode, currently we have a checking for if a
> > phy is in promiscuous mode on ifup and it would forbid to ifup a node
> > interface if the phy is in promiscuous mode (because of the missing
> > automatic acknowledgement). I see there is a need to turn the phy into
> > promiscuous mode during runtime... so we need somehow make sure the
> > constraints are still valid here.
>
> Yes, the code (rx.c) currently drops everything that is not a beacon
> during a scan.
>

Okay, I will look at this code closely regarding whenever multiple
wpan_devs are running.

You should also check for possible stop of all possible wpan dev
transmit queues, if it's not already done. I suppose a scan can take a
long time and we should not send some data frames out. I am thinking
about the long time scan operation... if we stop the queue for a long
time I think we will drop a lot, however the scan can only be
triggered by the right permissions and the user should be aware of the
side effects. Proper reliable upper layer protocols will care or non
reliable will not care about this.

There still exists the driver "ca8210" which is the mentioned HardMAC
transceiver in SoftMAC. There should somehow be a flag that it cannot
do a scan and the operation should not be allowed as the xmit callback
allows dataframes only.

- Alex
