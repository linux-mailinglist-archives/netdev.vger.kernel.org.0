Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898CE215EEE
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgGFSkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729569AbgGFSkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:40:41 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782D1C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:40:41 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so13666684pje.0
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TugJQ4pXXgIecgvqoOuUHX3i9QSmZK+IeNGDcSbnxZ0=;
        b=fMsF3sFFKQmSNLNlkYzzboSRRhTRxEKNEgYA648M0FkcE3vHd0nqhIzkabKqCchoqN
         CSzjYYFT8IRcorVMz+lWB7yGIChWVjBy1oY9BjCerNx6eF4i1N+aPiRLbWSyJFTRWSOy
         2WMG+plGIalBCwN9+ep6KKZwMa9Mj4RihKXnMdMaL1fh/3xJfHPUl79S/KH0930FB5sC
         CqaJvMMlUSZ0/o5hJSJ7y5/4URB+FPj9HdkHKzHjba1x9LgIGqtVyHT+7ag7RQlV5emG
         kSTta8cOVTGHkoauaq9nN0z/TQ4Tb9lxQuEqjfqv+X8j1u47gt9K1SrfHhFtaW7Egph5
         Oe8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TugJQ4pXXgIecgvqoOuUHX3i9QSmZK+IeNGDcSbnxZ0=;
        b=AVpCmh3Xegz7L91JSCG+3efOEh1jlC8pWsHAcA87d+dNTEvx7AQIJrNcqXz1PJRs5L
         oQHXcCW/5azA/L0TT2I20B5ZppTPZ1JCvVNEAcpZBfahW9utorQ2Mj89X2Z5G4WSbs7G
         0A4vY+h+aFa6horIqOYhH3HfhiCLidoMs3tsolPoPSqEYPUUeKq/Xxx4Vu/kRRPw7pSI
         MLboJslSc16yzalGG1+A/bBN/aSS0TafcwKLD7lFAo6YNXxQOVUxkiXJ3VfFWL/HkBnU
         WQpoL5hCYx46gRI26GK2gRdmKPpXR6iHXaWtQgdJCMuQNGAI5RdXtbnsrgWhP776wT3X
         hb0g==
X-Gm-Message-State: AOAM532DieXbB16rxBSQFFUf8w0igfu1mvSx9AXpTR+4ez/PYg7fzg5w
        D0Z8DrTDPqL9i7yNeZ7e8vBDGz9JJkA=
X-Google-Smtp-Source: ABdhPJyBBEAAcQpxlw9Zu4cHd0nIGe3A8xaAo912xpuLtxE7VvJt7ArXd18UBXNJbWfLHeegFWU49A==
X-Received: by 2002:a17:902:b18b:: with SMTP id s11mr34887693plr.92.1594060841070;
        Mon, 06 Jul 2020 11:40:41 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c19sm184373pjs.11.2020.07.06.11.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:40:40 -0700 (PDT)
Date:   Mon, 6 Jul 2020 11:40:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] iproute2 Support lockless token bucket
 (LTB)
Message-ID: <20200706114037.519161d0@hermes.lan>
In-Reply-To: <0010e146-ccda-ee6b-819b-96e518204f8a@alibaba-inc.com>
References: <0010e146-ccda-ee6b-819b-96e518204f8a@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Jul 2020 02:08:21 +0800
"YU, Xiangning" <xiangning.yu@alibaba-inc.com> wrote:

> +static int ltb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
> +{
> +	struct rtattr *tb[TCA_LTB_MAX + 1];
> +	struct tc_ltb_opt *lopt;
> +	struct tc_ltb_glob *gopt;
> +	__u64 rate64, ceil64;
> +
> +	SPRINT_BUF(b1);
> +	if (opt == NULL)
> +		return 0;
> +
> +	parse_rtattr_nested(tb, TCA_LTB_MAX, opt);
> +
> +	if (tb[TCA_LTB_PARMS]) {
> +		lopt = RTA_DATA(tb[TCA_LTB_PARMS]);
> +		if (RTA_PAYLOAD(tb[TCA_LTB_PARMS])  < sizeof(*lopt))
> +			return -1;
> +
> +		fprintf(f, "prio %d ", (int)lopt->prio);
> +
> +		rate64 = lopt->rate.rate;
> +		if (tb[TCA_LTB_RATE64] &&
> +		    RTA_PAYLOAD(tb[TCA_LTB_RATE64]) >= sizeof(rate64)) {
> +			rate64 = *(__u64 *)RTA_DATA(tb[TCA_LTB_RATE64]);
> +		}
> +
> +		ceil64 = lopt->ceil.rate;
> +		if (tb[TCA_LTB_CEIL64] &&
> +		    RTA_PAYLOAD(tb[TCA_LTB_CEIL64]) >= sizeof(ceil64))
> +			ceil64 = *(__u64 *)RTA_DATA(tb[TCA_LTB_CEIL64]);
> +
> +		fprintf(f, "rate %s ", sprint_rate(rate64, b1));
> +		fprintf(f, "ceil %s ", sprint_rate(ceil64, b1));

The print function needs to support JSON output like the rest
of the qdisc in current iproute2.
