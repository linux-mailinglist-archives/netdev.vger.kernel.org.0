Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A2D3EDE5E
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 22:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhHPUB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 16:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhHPUB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 16:01:28 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AAEC061764;
        Mon, 16 Aug 2021 13:00:55 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z2so36843435lft.1;
        Mon, 16 Aug 2021 13:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=jn+MCTO2XYnz+C1uUpqojL4zLVrIjta44UP412OIer4=;
        b=Xt9HmHYTLeyIXCim60eBJQW5NEjrtHU7AGIjyBEHuGn65SAb1YaSPTWO5kc+yqxloF
         e4XA06A2949/ONTPWfHJrIk8LalmRyfQuNXpv7fWzOHBnLzH63D7aDXBsNafKO/Tl2OK
         RKG2Xu8ws50t9RKrfpKlZWKCcNxs7snreU+6nbX45q5RoYFHFcrCTLW3mnM9nYKZu+cD
         6elPJRDN7/ozAioY+XqWAT+lgLN8tN9G6FGMogPWn8t9YcjLfOJongAr0sl6vOhTPuXL
         1B9TLyqGKUt7y6DBtnEK6S+qW3VkR9r7iL6GNgc9kPEb4Va2juM4Ew5NEdgrjdhmtcLD
         D2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=jn+MCTO2XYnz+C1uUpqojL4zLVrIjta44UP412OIer4=;
        b=bBbKKZV2bbi+adwjb9KjXUIBkQFeT53tXaBIcMNBWBMCTB5vqszQ/Yp/QffIbQbIis
         8uGUOmD1K6c2MDcgx3wjIn41l9lnayZSLeBB2PTiE5G6wCT1TElI9oDsYSgMVvj65BAd
         qc2rgtpNUdfhELzgdwfiey+BTGyH5X9mSOPOpa3iAQwIufXBoeRtvpWHA2LG04yAjOqr
         EB2S2l5WVgRVUmMo0f3Z7s5q/RWhlva2OuoF97Jn0B8Xszvzvq6jjAUQ7N3jv2o+OA6Y
         ouBEFddE+kX87gxAfUNYO4KkkWlQIvRxSg/SNi+om6hpMfjYhgMdwmV3HecHoAJBn6Cq
         1AVw==
X-Gm-Message-State: AOAM532N+hE7q5E2Ixp+Ggict2VcRWViVJ9eWQsWHhDjA7JB4TRFqeq4
        BDAz3yPP9/4tOwxKm7cxab4=
X-Google-Smtp-Source: ABdhPJw8n+sXoiijbBBS57ncU1c4jJjF9sNXQWuW0YYgHxiEiFLxnsPwwVBUL25sKgcUVqxtREtWUw==
X-Received: by 2002:a19:ca4e:: with SMTP id h14mr69913lfj.146.1629144052653;
        Mon, 16 Aug 2021 13:00:52 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id m28sm33270ljc.46.2021.08.16.13.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 13:00:52 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in hci_req_sync
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     syzbot <syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000c5482805c956a118@google.com>
 <9365fdfa-3cee-f22e-c53d-6536a96d27ae@gmail.com>
 <57BAFAA4-3C3D-40C8-9121-44EEF44509B8@holtmann.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <568c354b-6e4b-d15a-613e-3389c99a93a1@gmail.com>
Date:   Mon, 16 Aug 2021 23:00:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <57BAFAA4-3C3D-40C8-9121-44EEF44509B8@holtmann.org>
Content-Type: multipart/mixed;
 boundary="------------A192B244700466BCDC3D5042"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------A192B244700466BCDC3D5042
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/21 6:56 PM, Marcel Holtmann wrote:
> Hi Pavel,
> 

[snip]

> I agree. Feel free to send a patch.
> 

Thank you, Marcel! I will send a patch if it will pass syzbot testing.

I believe, 60 seconds will be more than enough for inquiry request. I've 
searched for examples on the internet and maximum ir.length I found was 
8. Maybe, we have users, which need more than 60 seconds, idk...



#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master




With regards,
Pavel Skripkin

--------------A192B244700466BCDC3D5042
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-Bluetooth-add-timeout-sanity-check-to-hci_inquiry.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Bluetooth-add-timeout-sanity-check-to-hci_inquiry.patch"

From c868a2f2533bb05873fedcde6bc4ca174f8908ea Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Mon, 16 Aug 2021 22:52:29 +0300
Subject: [PATCH] Bluetooth: add timeout sanity check to hci_inquiry

/* ... */

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 include/net/bluetooth/hci_sock.h | 1 +
 net/bluetooth/hci_core.c         | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/bluetooth/hci_sock.h b/include/net/bluetooth/hci_sock.h
index 9949870f7d78..1cd63d4da00b 100644
--- a/include/net/bluetooth/hci_sock.h
+++ b/include/net/bluetooth/hci_sock.h
@@ -168,6 +168,7 @@ struct hci_inquiry_req {
 	__u16 dev_id;
 	__u16 flags;
 	__u8  lap[3];
+#define HCI_INQUIRY_MAX_TIMEOUT		30
 	__u8  length;
 	__u8  num_rsp;
 };
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e1a545c8a69f..cd00bcd2faef 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1343,6 +1343,11 @@ int hci_inquiry(void __user *arg)
 		goto done;
 	}
 
+	if (ir.length > HCI_MAX_TIMEOUT) {
+		err = -EINVAL;
+		goto done;
+	}
+
 	hci_dev_lock(hdev);
 	if (inquiry_cache_age(hdev) > INQUIRY_CACHE_AGE_MAX ||
 	    inquiry_cache_empty(hdev) || ir.flags & IREQ_CACHE_FLUSH) {
-- 
2.32.0


--------------A192B244700466BCDC3D5042--
