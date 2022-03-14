Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96E34D8AFE
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbiCNRn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiCNRn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:43:56 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6E56151
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 10:42:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fs4-20020a17090af28400b001bf5624c0aaso15400436pjb.0
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 10:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eAlsB5oNEYsER7jPWoA72QjRxXZtYemLvQqqOj41w8g=;
        b=UxNgPrHrlJKADdwlA8u874Q1Bry/4tC8S8vYRetLSi4iCzekGEmfXiwmvLjaELUvei
         HSefhg3oySNEFjaMLm1iZ4A6bsXQdfO4gogNA0V6bxCBZhCMBL4VS+fLToWXnI1T+NdP
         QJiVLeopiuaEIjDn/dNYTEwpdwmKUouPZk6hW4Qo6G94PacD57MuD18aTOAHS0zmgF1F
         TUhjbkfgrlTDPcyaTq9AuHJ5Mh2myd1ct3aWJ6f9q85YRAA48EdKieD0CUfrSyrs3rbC
         1OJgzwvi0QLWcWUDz4YAU9k7Bco1TqlTBvb24KD8DSQSW6zUxHTlTdjp2PkgrfE4CAjO
         7yGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eAlsB5oNEYsER7jPWoA72QjRxXZtYemLvQqqOj41w8g=;
        b=dXsNLFgSZ20MxKBpYIOlMb8l8c7gBKX8voQYMZj5uERsxAbQb/q08KKT/LoJJk1K9g
         sHh/WKO8KRUqVVg8b4ItHJgMxozZR2zXwHnUzp3AfzHKr1ajZRz5P4FCALS4OFFbygRC
         QM/jKh1UDC+M21sc4YFRMln/Q1SU0k09YTfcj5LeoTc+gorIbq8q7h128v8yt+EhWWrc
         UqHwwSRyzHkivjLlGhF+QBs/aMJntw+T3koNv7wd4CZirq8qTqsj+tvx+ddS8RJeAazM
         NHRjfY57y0Rqs5pTRs1ihbtFRYgRbYL4CbRew0/ETQbERFZ5j8jRB5knk1aihzOR3YfX
         yOXg==
X-Gm-Message-State: AOAM533pCbaw0QEPj95VSvKGJfzgBUUl9cyAo84TKcSz4QI0q2hJ7D+/
        aTi/bWIRoc+ZkAVTBFxfPoI=
X-Google-Smtp-Source: ABdhPJw1hGVJs/DkUF8oMFBAVYSL9AiuhAM2WGCdu869LbPIKN47jz1EpMQ/EhWT9/4cd8EK71KaGg==
X-Received: by 2002:a17:90b:240e:b0:1b9:2963:d5a1 with SMTP id nr14-20020a17090b240e00b001b92963d5a1mr279369pjb.227.1647279765121;
        Mon, 14 Mar 2022 10:42:45 -0700 (PDT)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m12-20020a17090a414c00b001bf6d88870csm89992pjg.55.2022.03.14.10.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 10:42:44 -0700 (PDT)
Message-ID: <bb446581-6eaf-3b61-1e5d-07d629c77831@gmail.com>
Date:   Mon, 14 Mar 2022 10:42:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net] af_unix: Support POLLPRI for OOB.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rao Shoaib <Rao.Shoaib@oracle.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220314052110.53634-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220314052110.53634-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/13/22 22:21, Kuniyuki Iwashima wrote:
> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
> piece.
>
> In the selftest, normal datagrams are sent followed by OOB data, so this
> commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first test
> case.
>
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>   net/unix/af_unix.c                                  | 2 ++
>   tools/testing/selftests/net/af_unix/test_unix_oob.c | 6 +++---
>   2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index c19569819866..711d21b1c3e1 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -3139,6 +3139,8 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
>   		mask |= EPOLLIN | EPOLLRDNORM;
>   	if (sk_is_readable(sk))
>   		mask |= EPOLLIN | EPOLLRDNORM;
> +	if (unix_sk(sk)->oob_skb)
> +		mask |= EPOLLPRI;


This adds another data-race, maybe add something to avoid another syzbot 
report ?


>   
>   	/* Connection-based need to check for termination and startup */
>   	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
> diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c b/tools/testing/selftests/net/af_unix/test_unix_oob.c
> index 3dece8b29253..b57e91e1c3f2 100644
> --- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
> +++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
> @@ -218,10 +218,10 @@ main(int argc, char **argv)
>   
>   	/* Test 1:
>   	 * veriyf that SIGURG is
> -	 * delivered and 63 bytes are
> -	 * read and oob is '@'
> +	 * delivered, 63 bytes are
> +	 * read, oob is '@', and POLLPRI works.
>   	 */
> -	wait_for_data(pfd, POLLIN | POLLPRI);
> +	wait_for_data(pfd, POLLPRI);
>   	read_oob(pfd, &oob);
>   	len = read_data(pfd, buf, 1024);
>   	if (!signal_recvd || len != 63 || oob != '@') {
