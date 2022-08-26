Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0118F5A226E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 09:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245719AbiHZHzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 03:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343557AbiHZHzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 03:55:37 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503A020F6E
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:55:30 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id h1so432171wmd.3
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc;
        bh=mI7+lToELE6EMlyR2Vmj76yyzmG/NU74JgIyAcMpaD0=;
        b=O8cGR6kBKCPokk0HOZLB/45r9CivLzhXg2X8sYMdlyKCCZtufltiSqEYR3mgOzSFPR
         jfrsopsOmQGBV+UM7Qgd4it/KaGZTDgGlbF28sqIET3lpZdUWA+L6IeaJbGk1nl1EhDw
         vwlJzdgATtMnk4Uo9vibvMJKiWMWoOiisk2eCbj12leBxxv4IDXgTHpEclZmABZCQNB7
         uYVlAuCzOEwR9bGd89p/r2f8a7xizwtfRt8mmPVkiN0jqnImWRK3aN0MPaAqvbRyDfOS
         khJwI6RF6DBHilpcmbuEcxfLuv3p/SKloRC+h41BJrRDXLuevJs4bS+XcIx0nGpKiMj5
         IfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc;
        bh=mI7+lToELE6EMlyR2Vmj76yyzmG/NU74JgIyAcMpaD0=;
        b=dAJflUoXV1IolVqZQvbtIuLhvDcrx352Cf8p8wXkRQPH3rVn9rwbhsCPehrY4l7cdo
         y+WdOwi4Nkycvbrw3I0b+/Nio+rWtBtfqzuM1b0vnefsx4dO/h8wauXs5dyTpgWiwRGW
         Qig0IpAYdj23f1L8nCQRr2a2uASVIR20FsI7Qt+kYWjMN7pGkELXCtwZbcOd4vjSGfhK
         np2SfjCZ1658eGK3oCe4lW4t4slTBvqayhMNAGWNSLz6qCz6z8gEsxANyx3nGU2itT+5
         NLzkBZtz/cg/FWIfxwl1A/KnmPRIlFN5cFF3s8Z605NaLsk5tuE9JU9v64QtzBrhWpM9
         tMgg==
X-Gm-Message-State: ACgBeo00oki28TNMwdYEHnVXFoslyZwYjCLWesJVjBp3Uy1MarlrlrBX
        ymDcIxa76XbmMOSWQgZ3sA8ONg==
X-Google-Smtp-Source: AA6agR7JTKmJzH3+nzZVmHR0qMfNWWJDLapy8gSz0sUjxXa6QOZzGp/MElkan8LjuvY7tbv1yll0Yg==
X-Received: by 2002:a1c:f406:0:b0:3a5:d667:10 with SMTP id z6-20020a1cf406000000b003a5d6670010mr4438343wma.70.1661500528574;
        Fri, 26 Aug 2022 00:55:28 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:5d94:b816:24d3:cd91? ([2a01:e0a:b41:c160:5d94:b816:24d3:cd91])
        by smtp.gmail.com with ESMTPSA id g4-20020a5d4884000000b002250fa18eb6sm1210514wrq.71.2022.08.26.00.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 00:55:28 -0700 (PDT)
Message-ID: <03415861-593d-6bef-5b50-7a8d87281ea2@6wind.com>
Date:   Fri, 26 Aug 2022 09:55:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec-next,v3 2/3] xfrm: interface: support collect
 metadata mode
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        dsahern@kernel.org, contact@proelbtn.com, pablo@netfilter.org,
        razor@blackwall.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220825154630.2174742-1-eyal.birger@gmail.com>
 <20220825154630.2174742-3-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220825154630.2174742-3-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 25/08/2022 à 17:46, Eyal Birger a écrit :
> This commit adds support for 'collect_md' mode on xfrm interfaces.
> 
> Each net can have one collect_md device, created by providing the
> IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
> altered and has no if_id or link device attributes.
> 
> On transmit to this device, the if_id is fetched from the attached dst
> metadata on the skb. If exists, the link property is also fetched from
> the metadata. The dst metadata type used is METADATA_XFRM which holds
> these properties.
> 
> On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
> packet received and attaches it to the skb. The if_id used in this case is
> fetched from the xfrm state, and the link is fetched from the incoming
> device. This information can later be used by upper layers such as tc,
> ebpf, and ip rules.
> 
> Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
> metadata is postponed until after scrubing. Similarly, xfrm_input() is
> adapted to avoid dropping metadata dsts by only dropping 'valid'
> (skb_valid_dst(skb) == true) dsts.
> 
> Policy matching on packets arriving from collect_md xfrmi devices is
> done by using the xfrm state existing in the skb's sec_path.
> The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
> is changed to keep the details of the if_id extraction tucked away
> in xfrm_interface.c.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
