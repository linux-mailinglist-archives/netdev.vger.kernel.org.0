Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424E735FAB8
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350768AbhDNSVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:21:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45709 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232769AbhDNSVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 14:21:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 337D95C0064;
        Wed, 14 Apr 2021 14:21:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 14 Apr 2021 14:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        /QZgQXTmoIzWzCXIMXCB32oxFOEcZO9uDNiL7A/7MJs=; b=eSyZNgJi5uXxraVa
        0aQdW3gXfauZMOzrUgAkGNGwUxheUs5UPHmG2O9VMZwMfOKYgHqXBWDJCjmUQuPB
        LunxeGPwvaId0rAXLNKftmJteKNdBVOW6VNtHJ6OPqLrEDSJYHtN1ov7B3hBKNkr
        8Laqb9vU7JK+jhCG1etbrebVtpjXsIcw+ER9t9cZRZBGmttnBcvxMnKoVTY9uIfN
        2yq41o1gKfs7eQ+yGB+AL78vISTd9B1MrX0YhIYIMhO9ZeLrkQbE6G6C+96/ZFCY
        +oBNruzMj5MUHCsnQH+jIFz7VKmEKJ75hyGen8zg32wVXbIadEwwhiKccegoFDby
        Pq4qdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=/QZgQXTmoIzWzCXIMXCB32oxFOEcZO9uDNiL7A/7M
        Js=; b=Qxu+KSckjWFncLfgX4bVTg+lpW3Hl+BIBepkje8aL7R9O7FxMIjrOO0Lj
        bA43EKnGjpYAO8vNZ+fljOaDbvIPDSekoDPBjMkdgQ7NseTXkH4JIdKK1BkI3maN
        RLZZ7d++12TC/7Y98qeYQOLny4aRKIxnuRLZkwL+lpXjXlzrfw6uTqyl57RLmSD+
        W9DtY68XpYkI0uNXjYYHiyvRTRr0HSgmHPTDPhJId+40qwzQg2T7aWr0p9SVdsKu
        vAOYkc/Re7hSuVgFbIWU0VK8OFRufYuCP0EHVAKUv2sRq19Xm2h0hRBMqtp2nt1e
        hiW2hQVNtMJ1eLz2lglirEflLelZw==
X-ME-Sender: <xms:kTJ3YLbvPtznvIwzCzDYnNigGdFkyVHjPXcQmtSLWwFLIrmKFWusXg>
    <xme:kTJ3YMb_E55GpWKi8vxeXvoBhIrFhFSwdjUqaeTEgshQhQcGUYYBkXOckayAzP4kc
    cov7iiUKzPv4j0Mmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeluddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepkffuhffvffgjfhgtfggggfesth
    ejredttderjeenucfhrhhomhepvehhrhhishcuvfgrlhgsohhtuceotghhrhhishesthgr
    lhgsohhthhhomhgvrdgtohhmqeenucggtffrrghtthgvrhhnpedvudeiudevuddvtefgve
    euueefhfehudekffetudefheeuveffhfetvedufefgheenucffohhmrghinhepphhurhhi
    rdhsmhenucfkphepuddvkedrvddrheeirdduvdelnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheptghhrhhishesthgrlhgsohhthhhomhgvrdgt
    ohhm
X-ME-Proxy: <xmx:kTJ3YHVMTS30SA-C84iti97f8hHRWyoRKJzEMy4qi0_SEgWW1qLy6Q>
    <xmx:kTJ3YD2hm08OxaRGg5gtyvqw7bzT7OXBq9VNUva43RWqpyFKuJ0LRw>
    <xmx:kTJ3YOZhBwQArszbKGIK6IGzZWp2bjvW9unxXnBek5noZnfmRNNW5w>
    <xmx:kzJ3YKm5YEiki2Zfv2SQqYfM8ud8QVsxwXpf9jvk6G3bl1hOihz34g>
Received: from CMU-974457.ANDREW.CMU.EDU (cmu-974457.andrew.cmu.edu [128.2.56.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CE2F1080066;
        Wed, 14 Apr 2021 14:21:05 -0400 (EDT)
Message-ID: <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com>
Subject: Forking on MMSD
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm, 982250@bugs.debian.org,
        985893@bugs.debian.org
Date:   Wed, 14 Apr 2021 14:21:04 -0400
In-Reply-To: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello All,

In talking to the Debian Developer Mr. Federico Ceratto, since I have
been unable to get a hold of the Ofono Maintainers, the best course of
action for packaging mmsd into Debian is to simply fork the project and
submit my version upstream for packaging in Debian. My repository is
here: https://source.puri.sm/kop316/mmsd/

I am sending this so the relavent parties are aware of this, and to
indicate that I no longer intend on trying to get a hold of upstream
mmsd to try and submit patches.

For the Purism Employees, I am additionally asking for permission to
keep hosting mmsd on https://source.puri.sm/ . I have been extremely
appreciative in using it and I am happy to keep it there, but I want to
be neighboorly and ask if it is okay for me to keep it there. If it is
not, I completely understand and I am fine with moving it to a new
host.

If you have any questions, comments, or concern, please reach out to
me.

-- 
Respectfully,
Chris Talbot

