Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A2390688
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 19:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfHPROK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 13:14:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35496 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfHPROJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 13:14:09 -0400
Received: by mail-pf1-f195.google.com with SMTP id d85so3446143pfd.2
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 10:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x4NjyU4fXZSGsPyYUIJF9/drwTFSoMg/JfJZiqgHnYg=;
        b=C86cAihN7r/vHRvWRAN2jyr39Yn/sFzZ4CwIXENJQLP9+r14bozL3ibEMOfZJbcPCt
         4f4PswVzPAYgA6DYO6Gqar0hmDB3yCDAXXMb+A0K9fMvlatBDuiW4sR2rFCH2N/r82BW
         aLjynKfDmVNmCtE/CS6V/OlI9jWLZ4SPSmsF1CV3rI9DVYFtwMCAnJfhSI/gZq1NXRaz
         p6Nq77YaoeO0u+qBoO+uuOZiSDJqtAbj2HSPOxoE81YWWuV23NWOCGXJ2Lj/2auLuwSk
         WpT+IdphbdxvAxq+lQbeGlhi+mgFkA0DzjwTX2B0OkiNPoVosDGb277Dr7em86QfEzsn
         VVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x4NjyU4fXZSGsPyYUIJF9/drwTFSoMg/JfJZiqgHnYg=;
        b=FEPZfUfP+r15vgWNorQsOYLhzh5ZXZ/RtSyaNDHk5PvxBA/VC46XYH0dvTcWhf2p3e
         7UOr930VPno7nTjipg5jcQlAv632LqBH4fnARj7ile75J6KIHIpFq+KgB9G+qT8ovZXZ
         pGeuZU5xz4sFNBuvs7FHvwzdd2KGIqJ/3tKOINFvFkogKKOgvMBiiQJVkEVQ/6wJHEat
         c0LQMl9JWR2ZT7Pr5DJuDnp2JHwqdwkWGx5zuWkcmdY/vBGHxf0gCTfemd0x67UxiKtc
         juhKuPLPpUyaRxeaqpmBrrEIMQDjj4wPlF9dj359sQI5r3gigs3x8zphrtMRfbV19R0P
         0oaA==
X-Gm-Message-State: APjAAAWO5q0q8RWl6FsEgKb/sLgnd9MJZiGjCcqy3mTtDEsBOFBKxvlM
        kstkKodiO4n0anHQ8Wtq3b/IZA==
X-Google-Smtp-Source: APXvYqxZPscuoo6KAJ0cqnAfVzVy4gQnogE7MGUFSeUsf/4/qi0gl1VPViCMOyKT2S9c7ouPVbp/BA==
X-Received: by 2002:a63:947:: with SMTP id 68mr124897pgj.212.1565975648853;
        Fri, 16 Aug 2019 10:14:08 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id w11sm5378793pjr.15.2019.08.16.10.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 10:14:08 -0700 (PDT)
Date:   Fri, 16 Aug 2019 10:14:07 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [bpf-next,v2] selftests/bpf: fix race in test_tcp_rtt test
Message-ID: <20190816171407.GS2820@mini-arch>
References: <20190816170825.22500-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816170825.22500-1-ppenkov.kernel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/16, Petar Penkov wrote:
> From: Petar Penkov <ppenkov@google.com>
> 
> There is a race in this test between receiving the ACK for the
> single-byte packet sent in the test, and reading the values from the
> map.
> 
> This patch fixes this by having the client wait until there are no more
> unacknowledged packets.
Reviewed-by: Stanislav Fomichev <sdf@google.com>

Thanks!
> 
> Before:
> for i in {1..1000}; do ../net/in_netns.sh ./test_tcp_rtt; \
> done | grep -c PASSED
> < trimmed error messages >
> 993
> 
> After:
> for i in {1..10000}; do ../net/in_netns.sh ./test_tcp_rtt; \
> done | grep -c PASSED
> 10000
> 
> Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
> Signed-off-by: Petar Penkov <ppenkov@google.com>
> ---
>  tools/testing/selftests/bpf/test_tcp_rtt.c | 31 ++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/test_tcp_rtt.c b/tools/testing/selftests/bpf/test_tcp_rtt.c
> index 90c3862f74a8..93916a69823e 100644
> --- a/tools/testing/selftests/bpf/test_tcp_rtt.c
> +++ b/tools/testing/selftests/bpf/test_tcp_rtt.c
> @@ -6,6 +6,7 @@
>  #include <sys/types.h>
>  #include <sys/socket.h>
>  #include <netinet/in.h>
> +#include <netinet/tcp.h>
>  #include <pthread.h>
>  
>  #include <linux/filter.h>
> @@ -34,6 +35,30 @@ static void send_byte(int fd)
>  		error(1, errno, "Failed to send single byte");
>  }
>  
> +static int wait_for_ack(int fd, int retries)
> +{
> +	struct tcp_info info;
> +	socklen_t optlen;
> +	int i, err;
> +
> +	for (i = 0; i < retries; i++) {
> +		optlen = sizeof(info);
> +		err = getsockopt(fd, SOL_TCP, TCP_INFO, &info, &optlen);
> +		if (err < 0) {
> +			log_err("Failed to lookup TCP stats");
> +			return err;
> +		}
> +
> +		if (info.tcpi_unacked == 0)
> +			return 0;
> +
> +		usleep(10);
> +	}
> +
> +	log_err("Did not receive ACK");
> +	return -1;
> +}
> +
>  static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
>  		     __u32 dsack_dups, __u32 delivered, __u32 delivered_ce,
>  		     __u32 icsk_retransmits)
> @@ -149,6 +174,11 @@ static int run_test(int cgroup_fd, int server_fd)
>  			 /*icsk_retransmits=*/0);
>  
>  	send_byte(client_fd);
> +	if (wait_for_ack(client_fd, 100) < 0) {
> +		err = -1;
> +		goto close_client_fd;
> +	}
> +
>  
>  	err += verify_sk(map_fd, client_fd, "first payload byte",
>  			 /*invoked=*/2,
> @@ -157,6 +187,7 @@ static int run_test(int cgroup_fd, int server_fd)
>  			 /*delivered_ce=*/0,
>  			 /*icsk_retransmits=*/0);
>  
> +close_client_fd:
>  	close(client_fd);
>  
>  close_bpf_object:
> -- 
> 2.23.0.rc1.153.gdeed80330f-goog
> 
