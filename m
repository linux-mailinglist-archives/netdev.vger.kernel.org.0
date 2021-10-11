Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625A4428D9D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbhJKNRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235196AbhJKNRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 09:17:12 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC42C061570;
        Mon, 11 Oct 2021 06:15:12 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id f4so6927431uad.4;
        Mon, 11 Oct 2021 06:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fitsBjMz/h2eNHgz0yyQJgJiCCDLkmLgwiQaTAGbqq4=;
        b=q08VJR33RTNwXYnfhSPucwZ7/QLy2GCY865dyxIB/cNhP9cFCLSXfEbgKMrm8bYdkE
         a7+3YSyfc7O3iXzIQ3gHRf1UUj6qfzCwwjbYk0vhRumGRmZ1yzDDd+/P6DFpga0Dty4j
         MuTQbAXC8bBsVQNlyNwYzQSolhiw/CQ8ErpuSHlGU0upfXAW/MknFgoEAAk/A8NprI3Y
         kvDfRZ34nQz1K5sBnn4i3g3EKrCbnXH2o1YUfDie0sHFUPJZRmY8C1m3Gd1rH5epHSsR
         q2aOP2EbaDNxHIcn0wQByI1b++w3j/eGTsMuk79kUep8gvP1F89unvo7qV4iKx/71Osb
         rLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fitsBjMz/h2eNHgz0yyQJgJiCCDLkmLgwiQaTAGbqq4=;
        b=rFJ48Zafst0G2VE/w9cvqmQW04rcYEcRyiIR9HyYt24HegFVJsR/YCmw1vkv04Xe76
         RqiwBenISHeTKGV1DF+i5F/JKcPpArTfBAl01b80oMCTXBFYQtxlyZukduNLr256atEQ
         hWCmgGtYuPIPl9mrnz8f0NDDeekhELnEc6KbUvDD0GfJnCiqgHVLK5EiSPMLxWX/Je6O
         SJsa0LAPQXhOdybKbZAr9zogOwNjo8Je2PqnoNNasw62G3gitTFodPfl8EMGCyi1nvDB
         6ErRBm+PQ9C+3CXkBkmhcePoc3sspBtNFsyZwrfP+Fa+mwLlTMnZKN1mqI8WkAWE7ge4
         nLqA==
X-Gm-Message-State: AOAM533D082tKGb9OIrMHPQKpHDiSNE555PAJsCVb482J0ri2cT14ZjN
        sst/bxwwxocveuFFTxN5hlM=
X-Google-Smtp-Source: ABdhPJzOPFfD3ZAZa6IGzzxozf/tLTgMp2560nhJdGuS7b6fBWOjJVpsSWHUQaZ8wUBKdptS1OIOZg==
X-Received: by 2002:a05:6102:109b:: with SMTP id s27mr23435816vsr.19.1633958111333;
        Mon, 11 Oct 2021 06:15:11 -0700 (PDT)
Received: from t14s.localdomain ([177.220.174.164])
        by smtp.gmail.com with ESMTPSA id n20sm3404102vkn.7.2021.10.11.06.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 06:15:10 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 4F7267EDF3; Mon, 11 Oct 2021 10:15:09 -0300 (-03)
Date:   Mon, 11 Oct 2021 10:15:09 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: Re: [PATCH] sctp: account stream padding length for reconf chunk
Message-ID: <YWQ43VyG8bF2gvF7@t14s.localdomain>
References: <YWPc8Stn3iBBNh80@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWPc8Stn3iBBNh80@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 08:42:57AM +0200, Greg KH wrote:
> From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> 
> "stream_len" is not always multiple of 4. Account padding length
> which can be added in sctp_addto_chunk() for reconf chunk.

This could be improved somehow. The real problem here is that the
padding gets added twice by repeated calls to sctp_addto_chunk() while
it's accounted only once in sctp_make_reconf() and yes, only shows up
when "stream_len" is not a multiple of 4.

> 
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-sctp@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
> Reported-by: syzbot <syzkaller@googlegroups.com>

Perhaps we can drop this Reported-by tag, as it was Eiichi that
adapted a syzcaller repro to work on SCTP code.

> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/sctp/sm_make_chunk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index b8fa8f1a7277..f7a1072a2a2a 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3694,8 +3694,8 @@ struct sctp_chunk *sctp_make_strreset_req(

more context:

        __u16 stream_len = stream_num * sizeof(__u16);
        struct sctp_strreset_outreq outreq;
        struct sctp_strreset_inreq inreq;

>  	struct sctp_chunk *retval;
>  	__u16 outlen, inlen;
>  
> -	outlen = (sizeof(outreq) + stream_len) * out;
> -	inlen = (sizeof(inreq) + stream_len) * in;
> +	outlen = (sizeof(outreq) + SCTP_PAD4(stream_len)) * out;
> +	inlen = (sizeof(inreq) + SCTP_PAD4(stream_len)) * in;
>  
>  	retval = sctp_make_reconf(asoc, outlen + inlen);
>  	if (!retval)

more context:
                return NULL;

        if (outlen) {
                outreq.param_hdr.type = SCTP_PARAM_RESET_OUT_REQUEST;
                outreq.param_hdr.length = htons(outlen);
                                 ^^^^^^^^^^^^^^^^^^^^^^

The issue with this is that on the receiving side, it will:

sctp_process_strreset_outreq()
	...
        nums = (ntohs(param.p->length) - sizeof(*outreq)) / sizeof(__u16);
        str_p = outreq->list_of_streams;
        for (i = 0; i < nums; i++) {
                if (ntohs(str_p[i]) >= stream->incnt) {

So if stream_num was originally 1, stream_len would be 2, and with
padding, 4. Here, nums would be 2 then, and not 1. The padding gets
accounted as if it was payload.

IOW, the patch is making the padding part of the parameter data by
adding it to the header as well. SCTP padding works by having it in
between them, and not inside them.

This other approach avoids this issue by adding the padding only when
allocating the packet. It (ab)uses the fact that inreq and outreq are
already aligned to 4 bytes. Eiichi, can you please give it a go?

struct sctp_strreset_outreq {
        struct sctp_paramhdr       param_hdr;            /*     0     4 */
        __be32                     request_seq;          /*     4     4 */
        __be32                     response_seq;         /*     8     4 */
        __be32                     send_reset_at_tsn;    /*    12     4 */
        __be16                     list_of_streams[];    /*    16     0 */

        /* size: 16, cachelines: 1, members: 5 */
        /* last cacheline: 16 bytes */
};
struct sctp_strreset_inreq {
        struct sctp_paramhdr       param_hdr;            /*     0     4 */
        __be32                     request_seq;          /*     4     4 */
        __be16                     list_of_streams[];    /*     8     0 */

        /* size: 8, cachelines: 1, members: 3 */
        /* last cacheline: 8 bytes */
};

Thanks,
Marcelo

---8<---

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index b8fa8f1a7277..c7503fd64915 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3697,7 +3697,7 @@ struct sctp_chunk *sctp_make_strreset_req(
 	outlen = (sizeof(outreq) + stream_len) * out;
 	inlen = (sizeof(inreq) + stream_len) * in;
 
-	retval = sctp_make_reconf(asoc, outlen + inlen);
+	retval = sctp_make_reconf(asoc, SCTP_PAD4(outlen) + SCTP_PAD4(inlen));
 	if (!retval)
 		return NULL;
 
