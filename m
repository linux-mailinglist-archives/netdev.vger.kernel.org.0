Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D776C6C26
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjCWPTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbjCWPTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:19:32 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE852A17F
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:19:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o12so88127597edb.9
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679584770;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kCVX/ZGs38xTzfRz8Q3mDhvapHOM3T+gRXbVZTIJnSA=;
        b=QXtX1hYNAEDMTNK10MmOHniiVZXUjGMDiX7wmvr18NbVHM4WqnfPEVHdUtUzOJpafV
         MpzX7qrmQeuPdzD55Asm2gXvWbNKoc6FnclP9reBcjXrldRPmrtIFN7Al3ZeTdu0v4ps
         kj5nmz+BT+wufk+4VVzNA4kvSEdQNABVKgdg2OlvIXrFRBXPDkwQJdhl19wvQr9oC8tl
         11scaBcKrs9v/NudHxJ1QtL7e7O/xsh+eA6idDI0Mbt0Z6aIvHe5X8c9X3GoPQLV065G
         0vpJSworNQwrgkGY57mIgqqP0R6RUUIyPW4Uv8epB+Orl8NNXut8ycCExBM28u++zxy9
         cv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584770;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kCVX/ZGs38xTzfRz8Q3mDhvapHOM3T+gRXbVZTIJnSA=;
        b=o2cUmLrKA9zNeemmLimsscRlquUOW//ZMspL5uDA8nSHYvTo03pbn5k3Oye8DsSzF/
         V1FVtlWgZIKQlt4XJz9sWVB/BpiDUNuHb1yt95UxzDkuJIE/kY5ynYsXXM9JBqOc6k9l
         aPeGeMWLFJHHGg5NdqgHe3O39K/MxRFVCiDkotOhmar7VRaxR0Yuptfe14aUbudK9Mc/
         //t+Y/vf1D/LYWvzj27nnT4DPBEIzQcrfNkyX5fFpnALJQRgQPmAP9IR7JAlBl+9shxP
         CONFE2ZVOuCNo6PBcyhNz9zzmDxN6AFLL0hSujatTUVfFyMzbUj5SJffv3WtS7qaPxtO
         Za/A==
X-Gm-Message-State: AO0yUKWSBy6oom4JAJPQOli9bsrovq/uOE1WlRnKqakrn9ou4zKjJsEL
        PcscA5NfgDjodo8DycKEWdNLOw==
X-Google-Smtp-Source: AK7set/1IuQQ5zEXAAzbWCy3wg/bgePAyS45pQH2jgnwngB51gj5zjz//tRbeyYRzL6mZ4xxLgM84g==
X-Received: by 2002:a17:906:538e:b0:906:3373:cfe9 with SMTP id g14-20020a170906538e00b009063373cfe9mr12131090ejo.10.1679584769778;
        Thu, 23 Mar 2023 08:19:29 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id bv1-20020a170906b1c100b00939e76a0cabsm3831917ejb.111.2023.03.23.08.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 08:19:29 -0700 (PDT)
Message-ID: <18810a42-b9cb-ce27-431d-310c903af3d3@blackwall.org>
Date:   Thu, 23 Mar 2023 17:19:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH iproute2-next 4/7] bridge: mdb: Add destination VNI
 support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230321130127.264822-1-idosch@nvidia.com>
 <20230321130127.264822-5-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230321130127.264822-5-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2023 15:01, Ido Schimmel wrote:
> In a similar fashion to VXLAN FDB entries, allow user space to program
> and view the destination VNI of VXLAN MDB entries. Specifically, add
> support for the 'MDBE_ATTR_VNI' and 'MDBA_MDB_EATTR_VNI' attributes in
> request and response messages, respectively.
> 
> This is useful when ingress replication (IR) is used and the destination
> VXLAN tunnel endpoint (VTEP) is not a member of the source broadcast
> domain (BD). In this case, the ingress VTEP should transmit the packet
> using the VNI of the Supplementary Broadcast Domain (SBD) in which all
> the VTEPs are member of [1].
> 
> Example:
> 
>  # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1 vni 1111
> 
>  $ bridge -d -s mdb show
>  dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1 vni 1111    0.00
> 
>  $ bridge -d -s -j -p mdb show
>  [ {
>          "mdb": [ {
>                  "index": 15,
>                  "dev": "vxlan0",
>                  "port": "vxlan0",
>                  "grp": "239.1.1.1",
>                  "state": "permanent",
>                  "filter_mode": "exclude",
>                  "protocol": "static",
>                  "flags": [ ],
>                  "dst": "198.51.100.1",
>                  "vni": 1111,
>                  "timer": "   0.00"
>              } ],
>          "router": {}
>      } ]
> 
> [1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-3.2.2
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c      | 34 ++++++++++++++++++++++++++++++++--
>  man/man8/bridge.8 | 10 +++++++++-
>  2 files changed, 41 insertions(+), 3 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


