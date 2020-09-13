Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5171C267E1E
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 08:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgIMGN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 02:13:59 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:37865 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbgIMGNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 02:13:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A79E5536;
        Sun, 13 Sep 2020 02:13:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 13 Sep 2020 02:13:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=yaJXsUV1HEEKbJ1V767HrJVyGgM
        e4Ybrw0a4w7CPATE=; b=E1skuiwCPlgfLHIr6OtTPQ8IKumNYb/0AvKu8T7u0o9
        6b3blJ4tTlXxgBvTmZEBVr8CW6OBx5JXXd0Jk5cQBG/oZ4+EbngpqFYcnZwdk/fE
        VvxC7X5iLdye7LEIpc8PwWCd/v9kTg47M4qTimJBniPK8+jast3Wk+sxkxfcRiau
        iqZKe0hJADJXK6JT/HqsgmrmDma4tOKcCDf9yI9/ROBlknstsfd8yqe+LBnxhWOc
        L2uSnpJgmByLF01iruZG87dxxWr1NsEJ1USdy3jmEJWbeTpkUhrOqJbzwqSHK+wV
        Arkk6Pu4UJaiMdmZUo6/5sI+BOrL9BQnXzF2zp10EEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yaJXsU
        V1HEEKbJ1V767HrJVyGgMe4Ybrw0a4w7CPATE=; b=kz/oILbbB+xftc1yFOn9sd
        H9v0BY+2zf34ZNpHrZP55r24cvnczmYHh9nkfsN++uAtuwR3xA9vNIxOnZKwWOxQ
        UQrt5mBGXyyHBQJTlXSEhsAoIKpBZZbt7T//QaQDU5+2QJXx2Qpj8u9xKforqTgS
        zbTUNzBiQDTVwgLs/211ZjR7mEgl+Hrx7pCUPQAkRxC2XJGV8tcttjemgbIS65+3
        /ORnmqrdzFshhWBt7u8YMeszY+20uA2yzFj1kwGVGCXHEHFPIiP/AHqTwiCQ0iz8
        1AaFLlTBLLAD3cp+TeAHDdmXR+wvn3JikxG6lhRptd7gOVS1V2aZCJNoTbWfegaw
        ==
X-ME-Sender: <xms:oLhdX5eBmVbUi_DzpB0eyQImEVErySZE2HPTSCjb3YYOaNsZZMLw6g>
    <xme:oLhdX3Pz83pM-1VaaJqSrhCM3i8nnmkBebQUAIYn_dE-CvQgLr_cmATyaQtPu3A5M
    WsJTa0Nmer3xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeivddguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:oLhdXyhS_KWEkERCXah7dwQ9_vonUVF7soCVvU2KcU_Y2Gl3a_vVuQ>
    <xmx:oLhdXy9XAhAmiW-3kRjuxWAQkecAAC1-kwpGkFIBEAubwWm1y4f0fg>
    <xmx:oLhdX1sd60jzE4oG7_oUZb5bMQ5Pjrurz8uvW6ImglgGvNXwET082w>
    <xmx:obhdX_Kozlg_M3C63EuY1yjl77GCuDozlC6hI46BTBnaZh9wUzG-NQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94C54328005D;
        Sun, 13 Sep 2020 02:13:52 -0400 (EDT)
Date:   Sun, 13 Sep 2020 08:13:51 +0200
From:   Greg KH <greg@kroah.com>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [Linux-kernel-mentees] [PATCH] net: fix uninit value error in
 __sys_sendmmsg
Message-ID: <20200913061351.GA585618@kroah.com>
References: <20200913055639.15639-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200913055639.15639-1-anant.thazhemadam@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 11:26:39AM +0530, Anant Thazhemadam wrote:
> The crash report showed that there was a local variable;
> 
> ----iovstack.i@__sys_sendmmsg created at:
>  ___sys_sendmsg net/socket.c:2388 [inline]
>  __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480
>  
>  that was left uninitialized.
> 
> The contents of iovstack are of interest, since the respective pointer
> is passed down as an argument to sendmsg_copy_msghdr as well.
> Initializing this contents of this stack prevents this bug from happening.
> 
> Since the memory that was initialized is freed at the end of the function
> call, memory leaks are not likely to be an issue.
> 
> syzbot seems to have triggered this error by passing an array of 0's as
> a parameter while making the initial system call.
> 
> Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
> Tested-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> ---
>  net/socket.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 0c0144604f81..d74443dfd73b 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2396,6 +2396,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
>  {
>  	struct sockaddr_storage address;
>  	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
> +	memset(iov, 0, UIO_FASTIOV);
>  	ssize_t err;
>  
>  	msg_sys->msg_name = &address;

I don't think you built this code change, otherwise you would have seen
that it adds a build warning to the system, right?

:(
