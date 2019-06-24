Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 219D15189E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731968AbfFXQ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:27:07 -0400
Received: from canardo.mork.no ([148.122.252.1]:56291 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfFXQ1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 12:27:07 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x5OGQpI1008347
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 24 Jun 2019 18:26:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1561393612; bh=fLGEnw2Njzn9xoqzS5V4EDKFzf98/cQHM5dM1LpBLzA=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=dKDvQAwpJjFXmlAogZehs5GN9Y0cWRugc8cEv6J7slbl2Gp91bIw92D6f8xqQPH1C
         2D1A6sM+SFV7PUESbRMLRQ8XCn1KbzQrGpeCn7dKGZ1MWCkmcPx5tg1DETysp/3GEE
         pWXw8Nq+31CbbTfMV6RbuTVO7HvammQT1NNOkUL0=
Received: from bjorn by miraculix.mork.no with local (Exim 4.89)
        (envelope-from <bjorn@mork.no>)
        id 1hfRnv-0008IY-E4; Mon, 24 Jun 2019 18:26:51 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        syzbot <syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com>,
        andreyknvl@google.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: global-out-of-bounds Read in qmi_wwan_probe
Organization: m
References: <0000000000008f19f7058c10a633@google.com>
        <871rzj6sww.fsf@miraculix.mork.no>
Date:   Mon, 24 Jun 2019 18:26:51 +0200
In-Reply-To: <871rzj6sww.fsf@miraculix.mork.no> (Hillf Danton's message of
        "Mon, 24 Jun 2019 23:38:36 +0800")
Message-ID: <87tvcf54qc.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> writes:

> and wonder if the following works.
>
> -	info =3D (void *)&id->driver_info;
> +	info =3D (void *)id->driver_info;


Doh! Right you are.  Thanks to both you and Andrey for quick and good
help.

We obviously have some bad code patterns here, since this apparently
worked for Kristian by pure luck.


Bj=C3=B8rn
