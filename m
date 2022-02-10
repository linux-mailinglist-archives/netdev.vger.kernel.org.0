Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D24A4B14FE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245573AbiBJSLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:11:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBJSLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:11:07 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B6A1169;
        Thu, 10 Feb 2022 10:11:08 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso6410400pjg.0;
        Thu, 10 Feb 2022 10:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=k6N2s4V8eQa/iy+jkMeryWb488ArbG76+kT+N6TtkqA=;
        b=ogRQEud2IPc+YtyoYtBXU6MZVpBWOiQQihqzXux/znY+17Liz8L5e1v0Z8oGGIyNSy
         TaAEfPtMmxTLMucSVs3agGFvhb+bWwBq8J8StUPxez11GAuRjrkK4SnqPZbMHmFmrNLo
         vMii+ulIuKrNtdcr2MK8jKGl1tDQmBq/4pMB8sdgyhLbuv4//8apQassnmLm7/w0UFSe
         zHu4GZ2NDQEgUd0GiQwFqKeHE7frPjsVcDB0uURBzTmN7plqfBT810sV5BSPwWDc9RpX
         31HAP/Y/7+jt8B0lwc8ghGJYYPZ8a6XRbouKHztWO0VMgafb6b10PpF4BORZffNe+b1t
         uk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k6N2s4V8eQa/iy+jkMeryWb488ArbG76+kT+N6TtkqA=;
        b=hEU3B/G1KHzz+ZID5lzoYObTLl9dsJoJqjNrK9KePKNYiBWflEouufx60E3Y0kH1+P
         0VGBgrSXWlx1jLCMSjHuO9n7uynpVLqV5STcRPKGXmlgijR5y59V7Tt0fy7PxjEe9MMo
         ucAOiHouJNTGx5iQ975kx4AVhMN+v/0tgpDoWximxRLPEDO2XZaOiscGvrMagMXxBWqj
         YRGJIyODwA4YFYgSzxot6x5Km14YG15ZMxP+ScudPiFeyrh4I7Vcp/2vYFQGu2EbV4c+
         ubVna4/Usj/DrfcsFTpF/hYIbil9haFEivZBHnZLP/YbyPoBtksdGu46owNCgK0DUMtL
         hXdw==
X-Gm-Message-State: AOAM531f6H+TwOYlbprTGrz3awsvMVSdr4HV9Sil22/yixtyW8oI/gRm
        8aea3U+3YpYwRa4VIoIDUUPQMoi4Il4=
X-Google-Smtp-Source: ABdhPJyWrMOOnbaY/SnbYOfCEoXt8t83gN7NQrBD90Kd4V1W4IGy9iO/coNMcPsiro812zf7R/GE8A==
X-Received: by 2002:a17:903:2309:: with SMTP id d9mr4199037plh.16.1644516668179;
        Thu, 10 Feb 2022 10:11:08 -0800 (PST)
Received: from [10.20.86.120] ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id a14sm1306846pgw.27.2022.02.10.10.11.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 10:11:07 -0800 (PST)
Message-ID: <6952fd74-0202-47ed-a0f8-4b776bdf3ff2@gmail.com>
Date:   Thu, 10 Feb 2022 10:11:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next] ipv6: Reject routes configurations that specify
 dsfield (tos)
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <51234fd156acbe2161e928631cdc3d74b00002a7.1644505353.git.gnault@redhat.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <51234fd156acbe2161e928631cdc3d74b00002a7.1644505353.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/22 7:08 AM, Guillaume Nault wrote:
> The ->rtm_tos option is normally used to route packets based on both
> the destination address and the DS field. However it's ignored for
> IPv6 routes. Setting ->rtm_tos for IPv6 is thus invalid as the route
> is going to work only on the destination address anyway, so it won't
> behave as specified.
> 
> Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
> The same problem exists for ->rtm_scope. I'm working only on ->rtm_tos
> here because IPv4 recently started to validate this option too (as part
> of the DSCP/ECN clarification effort).
> I'll give this patch some soak time, then send another one for
> rejecting ->rtm_scope in IPv6 routes if nobody complains.
> 
>  net/ipv6/route.c                         |  6 ++++++
>  tools/testing/selftests/net/fib_tests.sh | 13 +++++++++++++
>  2 files changed, 19 insertions(+)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>


