Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72E64DD1C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 23:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfFTV4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 17:56:32 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:32987 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFTV4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 17:56:32 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so3051687qkc.0
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 14:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/qT8+w13sh5bxkSQag4fh6UhgmcT4J7HP+qFcMaHogQ=;
        b=Vb1GIfyBKvrb79uXZDeac7rN+yGMmk3N0wBT0FHCODFJZKdCjO72lZxMfHUHauloqj
         sJeOkZeU6PrsElYTkjVwNp8nejxYTTnexlaKLzx9fH7cJPtfgVPPgj5RpRl1Amuw33F+
         Td9oaM/qzq5xXHG4DtAoRVAbrXSxCyyWC5x+iX9Y2xI31NWFZgpzVI9rF4Ny799KGAsi
         b6p2yhuT9xaMgCjfRqt9qqWpEZ6LxqNtXXJf8Zb7wcikqb7cRmd0zm1AEFsJU1B/aRl3
         8xS5CbmZAUPczMH+D2HbEWhccjoXjTyESGKyGu15uInq0DZLlJ22BB3rUvdHLpEW1U1K
         M5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/qT8+w13sh5bxkSQag4fh6UhgmcT4J7HP+qFcMaHogQ=;
        b=Dl9meVrVv7vbl4TebbgjTpXOzOoci1TaX1iKjbUsZ9UWp/YBzHk3LMWeLqzrtXbe3b
         4hm9c0HdgzVsITiFWugle8yO7uy3ozv/gZT5wiMmOYwLp92ONmEakQKKQRnGU3b+mnSI
         1o7R/gph7o4m0o3sPb1pUBu1TUnXfbDWqFM5mIgC8ipVeJ/xlcEgUDv1LskQnShPhpdy
         vXhNWKCjE2SV9zp0VWQ36Uf5urW1cdTfruUKtYGuDRLkpV7Lr/OSBVYtWuXsFsECbZn3
         JKC8ZbjVB6pK2uEb06yCuRYBx8CjN1F8j98SzwuUFF6eK6HxVmMNcDpjrlQmVBVln/cw
         9c4g==
X-Gm-Message-State: APjAAAV2VGMLS/svGJRpv2ATEOUH1GPLBNi4nZMj2T2TzC4yDShrnnJj
        IAEJnSsS5JUkVYvCg/QZmkA=
X-Google-Smtp-Source: APXvYqx/YADWsc2H55VU4Ggqmkj+zGgGpvxIfx+TVi7RM7RN1zxi7sJuS1W5UmH+RYMCs5afvy9Ikw==
X-Received: by 2002:ae9:f209:: with SMTP id m9mr20277705qkg.251.1561067791225;
        Thu, 20 Jun 2019 14:56:31 -0700 (PDT)
Received: from [10.246.221.134] ([50.234.174.228])
        by smtp.gmail.com with ESMTPSA id d17sm339727qtp.84.2019.06.20.14.56.28
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 14:56:29 -0700 (PDT)
Subject: Re: [PATCH net-next v4 1/7] igb: clear out tstamp after sending the
 packet
To:     "Patel, Vedang" <vedang.patel@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
References: <1560966016-28254-1-git-send-email-vedang.patel@intel.com>
 <1560966016-28254-2-git-send-email-vedang.patel@intel.com>
 <d6655497-5246-c24e-de35-fc6acdad0bf1@gmail.com>
 <A1A5CF42-A7D4-4DC4-9D57-ED0340B04A6F@intel.com>
 <99e834ed-1c78-d35c-84dc-511d377284a1@gmail.com>
 <D1A9515C-D317-40F3-81A2-451F7228A853@intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <799b2d75-a60d-4d93-b8d7-c29442b73dce@gmail.com>
Date:   Thu, 20 Jun 2019 17:56:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <D1A9515C-D317-40F3-81A2-451F7228A853@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/20/19 1:32 PM, Patel, Vedang wrote:
> 

> Ahh.. that’s clearly a false statement. Skb->tstamp is cleared so
> that it is not interpreted as a software timestamp when trying to
> send the Hardware TX timestamp to the userspace. I will rephrase the
> commit message in the next version.
> 
> Some more details: The problem occurs when using the txtime-assist
> mode of taprio with packets which also request the hardware transmit
> timestamp (e.g. PTP packets). Whenever txtime-assist mode is set,
> taprio will assign a hardware transmit timestamp to all the packets
> (in skb->tstamp). PTP packets will also request the hardware transmit
> timestamp be sent to the userspace after packet is transmitted.
> 
> Whenever a new timestamp is detected by the driver (this work is done
> in igb_ptp_tx_work() which calls igb_ptp_tx_hwtstamps() in
> igb_ptp.c[1]), it will queue the timestamp in the ERR_QUEUE for the
> userspace to read. When the userspace is ready, it will issue a
> recvmsg() call to collect this timestamp. The problem is in this
> recvmsg() call. If the skb->tstamp is not cleared out, it will be
> interpreted as a software timestamp and the hardware tx timestamp
> will not be successfully sent to the userspace. Look at
> skb_is_swtx_tstamp() and the callee function __sock_recv_timestamp()
> in net/socket.c for more details.


That amount of details in the changelog would be really nice ;)


