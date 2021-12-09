Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7203746E89E
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbhLIMu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:50:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229680AbhLIMu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 07:50:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639054013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+rgwOZXwpAx5YyVASfGnt3zTU62rqVUjO/0XDdwQk1Q=;
        b=GyTosu2fKWyUaeXRkIfJpMe61coNVLE5+KI5Uw1QC+OPnUK/ZupX1xyUloJB4T7caN0GzJ
        M9JB3Au42jdBA4UKZoVXLtxSEDKkfplqN4z0uTghWqmdYjDC6QUt7xlJ72WQDnUt+dugwm
        629+UvRa2xaq78/gT/qGw7w+pJVv1CQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-FkNEo8fQO1S60-XFZcIZPw-1; Thu, 09 Dec 2021 07:46:52 -0500
X-MC-Unique: FkNEo8fQO1S60-XFZcIZPw-1
Received: by mail-wm1-f72.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so3096488wmb.3
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 04:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version;
        bh=+rgwOZXwpAx5YyVASfGnt3zTU62rqVUjO/0XDdwQk1Q=;
        b=Mx+XjDw3yZW+5gfxEKqfGgB1k9cvbagHeJuo5LfYCpkyx/njmERnZ0Cr0lBwPoW/FG
         sFpi9VoJSS7us3ubFh+tlJNaw83Vx6fYwafMtTsjDjyfD00lbqW9Ajv+gFW+CfNpFThZ
         KwfHFMIigaBG/XknVWunws3ytxF28FIEp+l4MFAGE+fKDbmjsanmlibvTYQ75KeBw3vK
         x53ybbnQ5gZZ7AiFP1EERimoIeMbdtQD/KgtBDKeLA4X0gMxlP5M20SUWoJ8DzmLM6kQ
         KCEMSj4vdQIqyaGEZ28TKWw2/DORXocT9WlTLJXIM+QN6+oOErgPya9h6q846l2r15Jb
         sUHg==
X-Gm-Message-State: AOAM531KwWZH2ifYqX3BFCBkEj4/l40tcWkx3RApvifXqnzLbfECGhef
        wBPVifhxeEyE8pbjvzLObs+HBazTvZ5wgkqylI7250V3gxMdt7krCd43FyJXc+4HHEuT+5tOHto
        9f9J/0jHIMy6SU5SX
X-Received: by 2002:adf:f6cf:: with SMTP id y15mr6060761wrp.56.1639054011192;
        Thu, 09 Dec 2021 04:46:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxcYWp6HpitNPUMAnq1oU8ygzfOdTkel9TMOiRGTFVUC9FyfEIlxxRl1jFiLHUrW8VwlvpPxQ==
X-Received: by 2002:adf:f6cf:: with SMTP id y15mr6060733wrp.56.1639054010986;
        Thu, 09 Dec 2021 04:46:50 -0800 (PST)
Received: from ?IPv6:2003:c4:372a:6fe5:a08b:eb12:3927:3670? (p200300c4372a6fe5a08beb1239273670.dip0.t-ipconnect.de. [2003:c4:372a:6fe5:a08b:eb12:3927:3670])
        by smtp.gmail.com with ESMTPSA id g19sm8880792wmg.12.2021.12.09.04.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 04:46:50 -0800 (PST)
Message-ID: <14584c1a1e449cc20b5af7918b411ee27cf1570b.camel@redhat.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 hci_cmd_sync_cancel
From:   Benjamin Berg <bberg@redhat.com>
To:     Oliver Neukum <oneukum@suse.com>,
        syzbot <syzbot+485cc00ea7cf41dfdbf1@syzkaller.appspotmail.com>,
        Thinh.Nguyen@synopsys.com, changbin.du@intel.com,
        christian.brauner@ubuntu.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, luiz.dentz@gmail.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        mathias.nyman@linux.intel.com, netdev@vger.kernel.org,
        stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com,
        yajun.deng@linux.dev
Date:   Thu, 09 Dec 2021 13:46:47 +0100
In-Reply-To: <3e8cba55-5d34-eab3-0625-687b66bb9449@suse.com>
References: <00000000000098464c05d2acf3ba@google.com>
         <3e8cba55-5d34-eab3-0625-687b66bb9449@suse.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-83lGBtdr6vrReHv5wmRv"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-83lGBtdr6vrReHv5wmRv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2021-12-09 at 11:06 +0100, Oliver Neukum wrote:
> As __cancel_work_timer can be called from hci_cmd_sync_cancel() this is
> just not
> an approach you can take. It looks like asynchronously canceling the
> scheduled work
> would result in a race, so I would for now just revert.

Right, so this needs to be pushed into a workqueue instead, I suppose.

> What issue exactly is this trying to fix or improve?

The problem is aborting long-running synchronous operations. i.e.
without this patchset, USB enumeration will hang for 10s if a USB
bluetooth device disappears during firmware loading. This is because
even though the USB device is gone and all URB submissions fail, the
operation will only be aborted after the internal timeout happens.

The device in turn disappears because an rfkill switch is blocked and
the platform removes it from the bus. Overall, this can lead to
graphical login to hang as fprintd cannot initialise as it hangs in USB
enumeration.

Benjamin

--=-83lGBtdr6vrReHv5wmRv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEED2NO4vMS33W8E4AFq6ZWhpmFY3AFAmGx+rcACgkQq6ZWhpmF
Y3CJqw/+ONFnidIqlEKcCVDa9JZe01o4i/3PKsHyINaj/XljOCQr1869ewL084xw
GYdljx03tA+05TDlwnMwaZOE8ozxAB8JInuAhg72BGcmM5HuaB0wMxej0Eyl1yRU
Es2TLCvJhjRbOtoYnbQ/sMpmuhnAh9ditH7az1UR+dBIWD4/3y7A6wqzqEE1GbJw
M29xhWuFP6WLn4InqY0PvhAnEiSxE5sWtGfl6gvm9RBtoSpdreFVu5DgYSHSodF6
FFqg1HorMZP4gBalSe4EOYZiS21pN6aNih7o09TPGmRFfVIEUDbPjODR5z8zsYQx
wLRHGSaG2O9oeMEJe0YufJyxSC1cZVMi/AzF3RNpX4N89Y4oCfA+TPx3SWqHGYyc
aaiJkcxudD9Uu7y3EMC3P0J290tLQJkKHeyGrHHwtLPvvc7gS2CidCvAwM+m5qwX
LTVXlnUX23xt/1ReFVlRBjq09kdxKNUDU4qkt7I0my1BXooCmR7qew1NqHW6c3ex
lJdVX9y91RivhMVp8udORuT1V0C7K0Mrkr03xJy0q4LTAu94FkqPCjz8O+dRURMX
jwj3uQ30jP28dwUq5QysHXN+lOrd+Fa2ksmCAIRU2WKBtNKDCXX1uyDjBZMwunvD
IBrI3O953a1bwgHr+EaBGTgoibSP3f0vmA4P/QLp4/QtX8me5Uk=
=xPCC
-----END PGP SIGNATURE-----

--=-83lGBtdr6vrReHv5wmRv--

