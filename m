Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877DE3E8367
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhHJTHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhHJTHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:07:00 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803D4C0613C1;
        Tue, 10 Aug 2021 12:06:38 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t3so22560131plg.9;
        Tue, 10 Aug 2021 12:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Lv9Kbnrsoc3CJsd1J3pEd+P6FWJYORyGFYJTnBATrls=;
        b=BrWfZA50uBVToYTNrjxQkjbkc3gkOoAx0a6Mq+epudkH3U7mIQ/m4XSzY6mLdMtmYw
         dqChATm0PezvZU5B9LGEYiquniYRm1vYkE4NQjfNt5SNrb7n9hEnZZISQNgKdFonvstz
         6gqH4KnzGzFKwVpC2RkQUc9jE7v+cz6gnc6oBT/wMy3WL7V49+Z/UQI5dJUC/nKA85q7
         sk9M7iaztISmwYkI5C0ByJJgRPW/aCuOpq1YIWxHQi9/gSNd7PYDAQSMOgttZ7w/uxj6
         wBtvwmIPBjj8WkIFQcrdYYdLxc4ltMbZ5LbbvOIs11ZnFbtUMVzywkiWoWuJhn/42FVY
         qYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Lv9Kbnrsoc3CJsd1J3pEd+P6FWJYORyGFYJTnBATrls=;
        b=k1vy06XbcJqlMivNNCxFcHHyWbydS2RiGKa3G8JmXYAAByxDpLfZMRf9TOpQG3vs5s
         S15kt7VaNG0/VXZK3TCuI+OX8W5rvrmJSyYb6XdvNSoHfzNezC0nG3hWONv2dabEOyqj
         z1IDhxZvsX7K2GqPaE9y9sVVq/dMq6ASK5kIzPEfz2hSQcUg1ENpm+jn9QxhgH6bCffE
         mdIEi8ulKxR3yCEnA1i4X981WexCFi4cXhDVsnLtkUGhrVWk5ZQAF2nvluWCTpBP48Xb
         r26jAD9MXijvUaUK64mehHs3miL1Qs9ZZ2VJezbtqT/tYgTgU9PpUfoO0tt20r3ZIvG6
         8PVg==
X-Gm-Message-State: AOAM532ILR1aX8Fh2iJr4PhfvHmXALgQgJoR+9KyxW5cuLQi2/Sgohbo
        +ZcqjuyLt6qFQKojSVrRBjA=
X-Google-Smtp-Source: ABdhPJz9UPo/Gn5SSIodiFawy9+MMaapuWqFWlTa7yV5t1SFB9v8GLoRg9Rof8ZejnuJerDWgu4aRA==
X-Received: by 2002:a63:6d3:: with SMTP id 202mr447772pgg.420.1628622397952;
        Tue, 10 Aug 2021 12:06:37 -0700 (PDT)
Received: from fedora ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.gmail.com with ESMTPSA id q5sm3441292pfu.185.2021.08.10.12.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 12:06:37 -0700 (PDT)
Date:   Wed, 11 Aug 2021 00:36:30 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        willemb@google.com, xie.he.0141@gmail.com, gustavoars@kernel.org,
        wanghai38@huawei.com, tannerlove@google.com, eyal.birger@gmail.com,
        rsanger@wand.net.nz, jiapeng.chong@linux.alibaba.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Can a valid vnet header have both csum_start and csum_offset 0?
Message-ID: <YRLONiYsdqKLeja3@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When parsing the vnet header in __packet_snd_vnet_parse[1], we do not
check for if the values of csum_start and csum_offset given in the
header are both 0.

Having both these values 0, however, causes a crash[2] further down the
gre xmit code path. In the function ipgre_xmit, we pull the ip header
and gre header from skb->data, this results in an invalid
skb->csum_start which was calculated from the vnet header. The
skb->csum_start offset in this case turns out to be lower than
skb->transport_header. This causes us to pass a negative number as an
argument to csum_partial[3] and eventually to do_csum[4], which then causes
a kernel oops in the while loop.

I do not understand what should the correct behavior be in this
scenario, should we consider this vnet header as invalid? (Which I think
is the most likely solution, however I do not have experience with
networking.) Or should we rather accomodate for both csum_start
and csum_offset values to be 0 in ipgre_xmit?

Regards,
Shreyansh Chouhan

--

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/packet/af_packet.c#n2480
[2] https://syzkaller.appspot.com/bug?id=c391f74aac26dd8311c45743ae618f9d5e38b674
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/skbuff.h#n4662
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/lib/csum-partial_64.c#n35
