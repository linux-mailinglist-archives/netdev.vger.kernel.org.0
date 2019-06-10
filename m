Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D033BF1D
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389742AbfFJWGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:06:13 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33612 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387661AbfFJWGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:06:13 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so6424346qkc.0
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2+stKTiDwz+DUxdbGlTX2YZ80vsUADihdEwOnDlBg/8=;
        b=b7pbfgnYd2Kymk5/jif65XmZT9jJWKzh+Uz9mmg7kv+n3ITh2h97vR8MyKVOn6yPrG
         HrujUNd9WPA4/pBY8Z8e6PjnTbBFGAKnlSF+wGx90mkiWaZYqBhhtXfbqUyQ0oLsUSc6
         j48Ut1datbuH0mT5jquoBgtfOfly96j0EJF4/RtcWiVrw6KCH47tSHrGNLBWk5CU0M0c
         nHIGuCfUSDgv2HZb0leCwi76uJOCBjtITB+mc9U/tDKpoTDyxR/grWPWskKLW6Tg1OX4
         F8RESHb+LZEpzuP3qcMF/VnTci2TENJv3zNYK1Mk8BypTRdMp64sOMefENBAsN65Qz6J
         helA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2+stKTiDwz+DUxdbGlTX2YZ80vsUADihdEwOnDlBg/8=;
        b=AdXbxrp5WNAUhBw7rL+2nRuYGdrhReAJY73ziOJHjbIQTt5SWr+MSRxE+yUFRIz3Kp
         BEpJfck0L1XJwBwjhCID7p0cvzj1GsBdxZ9PIjvq8F+PcJdr/DcpQV+U6Lw8XKMa9eVA
         QMVOy23mfpzekJcbuAwJ5UgHgkeLIrrvX3JtAF7yI5eLBb9zEUL7Lt4GUSGuPV/Ad4IZ
         GYHDK3aSrdhAGPbqFVcQ5ETm5uvNmgSN9H6PRHxXs4uoKOzUpU3WbmJWlszssXaNRQ3j
         y1CBEqcyQ/Q/8HHW7NdUGYwHj3UQpZvw7N834h2qbLMJVmjZi/FIFahxSjMXkb/xaNW4
         BpTQ==
X-Gm-Message-State: APjAAAXY05oWbqJ005p/uIvi6UKOMlzjLJTjXXTGqjb07gJq6nkb3Ofy
        4LrsTpSox1Gu3XArgt6NxnNluA==
X-Google-Smtp-Source: APXvYqzoR9hZar/Z9If1SaakOUTSTpUp0krJIqnjCKOlXojrVtJWwlgQI2Q3UcYvCEgUJYm4P98udQ==
X-Received: by 2002:a37:ac14:: with SMTP id e20mr56070139qkm.243.1560204372707;
        Mon, 10 Jun 2019 15:06:12 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a139sm5629591qkb.48.2019.06.10.15.06.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 15:06:12 -0700 (PDT)
Date:   Mon, 10 Jun 2019 15:06:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v3 3/3] devlink: implement flash status
 monitoring
Message-ID: <20190610150607.22d4f963@cakuba.netronome.com>
In-Reply-To: <e82080ee-9098-01c5-1108-294c32f53f33@gmail.com>
References: <20190604134044.2613-1-jiri@resnulli.us>
        <20190604134450.2839-3-jiri@resnulli.us>
        <08f73e0f-918b-4750-366b-47d7e5ab4422@gmail.com>
        <20190610102438.69880dcd@cakuba.netronome.com>
        <249eca9b-e62a-df02-7593-4492daf39183@gmail.com>
        <20190610104723.66e78254@cakuba.netronome.com>
        <e82080ee-9098-01c5-1108-294c32f53f33@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 15:56:00 -0600, David Ahern wrote:
> On 6/10/19 11:47 AM, Jakub Kicinski wrote:
> > It's the kernel that does this, the request_firmware() API.  It's
> > documented in both devlink's and ethtool's API.  I was initially
> > intending to use the file request API directly in devlink, but because
> > of the requirement to keep compatibility with ethtool that was a no go.
> >=20
> > FWIW you can load from any directory, just prefix the file name
> > with ../../ to get out of /lib/firmware.
> >=20
> > I guess we could add some logic into devlink user space to detect that
> > user does not know about this quirk and fix up the path for them.. =F0=
=9F=A4=94 =20
>=20
> If the user can not load a file based on an arbitrary path, what is the
> point of the option in the devlink command? You might as well just have
> the driver use the firmware interface.

This may be a question about mlxsw quirks.  Traditionally drivers don't
flash firmware on probe.  Devlink/ethtool interface is for updating
flash contents, while probe may load FW directly into SRAM for devices
which don't store firmware on flash (e.g. most WiFi cards).

Also - devlink _can_ load from arbitrary paths.  User just has to assume
getcwd() =3D=3D "/lib/firmware".  Probe has a hard coded file name it=20
will try to load.
