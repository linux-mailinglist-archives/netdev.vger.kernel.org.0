Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BDFA81A0
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 13:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbfIDL4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 07:56:13 -0400
Received: from mout.web.de ([212.227.17.11]:36237 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfIDL4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 07:56:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1567598157;
        bh=0Vd5KXHqrD9nLV6Q3JvJdI/QMKT4EO/kc5Iz/L+UM4Y=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=Fl4tqQE7je3YJqrzvLqX0nxsZKVXEGYHolsp632JoP+31T4DAxFHKg+giILuknUOp
         QURDwjrukpRHu+YAnRvBV6Sm7M76kWAlMJw7gTQfw0jlhn7rSNPNwwEr8to569rNsX
         E970qUoTJptgL/DdxTKkZ4hiXJmu494062yGc51Q=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.100.89]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lcy1k-1iVhyG3gTA-00iE9z; Wed, 04
 Sep 2019 13:55:57 +0200
To:     zhong jiang <zhongjiang@huawei.com>,
        Arvid Brodin <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1567566558-7764-1-git-send-email-zhongjiang@huawei.com>
Subject: Re: net: hsr: remove a redundant null check before kfree_skb
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <ce4f53c1-fd91-af5b-7f0a-4746c3ad8de1@web.de>
Date:   Wed, 4 Sep 2019 13:55:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <1567566558-7764-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:Q6RYP+WHeHMmx8m0im85yJh/hHkT7YiG1UfxMdqjPlmM1p98XIY
 F553xK/BOfh8jLlxYBmnsFmeRUImQ4EJZD77NDs07IOw1xBiH/mSLpsSlYRheTE89vPV0cx
 YTevrnWsxah7Bsh7nEjyMo5CYFsyXUYdQlftkES+tf7O7mb536RAlIF2JvmZztmMF+IpWs4
 FI4/DiCEOS+bkHYKl7yVA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QsnWmNsPpKA=:rfE+wlQzwwTHK7pyVzt5Mb
 rcn9HzVXvoztoXZx42YrgYkVPUto/BT28HnJP1s+UL+314cgaSQG+wZ01yl97XP1mu29fm9WU
 CgfQyhzdwHi7dq91SErDbQXtGJJmmbdzmgW1vczAX6AFzEO3iY6dbVsXHEg5McWplvchBmP1e
 b6DegdTtT9ALlJ2ddqYV77gekw8ZRTCPmVNReV3D6V3Rkxx/m+WMj1kjCuprvSDmUTAjDiojs
 YnB7zmnPE1+uZziKC/foQhxjID503RgM+oVaBvrItpkSb26gW4LQHZnm8/x6UEdS1WeqLSOHF
 H7SjtEXaHFm+wMOTvFSxyh5m3+dMpj3o8mOK7IEhV154B8zfbT+s/mQdrV+MfLTWKmwUZwK56
 ryhMChADNO6EgQ1hCbC0Ao0EYfguqr0LDJRw8N2DYzJM/dAaKdyLXMpG9gamr4lTs5vVfLwDS
 H+99emPN33NTqT+hY5YCcqbVio6v9tSB5q8Wb+WG/En3dlZbF/gVZfG2gjR1mI8yDciYTisJ6
 bqAYNo7ghj9YWxCT8VfmfRyHb1s+Mgzo4YubfTtDLPVMowUgw0Umu2zIRf5ecZHArpoApKB8X
 I1z8dmzIHWETnNR6nOBXxMWtJLW3UDNbDC0htf76gayqcoZkUyqDJbTyI+wkFgLlHcI2Dv9dL
 HVRbOZBrC61jxaF7OQlCI/45Rrl4C74aNICdIJuS+OfYHMUFfzmLZH0wZtq4VQqV9QipIsD6g
 9OvVdG+qn5yeVxCbg6V4nJsHFBcMQPqXy0Rag1Bug0sLcMKFyWh4oBa0ySswWc1kQNj1Auy9V
 58AOzw8O8nkn84hbC4JV6cmlADJR7ahfxcxHJrrX3pRpyWWwSNUv7OA3WekpoHWgjcCjeEh7f
 kW3D/UoLdi+htqiWan4vAZBbiynn83I3nBjKLfPB5N7nMijbC8hz0JmBqsMV5I28R21JgP15s
 b9+bnlP22PRCE9naX58tHx2wB+MBqneGYKpmKC83EtRMjJvK27HPb0FVqlRYLUb+1jgpByybi
 5jInhjg+Ns4w2jErg85RtEfj+y0cfMjKjB9Pr+G7toqjAvraxv7RkdA9v8ETtYZmYIH/q+zlg
 sOf1T/PT1b+ZI8S7nLBYao1T4TtKxOF85MCap1al6Y0aFiZQ6QubOGjXmpUlOLusfVIB28F+2
 5o2CJq2jyaee9ordoP1YVhRGisI2lIMLMfId0omAqYOQQnmiAPIEihM2Y3JerC+R0ruhR1MXG
 aah87XqF/tkTGzaXt
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> kfree_skb has taken the null pointer into account.

I suggest to take another look also at information around
a similar update suggestion.

net-hsr: Delete unnecessary checks before the function call "kfree_skb"
https://lkml.org/lkml/2015/11/14/120
https://lore.kernel.org/patchwork/patch/617878/
https://lore.kernel.org/r/5647A77E.6040501@users.sourceforge.net/

https://lkml.org/lkml/2015/11/24/433
https://lore.kernel.org/r/56546951.9080101@alten.se/

Regards,
Markus
