Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF48F138DFE
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgAMJmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:42:16 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35609 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbgAMJmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 04:42:15 -0500
Received: by mail-ed1-f68.google.com with SMTP id f8so7869165edv.2;
        Mon, 13 Jan 2020 01:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U7KeLP59PevGGC5Z3wB8REEwHPKJRQN3w5hiDB2hOxQ=;
        b=gkdIVs2lFneKxILRe08ZFuatX83Y1qz9EEbVaioH/dqogaaCCdsTaKHQ+JHTS3srR0
         F2mHpMbTne+ScQQODsLLcDSztAY3RlD3ghO5cSKu6JhHjDUP0evfCBmHnx+sHdPYehLT
         fhE8+ad2EaaexkZhkPJenTbckLlM9La2xTJvRtcbhratmc6w7+iKbpp5cQuHiILJ2BG5
         rcNMTHI46v9qSBc77zu1QQX+Gxhm6sq8Pmv4X4Ky6xew543BRMrEDsZ1e+ns3w58ZE+Z
         G0fSFsa9y6c3vxWrWSK9c3OlJ+Y/2MGU0BafdEHzo839WVJuRNU+wFRCJGIReeY89RKc
         eLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U7KeLP59PevGGC5Z3wB8REEwHPKJRQN3w5hiDB2hOxQ=;
        b=RX+HQAfi2pILhtulibdshzl05QkSUguafoMhpwil1DHis+AkFz3EfmZfrJ4AYv/swY
         b06N3V/KI2VIEpXAG5yJBFZU4Mua6xpRgQzXaem8DImdc6Yxsr+YVRCB0rdlLOvVVX68
         h6lVxZHvuaeLradE3YiVYepeP/jaiCRqO+cE9qIXTgb3+i9sEytH5p3zRHFS0NSqGrfQ
         U89jkVIzb0SclOKUvKIqTx3Zyk0vZw9/WVcn+f1iRhNrDxCmmy4tupRnD8jYY3T/c4PF
         EiLq4ppLrJ1UHn9h/HBRQ00dzaByH10J9bmsBl/AJiCuTUI+xLqQE9Wlbvrp2feANYvo
         88KQ==
X-Gm-Message-State: APjAAAVstuOrDfUGt5Fyos7RXNFBP+BQ93LvRzfyXyhZ1+z/hWHDBtbS
        kaUK1AyGzz2Ot1bOPOEj7jDxN6D83fKfQhRjtc8=
X-Google-Smtp-Source: APXvYqy8SM8Y+cR4BrF+oboBLfO9xNOTU4QgWP76WoRWA5nmy26BCRXzTEgIWDK02oI7osEZsjrKqq2/XWN0/Rs4LNQ=
X-Received: by 2002:a05:6402:1742:: with SMTP id v2mr16594732edx.171.1578908534048;
 Mon, 13 Jan 2020 01:42:14 -0800 (PST)
MIME-Version: 1.0
References: <20191230143028.27313-1-alobakin@dlink.ru> <20191230143028.27313-6-alobakin@dlink.ru>
 <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com> <ed0ad0246c95a9ee87352d8ddbf0d4a1@dlink.ru>
In-Reply-To: <ed0ad0246c95a9ee87352d8ddbf0d4a1@dlink.ru>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 13 Jan 2020 11:42:03 +0200
Message-ID: <CA+h21hoSoZT+ieaOu8N=MCSqkzey0L6HeoXSyLtHjZztT0S9ug@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 05/19] net: dsa: tag_ar9331: add GRO callbacks
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

On Mon, 13 Jan 2020 at 11:22, Alexander Lobakin <alobakin@dlink.ru> wrote:
>
> CPU ports can't be bridged anyway
>
> Regards,
> =E1=9A=B7 =E1=9B=96 =E1=9A=A2 =E1=9A=A6 =E1=9A=A0 =E1=9A=B1

The fact that CPU ports can't be bridged is already not ideal.
One can have a DSA switch with cascaded switches on each port, so it
acts like N DSA masters (not as DSA links, since the taggers are
incompatible), with each switch forming its own tree. It is desirable
that the ports of the DSA switch on top are bridged, so that
forwarding between cascaded switches does not pass through the CPU.

-Vladimir
