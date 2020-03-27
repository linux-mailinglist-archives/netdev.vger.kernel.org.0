Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50EB195C39
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgC0RPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:15:49 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:38341 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0RPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 13:15:48 -0400
Received: by mail-vk1-f194.google.com with SMTP id n128so2883947vke.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 10:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YkdfgfCAf3fZ2/2PAS0o1FL8kUaB/zOGqNQ2PAsxSt4=;
        b=UdHG5Dn1tUXfVF2NXuUjh90ft215Tb6XsaDoJkWRcrlrrioYH48Nl+8i/LUd/Zh8Nq
         Go/1CsIp4D6XXw4GX/4S/KHShVXEt4exFuwTbzSuWhNSDpANj6MpfsNrPovPSPzMOJE0
         lPrlXLv+BpHKXxFmHfft53KHhEcXGQdJg7XgO7+um6+HqPVPwPeuNH7csfiJXKIEuEkv
         4+r1rU0VFOl3zMd69Qv65/ck6zu8WMNdzqckqCEao1NHnHb0xjfHKn62Ki6IvafZuq6b
         BrUw9lYCKG1WQ0Op6A2TDykBPYaXdByeGZQk6ni+i1B99857t9QVkO4qkAiQUUJ0v3Xu
         QklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YkdfgfCAf3fZ2/2PAS0o1FL8kUaB/zOGqNQ2PAsxSt4=;
        b=LDUc5oVyrVX7sOGizjr+uXEhY4kdl8O37ODo2EzXLascg8mc5xFTf68+TXdDhhFa2w
         gKi+ZxifDx8K7c9M8IZn5dAIqmWY0sXAFuUoktEeJ9hDPgeX9iPoyiUZwrAm5OHtsvnJ
         1kprgjCaYe9prnlAv/as1/pcNjeda+7hsMQH9Gb2L+Ou8978qJedqt8ev4h17GGxsbzW
         rJW02udzihPhVLQTKd2IDgr27OVn1t4u/JYkxkm6OQ6o6+wXTC2rM54+VUirTomBDqja
         EoOR2aWyoNoPj0fvMn2ryg83bITsD1KEJv2hDvjRcGFeftjRBjMotrCEDESEQduV1Dj7
         I//w==
X-Gm-Message-State: ANhLgQ1UaKlVza4pNJlVaHlMYq2CZaBqQhh2YhoRNeQRRlSE5MWuD8x0
        Bu9pvIt19FfyhKLXuh7ySdgLF03UgEMQREKXbe+BNg==
X-Google-Smtp-Source: ADFU+vufzwAJc5tLUIXT6ChD5HNc95UKmGRWt3tr2bYpxNGiJmUvwSzT2dT8Y1zoNbeBaE6HubjGW1enlrqnX6ZFuTQ=
X-Received: by 2002:a05:6122:330:: with SMTP id d16mr12217346vko.28.1585329346994;
 Fri, 27 Mar 2020 10:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200326094252.157914-1-brambonne@google.com> <20200326.114550.2060060414897819387.davem@davemloft.net>
 <CABWXKLwamYiLhwUHsb5nZHnyZb4=6RrrdUg3CiX7CZOuVime7g@mail.gmail.com> <a50808d0-df80-4fbc-a0aa-5a3342067378@www.fastmail.com>
In-Reply-To: <a50808d0-df80-4fbc-a0aa-5a3342067378@www.fastmail.com>
From:   =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>
Date:   Fri, 27 Mar 2020 18:15:34 +0100
Message-ID: <CABWXKLz-+wmhypzZGRMCtsWkGzg0-hj8qzjC2M=JYZXRWXFjEQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ipv6: Use dev_addr in stable-privacy address generation
To:     Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, kuba@kernel.org,
        netdev@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hannes,

Thank you for your detailed explanation and helping me understand the
context! This is really useful.

On Fri, Mar 27, 2020 at 2:06 PM Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> The main idea behind stable IPv6 identifiers is to eventually replace EUI=
-48 based generated addresses, because knowledge of the MAC address should =
never leave the broadcast domain you are in. This leads to tracking of a us=
er moving between different networks (in this case moving between different=
 ipv6 prefixes). It does not necessarily replace the temporary address mode=
 which fully randomizes addresses and is still available to you for use in =
cases where you don't want to have this compromise. temp_addresses are stil=
l a good choice to use.
>
> MAC address randomization was mainly introduced to blind the unique ident=
ifier during wifi probing and association, where no IPv6 traffic is yet vis=
ible on unencrypted links. As soon as the encrypted link between your wifi =
endpoint and the access point is established, IPv6 addresses are generated =
and used inside the "encrypted wifi tunnel". This is an orthogonal measure =
to reduce the exposure of unique identifiers in the closer geographical pro=
ximity.

While the purpose of disassociated MAC address randomization is indeed
to prevent tracking a device during probing and association, my
understanding is that connected MAC address randomization (as used in
Android, for example) is designed to prevent devices being tracked
across different networks that are managed by the same network
operator. In this mode, a different MAC address is used for every
network (based on SSID in the case of wireless networks) the user
associates with. A user using connected MAC address randomization to
associate with two different networks has the privacy expectation that
those networks are not able to link those associations to the same
device without some other form of identification.

> You might want to combine those two features: Not being able to be disclo=
sed in your proximity while having a stable address on your network. If tha=
t is not your goal, you can still enable temporary addresses, which will fu=
lly randomize your IPv6 addresses and are thus is completely independent of=
 your MAC address. This would meet your concerns above.

I was under the impression that use_tempaddr does not apply to
link-local addresses. Is this not the case? A quick experiment on my
machine shows:

# sysctl -w net.ipv6.conf.enp0s31f6.use_tempaddr=3D2
# ip link set dev enp0s31f6 down && ip link set dev enp0s31f6 up
# ip address show dev enp0s31f6
2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
pfifo_fast state UP group default qlen 1000
inet6 {same as before} scope link noprefixroute
valid_lft forever preferred_lft forever

> My additional concern with this patch is that users might already expect =
a certain way of the generation of stable IPv6 identifiers: even though wpa=
_supplicant randomizes the mac address, they might already depend on the st=
able generation of those addresses. If this changes, contact to those syste=
ms might get lost during upgrade. Though I don't know how severe this scena=
rio is, I do, in fact, have some IPv6 stable identifiers in my shell histor=
y which are wifi endpoints.

If this is a scenario we care about, do you think it would make sense
to put this behavior behind a separate configuration parameter?
Something like use_software_mac, defaulting to disabled to keep
current behavior?

> If the IPv6 link local address can get discovered on the unencrypted wifi=
 medium, I would be concerned but I don't think that is the case. In case o=
f fully unencrypted wifis you can make the above case. It is possible to de=
termine if a network endpoint (with the same secret and permanent mac addre=
ss) shows up again. In this case I would recommend temporary addresses.

I'm not sure I understand this paragraph. In unencrypted wireless
networks, the link-local IPv6 address would be visible to
eavesdroppers when it's being used, again negating the benefits of MAC
address randomization. Please let me know if I misunderstood.

Thanks again for taking the time to respond to my questions.

Kind regards,
Bram
