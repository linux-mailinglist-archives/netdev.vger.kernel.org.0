Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCB72AF953
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgKKTz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKTz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 14:55:28 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89549C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 11:55:28 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id q5so2279200pfk.6
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 11:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2D4UopeoGsADyGSgakVUyeylQq/DbszdJ62imU5+3As=;
        b=vkEiIslpKfq1kwlB5N1raWqNwi4R9XOq9yiZLMQ00aNu3El848yUVaBKPgqUnZFzBH
         b/kT4g9RRc+kRVHR7utZqzCtzh2wEWXMpNCgmVraXDQam1Svg85lUA0j19qXL0mjk4pZ
         ls7GV3aO28tQ/7wqpeMhW8AgIEM+bH0uDxRoFBToCIloXlFMQMYL8S7rU36iYaLbtUEk
         wgojer2mhXjp+U834LeovembKoTcI5demIGv0j11+wK6ZNE06LfPr1EFP2fXnHrH94f4
         WfGuld8ysibduB+43rz2j7lww8BwYeXWuMIyCeeA/wY1huuYJnOW5PeJe2QOMtxy3Sx1
         mdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2D4UopeoGsADyGSgakVUyeylQq/DbszdJ62imU5+3As=;
        b=kRrjZAEY3GUw5C0z1bRnKLFUGR8jLEL8HFX2uB2qiWTbULJv4B4uTEMIPzM/xj52+N
         WRMBD6B6GtScYcQFJQCqVGBqPoyw/1UdzYLhbbc9Hp6I5aQB2PrncEfnZs4co0D1PDGq
         NZk6LsprJ6i4UBis6/0L8lALK5T5BoggzVzii7hjF9VC+Nm9pATvvPbiDli05CD9kJ1p
         Z6hoxC6AYMD1I+W6RL3v4cNARqRHL4MDWnqlY8GlSvF5FrAiXZDlf7MyLtcBDztIzBC7
         7J/ZiVomSyzN3swHKPovifepg0iUAigR29+GdN/dGnTYCJXMQe1ibobT2jiQvrjvnQYl
         b3Gg==
X-Gm-Message-State: AOAM532jE4/n8YkJhVrCRUeOpX2Wa/YKy53fJoVK4bZHwpiuxUTASIP0
        ucRtmpeLQM9gh8Z485JQzGIbkw==
X-Google-Smtp-Source: ABdhPJzE7PbRtducXtTQfUAZPUp4s9NmSFEw737YFgfr1HarT/OTS897oyuNG4vVPuQta5T3oPrHFg==
X-Received: by 2002:a62:7504:0:b029:18b:8238:cc0 with SMTP id q4-20020a6275040000b029018b82380cc0mr23990635pfc.81.1605124528059;
        Wed, 11 Nov 2020 11:55:28 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q6sm3282855pfu.23.2020.11.11.11.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 11:55:27 -0800 (PST)
Date:   Wed, 11 Nov 2020 11:55:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     =?UTF-8?B?5p2c6Iux5p2w?= <leondyj@pku.edu.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: some question about "/sys/class/net/<iface>/operstate"
Message-ID: <20201111115520.08b58818@hermes.local>
In-Reply-To: <CAM_iQpVzC6PTX8b0cgXO=Pcp_jFCw-UtP__AYyoN7pZLovkqcQ@mail.gmail.com>
References: <1a87f1b4.3d6ab.175b592a271.Coremail.leondyj@pku.edu.cn>
        <CAM_iQpVzC6PTX8b0cgXO=Pcp_jFCw-UtP__AYyoN7pZLovkqcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 11:02:14 -0800
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> On Tue, Nov 10, 2020 at 8:32 PM =E6=9D=9C=E8=8B=B1=E6=9D=B0 <leondyj@pku.=
edu.cn> wrote:
> >
> > I want to use inotify to monitor /sys/class/net//operstate  to detect s=
tatus of a iface in real time.
> > when I ifdown &amp;&amp; ifup eth3, the content of operstate changed, b=
ut the file's Modify time didn't change.
> > I don't know the reason, is there any file which can be monitored by in=
otify to get iface status in real time?
> > Much appreciation for any advice! =20
>=20
> You need to listen to netdev netlink messages for changes like
> this. These messages are generated in real-time.

The /sys and /proc are pseudo-filesystems. The file modify time and inotify=
 do not work
as expected on these files. Cong is right you need to use netlink for this.
