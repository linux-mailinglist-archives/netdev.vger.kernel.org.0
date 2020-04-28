Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D42F1BC741
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgD1Rxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:53:32 -0400
Received: from mout.web.de ([212.227.15.14]:43959 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbgD1Rxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 13:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588096373;
        bh=tnjQv2P9gGiR9Mb9PDJN0nYvFGdtYNLKJDSs4Sk2/Wg=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=YWWcul4nCyZy4q/m9sIPWVgxeHXOqy4GKNkUhCkxeEi0o3cg4DhWAabyuyngxrBKW
         +bxwPzloZkbJwV200G4wkj4Hm8EC1e4LdwRfNs6cSwQwZNlcwYpX9wWouyLlZIHOLC
         a7OVYOvcIDa/NG8Gx8X0eRwZpZE1j25wgS/cL+o8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.179.255]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mho04-1iyqYP1sW0-00dlUG; Tue, 28
 Apr 2020 19:52:53 +0200
Cc:     linux-kernel@vger.kernel.org, Allison Randal <allison@lohutok.net>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>
Subject: Re: [PATCH] net/x25: Fix null-ptr-deref in x25_disconnect
To:     YueHaibing <yuehaibing@huawei.com>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <2638b7a4-4c19-ca4d-3931-7442378b3b30@web.de>
Date:   Tue, 28 Apr 2020 19:52:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:D5/9WS1n/ydLkrFWaCYUuA4RQwaKOb89GOlnieaVZKBrNRqf6kr
 UoMzoB2pLTZl6gA4fmmrFbVBMDZVw0MjoX6zt4PkiyKKxfBjWA1zXqGJlirnPO/9yqNrWCp
 xzt4SxE3UO3blTGfxJtnP2L8GvX3vnvqzogoyZeAlDRuuNy7oadUiBvzx9a/Wj37uixtEdv
 vLvfAD+YNOfki4H+QnP8A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hLzm4VX9290=:Wbx3fxI0yP8205erAsqsma
 jOiY1m+lb9YZcLS4jeUR03WYQN5irLNmtExn0/gGR+4z+zbYqclKds6ByzLMJybmQndX8yR5W
 Sl3r9Q4RIWVNf9Sb+29W3+3TVyFOZUwnwtHVwE58XVExf5yBQIBOvlcGnPrSvamZpWU9I2nBg
 CoLRqL2dwxOIYqN0L01FtWM7J5sMHGOKKGYtPokyjwXmoUWaYDuUXC8CF0QQkWYEFHNkBDJYa
 LyQMy/zd8990igYKG9szmtRb9q9i70u3pHzIOyeHMwxVekL26lCE0CqIPvYviUsy9aXGkN4VG
 BauCcJv6D2AL2D1kxAs/BW/y28aMcE87tcQKNEsnH01s0Wa8JwnRvBKrvNHgx/z7gtfXlQoRI
 qpFqHn4pyDe5w2WKA5DBoK0sXygwUcU0ktAYx/hyPHx3qeayVF2CnNXGi7c3xGRB113XAmqC9
 /bhkAMDP50D9G7Gi5yx2RgrPtWtjxCYaLdGKJGfCPMo69CbEd5iLTpyJzqS0aB7YLAKJrU/Ml
 nMpyIX1yIAG5ZmUDcYYCNr9FtuTFZTgD4bD3AHpQtIXJsmR/2RsqLtXTm4AGPT1hSwM0bb3Hx
 z4i8HXLXdB86iiPpEOb86Vj/ib3XTBjln5pZrBgciluknS41hlCnvsKoW1ihA10KXbf6X6QwX
 MnRAOs9bm8J5E6OeYr82fa9aRbQD3ekNynD8Jwfh+4+fFxqg538GhDsOV8u50uiWjCiNovRNy
 sOB2TTh3IG+eTlePpYyBinvxHzUOjbPbvyYSRy+CHAwuimVPRfL+AulmrXuj3YmAiosCp9m2X
 uCn401FHaRPTNYeWg380v0WALmWiYlboLtqX8h0Nw/rVgZjXoRhkk5XhiARJ01gS5Wlw12dtQ
 SwxN23qDi5mZHav54HapF0xqPyyNKVYSAFVpRtrbYcnzvd0gIkBAMILVq2CI3tcAf798ndwyF
 zZftihsle2+PfaF0YDo0gX8ZmrDiev6QNBy1APsYsf9GQ/GHPO6cRQeaRNdxg3kBbfVKAnOzX
 1OMiALPc/u78QN9eqPnh8ArydZWx3zkOumSqxA/sswzyXd4s3+9zGBX/La8+qzi3ya7T94PBC
 7SruHzxA/HqIfuigvsQZsqOu/wQC0Jt9vAqjPR/5HUYD4L+EZRHcf5MXmZ8UaLNon6OBvKJRK
 Zl3/ozxHv9XMRUa8IbD2gpF5FZOkw9k7YrW8iUWKp0Enb6fAcYNg3AsWCdhSRVo6t2kcm8jnG
 ghPQwhVMKlA2CrNMA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We should check null before do x25_neigh_put in x25_disconnect,
> otherwise may cause null-ptr-deref like this:

Will it be clearer to use the term =E2=80=9Cnull pointer dereference=E2=80=
=9D
in the final commit subject?

Regards,
Markus
