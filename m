Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F23C2684B0
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 08:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgINGTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 02:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgINGTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 02:19:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423FCC06174A;
        Sun, 13 Sep 2020 23:18:57 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o16so4919078pjr.2;
        Sun, 13 Sep 2020 23:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MYPgJwOB3wumsWdm8PpM5P24nVAroSIX0XmTHErtiN8=;
        b=m5zMQqKAG7mE5eqF77oB/b+ELIhxJkB11rPryu9vgZLGbo7a1hjoJPuvEC46eeAbUb
         TvORpGMCWlzy78ABjT1P8r37FE7fDcjlIRp3EyDUNtuk5fq/U/c5lbVDOdA3NK5Y4ucD
         65f+xAFfoO4sbKoTuikmMNgGMxj8FKtoa05l7gyBS0KQAsW8rZNwELD7uyMW930xwSxK
         BxSt1RQ2vNiQQcwlMGr2Iobk1FBirbaqaHv0GuZDKwIX23s3o0S/twXEw5hVBrPtiYAT
         +1WX+naMwoWrE14C5dLRsD/N9Grk/QAgGFYLVdND9VyqROiLmtEwI8VAzWJZKWOU0F7z
         Ts2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MYPgJwOB3wumsWdm8PpM5P24nVAroSIX0XmTHErtiN8=;
        b=Qmzyo6JXLg3JG/I3niXWVkxEfsqVyLJ1F1ODNs24vDEM2mUu6+PZzNpVe53dQ1FbGZ
         5FPEeWDN+uJ1vU3rHv0KnDgsTP6+OQ918JTpgFJW8d8tnEOM9nbauzgiuPbb3GL5o3ax
         v1oeIU8aqOYkJhfHm0BZW6M2lcI4zjfWlIl6hMK0AjweHapn1O29edexo7OHYiMT8eIy
         Qmk7cRxGtRDcMZPCv9u7iwUdbRRVeLGHp3VdpL9cYU5fsbu6tbjwysTzL44vdW+zbFSl
         K2sVuaWsOsN+j3MsaEuUVQxvDzWhLKamwu+l26NguCXeFx2mB/6K7YOdDKcXz6tk1Xyf
         V+hg==
X-Gm-Message-State: AOAM533KL5atjmgZiPpCE617PLQ7XXB6tLNUXO8aeIuOJL9CeSaxCMvL
        kYO5hdfp67cTJOBDBuFshdHQA2C5X1nzf1Bf6lKjhoPk
X-Google-Smtp-Source: ABdhPJyEN20m5tXqOxy4gIhmp00NE75m2DyLIIl8otL6PZ8wLltOCahP2WCtfHH9VdmpvmESJEu6iu48pwOkmLq1X8I=
X-Received: by 2002:a17:90b:816:: with SMTP id bk22mr12784047pjb.66.1600064336828;
 Sun, 13 Sep 2020 23:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200903000658.89944-1-xie.he.0141@gmail.com> <20200904151441.27c97d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EN+=WTuduvm43_Lq=XWL78AcF5q6Zoyg8S5fao_udL=+Q@mail.gmail.com> <m3v9ghgc97.fsf@t19.piap.pl>
In-Reply-To: <m3v9ghgc97.fsf@t19.piap.pl>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 13 Sep 2020 23:18:46 -0700
Message-ID: <CAJht_ENMtrJouSazq3yL7JUS+Hwv4mjtxrcpqxOrc+6vMUVM=w@mail.gmail.com>
Subject: Re: [PATCH net v2] drivers/net/wan/hdlc_fr: Add needed_headroom for
 PVC devices
To:     =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc:     Jakub Kicinski <kuba@kernel.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 10:26 PM Krzysztof Ha=C5=82asa <khalasa@piap.pl> wr=
ote:
>
> Xie He <xie.he.0141@gmail.com> writes:
>
> > The HDLC device is not actually prepending any header when it is used
> > with this driver. When the PVC device has prepended its header and
> > handed over the skb to the HDLC device, the HDLC device just hands it
> > over to the hardware driver for transmission without prepending any
> > header.
>
> That's correct. IIRC:
> - Cisco and PPP modes add 4 bytes
> - Frame Relay adds 4 (specific protocols - mostly IPv4) or 10 (general
>   case) bytes. There is that pvcX->hdlcX transition which adds nothing
>   (the header is already in place when the packet leaves pvcX device).
> - Raw mode adds nothing (IPv4 only, though it could be modified for
>   both IPv4/v6 easily)
> - Ethernet (hdlc_raw_eth.c) adds normal Ethernet header.

Thank you for the nice summary!

I just realized that we can indeed support both IPv4/v6 in hdlc_raw.
Both IPv4 and v6 packets have a version field in the header, so we can
use it to distinguish v4 and v6 packets on receiving. We can introduce
it as a new feature some time.
