Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F19494F97
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfHSVKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:10:09 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42319 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHSVKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 17:10:09 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so2700495qkm.9
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 14:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gNko8uYZ/iSVAQkfn2DxMOBCbut/oBDTcq1NiXuMq1Q=;
        b=d9zbuePbVfnVj+QN/ZFdPRmQgkE8/L2bKlSBU+iTJaTACwicNRb8RIVd/OgSurHSl2
         3K/wKETiXla57BE/k/VWoPOvW9Qwmho+85Q09Wu0PiiB8JyZWKVNP3QW5DFwhLAORm6E
         egJnME5xBnx+TAu/y0VP12DBd+NSnNJcM8buHsmNZN+WcBsPmtqbmlWSW+cf5l4apqzH
         /koqgZ8IbY+5QPCVkbjXl/nBdtU+GaDAWxT7CEga7brX3Oj+Di9slysot7Pki7CrZp8x
         FSN8caxSyLv5RXg+eHlkrdrZH169XjGnlHDJUJSZdgyZwegqUtlXXqmaCkts42Sp+d3B
         LV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gNko8uYZ/iSVAQkfn2DxMOBCbut/oBDTcq1NiXuMq1Q=;
        b=PfZ7eUwuSWsMtKxFC2IURzP3oGreaTmTWYXGPb/HKk3GXVts43n/TmrSoFyrHV4KB2
         s77EwaCr40uSgrMgiTLzaS+kXK3motG0wDZPkoRWA7VXzIoQPQc3++zGlFoOQWnoYvnh
         s1/wTWDv7dyB8ZU6WUm2ug5mhkYIIMEyWV6kfJabztmgUpJbckhLspubcdbsJ2lFiR0f
         pEH1QBYHrALNKCrTBe/tXimVKOM3E+sOzgNnyiMPlF/UfpVezukEpHLVLSBN1yB4TFbc
         FcYyIm8RbfFKj4lRkuug/eblqI5qFC1Vp2nRy0VFsQ4PBDgWUHLj0hgbDbmVxbwF/I8l
         weDQ==
X-Gm-Message-State: APjAAAXLAXKHlntYaRYnOwPlHMmfZmyPVmJZVz1n5MrOBGqMLla+UCo4
        1WfNwsIoSiS5rKQz51ZyAadcuQ==
X-Google-Smtp-Source: APXvYqxbOHmZq2qLpckgNNtItEsJCIiUrNJX2RlAGSln7w+nCPcQfnCWxfv/mTB9PQZBdMUL2wpgYw==
X-Received: by 2002:a37:7c02:: with SMTP id x2mr23287096qkc.298.1566249008458;
        Mon, 19 Aug 2019 14:10:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t13sm7579042qkm.117.2019.08.19.14.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 14:10:08 -0700 (PDT)
Date:   Mon, 19 Aug 2019 14:09:59 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+8a6df99c3b1812093b70@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Eric Biggers <ebiggers@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: Re: INFO: task hung in tls_sw_sendmsg
Message-ID: <20190819140959.72a419d8@cakuba.netronome.com>
In-Reply-To: <0000000000006a71990583cd3d9c@google.com>
References: <0000000000006a71990583cd3d9c@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Mar 2019 01:20:05 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    d9862cfb Merge tag 'mips_5.1' of git://git.kernel.org/pub/..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16e9d977200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=73d88a42238825ad
> dashboard link: https://syzkaller.appspot.com/bug?extid=8a6df99c3b1812093b70
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> userspace arch: amd64
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+8a6df99c3b1812093b70@syzkaller.appspotmail.com

Looks like the TLS bugs which involve pcrypt may be a pcrypt issue.
There seems to be no clear explanation for these in TLS code.

#syz dup: INFO: task hung in aead_recvmsg

This is similar to:
https://syzkaller.appspot.com/bug?id=44ae4b4fa7e6c6e92aa921d2ec20ce9fbee97939
(INFO: task hung in tls_sw_free_resources_tx)
