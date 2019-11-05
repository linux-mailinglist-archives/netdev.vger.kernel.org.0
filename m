Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D377F003F
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 15:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbfKEOsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 09:48:16 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35686 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729092AbfKEOsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 09:48:16 -0500
Received: by mail-il1-f195.google.com with SMTP id z12so6466059ilp.2;
        Tue, 05 Nov 2019 06:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5Q1vt3almzqAzb5sEBadWFskQeA0wPngKWFtSxaTh1Q=;
        b=RFUp1sQZPTnb8GxDXGbG7y/J83JmqMYQv1rnPHDSrMP7cGsQU4oITCooYtkVnc7T4P
         y06lqFnM417K9levONy8Nyd3IoH/0sRSwwgZ3jIcVU4tEeEhsCpOt61E9nHBygab6k3/
         8u8P/zPCCFoGbinBrSgCs9lG4V2F5ivVhBe/jD0ffpVDMuSJMj4dtl7Vca+OkvjxM5nv
         8Yk/+brHRqCi3bytfPBugRCYL/vqCE3Zh+B8YJhlfj1X3lc1vjeFisb+ZERqSzdSkK47
         dfN+ieN+txBe0NgrDGm1Q9LTZvCkK3HAtAspzeu1f6empoHvuo7WQ0cLVyy5mBeue2Gj
         SmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5Q1vt3almzqAzb5sEBadWFskQeA0wPngKWFtSxaTh1Q=;
        b=EuBuWSmJHhBm3KWAUBdhI9NCm+LUnF7ZQqEQwbpwkivizzLqxyWLUrLZT+GQHSsCo+
         bqeYW7kbABuarDfsxzfZqAr3IwWVBZuoGI3RzCw9I5QkajERjto7UbsfTmUZzTFFb6NR
         JOJCYqFC1Nx5IJDTcwEe/C+9z6q8oet1Ynnb6xheLJJ4gGY2+ZOPic6MGtIK4hJqcY4w
         mOLhkCdoWCanQY8Q7X9yJyxfqk8J/LdzX7uR3lrIMEr++pJ2nicPCdv/jme+wZFpaCBn
         9ZRBEM/VQqPUD8DU0OyoLhX42EdyRWpfnI+XToUc48zLf1HQCZM98WaEp2qR1Ko6i6Rj
         ywKg==
X-Gm-Message-State: APjAAAVvxtbirkD/0hO9eSogPyrtAQ8r2Sc1W171kK/veDcarYI3k0df
        /VAks3kcISGfz4m3bQxXz24=
X-Google-Smtp-Source: APXvYqwFwC45O+JY4lzd+zYWbG66p7c7n+9VpyFAqPAx48dHKQvjVbO3A9KPOIQ9oIM1qoeyZlSHvQ==
X-Received: by 2002:a92:9198:: with SMTP id e24mr33866410ill.184.1572965293616;
        Tue, 05 Nov 2019 06:48:13 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y1sm1126861iob.42.2019.11.05.06.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 06:48:12 -0800 (PST)
Date:   Tue, 05 Nov 2019 06:48:05 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Message-ID: <5dc18ba56aec_48332abec96485b835@john-XPS-13-9370.notmuch>
In-Reply-To: <20191104233657.21054-1-jakub.kicinski@netronome.com>
References: <20191104233657.21054-1-jakub.kicinski@netronome.com>
Subject: RE: [PATCH net v2] net/tls: fix sk_msg trim on fallback to copy mode
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> sk_msg_trim() tries to only update curr pointer if it falls into
> the trimmed region. The logic, however, does not take into the
> account pointer wrapping that sk_msg_iter_var_prev() does nor
> (as John points out) the fact that msg->sg is a ring buffer.
> 
> This means that when the message was trimmed completely, the new
> curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> neither smaller than any other value, nor would it actually be
> correct.
> 
> Special case the trimming to 0 length a little bit and rework
> the comparison between curr and end to take into account wrapping.
> 
> This bug caused the TLS code to not copy all of the message, if
> zero copy filled in fewer sg entries than memcopy would need.
> 
> Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> 
> v2:
>  - take into account that msg->sg is a ring buffer (John).
> 
> Link: https://lore.kernel.org/netdev/20191030160542.30295-1-jakub.kicinski@netronome.com/ (v1)
> 
> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> Co-developed-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
> CC: Eric Biggers <ebiggers@kernel.org>
> CC: herbert@gondor.apana.org.au
> CC: glider@google.com
> CC: linux-crypto@vger.kernel.org
> ---

I'll run it through our CI here when I get a chance but LGTM
thanks for sending this and tracking it down. Per process.rst
I guess we add Signed-off-by lines instead of acks from
co-developers. News to me.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
