Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4904B2F20
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 22:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344144AbiBKVM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 16:12:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiBKVM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 16:12:28 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1148ABFB;
        Fri, 11 Feb 2022 13:12:26 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id om7so9136213pjb.5;
        Fri, 11 Feb 2022 13:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=x8POYbCaaSySzHWe6l3CukXGIHLL9HE7GZC5/X1ii4E=;
        b=lfhtJAp6+k5GT93BneVzOju5Su5LQoUzD6eSwEt8GbSD25uuDKp17mHBNkdRAKcOjt
         IlFLNo152dSoS48KaqB+4sjPXLI5CBLXav/yzqQzLxJWBZKTMPo4pJOWaiVBgrqpHebQ
         I5uKx7SSF1evRkbRrNeWTO+t9xkDAfBZVTidyaAGoB2QzoTKaTT8zilX5wsekhNUMwtN
         GwpPL/tLG7CJnPhZE7Zodx2g+zQbAxQpcN8ML1mHzjuXHZ6dlTZcxjt8nqGoFbdrhevl
         2hYSeCGOa9wRWO8PPARJTBFNDul/9Hq3AzMmMmxySAF6GAfG/oKCkADkJoY3Pz0dpC1q
         nppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=x8POYbCaaSySzHWe6l3CukXGIHLL9HE7GZC5/X1ii4E=;
        b=TZ33arf6ZZNadIM8ri5QMtQRmD5T1YxLOStHXpi9emSdJn52dElE2jkjRWMlDigeYo
         NU2REeou/iCH1PyNC7fnRGLtNoJaz8LKLoiETiFNtRw3PSaWQ/ZnK5QagKx4g75NCS0o
         a2TqBZXe2aeIMSdMiD5S6FDZjyNR56X5+WFNsaU428k1pDD+0jq3fqnkA9TpdLIYSMC0
         stZdEFlp7eZzl7rEwej97SPNNGEajmVgw2TZbi8j9Ihw0PZ/G89CAp+Zmv1Mq2HtBsKj
         oDuqjpRDFBcIQuum932gFO0EXAVD7ix+8JnbZ1KKwNBFfHOQvyvmslhzxcmeXX1GqqTU
         SjTw==
X-Gm-Message-State: AOAM532mtJB6u67QpLmR5KD4e2Qdb6j8yl/4n449sf9JZLCAvFASYXxo
        VV7+x6SYSndss1BCC/Y8kPE=
X-Google-Smtp-Source: ABdhPJw9sezByfs1qcpJLn9zs0tSoH7u9M3WXlRpBtfxJWeAvWqovxCBs03Z0wNZOvkCPDJklJn89Q==
X-Received: by 2002:a17:90b:3509:: with SMTP id ls9mr2269501pjb.119.1644613945459;
        Fri, 11 Feb 2022 13:12:25 -0800 (PST)
Received: from localhost ([47.9.2.133])
        by smtp.gmail.com with ESMTPSA id f2sm27004637pfj.6.2022.02.11.13.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 13:12:25 -0800 (PST)
Date:   Sat, 12 Feb 2022 02:42:21 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zhiqian Guan <zhguan@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] libbpf: Use dynamically allocated buffer when
 receiving netlink messages
Message-ID: <20220211211221.wc5ouk32krtlxhlr@apollo.legion>
References: <20220211195101.591642-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220211195101.591642-1-toke@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 12, 2022 at 01:21:00AM IST, Toke Høiland-Jørgensen wrote:
> When receiving netlink messages, libbpf was using a statically allocated
> stack buffer of 4k bytes. This happened to work fine on systems with a 4k
> page size, but on systems with larger page sizes it can lead to truncated
> messages. The user-visible impact of this was that libbpf would insist no
> XDP program was attached to some interfaces because that bit of the netlink
> message got chopped off.
>
> Fix this by switching to a dynamically allocated buffer; we borrow the
> approach from iproute2 of using recvmsg() with MSG_PEEK|MSG_TRUNC to get
> the actual size of the pending message before receiving it, adjusting the
> buffer as necessary. While we're at it, also add retries on interrupted
> system calls around the recvmsg() call.
>
> Reported-by: Zhiqian Guan <zhguan@redhat.com>
> Fixes: 8bbb77b7c7a2 ("libbpf: Add various netlink helpers")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---

Thanks for the fix!

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

>  tools/lib/bpf/netlink.c | 55 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 52 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index c39c37f99d5c..9a6e95206bf0 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -87,22 +87,70 @@ enum {
>  	NL_DONE,
>  };
>
> +static int __libbpf_netlink_recvmsg(int sock, struct msghdr *mhdr, int flags)
> +{
> +	int len;
> +
> +	do {
> +		len = recvmsg(sock, mhdr, flags);
> +	} while (len < 0 && (errno == EINTR || errno == EAGAIN));
> +
> +	if (len < 0)
> +		return -errno;
> +	return len;
> +}
> +
> +static int libbpf_netlink_recvmsg(int sock, struct msghdr *mhdr, char **buf)
> +{
> +	struct iovec *iov = mhdr->msg_iov;
> +	void *nbuf;
> +	int len;
> +
> +	len = __libbpf_netlink_recvmsg(sock, mhdr, MSG_PEEK | MSG_TRUNC);
> +	if (len < 0)
> +		return len;
> +
> +	if (len < 4096)
> +		len = 4096;
> +
> +	if (len > iov->iov_len) {
> +		nbuf = realloc(iov->iov_base, len);
> +		if (!nbuf) {
> +			free(iov->iov_base);
> +			return -ENOMEM;
> +		}
> +		iov->iov_base = nbuf;
> +		iov->iov_len = len;
> +	}
> +
> +	len = __libbpf_netlink_recvmsg(sock, mhdr, 0);
> +	if (len > 0)
> +		*buf = iov->iov_base;
> +	return len;
> +}
> +
>  static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
>  			       __dump_nlmsg_t _fn, libbpf_dump_nlmsg_t fn,
>  			       void *cookie)
>  {
> +	struct iovec iov = {};
> +	struct msghdr mhdr = {
> +		.msg_iov = &iov,
> +		.msg_iovlen = 1,
> +	};
>  	bool multipart = true;
>  	struct nlmsgerr *err;
>  	struct nlmsghdr *nh;
> -	char buf[4096];
>  	int len, ret;
> +	char *buf;
> +
>
>  	while (multipart) {
>  start:
>  		multipart = false;
> -		len = recv(sock, buf, sizeof(buf), 0);
> +		len = libbpf_netlink_recvmsg(sock, &mhdr, &buf);
>  		if (len < 0) {
> -			ret = -errno;
> +			ret = len;
>  			goto done;
>  		}
>
> @@ -151,6 +199,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
>  	}
>  	ret = 0;
>  done:
> +	free(iov.iov_base);
>  	return ret;
>  }
>
> --
> 2.35.1
>

--
Kartikeya
