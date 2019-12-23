Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBFB129670
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWN0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:26:16 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37181 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfLWN0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:26:16 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so8833182pga.4;
        Mon, 23 Dec 2019 05:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BmTQDyGLMu6c7YjIBdeFAFkvuYWoq3WAP/yZHqx1jsU=;
        b=kjy/qPKWfSWtPxQiG9QWf2tn7CtSzuSpAYtbq3TCjWEkEEfvz8a2li1q3lyOm802Z+
         /gBYKtwg19uBILPjAcIGHtLtJ1HLXUzlWBb2IIyKBTukYIx3vBSvhg8PyHSXbyHvantr
         tXRkAYsR182ftW9gClv7R+1saw9ERS/CnFG1bEtwKxoRcrzJYde44gzF79rYiK5Pqqc3
         z5KMO4FhRtHYXsmaldgBsHwxwUVJ9aZbpgBXAMskMNog31B6mOGxlOpKc0aZdtU6F1B7
         nsbx0546s5beyv8pxeWS1KBhJU/IvlShvQHazTfTFwzBlYgKlUASlDdFH0UIj2/UTxrT
         CKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BmTQDyGLMu6c7YjIBdeFAFkvuYWoq3WAP/yZHqx1jsU=;
        b=ByI3enPeL+PWY/lZhOtSlgNZc8R96SIe6veJtGEUvb3jeDt/nylMuwvrmh/5ILIYOz
         ZycMfLyoZbfY6ck6uf59qe//T+5iZXRScO7U4nAK5nPN+eNk1WHOuX9l5/5VGFgsz/Ii
         ck4K5T/pDKd1ehzkfxmCAIno/YdqJqQlKSEFFfTI/rvVUVTDmSo5pZ5ysVq0HTVr3K/B
         ohEYOAN98PWE0WqWqg2QfKsWJN7IhPhlY42PricuM7hRFeHEVHXlcL5IUqrvhZ5C3rqO
         ZzyqYh/NWGriX/aQVvadEvqsPSOxB87Ah/btb3vgLZ8MwoGzO1YANhAbWuCiLx18+nMQ
         JQjA==
X-Gm-Message-State: APjAAAWWK5F0qCisTiZ+soGZ2xIcj55pztwx2Kd/ExY1m+7GHRYxF43U
        GzpDlOFmJgqZz2tDxFsxdFM=
X-Google-Smtp-Source: APXvYqxKmiGYNGKsGHVnJcPmCLsTTs/UrFLIl6033SjKaidMV1lZ0/ZndYxz3GthsWDZvxNW+2nfHg==
X-Received: by 2002:a62:1552:: with SMTP id 79mr31998009pfv.156.1577107575168;
        Mon, 23 Dec 2019 05:26:15 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:d619:5b44:72e4:9760:c602])
        by smtp.gmail.com with ESMTPSA id b185sm7866001pfa.102.2019.12.23.05.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 05:26:14 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 613B0C16F2; Mon, 23 Dec 2019 10:26:11 -0300 (-03)
Date:   Mon, 23 Dec 2019 10:26:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin Kou <qdkevin.kou@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: do trace_sctp_probe after SACK validation and check
Message-ID: <20191223132611.GF5058@localhost.localdomain>
References: <20191220044703.88-1-qdkevin.kou@gmail.com>
 <20191220161756.GE5058@localhost.localdomain>
 <1ec267f2-1172-32c0-baee-0d4ebcbfb380@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ec267f2-1172-32c0-baee-0d4ebcbfb380@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 22, 2019 at 12:22:24PM +0800, Kevin Kou wrote:
