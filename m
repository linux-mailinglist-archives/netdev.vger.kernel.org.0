Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCB939C09
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 11:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfFHJP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 05:15:29 -0400
Received: from pb-smtp21.pobox.com ([173.228.157.53]:60011 "EHLO
        pb-smtp21.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfFHJP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 05:15:28 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jun 2019 05:15:27 EDT
Received: from pb-smtp21.pobox.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 8DC477FC3E;
        Sat,  8 Jun 2019 05:08:29 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=to:cc:from
        :subject:message-id:date:mime-version:content-type
        :content-transfer-encoding; s=sasl; bh=jFkOIkwtY1j9QwTNMffRGuqkA
        v8=; b=aeVIpH+r/etQ7zYRVtxNAvP5d5TvIFEZoDQVjLyrzfmtVOqYjtzRdzubY
        9sWathkAZ6zpJxBsQXkpueKXljX/6UC476HH1tOU6LC14RN0qz4eTkbrv5Gr84/1
        rYql2yUrFpqfqoyKwNLI4tuRpeJlo4FK2ofGAxTJLMW6ORvKy4=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:from
        :subject:message-id:date:mime-version:content-type
        :content-transfer-encoding; q=dns; s=sasl; b=g/U8etg3g9LIUJtBBkG
        A2hdB3EeC/irrXuvdRs2xJkFbsluNlV9XnJn58WCpj9xUb5+CGr3Ievz/c/Et4gn
        f6YhktVBSIfprM+U9BKY4RCBwh1TlippUu4yloBkOGiIomfyBbn3csKDznPeSXlb
        mtrLWsXg4Rtzoaektvxci1fg=
Received: from pb-smtp21.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 856517FC3D;
        Sat,  8 Jun 2019 05:08:29 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
Received: from [192.168.2.4] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp21.pobox.com (Postfix) with ESMTPSA id A65C37FC3C;
        Sat,  8 Jun 2019 05:08:26 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
To:     Felix Fietkau <nbd@nbd.name>,
        openwrt-devel <openwrt-devel@lists.openwrt.org>
Cc:     netdev@vger.kernel.org, Vitaly Chekryzhev <13hakta@gmail.com>
From:   Daniel Santos <daniel.santos@pobox.com>
Subject: Using ethtool or swconfig to change link settings for mt7620a?
Message-ID: <5316c6da-1966-4896-6f4d-8120d9f1ff6e@pobox.com>
Date:   Sat, 8 Jun 2019 04:06:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: F9E6FF60-89CC-11E9-9083-8D86F504CC47-06139138!pb-smtp21.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I need to change auto-negotiate, speed and duplex for a port on my
mt7620a-based device, but I'm not quite certain that I understand the
structure here.=C2=A0 When using ethtool on eth0 I always get ENODEV,
apparently because priv->phy_dev is always NULL in fe_get_link_ksettings
of drivers/net/ethernet/mtk/ethtool.c.=C2=A0 But I'm being told that eth0=
 is
only an internal device between the =C2=B5C and the switch hardware, so i=
t
isn't even the one I need to change.

If this is true, then it looks like I will need to implement a
get_port_link function for struct switch_dev_ops?=C2=A0 Can anybody confi=
rm
this to be the case?=C2=A0 Also, are there any examples aside from the
Broadcom drivers?=C2=A0 I have the mt7620 programmer's guide and it speci=
fies
the registers I need to change.

Thanks,
Daniel
