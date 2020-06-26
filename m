Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6A720BC41
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgFZWOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZWOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:14:20 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46984C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 15:14:20 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q198so10258851qka.2
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 15:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=59782O3sdjlqa4dnbV2WOzGQVwvvDwaWIMDHrDGgO+A=;
        b=YJGSNO1gIiujSymDqdeFe0lNYco0ItMHAUiNtoGqQrCn890nc1WMS39k5FQUN0lpov
         AIqp00BoopbN7UV+xr/Q5k3iZBF1hOP3dTyTP25/UtvjkIiPVFLVQ/wISkRLKjEtbEra
         DsdApA8/yNrXWWQS5qicRFiFpj8bWeWN6K7FxZzd4j9GjbqFY0+R/fOYOEUfrBZpG0+o
         n6zXPWph9hyQBNPuDYWyP223DfurG8/opvRIDp1gopMs7IZVBOGQa0JlkUtPAsU8HEBO
         GZEgXPBEcQuKarAELSd4R3v6GIJHgdfTJurJYTAgVZiVlH9dG2valjDSAEiwZrqtbghR
         hh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=59782O3sdjlqa4dnbV2WOzGQVwvvDwaWIMDHrDGgO+A=;
        b=Z/QNWtRN+wPq0TrJJ9+iRRzPhj9J90DdPcLHLQsnuM6rDPgJdHQGCtPSJF0S8eJvDE
         ZvMVLSPe+9rjp8OqWEUusvNLqme82AViDpD62+zmBHYsY+m9jvWTBle40zNr99njzhB6
         9E9ORTq4Wo/lHs8u/HJDodl1lqTIo+W14EDonSn0h/M5C0BV0eZdBUrRfb/N6SIWkAXr
         GWI+Uw3gk2B6meBtJ+Yc1RV4A86uPoKkfMyRi20sRFq0bqgycNRtIb4A5VDCBCp4aUAR
         DcFSXYVfmmNUffPGwqJiMRXMotXyt05nTbQt0BZuSQdCkT8uBQA22V5buAxx1kMziPvG
         9bYQ==
X-Gm-Message-State: AOAM533j1kB5WaXFcKg91CpkbCLMEIfuFdB/g2ipqAwRruWHfTTo/EXq
        Yz0/A79s+1Rbt34uywR709SuTjNyx0UBaJkaVsw=
X-Google-Smtp-Source: ABdhPJyZnj4FoLB116lJK93IO6+q7+mSk4OI7BSWotCRbH3oEfY0n60/SuHaiUdkFjygCAMiJURnSPOKndNV5hLf02w=
X-Received: by 2002:a37:4d85:: with SMTP id a127mr4864957qkb.338.1593209659471;
 Fri, 26 Jun 2020 15:14:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200626144724.224372-1-idosch@idosch.org> <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch> <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
 <20200626190716.GG535869@lunn.ch>
In-Reply-To: <20200626190716.GG535869@lunn.ch>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Fri, 26 Jun 2020 23:13:42 +0100
Message-ID: <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for QSFP-DD transceivers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You are saying pages 00h, 01h and 02h are mandatory for QSPF-DD.  Page
> 03h is optional, but when present, it seems to contain what is page
> 02h above. Since the QSPF KAPI has it, QSPF-DD KAPI should also have
> it. So i would suggest that pages 10h and 11h come after that.
>
> If a driver wants to pass a subset, it can, but it must always trim
> from the right, it cannot remove pages from the middle.
>
>      Andrew

I agree with this. Basically there are two big cases:
- passive copper transceivers with flat memory => just 00h will be
present (both lower and higher => 256 bytes)
- optical transceivers with paged memory => 00h, 01h, 02h, 10h, 11h => 768 bytes
Having page 03h after 02h (so 896 bytes in total) seems like a good
idea and the updates I'll have to do to my old patch are minor
(updating the offset value of page 10h and 11h). When I tested my
patch, I did it with both passive copper transceivers and optical
transceivers and there weren't any issues.

In this patch, Ido added a comment in the code stating "Upper pages
10h and 11h are currently not supported by the driver.". This won't
actually be a problem! In CMIS Rev. 4, Table 8-12 Byte 85 (55h), we
learn that if the value of that byte is 01h or 02h, we have a SMF or
MMF interface (both optical). In the qsfp_dd_show_sig_optical_pwr
function (in my patch) there is this bit:

+ __u8 module_type = id[QSFP_DD_MODULE_TYPE_OFFSET];
[...]
+ /**
+ * The thresholds and the high/low alarms/warnings are available
+ * only if an optical interface (MMF/SMF) is present (if this is
+ * the case, it means that 5 pages are available).
+ */
+ if (module_type != QSFP_DD_MT_MMF &&
+    module_type != QSFP_DD_MT_SMF &&
+    eeprom_len != QSFP_DD_EEPROM_5PAG)
+ return;

But Ido sets the eeprom_len to be ETH_MODULE_SFF_8472_LEN which is
512, while QSFP_DD_EEPROM_5PAG is defined as 80h * 6 = 768. So there
won't be any issues of accessing non-existent values, since I return
from the function that deals with the pages 10h and 11h early. When
the driver will support them too everything will just work so your
idea of a driver being able to pass only a subset of pages (being
allowed to trim only from the right) holds.

Adrian
