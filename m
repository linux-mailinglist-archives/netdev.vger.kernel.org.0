Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0F811925E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLJUn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:43:27 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39909 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfLJUn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:43:27 -0500
Received: by mail-pj1-f66.google.com with SMTP id v93so7860454pjb.6
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 12:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oscuAw5vAE51n3TxNTO2T3duoHxKljGjiqEM2pxbrAE=;
        b=EqaG3Zgh66B2ZlBqDiUF9UNe4O9r2Sra4GkvhJEOhxiWeiMaLTVvDoZipPCmw3xAlR
         L1irjKAc0/Dan9MGX3t3MH+lU5vWvTyOnp8eGzag1CI4S6IYqdhohnVy9SzUtxmVd2Vd
         vK+uG7i87wjhTJs7rPjG4/8k/FcdsP8s1OKr0bbpL+xL/p133xnwlDpzAfnbLWDpNXvA
         GDUFu7KNECeH0B7iI+pUGbG55VG5TAD1tEbTT+WTmOziFiFah4dHeLuSn5uQ/4wPK+A6
         rrztK7HmvbTulXHP69dRttHZHgE3UlM7g3Fy7Ju8ensIDDSkLG0fTmh+XeX7ScYe7ikN
         g4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oscuAw5vAE51n3TxNTO2T3duoHxKljGjiqEM2pxbrAE=;
        b=iA4wruOc1VC0wELrZ8dfwbe3Dibps7b35+3jxD6eRwX1pka4lUWSuXEw36EbaZtyzN
         APHmwyefZITSn0XLeiyOCffCC0+OrO70a9JUEGQa4YMU5RFmr8SOWvWHAfmOAxbrqBpt
         RRqRbupyn4Dym4tF4JufOWufLAJjzzJJnGivPZv+t+NzbqP0cqL/nBCyv3Qz/rAednKP
         aYBWKbW35fk79aPjXxorR770hNRZ7LQarGUfOTXjlSnE0UtkUJq5QVxsxhp825wOBPju
         WjMY7X3AilBgi7arcNauc2o4jbYfsH7iK4UsKAipYczt1I+DgtsqlOmDsasTlG4RGdAa
         nDMQ==
X-Gm-Message-State: APjAAAUB0qJk8pbvE2WCa2Rw3oQls3qFfd5dUEu35hQAEoiP1kE4h27w
        n08yCf6cZ3b1QH5fqIVALhB6IWUZ2GEehA==
X-Google-Smtp-Source: APXvYqzKu9FMBGbFyZa2IS3LDGGu1YYA3zjt1iFIfTrfgsVFl8Iv7l0MSgniv67vnvchLOUCY13UiQ==
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr7670914pjb.113.1576010606237;
        Tue, 10 Dec 2019 12:43:26 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id r20sm4535871pgu.89.2019.12.10.12.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 12:43:25 -0800 (PST)
Subject: Re: [PATCH 10/11] net: make socket read/write_iter() honor
 IOCB_NOWAIT
To:     David Miller <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-11-axboe@kernel.dk>
 <20191210.113700.2038253518329326443.davem@davemloft.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5a1abbbe-2230-d3d8-839b-a1c7acb46bdb@kernel.dk>
Date:   Tue, 10 Dec 2019 13:43:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191210.113700.2038253518329326443.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 12:37 PM, David Miller wrote:
> From: Jens Axboe <axboe@kernel.dk>
> Date: Tue, 10 Dec 2019 08:57:41 -0700
> 
>> The socket read/write helpers only look at the file O_NONBLOCK. not
>> the iocb IOCB_NOWAIT flag. This breaks users like preadv2/pwritev2
>> and io_uring that rely on not having the file itself marked nonblocking,
>> but rather the iocb itself.
>>
>> Cc: David Miller <davem@davemloft.net>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> I guess this should be OK:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks for reviewing!

-- 
Jens Axboe

