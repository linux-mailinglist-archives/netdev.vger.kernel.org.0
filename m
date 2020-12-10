Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E41D2D4F4D
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgLJAUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgLJAUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 19:20:21 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C2CC0613CF;
        Wed,  9 Dec 2020 16:19:41 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c79so2354107pfc.2;
        Wed, 09 Dec 2020 16:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Es4gBJWVCcMkdwSCcQrKE/vAnJLC23HmAax/oGZgRwg=;
        b=diU+dX9rAiB5NxbqbWwFZbOd6lP+clJ3wPmR4y3Cu6dorIhfweocBdlxznXu9pHHHa
         Bv1bSutZxzhXvR/EqOiyOjz9bQVqjpEPG0UdG5UHvNfrdKLSVYz0LWnvKZvMn1nq3KUi
         IqyMQayumOU4jYct1DWSB50aGdHjR9uOg9AXpLZZKu8eacTfKKNKWCHlqIQA70FPuGrh
         mBPGRwzGB0mmmoZRIPzpj7KQAyHiJMFDxBSWvmB0sIaIxgNyYVdjQ6b4iSx1XN9KwmVM
         wyqAPlKjhFXwplfwyby+slFFMWqJWRCK7qunGWMXHxy8R9JXFOHEiWu32OYDawSe3QBx
         n0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Es4gBJWVCcMkdwSCcQrKE/vAnJLC23HmAax/oGZgRwg=;
        b=IEibQb3N8chxiTVaXOfHkpWI8duhVbfLkHgFgjEZ42PowXM2HPVnZjFUge3chtENdw
         p3JqXkcIENWgX0Y39FyVYabifx6MCJQF1Uux9IyIVgahYaM7bkiGeJhZ1fviFGf2PtIN
         WRTRHPnCZ+XZxY8iz5RVUts80mwHxEXWaUJ0dX1Chf2/Bl74mJuYZ42bqFuEEo+0mtdp
         RSKR/HvXnhF67jirN+nAhuGlsNuXoVaX8opL73YsAqrWMRC/kK8Zv1vcjivQIaK7zkwo
         OCLKRjDvIWEalfFoyA9wxk5K2vgLlPCI3ySQBx8YOKcPH85hXq3FCZu9vad6yOBnYcuR
         d8oA==
X-Gm-Message-State: AOAM533RNmt8gK9kOGKvAtd7bFSZXtLsEnv4rHKu0Bl9vj9Snac6kaRe
        /tg1f0af+9HQL1MIGWCYmUM=
X-Google-Smtp-Source: ABdhPJyWj0y3IrCO4/cTvoXDwqW+C4q9tMq3qsu1dAvLZvMYWzE+zbk4G+8+YPLpb216J+gh3qjE4w==
X-Received: by 2002:a63:ce0c:: with SMTP id y12mr4260402pgf.208.1607559580676;
        Wed, 09 Dec 2020 16:19:40 -0800 (PST)
Received: from zen.local ([71.212.189.78])
        by smtp.gmail.com with ESMTPSA id 10sm3320880pjt.35.2020.12.09.16.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 16:19:39 -0800 (PST)
From:   Trent Piepho <tpiepho@gmail.com>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Joseph Hwang <josephsih@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Bluetooth: btusb: define HCI packet sizes of USB Alts
Date:   Wed, 09 Dec 2020 16:19:39 -0800
Message-ID: <5703442.lOV4Wx5bFT@zen.local>
In-Reply-To: <20201209011336.4qdnnehnz3kdlqid@pali>
References: <20200910060403.144524-1-josephsih@chromium.org> <9810329.nUPlyArG6x@zen.local> <20201209011336.4qdnnehnz3kdlqid@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, December 8, 2020 5:13:36 PM PST Pali Roh=E1r wrote:
> On Tuesday 08 December 2020 15:04:29 Trent Piepho wrote:
> > Does this also give userspace a clear point at which to determine MTU=20
setting,=20
> > _before_ data is sent over SCO connection?  It will not work if sco_mtu=
=20
is not=20
> > valid until after userspace sends data to SCO connection with incorrect=
=20
mtu.
>=20
> IIRC connection is established after sync connection (SCO) complete
> event. And sending data is possible after connection is established. So
> based on these facts I think that userspace can determinate MTU settings
> prior sending data over SCO socket.
>=20
> Anyway, to whole MTU issue for SCO there is a nice workaround which
> worked fine with more tested USB adapters and headsets. As SCO socket is
> synchronous and most bluetooth headsets have own clocks, you can
> synchronize sending packets to headsets based on time events when you
> received packets from other side and also send packets of same size as
> you received. I.e. for every received packet send own packet of the same
> size.

As I understand it, the RX side from the headset is not guaranteed, so in=20
the TX only case this will not work and we still need to be told what MTU=20
kernel has selected for the SCO link.

It seems also it would add some latency to start up, since it would be=20
necessary to wait for packets to arrive before knowing what size packet to=
=20
send.

Would timing based on matching TX to RX in the case of packet loss on RX=20
side?




