Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9A212017B
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfLPJvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:51:01 -0500
Received: from mout.web.de ([217.72.192.78]:41887 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfLPJvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 04:51:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576489847;
        bh=FUer5ob7MCtjvag5eil5GrqlkSAE6mVJbS7PtyWTrtg=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=YpzzmwcyQWvfUEVs7QMOFzE3kha0DxoR3pPBpztI497TumZb/NzDYN1k37qbutUgE
         v6XftzneJQFfV9m4zMH3+KdxpJnubpKrTwI1EBZpHuQCd4Yw81XiVV/j8WlFvYeQRg
         EUns1F/sD64yYKsUA87W3EoYHeACMJBqsRKSnwpE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([78.48.181.202]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M5Oct-1hlvi40s4F-00zZIV; Mon, 16
 Dec 2019 10:50:47 +0100
To:     Aditya Pakki <pakki001@umn.edu>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>, Kangjie Lu <kjlu@umn.edu>
References: <20191215195900.6109-1-pakki001@umn.edu>
Subject: Re: [PATCH] orinoco: avoid assertion in case of NULL pointer
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <180574a2-ec2f-cbe0-3458-02b5228db51e@web.de>
Date:   Mon, 16 Dec 2019 10:50:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191215195900.6109-1-pakki001@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rbNb/j4I4QA2q8r1n1v2kwPohwIWMgC6x0YCyZ+Q1OFzivnZZl3
 eM+Y4Od6z/SVJzQhMKoASjbqlFCpkwDB9sTo3ndyI74CbhelRbvkzlq4evgz8FFpkBFy39K
 Y6gcZi1zv8u5QHEPyBsHHLinmeQUUyD4l79Nmlv7TSVoBYsuarJCSP4wUF/YK/YjQCO5Vi/
 jI9bD3d2tgx9dDc5PZVfw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:WqgRjg9WxEA=:UvHqcStWQbC+FCNvt30oCJ
 0aL84rc+Buz/ykndmWlDVaBh9oflYH7jJfSGs7VE0SU/Szs+TNWB1jJj+mFG25aZfK247JmNO
 4yOptYTflIp2mS/WRLyAJOmPFE1FIaU31d6TNRm7rCmKWv7o0npYY1JOC3lZlI5ljTCaRnHW1
 hqq5+q2yNlKBd7fuq+aArO+JexJzywuoxAmQbGk7CLdR+tvTTOsMP2IA4yC4PgNoIcnM8obQT
 03DP3+wv4u+y+PI02NTP8/S+jKP3h0xkhv1/jgfHFdh1SPIpUBsVtFUJTnEDsvX9NNrO3n5nz
 N/Yt+tfoHmmMPZgZyQE5xSsmEFgJsqT5nELR+70eWzylRu0scA4FlKzwX7QgQS13iFjpRjwZ6
 eebC8KaiS92ATwMQnzEgkz03cjPk+Zpg2fQ0YX/3bWHn0mtuD8DM1Fh/WSVtHr5sk/yr8K7Iq
 glycqJn7WGrFmWTPvfpuEkkKyRke3BYjp4ijkoVT0Zj7tl6r5kDi15I3qXrArUczjZoearoj0
 s2eDDXlnLURozr+fFZgTEjqrBHQGPNBsR7BsZp+fZhJfJQ8kXvHx9pu2jggS+ur/y2mUKW9Us
 S1rHfiEF/ba6LM1B74fBAhUNbxtxsMRv/34eSwnl1JeuFq9pi7klPk/tFm+tw4LAMHAH2nrAQ
 onvdN2Ex7X96Hjq6GsK+ifMPY0JbTYKVALNFekUI4/64LI49sNRd371K9UbT1h0oRXLzWWsd6
 RcFFqBlDWt4SzJ5ceAdX8b+qb6vuifA2l/Md7hcubi/aFeYLQhCWVW85ukJ/zHfAaoN81Svlb
 jBJV5B4K1ZsXiEsgT2JWrupOlsTP7T/ESOyiXvlhLNenzo0PllaycLEnI7dpeYKeARdTtas2b
 z7VVHsSDf2zJKzdIos+TLxFdbhctyZdR3oaeaO8OyPvHgUK4+58oCn/dsSs+jScKnFay6Wco5
 b0McMpqvdevrbHZ7keU5PkHQwPBTULZev5/MEtozACdA4eCiyQX+U5xRSTo0uLGfGquCovJdy
 J8+HiF2aPp6IfWrQnNlLmC4ntUKMlpt+ia7VMr407FPNuZ8Wd5nbtBrQP6i1XDz3K0djT4ZWw
 p3+B6YOBbHacaCE30/WgUN1Q20AZHlVc5pY2ZAS7hd9ahMOft4leslcJMOo3m/vu+NZDQ0sQj
 3CHh6DixUSFd3R9woM1eM947ZWEflsJ4ApbwpvnOytom9ZDNmnFnXWK01VMiLydU6+aQnvWYn
 Nv0XHVujz+lD8OlAiyubDRCb3c0aJbCon5NcKIXQH6Oo0BqXiAp874OLXf3c=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The patch replaces the BUG_ON call to error return.

Would a wording like =E2=80=9CReplace the BUG_ON() call by a return of an =
error code
after a null pointer check=E2=80=9D be nicer for this change description?

Will the tag =E2=80=9CFixes=E2=80=9D become helpful here?

Regards,
Markus
