Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2754C54800E
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 09:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbiFMHBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 03:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238308AbiFMHBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 03:01:20 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773DA167F0;
        Mon, 13 Jun 2022 00:01:18 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id DDD1FC021; Mon, 13 Jun 2022 09:01:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655103676; bh=YpDF1SHYxI61u2L6DgPHZqPG6ImYo1B3buDP6pUy5ao=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=YYD/QoI//cCiQkMsSXbj4VL18p+EAUve37OyMr+1wr9ez9EIE1rMf0GtR8W6Cfu9T
         OcEuQV9+sBIyiZbrOF8cQ5BfhDN6uhP0uXO3T6MMcu3f0J28ksA/NbZ7fOGnyg6g1d
         NxLAJAh7uOlhu7g2KkQDKNHU4TR2lbNqWMS6S6gD6/CqVX65TiF2q7UoDGsnxowMgA
         GkVoT8jSIqF5ZM9/TPsmjdxcyceu5FRN3gjiIR+Ld41Kt9En07Re/Vszf5i5M+eT39
         xn3mexSuXYBbnoSXUTcWKV4Td31/hslYVWnXmNvh9yUqlcUQarXwrh5f0PVjPn6bYj
         Kul3dNWX0DZcg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 7E76EC009;
        Mon, 13 Jun 2022 09:01:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655103675; bh=YpDF1SHYxI61u2L6DgPHZqPG6ImYo1B3buDP6pUy5ao=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=g5vkwGIRlWJb8UwwjzWK20P35pU7SAYnffIyS8mRhn+XU6DqXxVMzOEFnYut0kQwh
         kDNfZxZ37VUYBbSADidP0dbzU8dgIr8TNaRby33s83SpXFtM3is4yZyk/n6RoBSwSv
         BlOrUb97JD7ooQxhGCnQb/GJGqjncvNjIstOZNaW0EV6TV9rQ0OwxGIez3CdnfeX5f
         n1IX9nZ/tHLzDO6h/P1boJ6MB8ZJGWJI/p1/wVxKSA0Wp/uIvZgRzpxNPrl2WQaaCB
         yA4tBRXZFKDEm13CS9Jx7PzZecWiEkbeKkuinhoCbYnvNtjA0fY0zRavKZIE1G7OWS
         iJOpTrDTFH5IQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 124ad89d;
        Mon, 13 Jun 2022 07:01:07 +0000 (UTC)
Date:   Mon, 13 Jun 2022 16:00:52 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 05/06] 9p fid refcount: add a 9p_fid_ref tracepoint
Message-ID: <YqbgpMJCVk44Q0zP@codewreck.org>
References: <20220612184659.6dff5107@rorschach.local.home>
 <20220612234634.1559778-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220612234634.1559778-1-asmadeus@codewreck.org>
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dominique Martinet wrote on Mon, Jun 13, 2022 at 08:46:34AM +0900:
> I've applied your suggestion to use DECLARE_TRACEPOINT + enable checks,
> it doesn't seem to have many users but it looks good to me.
>
> diff --git a/include/net/9p/client.h b/include/net/9p/client.h
> index 9fd38d674057..6f347983705d 100644
> --- a/include/net/9p/client.h
> +++ b/include/net/9p/client.h
> @@ -237,8 +238,17 @@ static inline int p9_req_try_get(struct p9_req_t *r)
>  
>  int p9_req_put(struct p9_req_t *r);
>  
> +/* We cannot have the real tracepoints in header files,
> + * use a wrapper function */
> +DECLARE_TRACEPOINT(9p_fid_ref);
> +void do_trace_9p_fid_get(struct p9_fid *fid);
> +void do_trace_9p_fid_put(struct p9_fid *fid);
> +
>  static inline struct p9_fid *p9_fid_get(struct p9_fid *fid)
>  {
> +	if (tracepoint_enabled(9p_fid_ref))

This here requires __tracepoint_9p_fid_ref exported...

> diff --git a/net/9p/client.c b/net/9p/client.c
> index f3eb280c7d9d..06d67a02d431 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -928,6 +931,18 @@ static void p9_fid_destroy(struct p9_fid *fid)
>  	kfree(fid);
>  }
>  

So I've also added this here:

+/* We also need to export tracepoint symbols for tracepoint_enabled() */
+EXPORT_TRACEPOINT_SYMBOL(9p_fid_ref);
+

Which looks frequent enough to probably be the right thing to do?

(It's small enough that I won't bother repost a v3 unless something else
comes up)

> +void do_trace_9p_fid_get(struct p9_fid *fid)
> +{
> +	trace_9p_fid_ref(fid, P9_FID_REF_GET);
> +}
> +EXPORT_SYMBOL(do_trace_9p_fid_get);
> +
> +void do_trace_9p_fid_put(struct p9_fid *fid)
> +{
> +	trace_9p_fid_ref(fid, P9_FID_REF_PUT);
> +}
> +EXPORT_SYMBOL(do_trace_9p_fid_put);
> +
>  static int p9_client_version(struct p9_client *c)
>  {
>  	int err = 0;

-- 
Dominique
