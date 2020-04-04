Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681FC19E4ED
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 14:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgDDMay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 08:30:54 -0400
Received: from mout.web.de ([212.227.17.12]:58315 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgDDMax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Apr 2020 08:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586003423;
        bh=EgjoOrOfNszCHgR9zPO/wVOqjPYsnHpGG05ACXZM6SI=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=MVKLfNt5zzz6HHa2uAzeCe/HJRZY1E3fnLWkxTJrmtTfAi/cP9AYP2lkL70CYLaD4
         8p/koFI2CyF+3ak2cXYpFZ0yVGjLhqUP6/6gQPeRE+/ikLVDhG4bQbHIf+d8sq1ort
         VVJfJsfbnAONRuDkZg1Cj0G8pl5rCviouXZSSBkY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.132.181.229]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M3T5g-1j3B1T0Dtw-00qzd3; Sat, 04
 Apr 2020 14:30:23 +0200
To:     Qiujun Huang <hqjagain@gmail.com>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Qiujun Huang <anenbupt@gmail.com>
Subject: Re: [PATCH 1/5] ath9k: Fix use-after-free read in htc_connect_service
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <d3083092-bb87-daa4-673c-06f935285254@web.de>
Date:   Sat, 4 Apr 2020 14:30:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:004CYPF3hqD9JGG6qw09Kz9gax4Qh7fBcp/QBmGBQzF6SkiDZJF
 kRf1CF8yB+by6102CbFrVb3zXSLMXWWD6crWOTnPePy1eF11k3BTczT44KsuocCqjUJjFiw
 I2XZBXyKDYEdKeQk/oXQa86eR65MRP6gkEq/iD/FNleUfZ0h4ZKX44tSAarTNI4pjOWQqqi
 HlrYK7ewRHYxMfw3KkIQA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NOL2uWzJc8g=:jD03p0FtoayiqIkM2IUeUB
 xBNpnwqLePoPIFd1EWGzSaeISkXc/IsW8Xo8kqjY7x5oEDQgpliFig5vog+DkA8xBL6Dz1VFM
 BJvQqZH8XX+p/lK4aFe9Qoufh09p/Hpg2vrh9RSjqn2MNXNnmfx/25+bW+75mZWAQUO4kWkUP
 rCV7H7oLq6lhhhkX8om89oWt9KjvvzesysbMRJRq9zCeabDn9OcEy+e0ZBxJEiQV6wubfaDag
 61C61Guia7zDIs7ox4K8GZAmFQAD/xgaymOZoL/OCFiallvZpsWtc9rzDNt20wHt3AXLk8PxM
 tJG5cVY5qtlPwbQDtdJjwat7YhK1qZwN60Lx5vnQeYlD3/NOncug5N3ZJUmKP8BHxos7s7Cvx
 ncX1/4yc0NyI8b6pFrr+nYAnacDFNHfoE7G7SruApTGiKeFcWZXeZFKSXFzxgK163JetBtu0L
 uXFfpGU8YB73TA7qaRYqvldI2+dW/hr84sbn7p2PfKUE2ikS7rVD7mK6/3e/IkCyihVEKUOhd
 Pr6sQ0RPNcaLz+ZCJv56jZRRYpLOYucP07aa6wTuF6uf9bKZU4tyPhS1NSF8TvR94NQsW80te
 XBuoYw6mC++TYlIZaRqofb4M54JNjDMMTglt2GM3b00lUIpGAWpb7ZtMwlipM9+ZeI/9P00DU
 8vAGyXfplNhAQ83/ndYa1YRHNSup4ce1rrMubR2bFfQGepVQyJTpncyS4JoRMSma03e+NEgbq
 bueuXc63z+2OZO2Q0K6uOOcivkDnnCYXqOkYHTStrj5UA99L9DIZSrcSgqECPhaMcetlPj2ir
 JKf2fIL2GItXfJ9z6bxdBZh5r3UE+2Lvmx+/PUyNjQUGKVFHubsOnEVhAEP9KzSuj5lw9CLLp
 bsm3y7vLn2YNtlu4IqAdJgXZiWfpXzqx9/NsZ8voHRFfNQ43ikNGYrnRGl6F5lZhwl9GcHiDu
 YJRL9wFnO/Xxz23n0EjEtCLtOFbCTeVZ9nNTF4JvSnpeAvYV1L1HKE/WgxHI4yZVfNZt9rX/k
 vczcDwGFvxSBhcW5QzlJdtO3cvhFLqtBmuSlxlr8CvrQQY4ldIGyE3+yfKZrquvo1169W02IL
 rPd/4udCYbFO0GjWuBRKwvVhTeRf9YqVgX5wjvQVgk2UE5H+7mBkl+guGHf/4H849jBgAwLyp
 iRtpH2+SQGFkR4DL/E9eY4lk88KICfgIMnBGIbKdirZFkMG56Bj97ih2EyBLmFwezaODR9Qlr
 XDGUy6HyxgANKNRvs
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The skb is consumed by htc_send_epid, so it needn't release again.

I suggest to use the word =E2=80=9Creleased=E2=80=9D so that a typo will b=
e avoided
in the final commit message.

Regards,
Markus
