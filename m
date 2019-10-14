Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C21D6315
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 14:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731948AbfJNMv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 08:51:28 -0400
Received: from mout.web.de ([212.227.15.14]:36913 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731466AbfJNMv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 08:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1571057454;
        bh=ltdnQ3BCEwt2QtrDNyXPXfdPyb0PNI02wD4bjTd17NY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=VzLS++qqc2dlxkS9wOTDXSjIDFqJO8adgneMmRPRwOInmgCOr4T0RAzV++nOlsMth
         bZh1EapmpBdzlKBmX8bM8745zjZNFCUrcYHdbzFwIcesM0MdDNgukMsh2e/9AeipZw
         UrDw5Lpsmnu2hXnS5QqP3lpOPLmbunYZ5Ib8K24g=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.26.106]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Mbhiv-1iahDP1aBJ-00J2dx; Mon, 14
 Oct 2019 14:50:54 +0200
Subject: Re: tcp: Checking a kmemdup() call in tcp_time_wait()
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        kernel-janitors@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Aditya Pakki <pakki001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
References: <a219235e-bad5-8a9d-0f3e-c05d5cb11df1@web.de>
 <124b41aa-7ba5-f00c-ab73-cb8e6a2ae75f@gmail.com>
 <fc39488c-f874-5d85-3200-60001e6bda52@web.de>
 <0984a481-f5eb-4346-fb98-718174c55e36@gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <248c2ca6-0c27-dc62-6d20-49c87f0af15f@web.de>
Date:   Mon, 14 Oct 2019 14:50:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0984a481-f5eb-4346-fb98-718174c55e36@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:36Xkc0NrmY2078ds001DqHe09Te71+zgR9nHUIwzba1Ea+Qrh7y
 swPm7ZhM4MEkTJA1HhM8JCz8GvyHb3HHAcAWL5cm0B2VggyqN+vw/LN2HRHtnQyDFwYVxH6
 FPqq2iIc+OlYs9szhQCOSMgPhsfRI5JTp8Z3GjoCVFMs1/h45bxWhthGsH516aRLWevh+V4
 7OKLduGk+ihkPxnNPTZ0A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mXMlLphrFCI=:GfOH/Cv7bXnVDg4MgwM7OQ
 +cggJTfLaV3h2r1Hg3q2qzU4pbQFb1PDHA8YNSl47RH3TARNu5EahhdIq5hhFUNtThVWKwhml
 XOF95uBO35VJPC+uBaogBmyABmWIOK/wcpiR7mEpqgaQtEce9P5QUQ9IBek82/KiSCvvMA8rM
 X1slDxskuwh+4iUIIPuc0GVwkN1LX8K/5vVFfhY9RAzXcbleFZUtPyQFbQ3p3da4cCHrJ8mRk
 xYFxyeiPtCS6/FIPk9/XlekN7q+s3aTmt7RXquIxCxlfKMYo70z46batU1qgt7r6tO2hK4HFb
 wiB1Iqtfij22DDLxuf4mcayN4Ma5tX68w/RpGZxO8jq+fiE5Cq1XWoiF1hZMA+bRsdkJQFhn/
 2pVzqrZZB5bwv8d+BRgdYUtDjOjFfueo9Ads4hWp5tpDuGtBu/o9SMFfnHrHHlCwmjb97uly3
 4/O23aJoAddXxvB9ocOJ2+l05Ceg7MJ4jiXd3GzvU8QZAQoHGG7GjmHvHbkQhBU/OYjfzkKYy
 GgEPS7kMHp2tzGmIVnxuipcqvGkhRYvce/NZncqUq5o2J00JODQOCijPmVcFQd9c2HRkubpvl
 aU53CfM/C+rWd+p7blzQoXhiwaLUnEHe504tprW3Sm45ms5ne6qRnhDAdNnWDciQaLcSQoS5S
 vPN43J2068GO6uXwWhTKBqn6u767Wh1lf8vHxYJbL2YgDkFDRhT6afhd1KdYQMibfM1aYHfT3
 Eo518OGgcfjCrXVdg70RBWKW1w0HFU5Sp3XaMUlEy7v7NTkPdBQzzSQovCbX697eNYT5gwD9o
 unnn1XxXIZZtjx2mq8J9uG/ceRLTsRwjMyD1eM8a0Er116wuaeEOlp0H6WAgdBZ7Irp0DrG+F
 oZwdkfSCmEq8XB3+mAlc6xv+epVefqrTt/2PmneJV7x9uplm3TKHBX6kjKv1WTViBZ7wNoPsp
 SyTtLdnzhjXHezfhHRxtod7BN/LKbZBXLYC9fU3alZuv5gb0MmCDFaMKRVi3brVq5c4xGPMGJ
 L2XJW9W8H4OSg7aHOl/QU9iZDXKz/UozgZbokZngIn3MSJbg1yPJHncO2zCB1Move1ILxXe70
 SUHzXWsdcg+DQuMMTYYqcPJEs7mnRSi+fcpZzEzOEb5q7O5o6w6ipahzA8MpGgsURZgujS9qm
 gynaGETNHmlNZw6VDkoh1M/aB0+CSr5kAfGsyX5TeJDVjEujrHh1McAarQ9OxHtWM0JGsEEXV
 eLPurANv4ouuo0NOyZEuhtAtvrigLKT1o2Qt70sCQE7i0t+H3ox5YYj7fSvQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/net/ipv4/tcp_minisocks.c?id=3D1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#=
n306
>>>> https://elixir.bootlin.com/linux/v5.4-rc2/source/net/ipv4/tcp_minisoc=
ks.c#L306
=E2=80=A6

>> Can an other error reporting approach be nicer here?
>
> There is no error reported if kmemdup() has failed.

How do data from the Linux allocation failure report fit to this informati=
on?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?id=3D4f5cafb5cb8471e54afdc9054d973535=
614f7675#n878


> timewait is best effort.

How do you think about to return an error code like =E2=80=9C-ENOMEM=E2=80=
=9D at this place?

Regards,
Markus
