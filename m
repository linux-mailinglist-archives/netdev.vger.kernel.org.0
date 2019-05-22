Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A257272C2
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbfEVXMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:12:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38725 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbfEVXMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:12:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id v11so2068670pgl.5
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iSR8c9EVVMV5FED+J4MEd80CoCczKyDqKguuCikzCt4=;
        b=bcRPv8SbXfnc3aWiBfcJjRixhyibAaJ7pTxpJpGNUkX0ndBLwk1bEUzGjbBqyI/n1V
         rWYzEdTMzleXOY980msJKO3cfh6rLyLQQ/m7FSaPQWk2WrywrcgC4Bi+P0zjKu7PPFRq
         Te8nfKbTGXhfcm4zlyTnXyvgkgoUDTNOFIrS0OssPvLA3RsbwwBvwf6pHKjVfwV8fUL+
         0V+R22DTTMSajQZ0IpREZ3aoOQ5au8IKdi5HpQRi/9zP4CI6H/F6SJf2JkrsjnZyNPVZ
         5rH68pV9Ex4i/PWW6zsXNui3rljvuS9Xs2yyTngEKSlEnyS6n6VuhRB2ykaTjpWZu1hR
         6G7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iSR8c9EVVMV5FED+J4MEd80CoCczKyDqKguuCikzCt4=;
        b=YNj7iiNw6etfXTO86+PMn8Dipp1io/Kr9hulbhUBkUTSGnasFm/FwCvlZc2jOi5K5L
         Zyxte5Z9ATUq7NIshRK1cs/ygEGDqz9BKDV2tMNRE4ji2lPB14Nt7XPdRGO6m5ARti/N
         iR9JZ/7gvuYS96x78OE2V0/2Qr0dmiO4BKkcGeB2IjZ0TEG6kLsAiALn9lZuiETQv8Dw
         xl+Cx0AJ3bZDljd7gt1JEHOdaRzob3qd2sASI+U1sN8H+nBS7rcs+Ezm2Y2WgFNA4169
         KRWemI7AbUz9wC5GwRAjr7gQLNoInzoj/RLxW9F80Jeq8yrajDxMUZBmFxbeaU8LWySa
         h67Q==
X-Gm-Message-State: APjAAAWQjSjhVmlyuJFsKHSLMBkDkBDe5aQrJsjuguiV3BN2R7PdBly9
        Yry3F3qTI+I1lTAgig9wyl1fQA==
X-Google-Smtp-Source: APXvYqw0G66fU17iP7/x8AK72WYbLavKcuIBrasq4pfVcqyBvDz8MrNsQRCdqX69PxcrookNV0zaUQ==
X-Received: by 2002:aa7:8d81:: with SMTP id i1mr71762713pfr.244.1558566752498;
        Wed, 22 May 2019 16:12:32 -0700 (PDT)
Received: from xps13.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 7sm7426438pfo.90.2019.05.22.16.12.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 16:12:32 -0700 (PDT)
Date:   Wed, 22 May 2019 16:12:30 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Sunil Muthuswamy <sunilmut@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] hv_sock: perf: Allow the socket buffer size
 options to influence the actual socket buffers
Message-ID: <20190522161230.7daf840c@xps13.lan>
In-Reply-To: <BN6PR21MB04652168EAE5D6D7D39BD4AAC0000@BN6PR21MB0465.namprd21.prod.outlook.com>
References: <BN6PR21MB04652168EAE5D6D7D39BD4AAC0000@BN6PR21MB0465.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 22:56:07 +0000
Sunil Muthuswamy <sunilmut@microsoft.com> wrote:

> Currently, the hv_sock buffer size is static and can't scale to the
> bandwidth requirements of the application. This change allows the
> applications to influence the socket buffer sizes using the SO_SNDBUF and
> the SO_RCVBUF socket options.
> 
> Few interesting points to note:
> 1. Since the VMBUS does not allow a resize operation of the ring size, the
> socket buffer size option should be set prior to establishing the
> connection for it to take effect.
> 2. Setting the socket option comes with the cost of that much memory being
> reserved/allocated by the kernel, for the lifetime of the connection.
> 
> Perf data:
> Total Data Transfer: 1GB
> Single threaded reader/writer
> Results below are summarized over 10 iterations.
> 
> Linux hvsocket writer + Windows hvsocket reader:
> |---------------------------------------------------------------------------------------------|
> |Packet size ->   |      128B       |       1KB       |       4KB       |        64KB         |
> |---------------------------------------------------------------------------------------------|
> |SO_SNDBUF size | |                 Throughput in MB/s (min/max/avg/median):                  |
> |               v |                                                                           |
> |---------------------------------------------------------------------------------------------|
> |      Default    | 109/118/114/116 | 636/774/701/700 | 435/507/480/476 |   410/491/462/470   |
> |      16KB       | 110/116/112/111 | 575/705/662/671 | 749/900/854/869 |   592/824/692/676   |
> |      32KB       | 108/120/115/115 | 703/823/767/772 | 718/878/850/866 | 1593/2124/2000/2085 |
> |      64KB       | 108/119/114/114 | 592/732/683/688 | 805/934/903/911 | 1784/1943/1862/1843 |
> |---------------------------------------------------------------------------------------------|
> 
> Windows hvsocket writer + Linux hvsocket reader:
> |---------------------------------------------------------------------------------------------|
> |Packet size ->   |     128B    |      1KB        |          4KB        |        64KB         |
> |---------------------------------------------------------------------------------------------|
> |SO_RCVBUF size | |               Throughput in MB/s (min/max/avg/median):                    |
> |               v |                                                                           |
> |---------------------------------------------------------------------------------------------|
> |      Default    | 69/82/75/73 | 313/343/333/336 |   418/477/446/445   |   659/701/676/678   |
> |      16KB       | 69/83/76/77 | 350/401/375/382 |   506/548/517/516   |   602/624/615/615   |
> |      32KB       | 62/83/73/73 | 471/529/496/494 |   830/1046/935/939  | 944/1180/1070/1100  |
> |      64KB       | 64/70/68/69 | 467/533/501/497 | 1260/1590/1430/1431 | 1605/1819/1670/1660 |
> |---------------------------------------------------------------------------------------------|
> 
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>

It looks like Exchange mangled you patch. It doesn't apply clean.


>  

