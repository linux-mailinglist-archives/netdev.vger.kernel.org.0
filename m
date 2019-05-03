Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA58612FD5
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfECOJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:09:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51382 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfECOJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 10:09:34 -0400
Received: by mail-wm1-f66.google.com with SMTP id t76so7319376wmt.1
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 07:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=3LxTUsWtAnugj+yiOaxg4TXl8GgTh7eQs5xZZAZRyaA=;
        b=TtBiPkj9qUv5qRt5mG5HzJVFiXjO/TI+M7cB7E0/Wx+Ib2lg3ITuVgeIhlEBGsdoq+
         qT9C5IYswN7vzTMTWSGEFxPYDQSC29b9g6rBEaefbp343HEAwxmCtvfs1vtTbX+bfPAM
         ZpCSwnHTGwFiXchnVbG10bOlTM4CHJ2Vk/c+31H8Czn0CnwuGFsFFkYOz6gGm6tZ7cKX
         u30YcXZUkpwxLYlyPisV8z5125ZZpO1gujKeuE/qDEtA0cVnjKWtjtT33C1Xae7ml5R5
         HNVbCza19In/nlvuR66Mj754/rymiBCg6pQsz3kbDa5XEvud53ZooVkazPIHOefRrRkD
         aPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=3LxTUsWtAnugj+yiOaxg4TXl8GgTh7eQs5xZZAZRyaA=;
        b=A87vXx1+hBJED6EiCbUNVb3hxKqpE26iI1PYbQEkdwGcHksDXnLR3eGndUo4Fc4L5W
         CFsbuLcfMX0xWownEFwf4NRzvQgNqUhPb1eL3B+54WpNkY2BbxeWqvDVAbB32mIJvDSt
         yKjDHb6Ic8ezmj2vLSgo+TFjByR7zaVWoyiGmLLYr5WtXIydVbCYJ+Wtw0tMpszWMRQa
         onOMno9uS3mxgwSiefL380qgmHWZbWJD93sQfhs4uTbFU5nL10EmGAjag0KwEBaXHYM6
         VZWa7zS2CTC33Qh+5zRPxw2HKU3ArP6BFOTCgnGGRFhXvz7C5qWr70lS5065eF3gFvLt
         oADQ==
X-Gm-Message-State: APjAAAVptQYjCKtI5pFxhNkc3qzyBpsiXftl+6IFxNP1IPicv2/x9c30
        12M0yWkndaUc8i1eOtvGLdPUXg==
X-Google-Smtp-Source: APXvYqy9E6ZOEkePRxtojtiwEO+EjbEE02ROsyb8URo0GPFIwy6HHw/JCsCpPIGvuFGrE6NMB8zzuw==
X-Received: by 2002:a1c:e916:: with SMTP id q22mr6417579wmc.148.1556892572728;
        Fri, 03 May 2019 07:09:32 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a20sm4599865wrf.37.2019.05.03.07.09.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 07:09:31 -0700 (PDT)
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com> <1556880164-10689-14-git-send-email-jiong.wang@netronome.com> <20190503134118.GA5602@osiris>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v6 bpf-next 13/17] s390: bpf: eliminate zero extension code-gen
In-reply-to: <20190503134118.GA5602@osiris>
Date:   Fri, 03 May 2019 15:09:29 +0100
Message-ID: <87zho38w9y.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Heiko Carstens writes:

> On Fri, May 03, 2019 at 11:42:40AM +0100, Jiong Wang wrote:
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> ---
>>  arch/s390/net/bpf_jit_comp.c | 20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
>
> When sending patches which affect s390, could you please add Martin
> and me on cc to _all_ patches? We now received only the cover-letter
> plus one patch. It's always hard in such cirumstances to figure out if
> the code is doing the right thing.

OK, will do it next time.

Will just CC back-end maintainers on all patches including patches for the
other back-ends to make the information complete.

Regards,
Jiong

> Usually I end up looking up the missing patches within other mailing
> lists, however I haven't subscribed the bpf and netdev mailing lists.
>
> The extra e-mail volume because of being added to CC really doesn't
> matter at all.
