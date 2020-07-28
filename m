Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7091F230B4A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgG1NTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 09:19:19 -0400
Received: from mout.web.de ([212.227.15.14]:37367 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbgG1NTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 09:19:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1595942344;
        bh=sLoKCnMzfBiSUCaJhj35rQFYoxHqASg6l9Wq5VY0tHo=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=mwR8YHY9XIWKMLwMIo4UQ2pDGS/4WfezIj4BDIJeNeJWTGWrOv7aFuz2Bt5j/HLUL
         lx3IU6Bb6/Z2KwhAN5BqfJhzjIgAtd339Xq8fXs2AWF/GO72Tel0jriqij22oFuz2K
         hjnFHwSpF0bTt14SuH+FB4/q9K1aQs6wo0O9FYHA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.153.150]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M25Bz-1kuRlr0kjj-00txTA; Tue, 28
 Jul 2020 15:19:04 +0200
To:     Rustam Kovhaev <rkovhaev@gmail.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+67b2bd0e34f952d0321e@syzkaller.appspotmail.com
Subject: Re: [PATCH] usb: hso: check for return value in
 hso_serial_common_create()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a42328b6-6d45-577f-f605-337b91c19f1a@web.de>
Date:   Tue, 28 Jul 2020 15:19:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YItiF5LwwrvSAlzShuxa2AngDcJMhs6LK6WCv59i3SZFFkUjOl+
 mwql597uc29YtnRAEilWXhgxoIG4Vg5S48MKpiRTcZH8OOLYjeVavBS/nuib1V0qfogY9yj
 RgS3NeIICxDaQ+ZufH2d8Evl6ZhuL5icbdIX98nZ/i7pHz94SzCHn/DjcGH2z4laUijf+qs
 HuAxcbU0MpUDUc6OiOcdQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZVOJTKSFzUM=:+6wBv3u6U6bSWPtBNvaOdE
 iDsybS6Swig/u2eXgPgYPQNhWOWVQUlH3E3iW6uWFPkkiaSdKPpXxfbATZLFVLtQ7ibN74dlW
 JQ49tpvdZsTw91pVnL+WellBQgpsPQs+HYYbza1j/QgcWHtzl7bSaOptkyfdFN428Eq6eEQl8
 Y4QoB6MpFJwonUItrx6QlrkeZJSxdvr58EQllpw+Xdw6nu9vi+MLVjaVPETMtK2TWuL4PiW8O
 W1tT0e3f2hkF0Mul8Z2uKkCQI7cr2wm/g6KKT2ToSHm6oUhEKR8X8pFhlNQpQtCIOX9kv/Lcm
 Kju64K+t9VZ6qvHQBvXy/B2NJWKFldCnYFuze+4EdgB7X+0/KOZ2VEoj/TgKjJoN36dfsWoDi
 AeUdbae36Fn6FzAY157y+eGUMc8cgn5x+Zc94Vqp6dnaqhiBHDrO5UNSx5Z28fwGENrDrUVum
 h4WpX6JizXyuqlSlUFRaKyHzy77DZ+2nrc3qhFZ/En+5jmXF43WoFEFbHZhQYGC+iDW/T+Nzt
 wq0t1UpmG41KQwlh/uV3+xrptSlDBNHQICWRUol6IAnl3nBtwDltjBN3sHpGae3G3NgGk2NoF
 PF2cnQV137xAnB95jbZ5APssx9OjlrwdJLWE/PR/qgU9tECNNskPvY3hclBq9+BcXGkPWupsj
 Ca8+cIsE8NKJPlhKBDOrXrcW+Bu9UGkS0+3HDvUyHHhEZoBHYa6JtuiTduT2WJwFsf1j9T9E1
 7G0TZmortLku6ddJAnOv8x274ESxA6n0ynorWUlm1hlm8aIDqQ0VpcJhLYu3YpTXw+TaK5mSp
 12M91KGTunGlWy8hIgFO5kxD3anv2OT8sgInYAT61Z1uHp9WZaE0Jjjsqr88Jfj4NRvsdXHCY
 17G69I+oEUywT2YP1HGpDyNPFoLNHiRjJIs5PTEQ+ppUsHMMJUi01ninOw0Fg1+tbxPZkdXVF
 xrRaLfGjyclQYrd+0j2pDjDzOt89SdW5P7L56JPIFQsj29B9ZXfzgr6gObg5XOsUrmUCU4HPz
 KkQcrEZgGCoOANa5M3yubggnzwIHnIUxSdK7w6iUZgGdOieLN2oJO5yzW5IusTd6V8IRsOX8B
 4OharPW3x2gfW974tCE50Lyc/7WTQfXcHDNnOSMbIQAYInr+g8Vi6KkOMmMQtAow6Y+5351Tp
 CSXVQ0nqrj+gDjqKDp8SmJWo+6W3kANWva93itxRknCFcdLr6w6laLlj4mLzVJUdZJixT+xR+
 1lFCYh2f5TBRCYUTHZBYEBPZiZy25ulBGdjdPRQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> in case of an error tty_register_device_attr() returns ERR_PTR(),
> add IS_ERR() check

I suggest to improve this change description a bit.

Will the tag =E2=80=9CFixes=E2=80=9D become helpful for the commit message=
?


=E2=80=A6
> +++ b/drivers/net/usb/hso.c
=E2=80=A6
> @@ -2311,6 +2313,7 @@  static int hso_serial_common_create(struct hso_se=
rial *serial, int num_urbs,
>  	return 0;
>  exit:
>  	hso_serial_tty_unregister(serial);
> +exit2:
>  	hso_serial_common_free(serial);
>  	return -1;
>  }

Can other labels (like =E2=80=9Cunregister_serial=E2=80=9D and =E2=80=9Cfr=
ee_serial=E2=80=9D) be preferred here?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?id=3D92ed301919932f777713b9172e525674=
157e983d#n485

Regards,
Markus
