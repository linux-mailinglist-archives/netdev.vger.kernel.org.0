Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA162607FE
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 03:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgIHBWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 21:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbgIHBWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 21:22:42 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA19C061573;
        Mon,  7 Sep 2020 18:22:42 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h4so15406728ioe.5;
        Mon, 07 Sep 2020 18:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GYsBegW1E1w/duSqDumQ/6BnVkxD+sj7KRg+kol7Kug=;
        b=l5oEidU4eqtXGLWGLe1fzYnlCUDss0wiSthgavfD3Ks/2ByU6oI+lRZfV6wcmbMaIm
         zpPJtrZOHi9kheoXQrloUsnaXWl2XWIusXpAwukjvo4YoBvF68JZcxjgCgLUBTknPcRW
         oZq7D8hBdTJqzaG/mYESCHT1WpGMw7+mnu/AtV8NrT1rcd7uKbCL14+oI0dsKgTgxZ+U
         uEh97oUWAXeyY33QnNjR6dTrEQwQ6c9B/3emFNKb765aCWWsXzChz1Ompoa68g0TcCA5
         WDb7j/BiAUKKIXWFy7uLVUCwPiDqfLlDJmpiJjry46zFUm+0DXaVJ4aSzDArF/6HxhM/
         0wMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GYsBegW1E1w/duSqDumQ/6BnVkxD+sj7KRg+kol7Kug=;
        b=c8sf04au4W3mQalZcs+HdE7Rp5JtqfcKKRZG/CMlzdkopkb7MMGhNurWV6Rvv5sM9F
         9Pot5Kmjbk/l+X7xmQZrJZF0wgiULgzaBS6/puXJDIo7gUvclpHqnpD+9BjNevMSf9So
         r7v7YXNw91nafqrtq45HZKpW86nrscv4lLIEL623x451s6hkEMy0PCXsz5622RvPsOo3
         I60ZuZovCcAuuQ3ByQS6jMz/22wJ2thm65IFU7MjVVrn4sWnwE61oN0qgLueUEq5/vTT
         L/63ByLc2q7uocI4nZtuaB+gA/NSmgAGAzGWwDVQ09bxybLIekbkbC+B9NBbkH+mx+qJ
         Lesg==
X-Gm-Message-State: AOAM532Il2eXN9HbLFuhB8fBNjL1IlYYq7a/WZ/7KNeDF7cGPxyP0nPe
        /m1gWWyiE3rcAsO6jG2RrZg=
X-Google-Smtp-Source: ABdhPJwERJE2LQcnaY1cCja1hcI+xA8jnnTh2yEeIvsOumlVGQ+OPL6svAhcQHGsH+B5Gxm2xduyNA==
X-Received: by 2002:a05:6638:2a6:: with SMTP id d6mr10971376jaq.132.1599528161672;
        Mon, 07 Sep 2020 18:22:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:55f5:1bb7:a67a:a2c6])
        by smtp.googlemail.com with ESMTPSA id m15sm2006038iow.9.2020.09.07.18.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 18:22:40 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 1/9] xdp: introduce mb in xdp_buff/xdp_frame
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <1e8e82f72e46264b7a7a1ac704d24e163ebed100.1599165031.git.lorenzo@kernel.org>
 <20200904010705.jm6dnuyj3oq4cpjd@ast-mbp.dhcp.thefacebook.com>
 <20200904091939.069592e4@carbon>
 <1c3e478c-5000-1726-6ce9-9b0a3ccfe1e5@gmail.com>
 <20200904175946.6be0f565@carbon>
 <107260d3-1fea-b582-84d3-2d092f3112b1@gmail.com>
 <20200907200245.0cdb63f1@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <51b88537-877a-c6bb-b4fb-0d629f37c0e6@gmail.com>
Date:   Mon, 7 Sep 2020 19:22:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907200245.0cdb63f1@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/20 12:02 PM, Jesper Dangaard Brouer wrote:
> 
>> ok, is there any alignment requirement? can frame_sz be number of 32-bit
>> words? I believe bit shifts are cheap.
> 
> No that is not possible, because some drivers and generic-XDP have a
> fully dynamic frame_sz.
> 

frame_sz represents allocated memory right? What is the real range that
needs to be supported for frame_sz? Surely there is some upper limit,
and I thought it was 64kB.

Allocated memory will not be on an odd number, so fair to assume at a
minimum it is a multiple of 2. correct? At a minimum we should be able
to shift frame_sz by 1 which now covers 64kB in a u16.
