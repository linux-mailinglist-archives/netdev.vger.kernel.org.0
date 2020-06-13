Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3401F812E
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 07:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgFMF4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 01:56:53 -0400
Received: from mout.web.de ([212.227.15.3]:48967 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgFMF4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 01:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592027800;
        bh=cnJY+YCzTwmy3G4rlwIaVZSJC4XAT22QprxS3qAWiNU=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=rv3jjGxVYpJsFMM8+2Db8IqjzhKaFPIIAcqQ6ulhgev71RXGH+tlcX6fh39BvT7vS
         ywypyw7hE6nd1DXVniazHX1y5Hgtf7aWlnUg8H2wcfZvsRBe7zvQFFXA48rRqzfenX
         Q344uX5VUT2o7pqWhXW3zBaRjtw/PaasXeHh6TuE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.51.155]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mm9VU-1j25hQ1V8y-00iFqP; Sat, 13
 Jun 2020 07:56:40 +0200
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kangjie Lu <kjlu@umn.edu>,
        Qiushi Wu <wu000273@umn.edu>
Subject: Re: [PATCH] NFC: Fix error handling in rawsock_connect()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org
Message-ID: <77ad4473-2c8a-f25a-51a8-be905d1414cd@web.de>
Date:   Sat, 13 Jun 2020 07:56:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xHL6e45gpvPR3VjyPn5mu3Exfp4t2XwhtK9fDfrQus65PhVngH4
 qjGkvYXKJg/rGbIP12qS2K8WdmhEzu1vbO5OOGywG6XXowIjzUJ0tiDeGdkbnpuUHc//o1a
 6cOaaTj502FtfnMe3sCLnBrPFC4w8rOvV3y5cXgaxqcKWbYKiWj8MvSzf86P045DJY9wbdL
 QL2TEmmQ+xenHvMZR/7Rg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FVhYn1S4/o4=:TcO9+NaFRTES+YOJHVslCk
 k6nxVVSi1kbkA6oMBQkZcQziqBRu3KSxnVIHfFhuvHfFwZM4lsCHx6WZ9o7AErC5zvxp2MrBf
 0ZxmCpWGzgQ64JxOPn7RyPKadqznH5krs0lvDqCupzhQgwBm53/GqS6rWGLQwXzkzLJk9g2Jv
 4eS+uwlum1J+mvYAfSy7LmGF/1l7QB0GstpnDc7pYQ8qxGdHIXJf9sb0h5ZutMBj17PVx5dF7
 GsADBGsXboBIdQeuM9qLejUE4wHKMuTYsxIR5DsmZraTxxvIPuhQKK0IWFd16Je/9zNeXTkNC
 Zer9DrISz8jCQdCQYWadxnF/r1cf7O9K58K8v9E0dKnzwWwTq0atGpQosjXbRNvSuYc5UeqdU
 RRba0jwXzjhfUO3kurKAWt3f8wTNqIp5rr4HSzFhBiKZlHyfHBiavq/CuKpd0TuYQZpQaKHGi
 3bg9jE15RtsS0xI17z7vvewuatwDCBfWqSS9pH4sNWrHaDX0F03vQo6SgJmtLf2l4XISxvhQE
 MpxSOExmT88XLpJziYp1IgXC5TX9Ilb4iPee04rBkqYwsyE7hZvilTtBSksujuIBTHxZs6Z07
 JC6E+GHqKHmX6fblcEZi1kbCEVun1gRkWy7sE2SoN0Mli50oZM8csDxA0/84y4v9ZgKoYAQTq
 LMz92KFIMVYMBylQ54f/2GBO4/6uTetLZ7j8fetpjw9CVx2SM2hbxnrZxhaMK5sb6EuW7K64U
 0l636vjtAgH+GA+ySLpSdKZ6XiSAGY/fbhuVnPll0sSgKSK+wVch+cyKP+8xAqkY2coLNcsdj
 KbylEbm/yvJG8+3IRvvBjQ3QBHjGV2SsZury22kUNGg9J/vZp4pCX78wQNe/IQMlNFlOZeNAp
 giqjNgGAppWM8V44DCokdo6LW0C2Z5pAKUtuBLccEAvCGZFJ5tZnS+xrkzzFw+ZKy0ewR2XUH
 KDpaqaM5oIS2usP1LUx+h26qXpV76iMsHFiseX3YbF8yUjaNVU6KoequLXUZ33GI4TAAzeIrX
 o6kYfLIPAeRFt5LKgQPKowH6eq9wh2CW8e5OeBpviu20NkMIDmnk2VREVllKuM28zhlOP/m+R
 hAiQZhwSAbMtKwU6jrTKbdQLj//oE8QPTvChn0lzo5DWJ9j2sECDYGtrvrsV+LwML9plbOZ8X
 bK4odc4ZcL0Nr7rbAhCFiQJHD372HBIEJJKjZT9wwjSY5T+V98ClJHNPt3ypjOGSg0Dz794Er
 AWGmrZonhXrAmaolo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> =E2=80=A6 The patch fixes this issue.

I suggest to replace this information by the tag =E2=80=9CFixes=E2=80=9D.
Please choose another imperative wording for your change description.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3Ddf2fbf5bfa0e7fff8b4784507e=
4d68f200454318#n151

Regards,
Markus
