Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C552B1C8353
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 09:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgEGHSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 03:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbgEGHSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 03:18:49 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF62C061A10
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 00:18:47 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id r26so5502623wmh.0
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 00:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=/83oAbY9HuET575P1iiSrUMJVpsBpJcdwnH0NxV4nfA=;
        b=SfhvcyKq+aOvm3nL0nAMhXO39Kpoq1JJfQca4QVwn6RXkijOlea7kaecoOWrGMYBJ3
         X5kSSvyuz55P+HRFC7u5RXgUK4XqG6/NAunJ70CW0XWr4p6ZPYn66RR025yK88VEpOZJ
         f02xfE8+aTmUaVMqG5zOBORw5k+VLZv7Z7UFydx01udxW/dHsmCTSHt1yqQujXLrzs7o
         PwH7aDbtLKtXojNm37TWqNHFO/W7/so5fVyXPtaGRnXnE/OlWAM/m05+nl1nKxpmKj35
         6nG8N1mffXZiwefnxQFnJTEznfCi3yK/bLJFLB3ce0kcKbET8z/eOcmAdEBe1buB41MM
         VDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :thread-index:content-language;
        bh=/83oAbY9HuET575P1iiSrUMJVpsBpJcdwnH0NxV4nfA=;
        b=B55DQIOnk1CP/2GWILtdak5LPPgZ8VHHdHxi4aFhSblCp3OZ9so0FPTbTyw1QPUixD
         31VkqH34MPZzlJe3YkqwToW05iO8lOj9/dNeAxT7eAsCPHfrhlV7+06i78B423EzRubX
         No0Iap0sywRzX52SY5BML9uyEVWzxwZ7CkxucNhG44ILmvWsbCAXaFEVNf1QXYe9MBV0
         4RDH3LkuXWevHoODRnwdiYcnlcSngKqQAfwLWbDPfmkmNmBW9MY49HmX+aTalVVtM69G
         NrnTykywrTP9lkTNZPSYp02zNxbgQjrOZvGIkwMZ6dC6i50+8keHbG9FKYQxuwNSXG33
         tz9w==
X-Gm-Message-State: AGi0PuY53TXsGPXXwdYFRDUiliIJOBP/v4XnK7Zwy+q8IgxzmXu7k0Ip
        rxUfdF7QelWJLhZ+RkCiLJE=
X-Google-Smtp-Source: APiQypJGp+Dkh7Uu7E7S2A0UM29cbvbjhb0zPwz1y7c8gzfAH63mCWl3HA5L+ejlFVYxoQXb5BtJxw==
X-Received: by 2002:a1c:44b:: with SMTP id 72mr8579112wme.58.1588835926327;
        Thu, 07 May 2020 00:18:46 -0700 (PDT)
Received: from CBGR90WXYV0 ([54.239.6.185])
        by smtp.gmail.com with ESMTPSA id l6sm6784317wrb.75.2020.05.07.00.18.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 May 2020 00:18:45 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>
Cc:     <netdev@vger.kernel.org>, <jgross@suse.com>, <wei.liu@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <1588581474-18345-1-git-send-email-kda@linux-powerpc.org> <1588581474-18345-2-git-send-email-kda@linux-powerpc.org> <004201d622e8$2fff5cf0$8ffe16d0$@xen.org> <CAOJe8K3sByKRgecjYBnm35_Kijaqu0TTruQwvddEu1tkF-TEVg@mail.gmail.com> <005a01d622fa$25745e40$705d1ac0$@xen.org> <CAOJe8K3ieApcY_VmEx1fm4=vgKgWOs3__WSr4m+F8kkAAKX_uQ@mail.gmail.com>
In-Reply-To: <CAOJe8K3ieApcY_VmEx1fm4=vgKgWOs3__WSr4m+F8kkAAKX_uQ@mail.gmail.com>
Subject: RE: [PATCH net-next v7 2/2] xen networking: add XDP offset adjustment to xen-netback
Date:   Thu, 7 May 2020 08:18:44 +0100
Message-ID: <00aa01d6243f$bedafad0$3c90f070$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQE3/rdtCvsSNPb5s7Kxs8cJj/qIbwLQYVL2AY7IqSUBQOo04QIlemOzALzHgDWplG3jsA==
Content-Language: en-gb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Sent: 06 May 2020 18:45
> To: paul@xen.org
> Cc: netdev@vger.kernel.org; jgross@suse.com; wei.liu@kernel.org; =
ilias.apalodimas@linaro.org
> Subject: Re: [PATCH net-next v7 2/2] xen networking: add XDP offset =
adjustment to xen-netback
>=20
> On 5/5/20, Paul Durrant <xadimgnik@gmail.com> wrote:
> >> -----Original Message-----
> >> >> @@ -417,6 +431,11 @@ static void frontend_changed(struct =
xenbus_device
> >> >> *dev,
> >> >>  		set_backend_state(be, XenbusStateConnected);
> >> >>  		break;
> >> >>
> >> >> +	case XenbusStateReconfiguring:
> >> >> +		read_xenbus_frontend_xdp(be, dev);
> >> >
> >> > Is the frontend always expected to trigger a re-configure, or =
could
> >> > feature-xdp already be enabled prior to connection?
> >>
> >> Yes, feature-xdp is set by the frontend when  xdp code is loaded.
> >>
> >
> > That's still ambiguous... what I'm getting at is whether you also =
need to
> > read the xdp state when transitioning into Connected as well as
> > Reconfiguring?
>=20
> I have to read the state only during the Reconfiguring state since
> that's where an XDP program is loaded / unloaded and then we =
transition
> from Reconfigred to Connected
>=20

Ok, but what about netback re-connection? It is possible that netback =
can be disconnected, unloaded, reloaded and re-attached to a running =
frontend. In this case XDP would be active so I still think =
read_xenbus_frontend_xdp() needs to form part of ring connection (if =
only in this case).

  Paul

