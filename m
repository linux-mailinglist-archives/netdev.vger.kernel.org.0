Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEA67DF7D
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbfHAPxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:53:37 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34722 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbfHAPxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 11:53:37 -0400
Received: by mail-lf1-f66.google.com with SMTP id b29so43399083lfq.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 08:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jOies/q8GNu6zMRJDNga96FSVWyO2X9XensDmj1AZZY=;
        b=JCfUKgCbIl3b8Om0ozKmxK3ZkAX7v5HdGpeskesaFuP4NVGJl/awlJnYAPCtEVSloc
         lzcOj6CeND6AuD80dr4q1nJBDmRFU2KqlXk9+ptF9UyEfTbMir9PajC+w3TevrMU1QoH
         5DhGRwdIMNBej8DEM2/cRH4RJvSjQ8ijfcZ6NPBCDsO/9awA61b+xRtL/izy/7RChYgz
         xTwQzNHzisQ2LYNZskcc+ZWMrodoblpe5iCPH3IT6NXa5X/R9AccGBJEJPnLdMVO54Am
         kK8utE4/RrvLlDgPlD3Taj9+1QnLV4AmRZXmPVkCyhvXdMHhxVJppbxOVcR7A9M2e9A2
         zOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jOies/q8GNu6zMRJDNga96FSVWyO2X9XensDmj1AZZY=;
        b=ou6BF0fLYluLED1KO9dy5XEC0wzhnTlmJ2RkCaAhD44XONxphBgaQ3A4aCnQYdh5Yo
         cuD5bbfAY6zsLOy7Qdh9PS91RKmhl3mHjTpxoN5p/6ExlPJ9qO3iMaj9v4sW2uQrZcZU
         CHsq3WToutEYLnwSjKBqTJt1v8LuLF4H7zEXrSDATQ8pU6zsqY6g909TsuErPoqoPRU0
         VzS5zrZ8ICICHRGnEMANxOeNwwse+GRM7qNT64wBQDypum8b/U/T2XoGyPULkuWBcv3m
         aVBuJlewBh/7IEaDaQHe9qXBklbIjnAGTs3sm7QGpzaORtwlOFKY82bXsXlM4qHjCtey
         IxZQ==
X-Gm-Message-State: APjAAAXmP13iK0W1+GmIYEuYpp6yo385NSVQd32lhbf3C3GHwLPHHPsQ
        HgigegHqYOTiiOwdVGQBS8BdzQ==
X-Google-Smtp-Source: APXvYqzp9NIlaxkTBvMmj+xKyDzpb+n9dCj96Ve4HvOBx6VdwDWSrusU3JCFMHB8k+qhxDs91gSPrA==
X-Received: by 2002:a19:5f46:: with SMTP id a6mr63906353lfj.142.1564674814647;
        Thu, 01 Aug 2019 08:53:34 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:6ee:d28:6484:8b6b:cce6:b9f0])
        by smtp.gmail.com with ESMTPSA id q4sm16666213lje.99.2019.08.01.08.53.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 08:53:34 -0700 (PDT)
Subject: Re: [PATCH v2 10/11] vsock_test: skip read() in test_stream*close
 tests on a VMCI host
To:     Stefano Garzarella <sgarzare@redhat.com>, netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <20190801152541.245833-11-sgarzare@redhat.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <79ffb2a6-8ed2-cce2-7704-ed872446c0fe@cogentembedded.com>
Date:   Thu, 1 Aug 2019 18:53:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190801152541.245833-11-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 08/01/2019 06:25 PM, Stefano Garzarella wrote:

> When VMCI transport is used, if the guest closes a connection,
> all data is gone and EOF is returned, so we should skip the read
> of data written by the peer before closing the connection.
> 
> Reported-by: Jorgen Hansen <jhansen@vmware.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  tools/testing/vsock/vsock_test.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> index cb606091489f..64adf45501ca 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
[...]
> @@ -79,16 +80,27 @@ static void test_stream_client_close_server(const struct test_opts *opts)
>  		exit(EXIT_FAILURE);
>  	}
>  
> +	local_cid = vsock_get_local_cid(fd);
> +
>  	control_expectln("CLOSED");
>  
>  	send_byte(fd, -EPIPE);
> -	recv_byte(fd, 1);
> +
> +	/* Skip the read of data wrote by the peer if we are on VMCI and

   s/wrote/written/?

> +	 * we are on the host side, because when the guest closes a
> +	 * connection, all data is gone and EOF is returned.
> +	 */
> +	if (!(opts->transport == TEST_TRANSPORT_VMCI &&
> +	    local_cid == VMADDR_CID_HOST))
> +		recv_byte(fd, 1);
> +
>  	recv_byte(fd, 0);
>  	close(fd);
>  }
[...]

MBR, Sergei
