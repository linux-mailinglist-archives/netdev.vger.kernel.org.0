Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F8221CC12
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgGLXPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728617AbgGLXPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 19:15:50 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084B7C061794;
        Sun, 12 Jul 2020 16:15:50 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a8so10421369edy.1;
        Sun, 12 Jul 2020 16:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ufXlWsSbQjgi4oIUlNgGwOevOPgtDjD5Z0wxS+QyBqs=;
        b=gIyFzsDcvDoFbqmY8MNNEoFc4zyHlEt7W5KBJnNGbEY2rsjYLkCDxC0V3W4XvwZERd
         ZJY/uzU1K1rSDmaruC0TtCzCFLIoGe6QwaIHlz+WN/Mj+0LqUV45+qKeJDrs4dnlKDxU
         QNp5FxpR3+7DZ+N6Xf4qWyMlnvucUwb3wfhfl18HoEJZPH9NtALg7de5Lshv2fM/5+2R
         cDXX0LqNxXJJhM6LpUiVFvA1kZKY35tAtgWJZsQ1mddy4qDlkxQ23H7QANaNyyhbo8Lx
         K046lwZUKIlkDlJA0gSjfLy90ECJWxCqJ5BpqtwWxGHq8Qad7DXuN7MydTKhTjbhSuQJ
         xzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ufXlWsSbQjgi4oIUlNgGwOevOPgtDjD5Z0wxS+QyBqs=;
        b=ljET0AV6Owr756/zidz51/J7hT9DNI6ZgSmhp1ADZp4eP5ltAF+ehD6+2F4GrKrzUR
         QymROaKFj2C5IQk6G6vZHdssXfqpubHZqCBVs1EAHtMJA9EpjRaHjFX8J4i+Al8NBPjj
         QFrZq8eYCcd+FBJ2O63mlL/KbVCtBAFBk81MOS7rb0Lk83c/z5jkJuoSGGKPV4n6EVEl
         7+v077siAeNUrgxYYrcAXvdfP6LLpsf3n/uUxgJUhD/G9lZn+PogEdK3x3y7vQaC31JT
         r+dlFk7KXS4kM2PTf8Plrv1zkyVLi5hrFcHJhB9zNXZz23MytH1NtxyEIWAKv0htjFVi
         SOoA==
X-Gm-Message-State: AOAM532k2Px7KJO65WG5dLdNqlLpwavLj8JHA10RJmfA6I8mzU3deBo9
        4Hys06QDdrQ5zT02pvOkf2qG42sx
X-Google-Smtp-Source: ABdhPJzYsShQzcoTdZHEXG8NR5IOJV9+SW4PEDBQTFQt/rFG6kH4qrNhToHHe92JRfJbCJMhOryToA==
X-Received: by 2002:a50:f149:: with SMTP id z9mr90011386edl.167.1594595748632;
        Sun, 12 Jul 2020 16:15:48 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id o17sm8502946ejb.105.2020.07.12.16.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 16:15:48 -0700 (PDT)
Date:   Mon, 13 Jul 2020 02:15:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
Message-ID: <20200712231546.4k6qyaiq2cgok3ep@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200711120842.2631-1-sorganov@gmail.com>
 <20200711231937.wu2zrm5spn7a6u2o@skbuf>
 <87wo387r8n.fsf@osv.gnss.ru>
 <20200712150151.55jttxaf4emgqcpc@skbuf>
 <87r1tg7ib9.fsf@osv.gnss.ru>
 <20200712193344.bgd5vpftaikwcptq@skbuf>
 <87365wgyae.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87365wgyae.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 01:32:09AM +0300, Sergey Organov wrote:
> >
> > If you run "ethtool -T eth0" on a FEC network interface, it will always
> > report its own PHC, and never the PHC of a PHY. So, you cannot claim
> > that you are fixing PHY timestamping, since PHY timestamping is not
> > advertised. That's not what a bug fix is, at least not around here, with
> > its associated backporting efforts.
>
> You can't actually try it as you don't have the hardware, right? As for
> me, rather than running exactly ethtool, I do corresponding ioctl() in
> my program, and the kernel does report features of my external PTP PHY,
> not of internal one of the FEC, without my patches!
>
> > The only way you could have claimed that this was fixing PHY
> > timestamping was if "ethtool -T eth0" was reporting a PHY PHC, however
> > timestamps were not coming from the PHY.
>
> That's /exactly/ the case! Moreover, my original work is on 4.9.146
> kernel, so ethtool works correctly at least since then. Here is quote from
> my original question that I already gave reference to:
>
> <quote>
> Almost everything works fine out of the box, except hardware
> timestamping. The problems are that I apparently get timestamps from fec
> built-in PTP instead of external PHY, and that
>
>   ioctl(fd, SIOCSHWTSTAMP, &ifr)
>
> ends up being executed by fec1 built-in PTP code instead of being
> forwarded to the external PHY, and that this happens despite the call to
>
>    info.cmd = ETHTOOL_GET_TS_INFO;
>    ioctl(fd, SIOCETHTOOL, &ifr);
>
> returning phc_index = 1 that corresponds to external PHY, and reports
> features of the external PHY, leading to major inconsistency as seen
> from user-space.
> </quote>
>
> You see? This is exactly the case where I could claim fixing PHY time
> stamping even according to your own expertise!
>
> > From the perspective of the mainline kernel, that can never happen.
>
> Yet in happened to me, and in some way because of the UAPI deficiencies
> I've mentioned, as ethtool has entirely separate code path, that happens
> to be correct for a long time already.
>

Yup, you are right:

int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
{
	const struct ethtool_ops *ops = dev->ethtool_ops;
	struct phy_device *phydev = dev->phydev;

	memset(info, 0, sizeof(*info));
	info->cmd = ETHTOOL_GET_TS_INFO;

	if (phy_has_tsinfo(phydev))
		return phy_ts_info(phydev, info);
	if (ops->get_ts_info)
		return ops->get_ts_info(dev, info);

	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
				SOF_TIMESTAMPING_SOFTWARE;
	info->phc_index = -1;

	return 0;
}

Very bad design choice indeed...
Given the fact that the PHY timestamping needs massaging from MAC driver
for plenty of other reasons, now of all things, ethtool just decided
it's not going to consult the MAC driver about the PHC it intends to
expose to user space, and just say "here's the PHY, deal with it". This
is a structural bug, I would say.

> > From your perspective as a developer, in your private work tree, where
> > _you_ added the necessary wiring for PHY timestamping, I fully
> > understand that this is exactly what happened _to_you_.
> > I am not saying that PHY timestamping doesn't need this issue fixed. It
> > does, and if it weren't for DSA, it would have simply been a "new
> > feature", and it would have been ok to have everything in the same
> > patch.
>
> Except that it's not a "new feature", but a bug-fix of an existing one,
> as I see it.
>

See above. It's clear that the intention of the PHY timestamping support
is for MAC drivers to opt-in, otherwise some mechanism would have been
devised such that not every single one of them would need to check for
phy_has_hwtstamp() in .ndo_do_ioctl(). That simply doesn't scale. Also,
it seems that automatically calling phy_ts_info from
__ethtool_get_ts_info is not coherent with that intention.

I need to think more about this. Anyway, if your aim is to "reduce
confusion" for others walking in your foot steps, I think this is much
worthier of your time: avoiding the inconsistent situation where the MAC
driver is obviously not ready for PHY timestamping, however not all
parts of the kernel are in agreement with that, and tell the user
something else.

Thanks,
-Vladimir
