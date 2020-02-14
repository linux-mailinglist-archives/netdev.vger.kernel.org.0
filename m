Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C04215D484
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 10:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgBNJRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 04:17:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20796 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728783AbgBNJRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 04:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581671833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MbvVsS80jyuIivaGxlNu0wESiZvUHG0f8K3W28JtwWg=;
        b=f9nAsk9kAV2bCSkzzoQBQLXFd6PnavpU7dfSA8cAIndiGcvcytYEZsADw3krqnIh7osufS
        8eyMmBVp7zlK6OtWrKzdOmr3sBK1IyYeyD+uuq0lJAG1I89x0lEmecbgO+XIshD1ebvhZA
        yQvKrmNpfBsCHXDXmXwZzI3USKoiO6U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-zD6B77mIPhGOOzfe8w-KAQ-1; Fri, 14 Feb 2020 04:17:08 -0500
X-MC-Unique: zD6B77mIPhGOOzfe8w-KAQ-1
Received: by mail-wr1-f71.google.com with SMTP id v17so3670517wrm.17
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 01:17:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MbvVsS80jyuIivaGxlNu0wESiZvUHG0f8K3W28JtwWg=;
        b=R7Ad3SUsCkVpJ5GlPm9NZg7NWh1jmzFzpCXUlEMDNklr4SMVxscHzdW71U/lc5ixMO
         gZ/TOMGSvQ9WM3m0s9MXooJFDR07agKAr0SpIPf8J6o0F6ffecnwSLaR2SpgmQUYxz7J
         Gkvh6euHFil6e+lvhB9aiEcPgEHIChVoOKjXvPqjBxHJ1OGbiCi8b5MdeZYiJzE8PCeR
         HcUM1JJtoDUTYt6JYQmfyn5mCSTYIeqeTZGHfBTb/B82wGXK5AUgk2FCP0xuqV2XDD//
         xpYbRA79dB+XgAfk9eqBZFv55IwSf0c7jw4uvew1PLx/5BOnIaN5JTzdrIuMuOtoJDTX
         X9+A==
X-Gm-Message-State: APjAAAUIAd0+4sk2obWPyUpypI82jq4TxA4MUXHyKdeQ31lk4WwU1B+0
        GbPN6jnfIqtbgz1EwlS8pidDhHTssIMhwxzswhZQ5rMDSzISaonDnwsBW/a7uZcZkIXP5NIDEgu
        vBAVeR494v3zZvKf5
X-Received: by 2002:adf:81c2:: with SMTP id 60mr2919331wra.8.1581671827336;
        Fri, 14 Feb 2020 01:17:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqzpFRkNkclzeAeIe/A9BF/qXa1lShiKMqp+dPFkyCAEq9fTSf4A/HWmff5rtOeQYVLDS7RTrQ==
X-Received: by 2002:adf:81c2:: with SMTP id 60mr2919302wra.8.1581671826984;
        Fri, 14 Feb 2020 01:17:06 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id w13sm6501906wru.38.2020.02.14.01.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 01:17:06 -0800 (PST)
Date:   Fri, 14 Feb 2020 10:17:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net v2] net: virtio_vsock: Enhance connection semantics
Message-ID: <20200214091704.f6cvbj7a5cwx725b@steredhat>
References: <38828afab4efd8f6b8b8c43501a5f164a2841990.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38828afab4efd8f6b8b8c43501a5f164a2841990.camel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastien,
the patch and the test look good to me!
I tested with virtio and VMCI transports and your test works great, thanks!

I suggest split the patch in two, one for the fix and one for the test.

Are you using git format-patch / git send-email?
I fought a little bit to apply it because of CRLF ;-)

Thanks,
Stefano