> On 2019/12/21 0:17, Marcelo Ricardo Leitner wrote:
> > On Fri, Dec 20, 2019 at 04:47:03AM +0000, Kevin Kou wrote:
> > > The function sctp_sf_eat_sack_6_2 now performs
> > > the Verification Tag validation, Chunk length validation, Bogu check,
> > > and also the detection of out-of-order SACK based on the RFC2960
> > > Section 6.2 at the beginning, and finally performs the further
> > > processing of SACK. The trace_sctp_probe now triggered before
> > > the above necessary validation and check.
> > > 
> > > This patch is to do the trace_sctp_probe after the necessary check
> > > and validation to SACK.
> > > 
> > > Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
> > > ---
> > >   net/sctp/sm_statefuns.c | 3 ++-
> > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> > > index 42558fa..b4a54df 100644
> > > --- a/net/sctp/sm_statefuns.c
> > > +++ b/net/sctp/sm_statefuns.c
> > > @@ -3281,7 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
> > >   	struct sctp_sackhdr *sackh;
> > >   	__u32 ctsn;
> > > -	trace_sctp_probe(ep, asoc, chunk);
> > >   	if (!sctp_vtag_verify(chunk, asoc))
> > >   		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> > > @@ -3319,6 +3318,8 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
> > >   	if (!TSN_lt(ctsn, asoc->next_tsn))
> > >   		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
> > > +	trace_sctp_probe(ep, asoc, chunk);
> > > +
> > 
> > Moving it here will be after the check against ctsn_ack_point, which
> > could cause duplicated SACKs to be missed from the log.
> 
> 
> As this SCTP trace used to trace the changes of SCTP association state in
> response to incoming packets(SACK). It is used for debugging SCTP congestion
> control algorithms, so according to the code in include/trace/events/sctp.h,
> the trace event mainly focus on congestion related information, and there is
> no SACK Chunk related information printed. So it is hard to point out
> whether the SACK is duplicate one or not based on this trace event.

I see. Yet, it's quite odd to do debugging of congestion control
algorithms without knowing how many TSNs/bytes are being acked by this
ack, but let's keep that aside for now.

I still can't agree with filtering out based the out-of-order SACK check
(the TSN_lt(ctsn, asoc->ctsn_ack_point) check. That is valuable to
congestion control debugging, because it will likely mean that the
sender is working with fewer acks than it would like/expect.

If you need to filter out them and have a "clean" list of what got in,
then the fix it needs lies in adding support for logging the ctsn in
the trace point itself (similarly to the pr_debug in there) and filter
it on post-processing of the logs.

I don't know how much of UAPI cover probe points. Hopefully we can add
that information without having to create new probe points.

PS: You can invert the check in
        if (!TSN_lt(ctsn, asoc->next_tsn))
to
        if (TSN_lte(asoc->next_tsn, ctsn))
and move it above, so it is done before the out-of-order check, and
the trace point in between them.

> 
> include/trace/events/sctp.h
> 1. TRACE_EVENT(sctp_probe,
> 
> TP_printk("asoc=%#llx mark=%#x bind_port=%d peer_port=%d pathmtu=%d "
> 		  "rwnd=%u unack_data=%d",
> 		  __entry->asoc, __entry->mark, __entry->bind_port,
> 		  __entry->peer_port, __entry->pathmtu, __entry->rwnd,
> 		  __entry->unack_data)
> 
> 2. TRACE_EVENT(sctp_probe_path,
> 
> TP_printk("asoc=%#llx%s ipaddr=%pISpc state=%u cwnd=%u ssthresh=%u "
> 		  "flight_size=%u partial_bytes_acked=%u pathmtu=%u",
> 		  __entry->asoc, __entry->primary ? "(*)" : "",
> 		  __entry->ipaddr, __entry->state, __entry->cwnd,
> 		  __entry->ssthresh, __entry->flight_size,
> 		  __entry->partial_bytes_acked, __entry->pathmtu)
> 
> > 
> > Yes, from the sender-side CC we don't care about it (yet), but it
> > helps to spot probably avoidable retransmissions.
> > 
> > I think this is cleaning up the noise too much. I can agree with
> > moving it to after the chunk sanity tests, though.
> > 
> > >   	/* Return this SACK for further processing.  */
> > >   	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
> > > -- 
> > > 1.8.3.1
> > > 
> 
