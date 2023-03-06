Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F8A6AC0F6
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjCFNbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjCFNbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:31:04 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE1B2E809;
        Mon,  6 Mar 2023 05:31:03 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso5177262wms.5;
        Mon, 06 Mar 2023 05:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678109461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=rhJH6/756BF4GI7cA8Nb7CM9sk6OwpwkOhKbYvpbmHM=;
        b=DB2ZV6xUSRRGkB15jEDEuA7m1VPT/zd3VQN7JmOLz0I3iYPbFY0RiPjDD27lwywaJk
         MT+LzDaPLUV5BovzFNDv3uZ2ALMsTlmvsf3HKHAUyqkRCRSw3pJm90rliE5wmOaE/uvy
         8uDC+KvYPuRtUPOvr9LaGP1CoSHeb4RZOIi69seGQm59JhINktHoU/FxHRuZO3Zjlc63
         LmyJK1FQJEdxlccM+Gl0dh9nq0KY/NquR1SNwgAlVTaO2PqtQawdX65AuQShs5DfK02V
         0bVFzpDpJc70lJRjv5z4Qr/xEWx9lgURkYh/ul1grRkgOVvqbARmWLBHleAR3KhPrTAn
         zY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678109461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rhJH6/756BF4GI7cA8Nb7CM9sk6OwpwkOhKbYvpbmHM=;
        b=cwGUiuLD7UhNYG++AUzX2QvNT3S6FTP0uM4eyRz7i5i7dCHSQ2ALTEbBHGA5hXPAhm
         xHde+vaqfSqO1BaYunK/pE+tsNu8JFDSmHL7HZRmqXcGB+Vpe01ah0815zNANYbsRJnX
         XRjMFFLFh/+XvAvnz4Uo0CJb0Ar6ogEZRzfwAeWM8Us8I3iVAN4Ib8z0T36hJVKQCp2k
         EP2SX8kF4iCv1UjQ3NezMk7UjdGgiivMnQz9XtDmUI42AKPO0urAK/amT5h41yCyV7+E
         eRpifrsxotF3kBYlhNVmZrWnXjMi7pOcxW7tOHfdf1oht8ykTgEMmJxZIqT89xryryCU
         3SXA==
X-Gm-Message-State: AO0yUKUCHJX/BguPVfgBOUm3jiILGBQ4jp4e7I3JVThQXxxTE2kld4z7
        sI8PEwZ0qP3NO4LO6jCjuUo=
X-Google-Smtp-Source: AK7set9aQF5WOvWDUBJFs/JQ/968i5JidVqTKngMlI2EOuZw63Ixst878FeGMNVGHOxXOThC2TvPjg==
X-Received: by 2002:a05:600c:468b:b0:3e2:589:2502 with SMTP id p11-20020a05600c468b00b003e205892502mr8731744wmo.28.1678109461414;
        Mon, 06 Mar 2023 05:31:01 -0800 (PST)
Received: from [192.168.0.160] ([170.253.51.134])
        by smtp.gmail.com with ESMTPSA id z26-20020a1c4c1a000000b003eb395a8280sm14071563wmf.37.2023.03.06.05.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 05:31:01 -0800 (PST)
Sender: Alejandro Colomar <alx.mailinglists@gmail.com>
Message-ID: <d204f477-2655-57f6-c44c-cbe15f991933@gmail.com>
Date:   Mon, 6 Mar 2023 14:30:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH manpages v2 1/2] udp.7: add UDP_SEGMENT
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-man@vger.kernel.org
Cc:     mtk.manpages@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
From:   Alejandro Colomar <alx.manpages@gmail.com>
In-Reply-To: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

On 3/2/23 16:48, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> UDP_SEGMENT was added in commit bec1f6f69736
> ("udp: generate gso with UDP_SEGMENT")
> 
>     $ git describe --contains bec1f6f69736
>     linux/v4.18-rc1~114^2~377^2~8
> 
> Kernel source has example code in tools/testing/selftests/net/udpgso*
> 
> Per https://www.kernel.org/doc/man-pages/patches.html,
> "Describe how you obtained the information in your patch":
> I am the author of the above commit and follow-ons.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 

It doesn't apply.  Can you please rebase on top of master?

Thanks,

Alex

> ---
> 
> Changes v1->v2
>   - semantic newlines: also break on comma and colon
>   - remove bold: section number following function name
>   - add bold: special macro USHRT_MAX
> ---
>  man7/udp.7 | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/man7/udp.7 b/man7/udp.7
> index 5822bc551fdf..6646c1e96bb0 100644
> --- a/man7/udp.7
> +++ b/man7/udp.7
> @@ -204,6 +204,34 @@ portable.
>  .\"     UDP_ENCAP_ESPINUDP draft-ietf-ipsec-udp-encaps-06
>  .\"     UDP_ENCAP_L2TPINUDP rfc2661
>  .\" FIXME Document UDP_NO_CHECK6_TX and UDP_NO_CHECK6_RX, added in Linux 3.16
> +.TP
> +.BR UDP_SEGMENT " (since Linux 4.18)"
> +Enables UDP segmentation offload.
> +Segmentation offload reduces
> +.BR send (2)
> +cost by transferring multiple datagrams worth of data as a single large
> +packet through the kernel transmit path,
> +even when that exceeds MTU.
> +As late as possible,
> +the large packet is split by segment size into a series of datagrams.
> +This segmentation offload step is deferred to hardware if supported,
> +else performed in software.
> +This option takes a value between 0 and
> +.BR USHRT_MAX
> +that sets the segment size:
> +the size of datagram payload,
> +excluding the UDP header.
> +The segment size must be chosen such that at most 64 datagrams are sent in
> +a single call and that the datagrams after segmentation meet the same MTU
> +rules that apply to datagrams sent without this option.
> +Segmentation offload depends on checksum offload,
> +as datagram checksums are computed after segmentation.
> +The option may also be set for individual
> +.BR sendmsg (2)
> +calls by passing it as a
> +.BR cmsg (7).
> +A value of zero disables the feature.
> +This option should not be used in code intended to be portable.
>  .SS Ioctls
>  These ioctls can be accessed using
>  .BR ioctl (2).
