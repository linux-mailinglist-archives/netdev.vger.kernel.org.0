Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DBD95101
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 00:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfHSWmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 18:42:40 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35305 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbfHSWmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 18:42:39 -0400
Received: by mail-qk1-f196.google.com with SMTP id r21so2905827qke.2
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 15:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lcp+YLDBpIdavMYZNzsYtx/6frDIFLB/mtEMPIGQcP0=;
        b=IN8oX6sVAg2IBinffenCEWbsApvRd9a9R15KqQOKf1MrNurbdhkSlXMFZnisrsjEni
         Wi/NOPLUz/eU7VfDU7OBi3X7qi64sShMxSsqufmO5z47e4SM2jYnaEY7HLoFmhH1wYER
         TpJ0jxmK4f1Dq6cAUsLRkgqngVGBq//EzIE5fVfn1tBd5uVm5kQIOjIlm4CDlxivG1kb
         8JhPpVp6CX/ZUsL+Og+Xhj80Ksy2IRUqk204J/tvelajK+lZs1dLpSSHDfKizJHOgJHa
         ky4RIs646NLnzR0a0xQFb2AYe3C5ML9rYwNo6qN//7eqsAEDl2jht6Hjo1B9+S3EIbfM
         h8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lcp+YLDBpIdavMYZNzsYtx/6frDIFLB/mtEMPIGQcP0=;
        b=njgPVkyePIocUR/IpVu4JYxoZQt9ceSDUkKb5KtjOsS31pZ+9IKE61SA+CbA1OuYLZ
         fDssQ8/FdCGC6mbkv+HN6/tgpQw+kMJuMo4mDGnaJE0YHL8v4JlUTfN2N1gcOHNMTvM9
         d6BImS4vkPtJl2npESabVTTPgwU16dAWqDc26hqjrKCWYuoP41V2baXXwKWrb9qfKr62
         TUJufA2lEP/SqyLuS72AhWSRaE4aFJjKuX6ObnC+lHQ6fQws499KWraoKOOTSEtsBrnX
         uI2eVAmTItILveSUO7GUvv4Dhz5KsN0V8xaZKmqn7snmCBMeE0iCJFiW+yRghTpBeM21
         VPIQ==
X-Gm-Message-State: APjAAAWqozwkjQfjGRRVoLIM4KSMZTKs764r+sb7Wi5d/hgnJSPQh0NZ
        FWZoQEoiZIxY9FN9fetjSRSzWA==
X-Google-Smtp-Source: APXvYqwkycOlwWICAK5DY/s2gye+jBIFKcaX4m6pf/9isjOpkChpjqm9237VN/njknmFQUW8C4DhMQ==
X-Received: by 2002:a37:dc1:: with SMTP id 184mr23232000qkn.10.1566254558998;
        Mon, 19 Aug 2019 15:42:38 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g3sm7541182qke.105.2019.08.19.15.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 15:42:38 -0700 (PDT)
Date:   Mon, 19 Aug 2019 15:42:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+66fbe4719f6ef22754ee@syzkaller.appspotmail.com>
Cc:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in tls_push_sg
Message-ID: <20190819154232.4f1ed902@cakuba.netronome.com>
In-Reply-To: <0000000000000d1491058919b662@google.com>
References: <0000000000000d1491058919b662@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019 11:40:05 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    35c99ffa Merge tag 'for_linus' of git://git.kernel.org/pub..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10ff3322a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
> dashboard link: https://syzkaller.appspot.com/bug?extid=66fbe4719f6ef22754ee
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+66fbe4719f6ef22754ee@syzkaller.appspotmail.com

Most likely:

#syz fix: net/tls: fix page double free on TX cleanup
