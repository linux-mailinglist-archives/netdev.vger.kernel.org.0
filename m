Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CF63757E0
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 17:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbhEFPvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 11:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbhEFPvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 11:51:42 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E5EC061761
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 08:50:44 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q2so5382220pfh.13
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 08:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q38PAJ9+uMS5LIyUmdseGu2IcazIhzhvbZQsCgfZzn4=;
        b=1cUZc1c2lIsjBJsJ4rOOvLJzMepMGS/DzSPn09nST1vPpjvY9wgA70C4DBLt5bGDLJ
         WPaAXEaZgEjBu4Q0C88uBp5IWO1zeRjgwNNzt/vB7YfXxhyoT9XA1jkn4QHpn0qYJCaM
         oxXiurTz9jG3MEFWRmuKrqTmV5VJy0v+51oSeAQ0aWNCOI0ParK4dXwosAl0qVpmGIv/
         CDCsMnSmjisWdGai9oQyt1T9HZzUTym6xYlpNa/YP5ZUT/SP+yREFbbbALXzRei9J6jB
         reDLe2tSkqnnkAttGhpPxy3nUjTOLA4TtzbfshBodbwN1QaHhboQmjUlEPSKAM4BU/X+
         tt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q38PAJ9+uMS5LIyUmdseGu2IcazIhzhvbZQsCgfZzn4=;
        b=uSnuSgjM4ZO3sDYIQOFDrQVwCm7hkkiUPG/rU4uxxJg1PtG755mdukhEY9LGC+9YOX
         0TS7W5T4/QknIPlhhnqpj5E5aXDYgjTz2T+RzHxm+57tHWjfRxdjdBAUpvjJgoBNah7/
         Fqbx3H1B9/xdsh7KL1fgsFauQEg0WYj1Wq8Ft5EilyHrlG6LlUSWzpn9SBujKqx+79Lx
         b3N/oWBeNQOcd3zpg7rl+7FAIpc4vmb+LqWGDN/Ktj+VD7s/EUD3FMofCqiH1rkQB1D5
         C5ZXBgeNUVVaiDGUwzCeZwU00O4rbjWYel2rjjpC4Q2qIjHtL9EcRu2TH7f+wjOPokCs
         xQrA==
X-Gm-Message-State: AOAM5310fmtp7Gc99GQuBAmabDPY7GTar7JCQ9HicyxQeYKIeiLwOFNJ
        8aSTaN53MO3o9J1nQdHSp2b1oA==
X-Google-Smtp-Source: ABdhPJyjgjL58P30m9SNtzogdtxcO3JGCVNtxZZ7nUIhgb2sWuNtDd7TKt+ryVdWeknB0pIolxuoDQ==
X-Received: by 2002:a63:bd49:: with SMTP id d9mr4884354pgp.311.1620316244117;
        Thu, 06 May 2021 08:50:44 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id d8sm2329844pfl.156.2021.05.06.08.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 08:50:43 -0700 (PDT)
Date:   Thu, 6 May 2021 08:50:35 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] iplink_can: add new CAN FD bittiming
 parameters: Transmitter Delay Compensation (TDC)
Message-ID: <20210506085035.2fc33bf3@hermes.local>
In-Reply-To: <20210506112007.1666738-2-mailhol.vincent@wanadoo.fr>
References: <20210506112007.1666738-1-mailhol.vincent@wanadoo.fr>
        <20210506112007.1666738-2-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 May 2021 20:20:07 +0900
Vincent Mailhol <mailhol.vincent@wanadoo.fr> wrote:

> +	if (tb[IFLA_CAN_TDC_TDCV] && tb[IFLA_CAN_TDC_TDCO] &&
> +	    tb[IFLA_CAN_TDC_TDCF]) {
> +		__u32 *tdcv = RTA_DATA(tb[IFLA_CAN_TDC_TDCV]);
> +		__u32 *tdco = RTA_DATA(tb[IFLA_CAN_TDC_TDCO]);
> +		__u32 *tdcf = RTA_DATA(tb[IFLA_CAN_TDC_TDCF]);
> +
> +		if (is_json_context()) {
> +			open_json_object("tdc");
> +			print_int(PRINT_JSON, "tdcv", NULL, *tdcv);
> +			print_int(PRINT_JSON, "tdco", NULL, *tdco);
> +			print_int(PRINT_JSON, "tdcf", NULL, *tdcf);
> +			close_json_object();
> +		} else {
> +			fprintf(f, "\n	  tdcv %d tdco %d tdcf %d",
> +				*tdcv, *tdco, *tdcf);
> +		}
> +	}
> +

The most common pattern in iproute2 is to let json/non-json be decided
inside the print routine.  I search for all instances of fprintf as
indication of broken code. Also these are not signed values so please
print unsigned.  The code should use print_nl() to handle the single line
case. Also, there is helper to handle 

Something like:
              __u32 tdc = rte_getattr_u32(tb[IFLA_CAN_TDC_TDCV]);

		open_json_object("tdc");
		print_nl();
		print_u32(PRINT_ANY, "tdcv", "    tdcv %u", tdcv);
...
