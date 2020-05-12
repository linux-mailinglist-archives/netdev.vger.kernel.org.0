Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F20C1CF451
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 14:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgELM1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 08:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727783AbgELM1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 08:27:17 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3116C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 05:27:15 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n17so10811121ejh.7
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 05:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UQDJI2+HGYsksVNDvLK9A6tyjPx8w6rhHwJ1h3aihio=;
        b=bmClQnZdNjCKVLDJ/axTrqxYYmVH+VXAmPWENAkTaEhLSnGHUXDnwLb8r34jU4t1aO
         nB7n1L4wQUHGjA42rLcLYbXMheOjhrbKWZcljY15i3HEcyo4QeXq5kTOeuRX31MkIn2T
         fh8eCz1xQMRSF97MfvmptbffNDucSW/G+b0u7pULbyqXynULEz0UD14hfNFq9xoR6HBo
         WTRLMJ0N9nF0sOqn6tcez5jbMy2+ubCqCFQUz0Xqhp3cabMmWWrJuISuifbcgA/Z1Ngp
         b0mmCHwgOxzSp9+vl8fELTIkq2cf8047XUKqw04sjubaD5E8MeVflXTIRTWwyNuNdjkk
         Ys6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UQDJI2+HGYsksVNDvLK9A6tyjPx8w6rhHwJ1h3aihio=;
        b=FdDsOp6nTOSQQHFnNKQs4HBP0Z33hL3UCVctGUgqJfRMLmfTN5jV+48C9rFF9eStpC
         htbRjYWL9sYImf3jv42OGiYzi69Ca9cXBIc/X+KlsttDvjd3Vdvm5WfPBBVrUn8fCoM8
         evrjajPL6PDklj5bCOb4zJWtJCzgPhRqFMsW35cv2L9SE+zQkA34G1+GioENgf0I8Ox3
         5GfR/ZvQcxAcpK8WvtXQwINivivOyflc4n6IMl7ZqS7jPrfsG6+MolBbpIuHFjxIej9f
         F4C4awD5eXBIX2AHAN+7IDjsoEyjnPJNDM/25jT1fThGx1MI+CCOB+1KNTUhseo1KPvA
         6BKg==
X-Gm-Message-State: AGi0PuYywSnnb8UQxFhYaQfPGHa3arB5gpWqD3e0PNEcG1jJXTHRzyjI
        rn22FuYydNYxa9JIL7Z0XOAOcEkBdAO9ZDyNrJFwZA==
X-Google-Smtp-Source: APiQypKtI/gxICPNS4T28jpQrtcKycQcQwMlBiJkOUnPzj2N2mk34YegiOELOlICRcW59feCFrEkUPhfFeR3bMGSM5g=
X-Received: by 2002:a17:906:7f0c:: with SMTP id d12mr17076683ejr.40.1589286434409;
 Tue, 12 May 2020 05:27:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7497:0:0:0:0:0 with HTTP; Tue, 12 May 2020 05:27:13
 -0700 (PDT)
X-Originating-IP: [5.35.46.227]
In-Reply-To: <62f29aba-93d5-9a7d-a4ac-7fae1ac46f22@suse.com>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
 <1589192541-11686-2-git-send-email-kda@linux-powerpc.org> <649c940c-200b-f644-8932-7d54ac21a98b@suse.com>
 <CAOJe8K29vn6TK8t7g7j387F41ig-9yY-jT-k=mVpDQW3xmDPSg@mail.gmail.com> <62f29aba-93d5-9a7d-a4ac-7fae1ac46f22@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 12 May 2020 15:27:13 +0300
Message-ID: <CAOJe8K3mQuf_wj6rZ-hSHixosBsdvHZkgZRYHRGJjqaXHNoPxw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 1/2] xen networking: add basic XDP support for xen-netfront
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     paul@xen.org, netdev@vger.kernel.org, brouer@redhat.com,
        wei.liu@kernel.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
> On 11.05.20 19:27, Denis Kirjanov wrote:
>> On 5/11/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>> On 11.05.20 12:22, Denis Kirjanov wrote:
>>>> The patch adds a basic XDP processing to xen-netfront driver.
>>>>
>>>> We ran an XDP program for an RX response received from netback
>>>> driver. Also we request xen-netback to adjust data offset for
>>>> bpf_xdp_adjust_head() header space for custom headers.
>>>>
>>>> synchronization between frontend and backend parts is done
>>>> by using xenbus state switching:
>>>> Reconfiguring -> Reconfigured- > Connected
>>>>
>>>> UDP packets drop rate using xdp program is around 310 kpps
>>>> using ./pktgen_sample04_many_flows.sh and 160 kpps without the patch.
>>>
>>> I'm still not seeing proper synchronization between frontend and
>>> backend when an XDP program is activated.
>>>
>>> Consider the following:
>>>
>>> 1. XDP program is not active, so RX responses have no XDP headroom
>>> 2. netback has pushed one (or more) RX responses to the ring page
>>> 3. XDP program is being activated -> Reconfiguring
>>> 4. netback acknowledges, will add XDP headroom for following RX
>>>      responses
>>> 5. netfront reads RX response (2.) without XDP headroom from ring page
>>> 6. boom!
>>
>> One thing that could be easily done is to set the offset on  xen-netback
>> side
>> in  xenvif_rx_data_slot().  Are you okay with that?
>
> How does this help in above case?
>
> I think you haven't understood the problem I'm seeing.
>
> There can be many RX responses in the ring page which haven't been
> consumed by the frontend yet. You are doing the switch to XDP via a
> different communication channel (Xenstore), so you need some way to
> synchronize both communication channels.
>
> Either you make sure you have read all RX responses before doing the
> switch (this requires stopping netback to push out more RX responses),
> or you need to have a flag in the RX responses indicating whether XDP
> headroom is provided or not (requires an addition to the Xen netif
> protocol).
Hi J=C3=BCrgen,

I see your point that we can have a shared ring with mixed RX responses off=
set.
Since the offset field is set always  to 0 on netback side we can
adjust it and thus mark that a response has the offset adjusted or
it's not (if the offset filed is set to 0).

In this case we have to run an xdp program on netfront side only for a
response with offset set to xdp headroom.

I don't see a race in the scenario above.

Or I'm completely wrong and this can not happen due to the
> way XDP programs work, but you didn't provide any clear statement this
> being the case.
>
>
> Juergen
>
