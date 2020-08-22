Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E200E24E4A0
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 04:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHVCJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 22:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgHVCJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 22:09:00 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D790FC061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 19:08:58 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id r11so1942986pfl.11
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 19:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YE5NL0xxCktGXHrl/qXnPFbwVF+i5b8N0lXLhv65orU=;
        b=i5flxlyR9co4wz7I9zo7ay+vcmwEhQ0MxRmdCZwH7KJqYoJ5ag8Z7hRflXTTyqHdh/
         IRkV15U4/jODVOJEZPHcbT30QDIurHuce2VDzIkAxmKFFt4QfnvfPZeqKQk4xXmypn9U
         CrHVNK6nycL7l5w15H3On4uXNy+g7W+5CaX0UoY63Bvb3aZYvpN/GFhsjBrgcOsguTE8
         ix8jpyy2uSZb/Jdsj1LtvGORu6T5kR4dCCnTsl19l5O1Lko0WHRO6LjSOqnInft0AChx
         GtEvlXxyDZK6hS1AO7+ar4oNy43JmcqG4IzjEA2cqoCnAvZhmNslASvZxfQcrcGmh3Qp
         yavA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YE5NL0xxCktGXHrl/qXnPFbwVF+i5b8N0lXLhv65orU=;
        b=sgRVxUSIjrq5NjtouVKJR/pHzp3yyLn+3XiTvpqEtRKiS8aHwJVByADxqDTv/hziD0
         fOrPdG/xIN5ZRfSSgQHEyDOXBbTBq0zH1bnVmdw2XisArauKWG9ybeKXsANSzE9Lyzjs
         eYTA23oZXFDvuQhlDHBDThYgeM1497mTDBCpWSQDc6amYTYbt99kUc9XDWmZogwz+kam
         HiuwCzwV2ca0gDQyBqyU6WF/cs7dsGtGvU7E2aoazz3RgD8qD+jLMYv+662e+UW70L5P
         N0mY/mlhc2v1st4zNwD68wSsuCkUO6QOjolUGaPLyadiCW7JXbLTmOEdHoXREOqE7P+w
         Ma+g==
X-Gm-Message-State: AOAM531rJW92PpbCj/o2Q5fyuS0yDGdjLXSA7XYgJKsRkfs9SXIfqOjM
        jotLiQI3ksksBkPGVj5iUvvfZg==
X-Google-Smtp-Source: ABdhPJyRRt3cF1Q32Hbm5fTOHTy2T6wf31H5/Liom87ZfQgrhLnCfuMFAwCw27J4q9wmZM0cOaxYDg==
X-Received: by 2002:aa7:8431:: with SMTP id q17mr4846302pfn.132.1598062137574;
        Fri, 21 Aug 2020 19:08:57 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 74sm3832696pfv.191.2020.08.21.19.08.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 19:08:56 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] io_uring: ignore POLLIN for recvmsg on
 MSG_ERRQUEUE
To:     Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Luke Hsiao <lukehsiao@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <9abca73b-de63-f69d-caff-ae3ed24854de@kernel.dk>
 <20200822020442.2677358-1-luke.w.hsiao@gmail.com>
 <20200822020442.2677358-2-luke.w.hsiao@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8a2dcf9a-7ccd-f28d-deb4-bda0a4a7a387@kernel.dk>
Date:   Fri, 21 Aug 2020 20:08:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200822020442.2677358-2-luke.w.hsiao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 8:04 PM, Luke Hsiao wrote:
> From: Luke Hsiao <lukehsiao@google.com>
> 
> Currently, io_uring's recvmsg subscribes to both POLLERR and POLLIN. In
> the context of TCP tx zero-copy, this is inefficient since we are only
> reading the error queue and not using recvmsg to read POLLIN responses.
> 
> This patch was tested by using a simple sending program to call recvmsg
> using io_uring with MSG_ERRQUEUE set and verifying with printks that the
> POLLIN is correctly unset when the msg flags are MSG_ERRQUEUE.

Sorry, one more minor thing to fix up:

> @@ -4932,6 +4934,11 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  		mask |= POLLIN | POLLRDNORM;
>  	if (def->pollout)
>  		mask |= POLLOUT | POLLWRNORM;
> +
> +	/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
> +	if (req->opcode == IORING_OP_RECVMSG && (sqe->msg_flags & MSG_ERRQUEUE))
> +		mask &= ~POLLIN;
> +

Don't pass in the sqe here, but use req->sr_msg.msg_flags for this check. This
is actually really important, as you don't want to re-read anything from the
sqe.

I'm actually surprised this one got past Jann :-)

> @@ -6146,7 +6153,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	 * doesn't support non-blocking read/write attempts
>  	 */
>  	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
> -		if (!io_arm_poll_handler(req)) {
> +		if (!io_arm_poll_handler(req, sqe)) {

Also means you can drop this part.

-- 
Jens Axboe

