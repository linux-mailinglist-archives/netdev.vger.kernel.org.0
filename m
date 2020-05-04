Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B2E1C3C93
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 16:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgEDOM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 10:12:29 -0400
Received: from mout.web.de ([212.227.17.11]:43859 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728803AbgEDOM2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 10:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588601535;
        bh=UAsDAdzEesDdhSsGNqKHkiDxf63hFvLRdf35+NhJn64=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=afXj9uq2CXdiZOs5EVAMQB2Iw1ZGJ298HmyDgRU5Xl3bFMoXL1FcWBod/Q6qXasw2
         IYl0Tx8hDOLZ4RmH0oti3dihxlgFbjA/9DirXJSXMzSmpJTPDftLZpBPCL8u84/Goq
         exm2iSnr2YNBX6BLLbl6AMFV754cPfwSxLD1Xxjs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.152.69]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MMpCg-1joNhL1SOC-00IxGG; Mon, 04
 May 2020 16:12:15 +0200
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH] net: enetc: fix an issue about leak system resources
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Dejin Zheng <zhengdejin5@gmail.com>, netdev@vger.kernel.org
Message-ID: <9de14fae-458f-adb7-a5e7-5beb05d8d9ea@web.de>
Date:   Mon, 4 May 2020 16:12:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rl3DVGTzFlHf+dEb536eUHxAAiO3NGO8mSyhRmD3WgOx91M+zVn
 I6p4nUs9dVK+meGWXzIFCp4ADheAVN6Q+525jVfksIVZfKLxD41FvgFpUJK9cm616TjW6uv
 Rupeq0zA2Up3AzfFJwFJbcvRWLldJMjhwSVSwY/UzmRzFo7UIxioPpv8LWcfLCyr3SNWWjq
 fovb35JbZpEp+pP4ZCsTw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KeONVTIGYXs=:nV2XLIAWlmy40BSi1wZW87
 DGbk5lA//It4624X2p4KEFyELzaCq1VL1xYgILgiwI94YpB58rhlKHJarbq3ypI5NeI+Bi1Ka
 qJSnBPeQXBMLHNc5Q1PtfvBY4gn7z5oum2wpAFU0nkDdgm+HlJn6ngg/VW6LWFaEh9tffL5PY
 3B9GhTtnBZSVR35jlbR/xUrY96iHpbOo8QfUVoYGbMM+A8eUqj5PAGv7SEzX2f6To+VZEumUi
 4zkoRI6nWodpJj+ukaLZKkFLg/dhXO1Wsc0I05wPOpyPk9ndhwN1ouOPH98IeV4SvU0GekldG
 0eJQFcXf+3/CZx7P5vbqoTZf/3NxWBPsJuTgZzCsYMw5XpiC7XQS2nb4ChLb94glCy/hw62TU
 dzMTm3F0JjB0MKR1X8KxnKt71h8ioNt9OZFIUB+ZsFzMI0gOBAX1Eaxfs54kn582kncndmUyE
 Uw442fkiVD7ddTVTYoDUwR0Y9xFbptcm5hTldyaWx4WcinBSrX70qcvLbzxviIWXFzMPuF3ez
 qb9t5za7kDTAtd3bvZQQq0SBeGieE6v4wQ5Qk3cXaa3mljL20x747W0f+IqNSejMxZ7aQu4cw
 JSrUt1VB5rvVramN30mNd1/8/gyYEjqwxd/NBcIIp8fXJrGtfby4VHLC6fsddItGnkCXVLX8r
 lN74bWCYirgcjXXon1uCgvEy+lSj60VAxT6mbzd2d1vHYU47xWS/pnKE6WYcdQ4kyTjRvkIWt
 Ynx1oiDFtqK0XkBR9v03jz6y1aGGzcGmz9Sxx2P9CgNNAnyC828l0ELz5GhI+vExRFRyt3BAX
 AwCQg8WeJY/mUtP4h07Wl26Uz85fAAX2JCKr7c+rZUzHYHHUjiGXwDAhULCS6kDfJhO1Qdbqm
 NOgCudYmdY8fmkvNea9kNlGanmDp7p59LVPrItIkW6R42wbc6Gy3FXqWypfhi0ogVxZcwcNWX
 YLxm/V6fMf6TWrghPMcOePXX2d9T5FmANYuBE58aUloU/UYUyMiL/pVTRPsUODg59qfk+96H8
 0qa9w7sMYialpdjZgI4sqwFADgt2FkFd2MLCobLZIjljxXrTuXBEOrLQRmZ7eJRpDfPTnsNUO
 5AZHfYVUJ1dBAHZJ05uSi14k+4AoYtvv0bQ9YOMwc/rGF9O9bu8ej3L2FOFseOO9gleTBWY6U
 5X+yZhAnQzYiWjy9dHrbFR6hxrTqg6/Qn3TreblhEX4dM/LP7d7w/VEMiDIm5E6GB900K/jY0
 w+9X39Zt9PUIWzer+
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> the related system resources were not released when enetc_hw_alloc()
> return error in the enetc_pci_mdio_probe(), add iounmap() for error
> handling label "err_hw_alloc" to fix it.

How do you think about a wording variant like the following?

   Subject:
   [PATCH v2] net: enetc: Complete exception handling in enetc_pci_mdio_pr=
obe()

   Change description:
   A call of the function =E2=80=9Cenetc_hw_alloc=E2=80=9D can fail here.
   The corresponding system resources were not released then.
   Thus move a call of the function =E2=80=9Ciounmap=E2=80=9D behind
   the label =E2=80=9Cerr_hw_alloc=E2=80=9D.


Would you like to reduce the labels for this function implementation inste=
ad?

Regards,
Markus
