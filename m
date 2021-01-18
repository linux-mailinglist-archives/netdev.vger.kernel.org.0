Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8B62FA8A3
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407553AbhARSWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436845AbhARSV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:21:56 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFCDC061575
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:21:16 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id e17so2791408qto.3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PF5zvTMR972vChUQzfEzhOOt0/d4P0TcdoMqoMAx5wI=;
        b=t9GVitlVpfse/19e+BZbJqU092Pq7hR3mmPP8pSZ/bNSMxtHxXeEipobvsutGgVwMR
         Qfm14mO53MPs6TB3j+gBQ0cXI5vLD2B5NRpbq0lh1SNDCPW8d1Tm/01qDkTNbGfICMSD
         Ne/QnNB+Zrt58TEufoSuJbD7X8zfS0QhNUATfbfGB6pPpuoCZ7ytWmZ0kn2x+6neGwNY
         qV0eAJGt+FKjM8jL5JUqngAYsyp4hY4Ya+xdeKP0q3zDQNC4vEzbtg2r/PCvuoD07Wfk
         x0R/jLFJWxpbjlfglthOVcptUgF2SX1eOzR7vVsBzV9vLkb1MzHCk9x1VhCY5Irheiv8
         pASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PF5zvTMR972vChUQzfEzhOOt0/d4P0TcdoMqoMAx5wI=;
        b=Ujfi+QpCe69sDDqtI4kobVRjWitNfS7B5OWGCg2UeU/IaspZU3Gwkk3YiLetCf/Z6n
         J4csGivFwKn9u7tQ7PudiuBWAtJtpDborizCcxKhWXwYUxu8DuIHChXVMtyE59C30e6K
         AInERKPbWhpTxK9rvbV7ohvyTXl+1ExZqzR1/qo6gesiUZpEyEtYYGj5ktv2GrhI7scp
         ts1M3WmYP+hpWmvVBOChkqAN5gjyLmLIdHRepDhXH2xdJqZME6l6kpWblERJNMi5eJtM
         yELdTXNPconPIaddJRDoTEYCLURCHZnFnlBxazu3H8TnauAdei4mJItBoTPHUXTYkuUh
         OQyw==
X-Gm-Message-State: AOAM5337RzamNUi2uppKmG4kzecRXQmb//qeCyna+gHH4mG4ZpGb67AC
        MIdQyPxLCuiDCdStqLA7wAE=
X-Google-Smtp-Source: ABdhPJwupnRwiA7i1+JFOObP1nVXlGe188wD2adHX4T5tSiJMoPlrYujYQEE/pocSFka2EXhgQcchw==
X-Received: by 2002:ac8:4e1c:: with SMTP id c28mr835348qtw.67.1610994075679;
        Mon, 18 Jan 2021 10:21:15 -0800 (PST)
Received: from horizon.localdomain ([177.220.172.93])
        by smtp.gmail.com with ESMTPSA id y13sm11649961qkb.17.2021.01.18.10.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 10:21:14 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 54C59C0783; Mon, 18 Jan 2021 15:21:12 -0300 (-03)
Date:   Mon, 18 Jan 2021 15:21:12 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: cls_flower add CT_FLAGS_INVALID flag
 support
Message-ID: <20210118182112.GC2676@horizon.localdomain>
References: <1610947127-4412-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610947127-4412-1-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 01:18:47PM +0800, wenxu@ucloud.cn wrote:
...
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -305,6 +305,9 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
>  	struct fl_flow_key skb_key;
>  	struct fl_flow_mask *mask;
>  	struct cls_fl_filter *f;
> +	bool post_ct;
> +
> +	post_ct = qdisc_skb_cb(skb)->post_ct;

Patch-wise, only here I think you could initialize post_ct right on
the declaration. No need for the extra line/block of lines here.

But I'm missing the iproute2 changes for flower, with a man page
update as well. Not sure if you planned to post them later on or not,
but it's nice to always have them paired together.

Thanks,
Marcelo
