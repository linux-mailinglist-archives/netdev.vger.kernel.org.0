Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4354A826C2
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfHEVXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:23:06 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38783 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbfHEVXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 17:23:06 -0400
Received: by mail-oi1-f193.google.com with SMTP id v186so63432857oie.5
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 14:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=jQHkpLF4nIn7p+6PQvZ1L0bXi0ScynIQq40ZyjudfPI=;
        b=YYfbmMYlCORFZ4wo/oXYWNgV8McAxCEivUK1bb2ovOHtGdkUICuvSvhOMt8rANCvzp
         oX/MwlojMxhdNwbMFlIH47tZ/D21M21hccn4vAfALbelOqXl5QUK68z/yLvGbz0E/0cO
         S8unIp1W92nGFLVrcBdp3avH7mw2En3Rn/iRc7Aci6Q2oeQZ2jKS2fDgWjS1jgwhjG1G
         ocWhCXtDbCfg2+k+cgh8Of8SVJ3QANM5tvWBaK1c3hfwYrJZeSH+dfJVPgBIHI/h3L3Z
         tqiKaVrdJuGjAuOvjVn94JlHpB1EZnwkQ9AleSA3uw+0UrVaSiDUQ92N1jrQnvazGL50
         h02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=jQHkpLF4nIn7p+6PQvZ1L0bXi0ScynIQq40ZyjudfPI=;
        b=hmD5QuLkell1CiW8jHccHH93K1tEHcgUUgYb5ePnYYCtrLq5OstoQGG/PeIpKU+AWf
         AeZAE8X40PzAdbK82jzQIq794jfXsF9AyutBH0kIpCLZ3u8TLF1yZBMWOYXl5jKSk9Pk
         Jny5gvEz09cMvo9OBKVXqHrQ723jWxRJSOFvvm3OTOYSsEkmC/nDEtLIuW47Kjpxmk2/
         iu3tCNxN8N2Zjjdvh6DM5Q+ycwVOdogtGiHH+Pf8ryM+iQs9KUlISiFCYsEgiNrdhh2W
         SfQspsb5ZPRG3jC6iq8rJ+osxTcA3A6KD37+gA92BB7eMNPlor/3cZldN1xFAryTroJR
         HSQQ==
X-Gm-Message-State: APjAAAUIgNva05MAX3qFDODabh3upf2kgC88uhNTlryZr1XM+Nu9tW+C
        WS1AiBuRSnGPYj5s7lXGZpo=
X-Google-Smtp-Source: APXvYqwLSBfCVd9oG/z90Rtsvv2PO5T3lg/KiSYAJN2Oz0M2SMdVSG3HPDfOVPniYsOFnhrJbJfeMA==
X-Received: by 2002:a02:1607:: with SMTP id a7mr379529jaa.123.1565040185521;
        Mon, 05 Aug 2019 14:23:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q22sm67544759ioj.56.2019.08.05.14.23.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 14:23:04 -0700 (PDT)
Date:   Mon, 05 Aug 2019 14:22:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     David Miller <davem@davemloft.net>, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net
Message-ID: <5d489e309917d_2482b0eabedc5bc3@john-XPS-13-9370.notmuch>
In-Reply-To: <20190805.131552.1289253403274923799.davem@davemloft.net>
References: <20190801213602.19634-1-jakub.kicinski@netronome.com>
 <20190805.131552.1289253403274923799.davem@davemloft.net>
Subject: Re: [PATCH net 1/2] net/tls: partially revert fix transition through
 disconnect with close
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Thu,  1 Aug 2019 14:36:01 -0700
> 
> > Looks like we were slightly overzealous with the shutdown()
> > cleanup. Even though the sock->sk_state can reach CLOSED again,
> > socket->state will not got back to SS_UNCONNECTED once
> > connections is ESTABLISHED. Meaning we will see EISCONN if
> > we try to reconnect, and EINVAL if we try to listen.
> > 
> > Only listen sockets can be shutdown() and reused, but since
> > ESTABLISHED sockets can never be re-connected() or used for
> > listen() we don't need to try to clean up the ULP state early.
> > 
> > Fixes: 32857cf57f92 ("net/tls: fix transition through disconnect with close")
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> 
> Applied and queued up for -stable.

Bit late but, I went back and ran some of the syzbot tests that
were failing before original series and most of my ktls+bpf tests
and everything seems in good shape now. There is still one issue
with crypto stack that I'll look at fixing now. Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Tested-by: John Fastabend <john.fastabend@gmail.com>
