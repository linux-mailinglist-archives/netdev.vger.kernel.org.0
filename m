Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDAA266859
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 20:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgIKSmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 14:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgIKSmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 14:42:10 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB67C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 11:42:10 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g7so2266438iov.13
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 11:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DNQ+tlQwz0p357/D44qBWbxw+sJO4ObWWALNDOh20qM=;
        b=iLEStBFnn7JbyUJb6xKvSfYADLwddBVIsvJeGqviE0oMnA3HI4dVoifSMpnm3bi5dV
         hhz4dr5KwGLaoYzbqh+qHxdogon5Ox73+ZbZkRA623fmjkBvN5I/Aj+txR/1GOBUZ8oY
         sRfdhqKfXjSeGh7k2MgHdwqPbHi1oSgnhN4PO1+KE5y+IWIqfbdwlMHgezYB4zg7osuC
         Kdp5JV7CxLHQoCbu+ZHMDHt8e0HLVmMRUiuXG/JnhmejP/lY6eQ+VFNJBPT3Pa7Blej3
         2sXTj+Kr1G8i5pGajH1sDN6pFkf12ya9i10NJtcciHqSiZ7mM8SFJUZKNV25zbZBoz6W
         24Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DNQ+tlQwz0p357/D44qBWbxw+sJO4ObWWALNDOh20qM=;
        b=uMd5DEtR45px5OqpIg/ZaelCSKtVr2fk3TfqH6GLiSQK8kc0RnRcKRw7qwqZjCxNkD
         1iCGnpNOXDqsI2edB0Tku+gnRuFcdIt4ceVU8hzFej8xIyN7ojZ75z7J0Yi+Yxs9Ldh0
         WbKXSPn9WEiCGxqKkWhVRae4szCez+IcLpj7rxDu20TiVu5H0d2w84ZN0EZxUeEyD43K
         Cj9zTlw3utTTrQiJj/1AAeIzaoUwvCOLkHGj5X7niCGkeeyfXFyHosCUIbsZvO5MrVjQ
         5lESBdnY5XWgAa8M1rL/YQR2lkCNjjdnLsRW2koBzEn4YrE9khPSl6DSp4tLYavYAcN7
         csUA==
X-Gm-Message-State: AOAM5313D/uZwUKo1lBIq7//Dxzkw2PZQ+a+Dl3o6i+vmUB2vl6VE752
        Bpwh9O8Z+F5UPLhp9j/mmtab/QE3+VkoSLXicSSAzwjSfdM=
X-Google-Smtp-Source: ABdhPJyuceHMg35hmqdr4BcmZP0aFCq4o0K+BSapp7kEUdxXR76kVvfj/H0x3rPvu6vMJb9SBVSrVf3yBFjabI8wYn0=
X-Received: by 2002:a5e:8f4c:: with SMTP id x12mr2870343iop.38.1599849729284;
 Fri, 11 Sep 2020 11:42:09 -0700 (PDT)
MIME-Version: 1.0
References: <1599826106-19020-1-git-send-email-magnus.karlsson@gmail.com>
 <20200911120519.GA9758@ranger.igk.intel.com> <CAJ8uoz3ctVoANjiO_nQ38YA-JoB0nQH1B4W01AZFw3iCyCC_+w@mail.gmail.com>
 <20200911131027.GA2052@ranger.igk.intel.com> <b28b4e93-50c2-6183-90ea-8d33902e8f21@intel.com>
In-Reply-To: <b28b4e93-50c2-6183-90ea-8d33902e8f21@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 11 Sep 2020 11:41:58 -0700
Message-ID: <CAKgT0UcXLi5fK3UiOpfPKu6FxJh1tH4r+_ZjCNsH=cEqHztOOg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next] i40e: allow VMDQs to be used
 with AF_XDP zero-copy
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 11:05 AM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
>
>
> On 9/11/2020 6:10 AM, Maciej Fijalkowski wrote:
> > On Fri, Sep 11, 2020 at 02:29:50PM +0200, Magnus Karlsson wrote:
> >> On Fri, Sep 11, 2020 at 2:11 PM Maciej Fijalkowski
> >> <maciej.fijalkowski@intel.com> wrote:
> >>>
> >>> On Fri, Sep 11, 2020 at 02:08:26PM +0200, Magnus Karlsson wrote:
> >>>> From: Magnus Karlsson <magnus.karlsson@intel.com>
> >>>>
> >>>> Allow VMDQs to be used with AF_XDP sockets in zero-copy mode. For some
> >>>> reason, we only allowed main VSIs to be used with zero-copy, but
> >>>> there is now reason to not allow VMDQs also.
> >>>
> >>> You meant 'to allow' I suppose. And what reason? :)
> >>
> >> Yes, sorry. Should be "not to allow". I was too trigger happy ;-).
> >>
> >> I have gotten requests from users that they want to use VMDQs in
> >> conjunction with containers. Basically small slices of the i40e
> >> portioned out as netdevs. Do you see any problems with using a VMDQ
> >> iwth zero-copy?
>
> Today VMDQ VSIs are used when a macvlan interface is created on top of a
> i40e PF with l2-fwd-offload on. But i don't think we can create an
> AF_XDP zerocopy socket on top of a macvlan netdev as it doesn't support
> ndo_bpf or ndo_xdp_xxx apis or expose hw queues directly.
>
> We need to expose VMDQ VSI as a native netdev that can expose its own
> queues and support ndo_ ops in order to enable AF_XDP zerocopy on a
> VMDQ. We talked about this approach at the recent netdev conference to
> expose VMDQ VSI as a subdevice with its own netdev.
>
> https://netdevconf.info/0x14/session.html?talk-hardware-acceleration-of-container-networking-interfaces

I still hold the opinion that macvlan is still the best way to go
about addressing most of these needs. The problem with doing isolation
as separate netdevs is the fact that east/west traffic starts to
essentially swamp the PCIe bus on the device as you have to deal with
broadcast/multicast replication and east/west traffic. Leaving that
replication and east/west traffic up to software to handle while
allowing the unicast traffic to be directed is the best way to go in
my opinion.

The problem with just spawning netdevs is that each vendor can do it
differently and what you get varies in functionality. If anything we
would need to come up with a standardized interface to define what
features can be used and exposed. That was one of the motivations
behind using macvlan. So if anything it seems like it might make more
sense to look at extending the macvlan interface to enable offloading
additional features to the lower level device.

With that said I am not certain VMDq is even the right kind of
interface to use for containers. I would be more interested in
something like what we did in fm10k for macvlan offload where we used
resource tags to identify traffic that belonged to a given interface
and just dedicated that to it rather than queues and interrupts. The
problem with dedicating queues and interrupts is that those are a
limited resource so scaling will become an issue when you get to any
decent count of containers.

- Alex
