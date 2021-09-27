Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90F741955F
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 15:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhI0Nuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 09:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbhI0Nue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 09:50:34 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FD2C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 06:48:56 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 77-20020a9d0ed3000000b00546e10e6699so24524726otj.2
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 06:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mxYV8ML/zqHlJeEWfchjEnPLQ+SEt+onD/ktQ9KNZfY=;
        b=EnnsZe6QKEQ9SlF4+yG3UkeRh2tQORkCkhAOmLQ2C/Q9FN3tqbTkDhgt7r44UPthp5
         MzIM07pMM9kPcr2F5EoGDIR/xwCiVZlnqGTndDqPTa0TKP8P4atF0qATB6zbeUxB+MP6
         wiG71nJfOTe75UMzXi0RM7Nric3ilnb8OpqTj5oNp8AInNGDiAhILWd0/QgoRsUbLTSi
         GdKAxUuolC/x2hyxk3N3fWnRItS3hnhVxaLK2TmHp1kCd2meA+TVqetZllOFqJ4I3mNA
         sLl3h4Mfkh2FVqBgesqnpbD08DN6VyB8BHMuZz+WaodBDBm8fypM1k+UZu3UmorSjtIJ
         qvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mxYV8ML/zqHlJeEWfchjEnPLQ+SEt+onD/ktQ9KNZfY=;
        b=PH7w9KsWJiQHSFtSaRg1nWFJq9NY3dSkgOBu81FVTuFV6N/qhK1DitWeHHScx9Eptu
         ACKaSt4lzkxgPDpudXUaf7uspJ19CIIHw4EGn767UuR7VNwZ7P5EWdGWIyvKfMrm62a+
         Sg8rrxgn3pn8dYs/W/wOYcxEb0ZefqpiSAW9rW3cNLZOUAVmrnFIboNiulgC85NlXiS1
         jOTjGDGhC6dMWbewzrp6zU6EVwj1ldgtEcDA4skLBO3XqAiZJB7cj1qZKCvtpv9Z94Y7
         RskU6JNEIbfuMDvPtRb3bxwtOd+MF223KHCmJC70r9r1iU/5Z9SnZoDhWGQ6zbms9nIK
         A/6w==
X-Gm-Message-State: AOAM531zrAKz5eBf5kY9ij4/RFdnE6+kK35HZjqR4kBw/yepzkTL6XCW
        L7EfdMaq3ztttRR33c7PdSXdn2AOSX2A7g==
X-Google-Smtp-Source: ABdhPJywgajBAXyDcumTpBI3E5oFfnagSJMkgjAvmMpik76oNuBl9sE9+FUsioYDMnXhCD6fJDCzzA==
X-Received: by 2002:a9d:3e4b:: with SMTP id h11mr125822otg.294.1632750536028;
        Mon, 27 Sep 2021 06:48:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id k1sm4141641otr.43.2021.09.27.06.48.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 06:48:55 -0700 (PDT)
Subject: Re: [PATCH v2] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Alex Elder <elder@linaro.org>
Cc:     netdev@vger.kernel.org
References: <20210924033351.2878153-1-bjorn.andersson@linaro.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e0da1be9-e3d4-f718-e2c6-e18cda5b3269@gmail.com>
Date:   Mon, 27 Sep 2021 07:48:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210924033351.2878153-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 9:33 PM, Bjorn Andersson wrote:
> diff --git a/ip/iplink_rmnet.c b/ip/iplink_rmnet.c
> index 1d16440c6900..f629ca9976d9 100644
> --- a/ip/iplink_rmnet.c
> +++ b/ip/iplink_rmnet.c
> @@ -16,6 +16,12 @@ static void print_explain(FILE *f)
>  {
>  	fprintf(f,
>  		"Usage: ... rmnet mux_id MUXID\n"
> +		"                 [ingress-deaggregation { on | off } ]\n"
> +		"                 [ingress-commands { on | off } ]\n"
> +		"                 [ingress-chksumv4 { on | off } ]\n"
> +		"                 [ingress-chksumv5 { on | off } ]\n"
> +		"                 [egress-chksumv4 { on | off } ]\n"
> +		"                 [egress-chksumv5 { on | off } ]\n"
>  		"\n"
>  		"MUXID := 1-254\n"
>  	);
> @@ -26,9 +32,16 @@ static void explain(void)
>  	print_explain(stderr);
>  }
>  
> +static int on_off(const char *msg, const char *arg)
> +{
> +	fprintf(stderr, "Error: argument of \"%s\" must be \"on\" or \"off\", not \"%s\"\n", msg, arg);
> +	return -1;
> +}
> +
>  static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>  			   struct nlmsghdr *n)
>  {
> +	struct ifla_rmnet_flags flags = { };
>  	__u16 mux_id;
>  
>  	while (argc > 0) {
> @@ -37,6 +50,60 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>  			if (get_u16(&mux_id, *argv, 0))
>  				invarg("mux_id is invalid", *argv);
>  			addattr16(n, 1024, IFLA_RMNET_MUX_ID, mux_id);
> +		} else if (matches(*argv, "ingress-deaggregation") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_INGRESS_DEAGGREGATION;
> +			else
> +				return on_off("ingress-deaggregation", *argv);
> +		} else if (matches(*argv, "ingress-commands") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> +			else
> +				return on_off("ingress-commands", *argv);
> +		} else if (matches(*argv, "ingress-chksumv4") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> +			else
> +				return on_off("ingress-chksumv4", *argv);
> +		} else if (matches(*argv, "ingress-chksumv5") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_INGRESS_MAP_CKSUMV5;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV5;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_INGRESS_MAP_CKSUMV5;
> +			else
> +				return on_off("ingress-chksumv5", *argv);
> +		} else if (matches(*argv, "egress-chksumv4") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
> +			else
> +				return on_off("egress-chksumv4", *argv);
> +		} else if (matches(*argv, "egress-chksumv5") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
> +			else
> +				return on_off("egress-chksumv5", *argv);
>  		} else if (matches(*argv, "help") == 0) {
>  			explain();
>  			return -1;

use strcmp for new options. Also, please use 'csum' instead of 'chksum'
in the names. csum is already widely used in ip commands.

