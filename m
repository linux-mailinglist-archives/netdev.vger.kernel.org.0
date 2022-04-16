Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C53503807
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiDPTlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiDPTlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:41:50 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E7FCB038;
        Sat, 16 Apr 2022 12:39:17 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s137so12007123pgs.5;
        Sat, 16 Apr 2022 12:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=voxZ31qFlafqYv1KtZJxqTUhs3UryZT4D28XGScW+a0=;
        b=TvlBjYUb6jvPOj6IsHs0M9D5K2wvs0b2TjFENcykUyDcKNPhtWD7iiraagCgqnJXfu
         X+jWY3fdoRuNHTcyuhmbSM4+oTmU5ijesNoWgO69Hbbtr7J7eWUHkK0UDPlx1PL0WIQ7
         ctE0EbnqX3CCOG03pvoofNEdEaIrccBASxSjLWufJk1+DLF69pfywyReEZfxiL11dMra
         Ps8v6vgJ15q9TfbBLnIDgOoZ8gkJMqSOOG18LFapmNk8lSO6ei6E8GlHG+yaa1dFz/Pd
         UIr07HeEO/b981RrT/3upCExQJ5heif2jOckyrNIwVRqXEc4tNrKiEzZmnXwq18NRSK+
         hKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=voxZ31qFlafqYv1KtZJxqTUhs3UryZT4D28XGScW+a0=;
        b=zbwvp8wZmw59CeoreIA54t6gW4HdZCOidRDXME1oisr9FBY2d8g9dzrJRUfE1xLnMv
         ier2QTX6nWJ5Dk4Ap4il3HpHEOCn+E39Q/HuoVlNfRSIUBewFXPA6ey9o36J19k38H2G
         hpf3vpTgA/hnmWQIIM++4NzxAM0gAIM4BlZtqded5s5RomTGdU2/nHuy28CODcy085p6
         +cov91AiLSCONJQdTwhrHZMIKFVxbncMJO56+gBtwd9yq+WdwsCcj7YH1eUARqUJk6Kn
         J4FrZoEgkESY5LFY/y6yNpSLhiebxNndvodlZNrKVYMMrOoNyrSrdJKUsE1fuFZavJ59
         dXvA==
X-Gm-Message-State: AOAM530Hb94HCsG4gmJrBE6UA1HR90jRzW/plj2ZVFCEk8M7X+VVryo/
        /jrQU9RX0kYA1H0Sg9VS/4w=
X-Google-Smtp-Source: ABdhPJwpJnw7UFOao4GWq7HDPD7r7/mQ3y+uk5lJFjJ5tekzMlbaH4EjnEsFU6hBsHkI+VxR4u/mGQ==
X-Received: by 2002:a63:d13:0:b0:381:f043:c627 with SMTP id c19-20020a630d13000000b00381f043c627mr4027727pgl.168.1650137956942;
        Sat, 16 Apr 2022 12:39:16 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g200-20020a6252d1000000b0050833d7602csm6839324pfb.103.2022.04.16.12.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:39:16 -0700 (PDT)
Message-ID: <8f140d64-e486-f02c-c9c5-09e6c740220c@gmail.com>
Date:   Sat, 16 Apr 2022 12:39:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v4 03/18] net: dsa: sja1105: reorder
 sja1105_first_entry_longer_than with memory allocation
Content-Language: en-US
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
 <20220415122947.2754662-4-jakobkoschel@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220415122947.2754662-4-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2022 5:29 AM, Jakob Koschel wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> sja1105_first_entry_longer_than() does not make use of the full struct
> sja1105_gate_entry *e, just of e->interval which is set from the passed
> entry_time.
> 
> This means that if there is a gate conflict, we have allocated e for
> nothing, just to free it later. Reorder the memory allocation and the
> function call, to avoid that and simplify the error unwind path.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