On Thu, Feb 13, 2020 at 06:31:50PM +0000, Boeuf, Sebastien wrote:
> From d59100b8ab91289d9eac80d0e2a7ae9b0e19fe9c Mon Sep 17 00:00:00 2001
> From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Date: Thu, 13 Feb 2020 08:50:38 +0100
> Subject: [PATCH] net: virtio_vsock: Enhance connection semantics
> 
> Whenever the vsock backend on the host sends a packet through the RX
> queue, it expects an answer on the TX queue. Unfortunately, there is one
> case where the host side will hang waiting for the answer and might
> effectively never recover if no timeout mechanism was implemented.
> 
> This issue happens when the guest side starts binding to the socket,
> which insert a new bound socket into the list of already bound sockets.
> At this time, we expect the guest to also start listening, which will
> trigger the sk_state to move from TCP_CLOSE to TCP_LISTEN. The problem
> occurs if the host side queued a RX packet and triggered an interrupt
> right between the end of the binding process and the beginning of the
> listening process. In this specific case, the function processing the
> packet virtio_transport_recv_pkt() will find a bound socket, which means
> it will hit the switch statement checking for the sk_state, but the
> state won't be changed into TCP_LISTEN yet, which leads the code to pick
> the default statement. This default statement will only free the buffer,
> while it should also respond to the host side, by sending a packet on
> its TX queue.
> 
> In order to simply fix this unfortunate chain of events, it is important
> that in case the default statement is entered, and because at this stage
> we know the host side is waiting for an answer, we must send back a
> packet containing the operation VIRTIO_VSOCK_OP_RST.
> 
> One could say that a proper timeout mechanism on the host side will be
> enough to avoid the backend to hang. But the point of this patch is to
> ensure the normal use case will be provided with proper responsiveness
> when it comes to establishing the connection.
> 
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c |  1 +
>  tools/testing/vsock/vsock_test.c        | 77 +++++++++++++++++++++++++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index d9f0c9c5425a..2f696124bab6 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1153,6 +1153,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>  		virtio_transport_free_pkt(pkt);
>  		break;
>  	default:
> +		(void)virtio_transport_reset_no_sock(t, pkt);
>  		virtio_transport_free_pkt(pkt);
>  		break;
>  	}
> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> index 1d8b93f1af31..5a4fb80fa832 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -55,6 +55,78 @@ static void test_stream_connection_reset(const struct test_opts *opts)
>  	close(fd);
>  }
>  
> +static void test_stream_bind_only_client(const struct test_opts *opts)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_vm svm;
> +	} addr = {
> +		.svm = {
> +			.svm_family = AF_VSOCK,
> +			.svm_port = 1234,
> +			.svm_cid = opts->peer_cid,
> +		},
> +	};
> +	int ret;
> +	int fd;
> +
> +	/* Wait for the server to be ready */
> +	control_expectln("BIND");
> +
> +	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
> +
> +	timeout_begin(TIMEOUT);
> +	do {
> +		ret = connect(fd, &addr.sa, sizeof(addr.svm));
> +		timeout_check("connect");
> +	} while (ret < 0 && errno == EINTR);
> +	timeout_end();
> +
> +	if (ret != -1) {
> +		fprintf(stderr, "expected connect(2) failure, got %d\n", ret);
> +		exit(EXIT_FAILURE);
> +	}
> +	if (errno != ECONNRESET) {
> +		fprintf(stderr, "unexpected connect(2) errno %d\n", errno);
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	/* Notify the server that the client has finished */
> +	control_writeln("DONE");
> +
> +	close(fd);
> +}
> +
> +static void test_stream_bind_only_server(const struct test_opts *opts)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_vm svm;
> +	} addr = {
> +		.svm = {
> +			.svm_family = AF_VSOCK,
> +			.svm_port = 1234,
> +			.svm_cid = VMADDR_CID_ANY,
> +		},
> +	};
> +	int fd;
> +
> +	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
> +
> +	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
> +		perror("bind");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	/* Notify the client that the server is ready */
> +	control_writeln("BIND");
> +
> +	/* Wait for the client to finish */
> +	control_expectln("DONE");
> +
> +	close(fd);
> +}
> +
>  static void test_stream_client_close_client(const struct test_opts *opts)
>  {
>  	int fd;
> @@ -212,6 +284,11 @@ static struct test_case test_cases[] = {
>  		.name = "SOCK_STREAM connection reset",
>  		.run_client = test_stream_connection_reset,
>  	},
> +	{
> +		.name = "SOCK_STREAM bind only",
> +		.run_client = test_stream_bind_only_client,
> +		.run_server = test_stream_bind_only_server,
> +	},
>  	{
>  		.name = "SOCK_STREAM client close",
>  		.run_client = test_stream_client_close_client,
> -- 
> 2.20.1
> 
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris, 
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

