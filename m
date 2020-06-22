Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05833203374
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgFVJdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:33:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49871 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726982AbgFVJdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592818411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=taAm+yHynsWGizuM/1HFA84Om2/vElU4MDzfMW/Lhrk=;
        b=UxRVDJsYU/rPEe1qkxsI+cwjgObueqjiRg3Nlfukc8C0CMM/e+UyZhT2A+LZFAueMSvFzX
        FqqkXyuiBdbuqS3+NHZIQ6OU+hsynI07uLN3Pjbdiy2d6Lry5dH+6fAdC2WdBxeO5U8DeD
        yoE7GPxg17hRH1DjlHD+xwfkYgYSOVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-cedfWghFM4-CLIdk6K1KeA-1; Mon, 22 Jun 2020 05:33:27 -0400
X-MC-Unique: cedfWghFM4-CLIdk6K1KeA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CD3E1005512;
        Mon, 22 Jun 2020 09:33:26 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5C6410013D2;
        Mon, 22 Jun 2020 09:33:14 +0000 (UTC)
Date:   Mon, 22 Jun 2020 11:33:13 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 3/8] cpumap: formalize map value as a named
 struct
Message-ID: <20200622113313.6f56244d@carbon>
In-Reply-To: <804b20c4f6fdda24f81e946c5c67c37c55d9f590.1592606391.git.lorenzo@kernel.org>
References: <cover.1592606391.git.lorenzo@kernel.org>
        <804b20c4f6fdda24f81e946c5c67c37c55d9f590.1592606391.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 00:57:19 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> As it has been already done for devmap, introduce 'struct bpf_cpumap_val'
> to formalize the expected values that can be passed in for a CPUMAP.
> Update cpumap code to use the struct.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/uapi/linux/bpf.h       |  9 +++++++++
>  kernel/bpf/cpumap.c            | 25 +++++++++++++------------
>  tools/include/uapi/linux/bpf.h |  9 +++++++++
>  3 files changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 19684813faae..a45d61bc886e 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3774,6 +3774,15 @@ struct bpf_devmap_val {
>  	} bpf_prog;
>  };
>  
> +/* CPUMAP map-value layout
> + *
> + * The struct data-layout of map-value is a configuration interface.
> + * New members can only be added to the end of this structure.
> + */
> +struct bpf_cpumap_val {
> +	__u32 qsize;	/* queue size */
> +};
> +

Nitpicking the comment: /* queue size */
It doesn't provide much information to the end-user.

What about changing it to: /* queue size to remote target CPU */
?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

