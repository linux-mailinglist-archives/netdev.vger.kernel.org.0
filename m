Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9629F32240
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 07:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfFBFlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 01:41:04 -0400
Received: from mout.web.de ([212.227.17.11]:39023 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfFBFlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 01:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1559454051;
        bh=IAyv54Xq10Ah7uvwKkQaJL6K+uyoP2Zfsq5WTIgBscw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ZL5e7FySW24tOYgFImszaw+EWp63RbDb86vhypcEy02tzUUbKJVpDp/+F0uaFTM3e
         qgGCYRPFcCVmf7/4Y/CAzjLFB3nDQwM8BMtRAlfV2zMIu4WHmgZm2IIoU8/+FRBfps
         PmFTlPxHkHWQXOawhWoZ+AMUosTo5sCbmhBee9IY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.4] ([93.131.86.186]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LfRzh-1gmxvW2xab-00p8XY; Sun, 02
 Jun 2019 07:40:51 +0200
Subject: Re: ss: Checking efficient analysis for network connections
To:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Josh Hunt <johunt@akamai.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1556674718-5081-1-git-send-email-johunt@akamai.com>
 <3d1c67c8-7dfe-905b-4548-dae23592edc5@web.de>
 <20190601.164838.1496580524715275443.davem@davemloft.net>
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <e1af968b-199b-a0f2-dbb1-c294aceeb08c@web.de>
Date:   Sun, 2 Jun 2019 07:40:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190601.164838.1496580524715275443.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:n96cx3wdrwkO5U77W8HJWS3MLCj1DuOP4NfHbGeNbSoLfyybdZ9
 yHlPx9sWz+FRSMjI5lA4l6UnhpPEzeKPoHv4jm6izyUIs2wE9h2F4F09pervxdsT27B9G0t
 zuKSnUtMmZ6dMQwc71hU9P7NkUTfo/oKI4tVZnxfwcz8erFC4GBPDfw9A2Dr7hnfcZIrD6c
 x55AAZo5iK0F1TmogPCjA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pMAy72MVERg=:9q/g1Er3UnjL+Y+75PZjpJ
 oNoFMbhPmtmt1n6MCyQRrtGgmRZUPjK1J7d/MjQ1GKChzCZk48Lxs+vgfxOhnn2d5pHmyNWjb
 l0n//WHLYcriPUEqpXwljBIYEdC9pJp6i019Woh+9lsg+xm8+euAE/BkJUx88yqhN/FkUv/Eb
 NgcRbiucMk4vZiw0lYRgYopCpJTLsuvMWVSGvmA9zQsrd/pyzAkO82SAuFR3E5OufBIh9zv4T
 6eMtTtFt5j7Z3dJfiL3Tx+WO7D+ZAwQlQP2zgnX/+NT2ztBVQ3FL1m8A1pHUJSD1pD7VxGrB3
 ZPtfumSTdrtJzPJ/3+rrl2jHX8DGfr3nDRJo94+hivCqUKUciAdPZNmfjrnEFeymW/S2/fQpc
 v7R/o07/PEBPpUbabAAZ/cQATuQj8i2rvj5aZI9BBZ6jfN9AD6ZOg0JWrc2Ri5q+imacZqGcF
 YolNpHwn6O+ddSjXe3K03LKBoq3elc6fRxlW6vACPZ60+r9p67L9TDF00HlxPSyFXIkXP1Hdr
 h8Z8G4AkQ91E8Eqf/xSkyCwrOMI+GHfYmo8ttz+pIPIaTenim7wN8uBNJQFbHhGI1UZw+506s
 CRgWfAn4CS1F+mMCX4FW/ZeqILX0Te/AlFFWGjESuGb1DUKQpEXebhsj2qzs6Y4vY2GThRM9m
 Ix/oH+MSDPF+m6bqGqXcVc6YhpToMbED36f0o7ulOrOJ1oZ9zECrqvBn+pdXrb7IUNpuaP5HZ
 mmrAhVeJn/DPW3C/zXem7BzNZcxeBMDv22KqEhyYhuy8mjc6y08rQu0VmD8fp9gZhkG0FWyRm
 H2Hu31+kMRj+DYMd+D52PQLwmYEipgqbK9kS6J3QEtc8HkzUAMAj2Ryj33S5Eb2nP+V0GLjf4
 1eZ2Glwv5LV1MHtdQT4uN1r62iFJEh/RX2WNQ5GmBppijzZA9we9SeU+QCdDipveOMuH9Nq9h
 u063LGdj1oS74PW7dvJeOwwfcGB4+8xoRiipr2IrEEpOSHE9YCJ5x
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If you use netlink operations directly,

Thanks for such feedback.

Should this programming interface become better known?


> you can have the kernel filter on various criteria
> and only get the socket entries you are interested in.

This is good to know.


> This whole discussion has zero to do with what text format 'ss' outputs.

Some software components are affected here.

The socket statistic tool is using data from the directory =E2=80=9C/proc/=
net=E2=80=9D.

* Provided text files refer to known Linux data formats.
  Can it happen to work with other data formats there?

* The analysis program can also be extended for the support
  of additional data formats, can't it?

Regards,
Markus
