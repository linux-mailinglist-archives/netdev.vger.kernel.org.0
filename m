Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC33AD73
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387530AbfFJDMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:12:15 -0400
Received: from mx3.ucr.edu ([138.23.248.64]:21177 "EHLO mx3.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387400AbfFJDMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 23:12:14 -0400
X-Greylist: delayed 736 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jun 2019 23:12:13 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1560136335; x=1591672335;
  h=mime-version:from:date:message-id:subject:to;
  bh=WA23FRVPf4QoBaGZyT1lJz3zr/X/j8XWfGqXbqdOqlE=;
  b=hYtLiV6+ZzKFAT4jM+JEXjKmRdGLzAhkrHR2ekcTQ+4m8NibNU481Ov1
   gek6P3rH/JwV6UsgSiOMKA9+CIi+4sltfZN6am8HF2Tb+MJs71f3SqroY
   d51V2SvXtoW4g9SHr6LAFuMt3Idk6PsN6njlmdgLDRZZXOqE3dGbIMWUN
   L36TItCWcsOuE9smMK6CjfLmktApTVFeb6YFJ53roRj0/ORcTnDpgd+NM
   ET4nOVv7CfGtgi23dG5r7Q5xwnfbpeDww/Hrcpcg7tK9mVs9/5KZAjq4b
   Zs3AdjkkmB4ZGj2kVMYKlH7LvDFyk5iM0Z5yfUEKW/bHMZaoHGmfRxfTU
   A==;
IronPort-PHdr: =?us-ascii?q?9a23=3Aj/fKvRfI+cFT6xxOo0oFQHH8lGMj4u6mDksu8pMi?=
 =?us-ascii?q?zoh2WeGdxcuzYB7h7PlgxGXEQZ/co6odzbaP6ua5BDVLv83JmUtBWaQEbwUCh8?=
 =?us-ascii?q?QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFRrlKAV6?=
 =?us-ascii?q?OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MQi6oR/MusQWnIduJac8xxXUqXZUZu?=
 =?us-ascii?q?pawn9lK0iOlBjm/Mew+5Bj8yVUu/0/8sNLTLv3caclQ7FGFToqK2866tHluhnF?=
 =?us-ascii?q?VguP+2ATUn4KnRpSAgjK9w/1U5HsuSbnrOV92S2aPcrrTbAoXDmp8qlmRAP0hC?=
 =?us-ascii?q?oBKjU063/chNBug61HoRKhvx1/zJDSYIGJL/p1Y6fRccoHSWZdQspdUipMCZ6+?=
 =?us-ascii?q?YYQSFeoMJelXoYnzqVUNsBWwGxWjCfjzyjNUnHL6wbE23/gjHAzAwQcuH8gOsH?=
 =?us-ascii?q?PRrNjtN6gSUee1zK/HzTXBbvNZxyr254jSfRAnrvGHQLV9cMvfyEY1EQPFgUmc?=
 =?us-ascii?q?pIPmMj6Oy+QCr3Kb4/B+Wu2ylm4qsgd8qSWsyMc0koTFmJ4Zx1Te+Sh6wIs5P8?=
 =?us-ascii?q?O0RFN7bNK+DZddsyWXOo1rSc04WW5oojw1yrgetJ6+eygF1YooygbEa/yCb4iI?=
 =?us-ascii?q?+hXjVPuNITtghHJqZra/hxGq/Eil0OL8V8203E9SripKj9XAr34N2wHX58WDUP?=
 =?us-ascii?q?d98UCh2TGA1wDX9O5IO1w7la3eK5I5w74wkIQcsVjbEyPohEn7iLWae0Yk9+Sy?=
 =?us-ascii?q?9ejrf7XrqoWBO4JwjgzyKqEulda+AeQ8PAgORW+b+eGk2bzi80z2WrNKjvIqnq?=
 =?us-ascii?q?TWs53XPtkbqbKjAwNPzIks9gu/Ay+80NsEhXkHME5FeBWfgojvJV7OPO33Aumh?=
 =?us-ascii?q?g1m3jjdryO7JPqf7DpXOMHfDirHhcqh560JGzwoz199ftNpoDeQHLe7/V1HZqt?=
 =?us-ascii?q?PVFFk6PhayzuKhD89yksssWWOeH6nRCaLbtxfc9OIuMvSKfaceo3DgIOJj6vLz?=
 =?us-ascii?q?2ywXg1gYKJup2p0YanG1VstvJUrRNWjzi9EOSTtalhc1VqrnhEDUAm0bXGq7Q6?=
 =?us-ascii?q?9pvmJzM4mhF4qWA9n12LE=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BwAgAjx/1cdcfXVdFlDoIJg0wzhD2Sc?=
 =?us-ascii?q?YUVAZdSAQgBAQEOLwEBhywjNwYOAQMBAQUBAQEBBAETAQoNCgcnMYI6KQGDEAR?=
 =?us-ascii?q?4DwImAiQSAQUBIgEahSWacjyLIH4ziFEBBwqBRhJ6KItdghaML4JYBIEtAQEBk?=
 =?us-ascii?q?xeTdmkBBgIBgX4Tk0IbgiWGfI16LYxmllMPIYFEgXozGiV/BmeBT5AWWyKRHQE?=
 =?us-ascii?q?B?=
X-IPAS-Result: =?us-ascii?q?A2BwAgAjx/1cdcfXVdFlDoIJg0wzhD2ScYUVAZdSAQgBAQE?=
 =?us-ascii?q?OLwEBhywjNwYOAQMBAQUBAQEBBAETAQoNCgcnMYI6KQGDEAR4DwImAiQSAQUBI?=
 =?us-ascii?q?gEahSWacjyLIH4ziFEBBwqBRhJ6KItdghaML4JYBIEtAQEBkxeTdmkBBgIBgX4?=
 =?us-ascii?q?Tk0IbgiWGfI16LYxmllMPIYFEgXozGiV/BmeBT5AWWyKRHQEB?=
X-IronPort-AV: E=Sophos;i="5.63,573,1557212400"; 
   d="scan'208";a="62742533"
Received: from mail-pg1-f199.google.com ([209.85.215.199])
  by smtp3.ucr.edu with ESMTP/TLS/AES128-GCM-SHA256; 09 Jun 2019 19:59:56 -0700
Received: by mail-pg1-f199.google.com with SMTP id e16so5983621pga.4
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 19:59:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=L+6Il4/ysQ6D5UlBWcaU9SUlvFSLnkTzsdgSw7DdltU=;
        b=jD4KY90RhiX2ST2B+ouHj0WEgRMlDVmmat+4+DX+2A7p9biHsb4/fBjwEWZ2qyf4BL
         nCpFckaM6jwHPXjlu60CF/X3Ycfa2+4oeMbZrmY3+WnFqEHHSiTRWP/R50mRiuH5cUUh
         Qisr/PFg539QVX4UR7qlTQporfUilE5+bNO8bpbR29rOCTrgXQI6wfg2fVS7guiig0qy
         Ve9N0XnzNb35NGATvEcMxdB/P2nhvuo/MMlrT7tbjoIfCT5g0dPsVpURL2fdmxdaxGEM
         D6H0/+pcFXT1BS9jBwwUhQ/nws3Eqn/ykJRmLxkIJkvzmRmSN3rBMuxTis6QDskuEVkO
         DaEA==
X-Gm-Message-State: APjAAAWMHk0so8JTf2f30Bm1Ezji+IaU+jKik2sBNZWQW4ohbKz/A6SU
        0vAAgHNL0XOnbTtTVSRv/S2Z2KRMVDASMNArzzUvP7qUP50SUBI1vr/GTYQRonwwei/4oPKid/K
        CeuTcZPSnM1udrDz4GSshHgTrM6B0Rwkrrw==
X-Received: by 2002:aa7:90d3:: with SMTP id k19mr70057032pfk.1.1560135594491;
        Sun, 09 Jun 2019 19:59:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzfpnO6wmjHnxWQF6zgnpzmNPRTHzW6tw6+4jKATHv23c58OjYxqAoHmMzWNYnpIpHw2lHNwZwKg7Vkag+aoB8=
X-Received: by 2002:aa7:90d3:: with SMTP id k19mr70057006pfk.1.1560135594053;
 Sun, 09 Jun 2019 19:59:54 -0700 (PDT)
MIME-Version: 1.0
From:   Zhongjie Wang <zwang048@ucr.edu>
Date:   Sun, 9 Jun 2019 19:59:17 -0700
Message-ID: <CAHx7fy4nNq-iWVGF7CWuDi8W_BDRVLQg3QfS_R54eEO5bsXj3Q@mail.gmail.com>
Subject: tp->copied_seq used before assignment in tcp_check_urg
To:     netdev@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

We are a group of researchers at UC Riverside. We recently discovered
some weird case
in the TCP code in which the tp->copied_seq variable is used before
assignment to an
appropriate TCP sequence number. It's discovered with our symbolic
execution tool,
so we'd like to seek confirmation of the correctness of the discovery.

In tcp_input.c, tcp_check_urg() function:

if (tp->urg_seq == tp->copied_seq && tp->urg_data &&
    !sock_flag(sk, SOCK_URGINLINE) && tp->copied_seq != tp->rcv_nxt) {
        struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
        tp->copied_seq++;
        if (skb && !before(tp->copied_seq, TCP_SKB_CB(skb)->end_seq)) {
                __skb_unlink(skb, &sk->sk_receive_queue);
                __kfree_skb(skb);
        }
}

It compares tp->copied_seq with tcp->rcv_nxt.
However, tp->copied_seq is only assigned to an appropriate sequence number when
it copies data to user space. So here tp->copied_seq could be equal to 0,
which is its initial value, if no data are copied yet.
In this case, the condition becomes 0 != tp->rcv_nxt,
and it renders this comparison ineffective.

For example, if we send a SYN packet with initial sequence number 0xFF FF FF FF,
and after receiving SYN/ACK response, then send a ACK packet with sequence
number 0, it will bypass this if-then block.

We are not sure how this would affect the TCP logic. Could you please confirm
that tp->copied_seq should be assigned to a sequence number before its use?

Best,
Zhongjie Wang
Ph.D. Candidate 2015 Fall
Department of Computer Science & Engineering
University of California, Riverside
