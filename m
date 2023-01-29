Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4A167FE0F
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbjA2KK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjA2KK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:10:26 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337E11E5DC
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:10:25 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id fi26so8364243edb.7
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9XfzzI0aJv3Oy+nsDPy+TYtpW6ng2Irz9hGaMbx6s3M=;
        b=5rhHSPdoK0FJ67VKVFj4aFRHClNSijowYb9fWpJW4uJ68ApzouzjidnMg3ri3TJjgR
         AvUhX2TFYEBy0Cvgu4B4hI/MTBl7BHWx4nf60ae5M6cjCIXKbDbA9itdkc7t1vx+/jJS
         vCIMuXA6tJGEIEKZ9afWTbSJM6igKlg/E4njTvoJEvhWAPyhZCWEm6dPlMfeJ/OTEZek
         Hrw1z0SYsCuZohYRB4Kr4wY5eo/30rkvHOR8vuCIFIBfvc4vLR9bwTtCBvhJU3WGdSl7
         U8vaIBoDFokDorDz744nvY6yzYKzH0GNNG8C1CwuS6UXj9ONUAe9/51w+IOX3gmHq3Bm
         +sDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9XfzzI0aJv3Oy+nsDPy+TYtpW6ng2Irz9hGaMbx6s3M=;
        b=3KJVtNo9oN5S+eRndMe+q85ILbPVFxo53kTVZNoYIbZxeRWID9V6qIUceISjzIapyL
         5ym5AzEWtcUXHKYodH5sxfJnRjwBZ4B/D/z1W/M1gWp3XNX7BA2KSnQtzJVkNhIQ/Dlx
         7BRmlSG5b7jE3UNxw1Hqrj7oTN/F3CaLkDkdGZZy8x76/0tOF9S1XHhwPj+JJARQMjsK
         j2rH6GNLcHKVZ4GB7BsrXY3MjKGlSKRr/7IDOeAXoAHmIUbLYltkeYqGHMEytdmZprEv
         RLUrxjW1P0QCbnP9Lg7rGYDj+NOM0bqyXWrwnwpPBkhXC39/z4cQLD7EfJEcDguFCPGI
         E/nw==
X-Gm-Message-State: AFqh2krLZCXH4yT/ejk1g3OsIsUAHkakAdHR2PYxacO/cTpnZCqE75G8
        SXNdaxiI98MQZNkzL774K0BXJw==
X-Google-Smtp-Source: AMrXdXsxXpdFSn35m1OrWYjxgXxHBpPbStsUS+CGsQVTPJ3TOYBUTJGesCZF4/Tt26z1K4i5aa+Ztw==
X-Received: by 2002:a50:fe95:0:b0:46c:aa8b:da5c with SMTP id d21-20020a50fe95000000b0046caa8bda5cmr45548336edt.33.1674987023716;
        Sun, 29 Jan 2023 02:10:23 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id m5-20020aa7c485000000b0049e19136c22sm5031173edq.95.2023.01.29.02.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:10:23 -0800 (PST)
Message-ID: <dbcb7016-2473-0586-b6e2-2a42fca2b7f7@blackwall.org>
Date:   Sun, 29 Jan 2023 12:10:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 12/16] selftests: forwarding: lib: Add helpers
 for checksum handling
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <3ca0fe4de1f701befbc874e4b672c90aee602199.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <3ca0fe4de1f701befbc874e4b672c90aee602199.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> In order to generate IGMPv3 and MLDv2 packets on the fly, we will need
> helpers to calculate the packet checksum.
> 
> The approach presented in this patch revolves around payload templates
> for mausezahn. These are mausezahn-like payload strings (01:23:45:...)
> with possibly one 2-byte sequence replaced with the word PAYLOAD. The
> main function is payload_template_calc_checksum(), which calculates
> RFC 1071 checksum of the message. There are further helpers to then
> convert the checksum to the payload format, and to expand it.
> 
> For IPv6, MLDv2 message checksum is computed using a pseudoheader that
> differs from the header used in the payload itself. The fact that the
> two messages are different means that the checksum needs to be
> returned as a separate quantity, instead of being expanded in-place in
> the payload itself. Furthermore, the pseudoheader includes a length of
> the message. Much like the checksum, this needs to be expanded in
> mausezahn format. And likewise for number of addresses for (S,G)
> entries. Thus we have several places where a computed quantity needs
> to be presented in the payload format. Add a helper u16_to_bytes(),
> which will be used in all these cases.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/lib.sh | 56 +++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


