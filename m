Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9816302DD
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiKRXUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiKRXTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:19:39 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27964A47A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:07:34 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id c15so4129165qtw.8
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B7Pd8QyOUjOcGIHLSLVnGlDgpEEYv3D1dbgsDw+AtHc=;
        b=awGejOaxtyCavlynLmgIQ5wmucr2YDPO3gRdr/+h5FXEIGHkalj80CL2qfX+LZ/Nmj
         hR/WLADCZWRlB3Qy8dRcAMj4Fcky/Ry0jVCeXNou6uCJXn+zZss6dZVRxKWED77h/MTt
         /oqSxoTWE8T4TL80V8JemYX/DED+dTtpn/0h4OVoFh9ea8J4NhEL50yLVh2VUQvVPlFp
         /2EPgXmJsAfaelkYsZDephY/G+a/ztrWgA25rdyrKXyNge5ggstgNx1QP4N4Sm8lLyDg
         PeTPBMPzTPhsNdSk49T+oKU5AHw78fMLRdeEaLFzjO3ElxSWc0vfXbfY6ad/tsZzBHbI
         w7RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B7Pd8QyOUjOcGIHLSLVnGlDgpEEYv3D1dbgsDw+AtHc=;
        b=pR5onSgzpqHr1F5xTw6zIuoJ9L9bq6+27+jL3fgiGWACTTWJPRKKjjmXiymt3QuaXn
         TQOIr/vOLMxWug/X0CkGSyOO6nYN5SXBu7MWAQILDWhxO11t/jeP/Bq6g3KNa7eqtThD
         FZqNL7ZbytQr4lg8e/t+afGU/a9wC6EL0QSaQOr2+/zs41wT+TKSYuX2MoINV9l1O/nN
         jRD/GUMTjEJn11S6SPt8R/VY7EaI4EQ8Gvt/ggPlDsla6qv6BNTySS4qqiAT434ohMql
         GQPZ0c1Z7UPBWR2/U1F11WA0JkDmDq5MzoJPKgWaN0JsApKVj+8pYcZWBe9x0xHky3Tb
         WRYw==
X-Gm-Message-State: ANoB5pn7wTlr3g4dDusutff95K9W+zavSbTdaKBunJrQMcx7NITCbzo3
        ST3j/EGL6SQIGFHwVkVLdsFjeW5APA==
X-Google-Smtp-Source: AA0mqf6OCl7gLM6Y56AYOqGe7xrXaPEFQ+XT1WKeFkPYf1C6uVdtxDfdu76wGlj7BWOj/p4eAjgbUw==
X-Received: by 2002:ac8:7183:0:b0:3a5:1dcb:d22d with SMTP id w3-20020ac87183000000b003a51dcbd22dmr8705210qto.489.1668812853175;
        Fri, 18 Nov 2022 15:07:33 -0800 (PST)
Received: from bytedance ([130.44.212.155])
        by smtp.gmail.com with ESMTPSA id f7-20020ac84987000000b003a582090530sm2729320qtq.83.2022.11.18.15.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 15:07:32 -0800 (PST)
Date:   Fri, 18 Nov 2022 15:07:29 -0800
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        wizhao@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: act_mirred: use the backlog for mirred
 ingress
Message-ID: <20221118230729.GA2234@bytedance>
References: <33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Fri, Sep 23, 2022 at 05:11:12PM +0200, Davide Caratti wrote:
> +mirred_egress_to_ingress_tcp_test()
> +{
> +	local tmpfile=$(mktemp) tmpfile1=$(mktemp)
> +
> +	RET=0
> +	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
> +	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
> +		ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
> +			action ct commit nat src addr 192.0.2.2 pipe \
> +			action ct clear pipe \
> +			action ct commit nat dst addr 192.0.2.1 pipe \
> +			action ct clear pipe \
> +			action skbedit ptype host pipe \
> +			action mirred ingress redirect dev $h1

FWIW, I couldn't reproduce the lockup using this test case (with
forwarding.config.sample), but I got the same lockup in tcp_v4_rcv()
using a different (but probably less realistic) TC filter:

	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
		ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
			action pedit ex munge ip src set 192.0.2.2 pipe \
			action pedit ex munge ip dst set 192.0.2.1 pipe \
			action skbedit ptype host pipe \
			action mirred ingress redirect dev $h1

Thanks,
Peilin Ye

